Scriptname blackjack_weapon extends ObjectReference

Weapon Property BlackjackWeapon Auto
Perk Property LootPerk Auto

Event OnEquipped(Actor akActor)
	akActor.AddPerk(LootPerk)
EndEvent