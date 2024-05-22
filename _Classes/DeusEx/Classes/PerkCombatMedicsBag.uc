//=============================================================================
// PerkCombatMedicsBag.
//=============================================================================
class PerkCombatMedicsBag extends Perk;

function OnPerkPurchase()
{
    local Medkit med;
    local BioelectricCell cell;

    foreach PerkOwner.AllActors(class'Medkit',med)
    {
        med.MaxCopies = 20;
    }
    foreach PerkOwner.AllActors(class'BioelectricCell',cell)
    {
        cell.MaxCopies = 25;
    }
}

defaultproperties
{
    PerkName="COMBAT MEDIC'S BAG"
    PerkDescription="|nAn agent can carry five additional medkits and biocells each and swiftly apply them as secondary items.|n|nRequires: Medicine: MASTER"
    PerkSkill=Class'DeusEx.SkillMedicine'
    PerkCost=250
    PerkLevelRequirement=3
    PerkValue=1
}