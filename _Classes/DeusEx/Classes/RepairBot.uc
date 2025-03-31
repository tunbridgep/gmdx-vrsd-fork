//=============================================================================
// RepairBot.
//=============================================================================
class RepairBot extends Robot;

var int chargeAmount;
var int chargeRefreshTime;
var int mpChargeRefreshTime;
var int mpChargeAmount;
var Float lastchargeTime;
var int chargeMaxTimes;
var int lowerThreshold;                                                         //RSD: Added

// ----------------------------------------------------------------------
// Network replication
// ----------------------------------------------------------------------
replication
{
	// MBCODE: Replicate the last time charged to the server
   // DEUS_EX AMSD Changed to replicate to client.
	reliable if ( Role == ROLE_Authority )
		lastchargeTime, chargeRefreshTime;

}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	Super.PostBeginPlay();

   if (Level.NetMode != NM_Standalone)
   {
      chargeRefreshTime = mpChargeRefreshTime;
      chargeAmount = mpChargeAmount;
   }

   if (IsImmobile())
      bAlwaysRelevant = True;

   lastChargeTime = -chargeRefreshTime;
}

// ----------------------------------------------------------------------
// StandStill()
// ----------------------------------------------------------------------

function StandStill()
{
    local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());

   if (player != none && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkMisfeatureExploit').bPerkObtained == true)
   chargeAmount = 90;

    if (player != none && player.CombatDifficulty >= 3.0)                       //RSD: Realistic/Hardcore get 2 charges max
        lowerThreshold = 1;
    else                                                                        //RSD: Medium/Hard get 3 charges max
        lowerThreshold = 0;

	GotoState('Idle', 'Idle');
	Acceleration=Vect(0, 0, 0);
}

// ----------------------------------------------------------------------
// Frob()
//
// Invoke the Augmentation Upgrade
// ----------------------------------------------------------------------
function Frob(Actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

   if (DeusExPlayer(Frobber) == None)
      return;

   // DEUS_EX AMSD  In multiplayer, don't pop up the window, just use them
   // In singleplayer, do the old thing.
   if (Level.NetMode == NM_Standalone)
   {
      ActivateRepairBotScreens(DeusExPlayer(Frobber));
   }
   else
   {
      if (CanCharge())
      {
			PlaySound(sound'PlasmaRifleReload', SLOT_None,,, 256);
         ChargePlayer(DeusExPlayer(Frobber));
         Pawn(Frobber).ClientMessage("Received Recharge");
      }
      else
      {
         if(chargeMaxTimes>lowerThreshold)                                      //RSD: 0 changed to lowerThreshold
         Pawn(Frobber).ClientMessage("Repairbot still charging, "$int(chargeRefreshTime - (Level.TimeSeconds - lastChargetime))$" seconds to go.");
            else
            Pawn(Frobber).ClientMessage("Repairbot charge depleted");

      }
   }
}

// ----------------------------------------------------------------------
// ActivateRepairBotScreens()
// ----------------------------------------------------------------------

simulated function ActivateRepairBotScreens(DeusExPlayer PlayerToDisplay)
{
	local DeusExRootWindow root;
	local HUDRechargeWindow winCharge;

   root = DeusExRootWindow(PlayerToDisplay.rootWindow);
   if (root != None)
   {
      winCharge = HUDRechargeWindow(root.InvokeUIScreen(Class'HUDRechargeWindow', True));
      root.MaskBackground( True );
      winCharge.SetRepairBot( Self );
   }
}

// ----------------------------------------------------------------------
// ChargePlayer()
// DEUS_EX AMSD Moved back over here
// ----------------------------------------------------------------------
function int ChargePlayer(DeusExPlayer PlayerToCharge)
{
	local int chargedPoints;

	if ( CanCharge() )
	{
	    if (playerToCharge.CombatDifficulty > 1.0)                              //RSD: Changed from 2.5 to 1.0, now affects Medium and Hard as well as Realistic/Hardcore
	        chargeMaxTimes--;
		chargedPoints = PlayerToCharge.ChargePlayer( chargeAmount );
		lastChargeTime = Level.TimeSeconds;
	}
   return chargedPoints;
}

// ----------------------------------------------------------------------
// CanCharge()
//
// Returns whether or not the bot can charge the player
// ----------------------------------------------------------------------

simulated function bool CanCharge()
{
	return (( (Level.TimeSeconds - int(lastChargeTime)) > chargeRefreshTime)&&(chargeMaxTimes>lowerThreshold)); //RSD: 0 changed to lowerThreshold
}

// ----------------------------------------------------------------------
// GetRefreshTimeRemaining()
// ----------------------------------------------------------------------

simulated function Float GetRefreshTimeRemaining()
{
	return chargeRefreshTime - (Level.TimeSeconds - lastChargeTime);
}

// ----------------------------------------------------------------------
// GetAvailableCharge()
// ----------------------------------------------------------------------

simulated function Int GetAvailableCharge()
{
	if (CanCharge())
		return chargeAmount;
	else
		return 0;
}

function ChargeEquipment(ChargedPickup EquipToCharge, DeusExPlayer EquipOwner) //RSD: Can now recharge wearable equipment
{
	if ( CanCharge() )
	{
	    if (EquipOwner.CombatDifficulty > 1.0)                                  //RSD: Changed from 2.5 to 1.0, now affects Medium and Hard as well as Realistic/Hardcore
	        chargeMaxTimes--;
        if (EquipOwner != none && EquipOwner.PerkManager.GetPerkWithClass(class'DeusEx.PerkMisfeatureExploit').bPerkObtained == true)           //RSD: Misfeature Exploit perk
            EquipToCharge.Charge += 4.5*EquipToCharge.default.Charge*EquipToCharge.default.chargeMult;
        else
            EquipToCharge.Charge += 3*EquipToCharge.default.Charge*EquipToCharge.default.chargeMult;
		if (EquipToCharge.Charge > EquipToCharge.default.Charge)
		    EquipToCharge.Charge = EquipToCharge.default.Charge;

        EquipToCharge.bDrained=false;                                           //SARGE: Since you can now equip empty equipment.
        EquipToCharge.bActivatable=true;                                        //RSD: Since you can now hold one at 0%
        EquipToCharge.unDimIcon();                                              //RSD
		lastChargeTime = Level.TimeSeconds;
	}
}

// ----------------------------------------------------------------------

defaultproperties
{
     chargeAmount=60
     chargeRefreshTime=30
     mpChargeRefreshTime=30
     mpChargeAmount=100
     chargeMaxTimes=3
     GroundSpeed=100.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=100.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawType=DT_Mesh
     HDTPMesh="HDTPCharacters.HDTPRepairBot"
     Mesh=LodMesh'DeusExCharacters.RepairBot'
     SoundRadius=16
     SoundVolume=128
     AmbientSound=Sound'DeusExSounds.Robot.RepairBotMove'
     CollisionRadius=34.000000
     CollisionHeight=47.470001
     Mass=150.000000
     Buoyancy=97.000000
     BindName="RepairBot"
     FamiliarName="Repair Bot"
     UnfamiliarName="Repair Bot"
}
