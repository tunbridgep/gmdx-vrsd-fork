//=============================================================================
// PerkCracked.
//=============================================================================
class PerkCracked extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="CRACKED"
    PerkDescription="|nAn agent can bypass any security system with a single multitool.|n|nRequires: Electronics: MASTER"
    PerkSkill=Class'DeusEx.SkillTech'
    PerkCost=250
    perkLevelRequirement=2
    PerkValue=1
}