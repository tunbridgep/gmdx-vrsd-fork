//=============================================================================
// MissionScript.
//=============================================================================
class MissionScript extends Info
	transient
	abstract;

//
// State machine for each mission
// All flags set by this mission controller script should be
// prefixed with MS_ for consistency
//

var float checkTime;
var DeusExPlayer Player;
var FlagBase flags;
var string localURL;
var DeusExLevelInfo dxInfo;
var bool CanQuickSave;
var float TimeToSave;

// ----------------------------------------------------------------------
// PostPostBeginPlay()
//
// Set the timer
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{
	// start the script
	SetTimer(checkTime, True);
}

// ----------------------------------------------------------------------
// InitStateMachine()
//
// Get the player's flag base, get the map name, and set the player
// ----------------------------------------------------------------------

function InitStateMachine()
{
	local DeusExLevelInfo info;

	Player = DeusExPlayer(GetPlayerPawn());

	foreach AllActors(class'DeusExLevelInfo', info)
		dxInfo = info;

	if (Player != None)
	{
		flags = Player.FlagBase;

		// Get the mission number by extracting it from the
		// DeusExLevelInfo and then delete any expired flags.
		//
		// Also set the default mission expiration so flags
		// expire in the next mission unless explicitly set
		// differently when the flag is created.

		if (flags != None)
		{
			// Don't delete expired flags if we just loaded
			// a savegame
			if (flags.GetBool('PlayerTraveling'))
				flags.DeleteExpiredFlags(dxInfo.MissionNumber);

			flags.SetDefaultExpiration(dxInfo.MissionNumber + 1);

			localURL = Caps(dxInfo.mapName);

			log("**** InitStateMachine() -"@player@"started mission state machine for"@localURL);
		}
		else
		{
			log("**** InitStateMachine() - flagBase not set - mission state machine NOT initialized!");
		}
	}
	else
	{
		log("**** InitStateMachine() - player not set - mission state machine NOT initialized!");
	}
}

// ----------------------------------------------------------------------
// FirstFrame()
//
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
	local name flagName;
	local ScriptedPawn P;
	local int i;
	local tree tree;
	local HumanMilitary HumM;
    local bool bRandomCrates;                                                   //RSD
    local bool bRandomItems;                                                    //RSD

	flags.DeleteFlag('PlayerTraveling', FLAG_Bool);

	// Check to see which NPCs should be dead from prevous missions
	foreach AllActors(class'ScriptedPawn', P)
	{
		if (P.bImportant)
		{
			flagName = Player.rootWindow.StringToName(P.BindName$"_Dead");
			if (flags.GetBool(flagName))
				P.Destroy();
		}
	}

	// print the mission startup text only once per map
	flagName = Player.rootWindow.StringToName("M"$Caps(dxInfo.mapName)$"_StartupText");
	if (!flags.GetBool(flagName) && (dxInfo.startupMessage[0] != ""))
	{
		for (i=0; i<ArrayCount(dxInfo.startupMessage); i++)
			DeusExRootWindow(Player.rootWindow).hud.startDisplay.AddMessage(dxInfo.startupMessage[i]);
		DeusExRootWindow(Player.rootWindow).hud.startDisplay.StartMessage();
		flags.SetBool(flagName, True);
	}

    //RSD: On first map load, randomize ammo counts (also, this flag is used for GMDX difficulty settings so as to not alter health more than once)
    flagName = Player.rootWindow.StringToName("M"$Caps(dxInfo.mapName)$"_NotFirstTime");
	if (!flags.GetBool(flagName))
	{

        //Reset player Autosave timer
        //Actually, make this per mission instead, to really be punishing
        //Player.autosaveRestrictTimer = 0.0;

		//Player.BroadcastMessage("Loading this map for the first time");
		//Player.setupDifficultyMod();
		InitializeRandomAmmoCounts();
        bRandomItems = player.bRandomizeMods; //(player.bRandomizeModsHandling || player.bRandomizeModsAmmo || player.bRandomizeModsBallistics || player.bRandomizeModsAttachments);
        bRandomCrates = (bRandomItems || player.bRandomizeCrates); /*player.bRandomizeCratesGeneralTool || player.bRandomizeCratesGeneralWearable
                       || player.bRandomizeCratesGeneralPickup || player.bRandomizeCratesMedicalMain
                       || player.bRandomizeCratesAmmoPistol || player.bRandomizeCratesAmmoRifle
                       || player.bRandomizeCratesAmmoNonlethal || player.bRandomizeCratesAmmoRobot
                       || player.bRandomizeCratesAmmoHeavy || player.bRandomizeCratesAmmoExplosive);*/
        if (bRandomCrates)                                                      //RSD: Also randomize crates with user setting
			InitializeRandomCrateContents();
		if (bRandomItems)                                                       //RSD: Also randomize items (weapon mods) with user setting
			InitializeRandomItems();
		if (player.bRandomizeAugs)
			SetScrambledAugs();
		flags.SetBool(flagName, True);
	}

	flagName = Player.rootWindow.StringToName("M"$dxInfo.MissionNumber$"MissionStart");
	if (!flags.GetBool(flagName))
	{
		// Remove completed Primary goals and all Secondary goals
		Player.ResetGoals();
        
        //Reset player Autosave timer
        //Actually, make this per mission instead, to really be punishing
        Player.autosaveRestrictTimer = 0.0;

		// Remove any Conversation History.
		Player.ResetConversationHistory();

        //CyberP: add some hunger
        //if (Player.bHardCoreMode)                                             //RSD: Since we now have a menu option, always de-increment hunger and check option elsewhere
        //{
        //if (Player.PerkNamesArray[17] != 1)
        //Player.fullUp -= 33 + (FRand() * (60*FRand()));                       //RSD: Reworking this
        Player.fullUp -= 20;                                                    //RSD: Lose 20% hunger on mission transitions
        if (Player.fullUp < 0)
           Player.fullUp = 0;
        //}
        //else
        //   Player.fullUp=-99999;

        //Lose 20% addictions per mission
        Player.AddictionManager.RemoveAddictions(20,60);

		// Set this flag so we only get in here once per mission.
		flags.SetBool(flagName, True);
	}

	if (Flags.GetBool('Enhancement_Detected'))
	{
	    ForEach AllActors(class'HumanMilitary', HumM)
	    {
	        if (humM.IsA('MJ12Elite') || humM.IsA('MJ12Troop'))
	        if (HumM.UnfamiliarName == "MJ12 Elite" || HumM.MultiSkins[3]==Texture'DeusExCharacters.Skins.MiscTex1'
            || HumM.MultiSkins[3]==Texture'DeusExCharacters.Skins.TerroristTex0' || HumM.MultiSkins[3]==Texture'GMDXSFX.Skins.MJ12EliteTex0')
	            HumM.BarkBindName = "MJ12Elite";
        }
	}

	//HDTP DDL: make the trees not unlit, because seriously WTF people
	foreach AllActors(Class'tree', tree)
	{
		if(tree.bUnlit)
			tree.bUnlit = false;
	}
}

