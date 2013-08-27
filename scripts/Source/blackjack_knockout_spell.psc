Scriptname blackjack_knockout_spell extends activemagiceffect

float Property Duration Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akTarget.SetUnconscious(true)
	akTarget.SetNotShowOnStealthMeter(true)
	
	AlertAllNearby(akTarget, true)
	
	RegisterForSingleUpdate(Duration)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akTarget.SetUnconscious(false)
	akTarget.SetNotShowOnStealthMeter(false)
EndEvent

Event OnUpdate()
	Dispel()
EndEvent

Function AlertAllNearby(Actor target, bool attackNow)
	int i = 1
	float range = 512
	while(i < 4) 
		AlertNearbyActor(target, target.X + range*-0.1732035, target.Y + range*0.9372016, target.Z, range, attackNow)
		AlertNearbyActor(target, target.X + range*-0.8792607, target.Y + range*0.4391538, target.Z, range, attackNow)
		AlertNearbyActor(target, target.X + range*-0.1989337, target.Y + range*0.4308908, target.Z, range, attackNow)
		AlertNearbyActor(target, target.X + range*0.8045496, target.Y + range*0.4809247, target.Z, range, attackNow)
		AlertNearbyActor(target, target.X + range*-0.3928336, target.Y + range*-0.1244646, target.Z, range, attackNow)
		AlertNearbyActor(target, target.X + range*0.6305876, target.Y + range*-0.6511456, target.Z, range, attackNow)
		AlertNearbyActor(target, target.X + range*-0.4556656, target.Y + range*-0.8267384, target.Z, range, attackNow)
		AlertNearbyActor(target, target.X + range*0.2083596, target.Y + range*-0.218491, target.Z, range, attackNow)
		
		range = range*2
		i = i+1
	endwhile
EndFunction

Function AlertNearbyActor(Actor target, float x, float y, float z, float range, bool attackNow)
	Actor closest = Game.FindClosestActor(x, y, z, range)
	if closest != None && closest != target && closest != Game.GetPlayer() && !closest.IsUnconscious()
		bool detectedTarget = target.IsDetectedBy(closest)
		
		if detectedTarget
			if attackNow
				target.SendAssaultAlarm()
			endif
		else
			Utility.Wait(0.25)
		
			detectedTarget = target.IsDetectedBy(closest)
		
			if detectedTarget
				if attackNow
					target.SendAssaultAlarm()
				endif
			endif
		endif
	endif
EndFunction
