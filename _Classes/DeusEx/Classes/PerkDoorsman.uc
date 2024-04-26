//=============================================================================
// PerkDoorsman.
//=============================================================================
class PerkDoorsman extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="DOORSMAN"
    PerkDescription="|nWith advanced lockpicking skill comes knowledge of doors and their structural vulnerabilities. The damage threshold of all breakable doors is reduced by 5.  |n|nRequires: Lockpicking: ADVANCED"
    PerkSkill=Class'DeusEx.SkillLockpicking'
    PerkCost=225
    perkLevelRequirement=1
    PerkValue=1
}