// ----------------------------------------------------------------------
// PreTravel()
//
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
    local DeusExRootWindow root;

    Player = DeusExPlayer(GetPlayerPawn());
	root = DeusExRootWindow(Player.rootWindow);

	if (root != None && Player != none && localURL != "ENDGAME1" && localURL != "ENDGAME2" && localURL != "ENDGAME3" && (Player.bRealUI || Player.bHardCoreMode))
	{
	  if (!Player.bDeadLoad && root.hud.barkDisplay != None && !root.hud.barkDisplay.bIsVisible)
	     root.ClearWindowStack();   //CyberP: close the inventory/GUI
	}

	// turn off the timer
	SetTimer(0, False);

	// zero the flags so FirstFrame() gets executed at load
	flags = None;
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
	// make sure our flags are initialized correctly
	if (flags == None)
	{
		InitStateMachine();

		// Don't want to do this if the user just loaded a savegame
		if ((player != None) && (flags.GetBool('PlayerTraveling')))
			FirstFrame();
	}
}

function Tick(float DeltaTime)
{
   if (CanQuickSave && player != none && (player.bTogAutoSave || player.bHardCoreMode)) //CyberP: toggle autosave option //RSD: TEMPORARILY remove Hardcore autosave because it's pissing me off
   {
      if (TimeToSave>0) TimeToSave-=DeltaTime;
      else
      if (player.CanSave(true,true))
      {
         CanQuickSave=false;
         /*if (localURL == "05_NYC_UNATCOMJ12LAB")
         TimeToSave=0.5;
         else
         TimeToSave=0.1;*/
         TimeToSave=0.0;                                                        //RSD: Removed autosave delay
         player.PerformAutoSave();
      } else
         CanQuickSave=false;
   }
}
//State QuickSaver
//{
//   function Timer()
//   {
//      if (dxInfo != None && !(player.IsInState('Dying')) && !(player.IsInState('Paralyzed')) && !(player.IsInState('Interpolating')) &&
//      player.dataLinkPlay == None && Level.Netmode == NM_Standalone)
//      {
//         Player.bPendingHardCoreSave=true;
//         player.QuickSave();
//      }
//      GotoState('');
//   }
//
//Begin:
//   SetTimer(0.1,false);
//}


