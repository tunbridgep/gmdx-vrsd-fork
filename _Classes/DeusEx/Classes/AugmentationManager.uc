//=============================================================================
// AugmentationManager
//=============================================================================
class AugmentationManager extends Actor
	intrinsic;

struct S_AugInfo
{
	var int NumSlots;
	var int AugCount;
	var int KeyBase;
};

var travel S_AugInfo AugLocs[7];
var DeusExPlayer Player;				// which player am I attached to?
var travel Augmentation FirstAug;		// Pointer to first Augmentation

// All the available augmentations
var Class<Augmentation> augClasses[25];
var Class<Augmentation> defaultAugs[3];

var localized string AugLocationFull;
var localized String NoAugInSlot;
var Augmentation augie;
// ----------------------------------------------------------------------
// Network Replication
// ----------------------------------------------------------------------

replication
{

    //variables server to client
	reliable if ((Role == ROLE_Authority) && (bNetOwner))
	    AugLocs, FirstAug, Player;

	//functions client to server
	reliable if (Role < ROLE_Authority)
	    ActivateAugByKey, AddAllAugs, SetAllAugsToMaxLevel, ActivateAll, DeactivateAll, GivePlayerAugmentation;

}


// ----------------------------------------------------------------------
// CreateAugmentations()
// ----------------------------------------------------------------------

function CreateAugmentations(DeusExPlayer newPlayer)
{
	local int augIndex;
	local Augmentation anAug;
	local Augmentation lastAug;

	FirstAug = None;
	LastAug  = None;

	player = newPlayer;

	for(augIndex=0; augIndex<arrayCount(augClasses); augIndex++)
	{
		if (augClasses[augIndex] != None)
		{
			anAug = Spawn(augClasses[augIndex], Self);
			anAug.Player = player;

			// Manage our linked list
			if (anAug != None)
			{
				if (FirstAug == None)
				{
					FirstAug = anAug;
				}
				else
				{
					LastAug.next = anAug;
				}

				LastAug  = anAug;
			}
		}
	}

}

// ----------------------------------------------------------------------
// AddDefaultAugmentations()
// ----------------------------------------------------------------------

function AddDefaultAugmentations()
{
	local int augIndex;

	for(augIndex=0; augIndex<arrayCount(defaultAugs); augIndex++)
	{
		if (defaultAugs[augIndex] != None)
			GivePlayerAugmentation(defaultAugs[augIndex]);
	}
}

// ----------------------------------------------------------------------
// RefreshAugDisplay()
//
// Refreshes the Augmentation display with all the augs that are
// currently active.
// ----------------------------------------------------------------------

simulated function RefreshAugDisplay()
{
	local Augmentation anAug;

	if (player == None)
		return;

	// First make sure there are no augs visible in the HUD
	player.ClearAugmentationDisplay();
    player.RadialMenuClear();

	anAug = FirstAug;
	while(anAug != None)
	{
		/*// First make sure the aug is active if need be                       //RSD: Original code
		if (anAug.bHasIt)
		{
			if (anAug.bIsActive)
			{
				anAug.GotoState('Active');

				// Now, if this is an aug that isn't *always* active, then
				// make sure it's in the augmentation display

				if (!anAug.bAlwaysActive)
					player.AddAugmentationDisplay(anAug);
			}
			else if ((player.bHUDShowAllAugs) && (!anAug.bAlwaysActive))
			{
                 player.AddAugmentationDisplay(anAug);
			}
		}*/

        /*if (anAug.bHasIt && !anAug.bAlwaysActive) {                           //RSD: Lorenz's modification (Sorry, we're keeping the old unsanitary system)
		    // Only show augs which can be switched on/off

    	    if (anAug.bIsActive && anAug.IsInState('Inactive')) {
    	       // This is bad design (ION Storm, this goes to you!): Even if
        	    // bIsActive==True the aug is not necessarily in the state 'Active'
        	    // (e.g. after a level transition).
        	    // So make sure it is.
        	    anAug.Activate();
                //anAug.GotoState('Active');
                //player.AmbientSound = anAug.LoopSound;
            }

			if (player.bHUDShowAllAugs || anAug.bIsActive) {
			    // player wants to see all available augs even when inactive.
			    // Otherwise show only active augs.
				player.AddAugmentationDisplay(anAug);
			}*/

		// First make sure the aug is active if need be                         //RSD: Combined only necessary reworks from Lorenz's version
		if (anAug.bHasIt && !anAug.bAlwaysActive)
		{
			if (anAug.bIsActive)
			{
				anAug.GotoState('Active');

				// Now, if this is an aug that isn't *always* active, then
				// make sure it's in the augmentation display
			}
			if ((player.bHUDShowAllAugs) || (anAug.bIsActive))
			{
                 player.AddAugmentationDisplay(anAug);
			}
			if (!anAug.bAutomatic && !anAug.IsA('AugPower'))
			     player.RadialMenuAddAug(anAug);
		}

		anAug = anAug.next;
	}
}

