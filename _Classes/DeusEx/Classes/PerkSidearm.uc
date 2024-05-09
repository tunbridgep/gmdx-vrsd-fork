//=============================================================================
// PerkSidearm.
//=============================================================================
class PerkSidearm extends Perk;

defaultproperties
{
    PerkName="SIDEARM"
    PerkDescription="|nAn agent's standing accuracy bonus is not reset when swapping to a pistol.|n|nRequires: Pistols: TRAINED"
    PerkSkill=Class'DeusEx.SkillWeaponPistol'
    PerkIcon=Texture'RSDCrap.UserInterface.PerkSidearm'
    PerkCost=150
    PerkLevelRequirement=1
    PerkValue=1
}