//GMDX: unhide savepoints, will add reactivate at some point
function PutInWorld_SavePoint(Optional name MatchTag)
{
   local SavePoint SP;
   foreach AllActors(class'SavePoint',SP,MatchTag)
   {
      if (SP.bHidden)
         SP.bHidden=false;
   }
}

// ----------------------------------------------------------------------
// GetPatrolPoint()
// ----------------------------------------------------------------------


function PatrolPoint GetPatrolPoint(Name patrolTag, optional bool bRandom)
{
	local PatrolPoint aPoint;

	aPoint = None;

	foreach AllActors(class'PatrolPoint', aPoint, patrolTag)
	{
		if (bRandom && (FRand() < 0.5))
			break;
		else
			break;
	}

	return aPoint;
}

// ----------------------------------------------------------------------
// GetSpawnPoint()
// ----------------------------------------------------------------------

function SpawnPoint GetSpawnPoint(Name spawnTag, optional bool bRandom)
{
	local SpawnPoint aPoint;

	aPoint = None;

	foreach AllActors(class'SpawnPoint', aPoint, spawnTag)
	{
		if (bRandom && (FRand() < 0.5))
			break;
		else
			break;
	}

	return aPoint;
}

function InitializeRandomAmmoCounts()                                           //RSD: Initializes random ammo drop counts on first map load so they can't be savescummed
{
	local int ammoDropCount;
	local ScriptedPawn SP;
	local DeusExCarcass DC;

	foreach AllActors(class'ScriptedPawn', SP)
	{
		ammoDropCount = Rand(4) + 1;                                            //RSD: From general randomized PickupAmmoCount in DeusExCarcass.uc
		SP.PickupAmmoCount = ammoDropCount;
	}
	foreach AllActors(class'DeusExCarcass', DC)
	{
	    ammoDropCount = Rand(4) + 1;                                            //RSD: From general randomized PickupAmmoCount in DeusExCarcass.uc
		DC.PickupAmmoCount = ammoDropCount;
	}
}