// ----------------------------------------------------------------------
// NumAugsActive()
//
// How many augs are currently active?
// ----------------------------------------------------------------------

simulated function int NumAugsActive()
{
	local Augmentation anAug;
	local int count;

	if (player == None)
		return 0;

	count = 0;
	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.bHasIt && anAug.bIsActive && !anAug.bAlwaysActive)
			count++;

		anAug = anAug.next;
	}

	return count;
}

// ----------------------------------------------------------------------
// SetPlayer()
// ---------------------------------------------------------------------

function SetPlayer(DeusExPlayer newPlayer)
{
	local Augmentation anAug;

	player = newPlayer;

	anAug = FirstAug;
	while(anAug != None)
	{
		anAug.player = player;
		anAug = anAug.next;
	}
}

// ----------------------------------------------------------------------
// BoostAugs()
// ----------------------------------------------------------------------

function BoostAugs(bool bBoostEnabled, Augmentation augBoosting)
{
	local Augmentation anAug;

	anAug = FirstAug;
	while(anAug != None)
	{
		// Don't boost the augmentation causing the boosting! //CyberP: and don't even attempt passive augs
		if (anAug != augBoosting && anAug.bAlwaysActive == False)
		{
			if (bBoostEnabled)
			{
				if (anAug.bIsActive && !anAug.bBoosted && (anAug.CurrentLevel < anAug.MaxLevel))
				{
					anAug.Deactivate();
					anAug.CurrentLevel++;
					anAug.bBoosted = True;
					anAug.Activate();
				}
			}
			else if (anAug.bBoosted)
			{
				anAug.CurrentLevel--;
				anAug.bBoosted = False;
			}
		}
		anAug = anAug.next;
	}

}

// ----------------------------------------------------------------------
// GetClassLevel()
// this returns the level, but only if the augmentation is
// currently turned on
// ----------------------------------------------------------------------

simulated function int GetClassLevel(class<Augmentation> augClass)
{
	local Augmentation anAug;

	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.Class == augClass)
		{
			if (anAug.bHasIt && anAug.bIsActive)
				return anAug.CurrentLevel;
			else
				return -1;
		}

		anAug = anAug.next;
	}

	return -1;
}

// ----------------------------------------------------------------------
// GetAugLevelValue()
//
// takes a class instead of being called by actual augmentation
// ----------------------------------------------------------------------

simulated function float GetAugLevelValue(class<Augmentation> AugClass)
{
	local Augmentation anAug;
	local float retval;

	retval = 0;

	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.Class == augClass)
		{
			if (anAug.bHasIt && anAug.bIsActive)
				return anAug.LevelValues[anAug.CurrentLevel];
			else
				return -1.0;
		}

		anAug = anAug.next;
	}

	return -1.0;
}

// ----------------------------------------------------------------------
// ActivateAll()
//
// Loops through all the Augmentations, deactivating any that are active.
// ----------------------------------------------------------------------

function ActivateAll()
{
	local Augmentation anAug;

	// Only allow this if the player still has
	// Bioleectric Energy(tm)

	if ((player != None) && (player.Energy > 0))
	{
		anAug = FirstAug;
		while(anAug != None)
		{
         if ( (Level.NetMode == NM_Standalone) || (!anAug.IsA('AugLight')) )
            anAug.Activate();
			anAug = anAug.next;
		}
	}
}

