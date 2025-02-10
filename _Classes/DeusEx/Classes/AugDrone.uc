//=============================================================================
// AugDrone.
//=============================================================================
class AugDrone extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

var float lastDroneTime;

var bool bTimerEarly;                                                           //RSD: bool for if you tried to use the drone too early (need for rotation shenanigans)

var int EMPDrain;                                                               //SARGE: energy used for EMP attack

var const localized string ReconstructionMessage;
var const localized string GroundedMessage;

function string GetChargingMessage()
{
    return Sprintf(ReconstructionMessage, int(currentChargeTime));
}

function bool CanActivate(out string message)
{
    if (player.Physics == PHYS_Falling || player.physics == PHYS_Swimming)
    {
        message = GroundedMessage;
        return false;
    }

    return Super.CanActivate(message);
}

state Active
{

function Timer()
{
    if (IsInState('Active'))
    {
        Player.bSpyDroneActive = True;
        Player.bSpyDroneSet = False;                                            //RSD: Allows the user to toggle between moving and controlling the drone
        Player.spyDroneLevel = CurrentLevel;
        Player.spyDroneLevelValue = LevelValues[CurrentLevel];
        Player.ConfigBigDroneView(true);
    }
}
Begin:
	bTimerEarly = false;                                                        //RSD
    SetTimer(0.4,False);
    player.SAVErotation = player.ViewRotation;                                  //RSD: Set the SAVErotation the first time we activate
}

function Deactivate()
{
	if (Player.bSpyDroneSet)                                                    //RSD: Allows the user to toggle between moving and controlling the drone
	{
		if (IsA('AugDrone') && (player.Physics == PHYS_Falling || player.physics == PHYS_Swimming))
        	{ player.ClientMessage("You must be grounded to resume control of the drone"); return;  }

        Player.bSpyDroneSet = false;
		Player.SAVErotation = Player.ViewRotation;
		Player.ViewRotation = Player.DRONESAVErotation;

        Player.ConfigBigDroneView(true);
        return;
	}

    if (!bTimerEarly)
        Player.ViewRotation = Player.SAVErotation;

    Super.Deactivate();

	// record the time if we were just active
	if (Player.bSpyDroneActive)
		lastDroneTime = Level.TimeSeconds;

	Player.bSpyDroneActive = False;
    Player.ConfigBigDroneView(false);
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
     chargeTime=30.000000
     mpAugValue=100.000000
     mpEnergyDrain=20.000000
     lastDroneTime=-30.000000
     EnergyRate=30.000000
     EMPDrain=20
     Icon=Texture'DeusExUI.UserInterface.AugIconDrone'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDrone_Small'
     AugmentationName="Spy Drone"
     Description="Advanced nanofactories can assemble a spy drone upon demand which can then be remotely controlled by the agent until released or destroyed, at which a point a new drone will be assembled. Further upgrades equip the spy drones with better armor and a one-shot EMP attack.|n|nTECH ONE: The drone can take little damage and has a very light EMP attack.|n|nTECH TWO: The drone can take minor damage and has a light EMP attack.|n|nTECH THREE: The drone can take moderate damage and has a medium EMP attack.|n|nTECH FOUR: The drone can take heavy damage and has a strong EMP attack."
     MPInfo="Activation creates a remote-controlled spy drone.  Deactivation disables the drone.  Firing while active detonates the drone in a massive EMP explosion.  Energy Drain: Medium"
     ReconstructionMessage="Reconstruction will be complete in %i seconds"
     GroundedMessage="You must be grounded to construct the drone"
     LevelValues(0)=10.000000
     LevelValues(1)=20.000000
     LevelValues(2)=35.000000
     LevelValues(3)=50.000000
     MPConflictSlot=7
}
