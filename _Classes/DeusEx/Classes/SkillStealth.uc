//=============================================================================
// SkillStealth.
//=============================================================================
class SkillStealth extends Skill;

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
     SkillName="Stealth"
     Description="Covert ops require swift and precise stealth skills that must be developed by an agent over time via intensive training.|n|nTotal skill points to master: 5250|n# of perks: 3|n|nUNTRAINED: An agent can sneak, most effective if sticking to the shadows.|n|nTRAINED: Movement speed whilst walking & crouched is increased (+15%), and an agent produces less noise when landing from height by perfecting a basic landing technique.|n|nADVANCED: After further training speed whilst walking & crouched is increased moderately (+30%), and an agent understands the loopholes of the modern security camera's threat recon systems, avoiding detection for a longer period of time (+45%).|n|nMASTER: An agent need not rely on advanced tech to infiltrate high-security areas:|n|n-speed whilst walking & crouched is increased significantly (+45%).|n-An agent leans faster (+100%).|n-An agent discovers transgenically-modified animals prioritize eating over attacking; an agent can use this newfound knowledge to his advantage."
     SkillIcon=Texture'GMDXUI.UserInterface.SkillIconStealth_Small'
     bAutomatic=True
     cost(0)=750
     cost(1)=1500
     cost(2)=3000
     LevelValues(0)=0.100000
     LevelValues(1)=1.000000
     LevelValues(2)=1.500000
     LevelValues(3)=2.500000
     PerksDescription="|nAn agent is silent whilst mantling and climbing ladders. |n|nRequires: Stealth: TRAINED"
     PerksDescription2="|nAn agent easily identifies the blindspots of modern security systems, evading camera detection for a longer period of time (+50%) and tucking the legs away from laser tripwires.|n|nRequires: Stealth: ADVANCED"
     PerksDescription3="|nAn agent is skilled in the art of distraction, confusing enemies for longer with sound (+50%) and diverting enraged animals on the attack by using carcasses as bait.|n|nRequires: Stealth: MASTER"
     PerkName="NIMBLE"
     PerkName2="NERVES OF STEEL"
     PerkName3="CREEPER"
     PerkCost(0)=150
     PerkCost(1)=200
     PerkCost(2)=250
     LocalizedPerkName="NIMBLE"
     LocalizedPerkName2="SECURITY LOOPHOLE"
     LocalizedPerkName3="TACTICAL DISTRACTION"
}