// ----------------------------------------------------------------------
// DeactivateAll()
//
// Loops through all the Augmentations, deactivating any that are active.
// ----------------------------------------------------------------------

function DeactivateAll()
{
	local Augmentation anAug;

    if (Player.bSpyDroneSet)
    {
    	Player.SAVErotation = Player.ViewRotation;
        Player.bSpyDroneSet = false;                                            //RSD: Ensures that the Spy Drone will ACTUALLY be turned off
    }

	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.bIsActive)
			anAug.Deactivate();
		anAug = anAug.next;
	}
}

// ----------------------------------------------------------------------
// FindAugmentation()
//
// Returns the augmentation based on the class name
// ----------------------------------------------------------------------

simulated function Augmentation FindAugmentation(Class<Augmentation> findClass)
{
	local Augmentation anAug;

	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.Class == findClass)
			break;

		anAug = anAug.next;
	}

	return anAug;
}


// ----------------------------------------------------------------------
// GivePlayerAugmentation()
// ----------------------------------------------------------------------

function Augmentation GivePlayerAugmentation(Class<Augmentation> giveClass)
{
	local Augmentation anAug, augie, allTheAugs;                                //RSD: Added allTheAugs

	// Checks to see if the player already has it.  If so, we want to
	// increase the level
	anAug = FindAugmentation(giveClass);

    if (anAug != none && anAug.IsA('AugHeartLung')) //CyberP: AugHeartLung upgrades all passive augs. //RSD: Active too now, taken from HUDMedBotAddAugsScreen.uc for less specialized code architecture
       ForEach Player.AllActors(class'Augmentation',allTheAugs)
        if (allTheAugs.bHasIt && allTheAugs.CurrentLevel != allTheAugs.MaxLevel) //RSD: removed && allTheAugs.bAlwaysActive, no distinction between active or passive for synth heart anymore
          allTheAugs.CurrentLevel++;                                            //RSD: changed from +=1 to ++ for no reason

	if (anAug == None)
		return None;		// shouldn't happen, but you never know!

	if (anAug.bHasIt)
	{
		anAug.IncLevel();
		return anAug;
	}

	if (AreSlotsFull(anAug))
	{
		Player.ClientMessage(AugLocationFull);
		return anAug;
	}

	anAug.bHasIt = True;

	if (anAug.bAlwaysActive)
	{
		anAug.bIsActive = True;
		anAug.GotoState('Active');
	}
	else
	{
		anAug.bIsActive = False;
	}
    if (!anAug.IsA('AugHeartLung')                                              //RSD: If we already have Synth Heart installed, give a free upgrade
      && Player.AugmentationSystem.FindAugmentation(class'AugHeartLung').bHasIt
      && anAug.CurrentLevel != anAug.MaxLevel)
    	anAug.CurrentLevel++;

	if ( Player.Level.Netmode == NM_Standalone )
		Player.ClientMessage(Sprintf(anAug.AugNowHaveAtLevel, anAug.AugmentationName, anAug.CurrentLevel + 1));

	// Manage our AugLocs[] array
	AugLocs[anAug.AugmentationLocation].augCount++;

	// Assign hot key to new aug
	// (must be after before augCount is incremented!)
   if (!anAug.bAlwaysActive)
   {
   if (Level.NetMode == NM_Standalone && anAug.IsA('AugCombatStrength') || anAug.IsA('AugDrone') || anAug.IsA('AugDefense'))
   {
      //BroadcastMessage("begin");                                              //RSD: Shouldn't broadcast these to the player anymore
      ForEach AllActors(class'Augmentation',augie)
      {
         //BroadcastMessage(augie.AugmentationName);                            //RSD: Stop broadcasting, yikes
         if (augie.bHasIt && augie.GetHotKey() == 5)
         {
            //BroadcastMessage("found you");                                    //RSD: double yikes
            anAug.HotKeyNum = 6;
            break;
         }
      }
      if (anAug.HotKeyNum == anAug.default.HotKeyNum)
          anAug.HotKeyNum = 5;   //BroadcastMessage("default");                 //RSD: That's gonna be a triple yikes from me, dawg
   }
   else if (Level.NetMode == NM_Standalone)
      anAug.HotKeyNum = AugLocs[anAug.AugmentationLocation].augCount + AugLocs[anAug.AugmentationLocation].KeyBase;
   else
      anAug.HotKeyNum = anAug.MPConflictSlot + 2;
   }
	if ((!anAug.bAlwaysActive) && (Player.bHUDShowAllAugs))
	    Player.AddAugmentationDisplay(anAug);
    if (!anAug.bAlwaysActive)                                                   //RSD: Otherwise we get passive augs showing up in the radial menu
        Player.RadialMenuAddAug(anAug);

	return anAug;
}

