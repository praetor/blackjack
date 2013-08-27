Scriptname blackjack_knockout_dispel extends activemagiceffect

Spell Property DetectCloak Auto
Spell Property DispelSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget.HasSpell(DetectCloak)
		akTarget.RemoveSpell(DetectCloak)
	endif
	
	if akTarget.HasSpell(DispelSpell)
		akTarget.RemoveSpell(DispelSpell)
	endif
EndEvent  
