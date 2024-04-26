//=============================================================================
// PerkSidearm.
//=============================================================================
class PerkSidearm extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="SIDEARM"
    PerkDescription="|nAn agent's standing accuracy bonus is not reset when swapping to a pistol.|n|nRequires: Pistols: TRAINED"
    PerkSkill=Class'DeusEx.SkillWeaponPistol'
    PerkCost=150
    perkLevelRequirement=0
    PerkValue=1
}