// ----------------------------------------------------------------------
// AreSlotsFull()
//
// For the given Augmentation passed in, checks to see if the slots
// for this aug are already filled up.  This is used to prevent to
// prevent the player from adding more augmentations than the slots
// can accomodate.
// ----------------------------------------------------------------------

simulated function Bool AreSlotsFull(Augmentation augToCheck)
{
	local int num;
   local bool bHasMPConflict;
	local Augmentation anAug;

	// You can only have a limited number augmentations in each location,
	// so here we check to see if you already have the maximum allowed.

	num = 0;
   bHasMPConflict = false;
	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.AugmentationName != "")
			if (augToCheck != anAug)
            if (Level.Netmode == NM_Standalone)
            {
               if (augToCheck.AugmentationLocation == anAug.AugmentationLocation)
                  if (anAug.bHasIt)
                     num++;
            }
            else
            {
               if ((AnAug.MPConflictSlot == AugToCheck.MPConflictSlot) && (AugToCheck.MPConflictSlot != 0) && (AnAug.bHasIt))
               {
                  bHasMPConflict = true;
               }
            }
		anAug = anAug.next;
	}
	if (Level.NetMode == NM_Standalone)
      return (num >= AugLocs[augToCheck.AugmentationLocation].NumSlots);
   else
      return bHasMPConflict;
}

// ----------------------------------------------------------------------
// CalcEnergyUse()
//
// Calculates energy use for all active augmentations
// ----------------------------------------------------------------------

simulated function Float CalcEnergyUse(float deltaTime)
{
	local float energyUse, energyMult;
	local Augmentation anAug;
   local Augmentation PowerAug;
   local Augmentation heartylung;

	energyUse = 0;
	energyMult = 1.0;

	anAug = FirstAug;
	while(anAug != None)
	{
 	 if (anAug.IsA('AugHeartLung'))
         heartylung = anAug;
      else if (anAug.IsA('AugPower'))
         PowerAug = anAug;

        if (Player.carriedDecoration != None)  //CyberP: drain energy when carrying inhuman-heavy objects only //RSD: re-implemented
        {
             if (Player.carriedDecoration.Mass > 60 && anAug.IsA('AugMuscle') && anAug.bHasIt)
                 energyUse += ((20./60) * deltaTime);                           //RSD: Increased from 16 bpm -> 20 bpm (vanilla)
        }
        if (anAug.bHasIt && anAug.bIsActive && !anAug.bAlwaysActive)            //RSD: Added && !anAug.bAlwaysActive so passive augs can have energy rate listed but with no drain
		{
			if (!(anAug.IsA('AugDrone') && Player.bSpyDroneSet))
                 energyUse += ((anAug.GetEnergyRate()/60) * deltaTime);         //RSD: No drain for drone aug when on standby
			if (anAug.IsA('AugPower'))
         {
				energyMult = anAug.LevelValues[anAug.CurrentLevel];
         }
		}
		anAug = anAug.next;
	}

   // DEUS_EX AMSD Manage the power aug automatically in multiplayer. //cyberP: singleplayer too
   if ((PowerAug != None) && (PowerAug.bHasIt) )
   {
      /*                                                                        //RSD: Power aug is now fully passive
      //If using energy, turn on the power aug.
      if ((energyUse > 0) && (!PowerAug.bIsActive))
         ActivateAugByKey(PowerAug.HotKeyNum - 3);

      //If not using energy, turn off the power aug.
      if ((energyUse == 0) && (PowerAug.bIsActive))
         ActivateAugByKey(PowerAug.HotKeyNum - 3);

      if (PowerAug.bIsActive)*/
         energyMult = PowerAug.LevelValues[PowerAug.CurrentLevel];
   }
	// check for the power augmentation
	energyUse *= energyMult;

  if ((heartylung != None) && (heartylung.bHasIt))   //CyberP: automatic synthetic heart too
	{
	  energyUse *= heartylung.LevelValues[heartylung.CurrentLevel];
	  /*                                                                        //RSD: Synthetic Heart is now fully passive
    //If using energy, turn on the power aug.
      if ((energyUse > 0) && (!heartylung.bIsActive))
         ActivateAugByKey(heartylung.HotKeyNum - 3);

      //If not using energy, turn off the power aug.
      if ((energyUse == heartylung.GetEnergyRate()/60 * deltaTime) && (heartylung.bIsActive) && (heartylung.bBoosted == False))
         ActivateAugByKey(heartylung.HotKeyNum - 3);*/
    }
	return energyUse;
}

