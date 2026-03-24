local AbilitySchema = {}

AbilitySchema.AbilitySlot = table.freeze({
	Q = "Q",
	W = "W",
	E = "E",
})

AbilitySchema.CastType = table.freeze({
	Instant = "Instant",
	SkillshotLine = "SkillshotLine",
	GroundTarget = "GroundTarget",
	TargetedUnit = "TargetedUnit",
	Dash = "Dash",
})

AbilitySchema.CastStage = table.freeze({
	Ready = "Ready",
	Preview = "Preview",
	Buffered = "Buffered",
	Validating = "Validating",
	Windup = "Windup",
	Firing = "Firing",
	Recovery = "Recovery",
	Cooldown = "Cooldown",
	Interrupted = "Interrupted",
	Failed = "Failed",
})

AbilitySchema.FailReason = table.freeze({
	Unknown = "Unknown",
	MatchNotRunning = "MatchNotRunning",
	Dead = "Dead",
	Silenced = "Silenced",
	Stunned = "Stunned",
	Cooldown = "Cooldown",
	OutOfRange = "OutOfRange",
	InvalidTarget = "InvalidTarget",
	InvalidAim = "InvalidAim",
	AlreadyCasting = "AlreadyCasting",
})

AbilitySchema.MovementPolicy = table.freeze({
	Free = "Free",
	TurnOnly = "TurnOnly",
	RootDuringWindup = "RootDuringWindup",
})

function AbilitySchema.isValidSlot(slot: string): boolean
	return slot == AbilitySchema.AbilitySlot.Q
		or slot == AbilitySchema.AbilitySlot.W
		or slot == AbilitySchema.AbilitySlot.E
end

return AbilitySchema
