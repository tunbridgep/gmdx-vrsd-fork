//=============================================================================
// PerkCombatMedicsBag.
//=============================================================================
class PerkCombatMedicsBag extends Perk;

function OnPerkPurchase()
{
    class'BioelectricCell'.default.MaxCopies += 5;
    class'Medkit'.default.MaxCopies += 5;
}

/*
function OnMapLoadAndPurchase()
{
    local Medkit MK;
    local BioelectricCell BE;

    foreach PerkOwner.AllActors(class'Medkit',MK)
        MK.MaxCopies = MK.default.MaxCopies;
    foreach PerkOwner.AllActors(class'BioelectricCell',BE)
        BE.MaxCopies = BE.default.MaxCopies;
}
*/

defaultproperties
{
    PerkName="COMBAT MEDIC'S BAG"
    PerkDescription="An agent can carry %d additional medkits and biocells each and swiftly apply them as secondary items."
    PerkSkill=Class'DeusEx.SkillMedicine'
    PerkIcon=Texture'RSDCrap.UserInterface.PerkCombatMedicsBag'
    PerkCost=250
    PerkLevelRequirement=3
    PerkValueDisplay=Standard
    PerkValue=5
}