function AutoAugs(bool bTurnOff, bool environ)
{
local Augmentation anAug;
local AugAqualung AutoAug1;
local AugEnviro   AutoAug2;

anAug = FirstAug;
if (environ == false)
{
	while(anAug != None)
	{
 	  if (anAug.IsA('AugAqualung') && AugAqualung(anAug).bHasIt)
 	  {
          break;
      }

		anAug = anAug.next;
	}
	if (anAug != None && anAug.IsA('AugAqualung'))
	{
	    AugAqualung(anAug).AugmentationName = AugAqualung(anAug).AugmentationName2;
	    if (bTurnOff)
	    {
            if (AugAqualung(anAug).bIsActive)
                AugAqualung(anAug).Deactivate();
            else
               return;
        }
        else
        {
            if (!AugAqualung(anAug).bIsActive)
                AugAqualung(anAug).Activate();
            else
               return;
        }
	}
}
else
{
    while(anAug != None)
	{
 	  if (anAug.IsA('AugEnviro') && AugEnviro(anAug).bHasIt)
 	  {
          break;
      }
		anAug = anAug.next;
	}
	if (anAug != None && anAug.IsA('AugEnviro'))
	{
	    AugEnviro(anAug).AugmentationName = AugEnviro(anAug).AugmentationName2;
	    if (bTurnOff)
	    {
            if (AugEnviro(anAug).bIsActive)
                AugEnviro(anAug).Deactivate();
            else
               return;
        }
        else
        {
            if (player != None)
               player.enviroAutoTime = 4.0;
            if (!AugEnviro(anAug).bIsActive)
                AugEnviro(anAug).Activate();
            else
               return;
        }
	}
}
}
// ----------------------------------------------------------------------
// AddAllAugs()
// ----------------------------------------------------------------------

function AddAllAugs()
{
	local int augIndex;

	// Loop through all the augmentation classes and create
	// any augs that don't exist.  Then set them all to the
	// maximum level.

	for(augIndex=0; augIndex<arrayCount(augClasses); augIndex++)
	{
		if (augClasses[augIndex] != None)
			GivePlayerAugmentation(augClasses[augIndex]);
	}
}

// ----------------------------------------------------------------------
// SetAllAugsToMaxLevel()
// ----------------------------------------------------------------------

function SetAllAugsToMaxLevel()
{
	local Augmentation anAug;

	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.bHasIt)
			anAug.CurrentLevel = anAug.MaxLevel;

		anAug = anAug.next;
	}
}

// ----------------------------------------------------------------------
// IncreaseAllAugs()
// ----------------------------------------------------------------------

function IncreaseAllAugs(int Amount)
{
   local Augmentation anAug;

   anAug = FirstAug;
   while(anAug != None)
   {
      if (anAug.bHasIt)
         anAug.CurrentLevel = Min(anAug.CurrentLevel + Amount, anAug.MaxLevel);

      anAug = anAug.next;
   }
}

// ----------------------------------------------------------------------
// ActivateAugByKey()
// ----------------------------------------------------------------------

