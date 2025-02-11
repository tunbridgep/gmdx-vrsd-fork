//=============================================================================
// AugDrone.
//=============================================================================
class AugDrone extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

var float lastDroneTime;

var int EMPDrain;                                                               //SARGE: energy used for EMP attack

var bool bDestroyNow;                                                           //SARGE: If set, deactivating on zero energy will destroy the drone, rather than putting it on standby

var const localized string ReconstructionMessage;
var const localized string GroundedMessage;
var const localized string GroundedMessage2;
var const localized string BlockedMessage;

function string GetChargingMessage()
{
    return Sprintf(ReconstructionMessage, int(currentChargeTime));
}

function bool CanActivate(out string message)
{
    local Vector loc;

    if (player.Physics == PHYS_Falling || player.physics == PHYS_Swimming)
    {
        message = GroundedMessage;
        return false;
    }

    //Check for any other problem first, since we only
    //want to check the drone position if we actually have
    //a valid reason to create one in the first place;
    if (!Super.CanActivate(message))
        return false;

    //Code copied from CreateDrone() in DeusExPlayer.uc.
    //We need to check that we can actually make the drone, otherwise we will fuck everything up
    loc = (2.0 + class'SpyDrone'.Default.CollisionRadius + player.CollisionRadius) * Vector(player.ViewRotation);
    loc.Z = player.BaseEyeHeight;
    loc += player.Location;

    //SARGE: Check we actually have room for the drone, otherwise we get into a horrible state
    if (!player.FastTrace(loc))
    {
        message = BlockedMessage;
        return false;
    }

    return true;
}

function ToggleStandbyMode(bool standby)
{
    if (standby)
    {
        if (player.aDrone != None)
            player.aDrone.Velocity = vect(0.,0.,0.);
        Player.bSpyDroneSet = True;                                            //RSD: Allows the user to toggle between moving and controlling the drone
        Player.DRONESAVErotation = player.ViewRotation;
        if (!Player.RestrictInput())
        {
            Player.ViewRotation = player.SAVErotation;
            Player.ConfigBigDroneView(false);
            Player.UpdateHUD();
        }
    }
    else
    {
        player.SAVErotation = player.ViewRotation;
        Player.bSpyDroneActive = True;
        Player.bSpyDroneSet = False;                                            //RSD: Allows the user to toggle between moving and controlling the drone
        Player.spyDroneLevel = CurrentLevel;
        Player.spyDroneLevelValue = LevelValues[CurrentLevel];
        Player.ViewRotation = player.DRONESAVErotation;
        Player.ConfigBigDroneView(true);
        Player.UpdateHUD();
    }
}

state Active
{

function Timer()
{
    if (IsInState('Active'))
    {
        ToggleStandbyMode(false);
    }
}
Begin:
    player.bSpyDroneActive = True;
    player.bSpyDroneSet = False;
    player.SAVErotation = player.ViewRotation;                                  //RSD: Set the SAVErotation the first time we activate
    player.DRONESAVErotation = player.ViewRotation;                             //RSD: Set the DRONESAVErotation the first time we activate
    SetTimer(0.4,False);
}

function ActivateKeyPressed()
{
    //Blow up if we activate it on zero energy
    if (player.Energy == 0 && bActive && player.aDrone != None)
    {
        bDestroyNow = true;
        Deactivate();
        bDestroyNow = false;
    }
}

function Deactivate()
{
    //If we were shut off due to energy, go into standby instead
    if (player.Energy == 0 && !bDestroyNow)
    {
        ToggleStandbyMode(true);
        return;
    }

	if (Player.bSpyDroneSet && player.Energy > 0)                                                    //RSD: Allows the user to toggle between moving and controlling the drone
	{
		if (IsA('AugDrone') && (player.Physics == PHYS_Falling || player.physics == PHYS_Swimming))
        {
            player.ClientMessage(GroundedMessage2);
            return;
        }

        ToggleStandbyMode(false);
        return;
	}

    Super.Deactivate();

	// record the time if we were just active
    if (Player.bSpyDroneActive)
        lastDroneTime = Level.TimeSeconds;

    ToggleStandbyMode(true);
    Player.bSpyDroneSet = False;
    Player.ForceDroneOff(true);
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
     GroundedMessage2="You must be grounded to resume control of the drone"
     BlockedMessage="Insufficient space to release drone"
     LevelValues(0)=10.000000
     LevelValues(1)=20.000000
     LevelValues(2)=35.000000
     LevelValues(3)=50.000000
     MPConflictSlot=7
}
