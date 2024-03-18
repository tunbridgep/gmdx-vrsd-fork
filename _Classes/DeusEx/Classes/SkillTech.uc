//=============================================================================
// SkillTech.
//=============================================================================
class SkillTech extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

var localized String MultitoolString;

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
		skillName=MultitoolString;
	}
}

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=0.100000
     mpLevel1=0.400000
     mpLevel2=0.550000
     mpLevel3=0.950000
     MultitoolString="Multitooling"
     SkillName="Electronics"
     Description="By studying electronics and its practical application, agents can more efficiently bypass a number of security systems using multitools. Total Skill points to master: 5250 |n|nUNTRAINED: An agent can bypass security systems.|n|nTRAINED: The efficiency with which an agent bypasses security increases slightly.|n|nADVANCED: The efficiency with which an agent bypasses security increases moderately.|n|nMASTER: An agent encounters almost no security systems of any challenge."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconTech'
     cost(0)=750
     cost(1)=1500
     cost(2)=3000
     LevelValues(0)=0.100000
     LevelValues(1)=0.150000
     LevelValues(2)=0.250000
     LevelValues(3)=0.500000
     itemNeeded=Class'DeusEx.Multitool'
     PerksDescription="|nBypassed alarm units deliver a non-lethal electric shock to whoever may attempt to trigger them.|n|nRequires: Electronics: TRAINED"
     PerksDescription2="|nMultitools gain considerably increased wireless signal strength, enabling an agent to hack security systems at range.|n|nRequires: Electronics: ADVANCED"
     PerksDescription3="|nAn agent can bypass any security system with a single multitool.|n|nRequires: Electronics: MASTER"
     PerkName="SABOTAGE"
     PerkName2="WIRELESS STRENGTH"
     PerkName3="CRACKED"
     PerkCost(0)=50
     PerkCost(1)=250
     PerkCost(2)=250
     LocalizedPerkName="SABOTAGE"
     LocalizedPerkName2="WIRELESS STRENGTH"
     LocalizedPerkName3="CRACKED"
}
