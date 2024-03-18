//=============================================================================
// SkillWeaponRifle.
//=============================================================================
class SkillWeaponRifle extends Skill;

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
     SkillName="Weapons: Rifle"
     Description="The use of rifles, including assault rifles, sniper rifles, and shotguns. Total Skill points to master: 9975 |n|nUNTRAINED: An agent can use rifles.|n|nTRAINED: Accuracy and damage increases slightly, while reloading is faster.|n|nADVANCED: Accuracy and damage increases moderately, while reloading is even more rapid.|n|nMASTER: An agent can take down a target a mile away with one shot."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponRifle'
     cost(0)=1500
     cost(1)=3000
     cost(2)=4500
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
     PerksDescription="|nAn agent's standing accuracy bonus with rifles is accelerated by 50%.|n|nRequires: Rifles: TRAINED"
     PerksDescription2="|nAn agent can stop an enemy in their tracks with a shotgun blast, gaining bonus damage (+25%) when every pellet hits a single target.|n|nRequires: Rifles: ADVANCED"
     PerksDescription3="|nAn agent aims down a rifle's scope 30% faster, handles rifle recoil efficiently, and sway when looking through a rifle's scope is reduced marginally.|n|nRequires: Rifles: MASTER"
     PerkName="FOCUSED: RIFLES"
     PerkName2="QUICKDRAW"
     PerkName3="PERFECT STANCE: RIFLES"
     PerkCost(0)=200
     PerkCost(1)=150
     PerkCost(2)=300
     LocalizedPerkName="STEADY"
     LocalizedPerkName2="STOPPING POWER"
     LocalizedPerkName3="MARKSMAN"
}
