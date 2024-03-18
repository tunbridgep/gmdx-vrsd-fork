//=============================================================================
// AugHealing.
//=============================================================================
class AugHealing extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
var Skill sk_med;
var float adj_med;

state Active
{
Begin:
Loop:
	Sleep(2.0);
	/*adj_med=100.0;
	if (sk_med==None)
	{
      if (Player.SkillSystem!=None)
      {
         sk_med = Player.SkillSystem.GetSkillFromClass(Class'DeusEx.SkillMedicine');
         if (sk_med!=None)
            adj_med=(200+sk_med.CurrentLevel*10)/2.0;
      }
   } else
      adj_med=(200+sk_med.CurrentLevel*10)/2.0;
    if (player.DrugsTimerArray[1] > 0.0)                                        //RSD: Get 5 bonus health for every 2 min on timer
    	adj_med += 5.0*int(player.DrugsTimerArray[1]/120.0+1.0)/2.0;
   	if (player.DrugsWithdrawalArray[2] == 1)                                    //RSD: 10 health penalty for zyme withdrawal
   	    adj_med -= 10.0/2.0;
	if (Player.Health < adj_med)  //GMDX + current med skill*/
	if (Player.Health < Player.GenerateTotalMaxHealth())                        //RSD: New formula, needed to properly account for additive health bonuses/penalties (don't function properly over averaging)
		Player.HealPlayer(Int(LevelValues[CurrentLevel]), False);
	else
		Deactivate();
    Player.PlaySound(sound'biomodregenerate',SLOT_None);
	Player.ClientFlash(0.2, vect(0, 0, 500));  //CyberP: reduced flash scale (0.5).
	Goto('Loop');
}

function Deactivate()
{
	Super.Deactivate();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
	}
}

defaultproperties
{
     mpAugValue=10.000000
     mpEnergyDrain=100.000000
     EnergyRate=110.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconHealing'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconHealing_Small'
     AugmentationName="Regeneration"
     Description="Programmable polymerase automatically directs construction of proteins in injured cells, restoring an agent to full health over time.|n|nTECH ONE: Healing occurs at a normal rate.|n|nTECH TWO: Healing occurs at a slightly faster rate.|n|nTECH THREE: Healing occurs at a moderately faster rate.|n|nTECH FOUR: Healing occurs at a significantly faster rate."
     MPInfo="When active, you heal, but at a rate insufficient for healing in combat.  Energy Drain: High"
     LevelValues(0)=5.000000
     LevelValues(1)=10.000000
     LevelValues(2)=15.000000
     LevelValues(3)=20.000000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=2
}
