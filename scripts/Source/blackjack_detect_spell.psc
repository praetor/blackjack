Scriptname blackjack_detect_spell extends activemagiceffect

Keyword[] Property ValidRaceKeywords Auto
Weapon Property Blackjack Auto
float Property AttackRange Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
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
		RegisterForUpdate(8.0)
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
EndEvent

Event OnDying(Actor akKiller)
	Dispel()
EndEvent

Event OnUpdate()
	if GetCasterActor() == None
		UnregisterForUpdate()
		Dispel()
	else
		CheckDetection()
	endif
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
	
	float dist = Game.GetPlayer().GetDistance(caster)
	bool playerSendAlarm = (Game.GetPlayer().IsWeaponDrawn() && (Game.GetPlayer().GetEquippedWeapon(true) == Blackjack || Game.GetPlayer().GetEquippedWeapon(false) == Blackjack)) || Game.GetPlayer().IsTrespassing()
	if detectedBy && Game.GetPlayer().IsDetectedBy(target) && playerSendAlarm && dist <= AttackRange
		target.SendAssaultAlarm()
	endif
EndFunction

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	if aeCombatState != 0
		Dispel()
	endif
EndEvent