function InitializeRandomCrateContents()                                        //RSD: Randomizes crate contents depdending on new loot table classes
{
    local Containers CO;
    //local class<Inventory> itemClass;
    local bool bMatchFound;
	local LootTableAmmoPistol tablePistol;
	local LootTableAmmoRifle tableRifle;
	local LootTableAmmoNonlethal tableNonlethal;
	local LootTableAmmoRobot tableRobot;
	local LootTableAmmoHeavy tableHeavy;
	local LootTableAmmoExplosive tableExplosive;
    local LootTableGeneralTool tableTool;
    local LootTableGeneralWearable tableWearable;
    local LootTableGeneralPickup tablePickup;
    local LootTableMedicalMain tableMedical;
    //local LootTableModHandling tableModHandling;
    //local LootTableModAmmo tableModAmmo;
    //local LootTableModBallistics tableModBallistics;
    //local LootTableModAttachments tableModAttachments;
    local LootTableModGeneral tableModGeneral;

    tablePistol = Spawn(class'LootTableAmmoPistol');
    tableRifle = Spawn(class'LootTableAmmoRifle');
    tableNonlethal = Spawn(class'LootTableAmmoNonlethal');
    tableRobot = Spawn(class'LootTableAmmoRobot');
    tableHeavy = Spawn(class'LootTableAmmoHeavy');
    tableExplosive = Spawn(class'LootTableAmmoExplosive');
    tableTool = Spawn(class'LootTableGeneralTool');
    tableWearable = Spawn(class'LootTableGeneralWearable');
    tablePickup = Spawn(class'LootTableGeneralPickup');
    tableMedical = Spawn(class'LootTableMedicalMain');
    //tableModHandling = Spawn(class'LootTableModHandling');
    //tableModAmmo = Spawn(class'LootTableModAmmo');
    //tableModBallistics = Spawn(class'LootTableModBallistics');
    //tableModAttachments = Spawn(class'LootTableModAttachments');
    tableModGeneral = Spawn(class'LootTableModGeneral');

//log("BEGIN CRATE SWAPPING");
    ForEach AllActors(class'Containers', CO)
    {
    	if (CO.IsA('CrateBreakableMedCombat') || CO.IsA('CrateBreakableMedGeneral') || CO.IsA('CrateBreakableMedMedical'))
    	{
            //itemClass = CO.contents;
            if ((ClassIsChildOf(CO.contents,class'DeusExAmmo') || ClassIsChildOf(CO.contents,class'DeusExWeapon')) && player.bRandomizeCrates) //RSD: First do ammo tables since they're most common
            {
            //if (player.bRandomizeCratesAmmoPistol)
            bMatchFound = checkCrateLootTable(CO, tablePistol);
        	if (!bMatchFound)// && player.bRandomizeCratesAmmoRifle)
        		bMatchFound = checkCrateLootTable(CO, tableRifle);
       		if (!bMatchFound)// && player.bRandomizeCratesAmmoNonlethal)
        		bMatchFound = checkCrateLootTable(CO, tableNonlethal);
       		if (!bMatchFound)// && player.bRandomizeCratesAmmoRobot)
        		bMatchFound = checkCrateLootTable(CO, tableRobot);
       		if (!bMatchFound)// && player.bRandomizeCratesAmmoHeavy)
        		bMatchFound = checkCrateLootTable(CO, tableHeavy);
       		if (!bMatchFound)// && player.bRandomizeCratesAmmoExplosive)
        		bMatchFound = checkCrateLootTable(CO, tableExplosive);
            }
            else if (ClassIsChildOf(CO.contents,class'WeaponMod') && player.bRandomizeMods) //RSD: Then do weapon mods before general stuff
            {
            /*//if (player.bRandomizeModsHandling)
            bMatchFound = checkCrateLootTable(CO, tableModHandling);
        	if (!bMatchFound)// && player.bRandomizeModsAmmo)
        		bMatchFound = checkCrateLootTable(CO, tableModAmmo);
       		if (!bMatchFound)// && player.bRandomizeModsBallistics)
        		bMatchFound = checkCrateLootTable(CO, tableModBallistics);
       		if (!bMatchFound)// && player.bRandomizeModsAttachments)
        		bMatchFound = checkCrateLootTable(CO, tableModAttachments);*/
       		bMatchFound = checkCrateLootTable(CO, tableModGeneral);
            }
            else if (player.bRandomizeCrates)
            {
            //if (player.bRandomizeCratesMedicalMain)
        	bMatchFound = checkCrateLootTable(CO, tableMedical);
            if (!bMatchFound)// && player.bRandomizeCratesGeneralTool)
        		bMatchFound = checkCrateLootTable(CO, tableTool);
        	if (!bMatchFound)// && player.bRandomizeCratesGeneralWearable)
        		bMatchFound = checkCrateLootTable(CO, tableWearable);
       		if (!bMatchFound)// && player.bRandomizeCratesGeneralPickup)
        		bMatchFound = checkCrateLootTable(CO, tablePickup);
            }
	   	    /*if (bMatchFound && CO.contents != itemClass)
log("Swapped to" @ CO.contents);
	   	    else
log("Still" @ CO.contents);*/
    	}
    }

    //RSD: Destroy the objects otherwise they end up as bird icons in a random spot on the map
    tablePistol.Destroy();
    tableRifle.Destroy();
    tableNonlethal.Destroy();
    tableRobot.Destroy();
    tableHeavy.Destroy();
    tableExplosive.Destroy();
    tableTool.Destroy();
    tableWearable.Destroy();
    tablePickup.Destroy();
    tableMedical.Destroy();
    //tableModHandling.Destroy();
    //tableModAmmo.Destroy();
    //tableModBallistics.Destroy();
    //tableModAttachments.Destroy();
    tableModGeneral.Destroy();
//log("END CRATE SWAPPING");
}

