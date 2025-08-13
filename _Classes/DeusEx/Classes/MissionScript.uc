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
var bool CanQuickSave; //SARGE: Note this is actually for Autosaves, not Quicksaves
var float TimeToSave;

var bool firstTime;     //SARGE: Set to true the first time we enter a map.

var bool bConfixChecked;                        //SARGE: Set to true when we've checked confix being installed.

var byte savedSoundVolume;
var byte savedMusicVolume;
var byte savedSpeechVolume;

// ----------------------------------------------------------------------
// SARGE: UpdateSavePoints()
//
// Checks the required flags for all Save Points, and hides/unhides them accordingly.
// ----------------------------------------------------------------------

function UpdateSavePoints()
{
	local SavePoint SP;
    local bool bValid;
	
    foreach AllActors(class'SavePoint', SP)
    {
        bValid = SP.requiredFlag == '' || flags.GetBool(SP.requiredFlag);
        if (bValid)
        {
            if (SP.bHidden)
            {
                SP.bHidden = false;
                SP.LightRadius = SP.default.LightRadius;
            }
        }
        else
        {
            if (!SP.bHidden)
            {
                SP.bHidden = true;
                SP.LightRadius = 0;
            }
        }
    }
}

// ----------------------------------------------------------------------
// SARGE: SetMinimumVolume()
//
// Force the players Music, Sound and Speech volume to be a certain minimum amount.
// Used for cutscenes because they sound awkward/weird without music
// Saves the values so we can use RestorePreviousVolume to restore it to what it was. Used for cutscenes.
// ----------------------------------------------------------------------

function SetMinimumVolume()
{
    savedSoundVolume = byte(ConsoleCommand("get" @ "ini:Engine.Engine.AudioDevice SoundVolume"));
    savedMusicVolume = byte(ConsoleCommand("get" @ "ini:Engine.Engine.AudioDevice MusicVolume"));
    savedSpeechVolume = byte(ConsoleCommand("get" @ "ini:Engine.Engine.AudioDevice SpeechVolume"));
 
    if (!player.bCutsceneVolumeEqualiser)
        return;

    //Reduce the overall sound volume
    SoundVolume = savedSpeechVolume / 8;
    Player.SetInstantSoundVolume(savedSpeechVolume / 8);

    //Force the music on
    Player.SetInstantMusicVolume(savedSpeechVolume / 2);
}

function RestorePreviousVolume()
{
	Player.SetInstantSoundVolume(savedSoundVolume);
	Player.SetInstantMusicVolume(savedMusicVolume);
	Player.SetInstantSpeechVolume(savedSpeechVolume);
}

// ----------------------------------------------------------------------
// DoLightingAccessibility()
//
// Modify a light to be steady, rather than strobing, or optionally delete it instead,
// based on the players Lighting Accessibility setting
// ----------------------------------------------------------------------

function DoLightingAccessibility(Light L, name checkName, optional bool bStrobe)
{
    if (!player.bLightingAccessibility || L.name != checkName)
        return;
                
    //log("Light Found: [" $ L.Name $ "]");

    if (bStrobe)
    {
        L.LightPeriod = 155;
        L.LightType = LT_Strobe;
    }
    else
    {
        L.LightPeriod = 0;
        L.LightType = LT_Steady;
    }
}

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

// Generate a seed for the randomiser
// This is combined with the players seed to
// generate a unique combination for this playthrough
function int GenerateMapSeed()
{
    local float seed;
    local PathNode P;

    // Generate seed by finding every character in the map, and getting their world position
    foreach AllActors(class'PathNode', P)
    {
        seed += P.Location.X;
        seed += P.Location.Y;
        seed += P.Location.Z;
    }
        
    return int(seed);
}

