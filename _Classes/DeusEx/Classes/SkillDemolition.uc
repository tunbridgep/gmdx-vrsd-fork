//=============================================================================
// SkillDemolition.
//=============================================================================
class SkillDemolition extends Skill;

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
     mpLevel1=-0.100000
     mpLevel2=-0.300000
     mpLevel3=-0.500000
     SkillName="Weapons: Demolition"
     Description="The use of thrown explosive devices, including LAMs, gas grenades, EMP grenades, and electronic scrambler grenades. Total Skill points to master: 3875 |n|nUNTRAINED: An agent can throw grenades, attach them to a surface as a proximity device, or attempt to disarm and remove a previously armed proximity device.|n|nTRAINED: Grenade accuracy and damage increases slightly, as does the safety margin for disarming proximity devices.|n|nADVANCED: Grenade accuracy and damage increases moderately, as does the safety margin for disarming proximity devices.|n|nMASTER: An agent is an expert at all forms of demolition."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconDemolition'
     cost(0)=750
     cost(1)=1500
     cost(2)=3000
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
     PerksDescription="|nNearby proximity mines emit audible feedback to your infolink, revealing their location. |n|nRequires: Demolitions: TRAINED"
     PerksDescription2="|nGrenade detonation time is 1 second shorter. |n|nRequires: Demolitions: ADVANCED"
     PerksDescription3="|nAn agent modifies the chemical formula of gas grenades, adding a incapacitating agent to non-lethally knock out organic targets. |n|nRequires: Demolitions: MASTER"
     PerkName="SONIC-TRANSDUCER SENSOR"
     PerkName2="SHORT FUSE"
     PerkName3="KNOCKOUT GAS"
     PerkCost(0)=100
     PerkCost(1)=200
     PerkCost(2)=400
     LocalizedPerkName="SONIC-TRANSDUCER SENSOR"
     LocalizedPerkName2="SHORT FUSE"
     LocalizedPerkName3="KNOCKOUT GAS"
}
