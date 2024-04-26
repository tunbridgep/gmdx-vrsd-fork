//=============================================================================
// PerkTechSpecialist.
//=============================================================================
class PerkTechSpecialist extends Perk;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
}

defaultproperties
{
    PerkName="TECH SPECIALIST"
    PerkDescription="|nAn agent modifies tech goggle functionality, implementing short-ranged sonar scanning which enables the user to see potential threats through solid material.|n An Agent also modifies thermoptic camo output that enables the user to pass through laser alarms undetected. |n|nRequires: Environmental Training: MASTER"
    PerkSkill=Class'DeusEx.SkillEnviro'
    PerkCost=225
    perkLevelRequirement=2
    PerkValue=1
}