//SARGE: Confix sets the `Confix_Engaged` flag, but
//only when we've received the first message from Alex
function DoConfixCheck()
{
    if (bConfixChecked)
        return;

    //Check Training
    /*
    else if (localURL == "00_TRAINING" && flags.GetBool('DL_Start_Played'))
        bConfixChecked = true;
    */

    //Check on Liberty Island
    else if (localURL == "01_NYC_UNATCOISLAND" && flags.GetBool('DL_StartGame_Played'))
        bConfixChecked = true;
    
    //Check on MJ12 Lab (Alternate Start)
    else if (localURL == "05_NYC_UNATCOMJ12LAB" && flags.GetBool('M05AnnaTaunt_Played'))
        bConfixChecked = true;

    //Flag is not set, oh dear! Tell the player about it!
    if (bConfixChecked && !flags.GetBool('Confix_Engaged'))
    {
        player.clientMessage("ConFix is not installed! Please install ConFix for the best experience while playing GMDX!");
        player.clientMessage("After installing ConFix, it is highly recommended that you start a new playthrough!");
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
    local int seed;
    local DeusExCarcass C;                                                      //SARGE
    local DecalManager D;                                                       //SARGE
    local SecurityCamera Cam;                                                      //SARGE

	flags.DeleteFlag('PlayerTraveling', FLAG_Bool);

    //Recreate/Setup our decal manager
	foreach AllActors(class'DecalManager', D)
        break;

    if (D == None)
    {
        D = Spawn(class'DecalManager');
        player.DecalManager = D;
        D.Setup(player);
    }

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
        //SARGE: Seed the Randomiser, so that we can't autosave-cheese the generated items
        seed = GenerateMapSeed();
        //Player.ClientMessage("Map seed is: " $ seed);
        Player.Randomizer.Seed(Player.seed + seed);

		//Player.BroadcastMessage("Loading this map for the first time");
		//Player.setupDifficultyMod();
		InitializeRandomAmmoCounts();

        bRandomItems = player.bRandomizeMods; //(player.bRandomizeModsHandling || player.bRandomizeModsAmmo || player.bRandomizeModsBallistics || player.bRandomizeModsAttachments);
        bRandomCrates = (bRandomItems || player.bRandomizeCrates); /*player.bRandomizeCratesGeneralTool || player.bRandomizeCratesGeneralWearable
                       || player.bRandomizeCratesGeneralPickup || player.bRandomizeCratesMedicalMain
                       || player.bRandomizeCratesAmmoPistol || player.bRandomizeCratesAmmoRifle
                       || player.bRandomizeCratesAmmoNonlethal || player.bRandomizeCratesAmmoRobot
                       || player.bRandomizeCratesAmmoHeavy || player.bRandomizeCratesAmmoExplosive);*/
        //if (bRandomCrates)                                                      //RSD: Also randomize crates with user setting
			InitializeRandomCrateContents(bRandomCrates);
		if (bRandomItems)                                                       //RSD: Also randomize items (weapon mods) with user setting
			InitializeRandomItems();
		if (player.bRandomizeAugs)
			SetScrambledAugs();
        
        if (player.bRandomizeEnemies)
        {
            InitializeEnemySwap(0);
            InitializeEnemySwap(1);
        }

        //Make the placed corpses bleed
        foreach AllActors(class'DeusExCarcass', C)
        {
            if (!C.bHidden && !C.bNotDead)
                C.SetupCarcass(false);
        }

        //Randomise the crap around the level
        RandomiseCrap();

        if (dxInfo.MissionNumber > 0)
        {
            //Distribute PS20's and Flares
            DistributeItem('ScriptedPawn',class'WeaponHideAGun',0,2,class'AmmoHideAGun');
            DistributeItem('ScriptedPawn',class'Flare',1,3);

            //SARGE: Give Shurikens to Elites
            DistributeItem('MJ12Elite',class'WeaponShuriken',1,3);
        }

		flags.SetBool(flagName, True);

        //SARGE: HARDCORE ONLY, force all cameras to set off alarms etc,
        if (player.bHardCoreMode)
            foreach AllActors(class'SecurityCamera', Cam)
                Cam.bAlarmEvent = true;

        firstTime = true;
	}

	flagName = Player.rootWindow.StringToName("M"$dxInfo.MissionNumber$"MissionStart");
	if (!flags.GetBool(flagName))
	{
		// Remove completed Primary goals and all Secondary goals
		Player.ResetGoals();
        
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

	//SARGE: Remove the MJ12 Elite vocoded voices, they don't work properly for LDDP,
	//and have some other issues.
	foreach AllActors(class'ScriptedPawn', P)
	{
	   if (P.IsA('MJ12Elite') || P.IsA('MJ12Elite2'))
	   {
		    if (Rand(2) == 0)
				P.BarkBindName = "MJ12Troop";
			else
				P.BarkBindName = "MJ12TroopB";
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

    DoConfixCheck();
    UpdateSavePoints();
}

function Tick(float DeltaTime)
{
    if (CanQuickSave && player != none) //CyberP: toggle autosave option //RSD: TEMPORARILY remove Hardcore autosave because it's pissing me off
    {
        if (TimeToSave>0)
            TimeToSave-=DeltaTime;
        else
        {
            if (localURL ~= "11_PARIS_EVERETT")
                TimeToSave=0.0; //Save before speech if we can
            else if (localURL ~= "05_NYC_UNATCOMJ12LAB")
                TimeToSave=0.5;
            else
                TimeToSave=0.1;
            //TimeToSave=0.0;                                                        //RSD: Removed autosave delay
            CanQuickSave = !player.PerformAutoSave(firstTime);                      //Sarge: Keep trying until we successfully save
        }
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

//Gives the specified item to 0-X random enemies in the map.
function DistributeItem(name actorClass, class<Inventory> itemClass, int minAmount, int maxAmount, optional class<Ammo> ammoClass)
{
    local int i, j, swapTo, items;
    local ScriptedPawn actors[50], temp, SP;
    local int actorCount, toGive, index;
    local Inventory inv, inv2;
    
    player.DebugMessage("Distributing "$itemClass$"...");

    foreach AllActors(class'ScriptedPawn', SP)
    {
        if (/*!SP.bImportant && */SP.GetPawnAllianceType(Player) == ALLIANCE_Hostile && !SP.isA('Robot') && !SP.isA('Animal') && !SP.isA('HumanCivilian') && !SP.bDontRandomizeWeapons && actorCount < 50 && SP.IsA(actorClass))
            actors[actorCount++] = SP;
    }
    
    toGive = Player.Randomizer.GetRandomInt(maxAmount - minAmount) + minAmount;
    player.DebugMessage("  To Give: "$toGive);
    toGive = MIN(toGive,actorCount);
    player.DebugMessage("  To Give (capped): "$toGive);

    if (toGive == 0)
        return;
    
    player.DebugMessage("  Before Shuffle...");

    for (i = actorCount - 1;i >= 0;i--)
    {
        player.DebugMessage("    Actor: " $ actors[i]);
    }

    //Shuffle the array
    for (i = actorCount - 1;i >= 0;i--)
    {
        swapTo = Player.Randomizer.GetRandomInt(i);
        temp = actors[i];
        actors[i] = actors[swapTo];
        actors[swapTo] = temp;
    }
    
    player.DebugMessage("  After Shuffle...");
    
    for (i = actorCount - 1;i >= 0;i--)
    {
        player.DebugMessage("    Actor: " $ actors[i]);
    }

    //Now give the first 0-2 PS20s

    for(i = 0;i < actorCount;i++)
    {
        //No more to give?
        if (toGive == 0 || i > actorCount)
            break;

        //First, make sure they don't have one.
        //Need to restrict this to a max of 10, otherwise some maps crash for no reason
        inv = actors[i].Inventory;
        while (inv != None && items < 10)
        {
            items++;
            if (inv.Class == itemClass)
                continue;
            inv = inv.Inventory;
        }
    
        //Spawn the item and some ammo
        inv = spawn(itemClass, actors[i]);
        if (inv != None)
        {
            inv.GiveTo(actors[i]);
            inv.SetBase(actors[i]);
            inv.bHidden = True;
            inv.SetPhysics(PHYS_None);
            actors[i].AddInventory(inv);
            //player.ClientMessage("  Given a "$itemClass$" to "$actors[i]);
        }
        if (ammoClass != None)
        {
            inv2 = spawn(ammoClass, actors[i]);
            if (inv2 != None)
            {
                inv2.GiveTo(actors[i]);
                inv2.SetBase(actors[i]);
                inv2.bHidden = True;
                inv2.SetPhysics(PHYS_None);
                actors[i].AddInventory(inv2);
                if(inv.IsA('DeusExWeapon') && inv2.isA('Ammo'))
                    DeusExWeapon(inv).AmmoType = Ammo(inv2);
                //player.ClientMessage("  Given a "$ammoClass$" to "$actors[i]);
            }
        }
        Player.DebugMessage("  Give " $ actors[i].UnfamiliarName $ " (" $ actors[i] $ " ) a " $ itemClass);
        actors[i].SwitchToBestWeapon();
        toGive--;
    }
}

function InitializeRandomAmmoCounts()                                           //RSD: Initializes random ammo drop counts on first map load so they can't be savescummed
{
	local int ammoDropCount;
	local ScriptedPawn SP;
	local DeusExCarcass DC;

	foreach AllActors(class'ScriptedPawn', SP)
	{
		ammoDropCount = Player.Randomizer.GetRandomInt(4) + 1;                                            //RSD: From general randomized PickupAmmoCount in DeusExCarcass.uc
		SP.PickupAmmoCount = ammoDropCount;
	}
	foreach AllActors(class'DeusExCarcass', DC)
	{
	    ammoDropCount = Player.Randomizer.GetRandomInt(4) + 1;                                            //RSD: From general randomized PickupAmmoCount in DeusExCarcass.uc
		DC.PickupAmmoCount = ammoDropCount;
	}
}

//Sarge: Randomise all the crap around the level (sodacans, cigs, etc) to have random skins
function RandomiseCrap()
{
    local DeusExPickup P;
    local OfficeChair C;
    local CouchLeather L;
    local ChairLeather L2;
    local int chairSkin;
        
    if (!player.bRandomizeCrap)
        return;

    foreach AllActors(class'DeusExPickup', P)
    {
        P.RandomiseSkin(player);
    }
    
    //Roll once, so that all the chairs in the level get the same style.
    chairSkin=Player.Randomizer.GetRandomInt(5);
    //log("Applying chair skin to all swivel chairs: " $ chairSkin);
    foreach AllActors(class'OfficeChair', C)
    {
        C.SkinColor = chairSkin;
        C.UpdateHDTPsettings();
    }
    
    //Roll once, so that all the couches in the level get the same style.
    chairSkin=Player.Randomizer.GetRandomInt(4);
    //log("Applying chair skin to all leather couches: " $ chairSkin);
    foreach AllActors(class'CouchLeather', L)
    {
        L.SkinColor = chairSkin;
        L.UpdateHDTPsettings();
    }
    
    //And chairs
    //log("Applying chair skin to all leather chairs: " $ chairSkin);
    foreach AllActors(class'ChairLeather', L2)
    {
        L2.SkinColor = chairSkin;
        L2.UpdateHDTPsettings();
    }
}

//Sarge: Randomize Weapons amongs Enemies
function InitializeEnemySwap(int pool) //use pool 0 for regular weapons, pool 1 for snipers, plasma and GEP guns
{
	local ScriptedPawn Man;
    local ScriptedPawn randomizeActors[100];
    local int totalRandomized;
    local int i, swapTo, randPos;
    local ScriptedPawn temp;

    //Get all the relevant actors on the map
    foreach AllActors(class'ScriptedPawn', Man)
	{
        if (!Man.bImportant && Man.GetPawnAllianceType(Player) == ALLIANCE_Hostile && !Man.isA('Robot') && !Man.isA('Animal') && !Man.isA('HumanCivilian') && !Man.bDontRandomizeWeapons)
        {
            if (pool == 0 && !Man.Weapon.isA('WeaponRifle') && !Man.Weapon.isA('WeaponGEPGun') && !Man.Weapon.isA('WeaponPlasmaRifle'))
                randomizeActors[totalRandomized] = Man;
            else if (pool == 1 && (Man.Weapon.isA('WeaponRifle') || Man.Weapon.isA('WeaponGEPGun') || Man.Weapon.isA('WeaponPlasmaRifle')))
                randomizeActors[totalRandomized] = Man;
            totalRandomized++;
        }
	}
    
    //Player.ClientMessage("Total Enemies Found: " $ totalRandomized);

    //Shuffle the array
    for (i = totalRandomized;i > 0;i--)
    {
        swapTo = Player.Randomizer.GetRandomInt(i + 1);
        temp = randomizeActors[i];
        randomizeActors[i] = randomizeActors[swapTo];
        randomizeActors[swapTo] = temp;
    }
    
    //Now swap the actual enemies around
    for (i = 0;i < totalRandomized;i += 2)
    {
        randPos = i + 1;
        if (randPos >= totalRandomized)
            break;

        if (randomizeActors[i] != None && randomizeActors[randPos] != None)
            ReplaceEnemyWeapon(randomizeActors[i],randomizeActors[randPos]);
        //Player.SetLocation(tempLocation);
    }

}

function ReplaceEnemyWeapon(ScriptedPawn first, ScriptedPawn second)
{
    local Inventory weaps1[5], weaps2[5];
    local Inventory inv;
    local DeusExWeapon wep;
    local int i,j,k;
    local float tempAcc;


    //Do the ammos first, so we can assign them to weapons properly
    inv = first.Inventory;
    while (inv != None && i < 5)
    {
        if (inv.isA('Ammo'))
        {
            weaps1[i] = inv;
            i++;
        }
        inv = inv.Inventory;
    }
    
    inv = second.Inventory;
    while (inv != None && j < 5)
    {
        if (inv.isA('Ammo'))
        {
            weaps2[j] = inv;
            j++;
        }
        inv = inv.Inventory;
    }
    
    //Now actually swap the ammo between pawns
    for (k=0;k < i;k++)
    {
        //Player.ClientMessage("Give " $ first.FamiliarName $ " " $weaps1[k].ItemName $ " to " $ second.FamiliarName);
        weaps1[k].GiveTo(second);
        weaps1[k].SetBase(second);
    }

    for (k=0;k < j;k++)
    {
        //Player.ClientMessage("Give " $ second.FamiliarName $ " " $ weaps2[k].ItemName $ " to " $ first.FamiliarName);
        weaps2[k].GiveTo(first);
        weaps2[k].SetBase(first);
    }

    //Now do the weapons
    i = 0;
    j = 0;
    k = 0;

    //Get a list of all the weapons in each inventory
    inv = first.Inventory;
    while (inv != None && i < 5)
    {
        if (inv.isA('DeusExWeapon'))
        {
            weaps1[i] = inv;
            i++;
        }
        inv = inv.Inventory;
    }
    
    inv = second.Inventory;
    while (inv != None && j < 5)
    {
        if (inv.isA('DeusExWeapon'))
        {
            weaps2[j] = inv;
            j++;
        }
        inv = inv.Inventory;
    }

    //Now actually swap the weapons between pawns
    for (k=0;k < i;k++)
    {
        //Player.ClientMessage("Give " $ first.FamiliarName $ " " $weaps1[k].ItemName $ " to " $ second.FamiliarName);
        weaps1[k].GiveTo(second);
        weaps1[k].SetBase(second);
        wep = DeusExWeapon(weaps1[k]);
        if (wep != None)
            wep.AmmoType = Ammo(second.FindInventoryType(wep.AmmoName));
    }

    for (k=0;k < j;k++)
    {
        //Player.ClientMessage("Give " $ second.FamiliarName $ " " $ weaps2[k].ItemName $ " to " $ first.FamiliarName);
        weaps2[k].GiveTo(first);
        weaps2[k].SetBase(first);
        wep = DeusExWeapon(weaps2[k]);
        if (wep != None)
            wep.AmmoType = Ammo(first.FindInventoryType(wep.AmmoName));
    }

    //Swap BaseAccuracy between the two pawns.
    //Shotgunners and Crossbow Guys generally always have 0 base accuracy.
    tempAcc = first.BaseAccuracy;
    first.BaseAccuracy = second.BaseAccuracy;
    second.BaseAccuracy = tempAcc;
        
    first.WeaponSwap(second);
    second.WeaponSwap(first);

    first.SetupWeapon(false);
    second.SetupWeapon(false);
}

function InitializeRandomCrateContents(bool bRandomCrates)                                        //RSD: Randomizes crate contents depdending on new loot table classes
{
    local Containers CO;
    local class<Inventory> itemClass;
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
            //SARGE: The base game can swap crate contents between 1 of 3 items, the main contents, content2 or content3.
            //That worked completely differently to this system, and would be set upon the crate being destroyed, meaning
            //it could be savescummed.
            //We will fix it by just rolling it now instead.
            //This is a horribly lazy hacky implementation.
            itemClass = CO.contents;
            if (CO.Content2!=None && FRand()<0.33) itemClass = CO.Content2;
            if (CO.Content3!=None && FRand()<0.33) itemClass = CO.Content3;
            CO.contents = itemClass;
            CO.Content2 = None;
            CO.Content3 = None;

            //Jump out if crate randomisation isn't enabled.
            //We used to not run this entire function, but now we need to
            //ensure that the contents shuffling above takes place, because
            //crates will no longer pick random contents when being destroyed.
            if (!bRandomCrates)
                continue;

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
        if (Player.Randomizer.GetRandomFloat() > LT.slotChance)
        {
            CO.contents = none;
            return bMatchFound;
        }
        rnd = Player.Randomizer.GetRandomInt(weightCount);
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
        rnd = Player.Randomizer.GetRandomInt(weightCount);
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
