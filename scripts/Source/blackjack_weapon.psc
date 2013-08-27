Scriptname blackjack_weapon extends ObjectReference

Weapon Property BlackjackWeapon Auto
Perk Property LootPerk Auto

Event OnEquipped(Actor akActor)
	if akActor.HasPerk(LootPerk)
		akActor.RemovePerk(LootPerk)
	endif
	akActor.AddPerk(LootPerk)
EndEvent