//=============================================================================
// PerkMarksman.
//=============================================================================
class PerkMarksman extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="MARKSMAN"
    PerkDescription="|nAn agent aims down a rifle's scope 30% faster, handles rifle recoil efficiently, and sway when looking through a rifle's scope is reduced marginally.|n|nRequires: Rifles: MASTER"
    PerkSkill=Class'DeusEx.SkillWeaponRifle'
    PerkCost=300
    perkLevelRequirement=2
    PerkValue=1.3
}