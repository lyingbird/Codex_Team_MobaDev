local AbilityService = {}
AbilityService.__index = AbilityService

local function cloneTable(source)
	local result = {}
	for key, value in pairs(source) do
		result[key] = value
	end
	return result
end

function AbilityService.new(dependencies)
	assert(dependencies, "AbilityService 需要依赖表")
	assert(dependencies.AbilitySchema, "缺少 AbilitySchema")
	assert(dependencies.CastMath, "缺少 CastMath")
	assert(dependencies.HeroDefinitions, "缺少 HeroDefinitions")

	local self = setmetatable({}, AbilityService)
	self._schema = dependencies.AbilitySchema
	self._castMath = dependencies.CastMath
	self._heroes = dependencies.HeroDefinitions
	self._now = dependencies.nowProvider or os.clock
	self._heroStates = {}

	return self
end

function AbilityService:registerHero(entityId, heroId)
	local heroDefinition = self._heroes[heroId]
	assert(heroDefinition, (`未知英雄: {heroId}`))

	self._heroStates[entityId] = {
		entityId = entityId,
		heroId = heroId,
		matchState = "Waiting",
		isAlive = true,
		controlState = "Normal",
		cooldownEndBySlot = {},
		activeCast = nil,
		lastFailureReason = nil,
	}

	return cloneTable(self._heroStates[entityId])
end

function AbilityService:setHeroRuntimeState(entityId, patch)
	local heroState = self._heroStates[entityId]
	assert(heroState, (`未注册英雄实体: {entityId}`))

	for key, value in pairs(patch) do
		heroState[key] = value
	end
end

function AbilityService:getHeroState(entityId)
	local heroState = self._heroStates[entityId]
	if not heroState then
		return nil
	end

	return cloneTable(heroState)
end

function AbilityService:_getAbilityDefinition(entityId, slot)
	local heroState = self._heroStates[entityId]
	if not heroState then
		return nil, nil
	end

	local heroDefinition = self._heroes[heroState.heroId]
	if not heroDefinition then
		return nil, heroState
	end

	return heroDefinition.abilitiesBySlot[slot], heroState
end

function AbilityService:canCast(entityId, slot, request)
	local abilityDefinition, heroState = self:_getAbilityDefinition(entityId, slot)
	local schema = self._schema

	if not heroState or not abilityDefinition then
		return false, schema.FailReason.Unknown
	end

	if heroState.matchState ~= "Running" then
		return false, schema.FailReason.MatchNotRunning
	end

	if not heroState.isAlive then
		return false, schema.FailReason.Dead
	end

	if heroState.controlState == "Stunned" then
		return false, schema.FailReason.Stunned
	end

	if heroState.controlState == "Silenced" then
		return false, schema.FailReason.Silenced
	end

	if heroState.activeCast then
		return false, schema.FailReason.AlreadyCasting
	end

	local now = self._now()
	local cooldownEnd = heroState.cooldownEndBySlot[slot]
	if cooldownEnd and cooldownEnd > now then
		return false, schema.FailReason.Cooldown
	end

	local aimData = self._castMath.buildAimData(
		abilityDefinition,
		request.origin,
		request.targetPosition,
		request.targetUnitId
	)

	if abilityDefinition.castType ~= schema.CastType.Instant and not aimData then
		return false, schema.FailReason.InvalidAim
	end

	if aimData and aimData.distance and aimData.distance > abilityDefinition.castRange + 0.001 then
		return false, schema.FailReason.OutOfRange
	end

	if abilityDefinition.castType == schema.CastType.TargetedUnit and not request.targetUnitId then
		return false, schema.FailReason.InvalidTarget
	end

	return true, nil, abilityDefinition, heroState, aimData
end

function AbilityService:handleCastRequest(entityId, request)
	local slot = request.slot
	local isAllowed, failReason, abilityDefinition, heroState, aimData = self:canCast(entityId, slot, request)
	local schema = self._schema

	if not isAllowed then
		if heroState then
			heroState.lastFailureReason = failReason
		end

		return {
			accepted = false,
			stage = schema.CastStage.Failed,
			slot = slot,
			reason = failReason,
		}
	end

	local now = self._now()
	heroState.activeCast = {
		abilityId = abilityDefinition.id,
		slot = slot,
		stage = schema.CastStage.Windup,
		startedAt = now,
		firesAt = now + abilityDefinition.windupSeconds,
		recoveryEndsAt = now + abilityDefinition.windupSeconds + abilityDefinition.recoverySeconds,
		aimData = aimData,
	}
	heroState.cooldownEndBySlot[slot] = now + abilityDefinition.cooldownSeconds
	heroState.lastFailureReason = nil

	return {
		accepted = true,
		stage = schema.CastStage.Windup,
		slot = slot,
		abilityId = abilityDefinition.id,
		windupSeconds = abilityDefinition.windupSeconds,
		recoverySeconds = abilityDefinition.recoverySeconds,
		cooldownEndTime = heroState.cooldownEndBySlot[slot],
		aimData = aimData,
	}
end

function AbilityService:interruptActiveCast(entityId, reason)
	local heroState = self._heroStates[entityId]
	if not heroState or not heroState.activeCast then
		return nil
	end

	local interruptedCast = heroState.activeCast
	heroState.activeCast = nil
	heroState.lastFailureReason = reason

	return {
		accepted = false,
		stage = self._schema.CastStage.Interrupted,
		slot = interruptedCast.slot,
		abilityId = interruptedCast.abilityId,
		reason = reason,
	}
end

function AbilityService:tick(entityId)
	local heroState = self._heroStates[entityId]
	if not heroState or not heroState.activeCast then
		return nil
	end

	local cast = heroState.activeCast
	local now = self._now()

	if cast.stage == self._schema.CastStage.Windup and now >= cast.firesAt then
		cast.stage = self._schema.CastStage.Firing
		cast.firedAt = now

		return {
			stage = self._schema.CastStage.Firing,
			slot = cast.slot,
			abilityId = cast.abilityId,
			aimData = cast.aimData,
		}
	end

	if cast.stage == self._schema.CastStage.Firing and now >= cast.recoveryEndsAt then
		heroState.activeCast = nil

		return {
			stage = self._schema.CastStage.Cooldown,
			slot = cast.slot,
			abilityId = cast.abilityId,
			cooldownEndTime = heroState.cooldownEndBySlot[cast.slot],
		}
	end

	return nil
end

return AbilityService
