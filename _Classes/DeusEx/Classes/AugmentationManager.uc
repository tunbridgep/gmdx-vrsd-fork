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

var travel int heartOverflow;

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
// Setup()
// Called at the start of every game restart, map change, etc.
// Calls Setup on every augmentation
// ----------------------------------------------------------------------

function Setup()
{
    local Augmentation aug;
    aug = FirstAug;

    while (aug != None)
    {
        aug.Setup();
        if (aug.bIsActive)
            aug.GotoState('Active');
        aug = aug.next;
    }
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
		// First make sure the aug is active if need be                         //RSD: Combined only necessary reworks from Lorenz's version
		if (anAug.CanBeActivated())
		{
			if ((player.bHUDShowAllAugs) || (anAug.bIsActive))
			{
                 player.AddAugmentationDisplay(anAug);
			}
            player.RadialMenuAddAug(anAug);
		}

		anAug = anAug.next;
	}
}

// ----------------------------------------------------------------------
// AddToWheel()
//
// SARGE: Add an augmentation to the wheel, conditionally.
// ----------------------------------------------------------------------

function AddToWheel(Augmentation anAug)
{
    //If auto-add is turned off, don't add it
    if (player.iAugWheelAutoAdd == 0)
        return;

    //If auto add is turned on for active only, and it's not active, don't add it
    if (player.iAugWheelAutoAdd == 1 && anAug.AugmentationType != Aug_Active)
        return;

    anAug.bAddedToWheel = true;
}

// ----------------------------------------------------------------------
// NumAugsActive()
//
// How many augs are currently active?
// ----------------------------------------------------------------------

