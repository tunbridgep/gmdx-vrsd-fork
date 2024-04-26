//=============================================================================
// PerkSteady.
//=============================================================================
class PerkSteady extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="STEADY"
    PerkDescription="|nAn agent's standing accuracy bonus with rifles is accelerated by 50%.|n|nRequires: Rifles: TRAINED"
    PerkSkill=Class'DeusEx.SkillWeaponRifle'
    PerkCost=200
    perkLevelRequirement=0
    PerkValue=1.5
}