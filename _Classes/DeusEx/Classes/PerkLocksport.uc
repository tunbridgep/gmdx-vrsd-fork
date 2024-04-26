//=============================================================================
// PerkLocksport.
//=============================================================================
class PerkLocksport extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="LOCKSPORT"
    PerkDescription="|nAn agent can pick any mechanical lock with a single lockpick. |n|nRequires: Lockpicking: MASTER"
    PerkSkill=Class'DeusEx.SkillLockpicking'
    PerkCost=200
    perkLevelRequirement=2
    PerkValue=1
}