//=============================================================================
// SkillMedicine.
//=============================================================================
class SkillMedicine extends Skill;

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

// ----------------------------------------------------------------------
// IncLevel() , no Super.IncLevel is its pointless :P
// modified by dasraiser for GMDX :increment medical skill and upgrade head/torso hit points !HACK
// ----------------------------------------------------------------------
function bool IncLevel(optional DeusExPlayer usePlayer)
{
	local DeusExPlayer localPlayer;
    local int DrunkAdd, ZymeSubtract;                                           //RSD: Now get bonus max health from drinking, penalty for zyme
    if (player.AddictionManager.addictions[1].drugTimer > 0.0)
        DrunkAdd = 5*int(player.AddictionManager.addictions[1].drugTimer/120.0+1.0);                  //RSD: Get 5 bonus health for every 2 min on timer
    else
        DrunkAdd = 0;
    if (player.AddictionManager.addictions[2].bInWithdrawals)                                    //RSD: 10 health penalty for zyme withdrawal
        ZymeSubtract = 10;
    else
        ZymeSubtract = 0;
	// First make sure we're not maxed out
	if (CurrentLevel < 3)
	{
		// If "usePlayer" is passed in, then we want to use this
		// as the basis for making our calculations, temporarily
		// overriding whatever this skill's player is set to.

		if (usePlayer != None)
			localPlayer = usePlayer;
		else
			localPlayer = Player;

		// Now, if a player is defined, then check to see if there enough
		// skill points available.  If no player is defined, just do it.
		if (localPlayer != None)
		{
			if ((localPlayer.SkillPointsAvail >= Cost[CurrentLevel]))
			{
				// decrement the cost and increment the current skill level
				localPlayer.SkillPointsAvail -= GetCost();
				CurrentLevel++;
				//GMDX !HACK give extra health to player
				localPlayer.PlaySound(Sound'GMDXSFX.Generic.Select',SLOT_None);
				localPlayer.HealthHead=Min(localPlayer.HealthHead+CurrentLevel*10.0,100.0+CurrentLevel*10.0);
				localPlayer.HealthTorso=Min(localPlayer.HealthTorso+CurrentLevel*10.0+DrunkAdd,100.0+CurrentLevel*10.0+DrunkAdd-ZymeSubtract); //RSD: Added drunk, zyme
            localPlayer.GenerateTotalHealth();
				return True;
			}
		}
		else
		{
			CurrentLevel++;
			//GMDX !HACK
			localPlayer.HealthHead=Min(localPlayer.HealthHead+CurrentLevel*10.0,100.0+CurrentLevel*10.0);
			localPlayer.HealthTorso=Min(localPlayer.HealthTorso+CurrentLevel*10.0+DrunkAdd,100.0+CurrentLevel*10.0+DrunkAdd-ZymeSubtract); //RSD: Added drunk, zyme
	      localPlayer.GenerateTotalHealth();
			return True;
		}
	}
	return False;
}

// ----------------------------------------------------------------------
// DecLevel() , no Super.DecLevel required :P
//
// modified by dasraiser for GMDX: decrement skill and remove any extra health !HACK
// Decrements a skill level, making sure the skill isn't already at
// the lowest skill level.  Cost of the skill is optionally added back
// to the player's SkilPointsAvail variable.
// ----------------------------------------------------------------------

function bool DecLevel(
	optional bool bGiveUserPoints,
	optional DeusExPlayer usePlayer )
{
	local DeusExPlayer localPlayer;

	// First make sure we're not already at the bottom
	if (CurrentLevel > 0)
	{
		// Decrement the skill level
		CurrentLevel--;

		// If "usePlayer" is passed in, then we want to use this
		// as the basis for making our calculations, temporarily
		// overriding whatever this skill's player is set to.

		if (usePlayer != None)
			localPlayer = usePlayer;
		else
			localPlayer = Player;

		// If a player exists and the 'bGiveUserPoints' flag is set,
		// then add the points to the player
		if (( bGiveUserPoints ) && (localPlayer != None))
			localPlayer.SkillPointsAvail += GetCost();

      //GMDX !HACK
      localPlayer.HealthHead=Min(localPlayer.HealthHead,100.0+CurrentLevel*10.0);
		localPlayer.HealthTorso=Min(localPlayer.HealthTorso,100.0+CurrentLevel*10.0);
      localPlayer.GenerateTotalHealth();
		return True;
	}
	return False;
}

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=1.000000
     mpLevel1=1.000000
     mpLevel2=2.000000
     mpLevel3=3.000000
     SkillName="Medicine"
     Description="Practical knowledge of human physiology can be applied by an agent in the field allowing more efficient use of medkits. Total Skill points to master: 9000 |n|nUNTRAINED: An agent can use medkits.|n|nTRAINED: An agent can heal slightly more damage, has slightly more health and reduce the period of toxic poisoning.|n|nADVANCED: An agent can heal moderately more damage, has improved health and further reduce the period of toxic poisoning.|n|nMASTER: An agent can perform a heart bypass with household materials and has a significant health care package."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconMedicine'
     cost(0)=900
     cost(1)=1800
     cost(2)=3600
     LevelValues(0)=1.000000
     LevelValues(1)=2.000000
     LevelValues(2)=2.500000
     LevelValues(3)=3.000000
     PerksDescription="|nAn agent recieves additional bioelectrical charge from biocells (+5). |n|nRequires: Medicine: TRAINED"
     PerksDescription2="|nAn agent can instantaneously remove poisonous toxins from the bloodstream by applying a medkit to the torso. |n|nRequires: Medicine: ADVANCED"
     PerksDescription3="|nAn agent can carry five additional medkits and biocells each and swiftly apply them as secondary items.|n|nRequires: Medicine: MASTER"
     PerkName="BIOGENIC"
     PerkName2="TOXICOLOGIST"
     PerkName3="COMBAT MEDIC'S BAG"
     PerkCost(0)=175
     PerkCost(1)=75
     PerkCost(2)=250
     LocalizedPerkName="BIOGENIC"
     LocalizedPerkName2="TOXICOLOGIST"
     LocalizedPerkName3="COMBAT MEDIC'S BAG"
}
