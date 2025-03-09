//=============================================================================
// DeusExPlayer.
//=============================================================================
class DeusExPlayer extends PlayerPawnExt native;

#exec OBJ LOAD FILE=Effects

// Name and skin assigned to PC by player on the Character Generation screen
var travel String	TruePlayerName;
var travel int      PlayerSkin;

// Combat Difficulty, set only at new game time
var travel Float CombatDifficulty;

// Augmentation system vars
var travel AugmentationManager AugmentationSystem;

// Skill system vars // Trash: Now includes perk system
var travel SkillManager SkillSystem;

var() travel int SkillPointsTotal;
var() travel int SkillPointsAvail;

// Credits (money) the player has
var travel int Credits;

// Energy the player has
var travel float Energy;
var travel float EnergyMax;
var travel float EnergyDrain;				// amount of energy left to drain
var travel float EnergyDrainTotal;		// total amount of energy to drain
var float MaxRegenPoint;     // in multiplayer, the highest that auto regen will take you
var float RegenRate;         // the number of points healed per second in mp

// Keyring, used to store any keys the player picks up
var travel NanoKeyRing KeyRing;		// Inventory Item
var travel NanoKeyInfo KeyList;		// List of Keys

// frob vars
var() float MaxFrobDistance;
var Actor FrobTarget;
var float FrobTime;

// HUD Refresh Timer
var float LastRefreshTime;

// Conversation System Vars
var ConPlay conPlay;						// Conversation
var DataLinkPlay dataLinkPlay;				// Used for DataLinks
var travel ConHistory conHistory;			// Conversation History

// Inventory System Vars
var travel byte				invSlots[30];		// 5x6 grid of inventory slots
var int						maxInvRows;			// Maximum number of inventory rows
var int						maxInvCols;			// Maximum number of inventory columns
var travel Inventory		inHand;				// The current object in hand
var travel Inventory		inHandPending;		// The pending item waiting to be put in hand
var travel Inventory		ClientinHandPending; // Client temporary inhand pending, for mousewheel use.
var travel Inventory		LastinHand;			// Last object inhand, so we can detect inhand changes on the client.
var travel bool				bInHandTransition;	// The inHand is being swapped out
// DEUS_EX AMSD  Whether to ignore inv slots in multiplayer
var bool bBeltIsMPInventory;

// Goal Tracking
var travel DeusExGoal FirstGoal;
var travel DeusExGoal LastGoal;

// Note Tracking
var travel DeusExNote FirstNote;
var travel DeusExNote LastNote;

// Data Vault Images
var travel DataVaultImage FirstImage;

// Log Messages
var DeusExLog FirstLog;
var DeusExLog LastLog;

// used by ViewModel
var Actor ViewModelActor[8];

// DEUS_EX AMSD For multiplayer option propagation UGH!
// In most cases options will sync on their own.  But for
// initial loadout based on options, we need to send them to the
// server.  Easiest thing to do is have a function at startup
// that sends that info.
var bool bFirstOptionsSynced;
var bool bSecondOptionsSynced;

// used while crouching
var travel bool bForceDuck;
var travel bool bCrouchOn;				// used by toggle crouch
var travel bool bWasCrouchOn;			// used by toggle crouch //SARGE: UNUSED now, but left here for native class reasons
var travel byte lastbDuck;				// used by toggle crouch //SARGE: UNUSED now, but left here for native class reasons

// leaning vars
var bool bCanLean;
var float curLeanDist;
var float prevLeanDist;

// toggle walk
var bool bToggleWalk;

// communicate run silent value in multiplayer
var float	RunSilentValue;

// cheats
var bool  bWarrenEMPField;
var float WarrenTimer;
var int   WarrenSlot;

// used by lots of stuff
var name FloorMaterial;
var name WallMaterial;
var Vector WallNormal;

// drug effects on the player
var travel float drugEffectTimer;

// shake variables
var float JoltMagnitude;  // magnitude of bounce imposed by heavy footsteps

// poison dart effects on the player
var float poisonTimer;      // time remaining before next poison TakeDamage
var int   poisonCounter;    // number of poison TakeDamages remaining
var int   poisonDamage;     // damage taken from poison effect

// bleeding variables
var     float       BleedRate;      // how profusely the player is bleeding; 0-1
var     float       DropCounter;    // internal; used in tick()
var()   float       ClotPeriod;     // seconds it takes bleedRate to go from 1 to 0

var float FlashTimer; // How long it should take the current flash to fade.

// length of time player can stay underwater
// modified by SkillSwimming, AugAqualung, and Rebreather
var float swimDuration;
var travel float swimTimer;
var float swimBubbleTimer;

// conversation info
var Actor ConversationActor;
var Actor lastThirdPersonConvoActor;
var float lastThirdPersonConvoTime;
var Actor lastFirstPersonConvoActor;
var float lastFirstPersonConvoTime;

var Bool bStartingNewGame;							// Set to True when we're starting a new game.
var Bool bSavingSkillsAugs;

// Put spy drone here instead of HUD
var bool bSpyDroneActive;
var int spyDroneLevel;
var float spyDroneLevelValue;
var SpyDrone aDrone;

// Buying skills for multiplayer
var bool		bBuySkills;

// If player wants to see a profile of the killer in multiplayer
var bool		bKillerProfile;

// Multiplayer notification messages
const			MPFLAG_FirstSpot				= 0x01;
const			MPSERVERFLAG_FirstPoison	= 0x01;
const			MPSERVERFLAG_FirstBurn		= 0x02;
const			MPSERVERFLAG_TurretInv		= 0x04;
const			MPSERVERFLAG_CameraInv		= 0x08;
const			MPSERVERFLAG_LostLegs		= 0x10;
const			MPSERVERFLAG_DropItem		= 0x20;
const			MPSERVERFLAG_NoCloakWeapon = 0x40;

const			mpMsgDelay = 4.0;

var int		mpMsgFlags;
var int		mpMsgServerFlags;

const	MPMSG_TeamUnatco		=0;
const	MPMSG_TeamNsf			=1;
const	MPMSG_TeamHit			=2;
const	MPMSG_TeamSpot			=3;
const	MPMSG_FirstPoison		=4;
const	MPMSG_FirstBurn		=5;
const	MPMSG_TurretInv		=6;
const	MPMSG_CameraInv		=7;
const	MPMSG_CloseKills		=8;
const	MPMSG_TimeNearEnd		=9;
const	MPMSG_LostLegs			=10;
const	MPMSG_DropItem			=11;
const MPMSG_KilledTeammate =12;
const MPMSG_TeamLAM			=13;
const MPMSG_TeamComputer	=14;
const MPMSG_NoCloakWeapon	=15;
const MPMSG_TeamHackTurret	=16;

var int			mpMsgCode;
var float		mpMsgTime;
var int			mpMsgOptionalParam;
var String		mpMsgOptionalString;

// Variables used when starting new game to show the intro first.
var String      strStartMap;
var travel Bool bStartNewGameAfterIntro;
var travel Bool bIgnoreNextShowMenu;

// map that we're about to travel to after we finish interpolating
var String NextMap;

// Configuration Variables
var globalconfig bool bObjectNames;					// Object names on/off
var globalconfig bool bNPCHighlighting;				// NPC highlighting when new convos
var globalconfig bool bSubtitles;					// True if Conversation Subtitles are on
var globalconfig bool bAlwaysRun;					// True to default to running
var globalconfig bool bToggleCrouch;				// True to let key toggle crouch
var globalconfig float logTimeout;					// Log Timeout Value
var globalconfig byte  maxLogLines;					// Maximum number of log lines visible
var globalconfig bool bHelpMessages;				// Multiplayer help messages

// Overlay Options (TODO: Move to DeusExHUD.uc when serializable)
var globalconfig byte translucencyLevel;			// 0 - 10?
var globalconfig bool bObjectBeltVisible;
var globalconfig bool bHitDisplayVisible;
var globalconfig bool bAmmoDisplayVisible;
var globalconfig bool bDisplayAmmoByClip;
var globalconfig bool bCompassVisible;
var globalconfig bool bCrosshairVisible;
var globalconfig bool bAutoReload;
var globalconfig bool bDisplayAllGoals;
var globalconfig bool bHUDShowAllAugs;				// TRUE = Always show Augs on HUD
var globalconfig int  UIBackground;					// 0 = Render 3D, 1 = Snapshot, 2 = Black
var globalconfig bool bDisplayCompletedGoals;
var globalconfig bool bShowAmmoDescriptions;
var globalconfig bool bConfirmSaveDeletes;
var globalconfig bool bConfirmNoteDeletes;
var globalconfig bool bAskedToTrain;

// Multiplayer Playerspecific options
var() globalconfig Name AugPrefs[9]; //List of aug preferences.

// Used to manage NPC Barks
var travel BarkManager barkManager;

// Color Theme Manager, used to manage all the pretty
// colors the player gets to play with for the Menus
// and HUD windows.

var travel ColorThemeManager ThemeManager;
//SARGE: DO NOT USE THESE!!!
//They aren't removed because the game expects the player to be structured in a certain way
//(See the warning below, scroll down a bit to find it).
//But we don't want to use these because they can fuck regular Deus Ex menus if we uninstall GMDX.
//So we're going to use equivalents
var globalconfig String MenuThemeName;
var globalconfig String HUDThemeName;

// Translucency settings for various UI Elements
var globalconfig Bool bHUDBordersVisible;
var globalconfig Bool bHUDBordersTranslucent;
var globalconfig Bool bHUDBackgroundTranslucent;
var globalconfig Bool bMenusTranslucent;

var localized String InventoryFull;
var localized String TooMuchAmmo;
var localized String TooHeavyToLift;
var localized String CannotLift;
var localized String NoRoomToLift;
var localized String CanCarryOnlyOne;
var localized String CannotDropHere;
var localized String HandsFull;
var localized String NoteAdded;
var localized String GoalAdded;
var localized String PrimaryGoalCompleted;
var localized String SecondaryGoalCompleted;
var localized String EnergyDepleted;
var localized String AddedNanoKey;
var localized String HealedPointsLabel;
var localized String HealedPointLabel;
var localized String SkillPointsAward;
var localized String QuickSaveGameTitle;
var localized String WeaponUnCloak;
var localized String TakenOverString;
var localized String	HeadString;
var localized String	TorsoString;
var localized String LegsString;
var localized String WithTheString;
var localized String WithString;
var localized String PoisonString;
var localized String BurnString;
var localized String NoneString;

var ShieldEffect DamageShield; //visual damage effect for multiplayer feedback
var float ShieldTimer; //for turning shield to fade.
enum EShieldStatus
{
	SS_Off,
	SS_Fade,
	SS_Strong
};

var EShieldStatus ShieldStatus;

var Pawn					myBurner;
var Pawn					myPoisoner;
var Actor				myProjKiller;
var Actor				myTurretKiller;
var Actor				myKiller;
var KillerProfile		killProfile;
var InvulnSphere		invulnSph;

// Conversation Invocation Methods
enum EInvokeMethod
{
	IM_Bump,
	IM_Frob,
	IM_Sight,
	IM_Radius,
	IM_Named,
	IM_Other
};

enum EMusicMode
{
	MUS_Ambient,
	MUS_Combat,
	MUS_Conversation,
	MUS_Outro,
	MUS_Dying
};

var EMusicMode musicMode;
var byte savedSection;		// last section playing before interrupt
var float musicCheckTimer;
var float musicChangeTimer;

// Used to keep track of # of saves
var travel int saveCount;
var travel Float saveTime;

// for getting at the debug system
var DebugInfo GlobalDebugObj;

// Set to TRUE if the player can see the quotes.  :)
var globalconfig bool bQuotesEnabled;

// DEUS_EX AMSD For propagating gametype
var GameInfo DXGame;
var float	 ServerTimeDiff;
var float	 ServerTimeLastRefresh;

// DEUS_EX AMSD For trying higher damage games
var float MPDamageMult;

// Nintendo immunity
var float	NintendoImmunityTime;
var float	NintendoImmunityTimeLeft;
var bool		bNintendoImmunity;
const			NintendoDelay = 6.0;

// For closing comptuers if the server quits
var Computers ActiveComputer;

////============================================================\\\\
///                 THIS IS THE LINE OF SHAME
///                 DONT PLACE ANYTHING ABOVE THIS
///                 OTHERWISE THE NATIVE IMPLEMENTATION
///                 OF DEUSEXPLAYER FUCKS UP!
///                 YOU HAVE BEEN WARNED!!!!
///                 THIS HAS TO FOLLOW THE ORIGINAL
///                 STRUCTURE PERFECTLY, OR WEIRD
///                 SAVE CORRUPTION AND OTHER BUGS START
///                 TO OCCUR!!!!!!
///                 DO NOT DELETE, EDIT, MODIFY, CHANGE,
///                 TRANSPOSE, TRANSFORM, DISTORT, REVISE,
///                 ADJUST, TRANSMUTE, MUTATE, OR OTHERWISE
///                 VARY THESE VALUES! IF YOU EDIT ANYTHING
///                 ABOVE THIS LINE, YOUR PR WILL NOT BE ACCEPTED,
///                 PERIOD.
////============================================================\\\\

////GMDX, RSD and SARGE additions!

var bool bSpyDroneSet;                                                          //RSD: New variable for setting the spy drone in place

struct augBinary                                                                //RSD: Used to create the list of all augs in the game
{
	var name aug1;
	var name aug2;
};

//Holds information about the reserved items on the belt
struct BeltInfo
{
    var bool		bPlaceholder;		    //Sarge. Allow "empty" slots that show the old icon
    var texture		icon;				    //Sarge. Disconnect the icon from the inventory item, so we can keep it when the item disappears.
};

var globalconfig bool bWallPlacementCrosshair;		// SARGE: Show a blue crosshair when placing objects on walls
var globalconfig bool bDisplayTotalAmmo;		    // SARGE: Show total ammo count, rather than MAGS
var globalconfig bool bDisplayClips;		        // SARGE: For the weirdos who prefer Clips instead of Mags. Hidden Option
var globalconfig bool bColourCodeFrobDisplay;       //SARGE: Colour Code the Frob display when you don't meet or only just meet the number of tools/picks required. Some people might not like the colours.
var globalconfig int iFrobDisplayStyle;             //SARGE: Frob Display Style. 0 = "X Tools", 1 = "curr/total Tools", 2 = "total/curr Tools"
var globalconfig bool bGameplayMenuHardcoreMsgShown;//SARGE: Stores whether or not the gameplay menu message has been displayed.
var globalconfig bool bEnhancedCorpseInteractions;  //SARGE: Right click always searches corpses. After searching, right click picks up corpses as normal.
var globalconfig bool bSearchedCorpseText;          //SARGE: Corpses show "[Searched]" text when interacted with for the first time.
var globalconfig bool bCutsceneFOVAdjust;           //SARGE: Enforce 75 FOV in cutscenes
var globalconfig bool bLightingAccessibility;       //SARGE: Changes lighting in some areas to reduce strobing/flashing, as it may hurt eyes or cause seizures.

var globalconfig bool bSubtitlesCutscene;			// SARGE: Allow Subtitles for Third-Person cutscenes. Should generally be left on

var bool bPrisonStart;                              //SARGE: Alternate Start

//Radial Aug Menu
var bool bRadialAugMenuVisible;
var globalconfig bool bAugDisplayVisible;

//Left-Frob Weapon Priority
var localized String CantBreakDT;

//HDTP
var config int iHDTPModelToggle;
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;
var string HDTPMeshTex[8];
var bool bHDTPInstalled;
var globalconfig bool bHDTPEnabled;                      //SARGE: Master switch to enable or disable HDTP

//GMDX: CyberP & dasraiser
//SAVEOUT
//var globalconfig int QuickSaveIndex; //out of some number
//var globalconfig int QuickSaveTotal;//this number
var globalconfig bool bTogAutoSave;   //CyberP: enable/disable autosave
var globalconfig int iQuickSaveMax;//Maximum number of quicksaves
var globalconfig int iAutoSaveMax;//Maximum number of autosaves
var globalconfig int iLastSave;//index to last save. Used for quickloading.
var globalconfig int iAutosaveSlots[50];//Array of autosave slots
var globalconfig int iQuicksaveSlots[50];//Array of quicksave slots
var localized string AutoSaveGameTitle; //Autosave names
//var travel int QuickSaveLast;
//var travel int QuickSaveCurrent;
//hardcore mode
var travel bool bHardCoreMode; //if set disable save game options.
//misc
var globalconfig bool bSkipNewGameIntro; //CyberP: for GMDX option menu
var globalconfig bool bColorCodedAmmo;
var globalconfig bool bExtraHardcore;
var globalconfig bool bDecap;
var globalconfig bool bNoTranslucency;
var globalconfig int dblClickHolster;                      //SARGE: 0 = off, 1 = double click holstering only, 2 = double click holstering and unholstering
var globalconfig bool bHalveAmmo;
var globalconfig bool bHardcoreUnlocked;
var globalconfig bool bAutoHolster;
var globalconfig bool bRealUI;
var globalconfig bool bHardcoreAI1;
var globalconfig bool bHardcoreAI2;
var globalconfig bool bHardcoreAI3;
var globalconfig int bAlternateToolbelt;
var globalconfig bool bAnimBar1;
var globalconfig bool bAnimBar2;
var globalconfig bool bExtraObjectDetails;
var globalconfig bool bA51Camera;
var globalconfig bool bCameraSensors;
var globalconfig bool bHardcoreFilterOption;
var globalconfig bool bRealisticCarc;
var globalconfig bool bLaserRifle;
var globalconfig bool bRemoveVanillaDeath;
var globalconfig bool bHitmarkerOn;
var globalconfig bool bMantleOption;
var globalconfig bool bUSP;
var globalconfig bool bSkillMessage;
var globalconfig bool bXhairShrink;
var globalconfig bool bModdedHeadBob;
var globalconfig bool bBeltAutofill;											//Sarge: Added new feature for auto-populating belt
var globalconfig bool bHackLockouts;											//Sarge: Allow locking-out security terminals when hacked, and rebooting.
var bool bForceBeltAutofill;    	    										//Sarge: Overwrite autofill setting. Used by starting items
var globalconfig bool bBeltMemory;  											//Sarge: Added new feature to allow belt to rember items
var globalconfig bool bSmartKeyring;  											//Sarge: Added new feature to allow keyring to be used without belt, freeing up a slot
var globalconfig int dynamicCrosshair;       									//Sarge: Allow using a special interaction crosshair
var travel BeltInfo beltInfos[12];                                              //Sarge: Holds information about belt slots
var travel float fullUp; //CyberP: eat/drink limit.                             //RSD: was int, now float
var localized string fatty; //CyberP: eat/drink limit.
var localized string noUsing;  //CyberP: left click interaction
var bool bLeftClicked; //CyberP: left click interaction
var bool bDrainAlert; //CyberP: alert if energy low
var float bloodTime; //CyberP:
var float hitmarkerTime;
var float camInterpol;
var transient bool bThrowDecoration;

////Belt Stuff
var travel int SlotMem; //CyberP: for belt/weapon switching, so the code remembers what weapon we had before holstering
var travel int BeltLast;                                                    //Sarge: The last item we literally selected from the belt, regardless of holstering or alternate belt behaviour
var travel bool bScrollSelect;                                              //Sarge: Whether or not our last belt selection was done with Next/Last weapon keys rather than Number Keys. Used by Alternative Belt to know when to holster
var travel int beltScrolled;                                                //Sarge: The last item we scrolled to on the belt, if we are using Adv Toolbelt
var travel bool selectedNumberFromEmpty;                                    //Sarge: Was the current selection made from an empty hand. Used by Alternate Toolbelt Classic Mode to not jump back to previous weapon when we select from an empty hand.
var travel bool bBeltSkipNextPrimary;                                       //SARGE: Don't assign the next weapon we select as our primary.
var globalconfig bool bLeftClickUnholster;                                  //Enable left click unholstering

var int clickCountCyber; //CyberP: for double clicking to unequip
var bool bStunted; //CyberP: for slowing player under various conditions
var float stuntedTime; //SARGE: Replaces the SetTimer calls with a stuntedTime variable; Operates independently of bStunted, which is designed for stamina loss. This allows "temporary" stunting
var bool bRegenStamina; //CyberP: regen when in water but head above water
var bool bCrouchRegen;  //CyberP: regen when crouched and has skill
var float doubleClickCheck; //CyberP: to return from double clicking.
var travel Inventory assignedWeapon;
var Inventory primaryWeapon;
var bool bLastWasEmpty;                                                     //SARGE: Whether or not we were empty before being switched to this weapon.
var float augEffectTime;
var vector vecta;
var rotator rota;
var bool bOnLadder;
//var bool bBoosty;  //CyberP: low-tech speed boost
//Alias=LeanLeft,LeanRight
//Aliases[18]=(Command="Button bLeanRightHook",Alias=LeanRH)
//Aliases[19]=(Command="Button bLeanLeftHook",Alias=LeanLH)
var transient bool bLeanKeysDefined;
var globalconfig color customColorsMenu[14]; //CyberP: custom color theme
var globalconfig color customColorsHUD[14];
var bool bTiptoes; //based on left+right lean
var bool bCanTiptoes; //based on legs/crouch/can raise body
var bool bIsTiptoes;
var bool bPreTiptoes;
var bool bLeftToe,bRightToe;
var bool bRadarTran; //CyberP: radar trans effect
var bool bCloakEnabled; //player is cloaked was class'DeusExWeapon'.default.this=T/F wow :)
var transient bool bIsCloaked; //weapon is cloaked
var int LightLevelDisplay; //CyberP: augIFF light value
var travel int KillerCount; //CyberP: are we a pacifist
var travel Actor RocketTarget; //GEPDummyTarget (basic actor)
var travel int advBelt;
var travel float RocketTargetMaxDistance;
var bool bGEPzoomActive;
var bool bGEPprojectileInflight;//is projectile flighing
var int GEPSkillLevel;
var float GEPSkillLevelValue;
var DeusExProjectile aGEPProjectile;//Fired projectile inflight
var transient float GEPsteeringX,GEPsteeringY; //used for mouse input control
var WeaponGEPGun GEPmounted;
var travel int stepCount;
var travel bool bShowStatus;
var travel bool bShowAugStatus;
var bool bIcarusClimb;
var float CarriedDecoGlow;
var float StepTimer;
var float LadTime;
var bool bSpecialUpgrade;
var travel bool bBoosterUpgrade;
var float enviroAutoTime;
var Name SpecTex;
var globalconfig bool bFirstTimeGMDX;
var globalconfig bool bStaminaSystem;
var bool bDeadLoad;
var bool bGMDXNewGame;
//var travel int topCharge[4];
var bool bHardDrug;

//Crouch Stuff
var bool bCrouchHack;
var bool bToggledCrouch;		        // used by toggle crouch

//Recoil shockwave
var() vector RecoilSimLimit; //plus/minus
var() float RecoilDrain;
var vector RecoilShake;

var vector RecoilDesired;//lerp to this
var float RecoilTime; //amount of lerp shake before desired set to 0

var rotator SAVErotation;
var vector SAVElocation;
var bool bStaticFreeze;

//RSD Stuff
var rotator WHEELSAVErotation;                                                  //RSD: For Lorenz's wheel so it doesn't interfere with drone stuff

var float savedStandingTimer;                                                   //RSD: For transferring the standingTimer between weapons (Sidearm perk)
var travel float NanoVirusTimer;                                                //RSD: For deactivating augs from scrambler grenades
var int NanoVirusTicks;                                                         //RSD: For stupid hack to display the client message
var bool bNanoVirusSentMessage;                                                 //RSD: For stupid hack to display the client message
var localized String NanoVirusLabel;                                            //RSD: For deactivating augs from scrambler grenades
var globalconfig bool bRestrictedMetabolism;                                    //RSD: Enables restricted eating and halved withdrawal delay

//SARGE: Allow blocking the next weapon selection. Used by dialog number keys feature.
var float fBlockBeltSelection;

//GAMEPLAY MODIFIERS

/*var travel bool bRandomizeCratesGeneralTool;
var travel bool bRandomizeCratesGeneralWearable;
var travel bool bRandomizeCratesGeneralPickup;
var travel bool bRandomizeCratesMedicalMain;
var travel bool bRandomizeCratesAmmoPistol;
var travel bool bRandomizeCratesAmmoRifle;
var travel bool bRandomizeCratesAmmoNonlethal;
var travel bool bRandomizeCratesAmmoRobot;
var travel bool bRandomizeCratesAmmoHeavy;
var travel bool bRandomizeCratesAmmoExplosive;
var travel bool bRandomizeModsHandling;
var travel bool bRandomizeModsAmmo;
var travel bool bRandomizeModsBallistics;
var travel bool bRandomizeModsAttachments;*/
var travel bool bRandomizeCrates;
var travel bool bRandomizeMods;
var travel bool bRandomizeAugs;
var travel bool bRandomizeEnemies;
var travel bool bRestrictedSaving;												//Sarge: This used to be tied to hardcore, now it's a config option
var travel int iNoKeypadCheese;													//Sarge: 1 = Prevent using keycodes that we don't know, 2 = additionally prevent plot skips, 3 = additionally obscure keypad code length.
var travel int seed;                                                            //Sarge: When using randomisation playthrough modifiers, this is our generated seed for the playthrough, to prevent autosave abuse and the like
var travel int augOrderNums[21];                                                //RSD: New aug can order for scrambling
var const augBinary augOrderList[21];                                           //RSD: List of all aug cans in the game in order (to be scrambled)
var travel bool bAddictionSystem;

var travel bool bMoreLDDPNPCs;

var travel bool bDisableConsoleAccess;                                          //SARGE: Disable console access via a modifier.

var travel bool bWeaponRequirementsMatter;                                      //Sarge: Using certain weapons requires skill investments.

//END GAMEPLAY MODIFIERS

//Autosave Stuff
var travel float autosaveRestrictTimer;                                         //Sarge: Current time left before we're allowed to autosave again.
var const float autosaveRestrictTimerDefault;                                   //Sarge: Timer for autosaves.
var travel bool bResetAutosaveTimer;                                            //Sarge: This is necessary because our timer isn't set properly during the same frame as saving, for some reason.

//Menu Overhaul stuff
var localized String RechargedPointLabel;
var localized String RechargedPointsLabel;

var travel AddictionSystem AddictionManager;
var travel PerkSystem PerkManager;
var travel RandomTable Randomizer;
var travel FontManager FontManager;
var DecalManager DecalManager;

const DRUG_TOBACCO = 0;
const DRUG_ALCOHOL = 1;
const DRUG_CRACK = 2;

var travel bool bLastRun;                                                       //Sarge: Stores our last running state

var bool bUsingComputer;                                                        //SARGE: Are we currently using a computer? Set so that we can restrict input while using one
var bool bBlockNextFire;                                                        //SARGE: Set to TRUE to block the next weapon firing attempt. Used when blowing up the spy drone.

//Sarge: Allow Enhanced Weapon Offsets
var globalconfig bool bEnhancedWeaponOffsets; 									//Sarge: Allow using enhanced weapon offsets

//Sarge: Dialog Settings
var globalconfig bool bNumberedDialog;                                          //Sarge: Shows numbers in the dialog window and allows selecting topics with the number keys
var globalconfig bool bCreditsInDialog;                                         //Sarge: Shows credits in the dialog window
var globalconfig bool bDialogHUDColors;                                         //Sarge: Use HUD Theme Colors in the Dialog window

//SARGE: Aug Wheel Settings
//var globalconfig bool bAdvancedAugWheel;                                        //Sarge: Allow manually assigning augmentations to the aug wheel, rather than auto-assigning all of them.
var globalconfig bool bQuickAugWheel;                                           //Sarge: Instantly enable/disable augs when closing the menu over the selected aug, otherwise require a mouse click.
var globalconfig bool bAugWheelDisableAll;                                      //Sarge: Show the Disable All button on the Aug Wheel
var globalconfig bool bAugWheelFreeCursor;                                      //Sarge: Allow free cursor movement in the augmentation wheel
var globalconfig bool bAugWheelRememberCursor;                                  //Sarge: Remember the cursor position in the Aug Wheel, otherwise it will be reset to the center position

var globalconfig bool bBeltShowModified;                                        //SARGE: Shows a "+" in the belt for modified weapons.

var globalconfig bool bTrickReloading;											//Sarge: Allow reloading with a full clip.

var globalconfig bool bFemaleHandsAlways;                                      //SARGE: If true, use the Female hands on male JC. Goth JC with nail polish?

var globalconfig bool bShowDataCubeRead;                                      //SARGE: If true, darken the screens on Data Cubes when they have been read.

var globalconfig int iAllowCombatMusic;                                        //SARGE: Enable/Disable combat music, or make it require 2 enemies

//Decline Everything
var travel DeclinedItemsManager declinedItemsManager;                          //SARGE: Holds declined items.
var globalconfig bool bSmartDecline;                                            //SARGE: Allow not declining items when holding the walk/run key
var localized string msgDeclinedPickup;                                        //SARGE: Declined message

//Crosshair Settings
var globalconfig bool bFullAccuracyCrosshair;                                   //SARGE: If false, disable the "Accuracy Crosshairs" when at 100% accuracy

var globalconfig bool bAlwaysShowBloom;                                         //SARGE: Always show weapon bloom

var globalconfig bool bShowEnergyBarPercentages;                                //SARGE: If true, show the oxygen and bioenergy percentages below the bars.

//Drone View Switcher
var globalconfig bool bBigDroneView;                                            //SARGE: Whether or not Drone view should take up the whole screen with the player view in the window, or not.

var localized string EnergyCantReserve;                                         //SARGE: Message when we don't have enough energy to reserve for a togglable augmentation

var globalconfig bool bSimpleAugSystem;                                         //SARGE: Simplifies the Aug screen by merging Auto and Toggle augs into one "type". Doesn't change gameplay in any way.

//Remove Aug Hum Sounds
var globalconfig bool bQuietAugs;                                               //SARGE: If enabled, augmentations won't play the "hum" sound while active

//Colour Theme Manager
var globalconfig String MenuThemeNameGMDX;
var globalconfig String HUDThemeNameGMDX;

//Misc Strings
var localized String DuplicateNanoKey;

//Cat/Dog protector
var globalconfig bool bStompDomesticAnimals;                                    //SARGE: If disabled, we can't stomp cats or dogs anymore. Adopt a cute animal today!
var globalconfig bool bStompVacbots;                                            //SARGE: If disabled, we can't stomp vac-bots anymore.


//Killswitch Engaged
var travel bool bRealKillswitch;                                                        //SARGE: Playthrough Modifier for a real killswitch
var travel float killswitchTimer;                                                       //SARGE: Killswitch timer in seconds.

//Music Stuff
var transient string currentSong;                                                 //SARGE: The "Song" variable is notoriously unreliable...
var transient byte currentSection;                                              //SARGE: We need to track this for conversations/combat/etc
var globalconfig int bEnhancedMusicSystem;                                             //SARGE: Should the music system be a bit smarter about playing tracks?

//SARGE: Autoswitch to Health screen when installing the last augmentation at a med bot.
var globalconfig bool bMedbotAutoswitch;

//SARGE: Minimise Targeting Window
var travel bool bMinimiseTargetingWindow;

//SARGE: Enhanced Lip Sync
var globalconfig int iEnhancedLipSync; //0 = disabled, 1 = nice and smooth, 2 = intentionally chunky
var globalconfig bool bEnableBlinking; //Allows characters to blink

//SARGE: Randomised Death/Pain Sounds
var globalconfig int iDeathSoundMode; //0 = vanilla sounds, 1 = preset GMDX sounds, 2 = random sounds.

//SARGE: Bigger Belt. Inspired by Revisions one, but less sucky.
var globalconfig bool bBiggerBelt;

//SARGE: Right-Click Selection for Picks and Tools. Inspired by similar feature from Revision, but less sucky.
var globalconfig bool bRightClickToolSelection;


var globalconfig int iPersistentDebris;                               //SARGE: Fragments, Decals, etc, last forever. Probably really horrible for performance!


//SARGE: Decal Handling
var transient bool bCreatingDecals;                                     //SARGE: Stores if we're making decals right now.
var transient int currentDecalBatch;                                    //SARGE: Current decal batch number.

//////////END GMDX

// OUTFIT STUFF
var travel OutfitManagerBase outfitManager;
var globalconfig string unlockedOutfits[255];

// native Functions
native(1099) final function string GetDeusExVersion();
native(2100) final function ConBindEvents();
native(3001) final function name SetBoolFlagFromString(String flagNameString, bool bValue);
native(3002) final function ConHistory CreateHistoryObject();
native(3003) final function ConHistoryEvent CreateHistoryEvent();
native(3010) final function DeusExLog CreateLogObject();
native(3011) final function SaveGame(int saveIndex, optional String saveDesc);
native(3012) final function DeleteSaveGameFiles(optional String saveDirectory);
native(3013) final function GameDirectory CreateGameDirectoryObject();
native(3014) final function DataVaultImageNote CreateDataVaultImageNoteObject();
native(3015) final function DumpLocation CreateDumpLocationObject();
native(3016) final function UnloadTexture(Texture texture);
//native 3017 taken by particleiterator.

//
// network replication
//
replication
{
	// server to client
	reliable if ((Role == ROLE_Authority) && (bNetOwner))
		AugmentationSystem, SkillSystem, SkillPointsTotal, SkillPointsAvail, inHand, inHandPending, KeyRing, Energy,
		  bSpyDroneActive, DXGame, bBuySkills, drugEffectTimer, killProfile;

	reliable if (Role == ROLE_Authority)
	   ShieldStatus, RunSilentValue, aDrone, NintendoImmunityTimeLeft;

	// client to server
	reliable if (Role < ROLE_Authority)
		BarkManager, FrobTarget, AugPrefs, bCanLean, curLeanDist, prevLeanDist,
		bInHandTransition, bForceDuck, FloorMaterial, WallMaterial, WallNormal, swimTimer, swimDuration;

	// Functions the client can call
	reliable if (Role < ROLE_Authority)
		DoFrob, ParseLeftClick, ParseRightClick, ReloadWeapon, PlaceItemInSlot, RemoveItemFromSlot, ClearInventorySlots,
	  SetInvSlots, FindInventorySlot, ActivateBelt, DropItem, SetInHand, AugAdd, ExtinguishFire, CatchFire,
	  AllEnergy, ClearPosition, ClearBelt, AddObjectToBelt, RemoveObjectFromBelt, TeamSay,
	  KeypadRunUntriggers, KeypadRunEvents, KeypadToggleLocks, ReceiveFirstOptionSync, ReceiveSecondOptionSync,CreateDrone, MoveDrone,
	  CloseComputerScreen, SetComputerHackTime, UpdateCameraRotation, ToggleCameraState,
	  SetTurretTrackMode, SetTurretState, NewMultiplayerMatch, PopHealth, ServerUpdateLean, BuySkills, PutInHand,
	  MakeCameraAlly, PunishDetection, ServerSetAutoReload, FailRootWindowCheck, FailConsoleCheck, ClientPossessed;

	// Unreliable functions the client can call
	unreliable if (Role < ROLE_Authority)
	  MaintainEnergy, UpdateTranslucency;

	// Functions the server calls in client
	reliable if ((Role == ROLE_Authority) && (bNetOwner))
	  UpdateAugmentationDisplayStatus, AddAugmentationDisplay, RemoveAugmentationDisplay, ClearAugmentationDisplay, ShowHud,
		ActivateKeyPadWindow, SetDamagePercent, SetServerTimeDiff, ClientTurnOffScores;

	reliable if (Role == ROLE_Authority)
	  InvokeComputerScreen, ClientDeath, AddChargedDisplay, RemoveChargedDisplay, MultiplayerDeathMsg, MultiplayerNotifyMsg,
	  BuySkillSound, ShowMultiplayerWin, ForceDroneOff ,AddDamageDisplay, ClientSpawnHits, CloseThisComputer, ClientPlayAnimation, ClientSpawnProjectile, LocalLog,
	  VerifyRootWindow, VerifyConsole, ForceDisconnect;

}

exec function cheat()
{
	if (bHardCoreMode) bCheatsEnabled = false;
	else bCheatsEnabled = !bCheatsEnabled;

}

//Render the player and hide the hud.
//These are only necessary using the "full screen drone view" setting
function ConfigBigDroneView(bool droneView)
{
    local DeusExRootWindow root;

    if (!bBigDroneView)
        return;

    root = DeusExRootWindow(rootWindow);

    if (droneView)
    {
        /*
        //This breaks horribly, we need to hide the individual elements instead.
        if (root != None)
            root.hud.hide();
        */
        bBehindView=true;
    }
    else
    {
        bBehindView=false;
        /*
        if (root != None)
            root.hud.show();
        */
    }
}

//Handle Crouch Toggle
function HandleCrouchToggle()
{
    //SARGE: Don't let us toggle crouch while using the drone
    if (bSpyDroneActive && !bSpyDroneSet)
        return;

    if (!bToggleCrouch)
    {
        bCrouchOn = false;
        return;
    }

    if (!bIsCrouching)
        bToggledCrouch = false;

    if (bCrouchOn && bIsCrouching && !bToggledCrouch)
    {
        bCrouchOn = false;
        bToggledCrouch = true;
    }
    else if (!bCrouchOn && bIsCrouching && !bToggledCrouch)
    {
        bCrouchOn = true;
        bToggledCrouch = true;
    }
}

//Return if the character is crouching
function bool IsCrouching()
{
    return bCrouchOn || bForceDuck || bIsCrouching || bCrouchHack || IsInState('PlayerSwimming');
}

//set our crouch state to a certain value
function SetCrouch(bool crouch, optional bool setForce)
{
    bIsCrouching = crouch;
    bDuck = int(crouch);
    bCrouchOn = crouch;
    if (setForce)
        bForceDuck = crouch;
}


// ----------------------------------------------------------------------
// ClientMessage
// Copied over from PlayerPawnExt
// Sarge: Extended to not show blank messages
// ----------------------------------------------------------------------

function ClientMessage(coerce string msg, optional Name type, optional bool bBeep)
{
    if (msg == "")
        return;

    Super.ClientMessage(msg,type,bBeep);
}

// ----------------------------------------------------------------------
// AssignSecondary
// Sarge: Now needed because we need to fix up our charged item display if it's out of date
// ----------------------------------------------------------------------

function AssignSecondary(Inventory item)
{
    if (assignedWeapon.isA('ChargedPickup'))
        RemoveChargedDisplay(ChargedPickup(assignedWeapon));

    assignedWeapon = item;

    RefreshChargedPickups();
}

static function bool IsHDTPInstalled()
{
    return class'DeusExPlayer'.default.bHDTPInstalled && default.bHDTPEnabled;
}

static function bool IsHDTP()
{
    return IsHDTPInstalled() && default.iHDTPModelToggle > 0;
}

function UpdateHDTPsettings()
{
	local mesh tempmesh;
	local texture temptex;
	local int i;

	if(IsHDTP()) //lol recursive
	{
		if(HDTPMesh != "")
		{
			tempmesh = lodmesh(dynamicloadobject(HDTPMesh,class'mesh',true));
			if(tempmesh != none)
			{
				mesh = tempmesh;
				for(i=0;i<=7;i++)
				{
					if(HDTPMeshtex[i] != "")
					{
						temptex = texture(dynamicloadobject(HDTPMeshtex[i],class'texture',true));
						if(temptex != none)
							multiskins[i] = temptex;
					}
				}
			}
		}
	}
	else
	{
		mesh = default.mesh;
		for(i=0; i<=7;i++)
		{
			multiskins[i]=default.multiskins[i];
		}
	}
}

function setupDifficultyMod() //CyberP: scale things based on difficulty. To find all things modified by
{                             //CyberP: difficulty level in GMDX, search CombatDifficulty & bHardCoreMode.
local ScriptedPawn P;         //CyberP: WARNING: is called every login.
local ThrownProjectile TP;
local AutoTurret       T;
local SecurityCamera   SC;
local DeusExWeapon     WP;
local DeusExAmmo       AM;
local DeusExMover      MV;
local Keypad           KP;
local Medkit           MK;
local BioelectricCell  BC;
local inventory        anItem;
local int              i;
local Containers       CO;
local actor            AR;
local DeusExLevelInfo dxInfo;                                                   //RSD: Added
local name flagName;                                                            //RSD: Added
local bool bFirstLevelLoad;                                                     //RSD: Added
local AlarmUnit        AU;                                                      //RSD: Added
local Perk perkDoorsman;

//log("bHardCoreMode =" @bHardCoreMode);
//log("CombatDifficulty =" @CombatDifficulty);

     dxInfo=GetLevelInfo();
     flagName = rootWindow.StringToName("M"$Caps(dxInfo.mapName)$"_NotFirstTime");
   	 bFirstLevelLoad = !flagBase.GetBool(flagName);                             //RSD: Tells us if this is the first time loading a map
//log("flagName =" @flagName);
//log("bFirstLevelLoad =" @bFirstLevelLoad);

     bStunted = False; //CyberP: failsafe
     if (CarriedDecoration != None && CarriedDecoration.IsA('Barrel1'))
         Barrel1(CarriedDecoration).StupidBugfix();
     ForEach AllActors(class'ScriptedPawn', P)
     {
      if (P.bHardcoreOnly == True && bHardCoreMode == False && bHardcoreFilterOption == False)  //CyberP: remove this pawn if we are not hardcore
          P.Destroy();
      else if (P.bHardcoreRemove && (bHardCoreMode == True || bHardcoreFilterOption == True))
          P.Destroy();
      P.DifficultyMod(CombatDifficulty,bHardCoreMode,bExtraHardcore,bFirstLevelLoad); //RSD: Replaced ALL NPC stat modulation with a compact function implementation
    }

    if (bHardCoreMode == False)
    {
        ForEach AllActors(class'ThrownProjectile', TP)
        {
       	    if (TP.bNoHardcoreFilter == True) //CyberP: destroy this bomb if we are not hardcore
	       	    TP.Destroy();
            else
                TP.proxRadius=156.000000;  //Also lower radius if not hardcore
        }
        ForEach AllActors(class'Containers', CO)
        {
           if (CO.bLowDifficultyOnly && CombatDifficulty >= 3.0)
           {
              CO.DrawScale = 0.00001;
              CO.SetCollision(false,false,false);
              CO.SetCollisionSize(0,0);
	       }
        }
        if (SkillSystem != None && CombatDifficulty <= 1)
        {
            SkillSystem.UpdateSkillLevelValues(class'SkillTech');               //RSD: This function now BUFFS the lockpicking/electronics skill for Easy
            SkillSystem.UpdateSkillLevelValues(class'SkillLockpicking');        //RSD: From 10/15/25/50 -> 10/25/40/75
        }

    }
    else
    {
       ForEach AllActors(class'DeusExAmmo', AM)
       {
           if (AM.Owner == None && !AM.bLooted)                                 //RSD: Added !bLooted so we don't add free ammo to containers we've partially looted
           {
        	/*if (AM.IsA('AmmoDartTaser'))
	         AM.AmmoAmount = 3;                                                 //RSD: Was 1, now 3
	        else */if (AM.IsA('Ammo20mm'))
	         AM.AmmoAmount = 2;
	        else if (AM.IsA('AmmoRocket'))
             AM.AmmoAmount = 3;
           }
       }
       ForEach AllActors(class'Containers', CO)
       {
           if (CO.bLowDifficultyOnly || CO.bHardcoreRemoveIt)
           {
              CO.DrawScale = 0.00001;
              CO.SetCollision(false,false,false);
              CO.SetCollisionSize(0,0);
	       }
       }
       if (SkillSystem != None)
       {
        SkillSystem.UpdateSkillLevelValues(class'SkillTech');                   //RSD: This function still nerfs lockpicks/multitools on Hardcore, values altered
        SkillSystem.UpdateSkillLevelValues(class'SkillLockpicking');            //RSD: used to give lockpicks values of 5/10/15/50, now 5/10/20/50
       }
    }

    if (PerkManager.GetPerkWithClass(class'DeusEx.PerkCombatMedicsBag').bPerkObtained == true)
    {
    ForEach AllActors(class'Medkit', MK)
    {
		       MK.MaxCopies = 20;
    }
    ForEach AllActors(class'BioelectricCell', BC)
    {
		       BC.MaxCopies = 25;
    }
    }

	perkDoorsman = PerkManager.GetPerkWithClass(class'DeusEx.PerkDoorsman');

     ForEach AllActors(class'DeusExMover', MV)
     {
         if (!MV.bPerkApplied && perkDoorsman.bPerkObtained == true)
         {
		       MV.bPerkApplied = True;
		       MV.minDamageThreshold -= perkDoorsman.PerkValue;
		       if (MV.minDamageThreshold <= 0)
                MV.minDamageThreshold = 1;
		 }
		 if (MV.lockStrength == 0.050000)
		     MV.lockStrength = 0.100000;
     }

    //if (bLaserRifle == False)
    //{
    //ForEach AllActors(class'DeusExWeapon', WP)
    //{
    //    	if (WP.ItemName == "Laser Rifle") //CyberP: destroy it
	//        	WP.Destroy();
    //}
    //}

    //if (bUSP == False)
    //{
    ForEach AllActors(class'DeusExWeapon', WP)
    {
          if (WP.Owner == None)
          {
	         if (WP.default.ItemName == "Laser Rifle") //CyberP: destroy it
	        	WP.Destroy();
             if (WP.default.ItemName == "USP.10")
                WP.Destroy();
             if (WP.default.ItemName == "UMP7.62c")
	        	WP.Destroy();
          }
          if (bHardCoreMode && bExtraHardcore && Owner != None && Owner == self)
              WP.BaseAccuracy = WP.default.BaseAccuracy + 0.2;
    }
    //}

    ForEach AllActors(class'AutoTurret', T)
    {
        	if (CombatDifficulty < 3.0)
	        {
	        	if (T.gun.hackStrength > 0.25)                                  //RSD: limiting hack strength with failsafe
	        	   T.gun.hackStrength = 0.250000;
                T.maxRange=1400;
	            T.default.maxRange=1400;
            }
            else
            {
                if (T.gun.hackStrength > 0.50)                                  //RSD: limiting hack strength with failsafe
	        	   T.gun.hackStrength = 0.500000;
                T.maxRange=4000;
	            T.default.maxRange=4000;
	            if (bHardCoreMode && bExtraHardcore)
	                T.pitchLimit = 31000.0;
	        }
    }

    ForEach AllActors(class'SecurityCamera', SC)
    {
        	if (CombatDifficulty < 3.0)
	        {
	            if (SC.hackStrength > 0.1)
	        	   SC.hackStrength = 0.100000;
	        	if (SC.HitPoints > 40)
                   SC.HitPoints = 40;
	            SC.cameraRange = 1024;
	            SC.default.cameraRange = 1024;
	            if (SC.swingPeriod < 9.0)
	              SC.swingPeriod+=3.0;
            }
            else if (bHardCoreMode)
            {
                //SC.hackStrength=0.200000;                                     //RSD: This was commented for some reason
                if (SC.hackStrength > 0.2)                                      //RSD: Reinstating but with failsafe logic
	        	   SC.hackStrength = 0.200000;
                if (SC.cameraFOV<6144)
                    SC.cameraFOV=6144;
            }
            else
            {
            //    SC.hackStrength=0.150000;                                     //RSD: This was commented for some reason
                if (SC.hackStrength > 0.15)                                     //RSD: Reinstating but with failsafe logic
	        	   SC.hackStrength = 0.150000;
            }

            if ((bA51Camera || bHardcoreMode) && SC.minDamageThreshold != 70)
            {
                if (!SC.bDiffProperties)
                {
                if (SC.hackStrength>0.300000)
                    SC.hackStrength=0.300000;
                if (SC.HitPoints>60)
                    SC.HitPoints=60;
                SC.minDamageThreshold=70;
                SC.bDiffProperties = True;
                }
            }
    }
    ForEach AllActors(class'AlarmUnit', AU)                                     //RSD: Alarm Units are 5% hack strength now
    {
        if (AU.hackStrength > 0.050000)
            AU.hackStrength = 0.050000;
    }
}

// ----------------------------------------------------------------------
// PostBeginPlay()
//
// set up the augmentation and skill systems
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	local DeusExLevelInfo info;
	local int levelInfoCount;
    local float mult;

	Super.PostBeginPlay();

	class'DeusExPlayer'.default.DefaultFOV=DefaultFOV;
	class'DeusExPlayer'.default.DesiredFOV=DesiredFOV;

	// Check to make sure there's only *ONE* DeusExLevelInfo and
	// go fucking *BOOM* if we find more than one.

	levelInfoCount = 0;
	foreach AllActors(class'DeusExLevelInfo', info)
		levelInfoCount++;

	Assert(levelInfoCount <= 1);

	// give us a shadow
	if (Level.Netmode == NM_Standalone)
	  CreateShadow();

	InitializeSubSystems();
	DXGame = Level.Game;
	ShieldStatus = SS_Off;
	ServerTimeLastRefresh = 0;
	// Safeguard so no cheats in multiplayer
	if ( Level.NetMode != NM_Standalone )
		bCheatsEnabled = False;
	HDTP();

	RefreshLeanKeys();
    RefreshMantleKey();
    RefreshAugWheelKey();                                                       //RSD: Hold aug wheel

    //RSD: log item distribution on map load
    //logItemsInCrates();
    //logItemsInWorld();
    //logItemsInInventories();
}

exec function logItemsInCrates()                                                //RSD: To output crate contents to the log on map startup
{
    local Containers CO;
    local int i;

    log("BEGIN ITEMS IN CRATES");
    log("MAPNAME:" $ getLevelInfo().mapName);
    ForEach AllActors(class'Containers', CO)
    {
    	if (CO.IsA('CrateBreakableMedCombat') || CO.IsA('CrateBreakableMedGeneral') || CO.IsA('CrateBreakableMedMedical'))
        	log(CO.contents);                                                   //RSD: Ignores content2 and content3, be warned
    }
    log("END ITEMS IN CRATES");
}

exec function logItemsInWorld()                                                 //RSD: To output in-world items to the log on map startup
{
    local Inventory I;

    log("BEGIN ITEMS IN WORLD");
    log("MAPNAME:" $ getLevelInfo().mapName);
    ForEach AllActors(class'Inventory', I)
    {
    	log(I.Class);
    }
    log("END ITEMS IN WORLD");
}

exec function logItemsInInventories()                                           //RSD: To output NPC inventory items to the log on map startup
{
    local ScriptedPawn SP;
    local DeusExCarcass DXC;
    local int i;

    log("BEGIN ITEMS IN INVENTORIES");
    log("MAPNAME:" $ getLevelInfo().mapName);
    ForEach AllActors(class'ScriptedPawn', SP)
    {
    	for (i=0;i<8;i++)
			if (SP.InitialInventory[i].Inventory != None)
            	log(SP.InitialInventory[i].Inventory);
    }
    ForEach AllActors(class'DeusExCarcass', DXC)
    {
    	for (i=0;i<8;i++)
			if (DXC.InitialInventory[i].Inventory != None)
            	log(DXC.InitialInventory[i].Inventory);
    }
    log("END ITEMS IN INVENTORIES");
}

function ServerSetAutoReload( bool bAuto )
{
	bAutoReload = bAuto;
}

// ----------------------------------------------------------------------

function SetServerTimeDiff( float sTime )
{
	ServerTimeDiff = (sTime - Level.Timeseconds);
}

// ----------------------------------------------------------------------
// PostNetBeginPlay()
//
// Take care of the theme manager
// ----------------------------------------------------------------------

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	if (Role == ROLE_SimulatedProxy)
	{
	  DrawShield();
	  CreatePlayerTracker();
		if ( NintendoImmunityTimeLeft > 0.0 )
			DrawInvulnShield();
	  return;
	}

	//DEUS_EX AMSD In multiplayer, we need to do this for our local theme manager, since
	//PostBeginPlay isn't called to set these up, and the Thememanager can be local, it
	//doesn't have to sync with the server.
	if (ThemeManager == NONE)
	{
		CreateColorThemeManager();
		ThemeManager.SetOwner(self);
		ThemeManager.SetCurrentHUDColorTheme(ThemeManager.GetFirstTheme(1));
		ThemeManager.SetCurrentMenuColorTheme(ThemeManager.GetFirstTheme(0));
		ThemeManager.SetMenuThemeByName(MenuThemeNameGMDX);
		ThemeManager.SetHUDThemeByName(HUDThemeNameGMDX);
		if (DeusExRootWindow(rootWindow) != None)
		   DeusExRootWindow(rootWindow).ChangeStyle();
	}
	ReceiveFirstOptionSync(AugPrefs[0], AugPrefs[1], AugPrefs[2], AugPrefs[3], AugPrefs[4]);
	ReceiveSecondOptionSync(AugPrefs[5], AugPrefs[6], AugPrefs[7], AugPrefs[8]);
	ShieldStatus = SS_Off;
	bCheatsEnabled = False;

	 ServerSetAutoReload( bAutoReload );
}

function SetupAddictionManager()
{
	// install the Addiction Manager if not found
	if (AddictionManager == None)
    {
        //ClientMessage("Make new Addiction System");
	    AddictionManager = new(Self) class'AddictionSystem';
    }
    AddictionManager.SetPlayer(Self);

}

function SetupDecalManager()
{
	// install the Decal Manager if not found
	if (DecalManager != None)
    {
        //clientmessage("DecalManager Setup Called");
	    //DecalManager = new(Self) class'DecalManager';
        DecalManager.Setup(self);
        bCreatingDecals = true;
        //DecalManager.RecreateDecals();
    }
}

function SetupPerkManager()
{
	// install the Perk Manager if not found
	if (PerkManager == None)
    {
        //ClientMessage("Make new Perk System");
	    PerkManager = new(Self) class'PerkSystem';
    }
    PerkManager.InitializePerks(Self);
}

function SetupFontManager()
{
	// install the Perk Manager if not found
	if (FontManager == None)
    {
        //ClientMessage("Make new Font System");
	    FontManager = new(Self) class'FontManager';
    }
}

function SetupRandomizer()
{
	// install the Addiction Manager if not found
	if (Randomizer == None)
    {
        //ClientMessage("Make new Randomiser");
	    Randomizer = new(Self) class'RandomTable';
    }

    //If no seed is set, generate a new one
    if (seed == -1)
    {
        seed = Rand(10000);
        //ClientMessage("Generating new playthrough seed: " $ seed);
    }
}

// ----------------------------------------------------------------------
// InitializeSubSystems()
// ----------------------------------------------------------------------

function InitializeSubSystems()
{
	// Spawn the BarkManager
	if (BarkManager == None)
		BarkManager = Spawn(class'BarkManager', Self);

	// Spawn the Color Manager
	CreateColorThemeManager();
	ThemeManager.SetOwner(self);

    if (DeclinedItemsManager == None)
    {
        DeclinedItemsManager = Spawn(class'DeclinedItemsManager', Self);
        DeclinedItemsManager.SetOwner(Self);
    }

	// install the augmentation system if not found
	if (AugmentationSystem == None)
	{
		AugmentationSystem = Spawn(class'AugmentationManager', Self);
		AugmentationSystem.CreateAugmentations(Self);
		AugmentationSystem.AddDefaultAugmentations();
		AugmentationSystem.SetOwner(Self);
		AugmentationSystem.Setup();
	}
	else
	{
		AugmentationSystem.SetPlayer(Self);
		AugmentationSystem.SetOwner(Self);
		AugmentationSystem.Setup();
	}

	// install the skill system if not found
	if (SkillSystem == None)
	{
		SkillSystem = Spawn(class'SkillManager', Self);
		SkillSystem.CreateSkills(Self);
	}
	else
	{
		SkillSystem.SetPlayer(Self);
	}

	if ((Level.Netmode == NM_Standalone) || (!bBeltIsMPInventory))
	{
	  // Give the player a keyring
	  CreateKeyRing();
	}

    //Setup player subcomponents
    SetupRandomizer();
    SetupAddictionManager();
	SetupPerkManager();
	SetupFontManager();
	SetupDecalManager();
}

//SARGE: Helper function to get the count of an item type
function int GetInventoryCount(Name item)
{
	local int count;
	local Inventory anItem;
	
	anItem = Inventory;
	count = 0;

	while(anItem != None)
	{
		if (anItem.IsA(item))
        {
            if (anItem.IsA('DeusExPickup'))
                count += DeusExPickup(anItem).NumCopies;
            else
    			count++;
        }

		anItem = anItem.Inventory;
	}
	
	return count;
}

// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{


	Super.PostPostBeginPlay();

	// Bind any conversation events to this DeusExPlayer
	ConBindEvents();

	// Restore colors that the user selected (as opposed to those
	// stored in the savegame)
	ThemeManager.SetMenuThemeByName(MenuThemeNameGMDX);
	ThemeManager.SetHUDThemeByName(HUDThemeNameGMDX);





	if ((Level.NetMode != NM_Standalone) && ( killProfile == None ))
		killProfile = Spawn(class'KillerProfile', Self);
}

// ----------------------------------------------------------------------
// PreTravel() - Called when a ClientTravel is about to happen
// ----------------------------------------------------------------------

function PreTravel()
{
    local TechGoggles tech;
    local int i;                                                                //RSD
    local SpyDrone SD;
	// Set a flag designating that we're traveling,
	// so MissionScript can check and not call FirstFrame() for this map.

//   log("MYCHK:PreTravel:"@self);

	flagBase.SetBool('PlayerTraveling', True, True, 0);
    drugEffectTimer = 0;
	SaveSkillPoints();

    if (AugmentationSystem != None && AugmentationSystem.GetAugLevelValue(class'AugVision') != -1.0)
        AugmentationSystem.DeactivateAll();
    else if (UsingChargedPickup(class'TechGoggles'))
        foreach AllActors(class'TechGoggles', tech)
            if ((tech.Owner == Self) && tech.bActive)
                tech.Activate();

	if (dataLinkPlay != None)
		dataLinkPlay.AbortAndSaveHistory();

	// If the player is burning (Fire! Fire!), extinguish him
	// before the map transition.  This is done to fix stuff
	// that's fucked up.
	ExtinguishFire();
	if (bRadialAugMenuVisible) ToggleRadialAugMenu();
	if (inHand != none && inHand.IsA('DeusExWeapon'))
		DeusExWeapon(inHand).LaserOff(true);                                    //RSD: Otherwise dots will remain on the map
    ForceDroneOff();                                                            //RSD: Since we can move on standby, shut drone off
    ConsoleCommand("set DeusExCarcass bRandomModFix" @ bRandomizeMods);         //RSD: Stupid config-level hack since PostBeginPlay() can't access player pawn in DeusExCarcass.uc
    
    //SARGE: Store all the decals
    if (DecalManager != None && iPersistentDebris > 0)
        DecalManager.PopulateDecalsList();

	foreach AllActors(class'SpyDrone',SD)                                       //RSD: Destroy all spy drones so we can't activate disabled drones on map transition
		SD.Destroy();
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

event TravelPostAccept()
{
	local DeusExLevelInfo info;
	local MissionScript scr;
	local bool bScriptRunning;
	local InterpolationPoint I;
	local SavePoint SP;
	local rotator rofs;
    local int j;                                                                //RSD

	//local WeaponGEPGun gepTest;
	local vector ofst;

    //Update HUD
    UpdateHUD();

	Super.TravelPostAccept();

    //Setup player subcomponents
    SetupRandomizer();
    SetupAddictionManager();
	SetupPerkManager();
    SetupFontManager();
	SetupDecalManager();

	// reset the keyboard
	ResetKeyboard();

    //Reset Crosshair
    UpdateCrosshair();

	RefreshLeanKeys();
    RefreshMantleKey();
    RefreshAugWheelKey();                                                       //RSD: Hold aug wheel
	info = GetLevelInfo();

//   log("MYCHK:PostTravel: ,"@info.Name);

	if (info != None)
	{
		// hack for the DX.dx logo/splash level
		if (info.MissionNumber == -2)
		{
			foreach AllActors(class 'InterpolationPoint', I, 'IntroCam')
			{
				if (I.Position == 1)
				{
					SetCollision(False, False, False);
					bCollideWorld = False;
					Target = I;
					SetPhysics(PHYS_Interpolating);
					PhysRate = 1.0;
					PhysAlpha = 0.0;
					bInterpolating = True;
					bStasis = False;
					ShowHud(False);
					PutInHand(None);
					GotoState('Interpolating');
					break;
				}
			}
			return;
		}

		// hack for the DXOnly.dx splash level
		if (info.MissionNumber == -1)
		{
			ShowHud(False);
			GotoState('Paralyzed');
			return;
		}
	}

	// Restore colors
	if (ThemeManager != None)
	{
		ThemeManager.SetMenuThemeByName(MenuThemeNameGMDX);
		ThemeManager.SetHUDThemeByName(HUDThemeNameGMDX);
	}

	// Make sure any charged pickups that were active
	// before travelling are still active.
	RefreshChargedPickups();

	// Make sure the Skills and Augmentation systems
	// are properly initialized and reset.

	RestoreSkillPoints();

	if (SkillSystem != None)
	{
		SkillSystem.SetPlayer(Self);
	}

	if (AugmentationSystem != None)
	{
		// set the player correctly
		AugmentationSystem.SetPlayer(Self);
		AugmentationSystem.Setup();
		AugmentationSystem.RefreshAugDisplay();
	}

	// Nuke any existing conversation
	if (conPlay != None)
		conPlay.TerminateConversation();

	HDTP();
	// Make sure any objects that care abou the PlayerSkin
	// are notified
	UpdatePlayerSkin();

	// If the player was carrying a decoration,
	// call TravelPostAccept() so it can initialize itself
	if (CarriedDecoration != None)
		CarriedDecoration.TravelPostAccept();

	// If the player was carrying a decoration, make sure
	// it's placed back in his hand (since the location
	// info won't properly travel)
	PutCarriedDecorationInHand();

	// Reset FOV
	SetFOVAngle(Default.DesiredFOV);

	// If the player had a scope view up, make sure it's
	// properly restore
	RestoreScopeView();

	// make sure the mission script has been spawned correctly
	if (info != None)
	{
		bScriptRunning = False;
		foreach AllActors(class'MissionScript', scr)
			bScriptRunning = True;

		if (!bScriptRunning)
			info.SpawnScript();
	}

	// make sure the player's eye height is correct
	BaseEyeHeight = CollisionHeight - (GetBaseEyeHeight() - Default.BaseEyeHeight);

	//GMDX

	foreach AllActors(class'SavePoint',SP)
	{
 	 if ((!bHardCoreMode && !bRestrictedSaving)||(SP.bUsedSavePoint))
		 SP.Destroy();
	}
	//ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness 1");

	if (bHardCoreMode)
	{
	  bCheatsEnabled=false;
	  bAutoReload=false;
	}

    setupDifficultyMod(); //CyberP: set difficulty modifiers
//set gep tracking
	if (RocketTarget==none)
	   RocketTarget=spawn(class'DeusEx.GEPDummyTarget');

	SetRocketWireControl();
	//end GMDX
}
//GMDX: set up mounted gep spawn, as no matter what i try it still draws it on spawn :/
function SpawnGEPmounted(bool mountIt)
{
	if (mountIt)
	{
		if ((Weapon!=none)&&(Weapon.IsA('WeaponGEPGun')))
		{
			GEPmounted=WeaponGEPGun(Weapon);
			GEPmounted.SetMount(self);
		} else
			log("ERROR: GEP gun in zoom but GEP not in hand");
	} else
	{
		GEPmounted.SetMount(none);
	  // GEPmounted=none;
	}
	/*if (GEPmounted!=none) return true;

	GEPmounted=spawn(class'WeaponGEPmounted',self,,Location,Rotation);
	if (GEPmounted!=none)
	{
	  GEPmounted.bHidden=true;//use this to invoke renderoverlays
	  GEPmounted.bHideWeapon=true;
	  GEPmounted.SetPhysics(PHYS_None);
 	  GEPmounted.SetMount(self);
	  return true;
	} else log("ERROR: could not spawn GEPmounted");//else
	  //bNoGEPmounted=true;
	return false;*/
}

function string retInfo()
{
 local DeusExLevelInfo inf;

 forEach AllActors(class'DeusExLevelInfo' ,inf)
 {
  if (inf.MissionLocation == "Secret MJ12 Facility")
       return "Location Unavailable";
  else if (inf.MissionLocation != "")
       return inf.MissionLocation;
  else
       return "Location Unavailable";
 }
}

//GMDX remove console from Hardcore mode >:]
exec function Say(string Msg )
{
	if (bDisableConsoleAccess || bExtraHardcore)
        return;
    else                                                                  //RSD: temporarily re-enable console for HC testing //SARGE: Made it a gameplay modifier
	    super.Say(Msg);
}

//SARGE: TODO: Add a proper console window.
exec function Type()
{
	if (bDisableConsoleAccess || bExtraHardcore)                         //RSD: temporarily re-enable console for HC testing //SARGE: Made it a gameplay modifier
        return;
    else
	  super.Type();
}

function Typing( bool bTyping )
{
	if (bDisableConsoleAccess || bExtraHardcore)                                                        //RSD: temporarily re-enable console for HC testing //SARGE: Made it a gameplay modifier
	    Player.Console.GotoState('');
	else
        super.Typing(bTyping);
}

/////

exec function HDTP(optional string s)
{
	local scriptedpawn P;
	local deusexcarcass C;
	local DeusExWeapon W;                                                       //RSD: Added for weapon model toggles
	local DeusExDecoration D;                                                   //SARGE: Added for object toggles
	local DeusExPickup PK;                                                      //SARGE: Added for object toggles
	local DeusExProjectile PR;                                                  //SARGE: Added for object toggles
	local DeusExAmmo AM;                                                        //SARGE: Added for object toggles
	local DeusExDecal DC;                                                        //SARGE: Added for object toggles
    
    //SARGE: Yes, using the class name is necessary. Statics are weird.
	class'DeusExPlayer'.default.bHDTPInstalled = class'HDTPLoader'.static.HDTPInstalled();
	
	foreach Allactors(Class'Scriptedpawn',P)
		P.UpdateHDTPSettings();
	foreach Allactors(Class'DeusexCarcass',C)
		C.UpdateHDTPsettings();
    foreach AllActors(Class'DeusExWeapon',W)                                    //RSD: Added for weapon model toggles
    	W.UpdateHDTPsettings();
    foreach AllActors(Class'DeusExPickup',PK)                                   //SARGE: Added for object toggles
    	PK.UpdateHDTPsettings();
    foreach AllActors(Class'DeusExDecoration',D)                                //SARGE: Added for object toggles
    	D.UpdateHDTPsettings();
    foreach AllActors(Class'DeusExProjectile',PR)                               //SARGE: Added for object toggles
    	PR.UpdateHDTPsettings();
    foreach AllActors(Class'DeusExAmmo',AM)                                     //SARGE: Added for object toggles
    	AM.UpdateHDTPsettings();
    //SARGE: These don't draw properly if we update them... What a shame!
    //It was a good feature, what a rotten way to die!
    /*
    foreach AllActors(Class'DeusExDecal',DC)                                     //SARGE: Added for object toggles
    	DC.UpdateHDTPsettings();
    */

	UpdateHDTPsettings();
}

// ----------------------------------------------------------------------
// Update Time Played
// ----------------------------------------------------------------------

final function UpdateTimePlayed(float deltaTime)
{
	saveTime += deltaTime;
}

// ----------------------------------------------------------------------
// RestoreScopeView()
// ----------------------------------------------------------------------

function RestoreScopeView()
{
	if (inHand != None)
	{
		if (inHand.IsA('Binoculars') && (inHand.bActive))
			Binoculars(inHand).RefreshScopeDisplay(Self, True);
		else if ((DeusExWeapon(inHand) != None) && (DeusExWeapon(inHand).bZoomed))
			DeusExWeapon(inHand).RefreshScopeDisplay(Self, True, True);
	}
}

// ----------------------------------------------------------------------
// RefreshChargedPickups()
// ----------------------------------------------------------------------

function RefreshChargedPickups()
{
	local ChargedPickup anItem;

	// Loop through all the ChargedPicksups and look for charged pickups
	// that are active.  If we find one, add to the user-interface.

	foreach AllActors(class'ChargedPickup', anItem)
	{
		if (anItem.Owner == Self)
		{
			// Make sure tech goggles display is refreshed
			if (anItem.IsA('TechGoggles') && anItem.IsActive())
				TechGoggles(anItem).UpdateHUDDisplay(Self);

            if ((anItem.IsActive() || assignedWeapon == anItem) && anItem.GetCurrentCharge() > 0)
    			AddChargedDisplay(anItem);
		}
	}
}

// ----------------------------------------------------------------------
// UpdatePlayerSkin()
// ----------------------------------------------------------------------

function UpdatePlayerSkin()
{
	local PaulDenton paul;
	local PaulDentonCarcass paulCarcass;
	local JCDentonMaleCarcass jcCarcass;
	local JCDouble jc;
	local DentonClone DC;

	// Paul Denton
	foreach AllActors(class'PaulDenton', paul)
		break;

	if (paul != None)
		paul.SetSkin(Self);

	// Paul Denton Carcass
	foreach AllActors(class'PaulDentonCarcass', paulCarcass)
		break;

	if (paulCarcass != None)
		paulCarcass.SetSkin(Self);

	// JC Denton Carcass
	foreach AllActors(class'JCDentonMaleCarcass', jcCarcass)
		break;

	if (jcCarcass != None)
		jcCarcass.SetSkin(Self);

	// JC's stunt double
	foreach AllActors(class'JCDouble', jc)
		break;

	//LDDP, 10/26/21: Reskin denton clone on the fly
	forEach AllActors(class'DentonClone', DC)
	{
		DC.SetSkin(Human(Self));
	}

	if (jc != None)
		jc.SetSkin(Self);
}


// ----------------------------------------------------------------------
// GetLevelInfo()
// ----------------------------------------------------------------------

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;


	foreach AllActors(class'DeusExLevelInfo', info)
		break;

//   log("MYCHK:LevelInfo: ,"@info.Name);

	return info;
}

//
// If player chose to dual map the F keys
//
exec function DualmapF3() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(0); }
exec function DualmapF4() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(1); }
exec function DualmapF5() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(2); }
exec function DualmapF6() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(3); }
exec function DualmapF7() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(4); }
exec function DualmapF8() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(5); }
exec function DualmapF9() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(6); }
exec function DualmapF10() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(7); }
exec function DualmapF11() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(8); }
exec function DualmapF12() { if ( AugmentationSystem != None) AugmentationSystem.ActivateAugByKey(9); }

//
// Team Say
//
exec function TeamSay( string Msg )
{
	local Pawn P;
	local String str;

	if (bHardCoreMode) return;

	if ( TeamDMGame(DXGame) == None )
	{
		Say(Msg);
		return;
	}

	str = PlayerReplicationInfo.PlayerName $ ": " $ Msg;

	if ( Role == ROLE_Authority )
		log( "TeamSay>" $ str );

	for( P=Level.PawnList; P!=None; P=P.nextPawn )
	{
		if( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
		{
			if ( P.IsA('DeusExPlayer') )
				DeusExPlayer(P).ClientMessage( str, 'TeamSay', true );
		}
	}
}

// ----------------------------------------------------------------------
// RestartLevel()
// ----------------------------------------------------------------------

exec function RestartLevel()
{
	ResetPlayer();
	Super.RestartLevel();
}

// ----------------------------------------------------------------------
// LoadGame()
// ----------------------------------------------------------------------

exec function LoadGame(int saveIndex)
{

//   log("MYCHK:LoadGame: ,"@saveIndex);
	// Reset the FOV
	if (class'DeusExPlayer'.default.bRadarTran == True)
    {
       class'DeusExPlayer'.default.bRadarTran = False;   //CyberP: disable the radar effect
       class'DeusExPlayer'.default.bCloakEnabled = False;
       ScaleGlow = default.ScaleGlow;
       Style = default.Style;
       AmbientGlow = default.AmbientGlow;
       if (inhand != None)
       {
           if (inHand.IsA('DeusExWeapon'))
           {
              DeusExWeapon(inHand).HideCamo();
           }
           else if (inHand.IsA('DeusExPickup'))
           {
              DeusExPickup(inHand).HideCamo();
           }
       }
    }
	else if (class'DeusExPlayer'.default.bCloakEnabled || class'DeusExPlayer'.default.bRadarTran) //RSD: Added bRadarTran
	{
       class'DeusExPlayer'.default.bCloakEnabled = False; //CyberP: disable the cloak effect
       class'DeusExPlayer'.default.bRadarTran = False;
       ScaleGlow = default.ScaleGlow;
       Style = default.Style;
       MultiSkins[6] = Texture'DeusExCharacters.Skins.FramesTex4';
       MultiSkins[7] = Texture'DeusExCharacters.Skins.LensesTex5';
       AmbientGlow = default.AmbientGlow;
       if (inhand != None)
       {
           if (inHand.IsA('DeusExWeapon'))
           {
              DeusExWeapon(inHand).HideCamo();
           }
           else if (inHand.IsA('DeusExPickup'))
           {
              DeusExPickup(inHand).HideCamo();
           }
       }
    }
    if (DeusExRootWindow(rootWindow) != None)
    {
       DeusExRootWindow(rootWindow).ClearWindowStack();
	}
	if (DeusExRootWindow(rootWindow) != None)
	{
	   DeusExRootWindow(rootWindow).ClearWindowStack();
	}
    if (bRadialAugMenuVisible) ToggleRadialAugMenu();
	DesiredFOV = Default.DesiredFOV;
	ClientTravel("?loadgame=" $ saveIndex, TRAVEL_Absolute, False);
}

//Sarge: Move Save Checks to a single function, rather than being everywhere
function bool CanSave(optional bool allowHardcore)
{
	local DeusExLevelInfo info;

	info = GetLevelInfo();

	// Don't allow saving if:
	//
    // 1) Hardcore mode or Restricted Saving is on (disable with allowHardcore flag)
	// 2) We're on the logo map
	// 3) The player is dead
	// 4) We're interpolating (playing outtro)
	// 5) A datalink is playing
	// 6) We're in a multiplayer game
    // 7) SARGE: We're in a conversation
    // 8) SARGE: We're currently recreating decals

    if ((bHardCoreMode || bRestrictedSaving) && !allowHardcore) //Hardcore Mode
        return false;

	if ((info != None) && (info.MissionNumber < 0)) //Logo Screen
        return false;

	if ((IsInState('Dying')) || (IsInState('Paralyzed')) || (IsInState('Interpolating'))) //Dead or Interpolating
        return false;

	if (dataLinkPlay != None) //Datalink playing
        return false;

    if (Level.Netmode != NM_Standalone) //Multiplayer Game
	   return false;

    if (InConversation())
        return false;

    if (bCreatingDecals)
        return false;

    return true; 
}

function GameDirectory GetSaveGameDirectory()
{
	local GameDirectory saveDir;

	// Create our Map Directory class
	saveDir = CreateGameDirectoryObject();
	saveDir.SetDirType(saveDir.EGameDirectoryTypes.GD_SaveGames);
	saveDir.GetGameDirectory();

	return saveDir;
}

//We can't modify the native function, so do this here, and then call it
function int DoSaveGame(int saveIndex, optional String saveDesc)
{
	local GameDirectory saveDir;
    local TechGoggles tech;
	local DeusExRootWindow root;
	
	root = DeusExRootWindow(rootWindow);

    //Placeholder Hackfix
    if (AugmentationSystem != None && AugmentationSystem.GetAugLevelValue(class'AugVision') != -1.0)
        AugmentationSystem.DeactivateAll();
    else if (UsingChargedPickup(class'TechGoggles'))
        foreach AllActors(class'TechGoggles', tech)
            if ((tech.Owner == Self) && tech.bActive)
                tech.Activate();
    
    //SARGE: Store all the decals
    if (DecalManager != None && iPersistentDebris > 0)
        DecalManager.PopulateDecalsList();

    if (saveIndex == 0)
    {
        saveDir = GetSaveGameDirectory();
		saveIndex=saveDir.GetNewSaveFileIndex();
    }
    
    //root.hide();
    root.GenerateSnapshot(True);
    SaveGame(saveIndex, saveDesc);
    root.HideSnapshot();
    //root.show();

    ConsoleCommand("set DeusExPlayer iLastSave " $ saveIndex);
    return saveIndex;
}

function int FindAutosaveSlot()
{
    local int slot, i, last;
	local GameDirectory saveDir;

    last = iAutoSaveMax - 1;

    if (last <= 0)
        return -1; //If no slots, Use the standard quicksave slot

    //pick out highest index
    slot = iAutoSaveSlots[last];
    
    //If it's zero, get a new index and add it to the array
    if (slot == 0)
    {
        saveDir = GetSaveGameDirectory();
		slot=saveDir.GetNewSaveFileIndex();
    }

    //Now "rotate" the array by moving everything up (and wrapping)
    for (i = last; i > 0;i--)
        iAutoSaveSlots[i] = iAutoSaveSlots[i - 1];

    //Set slot 0 to our current slot
    iAutoSaveSlots[0] = slot;
    
    CriticalDelete(saveDir);

    return slot;
}

function int FindQuicksaveSlot()
{
    local int slot, i, last;
	local GameDirectory saveDir;

    last = iQuickSaveMax - 1;

    if (last <= 0)
        return -1; //If no slots, Use the standard quicksave slot

    //pick out highest index
    slot = iQuicksaveSlots[last];
    
    //If it's zero, get a new index and add it to the array
    if (slot == 0)
    {
        saveDir = GetSaveGameDirectory();
		slot=saveDir.GetNewSaveFileIndex();
    }

    //Now "rotate" the array by moving everything up (and wrapping)
    for (i = last; i > 0;i--)
        iQuicksaveSlots[i] = iQuicksaveSlots[i - 1];

    //Set slot 0 to our current slot
    iQuicksaveSlots[0] = slot;
	
    CriticalDelete(saveDir);

    return slot;
}

function bool PerformAutoSave(bool allowHardcore)
{
    if (!CanSave(allowHardcore))
        return false;
    
    //Only allow autosaving if we have autosaves turned on,
    //or if saving restrictions is enabled.
    if (bTogAutoSave || bRestrictedSaving || bHardCoreMode)
    {
        DoSaveGame(FindAutosaveSlot(), sprintf(AutoSaveGameTitle,TruePlayerName));
        return true;
    }
    return false;
}

// ----------------------------------------------------------------------
// QuickSave()
// ----------------------------------------------------------------------
exec function QuickSave()
{
    Quicksave2(sprintf(QuickSaveGameTitle,TruePlayerName));
}

//Can't add an optional to the above function, so we use a separate one instead
function QuickSave2(string SaveString, optional bool allowHardcore)
{
    if (!CanSave(allowHardcore))
        return;

	DoSaveGame(FindQuicksaveSlot(), SaveString);
}

// ----------------------------------------------------------------------
// QuickLoad()
// ----------------------------------------------------------------------

exec function QuickLoad()
{
	local GameDirectory saveDir;
	local DeusExSaveInfo info;

    saveDir = GetSaveGameDirectory();

	//Don't allow in multiplayer.
	if (Level.Netmode != NM_Standalone)
	  return;

    //Confirm the save exists before trying to do anything
    info = saveDir.GetSaveInfo(int(ConsoleCommand("get DeusExPlayer iLastSave")));
    if (info == None)
        return;

	if (DeusExRootWindow(rootWindow) != None && !IsInState('dying'))
		DeusExRootWindow(rootWindow).ConfirmQuickLoad();
	else if (DeusExRootWindow(rootWindow) != None && IsInState('dying') && !bDeadLoad)
	{ bDeadLoad=True; GoToState('Dying','LoadHack');   }
}

// ----------------------------------------------------------------------
// QuickLoadConfirmed()
// ----------------------------------------------------------------------

function QuickLoadConfirmed()
{
	if (Level.Netmode != NM_Standalone)
	  return;

    LoadGame(int(ConsoleCommand("get DeusExPlayer iLastSave"))); //changed so now selects last saved game, even if from menu
}

// ----------------------------------------------------------------------
// BuySkillSound()
// ----------------------------------------------------------------------

function BuySkillSound( int code )
{
	local Sound snd;

	switch( code )
	{
		case 0:
			snd = Sound'Menu_OK';
			break;
		case 1:
			snd = Sound'Menu_Cancel';
			break;
		case 2:
			snd = Sound'Menu_Focus';
			break;
		case 3:
			snd = Sound'Menu_BuySkills';
			break;
	}
	PlaySound( snd, SLOT_Interface, 0.75 );
}

// ----------------------------------------------------------------------
// StartNewGame()
//
// Starts a new game given the map passed in
// ----------------------------------------------------------------------

exec function StartNewGame(String startMap)
{
    local Inventory item, nextItem;
    local int musicVol, soundVol, speechVol;

    bGMDXNewGame = True;
    seed = -1;

	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();

    if(KeyRing != None)
		KeyRing.RemoveAllKeys();

	for(item = Inventory; item != None; item = nextItem)
	{
		nextItem = item.Inventory;
		item.Destroy();
	}
	// Set a flag designating that we're traveling,
	// so MissionScript can check and not call FirstFrame() for this map.
	flagBase.SetBool('PlayerTraveling', True, True, 0);

	SaveSkillPoints();
	ResetPlayer();
	DeleteSaveGameFiles();

	bStartingNewGame = True;

	// Send the player to the specified map!
	if (startMap == "")
		Level.Game.SendPlayer(Self, "01_NYC_UNATCOIsland");		// TODO: Must be stored somewhere!
	else
		Level.Game.SendPlayer(Self, startMap);

    //If Addiction System is enabled, set it as our default screen in the Health display
    if (bAddictionSystem)
        bShowStatus = false;

    //SARGE: Fix audio volume being incorrectly set on new game
    //TODO: Make this an option
    //TODO: Move this to ResetPlayer, since this function is for loading maps
    musicVol = int(ConsoleCommand("get" @ "ini:Engine.Engine.AudioDevice MusicVolume"));
    soundVol = int(ConsoleCommand("get" @ "ini:Engine.Engine.AudioDevice SoundVolume"));
    speechVol = int(ConsoleCommand("get" @ "ini:Engine.Engine.AudioDevice SpeechVolume"));
    
    ConsoleCommand("set" @ "ini:Engine.Engine.AudioDevice SoundVolume" @ soundVol);
    ConsoleCommand("set" @ "ini:Engine.Engine.AudioDevice MusicVolume" @ musicVol);
    ConsoleCommand("set" @ "ini:Engine.Engine.AudioDevice SpeechVolume" @ speechVol);
}

// ----------------------------------------------------------------------
// StartTrainingMission()
// ----------------------------------------------------------------------

function StartTrainingMission()
{
    local Inventory anItem;
	//if (DeusExRootWindow(rootWindow) != None)
	//	DeusExRootWindow(rootWindow).ClearWindowStack();

	// Make sure the player isn't asked to do this more than
	// once if prompted on the main menu.
	if (!bAskedToTrain)
	{
		bAskedToTrain = True;
		SaveConfig();
	}

    if (IsInState('Dying')) GotoState('PlayerWalking');

	if (DeusExRootWindow(rootWindow) != None)
	{
	      ForEach AllActors(class'Inventory',anItem)
	      {
	          anItem.Destroy();
              DeleteInventory(anItem);
	      }
        DeusExRootWindow(rootWindow).ClearWindowStack();
		DeusExRootWindow(rootWindow).hud.belt.ClearBelt();
    }
	SkillSystem.ResetSkills();
	ResetPlayer(True);
	DeleteSaveGameFiles();
	bStartingNewGame = True;
	Level.Game.SendPlayer(Self, "00_Training");
}

// ----------------------------------------------------------------------
// ShowIntro()
// ----------------------------------------------------------------------

function ShowIntro(optional bool bStartNewGame, optional bool force)
{
    local Inventory anItem;
	//GMDX: fix inventory bug when player dies and starts new game
	if (IsInState('Dying')) GotoState('PlayerWalking');

	if (DeusExRootWindow(rootWindow) != None)
		{
	      ForEach AllActors(class'Inventory',anItem)
	      {
	          anItem.Destroy();
              DeleteInventory(anItem);
	      }
        DeusExRootWindow(rootWindow).ClearWindowStack();
		DeusExRootWindow(rootWindow).hud.belt.ClearBelt();
        }
	bStartNewGameAfterIntro = bStartNewGame;

	// Make sure all augmentations are OFF before going into the intro
	AugmentationSystem.DeactivateAll(true);

	if ((bSkipNewGameIntro || bPrisonStart) && !force)
	  PostIntro();
	  else// Reset the player
		 Level.Game.SendPlayer(Self, "00_Intro");
}

// ----------------------------------------------------------------------
// ShowCredits()
// ----------------------------------------------------------------------

function ShowCredits(optional bool bLoadIntro)
{
	local DeusExRootWindow root;
	local CreditsWindow winCredits;

	root = DeusExRootWindow(rootWindow);

	if (root != None)
	{
		// Show the credits screen and force the game not to pause
		// if we're showing the credits after the endgame
		winCredits = CreditsWindow(root.InvokeMenuScreen(Class'CreditsWindow', bLoadIntro));
		winCredits.SetLoadIntro(bLoadIntro);
	}
}

// ----------------------------------------------------------------------
// StartListenGame()
// ----------------------------------------------------------------------

function StartListenGame(string options)
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	if (root != None)
	  root.ClearWindowStack();

	ConsoleCommand("start "$options$"?listen");
}

// ----------------------------------------------------------------------
// StartMultiplayerGame()
// ----------------------------------------------------------------------

function StartMultiplayerGame(string command)
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	if (root != None)
	  root.ClearWindowStack();

	ConsoleCommand(command);
}

// ----------------------------------------------------------------------
// NewMultiplayerMatch()
// ----------------------------------------------------------------------

function NewMultiplayerMatch()
{
	DeusExMPGame( DXGame ).RestartPlayer( Self );
	PlayerReplicationInfo.Score = 0;
	PlayerReplicationInfo.Deaths = 0;
	PlayerReplicationInfo.Streak = 0;
}

// ----------------------------------------------------------------------
// ShowMultiplayerWin()
// ----------------------------------------------------------------------

function ShowMultiplayerWin( String winnerName, int winningTeam, String Killer, String Killee, String Method )
{
	local HUDMultiplayer mpScr;
	local DeusExRootWindow root;

	if (( Player != None ) && ( Player.Console != None ))
		Player.Console.ClearMessages();

	root = DeusExRootWindow(rootWindow);

	if ( root != None )
	{
		mpScr = HUDMultiplayer(root.InvokeUIScreen(Class'HUDMultiplayer', True));
		root.MaskBackground(True);

		if ( mpScr != None )
		{
		 mpScr.winnerName = winnerName;
			mpScr.winningTeam = winningTeam;
			mpScr.winKiller = Killer;
			mpScr.winKillee = Killee;
			mpScr.winMethod = Method;
		}
	}

	//Do cleanup
	if (PlayerIsClient())
	{
	  if (AugmentationSystem != None)
		 AugmentationSystem.DeactivateAll(true);
	}
}


// ----------------------------------------------------------------------
// ResetPlayer()
//
// Called when a new game is started.
//
// 1) Erase all flags except those beginning with "SKTemp_"
// 2) Dumps inventory
// 3) Restore any other defaults
// ----------------------------------------------------------------------

function ResetPlayer(optional bool bTraining)
{
	local inventory anItem;
	local inventory nextItem;
    local int i;

	ResetPlayerToDefaults();

	// Reset Augmentations
	if (AugmentationSystem != None)
	{
		AugmentationSystem.ResetAugmentations();
		AugmentationSystem.Destroy();
		AugmentationSystem = None;
	}

    // Reset Belt Memory
    for(i = 0;i < 12;i++)
        ClearPlaceholder(i);

	// Give the player a pistol and a prod
	if (!bTraining && !bPrisonStart)
	{

        //SARGE: Hack to make the starting items always appear in the belt, regardless of autofill setting
        bForceBeltAutofill = true;
		anItem = Spawn(class'WeaponPistol');
		anItem.Frob(Self, None);
		anItem.bInObjectBelt = True;
		anItem = Spawn(class'WeaponProd');
		anItem.Frob(Self, None);
		anItem.bInObjectBelt = True;
		anItem = Spawn(class'MedKit');
		anItem.Frob(Self, None);
		anItem.bInObjectBelt = True;
		swimTimer = 1000;  //CyberP: start with full stamina.
		KillerCount = 0;    //CyberP: start with 0 kills
		stepCount = 0;      //CyberP: start with 0 steps
        bForceBeltAutofill = false;
	}
}

// ----------------------------------------------------------------------
// ResetPlayerToDefaults()
//
// Resets all travel variables to their defaults
// ----------------------------------------------------------------------

function ResetPlayerToDefaults()
{
	local inventory anItem;
	local inventory nextItem;
    local int i;
	// reset the image linked list
	FirstImage = None;

	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ResetFlags();

	// Remove all the keys from the keyring before
	// it gets destroyed
	if (KeyRing != None)
	{
		KeyRing.RemoveAllKeys();
	  if ((Role == ROLE_Authority) && (Level.NetMode != NM_Standalone))
	  {
		 KeyRing.ClientRemoveAllKeys();
	  }
		KeyRing = None;
	}

	while(Inventory != None)
	{
		anItem = Inventory;
		DeleteInventory(anItem);
	  anItem.Destroy();
	}
/*
	anItem = Inventory;
	while(anItem!= None)
	{
	  log("DELETE "@anItem);
	   nextItem=anItem.Inventory;
		DeleteInventory(anItem,true);
	  anItem.Destroy();
	  anItem=nextItem;
	}
*/
	// Clear object belt
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).hud.belt.ClearBelt();

	// clear the notes and the goals
	DeleteAllNotes();
	DeleteAllGoals();

	// Nuke the history
	ResetConversationHistory();

	// Other defaults
	Credits = Default.Credits;
	Energy  = Default.Energy;
	SkillPointsTotal = Default.SkillPointsTotal;
	SkillPointsAvail = Default.SkillPointsAvail;

	SetInHandPending(None);
	SetInHand(None);

	bInHandTransition = False;

	RestoreAllHealth();
	ClearLog();

	// Reset save count/time
	saveCount = 0;
	saveTime  = 0.0;

    // Reset Addiction Manager
    AddictionManager = None;

	// Reinitialize all subsystems we've just nuked
	InitializeSubSystems();

	PerkManager.ResetPerks();

    bBoosterUpgrade = False;

	// Give starting inventory.
	if (Level.Netmode != NM_Standalone)
	{
		NintendoImmunityEffect( True );
	  GiveInitialInventory();
	}
}

// ----------------------------------------------------------------------
// CreateKeyRing()
// ----------------------------------------------------------------------

function CreateKeyRing()
{
	if (KeyRing == None)
	{
		KeyRing = Spawn(class'NanoKeyRing', Self);
		KeyRing.InitialState='Idle2';
		KeyRing.GiveTo(Self);
		KeyRing.SetBase(Self);
	}
}

singular function RecoilShaker(vector shakeAmount)  //CyberP: Cosmetic effects when shooting
{
	//SARGE: Don't do recoil effects when we're out of control, to stop shaking in cutscenes etc
	if (RestrictInput())
		return;

    if (inHand != none && inHand.IsA('Binoculars') && Binoculars(inHand).bActive) //RSD: To make sure zoom isn't messed up
       return;
    else if (assignedWeapon != none && assignedWeapon.IsA('Binoculars') && Binoculars(assignedWeapon).bActive)
       return;

    RecoilDesired.X=RecoilShake.X+((1.0*shakeAmount.X)-shakeAmount.X);//2.0)-shakeAmount.X);
    RecoilDesired.Y=RecoilShake.Y+((1.0*shakeAmount.Y)-shakeAmount.Y);     //CyberP: 2
	RecoilDesired.Z=RecoilShake.Z+((1.0*shakeAmount.Z)-shakeAmount.Z);

    if (Weapon != none && DeusExWeapon(Weapon).IsInState('NormalFire'))
    {
	if (DeusExWeapon(Weapon).IsA('WeaponShuriken'))
    {
       RecoilTime=default.RecoilTime/2;
       if (!DeusExWeapon(Weapon).bZoomed)
          DesiredFOV = default.DesiredFOV + 1;
    }
    else if (DeusExWeapon(Weapon).bFiring)
    {
       if (DeusExWeapon(Weapon).bAutomatic && DeusExWeapon(inHand).bFiring)
       {
       RecoilTime=default.RecoilTime/2.5;
       if (!DeusExWeapon(Weapon).bZoomed)
          DesiredFOV = default.DesiredFOV - 1;
       }
       else
       {
       RecoilTime=default.RecoilTime*0.65;   //CyberP: faster shake for guns
       if (!DeusExWeapon(Weapon).bZoomed)
       {
          if (Weapon.IsA('WeaponSawedOffShotgun') || Weapon.IsA('WeaponAssaultShotgun') || Weapon.IsA('WeaponRifle') || Weapon.IsA('PlasmaRifle'))
             DesiredFOV = default.DesiredFOV - 2;
          else
             DesiredFOV = default.DesiredFOV + 2;
          //if ((DeusExWeapon(inHand).bExtraShaker)) //CyberP: hmm, tick...
          //   ShakeView(0.01, 160, 8);
       }
       }
    }
    else
    {
       RecoilTime=default.RecoilTime;
    }
    }
    else
    {
       RecoilTime=default.RecoilTime;   //CyberP: else for flinching and other effects
    }

    //SetFOVAngle(FOVAngle);
	if (RecoilShake.X>RecoilSimLimit.X) RecoilShake.X=RecoilSimLimit.X;
	if (RecoilShake.Y>RecoilSimLimit.Y) RecoilShake.Y=RecoilSimLimit.Y;
	if (RecoilShake.Z>RecoilSimLimit.Z) RecoilShake.Z=RecoilSimLimit.Z;

	if (RecoilShake.X<-RecoilSimLimit.X) RecoilShake.X=-RecoilSimLimit.X;
	if (RecoilShake.Y<-RecoilSimLimit.Y) RecoilShake.Y=-RecoilSimLimit.Y;
	if (RecoilShake.Z<-RecoilSimLimit.Z) RecoilShake.Z=-RecoilSimLimit.Z;
}

function RecoilEffectTick(float deltaTime)
{
	local float invTime;

	if ((RecoilTime>0)||(VSize(RecoilShake)>0.0))
	{
	   if (inHand !=none && inHand.IsA('DeusExWeapon') && DeusExWeapon(inHand).bFiring)
          invTime=3/default.RecoilTime;
       else
          invTime=1.0/0.140000;

		RecoilShake.X=Lerp(deltaTime*invTime,RecoilShake.X,RecoilDesired.X);
		RecoilShake.Y=Lerp(deltaTime*invTime,RecoilShake.Y,RecoilDesired.Y);
		RecoilShake.Z=Lerp(deltaTime*invTime,RecoilShake.Z,RecoilDesired.Z);
		RecoilTime-=deltaTime;

		if (RecoilTime<=0.0)
		{
			RecoilTime=0;
			
			//SARGE: Don't do recoil effects when we're out of control, to stop shaking in cutscenes etc
			if (RestrictInput())
				return;
			
			if ((DeusExWeapon(inHand) != None) && (DeusExWeapon(inHand).bZoomed))
			   DesiredFOV = DeusExWeapon(inHand).ScopeFOV;
            else if (inHand != none && inHand.IsA('Binoculars') && Binoculars(inHand).bActive) //RSD: To make sure zoom isn't messed up
            {}
			else if (assignedWeapon != none && assignedWeapon.IsA('Binoculars') && Binoculars(assignedWeapon).bActive)
			{}
			else
			{
			   //FovAngle = Default.DesiredFOV;
			   DesiredFOV = Default.DesiredFOV;
			}
			RecoilDesired=vect(0,0,0);
			if (VSize(RecoilShake)<0.1)
              RecoilShake=vect(0,0,0);
		}
	}
}

// ----------------------------------------------------------------------
// SelectMeleePriority()
// ----------------------------------------------------------------------

function bool SelectMeleePriority(int damageThreshold)	// Trash: Used to automatically decide what to draw
{
	local Inventory anItem;
	local DeusExWeapon meleeWeapon;

	local DeusExWeapon crowbar, sword, knife, baton, dts;

	For(anItem = Inventory; anItem != None; anItem = anItem.Inventory)	// Go through the entire inventory, check for these melee weapons
	{
		if (anItem.IsA('WeaponSword'))
			sword = DeusExWeapon(anItem);
		if (anItem.IsA('WeaponCrowbar'))
			crowbar = DeusExWeapon(anItem);
		if (anItem.IsA('WeaponCombatKnife'))
			knife = DeusExWeapon(anItem);
		if (anItem.IsA('WeaponBaton'))
			baton = DeusExWeapon(anItem);
		if (anItem.IsA('WeaponNanoSword'))
			dts = DeusExWeapon(anItem);
	}

	if (sword == None && crowbar == none && knife == none && baton == none && dts == none)	// Don't proceed if you have no melee weapons
		return false;


	if (sword != None && (bHardCoreMode || BreaksDamageThreshold(sword, damageThreshold)))
		meleeWeapon = sword;
	else if (crowbar != None && (bHardCoreMode || BreaksDamageThreshold(crowbar, damageThreshold)))
		meleeWeapon = crowbar;
	else if (knife != None && (bHardCoreMode || BreaksDamageThreshold(knife, damageThreshold)))
		meleeWeapon = knife;
	else if (baton != None && (bHardCoreMode || BreaksDamageThreshold(baton, damageThreshold)))
		meleeWeapon = baton;
	else if (dts != None && (bHardCoreMode || BreaksDamageThreshold(dts, damageThreshold)))
		meleeWeapon = dts;
	else if (!bHardCoreMode)
    {
		ClientMessage(CantBreakDT);
        return false;
    }
    else
        return false;
	
    PutInHand(meleeWeapon,true);
    return true;
}

function bool BreaksDamageThreshold(DeusExWeapon weapon, int damageThreshold)	// Checks if the weapon breaks the damageThreshold
{
	if (weapon.IsA('WeaponCrowbar'))	// Special check for Crowbar since it deals +5 extra damage to objects //SARGE: Now deals 2x damage, to scale with low-tech
        return (weapon.CalculateTrueDamage() * 2) >= damageThreshold;
    else
        return (weapon.CalculateTrueDamage()) >= damageThreshold;
}

// ----------------------------------------------------------------------
// DrugEffects()
// ----------------------------------------------------------------------

simulated function DrugEffects(float deltaTime)
{
	local float mult, fov;
	local Rotator rot;
	local DeusExRootWindow root;
    local Crosshair        cross;
    local int i;                                                                //RSD: For loop later
    //local float addictionLevelSubtracted;                                       //RSD: addiction system
    local int skillMedLevel;                                                    //RSD: drunk health stuff
    local PersonaScreenHealth winHealth;                                        //RSD: addiction update

	root = DeusExRootWindow(rootWindow);

	if (hitmarkerTime > 0)
    {
        if ((root != None) && (root.hud != None))
		{
            hitmarkerTime -= deltaTime;

            if (hitmarkerTime < 0.05 || IsInState('Dying'))
                hitmarkerTime = 0;
            
            UpdateCrosshair();
        }
    }
    if (enviroAutoTime > 0)
	{
	   enviroAutoTime -= deltaTime;
	   if (enviroAutoTime <= 0)
	   {
	      enviroAutoTime = 0;
	      if (bBoosterUpgrade)
	          AugmentationSystem.AutoAugs(true,true);
       }
	}
	if (drugEffectTimer > 0)
	{
		if ((root != None) && (root.hud != None))
		{
			if (root.hud.background == None)
			{
			    if (bHardDrug)
			    {
			        root.hud.SetBackground(Texture'DrunkBoy');
			    }
                else
			        root.hud.SetBackground(Texture'DrunkFX');
				root.hud.SetBackgroundSmoothing(True);
				root.hud.SetBackgroundStretching(True);
				root.hud.SetBackgroundStyle(DSTY_Modulated);
			}
		}

        if (!bAddictionSystem)                                                  //RSD: Only mess with view rot without addiction system
        {
		mult = FClamp(drugEffectTimer / 10.0, 0.0, 3.0);
		rot.Roll = 1024.0 * Sin(Level.TimeSeconds * mult) * deltaTime * mult;
        rot.Pitch = 1024.0 * Cos(Level.TimeSeconds * mult) * deltaTime * mult;
		rot.Yaw = 1024.0 * Sin(Level.TimeSeconds * mult) * deltaTime * mult;
		if (bHardDrug)
            rot.Roll+=sin(Level.TimeSeconds*100) * deltaTime;
        else
            rot.Roll = 0;

        rot.Roll = FClamp(rot.Roll, -4096, 4096);
		rot.Pitch = FClamp(rot.Pitch, -4096, 4096);
		rot.Yaw = FClamp(rot.Yaw, -4096, 4096);

		ViewRotation += rot;
        if ((ViewRotation.Pitch > 16384) && (ViewRotation.Pitch < 32768))
				ViewRotation.Pitch = 16384; //CyberP: stop view rot
        }

		drugEffectTimer -= deltaTime;
		if (drugEffectTimer < 0)
		{
			drugEffectTimer = 0;
			bHardDrug = False;
		}
	}
	else
	{
		if ((root != None) && (root.hud != None))
		{
			if (root.hud.background != None)
			{
				root.hud.SetBackground(None);
				root.hud.SetBackgroundStyle(DSTY_Normal);
				if (inHand.IsA('DeusExWeapon') && DeusExWeapon(inHand).bZoomed)
				{
				}
				else if (!RestrictInput())
					DesiredFOV = Default.DesiredFOV;
			}
		}
	}

	//RSD: Management for new Addiction System follows
	if (bAddictionSystem)
        AddictionManager.TickAddictions(deltaTime);
}

// ----------------------------------------------------------------------
// PlayMusic()
// ----------------------------------------------------------------------

function PlayMusic(String musicToPlay, optional int sectionToPlay)
{
	local Music LoadedMusic;
	local EMusicMode newMusicMode;

	if (musicToPlay != "")
	{
		LoadedMusic = Music(DynamicLoadObject(musicToPlay $ "." $ musicToPlay, class'Music'));

		if (LoadedMusic != None)
		{
			switch(sectionToPlay)
			{
				case 0:  newMusicMode = MUS_Ambient; break;
				case 1:  newMusicMode = MUS_Combat; break;
				case 2:  newMusicMode = MUS_Conversation; break;
				case 3:  newMusicMode = MUS_Outro; break;
				case 4:  newMusicMode = MUS_Dying; break;
				default: newMusicMode = MUS_Ambient; break;
			}

			ClientSetMusic(LoadedMusic, newMusicMode, 255, MTRAN_FastFade);
		}
	}
}

// ----------------------------------------------------------------------
// PlayMusicWindow()
//
// Displays the Load Map dialog
// ----------------------------------------------------------------------

exec function PlayMusicWindow()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'PlayMusicWindow');
}

// ----------------------------------------------------------------------
// ClientSetMusic()
//
// SARGE: Copied over from Engine/PlayerPawn.uc
// Modified to not restart music if the new song is the same as the current song, and the
// sections are the same (section 0 is always used on map-change, so we set it to that if we're using the "remembered" section).
// ----------------------------------------------------------------------
function ClientSetMusic( music NewSong, byte NewSection, byte NewCdTrack, EMusicTransition NewTransition )
{
    //ClientMessage("Switching music: " $ Song $ "->" $ NewSong $ ":" $ NewSection $ " (current: " $ default.currentSong $ ", " $ default.currentSection $ ")");
    if (default.currentSong != string(NewSong) || default.currentSection != NewSection || bEnhancedMusicSystem == 0)
    {
        super.ClientSetMusic(NewSong,NewSection,NewCdTrack,NewTransition);
        default.currentSong = string(NewSong);
        if (NewSection == savedSection)
            default.currentSection = 0;
        else
            default.currentSection = NewSection;
    }
}

// ----------------------------------------------------------------------
// UpdateDynamicMusic()
//
// Pattern definitions:
//   0 - Ambient 1
//   1 - Dying
//   2 - Ambient 2 (optional)
//   3 - Combat
//   4 - Conversation
//   5 - Outro
// ----------------------------------------------------------------------

function UpdateDynamicMusic(float deltaTime)
{
	local ScriptedPawn npc;
	local Pawn CurPawn;
	local DeusExLevelInfo info;
    local int aggro;                    //Sarge: Keep track of the number of aggro enemies. If >2, start combat music. If 0 stop combat music.

	if (Level.Song == None)
		return;

    info = GetLevelInfo();

	// DEUS_EX AMSD In singleplayer, do the old thing.
	// In multiplayer, we can come out of dying.
	if (!PlayerIsClient())
	{
	  if ((musicMode == MUS_Dying) || (musicMode == MUS_Outro))
		 return;
	}
	else
	{
	  if (musicMode == MUS_Outro)
		 return;
	}


	musicCheckTimer += deltaTime;
	musicChangeTimer += deltaTime;

	if (IsInState('Interpolating'))
	{
		// don't mess with the music on any of the intro maps
		info = GetLevelInfo();
		if ((info != None) && (info.MissionNumber < 0))
		{
			musicMode = MUS_Outro;
			return;
		}

		if (musicMode != MUS_Outro)
		{
			ClientSetMusic(Level.Song, 5, 255, MTRAN_FastFade);
			musicMode = MUS_Outro;
		}
	}
	else if (IsInState('Conversation'))
	{
        //CyberP: no dynamic music in clubs and bars.
	    if (info != none && info.bBarOrClub && bEnhancedMusicSystem >= 2)
              return;
		if (musicMode != MUS_Conversation)
		{
			// save our place in the ambient track
			if (musicMode == MUS_Ambient)
				savedSection = SongSection;
			else
				savedSection = 255;

			ClientSetMusic(Level.Song, 4, 255, MTRAN_Fade);
			musicMode = MUS_Conversation;
		}
	}
	else if (IsInState('Dying'))
	{
	    if (info != none && info.bBarOrClub && bEnhancedMusicSystem >= 2)
              return;
		if (musicMode != MUS_Dying)
		{
			ClientSetMusic(Level.Song, 1, 255, MTRAN_Fade);
			musicMode = MUS_Dying;
		}
	}
	else
	{
        //SARGE: Changed to only start combat music if at least 3 enemies are aggro'd
		// only check for combat music every second //CyberP: 2 secs
		if (musicCheckTimer >= 2.0)
		{
			musicCheckTimer = 0.0;
			aggro = 0;

            if (info != none && info.bBarOrClub && bEnhancedMusicSystem >= 2)
                return;

            // check a 100 foot radius around me for combat
            // XXXDEUS_EX AMSD Slow Pawn Iterator
            //foreach RadiusActors(class'ScriptedPawn', npc, 1600)
            for (CurPawn = Level.PawnList; CurPawn != None; CurPawn = CurPawn.NextPawn)
            {
                npc = ScriptedPawn(CurPawn);
                if ((npc != None) && (VSize(npc.Location - Location) < (2000 + npc.CollisionRadius)))
                {
                    if ((npc.GetStateName() == 'Attacking') && (npc.Enemy == Self) && iAllowCombatMusic > 0)
                    {
                        aggro++;
                    }
                }
            }
            if (aggro >= iAllowCombatMusic && iAllowCombatMusic > 0)
            {
                musicChangeTimer = 0.0;

                if (musicMode != MUS_Combat)
                {
                    // save our place in the ambient track
                    if (musicMode == MUS_Ambient)
                        savedSection = SongSection;
                    else
                        savedSection = 255;

                    ClientSetMusic(Level.Song, 3, 255, MTRAN_FastFade);
                    musicMode = MUS_Combat;
                }
            }
            else if (aggro == 0 && musicMode != MUS_Ambient)
            {
                // wait until we've been out of combat for 5 seconds before switching music
                if (musicChangeTimer >= 5.0)
                {
                    // use the default ambient section for this map
                    if (savedSection == 255)
                        savedSection = Level.SongSection;

                    // fade slower for combat transitions
                    if (musicMode == MUS_Combat)
                        ClientSetMusic(Level.Song, savedSection, 255, MTRAN_SlowFade);
                    else
                        ClientSetMusic(Level.Song, savedSection, 255, MTRAN_Fade);

                    savedSection = 255;
                    musicMode = MUS_Ambient;
                    musicChangeTimer = 0.0;
                }
            }
		}
	}
}

// ----------------------------------------------------------------------
// MaintainEnergy()
// ----------------------------------------------------------------------

//SARGE: TODO: Refactor
function MaintainEnergy(float deltaTime)
{
	local Float energyUse;
	local Float energyRegen;

	// make sure we can't continue to go negative if we take damage
	// after we're already out of energy
	if (Energy <= 0)
	{
		Energy = 0;
		EnergyDrain = 0;
		EnergyDrainTotal = 0;
	}

	energyUse = 0;

	// Don't waste time doing this if the player is dead or paralyzed
	if ((!IsInState('Dying')) && (!IsInState('Paralyzed')))
	{
	  if (Energy > 0)
	  {
		 // Decrement energy used for augmentations
		 energyUse = AugmentationSystem.CalcEnergyUse(deltaTime);

		 Energy -= EnergyUse;
         if (Energy < 6)
         {
            if (EnergyUse != 0 && bDrainAlert==False)
            {
            PlaySound(sound'GMDXSFX.Generic.biolow',SLOT_None);
            bDrainAlert=True; //CyberP: alert when energy is low
            }
         }

         if (Energy > 10)
			bDrainAlert=False;

		 // Calculate the energy drain due to EMP attacks
		 if (EnergyDrain > 0)
		 {
			energyUse = EnergyDrainTotal * deltaTime;
			Energy -= EnergyUse;
			EnergyDrain -= EnergyUse;

			if (EnergyDrain <= 0)
			{
			   EnergyDrain = 0;
			   EnergyDrainTotal = 0;
			}
		 }
	  }

	  //Do check if energy is 0.
	  // If the player's energy drops to zero, deactivate
	  // all augmentations
	  if (Energy <= 0)
	  {
		 //If we were using energy, then tell the client we're out.
		 //Otherwise just make sure things are off.  If energy was
		 //already 0, then energy use will still be 0, so we won't
		 //spam.  DEUS_EX AMSD
		 if (energyUse > 0)
			ClientMessage(EnergyDepleted);
		 Energy = 0;
		 EnergyDrain = 0;
		 EnergyDrainTotal = 0;
		 AugmentationSystem.DeactivateAll();
	  }

	  // If all augs are off, then start regenerating in multiplayer,
	  // up to 25%.
	  if (Level.NetMode != NM_Standalone)
	  {
	    if ((energyUse == 0) && (Energy <= MaxRegenPoint))
	    {
		 energyRegen = RegenRate * deltaTime;
		 Energy += energyRegen;
        }
	  }
	}

	//RSD: Doing new NanoVirus stuff here since I'm lazy
	NanoVirusTimer -= deltaTime;
	if (NanoVirusTimer <= 0)
		NanoVirusTimer = 0;
	if (!bNanoVirusSentMessage && nanoVirusTimer > 0)
	    NanoVirusTicks++;
	if (NanoVirusTicks >= 2)                                                    //RSD: Only want to print this message once, but explosions do 5 instances
	{
        ClientMessage(Sprintf(NanoVirusLabel, int(NanoVirusTimer)));
        bNanoVirusSentMessage = true;
        NanoVirusTicks = 0;
    }
}
// ----------------------------------------------------------------------
// RefreshSystems()
// DEUS_EX AMSD For keeping multiplayer working in better shape
// ----------------------------------------------------------------------

simulated function RefreshSystems(float DeltaTime)
{
	local DeusExRootWindow root;

	if (Level.NetMode == NM_Standalone)
	  return;

	if (Role == ROLE_Authority)
	  return;

	if (LastRefreshTime < 0)
	  LastRefreshTime = 0;

	LastRefreshTime = LastRefreshTime + DeltaTime;

	if (LastRefreshTime < 0.25)
	  return;

	if (AugmentationSystem != None)
	  AugmentationSystem.RefreshAugDisplay();

	root = DeusExRootWindow(rootWindow);
	if (root != None)
	  root.RefreshDisplay(LastRefreshTime);

	RepairInventory();

	LastRefreshTime = 0;

}

function RepairInventory()
{
	local byte				LocalInvSlots[30];		// 5x6 grid of inventory slots
	local int i;
	local int slotsCol;
	local int slotsRow;
	local Inventory curInv;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	  return;

	//clean out our temp inventory.
	for (i = 0; i < 30; i++)
	  LocalInvSlots[i] = 0;

	// go through our inventory and fill localinvslots
	if (Inventory != None)
	{
      for (curInv = Inventory; curInv != None; curInv = curInv.Inventory)
	  {
		 if (curInv.IsA('DeusExWeapon'))                                        //RSD: Disgusting hack so we don't go out of array bounds due to inventory item rotation
		 {
			curInv.invSlotsX = DeusExWeapon(curInv).invSlotsXtravel;
			curInv.invSlotsY = DeusExWeapon(curInv).invSlotsYtravel;
		 }
         // Make sure this item is located in a valid position
		 if (( curInv.invPosX != -1 ) && ( curInv.invPosY != -1 ))
		 {
			// fill inventory slots
			for( slotsRow=0; slotsRow < curInv.invSlotsY; slotsRow++ )
			   for ( slotsCol=0; slotsCol < curInv.invSlotsX; slotsCol++ )
				  LocalInvSlots[((slotsRow + curInv.invPosY) * maxInvCols) + (slotscol + curInv.invPosX)] = 1;
		 }
	  }
	}

	// verify that the 2 inventory grids match
	for (i = 0; i < 30; i++)
	  if (LocalInvSlots[i] < invSlots[i]) //don't stuff slots, that can get handled elsewhere, just clear ones that need it
	  {
		 log("ERROR!!! Slot "$i$" should be "$LocalInvSlots[i]$", but isn't!!!!, repairing");
		 invSlots[i] = LocalInvSlots[i];
	  }

}

// ----------------------------------------------------------------------
// Bleed()
//
// Let the blood flow
// ----------------------------------------------------------------------

function Bleed(float deltaTime)
{
	local float  dropPeriod;
	local float  adjustedRate;
	local vector bloodVector;

	if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	{
	  bleedrate = 0;
	  dropCounter = 0;
	  return;
	}

	// Copied from ScriptedPawn::Tick()
	bleedRate = FClamp(bleedRate, 0.0, 1.0);
	if (bleedRate > 0)
	{
		adjustedRate = (1.0-bleedRate)*1.0+0.1;  // max 10 drops per second
		dropPeriod = adjustedRate / FClamp(VSize(Velocity)/512.0, 0.05, 1.0);
		dropCounter += deltaTime;
		while (dropCounter >= dropPeriod)
		{
			bloodVector = vect(0,0,1)*CollisionHeight*0.5;  // so folks don't bleed from the crotch
			spawn(Class'BloodDrop',,,bloodVector+Location);
			dropCounter -= dropPeriod;
		}
		bleedRate -= deltaTime/clotPeriod;
	}
	if (bleedRate <= 0)
	{
		dropCounter = 0;
		bleedRate   = 0;
	}
}

// ----------------------------------------------------------------------
// UpdatePoison()
//
// Get all woozy 'n' stuff
// ----------------------------------------------------------------------

function UpdatePoison(float deltaTime)
{
	if (Health <= 0)  // no more pain -- you're already dead!
		return;

	if (InConversation())  // kinda hacky...
		return;

	if (poisonCounter > 0)
	{
		poisonTimer += deltaTime;
		if (poisonTimer >= 3.0)  // pain every two seconds //CyberP: three seconds
		{
			poisonTimer = 0;
			poisonCounter--;
			TakeDamage(poisonDamage * 0.375, myPoisoner, Location, vect(0,0,0), 'PoisonEffect'); //CyberP: since we have more effective tranq darts, reduce poison damage to player by half. 15 dam per interval on hardcore //SARGE: Reduced from 0.5 to 0.375 because it still feels like bullshit. You won't be able to regenerate stamina while poisoned, though, so it'll fuck you up.
		}
		if ((poisonCounter <= 0) || (Health <= 0))
			StopPoison();
	}
}

// ----------------------------------------------------------------------
// StartPoison()
//
// Gakk!  We've been poisoned!
// ----------------------------------------------------------------------

function StartPoison( Pawn poisoner, int Damage )
{
	myPoisoner = poisoner;

    if (myPoisoner.weapon.IsA('WeaponGreaselSpit') && FRand() < 0.3)
    {
        if (FlagBase.GetBool('LDDPJCIsFemale')) //Sarge: Lay-D Denton support
            PlaySound(Sound(DynamicLoadObject("FJCCough", class'Sound', false)), SLOT_Pain);
        else
            PlaySound(sound'MaleCough',SLOT_Pain);    //CyberP: cough to greasel spit
    }

	if (Health <= 0)  // no more pain -- you're already dead!
		return;

	if (InConversation())  // kinda hacky...
		return;

    // CyberP: less poison if
	if (PerkManager.GetPerkWithClass(class'DeusEx.PerkHardened').bPerkObtained == true)
       poisonCounter = 3;
	else
	    poisonCounter = 4;   // take damage no more than four times (over 8 seconds)

    poisonTimer   = 0;    // reset pain timer
	if (poisonDamage < Damage)  // set damage amount
		poisonDamage = Damage;

        // CyberP: Don't do drug effects if

		if (PerkManager.GetPerkWithClass(class'DeusEx.PerkHardened').bPerkObtained == true && poisonCounter > 0)
		drugEffectTimer = 0;
		else
     	drugEffectTimer += 3;  // make the player vomit for the next four seconds

	// In multiplayer, don't let the effect last longer than 30 seconds
	if ( Level.NetMode != NM_Standalone )
	{
		if ( drugEffectTimer > 30 )
			drugEffectTimer = 30;
	}
}

// ----------------------------------------------------------------------
// StopPoison()
//
// Stop the pain
// ----------------------------------------------------------------------

function StopPoison()
{
	myPoisoner = None;
	poisonCounter = 0;
	poisonTimer   = 0;
	poisonDamage  = 0;
}

// ----------------------------------------------------------------------
// SpawnEMPSparks()
//
// Spawn sparks for items affected by Warren's EMP Field
// ----------------------------------------------------------------------

function SpawnEMPSparks(Actor empActor, Rotator rot)
{
	local ParticleGenerator sparkGen;

	if ((empActor == None) || empActor.bDeleteMe)
		return;

	sparkGen = Spawn(class'ParticleGenerator', empActor,, empActor.Location, rot);
	if (sparkGen != None)
	{
		sparkGen.SetBase(empActor);
		sparkGen.LifeSpan = 3;
		sparkGen.particleTexture = Texture'Effects.Fire.SparkFX1';
		sparkGen.particleDrawScale = 0.1;
		sparkGen.bRandomEject = True;
		sparkGen.ejectSpeed = 100.0;
		sparkGen.bGravity = True;
		sparkGen.bParticlesUnlit = True;
		sparkGen.frequency = 1.0;
		sparkGen.riseRate = 10;
		sparkGen.spawnSound = Sound'Spark2';
	}
}

// ----------------------------------------------------------------------
// UpdateWarrenEMPField()
//
// Update Warren's EMP field
// ----------------------------------------------------------------------

function UpdateWarrenEMPField(float deltaTime)
{
	local float          empRadius;
	local Robot          curRobot;
	local AlarmUnit      curAlarm;
	local AutoTurret     curTurret;
	local LaserTrigger   curLaser;
	local BeamTrigger    curBeam;
	local SecurityCamera curCamera;
	local int            option;

	if (bWarrenEMPField)
	{
		WarrenTimer -= deltaTime;
		if (WarrenTimer <= 0)
		{
			WarrenTimer = 0.15;

			empRadius = 600;
			if (WarrenSlot == 0)
			{
				foreach RadiusActors(Class'Robot', curRobot, empRadius)
				{
					if ((curRobot.LastRendered() < 2.0) && (curRobot.CrazedTimer <= 0) &&
					    (curRobot.EMPHitPoints > 0))
					{
						if (curRobot.GetPawnAllianceType(self) == ALLIANCE_Hostile)
							option = Rand(2);
						else
							option = 0;
						if (option == 0)
							curRobot.TakeDamage(curRobot.EMPHitPoints*2, self, curRobot.Location, vect(0,0,0), 'EMP');
						else
							curRobot.TakeDamage(100, self, curRobot.Location, vect(0,0,0), 'NanoVirus');
						SpawnEMPSparks(curRobot, Rotator(Location-curRobot.Location));
					}
				}
			}
			else if (WarrenSlot == 1)
			{
				foreach RadiusActors(Class'AlarmUnit', curAlarm, empRadius)
				{
					if ((curAlarm.LastRendered() < 2.0) && !curAlarm.bConfused)
					{
						curAlarm.TakeDamage(100, self, curAlarm.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curAlarm, curAlarm.Rotation);
					}
				}
			}
			else if (WarrenSlot == 2)
			{
				foreach RadiusActors(Class'AutoTurret', curTurret, empRadius)
				{
					if ((curTurret.LastRendered() < 2.0) && !curTurret.bConfused)
					{
						curTurret.TakeDamage(100, self, curTurret.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curTurret, Rotator(Location-curTurret.Location));
					}
				}
			}
			else if (WarrenSlot == 3)
			{
				foreach RadiusActors(Class'LaserTrigger', curLaser, empRadius)
				{
					if ((curLaser.LastRendered() < 2.0) && !curLaser.bConfused)
					{
						curLaser.TakeDamage(100, self, curLaser.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curLaser, curLaser.Rotation);
					}
				}
			}
			else if (WarrenSlot == 4)
			{
				foreach RadiusActors(Class'BeamTrigger', curBeam, empRadius)
				{
					if ((curBeam.LastRendered() < 2.0) && !curBeam.bConfused)
					{
						curBeam.TakeDamage(100, self, curBeam.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curBeam, curBeam.Rotation);
					}
				}
			}
			else if (WarrenSlot == 5)
			{
				foreach RadiusActors(Class'SecurityCamera', curCamera, empRadius)
				{
					if ((curCamera.LastRendered() < 2.0) && !curCamera.bConfused)
					{
						curCamera.TakeDamage(100, self, curCamera.Location, vect(0,0,0), 'EMP');
						SpawnEMPSparks(curCamera, Rotator(Location-curCamera.Location));
					}
				}
			}

			WarrenSlot++;
			if (WarrenSlot >= 6)
				WarrenSlot = 0;
		}
	}
}


// ----------------------------------------------------------------------
// UpdateTranslucency()
// DEUS_EX AMSD Try to make the player harder to see if he is in darkness.
// ----------------------------------------------------------------------

function UpdateTranslucency(float DeltaTime)
{
	local float DarkVis;
	local float CamoVis;
	local AdaptiveArmor armor;
	local bool bMakeTranslucent;
	local DeusExMPGame Game;

	// Don't do it in multiplayer.
	if (Level.NetMode == NM_Standalone)
	  return;

	Game = DeusExMPGame(Level.Game);
	if (Game == None)
	{
	  return;
	}

	bMakeTranslucent = false;

	//DarkVis = AIVisibility(TRUE);
	DarkVis = 1.0;

	CamoVis = 1.0;

	//Check cloaking.
	if (AugmentationSystem.GetAugLevelValue(class'AugCloak') != -1.0)
	{
	  bMakeTranslucent = TRUE;
	  CamoVis = Game.CloakEffect;
	}

	// If you have a weapon out, scale up the camo and turn off the cloak.
	// Adaptive armor leaves you completely invisible, but drains quickly.
	if ((inHand != None) && (inHand.IsA('DeusExWeapon')) && (CamoVis < 1.0))
	{
	  CamoVis = 1.0;
	  bMakeTranslucent=FALSE;
	  ClientMessage(WeaponUnCloak);
	  AugmentationSystem.FindAugmentation(class'AugCloak').Deactivate();
	}

	// go through the actor list looking for owned AdaptiveArmor
	// since they aren't in the inventory anymore after they are used
	if (UsingChargedPickup(class'AdaptiveArmor'))
	  {
		 CamoVis = CamoVis * Game.CloakEffect;
		 bMakeTranslucent = TRUE;
	  }

	ScaleGlow = Default.ScaleGlow * CamoVis * DarkVis;

	//Translucent is < 0.1, untranslucent if > 0.2, not same edge to prevent sharp breaks.
	if (bMakeTranslucent)
	{
	  Style = STY_Translucent;
	  if (Self.IsA('JCDentonMale'))
	  {
		 MultiSkins[6] = Texture'BlackMaskTex';
		 MultiSkins[7] = Texture'BlackMaskTex';
	  }
	}
	else if (Game.bDarkHiding)
	{
	  if (CamoVis * DarkVis < Game.StartHiding)
		 Style = STY_Translucent;
	  if (CamoVis * DarkVis > Game.EndHiding)
		 Style = Default.Style;
	}
	else if (!bMakeTranslucent)
	{
	  if (Self.IsA('JCDentonMale'))
	  {
		 MultiSkins[6] = Default.MultiSkins[6];
		 MultiSkins[7] = Default.MultiSkins[7];
	  }
	  Style = Default.Style;
	}
}

// ----------------------------------------------------------------------
// RestoreSkillPoints()
//
// Restore skill point variables
// ----------------------------------------------------------------------

function RestoreSkillPoints()
{
	local name flagName;

	bSavingSkillsAugs = False;

	// Get the skill points available
	flagName = rootWindow.StringToName("SKTemp_SkillPointsAvail");
	if (flagBase.CheckFlag(flagName, FLAG_Int))
	{
		SkillPointsAvail = flagBase.GetInt(flagName);
		flagBase.DeleteFlag(flagName, FLAG_Int);
	}

	// Get the skill points total
	flagName = rootWindow.StringToName("SKTemp_SkillPointsTotal");
	if (flagBase.CheckFlag(flagName, FLAG_Int))
	{
		SkillPointsTotal = flagBase.GetInt(flagName);
		flagBase.DeleteFlag(flagName, FLAG_Int);
	}
}

// ----------------------------------------------------------------------
// SaveSkillPoints()
//
// Saves out skill points, used when starting a new game
// ----------------------------------------------------------------------

function SaveSkillPoints()
{
	local name flagName;

	// Save/Restore must be done as atomic unit
	if (bSavingSkillsAugs)
		return;

	bSavingSkillsAugs = True;

	// Save the skill points available
	flagName = rootWindow.StringToName("SKTemp_SkillPointsAvail");
	flagBase.SetInt(flagName, SkillPointsAvail);

	// Save the skill points available
	flagName = rootWindow.StringToName("SKTemp_SkillPointsTotal");
	flagBase.SetInt(flagName, SkillPointsTotal);
}

// ----------------------------------------------------------------------
// AugAdd()
//
// Augmentation system functions
// exec functions for command line for demo
// ----------------------------------------------------------------------

exec function AugAdd(class<Augmentation> aWantedAug)
{
	local Augmentation anAug;

	if (!bCheatsEnabled)
		return;

	if (AugmentationSystem != None)
	{
		anAug = AugmentationSystem.GivePlayerAugmentation(aWantedAug);

		if (anAug == None)
			ClientMessage(GetItemName(String(aWantedAug)) $ " is not a valid augmentation!");
	}
}

//SARGE: Add in a way to remove augs
exec function AugRemove(class<Augmentation> aWantedAug)
{
	if (!bCheatsEnabled)
		return;

	if (AugmentationSystem != None)
		AugmentationSystem.RemoveAugmentation(aWantedAug);
}

//SARGE: Add in a way to cheat perks
exec function PerkAdd(class<Perk> aWantedPerk)
{
	if (!bCheatsEnabled || PerkManager == None)
		return;

    if (PerkManager.PurchasePerk(aWantedPerk,true))
        ClientMessage("Perk Added");
}

//SARGE: Add in a way to cheat perks
exec function PerkReAdd(class<Perk> aWantedPerk)
{
	if (!bCheatsEnabled || PerkManager == None)
		return;

    if (PerkManager.PurchasePerk(aWantedPerk,true,true))
        ClientMessage("Perk Re-added");
}

exec function OPAug() //CyberP: cheat for my fucked keyboard
{
   local AugmentationCannister cann;
   Allskills();
   Allaugs();
   AllWeapons();
   cann = Spawn(class'AugmentationCannister',,,Location + (CollisionRadius+3) * Vector(Rotation) + vect(0,0,1) * 15 );
   if (cann != None)
       cann.AddAugs[1] = 'AugIcarus';
   Spawn(class'MedicalBot',,,Location + (CollisionRadius+60) * Vector(Rotation) + vect(0,0,1) * 15 );
}

// ----------------------------------------------------------------------
// ActivateAugmentation()
// ----------------------------------------------------------------------

exec function ActivateAugmentation(int num)
{
	local Augmentation anAug;
	local int count, wantedSlot, slotIndex;
	local bool bFound;

	if (RestrictInput())
		return;

	if (AugmentationSystem != None)
		AugmentationSystem.ActivateAugByKey(num);
}

// ----------------------------------------------------------------------
// ActivateAllAugs()
// ----------------------------------------------------------------------

exec function ActivateAllAugs()
{
	if (AugmentationSystem != None)
		AugmentationSystem.ActivateAll();
}

// ----------------------------------------------------------------------
// DeactivateAllAugs()
// ----------------------------------------------------------------------

exec function DeactivateAllAugs(optional bool toggle)
{
	if (AugmentationSystem != None)
		//AugmentationSystem.DeactivateAll(true);
		AugmentationSystem.DeactivateAll(toggle);
}

// ----------------------------------------------------------------------
// SwitchAmmo()
// ----------------------------------------------------------------------

exec function SwitchAmmo()
{
	if (inHand != None && inHand.IsA('DeusExWeapon')) //CyberP: fixed vanilla accessed none
		DeusExWeapon(inHand).CycleAmmo();
}

// ----------------------------------------------------------------------
// RemoveInventoryType()
// ----------------------------------------------------------------------

function RemoveInventoryType(Class<Inventory> removeType)
{
	local Inventory item;

	item = FindInventoryType(removeType);

	if (item != None)
		DeleteInventory(item);
}


// ----------------------------------------------------------------------
// RadialMenuAddAug
// ----------------------------------------------------------------------

function RadialMenuAddAug(Augmentation aug)
{
	if ((rootWindow != None) && (aug != None))
		DeusExRootWindow(rootWindow).hud.radialAugMenu.AddItem(aug);
}

// ----------------------------------------------------------------------
// RadialMenuUpdateAug()
// ----------------------------------------------------------------------

function RadialMenuUpdateAug(Augmentation aug)
{
	if ((rootWindow != None) && (aug != None))
	   DeusExRootWindow(rootWindow).hud.radialAugMenu.UpdateItemStatus(aug);
}

// ----------------------------------------------------------------------
// RadialMenuQuickCancel()
// ----------------------------------------------------------------------

function RadialMenuQuickCancel()
{
	if (rootWindow != None)
	   DeusExRootWindow(rootWindow).hud.radialAugMenu.skipQuickToggle = true;
}

// ----------------------------------------------------------------------
// RadialMenuUpdateAug()
// ----------------------------------------------------------------------

function RadialMenuToggleCurrentAug()
{
	if (rootWindow != None)
	   DeusExRootWindow(rootWindow).hud.radialAugMenu.ToggleCurrent();
}

// ----------------------------------------------------------------------
// RadialMenuClear()
// ----------------------------------------------------------------------

function RadialMenuClear()
{
	DeusExRootWindow(rootWindow).hud.radialAugMenu.Clear();
}


// ----------------------------------------------------------------------
// AddAugmentationDisplay()
// ----------------------------------------------------------------------

function AddAugmentationDisplay(Augmentation aug)
{
	//DEUS_EX AMSD Added none check here.
	if ((rootWindow != None) && (aug != None))
		DeusExRootWindow(rootWindow).hud.activeItems.AddIcon(aug.SmallIcon, aug);
}

// ----------------------------------------------------------------------
// RemoveAugmentationDisplay()
// ----------------------------------------------------------------------

function RemoveAugmentationDisplay(Augmentation aug)
{
	DeusExRootWindow(rootWindow).hud.activeItems.RemoveIcon(aug);
}

// ----------------------------------------------------------------------
// ClearAugmentationDisplay()
// ----------------------------------------------------------------------

function ClearAugmentationDisplay()
{
	DeusExRootWindow(rootWindow).hud.activeItems.ClearAugmentationDisplay();
}

// ----------------------------------------------------------------------
// UpdateAugmentationDisplayStatus()
// ----------------------------------------------------------------------

function UpdateAugmentationDisplayStatus(Augmentation aug)
{
	DeusExRootWindow(rootWindow).hud.activeItems.UpdateAugIconStatus(aug);
}

// ----------------------------------------------------------------------
// AddChargedDisplay()
// ----------------------------------------------------------------------

function AddChargedDisplay(ChargedPickup item)
{
	if ( (PlayerIsClient()) || (Level.NetMode == NM_Standalone) )
	  DeusExRootWindow(rootWindow).hud.activeItems.AddIcon(item.ChargedIcon, item);
}

// ----------------------------------------------------------------------
// RemoveChargedDisplay()
// ----------------------------------------------------------------------

function RemoveChargedDisplay(ChargedPickup item)
{
	if ( (PlayerIsClient()) || (Level.NetMode == NM_Standalone) )
	  DeusExRootWindow(rootWindow).hud.activeItems.RemoveIcon(item);
}

// ----------------------------------------------------------------------
// ActivateKeypadWindow()
// DEUS_EX AMSD Has to be here because player doesn't own keypad, so
// func rep doesn't work right.
// ----------------------------------------------------------------------
function ActivateKeypadWindow(Keypad KPad, bool bHacked)
{
	KPad.ActivateKeypadWindow(Self, bHacked);
}

function KeypadRunUntriggers(Keypad KPad)
{
	KPad.RunUntriggers(Self);
}

function KeypadRunEvents(Keypad KPad, bool bSuccess)
{
	KPad.RunEvents(Self, bSuccess);
}

function KeypadToggleLocks(Keypad KPad)
{
	KPad.ToggleLocks(Self);
}

// ----------------------------------------------------------------------
// Multiplayer computer functions
// ----------------------------------------------------------------------

//server->client (computer to frobber)
function InvokeComputerScreen(Computers computerToActivate, float CompHackTime, float ServerLevelTime)
{
	local NetworkTerminal termwindow;
	local DeusExRootWindow root;

	computerToActivate.LastHackTime = CompHackTime + (Level.TimeSeconds - ServerLevelTime);

	ActiveComputer = ComputerToActivate;

	//only allow for clients or standalone
	if ((Level.NetMode != NM_Standalone) && (!PlayerIsClient()))
	{
	  ActiveComputer = None;
	  CloseComputerScreen(computerToActivate);
	  return;
	}

	root = DeusExRootWindow(rootWindow);
	if (root != None)
	{
	  termwindow = NetworkTerminal(root.InvokeUIScreen(computerToActivate.terminalType, True));
	  if (termwindow != None)
	  {
			computerToActivate.termwindow = termwindow;
		 termWindow.SetCompOwner(computerToActivate);
		 // If multiplayer, start hacking if there are no users
		 if ((Level.NetMode != NM_Standalone) && (!termWindow.bHacked) && (computerToActivate.NumUsers() == 0) &&
			 (termWindow.winHack != None) && (termWindow.winHack.btnHack != None))
		 {
			termWindow.winHack.StartHack();
			termWindow.winHack.btnHack.SetSensitivity(False);
			termWindow.FirstScreen=None;
		 }
		 termWindow.ShowFirstScreen();
	  }
	}
	if ((termWindow == None)  || (root == None))
	{
	  CloseComputerScreen(computerToActivate);
	  ActiveComputer = None;
	}
}


// CloseThisComputer is for the client (used at the end of a mp match)

function CloseThisComputer( Computers comp )
{
	if ((comp != None) && ( comp.termwindow != None ))
		comp.termwindow.CloseScreen("EXIT");
}

//client->server (window to player)
function CloseComputerScreen(Computers computerToClose)
{
	computerToClose.CloseOut();
}

//client->server (window to player)
function SetComputerHackTime(Computers computerToSet, float HackTime, float ClientLevelTime)
{
	computerToSet.lastHackTime = HackTime + (Level.TimeSeconds - ClientLevelTime);
}

//client->server (window to player)
function UpdateCameraRotation(SecurityCamera camera, Rotator rot)
{
	camera.DesiredRotation = rot;
}

//client->server (window to player)
function ToggleCameraState(SecurityCamera cam, ElectronicDevices compOwner, optional bool bHacked)
{
    //If we're active, or we were rebooting, and we logged in, then disable
	if ((cam.bActive || cam.bRebooting) && !bHacked)
	{
	  cam.UnTrigger(compOwner, self);
	  cam.team = -1;
	}
    //Set to reboot
    else if (cam.bActive && bHacked)
    {
        cam.UnTrigger(compOwner, self);
        cam.team = -1;
        cam.StartReboot(self);
    }
    //Re-enable
	else
	{
      cam.bRebooting = false;
      cam.disableTime = 0;
	  MakeCameraAlly(cam);
	  cam.Trigger(compOwner, self);
	}

	// Make sure the camera isn't in bStasis=True
	// so it responds to our every whim.
	cam.bStasis = False;
}

//client->server (window to player)
function SetTurretState(AutoTurret turret, bool bActive, bool bDisabled, bool bHacked)
{
    if (!bHacked)
    {
        turret.disableTime = 0;
        turret.bRebooting = false;
    }
    else
    {
        turret.StartReboot(self);
    }
	turret.bActive   = bActive;
	turret.bDisabled = bDisabled;
	turret.bComputerReset = False;
}

//client->server (window to player)
function SetTurretTrackMode(ComputerSecurity computer, AutoTurret turret, bool bTrackPlayers, bool bTrackPawns,bool bHacked)
{
	local String str;
    
    if (bHacked)
    {
        turret.StartReboot(self);
    }
    else
    {
        turret.disableTime = 0;
        turret.bRebooting = false;
    }

	turret.bTrackPlayersOnly = bTrackPlayers;
	turret.bTrackPawnsOnly   = bTrackPawns;
	turret.bComputerReset = False;

	//in multiplayer, behave differently
	//set the safe target to ourself.
	if (Level.NetMode != NM_Standalone)
	{
	  //we abuse the names of the booleans here.
		turret.SetSafeTarget( Self );

		if (Role == ROLE_Authority)
		{
			if ( TeamDMGame(DXGame) != None )
			{
				computer.team = PlayerReplicationInfo.team;
				turret.team = PlayerReplicationInfo.Team;
				if ( !turret.bDisabled )
				{
					str = TakenOverString $ turret.titleString $ ".";
					TeamSay( str );
				}
			}
			else
			{
				computer.team = PlayerReplicationInfo.PlayerID;
				turret.team = PlayerReplicationInfo.PlayerID;
			}
		}
	}
}

//client->server (window to player)
function MakeCameraAlly(SecurityCamera camera)
{
	Camera.SafeTarget = Self;
	if (Level.Game.IsA('TeamDMGame'))
	  Camera.Team = PlayerReplicationInfo.Team;
	else
	  Camera.Team = PlayerReplicationInfo.PlayerID;
}

//client->server (window to player)
function PunishDetection(int DamageAmount)
{
	if (DamageAmount > 0)
	  TakeDamage(DamageAmount, None, vect(0,0,0), vect(0,0,0), 'EMP');
}

// ----------------------------------------------------------------------
// AddDamageDisplay()
//
// Turn on the correct damage type icon on the HUD
// Note that these icons naturally fade out after a few seconds,
// so there is no need to turn them off
// ----------------------------------------------------------------------

function AddDamageDisplay(name damageType, vector hitOffset)
{
	DeusExRootWindow(rootWindow).hud.damageDisplay.AddIcon(damageType, hitOffset);
}

// ----------------------------------------------------------------------
// SetDamagePercent()
//
// Set the percentage amount of damage that's being absorbed
// ----------------------------------------------------------------------

function SetDamagePercent(float percent)
{
	DeusExRootWindow(rootWindow).hud.damageDisplay.SetPercent(percent);
}

// ----------------------------------------------------------------------
// default sound functions
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// PlayBodyThud()
//
// this is called by MESH NOTIFY
// ----------------------------------------------------------------------

function PlayBodyThud()
{
	PlaySound(sound'BodyThud', SLOT_Interact);
}

// ----------------------------------------------------------------------
// GetWallMaterial()
//
// gets the name of the texture group that we are facing
// ----------------------------------------------------------------------

function name GetWallMaterial(out vector wallNormal)
{
	local vector EndTrace, HitLocation, HitNormal;
	local actor target;
	local int texFlags, grabDist;
	local name texName, texGroup;

	// if we are falling, then increase our grabbing distance
	if (Physics == PHYS_Falling)
		grabDist = 3.0;
	else
		grabDist = 1.5;

	// trace out in front of us
	EndTrace = Location + (Vector(Rotation) * CollisionRadius * grabDist);

 	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
	{
		if ((target == Level) || target.IsA('Mover'))
			break;
	}

	wallNormal = HitNormal;

	return texGroup;
}

// ----------------------------------------------------------------------
// GetFloorMaterial()
//
// gets the name of the texture group that we are standing on
// ----------------------------------------------------------------------

function name GetFloorMaterial()
{
	local vector EndTrace, HitLocation, HitNormal;
	local actor target;
	local int texFlags;
	local name texName, texGroup;

	// trace down to our feet
	EndTrace = Location - CollisionHeight * 2 * vect(0,0,1);

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
	{
		if ((target == Level) || target.IsA('Mover'))
			break;
	}

    if (target != None && target.IsA('DeusExMover')) //CyberP: special case for movers.
    {
     if (target.IsA('BreakableGlass'))
        texGroup = 'Glass';
     else if (DeusExMover(target).FragmentClass == Class'DeusEx.WoodFragment')
        texGroup = 'Wood';
     else if (DeusExMover(target).FragmentClass == Class'DeusEx.MetalFragment')
        texGroup = 'Metal';
     else
        texGroup = 'Stucco';
    }
    SpecTex = texName;
	return texGroup;
}

function name GetVentMaterial()
{
	local vector EndTrace, HitLocation, HitNormal;
	local actor target;
	local int texFlags;
	local name texName, texGroup;

	// trace down to our feet
	EndTrace = Location - CollisionHeight * 2 * vect(0,0,1);

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
	{
		if ((target == Level) || target.IsA('Mover'))
			break;
	}

	return texName;
}

// ----------------------------------------------------------------------
// PlayFootStep()
//
// plays footstep sounds based on the texture group
// yes, I know this looks nasty -- I'll have to figure out a cleaner
// way to do this
// ----------------------------------------------------------------------

simulated function PlayFootStep()
{
	local Sound stepSound;
	local float rnd;
	local float speedFactor, massFactor;
	local float volume, pitch, range;
	local float radius, mult;
	local float volumeMultiplier,volumeMod;
	local DeusExPlayer pp;
	local bool bOtherPlayer;
	local float shakeTime, shakeRoll, shakeVert;

	// Only do this on ourself, since this takes into account aug stealth and such
	if ( Level.NetMode != NM_StandAlone )
		pp = DeusExPlayer( GetPlayerPawn() );

	if ( pp != Self )
		bOtherPlayer = True;
	else
		bOtherPlayer = False;

	rnd = FRand();

	volumeMultiplier = 1.0;
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
	{
		volumeMultiplier = 0.5;
		if (rnd < 0.5)
			stepSound = Sound'Swimming';
		else
			stepSound = Sound'Treading';
	}
	else if (FootRegion.Zone.bWaterZone)
	{
		volumeMultiplier = 1.0;
		if (rnd < 0.33)
			stepSound = Sound'WaterStep1';
		else if (rnd < 0.66)
			stepSound = Sound'WaterStep2';
		else
			stepSound = Sound'WaterStep3';
	}
	else
	{
		switch(FloorMaterial)
		{
			case 'Textile':
			case 'Paper':
				volumeMultiplier = 0.6;
				if (rnd < 0.25)
					stepSound = Sound'CarpetStep1';
				else if (rnd < 0.5)
					stepSound = Sound'CarpetStep2';
				else if (rnd < 0.75)
					stepSound = Sound'CarpetStep3';
				else
					stepSound = Sound'CarpetStep4';
				break;

                case 'Earth':
                volumeMultiplier = 0.8;
				if (rnd < 0.25)
					stepSound = Sound'DIRT1';
				else if (rnd < 0.5)
					stepSound = Sound'DIRT2';
				else if (rnd < 0.75)
					stepSound = Sound'DIRT3';
				else
					stepSound = Sound'DIRT4';
				break;

			case 'Foliage':
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'GrassStep1';
				else if (rnd < 0.5)
					stepSound = Sound'GrassStep2';
				else if (rnd < 0.75)
					stepSound = Sound'GrassStep3';
				else
					stepSound = Sound'GrassStep4';
				break;

			case 'Metal':
				volumeMultiplier = 0.9;
			if (SpecTex == 'A51_Floor_01')
			{
			    if (rnd < 0.25)
					stepSound = Sound'GRATE1';
				else if (rnd < 0.5)
					stepSound = Sound'GRATE2';
				else if (rnd < 0.75)
					stepSound = Sound'GRATE3';
				else
					stepSound = Sound'GRATE4';
			}
			else if (SpecTex == 'metalgrate_a')
			{
                if (rnd < 0.2)
			     	stepSound = Sound'GMDXSFX.Player.metal_grate_01';
                else if (rnd < 0.4)
			   		stepSound = Sound'GMDXSFX.Player.metal_grate_02';
			    else if (rnd < 0.6)
			     	stepSound = Sound'GMDXSFX.Player.metal_grate_03';
		  	    else if (rnd < 0.8)
			     	stepSound = Sound'GMDXSFX.Player.metal_grate_04';
		  	    else
				   	stepSound = Sound'GMDXSFX.Player.metal_grate_05';
			}
			else
			{
            	if (rnd < 0.25)
					stepSound = Sound'MetalStep1';
				else if (rnd < 0.5)
					stepSound = Sound'MetalStep2';
				else if (rnd < 0.75)
					stepSound = Sound'MetalStep3';
				else
					stepSound = Sound'MetalStep4';
			}
				break;

			case 'Ladder':
				volumeMultiplier = 1.0;
                if (rnd < 0.25)
					stepSound = Sound'GRATE1';
				else if (rnd < 0.5)
					stepSound = Sound'GRATE2';
				else if (rnd < 0.75)
					stepSound = Sound'GRATE3';
				else
					stepSound = Sound'GRATE4';
                 break;

            case 'Glass':
            volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'GLASS1';
				else if (rnd < 0.5)
					stepSound = Sound'GLASS2';
				else if (rnd < 0.75)
					stepSound = Sound'GLASS3';
				else
					stepSound = Sound'GLASS4';
				break;

			case 'Ceramic':
			case 'Tiles':
				volumeMultiplier = 0.75;
				if (rnd < 0.25)
					stepSound = Sound'TileStep1';
				else if (rnd < 0.5)
					stepSound = Sound'TileStep2';
				else if (rnd < 0.75)
					stepSound = Sound'TileStep3';
				else
					stepSound = Sound'TileStep4';
				break;

			case 'Wood':
				volumeMultiplier = 0.825;
				if (SpecTex == 'OldeOakPlank_A')
				{
				    if (rnd < 0.2)
			     		stepSound = Sound'GMDXSFX.Player.Wood_01';
				    else if (rnd < 0.4)
			     		stepSound = Sound'GMDXSFX.Player.Wood_02';
				    else if (rnd < 0.6)
			     		stepSound = Sound'GMDXSFX.Player.Wood_03';
			     	else if (rnd < 0.8)
			     		stepSound = Sound'GMDXSFX.Player.Wood_04';
			    	else
				    	stepSound = Sound'GMDXSFX.Player.Wood_05';
				}
				else
				{
			    	if (rnd < 0.25)
			     		stepSound = Sound'WoodStep1';
			       	else if (rnd < 0.5)
			        	stepSound = Sound'WoodStep2';
			       	else if (rnd < 0.75)
				       	stepSound = Sound'WoodStep3';
				    else
				       	stepSound = Sound'WoodStep4';
				}
                break;

            case 'Stucco':
            volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'CARDB1';
				else if (rnd < 0.5)
					stepSound = Sound'CARDB2';
				else if (rnd < 0.75)
					stepSound = Sound'CARDB3';
				else
					stepSound = Sound'CARDB4';
				break;

			case 'Brick':
			case 'Concrete':
			volumeMultiplier = 0.9;
				if (rnd < 0.25)
					stepSound = Sound'STEP1';
				else if (rnd < 0.5)
					stepSound = Sound'STEP2';
				else if (rnd < 0.75)
					stepSound = Sound'STEP3';
				else
					stepSound = Sound'STEP4';
				break;

			/*case 'Stone':
				volumeMultiplier = 0.8;
				if (rnd < 0.25)
					stepSound = Sound'GMDXSFX.Player.concrete_ct_01';
				else if (rnd < 0.5)
					stepSound = Sound'GMDXSFX.Player.concrete_ct_02';
				else if (rnd < 0.75)
					stepSound = Sound'GMDXSFX.Player.concrete_ct_03';
				else
					stepSound = Sound'GMDXSFX.Player.concrete_ct_04';
				break;
            */
			default:
                    volumeMultiplier = 0.8;
					if (rnd < 0.25)
			    		stepSound = Sound'StoneStep1';
				    else if (rnd < 0.5)
			     		stepSound = Sound'StoneStep2';
			    	else if (rnd < 0.75)
			     		stepSound = Sound'StoneStep3';
			    	else
			     		stepSound = Sound'StoneStep4';
					break;
		}
	}

	// compute sound volume, range and pitch, based on mass and speed
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
		speedFactor = WaterSpeed/180.0;
	else
		speedFactor = VSize(Velocity)/190.0; //CyberP: was 180

	massFactor  = Mass/150.0;
	radius      = 375.0;
	volume      = (speedFactor+0.2) * massFactor;
	range       = radius * volume;
	pitch       = (volume+0.5);
	volume      = FClamp(volume, 0, 1.0) * 0.5;		// Hack to compensate for increased footstep volume.
	range       = FClamp(range, 0.01, radius*4);
	pitch       = FClamp(pitch, 1.0, 1.5);

	// AugStealth decreases our footstep volume
	volume *= RunSilentValue;

     //CyberP: new sounds for landing from height.
    if (Velocity.Z < -350)
    {
       if (FloorMaterial=='Wood' && Velocity.Z > -500)
	      stepSound=sound'WoodLand';
	   else if (FloorMaterial=='Concrete' || FloorMaterial=='Stone' || FloorMaterial=='Tile')
          stepSound=sound'pcconcfall1';
	   else if (FloorMaterial=='Wood')
	      stepSound=sound'DSOOF2';
       else if (FloorMaterial=='Textile' || FloorMaterial=='Paper')
	      stepSound=sound'CarpetLand';
	   else if (FloorMaterial=='Earth' || FloorMaterial=='Foliage')
	      stepSound=sound'pl_jumpland1';

       if (CombatDifficulty >= 3.0)
          volume*=1.3;
       else
          volume*=1.15;

       if (Velocity.Z < -500)
       {
	   if (SpecTex == 'A51_Floor_01' || FloorMaterial=='Ladder')
          PlaySound(sound'bouncemetal',SLOT_None,volume*1.5,,,0.6);
       else if (SpecTex == 'metalgrate_a')
          PlaySound(sound'metal_chainlink_07',SLOT_None,volume*1.5,,,0.9);
       else if (FloorMaterial=='Metal')
          PlaySound(sound'MetalDoorClose',SLOT_None,volume*1.5,,,1.5);
	   }
    }

	//GMDX: modded for skill system stealth
	volumeMod=0.9;
	if (SkillSystem!=None && SkillSystem.GetSkillLevel(class'SkillStealth')>=1)
	{
		if (abs(Velocity.z)>20) volumeMod*=0.9; //no point really having landed caclucate when footstep overrides it, so a nasty hack is afoot.
	}
	//if (bJustLanded) log("PlayFootStep bJustLanded vol="@volume@": mod="@volumeMod@": Z="@Velocity.Z);

    if (IsCrouching() && velocity.Z == 0)  //CyberP: only applies when speed enhancement is active.
       volume *= 1.5;
    else if (bIsWalking)
       volume *= 0.5;  //CyberP: can walk up behind enemies.

    //BroadcastMessage(volume);

    stepCount++;
    PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
    if (!bHardCoreMode) //CyberP: Nerf footsteps a touch on lower diffs.
        range*=0.9;
	AISendEvent('LoudNoise', EAITYPE_Audio, volume*volumeMultiplier*volumeMod, range*volumeMultiplier);
}

// ----------------------------------------------------------------------
// IsHighlighted()
//
// checks to see if we should highlight this actor
// ----------------------------------------------------------------------

function bool IsHighlighted(actor A)
{
	if (bBehindView)
		return False;

	if (A != None)
	{
        //strange that we have to do this manually...
        if (A.IsA('SpyDrone') && bSpyDroneSet)
            return true;

		if (A.bDeleteMe || A.bHidden)
			return False;

		if (A.IsA('Pawn'))
		{
			if (!bNPCHighlighting)
				return False;
		}

		if (A.IsA('DeusExMover') && !DeusExMover(A).bHighlight)
			return False;
		else if (A.IsA('Mover') && !A.IsA('DeusExMover'))
			return False;
		else if (A.IsA('DeusExDecoration') && !DeusExDecoration(A).bHighlight)
			return False;
		else if (A.IsA('DeusExCarcass') && !DeusExCarcass(A).bHighlight)
			return False;
		else if (A.IsA('ThrownProjectile') && !ThrownProjectile(A).bHighlight)
			return False;
		else if (A.IsA('DeusExProjectile') && (!DeusExProjectile(A).bStuck || A.IsA('RubberBullet')))
			return False;
		else if (A.IsA('ScriptedPawn') && !ScriptedPawn(A).bHighlight)
			return False;
	}

	return True;
}

// ----------------------------------------------------------------------
// IsFrobbable()
//
// is this actor frobbable?
// ----------------------------------------------------------------------

function bool IsFrobbable(actor A)
{
	if ((!A.bHidden)) //GMDX: so you it doesnt hightlight spoof &&(!A.IsA('WeaponGEPmounted'))
		if (A.IsA('Mover') || A.IsA('DeusExDecoration') || A.IsA('Inventory') ||
			A.IsA('ScriptedPawn') || A.IsA('DeusExCarcass') || A.IsA('DeusExProjectile'))
			return True;

	return False;
}

// ----------------------------------------------------------------------
// HighlightCenterObject()
//
// checks to see if an object can be frobbed, if so, then highlight it
// ----------------------------------------------------------------------

function HighlightCenterObject()
{
	local Actor target, smallestTarget;
	local Vector HitLoc, HitNormal, StartTrace, EndTrace;
	local DeusExRootWindow root;
	local float minSize;
	local bool bFirstTarget;
	local int skillz;
	local float shakeTime, shakeRoll, shakeVert;
    local float rnd;

    if (IsInState('Dying'))
		return;

	root = DeusExRootWindow(rootWindow);

	// only do the trace every tenth of a second
	if (FrobTime >= 0.1)
	{
	  LadTime+=FrobTime;
	  if (LadTime > 0.4) //CyberP: primitive hack for ladder climbing sfx.
	  {
	   if (Velocity.Z != 0)
       {
        //if (!Region.Zone.bWaterZone && Physics != PHYS_Falling)
        //   SetPhysics(PHYS_Falling);
	    if (bOnLadder)//(WallMaterial == 'Ladder')
        {
           bIsWalking=True;
           if (AugmentationSystem.GetAugLevelValue(class'DeusEx.AugStealth') < 0)
           {
             if (PerkManager.GetPerkWithClass(class'DeusEx.PerkNimble').bPerkObtained == false)
             {
                rnd = FRand();
                if (rnd < 0.25) PlaySound(Sound'GMDXSFX.Player.pl_ladder1',SLOT_None,0.75);
                else if (rnd < 0.5) PlaySound(Sound'GMDXSFX.Player.pl_ladder2',SLOT_None,0.75);
                else if (rnd < 0.75) PlaySound(Sound'GMDXSFX.Player.pl_ladder3',SLOT_None,0.75);
                else PlaySound(Sound'GMDXSFX.Player.pl_ladder4',SLOT_None,0.75);
                AISendEvent('LoudNoise',EAITYPE_Audio,,320);
             }
           }
        }
       }
       LadTime = 0;
      }
      if (inHand != None && inHand.IsA('Multitool'))
          	{
            	if (self.IsA('DeusExPlayer') && PerkManager.GetPerkWithClass(class'DeusEx.PerkWirelessStrength').bPerkObtained == true)
                MaxFrobDistance = 768;
          	}
     	else
           	{
	            MaxFrobDistance = 112;
            }
		// figure out how far ahead we should trace
		StartTrace = Location;
		EndTrace = Location + (Vector(ViewRotation) * MaxFrobDistance);

		// adjust for the eye height
		StartTrace.Z += BaseEyeHeight;
		EndTrace.Z += BaseEyeHeight;

		smallestTarget = None;
		minSize = 99999;
		bFirstTarget = True;

     if (inHand != none && inHand.IsA('Multitool'))
     {
        foreach TraceActors(class'Actor', target, HitLoc, HitNormal, EndTrace, StartTrace)
		{
		if (IsFrobbable(target) && (target != CarriedDecoration))
		     {
                if (target.IsA('HackableDevices'))
			    {
                }
			    else
			    {
			    MaxFrobDistance=112;
		        StartTrace = Location;
		        EndTrace = Location + (Vector(ViewRotation) * MaxFrobDistance);
		        StartTrace.Z += BaseEyeHeight;
		        EndTrace.Z += BaseEyeHeight;
                }
             }
        }
     }
		// find the object that we are looking at
		// make sure we don't select the object that we're carrying
		// use the last traced object as the target...this will handle
		// smaller items under larger items for example
		// ScriptedPawns always have precedence, though
		foreach TraceActors(class'Actor', target, HitLoc, HitNormal, EndTrace, StartTrace)
		{
			if (IsFrobbable(target) && (target != CarriedDecoration))
			{
                if (target.IsA('ScriptedPawn'))
				{
					smallestTarget = target;
					break;
				}
				else if (target.IsA('Mover') && bFirstTarget)
				{
					smallestTarget = target;
					break;
				}
				else if (target.CollisionRadius < minSize)
				{
					minSize = target.CollisionRadius;
					smallestTarget = target;
					bFirstTarget = False;
				}
			}
		}
		FrobTarget = smallestTarget;

		// reset our frob timer
		FrobTime = 0;
	}
}

// ----------------------------------------------------------------------
// Landed()
//
// copied from Engine.PlayerPawn new landing code for Deus Ex
// zero damage if falling from 15 feet or less
// scaled damage from 15 to 60 feet
// death over 60 feet
// ----------------------------------------------------------------------

function Landed(vector HitNormal)
{
	local vector legLocation;
	local int augLevel;
	local float augReduce, dmg, skillStealthMod;
    local float shakeTime, shakeRoll, shakeVert;
	//Note - physics changes type to PHYS_Walking by default for landed pawns
	PlayLanded(Velocity.Z);
//    PlaySound(Land, SLOT_Interact, 1); //this is aweful sound, leaving it to footstep
    bIcarusClimb = False;
	if (Velocity.Z < -1.4 * JumpZ)
	{
		//MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		if ((Velocity.Z < -800) && (ReducedDamageType != 'All'))
			if ( Role == ROLE_Authority )
			{
				// check our jump augmentation and reduce falling damage if we have it
				// jump augmentation doesn't exist anymore - use Speed instaed
				// reduce an absolute amount of damage instead of a relative amount
				augReduce = 0;
				if (AugmentationSystem != None)
				{
				    if (AugmentationSystem.GetAugLevelValue(class'AugStealth') != -1.0) //CyberP: silent running also reduces falling dam too
				        augLevel = AugmentationSystem.GetClassLevel(class'AugStealth');
				    else
					    augLevel = AugmentationSystem.GetClassLevel(class'AugSpeed');
					if (augLevel >= 0)
						augReduce = 15 * (augLevel+1);
				}

                if (AugmentationSystem.GetAugLevelValue(class'DeusEx.AugIcarus') == -1.0)
                {
				dmg = Max((-0.16 * (Velocity.Z + 700)) - augReduce, 0);
				if (combatDifficulty < 2.0)
				   dmg *= 0.75;
				else if (bHardCoreMode && bExtraHardcore)
                   dmg *= 1.4;
				legLocation = Location + vect(-1,0,-1);			// damage left leg
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');

				legLocation = Location + vect(1,0,-1);			// damage right leg
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');

				dmg = Max((-0.06 * (Velocity.Z + 700)) - augReduce, 0);
				legLocation = Location + vect(0,0,1);			// damage torso
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');
				if (dmg > 20)
				PlaySound(sound'pl_fallpain3',SLOT_None,2.0);
				}
			}
	}
	if (Velocity.Z < -460)//(Abs(Velocity.Z) >= 1.5 * JumpZ)//GMDX add compression to jump/fall (cosmetic) //CyberP: edited
	{
	camInterpol = 0.4;
	if (IsCrouching())
	   PlayFootstep();
	if (inHand != none && (inHand.IsA('NanoKeyRing') || inHand.IsA('DeusExPickup')))
	{
	}
	else
	{
	    if (inHand != None && inHand.IsA('DeusExWeapon') && (DeusExWeapon(inHand).bAimingDown || AnimSequence == 'Shoot'))
	    {
	    RecoilTime=default.RecoilTime;
		RecoilShake.Z-=lerp(min(Abs(Velocity.Z),4.0*310)/(4.0*310),0,3.0); //CyberP: 7
		RecoilShake.Y-=lerp(min(Abs(Velocity.Z),4.0*310)/(4.0*310),0,2.0);
		RecoilShaker(vect(1,1,2));
	    }
	    else
	    {
	    RecoilTime=default.RecoilTime;
		RecoilShake.Z-=lerp(min(Abs(Velocity.Z),4.0*310)/(4.0*310),0,16.0); //CyberP: 7
		RecoilShake.Y-=lerp(min(Abs(Velocity.Z),4.0*310)/(4.0*310),0,6.0);
		RecoilShaker(vect(1,2,6));
		shakeTime= 0.15; shakeRoll = 0; shakeVert = -8; shakeView(shakeTime,shakeRoll,shakeVert);
		}
	}
	}

	//if ( (Level.Game != None) && (Level.Game.Difficulty > 0) && (Abs(Velocity.Z) > 0.75 * 400) )
	//{//GMDX: skill system stealth mod
    //if (SkillSystem!=None && SkillSystem.GetSkillLevel(class'SkillStealth')==0 &&
    //AugmentationSystem != None && AugmentationSystem.GetAugLevelValue('AugStealth') == -1.0)
      //   AISendEvent('LoudNoise', EAITYPE_Audio,, 512);
	  //skillStealthMod=0.075;
		//else skillStealthMod=0.8;//0.15;

	//skillStealthMod*= Level.Game.Difficulty * (0.01+fMin(abs(Velocity.Z/100.0),3));

	//MakeNoise(skillStealthMod );
    //log("LANDED VOL: "@skillStealthMod@"  "@fMin(abs(Velocity.Z),640));
    //if (SkillSystem!=None && SkillSystem.GetSkillLevel(class'SkillStealth')==0) //CyberP: fuck it, we'll just have it not send at all
	//AISendEvent('LoudNoise', EAITYPE_Audio, skillStealthMod, fMin(Abs(Velocity.Z*1.5),536));
	//}
	bJustLanded = true;
}

function BumpWall( vector HitLocation, vector HitNormal )
{
local AugIcarus icar;
local actor     acti;

  super.BumpWall(HitLocation,HitNormal);

  if (VSize(Velocity) > 430) //CyberP: Smash through glass at high velocities.
  {
      acti = Trace(HitLocation,HitNormal,Location + (velocity*0.1),Location); //CyberP: Trace in the direction we are moving
      if (acti != None && acti.IsA('DeusExMover'))
      {
         if (DeusExMover(acti).DamageThreshold < 4 && DeusExMover(acti).bBreakable) //CyberP: Limit it to breakable glass only
         {
             DeusExMover(acti).TakeDamage(10,self,DeusExMover(acti).Location,vect(0,0,0),'shot');
             TakeDamage(5,self,Location,vect(0,0,0),'shot'); //CyberP: Hurts the player a bit too!
         }
      }
      if (VSize(Velocity) > 1200 && Velocity.Z > -600)
      {
         TakeDamage(6,self,vect(0,0,0),vect(0,0,0),'shot');
      }
  }
  if (RocketTargetMaxDistance==40001.000000)
  {
    icar = AugIcarus(AugmentationSystem.FindAugmentation(class'AugIcarus'));
    if (icar.incremental > 1.75 - AugmentationSystem.GetAugLevelValue(class'DeusEx.AugIcarus'))
    {
       icar.incremental = 2;
    }
  }
}

//exec function startMantling()
//{
//}

// ----------------------------------------------------------------------
// SupportActor()
//
// Copied directly from ScriptedPawn.uc
// Called when something lands on us
// ----------------------------------------------------------------------

function SupportActor(Actor standingActor)
{
	local vector newVelocity;
	local float  angle;
	local float  zVelocity;
	local float  baseMass;
	local float  standingMass;
	local vector damagePoint;
	local float  damage;

	zVelocity    = standingActor.Velocity.Z;
	standingMass = FMax(1, standingActor.Mass);
	baseMass     = FMax(1, Mass);
	damagePoint  = Location + vect(0,0,1)*(CollisionHeight-1);
	damage       = (1 - (standingMass/baseMass) * (zVelocity/100));

	// Have we been stomped?
	if ((zVelocity*standingMass < -7500) && (damage > 0))
		TakeDamage(damage, standingActor.Instigator, damagePoint, 0.2*standingActor.Velocity, 'stomped');

	// Bounce the actor off the player
	angle = FRand()*Pi*2;
	newVelocity.X = cos(angle);
	newVelocity.Y = sin(angle);
	newVelocity.Z = 0;
	newVelocity *= FRand()*35 + 35;
	newVelocity += standingActor.Velocity;
	newVelocity.Z = 100;
	standingActor.Velocity = newVelocity;
	standingActor.SetPhysics(PHYS_Falling);
}

// ----------------------------------------------------------------------
// SpawnCarcass()
//
// copied from Engine.PlayerPawn
// modified to let carcasses have inventories
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
	local DeusExCarcass carc;
	local Inventory item;
	local Vector loc;

	// don't spawn a carcass if we've been gibbed
	if (Health < -40) //CyberP: gib
	  return None;

	carc = DeusExCarcass(Spawn(CarcassType));
	if (carc != None)
	{
	    if (bRemoveVanillaDeath)
	        carc.DrawScale = 0.000050;
		carc.Initfor(self);

		// move it down to the ground
		loc = Location;
		loc.z -= CollisionHeight;
		loc.z += carc.CollisionHeight;
		carc.SetLocation(loc);

		if (Player != None)
			carc.bPlayerCarcass = true;
		MoveTarget = carc; //for Player 3rd person views

		// give the carcass the player's inventory
		for (item=Inventory; item!=None; item=Inventory)
		{
			DeleteInventory(item);
		//	carc.AddInventory(item);   //CyberP: commented out to prevent suicide inventory exploit.
		}
	}

	return carc;
}

// ----------------------------------------------------------------------
// Reloading()
//
// Called when one of the player's weapons is reloading
// ----------------------------------------------------------------------

function Reloading(DeusExWeapon weapon, float reloadTime)
{
	if (!IsLeaning() && !IsCrouching() && (Physics != PHYS_Swimming) && !IsInState('Dying'))
		PlayAnim('Reload', 1.0 / reloadTime, 0.1);
}
function DoneReloading(DeusExWeapon weapon)
{
    UpdateCrosshair();
}

// ----------------------------------------------------------------------
// HealPlayer()
// ----------------------------------------------------------------------

function int HealPlayer(int baseHealPoints, optional Bool bUseMedicineSkill)
{
	local float mult;
	local int adjustedHealAmount, aha2, tempaha;
	local int origHealAmount;
	local float dividedHealAmount;

	if (bUseMedicineSkill)
		adjustedHealAmount = CalculateSkillHealAmount(baseHealPoints);
	else
		adjustedHealAmount = baseHealPoints;

	origHealAmount = adjustedHealAmount;

    //if (!bHardCoreMode)                                                       //RSD: Removed since we now have a menu option
    //     fullUp = 0;

	if (adjustedHealAmount > 0)
	{
		if (bUseMedicineSkill)
			{
            PlaySound(sound'MedicalHiss', SLOT_None,,, 256);
            ClientFlash(1,vect(0,0,200));     //CyberP: flash when using medkits.
            }
		// Heal by 3 regions via multiplayer game
		if (( Level.NetMode == NM_DedicatedServer ) || ( Level.NetMode == NM_ListenServer ))
		{
		 // DEUS_EX AMSD If legs broken, heal them a little bit first
		 if (HealthLegLeft == 0)
		 {
			aha2 = adjustedHealAmount;
			if (aha2 >= 5)
			   aha2 = 5;
			tempaha = aha2;
			adjustedHealAmount = adjustedHealAmount - aha2;
			HealPart(HealthLegLeft, aha2);
			HealPart(HealthLegRight,tempaha);
				mpMsgServerFlags = mpMsgServerFlags & (~MPSERVERFLAG_LostLegs);
		 }
			HealPart(HealthHead, adjustedHealAmount);

			if ( adjustedHealAmount > 0 )
			{
				aha2 = adjustedHealAmount;
				HealPart(HealthTorso, aha2);
				aha2 = adjustedHealAmount;
				HealPart(HealthArmRight,aha2);
				HealPart(HealthArmLeft, adjustedHealAmount);
			}
			if ( adjustedHealAmount > 0 )
			{
				aha2 = adjustedHealAmount;
				HealPart(HealthLegRight, aha2);
				HealPart(HealthLegLeft, adjustedHealAmount);
			}
		}
		else
		{
			HealPartMedicalSkill(HealthHead, adjustedHealAmount);   //GMDX upgraded out
			//HealPartMedicalSkill(HealthTorso, adjustedHealAmount);  //GMDX upgraded out
			HealPartMedicalSkillDrunk(HealthTorso, adjustedHealAmount);         //RSD: upgraded out further
			HealPart(HealthLegRight, adjustedHealAmount);
			HealPart(HealthLegLeft, adjustedHealAmount);
			HealPart(HealthArmRight, adjustedHealAmount);
			HealPart(HealthArmLeft, adjustedHealAmount);
		}

		GenerateTotalHealth();

		adjustedHealAmount = origHealAmount - adjustedHealAmount;

		if (origHealAmount == baseHealPoints)
		{
			if (adjustedHealAmount == 1)
				ClientMessage(Sprintf(HealedPointLabel, adjustedHealAmount));
			else
				ClientMessage(Sprintf(HealedPointsLabel, adjustedHealAmount));
		}
		else
		{
			ClientMessage(Sprintf(HealedPointsLabel, adjustedHealAmount));
		}
	}

	return adjustedHealAmount;
}

// ----------------------------------------------------------------------
// GetMaxEnergy()
// Returns the max energy left after energy reservations
// ----------------------------------------------------------------------

function float GetMaxEnergy(optional bool trueMax)
{
    local int max;
    max = EnergyMax - AugmentationSystem.CalcEnergyReserve();

    if (Energy > max)
        Energy = max;

    if (trueMax)
        return EnergyMax;
    return FMax(0.0,max);
}

// ----------------------------------------------------------------------
// ChargePlayer()
// ----------------------------------------------------------------------

function int ChargePlayer(int baseChargePoints, optional bool showMessage)
{
	local int chargedPoints;

	chargedPoints = Min(GetMaxEnergy() - Int(Energy), baseChargePoints);

	Energy += chargedPoints;

    if (showMessage && chargedPoints > 0)
    {
        if (chargedPoints == 1)
            ClientMessage(sprintf(RechargedPointLabel,chargedPoints));
        else
            ClientMessage(sprintf(RechargedPointsLabel,chargedPoints));
    }

	return chargedPoints;
}

// ----------------------------------------------------------------------
// CalculateSkillHealAmount()
// ----------------------------------------------------------------------

function int CalculateSkillHealAmount(int baseHealPoints)
{
	local float mult;
	local int adjustedHealAmount;

	// check skill use
	if (SkillSystem != None)
	{
		/*mult = SkillSystem.GetSkillLevelValue(class'SkillMedicine');
        //RSD: Unfortunately we have to hack in the new medkit level values (30/45/65/90) here so they don't mess things up elsewhere
        if ((mult > 1.99)  && (mult < 2.01))
        	mult = 1.500000;
        else if ((mult > 2.49) && (mult < 2.51))
        	mult = 2.166667;
        else if ((mult > 2.99) && (mult < 3.01))
        	mult = 3.000000;
       	else mult = 1.000000;*/                                                 //RSD: this is dumb but I'd rather have the default be 30

       	mult = SkillSystem.GetSkillLevel(class'SkillMedicine');
        //RSD: Still hacking medkit level values (30/45/65/90), but 30% less stupidly
        if (mult == 1)
        	mult = 1.500000;
        else if (mult == 2)
        	mult = 2.166667;
        else if (mult == 3)
        	mult = 3.000000;
       	else mult = 1.000000;

		// apply the skill
		adjustedHealAmount = baseHealPoints * mult;
	}

	return adjustedHealAmount;
}

// ----------------------------------------------------------------------
// HealPart()
// ----------------------------------------------------------------------

function HealPart(out int points, out int amt)
{
	local int spill;

	points += amt;
	spill = points - 100;
	if (spill > 0)
		points = 100;
	else
		spill = 0;

	amt = spill;
}

// ----------------------------------------------------------------------
// by dasraiser for GMDX
// HealPart()Extended
// Medical Upgrade for Head Torso Base on Medical Skill Upgrade
// ----------------------------------------------------------------------
function HealPartMedicalSkill(out int points, out int amt)
{
	local int spill;
	local Skill sk;

	if (SkillSystem!=None)
	{
	  sk = SkillSystem.GetSkillFromClass(Class'DeusEx.SkillMedicine');
	  if (sk==None) HealPart(points,amt); //deal with default if no medical skill!!
	  else
	  {
		 points += amt;
		 spill = points - (100+sk.CurrentLevel*10);
		 if (spill > 0)
			points = (100+sk.CurrentLevel*10);
		 else
			spill = 0;
		 amt = spill;
	   }
	}
	else HealPart(points,amt); //deal with default if no skill system!!
}

//RSD: Yet another new function for the torso, so we can add drunk overhealing and zyme withdrawal penalty
function HealPartMedicalSkillDrunk(out int points, out int amt)
{
	local int spill;
	local Skill sk;
    local int AddictionAdd;                                           //RSD: Now get bonus max torso health from drinking, penalty for zyme
    
    AddictionAdd = AddictionManager.GetTorsoHealthBonus();                         //RSD: Get 5 bonus health for every 2 min on timer
	if (SkillSystem!=None)
	{
	  sk = SkillSystem.GetSkillFromClass(Class'DeusEx.SkillMedicine');
	  if (sk==None) HealPart(points,amt); //deal with default if no medical skill!!
	  else
	  {
		 points += amt;
		 spill = points - (100+sk.CurrentLevel*10+AddictionAdd);
		 if (spill > 0)
			points = (100+sk.CurrentLevel*10+AddictionAdd);
		 else
			spill = 0;
		 amt = spill;
	   }
	}
	else HealPart(points,amt); //deal with default if no skill system!!
}

// ----------------------------------------------------------------------
// HandleWalking()
//
// subclassed from PlayerPawn so we can control run/walk defaults
// ----------------------------------------------------------------------

function HandleWalking()
{
	//Super.HandleWalking(); //CyberP: super function override
    local rotator carried;

	// this is changed from Unreal -- default is now walk - DEUS_EX CNN
	bIsWalking = ((bRun == 0) || (IsCrouching())) && !Region.Zone.IsA('WarpZoneInfo');

	if ( CarriedDecoration != None )
	{
		if ( (Role == ROLE_Authority) && (standingcount == 0) )
			{PutCarriedDecorationInHand(true);}//CarriedDecoration = None; //CyberP: Really nice hack fix to a weird vanilla bug.
		if ( CarriedDecoration != None ) //verify its still in front
		{
			bIsWalking = true;
			if ( Role == ROLE_Authority )
			{
				carried = Rotator(CarriedDecoration.Location - Location);
				carried.Yaw = ((carried.Yaw & 65535) - (Rotation.Yaw & 65535)) & 65535;
				//if ( (carried.Yaw > 3072) && (carried.Yaw < 62463) )  //CyberP: Another fix
				//	DropDecoration();
			}
		}
	}

	//CyberP: super function override end

	if (bAlwaysRun)  //&& !bHardCoreMode
		bIsWalking = (bRun != 0) || IsCrouching();
	else
		bIsWalking = (bRun == 0) || IsCrouching();

	// handle the toggle walk key
	if (bToggleWalk)   //&& !bHardCoreMode
		bIsWalking = !bIsWalking;

    //SARGE: If we started running with the run key, untoggle crouch
    if (!bLastRun && bRun == 1 && IsCrouching() && !bAlwaysRun)
        SetCrouch(false);

    bLastRun = bool(bRun);
}

// ----------------------------------------------------------------------
// DoJump()
//
// copied from Engine.PlayerPawn
// Modified to let you jump if you are carrying something rather light
// You can also jump if you are crouching, just at a much lower height
// ----------------------------------------------------------------------

function DoJump( optional float F )
{
	local DeusExWeapon w;
	local float scaleFactor, augLevel, augStealthValue;                         //RSD: added augStealthValue
	local int MusLevel;
	local Vector velocityNormal;                                                //RSD: added velocityNormal
    local AugSpeed SpeedAug;
        
    //SARGE: Prevent jumping if we're using a computer
    if (bUsingComputer)
        return;

	MusLevel = AugmentationSystem.GetClassLevel(class'AugMuscle');
    SpeedAug = AugSpeed(AugmentationSystem.GetAug(class'AugSpeed'));

	if (MusLevel==-1) MusLevel=30;
	  else MusLevel=(MusLevel+3)*50;

	if ((CarriedDecoration != None) && (CarriedDecoration.Mass > MusLevel))
		return;
	else if (bForceDuck || IsLeaning())
		return;

    if (bOnLadder && WallMaterial != 'Ladder')
    {
        //BroadcastMessage("new dojump");

	    if (camInterpol == 0)
	        camInterpol = 0.4; //do not change this value. its used by mantling code
		if ((Role == ROLE_Authority )&&(FRand()<0.33))
			PlaySound(JumpSound, SLOT_None, 1.5, true, 1200, 1.0 - 0.2*FRand() );
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			MakeNoise(0.1 * Level.Game.Difficulty);
		PlayInAir();

        //if (JumpZ > 650)      //CyberP: fix super jump exploit.
        //JumpZ = default.JumpZ;
        SetPhysics(PHYS_Flying);
        if (IsStunted())
        {
        Velocity = Vector(Rotation) * 200;
        Velocity.Z = JumpZ*0.5;
        }
        else
        {
        Velocity = Vector(Rotation) * 260;
		Velocity.Z = JumpZ*0.75;
		}
	
        // Trash: Speed Enhancement now uses energy while jumping
        if (SpeedAug.CurrentLevel > -1)
        {
            Energy=MAX(Energy - SpeedAug.GetAdjustedEnergy(SpeedAug.EnergyDrainJump),0);
        }

        if (bHardCoreMode)                                                      //RSD: Running drains 1.3x on Hardcore, now jumping drains 1.25x
            swimTimer -= 1.0;
        else
            swimTimer -= 0.8;
        if (swimTimer < 0)
		swimTimer = 0;
		if ( Level.NetMode != NM_Standalone )
		{
		 if (AugmentationSystem == None)
			augLevel = -1.0;
		 else
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugSpeed');
			w = DeusExWeapon(InHand);
			if ((augLevel != -1.0) && ( w != None ) && ( w.Mass > 30.0))
			{
				scaleFactor = 1.0 - FClamp( ((w.Mass - 30.0)/55.0), 0.0, 0.5 );
				Velocity.Z *= scaleFactor;
			}
		}

		// reduce the jump velocity if you are crouching
//		if (IsCrouching())
//			Velocity.Z *= 0.9;

		//if ( Base != Level )
		//	Velocity.Z += Base.Velocity.Z;
		SetTimer(0.15,false);
		//SetPhysics(PHYS_Falling);
		if ( bCountJumps && (Role == ROLE_Authority) )
			Inventory.OwnerJumped();
		return;
	}

        //CyberP: effect when jumping
if (Physics == PHYS_Walking)
{
   RecoilTime=default.RecoilTime + 0.9;

   if (Weapon != none && inHand != none)
   {
     if (weapon.IsA('DeusExWeapon') && (DeusExWeapon(weapon).bAimingDown || AnimSequence == 'Shoot'))
     {
         RecoilShake.Z-=lerp(min(Abs(30),4.0*30)/(4.0*30),1,2.0);
		 RecoilShaker(vect(0,0,1));
     }
     else if (Weapon.IsA('WeaponPlasmaRifle') || Weapon.IsA('WeaponGEPGun') || Weapon.IsA('WeaponFlamethrower') || inHand.IsA('DeusExPickup'))
     {
        RecoilShake.Z-=lerp(min(Abs(4),4.0*4)/(4.0*4),2,4.0);
        RecoilShaker(vect(0,0,2));
     }
     else
     {
        RecoilShake.Z-=lerp(min(Abs(30),4.0*30)/(4.0*30),5,11.0);
		RecoilShaker(vect(0,0,3));
     }
   }
   else
   {
   RecoilShake.Z-=lerp(min(Abs(10),4.0*10)/(4.0*10),1,2.0);
   RecoilShaker(vect(0,0,1));
   }
}

	if (Physics == PHYS_Walking && !bOnLadder)
	{
	    if (camInterpol == 0)
	        camInterpol = 0.4; //do not change this value. its used by mantling code
		if ((Role == ROLE_Authority )&&(FRand()<0.33))
			PlaySound(JumpSound, SLOT_None, 1.5, true, 1200, 1.0 - 0.2*FRand() );
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			MakeNoise(0.1 * Level.Game.Difficulty);
		PlayInAir();

        //RSD: reset ground speed to default if Run Silent is on
        augStealthValue = AugmentationSystem.GetAugLevelValue(class'AugStealth');
        if(augStealthValue != -1.0)
        {
        	velocityNormal = Normal(Velocity);
        	Velocity.X = Default.GroundSpeed*velocityNormal.X;
        	Velocity.Y = Default.GroundSpeed*velocityNormal.Y;
        }
        //if (JumpZ > 650)      //CyberP: fix super jump exploit.
        //JumpZ = default.JumpZ;

        if (IsStunted())
        Velocity.Z = JumpZ*0.75;                                                 //RSD: Was 0.75
        else
		Velocity.Z = JumpZ;

        // Trash: Speed Enhancement now uses energy while jumping
        if (SpeedAug.CurrentLevel > -1)
        {
            Energy=MAX(Energy - SpeedAug.GetAdjustedEnergy(SpeedAug.EnergyDrainJump),0);
        }

        if (bHardCoreMode)                                                      //RSD: Running drains 1.3x on Hardcore, now jumping drains 1.25x
            swimTimer -= 1.0;
        else
            swimTimer -= 0.8;
        if (swimTimer < 0)
		swimTimer = 0;
		if ( Level.NetMode != NM_Standalone )
		{
		 if (AugmentationSystem == None)
			augLevel = -1.0;
		 else
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugSpeed');
			w = DeusExWeapon(InHand);
			if ((augLevel != -1.0) && ( w != None ) && ( w.Mass > 30.0))
			{
				scaleFactor = 1.0 - FClamp( ((w.Mass - 30.0)/55.0), 0.0, 0.5 );
				Velocity.Z *= scaleFactor;
			}
		}

		// reduce the jump velocity if you are crouching
//		if (IsCrouching())
//			Velocity.Z *= 0.9;

		if ( Base != Level )
			Velocity.Z += Base.Velocity.Z;
		SetPhysics(PHYS_Falling);
		if ( bCountJumps && (Role == ROLE_Authority) )
			Inventory.OwnerJumped();
		//BroadcastMessage("default dojump");
	}
}

function bool IsLeaning()
{
	return (curLeanDist != 0);
}

// ----------------------------------------------------------------------
// SetBasedPawnSize()
// ----------------------------------------------------------------------

function bool SetBasedPawnSize(float newRadius, float newHeight)
{
	local float  oldRadius, oldHeight;
	local bool   bSuccess;
	local vector centerDelta, lookDir, upDir;
	local float  deltaEyeHeight;
	local Decoration savedDeco;

	if (newRadius < 0)
		newRadius = 0;
	if (newHeight < 0)
		newHeight = 0;

	oldRadius = CollisionRadius;
	oldHeight = CollisionHeight;

	if ( Level.NetMode == NM_Standalone )
	{
		if ((oldRadius == newRadius) && (oldHeight == newHeight))
			return true;
	}

	centerDelta    = vect(0, 0, 1)*(newHeight-oldHeight);
	deltaEyeHeight = GetBaseEyeHeight() - Default.BaseEyeHeight;

	if ( Level.NetMode != NM_Standalone )
	{
		if ((oldRadius == newRadius) && (oldHeight == newHeight) && (BaseEyeHeight == newHeight - deltaEyeHeight))
			return true;
	}

	if (CarriedDecoration != None)
		savedDeco = CarriedDecoration;

	bSuccess = false;
	if ((newHeight <= CollisionHeight) && (newRadius <= CollisionRadius))  // shrink
	{
		SetCollisionSize(newRadius, newHeight);
		if (Move(centerDelta))
			bSuccess = true;
		else
			SetCollisionSize(oldRadius, oldHeight);
	}
	else
	{
		if (Move(centerDelta))
		{
			SetCollisionSize(newRadius, newHeight);
			bSuccess = true;
		}
	}

	if (bSuccess)
	{
		// make sure we don't lose our carried decoration
		if (savedDeco != None)
		{
			savedDeco.SetPhysics(PHYS_None);
			savedDeco.SetBase(Self);
			savedDeco.SetCollision(False, False, False);

			// reset the decoration's location
			lookDir = Vector(Rotation);
			lookDir.Z = 0;
			upDir = vect(0,0,0);
			upDir.Z = CollisionHeight / 2;		// put it up near eye level
			savedDeco.SetLocation(Location + upDir + (0.5 * CollisionRadius + CarriedDecoration.CollisionRadius) * lookDir);
		}

//		PrePivotOffset  = vect(0, 0, 1)*(GetDefaultCollisionHeight()-newHeight);
		PrePivot        -= centerDelta;
//		DesiredPrePivot -= centerDelta;
		BaseEyeHeight   = newHeight - deltaEyeHeight;

		//LDDP, 10/26/21: We use this to dynamically adjust our collision height. Bear this in mind.
		if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
		{
			if (PrePivot.Z ~= 4.5)
			{
				PrePivot.Z -= 4.5;
			}
			BaseEyeHeight -= 2;
		}

		// Complaints that eye height doesn't seem like your crouching in multiplayer
		if (( Level.NetMode != NM_Standalone ) && (IsCrouching()) )
			EyeHeight		-= (centerDelta.Z * 2.5);
		else
			EyeHeight		-= centerDelta.Z;
	}
	return (bSuccess);
}

// ----------------------------------------------------------------------
// ResetBasedPawnSize()
// ----------------------------------------------------------------------

function bool ResetBasedPawnSize()
{
	return SetBasedPawnSize(Default.CollisionRadius, GetDefaultCollisionHeight());
}

// ----------------------------------------------------------------------
// GetDefaultCollisionHeight()
// ----------------------------------------------------------------------

function float GetDefaultCollisionHeight()
{
	return (Default.CollisionHeight-4.5);
}

function float GetBaseEyeHeight()
{
	if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
	{
		return Default.CollisionHeight;
	}
	return (Default.CollisionHeight-4.5);
}

// ----------------------------------------------------------------------
// GetCurrentGroundSpeed()
// ----------------------------------------------------------------------

//RSD: Run Silent now gives half of the speed bonus that Speed Enhancement gives
function float GetCurrentGroundSpeed()
{
	local float augSpeedValue, augStealthValue, speed;                           //RSD: replaced augValue with augSpeedValue and augStealthValue
    local float groundSpeed;
    local PerkSprinter perk;

	// Remove this later and find who's causing this to Access None MB
	if ( AugmentationSystem == None )
		return 0;

	augSpeedValue = AugmentationSystem.GetAugLevelValue(class'AugSpeed');
	augStealthValue = AugmentationSystem.GetAugLevelValue(class'AugStealth');

    //if (augValue == -1.0)
	//	augValue = 1.0;

    if (augStealthValue == -1.0)                                                //RSD: Duplicated for augStealthValue
		augStealthValue = 1.0;
    else
        augStealthValue = 1.0+0.2*(1.0-augStealthValue);                        //RSD: Gives half of Speed Enhancement's bonus with CHANGED LevelValues

	if (augSpeedValue == -1.0)
		augSpeedValue = 1.0;

	if (( Level.NetMode != NM_Standalone ) && Self.IsA('Human') )
		groundSpeed = Human(Self).mpGroundSpeed;
	else
		groundSpeed = self.Default.GroundSpeed;

    //SARGE: Add Sprinter bonus 10% movespeed
    perk = PerkSprinter(PerkManager.GetPerkWithClass(class'DeusEx.PerkSprinter'));
    if (perk != None && perk.bPerkObtained && inHand == None && CarriedDecoration == None)
        groundSpeed = groundSpeed * perk.perkValue;
		
    speed = GroundSpeed * FMax(augSpeedValue,augStealthValue);

    //clientMessage("Speed: " $ speed);

	return speed;
}

// ----------------------------------------------------------------------
// CreateDrone
// ----------------------------------------------------------------------
function CreateDrone()
{
	local Vector loc;

    spyDroneLevelValue = AugmentationSystem.GetAugLevelValue(class'AugDrone');

	loc = (2.0 + class'SpyDrone'.Default.CollisionRadius + CollisionRadius) * Vector(ViewRotation);
	loc.Z = BaseEyeHeight;
	loc += Location;
	aDrone = Spawn(class'SpyDrone', Self,, loc, ViewRotation);
	if (aDrone != None)
	{
		aDrone.Speed = 3 * spyDroneLevelValue;
		aDrone.MaxSpeed = 3 * spyDroneLevelValue;
		aDrone.Damage = 5 * spyDroneLevelValue;
		aDrone.blastRadius = 8 * spyDroneLevelValue;
		// window construction now happens in Tick()
	}
}

// ----------------------------------------------------------------------
// MoveDrone
// ----------------------------------------------------------------------

simulated function MoveDrone( float DeltaTime, Vector loc )
{
	// if the wanted velocity is zero, apply drag so we slow down gradually
	if (VSize(loc) == 0)
	{
	  aDrone.Velocity *= 0.9;
	  Velocity *= 0;
	}
	else
	{
	  aDrone.Velocity += deltaTime * aDrone.MaxSpeed * loc;
	}

	// add slight bobbing
	// DEUS_EX AMSD Only do the bobbing in singleplayer, we want stationary drones stationary.
	if (Level.Netmode == NM_Standalone)
	  aDrone.Velocity += deltaTime * Sin(Level.TimeSeconds * 2.0) * vect(0,0,1);
}

function ServerUpdateLean( Vector desiredLoc )
{
	local Vector gndCheck, traceSize, HitNormal, HitLocation;
	local Actor HitActor, HitActorGnd;

	// First check to see if anything is in the way
	traceSize.X = CollisionRadius;
	traceSize.Y = CollisionRadius;
	traceSize.Z = CollisionHeight;
	HitActor = Trace( HitLocation, HitNormal, desiredLoc, Location, True, traceSize );

	// Make we don't lean off the edge of something
	//if ( HitActor == None )	// Don't bother if we're going to fail to set anyway
	//{
	//	gndCheck = Location - vect(0,0,1) * CollisionHeight;//desiredLoc - vect(0,0,1) * CollisionHeight;
	//	HitActorGnd = Trace( HitLocation, HitNormal, gndCheck, desiredLoc, True, traceSize );
	//}

	if ( (HitActor == None)) //&& (HitActorGnd != None) )
		SetLocation( desiredLoc );

//	SetRotation( rot );
}


// ----------------------------------------------------------------------
// GMDX:dasraiser insert lean to Tiptoes
// RefreshKey copied from HUDMultiSkill.uc for Tiptoes Lean
// ----------------------------------------------------------------------

function RefreshLeanKeys()
{
	local String KeyName, Alias,KeyLeanLeft,AliasLeanLeft,KeyLeanRight,AliasLeanRight;
//	local int EI_KL,EI_KR;
	local int i;
	local int Nfound;

//GMDX as EInputKey enum not same as Actor!
//^^var int LeanLeftKey, LeanRightKey;


	bLeanKeysDefined=false;

	for ( i=0; i<255; i++ )
	{
		KeyName = ConsoleCommand ( "KEYNAME "$i );
		if ( KeyName != "" )
		{
			Alias = ConsoleCommand( "KEYBINDING "$KeyName );
			if ( InStr(Alias,"LeanRight" )!=-1)
			{
			   //EI_KR=i;
			   KeyLeanRight=KeyName;
			   AliasLeanRight=Alias;
			   Nfound++;
			} else
			if ( InStr(Alias,"LeanLeft" )!=-1)
			{
			   //EI_KL=i;
			KeyLeanLeft=KeyName;
			   AliasLeanLeft=Alias;
			   Nfound++;
			}
			if (Nfound==2) break;
		}
	}
	if (Nfound==2)
	{
	  bLeanKeysDefined=true;
//	  log("Set InputExt "$KeyLeanRight$" "$AliasLeanRight$" | bLeanRightHook 1 | OnRelease bLeanRightHook 0");
//	  log("Set InputExt "$KeyLeanLeft$" "$AliasLeanLeft$" | bLeanLeftHook 1 | OnRelease bLeanLeftHook 0");
 	  ConsoleCommand("SET InputExt "$KeyLeanRight$" LeanRight | SetTiptoesRight 1 | OnRelease SetTiptoesRight 0");
	  ConsoleCommand("SET InputExt "$KeyLeanLeft$" LeanLeft | SetTiptoesLeft 1 | OnRelease SetTiptoesLeft 0");
	} else log("Lean Keys UNDEFINED, disabling tiptoes");

}

function RefreshMantleKey()
{
	local String KeyName, Alias,KeyJump,AliasJump;
	local int i;
	local int Nfound;

//GMDX as EInputKey enum not same as Actor!
//^^var int LeanLeftKey, LeanRightKey;

	for ( i=0; i<255; i++ )
	{
		KeyName = ConsoleCommand ( "KEYNAME "$i );
		if ( KeyName != "" )
		{
			Alias = ConsoleCommand( "KEYBINDING "$KeyName );
			if ( InStr(Alias,"Jump" )!=-1)
			{
			   //EI_KR=i;
			   KeyJump=KeyName;
			   AliasJump=Alias;
			   Nfound++;
			}
			if (Nfound==1) break;
		}
	}
	if (Nfound==1)
	{
//	  log("Set InputExt "$KeyLeanRight$" "$AliasLeanRight$" | bLeanRightHook 1 | OnRelease bLeanRightHook 0");
//	  log("Set InputExt "$KeyLeanLeft$" "$AliasLeanLeft$" | bLeanLeftHook 1 | OnRelease bLeanLeftHook 0");
 	  ConsoleCommand("SET InputExt "$KeyJump$" Jump | StartMantling 1 | OnRelease StopMantling 1");
	  //ConsoleCommand("SET InputExt "$KeyLeanLeft$" LeanLeft | SetTiptoesLeft 1 | OnRelease SetTiptoesLeft 0");
	}
}

function RefreshAugWheelKey()                                                   //RSD: Hold aug wheel
{
local String KeyName, Alias,KeyHold,AliasHold;
	local int i;
	local int Nfound;

//GMDX as EInputKey enum not same as Actor!
//^^var int LeanLeftKey, LeanRightKey;

	for ( i=0; i<255; i++ )
	{
		KeyName = ConsoleCommand ( "KEYNAME "$i );
		if ( KeyName != "" )
		{
			Alias = ConsoleCommand( "KEYBINDING "$KeyName );
			if ( InStr(Alias,"HoldRadialAugMenu" )!=-1)
			{
			   //EI_KR=i;
			   KeyHold=KeyName;
			   AliasHold=Alias;
			   Nfound++;
			}
			if (Nfound==1) break;
		}
	}
	if (Nfound==1)
	{
 	  ConsoleCommand("SET InputExt "$KeyHold$" HoldRadialAugMenu | ToggleRadialAugMenu 1 | OnRelease ToggleRadialAugMenu 1");
	}
}

exec function SetTiptoesLeft(bool B)
{
	if (bLeanKeysDefined)
	  bLeftToe=B; else bLeftToe=false;

	if (bLeftToe&&bRightToe) bPreTiptoes=true;
	  else bPreTiptoes=false;

	  //log("Exec LeftTip"@bLeftToe@bPreTiptoes@bLeanKeysDefined);
}

exec function SetTiptoesRight(bool B)
{
	if (bLeanKeysDefined)
	  bRightToe=B; else bLeftToe=false;

	if (bLeftToe&&bRightToe) bPreTiptoes=true;
	  else bPreTiptoes=false;

	//log("Exec RightTip"@bRightToe@bPreTiptoes);
}

// ----------------------------------------------------------------------
// state PlayerWalking
// ----------------------------------------------------------------------

state PlayerWalking
{
	// lets us affect the player's movement
	function ProcessMove ( float DeltaTime, vector newAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local int newSpeed, defSpeed;
		local name mat;
		local vector HitLocation, HitNormal, checkpoint, downcheck;
		local Actor HitActor, HitActorDown;
		local bool bCantStandUp;
		local Vector loc, traceSize;
		local float alpha, maxLeanDist;
		local float legTotal, weapSkill;
		local int augValue;
		local int ResetSize;
        local float mult, mult2, mult3, rand;
        local name ventMat;
        local float heavyMult;                                                  //RSD
        local float heavySkillVal;                                              //RSD
        local float mult4;                                                      //RSD

        //SARGE: Prevent walking if we're using a computer
        if (bUsingComputer)
        {
            newAccel = vect(0,0,0);
        }

		if (bStaticFreeze)
		{
			SetRotation(SAVErotation);
			return;
		}

		// if the spy drone augmentation is active //Lorenz: and augmentation wheel is invis
		if (bSpyDroneActive && !bSpyDroneSet)                                   //RSD: Allows the user to toggle between moving and controlling the drone
		{
			if ( aDrone != None )
			{
				// put away whatever is in our hand
                /*
				if (inHand != None)
					PutInHand(None);
                */

				// make the drone's rotation match the player's view
				if (!bRadialAugMenuVisible)
				    aDrone.SetRotation(ViewRotation);

				// move the drone
				loc = Normal((aUp * vect(0,0,1) + aForward * vect(1,0,0) + aStrafe * vect(0,1,0)) >> ViewRotation);

				// opportunity for client to translate movement to server
				MoveDrone( DeltaTime, loc );

				// freeze the player
				Velocity = vect(0,0,0);
                
                //SARGE: Stop player from sliding along the ground very slowly while the drone is active
                SetPhysics(PHYS_None);
                SetPhysics(PHYS_Walking);
			}
			return;
		}

	defSpeed = GetCurrentGroundSpeed();
	ResetSize=0;

//      log("TIPTOES "@bLeanLeftHook@bLeanRightHook@IsLeaning()@bIsCrouching@bForceDuck);
	  //GMDX:tiptoes
	  if (!bPreTiptoes) bIsTiptoes=false;

	  bTiptoes=bPreTiptoes&&(!IsLeaning()||bIsTiptoes);

	  // crouching makes you two feet tall
		if (IsCrouching())
		{
			if ( Level.NetMode != NM_Standalone )
				SetBasedPawnSize(Default.CollisionRadius, 30.0);
			else
			   SetBasedPawnSize(Default.CollisionRadius, 16);

				// check to see if we could stand up if we wanted to
				checkpoint = Location;
				// check normal standing height
				checkpoint.Z = checkpoint.Z - CollisionHeight + 2 * GetDefaultCollisionHeight();
				traceSize.X = CollisionRadius;
				traceSize.Y = CollisionRadius;
				traceSize.Z = 1;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);
				if (HitActor == None)
					bCantStandUp = False;
				else
					bCantStandUp = True;
	  } else
		 ResetSize++;

		if (bTiptoes)
		{ //check we can go on tiptoes
			checkpoint = Location;
		 if (IsCrouching())
			checkpoint.Z = checkpoint.Z + 14 +18;
			else
			   checkpoint.Z = checkpoint.Z + 5.3 + GetDefaultCollisionHeight();

			traceSize.X = CollisionRadius;
			traceSize.Y = CollisionRadius;
			traceSize.Z = 1;
			HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);
			if (HitActor == None && !bForceDuck)
				bCanTiptoes = True;
			else
				bCanTiptoes = False;

			//log("bCanTiptoes "@bCanTiptoes);
		} else
		 ResetSize++;

	if (ResetSize==2)
	  {
		 // DEUS_EX AMSD Changed this to grab defspeed, because GetCurrentGroundSpeed takes 31k cycles to run.
			GroundSpeed = defSpeed;
			// make sure the collision height is fudged for the floor problem - CNN
			if (!IsLeaning())
			{
				ResetBasedPawnSize();
				//log("Size Reset");
			}
		}

		if (bCantStandUp)
			bForceDuck = True;
		else
			bForceDuck = False;

		// if the player's legs are damaged, then reduce our speed accordingly
		newSpeed = defSpeed;

		if ( Level.NetMode == NM_Standalone && PerkManager.GetPerkWithClass(class'DeusEx.PerkPerserverance').bPerkObtained == false)          //RSD: Was PerkNamesArray[17] (Adrenaline), changed to PerkNamesArray[5] (Clarity)
		{
			if (HealthLegLeft < 1)
				newSpeed -= (defSpeed/2) * 0.25;
			else if (HealthLegLeft < 34)
				newSpeed -= (defSpeed/2) * 0.15;
			else if (HealthLegLeft < 67)
				newSpeed -= (defSpeed/2) * 0.10;

			if (HealthLegRight < 1)
				newSpeed -= (defSpeed/2) * 0.25;
			else if (HealthLegRight < 34)
				newSpeed -= (defSpeed/2) * 0.15;
			else if (HealthLegRight < 67)
				newSpeed -= (defSpeed/2) * 0.10;

			if (HealthTorso < 67)
				newSpeed -= (defSpeed/2) * 0.05;
		}

		// let the player pull themselves along with their hands even if both of
		// their legs are blown off
		if ((HealthLegLeft < 1) && (HealthLegRight < 1))
		{
			newSpeed = defSpeed * 0.8;
			bIsWalking = True;
			bForceDuck = True;
			bCanTiptoes=false;
		}
		// make crouch speed faster than normal
		else if (IsCrouching() && !bOnLadder)
		{
		    mult3=1;             //CyberP: faster crouch speed. Comment out all except bIsWalking = True to remove
		    if (SkillSystem!=None && SkillSystem.GetSkillLevel(class'SkillStealth')>=1)
		        mult3= 1 + (SkillSystem.GetSkillLevel(class'SkillStealth')* 0.15); //RSD: changed from *0.1
			newSpeed = defSpeed * mult3;
			bIsWalking = True;
		}

		// CNN - Took this out because it sucks ASS!
		// if the legs are seriously damaged, increase the head bob
		// (unless the player has turned it off)
	//	if (Bob > 0.0)
	//	{
	//		legTotal = (HealthLegLeft + HealthLegRight) / 2.0;
	//		if (legTotal < 20)
	//			Bob = Default.Bob * FClamp(0.05*(70 - legTotal), 1.0, 3.0);
	//		else
	//			Bob = Default.Bob;
	//	}


       //CyberP: slow the player under certain conditions
       if (IsStunted())
       {
         if (Physics == PHYS_Walking && !bOnLadder)
         {
           bIsWalking = True;
           newSpeed = defSpeed;
         }
       }

		// slow the player down if he's carrying something heavy
		// Like a DEAD BODY!  AHHHHHH!!!
		if (CarriedDecoration != None)
		{
		    if ( AugmentationSystem != None )
		     augValue = AugmentationSystem.GetClassLevel(class'AugMuscle');
	        if (augValue==3) augValue = 0; else augValue=1;

            newSpeed -= CarriedDecoration.Mass * 2 * augValue;
		}
		// don't slow the player down if he's skilled at the corresponding weapon skill
		else if ((DeusExWeapon(Weapon) != None) && (Weapon.Mass > 30) && (AugmentationSystem != None))
		{
		  /*if (DeusExWeapon(Weapon).GetWeaponSkill() > -0.25 && AugmentationSystem.GetAugLevelValue(class'AugMuscle') == -1)
			{
            bIsWalking = True;
			newSpeed = defSpeed;
			}*/
			//RSD: New formula for Heavy weap speed penalty:
			// 50% mult is lowest speed, 100% is normal run
			// SkillWeaponHeavy adds 10/25/50%
			// Microfibral Muscle adds 12.5/25/37.5/50%
			// Caps at 100%
			heavyMult = 0.5;                                                    //RSD: For more granular heavy weapon MS penalty
			heavySkillVal = SkillSystem.GetSkillLevelValue(DeusExWeapon(Weapon).GoverningSkill);
			//if (heavySkillVal >= 3.0)                                         //RSD: Was from when I was using skill level rather than value
			//	heavySkillVal = 4.0;
		    heavyMult -= heavySkillVal;
		    if (AugmentationSystem.GetAugLevelValue(class'AugMuscle') != -1.0)
            	heavyMult += 0.5*(AugmentationSystem.GetAugLevelValue(class'AugMuscle')-1.0);
     		if (heavyMult > 1.0)
     			heavyMult = 1.0;
   			newSpeed *= heavyMult;
		}
		else if ((inHand != None) && inHand.IsA('POVCorpse'))
		{
		    if ( AugmentationSystem != None )
		     augValue = AugmentationSystem.GetClassLevel(class'AugMuscle');
	        if (augValue==3) augValue = 0; else augValue=1;
			newSpeed -= inHand.Mass * 3*augValue;
		}

		/*// Multiplayer movement adjusters   //CyberP: no multiplayer
		if ( Level.NetMode != NM_Standalone )
		{
			if ( Weapon != None )
			{
				weapSkill = DeusExWeapon(Weapon).GetWeaponSkill();
				// Slow down heavy weapons in multiplayer
				if ((DeusExWeapon(Weapon) != None) && (Weapon.Mass > 30) )
				{
					newSpeed = defSpeed;
					newSpeed -= ((( Weapon.Mass - 30.0 ) / (class'WeaponGEPGun'.Default.Mass - 30.0 )) * (0.70 + weapSkill) * defSpeed );
				}
				// Slow turn rate of GEP gun in multiplayer to discourage using it as the most effective close quarters weapon
				if ((WeaponGEPGun(Weapon) != None) && (!WeaponGEPGun(Weapon).bZoomed))
					TurnRateAdjuster = FClamp( 0.20 + -(weapSkill*0.5), 0.25, 1.0 );
				else
					TurnRateAdjuster = 1.0;
			}
			else
				TurnRateAdjuster = 1.0;
		} */

		// if we are moving really slow, force us to walking
		if ((newSpeed <= defSpeed / 3) && !bForceDuck)
		{
			bIsWalking = True;
			newSpeed = defSpeed;
		}
		if (curLeanDist != 0)
		{
		    bIsWalking = True;
		    newSpeed *= 0.3;
		}

		// if we are moving backwards, we should move slower
	  // DEUS_EX AMSD Turns out this wasn't working right in multiplayer, I have a fix
	  // for it, but it would change all our balance.
		//if ((aForward < 0) && (Level.NetMode == NM_Standalone))
		//	newSpeed *= 0.65;  //CyberP:


	  if (bTiptoes&&bCanTiptoes) //!bIsTiptoes fuuk why so much spamming size
	  {
		 bIsTiptoes=true;
		 if (IsCrouching())
			SetBasedPawnSize(Default.CollisionRadius, 16+18);
			else
			   SetBasedPawnSize(Default.CollisionRadius, GetDefaultCollisionHeight()+5.3);
		 newSpeed*=0.6;
	  }

      mult = 0.5+0.5*SkillSystem.GetSkillLevelValue(class'SkillSwimming');      //RSD: Halved breath increase
      /*UnderWaterTime = AugmentationSystem.GetAugLevelValue(class'AugAqualung'); //RSD: Passive Aqualung
      if (UnderWaterTime == -1.0)
          UnderWaterTime = default.UnderWaterTime;*/
      swimDuration = UnderWaterTime * mult;                                  //RSD: Removed effect of Athletics on stamina //RSD: reinstated
      //if (mult > 1.0)                                                         //RSD: Never went into effect anyway?
      //   mult *= 0.85;
      if (bIsWalking && !IsCrouching())  //CyberP: faster walking
      {
          mult3=1;             //CyberP: faster walk speed. Comment out all except newSpeed *= 1.7 to remove
		  if (SkillSystem!=None && SkillSystem.GetSkillLevel(class'SkillStealth')>=1)
		      mult3= 1 + (SkillSystem.GetSkillLevel(class'SkillStealth')* 0.15);
			//newSpeed = defSpeed * mult3;
          newSpeed *= 1.7; //1.5
          newSpeed *= mult3;
      }

      if (Physics == PHYS_Walking && (bStaminaSystem || bHardCoreMode))   //CyberP: stamina system
      {
      if (bIsWalking == false && !IsCrouching() && (Velocity.X != 0 || Velocity.Y != 0 ))
	  {
	    /*if (bHardCoreMode)                                                    //RSD: Generalizing this a bit
		swimTimer -= deltaTime*1.3;
		else
        swimTimer -= deltaTime;*/

        mult4 = 1.0;
        //if (DrugsWithdrawalArray[0] == 1)                                       //RSD: if suffering from nicotine withdrawal, start at double
	    //    mult4 = 2.0;
        if (bHardcoreMode)
            mult4 *= 1.3;
        swimTimer -= mult4*deltaTime;

		if (swimTimer < 0)
        {
        swimTimer = 0;
            if (bStaminaSystem || bHardCoreMode)
            {
               bStunted = true;
               if (!bOnLadder && FRand() < 0.7)
               {
                   PlayBreatheSound();
               }
               if (bBoosterUpgrade && Energy > 0)
	               AugmentationSystem.AutoAugs(false,false);
            }
        }
	  }
      }

      if (Physics == PHYS_Walking)  //CyberP: stamina system
      {
      if (bIsWalking || (Velocity.X == 0 && Velocity.Y == 0))
	  {
		
		//SARGE: Moved Endurance check to here.
        bCrouchRegen=PerkManager.GetPerkWithClass(class'DeusEx.PerkEndurance').bPerkObtained;
	    if ((!IsCrouching() || bCrouchRegen) && !bOnLadder && (inHand == None || !inHand.IsA('POVCorpse'))) //(bIsCrouching)     //RSD: Simplified this entire logic from original crouching -> bCrouchRegen check, added !bOnLadder //SARGE: Added corpse carrying
	    	RegenStaminaTick(deltaTime);                                        //RSD: Generalized stamina regen function
	  }
      }

	  GroundSpeed = FMax(newSpeed, 100);

		// if we are moving or crouching, we can't lean
		// uncomment below line to disallow leaning during crouch

			if (abs(Velocity.Z) < 10 && Physics == PHYS_Walking && !(bPreTiptoes||bIsTiptoes||CarriedDecoration != None))//if ((VSize(Velocity) < 10) && (aForward == 0) && !(bPreTiptoes||bIsTiptoes||CarriedDecoration != None))		// && !bIsCrouching && !bForceDuck)
				bCanLean = True;
			else
				bCanLean = False;

			// check leaning buttons (axis aExtra0 is used for leaning)
			maxLeanDist = 40;

			if (IsLeaning()&&!bIsTiptoes)
			{
				if ( PlayerIsClient() || (Level.NetMode == NM_Standalone) )
					ViewRotation.Roll = curLeanDist * 20;

				if (!IsCrouching())
				{
					SetBasedPawnSize(CollisionRadius, GetDefaultCollisionHeight() - Abs(curLeanDist) / 3.0);
					//log("Size REset");
				}
			}
			if (bCanLean && (aExtra0 != 0))
			{
				// lean
				DropDecoration();		// drop the decoration that we are carrying
				if (AnimSequence != 'CrouchWalk')
					PlayCrawling();
				mult3= SkillSystem.GetSkillLevel(class'SkillStealth');
				if (mult3 >=3)
				    alpha = maxLeanDist * aExtra0 * 2.0 * (DeltaTime*2.0);
                else if (mult3 >=2)
				    alpha = maxLeanDist * aExtra0 * 2.0 * (DeltaTime*1.6);
				else if (mult3 >=1)
                    alpha = maxLeanDist * aExtra0 * 2.0 * (DeltaTime*1.3);
				else
                    alpha = maxLeanDist * aExtra0 * 2.0 * DeltaTime;

				loc = vect(0,0,0);
				loc.Y = alpha;
				if (Abs(curLeanDist + alpha) < maxLeanDist)
				{
					// check to make sure the destination not blocked
					checkpoint = (loc >> Rotation) + Location;
					traceSize.X = CollisionRadius;
					traceSize.Y = CollisionRadius;
					traceSize.Z = CollisionHeight;
					HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);

					// check down as well to make sure there's a floor there
					downcheck = checkpoint - vect(0,0,1) * CollisionHeight;
					HitActorDown = Trace(HitLocation, HitNormal, downcheck, checkpoint, True, traceSize);
					if ((HitActor == None || (HitActor != None && (HitActor.IsA('DeusExCarcass') || HitActor.CollisionHeight < MaxStepHeight )) ) && (HitActorDown != None))
					{
						if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
						{
							SetLocation(checkpoint);
							ServerUpdateLean( checkpoint );
							curLeanDist += alpha;
						}
					}
				}
				else
				{
					if ( PlayerIsClient() || (Level.NetMode == NM_Standalone) )
						curLeanDist = aExtra0 * maxLeanDist;
				}
			}
			else if (IsLeaning())	//if (!bCanLean && IsLeaning())	// uncomment this to not hold down lean
			{
				// un-lean
				if (AnimSequence == 'CrouchWalk')
					PlayRising();

				if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
				{
					prevLeanDist = curLeanDist;
					alpha = FClamp(7.0 * DeltaTime, 0.001, 0.9);
					curLeanDist *= 1.0 - alpha;
					if (Abs(curLeanDist) < 1.0)
						curLeanDist = 0;
				}

				loc = vect(0,0,0);
				loc.Y = -(prevLeanDist - curLeanDist);

				// check to make sure the destination not blocked
				checkpoint = (loc >> Rotation) + Location;
				traceSize.X = CollisionRadius;
				traceSize.Y = CollisionRadius;
				traceSize.Z = CollisionHeight;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);

				// check down as well to make sure there's a floor there
				downcheck = checkpoint - vect(0,0,1) * CollisionHeight;
				HitActorDown = Trace(HitLocation, HitNormal, downcheck, checkpoint, True, traceSize);
				if ((HitActor == None) && (HitActorDown != None))
				{
					if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
					{
						SetLocation( checkpoint );
						ServerUpdateLean( checkpoint );
					}
				}
			}

		Super.ProcessMove(DeltaTime, newAccel, DodgeMove, DeltaRot);
	}

	function ZoneChange(ZoneInfo NewZone)
	{
	local vector loc;
    local int i;
		// if we jump into water, empty our hands
		if (NewZone.bWaterZone)
			{
			//AugmentationSystem.AutoAugs(false,false);
            DropDecoration();
            //loc = Location + VRand() * 4;
	        //loc.Z += CollisionHeight * 0.9;

			if (Velocity.Z < -440)  //CyberP: effects for jumping in water from height.
			{
			PlaySound(sound'SplashLarge', SLOT_Pain);
            ClientFlash(12,vect(160,200,255));
			for (i=0;i<38;i++)
			{
			    loc = Location + VRand() * 35;
		     	loc.Z = Location.Z + FRand();
			    loc += Vector(ViewRotation) * CollisionRadius * 1.02;
			    loc.Z -= CollisionHeight + FRand();
				Spawn(class'AirBubble', Self,, loc);

			}
	       if (inHand != none && (inHand.IsA('NanoKeyRing') || inHand.IsA('DeusExPickup')))
          	{
         	}
	        else
	        {
	          if (inHand != None && inHand.IsA('DeusExWeapon') && DeusExWeapon(inHand).bAimingDown)
	              DeusExWeapon(inHand).ScopeToggle();
	          RecoilTime=default.RecoilTime;
		      RecoilShake.Z-=lerp(min(Abs(Velocity.Z),4.0*JumpZ)/(4.0*JumpZ),0,14.0); //CyberP: 7
		      RecoilShake.Y-=lerp(min(Abs(Velocity.Z),4.0*JumpZ)/(4.0*JumpZ),0,6.0);
		      RecoilShaker(vect(6,8,18));
	          }
	        }
	        else
	           PlaySound(sound'SplashMedium', SLOT_Pain);
            Super.ZoneChange(NewZone);
         }
	}
    function PlayerMove( float DeltaTime )                                      //RSD: Overwrites State PlayerWalking function PlayerMove() from PlayerPawn.uc just to enable headbobbing with Lorenz's radial menu
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local name AnimGroupName;

		GetAxes(Rotation,X,Y,Z);

		aForward *= 0.4;
		aStrafe  *= 0.4;
		aLookup  *= 0.24;
		aTurn    *= 0.24;

		// Update acceleration.
		NewAccel = aForward*X + aStrafe*Y;
		NewAccel.Z = 0;
		// Check for Dodge move
		if ( DodgeDir == DODGE_Active )
			DodgeMove = DODGE_Active;
		else
			DodgeMove = DODGE_None;
		if (DodgeClickTime > 0.0)
		{
			if ( DodgeDir < DODGE_Active )
			{
				OldDodge = DodgeDir;
				DodgeDir = DODGE_None;
				if (bEdgeForward && bWasForward)
					DodgeDir = DODGE_Forward;
				if (bEdgeBack && bWasBack)
					DodgeDir = DODGE_Back;
				if (bEdgeLeft && bWasLeft)
					DodgeDir = DODGE_Left;
				if (bEdgeRight && bWasRight)
					DodgeDir = DODGE_Right;
				if ( DodgeDir == DODGE_None)
					DodgeDir = OldDodge;
				else if ( DodgeDir != OldDodge )
					DodgeClickTimer = DodgeClickTime + 0.5 * DeltaTime;
				else
					DodgeMove = DodgeDir;
			}

			if (DodgeDir == DODGE_Done)
			{
				DodgeClickTimer -= DeltaTime;
				if (DodgeClickTimer < -0.35)
				{
					DodgeDir = DODGE_None;
					DodgeClickTimer = DodgeClickTime;
				}
			}
			else if ((DodgeDir != DODGE_None) && (DodgeDir != DODGE_Active))
			{
				DodgeClickTimer -= DeltaTime;
				if (DodgeClickTimer < 0)
				{
					DodgeDir = DODGE_None;
					DodgeClickTimer = DodgeClickTime;
				}
			}
		}

		AnimGroupName = GetAnimGroup(AnimSequence);
		if ( (Physics == PHYS_Walking) && (AnimGroupName != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bCenterView )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			//add bobbing when walking
			if ( !(bShowMenu && !bRadialAugMenuVisible) )                       //RSD: So we get headbobbing in Lorenz's menu
				CheckBob(DeltaTime, Speed2D, Y);

		}
		else if ( !(bShowMenu && !bRadialAugMenuVisible) )                      //RSD: So we get headbobbing in Lorenz's menu
		{
			BobTime = 0;
			WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if ( bPressedJump && (AnimGroupName == 'Dodge') )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
			bSaveJump = false;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		bPressedJump = bSaveJump;
	}
	event PlayerTick(float deltaTime)
	{
		//DEUS_EX AMSD Additional updates
		//Because of replication delay, aug icons end up being a step behind generally.  So refresh them
		//every freaking tick.
		RefreshSystems(deltaTime);
        //BroadcastMessage(self.AIVisibility());
		DrugEffects(deltaTime);
		RecoilEffectTick(deltaTime);
		Bleed(deltaTime);
		HighlightCenterObject();

		UpdateDynamicMusic(deltaTime);
		UpdateWarrenEMPField(deltaTime);
	  // DEUS_EX AMSD Move these funcions to a multiplayer tick
	  // so that only that call gets propagated to the server.
	  MultiplayerTick(deltaTime);
	  // DEUS_EX AMSD For multiplayer...
		FrobTime += deltaTime;

        if (camInterpol > 0)
        {
          camInterpol -= deltaTime;
          if (camInterpol < 0)
            camInterpol = 0;
          if (bob == 0.016)
          {
          if (camInterpol > 0.2)
             ViewRotation.Pitch -= deltaTime * 2000;
          else
             ViewRotation.Pitch += deltaTime * 2000;
          if ((ViewRotation.Pitch > 16384) && (ViewRotation.Pitch < 32768))
				ViewRotation.Pitch = 16384;
		   }
        }
		// save some texture info
		FloorMaterial = GetFloorMaterial();
		WallMaterial = GetWallMaterial(WallNormal);

		// Check if player has walked outside a first-person convo.
		CheckActiveConversationRadius();

		// Check if all the people involved in a conversation are
		// still within a reasonable radius.
		CheckActorDistances();

		// handle poison
	  //DEUS_EX AMSD Now handled in multiplayertick
		//UpdatePoison(deltaTime);

		// Update Time Played
		UpdateTimePlayed(deltaTime);
       
        //Update belt selection timer
        if (fBlockBeltSelection > 0)
            fBlockBeltSelection -= deltaTime;

        //Tick down killswitch
        if (killswitchTimer > 0)
        {
            killswitchTimer -= deltaTime;
            if (killswitchTimer < 0)
                killswitchTimer = 0;
        }

        //Stop double click timer
        if (doubleClickCheck > 0)
        {
            doubleClickCheck -= deltaTime;
            if (doubleClickCheck <= 0)
            {
                doubleClickCheck = 0;
                clickCountCyber=0;
            }
        }

        //Stop being stunted if we elapse the stunted timer
        if (stuntedTime > 0)
            stuntedTime -= deltaTime;
            

        //SARGE: Recreate decals slowly over a few frames, to avoid
        //crashing when changing maps
        if (bCreatingDecals && DecalManager != None)
        {
            //First time, destroy the decals
            if (currentDecalBatch == 0)
                DecalManager.HideAllDecals();

            DecalManager.RecreateDecals(currentDecalBatch,500);
            currentDecalBatch += 500;
            bCreatingDecals = DecalManager.GetTotalDecals() > currentDecalBatch;
        }
        //Fire blocking is only valid for 1 frame
        bBlockNextFire = False;

		Super.PlayerTick(deltaTime);
	}
}

// ----------------------------------------------------------------------
// state PlayerFlying
// ----------------------------------------------------------------------

state PlayerFlying
{
	function ZoneChange(ZoneInfo NewZone)
	{
		// if we jump into water, empty our hands
		if (NewZone.bWaterZone)
			DropDecoration();

		Super.ZoneChange(NewZone);
	}

	event PlayerTick(float deltaTime)
	{

		//DEUS_EX AMSD Additional updates
		//Because of replication delay, aug icons end up being a step behind generally.  So refresh them
		//every freaking tick.
		RefreshSystems(deltaTime);

		DrugEffects(deltaTime);
		RecoilEffectTick(deltaTime);
		HighlightCenterObject();
		UpdateDynamicMusic(deltaTime);
	    // DEUS_EX AMSD For multiplayer...
	    MultiplayerTick(deltaTime);
		FrobTime += deltaTime;

		// Check if player has walked outside a first-person convo.
		CheckActiveConversationRadius();

		// Check if all the people involved in a conversation are
		// still within a reasonable radius.
		CheckActorDistances();

		// Update Time Played
		UpdateTimePlayed(deltaTime);

		Super.PlayerTick(deltaTime);
	}
}

// ----------------------------------------------------------------------
// event HeadZoneChange
// ----------------------------------------------------------------------

event HeadZoneChange(ZoneInfo newHeadZone)
{
	local float mult, augLevel;

	// hack to get the zone's ambientsound working until Tim fixes it
	if (newHeadZone.AmbientSound != None)
		newHeadZone.SoundRadius = 255;
	if (HeadRegion.Zone.AmbientSound != None)
		HeadRegion.Zone.SoundRadius = 0;

	if (newheadZone != none && newHeadZone.bWaterZone && !HeadRegion.Zone.bWaterZone) //RSD: accessed none?
	{
		// make sure we're not crouching when we start swimming
        SetCrouch(false);
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		if (SkillSystem != none)                                                //RSD: accessed none?
			mult = 0.5+0.5*SkillSystem.GetSkillLevelValue(class'SkillSwimming'); //RSD: Halved breath increase
		else
			mult = 1.0;
		/*UnderWaterTime = AugmentationSystem.GetAugLevelValue(class'AugAqualung'); //RSD: Passive Aqualung
        if (UnderWaterTime == -1.0)
        	UnderWaterTime = default.UnderWaterTime;*/
        swimDuration = UnderWaterTime * mult;                                //RSD: Removed effect of Athletics on stamina //RSD: Reinstated
		bRegenStamina = false;
		AmbientSound = Sound'swimmingloop';
		SoundPitch = 46;
		Buoyancy=155.000000;
		//if (bBoosterUpgrade && Energy > 0)
		//    AugmentationSystem.AutoAugs(false,false);
		if (!bHardCoreMode && !bStaminaSystem)
		   SwimTimer = swimDuration;
        //SARGE: Disabled so we can't "dolphin dive" repeatedly for free stamina
        /*
		else if (SwimTimer < 10)
           SwimTimer += 2;
        */
		//swimTimer = swimDuration;


		if (( Level.NetMode != NM_Standalone ) && Self.IsA('Human') )
		{
			if ( AugmentationSystem != None )
				augLevel = AugmentationSystem.GetAugLevelValue(class'AugAqualung');
			if ( augLevel == -1.0 )
				WaterSpeed = Human(Self).Default.mpWaterSpeed * mult;
			else
				WaterSpeed = Human(Self).Default.mpWaterSpeed * 2.0 * mult;
		}
		else
			WaterSpeed = Default.WaterSpeed * mult;
	}
    else
    {
    bRegenStamina = true;

        //SARGE: Always play a breathsound if we went below 70% breath
        //Don't play at 25% or below though, since it already plays the 
        //EDIT: Okay maybe not, this causes overlapping sound issues
        /*
	    if ((100.0 * swimTimer / swimDuration) < 70 && (100.0 * swimTimer / swimDuration) > 25)
            PlayBreatheSound();
        */

    Buoyancy=150.500000;
    if (bBoosterUpgrade)
    {
        if (AugmentationSystem != None)                                         //RSD: Failsafe
            AugmentationSystem.AutoAugs(true,false);
        SwimTimer += 0.5;
    }
    /*UnderWaterTime = AugmentationSystem.GetAugLevelValue(class'AugAqualung');   //RSD: Passive Aqualung
    if (UnderWaterTime == -1.0)
        UnderWaterTime = default.UnderWaterTime;*/
    if (SkillSystem != none)                                                //RSD: accessed none?
		mult = 0.5+0.5*SkillSystem.GetSkillLevelValue(class'SkillSwimming'); //RSD: Halved breath increase
	else
		mult = 1.0;
	swimDuration = UnderWaterTime * mult;                                    //RSD: Removed effect of Athletics on stamina //RSD: Reinstated
    if (SwimTimer > swimDuration)                                               //RSD: Fix for stamina going over max when repeatedly dolphin jumping on Hardcore
        SwimTimer = swimDuration;
    AmbientSound = none;
    SoundPitch = 64;
    }
	Super.HeadZoneChange(newHeadZone);
}

// ----------------------------------------------------------------------
// state PlayerSwimming
// ----------------------------------------------------------------------

state PlayerSwimming
{
	function GrabDecoration()
	{
		// we can't grab decorations underwater
	}

	function ZoneChange(ZoneInfo NewZone)
	{
		// if we jump into water, empty our hands
		if (NewZone.bWaterZone)
		{
			DropDecoration();
			if (bOnFire)
				ExtinguishFire();
		}

		Super.ZoneChange(NewZone);
	}

	event PlayerTick(float deltaTime)
	{
		local vector loc;
        local float mult;
		//DEUS_EX AMSD Additional updates
		//Because of replication delay, aug icons end up being a step behind generally.  So refresh them
		//every freaking tick.
		RefreshSystems(deltaTime);
		RecoilEffectTick(deltaTime);

		DrugEffects(deltaTime);
		HighlightCenterObject();
		UpdateDynamicMusic(deltaTime);
	  // DEUS_EX AMSD For multiplayer...
	  MultiplayerTick(deltaTime);
		FrobTime += deltaTime;

		if (bOnFire)
			ExtinguishFire();

        if (bRegenStamina)
            RegenStaminaTick(deltaTime);                                        //RSD: Generalized stamina regen function

		// save some texture info
		FloorMaterial = GetFloorMaterial();
		WallMaterial = GetWallMaterial(WallNormal);

		// don't let the player run if swimming
		bIsWalking = True;

		// update our swimming info
		mult = AugmentationSystem.GetAugLevelValue(class'AugAqualung');         //RSD: Aqualung decreases drain rate
		if (mult == -1.0)
		    mult = 1.0;
		swimTimer -= (2.0-mult)*deltaTime;
		swimTimer = FMax(0, swimTimer);

        if (swimTimer < swimDuration*0.7 && AugmentationSystem.GetAugLevelValue(class'AugAqualung') == -1.0)
            if (bBoosterUpgrade && Energy > 0)
		        AugmentationSystem.AutoAugs(false,false);

		if ( Role == ROLE_Authority )
		{
			if (swimTimer > 0)
				PainTime = swimTimer;
		}

		// Check if player has walked outside a first-person convo.
		CheckActiveConversationRadius();

		// Check if all the people involved in a conversation are
		// still within a reasonable radius.
		CheckActorDistances();

		// Randomly spawn an air bubble every 0.2 seconds
		// Place them in front of the player's eyes
		swimBubbleTimer += deltaTime;
		if (swimBubbleTimer >= 0.2)
		{
			swimBubbleTimer = 0;
			if (FRand() < 0.2)
			{
				loc = Location + VRand() * 4;
				loc += Vector(ViewRotation) * CollisionRadius * 2;
				loc.Z += CollisionHeight * 0.9;
				Spawn(class'AirBubble', Self,, loc);
			}
		}

		// handle poison
	  //DEUS_EX AMSD Now handled in multiplayertick
		//UpdatePoison(deltaTime);

		// Update Time Played
		UpdateTimePlayed(deltaTime);

		Super.PlayerTick(deltaTime);
	}

	function BeginState()
	{
		local float mult, augLevel;
        local float mult2;                                                      //RSD: Added

		// set us to be two feet high
		SetBasedPawnSize(Default.CollisionRadius, 16);

		// get our skill info
		/*UnderWaterTime = AugmentationSystem.GetAugLevelValue(class'AugAqualung'); //RSD: Passive Aqualung
    	if (UnderWaterTime == -1.0)
        	UnderWaterTime = default.UnderWaterTime;*/
        mult = SkillSystem.GetSkillLevelValue(class'SkillSwimming');
        mult2 = 0.5+0.5*mult;                                                   //RSD: Halved breath increase
		swimDuration = UnderWaterTime * mult2;                                //RSD: Removed effect of Athletics on stamina
		//swimTimer = swimDuration;
		swimBubbleTimer = 0;
        WaterSpeed = Default.WaterSpeed * mult;

		Super.BeginState();
	}
}


// ----------------------------------------------------------------------
// state Dying
//
// make sure the death animation finishes
// ----------------------------------------------------------------------

state Dying
{
	ignores all;

	event PlayerTick(float deltaTime)
	{
	local float time;

      if (PlayerIsClient())
         ClientDeath();
		UpdateDynamicMusic(deltaTime);
		time = Level.TimeSeconds - FrobTime;
        HeadRegion.Zone.ViewFog.X = time*0.01;
        if (bRemoveVanillaDeath && time > 64.0 && HeadRegion.Zone.ViewFog.X != 0)
		{
		if ((MenuUIWindow(DeusExRootWindow(rootWindow).GetTopWindow()) == None) &&
		(ToolWindow(DeusExRootWindow(rootWindow).GetTopWindow()) == None))
		    ConsoleCommand("OPEN DXONLY");
        }
		Super.PlayerTick(deltaTime);
	}

	exec function Fire(optional float F)
	{
		if ( Level.NetMode != NM_Standalone )
        Super.Fire();
	}

	exec function ShowMainMenu()
	{
		// reduce the white glow when the menu is up
		if (InstantFog != vect(0,0,0))
		{
			InstantFog   = vect(0.1,0.1,0.1);
			InstantFlash = 0.01;

			// force an update
			ViewFlash(1.0);
		}
        HeadRegion.Zone.ViewFog.X = 0;
		Global.ShowMainMenu();
	}

	function BeginState()
	{
	local DeusExRootWindow root;
    local BloodPool pool;
    local Vector HitLocation, HitNormal, EndTrace;
	local Actor hit;
    local Inventory anItem;
    local DeusExLevelInfo info;

    UpdateCrosshair();

	info = GetLevelInfo();
	root = DeusExRootWindow(rootWindow);

    ClientFlash(900000,vect(255,0,0));
    if (IsCrouching())
       MeleeRange=51.000000; //CyberP: change this unused var to avoid adding yet more global vars

	if (root != None)
	{
	  root.ClearWindowStack();
	}
    	FrobTime = Level.TimeSeconds;

        if (bRemoveVanillaDeath && Health > -40)
        {
           KillShadow();
           EndTrace = Location - vect(0,0,320);
           if (!HeadRegion.Zone.bWaterZone)
           {
            hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);
            pool = spawn(class'BloodPool',,, HitLocation, Rotator(HitNormal));
            if (pool != none)
            {
				if (pool.IsHDTP())
					pool.maxDrawScale = CollisionRadius / 520.0;
				else
					pool.maxDrawScale = CollisionRadius / 20.0;
                pool.ReattachDecal();
            }
           }
        }
      ClientDeath();
	}

   function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
	{
	}

    function Landed(vector HitNormal)
    {
       if (Velocity.Z < -400)
       {
       PlaySound(sound'pl_fallpain3',SLOT_None,1.5);
       HeadRegion.Zone.ViewFog.X = 255;
       }
    }

	function PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
	{
		local vector ViewVect, HitLocation, HitNormal, whiteVec;
		local float ViewDist;
		local actor HitActor;
		local float time;

		ViewActor = Self;
		if (bHidden && (!bRemoveVanillaDeath || Health < -40))
		{
			// spiral up and around carcass and fade to white in five seconds
			time = Level.TimeSeconds - FrobTime;

			if ( ((myKiller != None) && (killProfile != None) && (!killProfile.bKilledSelf)) ||
				  ((killProfile != None) && killProfile.bValid && (!killProfile.bKilledSelf)))
			{
				if ( killProfile.bValid && killProfile.bTurretKilled )
					ViewVect = killProfile.killerLoc - Location;
				else if ( killProfile.bValid && killProfile.bProximityKilled )
					ViewVect = killProfile.killerLoc - Location;
				else if (( !killProfile.bKilledSelf ) && ( myKiller != None ))
					ViewVect = myKiller.Location - Location;
				CameraLocation = Location;
				CameraRotation = Rotator(ViewVect);
			}
			else if (time < 8.0)
			{
				whiteVec.X = time / 16.0;
				whiteVec.Y = time / 16.0;
				whiteVec.Z = time / 16.0;
				CameraRotation.Pitch = -16384;
				CameraRotation.Yaw = (time * 2000.0); // 8192.0) % 65536; CyberP: slow down the spinning
				ViewDist = 32 + time * 32;
				InstantFog = whiteVec;
				InstantFlash = 0.5;
				ViewFlash(1.0);
				// make sure we don't go through the ceiling
				ViewVect = vect(0,0,1);
				HitActor = Trace(HitLocation, HitNormal, Location + ViewDist * ViewVect, Location);
				if ( HitActor != None )
					CameraLocation = HitLocation;
				else
					CameraLocation = Location + ViewDist * ViewVect;
			}
			else
			{
				if  ( Level.NetMode != NM_Standalone )
				{
					// Don't fade to black in multiplayer
				}
				else
				{
					// then, fade out to black in four seconds and bring up
					// the main menu automatically
					whiteVec.X = FMax(0.5 - (time-8.0) / 8.0, -1.0);
					whiteVec.Y = FMax(0.5 - (time-8.0) / 8.0, -1.0);
					whiteVec.Z = FMax(0.5 - (time-8.0) / 8.0, -1.0);
					CameraRotation.Pitch = -16384;
					CameraRotation.Yaw = (time * 2000.0); //% 65536;  cyberP: same changes as above.
					 ViewDist = 32 + 8.0 * 32;
					InstantFog = whiteVec;
					InstantFlash = whiteVec.X;
					ViewFlash(1.0);

					// start the splash screen after a bit
					// only if we don't have a menu open
					// DEUS_EX AMSD Don't do this in multiplayer!!!!
					if (Level.NetMode == NM_Standalone)
					{
						if (whiteVec == vect(-1.0,-1.0,-1.0))
							if ((MenuUIWindow(DeusExRootWindow(rootWindow).GetTopWindow()) == None) &&
								(ToolWindow(DeusExRootWindow(rootWindow).GetTopWindow()) == None))
								ConsoleCommand("OPEN DXONLY");
					}
				}
				// make sure we don't go through the ceiling
				ViewVect = vect(0,0,1);
				HitActor = Trace(HitLocation, HitNormal, Location + ViewDist * ViewVect, Location);
				if ( HitActor != None )
					CameraLocation = HitLocation;
				else
					CameraLocation = Location + ViewDist * ViewVect;
			}
		}
		else if (bRemoveVanillaDeath)
		{
            time = Level.TimeSeconds - FrobTime;

               CameraLocation = Location;
               CameraRotation = ViewRotation;
               ViewFlash(1.0);
               bHidden = True;

            if (time < 0.35 && !HeadRegion.Zone.bWaterZone && ((AnimSequence == 'DeathFront' && Physics != PHYS_Falling) || bJustLanded))
            {
			//CameraRotation.Pitch = (time * -17000);
			//CameraRotation.Yaw = (time * 1000.0);
			//CameraLocation += Vector(ViewRotation) * (time * 60);
			//CameraLocation.Z -= (time * 5);
			CameraRotation.Pitch = (time * 7000);
			CameraRotation.Roll = (time * 34000.0);
			if (MeleeRange != 51.000000)
			   CameraLocation.Z -= (time * 127);
			else
               CameraLocation.Z -= (time * 48);
			rota = CameraRotation;
			vecta = CameraLocation;
			}
			else if (time < 1.05 && !HeadRegion.Zone.bWaterZone && (AnimSequence == 'DeathBack' || (AnimSequence == 'DeathFront' && Physics == PHYS_Falling)))
            {
            if (time < 0.5)
			CameraRotation.Pitch = (time * 16000);
			else if (time < 0.6)
			CameraRotation.Pitch = (time * 16500);
			else if  (time < 0.7)
			CameraRotation.Pitch = (time * 17000);
			else if (time < 0.8)
			CameraRotation.Pitch = (time * 17500);
			else
			CameraRotation.Pitch = (time * 18000);

			CameraRotation.Yaw += (time * 6000.0);
			if (CameraLocation.Z > Location.Z + (CollisionHeight+1))
			{
			if (MeleeRange != 51.000000)
			   CameraLocation.Z -= (time * 30);
			else
               CameraLocation.Z -= (time * 13);
			}
            rota = CameraRotation;
			vecta = CameraLocation;
			}
			else if (time < 8.0 && HeadRegion.Zone.bWaterZone)
			{
			   CameraRotation.Pitch -= (time * 2000);
			   CameraRotation.Yaw -= (time * 1000);
			   rota = CameraRotation;
			   vecta = CameraLocation;
			}
			else
            {
            CameraRotation = rota;
			CameraLocation = vecta;
			}
		}
		else
		{
			// use FrobTime as the cool DeathCam timer
			FrobTime = Level.TimeSeconds;

			// make sure we don't go through the wall
		    ViewDist = 190;
			ViewVect = vect(1,0,0) >> Rotation;
			HitActor = Trace( HitLocation, HitNormal,
					Location - ViewDist * vector(CameraRotation), Location, false, vect(12,12,2));
			if ( HitActor != None )
				CameraLocation = HitLocation;
			else
				CameraLocation = Location - ViewDist * ViewVect;
		}

		// don't fog view if we are "paused"
		if (DeusExRootWindow(rootWindow).bUIPaused)
		{
			InstantFog   = vect(0,0,0);
			InstantFlash = 0;
			ViewFlash(1.0);
		}
	}

Begin:
    ShowHUD(false);
	// Dead players comes back to life with scope view, so this is here to prevent that
	if ( DeusExWeapon(inHand) != None )
	{
		DeusExWeapon(inHand).bZoomed = False;
		DeusExWeapon(inHand).RefreshScopeDisplay(Self, True, False);
	}

	if ( DeusExRootWindow(rootWindow).hud.augDisplay != None )
	{
		DeusExRootWindow(rootWindow).hud.augDisplay.bVisionActive = False;
		DeusExRootWindow(rootWindow).hud.augDisplay.activeCount = 0;
	}

	// Don't come back to life drugged or posioned
	poisonCounter		= 0;
	poisonTimer			= 0;
	drugEffectTimer	= 0;

    if (AugmentationSystem != None)
        AugmentationSystem.DeactivateAll(true); //CyberP: deactivate augs
	// Don't come back to life crouched
    SetCrouch(false,true);

    ClientFlash(900000,vect(160,0,0));
    IncreaseClientFlashLength(4);
	FrobTime = Level.TimeSeconds;
	bBehindView = True;
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	DesiredFOV = Default.DesiredFOV;
	FinishAnim();
	KillShadow();

   FlashTimer = 0;

	// hide us and spawn the carcass
	bHidden = True;
	//if (!bRemoveVanillaDeath)
	   SpawnCarcass();
   //DEUS_EX AMSD Players should not leave physical versions of themselves around :)
   if (Level.NetMode != NM_Standalone)
      HidePlayer();

   LoadHack:
    if (bDeadLoad)
	{
	    Sleep(0.2);
	    bDeadLoad = False;
	    QuickLoadConfirmed();
	}
}

// ----------------------------------------------------------------------
// state Interpolating
// ----------------------------------------------------------------------

state Interpolating
{
	ignores all;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
	{
	}

	// check to see if we are done interpolating, if so, then travel to the next map
	event InterpolateEnd(Actor Other)
	{
		if (InterpolationPoint(Other).bEndOfPath)
			if (NextMap != "")
			{
				// DEUS_EX_DEMO
				//
				// If this is the demo, show the demo splash screen, which
				// will exit the game after the player presses a key/mouseclick
//				if (NextMap == "02_NYC_BatteryPark")
//					ShowDemoSplash();
//				else
					Level.Game.SendPlayer(Self, NextMap);
			}
	}

	exec function Fire(optional float F)
	{
		local DeusExLevelInfo info;

		// only bring up the menu if we're not in a mission outro
		info = GetLevelInfo();
		if ((info != None) && (info.MissionNumber < 0))
			ShowMainMenu();
	}

	event PlayerTick(float deltaTime)
	{
		UpdateInHand();
		UpdateDynamicMusic(deltaTime);
		ShowHud(False);
	}

Begin:
	if (bOnFire)
		ExtinguishFire();

	bDetectable = False;

	// put away your weapon
	if (Weapon != None)
	{
		Weapon.bHideWeapon = True;
		Weapon = None;
		PutInHand(None);
	}

	// can't carry decorations across levels
	if (CarriedDecoration != None)
	{
		CarriedDecoration.Destroy();
		CarriedDecoration = None;
	}

	PlayAnim('Still');
}

state StaticFreeze
{
	ignores all;

	event PlayerTick(float deltaTime)
	{
		UpdateInHand();

//		ViewFlash(deltaTime);
		if (aGEPProjectile==none)
		{
			bStaticFreeze=false;
		   GotoState('PlayerWalking');
		}
	}
Begin:
}
// ----------------------------------------------------------------------
// state Paralyzed
// ----------------------------------------------------------------------

state Paralyzed
{
	ignores all;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
	{
	}

	exec function Fire(optional float F)
	{
		ShowMainMenu();
	}

	event PlayerTick(float deltaTime)
	{
		UpdateInHand();
		ShowHud(False);
		ViewFlash(deltaTime);
	}

Begin:
	if (bOnFire)
		ExtinguishFire();

	bDetectable = False;

	// put away your weapon
	if (Weapon != None)
	{
		Weapon.bHideWeapon = True;
		Weapon = None;
		PutInHand(None);
	}

	// can't carry decorations across levels
	if (CarriedDecoration != None)
	{
		CarriedDecoration.Destroy();
		CarriedDecoration = None;
	}

	SetPhysics(PHYS_None);
	PlayAnim('Still');
	Stop;

Letterbox:
	if (bOnFire)
		ExtinguishFire();

	bDetectable = False;

	// put away your weapon
	if (Weapon != None)
	{
		Weapon.bHideWeapon = True;
		Weapon = None;
		PutInHand(None);
	}

	// can't carry decorations across levels
	if (CarriedDecoration != None)
	{
		CarriedDecoration.Destroy();
		CarriedDecoration = None;
	}

	SetPhysics(PHYS_None);
	PlayAnim('Still');
	if (rootWindow != None)
		rootWindow.NewChild(class'CinematicWindow');
}

// ----------------------------------------------------------------------
// RenderOverlays()
// render our in-hand object
// ----------------------------------------------------------------------
simulated event RenderOverlays( canvas Canvas )
{
//	if ((aGEPProjectile!=none)&&(aGEPProjectile.IsA('Rocket'))&&(Rocket(aGEPProjectile).bFlipFlopCanvas)) return;

	if ((GEPmounted!=none)&&(GEPmounted.bFlipFlopCanvas)) return;

	Super.RenderOverlays(Canvas);

	if (!IsInState('Interpolating') && !IsInState('Paralyzed'))
		if ((inHand != None) && (!inHand.IsA('Weapon')))
			inHand.RenderOverlays(Canvas);



	if ((aGEPProjectile!=none)&&(aGEPProjectile.IsA('Rocket'))&&(bGEPprojectileInflight))
	{
		if (!bStaticFreeze)
		{
			SAVErotation=Rotation;
			SAVElocation=Location;
			bStaticFreeze=true;
		}
//		Rocket(aGEPProjectile).RenderPortal(Canvas);
	} else
		bStaticFreeze=false;
}

// ----------------------------------------------------------------------
// RestrictInput()
//
// Are we in a state which doesn't allow certain exec functions?
// ----------------------------------------------------------------------

function bool RestrictInput(optional bool bDontCheckConversation)
{
	if (IsInState('Interpolating') || IsInState('Dying') || IsInState('Paralyzed') || (FlagBase.GetBool('PlayerTraveling') ))
		return True;

    //SARGE: Being in a cutscene counts as restricted input
    if (!bDontCheckConversation && conPlay != None && conPlay.bConversationStarted && conPlay.displayMode == DM_ThirdPerson)
        return true;

    //SARGE: Disallow any sort of UI operations when the "pause" key is pressed
    //This way, real-time UI is actually a real-time UI
    if (bHardCoreMode || bRealUI)
    {
        if (DeusExRootWindow(rootWindow) != None && DeusExRootWindow(rootWindow).bUIPaused || Level.Pauser != "")
            return true;
    }

	return False;
}


// ----------------------------------------------------------------------
// DroneExplode
// SARGE: Now requires a high amount of energy, won't detonate if energy is lacking.
// ----------------------------------------------------------------------
function bool DroneExplode()
{
    local AugDrone anAug;
    anAug = AugDrone(AugmentationSystem.FindAugmentation(class'AugDrone'));
    if (anAug == None)
        return false;

    //Don't detonate without Energy
    if (Energy < anAug.GetAdjustedEnergy(anAug.EMPDrain))
        return false;

    if (bSpyDroneSet)
    {
    	SAVErotation = ViewRotation;
    	bSpyDroneSet = false;                                                   //RSD: Ensures that the Spy Drone will ACTUALLY be turned off
    }
	if (aDrone != None)
	{
		aDrone.Explode(aDrone.Location, vect(0,0,1));
        anAug.Deactivate();
        Energy -= anAug.GetAdjustedEnergy(anAug.EMPDrain); //CyberP: energy cost upon detonation.
        if (Energy < 0)
            Energy = 0;

        return true;
	}

    return false;
}

// ----------------------------------------------------------------------
// BuySkills()
// ----------------------------------------------------------------------

exec function BuySkills()
{
	if ( Level.NetMode != NM_Standalone )
	{
		// First turn off scores if we're heading into skill menu
		if ( !bBuySkills )
			ClientTurnOffScores();

		bBuySkills = !bBuySkills;
		BuySkillSound( 2 );
	}
}

// ----------------------------------------------------------------------
// KillerProfile()
// ----------------------------------------------------------------------

exec function KillerProfile()
{
	bKillerProfile = !bKillerProfile;
}

// ----------------------------------------------------------------------
// ClientTurnOffScores()
// ----------------------------------------------------------------------
function ClientTurnOffScores()
{
	if ( bShowScores )
		bShowScores = False;
}

// ----------------------------------------------------------------------
/// ShowScores()  //CyberP: this function is now used in singleplayer for secondary weapon use
// ----------------------------------------------------------------------

exec function ShowScores()
{
	if ( bBuySkills && !bShowScores )
		BuySkills();
	if (Level.NetMode == NM_Standalone)
	{
        if (RestrictInput())
		return;

        if (CarriedDecoration != none)                                          //RSD: just don't screw around with this, it didn't make any sense anyway
        return;

        //Sarge: Now we check for ChargedPickup charge level
        if (assignedWeapon.IsA('ChargedPickup') && ChargedPickup(assignedWeapon).GetCurrentCharge() == 0)
        {
            //Do nothing.
            return;
        }
        //SARGE: Check DTS Charge Level
        else if (assignedWeapon.IsA('WeaponNanoSword') && WeaponNanoSword(assignedWeapon).ChargeManager.GetCurrentCharge() == 0)
        {
            //Do nothing.
            return;
        }
        else if (assignedWeapon != none && assignedWeapon.IsA('RSDEdible')) //Sarge: Allow using edibles from the secondary button
		{
            assignedWeapon.GotoState('Activated');
            return;
		}
        else if (assignedWeapon != none && (assignedWeapon.IsA('Medkit') || assignedWeapon.IsA('BioelectricCell') || (assignedWeapon.IsA('ChargedPickup'))))
		{
            if(assignedWeapon.IsInState('Activated'))
                assignedWeapon.GotoState('DeActivated');
            else assignedWeapon.GotoState('Activated');
            return;
		}
		if (!(inHand != none && inHand.IsA('Binoculars')) && CarriedDecoration == None &&assignedWeapon != none && assignedWeapon.IsA('Binoculars')) //RSD: Added Binoculars as secondary items (when not holding Binocs)
        {
            if(!Binoculars(assignedWeapon).bActive)
            {
                if (inHand != none && inHand.IsA('DeusExWeapon'))
                {
                    //DeusExWeapon(inHand).GotoState('DownWeapon');
                    DeusExWeapon(inHand).ScopeOff();
                    DeusExWeapon(inHand).LaserOff(true);
                    PutInHand(None);
                }
                else if (inHand.IsA('SkilledTool'))
                {
                    SkilledTool(inHand).PutDown();
                }
                else if (inHand.IsA('DeusExPickup'))
                {
                    PutInHand(None);
                }
                //assignedWeapon.GotoState('Activated');
                Binoculars(assignedWeapon).Activate();
            }
            else
            {
                //assignedWeapon.GotoState('DeActivated');
                Binoculars(assignedWeapon).Activate();
            }
            return;
        }
        else if (inHand != none && inHand.IsA('Binoculars') && assignedWeapon != none && assignedWeapon.IsA('Binoculars')) //RSD: Added Binoculars as secondary items (when holding Binocs)
        {
            if(!Binoculars(inHand).bActive)
                //inHand.GotoState('Activated');
                Binoculars(assignedWeapon).Activate();
            else
                //inHand.GotoState('DeActivated');
                Binoculars(assignedWeapon).Activate();
        }
        if (/*inHand != none && */assignedWeapon != None && assignedWeapon != inHand) //RSD: Always do quickdraw even if nothing in hand
        {
         if (Region.Zone.bWaterZone)
         {
             if (assignedWeapon.IsA('WeaponShuriken'))
             {
                 ClientMessage(WeaponShuriken(assignedWeapon).msgNotWorking);
                 return;
             }
         }
         PutInHand(assignedWeapon,true);
         if (inHandPending.IsA('DeusExWeapon'))
	         DeusExWeapon(inHandPending).bBeginQuickMelee=true;
         if (inHandPending.IsA('Flare'))
             Flare(inHandPending).bBeginQuickThrow=true;
	    }
	    else if (inHand != none && assignedWeapon != None && assignedWeapon == inHand)
	    {
	      if (inHand.IsA('DeusExWeapon') && DeusExWeapon(inHand).bBeginQuickMelee)
	      {
	              if (DeusExWeapon(inHand).AccurateRange > 200 && DeusExWeapon(inHand).AmmoLeftInClip() == 0 ) //CyberP/|Totalitarian|: hack fix bug
	                 return;
	              else
	              {
                     DeusExWeapon(inHand).quickMeleeCombo = 0.4;
                     DeusExWeapon(inHand).bAlreadyQuickMelee = true;
	              }
          }
          else if (inHand.IsA('Flare') && Flare(inHand).bBeginQuickThrow)
          {
               Flare(inHand).quickThrowCombo = 0.4;
          }
          else// if (primaryWeapon == None || primaryWeapon == assignedWeapon)  //RSD: Don't actually need this stuff?
          {
               if (inHand.IsA('DeusExWeapon'))
                  DeusExWeapon(inHand).Fire(0);
               if (inHand.IsA('Flare'))
                  Flare(inHand).Activate();
          }
	    }
	    else if (inHand == none && inHandPending == None && CarriedDecoration == None)
	    {
	       if (assignedWeapon != None)
	       {
	           PutInHand(assignedWeapon,true);
           }
	    }

        /*if (Weapon != None && inHand != none && assignedWeapon != None && assignedWeapon != inHand)
        {
         if (Region.Zone.bWaterZone)
         {
             if (assignedWeapon.IsA('WeaponShuriken'))
             {
                 ClientMessage(WeaponShuriken(assignedWeapon).msgNotWorking);
                 return;
             }
         }
         if (inHand.IsA('DeusExWeapon'))
         PutInHand(assignedWeapon,true);
         if (inHandPending.IsA('DeusExWeapon'))
	         DeusExWeapon(inHandPending).bBeginQuickMelee=true;
	    }
	    else if (inHand != none && assignedWeapon != None && assignedWeapon == inHand)
	    {
	      if (inHand.IsA('DeusExWeapon') && DeusExWeapon(inHand).bBeginQuickMelee)
	      {
	              if (DeusExWeapon(inHand).AccurateRange > 200 && DeusExWeapon(inHand).AmmoLeftInClip() == 0 ) //CyberP/|Totalitarian|: hack fix bug
	                 return;
	              else
                     DeusExWeapon(inHand).quickMeleeCombo = 0.4;
          }
          else if (primaryWeapon == None || primaryWeapon == assignedWeapon)
          {
               if (inHand.IsA('DeusExWeapon'))
                  DeusExWeapon(inHand).Fire(0);
          }
	    }
	    else if (inHand == none && inHandPending == None && CarriedDecoration == None)
	    {
	       if (assignedWeapon != None)
	           inHandPending = assignedWeapon;
	    }*/
    }
	bShowScores = !bShowScores;
}

//Sarge: Because we can only inherit from one class,
//we don't have proper OOP support, because all the Deus Ex objects
//are inheriting off native unreal objects. So we need to do some
//magic here to fix it all up.
//This should probably be moved elsewhere
function DoLeftFrob(Actor frobTarget)
{
    local bool bDefaultFrob;
    
    if (CheckFrobDeclined(frobTarget))
        return;
    
    if (inHand == None)
    {
        if (frobTarget.isA('DeusExPickup'))
            bDefaultFrob = DeusExPickup(frobTarget).DoLeftFrob(Self);
        else if (frobTarget.isA('DeusExWeapon'))
            bDefaultFrob = DeusExWeapon(frobTarget).DoLeftFrob(Self);
        else if (frobTarget.isA('DeusExMover'))
            bDefaultFrob = DeusExMover(frobTarget).DoLeftFrob(Self);
        else if (frobTarget.isA('ElectronicDevices'))
            bDefaultFrob = ElectronicDevices(frobTarget).DoLeftFrob(Self);
        else if (frobTarget.isA('DeusExDecoration'))
            bDefaultFrob = DeusExDecoration(frobTarget).DoLeftFrob(Self);
        else if (frobTarget.isA('DeusExCarcass'))
            bDefaultFrob = DeusExCarcass(frobTarget).DoLeftFrob(Self);
    }

    //Pick up and equip items by default
    //This can't be done in Inventory classes. Ugh. I really wish we could access this class!
    if (bDefaultFrob && frobTarget.IsA('Inventory'))
    {
        if (HandleItemPickup(FrobTarget, True))
        { 
            bLeftClicked = true;
            FindInventorySlot(Inventory(FrobTarget));
        }
    }
}

//Sarge: Because we can only inherit from one class,
//we don't have proper OOP support, because all the Deus Ex objects
//are inheriting off native unreal objects. So we need to do some
//magic here to fix it all up.
//This should probably be moved elsewhere
function DoRightFrob(Actor frobTarget)
{
    local bool bDefaultFrob;

    if (frobTarget == None)
        return;

    if (CheckFrobDeclined(frobTarget))
        return;

    bDefaultFrob = true;
    bLeftClicked = false;

    if (frobTarget.isA('DeusExPickup'))
        bDefaultFrob = DeusExPickup(frobTarget).DoRightFrob(Self,inHand != None);
    else if (frobTarget.isA('DeusExWeapon'))
        bDefaultFrob = DeusExWeapon(frobTarget).DoRightFrob(Self,inHand != None);
    else if (frobTarget.isA('DeusExMover'))
        bDefaultFrob = DeusExMover(frobTarget).DoRightFrob(Self,inHand != None);
    else if (frobTarget.isA('ElectronicDevices'))
        bDefaultFrob = ElectronicDevices(frobTarget).DoRightFrob(Self,inHand != None);
    else if (frobTarget.isA('DeusExDecoration'))
        bDefaultFrob = DeusExDecoration(frobTarget).DoRightFrob(Self,inHand != None);

    //Handle Inventory classes. Ugh. I really wish we could access this class!
    if (bDefaultFrob && frobTarget.IsA('Inventory'))
    {
        if (HandleItemPickup(FrobTarget, True))
            FindInventorySlot(Inventory(FrobTarget));
    }
    else if (bDefaultFrob)
        DoFrob(Self, None);
}

//SARGE: Check if a frobbed item is declined, and handle it
//Returns FALSE if an item was not declined, TRUE if it was
function bool CheckFrobDeclined(Actor frobTarget)
{
    if (frobTarget.IsA('Inventory') && DeclinedItemsManager.IsDeclined(class<Inventory>(frobTarget.class)) && clickCountCyber == 0)
    {
        SetDoubleClickTimer();
        ClientMessage(sprintf(msgDeclinedPickup,Inventory(frobTarget).ItemName));
        return true;
    }
    return false;
}

//Sarge: Because we can only inherit from one class,
//we don't have proper OOP support, because all the Deus Ex objects
//are inheriting off native unreal objects. So we need to do some
//magic here to fix it all up.
//This should probably be moved elsewhere
function DoItemPutAwayFunction(Inventory inv)
{
    /*
    if (inv.isA('DeusExPickup'))
        DeusExPickup(inv).PutAway(Self);
    else if (inv.isA('DeusExWeapon'))
        DeusExWeapon(inv).PutAway(Self);
    else if (inv.isA('DeusExMover'))
        DeusExMover(inv).PutAway(Self);
    else if (inv.isA('ElectronicDevices'))
        ElectronicDevices(inv).PutAway(Self);
    else if (inv.isA('DeusExDecoration'))
        DeusExDecoration(inv).PutAway(Self);
    */
}

//Sarge: Because we can only inherit from one class,
//we don't have proper OOP support, because all the Deus Ex objects
//are inheriting off native unreal objects. So we need to do some
//magic here to fix it all up.
//This should probably be moved elsewhere
function DoItemDrawFunction(Inventory inv)
{
    if (inv == None)
        return;

    if (inv.isA('DeusExPickup'))
        DeusExPickup(inv).Draw(Self);
    else if (inv.isA('DeusExWeapon'))
        DeusExWeapon(inv).Draw(Self);
    /*else if (inv.isA('DeusExMover'))
        DeusExMover(inv).Draw(Self);
    else if (inv.isA('ElectronicDevices'))
        ElectronicDevices(inv).Draw(Self);
    else if (inv.isA('DeusExDecoration'))
        DeusExDecoration(inv).Draw(Self);
    */
}


// ----------------------------------------------------------------------
// ParseLeftClick()
// ----------------------------------------------------------------------

exec function ParseLeftClick()
{
	local int AugMuscleOn;
	local DeusExPickup pickup;
	local int MedSkillLevel;
	local DeusExRootWindow root;
	local bool bThrownDecor;
	local Inventory item, nextItem;
	//local Decoration Decor;  //CyberP: see commented out block further down.

	//
	// ParseLeftClick deals with things in your HAND
	//
	// Precedence:
    // - Select aug in radial menu
	// - Detonate spy drone
	// - Fire (handled automatically by user.ini bindings)
	// - Use inHand
	// - Select last weapon

	if (RestrictInput())
		return;

    //Select current aug
	if (bRadialAugMenuVisible) {
        RadialMenuToggleCurrentAug();
        return;
    }

	// if the spy drone augmentation is active, blow it up
	if (bSpyDroneActive && !bSpyDroneSet && !bRadialAugMenuVisible)                                       //RSD: Allows the user to toggle between moving and controlling the drone, also added Lorenz's wheel
	{
        bBlockNextFire = true;
		if (DroneExplode());
            return;
	}

    //Blow up any GEP profectiles in flight
	if (bGEPprojectileInflight)
	{
        if (aGEPProjectile!=none && aGEPProjectile.IsA('Rocket'))
        {
            if (aGEPProjectile.SoundPitch!=112)
            {
                aGEPProjectile.MaxSpeed=1600.000000;
                aGEPProjectile.speed=1600.000000;
                aGEPProjectile.Velocity *= 2;
                aGEPProjectile.SoundPitch=112;
                PlaySound(sound'impboom2',SLOT_None);
            }
            return;
        }
	}

    if (inHand != None)
    {

        //Handle Reload Cancelling
        if (inHand.isA('DeusExWeapon') && DeusExWeapon(inHand).IsInState('Reload'))
            DeusExWeapon(inHand).bCancelLoading = true;

        //Use SkilledTools
        else if (inHand.isA('SkilledTool') && frobTarget != None && (frobTarget.isA('DeusExMover') || frobTarget.isA('HackableDevices')))
        {
            DoFrob(Self, inHand);
        }

        //Activate activatable items
        else if (inHand.bActivatable)
            inHand.Activate();

    }

    //Special cases aside, now do the left hand frob behaviour
    else if (FrobTarget != none && IsReallyFrobbable(FrobTarget,true) && !bInHandTransition && (inHand == None || !inHand.IsA('POVcorpse')) && CarriedDecoration == None)
	{
        DoLeftFrob(FrobTarget);
	}

    //Handle throwing decorations/corpses and selecting weapons
	else
	{
        if (AugmentationSystem != None)
            AugMuscleOn = AugmentationSystem.GetAugLevelValue(class'AugMuscle');
		if (AugMuscleOn> -1.0)
		{
            if ((inHand != None) && !bInHandTransition &&(InHand.IsA('POVcorpse')))
            {
                bThrownDecor=true;
                if (bRealisticCarc || bHardCoreMode)
                    bThrowDecoration=False;
                else
                    bThrowDecoration=True;
                DropItem();
                return;
            }
            else
            {
                if (Energy <= 0 && CarriedDecoration != None && carriedDecoration.Mass > 60)
                {
                    PlaySound(sound'cantdrophere',SLOT_None,,,,0.7);
                    ClientMessage(EnergyDepleted);
                    return;
                }
                if (CarriedDecoration != None)
                {
                    bThrownDecor=true;
                    bThrowDecoration=true;                                         //RSD: Rest of this should be in the if branch so you can't cancel footsteps
                    DropDecoration();
                    // play a throw anim
                    PlayAnim('Attack',,0.1);
                    return;
                }
            }
        }

        //SARGE: Final option - select last weapon
        if (inHand == None && bLeftClickUnholster)
            SelectLastWeapon();
	}
}

// ----------------------------------------------------------------------
// SelectLastWeapon()
// Sarge: Selects the last weapon we had selected, or if we're using the alternate toolbelt, selects the primary selection.
// ----------------------------------------------------------------------

function SelectLastWeapon(optional bool allowEmpty)
{
    local DeusExRootWindow root;
    root = DeusExRootWindow(rootWindow);

    if (bLastWasEmpty)
    {
        bLastWasEmpty = false;
        if (allowEmpty)
        {
            PutInHand(None);
            return;
        }
    }

    if (root != None && root.hud != None)
    {
        if (bAlternateToolbelt > 0 && root.ActivateObjectInBelt(advBelt))
        {
            NewWeaponSelected();
            return;
        }
    }
    
    if (primaryWeapon.Owner == self)
    {
        PutInHand(primaryWeapon);
        NewWeaponSelected();
    }
}

// ----------------------------------------------------------------------
// NewWeaponSelected()
// Sarge: Resets some values when a new weapon is selected, to control belt/holstering/selection functions
// ----------------------------------------------------------------------

function NewWeaponSelected()
{
    bScrollSelect = false;
    clickCountCyber = 0;
    beltScrolled = advBelt;
}

//Select Inventory Item
function bool SelectInventoryItem(Name type, optional bool bNoPrimary)
{
    local Inventory item;
    item = Inventory;
    while (item != None)
    {
        if (item.IsA(type))
        {
            PutInHand(item,bNoPrimary);
            return true;
        }
        item = item.Inventory;
    }
    return false;
}

//Returns whether a given frobbable can actually be interacted with
//So that we can skip the ones that don't highlight or can't really be used,
//preventing them from blocking holstering with right click
function bool IsReallyFrobbable(Actor target, optional bool left)
{
    if (target.isA('DeusExDecoration') && !DeusExDecoration(target).bHighlight)
        return false;
    if (target.isA('DeusExMover') && left)
        return DeusExMover(target).bBreakable || DeusExMover(target).bFrobbable;
    if (target.isA('DeusExMover'))
        return DeusExMover(target).bHighlight && DeusExMover(target).bFrobbable;
    if (target.isA('ElevatorMover'))
        return false;
    return true;
}

// ----------------------------------------------------------------------
// SetDoubleClickTimer()
// Sets up the double-click holster/unholster timer
// ----------------------------------------------------------------------

function SetDoubleClickTimer()
{
    doubleClickCheck=0.4;
    clickCountCyber=1;
}
    
function DoAutoHolster()
{
    if (bAutoHolster)// && (clickCountCyber >= 1 || dblClickHolster == 0 ))
        PutInHand(None);
    else if (bAutoHolster && dblClickHolster > 0)
        SetDoubleClickTimer();
}

// ----------------------------------------------------------------------
// ParseRightClick()
// ----------------------------------------------------------------------

exec function ParseRightClick()
{
	//
	// ParseRightClick deals with things in the WORLD
	//
	// Precedence:
    // - Reload last save if dead
    // - Unscope/Unzoom currently held object
    // - Park Spy Drone
	// - Pickup highlighted Inventory
	// - Frob highlighted object
	// - Grab highlighted Decoration
	// - Put away (or drop if it's a deco) inHand
	//

	local AutoTurret turret;
	local int ViewIndex;
	local bool bPlayerOwnsIt;
	local Inventory oldFirstItem;
	local Inventory oldInHand;
	local Decoration oldCarriedDecoration;
	local Vector loc;
	local DeusExWeapon ExWep;
    local DeusExRootWindow root;

    //SARGE: Add quickloading if pressing right click while dead.
    if (IsInState('dying') && !bDeadLoad)
    {
        QuickLoad();
    }

    if (RestrictInput())
		return;

    if (bRadialAugMenuVisible)
    {
        RadialMenuQuickCancel();
        return;
    }

    //Descope if we have binocs/scope
    if (inHand != None)
    {
        if (inHand.IsA('DeusExWeapon') && DeusExWeapon(inhand).bZoomed)
        {
            DeusExWeapon(inhand).ScopeToggle();
            return;
        }
        else if (inHand.IsA('Binoculars') && Binoculars(inhand).bActive)
        {
            Binoculars(inhand).Activate();
            return;
        }
    }

    //Park spy drone
    if (bSpyDroneActive && !bSpyDroneSet)                                       //RSD: Allows the user to toggle between moving and controlling the drone
	{
	    /*if (aDrone != none)
		aDrone.AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 768);
		if (FRand() < 0.25)
        PlaySound(sound'CatDie');
        else if (FRand() < 0.5)
        PlaySound(sound'DogLargeBark1');
        else if (FRand() < 0.75)
        PlaySound(sound'SeagullCry');
        else
        PlaySound(sound'RatSqueak1');
		return;*/
		if (aDrone != none)
        {
            AugDrone(AugmentationSystem.FindAugmentation(class'AugDrone')).ToggleStandbyMode(true);
            return;
        }
	}

	oldFirstItem = Inventory;
	oldInHand = inHand;
	oldCarriedDecoration = CarriedDecoration;

	if (FrobTarget != None)
		loc = FrobTarget.Location;

	if (FrobTarget != None && IsReallyFrobbable(FrobTarget))
	{
        //SARGE: I really should add this to the proper OOP setup, but I just don't care.
        //We don't care about MP, so will omit it for now
        if (( Level.NetMode != NM_Standalone ) && ( TeamDMGame(DXGame) != None ))
        {
            if ( FrobTarget.IsA('LAM') || FrobTarget.IsA('GasGrenade') || FrobTarget.IsA('EMPGrenade'))
            {
                if ((ThrownProjectile(FrobTarget).team == PlayerReplicationInfo.team) && ( ThrownProjectile(FrobTarget).Owner != Self ))
                {
                    if ( ThrownProjectile(FrobTarget).bDisabled )		// You can re-enable a grenade for a teammate
                    {
                        ThrownProjectile(FrobTarget).ReEnable();
                        return;
                    }
                    MultiplayerNotifyMsg( MPMSG_TeamLAM );
                    return;
                }
            }
            if ( FrobTarget.IsA('ComputerSecurity') && (PlayerReplicationInfo.team == ComputerSecurity(FrobTarget).team) )
            {
                // Let controlling player re-hack his/her own computer
                bPlayerOwnsIt = False;
                foreach AllActors(class'AutoTurret',turret)
                {
                    for (ViewIndex = 0; ViewIndex < ArrayCount(ComputerSecurity(FrobTarget).Views); ViewIndex++)
                    {
                        if (ComputerSecurity(FrobTarget).Views[ViewIndex].turretTag == turret.Tag)
                        {
                            if (( turret.safeTarget == Self ) || ( turret.savedTarget == Self ))
                            {
                                bPlayerOwnsIt = True;
                                break;
                            }
                        }
                    }
                }
                if ( !bPlayerOwnsIt )
                {
                    MultiplayerNotifyMsg( MPMSG_TeamComputer );
                    return;
                }
            }
        }
		// otherwise, just frob it
		DoRightFrob(FrobTarget);
	}
	else
	{
		// if there's no FrobTarget, put away an inventory item or drop a decoration
		// or drop the corpse
		if ((inHand != None) && inHand.IsA('POVCorpse'))
		{
			DropItem();
		}
		else if (CarriedDecoration != None)
		{
			PutInHand(None);
		}
        //If we are using a different items to our belt item, and classic mode is on or we scrolled, select it instantly
		else if ((bAlternateToolbelt > 1 || bScrollSelect) && beltScrolled != beltLast && inHand != None && !selectedNumberFromEmpty)
		{
			root = DeusExRootWindow(rootWindow);
			if (root != None && root.hud != None)
			{
				root.ActivateObjectInBelt(advBelt);
                NewWeaponSelected();
                beltLast = advBelt;
			}
		}
        else if (inHand == None && (clickCountCyber >= 1 || dblClickHolster < 2))
		{
            //SARGE: Added support for the unholster behaviour from the Alternate Toolbelt on both Toolbelts
            //Additionally, unholstering is now tied to the double-click holstering setting.
            SelectLastWeapon();
		}
		else if (inHand != None && (clickCountCyber >= 1 || dblClickHolster == 0))
		{
            PutInHand(None);
            NewWeaponSelected();
		    DoRightFrob(FrobTarget); //Last minute check for things with no highlight.
		}
		else
		{
            SetDoubleClickTimer();
		    DoRightFrob(FrobTarget); //Last minute check for things with no highlight.
        }
	}

	if ((oldInHand == None) && (inHand != None))
		PlayPickupAnim(loc);
	else if ((oldCarriedDecoration == None) && (CarriedDecoration != None))
		PlayPickupAnim(loc);
}

// ----------------------------------------------------------------------
// PlayPickupAnim()
// ----------------------------------------------------------------------

function PlayPickupAnim(Vector locPickup)
{
	if (Location.Z - locPickup.Z < 16)
		PlayAnim('PushButton',,0.1);
	else
		PlayAnim('Pickup',,0.1);
}

// ----------------------------------------------------------------------
// HandleItemPickup()
// ----------------------------------------------------------------------

function bool HandleItemPickup(Actor FrobTarget, optional bool bSearchOnly)
{
	local bool bCanPickup;
	local bool bSlotSearchNeeded;
	local Inventory foundItem;
    local DeusExAmmo foundAmmo;
    local DeusExAmmo assignedAmmo;
    local int intj;

	bSlotSearchNeeded = True;
	bCanPickup = True;

	// Special checks for objects that do not require phsyical inventory
	// in order to be picked up:
	//
	// - NanoKeys
	// - DataVaultImages
	// - Credits

	if ((FrobTarget.IsA('DataVaultImage')) || (FrobTarget.IsA('NanoKey')) || (FrobTarget.IsA('Credits')))
	{
		bSlotSearchNeeded = False;
	}
	else if (FrobTarget.IsA('DeusExPickup'))
	{
		// If an object of this type already exists in the player's inventory *AND*
		// the object is stackable, then we don't need to search.

		if ((FindInventoryType(FrobTarget.Class) != None) && (DeusExPickup(FrobTarget).bCanHaveMultipleCopies))
			 bSlotSearchNeeded = False;
        /*else if (FindInventoryType(FrobTarget.Class) != None)
        	 bCanPickup = False;*/
        if (!bCanPickup)
			 ClientMessage(Sprintf(CanCarryOnlyOne, foundItem.itemName));
   	}
	else
	{
		// If this isn't ammo or a weapon that we already have,
		// check if there's enough room in the player's inventory
		// to hold this item.

		foundItem = GetWeaponOrAmmo(Inventory(FrobTarget));

		if (foundItem != None)
		{
			bSlotSearchNeeded = False;

			// if this is an ammo, and we're full of it, abort the pickup
			if (foundItem.IsA('Ammo'))
			{
			  	if (Ammo(foundItem).AmmoAmount >= GetAdjustedMaxAmmo(Ammo(foundItem))) //RSD: replaced Ammo(foundItem).MaxAmmo) with adjusted
				{
                    ClientMessage(TooMuchAmmo);
					bCanPickup = False;
				}
			}
//GMDX: hmm
			// If this is a grenade or LAM (what a pain in the ass) then also check
			// to make sure we don't have too many grenades already
			else if ((foundItem.IsA('WeaponEMPGrenade')) ||
			    (foundItem.IsA('WeaponGasGrenade')) ||
				(foundItem.IsA('WeaponNanoVirusGrenade')) ||
				(foundItem.IsA('WeaponLAM')))
			{
				if (DeusExWeapon(foundItem).AmmoType.AmmoAmount >= GetAdjustedMaxAmmo(DeusExWeapon(foundItem).AmmoType)) //RSD: replaced DeusExWeapon(foundItem).AmmoType.MaxAmmo with adjusted
			{
					ClientMessage(TooMuchAmmo);
					bCanPickup = False;
				}
			}

			// Otherwise, if this is a single-use weapon, prevent the player
			// from picking up  //CyberP: also check if ammo is full when picking up weapons

			else if (foundItem.IsA('Weapon'))
			{
				// If these fields are set as checked, then this is a
				// single use weapon, and if we already have one in our
				// inventory another cannot be picked up (puke).

				bCanPickup = ! ( (Weapon(foundItem).ReloadCount == 0) &&
				                 (Weapon(foundItem).PickupAmmoCount == 0) &&
				                 (Weapon(foundItem).AmmoName != None) );

				/*if (Weapon(foundItem).IsA('WeaponHideAGun'))
                {bCanPickup = True;  bSearchSlotNeeded = True;  }*/

				if (!bCanPickup)
					ClientMessage(Sprintf(CanCarryOnlyOne, foundItem.itemName));
				//DeusExWeapon(foundItem).SetMaxAmmo();                           //RSD: No longer needed
			  	if (Weapon(foundItem).AmmoType != none && Weapon(foundItem).AmmoType.AmmoAmount >= GetAdjustedMaxAmmo(Weapon(foundItem).AmmoType)) //RSD: removed DeusExWeapon(foundItem).MaxiAmmo for adjusted, changed DeusExWeapon to Weapon, added none check
				{
                    if (Weapon(foundItem).AmmoName != class'AmmoNone')   //RSD: So we don't get this for melee weapons
                    	ClientMessage(TooMuchAmmo);
					bCanPickup = False;
				}

			}
		}
	}

	if (bSlotSearchNeeded && bCanPickup)
	{
//	  log("MYCHK::DXPlayer::HIP::ADD TO::"@FrobTarget);
		if (FindInventorySlot(Inventory(FrobTarget), bSearchOnly) == False)
		{
//		 log("MYCHK::DXPlayer::HIP::ADD TO FAILED::"@foundItem);
			ClientMessage(Sprintf(InventoryFull, Inventory(FrobTarget).itemName));
			bCanPickup = False;
			ServerConditionalNotifyMsg( MPMSG_DropItem );
            if (frobTarget != None && frobTarget.IsA('DeusExWeapon'))
            {
               forEach AllActors(class'DeusExAmmo',foundAmmo)
                   if (foundAmmo.Owner != None && foundAmmo.Owner.IsA('DeusExPlayer') && foundAmmo.default.ItemName == DeusExWeapon(frobTarget).AmmoTag)
                   { assignedAmmo = foundAmmo; break; }

               if (assignedAmmo != None && assignedAmmo.AmmoAmount < GetAdjustedMaxAmmo(assignedAmmo) && DeusExWeapon(frobTarget).PickupAmmoCount != 0)
               {                                                                //RSD: Replaced assignedAmmo.MaxAmmo with adjusted
                   intj = GetAdjustedMaxAmmo(assignedAmmo) - assignedAmmo.AmmoAmount; //RSD: Replaced assignedAmmo.MaxAmmo with adjusted
                   assignedAmmo.AmmoAmount += DeusExWeapon(frobTarget).PickupAmmoCount;
                    if (assignedAmmo.AmmoAmount > GetAdjustedMaxAmmo(assignedAmmo)) //RSD: Replaced assignedAmmo.MaxAmmo with adjusted
                    {
                        assignedAmmo.AmmoAmount = GetAdjustedMaxAmmo(assignedAmmo); //RSD: Replaced assignedAmmo.MaxAmmo with adjusted
                        ClientMessage(assignedAmmo.PickupMessage $ " " $ assignedAmmo.ItemName $ " (" $ intj $ ")");
                        DeusExWeapon(frobTarget).PickupAmmoCount -= intj;
                    }
                    else
                    {
                        ClientMessage(assignedAmmo.PickupMessage $ " " $ assignedAmmo.ItemName $ " (" $ DeusExWeapon(frobTarget).PickupAmmoCount $ ")");
                        DeusExWeapon(frobTarget).PickupAmmoCount = 0;
                    }
               }
            }
		}
	}

	if (bCanPickup)
	{
		if (FrobTarget.IsA('WeaponShuriken'))
			WeaponShuriken(FrobTarget).ItemName = WeaponShuriken(FrobTarget).default.ItemName @ "(" $ WeaponShuriken(FrobTarget).PickupAmmoCount $ ")";

        //if (FrobTarget.IsA('WeaponLAW'))
		//	PlaySound(sound'WeaponPickup', SLOT_Interact, 0.5+FRand()*0.25, , 256, 0.95+FRand()*0.1);
		DoFrob(Self, inHand);
        /*if ( FrobTarget.IsA('DeusExWeapon') && bLeftClicked) //CyberP: for left click interaction //RSD: This is actually in FindInventorySlot() already, and the conflict made the player equip nothing
        {
        PutInHand(FoundItem);
        //bLeftClicked = False;
        }*/
		// This is bad. We need to reset the number so restocking works
		if ( Level.NetMode != NM_Standalone )
		{
			if ( FrobTarget.IsA('DeusExWeapon') && (DeusExWeapon(FrobTarget).PickupAmmoCount == 0) )
			{
				DeusExWeapon(FrobTarget).PickupAmmoCount = DeusExWeapon(FrobTarget).Default.mpPickupAmmoCount * 3;
			}
		}

		if (FrobTarget.IsA('WeaponShuriken'))
			WeaponShuriken(FrobTarget).ItemName = WeaponShuriken(FrobTarget).default.ItemName;
	}

	return bCanPickup;
}

// ----------------------------------------------------------------------
// GetNanoKeyDesc(Name)
// Returns the description for the NanoKey matching the specified name
// ----------------------------------------------------------------------

function String GetNanoKeyDesc(Name nanokey)
{
    local NanoKeyInfo key;
    key = KeyList;
    while (key != None)
    {
        if (key.KeyID == nanokey)
            return key.Description;
        key = key.NextKey;
    }
    return "";
}


// ----------------------------------------------------------------------
// CreateNanoKeyInfo()
// ----------------------------------------------------------------------

function NanoKeyInfo CreateNanoKeyInfo()
{
	local NanoKeyInfo newKey;

	newKey = new(Self) Class'NanoKeyInfo';

	return newKey;
}

// ----------------------------------------------------------------------
// PickupNanoKey()
//
// Picks up a NanoKey
//
// 1. Add KeyID to list of keys
// 2. Destroy NanoKey (since the user can't have it in his/her inventory)
// ----------------------------------------------------------------------

function PickupNanoKey(NanoKey newKey)
{
    if (KeyRing.HasKey(newKey.KeyID))
        ClientMessage(Sprintf(DuplicateNanoKey, newKey.Description));
    else
        ClientMessage(Sprintf(AddedNanoKey, newKey.Description));
	KeyRing.GiveKey(newKey.KeyID, newKey.Description);
	//DEUS_EX AMSD In multiplayer, propagate the key to the client if the server
	if ((Role == ROLE_Authority) && (Level.NetMode != NM_Standalone))
	{
	  KeyRing.GiveClientKey(newKey.KeyID, newKey.Description);
	}
}

// ----------------------------------------------------------------------
// RemoveNanoKey()
// ----------------------------------------------------------------------

exec function RemoveNanoKey(Name KeyToRemove)
{
	if (!bCheatsEnabled)
		return;

	KeyRing.RemoveKey(KeyToRemove);
	if ((Role == ROLE_Authority) && (Level.NetMode != NM_Standalone))
	{
	  KeyRing.RemoveClientKey(KeyToRemove);
	}
}

// ----------------------------------------------------------------------
// GiveNanoKey()
// ----------------------------------------------------------------------

exec function GiveNanoKey(Name newKeyID, String newDescription)
{
	if (!bCheatsEnabled)
		return;

	KeyRing.GiveKey(newKeyID, newDescription);
	//DEUS_EX AMSD In multiplayer, propagate the key to the client if the server
	if ((Role == ROLE_Authority) && (Level.NetMode != NM_Standalone))
	{
	  KeyRing.GiveClientKey(newKeyID, newDescription);
	}

}

// ----------------------------------------------------------------------
// DoFrob()
//
// Frob the target
// ----------------------------------------------------------------------

function DoFrob(Actor Frobber, Inventory frobWith)
{
	local DeusExRootWindow root;
	local Ammo ammo;
	local Inventory item;
	local Actor A;

    // if the object destroyed itself, get out   //CyberP: copy-pasted this from below
	if (FrobTarget == None)
		return;

	// make sure nothing is based on us if we're an inventory
	if (FrobTarget.IsA('Inventory'))
		foreach FrobTarget.BasedActors(class'Actor', A)
			A.SetBase(None);

//   log("MYCHK::DXPlayer::DoFrob:Frobber:"@Frobber@": frobWith:"@frobWith@": FrobTarget:"@FrobTarget);
	FrobTarget.Frob(Frobber, frobWith);

	// if the object destroyed itself, get out
	if (FrobTarget == None)
		return;

	// if the inventory item aborted it's own pickup, get out
	if (FrobTarget.IsA('Inventory') && (FrobTarget.Owner != Self))
		return;

	// alert NPCs that I'm messing with stuff
	if ((FrobTarget.bOwned) && PerkManager.GetPerkWithClass(class'DeusEx.PerkSleightOfHand').bPerkObtained == false)                         //RSD: Unless you have the Sleight of Hand perk
		AISendEvent('Futz', EAITYPE_Visual);

	// play an animation
	PlayPickupAnim(FrobTarget.Location);

	// set the base so the inventory follows us around correctly
	if (FrobTarget.IsA('Inventory'))
		FrobTarget.SetBase(Frobber);
}

// ----------------------------------------------------------------------
// PutInHand()
//
// put the object in the player's hand and draw it in front of the player
// ----------------------------------------------------------------------

exec function PutInHand(optional Inventory inv, optional bool bNoPrimary)
{
    local DeusExWeapon weap;

	if (RestrictInput(true))
		return;

	if (bGEPprojectileInflight) return;
	// can't put anything in hand if you're using a spy drone
	if ((inHand == None) && bSpyDroneActive && !bSpyDroneSet)                   //RSD: Allows the user to toggle between moving and controlling the drone
		return;

    //SARGE: Weapon Requirements Matter
    weap = DeusExWeapon(inv);
    if (weap != None && !weap.CanUseWeapon(self))
        return;

	// can't do anything if you're carrying a corpse
	if ((inHand != None) && inHand.IsA('POVCorpse'))
		return;

	if (inv != None)
	{
		// can't put ammo in hand
		if (inv.IsA('Ammo'))
			return;

		// Can't put an active charged item in hand  //cyberP: overruled for armor system
		//if ((inv.IsA('ChargedPickup')) && (ChargedPickup(inv).IsActive()))
		//	return;

	}

	if (CarriedDecoration != None)
		DropDecoration();
    bLeftClicked = False; //CyberP: fail safe
	if (assignedWeapon != none && assignedWeapon.IsA('Binoculars'))             //RSD: Make sure we aren't in binocs view
		if (Binoculars(assignedWeapon).bActive)
            assignedWeapon.GotoState('DeActivated');
    if (inHandPending != inv && inHand != inv)
        bBeltSkipNextPrimary = bNoPrimary;

    if (!bNoPrimary)
        bLastWasEmpty = inv == None;
    
    SetInHandPending(inv);
                
    //clientMessage("PutInHand called for : " $ inv $ ", bBeltSkipNextPrimary=" $ bBeltSkipNextPrimary);

    UpdateCrosshair();
}

// ----------------------------------------------------------------------
// UpdateBeltText()
// ----------------------------------------------------------------------

function UpdateBeltText(Inventory item)
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	// Update object belt text
	if ((item.bInObjectBelt) && (root != None))
		root.hud.belt.UpdateObjectText(item.beltPos);
}

// ----------------------------------------------------------------------
// UpdateAmmoBeltText()
//
// Loops through all the weapons in the player's inventory and updates
// the ammo for any that matches the ammo type passed in.
// ----------------------------------------------------------------------

function UpdateAmmoBeltText(Ammo ammo)
{
	local Inventory inv;

	inv = Inventory;
	while(inv != None)
	{
		if ((inv.IsA('DeusExWeapon')) && (DeusExWeapon(inv).AmmoType == ammo))
			UpdateBeltText(inv);

		inv = inv.Inventory;
	}
}

// ----------------------------------------------------------------------
// SetInHand()
// ----------------------------------------------------------------------

function SetInHand(Inventory newInHand)
{
	local DeusExRootWindow root;
    
    //Sarge: Call weapon putaway/draw functions and reset belt variables
    DoItemPutAwayFunction(inHand);
    DoItemDrawFunction(newInHand);
    NewWeaponSelected();

	inHand = newInHand;

	// Notify the hud
	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.hud.belt.UpdateInHand();

    UpdateCrosshair();
}

// ----------------------------------------------------------------------
// SetInHandPending()
// ----------------------------------------------------------------------

function SetInHandPending(Inventory newInHandPending)
{
	local DeusExRootWindow root;

	if ( newInHandPending == None )
		ClientInHandPending = None;

	inHandPending = newInHandPending;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.hud.belt.UpdateInHand();
    
    UpdateCrosshair();
}

// ----------------------------------------------------------------------
// SARGE: Shorthand function for Resetting Aim of current weapon
// ResetAim()
// ----------------------------------------------------------------------

function ResetAim()
{
    local DeusExWeapon weap;
    weap = DeusExWeapon(inHand);

    if (weap != None)
    {
        weap.standingTimer = 0;
        savedStandingTimer = 0;
    }

}

// ----------------------------------------------------------------------
// UpdateInHand()
//
// Called every frame
// Checks the state of inHandPending and deals with animation and crap
// 1. Check for pending item
// 2. Play down anim (and deactivate) for inHand and wait for it to finish
// 3. Assign inHandPending to inHand (and SelectedItem)
// 4. Play up anim for inHand
// ----------------------------------------------------------------------

function UpdateInHand()
{
	local bool bSwitch;
    local rotator rot;
    local DeusExRootWindow root;
	root = DeusExRootWindow(rootWindow);

	//sync up clientinhandpending.
	if (inHandPending != inHand)
		ClientInHandPending = inHandPending;

	//DEUS_EX AMSD  Don't let clients do this.
	if (Role < ROLE_Authority)
	  return;

	if (inHand != inHandPending)
	{
		bInHandTransition = True;
		bSwitch = False;
		if (inHand != None)
		{
			// turn it off if it is on
			if (inHand.bActive && !inHand.IsA('ChargedPickup')) //CyberP: armor system
				inHand.Activate();

			if (inHand.IsA('SkilledTool'))
			{
				if (inHand.IsInState('Idle'))
			{
					SkilledTool(inHand).PutDown();
			}
				else if (inHand.IsInState('Idle2'))
			{
					bSwitch = True;
			}
			}
			else if (inHand.IsA('DeusExWeapon'))
			{
				if (inHand.IsInState('Idle') || inHand.IsInState('Reload'))
				{
					if (InHandPending != none && InHandPending.IsA('DeusExWeapon') && //RSD: New Sidearm perk
                      DeusExWeapon(inHandPending).GoverningSkill == class'SkillWeaponPistol' &&
                      PerkManager.GetPerkWithClass(class'DeusEx.PerkSidearm').bPerkObtained == true)
                        savedStandingTimer = DeusExWeapon(InHand).standingTimer;
                    else
                        savedStandingTimer = 0.0;
                    DeusExWeapon(inHand).PutDown();
				}
				else if (inHand.IsInState('DownWeapon') && (Weapon == None))
					bSwitch = True;
			}
			else
			{
				bSwitch = True;
			}
		}
		else
		{
			savedStandingTimer = 0.0;                                           //RSD: Added
            bSwitch = True;
		}

		// OK to actually switch?
		if (bSwitch)
		{
			SetInHand(inHandPending);
			SelectedItem = inHandPending;
        
            if (inHandPending != None && !inHandPending.IsA('POVCorpse') && !bBeltSkipNextPrimary)
            {
                //clientMessage("Update Primary to: " $ selectedItem);
                primaryWeapon = selectedItem;
                bBeltSkipNextPrimary = false;
            }

			if (inHand != None)
			{
				if (inHand.IsA('SkilledTool'))
					SkilledTool(inHand).BringUp();
				else if (inHand.IsA('DeusExWeapon'))
					SwitchWeapon(DeusExWeapon(inHand).InventoryGroup);
                NewWeaponSelected();
			}
            // Notify the hud
            if (root != None)
                root.hud.belt.UpdateInHand();
		}
	}
	else
	{
		bInHandTransition = False;

		// Added this code because it's now possible to reselect an in-hand
		// item while we're putting it down, so we need to bring it back up...

		if (inHand != None)
		{
			// if we put the item away, bring it back up
			if (inHand.IsA('SkilledTool'))
			{
				if (inHand.IsInState('Idle2'))
					SkilledTool(inHand).BringUp();
			}
			else if (inHand.IsA('DeusExWeapon'))
			{
				if (inHand.IsInState('DownWeapon') && (Weapon == None))
					SwitchWeapon(DeusExWeapon(inHand).InventoryGroup);
			}


        // Notify the hud
        if (root != None)
            root.hud.belt.UpdateInHand();

		}

	}

	UpdateCarcassEvent();
}

// ----------------------------------------------------------------------
// UpdateCarcassEvent()
//
// Small hack for sending carcass events
// ----------------------------------------------------------------------

function UpdateCarcassEvent()
{
	if ((inHand != None) && (inHand.IsA('POVCorpse')))
	{
		AIStartEvent('WeaponDrawn', EAITYPE_Visual);//AIStartEvent('Carcass', EAITYPE_Visual);
	}
	else
	{
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		AIEndEvent('Carcass', EAITYPE_Visual);
	}
}

// ----------------------------------------------------------------------
// IsEmptyItemSlot()
//
// Returns True if the item will fit in this slot
// ----------------------------------------------------------------------

function Bool IsEmptyItemSlot( Inventory anItem, int col, int row )
{
	   local int slotsCol;
	   local int slotsRow;
	   local Bool bEmpty;
	   local Inventory inv;
	   local DeusExRootWindow root;
	   local PersonaScreenInventory winInv;

	   if ( anItem == None )
			   return False;

  //=== If cheats are off, then don't let us do the "overlap" trick
  root = DeusExRootWindow(rootWindow);
  winInv = PersonaScreenInventory(root.GetTopWindow());
  if(winInv == None || !winInv.bDragging)
  {
	   inv = Inventory;
	   while(inv != None)
	   {
			   SetInvSlots(inv, 1);
			   inv = inv.Inventory;
	   }
  }

	   // First make sure the item can fit horizontally
	   // and vertically
	   if (( col + anItem.invSlotsX > maxInvCols ) ||
			   ( row + anItem.invSlotsY > maxInvRows ))
					   return False;

  if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	 return True;

	   // Now check this and the needed surrounding slots
	   // to see if all the slots are empty

	   bEmpty = True;
	   for( slotsRow=0; slotsRow < anItem.invSlotsY; slotsRow++ )
	   {
			   for ( slotsCol=0; slotsCol < anItem.invSlotsX; slotsCol++ )
			   {
					   if ( invSlots[((slotsRow + row) * maxInvCols) + (slotsCol + col)] == 1 )
					   {
							   bEmpty = False;
							   break;
					   }
			   }

			   if ( !bEmpty )
					   break;
	   }

	   return bEmpty;
}

// ----------------------------------------------------------------------
// IsEmptyItemSlotXY()
//
// Returns True if the item will fit in this slot
// ----------------------------------------------------------------------

function Bool IsEmptyItemSlotXY( int invSlotsX, int invSlotsY, int col, int row )
{
	local int slotsCol;
	local int slotsRow;
	local Bool bEmpty;

	// First make sure the item can fit horizontally
	// and vertically
	if (( col + invSlotsX > maxInvCols ) ||
		( row + invSlotsY > maxInvRows ))
			return False;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	  return True;

	// Now check this and the needed surrounding slots
	// to see if all the slots are empty

	bEmpty = True;
	for( slotsRow=0; slotsRow < invSlotsY; slotsRow++ )
	{
		for ( slotsCol=0; slotsCol < invSlotsX; slotsCol++ )
		{
			if ( invSlots[((slotsRow + row) * maxInvCols) + (slotsCol + col)] == 1 )
			{
				bEmpty = False;
				break;
			}
		}

		if ( !bEmpty )
			break;
	}

	return bEmpty;
}

// ----------------------------------------------------------------------
// SetInvSlots()
// ----------------------------------------------------------------------

function SetInvSlots( Inventory anItem, int newValue )
{
	local int slotsCol;
	local int slotsRow;

	if ( anItem == None )
		return;

    if (anItem.IsA('DeusExWeapon'))                                             //RSD: Disgusting hack so we don't go out of array bounds due to inventory item rotation
    {
        DeusExWeapon(anItem).invSlotsXtravel = anItem.invSlotsX;
        DeusExWeapon(anItem).invSlotsYtravel = anItem.invSlotsY;
    }

	// Make sure this item is located in a valid position
	if (( anItem.invPosX != -1 ) && ( anItem.invPosY != -1 ))
	{
		// fill inventory slots
		for( slotsRow=0; slotsRow < anItem.invSlotsY; slotsRow++ )
			for ( slotsCol=0; slotsCol < anItem.invSlotsX; slotsCol++ )
				invSlots[((slotsRow + anItem.invPosY) * maxInvCols) + (slotsCol + anItem.invPosX)] = newValue;
	}
}

// ----------------------------------------------------------------------
// PlaceItemInSlot()
// ----------------------------------------------------------------------

function PlaceItemInSlot( Inventory anItem, int col, int row )
{
	// Save in the original Inventory item also
	anItem.invPosX = col;
	anItem.invPosY = row;

	SetInvSlots(anItem, 1);
}

// ----------------------------------------------------------------------
// RemoveItemFromSlot()
//
// Removes an inventory item from the inventory grid
// ----------------------------------------------------------------------

function RemoveItemFromSlot(Inventory anItem)
{
	if (anItem != None)
	{
		SetInvSlots(anItem, 0);
		anItem.invPosX = -1;
		anItem.invPosY = -1;
	}
}

// ----------------------------------------------------------------------
// ClearInventorySlots()
//
// Not for the foolhardy
// ----------------------------------------------------------------------

function ClearInventorySlots()
{
	local int slotIndex;

	for(slotIndex=0; slotIndex<arrayCount(invSlots); slotIndex++)
		invSlots[slotIndex] = 0;
}

// ----------------------------------------------------------------------
// FindInventorySlot()
//
// Searches through the inventory slot grid and attempts to find a
// valid location for the item passed in.  Returns True if the item
// is placed, otherwise returns False.
// ----------------------------------------------------------------------

function Bool FindInventorySlot(Inventory anItem, optional Bool bSearchOnly)
{
	local bool bPositionFound;
	local int row;
	local int col;
	local int newSlotX;
	local int newSlotY;
	local int beltpos;
	local ammo foundAmmo;
	local int invX, invY, invWidth, invHeight;                                  //RSD: For inv rotation check

	if (anItem == None)
		return False;

	// Special checks for objects that do not require phsyical inventory
	// in order to be picked up:
	//
	// - NanoKeys
	// - DataVaultImages
	// - Credits
	// - Ammo

	if ((anItem.IsA('DataVaultImage')) || (anItem.IsA('NanoKey')) || (anItem.IsA('Credits')) || (anItem.IsA('Ammo')))
		return True;

	bPositionFound = False;
	// DEUS_EX AMSD In multiplayer, due to propagation delays, the inventory refreshers in the
	// personascreeninventory can keep bouncing items back and forth.  So just return true and
	// place the item where it already was.
	if ((anItem.invPosX != -1) && (anItem.invPosY != -1) && (Level.NetMode != NM_Standalone) && (!bSearchOnly))
	{
	  SetInvSlots(anItem,1);
	  log("Trying to place item "$anItem$" when already placed at "$anItem.invPosX$", "$anItem.invPosY$".");
	  return True;
	}

	// Loop through all slots, looking for a fit
	for (row=0; row<maxInvRows; row++)
	{
		if (row + anItem.invSlotsY > maxInvRows)
			break;

		// Make sure the item can fit vertically
		for(col=0; col<maxInvCols; col++)
		{
			if (IsEmptyItemSlot(anItem, col, row ))
			{
				bPositionFound = True;
				break;
			}
		}

		if (bPositionFound)
			break;
	}

	if (!bPositionFound && anItem.invSlotsX != anItem.invSlotsY)                //RSD: Can now rotate inventory items, so check again rotated
	{
    invX = anItem.invSlotsX;
	invY = anItem.invSlotsY;
	invWidth = anItem.largeIconWidth;
	invHeight = anItem.largeIconHeight;
	anItem.invSlotsX = invY;
	anItem.invSlotsY = invX;
    if (anItem.isA('DeusExWeapon'))
	{
        DeusExWeapon(anItem).bRotated = !DeusExWeapon(anItem).bRotated;
		DeusExWeapon(anItem).UpdateLargeIcon();
	}
	anItem.largeIconWidth = invHeight;
	anItem.largeIconHeight = invWidth;
    for (row=0; row<maxInvRows; row++)
	{
		if (row + anItem.invSlotsY > maxInvRows)
			break;

		// Make sure the item can fit vertically
		for(col=0; col<maxInvCols; col++)
		{
			if (IsEmptyItemSlot(anItem, col, row ))
			{
				bPositionFound = True;
				break;
			}
		}

		if (bPositionFound)
			break;
	}
	if (!bPositionFound)
	{
	anItem.invSlotsX = invX;
	anItem.invSlotsY = invY;
	anItem.largeIconWidth = invWidth;
	anItem.largeIconHeight = invHeight;
	}
	}

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  bPositionFound = False;
	  beltpos = 0;
	  if (DeusExRootWindow(rootWindow) != None)
	  {
		 for (beltpos = 0; beltpos < ArrayCount(DeusExRootWindow(rootWindow).hud.belt.objects); beltpos++)
		 {
			if ( (DeusExRootWindow(rootWindow).hud.belt.objects[beltpos].item == None) && (anItem.TestMPBeltSpot(beltpos)) )
			{
			   bPositionFound = True;
			}
		 }
	  }
	  else
	  {
		 log("no belt to check");
	  }
	}

	if ((bPositionFound) && (!bSearchOnly))
	{
		PlaceItemInSlot(anItem, col, row);
		if (bLeftClicked && inHand == None)
		{
            //PutInHand(anItem); //CyberP: left click interaction //SARGE: This breaks stacked items
            SelectInventoryItem(anItem.Class.name);
            bLeftClicked = False;
		}
	}

	return bPositionFound;
}

// ----------------------------------------------------------------------
// FindInventorySlotXY()
//
// Searches for an available slot given the number of horizontal and
// vertical slots this item takes up.
// ----------------------------------------------------------------------

function Bool FindInventorySlotXY(int invSlotsX, int invSlotsY, out int newSlotX, out int newSlotY)
{
	local bool bPositionFound;
	local int row;
	local int col;

	bPositionFound = False;

	// Loop through all slots, looking for a fit
	for (row=0; row<maxInvRows; row++)
	{
		if (row + invSlotsY > maxInvRows)
			break;

		// Make sure the item can fit vertically
		for(col=0; col<maxInvCols; col++)
		{
			if (IsEmptyItemSlotXY(invSlotsX, invSlotsY, col, row))
			{
				newSlotX = col;
				newSlotY = row;

				bPositionFound = True;
				break;
			}
		}

		if (bPositionFound)
			break;
	}

	return bPositionFound;
}

// ----------------------------------------------------------------------
// DumpInventoryGrid()
//
// Dumps the inventory grid to the log file.  Useful for debugging only.
// ----------------------------------------------------------------------

exec function DumpInventoryGrid()
{
	local int slotsCol;
	local int slotsRow;
	local String gridRow;

	log("DumpInventoryGrid()");
	log("=============================================================");

	log("        1 2 3 4 5");
	log("-----------------");


	for( slotsRow=0; slotsRow < maxInvRows; slotsRow++ )
	{
		gridRow = "Row #" $ slotsRow $ ": ";

		for ( slotsCol=0; slotsCol < maxInvCols; slotsCol++ )
		{
			if ( invSlots[(slotsRow * maxInvCols) + slotsCol] == 1)
				gridRow = gridRow $ "X ";
			else
				gridRow = gridRow $ "  ";
		}

		log(gridRow);
	}
	log("=============================================================");
}

// ----------------------------------------------------------------------
// Belt functions following are just callbacks to handle multiplayer
// belt updating.  First arg is true if it's the invbelt, false if it's
// the hudbelt.
// ----------------------------------------------------------------------

function ClearPosition(int pos)
{
	if (DeusExRootWindow(rootWindow) != None)
	  DeusExRootWindow(rootWindow).hud.belt.ClearPosition(pos);
}

function ClearBelt()
{
	if (DeusExRootWindow(rootWindow) != None)
	  DeusExRootWindow(rootWindow).hud.belt.ClearBelt();
}

function RemoveObjectFromBelt(Inventory item)
{
	if (DeusExRootWindow(rootWindow) != None)
	  DeusExRootWindow(rootWindow).hud.belt.RemoveObjectFromBelt(item);
}

function MakeBeltObjectPlaceholder(Inventory item)
{
	if (DeusExRootWindow(rootWindow) != None)
	  DeusExRootWindow(rootWindow).hud.belt.RemoveObjectFromBelt(item,true);
}

function AddObjectToBelt(Inventory item, int pos, bool bOverride)
{
	if (DeusExRootWindow(rootWindow) != None)
	  DeusExRootWindow(rootWindow).hud.belt.AddObjectToBelt(item,pos,bOverride);
}

////Sarge: Functions for dealing with belt memory

// Set Placeholder
function SetPlaceholder(int objectNum, bool value, optional texture icon)
{
    beltInfos[objectNum].bPlaceholder = value;
    if (icon != None)
        beltInfos[objectNum].icon = icon;
}

function ClearPlaceholder(int objectNum)
{
    beltInfos[objectNum].bPlaceholder = false;
    beltInfos[objectNum].icon = None;
}

function bool GetPlaceholder(int objectNum)
{
    return beltInfos[objectNum].bPlaceholder;
}

function texture GetBeltIcon(int objectNum)
{
    return beltInfos[objectNum].icon;
}


// ----------------------------------------------------------------------
// GetWeaponOrAmmo()
//
// Checks to see if the player already has this weapon or ammo
// in his inventory.  Returns the item if found, or None if not.
// ----------------------------------------------------------------------

function Inventory GetWeaponOrAmmo(Inventory queryItem)
{
	// First check to see if this item is actually a weapon or ammo
	if ((Weapon(queryItem) != None) || (Ammo(queryItem) != None))
		return FindInventoryType(queryItem.Class);
	else
		return None;
}

///
/////////////////////////////////////////////////////////
//CheckBob() //CyberP: overrides code in playerPawn.
/////////////////////////////////////////////////////////
///

function CheckBob(float DeltaTime, float Speed2D, vector Y)
{
	local float OldBobTime;

    if (!bModdedHeadBob)
    {
       Super.CheckBob(DeltaTime, Speed2D, Y);
       return;
    }
	OldBobTime = BobTime;
	if ( Speed2D < 10 )
		BobTime += 0.2 * DeltaTime;
	else
		BobTime += DeltaTime * (0.5 + 0.8 * Speed2D/GroundSpeed);   //0.5 + 0.8
	WalkBob = Y * 0.35 * Bob * Speed2D * sin(6 * BobTime);
	ViewRotation.Roll = WalkBob.Y*60;
	AppliedBob = AppliedBob * (1 - FMin(1, 2 * deltatime -70));
	if ( LandBob > 0.01 )
	{
		AppliedBob += FMin(1, 2 * deltatime) * LandBob;
		LandBob *= (1 - 8*Deltatime);
	}
	if ( Speed2D < 160 )
		WalkBob.Z = AppliedBob/14 + Bob * (Speed2D) * cos(11 * BobTime); // AppliedBob + Bob * 30 * sin(12 * BobTime);   // take out the "breathe" effect - DEUS_EX CNN
	else
		WalkBob.Z = AppliedBob/14 + Bob * (Speed2D/2) * cos(11 * BobTime);

}


// ----------------------------------------------------------------------
// Summon()
//
// automatically prepend DeusEx. to the summoned class
// ----------------------------------------------------------------------

exec function Summon(string ClassName)
{
	if (!bCheatsEnabled)
		return;

	if(!bAdmin && (Level.Netmode != NM_Standalone))
		return;
	if(instr(ClassName, ".") == -1)
		ClassName = "DeusEx." $ ClassName;
	Super.Summon(ClassName);
}


// ----------------------------------------------------------------------
// SpawnMass()
//
// Spawns a bunch of actors around the player
// ----------------------------------------------------------------------

exec function SpawnMass(Name ClassName, optional int TotalCount)
{
	local actor        spawnee;
	local vector       spawnPos;
	local vector       center;
	local rotator      direction;
	local int          maxTries;
	local int          count;
	local int          numTries;
	local float        maxRange;
	local float        range;
	local float        angle;
	local class<Actor> spawnClass;
	local string		holdName;

	if (!bCheatsEnabled)
		return;

	if (!bAdmin && (Level.Netmode != NM_Standalone))
		return;

	if (instr(ClassName, ".") == -1)
		holdName = "DeusEx." $ ClassName;
	else
		holdName = "" $ ClassName;  // barf

	spawnClass = class<actor>(DynamicLoadObject(holdName, class'Class'));
	if (spawnClass == None)
	{
		ClientMessage("Illegal actor name "$GetItemName(String(ClassName)));
		return;
	}

	if (totalCount <= 0)
		totalCount = 10;
	if (totalCount > 250)
		totalCount = 250;
	maxTries = totalCount*2;
	count = 0;
	numTries = 0;
	maxRange = sqrt(totalCount/3.1416)*4*SpawnClass.Default.CollisionRadius;

	direction = ViewRotation;
	direction.pitch = 0;
	direction.roll  = 0;
	center = Location + Vector(direction)*(maxRange+SpawnClass.Default.CollisionRadius+CollisionRadius+20);
	while ((count < totalCount) && (numTries < maxTries))
	{
		angle = FRand()*3.14159265359*2;
		range = sqrt(FRand())*maxRange;
		spawnPos.X = sin(angle)*range;
		spawnPos.Y = cos(angle)*range;
		spawnPos.Z = 0;
		spawnee = spawn(SpawnClass,,,center+spawnPos, Rotation);
		if (spawnee != None)
			count++;
		numTries++;
	}

	ClientMessage(count$" actor(s) spawned");

}

// ----------------------------------------------------------------------
// ToggleWalk()
// ----------------------------------------------------------------------

exec function ToggleWalk()
{
	if (RestrictInput())
		return;

	bToggleWalk = !bToggleWalk;
}

// ----------------------------------------------------------------------
// ReloadWeapon()
//
// reloads the currently selected weapon
// ----------------------------------------------------------------------

exec function ReloadWeapon()
{
	local DeusExWeapon W;
    local bool full, hasAmmo;

	if (RestrictInput())
		return;
//GMDX: bumped to restricted
//	if (bGEPprojectileInflight) return;// cant reload during projectil flight

	W = DeusExWeapon(Weapon);  //CyberP: cannot reload when ammo in mag but none in reserves.
                                //Sarge: Additionally fix reloading when full

    if (W != None)
    {
        full = W.AmmoLeftInClip() >= W.ReloadCount;
        hasAmmo = W.AmmoType.AmmoAmount - W.ClipCount > 0;
        if (W != None && ((!full && hasAmmo) || bTrickReloading || bHardCoreMode))
            W.ReloadAmmo();

    }
    UpdateCrosshair();
}

// ----------------------------------------------------------------------
// ToggleScope()
//
// turns the scope on or off for the current weapon
// ----------------------------------------------------------------------

exec function ToggleScope()
{
	local DeusExWeapon W;

	//log("ToggleScope "@IsInState('Interpolating')@" "@IsInState('Dying')@" "@IsInState('Paralyzed'));
	if (RestrictInput())
		return;

	W = DeusExWeapon(Weapon);
	if (W != None)
	{
	  if (W.IsInState('Idle') || (W.bZoomed == False && W.AnimSequence == 'Shoot') || (W.bZoomed == True && RecoilTime==0)) //CyberP: far less restrictive
	  {
	    if (W.AnimSequence == 'Idle1' || W.AnimSequence == 'Idle2' || W.AnimSequence == 'Idle3')
        W.PlayAnim('Still');
		
	    if (!W.bZoomed)
            W.activateAn = true;
        else
            W.ScopeToggle();
        
        if (W.bZoomed&&W.IsA('WeaponGEPGun'))
            SetLaser(false);
	  }
	}

    UpdateCrosshair();
}


//GMDX: tester for rocket tracking
//copied part from PutCarriedDecorationInHand()
//major cheat :P


//copied inpart from laseremitter
function bool CalcGEPLaserTrace(rotator newCamera,float newDistance,out vector HitLocOut)
{
	local vector StartTrace, EndTrace, HitLoc, HitNormal, Reflection;
	local actor target;
	local int i, texFlags;
	local name texName, texGroup;
	local bool HitObject;

	StartTrace = Location;
	StartTrace.Z += BaseEyeHeight;
	EndTrace = StartTrace + Vector(newCamera)*newDistance;
	HitObject = false;

	// trace the path of the reflected beam and draw points at each hit

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, HitLoc, HitNormal, EndTrace, StartTrace)
	{
  		if ((target.DrawType == DT_None) || target.bHidden)
		{
			// do nothing - keep on tracing
		}
		else if ((target == Level) || target.IsA('Mover'))
		{
			HitObject=true;
			HitLocOut=HitLoc;
			break;
		}
		else
		{
			HitObject=true;
			HitLocOut=HitLoc;
			break;
		}
	}
	return HitObject;
}

function bool UpdateRocketTarget(rotator newCamera,float newDistance,optional bool bForcedUpdate)
{
	local vector lookDir, upDir,accVec;
	local Vector Start, X, Y, Z;

	if (RocketTarget==none) return false;
	if (bForcedUpdate||((InHand!=none)&&(InHand.IsA('WeaponGEPGun'))&&(WeaponGEPGun(InHand).bLasing)))//  ||(WeaponGEPGun(InHand).bZoomed))))
	{
		if (CalcGEPLaserTrace(newCamera,newDistance,lookDir))
			return RocketTarget.SetLocation(lookDir);

		upDir = Location;
		upDir.Z += BaseEyeHeight;
		lookDir = Vector(newCamera)*newDistance;
		return RocketTarget.SetLocation(upDir + lookDir);
	}
	return false;
}


function SetRocketWireControl()
{
	if (RocketTarget!=none)
	{
		RocketTarget.SetPhysics(PHYS_None);
		RocketTarget.SetBase(self);

		if (!UpdateRocketTarget(Rotation,RocketTargetMaxDistance,true))
			log("Error: Could not base initialize Rocket Target!");
	} else
	   log("Error: Could not spawn Rocket Target!");
}

/*
function SetRocketPOVControl()
{
	if ((RocketTarget!=none)&&(InHand.IsA('WeaponGEPGun')))
	{
		RocketTarget.SetPhysics(PHYS_None);

		if (!bGEPprojectileInflight)
			RocketTarget.SetBase(InHand);
//			else
//				RocketTarget.SetBase(aGEPProjectile);

		if (UpdateRocketTarget(InHand.Rotation,0,true))
		{
			log("GEP Loc="@Location@" : Its="@RocketTarget.Location);
		} else
			log("Error: Could not base initialize Rocket Target to GEP!");
	} else
	   log("Error: Could not spawn Rocket Target!");
}
*/
/*
function SetRocketPOV(bool bSetToGEP)
{
	if (bSetToGEP)
	{
		SetRocketPOVControl();
	} else
	{
		SetRocketWireControl();
	}
}
*/
function UpdateTrackingSteering(float deltaT)
{
	local float smx,smy;
	local float vlen;

//Handle mouse inputs

	smX=SmoothMouseX*0.01;
	if (bInvertMouse)
		smY=-SmoothMouseY*0.01;
	else
	    smY=SmoothMouseY*0.01;
	if ((smX<0)&&(GEPSteeringX>smX))
		GEPsteeringX=smX;
		else
		if ((smX>0)&&(GEPSteeringX<smX))
			GEPsteeringX=smX;
//if (Abs(GEPsteeringX)<0.1) GEPsteeringX=0.0;

	if ((smY<0)&&(GEPSteeringY>smY))
		GEPsteeringY=smY;
		else
		if ((smY>0)&&(GEPSteeringY<smY))
			GEPsteeringY=smY;

	GEPsteeringX *=(0.7+(0.3-Fmax(0.3*deltaT*3.0,0.3)));
	GEPsteeringY *=(0.7+(0.3-Fmax(0.3*deltaT*3.0,0.3)));

	/*scaleGEP.X=GEPsteeringX;
	scaleGEP.Y=GEPsteeringY;
	vlen=Vsize(scaleGEP)*(0.8+(0.2-0.2*deltaT));

	GEPsteeringX = GEPsteeringX*3.0*deltaT; //drain to zero
	GEPsteeringY = GEPsteeringY*3.0*deltaT; //drain to zero
	*/
//            if (Abs(GEPsteeringY)<0.1) GEPsteeringY=0.0;

}

//GMDX: end Rocket Target system


// check to see if the player can lift a certain decoration taking
// into account his muscle augs
function bool CanBeLifted(Decoration deco)
{
	local int augLevel, augMult;
	local float maxLift;
//gmdx modded so aug has effect
	maxLift = 50;
	if (AugmentationSystem != None)
	{
		augLevel = AugmentationSystem.GetClassLevel(class'AugMuscle');

        if (Energy < 1)
            augLevel = -1;               //SARGE: If out of energy, pretend we don't have the aug at all

		augMult = 1;
		if (augLevel >= 1)
			augMult = augLevel+1;
		maxLift *= augMult;
		if (augLevel >= 2)
		    maxLift = 350;
		else if (augLevel >= 0 && maxLift < 100)
            maxLift = 100;
		if (deco.IsA('NewAshtray'))
		{
		   if (NewAshtray(deco).bSmoker)
		   {
		      if (NewAshtray(deco).smokeGen != None)
		      {
              NewAshtray(deco).smokeGen.DelayedDestroy();
              //return True;
              }
           }
        }
        if (deco.IsA('HKIncenseBurner'))
		{
		    if (HKIncenseBurner(deco).smokeGen != None)
		    {
              HKIncenseBurner(deco).smokeGen.DelayedDestroy();
              HKIncenseBurner(deco).AmbientSound = None;
              //return True;
            }
        }
	}

    //Always allow left-grabbing if we have bLeftGrab set, no matter what
    if (deco.isA('DeusExDecoration') && DeusExDecoration(deco).bLeftGrab)
    {
    }
    else if (!deco.bPushable || (deco.Mass > maxLift) || (deco.StandingCount > 1))
	{
		if (deco.bPushable)
			ClientMessage(TooHeavyToLift);
		else
			ClientMessage(CannotLift);

		return False;
	}
	if (deco.StandingCount == 1)
	{
	  if (deco.IsA('DeusExDecoration'))
      {
         if (DeusExDecoration(deco).standingActorGlobal != None && (DeusExDecoration(deco).standingActorGlobal.Mass > 35 || DeusExDecoration(deco).standingActorGlobal.IsA('Pawn')))
         {
             ClientMessage(TooHeavyToLift);
             return false;
         }
         else
         {
            deco.SetBase(None);
            if (DeusExDecoration(deco).standingActorGlobal != None)
            {
                if (DeusExDecoration(deco).standingActorGlobal.Owner != None && DeusExDecoration(deco).standingActorGlobal.Owner.IsA('DeusExPlayer'))
                {
                }
                else
                {
                DeusExDecoration(deco).standingActorGlobal.SetPhysics(PHYS_Falling);
                DeusExDecoration(deco).standingActorGlobal.Velocity.Z = -10;
                }
            }
         }
      }
	}

	return True;
}

// ----------------------------------------------------------------------
// GrabDecoration()
//
// This overrides GrabDecoration() in Pawn.uc
// lets the strength augmentation affect how much the player can lift
// ----------------------------------------------------------------------

function GrabDecoration()
{
	// can't grab decorations while leaning
	if (IsLeaning())
		return;

//   log("GrabDecoration::"@FrobTarget@FrobTarget.Owner@FrobTarget.Base);

	if ((FrobTarget!=none)&&(FrobTarget.Base!=none)&&(FrobTarget.Base.IsA('GMDXProjectileWrap')))
	{
	  FrobTarget.Base.Destroy();
	  return;//GMDX stop catching of mythical deco that has no collide settings! will expand to allow catch maybe!
	}
	// can't grab decorations while holding something else
	if (inHand != None)
	{
	    if (carriedDecoration != None || inHand.IsA('POVcorpse'))
        {ClientMessage(HandsFull); return;}
        else if (!bAutoHolster)
        {ClientMessage(HandsFull); return;}
        else
            DoAutoHolster();
	}

	if (carriedDecoration == None && inHand == None)
		if ((FrobTarget != None) && FrobTarget.IsA('Decoration') && Weapon == None)
			if (CanBeLifted(Decoration(FrobTarget)))
			{
				CarriedDecoration = Decoration(FrobTarget);
				PutCarriedDecorationInHand();

			}
}

// ----------------------------------------------------------------------
// PutCarriedDecorationInHand()
// ----------------------------------------------------------------------

function PutCarriedDecorationInHand(optional bool bNoSoundEffect)
{
	local vector lookDir, upDir;
    local float shakeTime, shakeVert, shakeRoll;

	if (CarriedDecoration != None)
	{
		lookDir = Vector(Rotation);
		lookDir.Z = 0;
		upDir = vect(0,0,0);
		if (CarriedDecoration.CollisionHeight < 8.000000)
		     upDir.Z = CollisionHeight / 1.75;      //CyberP: a bit higher for small objects.
		else
		     upDir.Z = CollisionHeight / 2.5;		// put it up near eye level  //CyberP: chest level. was 2
		CarriedDecoration.SetPhysics(PHYS_Falling);
        //CarriedDecoration.SetCollisionSize(CarriedDecoration.CollisionRadius*0.5,CarriedDecoration.CollisionHeight*0.5);
		if ( CarriedDecoration.SetLocation(Location + upDir + (0.25 * CollisionRadius + CarriedDecoration.CollisionRadius) * lookDir) )  //CyberP: was 0.5
		{
		    if (!bNoSoundEffect)
		    {
		    if (CarriedDecoration.Mass > 40)   //CyberP: pickup sounds
				{
                    if (FRand() < 0.5)
                    PlaySound(Sound'objpickup3',SLOT_None);
                    else
                    PlaySound(Sound'genericlargeequip',SLOT_None);
                }
				else if (FRand() < 0.33)
				PlaySound(Sound'genericlargeequip',SLOT_None);
				else if (FRand() < 0.66)
				PlaySound(Sound'genericsmallequip',SLOT_None);
				else
				PlaySound(Sound'genericsmallunequip',SLOT_None);
            }

			CarriedDecoration.SetPhysics(PHYS_None);
			CarriedDecoration.SetBase(self);
			CarriedDecoration.SetCollision(False, False, False);
			CarriedDecoration.bCollideWorld = False;
            //CarriedDecoration.SetCollisionSize(CarriedDecoration.CollisionRadius*2,CarriedDecoration.CollisionHeight*2);
			// make it translucent
			if ((!bNoTranslucency && !bHardcoreMode) || AugmentationSystem.GetAugLevelValue(class'AugCloak') != -1.0)
			{
			CarriedDecoGlow = CarriedDecoration.ScaleGlow;
			CarriedDecoration.Style = STY_Translucent;
			CarriedDecoration.ScaleGlow = 0.2; //CyberP: was 1.0
			CarriedDecoration.bUnlit = True;
			}

			FrobTarget = None;
		}
		else
		{
			ClientMessage(NoRoomToLift);
			//CarriedDecoration.SetCollisionSize(CarriedDecoration.CollisionRadius*2,CarriedDecoration.CollisionHeight*2);
			CarriedDecoration = None;
		}
	}
}

function ThrowDecoration(Decoration WrapDeco)
{
	local GMDXProjectileWrap PW;
	if (WrapDeco==none) return;

	PW=Spawn(class'GMDXProjectileWrap');
	if(PW!=none)
	{
	  //log("CARRIED DECO, spawn prj");
//      if (WrapDeco.IsA('Carcass'))
		 PW.InitWrapDecoration(WrapDeco,self);//,false);
		 swimTimer -= 1;
         shakeView(0.2,224,0);
         if (WrapDeco.IsA('DeusExDecoration'))
            DeusExDecoration(WrapDeco).bWrapped = True;
		 if (swimTimer < 0)
		   swimTimer = 0;
//         else
//           PW.InitWrapDecoration(WrapDeco,self);//,true);
	}
}
// ----------------------------------------------------------------------
// DropDecoration()
//
// This overrides DropDecoration() in Pawn.uc
// lets the player throw a decoration instead of just dropping it
// ----------------------------------------------------------------------

function DropDecoration()
{
	local Vector X, Y, Z, dropVect, origLoc, HitLocation, HitNormal, extent;
	local float velscale, size, mult;
	local bool bSuccess;
	local Actor hitActor;

	bSuccess = False;

	if (CarriedDecoration != None)
	{
	    PutCarriedDecorationInHand(true);
	    if (CarriedDecoration == None)
	        return;
		origLoc = CarriedDecoration.Location;
		GetAxes(Rotation, X, Y, Z);

		// if we are highlighting something, try to place the object on the target
		if ((FrobTarget != None) && !FrobTarget.IsA('Pawn') && !FrobTarget.IsA('DeusExWeapon') && !FrobTarget.IsA('Pickup') &&
           !FrobTarget.IsA('Decoration'))
		{
			CarriedDecoration.Velocity = vect(0,0,0);

			// try to drop the object about one foot above the target
			size = FrobTarget.CollisionRadius - CarriedDecoration.CollisionRadius * 2;
			dropVect.X = size/2 - FRand() * size;
			dropVect.Y = size/2 - FRand() * size;
			dropVect.Z = FrobTarget.CollisionHeight + CarriedDecoration.CollisionHeight + 16;
			dropVect += FrobTarget.Location;
		}
		else
		{
			// throw velocity is based on augmentation
			if (AugmentationSystem != None)
			{
				mult = 1.3;//AugmentationSystem.GetAugLevelValue(class'AugMuscle'); //CyberP: we don't need this anymore
				if (mult == -1.0)
					mult = 1.0;
			}

			//if (IsLeaning())
			//	CarriedDecoration.Velocity = vect(0,0,0);
			//else
				CarriedDecoration.Velocity = Vector(ViewRotation) * mult * 550 + vect(0,0,180) + 50 * VRand();

			// scale it based on the mass
			velscale = FClamp(CarriedDecoration.Mass / 20.0, 1.0, 40.0);

			CarriedDecoration.Velocity /= velscale;
			if (Velocity.X != 0 && Velocity.Y != 0)
			   dropVect = Location + (CarriedDecoration.CollisionRadius + CollisionRadius + 30) * X;
			else
			   dropVect = Location + (CarriedDecoration.CollisionRadius + CollisionRadius + 3) * X;
            dropVect.Z += BaseEyeHeight;
			//if (FRand() < 0.3)
			  // PlaySound(Sound'MaleLand',SLOT_None);
          if (CarriedDecoration.Mass <= 40 && CarriedDecoration.CollisionHeight < 23.000000 &&
             CarriedDecoration.CollisionRadius <= 22.500000)
			{
			CarriedDecoration.bFixedRotationDir = True;
            CarriedDecoration.RotationRate.Pitch = (32768 - Rand(65536)) * 1.5;
            if (FRand() < 0.2)
	        CarriedDecoration.RotationRate.Yaw = (32768 - Rand(65536)) * 1.0;
	        else if (FRand() < 0.7)
	        {
	        }
	        else
	        CarriedDecoration.RotationRate.Yaw -= (32768 - Rand(65536)) * 1.0;
	        }
		}

		// is anything blocking the drop point? (like thin doors)
		if (FastTrace(dropVect))
		{
			CarriedDecoration.SetCollision(True, True, True);
			CarriedDecoration.bCollideWorld = True;

			// check to see if there's space there
			extent.X = CarriedDecoration.CollisionRadius;
			extent.Y = CarriedDecoration.CollisionRadius;
			extent.Z = 1;
			hitActor = Trace(HitLocation, HitNormal, dropVect, CarriedDecoration.Location, True, extent);

			if ((hitActor == None) && CarriedDecoration.SetLocation(dropVect))
				bSuccess = True;
			else
			{
				CarriedDecoration.SetCollision(False, False, False);
				CarriedDecoration.bCollideWorld = False;
				CarriedDecoration.SetPhysics(PHYS_None);
			}
		}

		// if we can drop it here, then drop it
		if (bSuccess)
		{
			CarriedDecoration.bWasCarried = True;
			CarriedDecoration.SetBase(None);
			CarriedDecoration.SetPhysics(PHYS_Falling);
			CarriedDecoration.Instigator = Self;
			CarriedDecoration.SetCollision(True, True, True);
			CarriedDecoration.bCollideWorld = True;
			AIEndEvent('WeaponDrawn', EAITYPE_Visual);
            PlayAnim('Attack',,0.1);
			// turn off translucency
			CarriedDecoration.Style = CarriedDecoration.Default.Style;
			CarriedDecoration.bUnlit = CarriedDecoration.Default.bUnlit;
			if ((!bNoTranslucency && !bHardcoreMode) && CarriedDecoration.IsA('DeusExDecoration'))
				DeusExDecoration(CarriedDecoration).ScaleGlow = CarriedDecoGlow;

		 if (bThrowDecoration)
			ThrowDecoration(CarriedDecoration);

			CarriedDecoration = None;
		}
		else
		{
			// otherwise, don't drop it and display a message
			CarriedDecoration.SetLocation(origLoc);
			ClientMessage(CannotDropHere);
		}
	}
	bThrowDecoration=false;
}

// ----------------------------------------------------------------------
// DropItem()
//
// throws an item where you are currently looking
// or places it on your currently highlighted object
// if None is passed in, it drops what's inHand
// ----------------------------------------------------------------------

exec function bool DropItem(optional Inventory inv, optional bool bDrop)
{
	local Inventory item, previtem;
	local Inventory previousItemInHand;
	local Vector X, Y, Z, dropVect;
	local float size, mult;
	local DeusExCarcass carc;
	local class<DeusExCarcass> carcClass;
	local bool bDropped;
	local bool bRemovedFromSlots;
	local int  itemPosX, itemPosY, tex, i, amm;
    local Ammo ammoType;

	bDropped = True;

	if (RestrictInput(true))
		return False;

	if (inv == None)
	{
		previousItemInHand = inHand;
		item = inHand;
	}
	else
	{
		item = inv;
	}
	if ((item!=none)&&(!item.IsA('POVcorpse'))) bThrowDecoration=false;
	if (item != None)
	{
		GetAxes(Rotation, X, Y, Z);
		dropVect = Location + (CollisionRadius + 2*item.CollisionRadius) * X;
		dropVect.Z += BaseEyeHeight;

		// check to see if we're blocked by terrain
		if (!FastTrace(dropVect))
		{
			ClientMessage(CannotDropHere);
			return False;
		}

		// don't drop it if it's in a strange state
		if (item.IsA('DeusExWeapon'))
		{
			if (!DeusExWeapon(item).IsInState('Idle') && !DeusExWeapon(item).IsInState('Idle2') &&
				!DeusExWeapon(item).IsInState('DownWeapon') && !DeusExWeapon(item).IsInState('Reload'))
			{
				return False;
			}
			else		// make sure the scope/laser are turned off
			{
				DeusExWeapon(item).ScopeOff();
				DeusExWeapon(item).LaserOff(false);
				if (DeusExWeapon(item).bIsCloaked)
				{
				   DeusExWeapon(item).HideCamo();
				   DeusExWeapon(item).AmbientGlow=DeusExWeapon(item).default.AmbientGlow;
				}
                if (DeusExWeapon(item) == assignedWeapon)
				    assignedWeapon = None;
			}
		}

		// Don't allow active ChargedPickups to be dropped
		if ((item.IsA('ChargedPickup')) && (ChargedPickup(item).IsActive()))
		{
			item.GotoState('DeActivated');                                      //RSD: Deactivates the top in the stack when dropped
            //return False;
		}

		// don't let us throw away the nanokeyring
		if (item.IsA('NanoKeyRing'))
		{
			return False;
		}

		// take it out of our hand
		if (item == inHand)
			PutInHand(None);

		// handle throwing pickups that stack
		if (item.IsA('DeusExPickup'))
		{
			// turn it off if it is on
			if (DeusExPickup(item).bActive)
				DeusExPickup(item).Activate();

			tex = deusExPickUp(item).textureset; //our current tex

			DeusExPickup(item).NumCopies--;

			UpdateBeltText(item);

			if (DeusExPickup(item).NumCopies > 0)
			{
				// put it back in our hand, but only if it was in our
				// hand originally!!!
				if (previousItemInHand == item)
					PutInHand(previousItemInHand);

				previtem = item;

				item = Spawn(item.Class, Owner);
				if (item.IsA('ChargedPickup'))                                  //RSD: Simulates dropping the top ChargedPickup from the stack
				{
					item.Charge = previtem.Charge;
					previtem.Charge = previtem.default.Charge;
				}

				if(item != none)
				{
					if(deusExPickUp(item).bhasMultipleSkins)
					{
						deusExPickUp(item).textureSet = tex;
						deusExPickUp(item).SetSkin();
						deusExPickUp(previtem).UpdateCurrentSkin();
					}
				}
			}
			else
			{
				if(deusExPickUp(item).bhasMultipleSkins)
				{
					deusExPickUp(item).textureSet = tex;
					deusExPickUp(item).SetSkin();
				}

				// Keep track of this so we can undo it
				// if necessary
				bRemovedFromSlots = True;
				itemPosX = item.invPosX;
				itemPosY = item.invPosY;

				// Remove it from the inventory slot grid
				RemoveItemFromSlot(item);
                if (!bBeltAutofill)
                    MakeBeltObjectPlaceholder(item); //SARGE: Disabled because keeping dropped items as placeholders feels weird //Actually, re-enabled if autofill is false, since we obviously care about it
                else
                    RemoveObjectFromBelt(item);

				// make sure we have one copy to throw!
				DeusExPickup(item).NumCopies = 1;

				if (DeusExPickup(item) == assignedWeapon)                       //RSD: Reset our assigned weapon
				{
					AssignSecondary(None);
				}
			}
		}
        //If it's a disposable weapon, throw away only one, and deduct ammo
        else if (DeusExWeapon(item).bDisposableWeapon && DeusExWeapon(item).ammoName != none)
        {
            AmmoType = Ammo(FindInventoryType(Weapon(item).AmmoName));
            amm = ammoType.ammoAmount;
		    if (amm > 1)
            {
                // put it back in our hand, but only if it was in our
                // hand originally!!!
                if (previousItemInHand == item)
                    PutInHand(previousItemInHand);

                item = Spawn(item.Class, Owner);
            }
            else
            {
                // Keep track of this so we can undo it
				// if necessary
				bRemovedFromSlots = True;
				itemPosX = item.invPosX;
				itemPosY = item.invPosY;

				// Remove it from the inventory slot grid
				RemoveItemFromSlot(item);
                if (!bBeltAutofill)
                    MakeBeltObjectPlaceholder(item); //SARGE: Disabled because keeping dropped items as placeholders feels weird //Actually, re-enabled if autofill is false, since we obviously care about it
                else
                    RemoveObjectFromBelt(item);
				
                if (DeusExWeapon(item) == assignedWeapon)                       //RSD: Reset our assigned weapon
					AssignSecondary(None);
            }
            ammoType.ammoAmount -= 1;
            UpdateAmmoBeltText(AmmoType);
        }
		else
		{
			// Keep track of this so we can undo it
			// if necessary
			bRemovedFromSlots = True;
			itemPosX = item.invPosX;
			itemPosY = item.invPosY;

			// Remove it from the inventory slot grid
			RemoveItemFromSlot(item);
            if (!bBeltAutofill && bBeltMemory)
                MakeBeltObjectPlaceholder(item); //SARGE: Disabled because keeping dropped items as placeholders feels weird //Actually, re-enabled if autofill is false, since we obviously care about it
            else
                RemoveObjectFromBelt(item);
		}

		// if we are highlighting something, try to place the object on the target //CyberP: more lenience when dropping
		if ((FrobTarget != None) && !item.IsA('POVCorpse') && !FrobTarget.IsA('Pawn') && !FrobTarget.IsA('Pickup')
             && !FrobTarget.IsA('DeusExWeapon') && !FrobTarget.IsA('Decoration'))
		{
			item.Velocity = vect(0,0,0);

			// play the correct anim
			PlayPickupAnim(FrobTarget.Location);

			// try to drop the object about one foot above the target
			size = FrobTarget.CollisionRadius - item.CollisionRadius * 2;
			dropVect.X = size/2 - FRand() * size;
			dropVect.Y = size/2 - FRand() * size;
			dropVect.Z = FrobTarget.CollisionHeight + item.CollisionHeight + 16;
			if (FastTrace(dropVect))
			{
				item.DropFrom(FrobTarget.Location + dropVect);
			}
			else
			{
				ClientMessage(CannotDropHere);
				bDropped = False;
			}
		}
		else
		{
			// throw velocity is based on augmentation
			if (AugmentationSystem != None)
			{
				mult = AugmentationSystem.GetAugLevelValue(class'AugMuscle');
				if (mult == -1.0)
					mult = 1.0;                                                 //RSD: Was 0.7 in GMDX, back to 1.0 from vanilla
			}
			//mult = 1.0;                                                         //RSD: Screw it, no more having fun

			if (bDrop)
			{
				item.Velocity = VRand() * 60; //CyberP: was 30

				// play the correct anim
				PlayPickupAnim(item.Location);
			}
			else
			{
			    if (item.Mass > 20)
			       mult -= 0.15;
				//item.Velocity = Vector(ViewRotation) * (mult*1.5) * 600 + vect(0,0,100); //CyberP: z vect was 240
                item.Velocity = 0.5*Velocity + Vector(ViewRotation) * 1.5*mult * 300 + vect(0,0,150); //RSD: Formula closer to vanilla, except 1.5x power mult, 150z instead of *220z, and it inherits half the player's velocity

				// play a throw anim
				PlayAnim('Attack',,0.1);
			}

			GetAxes(ViewRotation, X, Y, Z);
			dropVect = Location + 0.8 * CollisionRadius * X;
			dropVect.Z += BaseEyeHeight;

			// if we are a corpse, spawn the actual carcass
			if (item.IsA('POVCorpse'))
			{
				if (POVCorpse(item).carcClassString != "")
				{
					carcClass = class<DeusExCarcass>(DynamicLoadObject(POVCorpse(item).carcClassString, class'Class'));
					if (carcClass != None)
					{
						carc = Spawn(carcClass);
						if (carc != None)
						{
						    if (POVCorpse(item).bHasSkins)
						    {
						        carc.passedSkins = true;
						        for(i=0;i<arrayCount(POVCorpse(item).pMultitex);i++)
						        {
						            carc.MultiSkins[i] = POVCorpse(item).pMultitex[i];
                                }
						    }
							carc.Mesh = carc.Mesh2;
							carc.KillerAlliance = POVCorpse(item).KillerAlliance;
							carc.KillerBindName = POVCorpse(item).KillerBindName;
							carc.Alliance = POVCorpse(item).Alliance;
							carc.bNotDead = POVCorpse(item).bNotDead;
							carc.Tag = POVCorpse(item).CarcassTag;  //CyberP: tag
							carc.bEmitCarcass = POVCorpse(item).bEmitCarcass;
							carc.CumulativeDamage = POVCorpse(item).CumulativeDamage;
							carc.MaxDamage = POVCorpse(item).MaxDamage;
							carc.itemName = POVCorpse(item).CorpseItemName;
							carc.CarcassName = POVCorpse(item).CarcassName;
							carc.Velocity = item.Velocity * 0.5;
							item.Velocity = vect(0,0,0);
							carc.bHidden = False;
							carc.bNotFirstFall = True;
							carc.bEmitCarcass = true;  //CyberP: emitcarc
							carc.SetPhysics(PHYS_Falling);
							carc.SetScaleGlow();
							Carc.UpdateHDTPSettings();
							Carc.Inventory = PovCorpse(item).Inv; //GMDX
							Carc.bSearched = POVCorpse(item).bSearched;
							Carc.PickupAmmoCount = POVCorpse(item).PickupAmmoCount;
							Carc.savedName = POVCorpse(item).savedName;
                            Carc.UpdateName();

                            //if (FRand() < 0.3)
                            //PlaySound(Sound'DeusExSounds.Player.MaleLand', SLOT_None, 0.9, false, 800, 0.85);

                            if (carc.SetLocation(dropVect))
							{
								// must circumvent PutInHand() since it won't allow
								// things in hand when you're carrying a corpse
								SetInHandPending(None);
								item.Destroy();
								item = None;

								if (bThrowDecoration)
								{
								    bThrowDecoration=false;
								    ThrowDecoration(carc);
				    				// play a throw anim
		                            PlayAnim('Attack',,0.1);
								}
							}
							else
								carc.bHidden = True;
						}
					}
				}
			}
			else
			{
				if (FastTrace(dropVect))
				{
					item.DropFrom(dropVect);
					item.bFixedRotationDir = True;
					item.RotationRate.Pitch = (32768 - Rand(65536)) * 4.0 * (mult*0.5);
					item.RotationRate.Yaw = (32768 - Rand(65536)) * 4.0 * (mult*0.5);
				}
			}
		}

		// if we failed to drop it, put it back inHand
		if (item != None)
		{
			if (((inHand == None) || (inHandPending == None)) && (item.Physics != PHYS_Falling))
			{
				PutInHand(item,true);
				ClientMessage(CannotDropHere);
				bDropped = False;
			}
			else
			{
				item.Instigator = Self;
			}
		}
	}
	else if (CarriedDecoration != None)
	{
	  bThrowDecoration=false;
	  DropDecoration();

		// play a throw anim
		PlayAnim('Attack',,0.1);
	}

	// If the drop failed and we removed the item from the inventory
	// grid, then we need to stick it back where it came from so
	// the inventory doesn't get fucked up.

	if ((bRemovedFromSlots) && (item != None) && (!bDropped))
	{
		//DEUS_EX AMSD Use the function call for this, helps multiplayer
		PlaceItemInSlot(item, itemPosX, itemPosY);
	}
    else if (DeusExWeapon(item).bDisposableWeapon) //SARGE: This has to be done here for some reason
        DeusExWeapon(item).PickupAmmoCount = 1;

	return bDropped;
}

// ----------------------------------------------------------------------
// RemoveItemDuringConversation()
// ----------------------------------------------------------------------

function RemoveItemDuringConversation(Inventory item)
{
	if (item != None)
	{
		// take it out of our hand
		if (item == inHand)
			PutInHand(None);

		// Make sure it's removed from the inventory grid
		RemoveItemFromSlot(item);

		// Make sure the item is deactivated!
		if (item.IsA('DeusExWeapon'))
		{
			DeusExWeapon(item).ScopeOff();
			DeusExWeapon(item).LaserOff(false);
		}
		else if (item.IsA('DeusExPickup'))
		{
			// turn it off if it is on
			if (DeusExPickup(item).bActive)
				DeusExPickup(item).Activate();
		}

		if (conPlay != None)
			conPlay.SetInHand(None);
	}
}

// ----------------------------------------------------------------------
// WinStats()
// ----------------------------------------------------------------------

exec function WinStats(bool bStatsOn)
{
	if (rootWindow != None)
		rootWindow.ShowStats(bStatsOn);
}


// ----------------------------------------------------------------------
// ToggleWinStats()
// ----------------------------------------------------------------------

exec function ToggleWinStats()
{
	if (!bCheatsEnabled)
		return;

	if (rootWindow != None)
		rootWindow.ShowStats(!rootWindow.bShowStats);
}


// ----------------------------------------------------------------------
// WinFrames()
// ----------------------------------------------------------------------

exec function WinFrames(bool bFramesOn)
{
	if (!bCheatsEnabled)
		return;

	if (rootWindow != None)
		rootWindow.ShowFrames(bFramesOn);
}


// ----------------------------------------------------------------------
// ToggleWinFrames()
// ----------------------------------------------------------------------

exec function ToggleWinFrames()
{
	if (!bCheatsEnabled)
		return;

	if (rootWindow != None)
		rootWindow.ShowFrames(!rootWindow.bShowFrames);
}


// ----------------------------------------------------------------------
// ShowClass()
// ----------------------------------------------------------------------

exec function ShowClass(Class<Actor> newClass)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.SetViewClass(newClass);
}


// ----------------------------------------------------------------------
// ShowEyes()
// ----------------------------------------------------------------------

exec function ShowEyes(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowEyes(bShow);
}


// ----------------------------------------------------------------------
// ShowArea()
// ----------------------------------------------------------------------

exec function ShowArea(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowArea(bShow);
}


// ----------------------------------------------------------------------
// ShowCylinder()
// ----------------------------------------------------------------------

exec function ShowCylinder(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowCylinder(bShow);
}


// ----------------------------------------------------------------------
// ShowMesh()
// ----------------------------------------------------------------------

exec function ShowMesh(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowMesh(bShow);
}


// ----------------------------------------------------------------------
// ShowZone()
// ----------------------------------------------------------------------

exec function ShowZone(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowZone(bShow);
}


// ----------------------------------------------------------------------
// ShowLOS()
// ----------------------------------------------------------------------

exec function ShowLOS(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowLOS(bShow);
}


// ----------------------------------------------------------------------
// ShowVisibility()
// ----------------------------------------------------------------------

exec function ShowVisibility(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowVisibility(bShow);
}


// ----------------------------------------------------------------------
// ShowData()
// ----------------------------------------------------------------------

exec function ShowData(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowData(bShow);
}


// ----------------------------------------------------------------------
// ShowEnemyResponse()
// ----------------------------------------------------------------------

exec function ShowEnemyResponse(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowEnemyResponse(bShow);
}


// ----------------------------------------------------------------------
// ShowER()
// ----------------------------------------------------------------------

exec function ShowER(bool bShow)
{
	// Convenience form of ShowEnemyResponse()
	ShowEnemyResponse(bShow);
}


// ----------------------------------------------------------------------
// ShowState()
// ----------------------------------------------------------------------

exec function ShowState(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowState(bShow);
}


// ----------------------------------------------------------------------
// ShowEnemy()
// ----------------------------------------------------------------------

exec function ShowEnemy(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowEnemy(bShow);
}


// ----------------------------------------------------------------------
// ShowInstigator()
// ----------------------------------------------------------------------

exec function ShowInstigator(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowInstigator(bShow);
}


// ----------------------------------------------------------------------
// ShowBase()
// ----------------------------------------------------------------------

exec function ShowBase(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowBase(bShow);
}


// ----------------------------------------------------------------------
// ShowLight()
// ----------------------------------------------------------------------

exec function ShowLight(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowLight(bShow);
}


// ----------------------------------------------------------------------
// ShowDist()
// ----------------------------------------------------------------------

exec function ShowDist(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowDist(bShow);
}


// ----------------------------------------------------------------------
// ShowBindName()
// ----------------------------------------------------------------------

exec function ShowBindName(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowBindName(bShow);
}


// ----------------------------------------------------------------------
// ShowPos()
// ----------------------------------------------------------------------

exec function ShowPos(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowPos(bShow);
}


// ----------------------------------------------------------------------
// ShowHealth()
// ----------------------------------------------------------------------

exec function ShowHealth(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowHealth(bShow);
}


// ----------------------------------------------------------------------
// ShowPhysics()
// ----------------------------------------------------------------------

exec function ShowPhysics(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowPhysics(bShow);
}


// ----------------------------------------------------------------------
// ShowMass()
// ----------------------------------------------------------------------

exec function ShowMass(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowMass(bShow);
}


// ----------------------------------------------------------------------
// ShowVelocity()
// ----------------------------------------------------------------------

exec function ShowVelocity(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowVelocity(bShow);
}


// ----------------------------------------------------------------------
// ShowAcceleration()
// ----------------------------------------------------------------------

exec function ShowAcceleration(bool bShow)
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		if (root.actorDisplay != None)
			root.actorDisplay.ShowAcceleration(bShow);
}

//Sarge: Moved this from DeusExWeapon because it's also used by SkilledTools
function texture GetWeaponHandTex()
{
	local texture tex;
    local bool femHands;
    
    if (bRadarTran)
        return Texture'Effects.Electricity.Xplsn_EMPG';
    else if (bIsCloaked)
        return FireTexture'GameEffects.InvisibleTex';

	if (FemaleEnabled() && (bFemaleHandsAlways || (FlagBase != None && FlagBase.GetBool('LDDPJCIsFemale'))))
    {
        switch(PlayerSkin)
        {
            case 0:
                tex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex0Fem", class'Texture', false));
                break;
            case 1:
                tex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex4Fem", class'Texture', false));
                break;
            case 2:
                tex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex5Fem", class'Texture', false));
                break;
            case 3:
                tex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex6Fem", class'Texture', false));
                break;
            case 4:
                tex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex7Fem", class'Texture', false));
                break;
        }
    }
    else
    {
        //For male, return the basic ones
		switch(PlayerSkin)
		{
			//default, black, latino, ginger, albino, respectively
			case 0: tex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.weaponhandstex0A"); break;
			case 1: tex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.weaponhandstex1A"); break;
			case 2: tex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.weaponhandstex2A"); break;
			case 3: tex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.weaponhandstex3A"); break;
			case 4: tex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.weaponhandstex4A"); break;
		}
    }

    if (tex == None) //Final backup
        tex = texture'weaponhandstex';
	return tex;
}

// ----------------------------------------------------------------------
// ShowHud()
// ----------------------------------------------------------------------

exec function ShowHud(bool bShow)
{
	local DeusExRootWindow root;
	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.ShowHud(bShow);
}

// ----------------------------------------------------------------------
// ToggleObjectBelt()
// ----------------------------------------------------------------------

exec function ToggleObjectBelt()
{
	local DeusExRootWindow root;

	bObjectBeltVisible = !bObjectBeltVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleHitDisplay()
// ----------------------------------------------------------------------

exec function ToggleHitDisplay()
{
	local DeusExRootWindow root;

	bHitDisplayVisible = !bHitDisplayVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleAmmoDisplay()
// ----------------------------------------------------------------------

exec function ToggleAmmoDisplay()
{
	local DeusExRootWindow root;

	bAmmoDisplayVisible = !bAmmoDisplayVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleAugDisplay()
// ----------------------------------------------------------------------

exec function ToggleAugDisplay()
{
	local DeusExRootWindow root;

	bAugDisplayVisible = !bAugDisplayVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
}

// ----------------------------------------------------------------------
// MinimiseTargetingWindow
// SARGE: Minimise the targeting window, since it's not always useful.
// ----------------------------------------------------------------------

exec function MinimiseTargetingWindow()
{
    bMinimiseTargetingWindow = !bMinimiseTargetingWindow;
}

// ----------------------------------------------------------------------
// SkipMessages
// ----------------------------------------------------------------------

exec function SkipMessages()
{
    if (dataLinkPlay != None)
        dataLinkPlay.AbortAndSaveHistory();
}

// ----------------------------------------------------------------------
// ToggleRadialAugMenu()
// ----------------------------------------------------------------------

exec function ToggleRadialAugMenu()
{
	local DeusExRootWindow root;
    root = DeusExRootWindow(rootWindow);

    if (!root.hud.bIsVisible) return; // don't toggle menu if HUD is invis

    if (RestrictInput())
        return;

    //No wheel while drone is active
    if (bSpyDroneActive && !bSpyDroneSet)
        return;

	bRadialAugMenuVisible = !bRadialAugMenuVisible;

	if (bRadialAugMenuVisible) {
	   // I know this is very bad design. But the shitty input handling forces
	   // this part of the code to know about the spy drone's status.
	   // Really ugly, Don't try this at home, it will lead to hell in the long run!!
	   // I am serious!
	    if (!(bSpyDroneActive && !bSpyDroneSet))                                //RSD: Allows the user to toggle between moving and controlling the drone
            WHEELSAVErotation = ViewRotation;                                   //RSD: Lorenz used SAVErotation, use WHEELSAVErotation instead
        else                                                                    //RSD: Need to use SAVErotation from when we activated drone though
            WHEELSAVErotation = SAVErotation;
	}
	else if (bSpyDroneActive && !bSpyDroneSet)                                  //RSD: Allows the user to toggle between moving and controlling the drone
	   ViewRotation = aDrone.Rotation; // This is especially nausea-invoking


    UpdateCrosshair();
    UpdateHud();
}

// ----------------------------------------------------------------------
// ToggleCompass()
// ----------------------------------------------------------------------

exec function ToggleCompass()
{
	bCompassVisible = !bCompassVisible;
    UpdateHUD();
}


// ----------------------------------------------------------------------
// ToggleLaser()
//
// turns the laser sight on or off for the current weapon
// ----------------------------------------------------------------------

exec function ToggleLaser()
{
	local DeusExWeapon W;
	W = DeusExWeapon(Weapon);

    if (W == None || !W.bHasLaser)
        return;

	SetLaser(!W.bLasing);
    UpdateCrosshair();
}

function SetLaser(bool bNewOn)
{
	local DeusExWeapon W;
	W = DeusExWeapon(Weapon);

	if (RestrictInput()||bGEPzoomActive)
		return;

	if (W == None || !W.bHasLaser)
        return;

	if (bNewOn)
	    W.LaserOn();
    else
	    W.LaserOff(false);
	
    UpdateCrosshair();
}

// ----------------------------------------------------------------------
// ToggleCrosshair()
// ----------------------------------------------------------------------
exec function ToggleCrosshair()
{
    bCrosshairVisible = !bCrosshairVisible;
	UpdateCrosshair();
}



// ----------------------------------------------------------------------
// GetCrosshairState()
// returns whether or not we should show the crosshair based on current conditions, such as lasing etc
// The checkforoutercrosshairs bool adds some additional checks for disabling the accuracy component of the crosshair
// ----------------------------------------------------------------------

function bool GetCrosshairState(optional bool bCheckForOuterCrosshairs)
{
	local DeusExWeapon W;
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);
	W = DeusExWeapon(inHand);

    //If we have the spy drone out, no outer crosshairs.
    if (bSpyDroneActive && !bSpyDroneSet && bCheckForOuterCrosshairs)
        return false;

    if (!bCrosshairVisible)
        return false;

    if (IsInState('Dying')) //No crosshair while dying
        return false;

    if (root != None && root.WindowStackCount() > 0) //No crosshair while windows are open
        return false;

    if (frobTarget != None && frobTarget.isA('InformationDevices') && InformationDevices(frobTarget).aReader == Self)
        return false;

    //SARGE: Holy shit the GMDX code absolutely sucks
    if (frobTarget != None && frobTarget.isA('GMDXTutorialCube') && GMDXTutorialCube(frobTarget).aReader == Self)
        return false;
        
    if(bRadialAugMenuVisible) //RSD: Remove the crosshair if the radial aug menu is visible
        return false;

    if (W != None)
    {
        if (W.bLasing)
            return false;
        else if (W.bLaserToggle)
            return false;
        //else if (W.bIsMeleeWeapon)
        //    return false;
        //else if (W.isA('WeaponBaton') || W.isA('WeaponProd'))
        //    return false;
        else if (W.bAimingDown)
            return false;
        else if (W.IsA('WeaponGEPGun') && WeaponGEPGun(W).GEPinout>=1.0) //No crosshair when using GEP scope
            return false;

        //Accuracy Crosshair stuff
        if (bCheckForOuterCrosshairs)
        {
            if (!W.isA('WeaponShuriken') && !W.isA('WeaponLAW') && (W.bHandToHand || W.GoverningSkill == class'DeusEx.SkillDemolition')) //Melee weapons and grenades have no accuracy crosshairs
                return false;
            else if (bHardcoreMode && W.IsInState('Reload')) //RSD: Remove the accuracy indicators if reloading on Hardcore
                return false;
        }
    }
    else if (dynamicCrosshair == 4) //If not a weapon, use nothing as our crosshair
        return false;
    //else if (inHand != None && !inHand.isA('SkilledTool') && dynamicCrosshair > 0) //Non-weapons have no crosshair
    //    return false;
    //else //Empty hands or non-weapons have no crosshair //SARGE: Now get a dot crosshair instead
    //    return false;
    
    return true;
}

// ----------------------------------------------------------------------
// GetBracketsState()
// returns whether or not we should show the frob selection brackets based on current conditions
// ----------------------------------------------------------------------

function bool GetBracketsState()
{
	local DeusExWeapon W;
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);
	W = DeusExWeapon(inHand);

    //SARGE: No brackets during fullscreen drone
    if (bSpyDroneActive && !bSpyDroneSet && bBigDroneView)
        return False;

    if (IsInState('Dying')) //No brackets while dying
        return false;

    if (root != None && root.WindowStackCount() > 0) //No brackets while windows are open
        return false;
    
    //No brackets on cloaked enemies
    if (frobTarget != None && frobTarget.isA('ScriptedPawn') && ScriptedPawn(frobTarget).bHasCloak)
        return False;

    //No brackets while reading books/datacubes/etc
    if (frobTarget != None && frobTarget.isA('InformationDevices') && InformationDevices(frobTarget).aReader == Self)
        return false;

    //SARGE: Holy shit the GMDX code absolutely sucks
    if (frobTarget != None && frobTarget.isA('GMDXTutorialCube') && GMDXTutorialCube(frobTarget).aReader == Self)
        return false;
        
    if(bRadialAugMenuVisible)
        return false;
    
    if (W != None)
    {
        if (W.IsA('WeaponGEPGun') && WeaponGEPGun(W).GEPinout>=1.0) //No brackets when using GEP scope
            return false;
    }

    return true;
}


// ----------------------------------------------------------------------
// UpdateCrosshairStyle()
// Sets the crosshair style based on hitmarkers, death, etc.
// ----------------------------------------------------------------------

function UpdateCrosshairStyle()
{
	local DeusExRootWindow root;
    local Crosshair cross;

	root = DeusExRootWindow(rootWindow);

    if (root != None && root.hud != None && root.hud.cross != None)
    {
        cross = root.hud.cross;

        if ((bSpyDroneActive && !bSpyDroneSet && bBigDroneView) || (inHand != None && inHand.isA('DeusExWeapon')) || dynamicCrosshair == 0)
    		root.hud.cross.SetBackground(Texture'CrossSquare');
        else if (dynamicCrosshair == 3)
    		root.hud.cross.SetBackground(Texture'RSDCrap.UserInterface.CrossDot3');
        else if (dynamicCrosshair == 2)
    		root.hud.cross.SetBackground(Texture'RSDCrap.UserInterface.CrossDot2');
        else
    		root.hud.cross.SetBackground(Texture'RSDCrap.UserInterface.CrossDot');
    }
}

function bool GetHitMarkerState()
{
    return hitmarkerTime > 0;
}

function UpdateCrosshair()
{
	local DeusExRootWindow root;
	root = DeusExRootWindow(rootWindow);
    
    UpdateCrosshairStyle();

    if (root != None)
        root.UpdateCrosshair();
}

function UpdateHUD()
{
	local DeusExRootWindow root;
	root = DeusExRootWindow(rootWindow);

    //SARGE: Hack to autobind belt keys - and =
    //TODO: Write a proper keybind handler class, for this and leaning,
    //the wheel, and any other keys you care to bind dynamically.
    if (bBiggerBelt)
    {
        //SARGE: TODO: Check these slots aren't already bound
        if(ConsoleCommand( "KEYBINDING Minus" ) == "")
            ConsoleCommand("SET InputExt Minus ActivateBelt 10");
        if(ConsoleCommand( "KEYBINDING Equals" ) == "")
            ConsoleCommand("SET InputExt Equals ActivateBelt 11");
    }

    if (root != None)
        root.UpdateHUD();
}

// ----------------------------------------------------------------------
// ShowInventoryWindow()
// ----------------------------------------------------------------------

exec function ShowInventoryWindow()
{
	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  ClientMessage("Inventory screen disabled in multiplayer");
	  return;
	}

	InvokeUIScreen(Class'PersonaScreenInventory');
}

// ----------------------------------------------------------------------
// ShowSkillsWindow()
// ----------------------------------------------------------------------

exec function ShowSkillsWindow()
{
	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  ClientMessage("Skills screen disabled in multiplayer");
	  return;
	}

	InvokeUIScreen(Class'PersonaScreenSkills');
}

// ----------------------------------------------------------------------
// ShowHealthWindow()
// ----------------------------------------------------------------------

exec function ShowHealthWindow()
{
	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  ClientMessage("Health screen disabled in multiplayer");
	  return;
	}

	InvokeUIScreen(Class'PersonaScreenHealth');
}

// ----------------------------------------------------------------------
// ShowImagesWindow()
// ----------------------------------------------------------------------

exec function ShowImagesWindow()
{
	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  ClientMessage("Images screen disabled in multiplayer");
	  return;
	}

	InvokeUIScreen(Class'PersonaScreenImages');
}

// ----------------------------------------------------------------------
// ShowConversationsWindow()
// ----------------------------------------------------------------------

exec function ShowConversationsWindow()
{
	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  ClientMessage("Conversations screen disabled in multiplayer");
	  return;
	}

	InvokeUIScreen(Class'PersonaScreenConversations');
}

// ----------------------------------------------------------------------
// ShowAugmentationsWindow()
// ----------------------------------------------------------------------

exec function ShowAugmentationsWindow()
{
	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  ClientMessage("Augmentations screen disabled in multiplayer");
	  return;
	}

	InvokeUIScreen(Class'PersonaScreenAugmentations');
}

// ----------------------------------------------------------------------
// ShowGoalsWindow()
// ----------------------------------------------------------------------

exec function ShowGoalsWindow()
{
	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  ClientMessage("Goals screen disabled in multiplayer");
	  return;
	}

	InvokeUIScreen(Class'PersonaScreenGoals');
}

// ----------------------------------------------------------------------
// ShowLogsWindow()
// ----------------------------------------------------------------------

exec function ShowLogsWindow()
{
	if (RestrictInput())
		return;

	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
	{
	  ClientMessage("Logs screen disabled in multiplayer");
	  return;
	}

	InvokeUIScreen(Class'PersonaScreenLogs');
}

// ----------------------------------------------------------------------
// ShowAugmentationAddWindow()
// ----------------------------------------------------------------------

exec function ShowAugmentationAddWindow()
{
	if (RestrictInput())
		return;

	InvokeUIScreen(Class'HUDMedBotAddAugsScreen');
}

// ----------------------------------------------------------------------
// ShowQuotesWindow()
// ----------------------------------------------------------------------

exec function ShowQuotesWindow()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'QuotesWindow');
}

// ----------------------------------------------------------------------
// ShowRGBDialog()
// ----------------------------------------------------------------------

exec function ShowRGBDialog()
{
	local DeusExRootWindow root;

	if (!bCheatsEnabled)
		return;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.PushWindow(Class'MenuScreenRGB');
}

// ----------------------------------------------------------------------
// ActivateBelt()
// ----------------------------------------------------------------------

exec function ActivateBelt(int objectNum)
{
	local DeusExRootWindow root;
    local Inventory beltItem;

    //SARGE: When holding the number keys in dialog, we will select a weapon
    //upon finishing the conversation. Ignore the weapon change command.
    if (fBlockBeltSelection > 0)
    {
        fBlockBeltSelection = 0;
        return;
    }

	if (RestrictInput())
		return;

    //SARGE: We need to do some wacky stuff here,
    //now that the belt slots go from 0-9 and are offset in the HUD,
    //rather than going from 1-10
    if (objectNum == 0)
        objectNum = 9;
    else if (objectNum <= 9)
        objectNum -= 1;

	if ((Level.NetMode != NM_Standalone) && bBuySkills)
	{
		root = DeusExRootWindow(rootWindow);
		if ( root != None )
		{
			if ( root.hud.hms.OverrideBelt( Self, objectNum ))
				return;
		}
	}

	if (CarriedDecoration == None)
	{
		root = DeusExRootWindow(rootWindow);
		if (root != None && root.hud != None)
		{
            beltItem = root.hud.belt.GetObjectFromBelt(objectNum);
			
            //we're not selecting anything!
            if (beltItem == None)
                return;

            //SARGE: If already selected in IW Belt mode, an additional press will set our primary weapon to that slot.
			if (bAlternateToolbelt >= 1 && beltItem == inHandPending)
			{
				advBelt = objectNum;
				root.hud.belt.RefreshAlternateToolbelt();
			}

            //If we're not in IW belt mode, set our IW belt to match our current belt.
            else if (bAlternateToolbelt == 0)
                advBelt = objectNum;

                
            //Did we select from empty?
            selectedNumberFromEmpty = inHand == None;
		
			root.ActivateObjectInBelt(objectNum);
			BeltLast = objectNum;
            NewWeaponSelected();
		}
	}
}

// ----------------------------------------------------------------------
// NextBeltItem()
// ----------------------------------------------------------------------

//SARGE: TODO: Rewrite this crappy code.
//I don't know who wrote it, but I want to punch them.
exec function NextBeltItem()
{
	local DeusExRootWindow root;
	local int slot, startSlot, totalSlots;

    if (bBiggerBelt)
        totalSlots = 12;
    else
        totalSlots = 10;

	if (RestrictInput())
		return;

   if (inHand != None && inHand.IsA('DeusExWeapon'))
	{
	 if (DeusExWeapon(inHand).bZoomed)
	 {
	  if (FovAngle < 60)
	  {
  	   DeusExWeapon(inHand).ScopeFOV += 2;
       DeusExWeapon(inHand).RefreshScopeDisplay(Self,False,True);
      }
     return;
	 }
	}
	else if (inHand != None && inHand.IsA('Binoculars'))
	{
	   if (Binoculars(inHand).bActive)
	   {
	       if (FovAngle < 60)
	       {
	           Binoculars(inHand).ScopeFov += 2;
	           Binoculars(inHand).RefreshScopeDisplay(Self,FALSE);
	       }
	       return;
	   }
	}
	else if (assignedWeapon != none && assignedWeapon.IsA('Binoculars'))        //RSD: Scrolling during secondary Binoc zoom
	{
	   if (Binoculars(assignedWeapon).bActive)
	   {
	       if (FovAngle < 60)
	       {
	           Binoculars(assignedWeapon).ScopeFov += 2;
	           Binoculars(assignedWeapon).RefreshScopeDisplay(Self,FALSE);
	       }
	       return;
	   }
	}

   if (bAlternateToolbelt == 0)
   {
	if (CarriedDecoration == None)
	{
		slot = 0;
		root = DeusExRootWindow(rootWindow);
		if (root != None)
		{
		    if (inHand == None)
	            slot = SlotMem-1;
			else if (ClientInHandPending != None)
				slot = ClientInHandPending.beltPos;
			else if (inHandPending != None)
				slot = inHandPending.beltPos;
			else if (inHand != None)
				slot = inHand.beltPos;

            startSlot = slot;

			do
			{
                //SARGE: UnrealScript doesn't short-circuit, aparrently
                slot++;
                if (bBiggerBelt && slot >= 12)
                    slot = 0;
                else if (!bBiggerBelt && slot >= 10)
                    slot = 0;
			}
			until (root.ActivateObjectInBelt(slot) || (startSlot == slot));
            advBelt = slot;

			clientInHandPending = root.hud.belt.GetObjectFromBelt(slot);

            switch( inHandPending.beltPos )
	   {
		case 1:SlotMem = 1;break;
        case 2:SlotMem = 2;break;
        case 3:SlotMem = 3;break;
		case 4:SlotMem = 4;break;
		case 5:SlotMem = 5;break;
		case 6:SlotMem = 6;break;
        case 7:SlotMem = 7;break;
		case 8:SlotMem = 8;break;
		case 9:SlotMem = 9;break;
		default:SlotMem = 1;break;
    	}
		}
	}
	BeltLast = slot;
	}
	else
	{
	if (CarriedDecoration == None)
	{
		root = DeusExRootWindow(rootWindow);
		if (root != None)
		{
            startSlot = advBelt;
			do
			{
                //SARGE: UnrealScript doesn't short-circuit, aparrently
                advBelt++;
                if (bBiggerBelt && advBelt >= 12)
                    advBelt = 0;
                else if (!bBiggerBelt && advBelt >= 10)
                    advBelt = 0;
			}
			until (root.hud.belt.GetObjectFromBelt(advBelt) != None || advBelt == startSlot);
			root.hud.belt.RefreshAlternateToolbelt();
            NewWeaponSelected();
			bScrollSelect = true;
			clientInHandPending = root.hud.belt.GetObjectFromBelt(advBelt);
            slot = advBelt;
		}
	}
    beltScrolled = slot;
    selectedNumberFromEmpty = false;
	}
}

// ----------------------------------------------------------------------
// PrevBeltItem()
// ----------------------------------------------------------------------

//SARGE: TODO: Rewrite this crappy code.
//I don't know who wrote it, but I want to punch them.
exec function PrevBeltItem()
{
	local DeusExRootWindow root;
	local int slot, startSlot;

	if (RestrictInput())
		return;

	if (inHand != None && inHand.IsA('DeusExWeapon'))
	{
	 if (DeusExWeapon(inHand).bZoomed)
	 {
	  if (FovAngle > 20)
	  {
  	   DeusExWeapon(inHand).ScopeFOV -= 2;
       DeusExWeapon(inHand).RefreshScopeDisplay(Self,False,True);
      }
     return;
	 }
	}
	else if (inHand != None && inHand.IsA('Binoculars'))
	{
	   if (Binoculars(inHand).bActive)
	   {
	       if (FovAngle > 20)
	       {
	           Binoculars(inHand).ScopeFov -= 2;
	           Binoculars(inHand).RefreshScopeDisplay(Self,FALSE);
	       }
	       return;
	   }
	}
	else if (assignedWeapon != none && assignedWeapon.IsA('Binoculars'))        //RSD: Scrolling during secondary Binoc zoom
	{
	   if (Binoculars(assignedWeapon).bActive)
	   {
	       if (FovAngle > 20)
	       {
	           Binoculars(assignedWeapon).ScopeFov -= 2;
	           Binoculars(assignedWeapon).RefreshScopeDisplay(Self,FALSE);
	       }
	       return;
	   }
	}

   if (bAlternateToolbelt == 0)
   {
	if (CarriedDecoration == None)
	{
		slot = 1;
		root = DeusExRootWindow(rootWindow);
		if (root != None)
		{
		    if (inHand == none)
		        slot = SlotMem+1;
			else if (ClientInHandPending != None)
				slot = ClientInHandPending.beltPos;
			else  if (inHandPending != None)
				slot = inHandPending.beltPos;
			else if (inHand != None)
				slot = inHand.beltPos;

			startSlot = slot;
			do
			{
                //SARGE: UnrealScript doesn't short-circuit, aparrently
                slot--;
                if (bBiggerBelt && slot <= -1)
					slot = 11;
				else if (!bBiggerBelt && slot <= -1)
					slot = 9;
			}
			until (root.ActivateObjectInBelt(slot) || (startSlot == slot));

            advBelt = slot;
			clientInHandPending = root.hud.belt.GetObjectFromBelt(slot);
			
			switch( inHandPending.beltPos )
	   {
		case 1:SlotMem = 1;break;
        case 2:SlotMem = 2;break;
        case 3:SlotMem = 3;break;
		case 4:SlotMem = 4;break;
		case 5:SlotMem = 5;break;
		case 6:SlotMem = 6;break;
        case 7:SlotMem = 7;break;
		case 8:SlotMem = 8;break;
		case 9:SlotMem = 9;break;
		default:SlotMem = 0;break;
    	}
		}
	}
	BeltLast = slot;
	}
	else
	{
	if (CarriedDecoration == None)
	{
		root = DeusExRootWindow(rootWindow);
		if (root != None)
		{	
			startSlot = advBelt;
			do
			{
                //SARGE: UnrealScript doesn't short-circuit, aparrently
                advBelt--;
                if (bBiggerBelt && advBelt <= -1)
					advBelt = 11;
				else if (!bBiggerBelt && advBelt <= -1)
					advBelt = 9;
			}
			until (root.hud.belt.GetObjectFromBelt(advBelt) != None || advBelt == startSlot);
            root.hud.belt.RefreshAlternateToolbelt();
			bScrollSelect = true;
			clientInHandPending = root.hud.belt.GetObjectFromBelt(advBelt);
            slot = advBelt;
		}
	}
    beltScrolled = slot;
    selectedNumberFromEmpty = false;
	}
}

// ----------------------------------------------------------------------
// ShowMainMenu()
// ----------------------------------------------------------------------

exec function ShowMainMenu()
{
	local DeusExRootWindow root;
	local DeusExLevelInfo info;
	local MissionEndgame Script;

	if (bIgnoreNextShowMenu)
	{
		bIgnoreNextShowMenu = False;
		return;
	}

	info = GetLevelInfo();

	// Special case baby!
	//
	// If the Intro map is loaded and we get here, that means the player
	// pressed Escape and we want to either A) start a new game
	// or B) return to the dx.dx screen.  Either way we're going to
	// abort the Intro by doing this.
	//
	// If this is one of the Endgames (which have a mission # of 99)
	// then we also want to call the Endgame's "FinishCinematic"
	// function

	// force the texture caches to flush
	if (!bFirstTimeGMDX) //CyberP: set the brightness to 60 first time player loads the game, as 50 was notoriously too dark
	{
        ConsoleCommand("set" @ "ini:Engine.Engine.ViewportManager Brightness" @ 0.6);
        ConsoleCommand("set" @ "DeusExPlayer bFirstTimeGMDX" @ "True");
        ConsoleCommand("set" @ "JCDentonMale bFirstTimeGMDX" @ "True");
        ConsoleCommand("set" @ "DeusExPlayer bRealisticCarc" @ "True");
        ConsoleCommand("set" @ "JCDentonMale bRealisticCarc" @ "True");
	}
    ConsoleCommand("FLUSH");

	if ((info != None) && (info.MissionNumber == 98))
	{
		bIgnoreNextShowMenu = True;
		PostIntro();
	}
	else if ((info != None) && (info.MissionNumber == 99))
	{
		foreach AllActors(class'MissionEndgame', Script)
			break;

		if (Script != None)
			Script.FinishCinematic();
	}
	else
	{
		root = DeusExRootWindow(rootWindow);
		if (root != None)
		{
//GMDX: stop lockpick and multitool cheat
		 if (!IsInState('Dying')&&InHand!=None&&InHand.IsA('SkilledTool')&&(InHand.IsA('Lockpick')||InHand.IsA('MultiTool')))
		 {
			if (SkilledTool(InHand).IsInState('UseIt'))
			   return; //just can InvokeMenu :P
		 }
	  	root.InvokeMenu(Class'MenuMain');
		}
	}
}

// ----------------------------------------------------------------------
// PostIntro()
// ----------------------------------------------------------------------

function PostIntro()
{
	if (bStartNewGameAfterIntro)
	{
		bStartNewGameAfterIntro = False;
		StartNewGame(strStartMap);
        if (bPrisonStart)
            StartNewGame("05_NYC_UNATCOMJ12lab"); //SARGE: Have to hardcode this. Game crashes if we use a property
        else
            StartNewGame(strStartMap); //SARGE: TODO: Add loadonly flag so we always reload.
	}
	else
	{
		Level.Game.SendPlayer(Self, "dxonly");
	}
}

// ----------------------------------------------------------------------
// EditFlags()
//
// Displays the Flag Edit dialog
// ----------------------------------------------------------------------

exec function EditFlags()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'FlagEditWindow');
}

// ----------------------------------------------------------------------
// InvokeConWindow()
//
// Displays the Invoke Conversation Window
// ----------------------------------------------------------------------

exec function InvokeConWindow()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'InvokeConWindow');
}

// ----------------------------------------------------------------------
// LoadMap()
//
// Displays the Load Map dialog
// ----------------------------------------------------------------------

exec function LoadMap()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'LoadMapWindow');
}

// ----------------------------------------------------------------------
// Overrides from PlayerPawn
// ----------------------------------------------------------------------

exec function Walk()
{
	if (RestrictInput())
		return;

	if (!bCheatsEnabled)
		return;

	Super.Walk();
}

exec function Fly()
{
	if (RestrictInput())
		return;

	if (!bCheatsEnabled)
		return;

	Super.Fly();
}

exec function Ghost()
{
	if (RestrictInput())
		return;

	if (!bCheatsEnabled)
		return;

	Super.Ghost();
}

exec function Fire(optional float F)
{
	if (RestrictInput())
	{
		if (bHidden)
			ShowMainMenu();
		return;
	}

	Super.Fire(F);
}

// ----------------------------------------------------------------------
// Tantalus()
//
// Instantly kills/destroys the object directly in front of the player
// (just like the Tantalus Field in Star Trek)
// ----------------------------------------------------------------------

exec function Tantalus()
{
	local Actor            hitActor;
	local Vector           hitLocation, hitNormal;
	local Vector           position, line;
	local ScriptedPawn     hitPawn;
	local DeusExMover      hitMover;
	local DeusExDecoration hitDecoration;
	local bool             bTakeDamage;
	local int              damage;

	if (!bCheatsEnabled)
		return;

	bTakeDamage = false;
	damage      = 1;
	position    = Location;
	position.Z += BaseEyeHeight;
	line        = Vector(ViewRotation) * 4000;

	hitActor = Trace(hitLocation, hitNormal, position+line, position, true);
	if (hitActor != None)
	{
		hitMover = DeusExMover(hitActor);
		hitPawn = ScriptedPawn(hitActor);
		hitDecoration = DeusExDecoration(hitActor);
		if (hitMover != None)
		{
			if (hitMover.bBreakable)
			{
				hitMover.doorStrength = 0;
				bTakeDamage = true;
			}
		}
		else if (hitPawn != None)
		{
			if (!hitPawn.bInvincible)
			{
				hitPawn.HealthHead     = 0;
				hitPawn.HealthTorso    = 0;
				hitPawn.HealthLegLeft  = 0;
				hitPawn.HealthLegRight = 0;
				hitPawn.HealthArmLeft  = 0;
				hitPawn.HealthArmRight = 0;
				hitPawn.Health         = 0;
				bTakeDamage = true;
			}
		}
		else if (hitDecoration != None)
		{
			if (!hitDecoration.bInvincible)
			{
				hitDecoration.HitPoints = 0;
				bTakeDamage = true;
			}
		}
		else if (hitActor != Level)
		{
			damage = 5000;
			bTakeDamage = true;
		}
	}

	if (bTakeDamage)
		hitActor.TakeDamage(damage, self, hitLocation, line, 'Tantalus');
}

// ----------------------------------------------------------------------
// OpenSesame()
//
// Opens any door immediately in front of you, locked or not
// ----------------------------------------------------------------------

exec function OpenSesame()
{
	local Actor       hitActor;
	local Vector      hitLocation, hitNormal;
	local Vector      position, line;
	local DeusExMover hitMover;
	local DeusExMover triggerMover;
	local HackableDevices device;

	if (!bCheatsEnabled)
		return;

	position    = Location;
	position.Z += BaseEyeHeight;
	line        = Vector(ViewRotation) * 4000;

	hitActor = Trace(hitLocation, hitNormal, position+line, position, true);
	hitMover = DeusExMover(hitActor);
	device   = HackableDevices(hitActor);
	if (hitMover != None)
	{
		if ((hitMover.Tag != '') && (hitMover.Tag != 'DeusExMover'))
		{
			foreach AllActors(class'DeusExMover', triggerMover, hitMover.Tag)
			{
				triggerMover.bLocked = false;
				triggerMover.Trigger(self, self);
			}
		}
		else
		{
			hitMover.bLocked = false;
			hitMover.Trigger(self, self);
		}
	}
	else if (device != None)
	{
		if (device.bHackable)
		{
			if (device.hackStrength > 0)
			{
				device.hackStrength = 0;
				device.HackAction(self, true);
			}
		}
	}
}

// ----------------------------------------------------------------------
// Legend()
//
// Displays the "Behind The Curtain" menu
// ----------------------------------------------------------------------

exec function Legend()
{
	if (!bCheatsEnabled)
		return;

	InvokeUIScreen(Class'BehindTheCurtain');
}

// ----------------------------------------------------------------------
// AddInventory()
// ----------------------------------------------------------------------

function bool AddInventory(inventory item)
{
	local bool retval;
	local DeusExRootWindow root;

    if (item == none) //CyberP: Patches up a really terrible bug. Origin: Unknown
       return(false);

	retval = super.AddInventory(item);

	// Force the object be added to the object belt
	// unless it's ammo
	//
	// Don't add Ammo and don't add Images!
	// Sarge: Don't add belt items if we have told not to

	if ((item != None) && !item.IsA('Ammo') && (!item.IsA('DataVaultImage')) && (!item.IsA('Credits')))
	{
		root = DeusExRootWindow(rootWindow);

		if ( item.bInObjectBelt )
		{
			if (root != None)
			{
				root.hud.belt.AddObjectToBelt(item, item.beltPos, True);
			}
		}

		if (retval)
		{
			if (root != None)
		 {
				root.AddInventory(item);
		 }
		}
	}

	return (retval);
}

// ----------------------------------------------------------------------
// DeleteInventory()
// ----------------------------------------------------------------------

function bool DeleteInventory(inventory item)
{
	local bool retval;
	local DeusExRootWindow root;
	local PersonaScreenInventory winInv;

    //BroadcastMessage("function DeleteInventory");
	// If the item was inHand, clear the inHand
	if (inHand == item)
	{
		SetInHand(None);
		SetInHandPending(None);
	}

	// Make sure the item is removed from the inventory grid
	RemoveItemFromSlot(item);

	root = DeusExRootWindow(rootWindow);

	if (root != None)
	{
		// If the inventory screen is active, we need to send notification
		// that the item is being removed
		winInv = PersonaScreenInventory(root.GetTopWindow());
		if (winInv != None)
			winInv.InventoryDeleted(item);

		// Remove the item from the object belt
		if (root != None)
        {
            // Sarge: Keep darkened version in the belt if we have Keep Deleted Belt Items setting turn on
            if (bBeltMemory)
                MakeBeltObjectPlaceholder(item);
            else
                RemoveObjectFromBelt(item);
        }
        else //In multiplayer, we often don't have a root window when creating corpse, so hand delete
        {
            item.bInObjectBelt = false;
            item.beltPos = -1;
        }
	}

	return Super.DeleteInventory(item);
}

// ----------------------------------------------------------------------
// JoltView()
// ----------------------------------------------------------------------

event JoltView(float newJoltMagnitude)
{
	if (Abs(JoltMagnitude) < Abs(newJoltMagnitude))
		JoltMagnitude = newJoltMagnitude;
}

// ----------------------------------------------------------------------
// UpdateEyeHeight()
// ----------------------------------------------------------------------

event UpdateEyeHeight(float DeltaTime)
{
	Super.UpdateEyeHeight(DeltaTime);

	if (JoltMagnitude != 0)
	{
		if ((Physics == PHYS_Walking) && (Bob != 0))
			EyeHeight += (JoltMagnitude * 5);
		JoltMagnitude = 0;
	}
}

// ----------------------------------------------------------------------
// PlayerCalcView()
// ----------------------------------------------------------------------

event PlayerCalcView( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local vector unX,unY,unZ;
    local rotator fixedRotation;
	if (bStaticFreeze)
	{
		CameraLocation = SAVElocation;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
		CameraRotation=SAVErotation;
		SetLocation(SAVElocation);
		SetRotation(SAVErotation);
		GotoState('StaticFreeze');
		return;
	}
	// check for spy drone and freeze player's view
	if (bSpyDroneActive && !bSpyDroneSet && !bRadialAugMenuVisible)                     //RSD: Allows the user to toggle between moving and controlling the drone, also added Lorenz's wheel
	{
		if (aDrone != None)
		{
            //Fix the player rotation
            fixedRotation = SAVErotation;
            fixedRotation.Pitch = 0f;
            fixedRotation.Roll = 0f;

            //SARGE: Added Drone-View
            if (bBigDroneView)
            {
                //View from the drone
                SetRotation(fixedRotation);
                CameraRotation = aDrone.Rotation;
                CameraLocation = aDrone.Location;
                //CameraLocation.Z += EyeHeight;
                //CameraLocation += WalkBob;
                ViewActor = aDrone;
                return;
            }
            else
            {
                //View from the player
                CameraRotation = SAVErotation;                                      //RSD: Added
                SetRotation(fixedRotation);                                         //RSD: Added
                CameraLocation = Location;
                CameraLocation.Z += EyeHeight;
                CameraLocation += WalkBob;
                return;
            }
		}
	}

	// Check if we're in first-person view or third-person.  If we're in first-person then
	// we'll just render the normal camera view.  Otherwise we want to place the camera
	// as directed by the conPlay.cameraInfo object.

	if ( bBehindView && (!InConversation()) )
	{
		Super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
		return;
	}

	if ( (!InConversation()) || ( conPlay.GetDisplayMode() == DM_FirstPerson ) )
	{
		// First-person view.
		ViewActor = Self;

        if (bRadialAugMenuVisible) {
            // prevent view from rotating
            ViewRotation=WHEELSAVErotation;                                     //RSD: Lorenz used SAVErotation, use WHEELSAVErotation instead
            SetRotation(WHEELSAVErotation);                                     //RSD: Lorenz used SAVErotation, use WHEELSAVErotation instead
        }

	    CameraRotation = ViewRotation;

		CameraLocation = Location;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;

//GMDX
		if (!bGEPzoomActive)
			UpdateRocketTarget(CameraRotation,RocketTargetMaxDistance);//wire guided (laser)

		GetAxes(Normalize(Rotation),unX,unY,unZ);
		unX*=RecoilShake.X;
		unY*=RecoilShake.Y;
		unZ*=RecoilShake.Z;
		CameraLocation += (unX+unY+unZ);
		return;
	}

	// Allow the ConCamera object to calculate the camera position and
	// rotation for us (in other words, take this sloppy routine and
	// hide it elsewhere).

	if (conPlay.cameraInfo.CalculateCameraPosition(ViewActor, CameraLocation, CameraRotation) == False)
		Super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
}


// ----------------------------------------------------------------------
// PlayerInput()
// ----------------------------------------------------------------------

event PlayerInput( float DeltaTime )
{
	if (!InConversation())
		Super.PlayerInput(DeltaTime);
}

// ----------------------------------------------------------------------
// state Conversation
// ----------------------------------------------------------------------

state Conversation
{
ignores SeePlayer, HearNoise, Bump;

	event PlayerTick(float deltaTime)
	{
		local rotator tempRot;
		local float   yawDelta;

		UpdateInHand();
		UpdateDynamicMusic(deltaTime);

		DrugEffects(deltaTime);
		RecoilEffectTick(deltaTime);
		Bleed(deltaTime);
		MaintainEnergy(deltaTime);

		// must update viewflash manually incase a flash happens during a convo
		ViewFlash(deltaTime);

		// Check if player has walked outside a first-person convo.
		CheckActiveConversationRadius();

		// Check if all the people involved in a conversation are
		// still within a reasonable radius.
		CheckActorDistances();

		Super.PlayerTick(deltaTime);
		LipSynch(deltaTime);

		// Keep turning towards the person we're speaking to
		if (ConversationActor != None)
		{
			LookAtActor(ConversationActor, true, true, true, 0, 0.5);

			// Hacky way to force the player to turn...
			tempRot = rot(0,0,0);
			tempRot.Yaw = (DesiredRotation.Yaw - Rotation.Yaw) & 65535;
			if (tempRot.Yaw > 32767)
				tempRot.Yaw -= 65536;
			yawDelta = RotationRate.Yaw * deltaTime;
			if (tempRot.Yaw > yawDelta)
				tempRot.Yaw = yawDelta;
			else if (tempRot.Yaw < -yawDelta)
				tempRot.Yaw = -yawDelta;
			SetRotation(Rotation + tempRot);
		}

		// Update Time Played
		UpdateTimePlayed(deltaTime);
	}

	function LoopHeadConvoAnim()
	{
	}

	function EndState()
	{
		conPlay = None;

		// Re-enable the PC's detectability
		MakePlayerIgnored(false);

		MoveTarget = None;
		bBehindView = false;
		StopBlendAnims();
		ConversationActor = None;
	}

	function int retLevelInfo()
	{
	   local DeusExLevelInfo info;
	   local int misNum;

	   info = GetLevelInfo();

	   if (info!=None)
	   {
	       misNum = info.missionNumber;
	   }
	   else
	       misNum = 0;

       return misNum;
	}

Begin:
	// Make sure we're stopped
	Velocity.X = 0;
	Velocity.Y = 0;
	Velocity.Z = 0;

	Acceleration = Velocity;

	PlayRising();

	// Make sure the player isn't on fire!
	if (bOnFire)
		ExtinguishFire();

	// Make sure the PC can't be attacked while in conversation
	MakePlayerIgnored(true);

	LookAtActor(conPlay.startActor, true, false, true, 0, 0.5);

	SetRotation(DesiredRotation);

	PlayTurning();
//	TurnToward(conPlay.startActor);
//	TweenToWaiting(0.1);
//	FinishAnim();

	if (!conPlay.StartConversation(Self))
	{
		AbortConversation(True);
	}
	else
	{
		// Put away whatever the PC may be holding //CyberP: don't put away wep when shit hits the fan or conversee is a potential threat
		if (inHand != None && inHand.IsA('DeusExWeapon') && !conPlay.startActor.IsA('NicoletteDuClare') && (retLevelInfo() == 5 || retLevelInfo() >= 12 || conPlay.startActor.IsA('HumanThug') ||
          conPlay.startActor.IsA('Terrorist') || conPlay.startActor.Style == STY_Translucent || conPlay.startActor.IsA('DeusExDecoration') || conPlay.startActor.IsA('JuanLebedev') || conPlay.startActor.IsA('BobPage')))
		{
		}
		else
		{
		    conPlay.SetInHand(InHand);
		    PutInHand(None);
		}
        UpdateInHand();

		if ( conPlay.GetDisplayMode() == DM_ThirdPerson )
			bBehindView = true;
	}
}

// ----------------------------------------------------------------------
// InConversation()
//
// Returns True if the player is currently engaged in conversation
// ----------------------------------------------------------------------

function bool InConversation()
{
	if ( conPlay == None )
	{
		return False;
	}
	else
	{
		if (conPlay.con != None)
			return ((conPlay.con.bFirstPerson == False) && (!conPlay.GetForcePlay()));
		else
			return False;
	}
}

// ----------------------------------------------------------------------
// CanStartConversation()
//
// Returns true if we can start a conversation.  Basically this means
// that
//
// 1) If in conversation, bCannotBeInterrutped set to False
// 2) If in conversation, if we're not in a third-person convo
// 3) The player isn't in 'bForceDuck' mode
// 4) The player isn't DEAD!
// 5) The player isn't swimming
// 6) The player isn't CheatFlying (ghost)
// 7) The player isn't in PHYS_Falling
// 8) The game is in 'bPlayersOnly' mode
// 9) UI screen of some sort isn't presently active.
// ----------------------------------------------------------------------

function bool CanStartConversation()
{
	if	(((conPlay != None) && (conPlay.CanInterrupt() == False)) ||
		((conPlay != None) && (conPlay.con.bFirstPerson != True)) ||
		 (( bForceDuck == True ) && ((HealthLegLeft > 0) || (HealthLegRight > 0))) ||
		 ( IsInState('Dying') ) ||
		 ( IsInState('PlayerSwimming') ) ||
		 ( IsInState('CheatFlying') ) ||
		 ( Physics == PHYS_Falling ) ||
		 ( Level.bPlayersOnly ) ||
	     (!DeusExRootWindow(rootWindow).CanStartConversation()))
		return False;
	else
		return True;
}

// ----------------------------------------------------------------------
// GetDisplayName()
//
// Returns a name that can be displayed in the conversation.
//
// The first time we speak to someone we'll use the Unfamiliar name.
// For subsequent conversations, use the Familiar name.  As a fallback,
// the BindName will be used if both of the other two fields
// are blank.
//
// If this is a DeusExDecoration and the Familiar/Unfamiliar names
// are blank, then use the decoration's ItemName instead.  This is
// for use in the FrobDisplayWindow.
// ----------------------------------------------------------------------

function String GetDisplayName(Actor actor, optional Bool bUseFamiliar)
{
	local String displayName;

	// Sanity check
	if ((actor == None) || (player == None) || (rootWindow == None))
		return "";

	// If we've spoken to this person already, use the
	// Familiar Name
	if ((actor.FamiliarName != "") && ((actor.LastConEndTime > 0) || (bUseFamiliar)))
		displayName = actor.FamiliarName;

	if ((displayName == "") && (actor.UnfamiliarName != ""))
		displayName = actor.UnfamiliarName;

	if (displayName == "")
	{
		if (actor.IsA('DeusExDecoration'))
			displayName = DeusExDecoration(actor).itemName;
		else
			displayName = actor.BindName;
	}

	return displayName;
}

// ----------------------------------------------------------------------
// EndConversation()
//
// Called by ConPlay when a conversation has finished.
// ----------------------------------------------------------------------

function EndConversation()
{
	local DeusExLevelInfo info;

	Super.EndConversation();

	// If we're in a bForcePlay (cinematic) conversation,
	// force the CinematicWindow to be displayd
	if ((conPlay != None) && (conPlay.GetForcePlay()))
	{
		if (DeusExRootWindow(rootWindow) != None)
			DeusExRootWindow(rootWindow).NewChild(class'CinematicWindow');
	}

	conPlay = None;

	// Check to see if we need to resume any DataLinks that may have
	// been aborted when we started this conversation
	ResumeDataLinks();

	StopBlendAnims();

	// We might already be dead at this point (someone drop a LAM before
	// entering the conversation?) so we want to make sure the player
	// doesn't suddenly jump into a non-DEATH state.
	//
	// Also make sure the player is actually in the Conversation state
	// before attempting to kick him out of it.

	if ((Health > 0) && ((IsInState('Conversation')) || (IsInState('FirstPersonConversation')) || (NextState == 'Interpolating')))
	{
		if (NextState == '')
			GotoState('PlayerWalking');
		else
			GotoState(NextState);
	}
}

// ----------------------------------------------------------------------
// ResumeDataLinks()
// ----------------------------------------------------------------------

function ResumeDataLinks()
{
	if ( dataLinkPlay != None )
		dataLinkPlay.ResumeDataLinks();
}

// ----------------------------------------------------------------------
// AbortConversation()
// ----------------------------------------------------------------------

function AbortConversation(optional bool bNoPlayedFlag)
{
	if (conPlay != None)
		conPlay.TerminateConversation(False, bNoPlayedFlag);
}

// ----------------------------------------------------------------------
// StartConversationByName()
//
// Starts a conversation by looking for the name passed in.
//
// Calls StartConversation() if a match is found.
// ----------------------------------------------------------------------

function bool StartConversationByName(
	Name conName,
	Actor conOwner,
	optional bool bAvoidState,
	optional bool bForcePlay
	)
{
	local ConListItem conListItem;
	local Conversation con;
	local Int  dist;
	local Bool bConversationStarted;

	bConversationStarted = False;

	if (conOwner == None)
		return False;

	conListItem = ConListItem(conOwner.conListItems);

	while( conListItem != None )
	{
		if ( conListItem.con.conName == conName )
		{
			con = conListItem.con;
			break;
		}

		conListItem = conListItem.next;
	}

	// Now check to see that we're in a respectable radius.
	if (con != None)
	{
		dist = VSize(Location - conOwner.Location);

		// 800 = default sound radius, from unscript.cpp
		//
		// If "bForcePlay" is set, then force the conversation
		// to play!

		if ((dist <= 800) || (bForcePlay))
			bConversationStarted = StartConversation(conOwner, IM_Named, con, bAvoidState, bForcePlay);
	}

	return bConversationStarted;
}

// ----------------------------------------------------------------------
// StartAIBarkConversation()
//
// Starts an AI Bark conversation, which really isn't a conversation
// as much as a simple bark.
// ----------------------------------------------------------------------

function bool StartAIBarkConversation(
	Actor conOwner,
	EBarkModes barkMode
	)
{
	if ((conOwner == None) || (conOwner.conListItems == None) || (barkManager == None) ||
		((conPlay != None) && (conPlay.con.bFirstPerson != True)))
		return False;
	else
		return (barkManager.StartBark(DeusExRootWindow(rootWindow), ScriptedPawn(conOwner), barkMode));
}

// ----------------------------------------------------------------------
// StartConversation()
//
// Checks to see if a valid conversation exists for this moment in time
// between the ScriptedPawn and the PC.  If so, then it triggers the
// conversation system and returns TRUE when finished.
// ----------------------------------------------------------------------

function bool StartConversation(
	Actor invokeActor,
	EInvokeMethod invokeMethod,
	optional Conversation con,
	optional bool bAvoidState,
	optional bool bForcePlay
	)
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	// First check to see the actor has any conversations or if for some
	// other reason we're unable to start a conversation (typically if
	// we're alread in a conversation or there's a UI screen visible)

	if ((!bForcePlay) && ((invokeActor.conListItems == None) || (!CanStartConversation())))
		return False;

	// Make sure the other actor can converse
	if ((!bForcePlay) && ((ScriptedPawn(invokeActor) != None) && (!ScriptedPawn(invokeActor).CanConverse())))
		return False;

	// If we have a conversation passed in, use it.  Otherwise check to see
	// if the passed in actor actually has a valid conversation that can be
	// started.

	if ( con == None )
		con = GetActiveConversation(invokeActor, invokeMethod);

	// If we have a conversation, put the actor into "Conversation Mode".
	// Otherwise just return false.
	//
	// TODO: Scan through the conversation and put *ALL* actors involved
	//       in the conversation into the "Conversation" state??

	if ( con != None )
	{
		// Check to see if this conversation is already playing.  If so,
		// then don't start it again.  This prevents a multi-bark conversation
		// from being abused.
		if ((conPlay != None) && (conPlay.con == con))
			return False;

		// Now check to see if there's a conversation playing that is owned
		// by the InvokeActor *and* the player has a speaking part *and*
		// it's a first-person convo, in which case we want to abort here.
		if (((conPlay != None) && (conPlay.invokeActor == invokeActor)) &&
		    (conPlay.con.bFirstPerson) &&
			(conPlay.con.IsSpeakingActor(Self)))
			return False;

		// Check if the person we're trying to start the conversation
		// with is a Foe and this is a Third-Person conversation.
		// If so, ABORT!
		if ((!bForcePlay) && ((!con.bFirstPerson) && (ScriptedPawn(invokeActor) != None) && (ScriptedPawn(invokeActor).GetPawnAllianceType(Self) == ALLIANCE_Hostile)))
			return False;

		// If the player is involved in this conversation, make sure the
		// scriptedpawn even WANTS to converse with the player.
		//
		// I have put a hack in here, if "con.bCanBeInterrupted"
		// (which is no longer used as intended) is set, then don't
		// call the ScriptedPawn::CanConverseWithPlayer() function

		if ((!bForcePlay) && ((con.IsSpeakingActor(Self)) && (!con.bCanBeInterrupted) && (ScriptedPawn(invokeActor) != None) && (!ScriptedPawn(invokeActor).CanConverseWithPlayer(Self))))
			return False;

		// Hack alert!  If this is a Bark conversation (as denoted by the
		// conversation name, since we don't have a field in ConEdit),
		// then force this conversation to be first-person
		if (Left(con.conName, Len(con.conOwnerName) + 5) == (con.conOwnerName $ "_Bark"))  //CyberP: we can make all conversations first person this way
			con.bFirstPerson = True;

		// Make sure the player isn't ducking.  If the player can't rise
		// to start a third-person conversation (blocked by geometry) then
		// immediately abort the conversation, as this can create all
		// sorts of complications (such as the player standing through
		// geometry!!)

		if ((!con.bFirstPerson) && (ResetBasedPawnSize() == False))
			return False;

		// If ConPlay exists, end the current conversation playing
		if (conPlay != None)
		{
			// If we're already playing a third-person conversation, don't interrupt with
			// another *radius* induced conversation (frobbing is okay, though).
			if ((conPlay.con != None) && (conPlay.con.bFirstPerson) && (invokeMethod == IM_Radius))
				return False;

			conPlay.InterruptConversation();
			conPlay.TerminateConversation();
		}

		// If this is a first-person conversation _and_ a DataLink is already
		// playing, then abort.  We don't want to give the user any more
		// distractions while a DL is playing, since they're pretty important.
		if ( dataLinkPlay != None )
		{
			if (con.bFirstPerson)
				return False;
			else
				dataLinkPlay.AbortAndSaveHistory();
		}

		// Found an active conversation, so start it
		conPlay = Spawn(class'ConPlay');
		conPlay.SetStartActor(invokeActor);
		conPlay.SetConversation(con);
		conPlay.SetForcePlay(bForcePlay);
		conPlay.SetInitialRadius(VSize(Location - invokeActor.Location));

		// If this conversation was invoked with IM_Named, then save away
		// the current radius so we don't abort until we get outside
		// of this radius + 100.
		if ((invokeMethod == IM_Named) || (invokeMethod == IM_Frob))
		{
			conPlay.SetOriginalRadius(con.radiusDistance);
			con.radiusDistance = VSize(invokeActor.Location - Location);
		}

		// If the invoking actor is a ScriptedPawn, then force this person
		// into the conversation state
		if ((!bForcePlay) && (ScriptedPawn(invokeActor) != None ))
			ScriptedPawn(invokeActor).EnterConversationState(con.bFirstPerson, bAvoidState);

		// Do the same if this is a DeusExDecoration
		if ((!bForcePlay) && (DeusExDecoration(invokeActor) != None ))
			DeusExDecoration(invokeActor).EnterConversationState(con.bFirstPerson, bAvoidState);

		// If this is a third-person convo, we're pretty much going to
		// pause the game.  If this is a first-person convo, then just
		// keep on going..
		//
		// If this is a third-person convo *AND* 'bForcePlay' == True,
		// then use first-person mode, as we're playing an intro/endgame
		// sequence and we can't have the player in the convo state (bad bad bad!)

		if ((!con.bFirstPerson) && (!bForcePlay))
		{
			GotoState('Conversation');
		}
		else
		{
			if (!conPlay.StartConversation(Self, invokeActor, bForcePlay))
			{
				AbortConversation(True);
			}
		}

		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// GetActiveConversation()
//
// This routine searches all the conversations in this chain until it
// finds one that is valid for this situation.  It returns the
// conversation or None if none are found.
// ----------------------------------------------------------------------

function Conversation GetActiveConversation( Actor invokeActor, EInvokeMethod invokeMethod )
{
	local ConListItem conListItem;
	local Conversation con;
	local Name flagName;
	local bool bAbortConversation;

	// If we don't have a valid invokeActor or the flagbase
	// hasn't yet been initialized, immediately abort.
	if ((invokeActor == None) || (flagBase == None))
		return None;

	bAbortConversation = True;

	// Force there to be a one second minimum between conversations
	// with the same NPC
	if ((invokeActor.LastConEndTime != 0) &&
		((Level.TimeSeconds - invokeActor.LastConEndTime) < 1.0))
		return None;

	// In a loop, go through the conversations, checking each.
	conListItem = ConListItem(invokeActor.ConListItems);

	while ( conListItem != None )
	{
		con = conListItem.con;

		bAbortConversation = False;

		// Ignore Bark conversations, as these are started manually
		// by the AI system.  Do this by checking to see if the first
		// part of the conversation name is in the form,
		//
		// ConversationOwner_Bark

		if (Left(con.conName, Len(con.conOwnerName) + 5) == (con.conOwnerName $ "_Bark"))
			bAbortConversation = True;

		if (!bAbortConversation)
		{
			// Now check the invocation method to make sure
			// it matches what was passed in

			switch( invokeMethod )
			{
				// Removed Bump conversation starting functionality, all convos
				// must now be "Frobbed" to start (excepting Radius, of course).
				case IM_Bump:
				case IM_Frob:
					bAbortConversation = !(con.bInvokeFrob || con.bInvokeBump);
					break;

				case IM_Sight:
					bAbortConversation = !con.bInvokeSight;
					break;

				case IM_Radius:
					if ( con.bInvokeRadius )
					{
						// Calculate the distance between the player and the owner
						// and if the player is inside that radius, we've passed
						// this check.

						bAbortConversation = !CheckConversationInvokeRadius(invokeActor, con);

						// First check to make sure that at least 10 seconds have passed
						// before playing a radius-induced conversation after a letterbox
						// conversation with the player
						//
						// Check:
						//
						// 1.  Player finished letterbox convo in last 10 seconds
						// 2.  Conversation was with this NPC
						// 3.  This new radius conversation is with same NPC.

						if ((!bAbortConversation) &&
						    ((Level.TimeSeconds - lastThirdPersonConvoTime) < 10) &&
						    (lastThirdPersonConvoActor == invokeActor))
							bAbortConversation = True;

						// Now check if this conversation ended in the last ten seconds or so
						// We want to prevent the user from getting trapped inside the same
						// radius conversation

						if ((!bAbortConversation) && (con.lastPlayedTime > 0))
							bAbortConversation = ((Level.TimeSeconds - con.lastPlayedTime) < 10);

						// Now check to see if the player just ended a radius, third-person
						// conversation with this NPC in the last 5 seconds.  If so, punt,
						// because we don't want these to chain together too quickly.

						if ((!bAbortConversation) &&
						    ((Level.TimeSeconds - lastFirstPersonConvoTime) < 5) &&
							(lastFirstPersonConvoActor == invokeActor))
							bAbortConversation = True;
					}
					else
					{
						bAbortConversation = True;
					}
					break;

				case IM_Other:
				default:
					break;
			}
		}

		// Now check to see if these two actors are too far apart on their Z
		// axis so we don't get conversations triggered when someone jumps on
		// someone else, or when actors are on two different levels.

		if (!bAbortConversation)
		{
			bAbortConversation = !CheckConversationHeightDifference(invokeActor, 20);

			// If the height check failed, look to see if the actor has a LOS view
			// to the player in which case we'll allow the conversation to continue

			if (bAbortConversation)
				bAbortConversation = !CanActorSeePlayer(invokeActor);
		}

		// Check if this conversation is only to be played once
		if (( !bAbortConversation ) && ( con.bDisplayOnce ))
		{
			flagName = rootWindow.StringToName(con.conName $ "_Played");
			bAbortConversation = (flagBase.GetBool(flagName) == True);
		}

		if ( !bAbortConversation )
		{
			// Then check to make sure all the flags that need to be
			// set are.

			bAbortConversation = !CheckFlagRefs(con.flagRefList);
		}

		if ( !bAbortConversation )
			break;

		conListItem = conListItem.next;
	}

	if (bAbortConversation)
		return None;
	else
		return con;
}

// ----------------------------------------------------------------------
// CheckConversationInvokeRadius()
//
// Returns True if this conversation can be invoked given the
// invoking actor and the conversation passed in.
// ----------------------------------------------------------------------

function bool CheckConversationInvokeRadius(Actor invokeActor, Conversation con)
{
	local Int  invokeRadius;
	local Int  dist;

	dist = VSize(Location - invokeActor.Location);

	invokeRadius = Max(16, con.radiusDistance);

	return (dist <= invokeRadius);
}

// ----------------------------------------------------------------------
// CheckConversationHeightDifference()
//
// Checks to make sure the player and the invokeActor are fairly close
// to each other on the Z Plane.  Returns True if they are an
// acceptable distance, otherwise returns False.
// ----------------------------------------------------------------------

function bool CheckConversationHeightDifference(Actor invokeActor, int heightOffset)
{
	local Int dist;

	dist = Abs(Location.Z - invokeActor.Location.Z) - Abs(Default.CollisionHeight - CollisionHeight);

	if (dist > (Abs(CollisionHeight - invokeActor.CollisionHeight) + heightOffset))
		return False;
	else
		return True;
}

// ----------------------------------------------------------------------
// CanActorSeePlayer()
// ----------------------------------------------------------------------

function bool CanActorSeePlayer(Actor invokeActor)
{
	return FastTrace(invokeActor.Location);
}

// ----------------------------------------------------------------------
// CheckActiveConversationRadius()
//
// If there's a first-person conversation active, checks to make sure
// that the player has not walked far away from the conversation owner.
// If so, the conversation is aborted.
// ----------------------------------------------------------------------

function CheckActiveConversationRadius()
{
	local int checkRadius;

	// Ignore if conPlay.GetForcePlay() returns True

	if ((conPlay != None) && (!conPlay.GetForcePlay()) && (conPlay.ConversationStarted()) && (conPlay.displayMode == DM_FirstPerson) && (conPlay.StartActor != None))
	{
		// If this was invoked via a radius, then check to make sure the player doesn't
		// exceed that radius plus

		if (conPlay.con.bInvokeRadius)
			checkRadius = conPlay.con.radiusDistance + 100;
		else
			checkRadius = 300;

		// Add the collisioncylinder since some objects are wider than others
		checkRadius += conPlay.StartActor.CollisionRadius;

		if (VSize(conPlay.startActor.Location - Location) > checkRadius)
		{
			// Abort the conversation
			conPlay.TerminateConversation(True);
		}
	}
}

// ----------------------------------------------------------------------
// CheckActorDistances()
//
// Checks to see how far all the actors are away from each other
// to make sure the conversation should continue.
// ----------------------------------------------------------------------

function bool CheckActorDistances()
{
	if ((conPlay != None) && (!conPlay.GetForcePlay()) && (conPlay.ConversationStarted()) && (conPlay.displayMode == DM_ThirdPerson))
	{
		if (!conPlay.con.CheckActorDistances(Self))
			conPlay.TerminateConversation(True);
	}
}

// ----------------------------------------------------------------------
// CheckFlagRefs()
//
// Loops through the flagrefs passed in and sees if the current flag
// settings in the game match this set of flags.  Returns True if so,
// otherwise False.
// ----------------------------------------------------------------------

function bool CheckFlagRefs( ConFlagRef flagRef )
{
	local ConFlagRef currentRef;

	// Loop through our list of FlagRef's, checking the value of each.
	// If we hit a bad match, then we'll stop right away since there's
	// no point of continuing.

	currentRef = flagRef;

	while( currentRef != None )
	{
		if ( flagBase.GetBool(currentRef.flagName) != currentRef.value )
			return False;

		currentRef = currentRef.nextFlagRef;
	}

	// If we made it this far, then the flags check out.
	return True;
}

// ----------------------------------------------------------------------
// StartDataLinkTransmission()
//
// Locates and starts the DataLink passed in
// ----------------------------------------------------------------------

function Bool StartDataLinkTransmission(
	String datalinkName,
	Optional DataLinkTrigger datalinkTrigger)
{
	local Conversation activeDataLink;
	local bool bDataLinkPlaySpawned;

	// Don't allow DataLinks to start if we're in PlayersOnly mode
	if ( Level.bPlayersOnly )
		return False;

	activeDataLink = GetActiveDataLink(datalinkName);

	if ( activeDataLink != None )
	{
		// Search to see if there's an active DataLinkPlay object
		// before creating one

		if ( dataLinkPlay == None )
		{
			datalinkPlay = Spawn(class'DataLinkPlay');
			bDataLinkPlaySpawned = True;
		}

		// Call SetConversation(), which returns
		if (datalinkPlay.SetConversation(activeDataLink))
		{
			datalinkPlay.SetTrigger(datalinkTrigger);

			if (datalinkPlay.StartConversation(Self))
			{
				return True;
			}
			else
			{
				// Datalink must already be playing, or in queue
				if (bDataLinkPlaySpawned)
				{
					datalinkPlay.Destroy();
					datalinkPlay = None;
				}

				return False;
			}
		}
		else
		{
			// Datalink must already be playing, or in queue
			if (bDataLinkPlaySpawned)
			{
				datalinkPlay.Destroy();
				datalinkPlay = None;
			}
			return False;
		}
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// GetActiveDataLink()
//
// Loops through the conversations belonging to the player and checks
// to see if the datalink conversation passed in can be found.  Also
// checks to the "PlayedOnce" flag to prevent datalink transmissions
// from playing more than one (unless intended).
// ----------------------------------------------------------------------

function Conversation GetActiveDataLink(String datalinkName)
{
	local Name flagName;
	local ConListItem conListItem;
	local Conversation con;
	local bool bAbortDataLink;
	local bool bDatalinkFound;
	local bool bDataLinkNameFound;

	// Abort immediately if the flagbase isn't yet initialized
	if ((flagBase == None) || (rootWindow == None))
		return None;

	conListItem = ConListItem(conListItems);

	// In a loop, go through the conversations, checking each.
	while ( conListItem != None )
	{
		con = conListItem.con;

		if ( Caps(datalinkName) == Caps(con.conName) )
		{
			// Now check if this DataLink is only to be played
			// once

			bDataLinkNameFound = True;
			bAbortDataLink = False;

			if ( con.bDisplayOnce )
			{
				flagName = rootWindow.StringToName(con.conName $ "_Played");
				bAbortDataLink = (flagBase.GetBool(flagName) == True);
			}

			// Check the flags for this DataLink
			if (( !bAbortDataLink ) && ( CheckFlagRefs( con.flagRefList ) == True ))
			{
				bDatalinkFound = True;
				break;
			}
		}
		conListItem = conListItem.next;
	}

	if (bDatalinkFound)
	{
		return con;
	}
	else
	{
		// Print a warning if this DL couldn't be found based on its name
		if (bDataLinkNameFound == False)
		{
			log("WARNING! INFOLINK NOT FOUND!! Name = " $ datalinkName);
			ClientMessage("WARNING! INFOLINK NOT FOUND!! Name = " $ datalinkName);
		}
		return None;
	}
}

// ----------------------------------------------------------------------
// AddNote()
//
// Adds a new note to the list of notes the player is carrying around.
// ----------------------------------------------------------------------

function DeusExNote AddNote( optional String strNote, optional Bool bUserNote, optional bool bShowInLog )
{
	local DeusExNote newNote;

	newNote = new(Self) Class'DeusExNote';

	newNote.text = strNote;
	newNote.originalText = strNote;
	newNote.SetUserNote( bUserNote );

	// Insert this new note at the top of the notes list
	if (FirstNote == None)
		LastNote  = newNote;
	else
		newNote.next = FirstNote;

	FirstNote = newNote;

	// Optionally show the note in the log
	if ( bShowInLog )
	{
		ClientMessage(NoteAdded);
		DeusExRootWindow(rootWindow).hud.msgLog.PlayLogSound(Sound'LogNoteAdded');
	}

	return newNote;
}

// ----------------------------------------------------------------------
// GetCodeNote()
//
// Loops through the notes and searches for the code in any note.
// Ignores user notes, so we can't add some equivalent of "The code's 0451" and instantly know a code
// Also makes sure to check the original text of notes, not user-added text, so we can't cheat by appending 0451 to an existing non-user note.
// ----------------------------------------------------------------------

function bool GetCodeNote(string code)
{
	local DeusExNote note;

	note = FirstNote;

	while( note != None )
	{
        //Skip user notes
        if (!note.bUserNote)
        {

            //handle any notes we were given which might not have "original" text for whatever reason
            if (note.originalText == "")
                note.originalText = note.text;

            //Check note contents for the code
            if (InStr(Caps(note.originalText),Caps(code)) != -1)
                return true;

            //log("NOTE: " $ note.text);
            
        }

		note = note.next;
	}

	return false;
}

//This is a simple list of codes which serve as exceptions to No Keypad Cheese
//See here for a full list. https://deusex.fandom.com/wiki/Passwords,_Logins,_and_Codes_(DX)
function bool GetExceptedCode(string code)
{
    code = Caps(code);
	return code == "CALVO" //Alex Jacobson computer password on the wall next to his computer
        || code == "BIONICMAN" //we get our code as soon as we enter our office, but it takes a little bit. Fix it not working when we should know it
        || code == "INSURGENT" //maggie chows code can only be guessed, never found, but is designed that way.
        //|| code == "2167" //Only displayed in a computer message, so we never get a note for it //NOW RANDOMISED
        || code == "718" //Can only be guessed based on cryptic information
        || code == "7243" //We are only given 3 digits, need to guess the 4th
        || code == "WYRDRED08" //We are not given the last digit
        || (code == "1966" && FlagBase.GetBool('GaveCassandraMoney')) //Only given in conversation, no note
        //|| code == "1966" //Only given in conversation, no note
        || code == "4321"; //We are told to "count backwards from 4"
}

//"Security" is a commonly used word in many logs.
//It's also a login for a lot of computers.
//But none of the computers with that username have in-game logs
//So anything with security as the username needs to be ignored
function bool EvilUsernameHack(string username)
{
    return (Caps(username) == "SECURITY") && iNoKeypadCheese > 0;
}

// ----------------------------------------------------------------------
// GetNote()
//
// Loops through the notes and searches for the TextTag passed in
// ----------------------------------------------------------------------

function DeusExNote GetNote(Name textTag)
{
	local DeusExNote note;

	note = FirstNote;

	while( note != None )
	{
		if (note.textTag == textTag)
			break;

		note = note.next;
	}

	return note;
}

// ----------------------------------------------------------------------
// DeleteNote()
//
// Deletes the specified note
// Returns True if the note successfully deleted
// SARGE: This has been replaced with simply hiding notes instead
// ----------------------------------------------------------------------

function Bool DeleteNote( DeusExNote noteToDelete )
{
	local DeusExNote note;
	local DeusExNote previousNote;
	local Bool bNoteDeleted;

	bNoteDeleted = False;
	note = FirstNote;
	previousNote = None;

	while( note != None )
	{
		if ( note == noteToDelete )
		{
            // SARGE: This has been replaced with simply hiding notes instead
            note.SetHidden(true);
            /*
			if ( note == FirstNote )
				FirstNote = note.next;

			if ( note == LastNote )
				LastNote = previousNote;

			if ( previousNote != None )
				previousNote.next = note.next;

			note = None;

            */
			note = None;
			bNoteDeleted = True;
			break;
		}
		previousNote = note;
		note = note.next;
	}

	return bNoteDeleted;
}

// ----------------------------------------------------------------------
// DeleteAllNotes()
//
// Deletes *ALL* Notes
// ----------------------------------------------------------------------

function DeleteAllNotes()
{
	local DeusExNote note;
	local DeusExNote noteNext;

	note = FirstNote;

	while( note != None )
	{
		noteNext = note.next;
		DeleteNote(note);
		note = noteNext;
	}

	FirstNote = None;
	LastNote = None;
}

// ----------------------------------------------------------------------
// NoteAdd()
// ----------------------------------------------------------------------

exec function NoteAdd( String noteText, optional bool bUserNote, optional bool bHidden, optional name noteName )
{
	local DeusExNote newNote;

	newNote = AddNote( noteText, bUserNote, !bHidden );
	newNote.SetHidden( bHidden );
	newNote.SetTextTag( noteName );
}

// ----------------------------------------------------------------------
// AddGoal()
//
// Adds a new goal to the list of goals the player is carrying around.
// ----------------------------------------------------------------------

function DeusExGoal AddGoal( Name goalName, bool bPrimaryGoal )
{
	local DeusExGoal newGoal;

	// First check to see if this goal already exists.  If so, we'll just
	// return it.  Otherwise create a new goal

	newGoal = FindGoal( goalName );

	if ( newGoal == None )
	{
		newGoal = new(Self) Class'DeusExGoal';
		newGoal.SetName( goalName );

		// Insert goal at the Top so goals are displayed in
		// Newest order first.
		if (FirstGoal == None)
			LastGoal  = newGoal;
		else
			newGoal.next = FirstGoal;

		FirstGoal    = newGoal;

		newGoal.SetPrimaryGoal( bPrimaryGoal );

		ClientMessage(GoalAdded);
		DeusExRootWindow(rootWindow).hud.msgLog.PlayLogSound(Sound'LogGoalAdded');
	}

	return newGoal;
}

// ----------------------------------------------------------------------
// FindGoal()
// ----------------------------------------------------------------------

function DeusExGoal FindGoal( Name goalName )
{
	local DeusExGoal goal;

	goal = FirstGoal;

	while( goal != None )
	{
		if ( goalName == goal.goalName )
			break;

		goal = goal.next;
	}

	return goal;
}

// ----------------------------------------------------------------------
// GoalAdd()
//
// Adds a new goal to the list of goals the player is carrying around.
// ----------------------------------------------------------------------

exec function GoalAdd( Name goalName, String goalText, optional bool bPrimaryGoal )
{
	local DeusExGoal newGoal;

	if (!bCheatsEnabled)
		return;

	newGoal = AddGoal( goalName, bPrimaryGoal );
	newGoal.SetText( goalText );
}

// ----------------------------------------------------------------------
// GoalSetPrimary()
//
// Sets a goal as a Primary Goal
// ----------------------------------------------------------------------

exec function GoalSetPrimary( Name goalName, bool bPrimaryGoal )
{
	local DeusExGoal goal;

	if (!bCheatsEnabled)
		return;

	goal = FindGoal( goalName );

	if ( goal != None )
		goal.SetPrimaryGoal( bPrimaryGoal );
}

// ----------------------------------------------------------------------
// GoalCompleted()
//
// Looks up the goal and marks it as completed.
// ----------------------------------------------------------------------

function GoalCompleted( Name goalName )
{
	local DeusExGoal goal;

	// Loop through all the goals until we hit the one we're
	// looking for.
	goal = FindGoal( goalName );

	if ( goal != None )
	{
		// Only mark a goal as completed once!
		if (!goal.IsCompleted())
		{
			goal.SetCompleted();
			DeusExRootWindow(rootWindow).hud.msgLog.PlayLogSound(Sound'LogGoalCompleted');

			// Let the player know
			if ( goal.bPrimaryGoal )
				ClientMessage(PrimaryGoalCompleted);
			else
				ClientMessage(SecondaryGoalCompleted);
		}
	}
}

// ----------------------------------------------------------------------
// DeleteGoal()
//
// Deletes the specified note
// Returns True if the note successfully deleted
// ----------------------------------------------------------------------

function Bool DeleteGoal( DeusExGoal goalToDelete )
{
	local DeusExGoal goal;
	local DeusExGoal previousGoal;
	local Bool bGoalDeleted;

	bGoalDeleted = False;
	goal = FirstGoal;
	previousGoal = None;

	while( goal != None )
	{
		if ( goal == goalToDelete )
		{
			if ( goal == FirstGoal )
				FirstGoal = goal.next;

			if ( goal == LastGoal )
				LastGoal = previousGoal;

			if ( previousGoal != None )
				previousGoal.next = goal.next;

			goal = None;

			bGoalDeleted = True;
			break;
		}
		previousGoal = goal;
		goal = goal.next;
	}

	return bGoalDeleted;
}

// ----------------------------------------------------------------------
// DeleteAllGoals()
//
// Deletes *ALL* Goals
// ----------------------------------------------------------------------

function DeleteAllGoals()
{
	local DeusExGoal goal;
	local DeusExGoal goalNext;

	goal = FirstGoal;

	while( goal != None )
	{
		goalNext = goal.next;
		DeleteGoal(goal);
		goal = goalNext;
	}

	FirstGoal = None;
	LastGoal = None;
}

// ----------------------------------------------------------------------
// ResetGoals()
//
// Called when progressing to the next mission.  Deletes all
// completed Primary Goals as well as *ALL* Secondary Goals
// (regardless of status)
// ----------------------------------------------------------------------

function ResetGoals()
{
	local DeusExGoal goal;
	local DeusExGoal goalNext;

	goal = FirstGoal;

	while( goal != None )
	{
		goalNext = goal.next;

		// Delete:
		// 1) Completed Primary Goals
		// 2) ALL Secondary Goals

		if ((!goal.IsPrimaryGoal()) || (goal.IsPrimaryGoal() && goal.IsCompleted()))
			DeleteGoal(goal);

		goal = goalNext;
	}
}

// ----------------------------------------------------------------------
// AddImage()
//
// Inserts a new image in the user's list of images.  First checks to
// make sure the player doesn't already have the image.  If not,
// sticks the image at the top of the list.
// ----------------------------------------------------------------------

function bool AddImage(DataVaultImage newImage)
{
	local DataVaultImage image;

	if (newImage == None)
		return False;

	// First make sure the player doesn't already have this image!!
	image = FirstImage;
	while(image != None)
	{
		if (newImage.imageDescription == image.imageDescription)
			return False;

		image = image.NextImage;
	}

	// If the player doesn't yet have an image, make this his
	// first image.
	newImage.nextImage = FirstImage;
	newImage.prevImage = None;

	if (FirstImage != None)
		FirstImage.prevImage = newImage;

	FirstImage = newImage;

	return True;
}

// ----------------------------------------------------------------------
// AddLog()
//
// Adds a log message to our FirstLog linked list
// ----------------------------------------------------------------------

function DeusExLog AddLog(String logText)
{
	local DeusExLog newLog;

	newLog = CreateLogObject();
	newLog.SetLogText(logText);

	// Add this Note to the list of player Notes
	if ( FirstLog != None )
		LastLog.next = newLog;
	else
		FirstLog = newLog;

	LastLog = newLog;

	return newLog;
}

// ----------------------------------------------------------------------
// ClearLog()
//
// Removes log objects
// ----------------------------------------------------------------------

function ClearLog()
{
	local DeusExLog log;
	local DeusExLog nextLog;

	log = FirstLog;

	while( log != None )
	{
		nextLog = log.next;
		CriticalDelete(log);
		log = nextLog;
	}

	FirstLog = None;
	LastLog  = None;
}

// ----------------------------------------------------------------------
// SetLogTimeout()
// ----------------------------------------------------------------------

function SetLogTimeout(Float newLogTimeout)
{
	logTimeout = newLogTimeout;

	// Update the HUD Log Display
	if (DeusExRootWindow(rootWindow).hud != None)
		DeusExRootWindow(rootWindow).hud.msgLog.SetLogTimeout(newLogTimeout);
}

// ----------------------------------------------------------------------
// GetLogTimeout()
// ----------------------------------------------------------------------

function Float GetLogTimeout()
{
	if (Level.NetMode == NM_Standalone)
	  return logTimeout;
	else
	  return (FMax(5.0,logTimeout));
}

// ----------------------------------------------------------------------
// SetMaxLogLines()
// ----------------------------------------------------------------------

function SetMaxLogLines(Byte newLogLines)
{
	maxLogLines = newLogLines;

	// Update the HUD Log Display
	if (DeusExRootWindow(rootWindow).hud != None)
		DeusExRootWindow(rootWindow).hud.msgLog.SetMaxLogLines(newLogLines);
}

// ----------------------------------------------------------------------
// GetMaxLogLines()
// ----------------------------------------------------------------------

function Byte GetMaxLogLines()
{
	return maxLogLines;
}

// ----------------------------------------------------------------------
// PopHealth() - This is used from the health screen (Medkits applied to body parts were not in sync with server)
// ----------------------------------------------------------------------

function PopHealth( float health0, float health1, float health2, float health3, float health4, float health5 )
{
	HealthHead     = health0;
	HealthTorso    = health1;
	HealthArmRight = health2;
	HealthArmLeft  = health3;
	HealthLegRight = health4;
	HealthLegLeft  = health5;
}

// ----------------------------------------------------------------------
// GenerateTotalHealth()
//
// this will calculate a weighted average of all of the body parts
// and put that value in the generic Health
// NOTE: head and torso are both critical
// ----------------------------------------------------------------------

function GenerateTotalHealth()
{
	local float ave, avecrit;
	//RSD: Fix max health calculation from Medicine skill, alcohol buff, zyme debuff
	local Skill sk;
	local float MedSkillAdd, headMult, torsoMult;

    MedSkillAdd = 0.0;
	if (SkillSystem!=None)
	{
	  sk = SkillSystem.GetSkillFromClass(Class'DeusEx.SkillMedicine');
	  if (sk!=None) MedSkillAdd=sk.CurrentLevel*10;
	}
    headMult = default.HealthHead/(default.HealthHead+MedSkillAdd);
    //SARGE: Instead of adding Zyme and Brunkenness manually, we now just call into the AddictionSystem's health boost function
    torsoMult = default.HealthTorso/(default.HealthTorso+MedSkillAdd+AddictionManager.GetTorsoHealthBonus());

	ave = (HealthLegLeft + HealthLegRight + HealthArmLeft + HealthArmRight) / 4.0;

	if ((HealthHead <= 0) || (HealthTorso <= 0))
		avecrit = 0;
	else
		avecrit = (headMult*HealthHead + torsoMult*HealthTorso) / 2.0;          //RSD: Added mults

	if (avecrit == 0)
		Health = 0;
	else
		Health = (ave + avecrit) / 2.0; //GMDX: TODO: check mini display for colouring etc, max value=115
}

function int GenerateTotalMaxHealth()                                           //RSD: need new function to correct for Med skill and new drug effects
{
	local float ave, avecrit;
	//RSD: Fix max health calculation from Medicine skill, alcohol buff, zyme debuff
	local Skill sk;
	local float MedSkillAdd, headMult, torsoMult;
	local int AddictionAdd;                                           //RSD: Now get bonus max torso health from drinking, penalty for zyme
	local int maxHealth;
    
    AddictionAdd = AddictionManager.GetTorsoHealthBonus();                         //RSD: Get 5 bonus health for every 2 min on timer

    MedSkillAdd = 0.0;
	if (SkillSystem!=None)
	{
	  sk = SkillSystem.GetSkillFromClass(Class'DeusEx.SkillMedicine');
	  if (sk!=None) MedSkillAdd=sk.CurrentLevel*10;
	}

    //SARGE: Was this intentionally commented out????
    //headMult = default.HealthHead/(default.HealthHead+MedSkillAdd);
    //torsoMult = default.HealthTorso/(default.HealthTorso+MedSkillAdd+AddictionAdd);

	ave = (default.HealthLegLeft + default.HealthLegRight + default.HealthArmLeft + default.HealthArmRight) / 4.0;

	if ((default.HealthHead <= 0) || (default.HealthTorso <= 0))
		avecrit = 0;
	else
		avecrit = (default.HealthHead + default.HealthTorso) / 2.0; //RSD: Added mults //SARGE: Was this intentionally not using mults, or did I break something??

	if (avecrit == 0)
		maxHealth = 0;
	else
		maxHealth = (ave + avecrit) / 2.0; //GMDX: TODO: check mini display for colouring etc, max value=115
	return maxHealth;
}

// ----------------------------------------------------------------------
// MultiplayerDeathMsg()
// ----------------------------------------------------------------------
function MultiplayerDeathMsg( Pawn killer, bool killedSelf, bool valid, String killerName, String killerMethod )
{
	local MultiplayerMessageWin	mmw;
	local DeusExRootWindow			root;

	myKiller = killer;
	if ( killProfile != None )
	{
		killProfile.bKilledSelf = killedSelf;
		killProfile.bValid = valid;
	}
	root = DeusExRootWindow(rootWindow);
	if ( root != None )
	{
		mmw = MultiplayerMessageWin(root.InvokeUIScreen(Class'MultiplayerMessageWin', True));
		if ( mmw != None )
		{
			mmw.bKilled = true;
			mmw.killerName = killerName;
			mmw.killerMethod = killerMethod;
			mmw.bKilledSelf = killedSelf;
			mmw.bValidMethod = valid;
		}
	}
}

function ShowProgress()
{
	local MultiplayerMessageWin	mmw;
	local DeusExRootWindow			root;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
	{
	  if (root.GetTopWindow() != None)
		 mmw = MultiplayerMessageWin(root.GetTopWindow());

	  if ((mmw != None) && (mmw.bDisplayProgress == false))
	  {
		 mmw.Destroy();
		 mmw = None;
	  }
	  if ( mmw == None )
	  {
		 mmw = MultiplayerMessageWin(root.InvokeUIScreen(Class'MultiplayerMessageWin', True));
		 if ( mmw != None )
		 {
			mmw.bKilled = false;
			mmw.bDisplayProgress = true;
			mmw.lockoutTime = Level.TimeSeconds + 0.2;
		 }
	  }
	}
}

// ----------------------------------------------------------------------
// ServerConditionalNoitfyMsg
// ----------------------------------------------------------------------

function ServerConditionalNotifyMsg( int code, optional int param, optional string str )
{
	switch( code )
	{
		case MPMSG_FirstPoison:
			if ( (mpMsgServerFlags & MPSERVERFLAG_FirstPoison) == MPSERVERFLAG_FirstPoison )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_FirstPoison;
			break;
		case MPMSG_FirstBurn:
			if ( (mpMsgServerFlags & MPSERVERFLAG_FirstBurn) == MPSERVERFLAG_FirstBurn )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_FirstBurn;
			break;
		case MPMSG_TurretInv:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_TurretInv ) == MPSERVERFLAG_TurretInv )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_TurretInv;
			break;
		case MPMSG_CameraInv:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_CameraInv ) == MPSERVERFLAG_CameraInv )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_CameraInv;
			break;
		case MPMSG_LostLegs:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_LostLegs) == MPSERVERFLAG_LostLegs )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_LostLegs;
			break;
		case MPMSG_DropItem:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_DropItem) == MPSERVERFLAG_DropItem )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_DropItem;
			break;
		case MPMSG_NoCloakWeapon:
			if ( ( mpMsgServerFlags & MPSERVERFLAG_NoCloakWeapon) == MPSERVERFLAG_NoCloakWeapon )
				return;
			else
				mpMsgServerFlags = mpMsgServerFlags | MPSERVERFLAG_NoCloakWeapon;
			break;
	}
	// If we made it here we need to notify
	MultiplayerNotifyMsg( code, param, str );
}

// ----------------------------------------------------------------------
// MultiplayerNotifyMsg()
// ----------------------------------------------------------------------
function MultiplayerNotifyMsg( int code, optional int param, optional string str )
{
	if ( !bHelpMessages )
	{
		switch( code )
		{
			case MPMSG_TeamUnatco:
			case MPMSG_TeamNsf:
			case MPMSG_TeamHit:
			case MPMSG_TeamSpot:
			case MPMSG_FirstPoison:
			case MPMSG_FirstBurn:
			case MPMSG_TurretInv:
			case MPMSG_CameraInv:
			case MPMSG_LostLegs:
			case MPMSG_DropItem:
			case MPMSG_KilledTeammate:
			case MPMSG_TeamLAM:
			case MPMSG_TeamComputer:
			case MPMSG_NoCloakWeapon:
			case MPMSG_TeamHackTurret:
				return;		// Pass on these
			case MPMSG_CloseKills:
			case MPMSG_TimeNearEnd:
				break;		// Go ahead with these
		}
	}

	switch( code )
	{
		case MPMSG_TeamSpot:
			if ( (mpMsgFlags & MPFLAG_FirstSpot) == MPFLAG_FirstSpot )
				return;
			else
				mpMsgFlags = mpMsgFlags | MPFLAG_FirstSpot;
			break;
		case MPMSG_CloseKills:
			if ((param == 0) || (str ~= ""))
			{
				log("Warning: Passed bad params to multiplayer notify msg." );
				return;
			}
			mpMsgOptionalParam = param;
			mpMsgOptionalString = str;
			break;
		case MPMSG_TimeNearEnd:
			if ((param == 0) || (str ~= ""))
			{
				log("Warning: Passed bad params to multiplayer notify msg." );
				return;
			}
			mpMsgOptionalParam = param;
			mpMsgOptionalString = str;
			break;
		case MPMSG_DropItem:
		case MPMSG_TeamUnatco:
		case MPMSG_TeamNsf:
			if (( DeusExRootWindow(rootWindow) != None ) && ( DeusExRootWindow(rootWindow).hud != None ) && (DeusExRootWindow(rootWindow).hud.augDisplay != None ))
				DeusExRootWindow(rootWindow).hud.augDisplay.RefreshMultiplayerKeys();
			break;
	}
	mpMsgCode = code;
  	mpMsgTime = Level.Timeseconds + mpMsgDelay;
	if (( code == MPMSG_TeamUnatco ) || ( code == MPMSG_TeamNsf ))
		mpMsgTime += 2.0;
}


//
// GetSkillInfoFromProjKiller
//
function GetSkillInfoFromProj( DeusExPlayer killer, Actor proj )
{
	local class<Skill> skillClass;

	if ( proj.IsA('GasGrenade') || proj.IsA('LAM') || proj.IsA('EMPGrenade') || proj.IsA('TearGas'))
		skillClass = class'SkillDemolition';
	else if ( proj.IsA('Rocket') || proj.IsA('RocketLAW') || proj.IsA('RocketWP') || proj.IsA('Fireball') || proj.IsA('PlasmaBolt'))
		skillClass = class'SkillWeaponHeavy';
	else if ( proj.IsA('Dart') || proj.IsA('DartFlare') || proj.IsA('DartPoison') || proj.IsA('Shuriken'))
		skillClass = class'SkillWeaponLowTech';
	else if ( proj.IsA('HECannister20mm') || proj.IsA('SpiderConstructorLaunched2') || proj.IsA('RubberBullet'))
		skillClass = class'SkillWeaponRifle';
	else if ( proj.IsA('DeusExDecoration') )
	{
		killProfile.activeSkill = NoneString;
		killProfile.activeSkillLevel = 0;
		return;
	}
	if ( killer.SkillSystem != None )
	{
		killProfile.activeSkill = skillClass.Default.skillName;
		killProfile.activeSkillLevel = killer.SkillSystem.GetSkillLevel(skillClass);
	}
}

function GetWeaponName( DeusExWeapon w, out String name )
{
	if ( w != None )
	{
		if ( WeaponGEPGun(w) != None )
			name = WeaponGEPGun(w).shortName;
		else if ( WeaponLAM(w) != None )
			name = WeaponLAM(w).shortName;
		else
			name = w.itemName;
	}
	else
		name = NoneString;
}

//
// CreateKillerProfile
//
function CreateKillerProfile( Pawn killer, int damage, name damageType, String bodyPart )
{
	local DeusExPlayer pkiller;
	local DeusExProjectile proj;
	local DeusExDecoration decProj;
	local Augmentation anAug;
	local int augCnt;
	local DeusExWeapon w;
	local Skill askill;
	local String wShortString;

	if ( killProfile == None )
	{
		log("Warning:"$Self$" has a killProfile that is None!" );
		return;
	}
	else
		killProfile.Reset();

	pkiller = DeusExPlayer(killer);

	if ( pkiller != None )
	{
		killProfile.bValid = True;
		killProfile.name = pkiller.PlayerReplicationInfo.PlayerName;
		w = DeusExWeapon(pkiller.inHand);
		GetWeaponName( w, killProfile.activeWeapon );

		// What augs the killer was using
		if ( pkiller.AugmentationSystem != None )
		{
			killProfile.numActiveAugs = pkiller.AugmentationSystem.NumAugsActive();
			augCnt = 0;
			anAug = pkiller.AugmentationSystem.FirstAug;
			while ( anAug != None )
			{
				if ( anAug.bHasIt && anAug.bIsActive && !anAug.bAlwaysActive && (augCnt < ArrayCount(killProfile.activeAugs)))
				{
					killProfile.activeAugs[augCnt] = anAug.augmentationName;
					augCnt += 1;
				}
				anAug = anAug.next;
			}
		}
		else
			killProfile.numActiveAugs = 0;

		// My weapon and skill
		GetWeaponName( DeusExWeapon(inHand), killProfile.myActiveWeapon );
		if ( DeusExWeapon(inHand) != None )
		{
			if ( SkillSystem != None )
			{
				askill = SkillSystem.GetSkillFromClass(DeusExWeapon(inHand).GoverningSkill);
				killProfile.myActiveSkill = askill.skillName;
				killProfile.myActiveSkillLevel = askill.CurrentLevel;
			}
		}
		else
		{
			killProfile.myActiveWeapon = NoneString;
			killProfile.myActiveSkill = NoneString;
			killProfile.myActiveSkillLevel = 0;
		}
		// Fill in my own active augs
		if ( AugmentationSystem != None )
		{
			killProfile.myNumActiveAugs = AugmentationSystem.NumAugsActive();
			augCnt = 0;
			anAug = AugmentationSystem.FirstAug;
			while ( anAug != None )
			{
				if ( anAug.bHasIt && anAug.bIsActive && !anAug.bAlwaysActive && (augCnt < ArrayCount(killProfile.myActiveAugs)))
				{
					killProfile.myActiveAugs[augCnt] = anAug.augmentationName;
					augCnt += 1;
				}
				anAug = anAug.next;
			}
		}
		killProfile.streak = (pkiller.PlayerReplicationInfo.Streak + 1);
		killProfile.healthLow = pkiller.HealthLegLeft;
		killProfile.healthMid =  pkiller.HealthTorso;
		killProfile.healthHigh = pkiller.HealthHead;
		killProfile.remainingBio = pkiller.Energy;
		killProfile.damage = damage;
		killProfile.bodyLoc = bodyPart;
		killProfile.killerLoc = pkiller.Location;
	}
	else
	{
		killProfile.bValid = False;
		return;
	}

	killProfile.methodStr = NoneString;

	switch( damageType )
	{
		case 'AutoShot':
			killProfile.methodStr = WithTheString $ AutoTurret(myTurretKiller).titleString  $ "!";
			killProfile.bTurretKilled = True;
			killProfile.killerLoc = AutoTurret(myTurretKiller).Location;
			if ( pkiller.SkillSystem != None )
			{
				killProfile.activeSkill = class'SkillComputer'.Default.skillName;
				killProfile.activeSkillLevel = pkiller.SkillSystem.GetSkillLevel(class'SkillComputer');
			}
			break;
		case 'PoisonEffect':
			killProfile.methodStr = PoisonString $ "!";
			killProfile.bPoisonKilled = True;
			killProfile.activeSkill = NoneString;
			killProfile.activeSkillLevel = 0;
			break;
		case 'Burned':
		case 'Flamed':
			if (( WeaponPlasmaRifle(w) != None ) || ( WeaponFlamethrower(w) != None ))
			{
				// Use the weapon if it's still in hand
			}
			else
			{
				killProfile.methodStr = BurnString $ "!";
				killProfile.bBurnKilled = True;
				killProfile.activeSkill = NoneString;
				killProfile.activeSkillLevel = 0;
			}
			break;
	}
	if ( killProfile.methodStr ~= NoneString )
	{
		proj = DeusExProjectile(myProjKiller);
		decProj = DeusExDecoration(myProjKiller);

		if (( killer != None ) && (proj != None) && (!(proj.itemName ~= "")) )
		{
			if ( (LAM(myProjKiller) != None) && (LAM(myProjKiller).bProximityTriggered) )
			{
				killProfile.bProximityKilled = True;
				killProfile.killerLoc = LAM(myProjKiller).Location;
				killProfile.myActiveSkill = class'SkillDemolition'.Default.skillName;
				if ( SkillSystem != None )
					killProfile.myActiveSkillLevel = SkillSystem.GetSkillLevel(class'SkillDemolition');
				else
					killProfile.myActiveSkillLevel = 0;
			}
			else
				killProfile.bProjKilled = True;
			killProfile.methodStr = WithString $ proj.itemArticle $ " " $ proj.itemName $ "!";
			GetSkillInfoFromProj( pkiller, myProjKiller );
		}
		else if (( killer != None ) && ( decProj != None ) && (!(decProj.itemName ~= "" )) )
		{
			killProfile.methodStr = WithString $ decProj.itemArticle $ " " $ decProj.itemName $ "!";
			killProfile.bProjKilled = True;
			GetSkillInfoFromProj( pkiller, myProjKiller );
		}
		else if ((killer != None) && (w != None))
		{
			GetWeaponName( w, wShortString );
			killProfile.methodStr = WithString $ w.itemArticle $ " " $ wShortString $ "!";
			askill = pkiller.SkillSystem.GetSkillFromClass(w.GoverningSkill);
			killProfile.activeSkill = askill.skillName;
			killProfile.activeSkillLevel = askill.CurrentLevel;
		}
		else
			log("Warning: Failed to determine killer method killer:"$killer$" damage:"$damage$" damageType:"$damageType$" " );
	}
	// If we still failed dump this to log, and I'll see if there's a condition slipping through...
	if ( killProfile.methodStr ~= NoneString )
	{
		log("===>Warning: Failed to get killer method:"$Self$" damageType:"$damageType$" " );
		killProfile.bValid = False;
	}
}

// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
	local int actualDamage;
	local bool bAlreadyDead, bPlayAnim, bDamageGotReduced;
	local Vector offset, dst;
	local float headOffsetZ, headOffsetY, armOffset;
	local float origHealth, fdst;
	local DeusExLevelInfo info;
	local DeusExWeapon dxw;
	local BallisticArmor armor;
	local String bodyString;
	local int MPHitLoc;
	local GMDXFlickerLight lightFlicker;
    local float augLVL, skillLevel;
    local DeusExRootWindow root;
    local GMDXImpactSpark AST;

	if ( bNintendoImmunity || ReducedDamageType == 'All')
		return;

	bodyString = "";
	origHealth = Health;

	if (Level.NetMode != NM_Standalone)
	  Damage *= MPDamageMult;
	else if (damageType=='Drowned')
	{
	  if (PerkManager.GetPerkWithClass(class'DeusEx.PerkPerserverance').bPerkObtained == false)
	      drugEffectTimer += 3.5; //freak player :)
	  if (combatDifficulty < 3)
         Damage=6;
      else
         Damage=12; //GMDX mod drowning damage, take that hard coded 5hpts
	}

	//CyberP: now we also reduce all other damage types based on difficulty.
    //CyberP: easy = reduced by half. Medium & hard = 1/4. Hardcore & realistic = No reduction
	    if (CombatDifficulty < 1)
		    Damage *= 0.5;
		else if (CombatDifficulty < 3)
		    Damage *= 0.75;


//log("MYCHK DXP_TD:"@self@"take damage in state"@GetStateName()@" : "@Damage@" : "@damageType@" : "@instigatedBy);

	// use the hitlocation to determine where the pawn is hit
	// transform the worldspace hitlocation into objectspace
	// in objectspace, remember X is front to back
	// Y is side to side, and Z is top to bottom
	offset = (hitLocation - Location) << Rotation;

	// add a HUD icon for this damage type
	if ((damageType == 'Poison') || (damageType == 'PoisonEffect'))  // hack
		AddDamageDisplay('PoisonGas', offset);
	else
		AddDamageDisplay(damageType, offset);

	// nanovirus damage doesn't affect us
	if (damageType == 'NanoVirus')
	{
        NanoVirusTimer += float(Damage);                                        //RSD: Actually it does, it makes augs unusable for as many seconds as damage taken
		AugmentationSystem.DeactivateAll(true);
		NanoVirusTicks = 0;                                                     //RSD: Awful hack
		bNanoVirusSentMessage = false;                                          //RSD: Awful hack
        return;
	}

	// handle poison
	if ((damageType == 'Poison') || ((Level.NetMode != NM_Standalone) && (damageType=='TearGas')) )
	{
		// Notify player if they're getting burned for the first time
		if ( Level.NetMode != NM_Standalone )
			ServerConditionalNotifyMsg( MPMSG_FirstPoison );

		StartPoison( instigatedBy, Damage );
	}

	// reduce our damage correctly
	if (ReducedDamageType == damageType)
		actualDamage = float(actualDamage) * (1.0 - ReducedDamagePct);

	// check for augs or inventory items
	bDamageGotReduced = DXReduceDamage(Damage, damageType, hitLocation, actualDamage, False);

    //broadcastmessage(actualdamage);                                           //RSD

	/// DEUS_EX AMSD Multiplayer shield
	if (Level.NetMode != NM_Standalone)
	  if (bDamageGotReduced)
	  {
		 ShieldStatus = SS_Strong;
		 ShieldTimer = 1.0;
	  }

    //CyberP: add flinch effects
    if ((DamageType == 'Shot' || DamageType == 'AutoShot' || DamageType == 'Shocked'))
    {
       if (inHand != None && inHand.IsA('DeusExWeapon') && !DeusExWeapon(inHand).bAimingDown && !DeusExWeapon(inHand).bFiring && FRand() < 0.18)
       {
       if (AugmentationSystem != None)
			augLVL = AugmentationSystem.GetAugLevelValue(class'AugBallistic');
         if (AugmentationSystem != None && augLVL >= 0.0)
         {
         }
         else
         {
        RecoilTime=default.RecoilTime;
        RecoilShake.Z-=lerp(min(Abs(ActualDamage),2.0*ActualDamage)/(1.0*ActualDamage),0,3.0); //CyberP: 7
		RecoilShake.Y-=lerp(min(Abs(ActualDamage),2.0*ActualDamage)/(1.0*ActualDamage),0,2.0);
		RecoilShaker(vect(1,2,-2));
         }
       }
       if (inHand != None && inHand.IsA('WeaponSword'))
        {
          if ((DamageType == 'Shot' || DamageType == 'AutoShot') && FRand() < 0.05)
           {
           PlaySound(sound'bouncemetal',SLOT_None);
           actualDamage = 0;
           return;
           }
        }
    }
	// Multiplayer only code
	if ( Level.NetMode != NM_Standalone )
	{
		if ( ( instigatedBy != None ) && (instigatedBy.IsA('DeusExPlayer')) )
		{
			// Special case the sniper rifle
			if ((DeusExPlayer(instigatedBy).Weapon != None) && ( DeusExPlayer(instigatedBy).Weapon.class == class'WeaponRifle' ))
			{
				dxw = DeusExWeapon(DeusExPlayer(instigatedBy).Weapon);
				if ( (dxw != None ) && ( !dxw.bZoomed ))
					actualDamage *= WeaponRifle(dxw).mpNoScopeMult; // Reduce damage if we're not using the scope
			}
			if ( (TeamDMGame(DXGame) != None) && (TeamDMGame(DXGame).ArePlayersAllied(DeusExPlayer(instigatedBy),Self)) )
			{
				// Don't notify if the player hurts themselves
				if ( DeusExPlayer(instigatedBy) != Self )
				{
					actualDamage *= TeamDMGame(DXGame).fFriendlyFireMult;
					if (( damageType != 'TearGas' ) && ( damageType != 'PoisonEffect' ))
						DeusExPlayer(instigatedBy).MultiplayerNotifyMsg( MPMSG_TeamHit );
				}
			}

		}
	}

	// EMP attacks drain BE energy
	if (damageType == 'EMP')
	{
		EnergyDrain += actualDamage;
		EnergyDrainTotal += actualDamage;
		PlayTakeHitSound(actualDamage, damageType, 1);
		if ((damageType == 'EMP') && (damage > 25))
		{
		PlaySound(sound'CloakDown', SLOT_None,,,,2.0);
        PlaySound(sound'tinnitus', SLOT_None,0.6);
        ClientFlash(800000,vect(255,255,255));
        IncreaseClientFlashLength(4);
        //ShowHud(false);                                                       //RSD: Removed HUD crap from EMP
		return;
	    }
    }

	if (instigatedBy.IsA('DeusExPlayer') && (damageType == 'Exploded' || damageType == 'Burned') && PerkManager.GetPerkWithClass(class'DeusEx.PerkBlastPadding').bPerkObtained == true)	// Trash: Less damage if you're wearing a vest and you have Blast Padding
	{
		if (UsingChargedPickup(class'BallisticArmor'))
		{
			skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
			actualDamage *= PerkManager.GetPerkWithClass(class'DeusEx.PerkBlastPadding').PerkValue; //GMDX: removed too easy * skillLevel; //CyberP: foreach durable armor
			foreach AllActors(class'BallisticArmor', armor)
			{
				if ((armor.Owner == Self) && armor.bActive)
					armor.Charge -= (Damage * 4 * skillLevel);
				if (armor.Charge < 0)                                       //RSD: Don't go below zero
				{
					armor.Charge = 0;
					armor.UsedUp();                                         //RSD: Otherwise doesn't deactivate properly
				}
			}
		}
	}

    if (damageType == 'Exploded' || damageType == 'Shocked')
    {
       if (AugmentationSystem != None)
       {
         if (AugmentationSystem.GetAugLevelValue(class'AugShield') == -1.0)// && PerkNamesArray[6] != 1) //RSD: Meh, no more steady-footed perk (who got this?)
         {
           //SetTimer(0.4,false); //SARGE: Replaced with stuntedTime variable
            if (stuntedTime < 0.4)
                stuntedTime = 0.4;
         }
       }
    }

	bPlayAnim = True;

	// if we're burning, don't play a hit anim when taking burning damage
	if (damageType == 'Burned')
		bPlayAnim = False;

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = 0.4 * VSize(momentum);
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;
	//	AddVelocity( momentum ); 	// doesn't do anything anyway

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.78;
	headOffsetY = CollisionRadius * 0.35;
	armOffset = CollisionRadius * 0.35;

	// We decided to just have 3 hit locations in multiplayer MBCODE
	if (( Level.NetMode == NM_DedicatedServer ) || ( Level.NetMode == NM_ListenServer ))
	{
		MPHitLoc = GetMPHitLocation(HitLocation);

		if (MPHitLoc == 0)
			return;
		else if (MPHitLoc == 1 )
		{
			// MP Headshot is 2x damage
			// narrow the head region
			actualDamage *= 2;
			HealthHead -= actualDamage;
			bodyString = HeadString;
			if (bPlayAnim)
				PlayAnim('HitHead', , 0.1);
		}
		else if ((MPHitLoc == 3) || (MPHitLoc == 4))	// Leg region
		{
			HealthLegRight -= actualDamage;
			HealthLegLeft -= actualDamage;

			if (MPHitLoc == 4)
			{
				if (bPlayAnim)
					PlayAnim('HitLegRight', , 0.1);
			}
			else if (MPHitLoc == 3)
			{
				if (bPlayAnim)
					PlayAnim('HitLegLeft', , 0.1);
			}
			// Since the legs are in sync only bleed up damage from one leg (otherwise it's double damage)
			if (HealthLegLeft < 0)
			{
				HealthArmRight += HealthLegLeft;
				HealthTorso += HealthLegLeft;
				HealthArmLeft += HealthLegLeft;
				bodyString = TorsoString;
				HealthLegLeft = 0;
				HealthLegRight = 0;
			}
		}
		else // arms and torso now one region
		{
			HealthArmLeft -= actualDamage;
			HealthTorso -= actualDamage;
			HealthArmRight -= actualDamage;

			bodyString = TorsoString;

			if (MPHitLoc == 6)
			{
				if (bPlayAnim)
					PlayAnim('HitArmRight', , 0.1);
			}
			else if (MPHitLoc == 5)
			{
				if (bPlayAnim)
					PlayAnim('HitArmLeft', , 0.1);
			}
			else
			{
				if (bPlayAnim)
					PlayAnim('HitTorso', , 0.1);
			}
		}
	}
	else // Normal damage code path for single player
	{
		if (offset.z > headOffsetZ)		// head
		{
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
			{
				if (damageType == 'Burned' || damageType == 'Exploded')	// Trash: Less damage from plasma and explosions
				HealthHead -= actualDamage * 1;
				else
				HealthHead -= actualDamage * 2;
				if (bPlayAnim)
					PlayAnim('HitHead', , 0.1);
					// elec effect
	if (damageType == 'Shocked' && AST == None)
	{
	root = DeusExRootWindow(rootWindow);
		if ((root != None) && (root.hud != None))
		{
			if (root.hud.background == None)
			{

				root.hud.SetBackground(Texture'Wepn_Prod_FX');
				//root.hud.SetBackgroundSmoothing(True);
				root.hud.SetBackgroundStretching(True);
				root.hud.SetBackgroundStyle(DSTY_Translucent);
				AST=Spawn(class'GMDXImpactSpark');
          if (AST != None)
          {
          AST.LifeSpan=4.000000;
          AST.DrawScale=0.000001;
          AST.Velocity=vect(0,0,0);
          AST.AmbientSound=Sound'Ambient.Ambient.Electricity3';
          AST.SoundVolume=224;
          AST.SoundRadius=64;
          AST.SoundPitch=80;
		  }
			}
		}
    }
			}
		}
		else if (offset.z < 0.0)	// legs
		{
			if (offset.y > 0.0)
			{
				HealthLegRight -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitLegRight', , 0.1);
			}
			else
			{
				HealthLegLeft -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitLegLeft', , 0.1);
			}

 			// if this part is already dead, damage the adjacent part
			if ((HealthLegRight < 0) && (HealthLegLeft > 0))
			{
				HealthLegLeft += HealthLegRight;
				HealthLegRight = 0;
			}
			else if ((HealthLegLeft < 0) && (HealthLegRight > 0))
			{
				HealthLegRight += HealthLegLeft;
				HealthLegLeft = 0;
			}

			if (HealthLegLeft < 0)
			{
				HealthTorso += HealthLegLeft;
				HealthLegLeft = 0;
			}
			if (HealthLegRight < 0)
			{
				HealthTorso += HealthLegRight;
				HealthLegRight = 0;
			}
		}
		else						// arms and torso
		{
			if (offset.y > armOffset)
			{
				HealthArmRight -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitArmRight', , 0.1);
			}
			else if (offset.y < -armOffset)
			{
				HealthArmLeft -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitArmLeft', , 0.1);
			}
			else
			{
				if (damageType == 'Burned' || damageType == 'Exploded')	// Trash: Less damage from plasma and explosions
				HealthTorso -= actualDamage * 1;
				else
				HealthTorso -= actualDamage * 2;
				if (bPlayAnim)
				{
                PlayAnim('HitTorso', , 0.1);
                }
			}

			// if this part is already dead, damage the adjacent part
			if (HealthArmLeft < 0)
			{
				HealthTorso += HealthArmLeft;
				HealthArmLeft = 0;
			}
			if (HealthArmRight < 0)
			{
				HealthTorso += HealthArmRight;
				HealthArmRight = 0;
			}
		}
	}

	// check for a back hit and play the correct anim
	if ((offset.x < 0.0) && bPlayAnim)
	{
		if (offset.z > headOffsetZ)		// head from the back
		{
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
				PlayAnim('HitHeadBack', , 0.1);
		}
		else
			PlayAnim('HitTorsoBack', , 0.1);
	}

	// check for a water hit
	if (Region.Zone.bWaterZone)
	{
		if ((offset.x < 0.0) && bPlayAnim)
			PlayAnim('WaterHitTorsoBack',,0.1);
		else
			PlayAnim('WaterHitTorso',,0.1);
	}

	GenerateTotalHealth();

	if ((damageType != 'Stunned') && (damageType != 'TearGas') && (damageType != 'HalonGas') &&
	    (damageType != 'PoisonGas') && (damageType != 'Radiation') && (damageType != 'EMP') &&
	    (damageType != 'NanoVirus') && (damageType != 'Drowned') && (damageType != 'KnockedOut'))
		bleedRate += (origHealth-Health)/30.0;  // 30 points of damage = bleed profusely

	if (CarriedDecoration != None)
        if (FRand() < 0.3 && AugmentationSystem.GetAugLevelValue(class'AugMuscle') < 2 && Damage > 0)
           DropDecoration();

	// don't let the player die in the training mission
	info = GetLevelInfo();
	if ((info != None) && (info.MissionNumber == 0))
	{
		if (Health <= 0)
		{
			HealthTorso = FMax(HealthTorso, 10);
			HealthHead = FMax(HealthHead, 10);
			GenerateTotalHealth();
		}
	}

	if (Health > 0)
	{
		if ((Level.NetMode != NM_Standalone) && (HealthLegLeft==0) && (HealthLegRight==0))
			ServerConditionalNotifyMsg( MPMSG_LostLegs );

		if (instigatedBy != None)
			damageAttitudeTo(instigatedBy);
		PlayDXTakeDamageHit(actualDamage, hitLocation, damageType, momentum, bDamageGotReduced);
		AISendEvent('Distress', EAITYPE_Visual);
	}
	else
	{
		NextState = '';
		if (inHand != None && FRand() < 0.3)
		   if (info != None && info.missionNumber != 4) //HACK: Not on mission 4 as player is revived in mj12 lab
		      DropItem();
		PlayDeathHit(actualDamage, hitLocation, damageType, momentum);
		if ( Level.NetMode != NM_Standalone )
			CreateKillerProfile( instigatedBy, actualDamage, damageType, bodyString );
		if (DamageType == 'Exploded')   //CyberP: always gib to explosives
		{
            Health = -1000;
            Spawn(class'FleshFragmentSmoking');
            Spawn(class'FleshFragmentSmoking');
            Spawn(class'FleshFragmentSmoking');
            Spawn(class'FleshFragmentSmoking');
            Spawn(class'FleshFragmentSmoking');
        }
        else if (DamageType == 'Burned' && instigatedBy.Weapon != None && (instigatedBy.Weapon.IsA('WeaponHideAGun') || instigatedBy.Weapon.IsA('WeaponPlasmaRifle') || instigatedBy.Weapon.IsA('WeaponRobotPlasmaGun')))
        {
            Health = -1000;
            Spawn(class'FleshFragmentSmoking');
            Spawn(class'FleshFragmentBurned');
            Spawn(class'FleshFragmentBurned');
            Spawn(class'FleshFragmentBurned');
            Spawn(class'FleshFragmentBurned');
            Spawn(class'FleshFragmentBurned');
            Spawn(class'FleshFragmentBurned');
            Spawn(class'FleshFragmentBurned');
            Spawn(class'FleshFragmentBurned');
        }
		else if ( actualDamage > mass )
			Health = -1 * actualDamage;
		Enemy = instigatedBy;
		Died(instigatedBy, damageType, HitLocation);
		return;
	}
	MakeNoise(1.0);

	if ((DamageType == 'Flamed') && !bOnFire)
	{
		// Notify player if they're getting burned for the first time
		if ( Level.NetMode != NM_Standalone )
			ServerConditionalNotifyMsg( MPMSG_FirstBurn );

		CatchFire( instigatedBy );
	}
	myProjKiller = None;
}

// ----------------------------------------------------------------------
// GetMPHitLocation()
// Returns 1 for head, 2 for torso, 3 for left leg, 4 for right leg, 5 for
// left arm, 6 for right arm, 0 for nothing.
// ----------------------------------------------------------------------
simulated function int GetMPHitLocation(Vector HitLocation)
{
	local float HeadOffsetZ;
	local float HeadOffsetY;
	local float ArmOffset;
	local vector Offset;

	offset = (hitLocation - Location) << Rotation;

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.78;
	headOffsetY = CollisionRadius * 0.35;
	armOffset = CollisionRadius * 0.35;

	if (offset.z > headOffsetZ )
	{
		// narrow the head region
		if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
		{
			// Headshot, return 1;
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else if (offset.z < 0.0)	// Leg region
	{
		if (offset.y > 0.0)
		{
			//right leg
			return 4;
		}
		else
		{
			//left leg
			return 3;
		}
	}
	else // arms and torso now one region
	{
		if (offset.y > armOffset)
		{
			return 6;
		}
		else if (offset.y < -armOffset)
		{
			return 5;
		}
		else
		{
			return 2;
		}
	}
	return 0;
}

// ----------------------------------------------------------------------
// DXReduceDamage()
//
// Calculates reduced damage from augmentations and from inventory items
// Also calculates a scalar damage reduction based on the mission number
// ----------------------------------------------------------------------
function bool DXReduceDamage(int Damage, name damageType, vector hitLocation, out int adjustedDamage, bool bCheckOnly)
{
	local float newDamage;
	local float augLevel, skillLevel, augLevel2;                                //RSD: Added augLevel2
	local float pct;
	local HazMatSuit suit;
	local BallisticArmor armor;
	local bool bReduced;
    local AugEnviro enviro;
    local AugAqualung lung;

	bReduced = False;
	newDamage = Float(Damage);

	if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'Radiation') ||
		(damageType == 'HalonGas')  || (damageType == 'PoisonEffect') || (damageType == 'Poison') ||
                	(damageType == 'Burned') || (damageType == 'Shocked'))
	{
	    if (DamageType != 'Shocked')
	    {
            if (bBoosterUpgrade && Energy > 0 && Damage > 0)
                    AugmentationSystem.AutoAugs(false,true);
            if (AugmentationSystem != None)
            {
                enviro = AugEnviro(AugmentationSystem.GetAug(class'AugEnviro'));
                augLevel = enviro.LevelValues[enviro.CurrentLevel];

                //Make sure we have enough energy
                //EDIT: This was based on damage tane, and still can be if you uncomment this. For now, use the old "20 per second" of the old aug.
                //if (enviro.bIsActive && augLevel >= 0.0 && Energy > 0 && Energy >= enviro.GetCustomEnergyRate(newDamage * 0.1))
                if (enviro.bIsActive && augLevel >= 0.0 && Energy > 0)
                {
                    //Only use energy once per 3 seconds, like the old aug
                    if (saveTime >= enviro.lastEnergyTick)
                    {
                        //Energy -= MAX(int(newDamage * 0.1),1);
                        Energy -= 1;
                        enviro.lastEnergyTick = saveTime + 3.0;
                    }
                    newDamage *= augLevel;
                }
            }
        }

		// get rid of poison if we're maxed out
		if (newDamage ~= 0.0)
		{
			StopPoison();
			drugEffectTimer -= 4;	// stop the drunk effect
			if (drugEffectTimer < 0)
				drugEffectTimer = 0;
		}

		// go through the actor list looking for owned HazMatSuits
		// since they aren't in the inventory anymore after they are used


	    if (UsingChargedPickup(class'HazMatSuit'))
        {
				skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
				newDamage *= 0.4;//0.75 * skillLevel;
				foreach AllActors(class'HazMatSuit', suit)
				{
			       if ((suit.Owner == Self) && suit.bActive)
			           suit.Charge -= (Damage * 16 * skillLevel);
			       if (suit.Charge < 0)                                         //RSD: Don't go below zero
			       {
                       suit.Charge = 0;
                       suit.UsedUp();                                           //RSD: Otherwise doesn't deactivate properly
			       }
				}
        }
        if (damageType == 'TearGas' || damageType == 'PoisonGas' || damageType == 'Poison' || damageType == 'PoisonEffect') //CyberP: gas grenades and poison barrels drain stamina. // Trash: Now with more damange types!
        {

            if (newDamage >= 1 && bStaminaSystem)
            {
				if (UsingChargedPickup(class'HazMatSuit') && PerkManager.GetPerkWithClass(class'DeusEx.PerkFilterUpgrade').bPerkObtained == true)
        		{
					// Trash: No stamina damage while wearing a hazmat suit and with the perk FilterUpgrade
        		}
				else
                {
                    //Aqualung now reduces stamina damage
                    augLevel = 1.0;
                    lung = AugAqualung(AugmentationSystem.GetAug(class'AugAqualung'));
                    if (lung.bIsActive)
                    {
                        augLevel = 2.0 - lung.LevelValues[lung.CurrentLevel];
                    }
                	swimTimer -= ((newDamage*0.4) + 3) * augLevel;
                    log("Stamina Damage AugLevel: " $ augLevel);
                }
				
                if (swimTimer < 0)
                    swimTimer = 0;
            }
        }
	}

	if ((damageType == 'Shot') || (damageType == 'Sabot') || (damageType == 'AutoShot'))
	{
		// go through the actor list looking for owned BallisticArmor
		// since they aren't in the inventory anymore after they are used
	  if (UsingChargedPickup(class'BallisticArmor'))
			{
                skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
				newDamage *= 0.65; //GMDX: removed too easy * skillLevel; //CyberP: foreach durable armor
				foreach AllActors(class'BallisticArmor', armor)
				{
			        if ((armor.Owner == Self) && armor.bActive)
			            {
							if (skillLevel == 1)
								armor.Charge -= (Damage * 16 * skillLevel);
							else
								armor.Charge -= (Damage * 32 * skillLevel);	// Trash: Nerfed
						}
                    if (armor.Charge < 0)                                       //RSD: Don't go below zero
                    {
                        armor.Charge = 0;
                        armor.UsedUp();                                         //RSD: Otherwise doesn't deactivate properly
                    }
                }
			}
	}

	if (damageType == 'HalonGas')
	{
		if (bOnFire && !bCheckOnly)
			ExtinguishFire();
	}

	if ((damageType == 'Shot') || (damageType == 'AutoShot') || (damageType == 'KnockedOut'))
	{
		if (AugmentationSystem != None) //CyberP: now includes ballistic passive aug
		{
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugBallistic');

			if (augLevel < 0.0 && Energy > 0.0) //this means we can't have both augs installed, and that for passive to work energy is required. //RSD: Actually it just means active overrides passive
			{
                augLevel = AugBallisticPassive(AugmentationSystem.GetAug(class'AugBallisticPassive')).GetDamageMod();
			}
			//augLevel *= AugmentationSystem.GetAugLevelValue(class'AugBallistic');//RSD: figure out stacking prots later maybe
        }

		if (augLevel > 0.0)
			newDamage *= augLevel;
	}

	//if (damageType == 'EMP')
	//{
	//	if (AugmentationSystem != None)
	//		augLevel = AugmentationSystem.GetAugLevelValue(class'AugEMP');
//
//		if (augLevel >= 0.0)
//			newDamage *= augLevel;
//	}

	if ((damageType == 'Burned') || (damageType == 'Flamed') ||
		(damageType == 'Exploded') || (damageType == 'Shocked') || (damageType == 'EMP'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugShield');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
		if (augLevel == 0.3)
            Spawn(class'SphereEffectShield2',,,(Location+vector(ViewRotation)*32));
	}

	if (newDamage < Damage)
	{
		if (!bCheckOnly)
		{
			pct = 1.0 - (newDamage / Float(Damage));
			SetDamagePercent(pct);
			ClientFlash(0.001, vect(32, 0, 0));
		}
		bReduced = True;
	}
	else
	{
		if (!bCheckOnly)
			SetDamagePercent(0.0);
	}


	//
	// Reduce or increase the damage based on the combat difficulty setting
	//
	if ((damageType == 'Shot') || (damageType == 'AutoShot') || (damageType == 'KnockedOut'))
	{
        newDamage *= CombatDifficulty;

		// always take at least one point of damage
		if ((newDamage <= 1) && (Damage > 0))
			newDamage = 1;

		/*if (AugmentationSystem.GetAugLevelValue(class'AugBallisticPassive') >= 0.0) //RSD: Removed passive drain
		{
           Energy -= newDamage * 0.125;
           if (Energy < 0)
              Energy = 0;
        }*/
	}
	adjustedDamage = Int(newDamage+0.5);                                        //RSD: Now rounds up! Fuck you!

	return bReduced;
}

// ----------------------------------------------------------------------
// Died()
//
// Checks to see if a conversation is playing when the PC dies.
// If so, nukes it.
// ----------------------------------------------------------------------

function Died(pawn Killer, name damageType, vector HitLocation)
{
	if (conPlay != None)
		conPlay.TerminateConversation();

	if (bOnFire)
		ExtinguishFire();

	if (AugmentationSystem != None)
		AugmentationSystem.DeactivateAll(true);

	if ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer))
	  ClientDeath();

	Super.Died(Killer, damageType, HitLocation);
}

// ----------------------------------------------------------------------
// ClientDeath()
//
// Does client side cleanup on death.
// ----------------------------------------------------------------------

function ClientDeath()
{
	if (!PlayerIsClient())
	  return;

	//FlashTimer = 0;

	// Reset skill notification
	DeusExRootWindow(rootWindow).hud.hms.bNotifySkills = False;

	DeusExRootWindow(rootWindow).hud.activeItems.winItemsContainer.RemoveAllIcons();
	DeusExRootWindow(rootWindow).hud.belt.ClearBelt();

	// This should get rid of the scope death problem in multiplayer
	if (( DeusExRootWindow(rootWindow).scopeView != None ) && DeusExRootWindow(rootWindow).scopeView.bViewVisible )
	   DeusExRootWindow(rootWindow).scopeView.DeactivateView();

	if ( DeusExRootWindow(rootWindow).hud.augDisplay != None )
	{
		DeusExRootWindow(rootWindow).hud.augDisplay.bVisionActive = False;
		DeusExRootWindow(rootWindow).hud.augDisplay.activeCount = 0;
	}

	if ( bOnFire )
		ExtinguishFire();

	// Don't come back to life drugged or posioned
	poisonCounter		= 0;
	poisonTimer			= 0;
	drugEffectTimer	= 0;

	// Don't come back to life crouched
    SetCrouch(false,true);

	// No messages carry over
	mpMsgCode = 0;
	mpMsgTime = 0;

	bleedrate = 0;
	dropCounter = 0;

}

// ----------------------------------------------------------------------
// Timer()
//
// continually burn and do damage
// ----------------------------------------------------------------------

function Timer()      //CyberP: my god I've turned this into a mess.
{                     //This can be called at any time by doubleClicking (if thr respective option is enabled)
	local int damage; //This wouldbe a lot cleaner if doubleClickHolster did not use Timer(), so this code needs refactoring.

    if (bBoosterUpgrade && !HeadRegion.Zone.bWaterZone)
        AugmentationSystem.AutoAugs(true,false);

    if (Physics == PHYS_Flying)
    {
     SetPhysics(PHYS_Falling);
     if (!bOnFire)
          return;
	}

	if (!InConversation() && bOnFire)
	{
		if ( Level.NetMode != NM_Standalone )
			damage = Class'WeaponFlamethrower'.Default.mpBurnDamage;
		else
			damage = Class'WeaponFlamethrower'.Default.BurnDamage;
		TakeDamage(damage, myBurner, Location, vect(0,0,0), 'Burned');

		if (HealthTorso <= 0)
		{
			TakeDamage(10, myBurner, Location, vect(0,0,0), 'Burned');
			ExtinguishFire();
		}
	}
}

// ----------------------------------------------------------------------
// CatchFire()
// ----------------------------------------------------------------------

function CatchFire( Pawn burner )
{
	local Fire f;
	local int i;
	local vector loc;

	myBurner = burner;

	burnTimer = 0;

	if (bOnFire || Region.Zone.bWaterZone)
		return;

	bOnFire = True;
	burnTimer = 0;

	for (i=0; i<8; i++)
	{
		loc.X = 0.5*CollisionRadius * (1.0-2.0*FRand());
		loc.Y = 0.5*CollisionRadius * (1.0-2.0*FRand());
		loc.Z = 0.6*CollisionHeight * (1.0-2.0*FRand());
		loc += Location;

	  // DEUS_EX AMSD reduce the number of smoke particles in multiplayer
	  // by creating smokeless fire (better for server propagation).
	  if ((Level.NetMode == NM_Standalone) || (i <= 0))
		 f = Spawn(class'Fire', Self,, loc);
	  else
		 f = Spawn(class'SmokelessFire', Self,, loc);

		if (f != None)
		{
			f.DrawScale = 0.5*FRand() + 1.0;

		 //DEUS_EX AMSD Reduce the penalty in multiplayer
		 if (Level.NetMode != NM_Standalone)
			f.DrawScale = f.DrawScale * 0.5;

			// turn off the sound and lights for all but the first one
			if (i > 0)
			{
				f.AmbientSound = None;
				f.LightType = LT_None;
			}

			// turn on/off extra fire and smoke
		 // MP already only generates a little.
			if ((FRand() < 0.5) && (Level.NetMode == NM_Standalone))
				f.smokeGen.Destroy();
			if ((FRand() < 0.5) && (Level.NetMode == NM_Standalone))
				f.AddFire();
		}
	}

	// set the burn timer
	SetTimer(1.0, True);
}

// ----------------------------------------------------------------------
// ExtinguishFire()
// ----------------------------------------------------------------------

function ExtinguishFire()
{
	local Fire f;

	bOnFire = False;
	burnTimer = 0;
	SetTimer(0, False);

	foreach BasedActors(class'Fire', f)
		f.Destroy();
}

// ----------------------------------------------------------------------
// SpawnBlood()
// ----------------------------------------------------------------------

function SpawnBlood(Vector HitLocation, float Damage)
{
	local int i;

	if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	{
	  return;
	}

	//spawn(class'BloodSpurt',,,HitLocation);
	//spawn(class'BloodDrop',,,HitLocation);
	for (i=0; i<int(Damage); i+=10)
		spawn(class'BloodDrop',,,HitLocation);
}

// ----------------------------------------------------------------------
// PlayDXTakeDamageHit()
// DEUS_EX AMSD Created as a separate function to avoid extra calls to
// DXReduceDamage, which is slow in multiplayer
// ----------------------------------------------------------------------
function PlayDXTakeDamageHit(float Damage, vector HitLocation, name damageType, vector Momentum, bool DamageReduced)
{
	local float rnd;

//log("MYCHK PDXTDH:"@self@"take damage in state"@GetStateName()@" : "@Damage@" : "@damageType);



	PlayHit(Damage,HitLocation,damageType,Momentum);

	// if we actually took the full damage, flash the screen and play the sound
	// DEUS_EX AMSD DXReduceDamage is slow.  Pass in the result from earlier.
	if (!DamageReduced)
	{
		if ( (damage > 0) || (ReducedDamageType == 'All') )
		{
			// No client flash on plasma bolts in multiplayer
			if (( Level.NetMode != NM_Standalone ) && ( myProjKiller != None ) && (PlasmaBolt(myProjKiller)!=None) )
			{
			}
			else
			{//gmdx changed 0.002 on burned
				rnd = FClamp(Damage, 15, 80);
				if (damageType == 'Burned')
					ClientFlash(0.0001, vect(75,37,37));   //vect(100,50,50)
				else if (damageType == 'Flamed')
					ClientFlash(rnd * 0.002, vect(200,100,100));
				else if (damageType == 'Radiation')
					ClientFlash(rnd * 0.002, vect(100,100,0));
				else if (damageType == 'PoisonGas')
					ClientFlash(rnd * 0.002, vect(50,150,0));
				else if (damageType == 'TearGas')
					ClientFlash(rnd * 0.002, vect(150,150,0));
				else if (damageType == 'Drowned')
					ClientFlash(rnd * 0.002, vect(0,100,200));
				else if (damageType == 'EMP')
					ClientFlash(rnd * 0.002, vect(0,200,200));
				else
					ClientFlash(rnd * 0.002, vect(44,0,0));
			}
			ShakeView(0.15 + 0.002 * Damage, Damage * 30, 0.3 * Damage);
		}
	}
}

// ----------------------------------------------------------------------
// PlayHit()
// ----------------------------------------------------------------------

function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	if ((Damage > 0) && (damageType == 'Shot') || (damageType == 'Exploded') || (damageType == 'AutoShot'))
		SpawnBlood(HitLocation, Damage);

    if (Damage > 0) //CyberP: Don't scream (and subsequently send AIEvents) if the damage is 0.
	   PlayTakeHitSound(Damage, damageType, 1);
}

// ----------------------------------------------------------------------
// PlayDeathHit()
// ----------------------------------------------------------------------

function PlayDeathHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	PlayDying(damageType, HitLocation);
}

// ----------------------------------------------------------------------
// SkillPointsAdd()
// ----------------------------------------------------------------------

function SkillPointsAdd(int numPoints)
{
	local int i;                                                                //RSD: For loop later

    if (numPoints > 0)
	{
		SkillPointsAvail += numPoints;
		SkillPointsTotal += numPoints;

		if ((DeusExRootWindow(rootWindow) != None) &&
		    (DeusExRootWindow(rootWindow).hud != None) &&
			(DeusExRootWindow(rootWindow).hud.msgLog != None))
		{
			ClientMessage(Sprintf(SkillPointsAward, numPoints));
			DeusExRootWindow(rootWindow).hud.msgLog.PlayLogSound(Sound'LogSkillPoints');
		}
	}

    //RSD: Subtracts 1% of skill points acquired from addiction levels
    AddictionManager.RemoveAddictions(0.01*float(numPoints),60.0);

	//if (bHardCoreMode)                                                          //RSD: Also subtract 1% of skill points acquired from hunger level
	//{                                                                         //RSD: Since we now have a menu option, always de-increment hunger and check option elsewhere
    	fullUp -= 0.01*float(numPoints);
    	if (fullUp < 0)
    		fullUp = 0;
	//}
}


		  /*
             mov.minDamageThreshold -= 5;
             if (mov.minDamageThreshold <= 0)
                mov.minDamageThreshold = 1;
             mov.bPerkApplied = True; */
		/* 
          case "COMBAT MEDIC'S BAG":
          PerkNamesArray[30]= 1;
          foreach AllActors(class'Medkit',med)
             med.MaxCopies = 20;
          foreach AllActors(class'BioelectricCell',cell)
             cell.MaxCopies = 25;
          break;
		  */

// ----------------------------------------------------------------------
// MakePlayerIgnored()
// ----------------------------------------------------------------------

function MakePlayerIgnored(bool bNewIgnore)
{
	bIgnore = bNewIgnore;
	// to restore original behavior, uncomment the next line
	//bDetectable = !bNewIgnore;
}

// ----------------------------------------------------------------------
// CalculatePlayerVisibility()
// ----------------------------------------------------------------------

function float CalculatePlayerVisibility(ScriptedPawn P)                        //RSD: Ignore all of the changes below, they don't work reliably. Messed with stuff in ScriptedPawn instead
{
	local float vis, skillStealthMod, litelvl;//, litemult;                     //RSD: Added skillStealthMod, litelvl
	local AdaptiveArmor armor;
	local DeusExWeapon wep;

    wep = DeusExWeapon(Weapon);
	vis = 1.0;
	/*litelvl = AIVisibility(false);                                              //RSD: Get AI visibility
    skillStealthMod = (SkillSystem.GetSkillLevelValue(class'SkillStealth')-0.5)*0.3;
    if (skillStealthMod < 0.0)
    	skillStealthMod = 0.0;*/                                                  //RSD: Returns 0/10/20/30% depending on skill level value
    //litemult = ((litelvl - 0.062745) / (litelvl));                            //RSD: Jose21Crisis' formula to keep visibility constant during night vision
    //litemult = litelvl-0.031;                                                 //RSD: New formula to keep visibility constant during night vision (9.3%)
	if ((P != None) && (AugmentationSystem != None))
	{
		if (P.IsA('Robot'))
		{
			// if the aug is on, give the player full invisibility
			if (AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') != -1.0)
				vis = 0.0;
		}
		else
		{
			// if the aug is on, give the player full invisibility
            if (AugmentationSystem.GetAugLevelValue(class'AugCloak') != -1.0)
            	vis = 0.0;
           	/*
            else if ((UsingChargedPickup(class'TechGoggles') ||  AugmentationSystem.GetAugLevelValue(class'AugVision') != -1.0) && vis != 0.0)
                //vis = litemult;                                               //RSD: From Jose21Crisis
                vis -= 0.031;                                                   //RSD: Hopefully accounts for night vision brightness
            if (vis != 0.0 && IsCrouching())
                vis -= (1.0-litelvl)*skillStealthMod;*/                           //RSD: Up to 0/20/40/60% visibility reduction when crouched in darkness
		}

		// go through the actor list looking for owned AdaptiveArmor
		// since they aren't in the inventory anymore after they are used

		if (UsingChargedPickup(class'AdaptiveArmor'))
			{
				vis = 0.0;
			}
	  //if (wep != None && wep.bLasing)
      //      {
      //          vis = 1.0;    //CyberP: if laser on, can be seen even if cloaked/radartrans
      //      }
	}

	return vis;
}

// ----------------------------------------------------------------------
// ClientFlash()
//
// copied from Engine.PlayerPawn
// modified to add the new flash to the current flash
// ----------------------------------------------------------------------
// MBCODE: changed to simulated so that player can experience flash client side
// DEUS_EX AMSD: Added so we can change the flash time duration.
simulated function ClientFlash( float scale, vector fog)
{
	DesiredFlashScale += scale;
	DesiredFlashFog += 0.001 * fog;  //CyberP: 0.001
}

function IncreaseClientFlashLength(float NewFlashTime)
{
	FlashTimer = FMax(NewFlashTime,FlashTimer);
}

// ----------------------------------------------------------------------
// ViewFlash()
// modified so that flash doesn't always go away in exactly half a second.
// ---------------------------------------------------------------------
function ViewFlash(float DeltaTime)
{
	local float delta;
	local vector goalFog;
	local float goalscale, ReductionFactor;

	ReductionFactor = 2;

	if (FlashTimer > 0)
	{
	  if (FlashTimer < Deltatime)
	  {
		 FlashTimer = 0;
	  }
	  else
	  {
		 ReductionFactor = 0;
		 FlashTimer -= Deltatime;
	  }
	}

	if ( bNoFlash )
	{
		InstantFlash = 0;
		InstantFog = vect(0,0,0);
	}

	delta = FMin(0.1, DeltaTime);
	goalScale = 1 + DesiredFlashScale + ConstantGlowScale + HeadRegion.Zone.ViewFlash.X;
	goalFog = DesiredFlashFog + ConstantGlowFog + HeadRegion.Zone.ViewFog;
	DesiredFlashScale -= DesiredFlashScale * ReductionFactor * delta;
	DesiredFlashFog -= DesiredFlashFog * ReductionFactor * delta;
	FlashScale.X += (goalScale - FlashScale.X + InstantFlash) * 10 * delta;
	FlashFog += (goalFog - FlashFog + InstantFog) * 10 * delta;
	InstantFlash = 0;
	InstantFog = vect(0,0,0);

	if ( FlashScale.X > 0.981 )
		FlashScale.X = 1;
	FlashScale = FlashScale.X * vect(1,1,1);

	if ( FlashFog.X < 0.019 )
		FlashFog.X = 0;
	if ( FlashFog.Y < 0.019 )
		FlashFog.Y = 0;
	if ( FlashFog.Z < 0.019 )
		FlashFog.Z = 0;
}
// ----------------------------------------------------------------------
// ViewModelAdd()
//
// lets an artist (or whoever) view a model and play animations on it
// from within the game
// ----------------------------------------------------------------------

exec function ViewModelAdd(int num, string ClassName)
{
	local class<actor> ViewModelClass;
	local rotator newrot;
	local vector loc;

	if (!bCheatsEnabled)
		return;

	if(instr(ClassName, ".") == -1)
		ClassName = "DeusEx." $ ClassName;

	if ((num >= 0) && (num <= 8))
	{
		if (num > 0)
			num--;

		if (ViewModelActor[num] == None)
		{
			ViewModelClass = class<actor>(DynamicLoadObject(ClassName, class'Class'));
			if (ViewModelClass != None)
			{
				newrot = Rotation;
				newrot.Roll = 0;
				newrot.Pitch = 0;
				loc = Location + (ViewModelClass.Default.CollisionRadius + CollisionRadius + 32) * Vector(newrot);
				loc.Z += ViewModelClass.Default.CollisionHeight;
				ViewModelActor[num] = Spawn(ViewModelClass,,, loc, newrot);
				if (ViewModelActor[num] != None)
					ViewModelActor[num].SetPhysics(PHYS_None);
				if (ScriptedPawn(ViewModelActor[num]) != None)
					ViewModelActor[num].GotoState('Paralyzed');
			}
		}
		else
			ClientMessage("There is already a ViewModel in that slot!");
	}
}

// ----------------------------------------------------------------------
// ViewModelDestroy()
//
// destroys the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelDestroy(int num)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
				{
					ViewModelActor[i].Destroy();
					ViewModelActor[i] = None;
				}
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
			{
				ViewModelActor[i].Destroy();
				ViewModelActor[i] = None;
			}
		}
	}
}

// ----------------------------------------------------------------------
// ViewModelPlay()
//
// plays an animation on the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelPlay(int num, name anim, optional float fps)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
				{
					if (fps == 0)
						fps = 1.0;
					ViewModelActor[i].PlayAnim(anim, fps);
				}
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
			{
				if (fps == 0)
					fps = 1.0;
				ViewModelActor[i].PlayAnim(anim, fps);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ViewModelLoop()
//
// loops an animation on the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelLoop(int num, name anim, optional float fps)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
				{
					if (fps == 0)
						fps = 1.0;
					ViewModelActor[i].LoopAnim(anim, fps);
				}
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
			{
				if (fps == 0)
					fps = 1.0;
				ViewModelActor[i].LoopAnim(anim, fps);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ViewModelBlendPlay()
//
// plays a blended animation on the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelBlendPlay(int num, name anim, optional float fps, optional int slot)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
				{
					if (fps == 0)
						fps = 1.0;
					ViewModelActor[i].PlayBlendAnim(anim, fps, , slot);
				}
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
			{
				if (fps == 0)
					fps = 1.0;
				ViewModelActor[i].PlayBlendAnim(anim, fps, , slot);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ViewModelBlendStop()
//
// stops the blended animation on the current ViewModel
// ----------------------------------------------------------------------

exec function ViewModelBlendStop(int num)
{
	local int i;

	if (!bCheatsEnabled)
		return;

	if ((num >= 0) && (num <= 8))
	{
		if (num == 0)
		{
			for (i=0; i<8; i++)
				if (ViewModelActor[i] != None)
					ViewModelActor[i].StopBlendAnims();
		}
		else
		{
			i = num - 1;
			if (ViewModelActor[i] != None)
				ViewModelActor[i].StopBlendAnims();
		}
	}
}

exec function ViewModelGiveWeapon(int num, string weaponClass)
{
	local class<Actor> NewClass;
	local Actor obj;
	local int i;
	local ScriptedPawn pawn;

	if (!bCheatsEnabled)
		return;

	if (instr(weaponClass, ".") == -1)
		weaponClass = "DeusEx." $ weaponClass;

	if ((num >= 0) && (num <= 8))
	{
		NewClass = class<Actor>(DynamicLoadObject(weaponClass, class'Class'));

		if (NewClass != None)
		{
			obj = Spawn(NewClass,,, Location + (CollisionRadius+NewClass.Default.CollisionRadius+30) * Vector(Rotation) + vect(0,0,1) * 15);
			if ((obj != None) && obj.IsA('DeusExWeapon'))
			{
				if (num == 0)
				{
					for (i=0; i<8; i++)
					{
						pawn = ScriptedPawn(ViewModelActor[i]);
						if (pawn != None)
						{
							DeusExWeapon(obj).GiveTo(pawn);
							obj.SetBase(pawn);
							pawn.Weapon = DeusExWeapon(obj);
							pawn.PendingWeapon = DeusExWeapon(obj);
						}
					}
				}
				else
				{
					i = num - 1;
					pawn = ScriptedPawn(ViewModelActor[i]);
					if (pawn != None)
					{
						DeusExWeapon(obj).GiveTo(pawn);
						obj.SetBase(pawn);
						pawn.Weapon = DeusExWeapon(obj);
						pawn.PendingWeapon = DeusExWeapon(obj);
					}
				}
			}
			else
			{
				if (obj != None)
					obj.Destroy();
			}
		}
	}
}

// ----------------------------------------------------------------------
// aliases to ViewModel functions
// ----------------------------------------------------------------------

exec function VMA(int num, string ClassName)
{
	ViewModelAdd(num, ClassName);
}

exec function VMD(int num)
{
	ViewModelDestroy(num);
}

exec function VMP(int num, name anim, optional float fps)
{
	ViewModelPlay(num, anim, fps);
}

exec function VML(int num, name anim, optional float fps)
{
	ViewModelLoop(num, anim, fps);
}

exec function VMBP(int num, name anim, optional float fps, optional int slot)
{
	ViewModelBlendPlay(num, anim, fps, slot);
}

exec function VMBS(int num)
{
	ViewModelBlendStop(num);
}

exec function VMGW(int num, string weaponClass)
{
	ViewModelGiveWeapon(num, weaponClass);
}

// ----------------------------------------------------------------------
// Cheat functions
//
// ----------------------------------------------------------------------
// AllHealth()
// ----------------------------------------------------------------------

exec function AllHealth()
{
	if (!bCheatsEnabled)
		return;

	RestoreAllHealth();
}

// ----------------------------------------------------------------------
// RestoreAllHealth()
// mod by dasraiser for GMDX MedSkill additional health
// ----------------------------------------------------------------------

function RestoreAllHealth()
{
	local int spill;
	local Skill sk;
	local float MedSkillAdd;
	local int AddictionAdd;                                           //RSD: Now get bonus max torso health from drinking, penalty for zyme
    AddictionAdd = AddictionManager.GetTorsoHealthBonus();
    MedSkillAdd = 0.0;
	if (SkillSystem!=None)
	{
	  sk = SkillSystem.GetSkillFromClass(Class'DeusEx.SkillMedicine');
	  if (sk!=None) MedSkillAdd=sk.CurrentLevel*10;
	}
	HealthHead = default.HealthHead+MedSkillAdd;
	HealthTorso = default.HealthTorso+MedSkillAdd+AddictionAdd;        //RSD: Added drunk, zyme
	HealthLegLeft = default.HealthLegLeft;
	HealthLegRight = default.HealthLegRight;
	HealthArmLeft = default.HealthArmLeft;
	HealthArmRight = default.HealthArmRight;
	Health = default.Health;
}

// ----------------------------------------------------------------------
// DamagePart()
// ----------------------------------------------------------------------

exec function DamagePart(int partIndex, optional int amount)
{
	if (!bCheatsEnabled)
		return;

	if (amount == 0)
		amount = 1000;

	switch(partIndex)
	{
		case 0:		// head
			HealthHead -= Min(HealthHead, amount);
			break;

		case 1:		// torso
			HealthTorso -= Min(HealthTorso, amount);
			break;

		case 2:		// left arm
			HealthArmLeft -= Min(HealthArmLeft, amount);
			break;

		case 3:		// right arm
			HealthArmRight -= Min(HealthArmRight, amount);
			break;

		case 4:		// left leg
			HealthLegLeft -= Min(HealthLegLeft, amount);
			break;

		case 5:		// right leg
			HealthLegRight -= Min(HealthLegRight, amount);
			break;
	}
}

// ----------------------------------------------------------------------
// DamageAll()
// ----------------------------------------------------------------------

exec function DamageAll(optional int amount)
{
	if (!bCheatsEnabled)
		return;

	if (amount == 0)
		amount = 1000;

	HealthHead     -= Min(HealthHead, amount);
	HealthTorso    -= Min(HealthTorso, amount);
	HealthArmLeft  -= Min(HealthArmLeft, amount);
	HealthArmRight -= Min(HealthArmRight, amount);
	HealthLegLeft  -= Min(HealthLegLeft, amount);
	HealthLegRight -= Min(HealthLegRight, amount);
}

// ----------------------------------------------------------------------
// AllEnergy()
// ----------------------------------------------------------------------

exec function AllEnergy()
{
	if (!bCheatsEnabled)
		return;

	Energy = default.Energy;
}

// ----------------------------------------------------------------------
// AllCredits()
// ----------------------------------------------------------------------

exec function AllCredits()
{
	if (!bCheatsEnabled)
		return;

	Credits = 100000;
}

// ---------------------------------------------------------------------
// AllSkills()
// ----------------------------------------------------------------------

exec function AllSkills()
{
	if (!bCheatsEnabled)
		return;

	AllSkillPoints();
	SkillSystem.AddAllSkills();
}

// ----------------------------------------------------------------------
// AllSkillPoints()
// ----------------------------------------------------------------------

exec function AllSkillPoints()
{
	if (!bCheatsEnabled)
		return;

	SkillPointsTotal = 115900;
	SkillPointsAvail = 115900;
}

// ----------------------------------------------------------------------
// AllAugs()
// ----------------------------------------------------------------------

exec function AllAugs()
{
	local Augmentation anAug;
	local int i;

	if (!bCheatsEnabled)
		return;

	if (AugmentationSystem != None)
	{
		AugmentationSystem.AddAllAugs();
		AugmentationSystem.SetAllAugsToMaxLevel();
	}
}

// ----------------------------------------------------------------------
// AllWeapons()
// ----------------------------------------------------------------------

exec function AllWeapons()
{
	local Vector loc;

	if (!bCheatsEnabled)
		return;

	loc = Location + 2 * CollisionRadius * Vector(ViewRotation);

	Spawn(class'WeaponAssaultGun',,, loc);
	Spawn(class'WeaponAssaultShotgun',,, loc);
	Spawn(class'WeaponBaton',,, loc);
	Spawn(class'WeaponCombatKnife',,, loc);
	Spawn(class'WeaponCrowbar',,, loc);
	Spawn(class'WeaponEMPGrenade',,, loc);
	Spawn(class'WeaponFlamethrower',,, loc);
	Spawn(class'WeaponGasGrenade',,, loc);
	Spawn(class'WeaponGEPGun',,, loc);
	Spawn(class'WeaponHideAGun',,, loc);
	Spawn(class'WeaponLAM',,, loc);
	Spawn(class'WeaponLAW',,, loc);
	Spawn(class'WeaponMiniCrossbow',,, loc);
	Spawn(class'WeaponNanoSword',,, loc);
	Spawn(class'WeaponNanoVirusGrenade',,, loc);
	Spawn(class'WeaponPepperGun',,, loc);
	Spawn(class'WeaponPistol',,, loc);
	Spawn(class'WeaponPlasmaRifle',,, loc);
	Spawn(class'WeaponProd',,, loc);
	Spawn(class'WeaponRifle',,, loc);
	Spawn(class'WeaponSawedOffShotgun',,, loc);
	Spawn(class'WeaponShuriken',,, loc);
	Spawn(class'WeaponStealthPistol',,, loc);
	Spawn(class'WeaponSword',,, loc);
}

// ----------------------------------------------------------------------
// AllImages()
// ----------------------------------------------------------------------

exec function AllImages()
{
	local Vector loc;
	local Inventory item;

	if (!bCheatsEnabled)
		return;

	item = Spawn(class'Image01_GunFireSensor');
	item.Frob(Self, None);
	item = Spawn(class'Image01_LibertyIsland');
	item.Frob(Self, None);
	item = Spawn(class'Image01_TerroristCommander');
	item.Frob(Self, None);
	item = Spawn(class'Image02_Ambrosia_Flyer');
	item.Frob(Self, None);
	item = Spawn(class'Image02_NYC_Warehouse');
	item.Frob(Self, None);
	item = Spawn(class'Image02_BobPage_ManOfYear');
	item.Frob(Self, None);
	item = Spawn(class'Image03_747Diagram');
	item.Frob(Self, None);
	item = Spawn(class'Image03_NYC_Airfield');
	item.Frob(Self, None);
	item = Spawn(class'Image03_WaltonSimons');
	item.Frob(Self, None);
	item = Spawn(class'Image04_NSFHeadquarters');
	item.Frob(Self, None);
	item = Spawn(class'Image04_UNATCONotice');
	item.Frob(Self, None);
	item = Spawn(class'Image05_GreaselDisection');
	item.Frob(Self, None);
	item = Spawn(class'Image05_NYC_MJ12Lab');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_Market');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_MJ12Helipad');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_MJ12Lab');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_Versalife');
	item.Frob(Self, None);
	item = Spawn(class'Image06_HK_WanChai');
	item.Frob(Self, None);
	item = Spawn(class'Image08_JoeGreenMIBMJ12');
	item.Frob(Self, None);
	item = Spawn(class'Image09_NYC_Ship_Bottom');
	item.Frob(Self, None);
	item = Spawn(class'Image09_NYC_Ship_Top');
	item.Frob(Self, None);
	item = Spawn(class'Image10_Paris_Catacombs');
	item.Frob(Self, None);
	item = Spawn(class'Image10_Paris_CatacombsTunnels');
	item.Frob(Self, None);
	item = Spawn(class'Image10_Paris_Metro');
	item.Frob(Self, None);
	item = Spawn(class'Image11_Paris_Cathedral');
	item.Frob(Self, None);
	item = Spawn(class'Image11_Paris_CathedralEntrance');
	item.Frob(Self, None);
	item = Spawn(class'Image12_Vandenberg_Command');
	item.Frob(Self, None);
	item = Spawn(class'Image12_Vandenberg_Sub');
	item.Frob(Self, None);
	item = Spawn(class'Image12_Tiffany_HostagePic');
	item.Frob(Self, None);
	item = Spawn(class'Image14_OceanLab');
	item.Frob(Self, None);
	item = Spawn(class'Image14_Schematic');
	item.Frob(Self, None);
	item = Spawn(class'Image15_Area51Bunker');
	item.Frob(Self, None);
	item = Spawn(class'Image15_GrayDisection');
	item.Frob(Self, None);
	item = Spawn(class'Image15_BlueFusionDevice');
	item.Frob(Self, None);
	item = Spawn(class'Image15_Area51_Sector3');
	item.Frob(Self, None);
	item = Spawn(class'Image15_Area51_Sector4');
	item.Frob(Self, None);
}

// ----------------------------------------------------------------------
// Trig()
// ----------------------------------------------------------------------

exec function Trig(name ev)
{
	local Actor A;

	if (!bCheatsEnabled)
		return;

	if (ev != '')
		foreach AllActors(class'Actor', A, ev)
			A.Trigger(Self, Self);
}

// ----------------------------------------------------------------------
// UnTrig()
// ----------------------------------------------------------------------

exec function UnTrig(name ev)
{
	local Actor A;

	if (!bCheatsEnabled)
		return;

	if (ev != '')
		foreach AllActors(class'Actor', A, ev)
			A.UnTrigger(Self, Self);
}

// ----------------------------------------------------------------------
// SetState()
// ----------------------------------------------------------------------

exec function SetState(name state)
{
	local ScriptedPawn P;
	local Actor hitActor;
	local vector loc, line, HitLocation, hitNormal;

	if (!bCheatsEnabled)
		return;

	loc = Location;
	loc.Z += BaseEyeHeight;
	line = Vector(ViewRotation) * 2000;

	hitActor = Trace(hitLocation, hitNormal, loc+line, loc, true);
	P = ScriptedPawn(hitActor);
	if (P != None)
	{
		P.GotoState(state);
		ClientMessage("Setting "$P.BindName$" to the "$state$" state");
	}
}

exec function CycleNextMap()                                                    //RSD: New cheat to cycle through all the maps so as to dump map info
{
    local DXMapListSP MapListSP;
    local string DestMap;

    if (!bCheatsEnabled)
		return;

    //BroadcastMessage("CycleNextMap");
    MapListSP = Spawn(class'DXMapListSP');
    MapListSP.CycleType = 2;
    DestMap = MapListSP.GetNextMap();
    //BroadcastMessage(MapListSP.GetCurrentMap());
    BroadcastMessage(DestMap);

	// Make sure we destroy all windows before sending the
	// player on his merry way.
	DeusExRootWindow(rootWindow).ClearWindowStack();
	Level.Game.SendPlayer(self, DestMap);
}

// ----------------------------------------------------------------------
// DXDumpInfo()
//
// Dumps the following player information to the log file
// - inventory (with item counts)
// - health (as %)
// - energy (as %)
// - credits
// - skill points (avail and max)
// - skills
// - augmentations
// ----------------------------------------------------------------------

exec function DXDumpInfo()
{
	local DumpLocation dumploc;
	local DeusExLevelInfo info;
	local string userName, mapName, strCopies;
	local Inventory item, nextItem;
	local DeusExWeapon W;
	local Skill skill;
	local Augmentation aug;
	local bool bHasAugs;

	dumploc = CreateDumpLocationObject();
	if (dumploc != None)
	{
		userName = dumploc.GetCurrentUser();
		CriticalDelete(dumploc);
	}

	if (userName == "")
		userName = "NO USERNAME";

	mapName = "NO MAPNAME";
	foreach AllActors(class'DeusExLevelInfo', info)
		mapName = info.MapName;

	log("");
	log("**** DXDumpInfo - User: "$userName$" - Map: "$mapName$" ****");
	log("");
	log("  Inventory:");

	if (Inventory != None)
	{
		item = Inventory;
		do
		{
			nextItem = item.Inventory;

			if (item.bDisplayableInv || item.IsA('Ammo'))
			{
				W = DeusExWeapon(item);
				if ((W != None) && W.bHandToHand && (W.ProjectileClass != None))
					strCopies = " ("$W.AmmoType.AmmoAmount$" rds)";
				else if (item.IsA('Ammo') && (Ammo(item).PickupViewMesh != Mesh'TestBox'))
					strCopies = " ("$Ammo(item).AmmoAmount$" rds)";
				else if (item.IsA('Pickup') && (Pickup(item).NumCopies > 1))
					strCopies = " ("$Pickup(item).NumCopies$")";
				else
					strCopies = "";

				log("    "$item.GetItemName(String(item.Class))$strCopies);
			}
			item = nextItem;
		}
		until (item == None);
	}
	else
		log("    Empty");

	GenerateTotalHealth();
	log("");
	log("  Health:");
	log("    Overall   - "$Health$"%");
	log("    Head      - "$HealthHead$"%");
	log("    Torso     - "$HealthTorso$"%");
	log("    Left arm  - "$HealthArmLeft$"%");
	log("    Right arm - "$HealthArmRight$"%");
	log("    Left leg  - "$HealthLegLeft$"%");
	log("    Right leg - "$HealthLegRight$"%");

	log("");
	log("  BioElectric Energy:");
	log("    "$Int(Energy)$"%");

	log("");
	log("  Credits:");
	log("    "$Credits);

	log("");
	log("  Skill Points:");
	log("    Available    - "$SkillPointsAvail);
	log("    Total Earned - "$SkillPointsTotal);

	log("");
	log("  Skills:");
	if (SkillSystem != None)
	{
		skill = SkillSystem.FirstSkill;
		while (skill != None)
		{
			if (skill.SkillName != "")
				log("    "$skill.SkillName$" - "$skill.skillLevelStrings[skill.CurrentLevel]);

			skill = skill.next;
		}
	}

	bHasAugs = False;
	log("");
	log("  Augmentations:");
	if (AugmentationSystem != None)
	{
		aug = AugmentationSystem.FirstAug;
		while (aug != None)
		{
			if (aug.bHasIt && (aug.AugmentationLocation != LOC_Default) && (aug.AugmentationName != ""))
			{
				bHasAugs = True;
				log("    "$aug.AugmentationName$" - Location: "$aug.AugLocsText[aug.AugmentationLocation]$" - Level: "$aug.CurrentLevel+1);
			}

			aug = aug.next;
		}
	}

	if (!bHasAugs)
		log("    None");

	log("");
	log("**** DXDumpInfo - END ****");
	log("");

	ClientMessage("Info dumped for user "$userName);
}


// ----------------------------------------------------------------------
// InvokeUIScreen()
//
// Calls DeusExRootWindow::InvokeUIScreen(), but first make sure
// a modifier (Alt, Shift, Ctrl) key isn't being held down.
// ----------------------------------------------------------------------

function InvokeUIScreen(Class<DeusExBaseWindow> windowClass)
{
	local DeusExRootWindow root;
	root = DeusExRootWindow(rootWindow);
	if (root != None)
	{
		if ( root.IsKeyDown( IK_Alt ) || root.IsKeyDown( IK_Shift ) || root.IsKeyDown( IK_Ctrl ))
			return;

//GMDX: stop lockpick and multitool cheat
	  if (InHand!=None&&InHand.IsA('SkilledTool')&&(InHand.IsA('Lockpick')||InHand.IsA('MultiTool')))
	  {
		 if (SkilledTool(InHand).IsInState('UseIt'))
			return; //just cant InvokeUIScreen :P
	  }

	  if (bRadialAugMenuVisible)
	       ToggleRadialAugMenu();

	    if (bRealUI || bHardCoreMode)
		root.InvokeUIScreen(windowClass,true);
		else
		root.InvokeUIScreen(windowClass);
	}
}

// ----------------------------------------------------------------------
// ResetConversationHistory()
//
// Clears any conversation history, used primarily when starting a
// new game or travelling to new missions
// ----------------------------------------------------------------------

function ResetConversationHistory()
{
	if (conHistory != None)
	{
		CriticalDelete(conHistory);
		conHistory = None;
	}
}

// ======================================================================
// ======================================================================
// COLOR THEME MANAGER FUNCTIONS
// ======================================================================
// ======================================================================

// ----------------------------------------------------------------------
// CreateThemeManager()
// ----------------------------------------------------------------------

function CreateColorThemeManager()
{
	if (ThemeManager == None)
	{
		ThemeManager = Spawn(Class'ColorThemeManager', Self);

		// Add all default themes.

		// Menus
		ThemeManager.AddTheme(Class'ColorThemeMenu_Default');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Custom1');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Aurora');
		ThemeManager.AddTheme(Class'ColorThemeMenu_BlueAndGold');
		ThemeManager.AddTheme(Class'ColorThemeMenu_BlueAngel');
		ThemeManager.AddTheme(Class'ColorThemeMenu_ColdWater');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Condiments');
		ThemeManager.AddTheme(Class'ColorThemeMenu_CoolGreen');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Cops');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Cyan');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Cybermancy');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Dawn');
		ThemeManager.AddTheme(Class'ColorThemeMenu_DesertStorm');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Dimension');
		ThemeManager.AddTheme(Class'ColorThemeMenu_DriedBlood');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Dusk');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Earth');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Formula1');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Green');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Grey');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Hermes');
		ThemeManager.AddTheme(Class'ColorThemeMenu_HumanRenovation');
		ThemeManager.AddTheme(Class'ColorThemeMenu_IonStorm');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Jasmine');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Lava');
		ThemeManager.AddTheme(Class'ColorThemeMenu_LDDP');
		ThemeManager.AddTheme(Class'ColorThemeMenu_MJ12');
		ThemeManager.AddTheme(Class'ColorThemeMenu_NightVision');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Ninja');
		ThemeManager.AddTheme(Class'ColorThemeMenu_NSF');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Olive');
		ThemeManager.AddTheme(Class'ColorThemeMenu_PaleGreen');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Pastel');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Plasma');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Primaries');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Purple');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Radiation');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Red');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Seawater');
		ThemeManager.AddTheme(Class'ColorThemeMenu_SoylentGreen');
		ThemeManager.AddTheme(Class'ColorThemeMenu_SplinterCell');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Starlight');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Steel');
		ThemeManager.AddTheme(Class'ColorThemeMenu_SteelGreen');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Superhero');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Terminator');
		ThemeManager.AddTheme(Class'ColorThemeMenu_Violet');
		ThemeManager.AddTheme(Class'ColorThemeMenu_VonBraun');
		ThemeManager.AddTheme(Class'ColorThemeMenu_WildBerry');
		ThemeManager.AddTheme(Class'ColorThemeMenu_ZeroOne');

		// HUD
		ThemeManager.AddTheme(Class'ColorThemeHUD_Default');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Custom2');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Amber');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Aurora');
		ThemeManager.AddTheme(Class'ColorThemeHUD_BlueAngel');
		ThemeManager.AddTheme(Class'ColorThemeHUD_ColdWater');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Condiments');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Cops');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Cyan');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Cybermancy');
		ThemeManager.AddTheme(Class'ColorThemeHUD_DarkBlue');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Dawn');
		ThemeManager.AddTheme(Class'ColorThemeHUD_DesertStorm');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Dimension');
		ThemeManager.AddTheme(Class'ColorThemeHUD_DriedBlood');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Dusk');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Formula1');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Grey');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Hermes');
		ThemeManager.AddTheme(Class'ColorThemeHUD_HumanRenovation');
		ThemeManager.AddTheme(Class'ColorThemeHUD_IonStorm');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Jasmine');
		ThemeManager.AddTheme(Class'ColorThemeHUD_LDDP');
		ThemeManager.AddTheme(Class'ColorThemeHUD_MJ12');
		ThemeManager.AddTheme(Class'ColorThemeHUD_NightVision');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Ninja');
		ThemeManager.AddTheme(Class'ColorThemeHUD_NSF');
		ThemeManager.AddTheme(Class'ColorThemeHUD_PaleGreen');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Pastel');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Plasma');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Primaries');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Purple');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Radiation');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Red');
		ThemeManager.AddTheme(Class'ColorThemeHUD_SoylentGreen');
		ThemeManager.AddTheme(Class'ColorThemeHUD_SplinterCell');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Starlight');
		ThemeManager.AddTheme(Class'ColorThemeHUD_SteelGreen');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Superhero');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Terminator');
		ThemeManager.AddTheme(Class'ColorThemeHUD_Violet');
		ThemeManager.AddTheme(Class'ColorThemeHUD_VonBraun');
		ThemeManager.AddTheme(Class'ColorThemeHUD_WildBerry');
		ThemeManager.AddTheme(Class'ColorThemeHUD_ZeroOne');
	}
}

// ----------------------------------------------------------------------
// NextHUDColorTheme()
//
// Cycles to the next available HUD color theme and squirts out
// a "StylesChanged" event.
// ----------------------------------------------------------------------

exec function NextHUDColorTheme()
{
	if (ThemeManager != None)
	{
		ThemeManager.NextHUDColorTheme();
		DeusExRootWindow(rootWindow).ChangeStyle();
	}
}

// ----------------------------------------------------------------------
// Cycles to the next available Menu color theme and squirts out
// a "StylesChanged" event.
// ----------------------------------------------------------------------

exec function NextMenuColorTheme()
{
	if (ThemeManager != None)
	{
		ThemeManager.NextMenuColorTheme();
		DeusExRootWindow(rootWindow).ChangeStyle();
	}
}

// ----------------------------------------------------------------------
// SetHUDBordersVisible()
// ----------------------------------------------------------------------

exec function SetHUDBordersVisible(bool bVisible)
{
	bHUDBordersVisible = bVisible;
}

// ----------------------------------------------------------------------
// GetHUDBordersVisible()
// ----------------------------------------------------------------------

function bool GetHUDBordersVisible()
{
	return bHUDBordersVisible;
}

// ----------------------------------------------------------------------
// SetHUDBorderTranslucency()
// ----------------------------------------------------------------------

exec function SetHUDBorderTranslucency(bool bNewTranslucency)
{
	bHUDBordersTranslucent = bNewTranslucency;
}

// ----------------------------------------------------------------------
// GetHUDBorderTranslucency()
// ----------------------------------------------------------------------

function bool GetHUDBorderTranslucency()
{
	return bHUDBordersTranslucent;
}

// ----------------------------------------------------------------------
// SetHUDBackgroundTranslucency()
// ----------------------------------------------------------------------

exec function SetHUDBackgroundTranslucency(bool bNewTranslucency)
{
	bHUDBackgroundTranslucent = bNewTranslucency;
}

// ----------------------------------------------------------------------
// GetHUDBackgroundTranslucency()
// ----------------------------------------------------------------------

function bool GetHUDBackgroundTranslucency()
{
	return bHUDBackgroundTranslucent;
}

// ----------------------------------------------------------------------
// SetMenuTranslucency()
// ----------------------------------------------------------------------

exec function SetMenuTranslucency(bool bNewTranslucency)
{
	bMenusTranslucent = bNewTranslucency;
}

// ----------------------------------------------------------------------
// GetMenuTranslucency()
// ----------------------------------------------------------------------

function bool GetMenuTranslucency()
{
	return bMenusTranslucent;
}

// ----------------------------------------------------------------------
// DebugInfo test functions
// ----------------------------------------------------------------------

exec function DebugCommand(string teststr)
{
	if (!bCheatsEnabled)
		return;

	if (GlobalDebugObj == None)
		GlobalDebugObj = new(Self) class'DebugInfo';

	if (GlobalDebugObj != None)
		GlobalDebugObj.Command(teststr);
}

exec function SetDebug(name cmd, name val)
{
	if (!bCheatsEnabled)
		return;

	if (GlobalDebugObj == None)
		GlobalDebugObj = new(Self) class'DebugInfo';

	Log("Want to setting Debug String " $ cmd $ " to " $ val);

	if (GlobalDebugObj != None)
		GlobalDebugObj.SetString(String(cmd),String(val));
}

exec function GetDebug(name cmd)
{
	local string temp;

	if (!bCheatsEnabled)
		return;

	if (GlobalDebugObj == None)
		GlobalDebugObj = new(Self) class'DebugInfo';

	if (GlobalDebugObj != None)
	{
		temp=GlobalDebugObj.GetString(String(cmd));
		Log("Debug String " $ cmd $ " has value " $ temp);
	}
}

exec function LogMsg(string msg)
{
	Log(msg);
}

simulated event Destroyed()
{
	if (GlobalDebugObj != None)
		CriticalDelete(GlobalDebugObj);

	ClearAugmentationDisplay();

	if (Role == ROLE_Authority)
	  CloseThisComputer(ActiveComputer);
	ActiveComputer = None;

	Super.Destroyed();
}

// ----------------------------------------------------------------------
// Actor Location and Movement commands
// ----------------------------------------------------------------------

exec function MoveActor(int xPos, int yPos, int zPos)
{
	local Actor            hitActor;
	local Vector           hitLocation, hitNormal;
	local Vector           position, line, newPos;

	if (!bCheatsEnabled)
		return;

	position    = Location;
	position.Z += BaseEyeHeight;
	line        = Vector(ViewRotation) * 4000;

	hitActor = Trace(hitLocation, hitNormal, position+line, position, true);
	if (hitActor != None)
	{
		newPos.x=xPos;
		newPos.y=yPos;
		newPos.z=zPos;
		// hitPawn = ScriptedPawn(hitActor);
		Log( "Trying to move " $ hitActor.Name $ " from " $ hitActor.Location $ " to " $ newPos);
		hitActor.SetLocation(newPos);
		Log( "Ended up at " $ hitActor.Location );
	}
}

exec function WhereActor(optional int Me)
{
	local Actor            hitActor;
	local Vector           hitLocation, hitNormal;
	local Vector           position, line, newPos;

	if (!bCheatsEnabled)
		return;

	if (Me==1)
		hitActor=self;
	else
	{
		position    = Location;
		position.Z += BaseEyeHeight;
		line        = Vector(ViewRotation) * 4000;
		hitActor    = Trace(hitLocation, hitNormal, position+line, position, true);
	}
	if (hitActor != None)
	{
		Log( hitActor.Name $ " is at " $ hitActor.Location );
		BroadcastMessage( hitActor.Name $ " is at " $ hitActor.Location );
	}
}

// ----------------------------------------------------------------------
// Easter egg functions
// ----------------------------------------------------------------------

function Matrix()
{
	if (Sprite == None)
	{
		Sprite = Texture(DynamicLoadObject("Extras.Matrix_A00", class'Texture'));
		ConsoleCommand("RMODE 6");
	}
	else
	{
		Sprite = None;
		ConsoleCommand("RMODE 5");
	}
}

exec function IAmWarren()
{
	if (!bCheatsEnabled)
		return;

	if (!bWarrenEMPField)
	{
		bWarrenEMPField = true;
		WarrenTimer = 0;
		WarrenSlot  = 0;
		ClientMessage("Warren's EMP Field activated");  // worry about localization?
	}
	else
	{
		bWarrenEMPField = false;
		ClientMessage("Warren's EMP Field deactivated");  // worry about localization?
	}
}

// ----------------------------------------------------------------------
// UsingChargedPickup
// ----------------------------------------------------------------------

function bool UsingChargedPickup(class<ChargedPickup> itemclass)
{
	local inventory CurrentItem;
	local bool bFound;

	bFound = false;

	for (CurrentItem = Inventory; ((CurrentItem != None) && (!bFound)); CurrentItem = CurrentItem.inventory)
	{
	  if ((CurrentItem.class == itemclass) && (CurrentItem.bActive))
		 bFound = true;
	}

	return bFound;
}

// ----------------------------------------------------------------------
// MultiplayerSpecificFunctions
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// ReceiveFirstOptionSync()
// DEUS_EX AMSD I have to enumerate every 2#%#@%Ing argument???
// ----------------------------------------------------------------------

function ReceiveFirstOptionSync ( Name PrefZero, Name PrefOne, Name PrefTwo, Name PrefThree, Name PrefFour)
{
	local int i;
	local Name AugPriority[5];

	if (bFirstOptionsSynced == true)
	{
	  return;
	}

	AugPriority[0] = PrefZero;
	AugPriority[1] = PrefOne;
	AugPriority[2] = PrefTwo;
	AugPriority[3] = PrefThree;
	AugPriority[4] = PrefFour;

	for (i = 0; ((i < ArrayCount(AugPrefs)) && (i < ArrayCount(AugPriority))); i++)
	{
	  AugPrefs[i] = AugPriority[i];
	}
	bFirstOptionsSynced = true;

	if (Role == ROLE_Authority)
	{
	  if ((DeusExMPGame(Level.Game) != None) && (bSecondOptionsSynced))
	  {
		 DeusExMPGame(Level.Game).SetupAbilities(self);
	  }
	}
}

// ----------------------------------------------------------------------
// ReceiveSecondOptionSync()
// DEUS_EX AMSD I have to enumerate every 2#%#@%Ing argument???
// ----------------------------------------------------------------------

function ReceiveSecondOptionSync ( Name PrefFive, Name PrefSix, Name PrefSeven, Name PrefEight)
{
	local int i;
	local Name AugPriority[9];

	if (bSecondOptionsSynced == true)
	{
	  return;
	}

	AugPriority[5] = PrefFive;
	AugPriority[6] = PrefSix;
	AugPriority[7] = PrefSeven;
	AugPriority[8] = PrefEight;

	for (i = 5; ((i < ArrayCount(AugPrefs)) && (i < ArrayCount(AugPriority))); i++)
	{
	  AugPrefs[i] = AugPriority[i];
	}
	bSecondOptionsSynced = true;

	if (Role == ROLE_Authority)
	{
	  if ((DeusExMPGame(Level.Game) != None) && (bFirstOptionsSynced))
	  {
		 DeusExMPGame(Level.Game).SetupAbilities(self);
	  }
	}
}

// ----------------------------------------------------------------------
// ClientPlayAnimation
// ----------------------------------------------------------------------

simulated function ClientPlayAnimation( Actor src, Name anim, float rate, bool bLoop )
{
	if ( src != None )
	{
			//		if ( bLoop )
			//			src.LoopAnim(anim, ,rate);
			//		else
			src.PlayAnim(anim, ,rate);
	}
}

// ----------------------------------------------------------------------
// ClientSpawnProjectile
// ----------------------------------------------------------------------

simulated function ClientSpawnProjectile( class<projectile> ProjClass, Actor owner, Vector Start, Rotator AdjustedAim )
{
	local DeusExProjectile proj;

	proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
	if ( proj != None )
	{
		proj.RemoteRole = ROLE_None;
		proj.Damage = 0;
	}
}

// ----------------------------------------------------------------------
// ClientSpawnHits
// ----------------------------------------------------------------------

simulated function ClientSpawnHits( bool bPenetrating, bool bHandToHand, Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
	local TraceHitSpawner hitspawner;
	log("DX");

	//if (inHand.isA('WeaponNanoSword'))
	//{
	//  class'TraceHitSpawner'.default.bForceBulletHole=true;
	//  log("NANO FOUND");
	//}
	if (bPenetrating)
	{
	  if (bHandToHand)
	  {
		 hitspawner = Spawn(class'TraceHitHandSpawner',Other,,HitLocation,Rotator(HitNormal));
	  }
	  else
	  {

		 hitspawner = Spawn(class'TraceHitSpawner',Other,,HitLocation,Rotator(HitNormal));
		    hitspawner.HitDamage = Damage;
	  }
	}
	else
	{
	  if (bHandToHand)
	  {
		 hitspawner = Spawn(class'TraceHitHandNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
		 if (IsInState('Dying'))
		 hitspawner = none; //CyberP: death overrides melee attacks
	  }
	  else
	  {
		 hitspawner = Spawn(class'TraceHitNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
	  }
	}
	if (hitSpawner != None)
	{
	  hitspawner.HitDamage = Damage;
	  if (inHand.isA('WeaponNanoSword'))
	  {
		 log("From DXplayer");
		 hitSpawner.damageType='NanoSword';
	  }
	}
}

// ----------------------------------------------------------------------
// NintendoImmunityEffect()
// ----------------------------------------------------------------------
function NintendoImmunityEffect( bool on )
{
	bNintendoImmunity = on;

	if (bNintendoImmunity)
	{
 		NintendoImmunityTime = Level.Timeseconds + NintendoDelay;
		NintendoImmunityTimeLeft = NintendoDelay;
	}
	else
		NintendoImmunityTimeLeft = 0.0;
}

// ----------------------------------------------------------------------
// GetAugPriority()
// Returns -1 if the player has the aug.
// Returns 0-8 (0 being higher priority) for the aug priority.
// If the player doesn't list the aug as a priority, returns the first
// unoccupied slot num (9 if all are filled).
// ----------------------------------------------------------------------
function int GetAugPriority( Augmentation AugToCheck)
{
	local Name AugName;
	local int PriorityIndex;

	AugName = AugToCheck.Class.Name;

	if (AugToCheck.bHasIt)
	  return -1;

	for (PriorityIndex = 0; PriorityIndex < ArrayCount(AugPrefs); PriorityIndex++)
	{
	  if (AugPrefs[PriorityIndex] == AugName)
	  {
		 return PriorityIndex;
	  }
	  if (AugPrefs[PriorityIndex] == '')
	  {
		 return PriorityIndex;
	  }
	}

	return PriorityIndex;
}

// ----------------------------------------------------------------------
// GrantAugs()
// Grants augs in order of priority.
// Sadly, we do this on the client because propagation of requested augs
// takes so long.
// ----------------------------------------------------------------------
function GrantAugs(int NumAugs)
{
	local Augmentation CurrentAug;
	local int PriorityIndex;
	local int AugsLeft;

	if (Role < ROLE_Authority)
	  return;
	AugsLeft = NumAugs;

	for (PriorityIndex = 0; PriorityIndex < ArrayCount(AugPrefs); PriorityIndex++)
	{
	  if (AugsLeft <= 0)
	  {
		 return;
	  }
	  if (AugPrefs[PriorityIndex] == '')
	  {
		 return;
	  }
	  for (CurrentAug = AugmentationSystem.FirstAug; CurrentAug != None; CurrentAug = CurrentAug.next)
	  {
		 if ((CurrentAug.Class.Name == AugPrefs[PriorityIndex]) && (CurrentAug.bHasIt == False))
		 {
	         AugmentationSystem.GivePlayerAugmentation(CurrentAug.Class);
				// Max out aug
				if (CurrentAug.bHasIt)
					CurrentAug.CurrentLevel = CurrentAug.MaxLevel;
			AugsLeft = AugsLeft - 1;
		 }
	  }
	}
}

// ------------------------------------------------------------------------
// GiveInitialInventory()
// ------------------------------------------------------------------------

function GiveInitialInventory()
{
	local Inventory anItem;

	// Give the player a pistol.

	// spawn it.
	if ((!Level.Game.IsA('DeusExMPGame')) || (DeusExMPGame(Level.Game).bStartWithPistol))
	{
	  anItem = Spawn(class'WeaponPistol');
	  // "frob" it for pickup.  This will spawn a copy and give copy to player.
	  anItem.Frob(Self,None);
	  // Set it to be in belt (it will be the first inventory item)
	  inventory.bInObjectBelt = True;
	  // destroy original.
	  anItem.Destroy();

	  // Give some starting ammo.
	  anItem = Spawn(class'Ammo10mm');
	  DeusExAmmo(anItem).AmmoAmount=50;
	  anItem.Frob(Self,None);
	  anItem.Destroy();
	}

	// Give the player a medkit.
	anItem = Spawn(class'MedKit');
	anItem.Frob(Self,None);
	inventory.bInObjectBelt = True;
	anItem.Destroy();

	// Give them a lockpick and a multitool so they can make choices with skills
	// when they come across electronics and locks
	anItem = Spawn(class'Lockpick');
	anItem.Frob(Self,None);
	inventory.bInObjectBelt = True;
	anItem.Destroy();

	anItem = Spawn(class'Multitool');
	anItem.Frob(Self,None);
	inventory.bInObjectBelt = True;
	anItem.Destroy();
}

// ----------------------------------------------------------------------
// MultiplayerTick()
// Not the greatest name, handles single player ticks as well.  Basically
// anything tick style stuff that should be propagated to the server gets
// propagated as this one function call.
// ----------------------------------------------------------------------
function MultiplayerTick(float DeltaTime)
{
	local int burnTime;
	local float augLevel;

	Super.MultiplayerTick(DeltaTime);

	//If we've just put away items, reset this.
	if ((LastInHand != InHand) && (Level.Netmode == NM_Client) && (inHand == None))
	{
	   ClientInHandPending = None;
	}

    //handle crouch toggle
    HandleCrouchToggle();

	LastInHand = InHand;

	if ((PlayerIsClient()) || (Level.NetMode == NM_ListenServer))
	{
	  if ((ShieldStatus != SS_Off) && (DamageShield == None))
		 DrawShield();
		if ( (NintendoImmunityTimeLeft > 0.0) && ( InvulnSph == None ))
			DrawInvulnShield();
	  if (Style != STY_Translucent)
		 CreateShadow();
	  else
		 KillShadow();
	}

	if (Role < ROLE_Authority)
	  return;

	UpdateInHand();

	UpdatePoison(DeltaTime);

	if (lastRefreshTime < 0)
	  lastRefreshTime = 0;

	lastRefreshTime = lastRefreshTime + DeltaTime;

	if (bOnFire)
	{
		if ( Level.NetMode != NM_Standalone )
			burnTime = Class'WeaponFlamethrower'.Default.mpBurnTime;
		else
			burnTime = Class'WeaponFlamethrower'.Default.BurnTime;
		burnTimer += deltaTime;
		if (burnTimer >= burnTime)
			ExtinguishFire();
	}

	if (lastRefreshTime < 0.25)
	  return;

	if (ShieldTimer > 0)
	  ShieldTimer = ShieldTimer - lastRefreshTime;

	if (ShieldStatus == SS_Fade)
	  ShieldStatus = SS_Off;

	if (ShieldTimer <= 0)
	{
	  if (ShieldStatus == SS_Strong)
		 ShieldStatus = SS_Fade;
	}

    //Sarge: If we're carrying an object we can no longer carry (such as running out of energy while using Microfibral Muscle), drop it
    if (CarriedDecoration != None && !CanBeLifted(CarriedDecoration))
    {
        DropDecoration();
    }

	// If we have a drone active (post-death etc) and we're not using the aug, kill it off
	augLevel = AugmentationSystem.GetAugLevelValue(class'AugDrone');
	if (( aDrone != None ) && (augLevel == -1.0))
		aDrone.TakeDamage(100, None, aDrone.Location, vect(0,0,0), 'EMP');

	if ( Level.Timeseconds > ServerTimeLastRefresh )
	{
		SetServerTimeDiff( Level.Timeseconds );
		ServerTimeLastRefresh = Level.Timeseconds + 10.0;
	}

	MaintainEnergy(lastRefreshTime);
	UpdateTranslucency(lastRefreshTime);
	if ( bNintendoImmunity )
	{
		NintendoImmunityTimeLeft = NintendoImmunityTime - Level.Timeseconds;
		if ( Level.Timeseconds > NintendoImmunityTime )
			NintendoImmunityEffect( False );
	}
	RepairInventory();
	lastRefreshTime = 0;

    //Tick down killswitch
    if (bRealKillswitch && killswitchTimer == 0)
    {
        killswitchTimer = 1;
        TakeDamage(1,None,Location,vect(0,0,0),'Poison');
    }
}

// ----------------------------------------------------------------------

function ForceDroneOff(optional bool skipDeactivation)
{
	local AugDrone anAug;

    if (AugmentationSystem != none)                                             //RSD: fix
    {
        anAug = AugDrone(AugmentationSystem.FindAugmentation(class'AugDrone'));
        //foreach AllActors(class'AugDrone', anAug)
        if (anAug != None)
        {
            if (bSpyDroneSet)
            {
                SAVErotation = ViewRotation;
                bSpyDroneSet = false;                                                 //RSD: Ensures that the Spy Drone will ACTUALLY be turned off
            }
            if (!skipDeactivation)
            {
                anAug.Deactivate();
                bSpyDroneActive = false;                                                  //RSD: Prevents being forced back into drone control at the last second
            }
        }
    }
}

// ----------------------------------------------------------------------
// PlayerIsListenClient()
// Returns True if the current player is the "client" playing ON the
// listen server.
// ----------------------------------------------------------------------
function bool PlayerIsListenClient()
{
	return ((GetPlayerPawn() == Self) && (Level.NetMode == NM_ListenServer));
}

// ----------------------------------------------------------------------
// PlayerIsRemoteClient()
// Returns true if this player is the main player of this remote client
// -----------------------------------------------------------------------
function bool PlayerIsRemoteClient()
{
	return ((Level.NetMode == NM_Client) && (Role == ROLE_AutonomousProxy));
}

// ----------------------------------------------------------------------
// PlayerIsClient()
// Returns true if the current player is the "client" playing ON the
// listen server OR a remote client
// ----------------------------------------------------------------------
function bool PlayerIsClient()
{
	return (PlayerIsListenClient() || PlayerIsRemoteClient());
}

// ----------------------------------------------------------------------
// DrawShield()
// ----------------------------------------------------------------------
simulated function DrawShield()
{
	local ShieldEffect shield;

	if (DamageShield != None)
	{
	  return;
	}

	shield = Spawn(class'ShieldEffect', Self,, Location, Rotation);
	if (shield != None)
	{
		shield.SetBase(Self);
	  shield.RemoteRole = ROLE_None;
	  shield.AttachedPlayer = Self;
	}

	DamageShield = shield;
}

// ----------------------------------------------------------------------
// DrawInvulnShield()
// ----------------------------------------------------------------------
simulated function DrawInvulnShield()
{
	if (( InvulnSph != None ) || (Level.NetMode == NM_Standalone))
		return;

	InvulnSph = Spawn(class'InvulnSphere', Self, , Location, Rotation );
	if ( InvulnSph != None )
	{
		InvulnSph.SetBase( Self );
		InvulnSph.RemoteRole = ROLE_None;
		InvulnSph.AttachedPlayer = Self;
		InvulnSph.LifeSpan = NintendoImmunityTimeLeft;
	}
}

// ----------------------------------------------------------------------
// CreatePlayerTracker()
// ----------------------------------------------------------------------
simulated function CreatePlayerTracker()
{
	local MPPlayerTrack PlayerTracker;

	PlayerTracker = Spawn(class'MPPlayerTrack');
	PlayerTracker.AttachedPlayer = Self;
}

// ----------------------------------------------------------------------
// DisconnectPlayer()
// ----------------------------------------------------------------------
exec function DisconnectPlayer()
{
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();

	if (PlayerIsRemoteClient())
	  ConsoleCommand("disconnect");

	if (PlayerIsListenClient())
	  ConsoleCommand("start dx.dx");
}

exec function ShowPlayerPawnList()
{
	local pawn curpawn;

	for (curpawn = level.pawnlist; curpawn != none; curpawn = curpawn.nextpawn)
	  log("======>Pawn is "$curpawn);
}

// ----------------------------------------------------------------------
// KillShadow
// ----------------------------------------------------------------------
simulated function KillShadow()
{
	if (Shadow != None)
	  Shadow.Destroy();
	Shadow = None;
}

// ----------------------------------------------------------------------
// CreateShadow
// ----------------------------------------------------------------------
simulated function CreateShadow()
{
	if (Shadow == None)
	{
	  Shadow = Spawn(class'Shadow', Self,, Location-vect(0,0,1)*CollisionHeight, rot(16384,0,0));
	  if (Shadow != None)
	  {
		 Shadow.RemoteRole = ROLE_None;
	  }
	}
}

// ----------------------------------------------------------------------
// LocalLog
// ----------------------------------------------------------------------
function LocalLog(String S)
{
	if (( Player != None ) && ( Player.Console != None ))
		Player.Console.AddString(S);
}

// ----------------------------------------------------------------------
// ShowDemoSplash()
// ----------------------------------------------------------------------
function ShowDemoSplash()
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.PushWindow(Class'DemoSplashWindow');
}

// ----------------------------------------------------------------------
// VerifyConsole()
// Verifies that console is Engine.Console.  If you want something different,
// override this in a subclassed player class.
// ----------------------------------------------------------------------

function VerifyConsole(Class<Console> ConsoleClass)
{
	local bool bCheckPassed;

	bCheckPassed = True;

	if (Player.Console == None)
		bCheckPassed = False;
	else if (Player.Console.Class != ConsoleClass)
		bCheckPassed = False;

	if (bCheckPassed == False)
		FailConsoleCheck();
}

// ----------------------------------------------------------------------
// VerifyRootWindow()
// Verifies that the root window is the right kind of root window, since
// it can be changed in the ini
// ----------------------------------------------------------------------
function VerifyRootWindow(Class<DeusExRootWindow> WindowClass)
{
	local bool bCheckPassed;

	bCheckPassed = True;

	if (RootWindow == None)
		bCheckPassed = False;
	else if (RootWindow.Class != WindowClass)
		bCheckPassed = False;

	if (bCheckPassed == False)
		FailRootWindowCheck();
}

// ----------------------------------------------------------------------
// FailRootWindowCheck()
// ----------------------------------------------------------------------
function FailRootWindowCheck()
{
	if (Level.Game.IsA('DeusExGameInfo'))
		DeusExGameInfo(Level.Game).FailRootWindowCheck(Self);
}

// ----------------------------------------------------------------------
// FailConsoleCheck()
// ----------------------------------------------------------------------
function FailConsoleCheck()
{
	if (Level.Game.IsA('DeusExGameInfo'))
		DeusExGameInfo(Level.Game).FailConsoleCheck(Self);
}

// ----------------------------------------------------------------------
// Possess()
// ----------------------------------------------------------------------
event Possess()
{
	Super.Possess();

	if (Level.Netmode == NM_Client)
	{
		ClientPossessed();
	}
}

// ----------------------------------------------------------------------
// ClientPossessed()
// ----------------------------------------------------------------------
function ClientPossessed()
{
	if (Level.Game.IsA('DeusExGameInfo'))
		DeusExGameInfo(Level.Game).ClientPlayerPossessed(Self);
}

// ----------------------------------------------------------------------
// ForceDisconnect
// ----------------------------------------------------------------------
function ForceDisconnect(string Message)
{
	player.Console.AddString(Message);
	DisconnectPlayer();
}


/*
//----------------------------------------------------------------------------
// dasraiser keybind move offset and rotations
//
exec function MyFovPos()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyFovPos();
}
exec function MyFovNeg()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyFovNeg();
}

exec function MyOfsetYPos()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetYPos();
}
exec function MyOfsetXPos()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetXPos();
}
exec function MyOfsetZPos()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetZPos();
}
exec function MyOfsetYNeg()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetYNeg();
}
exec function MyOfsetXNeg()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetXNeg();

}
exec function MyOfsetZNeg()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetZNeg();
}
exec function MyOfsetRollPlus()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetRollPlus();
}
exec function MyOfsetPitchPlus()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetPitchPlus();
}
exec function MyOfsetYawPlus()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetYawPlus();
}

exec function MyOfsetRollMinus()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetRollMinus();
}
exec function MyOfsetPitchMinus()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetPitchMinus();
}
exec function MyOfsetYawMinus()
{
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyOfsetYawMinus();
}
exec function MyLogInfos()
{
	log("test");
	if ((inHand!=none)&&(inHand.IsA('DeusExWeapon')))
	  DeusExWeapon(inHand).MyLogInfos();
}


*/

/*function ChangeAllMaxAmmo()                                                     //RSD: Function to cycle through ammo types and change their MaxAmmo (not used)
{
	local DeusExAmmo ammotype;
	local float augmultadd;

	augmultadd = 0.0;

	if (AugmentationSystem != none)
    	if (self.AugmentationSystem.GetAugLevelValue(class'AugAmmoCap') > 0.0)
            augmultadd = self.AugmentationSystem.GetAugLevelValue(class'AugAmmoCap');

	foreach AllActors(class'DeusExAmmo', ammotype)
	{
		ChangeThisMaxAmmo(ammotype, augmultadd);
	}
}*/

/*function ChangeThisMaxAmmo(DeusExAmmo ammotype, float augmultadd)               //RSD: Function to determine new maxAmmo (not used)
{
	local float mult;
    local class associatedSkill;

    mult = 1.0;

    associatedSkill = ammotype.default.ammoSkill;

    if (associatedSkill != class'SkillDemolition')
    	mult += augmultadd;

    if (associatedSkill != none && associatedSkill != class'DeusEx.SkillDemolition')
    	mult -= SkillSystem.GetSkillLevelValue(associatedSkill);
   	else if (associatedSkill == class'DeusEx.SkillDemolition')
   		mult -= 4*SkillSystem.GetSkillLevelValue(associatedSkill);

    ammotype.ChangeMaxAmmo(mult);
    BroadcastMessage(ammotype.maxAmmo);
}*/

function int GetAdjustedMaxAmmo(Ammo ammotype)
{
	local int adjustedMaxAmmo;
    local float mult;
    local class associatedSkill;
    local DeusExAmmo DXammotype;
    local Perk lawfare;

    mult = 1.0;

    //SARGE: Special case for LAW ammo
    if (ammoType.IsA('AmmoLAW'))
    {
        lawfare = PerkManager.GetPerkWithClass(class'PerkLawfare');
        if (lawfare != None && lawfare.bPerkObtained)
            return lawfare.PerkValue;
        else
            return 1;
    }

    else if (ammotype.IsA('DeusExAmmo'))
    {
        DXammotype = DeusExAmmo(ammotype);
        adjustedMaxAmmo = DXammotype.default.MaxAmmo;
        associatedSkill = DXammotype.default.ammoSkill;
        if (AugmentationSystem != none)
            if (self.AugmentationSystem.GetAugLevelValue(class'AugAmmoCap') > 0.0 && !DXAmmotype.default.bHarderScaling)// || associatedSkill != class'SkillWeaponLowTech'))
                mult += AugmentationSystem.GetAugLevelValue(class'AugAmmoCap');

        if (!DXAmmotype.default.bHarderScaling)
            mult += -2*SkillSystem.GetSkillLevelValue(associatedSkill)-0.5;
        else
            mult += -4*SkillSystem.GetSkillLevelValue(associatedSkill)-0.5;
    }
    else
    {
        adjustedMaxAmmo = ammotype.default.MaxAmmo;
    }
    //if (bHalveAmmo || (bHardcoreMode && bExtraHardcore))                        //RSD: Hardcore+ forces on halved max ammo
  	//	mult *= 0.5;
    if (mult <= 0.5)
    	mult = 0.5;

    adjustedMaxAmmo = int(float(adjustedMaxAmmo)*mult);
    //BroadcastMessage(adjustedMaxAmmo);
    return adjustedMaxAmmo;
}

exec function AllAmmo()                                                         //RSD: Function to override PlayerPawn in Engine classes for adjusted ammo counts
{
	local Inventory Inv;

	if( !bCheatsEnabled )
		return;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	// DEUS_EX CNN - make this be limited by the MaxAmmo per ammo instead of 999
	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
		if (Ammo(Inv)!=None)
            Ammo(Inv).AmmoAmount  = GetAdjustedMaxAmmo(Ammo(Inv));     //RSD: Replaced Ammo(Inv).MaxAmmo with adjusted
}

//SARGE: Plays the breathing sound based on gender
function PlayBreatheSound()
{
    if (FlagBase.GetBool('LDDPJCIsFemale')) //Sarge: Lay-D Denton support
        PlaySound(Sound(DynamicLoadObject("FemJC.FJCGasp", class'Sound', false)), SLOT_None, 0.8);
    else
        PlaySound(sound'MaleBreathe', SLOT_None,0.8);
}

function RegenStaminaTick(float deltaTime)                                      //RSD: New general stamina regen function for various state tick codes
{
	local float mult;
    local float base;
	local Perk perkEndurance;
    
    //SARGE: Stop regen if we're poisoned
    if (poisonCounter > 0)
        return;

	perkEndurance = PerkManager.GetPerkWithClass(class'DeusEx.PerkEndurance');

    if (AugmentationSystem != none)                                             //RSD: accessed none
    {
    mult = AugmentationSystem.GetAugLevelValue(class'AugAqualung');
	if (mult == -1.0)
		mult = 1.0;
	}
	else
        mult = 1.0;
	//RSD: base regen now 2.0, now properly multiplied with additive increases/decreases
	if (perkEndurance.bPerkObtained == true)                                                //RSD: endurance perk adds x2
		mult += perkEndurance.PerkValue;
	if (AddictionManager.addictions[DRUG_TOBACCO].bInWithdrawals == true)                                           //RSD: if suffering from nicotine withdrawal, subtract x0.5
		mult -= 0.5;
	if (AddictionManager.addictions[DRUG_TOBACCO].drugTimer > 0)                                                 //RSD: Zyme adds x2
		mult += 1.0;
      
    //SARGE: Increase at the same rate regardless of athletics skill
    //Was hardcoded at 5
    //base swimDuration is 18 seconds, 36 seconds at Master
    base = swimDuration / 3.6;
      
    swimTimer += base*mult*deltaTime;
	if (swimTimer > swimDuration)
	{
		swimTimer = swimDuration;
		bStunted = false;
	}
}

//Sarge: Checks if Lay-D Denton Mod is installed
function bool FemaleEnabled()
{
    local Texture TTex;
	TTex = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonFemale_1", class'Texture', true));
	return TTex != None;
}

//SARGE: We can be stunted through stamina, which needs to be recharged (bStunted), or through
//specific events like explosions (stuntedtime)
function bool IsStunted()
{
    return bStunted || stuntedTime > 0;
}


// ----------------------------------------------------------------------
// LipSynch()
// Copied over from Engine/Pawn.uc
// SARGE: Attempts to fix the janky DX lipsynching
// Based on the idea from https://www.youtube.com/watch?v=oxTWU2YgzfQ, but
// doesn't use any code from it.
// ----------------------------------------------------------------------

function HandleBlink()
{
	// blink randomly
	if (animTimer[0] > 3.5)
	{
		if (FRand() < 0.4 && bEnableBlinking)
        {
            animTimer[0] = 0;
			PlayBlendAnim('Blink', 0.2, 0.1, 1);
        }
        else
            animTimer[0] = 2; //Make us more likely to blink again sooner
	}
}

function LipSynch(float deltaTime)
{
	local name animseq;
	local float rnd;
	local float tweentime;

	// update the animation timers that we are using
	animTimer[0] += deltaTime;
	animTimer[1] += deltaTime;
	animTimer[2] += deltaTime;
        
    if (iEnhancedLipSync == 1)
        tweentime = 0.225;
    else if (iEnhancedLipSync == 2)
        tweentime = 0;
    else if (Level.TimeSeconds - animTimer[3]  < 0.05)
        tweentime = 0.1;

    // the last animTimer slot is used to check framerate
    animTimer[3] = Level.TimeSeconds;

	if (bIsSpeaking)
	{

		if (nextPhoneme == "A")
			animseq = 'MouthA';
		else if (nextPhoneme == "E")
			animseq = 'MouthE';
		else if (nextPhoneme == "F")
			animseq = 'MouthF';
		else if (nextPhoneme == "M")
			animseq = 'MouthM';
		else if (nextPhoneme == "O")
			animseq = 'MouthO';
		else if (nextPhoneme == "T")
			animseq = 'MouthT';
		else if (nextPhoneme == "U")
			animseq = 'MouthU';
		else if (nextPhoneme == "X")
			animseq = 'MouthClosed';

        /*
        if (lastPhoneme == "E" && nextPhoneme == "E")
            nextPhoneme = "A";
        else if (lastPhoneme == "A" && nextPhoneme == "A")
            nextPhoneme = "E";
        */

		if (animseq != '')
		{
			if (lastPhoneme != nextPhoneme)
			{
				lastPhoneme = nextPhoneme;
				TweenBlendAnim(animseq, tweentime);
			}
		}
	}
	else if (bWasSpeaking)
	{
		bWasSpeaking = False;
		TweenBlendAnim('MouthClosed', tweentime);
	}

    HandleBlink();
	LoopHeadConvoAnim();
	LoopBaseConvoAnim();
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     seed=-1;
     bNumberedDialog=True
     bCreditsInDialog=True
     TruePlayerName="JC Denton"
     CombatDifficulty=1.000000
     SkillPointsTotal=5000
     SkillPointsAvail=5000
     Credits=500
     Energy=100.000000
     EnergyMax=100.000000
     MaxRegenPoint=25.000000
     RegenRate=1.500000
     MaxFrobDistance=112.000000
     maxInvRows=6
     maxInvCols=5
     bBeltIsMPInventory=True
     RunSilentValue=1.000000
     ClotPeriod=30.000000
     strStartMap="01_NYC_UNATCOIsland"
     bObjectNames=True
     bNPCHighlighting=True
     bWallPlacementCrosshair=True
     bSubtitles=True
     bSubtitlesCutscene=True
     bBeltAutofill=True
     bAlwaysRun=True
     logTimeout=3.000000
     maxLogLines=4
     bHelpMessages=True
     bObjectBeltVisible=True
     bHitDisplayVisible=True
     bAmmoDisplayVisible=True
     bAugDisplayVisible=True
     bDisplayAmmoByClip=True
     bCompassVisible=True
     bCrosshairVisible=True
     bAutoReload=True
     bDisplayAllGoals=True
     bHUDShowAllAugs=True
     bShowAmmoDescriptions=True
     bConfirmSaveDeletes=True
     bConfirmNoteDeletes=True
     bAskedToTrain=True
     AugPrefs(0)=AugVision
     AugPrefs(1)=AugHealing
     AugPrefs(2)=AugSpeed
     AugPrefs(3)=AugDefense
     AugPrefs(4)=AugBallistic
     AugPrefs(5)=AugShield
     AugPrefs(6)=AugEMP
     AugPrefs(7)=AugStealth
     AugPrefs(8)=AugAqualung
     MenuThemeName="Default"
     HUDThemeName="Default"
     bHUDBordersVisible=True
     bHUDBordersTranslucent=True
     bHUDBackgroundTranslucent=True
     bMenusTranslucent=True
     InventoryFull="You don't have enough room in your inventory to pick up the %s"
     TooMuchAmmo="You already have enough of that type of ammo"
     TooHeavyToLift="It's too heavy to lift"
     CannotLift="You can't lift that"
     NoRoomToLift="There's no room to lift that"
     CanCarryOnlyOne="You can only carry one %s"
     CannotDropHere="Can't drop that here"
     HandsFull="Your hands are full"
	 CantBreakDT="Strongest melee damage doesn't pass threshold"
     NoteAdded="Note Received - Check DataVault For Details"
     GoalAdded="Goal Received - Check DataVault For Details"
     PrimaryGoalCompleted="Primary Goal Completed"
     SecondaryGoalCompleted="Secondary Goal Completed"
     EnergyDepleted="Bio-electric energy reserves depleted"
     EnergyCantReserve="Not enough reserve Bio-Energy"
     AddedNanoKey="%s added to Nano Key Ring"
     DuplicateNanoKey="%s not added to Key Ring [Duplicate]"
     HealedPointsLabel="Healed %d points"
     HealedPointLabel="Healed %d point"
     RechargedPointsLabel="Recharged %d points"
     RechargedPointLabel="Recharged %d point"
     SkillPointsAward="%d skill points awarded"
     QuickSaveGameTitle="Quick Save [%s]"
     AutoSaveGameTitle="Auto Save [%s]"
     WeaponUnCloak="Weapon drawn... Uncloaking"
     TakenOverString="I've taken over the "
     HeadString="Head"
     TorsoString="Torso"
     LegsString="Legs"
     WithTheString=" with the "
     WithString=" with "
     PoisonString=" with deadly poison"
     BurnString=" with excessive burning"
     NoneString="None"
     MPDamageMult=1.000000
     iQuickSaveMax=5
     iAutoSaveMax=3
     bTogAutoSave=True
     bColorCodedAmmo=True
     bHardcoreAI3=True
     bAnimBar1=True
     bAnimBar2=True
     bRealisticCarc=True
     bRemoveVanillaDeath=True
     bHitmarkerOn=True
     bMantleOption=True
     bSkillMessage=True
     bModdedHeadBob=True
     fatty="You cannot consume any more at this time"
     noUsing="You cannot use it at this time"
     msgDeclinedPickup="%s is declined. Press again to pick up."
     customColorsMenu(0)=(R=61,G=62,B=73)
     customColorsMenu(1)=(G=49,B=255)
     customColorsMenu(2)=(R=210,G=194,B=255)
     customColorsMenu(3)=(R=107,G=107,B=107)
     customColorsMenu(4)=(R=185,G=185,B=185)
     customColorsMenu(5)=(R=255,G=255,B=255)
     customColorsMenu(6)=(R=86,G=38,B=24)
     customColorsMenu(7)=(R=206,G=206,B=202)
     customColorsMenu(8)=(R=204,G=198,B=201)
     customColorsMenu(9)=(R=255)
     customColorsMenu(10)=(G=255)
     customColorsMenu(11)=(R=255,G=64)
     customColorsMenu(12)=(G=255)
     customColorsMenu(13)=(R=128,G=128,B=128)
     customColorsHUD(0)=(R=32,G=32,B=32)
     customColorsHUD(1)=(R=217)
     customColorsHUD(2)=(R=128)
     customColorsHUD(3)=(R=167)
     customColorsHUD(4)=(R=167,G=164,B=164)
     customColorsHUD(5)=(R=255)
     customColorsHUD(6)=(R=112)
     customColorsHUD(7)=(R=204,G=202,B=204)
     customColorsHUD(8)=(R=201,G=201,B=201)
     customColorsHUD(9)=(R=201)
     customColorsHUD(10)=(R=255,G=255,B=255)
     customColorsHUD(11)=(B=86)
     customColorsHUD(12)=(R=255)
     customColorsHUD(13)=(R=128,G=128,B=128)
     LightLevelDisplay=-1
     advBelt=1
     RocketTargetMaxDistance=40000.000000
     bShowStatus=True
     bShowAugStatus=True
     bStaminaSystem=True
     RecoilSimLimit=(X=7.000000,Y=16.000000,Z=7.000000)
     RecoilDrain=0.950000
     RecoilTime=0.140000
     NanoVirusLabel="Augmentation system scrambled for %d seconds"
     augOrderList(0)=(aug1=AugMuscle,aug2=AugCombat)
     augOrderList(1)=(aug1=AugAqualung,aug2=AugEnviro)
     augOrderList(2)=(aug1=AugSpeed,aug2=AugStealth)
     augOrderList(3)=(aug1=AugVision,aug2=AugTarget)
     augOrderList(4)=(aug1=AugBallistic,aug2=AugBallisticPassive)
     augOrderList(5)=(aug1=AugSpeed,aug2=AugStealth)
     augOrderList(6)=(aug1=AugCombatStrength,aug2=AugAmmoCap)
     augOrderList(7)=(aug1=AugDrone,aug2=AugDefense)
     augOrderList(8)=(aug1=AugHealing,aug2=AugShield)
     augOrderList(9)=(aug1=AugVision,aug2=AugTarget)
     augOrderList(10)=(aug1=AugCloak,aug2=AugRadarTrans)
     augOrderList(11)=(aug1=AugDrone,aug2=AugDefense)
     augOrderList(12)=(aug1=AugHeartLung,aug2=AugPower)
     augOrderList(13)=(aug1=AugCombatStrength,aug2=AugAmmoCap)
     augOrderList(14)=(aug1=AugAqualung,aug2=AugEnviro)
     augOrderList(15)=(aug1=AugBallistic,aug2=AugBallisticPassive)
     augOrderList(16)=(aug1=AugMuscle,aug2=AugCombat)
     augOrderList(17)=(aug1=AugSpeed,aug2=AugStealth)
     augOrderList(18)=(aug1=AugHealing,aug2=AugShield)
     augOrderList(19)=(aug1=AugCloak,aug2=AugRadarTrans)
     augOrderList(20)=(aug1=AugHeartLung,aug2=AugPower)
     bCanStrafe=True
     MeleeRange=50.000000
     GroundSpeed=360.000000
     AccelRate=1024.000000
     FovAngle=75.000000
     Intelligence=BRAINS_HUMAN
     AngularResolution=0.500000
     Alliance=Player
     DrawType=DT_Mesh
     SoundVolume=64
     RotationRate=(Pitch=3072,Yaw=65000,Roll=2048)
     BindName="JCDenton"
     FamiliarName="JC Denton"
     UnfamiliarName="JC Denton"
     bEnhancedWeaponOffsets=false
     bQuickAugWheel=false
     bAugWheelDisableAll=true
     bAugWheelFreeCursor=true
     bColourCodeFrobDisplay=True
     bWallPlacementCrosshair=True
     dynamicCrosshair=1
     bBeltMemory=True
     bEnhancedCorpseInteractions=True
     bBeltShowModified=true;
     bSearchedCorpseText=True
     bDisplayClips=true
     bCutsceneFOVAdjust=true
     iFrobDisplayStyle=1
     bShowDataCubeRead=true;
     iAllowCombatMusic=1
     bFullAccuracyCrosshair=true;
     bShowEnergyBarPercentages=true;
     bSimpleAugSystem=true
     bBigDroneView=True
     bSimpleAugSystem=true
	 MenuThemeNameGMDX="Default"
     HUDThemeNameGMDX="Default"
     dblClickHolster=2
     bSmartDecline=True
     killswitchTimer=-2
     bEnhancedMusicSystem=1
     bMedbotAutoswitch=True
     bHDTPEnabled=True
     iEnhancedLipSync=1
     bEnableBlinking=True
     iDeathSoundMode=2
     bBiggerBelt=True
     iPersistentDebris=1
}
