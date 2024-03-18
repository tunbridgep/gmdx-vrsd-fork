//=============================================================================
// SkillWeaponLowTech.
//=============================================================================
class SkillWeaponLowTech extends Skill;

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
     SkillName="Weapons: Low-Tech"
     Description="The use of melee weapons such as knives, throwing knives, swords, pepper guns, and prods. Total Skill points to master: 6000 |n|nUNTRAINED: An agent can use melee weaponry.|n|nTRAINED: Accuracy, damage, and rate of attack all increase slightly.|n|nADVANCED: Accuracy, damage, and rate of attack all increase moderately.|n|nMASTER: An agent can render most opponents unconscious or dead with a single blow."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponLowTech'
     cost(0)=900
     cost(1)=1800
     cost(2)=3600
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
     PerksDescription="|nAn agent can clearly see the traversed flight path of airborne darts and throwing knives. |n|nRequires: Low-Tech: TRAINED"
     PerksDescription2="|nAn agent is more likely to cause organic targets to flinch in pain when struck by low-tech weaponry, and an agent deals 20% more damage to bots with low-tech weaponry. |n|nRequires: Low-Tech: ADVANCED"
     PerksDescription3="|nAn agent can assign melee weapons as a secondary weapon. |n|nRequires: Low-Tech: MASTER"
     PerkName="SHARP-EYED"
     PerkName2="PIERCING"
     PerkName3="INVENTIVE"
     PerkCost(0)=125
     PerkCost(1)=250
     PerkCost(2)=400
     LocalizedPerkName="SHARP-EYED"
     LocalizedPerkName2="PIERCING"
     LocalizedPerkName3="INVENTIVE"
}
