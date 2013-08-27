Scriptname blackjack_detect_spell extends activemagiceffect

Keyword[] Property ValidRaceKeywords Auto
Weapon Property Blackjack Auto

bool madeAlert = false 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	madeAlert = false
	bool canAdd = false
	int i = 0
	while i < ValidRaceKeywords.Length
		if akTarget.GetRace().HasKeyword(ValidRaceKeywords[i])
			canAdd = true
			i = ValidRaceKeywords.Length + 1
		else
			i = i + 1
		endif
	endwhile
	
	; We don't want to be hostile, otherwise we don't care
	if akTarget.GetFactionReaction(akCaster) == 1 || akTarget.GetRelationshipRank(akCaster) < -1 || !canAdd || akTarget == Game.GetPlayer()
		Dispel()
	else
		CheckDetection()
		RegisterForUpdate(3.0)
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; Debug.Notification("    Done detecting: " + akTarget.GetActorBase().GetName())
	if madeAlert
		akTarget.SetAlert(false)
	endif
EndEvent

Event OnDying(Actor akKiller)
	Dispel()
EndEvent

Event OnUpdate()
	CheckDetection()
EndEvent

Function CheckDetection()
	Actor target = GetTargetActor()
	Actor caster = GetCasterActor()
	
	bool detectedBy = caster.IsDetectedBy(target)
	if !detectedBy
		Utility.Wait(0.1)
		detectedBy = caster.IsDetectedBy(target)
	endif
	
	if detectedBy && !caster.IsUnconscious()
		detectedBy = false
	endif
	
	Debug.Notification(target.GetActorBase().GetName() + " detected victim: " + detectedBy)
	
	bool playerSendAlarm = (Game.GetPlayer().IsWeaponDrawn() && (Game.GetPlayer().GetEquippedWeapon(true) == Blackjack || Game.GetPlayer().GetEquippedWeapon(false) == Blackjack)) || Game.GetPlayer().IsTrespassing()
	if detectedBy && Game.GetPlayer().IsDetectedBy(target) && playerSendAlarm
		target.SendAssaultAlarm()
	elseif detectedBy
		if !target.IsAlerted()
			target.SetAlert(true)
			madeAlert = true
		endif
	endif
EndFunction

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	if aeCombatState != 0
		madeAlert = false
		Dispel()
	endif
EndEvent
