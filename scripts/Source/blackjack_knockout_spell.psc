Scriptname blackjack_knockout_spell extends activemagiceffect

float Property DurationMin Auto
float Property DurationMax Auto
Spell Property DetectCloak Auto
Spell Property SuspectAbility Auto

float targetTime = 0.0
Actor tempActor = None

Event OnEffectStart(Actor akTarget, Actor akCaster)
	bool detectedBy = akCaster.IsDetectedBy(akTarget)
	if detectedBy
		akTarget.SendAssaultAlarm()
		Dispel()
	else
		Utility.Wait(0.1)
		
		detectedBy = akCaster.IsDetectedBy(akTarget)
		if detectedBy
			akTarget.SendAssaultAlarm()
			Dispel()
		else
			akCaster.PushActorAway(akTarget, 2)
		
			Utility.Wait(0.5)
			
			tempActor = akTarget.PlaceActorAtMe(akTarget.GetActorBase(), 4, None)
			tempActor.SetAlpha(0.0, false)
			tempActor.KillEssential(None)
			tempActor.BlockActivation(true)
			
			akTarget.SetAV("Paralysis", 1)
			akTarget.SetUnconscious(true)
			akTarget.SetNotShowOnStealthMeter(true)
			if akTarget.HasSpell(DetectCloak)
				akTarget.RemoveSpell(DetectCloak)
			endif
			akTarget.AddSpell(DetectCloak, false)
			if akTarget.HasSpell(SuspectAbility)
				akTarget.RemoveSpell(SuspectAbility)
			endif
			
			targetTime = Utility.GetCurrentGameTime() + Utility.RandomFloat(DurationMin, DurationMax)
			
			; Debug.Notification("Now: " + Utility.GetCurrentGameTime() + " Then: " + targetTime)
			
			RegisterForUpdate(1.0)
		endif
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; Debug.Notification("Removing")
	if tempActor != None
		tempActor.Delete()
		tempActor = None
	endif
	
	akTarget.SetAV("Paralysis", 0)
	akTarget.SetUnconscious(false)
	akTarget.SetNotShowOnStealthMeter(false)
	akTarget.RemoveSpell(DetectCloak)
	
	if akTarget.HasSpell(SuspectAbility)
		akTarget.RemoveSpell(SuspectAbility)
	endif
	if !akTarget.IsDead()
		akTarget.AddSpell(SuspectAbility, false)
	endif
EndEvent

Event OnUpdate()
	if Utility.GetCurrentGameTime() >= targetTime
		UnregisterForUpdate()
		Dispel()
	endif
	
	if tempActor != None
		tempActor.ForceRemoveRagdollFromWorld()
		tempActor.MoveTo(GetTargetActor(), 0.0, 0.0, 0.0, true)
	endif
EndEvent

Event OnDying(Actor akKiller)
	UnregisterForUpdate()
	Dispel()
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if akAggressor == Game.GetPlayer()
		float attackChance = 50.0
		if GetTargetActor().GetFactionReaction(Game.GetPlayer()) == 3 || GetTargetActor().GetRelationshipRank(Game.GetPlayer()) >= 3
			attackChance = 0.0
		elseif GetTargetActor().GetFactionReaction(Game.GetPlayer()) == 2 || GetTargetActor().GetRelationshipRank(Game.GetPlayer()) >= 1
			attackChance = 15.0
		elseif GetTargetActor().GetRelationshipRank(Game.GetPlayer()) == 0
			attackChance = 25.0
		endif
		
		if Utility.RandomFloat(0, 100) < attackChance
			GetTargetActor().SendAssaultAlarm()
		endif
	endif
	
	UnregisterForUpdate()
	Dispel()
EndEvent
