//=============================================================================
// SkillWeaponHeavy.
//=============================================================================
class SkillWeaponHeavy extends Skill;

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
     mpCost1=2000
     mpCost2=2000
     mpCost3=2000
     mpLevel0=-0.100000
     mpLevel1=-0.250000
     mpLevel2=-0.370000
     mpLevel3=-0.500000
     SkillName="Weapons: Heavy"
     Description="The use of heavy weaponry, including flamethrowers, LAWs, and the experimental plasma and GEP guns. Total skill points to master: 9000 |n# of perks: 3  |n|nUNTRAINED: An agent can use heavy weaponry, but their accuracy is low and movement is difficult.|n|nTRAINED: Accuracy and damage increases slightly, while reloading and movement is somewhat faster.|n|nADVANCED: Accuracy and damage increases moderately, while reloading and movement is even more rapid.|n|nMASTER: An agent is a walking tank when equipped with heavy weaponry."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     cost(0)=1500
     cost(1)=3000
     cost(2)=4500
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
     PerksDescription="|nAn agent is trained with the use of the flamethrower, ensuring that the igniting fuel is not blocked by targets.|n|nRequires: Heavy Weapons: TRAINED"
     PerksDescription2="|nAn agent tunes the plasma rifle to reduce damage falloff within the same blast radius.|n|nRequires: Heavy Weapons: ADVANCED"
     PerksDescription3="|nThe blast radius of an agent's GEP rockets is increased two-fold. |n|nRequires: Heavy Weapons: MASTER"
     PerkName="FOCUSED: HEAVY WEAPONS"
     PerkName2="PERFECT STANCE: HEAVY WEAPONS"
     PerkName3="H.E ROCKET"
     PerkCost(0)=150
     PerkCost(1)=250
     PerkCost(2)=400
     LocalizedPerkName="CONTROLLED BURN"
     LocalizedPerkName2="BLAST ENERGY"
     LocalizedPerkName3="H.E ROCKET"
}
