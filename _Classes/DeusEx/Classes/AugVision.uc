//=============================================================================
// AugVision.
//=============================================================================
class AugVision extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

var float visionRange;              //SARGE: Added
var float visionLevel;              //SARGE: Added

// ----------------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------------

replication
{
   //server to client function calls
   reliable if (Role == ROLE_Authority)
      SetVisionAugStatus;
}

state Active
{
Begin:
}

function Activate()
{
	local bool bWasActive;

	bWasActive = bIsActive;

	Super.Activate();

	if (!bWasActive && bIsActive)
	{
		SetVisionAugStatus(VisionLevel,GetVisionRange(),True);
		Player.RelevantRadius = GetVisionRange();
        Player.PlaySound(Sound'RSDCrap.Pickup.NightVisionEnable'); //CyberP: added new sound
	}
}

//SARGE: Vision range increases with level
function float GetVisionRange()
{
    return visionRange * (levelValues[3-CurrentLevel]);
}

function Deactivate()
{
	local bool bWasActive;

	bWasActive = bIsActive;

	Super.Deactivate();

	if (bWasActive && !bIsActive)
	{
		SetVisionAugStatus(VisionLevel,GetVisionRange(),False);
		Player.RelevantRadius = 0;
        Player.PlaySound(Sound'RSDCrap.Pickup.NightVisionDisable'); 
	}
}

// ----------------------------------------------------------------------
// SetVisionAugStatus()
// ----------------------------------------------------------------------

simulated function SetVisionAugStatus(int Level, int LevelValue, bool IsActive)
{
   if (IsActive)
   {
      if (++DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 1)
         DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = True;
   }
   else
   {
      if (--DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 0)
         DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = False;
      DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionBlinder = None;
      //Player.HeadRegion.Zone.ViewFog.Y = 0;
   }
	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = Level;
   DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = LevelValue;
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
     mpAugValue=800.000000
     mpEnergyDrain=50.000000
     EnergyRate=110.000000 //SARGE: Was 55
     Icon=Texture'DeusExUI.UserInterface.AugIconVision'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconVision_Small'
     AugmentationName="Vision Enhancement"
     Description="By bleaching selected rod photoreceptors and saturating them with metarhodopsin XII, the 'nightvision' present in most nocturnal animals can be duplicated. Subsequent upgrades and modifications add infravision and sonar-resonance imaging that effectively allows an agent to see through walls.|n|nTECH ONE: Nightvision.|n|nTECH TWO: Infravision.|n|nTECH THREE: Close range sonar imaging.|n|nTECH FOUR: Long range sonar imaging."
     MPInfo="When active, you can see enemy players in the dark from any distance, and for short distances you can see through walls and see cloaked enemies.  Energy Drain: Moderate"
     //LevelValues(2)=512.000000
     //LevelValues(3)=1024.000000 //SARGE: Now gives full benefit
     AugmentationLocation=LOC_Eye
     MPConflictSlot=6
     //SARGE: Now used for energy rate!
     LevelValues(0)=1.000000
     LevelValues(1)=0.830000
     LevelValues(2)=0.660000
     LevelValues(3)=0.500000
     visionRange=1024
     visionLevel=3
}