function bool ActivateAugByKey(int keyNum)
{
	local Augmentation anAug;
	local bool bActivated;

	bActivated = False;

	if ((keyNum < 0) || (keyNum > 9))
		return False;

	anAug = FirstAug;
	while(anAug != None)
	{
		if ((anAug.HotKeyNum - 3 == keyNum) && (anAug.bHasIt))
			break;

		anAug = anAug.next;
	}

	if (anAug == None)
	{
		player.ClientMessage(NoAugInSlot);
	}
	else
	{
		// Toggle
		if (anAug.bIsActive)
			anAug.Deactivate();
		else
			anAug.Activate();

		bActivated = True;
	}

	return bActivated;
}

// ----------------------------------------------------------------------
// ResetAugmentations()
// ----------------------------------------------------------------------

function ResetAugmentations()
{
	local Augmentation anAug;
	local Augmentation nextAug;
    local int LocIndex;

	anAug = FirstAug;
	while(anAug != None)
	{
		nextAug = anAug.next;
		anAug.Destroy();
		anAug = nextAug;
	}

	FirstAug = None;

    //Must also clear auglocs.
    for (LocIndex = 0; LocIndex < 7; LocIndex++)
    {
        AugLocs[LocIndex].AugCount = 0;
    }

}

//Returns the actual augmentation based on class
function Augmentation GetAug(class<Augmentation> AugClass, optional bool active)
{
	local Augmentation anAug;

	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.Class == augClass && anAug.bHasIt && (anAug.bIsActive||!active))
            return anAug;

		anAug = anAug.next;
	}

    return None;
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     AugLocs(0)=(NumSlots=1,KeyBase=4)
     AugLocs(1)=(NumSlots=1,KeyBase=7)
     AugLocs(2)=(NumSlots=3,KeyBase=8)
     AugLocs(3)=(NumSlots=2,KeyBase=5)
     AugLocs(4)=(NumSlots=1,KeyBase=6)
     AugLocs(5)=(NumSlots=2,KeyBase=2)
     AugLocs(6)=(NumSlots=3,KeyBase=11)
     augClasses(0)=Class'DeusEx.AugSpeed'
     augClasses(1)=Class'DeusEx.AugTarget'
     augClasses(2)=Class'DeusEx.AugCloak'
     augClasses(3)=Class'DeusEx.AugBallistic'
     augClasses(4)=Class'DeusEx.AugRadarTrans'
     augClasses(5)=Class'DeusEx.AugShield'
     augClasses(6)=Class'DeusEx.AugEnviro'
     augClasses(7)=Class'DeusEx.AugBallisticPassive'
     augClasses(8)=Class'DeusEx.AugCombat'
     augClasses(9)=Class'DeusEx.AugHealing'
     augClasses(10)=Class'DeusEx.AugStealth'
     augClasses(11)=Class'DeusEx.AugIFF'
     augClasses(12)=Class'DeusEx.AugLight'
     augClasses(13)=Class'DeusEx.AugMuscle'
     augClasses(14)=Class'DeusEx.AugVision'
     augClasses(15)=Class'DeusEx.AugDrone'
     augClasses(16)=Class'DeusEx.AugDefense'
     augClasses(17)=Class'DeusEx.AugAqualung'
     augClasses(18)=Class'DeusEx.AugDatalink'
     augClasses(19)=Class'DeusEx.AugHeartLung'
     augClasses(20)=Class'DeusEx.AugPower'
     augClasses(21)=Class'DeusEx.AugIcarus'
     augClasses(22)=Class'DeusEx.AugCombatStrength'
     augClasses(23)=Class'DeusEx.AugEnergyTransfer'
     augClasses(24)=Class'DeusEx.AugAmmoCap'
     defaultAugs(0)=Class'DeusEx.AugLight'
     defaultAugs(1)=Class'DeusEx.AugIFF'
     defaultAugs(2)=Class'DeusEx.AugDatalink'
     AugLocationFull="You can't add any more augmentations to that location!"
     NoAugInSlot="There is no augmentation in that slot"
     bHidden=True
     bTravel=True
}
