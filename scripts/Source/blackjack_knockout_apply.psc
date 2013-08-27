Scriptname blackjack_knockout_apply extends activemagiceffect 

Spell Property KnockoutSpell Auto 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget.HasSpell(KnockoutSpell)
		akTarget.RemoveSpell(KnockoutSpell)
	endif
	
	akCaster.IsDetectedBy(akTarget)
	
	Utility.Wait(0.1)
	
	; if akCaster.IsDetectedBy(akTarget)
	;	akTarget.SendAssaultAlarm()
	;else
		akCaster.PushActorAway(akTarget, 2)
		Utility.Wait(0.5)
		akTarget.AddSpell(KnockoutSpell)
	;endif
EndEvent