function InitializeRandomItems()
{
    local WeaponMod WM;
    local bool bMatchFound;
    //local LootTableModHandling tableModHandling;
    //local LootTableModAmmo tableModAmmo;
    //local LootTableModBallistics tableModBallistics;
    //local LootTableModAttachments tableModAttachments;
    local LootTableModGeneral tableModGeneral;

    //tableModHandling = Spawn(class'LootTableModHandling');
    //tableModAmmo = Spawn(class'LootTableModAmmo');
    //tableModBallistics = Spawn(class'LootTableModBallistics');
    //tableModAttachments = Spawn(class'LootTableModAttachments');
    tableModGeneral = Spawn(class'LootTableModGeneral');

//log("BEGIN ITEM SWAPPING");
    //RSD: For now, only swap out weapon mods since they have the same footprint
    foreach AllActors(class'WeaponMod', WM)                                     //RSD: Gross hack to keep us from infinitely looping
        WM.Tag = 'checkLootTable';
    foreach AllActors(class'WeaponMod', WM, 'checkLootTable')
	{
        WM.Tag = WM.default.Tag;
        if (WM.Owner == none && !WM.bNoRandomSwap)                              //RSD: Make sure no one's holding this item and it's not a shop item that we shouldn't swap
        {
        /*//if (Player.bRandomizeModsHandling)
        bMatchFound = CheckItemLootTable(WM,tableModHandling);
	    if (!bMatchFound)// && Player.bRandomizeModsAmmo)
	        bMatchFound = CheckItemLootTable(WM,tableModAmmo);
        if (!bMatchFound)// && Player.bRandomizeModsBallistics)
	        bMatchFound = CheckItemLootTable(WM,tableModBallistics);
        if (!bMatchFound)// && Player.bRandomizeModsAttachments)
	        bMatchFound = CheckItemLootTable(WM,tableModAttachments);*/
        bMatchFound = CheckItemLootTable(WM,tableModGeneral);
        }
	}

	//tableModHandling.Destroy();
    //tableModAmmo.Destroy();
    //tableModBallistics.Destroy();
    //tableModAttachments.Destroy();
    tableModGeneral.Destroy();
//log("END ITEM SWAPPING");
}

function bool checkCrateLootTable(Containers CO, LootTable LT)                  //RSD: Checks crate contents against a loot table and randomly swaps contents if it finds a match
{
    local int i, weightCount, rnd;
    local bool bMatchFound;
    local class<Inventory> itemClass;

    itemClass = CO.contents;

    weightCount = 0;
    for (i=0;i<ArrayCount(LT.entries);i++)                                      //RSD: Hardcoded 8 entries! Be careful //RSD: nvm
    {
        weightCount += LT.entries[i].weight;
        if (itemClass != None && itemClass == LT.entries[i].item)
            bMatchFound = true;
    }
    if (bMatchFound)
    {
        if (FRand() > LT.slotChance)
        {
            CO.contents = none;
            return bMatchFound;
        }
        rnd = Rand(weightCount);
        weightCount = 0;
        for (i=0;i<ArrayCount(LT.entries);i++)
        {
            weightCount += LT.entries[i].weight;
            if (rnd < weightCount)
            {
                CO.contents = LT.entries[i].item;
                break;
            }
        }
    }

    return bMatchFound;
}

function bool checkItemLootTable(Inventory item, LootTable LT)                  //RSD: Checks item against a loot table and randomly switches the item if it finds a match
{
    local int i, weightCount, rnd;
    local bool bMatchFound;
    local class<Inventory> itemClass;
    local vector itemLoc;
    local rotator itemRot;

    itemClass = item.Class;

    weightCount = 0;
    for (i=0;i<ArrayCount(LT.entries);i++)                                      //RSD: Hardcoded 8 entries! Be careful //RSD: nvm
    {
        weightCount += LT.entries[i].weight;
        if (itemClass != None && itemClass == LT.entries[i].item)
            bMatchFound = true;
    }
    if (bMatchFound)
    {
        rnd = Rand(weightCount);
        weightCount = 0;
        for (i=0;i<ArrayCount(LT.entries);i++)
        {
            weightCount += LT.entries[i].weight;
            if (rnd < weightCount)                                              //RSD: Copy old item location and replace it with the new item
            {
                itemLoc=item.Location;
                itemRot=item.Rotation;
                item.Destroy();
                item = Spawn(LT.entries[i].item,,,itemLoc);
                item.SetRotation(itemRot);
                break;
            }
        }
    }

    return bMatchFound;
}

function SetScrambledAugs()
{
    local AugmentationCannister AC;
    local int i, scrambledNum;

    if (player == none)
        return;

//    for (i=0; i<ArrayCount(player.augOrderNums); i++)
//log(player.augOrderNums[i]);
    foreach AllActors(class'AugmentationCannister', AC)
    {
        for (i=0; i<ArrayCount(player.AugOrderNums); i++)
        {
            if (AC.augListNum == i+1)                                           //RSD: i+1 so that default of 0 doesn't get swapped as a failsafe (augs numbered from 1 in maps)
            {
                scrambledNum = player.augOrderNums[i];                          //RSD: Grab the corresponding scrambled number
//log("scrambledNum" @ scrambledNum);
                AC.AddAugs[0] = player.augOrderList[scrambledNum].aug1;         //RSD: Swap the first aug
                AC.AddAugs[1] = player.augOrderList[scrambledNum].aug2;         //RSD: Swap the second aug
            }
        }
    }
}

defaultproperties
{
     checkTime=1.000000
     localURL="NOTHING"
     TimeToSave=0.200000
}
