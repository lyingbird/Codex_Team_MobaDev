local AbilityController = {}
AbilityController.__index = AbilityController

local function cloneTable(source)
	local result = {}
	for key, value in pairs(source) do
		result[key] = value
	end
	return result
end

function AbilityController.new(dependencies)
	assert(dependencies, "AbilityController 需要依赖表")
	assert(dependencies.AbilitySchema, "缺少 AbilitySchema")
	assert(dependencies.CastMath, "缺少 CastMath")
	assert(dependencies.HeroDefinitions, "缺少 HeroDefinitions")

	local self = setmetatable({}, AbilityController)
	self._schema = dependencies.AbilitySchema
	self._castMath = dependencies.CastMath
	self._heroes = dependencies.HeroDefinitions
	self._now = dependencies.nowProvider or os.clock
	self._sendCastRequest = dependencies.sendCastRequest or function() end
	self._heroId = nil
	self._abilityStateBySlot = {}
	self._previewBySlot = {}
	self._bufferedSlot = nil

	return self
end

function AbilityController:bindHero(heroId)
	local heroDefinition = self._heroes[heroId]
	assert(heroDefinition, (`未知英雄: {heroId}`))

	self._heroId = heroId
	self._abilityStateBySlot = {}

	for slot, abilityDefinition in pairs(heroDefinition.abilitiesBySlot) do
		self._abilityStateBySlot[slot] = {
			slot = slot,
			abilityId = abilityDefinition.id,
			stage = self._schema.CastStage.Ready,
			cooldownEndTime = 0,
			lastFailureReason = nil,
		}
	end
end

function AbilityController:getAbilityState(slot)
	local state = self._abilityStateBySlot[slot]
	if not state then
		return nil
	end

	return cloneTable(state)
end

function AbilityController:beginPreview(slot, origin: Vector3, targetPosition: Vector3?, targetUnitId: string?)
	local heroDefinition = self._heroes[self._heroId]
	local abilityDefinition = heroDefinition.abilitiesBySlot[slot]
	assert(abilityDefinition, (`未知技能槽位: {slot}`))

	local state = self._abilityStateBySlot[slot]
	state.stage = self._schema.CastStage.Preview

	self._previewBySlot[slot] = self._castMath.buildAimData(abilityDefinition, origin, targetPosition, targetUnitId)

	return self._previewBySlot[slot]
end

function AbilityController:confirmCast(slot, origin: Vector3, targetPosition: Vector3?, targetUnitId: string?)
	local heroDefinition = self._heroes[self._heroId]
	local abilityDefinition = heroDefinition.abilitiesBySlot[slot]
	local state = self._abilityStateBySlot[slot]
	local now = self._now()

	if state.cooldownEndTime > now then
		state.stage = self._schema.CastStage.Failed
		state.lastFailureReason = self._schema.FailReason.Cooldown
		return nil, state.lastFailureReason
	end

	local aimData = self._castMath.buildAimData(abilityDefinition, origin, targetPosition, targetUnitId)
	local request = {
		slot = slot,
		origin = origin,
		targetPosition = aimData and aimData.targetPosition or nil,
		targetUnitId = aimData and aimData.targetUnitId or nil,
		clientTimestamp = now,
	}

	state.stage = self._schema.CastStage.Validating
	self._sendCastRequest(request)

	return request, nil
end

function AbilityController:bufferCast(slot)
	self._bufferedSlot = {
		slot = slot,
		bufferedAt = self._now(),
	}
	self._abilityStateBySlot[slot].stage = self._schema.CastStage.Buffered
end

function AbilityController:receiveCastStarted(payload)
	local state = self._abilityStateBySlot[payload.slot]
	if not state then
		return
	end

	state.stage = self._schema.CastStage.Windup
	state.cooldownEndTime = payload.cooldownEndTime or state.cooldownEndTime
	state.lastFailureReason = nil
end

function AbilityController:receiveCastResolved(payload)
	local state = self._abilityStateBySlot[payload.slot]
	if not state then
		return
	end

	state.stage = payload.stage
	if payload.cooldownEndTime then
		state.cooldownEndTime = payload.cooldownEndTime
	end
end

function AbilityController:receiveCastFailed(payload)
	local state = self._abilityStateBySlot[payload.slot]
	if not state then
		return
	end

	state.stage = self._schema.CastStage.Failed
	state.lastFailureReason = payload.reason
end

function AbilityController:tick()
	local now = self._now()

	for _, state in pairs(self._abilityStateBySlot) do
		local isActiveCastStage = state.stage == self._schema.CastStage.Validating
			or state.stage == self._schema.CastStage.Windup
			or state.stage == self._schema.CastStage.Firing
			or state.stage == self._schema.CastStage.Recovery

		if state.cooldownEndTime > now then
			if not isActiveCastStage and state.stage == self._schema.CastStage.Ready then
				state.stage = self._schema.CastStage.Cooldown
			end
		elseif state.stage == self._schema.CastStage.Cooldown
			or state.stage == self._schema.CastStage.Failed
			or state.stage == self._schema.CastStage.Interrupted then
			state.stage = self._schema.CastStage.Ready
		end
	end
end

return AbilityController
