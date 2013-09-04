Scriptname blackjack_suspect_spell extends activemagiceffect  

Weapon Property Blackjack Auto
float Property Duration Auto
float Property AttackRange Auto

float targetTime = 0.0
bool hasAlerted = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if !akTarget.IsAlerted()
		akTarget.SetAlert(true)
		hasAlerted = true
	endif
	
	Debug.Notification(akTarget.GetActorBase().GetName() + " is suspicious")

	SuspectPlayer()
	
	targetTime = Utility.GetCurrentRealTime() + Duration
	
	RegisterForUpdate(2.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Debug.Notification(akTarget.GetActorBase().GetName() + " not suspicious")
	
	if hasAlerted
		akTarget.SetAlert(false)
		hasAlerted = false
	endif
EndEvent

Event OnDying(Actor akKiller)
	Dispel()
EndEvent

Event OnUpdate()
	if Utility.GetCurrentRealTime() >= targetTime
		Dispel()
	else
		SuspectPlayer()
	endif
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	if aeCombatState != 0
		Dispel()
	endif
EndEvent

Function SuspectPlayer()
	Actor target = GetTargetActor()
	float dist = Game.GetPlayer().GetDistance(target)
	bool playerSendAlarm = (Game.GetPlayer().IsWeaponDrawn() && (Game.GetPlayer().GetEquippedWeapon(true) == Blackjack || Game.GetPlayer().GetEquippedWeapon(false) == Blackjack)) || Game.GetPlayer().IsTrespassing()
	if Game.GetPlayer().IsDetectedBy(target) && playerSendAlarm && dist <= AttackRange
		target.SendAssaultAlarm()
	endif
EndFunction
