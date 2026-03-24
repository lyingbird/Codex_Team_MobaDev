local CastMath = {}

local FALLBACK_DIRECTION = Vector3.new(0, 0, -1)

local function getDirection(fromPosition: Vector3, toPosition: Vector3): Vector3
	local offset = toPosition - fromPosition
	if offset.Magnitude <= 0.0001 then
		return FALLBACK_DIRECTION
	end

	return offset.Unit
end

function CastMath.clampTargetPosition(origin: Vector3, desiredPosition: Vector3, maxRange: number): Vector3
	local offset = desiredPosition - origin
	if offset.Magnitude <= maxRange then
		return desiredPosition
	end

	return origin + offset.Unit * maxRange
end

function CastMath.buildAimData(abilityDefinition, origin: Vector3, targetPosition: Vector3?, targetUnitId: string?)
	local castType = abilityDefinition.castType

	if castType == "Instant" then
		return {
			targetPosition = origin,
			targetUnitId = nil,
			direction = FALLBACK_DIRECTION,
			distance = 0,
		}
	end

	if castType == "TargetedUnit" then
		return {
			targetPosition = nil,
			targetUnitId = targetUnitId,
			direction = FALLBACK_DIRECTION,
			distance = 0,
		}
	end

	if not targetPosition then
		return nil
	end

	local clampedTarget = CastMath.clampTargetPosition(origin, targetPosition, abilityDefinition.castRange)
	local direction = getDirection(origin, clampedTarget)

	return {
		targetPosition = clampedTarget,
		targetUnitId = targetUnitId,
		direction = direction,
		distance = (clampedTarget - origin).Magnitude,
	}
end

return CastMath
