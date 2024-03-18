//=============================================================================
// MedicalBot.
//=============================================================================
class MedicalBot extends Robot;

var int healAmount;
var int healRefreshTime;
var int mphealRefreshTime;
var Float lastHealTime;
var int healMaxTimes;
var int lowerThreshold;                                                         //RSD: Added

// ----------------------------------------------------------------------
// Network replication
// ----------------------------------------------------------------------
replication
{
	// MBCODE: Replicate the last time healed to the server
	reliable if ( Role < ROLE_Authority )
		lastHealTime, healRefreshTime;
}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	Super.PostBeginPlay();

   if (Level.NetMode != NM_Standalone)
   {
      healRefreshTime = mpHealRefreshTime;
   }

   if (IsImmobile())
      bAlwaysRelevant = True;

	lastHealTime = -healRefreshTime;
}

// ----------------------------------------------------------------------
// StandStill()
// ----------------------------------------------------------------------

function StandStill()
{
	local DeusExPlayer player;                                                  //RSD: Added

    player = DeusExPlayer(GetPlayerPawn());                                     //RSD

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
   local DeusExPlayer player;
	local DeusExRootWindow root;
	local HUDMedBotAddAugsScreen winAug;
	local HUDMedBotHealthScreen  winHealth;
	local AugmentationCannister augCan;

   Super.Frob(Frobber, frobWith);

   player = DeusExPlayer(Frobber);

   if (player == None)
      return;

   if (player.PerkNamesArray[21]==1)
      healAmount = 375;                                                         //RSD: Was 450

   // DEUS_EX AMSD  In multiplayer, don't pop up the window, just use them
   // In singleplayer, do the old thing.
   if (Level.NetMode == NM_Standalone)
   {
      root = DeusExRootWindow(player.rootWindow);
      if (root != None)
      {
         // First check to see if the player has any augmentation cannisters.
         // If so, then we'll pull up the Add Augmentations screen.
         // Otherwise pull up the Health screen first.

         augCan = AugmentationCannister(player.FindInventoryType(Class'AugmentationCannister'));

         if (augCan != None)
         {
            winAug = HUDMedBotAddAugsScreen(root.InvokeUIScreen(Class'HUDMedBotAddAugsScreen', True));
            winAug.SetMedicalBot(Self, True);
         }
         else
         {
            winHealth = HUDMedBotHealthScreen(root.InvokeUIScreen(Class'HUDMedBotHealthScreen', True));
            winHealth.SetMedicalBot(Self, True);
         }
         root.MaskBackground(True);
      }
   }
   else
   {
      if (CanHeal())
      {
			if ( Level.NetMode != NM_Standalone )
			{
				PlaySound(sound'MedicalHiss', SLOT_None,,, 256);
				if ( Frobber.IsA('DeusExPlayer') )
				{
					DeusExPlayer(Frobber).StopPoison();
					DeusExPlayer(Frobber).ExtinguishFire();
					DeusExPlayer(Frobber).drugEffectTimer = 0;
				}
			}
         HealPlayer(DeusExPlayer(Frobber));
      }
      else
      {
         if(healMaxTimes<=lowerThreshold)                                       //RSD: ==0 changed to <=lowerThreshold
            Pawn(Frobber).ClientMessage("Medbot power exhausted");
            else
               Pawn(Frobber).ClientMessage("Medbot still charging, "$int(healRefreshTime - (Level.TimeSeconds - lastHealTime))$" seconds to go.");
      }
   }
}

// ----------------------------------------------------------------------
// HealPlayer()
// ----------------------------------------------------------------------

function int HealPlayer(DeusExPlayer player)
{
	local int healedPoints;

	if (player != None)
	{
	    if (player.CombatDifficulty > 1.0)                                      //RSD: Changed from 2.5 to 1.0, now affects Medium and Hard as well as Realistic/Hardcore
	  	    healMaxTimes--;
		healedPoints = player.HealPlayer(healAmount);
		lastHealTime = Level.TimeSeconds;
	}
	return healedPoints;
}

// ----------------------------------------------------------------------
// CanHeal()
//
// Returns whether or not the bot can heal the player
// ----------------------------------------------------------------------

function bool CanHeal()
{
	return ((Level.TimeSeconds - lastHealTime > healRefreshTime)&&(healMaxTimes>lowerThreshold)); //RSD: 0 changed to lowerThreshold
}

// ----------------------------------------------------------------------
// GetRefreshTimeRemaining()
// ----------------------------------------------------------------------

function Float GetRefreshTimeRemaining()
{
	return healRefreshTime - (Level.TimeSeconds - lastHealTime);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     healAmount=250
     healRefreshTime=60
     mphealRefreshTime=30
     healMaxTimes=3
     WalkingSpeed=0.200000
     GroundSpeed=200.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawType=DT_Mesh
     Mesh=LodMesh'HDTPCharacters.HDTPMedicalBot'
     SoundRadius=16
     SoundVolume=128
     AmbientSound=Sound'DeusExSounds.Robot.MedicalBotMove'
     CollisionRadius=25.000000
     CollisionHeight=36.310001
     Buoyancy=97.000000
     BindName="MedicalBot"
     FamiliarName="Medical Bot"
     UnfamiliarName="Medical Bot"
}