simulated function int NumAugsActive(optional bool countEverything)
{
	local Augmentation anAug;
	local int count;

	if (player == None)
		return 0;

	count = 0;
	anAug = FirstAug;
	while(anAug != None)
	{
        //SARGE: Don't count the spy drone as active if it's set, unless we're counting everything
        if (anAug.IsA('AugDrone') && player.bSpyDroneSet && !countEverything)
        { /*do nothing*/ }
		else if (anAug.bHasIt && anAug.bIsActive && anAug.CanBeActivated() && (!anAug.IsToggleAug() || countEverything))
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
		if (anAug != augBoosting && anAug.CanBeActivated())
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

    //SARGE: TODO: Fix this for Toggle augs
	if ((player != None))
	{
		anAug = FirstAug;
		while(anAug != None)
		{
         if ( (Level.NetMode == NM_Standalone) || (!anAug.IsA('AugLight')) )
            ActivateAug(anAug,true);
			anAug = anAug.next;
		}
	}
}

// ----------------------------------------------------------------------
// DeactivateAll()
//
// Loops through all the Augmentations, deactivating any that are active.
// ActiveOnly only activates AugmentationType "Active" augs, leaves Toggle augmentations active.
// ----------------------------------------------------------------------

function DeactivateAll(optional bool forced)
{
	local Augmentation anAug;

    /*
    if (Player.bSpyDroneSet && forced)
    {
    	Player.SAVErotation = Player.ViewRotation;
        Player.bSpyDroneSet = false;                                            //RSD: Ensures that the Spy Drone will ACTUALLY be turned off
    }
    */

	anAug = FirstAug;
	while(anAug != None)
	{
        //SARGE: If we have a spy drone out, just put it on standby mode instead.
        if (anAug.IsA('AugDrone'))
            AugDrone(anAug).ToggleStandbyMode(true);
		else if (anAug.bIsActive && anAug.CanBeActivated() && (!anAug.IsToggleAug() || forced))
        {
            anAug.Deactivate();
        }
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
// RemoveAugmentation()
// SARGE: Takes an augmentation away from the player
// used for respeccing
// ----------------------------------------------------------------------

function bool RemoveAugmentation(Class<Augmentation> takeClass)
{
	local Augmentation anAug, allTheAugs;

	// Checks to see if the player already has it.  If so, we want to
	// increase the level
	anAug = FindAugmentation(takeClass);

	if (anAug == None || !anAug.bHasIt)
		return false;		// shouldn't happen, but you never know!

    if (anAug.bIsActive)
        anAug.Deactivate();

    anAug.bHasIt = false;
    anAug.CurrentLevel = anAug.default.CurrentLevel;
    anAug.bAddedToWheel = false;

    //If removing HeartLung, downgrade everything
    if (anAug.IsA('AugHeartLung'))
    {
        ForEach Player.AllActors(class'Augmentation',allTheAugs)
        {
            if (allTheAugs.bHasIt && allTheAugs.CurrentLevel != 0 && allTheAugs.heartUpgraded > 0)
            {
                allTheAugs.CurrentLevel -= allTheAugs.heartUpgraded;
                allTheAugs.heartUpgraded = 0;;
                allTheAugs.Setup();
            }
        }
    }

	// Manage our AugLocs[] array
	AugLocs[anAug.AugmentationLocation].augCount--;

    Player.RemoveAugmentationDisplay(anAug);
    Player.RadialMenuUpdateAug(anAug);

    return true;
}

// ----------------------------------------------------------------------
// AssignOverflow()
// SARGE: Assigns a specific priority list for heart augmentation overflow
// Focuses exclusively on augs that are at or below the max level
// ----------------------------------------------------------------------

function AssignOverflowTo(class<Augmentation> augClass, int maxLevel)
{
    local Augmentation aug;

    if (heartOverflow <= 0)
        return;

    aug = GetAug(augClass);

    if (aug != None && aug.bHasIt && aug.CurrentLevel < aug.MaxLevel && aug.CurrentLevel <= maxLevel)
    {
        //player.clientMessage("Overflow to " $ aug.GetName() $ ": " $ heartOverflow);
        heartOverflow--;
        aug.CurrentLevel++;
        aug.heartUpgraded++;
        aug.Setup();
    }
}

function AssignOverflow()
{
    local int level;

    level = 1;

    while (level <= 4 && heartOverflow > 0)
    {
        //Chest first
        AssignOverflowTo(class'AugShield',level);
        AssignOverflowTo(class'AugEMP',level);
        AssignOverflowTo(class'AugAqualung',level);
        AssignOverflowTo(class'AugEnviro',level);
        AssignOverflowTo(class'AugHealing',level);
        AssignOverflowTo(class'AugPower',level);
        
        //Then Head
        AssignOverflowTo(class'AugDefense',level);
        AssignOverflowTo(class'AugDrone',level);
        
        //Then Eyes
        AssignOverflowTo(class'AugVision',level);
        AssignOverflowTo(class'AugTarget',level);
        AssignOverflowTo(class'AugAutoaim',level);
        
        //Then Subdermal
        AssignOverflowTo(class'AugCloak',level);
        AssignOverflowTo(class'AugRadarTrans',level);
        AssignOverflowTo(class'AugBallisticPassive',level);
        AssignOverflowTo(class'AugBallistic',level);
        
        //Then Arms
        AssignOverflowTo(class'AugAmmoCap',level);
        AssignOverflowTo(class'AugCombatStrength',level);
        AssignOverflowTo(class'AugCombat',level);
        AssignOverflowTo(class'AugMuscle',level);

        //Then Legs
        AssignOverflowTo(class'AugSpeed',level);
        AssignOverflowTo(class'AugStealth',level);
        AssignOverflowTo(class'AugIcarus',level);
        
        //Then Default
        AssignOverflowTo(class'AugIFF',level);
        AssignOverflowTo(class'AugLight',level);

        level++;
    }
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

    //Add it to the aug wheel permanently, depending on settings.
    AddToWheel(anAug);

    if (anAug.IsA('AugHeartLung')) //CyberP: AugHeartLung upgrades all passive augs. //RSD: Active too now, taken from HUDMedBotAddAugsScreen.uc for less specialized code architecture
    {
        heartOverflow = 0;
        //SARGE: Now we try to assign 11 augs worth (1 for each slot), and bubble over any overflow.
        ForEach Player.AllActors(class'Augmentation',allTheAugs)
        {
            //Find any augs that are fully upgraded, which means we're wasting the aug upgrade.
            if (allTheAugs.bHasIt && allTheAugs.CurrentLevel == allTheAugs.MaxLevel && allTheAugs.CurrentLevel > 0)
            {
                heartOverflow++;
                player.clientMessage("Overflow from " $ allTheAugs.GetName() $ ": " $ heartOverflow);
            }

            else if (allTheAugs.bHasIt && allTheAugs.CurrentLevel != allTheAugs.MaxLevel)
            {
                allTheAugs.CurrentLevel++;
                allTheAugs.heartUpgraded++;
                allTheAugs.Setup();
            }
        }
        AssignOverflow();
    }

	anAug.bHasIt = True;

	if (anAug.AugmentationType == Aug_Passive)
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
    {
        anAug.CurrentLevel++;
        anAug.heartUpgraded++;
    }

	if ( Player.Level.Netmode == NM_Standalone )
		Player.ClientMessage(Sprintf(anAug.AugNowHaveAtLevel, anAug.GetName(), anAug.CurrentLevel + 1));

	// Manage our AugLocs[] array
	AugLocs[anAug.AugmentationLocation].augCount++;

	// Assign hot key to new aug
	// (must be after before augCount is incremented!)
   if (anAug.CanBeActivated())
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
	if ((anAug.CanBeActivated()) && (Player.bHUDShowAllAugs))
	    Player.AddAugmentationDisplay(anAug);
    if (anAug.CanBeActivated())                                                   //RSD: Otherwise we get passive augs showing up in the radial menu
        player.RadialMenuAddAug(anAug);

    anAug.Setup();
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
// SARGE: Energy Drain Rate is now calculated per augmentation, so we can display it in the HUD
// As a result, this function is now MUCH simpler.
// ----------------------------------------------------------------------

simulated function Float CalcEnergyUse(float deltaTime)
{
	local float energyUse;
	local Augmentation anAug;

	energyUse = 0;

	anAug = FirstAug;
	while(anAug != None)
	{
        if (anAug.bHasIt && anAug.bIsActive && anAug.CanDrainEnergy())
            energyUse += ((anAug.GetAdjustedEnergyRate()/60) * deltaTime);
		anAug = anAug.next;
	}

	return energyUse;
}

// ----------------------------------------------------------------------
// CalcEnergyReserve()
//
// Calculates total reserve energy all active augmentations
// ----------------------------------------------------------------------

simulated function Float CalcEnergyReserve()
{
	local Augmentation anAug;
	local float reserve;

	reserve = 0;

	anAug = FirstAug;
	while(anAug != None)
	{
        if (anAug.bHasIt && anAug.bIsActive)
            reserve += ((anAug.GetAdjustedEnergyReserve()));
		anAug = anAug.next;
	}

	return reserve;
}

//Sarge: TODO: Fix this to work generically
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
        {
			anAug.CurrentLevel = anAug.MaxLevel;
            anAug.Setup();
        }

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
        ActivateAug(anAug,!anAug.bIsActive);
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

//Attempts to activate an augmentation
function ActivateAug(Augmentation aug, bool active)
{
    aug.ActivateKeyPressed();
    if (active && !aug.bIsActive)
        aug.Activate();
    else if (!active && aug.bIsActive)
        aug.Deactivate();
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
