;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname PRKF_BlackjackKnockoutLoot_FF00A45E Extends Perk Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Actor target = akTargetRef as Actor
if target != None
    target.OpenInventory(true)
endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Actor target = akTargetRef as Actor
if target != None
    if akActor.GetItemCount(SmellingSalts) <= 0
       NoSmellingSaltsMessage.Show()
    else
        if target.HasSpell(KnockoutDispelSpell)
            target.RemoveSpell(KnockoutDispelSpell)
        endif
        target.AddSpell(KnockoutDispelSpell)
        akActor.RemoveItem(SmellingSalts, 1, false)
    endif
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Spell Property KnockoutDispelSpell Auto
Ingredient Property SmellingSalts Auto
Message Property NoSmellingSaltsMessage Auto
