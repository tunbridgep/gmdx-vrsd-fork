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

var localized string msgCharging;
var localized string msgDepleted;

var int chargeRefreshTimeShort; //SARGE: Have a much shorter charge time if we have charges.

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

    if (player != none && player.bHardCoreMode)                                 //SARGE: Hardcore gets 1 charge
        lowerThreshold = 2;
    else if (player != none && player.CombatDifficulty >= 3.0)                  //RSD: Realistic/Hardcore get 2 charges max
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
   if (Level.NetMode == NM_Standalone && (HasChargesRemaining() || !class'DeusExPlayer'.default.bStreamlinedRepairBotInterface))
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
         if(HasChargesRemaining())                                      //RSD: 0 changed to lowerThreshold
            Pawn(Frobber).ClientMessage(sprintf(msgCharging, int(chargeRefreshTime - (Level.TimeSeconds - lastChargetime))));
        else
            Pawn(Frobber).ClientMessage(msgDepleted);

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
      //SARGE: Shorten charge time if we're on higher difficulties, since we have limited charges to stop abuse already.
      if (playerToDisplay.CombatDifficulty > 1.0)
          chargeRefreshTime = chargeRefreshTimeShort;
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
        PlayerToCharge.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);
		lastChargeTime = Level.TimeSeconds;
	}
   return chargedPoints;
}

// ----------------------------------------------------------------------
// CanCharge()
//
// Returns whether or not the bot can charge the player
// ----------------------------------------------------------------------

function bool HasChargesRemaining()
{
    return chargeMaxTimes > lowerThreshold;
}

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

        EquipOwner.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);
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
     chargeRefreshTimeShort=15
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
     msgCharging="Recharging... %d seconds remaining"
     msgDepleted="Charges depleted"
}
