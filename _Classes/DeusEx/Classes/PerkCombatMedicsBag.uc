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
        med.MaxCopies = med.default.MaxCopies + PerkValue;
    }
    foreach PerkOwner.AllActors(class'BioelectricCell',cell)
    {
        cell.MaxCopies = cell.default.MaxCopies + PerkValue;
    }
}

defaultproperties
{
    PerkName="COMBAT MEDIC'S BAG"
    PerkDescription="An agent can carry %d additional medkits and biocells each and swiftly apply them as secondary items."
    PerkSkill=Class'DeusEx.SkillMedicine'
    PerkCost=250
    PerkLevelRequirement=3
    PerkValueDisplay=Standard
    PerkValue=5
}
