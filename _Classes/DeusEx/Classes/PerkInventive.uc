//=============================================================================
// PerkInventive.
//=============================================================================
class PerkInventive extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="Inventive"
    PerkDescription="|nAn agent can assign melee weapons as a secondary weapon. |n|nRequires: Low-Tech: MASTER"
    PerkSkill=Class'DeusEx.SkillWeaponLowTech'
    PerkCost=400
    perkLevelRequirement=2
    PerkValue=1
}