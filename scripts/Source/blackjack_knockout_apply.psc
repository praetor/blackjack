Scriptname blackjack_knockout_apply extends activemagiceffect 

Spell Property KnockoutSpell Auto 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget.HasSpell(KnockoutSpell)
		akTarget.RemoveSpell(KnockoutSpell)
	endif
	
	if akCaster.IsDetectedBy(akTarget)
		akTarget.SendAssaultAlarm()
	else
		akTarget.AddSpell(KnockoutSpell)
	endif
EndEvent
