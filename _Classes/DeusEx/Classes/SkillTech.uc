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

function bool UseHardcoreSkillValues(int index)
{
    return (player.bHarderLockpicking || player.bHardcoreMode) && LevelValuesHardcore[index] != -1;
}

function bool UseEasySkillValues(int index)
{
    return !player.bHarderLockpicking && player.CombatDifficulty <= 1 && LevelValuesEasy[index] != -1;
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
     Description="By studying electronics and its practical application, agents can more efficiently bypass a number of security systems using multitools. Total Skill points to master: 6000 |n|nUNTRAINED: An agent can bypass security systems.|n|nTRAINED: The efficiency with which an agent bypasses security increases slightly.|n|nADVANCED: The efficiency with which an agent bypasses security increases moderately.|n|nMASTER: An agent encounters almost no security systems of any challenge."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconTech'
     cost(0)=1000
     cost(1)=1750
     cost(2)=3250
     LevelValues(0)=0.100000
     LevelValues(1)=0.150000
     LevelValues(2)=0.250000
     LevelValues(3)=0.500000
     itemNeeded=Class'DeusEx.Multitool'
     bSmartSkillString=true
     LevelValuesHardcore(0)=0.050000
     LevelValuesHardcore(1)=0.100000
     LevelValuesHardcore(2)=0.200000
     LevelValuesHardcore(3)=0.50000
	 LevelValuesEasy(0)=0.100000
     LevelValuesEasy(1)=0.250000
     LevelValuesEasy(2)=0.400000
     LevelValuesEasy(3)=0.750000
}
