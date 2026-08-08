//=============================================================================
// PerkCombatMedicsBag.
//=============================================================================
class PerkCombatMedicsBag extends Perk;

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
