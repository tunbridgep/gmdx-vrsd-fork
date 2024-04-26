//=============================================================================
// PerkStoppingPower.
//=============================================================================
class PerkStoppingPower extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="STOPPING POWER"
    PerkDescription="|nAn agent can stop an enemy in their tracks with a shotgun blast, gaining bonus damage (+25%) when every pellet hits a single target.|n|nRequires: Rifles: ADVANCED"
    PerkSkill=Class'DeusEx.SkillWeaponRifle'
    PerkCost=150
    perkLevelRequirement=1
    PerkValue=1.25
}