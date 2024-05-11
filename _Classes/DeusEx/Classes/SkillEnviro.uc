//=============================================================================
// SkillEnviro.
//=============================================================================
class SkillEnviro extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		cost[0] = mpCost1;
		cost[1] = mpCost2;
		cost[2] = mpCost3;
		LevelValues[0] = mpLevel0;
		LevelValues[1] = mpLevel1;
		LevelValues[2] = mpLevel2;
		LevelValues[3] = mpLevel3;
	}
}

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=1.000000
     mpLevel1=0.750000
     mpLevel2=0.500000
     mpLevel3=0.250000
     SkillName="Environmental Training"
     Description="Experience with using hazmat suits, ballistic armor, thermoptic camo, and rebreathers in a number of dangerous situations. Total Skill points to master: 3000 |n|nUNTRAINED: An agent can use hazmat suits, ballistic armor, thermoptic camo, and rebreathers.|n|nTRAINED: Armor, suits, camo, and rebreathers can be used slightly longer and more efficiently.|n|nADVANCED: Armor, suits, camo, and rebreathers can be used moderately longer and more efficiently.|n|nMASTER: An agent wears suits and armor like a second skin."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconEnviro'
     bAutomatic=True
     cost(0)=750
     cost(1)=1500
     cost(2)=3000
     LevelValues(0)=1.000000
     LevelValues(1)=0.750000
     LevelValues(2)=0.500000
     LevelValues(3)=0.250000
     PerksDescription="|nAn agent can perform more effective equipment repairs with biocells (1.5x).|n|nRequires: Environmental Training: TRAINED"
     PerksDescription2="|nIf the bloodstream is exposed to toxic poisoning, an agent's vision is not distorted and internal damage is reduced marginally. |n|nRequires: Environmental Training: ADVANCED"
     PerksDescription3="|nAn agent modifies tech goggle functionality, implementing short-ranged sonar scanning which enables the user to see potential threats through solid material.|n An Agent also modifies thermoptic camo output that enables the user to pass through laser alarms undetected. |n|nRequires: Environmental Training: MASTER"
     PerkName="STEADY-FOOTED"
     PerkName2="HARDENED"
     PerkName3="TECH SPECIALIST"
     PerkCost(0)=200
     PerkCost(1)=175
     PerkCost(2)=225
     LocalizedPerkName="FIELD REPAIR"
     LocalizedPerkName2="HARDENED"
     LocalizedPerkName3="TECH SPECIALIST"
}
