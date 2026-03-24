local AbilityDefinitions = require(script.Parent.Parent.Abilities.AbilityDefinitions)
local AbilitySchema = require(script.Parent.Parent.Abilities.AbilitySchema)

local HeroDefinitions = {
	PrototypeKnight = {
		id = "PrototypeKnight",
		name = "原型骑士",
		role = "Bruiser",
		abilitiesBySlot = {
			[AbilitySchema.AbilitySlot.Q] = AbilityDefinitions.PrototypeKnight_Q_ShockSlash,
			[AbilitySchema.AbilitySlot.W] = AbilityDefinitions.PrototypeKnight_W_GuardPulse,
			[AbilitySchema.AbilitySlot.E] = AbilityDefinitions.PrototypeKnight_E_Skyfall,
		},
		baseStats = {
			maxHealth = 700,
			moveSpeed = 16,
			attackPower = 55,
			abilityPower = 0,
		},
	},
}

return HeroDefinitions
