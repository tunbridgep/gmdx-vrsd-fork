//=============================================================================
// SkillComputer.
//=============================================================================
class SkillComputer extends Skill;

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
//GMDX: upped level 4 so can be leisurely (was 4)

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=0.400000
     mpLevel1=0.400000
     mpLevel2=1.000000
     mpLevel3=5.000000
     SkillName="Computers"
     Description="The covert manipulation of computers and security consoles.|n|nTotal skill points to master: 6000.|n|nUNTRAINED: An agent can use terminals to read bulletins and news. |n|nTRAINED: An agent can hack computers and security consoles of intermediate security systems, can shut security systems down for 2 minutes, and siphon up to half of an ATM's funds. |n|nADVANCED: An agent can hack computers featuring advanced defense systems and siphon all credits from ATMs, and achieves a moderate increase in detection time as well as a 1 minute increase in security shutdown time.|n|nMASTER: An agent is an elite hacker that no system can withstand, gaining the ability to spoof additional credits from ATMs and evading detection for long periods, including an additional 1 minute increase in security shutdown time."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconComputer'
     cost(0)=1000
     cost(1)=2000
     cost(2)=3000
     LevelValues(0)=1.000000
     LevelValues(1)=1.000000
     LevelValues(2)=2.000000
     LevelValues(3)=16.000000
}
