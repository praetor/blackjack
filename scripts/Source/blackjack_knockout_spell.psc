Scriptname blackjack_knockout_spell extends activemagiceffect

float Property Duration Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForSingleUpdate(Duration)
EndEvent

Event OnUpdate()
	Dispel()
EndEvent
