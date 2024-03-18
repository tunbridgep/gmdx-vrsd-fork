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
     SkillName="Hacking"
     Description="The covert manipulation of computers and security consoles. Total Skill points to master: 6000 |n|nUNTRAINED: An agent can use terminals to read bulletins and news.|n|nTRAINED: An agent can hack ATMs, computers, and security consoles.|n|nADVANCED: An agent achieves a moderate increase in detection countdowns, a moderate decrease in lockout times and the ability to Siphon more cash from an ATM, as well as gaining the ability to control automated gun turrets.|n|nMASTER: An agent is an elite hacker that few systems can withstand."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconComputer'
     cost(0)=1000
     cost(1)=2000
     cost(2)=3000
     LevelValues(0)=1.000000
     LevelValues(1)=1.000000
     LevelValues(2)=2.000000
     LevelValues(3)=16.000000
     PerksDescription="|nAn agent improves the STOP! Worm program, doubling its effectiveness. |n|nRequires: Hacking: TRAINED"
     PerksDescription2="|nAn agent hacks additional restoration from medical and maintenance bots. |n|nRequires: Hacking: ADVANCED"
     PerksDescription3="|nAn agent can alter the IFF routines of gun turrets to make them target his enemies, or everything in sight. |n|nRequires: Hacking: MASTER"
     PerkName="MODDER"
     PerkName2="MISFEATURE EXPLOIT"
     PerkName3="NEAT HACK"
     PerkCost(0)=50
     PerkCost(1)=125
     PerkCost(2)=200
     LocalizedPerkName="MODDER"
     LocalizedPerkName2="MISFEATURE EXPLOIT"
     LocalizedPerkName3="TURRET DOMINATION"
}
