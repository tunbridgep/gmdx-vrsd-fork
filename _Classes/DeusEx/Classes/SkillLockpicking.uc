//=============================================================================
// SkillLockpicking.
//=============================================================================
class SkillLockpicking extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

//SARGE: Added special value arrays for HC and Easy
//vRSD previously hardcoded these :laughing_emoji:
var float LevelValuesHardcore[4];
var float LevelValuesEasy[4];

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

function Refresh()
{
    super.Refresh();

    //SARGE: Have to assign these individually,
    //because UnrealScript doesn't support assigning arrays
    if (player.bHardcoreMode || player.bHarderLockpicking)
    {
        LevelValues[0] = LevelValuesHardcore[0];
        LevelValues[1] = LevelValuesHardcore[1];
        LevelValues[2] = LevelValuesHardcore[2];
        LevelValues[3] = LevelValuesHardcore[3];
    }
    else if (player.CombatDifficulty <= 1)
    {
        LevelValues[0] = LevelValuesEasy[0];
        LevelValues[1] = LevelValuesEasy[1];
        LevelValues[2] = LevelValuesEasy[2];
        LevelValues[3] = LevelValuesEasy[3];
    }
    else
    {
        LevelValues[0] = default.LevelValues[0];
        LevelValues[1] = default.LevelValues[1];
        LevelValues[2] = default.LevelValues[2];
        LevelValues[3] = default.LevelValues[3];
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
     SkillName="Lockpicking"
     Description="Lockpicking is as much art as skill, but with intense study it can be mastered by any agent with patience and a set of lockpicks. Total Skill points to master: 6000 |n|nUNTRAINED: An agent can pick locks.|n|nTRAINED: The efficiency with which an agent picks locks increases slightly.|n|nADVANCED: The efficiency with which an agent picks locks increases moderately.|n|nMASTER: An agent can defeat almost any mechanical lock."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconLockPicking'
     cost(0)=1000
     cost(1)=1750
     cost(2)=3250
     LevelValues(0)=0.100000
     LevelValues(1)=0.150000
     LevelValues(2)=0.250000
     LevelValues(3)=0.500000
     itemNeeded=Class'DeusEx.Lockpick'
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
