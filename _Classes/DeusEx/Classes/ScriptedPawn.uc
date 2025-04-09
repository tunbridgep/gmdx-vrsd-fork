//=============================================================================
// ScriptedPawn.
//=============================================================================
class ScriptedPawn expands Pawn
	abstract
	native;

// ----------------------------------------------------------------------
// Enumerations

enum EDestinationType  {
	DEST_Failure,
	DEST_NewLocation,
	DEST_SameLocation
};


enum EAllianceType  {
	ALLIANCE_Friendly,
	ALLIANCE_Neutral,
	ALLIANCE_Hostile
};


enum ERaiseAlarmType  {
	RAISEALARM_BeforeAttacking,
	RAISEALARM_BeforeFleeing,
	RAISEALARM_Never
};


enum ESeekType  {
	SEEKTYPE_None,
	SEEKTYPE_Sound,
	SEEKTYPE_Sight,
	SEEKTYPE_Guess,
	SEEKTYPE_Carcass
};


enum EHitLocation  {
	HITLOC_None,
	HITLOC_HeadFront,
	HITLOC_HeadBack,
	HITLOC_TorsoFront,
	HITLOC_TorsoBack,
	HITLOC_LeftLegFront,
	HITLOC_LeftLegBack,
	HITLOC_RightLegFront,
	HITLOC_RightLegBack,
	HITLOC_LeftArmFront,
	HITLOC_LeftArmBack,
	HITLOC_RightArmFront,
	HITLOC_RightArmBack
};


enum ETurning  {
	TURNING_None,
	TURNING_Left,
	TURNING_Right
};


// ----------------------------------------------------------------------
// Structures

struct WanderCandidates  {
	var WanderPoint point;
	var Actor       waypoint;
	var float       dist;
};

struct FleeCandidates  {
	var HidePoint point;
	var Actor     waypoint;
	var Vector    location;
	var float     score;
	var float     dist;
};

struct NearbyProjectile  {
	var DeusExProjectile projectile;
	var vector           location;
	var float            dist;
	var float            range;
};

struct NearbyProjectileList  {
	var NearbyProjectile list[8];
	var vector           center;
};


struct InitialAllianceInfo  {
	var() Name  AllianceName;
	var() float AllianceLevel;
	var() bool  bPermanent;
};

struct AllianceInfoEx  {
	var Name  AllianceName;
	var float AllianceLevel;
	var float AgitationLevel;
	var bool  bPermanent;
};

struct InventoryItem  {
	var() class<Inventory> Inventory;
	var() int              Count;
};


// ----------------------------------------------------------------------
// Variables

var WanderPoint      lastPoints[2];
var float            Restlessness;  // 0-1
var float            Wanderlust;    // 0-1
var float            Cowardice;     // 0-1

var(Combat) float    BaseAccuracy;  // 0-1 or thereabouts
var(Combat) float    MaxRange;
var(Combat) float    MinRange;
var(Combat) float    MinHealth;

var(AI) float    RandomWandering;  // 0-1

var float       sleepTime;
var Actor       destPoint;
var Vector      destLoc;
var Vector      useLoc;
var Rotator     useRot;
var float       seekDistance;  // OBSOLETE
var int         SeekLevel;
var ESeekType   SeekType;
var Pawn        SeekPawn;
var float       CarcassTimer;
var float       CarcassHateTimer;  // OBSOLETE
var float       CarcassCheckTimer;
var name        PotentialEnemyAlliance;
var float       PotentialEnemyTimer;
var float       BeamCheckTimer;
var bool        bSeekPostCombat;
var bool        bSeekLocation;
var bool        bInterruptSeek;
var bool        bAlliancesChanged;         // set to True whenever someone changes AlliancesEx[i].AllianceLevel to indicate we must do alliance updating
var bool        bNoNegativeAlliances;      // True means we know all alliances are currently +, allows us to skip CheckEnemyPresence's slow part
var bool        bSitAnywhere;

var bool        bSitInterpolation;
var bool        bStandInterpolation;
var float       remainingSitTime;
var float       remainingStandTime;
var vector      StandRate;
var float       ReloadTimer;
var bool        bReadyToReload;

var(Pawn) class<carcass> CarcassType;		// mesh to use when killed from the front

// Advanced AI attributes.
var(Orders) name	Orders;         // orders a creature is carrying out
								  // will be initial state, plus creature will attempt
								  // to return to this state
var(Orders) name  OrderTag;       // tag of object referred to by orders
var(Orders) name  HomeTag;        // tag of object to use as home base
var(Orders) float HomeExtent;     // extent of home base
var         actor OrderActor;     // object referred to by orders (if applicable)
var         name  NextAnim;       // used in states with multiple, sequenced animations
var         float WalkingSpeed;   // 0-1

var(Combat)	float ProjectileSpeed;
var         name  LastPainAnim;
var         float LastPainTime;

var         vector DesiredPrePivot;
var         float  PrePivotTime;
var         vector PrePivotOffset;

var     bool        bCanBleed;      // true if an NPC can bleed
var     float       BleedRate;      // how profusely the NPC is bleeding; 0-1
var     float       DropCounter;    // internal; used in tick()
var()   float       ClotPeriod;     // seconds it takes bleedRate to go from 1 to 0

var     bool        bAcceptBump;    // ugly hack
var     bool        bCanFire;       // true if pawn is capable of shooting asynchronously
var(AI) bool        bKeepWeaponDrawn;  // true if pawn should always keep weapon drawn
var(AI) bool        bShowPain;      // true if pawn should play pain animations
var(AI) bool        bCanSit;        // true if pawn can sit
var(AI) bool        bAlwaysPatrol;  // true if stasis should be disabled during patrols
var(AI) bool        bPlayIdle;      // true if pawn should fidget while he's standing
var(AI) bool        bLeaveAfterFleeing;  // true if pawn should disappear after fleeing
var(AI) bool        bLikesNeutral;  // true if pawn should treat neutrals as friendlies
var(AI) bool        bUseFirstSeatOnly;   // true if only the nearest chair should be used for
var(AI) bool        bCower;         // true if fearful pawns should cower instead of fleeing
var(AI) bool        bMakeFemale;    // true if pawn is female

var     HomeBase    HomeActor;      // home base
var     Vector      HomeLoc;        // location of home base
var     Vector      HomeRot;        // rotation of home base
var     bool        bUseHome;       // true if home base should be used

var     bool        bInterruptState; // true if the state can be interrupted
var     bool        bCanConverse;    // true if the pawn can converse

var()   bool        bImportant;      // true if this pawn is game-critical
var()   bool        bInvincible;     // true if this pawn cannot be killed

var     bool        bInitialized;    // true if this pawn has been initialized

var(Combat) bool    bAvoidAim;      // avoid enemy's line of fire
var(Combat) bool    bAimForHead;    // aim for the enemy's head
var(Combat) bool    bDefendHome;    // defend the home base
var         bool    bCanCrouch;     // whether we should crouch when firing
var         bool    bSeekCover;     // seek cover
var         bool    bSprint;        // sprint in random directions
var(Combat) bool    bUseFallbackWeapons;  // use fallback weapons even when others are available
var         float   AvoidAccuracy;  // how well we avoid enemy's line of fire; 0-1
var         bool    bAvoidHarm;     // avoid painful projectiles, gas clouds, etc.
var         float   HarmAccuracy;   // how well we avoid harm; 0-1
var         float   CrouchRate;     // how often the NPC crouches, if bCrouch enabled; 0-1
var         float   SprintRate;     // how often the NPC randomly sprints if bSprint enabled; 0-1
var         float   CloseCombatMult;  // multiplier for how often the NPC sprints in close combat; 0-1

// If a stimulation is enabled, it causes an NPC to hate the stimulator
//var(Stimuli) bool   bHateFutz;
var(Stimuli) bool   bHateHacking;  // new
var(Stimuli) bool   bHateWeapon;
var(Stimuli) bool   bHateShot;
var(Stimuli) bool   bHateInjury;
var(Stimuli) bool   bHateIndirectInjury;  // new
//var(Stimuli) bool   bHateGore;
var(Stimuli) bool   bHateCarcass;  // new
var(Stimuli) bool   bHateDistress;
//var(Stimuli) bool   bHateProjectiles;

// If a reaction is enabled, the NPC will react appropriately to a stimulation
var(Reactions) bool bReactFutz;  // new
var(Reactions) bool bReactPresence;         // React to the presence of an enemy (attacking)
var(Reactions) bool bReactLoudNoise;        // Seek the source of a loud noise (seeking)
var(Reactions) bool bReactAlarm;            // Seek the source of an alarm (seeking)
var(Reactions) bool bReactShot;             // React to a gunshot fired by an enemy (attacking)
//var(Reactions) bool bReactGore;             // React to gore appropriately (seeking)
var(Reactions) bool bReactCarcass;          // React to gore appropriately (seeking)
var(Reactions) bool bReactDistress;         // React to distress appropriately (attacking)
var(Reactions) bool bReactProjectiles;      // React to harmful projectiles appropriately

// If a fear is enabled, the NPC will run away from the stimulator
var(Fears) bool     bFearHacking;           // Run away from a hacker
var(Fears) bool     bFearWeapon;            // Run away from a person holding a weapon
var(Fears) bool     bFearShot;              // Run away from a person who fires a shot
var(Fears) bool     bFearInjury;            // Run away from a person who causes injury
var(Fears) bool     bFearIndirectInjury;    // Run away from a person who causes indirect injury
var(Fears) bool     bFearCarcass;           // Run away from a carcass
var(Fears) bool     bFearDistress;          // Run away from a person causing distress
var(Fears) bool     bFearAlarm;             // Run away from the source of an alarm
var(Fears) bool     bFearProjectiles;       // Run away from a projectile

var(AI) bool        bEmitDistress;          // TRUE if NPC should emit distress

var(AI) ERaiseAlarmType RaiseAlarm;         // When to raise an alarm

var     bool        bLookingForEnemy;             // TRUE if we're actually looking for enemies
var     bool        bLookingForLoudNoise;         // TRUE if we're listening for loud noises
var     bool        bLookingForAlarm;             // TRUE if we're listening for alarms
var     bool        bLookingForDistress;          // TRUE if we're looking for signs of distress
var     bool        bLookingForProjectiles;       // TRUE if we're looking for projectiles that can harm us
var     bool        bLookingForFutz;              // TRUE if we're looking for people futzing with stuff
var     bool        bLookingForHacking;           // TRUE if we're looking for people hacking stuff
var     bool        bLookingForShot;              // TRUE if we're listening for gunshots
var     bool        bLookingForWeapon;            // TRUE if we're looking for drawn weapons
var     bool        bLookingForCarcass;           // TRUE if we're looking for carcass events
var     bool        bLookingForInjury;            // TRUE if we're looking for injury events
var     bool        bLookingForIndirectInjury;    // TRUE if we're looking for secondary injury events

var     bool        bFacingTarget;          // True if pawn is facing its target
var(Combat) bool    bMustFaceTarget;        // True if an NPC must face his target to fire
var(Combat) float   FireAngle;              // TOTAL angle (in degrees) in which a pawn may fire if bMustFaceTarget is false
var(Combat) float   FireElevation;          // Max elevation distance required to attack (0=elevation doesn't matter)

var(AI) int         MaxProvocations;
var     float       AgitationSustainTime;
var     float       AgitationDecayRate;
var     float       AgitationTimer;
var     float       AgitationCheckTimer;
var     float       PlayerAgitationTimer;  // hack

var     float       FearSustainTime;
var     float       FearDecayRate;
var     float       FearTimer;
var     float       FearLevel;

var     float       EnemyReadiness;
var     float       ReactionLevel;
var     float       SurprisePeriod;
var     float       SightPercentage;
var     float       CycleTimer;
var     float       CyclePeriod;
var     float       CycleCumulative;
var     Pawn        CycleCandidate;
var     float       CycleDistance;

var     AlarmUnit   AlarmActor;

var     float       AlarmTimer;
var     float       WeaponTimer;
var     float       FireTimer;
var     float       SpecialTimer;
var     float       CrouchTimer;
var     float       BackpedalTimer;

var     bool        bHasShadow;
var     float       ShadowScale;

var     bool        bDisappear;

var     bool        bInTransientState;  // true if the NPC is in a 3rd-tier (transient) state, like TakeHit

var(Alliances) InitialAllianceInfo InitialAlliances[8];
var            AllianceInfoEx      AlliancesEx[16];
var            bool                bReverseAlliances;

var(Pawn) float     BaseAssHeight;

var(AI)   float     EnemyTimeout;
var       float     CheckPeriod;
var       float     EnemyLastSeen;
var       int       SeatSlot;
var       Seat      SeatActor;
var       int       CycleIndex;
var       int       BodyIndex;
var       bool      bRunningStealthy;
var       bool      bPausing;
var       bool      bStaring;
var       bool      bAttacking;
var       bool      bDistressed;
var       bool      bStunned;
var       bool      bSitting;
var       bool      bDancing;
var       bool      bCrouching;

var       bool      bCanTurnHead;

var(AI)   bool      bTickVisibleOnly;   // Temporary?
var()     bool      bInWorld;
var       vector    WorldPosition;
var       bool      bWorldCollideActors;
var       bool      bWorldBlockActors;
var       bool      bWorldBlockPlayers;

var()     bool      bHighlight;         // should this object not highlight when focused?

var(AI)   bool      bHokeyPokey;

var       bool      bConvEndState;

var(Inventory) InventoryItem InitialInventory[8];  // Initial inventory items carried by the pawn

var Bool bConversationEndedNormally;
var Bool bInConversation;
var Actor ConversationActor;						// Actor currently speaking to or speaking to us

var() sound WalkSound;
var float swimBubbleTimer;
var bool  bSpawnBubbles;

var      bool     bUseSecondaryAttack;

var      bool     bWalkAround;
var      bool     bClearedObstacle;
var      bool     bEnableCheckDest;
var      ETurning TurnDirection;
var      ETurning NextDirection;
var      Actor    ActorAvoiding;
var      float    AvoidWallTimer;
var      float    AvoidBumpTimer;
var      float    ObstacleTimer;
var      vector   LastDestLoc;
var      vector   LastDestPoint;
var      int      DestAttempts;

var      float    DeathTimer;
var      float    EnemyTimer;
var      float    TakeHitTimer;

var      name     ConvOrders;
var      name     ConvOrderTag;

var      float    BurnPeriod;

var      float    FutzTimer;

var      float    DistressTimer;

var      vector   SeatLocation;
var      Seat     SeatHack;
var      bool     bSeatLocationValid;
var      bool     bSeatHackUsed;

var      bool     bBurnedToDeath;

var      bool     bHasCloak;
var      bool     bCloakOn;
var      int      CloakThreshold;
var      float    CloakEMPTimer;

var      float    poisonTimer;      // time remaining before next poison TakeDamage
var      int      poisonCounter;    // number of poison TakeDamages remaining
var      int      poisonDamage;     // damage taken from poison effect
var      Pawn     Poisoner;         // person who initiated PoisonEffect damage

var      Name     Carcasses[4];     // list of carcasses seen
var      int      NumCarcasses;     // number of carcasses seen

var      float    walkAnimMult;
var      float    runAnimMult;

//GMDX
var bool        bBurnedUp; //CyberP: for plasma rifle gibbing
var bool        bFlyer;    //CyberP: for pawn knockback
var bool        bSetupPop;      //CyberP: for headpop
var int         extraMult;       //CyberP: variable headshot multiplier
var bool        bRadialBlastClamp;  //CyberP: MiB radial attack
var bool        bCanFlare;   //CyberP: AI can throw flares if conditions are met. Should have used a return function.
var(AI) bool    bHasThrownFlare; //CyberP: has this NPC already thrown a flare?
var bool        bCanNade;   //CyberP: AI can throw nades if conditions are met. Should have used a return function.
var(Combat) bool        bGrenadier; //CyberP: this pawn class can throw nades
var bool        bCommandoMelee;
var bool        bDefensiveStyle;  //CyberP: this pawn doesn't always bum rush the player in close proximity
//var bool        bFrontPop;      //CyberP: for headpop
var int         disturbanceCount; //CyberP: obsolete.
var bool        bAlarmStatIncrease; //CyberP: AI get a one-time stat boost if alarm is triggered
var bool        bHasHelmet;
var bool        bBiteClamp;
var bool        bGreaselShould;
var(Filter) bool        bHardcoreOnly;     // CyberP: remove this pawn from world if we are not hardcore.
var(Filter) bool        bHardcoreRemove;     // CyberP: remove this pawn from world if we ARE hardcore.
var(AI) bool    bCanPop;       //CyberP: if we can pop at all.
var bool        bIcarused;
var float       sFire;         //CyberP: Suppresive fire timer
var bool        bHackFear;
var float       HackFearTimer;
var bool        bSpottedPlayer;  //CyberP: have we spotted the player?
var int         impaleCount;    //CyberP: number of TKs hit this pawn
var bool        bSmartStrafe;  //CyberP: AI strafe around corners facing the player
var float       smartStrafeRate;  //CyberP: the rate in which enemies strafe around corners.
var Name        SpecTexNPC;       //CyberP: used in special case footstep sounds
var bool        bTank;         //CyberP: AI smash through decoration
var vector      GMDXEnemyLastSeenPos;  //CyberP: alt vector for last seen pos.
var float       CombatSeeTimer;       //CyberP: while the enemy can see the player in combat this goes up in deltaSeconds.
var() bool      bSkinInherit;      //CyberP: pass on the skins to carcass WARNING: unreliable.
var bool        bGunVisual;
var float       DeathTimer2;
var float       nadeMult;
var(Combat) bool bStopCamping;
var bool        bReactToBeamGlobal;
var bool        bReactFlareBeam;

//Sarge
var() const float fireReactTime;                                                //Minimum time we must be seeing the player for, before we can fire on them
var float currentReactTime;                                                     //How much time remaining until we can fire

//RSD
var bool bHeadshotAltered;                                                      //RSD: Determines if the headshot multiplier was altered to avoid any edge cases
var int PickupAmmoCount;                                                        //RSD: Ammo count to be passed to DeusExCarcass on death. Initialized in MissionScript.uc on first map load
var float stunSleepTime;                                                        //RSD: Allows input of variable stun times
var bool bStunTimeAltered;                                                      //RSD: Determines if the stun time was altered to avoid any edge cases
var bool bNotFirstDiffMod;                                                      //RSD: Have we already changed difficulty stats?

//Sarge
var(GMDX) bool bDontRandomizeWeapons;                                           //If true, this pawn will never have it's weapons randomised amongst other enemies.

var bool bFirstTickDone;                                                        //SARGE: Set to true after the first tick. Allows us to do stuff on the first frame

//Sarge: Gender Stuff
var(GMDX) const bool requiresLDDP;                                              //Delete this character LDD is uninstalled
var(GMDX) const bool LDDPExtra;                                                 //Delete this character we don't have the "Extra LDDP Characters" playthrough modifier
var(GMDX) const bool deleteIfMale;                                              //Delete this character if we're male
var(GMDX) const bool deleteIfFemale;                                            //Delete this character if we're female

//SARGE: HDTP Model toggles
var config int iHDTPModelToggle;
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;
var string HDTPMeshTex[8];
var travel bool bSetupHDTP;

//SARGE: Blink timer
var float blinkTimer;

//SARGE: Allow randomised pain and death sounds
var Sound randomDeathSoundsM[22];
var Sound randomPainSoundsM[22];
var Sound randomDeathSoundsF[22];
var Sound randomPainSoundsF[22];
var bool bSetupRandomSounds; //Have we set up a random sound?
var Sound randomDeathSoundChoice; //These three variables hold the references to
var Sound randomPainSoundChoice1; //our randomly rolled sounds.
var Sound randomPainSoundChoice2; //Used by the GetDeathSound and GetPainSound functions.
var Sound deathSoundOverride;            //If this is set, we will use this instead of our rolled death sounds.
var bool bDontChangeDeathPainSounds; //If set, we don't randomise death or pain sounds for this actor


native(2102) final function ConBindEvents();

native(2105) final function bool IsValidEnemy(Pawn TestEnemy, optional bool bCheckAlliance);
native(2106) final function EAllianceType GetAllianceType(Name AllianceName);
native(2107) final function EAllianceType GetPawnAllianceType(Pawn QueryPawn);

native(2108) final function bool HaveSeenCarcass(Name CarcassName);
native(2109) final function AddCarcass(Name CarcassName);

// ----------------------------------------------------------------------
// ShouldCreate()
// If this returns FALSE, the object will be deleted on it's first tick
// ----------------------------------------------------------------------

function bool ShouldCreate(DeusExPlayer player)
{
    local bool maleDelete;
    local bool femaleDelete;
    local bool extraDelete;

    maleDelete = !player.FlagBase.GetBool('LDDPJCIsFemale') && deleteIfMale;
    femaleDelete = player.FlagBase.GetBool('LDDPJCIsFemale') && deleteIfFemale;
    extraDelete = LDDPExtra && !player.bMoreLDDPNPCs;

    return !maleDelete && !femaleDelete && !extraDelete && (player.FemaleEnabled() || !requiresLDDP);
}

// ----------------------------------------------------------------------
// PreBeginPlay()
// ----------------------------------------------------------------------

function PreBeginPlay()
{
	local float saveBaseEyeHeight;
    local int i;

	// TODO:
	//
	// Okay, we need to save the base eye height right now becase it's
	// obliterated in Pawn.uc with the following:
	//
	//  EyeHeight = 0.8 * CollisionHeight; //FIXME - if all baseeyeheights set right, use them
	//  BaseEyeHeight = EyeHeight;
	//
	// This must be fixed after ECTS.

	saveBaseEyeHeight = BaseEyeHeight;

	Super.PreBeginPlay();

	if (!bIsFemale)
		bIsFemale = bMakeFemale;  //GMDX

	BaseEyeHeight = saveBaseEyeHeight;

	// create our shadow
	CreateShadow();

	// Set our alliance
	SetAlliance(Alliance);

	// Set up callbacks
	UpdateReactionCallbacks();
}

static function bool IsHDTP()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && default.iHDTPModelToggle > 0;
}

//SARGE: New function to update model meshes (specifics handled in each class)
exec function UpdateHDTPsettings()
{
    local int i;
    local bool hdtp;

    hdtp = IsHDTP();

    //Bail out if we have no need to continue
    if ((hdtp && bSetupHDTP) || (!hdtp && !bSetupHDTP))
        return;

    if (HDTPMesh != "")
    {
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),hdtp);
        //We have to be careful here, or we will break holo-projectors
        for(i = 0; i < 8;i++)
            MultiSkins[i] = class'HDTPLoader'.static.GetTexture2(HDTPMeshTex[i],string(default.MultiSkins[i]),IsHDTP());
    }
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),hdtp);
    if (HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),hdtp);
    bSetupHDTP = hdtp;
}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{

	Super.PostBeginPlay();

    RandomiseSounds();

	//sort out HDTP settings
	UpdateHDTPSettings();
	// Set up pain timer
	if (Region.Zone.bPainZone || HeadRegion.Zone.bPainZone ||
	    FootRegion.Zone.bPainZone)
		PainTime = 5.0;
	else if (HeadRegion.Zone.bWaterZone)
		PainTime = UnderWaterTime;

	// Handle holograms
	if ((Style != STY_Masked) && (Style != STY_Normal))
	{
		SetSkinStyle(Style, None);
		if (!IsA('Terrorist'))
		    SetCollision(false, false, false);
		else
            ScaleGlow = 1.000000;
		KillShadow();
		bHasShadow = False;
	}
}


// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{
	Super.PostPostBeginPlay();

	// Bind any conversation events to this ScriptedPawn
	ConBindEvents();

	//bCloakOn = True;                                                            //RSD: Failsafe
	//EnableCloak(False);
}


// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------

simulated function Destroyed()
{
	local DeusExPlayer player;

	// Pass a message to conPlay, if it exists in the player, that
	// this pawn has been destroyed.  This is used to prevent
	// bad things from happening in converseations.

	player = DeusExPlayer(GetPlayerPawn());

	if ((player != None) && (player.conPlay != None))
		player.conPlay.ActorDestroyed(Self);

	Super.Destroyed();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// GENERAL UTILITIES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// InitializePawn()
// ----------------------------------------------------------------------

function InitializePawn()
{
	if (!bInitialized)
	{
		InitializeInventory();
		InitializeAlliances();
		InitializeHomeBase();

		BlockReactions();

		if (Alliance != '')
			ChangeAlly(Alliance, 1.0, true);

		if (!bInWorld)
		{
			// tricky
			bInWorld = true;
			LeaveWorld();
		}

		// hack!
		animTimer[1] = 20.0;
		PlayTurnHead(LOOK_Forward, 1.0, 0.0001);

		bInitialized = true;
	}
}


// ----------------------------------------------------------------------
// InitializeInventory()
// ----------------------------------------------------------------------

function InitializeInventory()
{
	local int       i, j;
	local Inventory inv;
	local Weapon    weapons[8];
	local int       weaponCount;
	local Weapon    firstWeapon;
    local DeusExPlayer player;                                                  //RSD

    player = DeusExPlayer(GetPlayerPawn());

    if (player.bRandomizeMods)
    	RandomizeMods();                                                        //RSD: Before we do anything, check for random loot

	// Add initial inventory items
	weaponCount = 0;
	for (i=0; i<8; i++)
	{
		if ((InitialInventory[i].Inventory != None) && (InitialInventory[i].Count > 0))
		{
			firstWeapon = None;
			//CyberP: Lazy hack to get rid of UMP weapons equipped by a pawn
			if (InitialInventory[i].Inventory.default.ItemName == "UMP7.62c")
			{
			    InitialInventory[i].Inventory = class'DeusEx.WeaponAssaultGun';
			}
			if (player != none && !player.bHardCoreMode)                        //RSD: also remove EMP underbarrel except on Hardcore
			{
                if (InitialInventory[i].Inventory == Class'DeusEx.WeaponAssaultGunSpider')
				    InitialInventory[i].Inventory = None;
            }

			for (j=0; j<InitialInventory[i].Count; j++)
			{
				inv = None;
				if (Class<Ammo>(InitialInventory[i].Inventory) != None)
				{
					inv = FindInventoryType(InitialInventory[i].Inventory);
					if (inv != None)
						Ammo(inv).AmmoAmount += Class<Ammo>(InitialInventory[i].Inventory).default.AmmoAmount;
				}
				if (inv == None)
				{
					inv = spawn(InitialInventory[i].Inventory, self);
					if (inv != None)
					{
						inv.InitialState='Idle2';
						inv.GiveTo(Self);
						inv.SetBase(Self);
                        if (Weapon(inv) != None)
                        {
                            if (firstWeapon == None)
                                firstWeapon = Weapon(inv);

                            //Sarge: Reload all weapons
                            if (inv.IsA('DeusExWeapon'))
                                DeusExWeapon(inv).ClipCount = DeusExWeapon(inv).ReloadCount;
                        }
					}
				}
			}
			if (firstWeapon != None)
				weapons[WeaponCount++] = firstWeapon;
		}
	}
	for (i=0; i<weaponCount; i++)
	{
		if ((weapons[i].AmmoType == None) && (weapons[i].AmmoName != None) &&
			(weapons[i].AmmoName != Class'AmmoNone'))
		{
			weapons[i].AmmoType = Ammo(FindInventoryType(weapons[i].AmmoName));
			if (weapons[i].AmmoType == None)
			{
				weapons[i].AmmoType = spawn(weapons[i].AmmoName);
				weapons[i].AmmoType.InitialState='Idle2';
				weapons[i].AmmoType.GiveTo(Self);
				weapons[i].AmmoType.SetBase(Self);
			}
		}
	}

	SetupWeapon(false);

}


// ----------------------------------------------------------------------
// InitializeAlliances()
// ----------------------------------------------------------------------

function InitializeAlliances()
{
	local int i;

	for (i=0; i<8; i++)
		if (InitialAlliances[i].AllianceName != '')
			ChangeAlly(InitialAlliances[i].AllianceName,
			           InitialAlliances[i].AllianceLevel,
			           InitialAlliances[i].bPermanent);

}

function bool CheckInitialAlliances() //CyberP: check our initial alliances
{
   local int i;

	for (i=0; i<8; i++)
		if (InitialAlliances[i].AllianceName == 'Player')
		   if (InitialAlliances[i].AllianceLevel < 0)
		      return true;

	return false;

}
// ----------------------------------------------------------------------
// InitializeHomeBase()
// ----------------------------------------------------------------------

function InitializeHomeBase()
{
	if (!bUseHome)
	{
		HomeActor = None;
		HomeLoc   = Location;
		HomeRot   = vector(Rotation);
		if (HomeTag == 'Start')
			bUseHome = true;
		else
		{
			HomeActor = HomeBase(FindTaggedActor(HomeTag, , Class'HomeBase'));
			if (HomeActor != None)
			{
				HomeLoc    = HomeActor.Location;
				HomeRot    = vector(HomeActor.Rotation);
				HomeExtent = HomeActor.Extent;
				bUseHome   = true;
			}
		}
		HomeRot *= 100;
	}
}


// ----------------------------------------------------------------------
// AddInitialInventory()
// ----------------------------------------------------------------------

function bool AddInitialInventory(class<Inventory> newInventory,
								  optional int newCount)
{
	local int i;

	if (newCount == 0)
		newCount = 1;

	for (i=0; i<8; i++)
		if ((InitialInventory[i].Inventory == None) &&
		    (InitialInventory[i].Count <= 0))
			break;

	if (i < 8)
	{
		InitialInventory[i].Inventory = newInventory;
		InitialInventory[i].Count = newCount;
		return true;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// SetEnemy()
// ----------------------------------------------------------------------

function bool SetEnemy(Pawn newEnemy, optional float newSeenTime,
					   optional bool bForce)
{
	if (bForce || IsValidEnemy(newEnemy))
	{
		if (newEnemy != Enemy)
			EnemyTimer = 0;
		Enemy         = newEnemy;
		EnemyLastSeen = newSeenTime;

		return True;
	}
	else
		return False;
}


// ----------------------------------------------------------------------
// SetState()
// ----------------------------------------------------------------------

function SetState(Name stateName, optional Name labelName)
{
	if (bInterruptState)
		GotoState(stateName, labelName);
	else
		SetNextState(stateName, labelName);
}


// ----------------------------------------------------------------------
// SetNextState()
// ----------------------------------------------------------------------

function SetNextState(name newState, optional name newLabel)
{
	if (!bInTransientState || !HasNextState())
	{
		if ((newState != 'Conversation') && (newState != 'FirstPersonConversation'))
		{
			NextState = newState;
			NextLabel = newLabel;
		}
	}
}


// ----------------------------------------------------------------------
// ClearNextState()
// ----------------------------------------------------------------------

function ClearNextState()
{
	NextState = '';
	NextLabel = '';
}


// ----------------------------------------------------------------------
// HasNextState()
// ----------------------------------------------------------------------

function bool HasNextState()
{
	if ((NextState == '') || (NextState == GetStateName()))
		return false;
	else
		return true;
}


// ----------------------------------------------------------------------
// GotoNextState()
// ----------------------------------------------------------------------

function GotoNextState()
{
	local bool bSuccess;
	local name oldState, oldLabel;

	if (HasNextState())
	{
		oldState = NextState;
		oldLabel = NextLabel;
		if (oldLabel == '')
			oldLabel = 'Begin';

		ClearNextState();

		GotoState(oldState, oldLabel);
	}
	else
		ClearNextState();
}


// ----------------------------------------------------------------------
// SetOrders()
// ----------------------------------------------------------------------

function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
{
	local bool bHostile;
	local Pawn orderEnemy;

	switch (orderName)
	{
		case 'Attacking':
		case 'Fleeing':
		case 'Alerting':
		case 'Seeking':
			bHostile = true;
			break;
		default:
			bHostile = false;
			break;
	}

	if (!bHostile)
	{
		bSeatHackUsed = false;  // hack!
		Orders   = orderName;
		OrderTag = newOrderTag;

		if (bImmediate)
			FollowOrders(true);
	}
	else
	{
		ReactionLevel = 1.0;
		orderEnemy = Pawn(FindTaggedActor(newOrderTag, false, Class'Pawn'));
		if (orderEnemy != None)
		{
			ChangeAlly(orderEnemy.Alliance, -1, true);
			if (SetEnemy(orderEnemy))
				SetState(orderName);
		}
	}

}


// ----------------------------------------------------------------------
// SetHomeBase()
// ----------------------------------------------------------------------

function SetHomeBase(vector baseLocation, optional rotator baseRotator, optional float baseExtent)
{
	local vector vectRot;

	if (baseExtent == 0)
		baseExtent = 800;

	HomeTag    = '';
	HomeActor  = None;
	HomeLoc    = baseLocation;
	HomeRot    = vector(baseRotator)*100;
	HomeExtent = baseExtent;
	bUseHome   = true;
}


// ----------------------------------------------------------------------
// ClearHomeBase()
// ----------------------------------------------------------------------

function ClearHomeBase()
{
	HomeTag  = '';
	bUseHome = false;
}


// ----------------------------------------------------------------------
// IsSeatValid()
// ----------------------------------------------------------------------

function bool IsSeatValid(Actor checkActor)
{
	local PlayerPawn player;
	local Seat       checkSeat;

	checkSeat = Seat(checkActor);
	if (checkSeat == None)
		return false;
	else if (checkSeat.bDeleteMe)
		return false;
	else if (!bSitAnywhere && (VSize(checkSeat.Location-checkSeat.InitialPosition) > 70))
		return false;
	else
	{
		player = GetPlayerPawn();
		if (player != None)
		{
			if (player.CarriedDecoration == checkSeat)
				return false;
		}
		return true;
	}
}


// ----------------------------------------------------------------------
// SetDistress()
// ----------------------------------------------------------------------

function SetDistress(bool bDistress)
{
	bDistressed = bDistress;
	if (bDistress && bEmitDistress)
		AIStartEvent('Distress', EAITYPE_Visual);
	else
		AIEndEvent('Distress', EAITYPE_Visual);
}

function ShouldGreaselMelee() //CyberP: gets called out of the desired state and crashes, so this prevents that.
   {
   }

// ----------------------------------------------------------------------
// SetDistressTimer()
// ----------------------------------------------------------------------

function SetDistressTimer()
{
	DistressTimer = 0;
}


// ----------------------------------------------------------------------
// SetSeekLocation()
// ----------------------------------------------------------------------

function SetSeekLocation(Pawn seekCandidate, vector newLocation, ESeekType newSeekType, optional bool bNewPostCombat)
{
	SetEnemy(None, 0, true);
	SeekPawn      = seekCandidate;
	LastSeenPos   = newLocation;
	bSeekLocation = True;
	SeekType      = newSeekType;
	if (newSeekType == SEEKTYPE_Carcass)
		CarcassTimer      = 120.0;
	if (newSeekType == SEEKTYPE_Sight)
		SeekLevel = Max(SeekLevel, 1);
	else
		SeekLevel = Max(SeekLevel, 3);
	if (bNewPostCombat)
		bSeekPostCombat = true;
}


// ----------------------------------------------------------------------
// GetCarcassData()
// ----------------------------------------------------------------------

function bool GetCarcassData(actor sender, out Name killer, out Name alliance,
							 out Name CarcassName, optional bool bCheckName)
{
	local DeusExPlayer  dxPlayer;
	local DeusExCarcass carcass;
	local POVCorpse     corpseItem;
	local bool          bCares;
	local bool          bValid;

	alliance = '';
	killer   = '';

	bValid   = false;
	dxPlayer = DeusExPlayer(sender);
	carcass  = DeusExCarcass(sender);
	if (dxPlayer != None)
	{
		corpseItem = POVCorpse(dxPlayer.inHand);
		if (corpseItem != None)
		{
			if (corpseItem.bEmitCarcass)
			{
				alliance    = corpseItem.Alliance;
				killer      = corpseItem.KillerAlliance;
				CarcassName = corpseItem.CarcassName;
				bValid      = true;
			}
		}
	}
	else if (carcass != None)
	{
		if (carcass.bEmitCarcass)
		{
			alliance    = carcass.Alliance;
			killer      = carcass.KillerAlliance;
			CarcassName = carcass.CarcassName;
			bValid      = true;
		}
	}

	bCares = false;
	if (bValid && (!bCheckName || !HaveSeenCarcass(CarcassName)))
	{
		if (bFearCarcass)
			bCares = true;
		else
		{
			if (GetAllianceType(alliance) == ALLIANCE_Friendly)
			{
				if (bHateCarcass)
					bCares = true;
				else if (bReactCarcass)
				{
					if (GetAllianceType(killer) == ALLIANCE_Hostile)
						bCares = true;
				}
			}
		}
	}

	return bCares;
}


// ----------------------------------------------------------------------
// ReactToFutz()
// ----------------------------------------------------------------------

function ReactToFutz()
{
	if (bLookingForFutz && bReactFutz && (FutzTimer <= 0) && !bDistressed)
	{
		FutzTimer = 2.0;
		PlayFutzSound();
	}
}


// ----------------------------------------------------------------------
// ReactToProjectiles()
// ----------------------------------------------------------------------

function ReactToProjectiles(Actor projectileActor)
{
	local DeusExProjectile dxProjectile;
	local Pawn             instigator;

	if ((bFearProjectiles || bReactProjectiles) && bLookingForProjectiles)
	{
		dxProjectile = DeusExProjectile(projectileActor);
		if ((dxProjectile == None) || IsProjectileDangerous(dxProjectile))
		{
			instigator = Pawn(projectileActor);
			if (instigator == None)
				instigator = projectileActor.Instigator;
			if (instigator != None)
			{
				if (bFearProjectiles)
					IncreaseFear(instigator, 2.0);
				if (SetEnemy(instigator))
				{
					SetDistressTimer();
					HandleEnemy();
				}
				else if (bFearProjectiles && IsFearful())
				{
					SetDistressTimer();
					SetEnemy(instigator, , true);
					GotoState('Fleeing');
				}
				else if (bAvoidHarm)
					SetState('AvoidingProjectiles');
			}
		}
	}
}


// ----------------------------------------------------------------------
// InstigatorToPawn()
// ----------------------------------------------------------------------

function Pawn InstigatorToPawn(Actor eventActor)
{
	local Pawn pawnActor;

	if (Inventory(eventActor) != None)
	{
		if (Inventory(eventActor).Owner != None)
			eventActor = Inventory(eventActor).Owner;
	}
	else if (DeusExDecoration(eventActor) != None)
		eventActor = GetPlayerPawn();
	else if (DeusExProjectile(eventActor) != None)
		eventActor = eventActor.Instigator;

	pawnActor = Pawn(eventActor);
	if (pawnActor == self)
		pawnActor = None;

	return pawnActor;

}


// ----------------------------------------------------------------------
// EnableShadow()
// ----------------------------------------------------------------------

function EnableShadow(bool bEnable)
{
	if (Shadow != None)
	{
		if (bEnable)
			Shadow.AttachDecal(32,vect(0.1,0.1,0));
		else
			Shadow.DetachDecal();
	}
}


// ----------------------------------------------------------------------
// CreateShadow()
// ----------------------------------------------------------------------

function CreateShadow()
{
	if (bHasShadow && bInWorld)
		if (Shadow == None)
			Shadow = Spawn(class'Shadow', Self,, Location-vect(0,0,1)*CollisionHeight, rot(16384,0,0));
}


// ----------------------------------------------------------------------
// KillShadow()
// ----------------------------------------------------------------------

function KillShadow()
{
	if (Shadow != None)
	{
		Shadow.Destroy();
		Shadow = None;
	}
}


// ----------------------------------------------------------------------
// EnterWorld()
// ----------------------------------------------------------------------

function EnterWorld()
{
	PutInWorld(true);
}


// ----------------------------------------------------------------------
// LeaveWorld()
// ----------------------------------------------------------------------

function LeaveWorld()
{
	PutInWorld(false);
}


// ----------------------------------------------------------------------
// PutInWorld()
// ----------------------------------------------------------------------

function PutInWorld(bool bEnter)
{
	if (bInWorld && !bEnter)
	{
		bInWorld            = false;
		GotoState('Idle');
		bHidden             = true;
		bDetectable         = false;
		WorldPosition       = Location;
		bWorldCollideActors = bCollideActors;
		bWorldBlockActors   = bBlockActors;
		bWorldBlockPlayers  = bBlockPlayers;
		SetCollision(false, false, false);
		bCollideWorld       = false;
		SetPhysics(PHYS_None);
		KillShadow();
		SetLocation(Location+vect(0,0,20000));  // move it out of the way
	}
	else if (!bInWorld && bEnter)
	{
		bInWorld    = true;
		bHidden     = Default.bHidden;
		bDetectable = Default.bDetectable;
		SetLocation(WorldPosition);
		SetCollision(bWorldCollideActors, bWorldBlockActors, bWorldBlockPlayers);
		bCollideWorld = Default.bCollideWorld;
		SetMovementPhysics();
		CreateShadow();
		FollowOrders();
	}
}


// ----------------------------------------------------------------------
// MakePawnIgnored()
// ----------------------------------------------------------------------

function MakePawnIgnored(bool bNewIgnore)
{
	if (bNewIgnore)
	{
		bIgnore = bNewIgnore;
		// to restore original behavior, uncomment the next line
		//bDetectable = !bNewIgnore;
	}
	else
	{
		bIgnore = Default.bIgnore;
		// to restore original behavior, uncomment the next line
		//bDetectable = Default.bDetectable;
	}

}


// ----------------------------------------------------------------------
// EnableCollision() [for sitting state]
// ----------------------------------------------------------------------

function EnableCollision(bool bSet)
{
	EnableShadow(bSet);

	if (bSet)
		SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
	else
		SetCollision(True, False, True);
}


// ----------------------------------------------------------------------
// SetBasedPawnSize()
// ----------------------------------------------------------------------

function bool SetBasedPawnSize(float newRadius, float newHeight)
{
	local float  oldRadius, oldHeight;
	local bool   bSuccess;
	local vector centerDelta;
	local float  deltaEyeHeight;

	if (newRadius < 0)
		newRadius = 0;
	if (newHeight < 0)
		newHeight = 0;

	oldRadius = CollisionRadius;
	oldHeight = CollisionHeight;

	if ((oldRadius == newRadius) && (oldHeight == newHeight))
		return true;

	centerDelta    = vect(0, 0, 1)*(newHeight-oldHeight);
	deltaEyeHeight = GetDefaultCollisionHeight() - Default.BaseEyeHeight;

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
		PrePivotOffset  = vect(0, 0, 1)*(GetDefaultCollisionHeight()-newHeight);
		PrePivot        -= centerDelta;
		DesiredPrePivot -= centerDelta;
		BaseEyeHeight   = newHeight - deltaEyeHeight;
	}

	return (bSuccess);
}


// ----------------------------------------------------------------------
// ResetBasedPawnSize()
// ----------------------------------------------------------------------

function ResetBasedPawnSize()
{
	SetBasedPawnSize(Default.CollisionRadius, GetDefaultCollisionHeight());
}


// ----------------------------------------------------------------------
// GetDefaultCollisionHeight()
// ----------------------------------------------------------------------

function float GetDefaultCollisionHeight()
{
	return (Default.CollisionHeight-4.5);
}


// ----------------------------------------------------------------------
// GetCrouchHeight()
// ----------------------------------------------------------------------

function float GetCrouchHeight()
{
	return (Default.CollisionHeight*0.65);
}


// ----------------------------------------------------------------------
// GetSitHeight()
// ----------------------------------------------------------------------

function float GetSitHeight()
{
	return (GetDefaultCollisionHeight()+(BaseAssHeight*0.5));
}


// ----------------------------------------------------------------------
// IsPointInCylinder()
// ----------------------------------------------------------------------

function bool IsPointInCylinder(Actor cylinder, Vector point,
								optional float extraRadius, optional float extraHeight)
{
	local bool  bPointInCylinder;
	local float tempX, tempY, tempRad;

	tempX    = cylinder.Location.X - point.X;
	tempX   *= tempX;
	tempY    = cylinder.Location.Y - point.Y;
	tempY   *= tempY;
	tempRad  = cylinder.CollisionRadius + extraRadius;
	tempRad *= tempRad;

	bPointInCylinder = false;
	if (tempX+tempY < tempRad)
		if (Abs(cylinder.Location.Z - point.Z) < (cylinder.CollisionHeight+extraHeight))
			bPointInCylinder = true;

	return (bPointInCylinder);
}


// ----------------------------------------------------------------------
// StartFalling()
// ----------------------------------------------------------------------

function StartFalling(Name resumeState, optional Name resumeLabel)
{
	SetNextState(resumeState, resumeLabel);
	GotoState('FallingState');
}


// ----------------------------------------------------------------------
// GetNextWaypoint()
// ----------------------------------------------------------------------

function Actor GetNextWaypoint(Actor destination)
{
	local Actor moveTarget;

	if (destination == None)
		moveTarget = None;
	else if (ActorReachable(destination))
		moveTarget = destination;
	else
		moveTarget = FindPathToward(destination);

	return (moveTarget);
}


// ----------------------------------------------------------------------
// GetNextVector()
// ----------------------------------------------------------------------

function bool GetNextVector(Actor destination, out vector outVect)
{
	local bool    bValid;
	local rotator rot;
	local float   dist;
	local float   maxDist;

	bValid = true;
	if (destination != None)
	{
		maxDist = 64;
		rot     = Rotator(destination.Location - Location);
		dist    = VSize(destination.Location - Location);
		if (dist < maxDist)
			outVect = destination.Location;
		else if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch,
		                               0, maxDist, outVect))
			bValid = false;
	}
	else
		bValid = false;

	return (bValid);
}


// ----------------------------------------------------------------------
// FindOrderActor()
// ----------------------------------------------------------------------

function FindOrderActor()
{
	if (Orders == 'Attacking')
		OrderActor = FindTaggedActor(OrderTag, true, Class'Pawn');
	else
		OrderActor = FindTaggedActor(OrderTag);
}


// ----------------------------------------------------------------------
// FindTaggedActor()
// ----------------------------------------------------------------------

function Actor FindTaggedActor(Name actorTag, optional bool bRandom, optional Class<Actor> tagClass)
{
	local float dist;
	local float bestDist;
	local actor bestActor;
	local actor tempActor;

	bestActor = None;
	bestDist  = 1000000;

	if (tagClass == None)
		tagClass = Class'Actor';

	// if no tag, then assume the player is the target
	if (actorTag == '')
	{
	    //CyberP: no psychic enemies!
	    if (IsInState('Attacking') && bSpottedPlayer)
		    bestActor = GetPlayerPawn();
		else if (IsInState('Attacking'))
        {
        }
		else
		//CyberP: end
            bestActor = GetPlayerPawn();
	}
	else
	{
		foreach AllActors(tagClass, tempActor, actorTag)
		{
			if (tempActor != self)
			{
				dist = VSize(tempActor.Location - Location);
				if (bRandom)
					dist *= FRand()*0.6+0.7;  // +/- 30%
				if ((bestActor == None) || (dist < bestDist))
				{
					bestActor = tempActor;
					bestDist  = dist;
				}
			}
		}
	}

	return bestActor;
}


// ----------------------------------------------------------------------
// HandleEnemy()
// ----------------------------------------------------------------------

function HandleEnemy()
{
	SetState('HandlingEnemy', 'Begin');
}


// ----------------------------------------------------------------------
// HandleSighting()
// ----------------------------------------------------------------------

function HandleSighting(Pawn pawnSighted)
{
    SetSeekLocation(pawnSighted, pawnSighted.Location, SEEKTYPE_Sight);
	GotoState('Seeking');
}


// ----------------------------------------------------------------------
// FollowOrders()
// ----------------------------------------------------------------------

function FollowOrders(optional bool bDefer)
{
	local bool bSetEnemy;
	local bool bUseOrderActor;

	if (Orders != '')
	{
		if ((Orders == 'Fleeing') || (Orders == 'Attacking'))
		{
			bSetEnemy      = true;
			bUseOrderActor = true;
		}
		else if ((Orders == 'WaitingFor') || (Orders == 'GoingTo') ||
		         (Orders == 'RunningTo') || (Orders == 'Following') ||
		         (Orders == 'Sitting') || (Orders == 'Shadowing') ||
		         (Orders == 'DebugFollowing') || (Orders == 'DebugPathfinding'))
		{
			bSetEnemy      = false;
			bUseOrderActor = true;
		}
		else
		{
			bSetEnemy      = false;
			bUseOrderActor = false;
		}
		if (bUseOrderActor)
		{
			FindOrderActor();
			if (bSetEnemy)
				SetEnemy(Pawn(OrderActor), 0, true);
		}
		if (bDefer)  // hack
			SetState(Orders);
		else
			GotoState(Orders);
	}
	else
	{
		if (bDefer)
			SetState('Wandering');
		else
			GotoState('Wandering');
	}
}


// ----------------------------------------------------------------------
// ResetConvOrders()
// ----------------------------------------------------------------------

function ResetConvOrders()
{
	ConvOrders   = '';
	ConvOrderTag = '';
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
	local float limbDamage, headDamage, torsoDamage;

	if (!bInvincible)
	{
		// Scoring works as follows:
		// Disabling the head (100 points damage) will kill you.
		// Disabling the torso (100 points damage) will kill you.
		// Disabling 2 1/2 limbs (250 points damage) will kill you.
		// Combinations can also do you in -- 50 points damage to the head
		// and 125 points damage to the limbs, for example.

		// Note that this formula can produce numbers less than zero, so we'll clamp our
		// health value...

		// Compute total limb damage
		limbDamage  = 0;
		if (Default.HealthLegLeft > 0)
			limbDamage += float(Default.HealthLegLeft-HealthLegLeft)/Default.HealthLegLeft;
		if (Default.HealthLegRight > 0)
			limbDamage += float(Default.HealthLegRight-HealthLegRight)/Default.HealthLegRight;
		if (Default.HealthArmLeft > 0)
			limbDamage += float(Default.HealthArmLeft-HealthArmLeft)/Default.HealthArmLeft;
		if (Default.HealthArmRight > 0)
			limbDamage += float(Default.HealthArmRight-HealthArmRight)/Default.HealthArmRight;
		limbDamage *= 0.4;  // 2 1/2 limbs disabled == death

		// Compute total head damage
		headDamage  = 0;
		if (Default.HealthHead > 0)
			headDamage  = float(Default.HealthHead-HealthHead)/Default.HealthHead;

		// Compute total torso damage
		torsoDamage = 0;
		if (Default.HealthTorso > 0)
			torsoDamage = float(Default.HealthTorso-HealthTorso)/Default.HealthTorso;

		// Compute total health, relative to original health level
		Health = FClamp(Default.Health - ((limbDamage+headDamage+torsoDamage)*Default.Health), 0.0, Default.Health);
	}
	else
	{
		// Pawn is invincible - reset health to defaults
		HealthHead     = Default.HealthHead;
		HealthTorso    = Default.HealthTorso;
		HealthArmLeft  = Default.HealthArmLeft;
		HealthArmRight = Default.HealthArmRight;
		HealthLegLeft  = Default.HealthLegLeft;
		HealthLegRight = Default.HealthLegRight;
		Health         = Default.Health;
	}
}


// ----------------------------------------------------------------------
// UpdatePoison()
// ----------------------------------------------------------------------

function UpdatePoison(float deltaTime)
{
	if ((Health <= 0) || bDeleteMe)  // no more pain -- you're already dead!
		return;

	if (poisonCounter > 0)
	{
		poisonTimer += deltaTime;
		if (poisonTimer >= 2.0)  // pain every two seconds
		{
			poisonTimer = 0;
			poisonCounter--;
			TakeDamage(poisonDamage, Poisoner, Location, vect(0,0,0), 'PoisonEffect');
		}
		if ((poisonCounter <= 0) || (Health <= 0) || bDeleteMe)
			StopPoison();
	}
}


// ----------------------------------------------------------------------
// StartPoison()
// ----------------------------------------------------------------------

function StartPoison(int Damage, Pawn newPoisoner)
{
	if ((Health <= 0) || bDeleteMe)  // no more pain -- you're already dead!
		return;

	poisonCounter = 8;    // take damage no more than eight times (over 16 seconds)
	poisonTimer   = 0;    // reset pain timer
	Poisoner      = newPoisoner;
	//if (poisonDamage < Damage)  // set damage amount
		poisonDamage = Damage*0.5;
}


// ----------------------------------------------------------------------
// StopPoison()
// ----------------------------------------------------------------------

function StopPoison()
{
	poisonCounter = 0;
	poisonTimer   = 0;
	poisonDamage  = 0;
	Poisoner      = None;
}


// ----------------------------------------------------------------------
// HasEnemyTimedOut()
// ----------------------------------------------------------------------

function bool HasEnemyTimedOut()
{
	if (EnemyTimeout > 0)
	{
	    if (EnemyLastSeen > EnemyTimeOut && bDefendHome && (HomeExtent > 64 || bStopCamping))
	    {
	        if (IsA('PaulDenton')) //CyberP: yet another hack
	            return true;
            bDefendHome = false;
            EnemyLastSeen *= 0.3;
        }
		if (EnemyLastSeen > EnemyTimeout)
			return true;
		else
			return false;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// UpdateActorVisibility()
// ----------------------------------------------------------------------

function UpdateActorVisibility(actor seeActor, float deltaSeconds,
							   float checkTime, bool bCheckDir)
{
	local bool bCanSee;
    local float distan, distan2;

	CheckPeriod += deltaSeconds;
	if (CheckPeriod >= checkTime)
	{
		CheckPeriod = 0.0;
		if (seeActor != None)
			bCanSee = (AICanSee(seeActor, ComputeActorVisibility(seeActor), false, bCheckDir, true, true) > 0);
		else
			bCanSee = false;
		if (bCanSee)
		{
		    if (IsInState('Attacking'))
		    {
		        if (seeActor != None && seeActor.IsA('DeusExPlayer'))
		        {
                    bSpottedPlayer = True;
                    CombatSeeTimer += deltaSeconds;
		        }
            }
			EnemyLastSeen = 0;
			sFire = 0;
			if (enemy != None)
			    GMDXEnemyLastSeenPos = enemy.Location;
		}
		else if (EnemyLastSeen <= 0)
		{
			EnemyLastSeen = 0.01;
			CombatSeeTimer = 0;
			if (!bCanSee && bSpottedPlayer)
			   if (FRand() < 0.33 && !Weapon.IsA('WeaponMiniCrossbow') && (IsA('MilitaryBot') || bIsHuman))
			      sFire = 0.4 + (FRand() * 4);
		}
	}
	if (EnemyLastSeen > 0)
		EnemyLastSeen += deltaSeconds;
	if (sFire > 0)
	{
        sFire -= deltaSeconds;
        if (sFire < 0)
           sFire = 0;
    }
}


// ----------------------------------------------------------------------
// ComputeActorVisibility()
// ----------------------------------------------------------------------

function float ComputeActorVisibility(actor seeActor)
{
	local float visibility;

	if (seeActor.IsA('DeusExPlayer'))
		visibility = DeusExPlayer(seeActor).CalculatePlayerVisibility(self);
	else
		visibility = 1.0;

	return (visibility);
}


// ----------------------------------------------------------------------
// UpdateReactionLevel() [internal use only]
// ----------------------------------------------------------------------

function UpdateReactionLevel(bool bRise, float deltaSeconds)
{
	local float surpriseTime;

	// Handle surprise levels...
	if (bRise)
	{
		if (ReactionLevel < 1.0)
		{
			surpriseTime = SurprisePeriod;
			if (surpriseTime <= 0)
				surpriseTime = 0.00000001;
			ReactionLevel += deltaSeconds/surpriseTime;
			if (ReactionLevel > 1.0)
				ReactionLevel = 1.0;
		}
	}
	else
	{
		if (ReactionLevel > 0.0)
		{
			surpriseTime = 7.0;
			ReactionLevel -= deltaSeconds/surpriseTime;
			if (ReactionLevel <= 0.0)
				ReactionLevel = 0.0;
		}
	}
}


// ----------------------------------------------------------------------
// CheckCycle() [internal use only]
// ----------------------------------------------------------------------

function Pawn CheckCycle()
{
	local float attackPeriod;
	local float maxAttackPeriod;
	local float sustainPeriod;
	local float decayPeriod;
	local float minCutoff;
	local Pawn  cycleEnemy;

	attackPeriod    = 0.5;
	maxAttackPeriod = 4.5;
	sustainPeriod   = 3.0;
	decayPeriod     = 4.0;

	minCutoff = attackPeriod/maxAttackPeriod;

	cycleEnemy = None;

	if (CycleCumulative <= 0)  // no enemies seen during this cycle
	{
		CycleTimer -= CyclePeriod;
		if (CycleTimer <= 0)
		{
			CycleTimer = 0;
			EnemyReadiness -= CyclePeriod/decayPeriod;
			if (EnemyReadiness < 0)
				EnemyReadiness = 0;
		}
	}
	else  // I saw somebody!
	{
		CycleTimer = sustainPeriod;
		CycleCumulative *= 2;  // hack
		if (CycleCumulative < minCutoff)
			CycleCumulative = minCutoff;
		else if (CycleCumulative > 1.0)
			CycleCumulative = 1.0;
		EnemyReadiness += CycleCumulative*CyclePeriod/attackPeriod;
		if (EnemyReadiness >= 1.0)
		{
			EnemyReadiness = 1.0;
			if (IsValidEnemy(CycleCandidate))
				cycleEnemy = CycleCandidate;
		}
		else if (EnemyReadiness >= SightPercentage)
			if (IsValidEnemy(CycleCandidate))
				HandleSighting(CycleCandidate);
	}
	CycleCumulative = 0;
	CyclePeriod     = 0;
	CycleCandidate  = None;
	CycleDistance   = 0;

	return (cycleEnemy);

}


// ----------------------------------------------------------------------
// CheckEnemyPresence()
// ----------------------------------------------------------------------

function bool CheckEnemyPresence(float deltaSeconds,
								 bool bCheckPlayer, bool bCheckOther)
{
	local int          i;
	local int          count;
	local int          checked;
	local Pawn         candidate;
	local float        candidateDist;
	local DeusExPlayer playerCandidate;
	local bool         bCanSee;
	local int          lastCycle;
	local float        visibility;
	local Pawn         cycleEnemy;
	local bool         bValid;
	local bool         bPlayer;
	local float        surpriseTime;
	local bool         bValidEnemy;
	local bool         bPotentialEnemy;
	local bool         bCheck;
    local float        skillStealthMod, oldVisibilityThreshold;// litelvl;      //RSD: Added

    oldVisibilityThreshold = VisibilityThreshold;

	bValid  = false;
	bCanSee = false;
	if (bReactPresence && bLookingForEnemy && !bNoNegativeAlliances)
	{
		if (PotentialEnemyAlliance != '')
			bCheck = true;
		else
		{
			for (i=0; i<16; i++)
				if ((AlliancesEx[i].AllianceLevel < 0) || (AlliancesEx[i].AgitationLevel >= 1.0))
					break;
			if (i < 16)
				bCheck = true;
		}

		if (bCheck)
		{
			bValid       = true;
			CyclePeriod += deltaSeconds;
			count        = 0;
			checked      = 0;
			lastCycle    = CycleIndex;
			foreach CycleActors(Class'Pawn', candidate, CycleIndex)
			{
				bValidEnemy = IsValidEnemy(candidate);
				if (!bValidEnemy && (PotentialEnemyTimer > 0))
					if (PotentialEnemyAlliance == candidate.Alliance)
						bPotentialEnemy = true;
				if (bValidEnemy || bPotentialEnemy)
				{
					count++;
					bPlayer = candidate.IsA('PlayerPawn');
					if ((bPlayer && bCheckPlayer) || (!bPlayer && bCheckOther))
					{
						if (candidate.IsA('DeusExPlayer'))
						{
							playerCandidate = DeusExPlayer(candidate);
							if (playerCandidate.IsCrouching())                   //RSD: Increase VisibilityThreshold according to stealth skill when crouched in darkness
							{
								/*skillStealthMod = (playerCandidate.SkillSystem.GetSkillLevelValue(class'SkillStealth')-0.5)*0.3;
								if (skillStealthMod < 0.0)
									skillStealthMod = 0.0;*/                    //RSD: Returns 0/15/35/45% depending on skill level value
								skillStealthMod = (playerCandidate.SkillSystem.GetSkillLevel(class'SkillStealth'))*0.15;
								/*litelvl = playerCandidate.AIVisibility();
								if (playerCandidate.UsingChargedPickup(class'TechGoggles'))
         							litelvl -= 0.031376;                        //RSD: Tech Goggles hack
			    	            if (litelvl <= 0.3333)
			    	            	VisibilityThreshold = (1.0+(1.0-3.*litelvl)*skillStealthMod)*oldVisibilityThreshold;*/
		    	            	if ((playerCandidate.UsingChargedPickup(class'TechGoggles')
                                || playerCandidate.AugmentationSystem.GetAugLevelValue(class'AugVision') != -1.0) && skillStealthMod > 0.0)
		    	            		//skillStealthMod *= 1.209;                   //RSD: Tech Goggles hack
		    	            		skillStealthMod += 0.094128;
	    	            		skillStealthMod = FClamp(skillStealthMod,0.0,0.90); //RSD: Just in case
		    	            	VisibilityThreshold = oldVisibilityThreshold/(1.0-skillStealthMod);
							}
							if (playerCandidate.UsingChargedPickup(class'TechGoggles') || playerCandidate.AugmentationSystem.GetAugLevelValue(class'AugVision') != -1.0)
                            	VisibilityThreshold += 0.0031376;               //RSD: Add TechGoggles lightamp amount (10% of it, IDK seems to work)
                            //playerCandidate.BroadcastMessage(VisibilityThreshold); //RSD: Threshold test
						}
						visibility = AICanSee(candidate, ComputeActorVisibility(candidate), true, true, true, true);
						VisibilityThreshold = oldVisibilityThreshold;
						if (visibility > 0)
						{
                            //candidate.BroadcastMessage(visibility);
                            if (bPotentialEnemy)  // We can see the potential enemy; ergo, we hate him
							{
								IncreaseAgitation(candidate, 1.0);
								PotentialEnemyAlliance = '';
								PotentialEnemyTimer    = 0;
								bValidEnemy = IsValidEnemy(candidate);
							}
							if (bValidEnemy)
							{
								visibility += VisibilityThreshold;
								candidateDist = VSize(Location-candidate.Location);
								if ((CycleCandidate == None) || (CycleDistance > candidateDist))
								{
									CycleCandidate = candidate;
									CycleDistance  = candidateDist;
								}
								if (!bPlayer)
									CycleCumulative += 100000;  // a bit of a hack...
								else
									CycleCumulative += visibility;
							}
						}
					}
					if (count >= 1)
						break;
				}
				checked++;
				if (checked > 20)  // hacky hardcoded number
					break;
			}
			if (lastCycle >= CycleIndex)  // have we cycled through all actors?
			{
				cycleEnemy = CheckCycle();
				if (cycleEnemy != None)
				{
					SetDistressTimer();
					SetEnemy(cycleEnemy, 0, true);
					bCanSee = true;
				}
			}
		}
		else
			bNoNegativeAlliances = True;
	}

	// Handle surprise levels...
	UpdateReactionLevel((EnemyReadiness>0)||(GetStateName()=='Seeking')||bDistressed, deltaSeconds);

	if (!bValid)
	{
		CycleCumulative = 0;
		CyclePeriod     = 0;
		CycleCandidate  = None;
		CycleDistance   = 0;
		CycleTimer      = 0;
	}

	return (bCanSee);

}


// ----------------------------------------------------------------------
// CheckBeamPresence
// ----------------------------------------------------------------------

function bool CheckBeamPresence(float deltaSeconds)
{
	local DeusExPlayer player;
	local Beam         beamActor;
	local bool         bReactToBeam;

	if (bReactPresence && bLookingForEnemy && (BeamCheckTimer <= 0) && (LastRendered() < 5.0))
	{
		BeamCheckTimer = 1.0;
		player = DeusExPlayer(GetPlayerPawn());
		if (player != None)
		{
			bReactToBeamGlobal = false;
			bReactFlareBeam = false;
			if (IsValidEnemy(player))
			{
				foreach RadiusActors(Class'Beam', beamActor, 1200)
				{
					if ((beamActor.Owner == player) && (beamActor.LightType != LT_None) && (beamActor.LightBrightness > 32))
					{
						if (VSize(beamActor.Location - Location) < (beamActor.LightRadius+1)*25)
							bReactToBeamGlobal = true;
						else
						{
							if (AICanSee(beamActor, , false, true, false, false) > 0)
							{
								if (FastTrace(beamActor.Location, Location+vect(0,0,1)*BaseEyeHeight))
									bReactToBeamGlobal = true;
							}
						}
					}
					if (bReactToBeamGlobal)
					{
					    if (beamActor.bFlareBeam)
					        bReactFlareBeam = True;
						break;
					}
				}
			}
			if (bReactToBeamGlobal)
				HandleSighting(player);
		}
	}
}


// ----------------------------------------------------------------------
// CheckCarcassPresence()
// ----------------------------------------------------------------------

function bool CheckCarcassPresence(float deltaSeconds)
{
	local Actor         carcass;
	local Name          CarcassName;
	local int           lastCycle;
	local DeusExCarcass body;
	local DeusExPlayer  player;
	local float         visibility;
	local Name          KillerAlliance;
	local Name          killedAlliance;
	local Pawn          killer;
	local Pawn          bestKiller;
	local float         dist;
	local float         bestDist;
	local float         maxCarcassDist;
	local int           maxCarcassCount;

	if (bFearCarcass && !bHateCarcass && !bReactCarcass)  // Major hack!
		maxCarcassCount = 1;
	else
		maxCarcassCount = ArrayCount(Carcasses);

	//if ((bHateCarcass || bReactCarcass || bFearCarcass) && bLookingForCarcass && (CarcassTimer <= 0))
	if ((bHateCarcass || bReactCarcass || bFearCarcass) && (NumCarcasses < maxCarcassCount))
	{
		maxCarcassDist = 1200;
		if (CarcassCheckTimer <= 0)
		{
			CarcassCheckTimer = 0.1;
			carcass           = None;
			lastCycle         = BodyIndex;
			foreach CycleActors(Class'DeusExCarcass', body, BodyIndex)
			{
				if (body.Physics != PHYS_Falling)
				{
					if (VSize(body.Location-Location) < maxCarcassDist)
					{
						if (GetCarcassData(body, KillerAlliance, killedAlliance, CarcassName, true))
						{
							visibility = AICanSee(body, ComputeActorVisibility(body), true, true, true, true);
							if (visibility > 0)
								carcass = body;
							break;
						}
					}
				}
			}
			if (lastCycle >= BodyIndex)
			{
				if (carcass == None)
				{
					player = DeusExPlayer(GetPlayerPawn());
					if (player != None)
					{
						if (VSize(player.Location-Location) < maxCarcassDist)
						{
							if (GetCarcassData(player, KillerAlliance, killedAlliance, CarcassName, true))
							{
								visibility = AICanSee(player, ComputeActorVisibility(player), true, true, true, true);
								if (visibility > 0)
									carcass = player;
							}
						}
					}
				}
			}
			if (carcass != None)
			{
				CarcassTimer = 120;
				AddCarcass(CarcassName);
				if (bLookingForCarcass)
				{
					if (KillerAlliance == 'Player')
						killer = GetPlayerPawn();
					else
					{
						bestKiller = None;
						bestDist   = 0;
						foreach AllActors(Class'Pawn', killer)  // hack
						{
							if (killer.Alliance == KillerAlliance)
							{
								dist = VSize(killer.Location - Location);
								if ((bestKiller == None) || (bestDist > dist))
								{
									bestKiller = killer;
									bestDist   = dist;
								}
							}
						}
						killer = bestKiller;
					}
					if (bHateCarcass)
					{
						PotentialEnemyAlliance = KillerAlliance;
						PotentialEnemyTimer    = 15.0;
						bNoNegativeAlliances   = false;
					}
					if (bFearCarcass)
						IncreaseFear(killer, 2.0);

					if (bFearCarcass && IsFearful() && !IsValidEnemy(killer))
					{
						SetDistressTimer();
						SetEnemy(killer, , true);
						GotoState('Fleeing');
					}
					else
					{
						SetDistressTimer();
						SetSeekLocation(killer, carcass.Location, SEEKTYPE_Carcass);
						HandleEnemy();
					}
				}
			}
		}
	}

}


// ----------------------------------------------------------------------
// AddProjectileToList()
// ----------------------------------------------------------------------

function AddProjectileToList(out NearbyProjectileList projList,
							 DeusExProjectile proj, vector projPos,
							 float dist, float range)
{
	local int   count;
	local int   pos;
	local int   bestPos;
	local float worstDist;

	bestPos   = -1;
	worstDist = dist;
	pos       = 0;
	while (pos < ArrayCount(projList.list))
	{
		if (projList.list[pos].projectile == None)
		{
			bestPos = pos;
			break;  // short-circuit loop
		}
		else
		{
			if (worstDist < projList.list[pos].dist)
			{
				worstDist = projList.list[pos].dist;
				bestPos   = pos;
			}
		}

		pos++;
	}

	if (bestPos >= 0)
	{
		projList.list[bestPos].projectile = proj;
		projList.list[bestPos].location   = projPos;
		projList.list[bestPos].dist       = dist;
		projList.list[bestPos].range      = range;
	}

}


// ----------------------------------------------------------------------
// IsProjectileDangerous()
// ----------------------------------------------------------------------

function bool IsProjectileDangerous(DeusExProjectile projectile)
{
	local bool bEvil;

	if (projectile.IsA('Cloud'))
		bEvil = true;
	else if (projectile.IsA('ThrownProjectile'))
	{
		if (projectile.IsA('SpyBot'))
			bEvil = false;
		else if ((ThrownProjectile(projectile) != None) && (ThrownProjectile(projectile).bProximityTriggered))
			bEvil = false;
		else
			bEvil = true;
	}
	else
		bEvil = false;

	return (bEvil);

}


// ----------------------------------------------------------------------
// GetProjectileList()
// ----------------------------------------------------------------------

function int GetProjectileList(out NearbyProjectileList projList, vector Location)
{
	local float            dist;
	local int              count;
	local DeusExProjectile curProj;
	local ThrownProjectile throwProj;
	local Cloud            cloudProj;
	local vector           HitNormal, HitLocation;
	local vector           extent;
	local vector           traceEnd;
	local Actor            hitActor;
	local float            range;
	local vector           pos;
	local float            time;
	local float            maxTime;
	local float            elasticity;
	local int              i;
	local bool             bValid;

	for (i=0; i<ArrayCount(projList.list); i++)
		projList.list[i].projectile = None;
	projList.center = Location;

	maxTime = 2.0;
	foreach RadiusActors(Class'DeusExProjectile', curProj, 1000)
	{
		if (IsProjectileDangerous(curProj))
		{
			throwProj = ThrownProjectile(curProj);
			cloudProj = Cloud(curProj);
			extent   = vect(1,1,0)*curProj.CollisionRadius;
			extent.Z = curProj.CollisionHeight;

			range    = VSize(extent);
			if (curProj.bExplodes)
				if (range < curProj.blastRadius)
					range = curProj.blastRadius;
			if (cloudProj != None)
				if (range < cloudProj.cloudRadius)
					range = cloudProj.cloudRadius+128;   //CyberP:added+28
			range += CollisionRadius+60;

			if (throwProj != None)
				elasticity = throwProj.Elasticity;
			else
				elasticity = 0.2;

			bValid = true;
			if (throwProj != None)
				if (throwProj.bProximityTriggered)  // HACK!!!
					bValid = false;

			if (((curProj.Physics == PHYS_Falling) || (curProj.Physics == PHYS_Projectile) || (curProj.Physics == PHYS_None)) &&
			    bValid)
			{
				pos = curProj.Location;
				dist = VSize(Location - curProj.Location);
				AddProjectileToList(projList, curProj, pos, dist, range);
				if (curProj.Physics == PHYS_Projectile)
				{
					traceEnd = curProj.Location + curProj.Velocity*maxTime;
					hitActor = Trace(HitLocation, HitNormal, traceEnd, curProj.Location, true, extent);
					if (hitActor == None)
						pos = traceEnd;
					else
						pos = HitLocation;
					dist = VSize(Location - pos);
					AddProjectileToList(projList, curProj, pos, dist, range);
				}
				else if (curProj.Physics == PHYS_Falling)
				{
					time = ParabolicTrace(pos, curProj.Velocity, curProj.Location, true, extent, maxTime,
					                      elasticity, curProj.bBounce, 60);
					if (time > 0)
					{
						dist = VSize(Location - pos);
						AddProjectileToList(projList, curProj, pos, dist, range);
					}
				}
			}
		}
	}

	count = 0;
	for (i=0; i<ArrayCount(projList.list); i++)
		if (projList.list[i].projectile != None)
			count++;

	return (count);

}


// ----------------------------------------------------------------------
// IsLocationDangerous()
// ----------------------------------------------------------------------

function bool IsLocationDangerous(NearbyProjectileList projList,
								  vector Location)
{
	local bool  bDanger;
	local int   i;
	local float dist;

	bDanger = false;
	for (i=0; i<ArrayCount(projList.list); i++)
	{
		if (projList.list[i].projectile == None)
			break;
		if (projList.center == Location)
			dist = projList.list[i].dist;
		else
			dist = VSize(projList.list[i].location - Location);
		if (dist < projList.list[i].range)
		{
			bDanger = true;
			break;
		}
	}

	return (bDanger);

}


// ----------------------------------------------------------------------
// ComputeAwayVector()
// ----------------------------------------------------------------------

function vector ComputeAwayVector(NearbyProjectileList projList)
{
	local vector          awayVect;
	local vector          tempVect;
	local rotator         tempRot;
	local int             i;
	local float           dist;
	local int             yaw;
	local int             absYaw;
	local int             bestYaw;
	local NavigationPoint navPoint;
	local NavigationPoint bestPoint;
	local float           segmentDist;

	segmentDist = GroundSpeed*0.5;

	awayVect = vect(0, 0, 0);
	for (i=0; i<ArrayCount(projList.list); i++)
	{
		if ((projList.list[i].projectile != None) &&
		    (projList.list[i].dist < projList.list[i].range))
		{
			tempVect = projList.list[i].location - projList.center;
			if (projList.list[i].dist > 0)
				tempVect /= projList.list[i].dist;
			else
				tempVect = VRand();
			awayVect -= tempVect;
		}
	}

	if (awayVect != vect(0, 0, 0))
	{
		awayVect += Normal(Velocity*vect(1,1,0))*0.9;  // bias to direction already running
		yaw = Rotator(awayVect).Yaw;
		bestPoint = None;
		foreach ReachablePathnodes(Class'NavigationPoint', navPoint, None, dist)
		{
			tempRot = Rotator(navPoint.Location - Location);
			absYaw = (tempRot.Yaw - Yaw) & 65535;
			if (absYaw > 32767)
				absYaw -= 65536;
			absYaw = Abs(absYaw);
			if ((bestPoint == None) || (bestYaw > absYaw))
			{
				bestPoint = navPoint;
				bestYaw = absYaw;
			}
		}
		if (bestPoint != None)
			awayVect = bestPoint.Location-Location;
		else
		{
			tempRot = Rotator(awayVect);
			tempRot.Pitch += Rand(7282)-3641;   // +/- 20 degrees
			tempRot.Yaw   += Rand(7282)-3641;   // +/- 20 degrees
			awayVect = Vector(tempRot)*segmentDist;
		}
	}
	else
		awayVect = VRand()*segmentDist;

	return (awayVect);

}


// ----------------------------------------------------------------------
// SetupWeapon()
// ----------------------------------------------------------------------

function SetupWeapon(bool bDrawWeapon, optional bool bForce)
{
	if (bKeepWeaponDrawn && !bForce)
		bDrawWeapon = true;

	if (ShouldDropWeapon())
		DropWeapon();
	else if (bDrawWeapon)
	{
//		if (Weapon == None)
		SwitchToBestWeapon();
	}
	else
		SetWeapon(None);
}


// ----------------------------------------------------------------------
// DropWeapon()
// ----------------------------------------------------------------------

function DropWeapon()
{
	local DeusExWeapon dxWeapon;
	local Weapon       oldWeapon;

	if (Weapon != None && !Weapon.IsA('WeaponRifle'))
	{
		dxWeapon = DeusExWeapon(Weapon);
		if ((dxWeapon == None) || !dxWeapon.bNativeAttack)
		{
			oldWeapon = Weapon;
			SetWeapon(None);
			if (oldWeapon.IsA('DeusExWeapon'))  //CyberP: Dropped weapons onto the floor should really give ammo...
                DeusExWeapon(oldWeapon).SetDroppedAmmoCount(PickupAmmoCount);   //RSD: Added PickupAmmoCount for initialization from MissionScript.uc
			if (oldWeapon.IsA('WeaponAssaultGunSpider')) //CyberP: make sure these are destroyed
			    oldWeapon.Destroy();
			else
			    oldWeapon.DropFrom(Location);
		}
	}
}


// ----------------------------------------------------------------------
// SetWeapon()
// ----------------------------------------------------------------------

function SetWeapon(Weapon newWeapon)
{
	if (Weapon == newWeapon)
	{
		if (Weapon != None)
		{
			if (Weapon.IsInState('DownWeapon'))
				Weapon.BringUp();
			Weapon.SetDefaultDisplayProperties();
		}
		if (Inventory != None)
			Inventory.ChangedWeapon();
		PendingWeapon = None;
		return;
	}

	PlayWeaponSwitch(newWeapon);
	if (Weapon != None)
	{
		Weapon.SetDefaultDisplayProperties();
		Weapon.PutDown();
	}

	Weapon = newWeapon;
	if (Inventory != None)
		Inventory.ChangedWeapon();
	if (Weapon != None)
		Weapon.BringUp();

	PendingWeapon = None;
}


// ----------------------------------------------------------------------
// ReactToInjury()
// ----------------------------------------------------------------------

function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
{
	local Name currentState;
	local bool bHateThisInjury;
	local bool bFearThisInjury;

	if ((health > 0) && (instigatedBy != None) && (bLookingForInjury || bLookingForIndirectInjury))
	{
		currentState = GetStateName();

		bHateThisInjury = ShouldReactToInjuryType(damageType, bHateInjury, bHateIndirectInjury);
		bFearThisInjury = ShouldReactToInjuryType(damageType, bFearInjury, bFearIndirectInjury);

		if (bHateThisInjury)
			IncreaseAgitation(instigatedBy);
		if (bFearThisInjury)
			IncreaseFear(instigatedBy, 2.0);

		if (SetEnemy(instigatedBy))
		{
			SetDistressTimer();
			SetNextState('HandlingEnemy');
		}
		else if (bFearThisInjury && IsFearful() )
		{
			SetDistressTimer();
			SetEnemy(instigatedBy, , true);
			SetNextState('Fleeing');
		}
		else
		{
//			if (instigatedBy.bIsPlayer)
//				ReactToFutz();
			SetNextState(currentState);
		}
		GotoDisabledState(damageType, hitPos);
	}
}


// ----------------------------------------------------------------------
// TakeHit()
// ----------------------------------------------------------------------

function TakeHit(EHitLocation hitPos)
{
	if (hitPos != HITLOC_None)
	{
		PlayTakingHit(hitPos);
		GotoState('TakingHit');
	}
	else
		GotoNextState();
}


// ----------------------------------------------------------------------
// ComputeFallDirection()
// ----------------------------------------------------------------------

function ComputeFallDirection(float totalTime, int numFrames,
							  out vector moveDir, out float stopTime)
{
	// Determine direction, and how long to slide
	if (AnimSequence == 'DeathFront')
	{
		moveDir = Vector(DesiredRotation) * Default.CollisionRadius*0.75;
		if (numFrames > 5)
			stopTime = totalTime * ((numFrames-5)/float(numFrames));
		else
			stopTime = totalTime * 0.5;
	}
	else if (AnimSequence == 'DeathBack')
	{
		moveDir = -Vector(DesiredRotation) * Default.CollisionRadius*0.75;
		if (numFrames > 5)
			stopTime = totalTime * ((numFrames-5)/float(numFrames));
		else
			stopTime = totalTime * 0.9;
	}
}


// ----------------------------------------------------------------------
// WillTakeStompDamage()
// ----------------------------------------------------------------------

function bool WillTakeStompDamage(Actor stomper)
{
	return true;
}


// ----------------------------------------------------------------------
// DrawShield()
// ----------------------------------------------------------------------

function DrawShield()
{
	local EllipseEffect shield;

	shield = Spawn(class'EllipseEffect', Self,, Location, Rotation);
	if (shield != None)
		shield.SetBase(Self);
}


// ----------------------------------------------------------------------
// StandUp()
// ----------------------------------------------------------------------

function StandUp(optional bool bInstant)
{
	local vector placeToStand;

	if (bSitting)
	{
		bSitInterpolation = false;
		bSitting          = false;

		EnableCollision(true);
		SetBase(None);
		SetPhysics(PHYS_Falling);
		ResetBasedPawnSize();

		if (!bInstant && (SeatActor != None) && IsOverlapping(SeatActor))
		{
			bStandInterpolation = true;
			remainingStandTime  = 0.3;
			StandRate = (Vector(SeatActor.Rotation+Rot(0, -16384, 0))*CollisionRadius) /
			            remainingStandTime;
		}
		else
			StopStanding();
	}

	if (SeatActor != None)
	{
		if (SeatActor.sittingActor[seatSlot] == self)
			SeatActor.sittingActor[seatSlot] = None;
		SeatActor = None;
	}

	if (bDancing)
		bDancing = false;
}


// ----------------------------------------------------------------------
// StopStanding()
// ----------------------------------------------------------------------

function StopStanding()
{
	if (bStandInterpolation)
	{
		bStandInterpolation = false;
		remainingStandTime  = 0;
		if (Physics == PHYS_Flying)
			SetPhysics(PHYS_Falling);
	}

}


// ----------------------------------------------------------------------
// UpdateStanding()
// ----------------------------------------------------------------------

function UpdateStanding(float deltaSeconds)
{
	local float  delta;
	local vector newPos;

	if (bStandInterpolation)
	{
		if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)))  // the bastard's walking now
			StopStanding();
		else
		{
			if ((deltaSeconds < remainingStandTime) && (remainingStandTime > 0))
			{
				delta = deltaSeconds;
				remainingStandTime -= deltaSeconds;
			}
			else
			{
				delta = remainingStandTime;
				StopStanding();
			}
			newPos = StandRate*delta;
			Move(newPos);
		}
	}
}


// ----------------------------------------------------------------------
// JumpOutOfWater()
// ----------------------------------------------------------------------

function JumpOutOfWater(vector jumpDir)
{
	Falling();
	Velocity = jumpDir * WaterSpeed;
	Acceleration = jumpDir * AccelRate;
	velocity.Z = 380; //set here so physics uses this for remainder of tick
	PlayFalling();
	bUpAndOut = true;
}


// ----------------------------------------------------------------------
// SupportActor()
//
// Modified from DeusExDecoration.uc
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

	standingMass = FMax(1, standingActor.Mass);
	baseMass     = FMax(1, Mass);
	if ((Physics == PHYS_Swimming) && Region.Zone.bWaterZone)
	{
		newVelocity = standingActor.Velocity;
		newVelocity *= 0.5*standingMass/baseMass;
		AddVelocity(newVelocity);
	}
	else
	{
		zVelocity    = standingActor.Velocity.Z;
		damagePoint  = Location + vect(0,0,1)*(CollisionHeight-1);
		damage       = (1 - (standingMass/baseMass) * (zVelocity/100));

		// Have we been stomped?
		if ((zVelocity*standingMass < -7500) && (damage > 0) && WillTakeStompDamage(standingActor))
			TakeDamage(damage, standingActor.Instigator, damagePoint, 0.2*standingActor.Velocity, 'stomped');

		if (IsA('Rat'))
		{
			TakeDamage(6, standingActor.Instigator, damagePoint, 0.2*standingActor.Velocity, 'stomped');
			AISendEvent('LoudNoise',EAITYPE_Audio, 0.25,416);
		}
	}
    if (!IsA('Rat') && !IsA('SpiderBot2') && !IsA('SpiderBot3') && !IsA('SpiderBot4'))
    {
	// Bounce the actor off the pawn
	angle = FRand()*Pi*2;
	newVelocity.X = cos(angle);
	newVelocity.Y = sin(angle);
	newVelocity.Z = 0;
	newVelocity *= FRand()*25 + 25;
	newVelocity += standingActor.Velocity;
	newVelocity.Z = 50;
	standingActor.Velocity = newVelocity;
	standingActor.SetPhysics(PHYS_Falling);
	}
}

// ----------------------------------------------------------------------
// PopHead()
// ----------------------------------------------------------------------

function PopHead()
{

}

function HelmetBreak()
{
local int i;
local PlasticFragment fragg;
local vector loc;

 loc = Location;
 loc.Z += CollisionHeight+4;

 if (mesh != default.mesh)
   return;

 for(i=0;i<35;i++)
 {
 fragg = Spawn(class'PlasticFragment',self,,loc);
 if (fragg != None)
 {
  fragg.RotationRate = RotRand();
  fragg.Skin = Multiskins[6];
  fragg.DrawScale *= 0.3 * Frand();
  fragg.Velocity = VRand()*80;
 }
 }
 Multiskins[6]=None;
 bHasHelmet=False;
 if (IsA('UNATCOTroop'))
     CarcassType = Class'DeusEx.UNATCOTroopCarcassDehelm';
 else if (IsA('Soldier'))
     CarcassType = Class'DeusEx.SoldierCarcassDehelm';
 else if (IsA('Mechanic'))
     CarcassType=Class'DeusEx.MechanicCarcass2';
}

singular function HelmetSpawn(Vector hitLocation, int actualDamage, Pawn instigatedBy)
{
local int i;
local GMDXUnatcoDamHelmet dh;
local vector loc;

 loc = Location;
 loc.Z += CollisionHeight+3;

 if (mesh != default.mesh || instigatedBy == None)
   return;

 dh = Spawn(class'GMDXUnatcoDamHelmet',,,loc);
 if (dh != None)
 {
    dh.Velocity = Vector(instigatedBy.ViewRotation) * (170 + actualDamage); //CyberP/Totalitarian: terrible, lazy hack.
    dh.Velocity.Z += 50;
    dh.SetTimer(0.4,false);
 }

 Multiskins[6]=None;
 bHasHelmet=False;
 if (IsA('UNATCOTroop'))
     CarcassType = Class'DeusEx.UNATCOTroopCarcassDehelm';
 else if (IsA('Soldier'))
     CarcassType = Class'DeusEx.SoldierCarcassDehelm';
}
// ----------------------------------------------------------------------
// SpawnCarcass()
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
	local DeusExCarcass carc;
	local vector loc;
	local Inventory item, nextItem;
	local FleshFragment chunk;
	local FleshFragmentAnimal chunk2;
	local BloodSpurt spur;
	local int i, j;
	local float size;
    local WeaponShuriken shuri;
	// if we really got blown up good, gib us and don't display a carcass
	if ((Health < -100) && !IsA('Robot')) //CyberP: was -100
	{
		size = (CollisionRadius + CollisionHeight) / 2;
        ExpelInventory(); //CyberP:
		if (size > 10.0)
		{
			spawn(class'FleshFragmentSmoking');   //CyberP: not in the loop below so less spawned.
			spawn(class'FleshFragmentSmoking');
			spawn(class'FleshFragmentSmoking');   //CyberP: not in the loop below so less spawned.
			spawn(class'FleshFragmentSmoking');
            spawn(class'BloodDropFlying');
            spawn(class'BloodDropFlying');
            spawn(class'BloodDropFlying');
            spawn(class'BloodDropFlying');
            Spawn(class'FleshFragmentSmall');
	        Spawn(class'FleshFragmentSmall');
            Spawn(class'FleshFragmentSmall');
            Spawn(class'FleshFragmentSmall');
            Spawn(class'FleshFragmentSmall');
            Spawn(class'FleshFragmentSmall');
            loc.X = (1-2*FRand()) * CollisionRadius;
			loc.Y = (1-2*FRand()) * CollisionRadius;
			loc.Z = (1-2*FRand()) * CollisionHeight;
			loc += Location;
			if (!IsA('Animal'))
			{
                Spawn(class'BloodExplodeHit');
			//spawn(class'BoneSkullBloody');
			 //spur = spawn(class'BloodSpurt');
                //if (spur!=none && i < 2)
                //{
                //spur.LifeSpan+=0.3;
                //spur.DrawScale+=FRand();
                //}
			for (i=0; i<size/1.1; i++) //CyberP: was /1.2
			{
				spawn(class'BloodDropFlying',,, loc);
                chunk = spawn(class'FleshFragment', None,, loc);
				if (chunk != None)
				{
				   if (bBurnedUp)
					{
					if (FRand() < 0.5)
                       chunk.Velocity.Z = FRand()* 650;
					chunk.DrawScale = size / 26;
					if (FRand() < 0.3)
					{
                      //chunk.Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex5';//Texture'Effects.Fire.Wepn_Prifle_SFX';
					  chunk.Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPAlarmLightTex5","DeusExDeco.Skins.AlarmLightTex5",IsHDTP());
                      chunk.LightEffect=LE_FireWaver;
                      chunk.LightBrightness=255;
                      chunk.LightHue=80;
                      chunk.LightSaturation=128;
                      chunk.LightRadius=2;
                    }
                    if (FRand() < 0.1)
                      chunk.bSmoking = true;
					}
					else
					{
                 	chunk.DrawScale = size / 22;
                 	if (FRand() < 0.5)
                       chunk.Velocity.Z = FRand()* 675;
					chunk.bFixedRotationDir = False;
					chunk.RotationRate = RotRand()*1000;
					}
       			}
			}
			}
			else
			{
                Spawn(class'BloodExplodeHit');
                  spur = spawn(class'BloodSpurt');
                if (spur!=none && i < 4)
                {
                spur.LifeSpan+=0.3;
                spur.DrawScale+=FRand();
                }
			for (i=0; i<size/1.1; i++) //CyberP: was /1.2
			{
				spawn(class'BloodDropFlying');
                chunk2 = spawn(class'FleshFragmentAnimal', None,, loc);
				if (chunk2 != None)
				{
				   if (bBurnedUp)
					{
					//chunk2.Velocity = VRand() * 300;
					chunk2.DrawScale = size / 26;
					if (FRand() < 0.3)
					{
					  //chunk2.Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex5';//Texture'Effects.Fire.Wepn_Prifle_SFX';
					  chunk2.Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPAlarmLightTex5","DeusExDeco.Skins.AlarmLightTex5",IsHDTP());
                      chunk2.LightEffect=LE_FireWaver;
                      chunk2.LightBrightness=255;
                      chunk2.LightHue=80;
                      chunk2.LightSaturation=128;
                      chunk2.LightRadius=2;
                    }
                    if (FRand() < 0.1)
                      chunk2.bSmoking = true;
					}
					else
					{
                    //chunk2.Velocity = VRand() * 300;
                    if (FRand() < 0.5)
                       chunk2.Velocity.Z = FRand() * 650;
                 	chunk2.DrawScale = size / 22;
					chunk2.bFixedRotationDir = False;
					chunk2.RotationRate = RotRand()*1000;
					}
       			}
			}
			}
		}
		return None;
	}

	// spawn the carcass
	carc = DeusExCarcass(Spawn(CarcassType));

	if ( carc != None )
	{
	    if (bSetupPop)
	        carc.bPop = True;
		if (bStunned)
			carc.bNotDead = True;

        if (bSkinInherit) //CyberP: carc inherit the skins of pawn
        {
          for (i=0; i<arrayCount(multiskins); i++)
          {
              carc.MultiSkins[i] = multiskins[i];
              carc.passedSkins = True;
          }
        }

		carc.Initfor(self);

		// move it down to the floor
		loc = Location;
		loc.z -= Default.CollisionHeight;
		loc.z += carc.Default.CollisionHeight;
		carc.SetLocation(loc);
		carc.Velocity = Velocity;
		carc.Acceleration = Acceleration;

		// give the carcass the pawn's inventory if we aren't an animal or robot
		if (!IsA('Robot')) //&& !IsA('Animal'))
		{
		   if (impaleCount > 0)
           {
    		        item = Spawn(Class'WeaponShuriken', self);
                   // item = item.Inventory;
                    if (item != None)
                    {
                        item.GiveTo(self);
                        item.SetBase(self);
					    item.SetPhysics(PHYS_None);
					    carc.passedImpaleCount = impaleCount;
					}
            }
			if (Inventory != None)
			{
				do
				{
				    j++;
					item = Inventory;
					nextItem = item.Inventory;
					DeleteInventory(item);
					if ((DeusExWeapon(item) != None) && (DeusExWeapon(item).bNativeAttack))
						item.Destroy();
					else
						carc.AddInventory(item);
					item = nextItem;
				}
				until (item == None);
			}

			carc.PickupAmmoCount = PickupAmmoCount;                             //RSD: Transfer this over from initialization in MissionScript.uc
		}
	}

	return carc;
}

// ----------------------------------------------------------------------
// ExpelInventory()
//
// G-Flex: so if the NPC is gibbed, items won't be lost
// G-Flex: uses some logic from SpawnCarcass()
// ----------------------------------------------------------------------

function ExpelInventory()
{
	local Vector loc;
	local Inventory item, nextItem;

	//G-Flex: just like carcass-spawning, don't bother with animal or robot inventories
	if (!IsA('Animal') && !IsA('Robot'))
	{
		if (Inventory != None)
		{
			do
			{
				item = Inventory;
				nextItem = item.Inventory;
				//G-Flex: not necessary to delete items since dropping them does that
				//DeleteInventory(item);
				if ((Ammo(item) != None) || ((DeusExWeapon(item) != None) && (DeusExWeapon(item).bNativeAttack || DeusExWeapon(item).IsA('WeaponAssaultGunSpider'))))
					item.Destroy();
				else
				{
					//G-Flex: spread them out like chunks, but a little less
					loc.X = (1-2*FRand()) * CollisionRadius;
					loc.Y = (1-2*FRand()) * CollisionRadius;
					loc.Z = (1-2*FRand()) * CollisionHeight;
					loc += Location;
					item.DropFrom(loc);

					item.Velocity += Velocity;
					item.Velocity += VRand() * (100.0 + (400.0 / item.Mass));   //RSD: This is way, WAY too much
					//item.Velocity += VRand() * (10.0 + (40.0 / item.Mass));     //RSD: 10x less honestly is enough

					//G-Flex: get the same ammo as from the carcass or a dropped weapon
					if (item.IsA('DeusExWeapon'))
						DeusExWeapon(item).SetDroppedAmmoCount(PickupAmmoCount);//RSD: Added PickupAmmoCount for initialization from MissionScript.uc
				}

				item = nextItem;
			}
			until (item == None);
		}
	}
}
// ----------------------------------------------------------------------
// FilterDamageType()
// ----------------------------------------------------------------------

function bool FilterDamageType(Pawn instigatedBy, Vector hitLocation,
							   Vector offset, Name damageType)
{
	// Special cases for certain damage types
	if (damageType == 'HalonGas')
		if (bOnFire)
			ExtinguishFire();

	if (damageType == 'EMP')
	{      //CYBERP: EMP removes cloak outright
	    if (bHasCloak)
		   bHasCloak = False; CloakThreshold = 0; EnableCloak(False); /*CloakEMPTimer += 10;
		if (CloakEMPTimer > 20)
			CloakEMPTimer = 20;
		EnableCloak(bCloakOn); */
		return false;
	}

	return true;

}


// ----------------------------------------------------------------------
// ModifyDamage()
// ----------------------------------------------------------------------

function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,
							Vector offset, Name damageType)
{
	local int   actualDamage;
	local float headOffsetZ, headOffsetY, armOffset;

	actualDamage = Damage;

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.7;
	headOffsetY = CollisionRadius * 0.3;
	armOffset   = CollisionRadius * 0.35;

	// if the pawn is stunned, damage is 4X
	if (bStunned)
		actualDamage *= 8; //CyberP: now *8, hacky fix

	// if the pawn is hit from behind at point-blank range, he is killed instantly
	else if (offset.x < 0)
		if ((instigatedBy != None) && (VSize(instigatedBy.Location - Location) < 96)) //CyberP: was 64
			actualDamage  *= 12; //CyberP: was 10

	actualDamage = Level.Game.ReduceDamage(actualDamage, DamageType, self, instigatedBy);

	if (ReducedDamageType == 'All') //God mode
		actualDamage = 0;
	else if (Inventory != None) //then check if carrying armor
		actualDamage = Inventory.ReduceDamage(actualDamage, DamageType, HitLocation);

	// gas, EMP and nanovirus do no damage
	if (damageType == 'TearGas' || damageType == 'EMP' || damageType == 'NanoVirus')
		actualDamage = 0;
    else if (damageType == 'Sabot')
        actualDamage *= 0.5;                                                    //RSD: 0.5x damage to organics (was 0.7)
	//if (damageType == 'EMP')
    //{bHasCloak = False; CloakThreshold = 0;}//CyberP: EMP just outright disables cloaking.

	return actualDamage;

}


// ----------------------------------------------------------------------
// ShieldDamage()
// ----------------------------------------------------------------------

function float ShieldDamage(Name damageType)
{
	return 1.0;
}


// ----------------------------------------------------------------------
// ImpartMomentum()
// ----------------------------------------------------------------------

function ImpartMomentum(Vector momentum, Pawn instigatedBy)
{
	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = 0.4 * VSize(momentum);
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;
	AddVelocity( momentum );
}


// ----------------------------------------------------------------------
// AddVelocity()
// ----------------------------------------------------------------------

function AddVelocity(Vector momentum)
{
	if (VSize(momentum) > 0.001)
		Super.AddVelocity(momentum);
}


// ----------------------------------------------------------------------
// CanShowPain()
// ----------------------------------------------------------------------

function bool CanShowPain()
{
	if (bShowPain && (TakeHitTimer <= 0))
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// IsPrimaryDamageType()
// ----------------------------------------------------------------------

function bool IsPrimaryDamageType(name damageType)
{
	local bool bPrimary;

	switch (damageType)
	{
		case 'Exploded':
		case 'TearGas':
		case 'HalonGas':
		case 'PoisonGas':
		case 'PoisonEffect':
		case 'Radiation':
		case 'EMP':
		case 'Drowned':
		case 'NanoVirus':
			bPrimary = false;
			break;

		case 'Stunned':
		case 'KnockedOut':
		case 'Burned':
		case 'Flamed':
		case 'Poison':
		case 'Shot':
		case 'Sabot':
		default:
			bPrimary = true;
			break;
	}

	return (bPrimary);
}


// ----------------------------------------------------------------------
// ShouldReactToInjuryType()
// ----------------------------------------------------------------------

function bool ShouldReactToInjuryType(name damageType,
									  bool bHatePrimary, bool bHateSecondary)
{
	local bool bIsPrimary;

	bIsPrimary = IsPrimaryDamageType(damageType);
	if ((bHatePrimary && bIsPrimary) || (bHateSecondary && !bIsPrimary))
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// HandleDamage()
// ----------------------------------------------------------------------

function EHitLocation HandleDamage(out int actualDamage, Vector hitLocation, Vector offset, name damageType, optional Pawn instigatedBy) //RSD: made actualDamage and damageType call by ref so hitting helmets produces no pain sounds
{
	local EHitLocation hitPos;
	local float        headOffsetZ, headOffsetY, armOffset;
    local float ricochetRand;                                                   //RSD: Added
    local name origDamageType;                                                  //RSD: Added

    origDamageType = damageType;                                                //RSD: For distinct helmet hit sounds

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.7;
	headOffsetY = CollisionRadius * 0.3;
	armOffset   = CollisionRadius * 0.35;

	hitPos = HITLOC_None;

	if (actualDamage > 0)
	{
		if (damageType == 'Burned' || damageType == 'Exploded' || damageType == 'Flamed') // Trash: Code stolen directly from RoSoDude, basically only deal torso damage multiplied by 4 if it's a flamethrower, explosive weapon, or the plasma gun for consistency.
		{
			healthTorso -= actualDamage * 4;
		}
		else if (offset.z > headOffsetZ)		// head
		{
		    if (offset.z > CollisionHeight * 0.85 && !(abs(offset.y) < headOffsetY && offset.x > 0.0 && offset.z < CollisionHeight*0.93) //RSD: Was CollisionHeight*0.93, I'm making it *0.85, and NOT from the front
            	&& bHasHelmet && (damageType == 'Shot' || damageType == 'Poison' || damageType == 'Stunned'))
            {
                    //PlaySound(sound'ArmorRicochet',SLOT_Interact,,true,1536); //RSD: New ricochet sounds because I hate that one
                    if (IsA('Mechanic') && (actualDamage >= 25 || FRand() < 0.2))
                    {
                          HelmetBreak();
                    }
                    else if (IsA('UNATCOTroop') && (actualDamage >= 25 || FRand() < 0.08))
                    {
                          HelmetSpawn(Location+vect(0,0,49), actualDamage, instigatedBy);
                          if (actualDamage < 25)
                          {
                          actualDamage = 0;
                          damageType = '';
                          }
                    }
                    else
                    {
                    if (actualDamage >= 25)
                    {
                    }
                    else
                    {
                        actualDamage = 0;
                        damageType = '';
                    }
                    }

                    if (actualDamage <= 0)                                      //RSD: Only play helmet sounds if we didn't do damage!
                    {
                    if (origDamageType == 'Shot')                               //RSD: Play new ricochet sounds for hard damage
                    {
                    ricochetRand = 7.0*FRand();
                    if (ricochetRand < 1.0)
                        PlaySound(sound'PDbulletricochet1',SLOT_Pain,,true,1536); //RSD: trying SLOT_Pain instead of SLOT_Interact for less clipping
                    else if (ricochetRand < 2.0)
                        PlaySound(sound'PDbulletricochet2',SLOT_Pain,,true,1536);
                    else if (ricochetRand < 3.0)
                        PlaySound(sound'PDbulletricochet3',SLOT_Pain,,true,1536);
                    else if (ricochetRand < 4.0)
                        PlaySound(sound'PDbulletricochet4',SLOT_Pain,,true,1536);
                    else if (ricochetRand < 5.0)
                        PlaySound(sound'PDbulletricochet6',SLOT_Pain,,true,1536); //RSD: 5 is ridiculous and usually gets cut off, double up on sound 6
                    else if (ricochetRand < 6.0)
                        PlaySound(sound'PDbulletricochet6',SLOT_Pain,,true,1536);
                    else
                        PlaySound(sound'PDbulletricochet7',SLOT_Pain,,true,1536);
                    }
                    else                                                        //RSD: Play weak sound for soft damage (tranq/taser darts, prod)
                        //PlaySound(sound'BatonHitSoft',SLOT_Interact,,true,1536);
                        PlaySound(sound'BatonHitSoft', SLOT_Pain, 5.0,true,1536,1.15);
                    }


            }
            else if (bHasHelmet && damageType == 'Sabot')
            {
                actualDamage *= 2.0;                                            //RSD: Armor piercing damage passes through helmets (x2 here because it's halved in ModifyDamage())
                if (IsA('Mechanic'))                                            //RSD: Also it breaks mechanic helmets
                    {
                          HelmetBreak();
                    }
                    else if (IsA('UNATCOTroop'))                                //RSD: And it pops off trooper helmets
                    {
                          HelmetSpawn(Location+vect(0,0,49), actualDamage, instigatedBy);
                    }
            }
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
			{
				// don't allow headshots with stunning weapons
				if ((damageType == 'Stunned') || (damageType == 'KnockedOut'))
					HealthHead -= actualDamage * 5;      //CyberP: Overruled.
				else
					HealthHead -= actualDamage * (8+extraMult); //CyberP: gmdx headshot multiplier variation
				if (offset.x < 0.0)
				{
					hitPos = HITLOC_HeadBack;
					bFlyer=False;
					// CyberP: DO allow headshots with stunning weapons if from behind.
				    if (((damageType == 'Stunned') || (damageType == 'KnockedOut')) && !IsInState('Attacking'))
					   HealthHead -= actualDamage * 3;
					//bFrontPop=False;
				}
				else
				{
					hitPos = HITLOC_HeadFront;
					bFlyer=False;
					//bFrontPop=True;
				}
			}
			else  // sides of head treated as torso  //CyberP: hmm              //RSD: Nah that's fucking ridiculous, all swapped to HealthHead
			{
			    if ((damageType == 'Stunned') || (damageType == 'KnockedOut'))
					HealthHead -= actualDamage * 5;
				else
				    HealthHead -= actualDamage * (8+extraMult);     //CyberP: lets just multiply the damage as head.
				if (offset.x < 0.0)
				{
					hitPos = HITLOC_HeadBack;                                   //RSD: was HITLOC_TorsoBack
					bFlyer=False;
					// CyberP: DO allow headshots with stunning weapons if from behind.
				    if (((damageType == 'Stunned') || (damageType == 'KnockedOut')) && !IsInState('Attacking'))
					   HealthHead -= actualDamage * 3;                          //RSD: Curiously this was already HealthHead
				}
				else
				{
					hitPos = HITLOC_HeadFront;                                  //RSD: was HITLOC_TorsoFront
					bFlyer=False;
				}
			}
		}
		else if (offset.z < 0.0)	// legs
		{
			if (offset.y > 0.0)
			{
				HealthLegRight -= actualDamage * 3;
				if (offset.x < 0.0)
					hitPos = HITLOC_RightLegBack;
				else
					hitPos = HITLOC_RightLegFront;
					bFlyer=False;
			}
			else
			{
				HealthLegLeft -= actualDamage * 3;
				if (offset.x < 0.0)
					hitPos = HITLOC_LeftLegBack;
				else
					hitPos = HITLOC_LeftLegFront;
				bFlyer=False;
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
				HealthArmRight -= actualDamage * 2;
				if (offset.x < 0.0)
					hitPos = HITLOC_RightArmBack;
				else
					hitPos = HITLOC_RightArmFront;
					bFlyer=False;
			}
			else if (offset.y < -armOffset)
			{
				HealthArmLeft -= actualDamage * 2;
				if (offset.x < 0.0)
					hitPos = HITLOC_LeftArmBack;
				else
					hitPos = HITLOC_LeftArmFront;
					bFlyer=False;
			}
			else
			{
				HealthTorso -= actualDamage * 3; //CyberP: torso and legs was *2. Make them a bit more vulnerable
				if (offset.x < 0.0)
				{
					hitPos = HITLOC_TorsoBack;
					bFlyer=False;
				}
				else
				{
					hitPos = HITLOC_TorsoFront;
			    	bFlyer=True;
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
	GenerateTotalHealth();

    bHeadshotAltered = false;                                                   //RSD: Ensuring that no extraMult is added in edge cases

	return hitPos;
}


// ----------------------------------------------------------------------
// TakeDamageBase()
// ----------------------------------------------------------------------

function TakeDamageBase(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType,
						bool bPlayAnim)
{
	local int          actualDamage;
	local Vector       offset;
	local float        origHealth;
	local EHitLocation hitPos;
	local float        shieldMult;
	local DeusExPlayer player;   //CyberP: for screenflash if near gibs
    local float dist;            //CyberP: for screenflash if near gibs
    local GMDXImpactSpark AST;
    local FleshFragmentSmall ffs;
    local int i;
    local DeusExWeapon wepa;
    local float modifier, modifier2;
	local Perk perkAdrenalineRush;

	// use the hitlocation to determine where the pawn is hit
	// transform the worldspace hitlocation into objectspace
	// in objectspace, remember X is front to back
	// Y is side to side, and Z is top to bottom
	offset = (hitLocation - Location) << Rotation;

	if (!CanShowPain())
		bPlayAnim = false;

	// Prevent injury if the NPC is intangible
	if (!bBlockActors && !bBlockPlayers && !bCollideActors)
		return;

	// No damage + no damage type = no reaction
	if ((Damage <= 0) && (damageType == 'None'))
		return;

	// Block certain damage types; perform special ops on others
	if (!FilterDamageType(instigatedBy, hitLocation, offset, damageType))
		return;

	// Impart momentum
	ImpartMomentum(momentum, instigatedBy);

	actualDamage = ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType);

    if (instigatedBy != None && instigatedBy.IsA('DeusExPlayer') && !bHidden && !bCloakOn)
    {
     if (DeusExPlayer(instigatedBy).bHitmarkerOn)
         DeusExPlayer(instigatedBy).hitmarkerTime = 0.2;

     /*if (DeusExPlayer(instigatedBy).inHand != None)                           //RSD: Handling this outside of ScriptedPawn.uc, yuck
     {
        if (DeusExPlayer(instigatedBy).inHand.IsA('WeaponNanoSword') || DeusExPlayer(instigatedBy).inHand.IsA('WeaponCrowbar'))
           extraMult = -2;
        else if (DeusExPlayer(instigatedBy).inHand.IsA('WeaponShuriken')) //RSD: removed unnecessary check for DeusExPlayer(instigatedBy).inHand != None
        {
            if (FRand() < 0.7)
               impaleCount++;
            extraMult = 1;                                                      //RSD: TKs are now x9 on headshots
        }
        else if (DeusExPlayer(instigatedBy).inHand.IsA('WeaponSawedOffShotgun'))
            extraMult = 1;
     }*/
    }

    if (!bHeadshotAltered)                                                      //RSD: Ensuring that no extraMult is added in edge cases
        extraMult = 0;

	if (actualDamage > 0)
	{
		shieldMult = ShieldDamage(damageType);
		if (shieldMult > 0)
			actualDamage = Max(int(actualDamage*shieldMult), 1);
		else
			actualDamage = 0;
		if (shieldMult < 1.0)
			DrawShield();
	}

	origHealth = Health;
    //log("Damage="$Damage);
	hitPos = HandleDamage(actualDamage, hitLocation, offset, damageType, instigatedBy);
	if (!bPlayAnim || (actualDamage <= 0))
		hitPos = HITLOC_None;

	if (bCanBleed)
		if ((damageType != 'Stunned') && (damageType != 'TearGas') && (damageType != 'HalonGas') &&
		    (damageType != 'PoisonGas') && (damageType != 'Radiation') && (damageType != 'EMP') &&
		    (damageType != 'NanoVirus') && (damageType != 'Drowned') && (damageType != 'KnockedOut') &&
		    (damageType != 'Poison') && (damageType != 'PoisonEffect'))
			bleedRate += (origHealth-Health)/(0.3*Default.Health);  // 1/3 of default health = bleed profusely

	if (CarriedDecoration != None)
		DropDecoration();

	if ((actualDamage > 0) && (damageType == 'Poison'))
		StartPoison(Damage, instigatedBy);

    if (bDefensiveStyle) //CyberP: stop camping
        if (Health < default.Health * (0.5+(FRand()*0.3)) && EnemyLastSeen > 1)
		    if (FRand() < 0.4)
		    {
		        bDefendHome = False;
		        bDefensiveStyle = False;
            }

	if (damageType == 'Stunned')
    {
          AST=Spawn(class'GMDXImpactSpark');
          if (AST != None)
          {
             AST.LifeSpan=4.000000;
             AST.DrawScale=0.000001;
             AST.Velocity=vect(0,0,0);
             AST.AmbientSound=Sound'Ambient.Ambient.Electricity3';
             AST.SoundVolume=224;
             AST.SoundRadius=64;
             AST.SoundPitch=64;
		  }
    }

	if (Health <= 0)
	{
		ClearNextState();
		//PlayDeathHit(actualDamage, hitLocation, damageType);
		if ( actualDamage > mass )
			Health = -1 * actualDamage;
		SetEnemy(instigatedBy, 0, true);

    if (bIcarused)
	{
        bFlyer = True;
        hitPos = HITLOC_TorsoFront;
    }
    if (!bSitting && bFlyer && !IsA('Robot') && !IsA('Animal'))
    {
    player = DeusExPlayer(GetPlayerPawn());
    if (DamageType == 'Shot' && (Damage >= 25 || (player.inHand != None && player.inHand.IsA('WeaponAssaultShotgun')) ||
     (player.inHand != None && player.inHand.IsA('WeaponSawedOffShotgun')))) //CyberP: meh
    {
    PlaySound(Sound'GMDXSFX.Generic.BloodSpray',SLOT_None,1.5,,1024);
    SetPhysics(PHYS_Flying);  //flying
    if (bIcarused)
    {
        Velocity = Vector(player.ViewRotation)*100;
        bIcarused = False;
    }
    else
        Velocity = (Momentum*0.25)*(25*128);  // damage*128
    Velocity.Z = 6; //6
    bFixedRotationDir = True;
    if (FRand() < 0.3 && instigator != None && instigator != self && ShouldDropWeapon())
       DropWeapon();
    }
    }

        if (HealthHead < 0 && (DamageType == 'Shot' || DamageType == 'Sabot'))
        {
        deathSoundOverride = Sound'DeusExSounds.Generic.FleshHit1';
       player = DeusExPlayer(GetPlayerPawn());
       //Sarge: Disable head popping because it looks awful, and doesn't work with HDTP
       /*
        if (bCanPop && FRand() < 0.8 && player.bDecap && (player.inHand.IsA('WeaponRifle') || player.inHand.IsA('WeaponAssaultShotgun') ||
     player.inHand.IsA('WeaponSawedOffShotgun'))) //CyberP: I need to change these conditions
        {
            bSetupPop = True;
            spawn(class'BloodSpurt',,,HitLocation);
            PopHead();
            if (player!=none)
            {
                dist = Abs(VSize(player.Location - Location));
                if (dist < 160)
                {
                    player.ClientFlash(14, vect(160,0,0));
                    player.bloodTime = 4.000000;
                }
            }
            for(i=0;i<18;i++)
            {
                ffs = spawn(Class'FleshFragmentSmall',,,hitLocation);
                if (ffs!=none)
                {
                    ffs.Velocity.Z = FRand() * 200 + 200;
                    ffs.Velocity.X *= 0.85;
                    ffs.Velocity.Y *= 0.85;
                }
                spawn(Class'BloodDrop',,,hitLocation);
                spawn(Class'BloodDrop',,,hitLocation);
                spawn(Class'BloodDrop',,,hitLocation);
                spawn(Class'BloodDrop',,,hitLocation);
                spawn(Class'BloodDrop',,,hitLocation);
                spawn(Class'BloodDrop',,,hitLocation);
                spawn(Class'BloodDrop',,,hitLocation);
                spawn(Class'BloodDrop',,,hitLocation);
            }
        }
        */
        spawn(Class'BloodDrop',,,hitLocation);
        spawn(Class'BloodDrop',,,hitLocation);
        spawn(Class'BloodDrop',,,hitLocation);
        }
		// gib us if we get blown up
		if (DamageType == 'Exploded') //|| (DamageType == 'Burned' && !bOnFire))
			{
            Health = -10000;
            //if (DamageType == 'Burned')
              // bBurnedUp = True;
            player = DeusExPlayer(GetPlayerPawn()); //CyberP: for screenflash if near gibs
            if (player != none && CollisionHeight > 10)
            {
   		    dist = Abs(VSize(player.Location - Location));
   		    if (dist < 192)
   		     {
                player.ClientFlash(14, vect(180,0,0));
                player.bloodTime = 5.000000;
             }
            }
            }
		else
			{
            Health = -1;
            }
		Died(instigatedBy, damageType, HitLocation);
        if (instigatedBy != None && instigatedBy.IsA('DeusExPlayer'))
        {
            if (DeusExPlayer(instigatedBy).AugmentationSystem.GetAugLevelValue(class'DeusEx.AugEnergyTransfer') > -1.0) //RSD: remove Energy Transference here?
            {
             if (DeusExPlayer(instigatedBy).inHand != None && (DeusExPlayer(instigatedBy).inHand.IsA('DeusExWeapon') &&
                 DeusExWeapon(DeusExPlayer(instigatedBy).inHand).bHandToHand && DeusExWeapon(DeusExPlayer(instigatedBy).inHand).AccurateRange < 200) )
             {
             if (bIsHuman || IsA('Animal'))
             {
             if (GetPawnAllianceType(DeusExPlayer(instigatedBy)) == ALLIANCE_Hostile)
             {
               if (CheckInitialAlliances() && VSize(DeusExPlayer(instigatedBy).Location - Location) < 128)
               {
                modifier = 1.8 + (DeusExPlayer(instigatedBy).swimDuration - 18);
                modifier *= DeusExPlayer(instigatedBy).AugmentationSystem.GetAugLevelValue(class'DeusEx.AugEnergyTransfer');
                modifier2 = 3;
                modifier2 *= DeusExPlayer(instigatedBy).AugmentationSystem.GetAugLevelValue(class'DeusEx.AugEnergyTransfer');
                if (!IsInState('Attacking'))
                {
                   modifier *= 1.5;
                   modifier2 *= 1.5;
                }
                DeusExPlayer(instigatedBy).swimTimer += modifier;
                DeusExPlayer(instigatedBy).Energy += modifier2;
                if (DeusExPlayer(instigatedBy).swimTimer > DeusExPlayer(instigatedBy).swimDuration)
                   DeusExPlayer(instigatedBy).swimTimer = DeusExPlayer(instigatedBy).swimDuration;
                if (DeusExPlayer(instigatedBy).Energy > 100)
                   DeusExPlayer(instigatedBy).Energy = 100;
                DeusExPlayer(instigatedBy).PlaySound(sound'BioElectricHiss',SLOT_None,0.3,,,0.5);
               }
              }
             }
             }
            }
			
			perkAdrenalineRush = DeusExPlayer(instigatedBy).PerkManager.GetPerkWithClass(class'DeusEx.PerkAdrenalineRush');
			
            if (perkAdrenalineRush.bPerkObtained == true)               //RSD: 50% Stamina return from Adrenaline perk
            {
              if (DeusExPlayer(instigatedBy).inHand != None && (DeusExPlayer(instigatedBy).inHand.IsA('DeusExWeapon') &&
                 DeusExWeapon(DeusExPlayer(instigatedBy).inHand).bHandToHand && DeusExWeapon(DeusExPlayer(instigatedBy).inHand).AccurateRange < 200) )
              {
              DeusExPlayer(instigatedBy).swimTimer += perkAdrenalineRush.PerkValue*DeusExPlayer(instigatedBy).swimDuration;
              if (DeusExPlayer(instigatedBy).swimTimer > DeusExPlayer(instigatedBy).swimDuration)
                   DeusExPlayer(instigatedBy).swimTimer = DeusExPlayer(instigatedBy).swimDuration;
              }
            }
            if (bIsHuman)
            {
                if (damageType != 'Stunned' && damageType != 'KnockedOut' && damageType != 'Poison' && damageType != 'PoisonEffect')
                   DeusExPlayer(instigatedBy).KillerCount+=1;
            }
        }
		if ((DamageType == 'Flamed') || (DamageType == 'Burned') && !IsA('Robot')) //CyberP: Not applicable to robots
		{
			bBurnedToDeath = true;
			ScaleGlow *= 0.1;  // blacken the corpse
		}
		else
			bBurnedToDeath = false;

		return;
	}
	// play a hit sound
	if (DamageType != 'Stunned')
		PlayTakeHitSound(actualDamage, damageType, 1);

	if ((DamageType == 'Flamed') && !bOnFire)
		CatchFire();

	ReactToInjury(instigatedBy, damageType, hitPos);
}


// ----------------------------------------------------------------------
// IsNearHome()
// ----------------------------------------------------------------------

function bool IsNearHome(vector position)
{
	local bool bNear;

	bNear = true;
	if (bUseHome)
	{
		if (VSize(HomeLoc-position) <= HomeExtent)
		{
			if (!FastTrace(position, HomeLoc))
				bNear = false;
		}
		else
			bNear = false;
	}

	return bNear;
}


// ----------------------------------------------------------------------
// IsDoor()
// ----------------------------------------------------------------------

function bool IsDoor(Actor door, optional bool bWarn)
{
	local bool        bIsDoor;
	local DeusExMover dxMover;

	bIsDoor = false;

	dxMover = DeusExMover(door);
	if (dxMover != None)
	{
		if (dxMover.NumKeys > 1)
		{
			if (dxMover.bIsDoor)
				bIsDoor = true;
			/*
			else if (bWarn)  // hack for now
				log("WARNING: NPC "$self$" trying to use door "$dxMover$", but bIsDoor flag is False");
			*/
		}
	}

	return bIsDoor;
}


// ----------------------------------------------------------------------
// CheckOpenDoor()
// ----------------------------------------------------------------------

function CheckOpenDoor(vector HitNormal, actor Door, optional name Label)
{
	local DeusExMover   dxMover;
    local DeusExWeapon  dxWeapon;
    local actor         acti;
    local vector        HitLocation;

    dxWeapon = DeusExWeapon(Weapon);
	dxMover = DeusExMover(Door);
	if (dxMover != None)
	{
		if (((IsA('MIB') && GroundSpeed > default.GroundSpeed) || IsA('Robot')) && IsDoor(dxMover) && dxMover.bBreakable) //CyberP: super mibs & robots run straight through doors.
        {
			dxMover.TakeDamage(200, self, dxMover.Location, Velocity, 'Shot');
			return;
		}
        else if (bCanOpenDoors && !IsDoor(dxMover) && dxMover.bBreakable)
		{
            if (dxMover.DamageThreshold < 4 && IsInState('Attacking') && EnemyLastSeen < 3 && dxWeapon != None && !dxWeapon.bHandToHand && dxWeapon.bInstantHit) //CyberP: stop and shoot if we hit glass
            {
                acti = Trace(HitLocation,HitNormal,Location + (vector(Rotation)) * 100,Location);
                if (acti != None && acti.IsA('DeusExMover'))
                {
                       destination = Location;
                       StopBlendAnims();
                       Velocity = vect(0,0,0);
	                   Acceleration = vect(0, 0, 0);
				       DesiredSpeed = 0;
                       if (HasTwoHandedWeapon())
				          TweenAnimPivot('Shoot2H', 0.1);
			           else
				          TweenAnimPivot('Shoot', 0.1);
                       Weapon.Fire(0);
                       GoToState('Attacking', 'RunToRange');
                }
            }
            if (dxMover != None && !dxMover.bSpecialExclusion)  //CyberP: exclude certain movers (like footlockers) from being steamrolled
			    dxMover.TakeDamage(200, self, dxMover.Location, Velocity, 'Shot');
			return;
		}
		if (dxMover.bInterpolating) //&& (dxMover.MoverEncroachType == ME_IgnoreWhenEncroach)) //CyberP: commented out
			return;

		if (bCanOpenDoors && bInterruptState && !bInTransientState && IsDoor(dxMover, true))
		{
			if (Label == '')
				Label = 'Begin';
			if (GetStateName() != 'OpeningDoor')
				SetNextState(GetStateName(), 'ContinueFromDoor');
			Target = Door;
			destLoc = HitNormal;
			GotoState('OpeningDoor', 'BeginHitNormal');
		}
		else if ((Acceleration != vect(0,0,0)) && (Physics == PHYS_Walking) &&
		         (TurnDirection == TURNING_None))
			Destination = Location;
	}
}


// ----------------------------------------------------------------------
// EncroachedBy()
// ----------------------------------------------------------------------

event EncroachedBy( actor Other )
{
	// overridden so indestructable NPCs aren't InstaGibbed by stupid movement code
}


// ----------------------------------------------------------------------
// EncroachedByMover()
// ----------------------------------------------------------------------

function EncroachedByMover(Mover encroacher)
{
	local DeusExMover dxMover;

	dxMover = DeusExMover(encroacher);
	if (dxMover != None)
		if (!dxMover.bInterpolating && IsDoor(dxMover))
			FrobDoor(dxMover);
}


// ----------------------------------------------------------------------
// FrobDoor()
// ----------------------------------------------------------------------

function bool FrobDoor(actor Target)
{
	local DeusExMover      dxMover;
	local DeusExMover      triggerMover;
	local DeusExDecoration trigger;
	local float            dist;
	local DeusExDecoration bestTrigger;
	local float            bestDist;
	local bool             bDone;

	bDone = false;

	dxMover = DeusExMover(Target);
	if (dxMover != None)
	{
		bestTrigger = None;
		bestDist    = 10000;
		foreach AllActors(Class'DeusExDecoration', trigger)
		{
			if (dxMover.Tag == trigger.Event)
			{
				dist = VSize(Location - trigger.Location);
				if ((bestTrigger == None) || (bestDist > dist))
				{
					bestTrigger = trigger;
					bestDist    = dist;
				}
			}
		}
		if (bestTrigger != None)
		{
			foreach AllActors(Class'DeusExMover', triggerMover, dxMover.Tag)
				triggerMover.Trigger(bestTrigger, self);
			bDone = true;
		}
		else if (dxMover.bFrobbable)
		{
			if ((dxMover.WaitingPawn == None) ||
			    (dxMover.WaitingPawn == self))
			{
				dxMover.Frob(self, None);
				bDone = true;
			}
		}

		if (bDone)
			dxMover.WaitingPawn = self;
	}
	return bDone;

}


// ----------------------------------------------------------------------
// GotoDisabledState()
// ----------------------------------------------------------------------

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
		GotoState('RubbingEyes');
	else if (damageType == 'Stunned')
		GotoState('Stunned');
	else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}


// ----------------------------------------------------------------------
// PlayAnimPivot()
// ----------------------------------------------------------------------

function PlayAnimPivot(name Sequence, optional float Rate, optional float TweenTime,
					   optional vector NewPrePivot)
{
	if (Rate == 0)
		Rate = 1.0;
	if (TweenTime == 0)
		TweenTime = 0.1;
	PlayAnim(Sequence, Rate, TweenTime);
	PrePivotTime    = TweenTime;
	DesiredPrePivot = NewPrePivot + PrePivotOffset;
	if (PrePivotTime <= 0)
		PrePivot = DesiredPrePivot;
}


// ----------------------------------------------------------------------
// LoopAnimPivot()
// ----------------------------------------------------------------------

function LoopAnimPivot(name Sequence, optional float Rate, optional float TweenTime, optional float MinRate,
					   optional vector NewPrePivot)
{
	if (Rate == 0)
		Rate = 1.0;
	if (TweenTime == 0)
		TweenTime = 0.1;
	LoopAnim(Sequence, Rate, TweenTime, MinRate);
	PrePivotTime    = TweenTime;
	DesiredPrePivot = NewPrePivot + PrePivotOffset;
	if (PrePivotTime <= 0)
		PrePivot = DesiredPrePivot;
}


// ----------------------------------------------------------------------
// TweenAnimPivot()
// ----------------------------------------------------------------------

function TweenAnimPivot(name Sequence, float TweenTime,
						optional vector NewPrePivot)
{
	if (TweenTime == 0)
		TweenTime = 0.1;
	TweenAnim(Sequence, TweenTime);
	PrePivotTime    = TweenTime;
	DesiredPrePivot = NewPrePivot + PrePivotOffset;
	if (PrePivotTime <= 0)
		PrePivot = DesiredPrePivot;
}


// ----------------------------------------------------------------------
// HasTwoHandedWeapon()
// ----------------------------------------------------------------------

function Bool HasTwoHandedWeapon()
{
	if ((Weapon != None) && (Weapon.Mass >= 29))
		return True;
	else
		return False;
}


// ----------------------------------------------------------------------
// GetStyleTexture()
// ----------------------------------------------------------------------

function Texture GetStyleTexture(ERenderStyle newStyle, texture oldTex, optional texture newTex)
{
	local texture defaultTex;

	if      (newStyle == STY_Translucent)
		defaultTex = Texture'BlackMaskTex';
	else if (newStyle == STY_Modulated)
		defaultTex = Texture'GrayMaskTex';
	else if (newStyle == STY_Masked)
		defaultTex = Texture'PinkMaskTex';
	else
		defaultTex = Texture'BlackMaskTex';

	if (oldTex == None)
		return defaultTex;
	else if (oldTex == Texture'BlackMaskTex')
		return Texture'BlackMaskTex';  // hack
	else if (oldTex == Texture'GrayMaskTex')
		return defaultTex;
	else if (oldTex == Texture'PinkMaskTex')
		return defaultTex;
	else if (newTex != None)
		return newTex;
	else
		return oldTex;

}


// ----------------------------------------------------------------------
// SetSkinStyle()
// ----------------------------------------------------------------------

function SetSkinStyle(ERenderStyle newStyle, optional texture newTex, optional float newScaleGlow)
{
	local int     i;
	local texture curSkin;
	local texture oldSkin;

	if (newScaleGlow == 0)
		newScaleGlow = ScaleGlow;

	oldSkin = Skin;
	for (i=0; i<8; i++)
	{
		curSkin = GetMeshTexture(i);
		MultiSkins[i] = GetStyleTexture(newStyle, curSkin, newTex);
	}
	Skin      = GetStyleTexture(newStyle, Skin, newTex);
	ScaleGlow = newScaleGlow;
	Style     = newStyle;
}


// ----------------------------------------------------------------------
// ResetSkinStyle()
// ----------------------------------------------------------------------

function ResetSkinStyle()
{
	local int i;

	for (i=0; i<8; i++)
		MultiSkins[i] = Default.MultiSkins[i];
	Skin      = Default.Skin;
	ScaleGlow = Default.ScaleGlow;
	Style     = Default.Style;
	if ((IsA('MJ12Troop') || IsA('MJ12Elite')) && bHasCloak)
	{
	MultiSkins[3] = Texture'DeusExCharacters.Skins.MiscTex1';
	MultiSkins[6] = Texture'DeusExCharacters.Skins.MJ12TroopTex3';
	MultiSkins[7] = None;
	}
}


// ----------------------------------------------------------------------
// EnableCloak()
// ----------------------------------------------------------------------

function EnableCloak(bool bEnable)  // beware! called from C++
{
local bool bCloaked;
local SpoofedCorona cor;
	if (!bHasCloak || (CloakEMPTimer > 0) || (Health <= 0) || bOnFire)
		bEnable = false;

	if (bEnable && !bCloakOn && !bCloaked)
	{
        SetSkinStyle(STY_Translucent, class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPAlarmLightTex6","DeusExDeco.Skins.AlarmLightTex6",IsHDTP()), 0.4);
        SetTimer(0.4,False);
        cor = Spawn(class'SpoofedCorona');
        if (cor != none)
        cor.SetBase(self);
        PlaySound(Sound'CloakUp', SLOT_Pain, 0.85, ,768,1.0);
        AmbientGlow = 255;
        LightType = LT_Strobe;
        LightBrightness = 64;
        LightHue = 160;
        LightSaturation = 96;
        LightRadius = 6;
		KillShadow();
		bCloakOn = bEnable;
		bCloaked = True;
	}
	else if (!bEnable && bCloakOn)
	{
		ResetSkinStyle();
		CreateShadow();
		LightRadius = 0;
        AmbientGlow = 0;
		bCloakOn = bEnable;
		bCloaked = False;
		if (Health > 0)
		PlaySound(Sound'CloakDown', SLOT_Pain, 0.85, ,768,1.0);
	}
}

function ForceCloakOff()                                                        //RSD: Hack function to force cloak off without playing sounds
{
		ResetSkinStyle();
		CreateShadow();
		LightRadius = 0;
        AmbientGlow = 0;
		bCloakOn = False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// SOUND FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// PlayBodyThud()
// ----------------------------------------------------------------------

function PlayBodyThud()
{
	PlaySound(sound'BodyThud', SLOT_Interact);
}


// ----------------------------------------------------------------------
// RandomPitch()
//
// Repetitive sound pitch randomizer to help make some sounds
// sound less monotonous
// ----------------------------------------------------------------------

function float RandomPitch()
{
	return (1.1 - 0.2*FRand());
}


// ----------------------------------------------------------------------
// Gasp()
// ----------------------------------------------------------------------

function Gasp()
{
	PlaySound(sound'MaleGasp', SLOT_Pain,,,, RandomPitch());
}


// ----------------------------------------------------------------------
// PlayDyingSound()
// ----------------------------------------------------------------------

function PlayDyingSound()
{
	SetDistressTimer();

	PlaySound(GetDeathSound(), SLOT_Pain,,,, RandomPitch());
	if (bEmitDistress)
		AISendEvent('Distress', EAITYPE_Audio,0.25,336); //CyberP: radius was 490 //RSD: psshh, only 224? We going to 336 baby
	AISendEvent('LoudNoise', EAITYPE_Audio,0.25,224);                           //RSD: was 320, to make it line up more with vanilla ratio it's now 224
}


// ----------------------------------------------------------------------
// PlayIdleSound()
// ----------------------------------------------------------------------

function PlayIdleSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_Idle);
}


// ----------------------------------------------------------------------
// PlayScanningSound()
// ----------------------------------------------------------------------

function PlayScanningSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_Scanning);
}


// ----------------------------------------------------------------------
// PlayPreAttackSearchingSound()
// ----------------------------------------------------------------------

function PlayPreAttackSearchingSound()
{
	local DeusExPlayer dxPlayer;


	dxPlayer = DeusExPlayer(GetPlayerPawn());

	if ((dxPlayer != None) && (SeekPawn == dxPlayer) && (FRand() < 0.7)) //CyberP: a bit of randomness
		dxPlayer.StartAIBarkConversation(self, BM_PreAttackSearching);
}


// ----------------------------------------------------------------------
// PlayPreAttackSightingSound()
// ----------------------------------------------------------------------

function PlayPreAttackSightingSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer) && (FRand() < 0.7)) //CyberP: a bit of randomness
		dxPlayer.StartAIBarkConversation(self, BM_PreAttackSighting);
}


// ----------------------------------------------------------------------
// PlayPostAttackSearchingSound()
// ----------------------------------------------------------------------

function PlayPostAttackSearchingSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer) && (FRand() < 0.7))  //CyberP: a bit of randomness
		dxPlayer.StartAIBarkConversation(self, BM_PostAttackSearching);
}


// ----------------------------------------------------------------------
// PlayTargetAcquiredSound()
// ----------------------------------------------------------------------

function PlayTargetAcquiredSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_TargetAcquired);
}


// ----------------------------------------------------------------------
// PlayTargetLostSound()
// ----------------------------------------------------------------------

function PlayTargetLostSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_TargetLost);
}


// ----------------------------------------------------------------------
// PlaySearchGiveUpSound()
// ----------------------------------------------------------------------

function PlaySearchGiveUpSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer) && (FRand() < 0.7))
		dxPlayer.StartAIBarkConversation(self, BM_SearchGiveUp);
}


// ----------------------------------------------------------------------
// PlayNewTargetSound()
// ----------------------------------------------------------------------

function PlayNewTargetSound()
{
	// someday...
}


// ----------------------------------------------------------------------
// PlayGoingForAlarmSound()
// ----------------------------------------------------------------------

function PlayGoingForAlarmSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer) && (FRand() < 0.7))
		dxPlayer.StartAIBarkConversation(self, BM_GoingForAlarm);
}


// ----------------------------------------------------------------------
// PlayOutOfAmmoSound()
// ----------------------------------------------------------------------

function PlayOutOfAmmoSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_OutOfAmmo);
}


// ----------------------------------------------------------------------
// PlayCriticalDamageSound()
// ----------------------------------------------------------------------

function PlayCriticalDamageSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_CriticalDamage);
}


// ----------------------------------------------------------------------
// PlayAreaSecureSound()
// ----------------------------------------------------------------------

function PlayAreaSecureSound()
{
	local DeusExPlayer dxPlayer;

	// Should we do a player check here?

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer) && (FRand() < 0.6)) //CyberP: cutting down on pawns barking same lines
		dxPlayer.StartAIBarkConversation(self, BM_AreaSecure);

}


// ----------------------------------------------------------------------
// PlayFutzSound()
// ----------------------------------------------------------------------

function PlayFutzSound()
{
	local DeusExPlayer dxPlayer;
	local Name         conName;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
	{
		if (dxPlayer.barkManager != None)
		{
			conName = dxPlayer.barkManager.BuildBarkName(self, BM_Futz);
			dxPlayer.StartConversationByName(conName, self, !bInterruptState);
		}
//		dxPlayer.StartAIBarkConversation(self, BM_Futz);
	}
}


// ----------------------------------------------------------------------
// PlayOnFireSound()
// ----------------------------------------------------------------------

function PlayOnFireSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_OnFire);
}


// ----------------------------------------------------------------------
// PlayTearGasSound()
// ----------------------------------------------------------------------

function PlayTearGasSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if (dxPlayer != None)
		dxPlayer.StartAIBarkConversation(self, BM_TearGas);
}


// ----------------------------------------------------------------------
// PlayCarcassSound()
// ----------------------------------------------------------------------

function PlayCarcassSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (SeekPawn == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_Gore);
}


// ----------------------------------------------------------------------
// PlaySurpriseSound()
// ----------------------------------------------------------------------

function PlaySurpriseSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_Surprise);
}


// ----------------------------------------------------------------------
// PlayAllianceHostileSound()
// ----------------------------------------------------------------------

function PlayAllianceHostileSound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_AllianceHostile);
}


// ----------------------------------------------------------------------
// PlayAllianceFriendlySound()
// ----------------------------------------------------------------------

function PlayAllianceFriendlySound()
{
	local DeusExPlayer dxPlayer;

	dxPlayer = DeusExPlayer(GetPlayerPawn());
	if ((dxPlayer != None) && (Enemy == dxPlayer))
		dxPlayer.StartAIBarkConversation(self, BM_AllianceFriendly);
}


// ----------------------------------------------------------------------
// PlayTakeHitSound()
// ----------------------------------------------------------------------

function PlayTakeHitSound(int Damage, name damageType, int Mult)
{
	local Sound hitSound;
	local float volume;

	if (Level.TimeSeconds - LastPainSound < 0.33) //CyberP: modded
		return;
	if (Damage <= 0)
		return;

	LastPainSound = Level.TimeSeconds;
	
    if (damageType != 'Exploded')
        hitSound = GetRandomHitSound();

	volume = FMax(Mult*TransientSoundVolume, Mult*2.0);

	SetDistressTimer();
    if (hitSound != None)
    {
        PlaySound(hitSound, SLOT_Pain, volume,,, RandomPitch());
        if (bEmitDistress)
            AISendEvent('Distress', EAITYPE_Audio, volume,224); //CyberP: added radius param
    }
}


// ----------------------------------------------------------------------
// GetFloorMaterial()
//
// Gets the name of the texture group that we are standing on
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
    SpecTexNPC = texName;
	return texGroup;
}


// ----------------------------------------------------------------------
// PlayFootStep()
//
// Plays footstep sounds based on the texture group
// (yes, I know this looks nasty -- I'll have to figure out a cleaner way to do this)
// ----------------------------------------------------------------------

function PlayFootStep()
{
	local Sound stepSound;
	local float rnd;
	local name mat;
	local float speedFactor, massFactor;
	local float volume, pitch, range;
	local float radius, maxRadius;
	local float volumeMultiplier;

	local DeusExPlayer dxPlayer;
	local float shakeRadius, shakeMagnitude;
	local float playerDist;

	rnd = FRand();
	mat = GetFloorMaterial();

	volumeMultiplier = 1.0;
	if (WalkSound == None)
	{
		if (FootRegion.Zone.bWaterZone)
		{
			if (rnd < 0.33)
				stepSound = Sound'WaterStep1';
			else if (rnd < 0.66)
				stepSound = Sound'WaterStep2';
			else
				stepSound = Sound'WaterStep3';
		}
		else
		{
			switch(mat)
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
                if (SpecTexNPC == 'A51_Floor_01')
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
			    else if (SpecTexNPC == 'metalgrate_a')
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
			    	if (SpecTexNPC == 'OldeOakPlank_A')
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
	}
	else
		stepSound = WalkSound;

	// compute sound volume, range and pitch, based on mass and speed
	speedFactor = VSize(Velocity)/120.0;
	massFactor  = Mass/150.0;
	radius      = 768.0;
	maxRadius   = 2048.0;
//	volume      = (speedFactor+0.2)*massFactor;
//	volume      = (speedFactor+0.7)*massFactor;
	volume      = massFactor*1.5;
	range       = radius * volume;
	pitch       = (volume+0.5);
	volume      = 1.0;
	range       = FClamp(range, 0.01, maxRadius);
	pitch       = FClamp(pitch, 1.0, 1.5);
    if (IsA('GuntherHermann'))
        pitch*=1.2;
	// play the sound and send an AI event
	PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
	AISendEvent('LoudNoise', EAITYPE_Audio, volume*volumeMultiplier, range*volumeMultiplier);

	// Shake the camera when heavy things tread
	if (Mass > 400)
	{
	radius      = 512.0;
		dxPlayer = DeusExPlayer(GetPlayerPawn());
		if (dxPlayer != None)
		{
			playerDist = DistanceFromPlayer;
			shakeRadius = FClamp((Mass-400)/300, 0, 1) * (range*0.5);
			shakeMagnitude = FClamp((Mass-400)/1600, 0, 1);
			shakeMagnitude = FClamp(1.0-(playerDist/shakeRadius), 0, 1) * shakeMagnitude;
			if (shakeMagnitude > 0 && playerDist < 512)
				dxPlayer.JoltView(shakeMagnitude);
		}
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ANIMATION CALLS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// GetSwimPivot()
// ----------------------------------------------------------------------

function vector GetSwimPivot()
{
	// THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
	return (vect(0,0,1)*CollisionHeight*0.65);
}


// ----------------------------------------------------------------------
// GetWalkingSpeed()
// ----------------------------------------------------------------------

function float GetWalkingSpeed()
{
	if (Physics == PHYS_Swimming)
		return MaxDesiredSpeed;
	else
		return WalkingSpeed;
}


// ----------------------------------------------------------------------
// PlayTurnHead()
// ----------------------------------------------------------------------

function bool PlayTurnHead(ELookDirection newLookDir, float rate, float tweentime)
{
	if (bCanTurnHead)
	{
		if (Super.PlayTurnHead(newLookDir, rate, tweentime))
		{
			AIAddViewRotation = rot(0,0,0); // default
			switch (newLookDir)
			{
				case LOOK_Left:
					AIAddViewRotation = rot(0,-5461,0);  // 30 degrees left
					break;
				case LOOK_Right:
					AIAddViewRotation = rot(0,5461,0);   // 30 degrees right
					break;
				case LOOK_Up:
					AIAddViewRotation = rot(5461,0,0);   // 30 degrees up
					break;
				case LOOK_Down:
					AIAddViewRotation = rot(-5461,0,0);  // 30 degrees down
					break;

				case LOOK_Forward:
					AIAddViewRotation = rot(0,0,0);      // 0 degrees
					break;
			}
		}
		else
			return false;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// PlayRunningAndFiring()
// ----------------------------------------------------------------------

function PlayRunningAndFiring()
{
	local DeusExWeapon W;
	local vector       v1, v2;
	local float        dotp;

	bIsWalking = FALSE;

	W = DeusExWeapon(Weapon);

	if (W != None)
	{
		if (Region.Zone.bWaterZone)
		{
			if (W.bHandToHand)
				LoopAnimPivot('Tread',,0.1,,GetSwimPivot());
			else
				LoopAnimPivot('TreadShoot',,0.1,,GetSwimPivot());
		}
		else
		{
			if (W.bHandToHand)
				LoopAnimPivot('Run',runAnimMult,0.1);
			else
			{
				v1 = Normal((Enemy.Location - Location)*vect(1,1,0));
				if (destPoint != None)
					v2 = Normal((destPoint.Location - Location)*vect(1,1,0));
				else
					v2 = Normal((destLoc - Location)*vect(1,1,0));
				dotp = Abs(v1 dot v2);
				if (dotp < 0.82682867)  // running sideways //CyberP: was 0.70710678
				{
					if (HasTwoHandedWeapon())
						LoopAnimPivot('Strafe2H',runAnimMult,0.1);
					else
						LoopAnimPivot('Strafe',runAnimMult,0.1);
				}
				else
				{
					if (HasTwoHandedWeapon())
						LoopAnimPivot('RunShoot2H',runAnimMult,0.1);
					else
						LoopAnimPivot('RunShoot',runAnimMult,0.1);
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// PlayReloadBegin()
// ----------------------------------------------------------------------

function PlayReloadBegin()
{
	PlayAnimPivot('ReloadBegin',, 0.1);
}


// ----------------------------------------------------------------------
// PlayReload()
// ----------------------------------------------------------------------

function PlayReload()
{
	LoopAnimPivot('Reload',,0.2);
}


// ----------------------------------------------------------------------
// PlayReloadEnd()
// ----------------------------------------------------------------------

function PlayReloadEnd()
{
	PlayAnimPivot('ReloadEnd',, 0.1);
}


// ----------------------------------------------------------------------
// TweenToShoot()
// ----------------------------------------------------------------------

function TweenToShoot(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('TreadShoot', tweentime, GetSwimPivot());
	else if (!bCrouching)
	{
		if (!IsWeaponReloading())
		{
			if (HasTwoHandedWeapon())
				TweenAnimPivot('Shoot2H', tweentime);
			else
				TweenAnimPivot('Shoot', tweentime);
		}
		else
			PlayReload();
	}
}


// ----------------------------------------------------------------------
// PlayShoot()
// ----------------------------------------------------------------------

function PlayShoot()
{
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('TreadShoot', , 0, GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			PlayAnimPivot('Shoot2H', , 0);
		else
			PlayAnimPivot('Shoot', , 0);
	}
}


// ----------------------------------------------------------------------
// TweenToCrouchShoot()
// ----------------------------------------------------------------------

function TweenToCrouchShoot(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('TreadShoot', tweentime, GetSwimPivot());
	else
		TweenAnimPivot('CrouchShoot', tweentime);
}


// ----------------------------------------------------------------------
// PlayCrouchShoot()
// ----------------------------------------------------------------------

function PlayCrouchShoot()
{
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('TreadShoot', , 0, GetSwimPivot());
	else
		PlayAnimPivot('CrouchShoot', , 0);
}


// ----------------------------------------------------------------------
// TweenToAttack()
// ----------------------------------------------------------------------

function TweenToAttack(float tweentime)
{
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
	{
		if (bUseSecondaryAttack)
			TweenAnimPivot('AttackSide', tweentime);
		else
			TweenAnimPivot('Attack', tweentime);
	}
}


// ----------------------------------------------------------------------
// PlayAttack()
// ----------------------------------------------------------------------

function PlayAttack()
{
local DeusExWeapon W;

W = DeusExWeapon(Weapon);

	if (Region.Zone.bWaterZone)
		PlayAnimPivot('Tread',,,GetSwimPivot());
	else
	{
		if (bUseSecondaryAttack)
			PlayAnimPivot('AttackSide',1.25,0.1);  //CyberP: added 1.2, same as below
		else if (W != None && W.bHandToHand)
			PlayAnimPivot('Attack',1.2,0.1);    //CyberP: faster attack rate with melee
		else
			PlayAnimPivot('Attack');
	}
}


// ----------------------------------------------------------------------
// PlayTurning()
// ----------------------------------------------------------------------

function PlayTurning()
{
//	ClientMessage("PlayTurning()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , , , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnimPivot('Walk2H', 0.1);
		else
			TweenAnimPivot('Walk', 0.1);
	}
}


// ----------------------------------------------------------------------
// TweenToWalking()
// ----------------------------------------------------------------------

function TweenToWalking(float tweentime)
{
//	ClientMessage("TweenToWalking()");
	bIsWalking = True;
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnimPivot('Walk2H', tweentime);
		else
			TweenAnimPivot('Walk', tweentime);
	}
}


// ----------------------------------------------------------------------
// PlayWalking()
// ----------------------------------------------------------------------

function PlayWalking()
{
//	ClientMessage("PlayWalking()");
	bIsWalking = True;
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , 0.15, , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnimPivot('Walk2H',walkAnimMult, 0.15);
		else
			LoopAnimPivot('Walk',walkAnimMult, 0.15);
	}
}


// ----------------------------------------------------------------------
// TweenToRunning()
// ----------------------------------------------------------------------

function TweenToRunning(float tweentime)
{
//	ClientMessage("TweenToRunning()");
	bIsWalking = False;
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',, tweentime,, GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnimPivot('RunShoot2H', runAnimMult, tweentime);
		else
			LoopAnimPivot('Run', runAnimMult, tweentime);
	}
}


// ----------------------------------------------------------------------
// PlayRunning()
// ----------------------------------------------------------------------

function PlayRunning()
{
//	ClientMessage("PlayRunning()");
	bIsWalking = False;
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			LoopAnimPivot('RunShoot2H', runAnimMult);
		else
			LoopAnimPivot('Run', runAnimMult);
	}
}


// ----------------------------------------------------------------------
// PlayPanicRunning()
// ----------------------------------------------------------------------

function PlayPanicRunning()
{
//	ClientMessage("PlayPanicRunning()");
	bIsWalking = False;
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
		LoopAnimPivot('Panic', runAnimMult);
}


// ----------------------------------------------------------------------
// TweenToWaiting()
// ----------------------------------------------------------------------

function TweenToWaiting(float tweentime)
{
//	ClientMessage("TweenToWaiting()");
	if (Region.Zone.bWaterZone)
		TweenAnimPivot('Tread', tweentime, GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			TweenAnimPivot('BreatheLight2H', tweentime);
		else
			TweenAnimPivot('BreatheLight', tweentime);
	}
}


// ----------------------------------------------------------------------
// PlayWaiting()
// ----------------------------------------------------------------------

function PlayWaiting()
{
//	ClientMessage("PlayWaiting()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())

                        LoopAnimPivot('BreatheLight2H', , 0.3);
		else
			LoopAnimPivot('BreatheLight', , 0.3);
	}
}


// ----------------------------------------------------------------------
// PlayIdle()
// ----------------------------------------------------------------------

function PlayIdle()
{
//	ClientMessage("PlayIdle()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			PlayAnimPivot('Idle12H', , 0.3);
		else
			PlayAnimPivot('Idle1', , 0.3);
	}
}


// ----------------------------------------------------------------------
// PlayDancing()
// ----------------------------------------------------------------------

function PlayDancing()
{
//	ClientMessage("PlayDancing()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
	else
		LoopAnimPivot('Dance', FRand()*0.2+0.9, 0.3);
}


// ----------------------------------------------------------------------
// PlaySittingDown()
// ----------------------------------------------------------------------

function PlaySittingDown()
{
//	ClientMessage("PlaySittingDown()");
	PlayAnimPivot('SitBegin', , 0.15);
}


// ----------------------------------------------------------------------
// PlaySitting()
// ----------------------------------------------------------------------

function PlaySitting()
{
//	ClientMessage("PlaySitting()");
	LoopAnimPivot('SitBreathe', , 0.15);
}


// ----------------------------------------------------------------------
// PlayStandingUp()
// ----------------------------------------------------------------------

function PlayStandingUp()
{
//	ClientMessage("PlayStandingUp()");
	PlayAnimPivot('SitStand', , 0.15);
}


// ----------------------------------------------------------------------
// PlayRubbingEyesStart()
// ----------------------------------------------------------------------

function PlayRubbingEyesStart()
{
//	ClientMessage("PlayRubbingEyesStart()");
	PlayAnimPivot('RubEyesStart', , 0.15);
}


// ----------------------------------------------------------------------
// PlayRubbingEyes()
// ----------------------------------------------------------------------

function PlayRubbingEyes()
{
//	ClientMessage("PlayRubbingEyes()");
	LoopAnimPivot('RubEyes');
}


// ----------------------------------------------------------------------
// PlayRubbingEyesEnd()
// ----------------------------------------------------------------------

function PlayRubbingEyesEnd()
{
//	ClientMessage("PlayRubbingEyesEnd()");
	PlayAnimPivot('RubEyesStop');
}


// ----------------------------------------------------------------------
// PlayCowerBegin()
// ----------------------------------------------------------------------

function PlayCowerBegin()
{
//	ClientMessage("PlayCowerBegin()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
		PlayAnimPivot('CowerBegin');
}


// ----------------------------------------------------------------------
// PlayCowering()
// ----------------------------------------------------------------------

function PlayCowering()
{
//	ClientMessage("PlayCowering()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
		LoopAnimPivot('CowerStill');
}


// ----------------------------------------------------------------------
// PlayCowerEnd()
// ----------------------------------------------------------------------

function PlayCowerEnd()
{
//	ClientMessage("PlayCowerEnd()");
	if (Region.Zone.bWaterZone)
		LoopAnimPivot('Tread',,,,GetSwimPivot());
	else
		PlayAnimPivot('CowerEnd');
}


// ----------------------------------------------------------------------
// PlayStunned()
// ----------------------------------------------------------------------

function PlayStunned()
{
//	ClientMessage("PlayStunned()");
	LoopAnimPivot('Shocked');
}


// ----------------------------------------------------------------------
// TweenToSwimming()
// ----------------------------------------------------------------------

function TweenToSwimming(float tweentime)
{
//	ClientMessage("TweenToSwimming()");
	TweenAnimPivot('Tread', tweentime, GetSwimPivot());
}


// ----------------------------------------------------------------------
// PlaySwimming()
// ----------------------------------------------------------------------

function PlaySwimming()
{
//	ClientMessage("PlaySwimming()");
	LoopAnimPivot('Tread', , , , GetSwimPivot());
}


// ----------------------------------------------------------------------
// PlayFalling()
// ----------------------------------------------------------------------

function PlayFalling()
{
//	ClientMessage("PlayFalling()");
	PlayAnimPivot('Jump', 3, 0.1);
}


// ----------------------------------------------------------------------
// PlayLanded()
// ----------------------------------------------------------------------

function PlayLanded(float impactVel)
{
//	ClientMessage("PlayLanded()");
	bIsWalking = True;
	if (impactVel < -12*CollisionHeight)
		PlayAnimPivot('Land');
}


// ----------------------------------------------------------------------
// PlayDuck()
// ----------------------------------------------------------------------

function PlayDuck()
{
//	ClientMessage("PlayDuck()");
	TweenAnimPivot('CrouchWalk', 0.25);
//	PlayAnimPivot('Crouch');
}


// ----------------------------------------------------------------------
// PlayRising()
// ----------------------------------------------------------------------

function PlayRising()
{
//	ClientMessage("PlayRising()");
	PlayAnimPivot('Stand');
}


// ----------------------------------------------------------------------
// PlayCrawling()
// ----------------------------------------------------------------------

function PlayCrawling()
{
//	ClientMessage("PlayCrawling()");
	LoopAnimPivot('CrouchWalk');
}


// ----------------------------------------------------------------------
// PlayPushing()
// ----------------------------------------------------------------------

function PlayPushing()
{
//	ClientMessage("PlayPushing()");
	PlayAnimPivot('PushButton',1.2 , 0.15);      //CyberP: added 1.2 rate
}


// ----------------------------------------------------------------------
// PlayBeginAttack()
// ----------------------------------------------------------------------

function bool PlayBeginAttack()
{
	return false;
}


// ----------------------------------------------------------------------
// PlayFiring()
// ----------------------------------------------------------------------

/*
function PlayFiring()
{
	local DeusExWeapon W;

//	ClientMessage("PlayFiring()");

	W = DeusExWeapon(Weapon);

	if (W != None)
	{
		if (W.bHandToHand)
		{
			PlayAnimPivot('Attack',1.1,0.1);
		}
		else
		{
			if (W.bAutomatic)
			{
				if (HasTwoHandedWeapon())
					LoopAnimPivot('Shoot2H',,0.1);
				else
					LoopAnimPivot('Shoot',,0.1);
			}
			else
			{
				if (HasTwoHandedWeapon())
					PlayAnimPivot('Shoot2H',,0.1);
				else
					PlayAnimPivot('Shoot',,0.1);
			}
		}
	}
}
*/


// ----------------------------------------------------------------------
// PlayTakingHit()
// ----------------------------------------------------------------------

function PlayTakingHit(EHitLocation hitPos)
{
	local vector pivot;
	local name   animName;
    local float locMod;

	animName = '';
	if (!Region.Zone.bWaterZone)
	{
		switch (hitPos)
		{
			case HITLOC_HeadFront:
				animName = 'HitHead';
				break;
			case HITLOC_TorsoFront:
				animName = 'HitTorso';
				locMod = 0.1;
				break;
			case HITLOC_LeftArmFront:
				animName = 'HitArmLeft';
				break;
			case HITLOC_RightArmFront:
				animName = 'HitArmRight';
				break;

			case HITLOC_HeadBack:
				animName = 'HitHeadBack';
				break;
			case HITLOC_TorsoBack:
			case HITLOC_LeftArmBack:
			case HITLOC_RightArmBack:
				animName = 'HitTorsoBack';
				break;

			case HITLOC_LeftLegFront:
			case HITLOC_LeftLegBack:
				animName = 'HitLegLeft';
				locMod = -0.2;
				break;

			case HITLOC_RightLegFront:
			case HITLOC_RightLegBack:
				animName = 'HitLegRight';
				locMod = -0.2;
                break;
		}
		pivot = vect(0,0,0);
	}
	else
	{
		switch (hitPos)
		{
			case HITLOC_HeadFront:
			case HITLOC_TorsoFront:
			case HITLOC_LeftLegFront:
			case HITLOC_RightLegFront:
			case HITLOC_LeftArmFront:
			case HITLOC_RightArmFront:
				animName = 'WaterHitTorso';
				break;

			case HITLOC_HeadBack:
			case HITLOC_TorsoBack:
			case HITLOC_LeftLegBack:
			case HITLOC_RightLegBack:
			case HITLOC_LeftArmBack:
			case HITLOC_RightArmBack:
				animName = 'WaterHitTorsoBack';
				break;
		}
		pivot = GetSwimPivot();
	}

	if (animName != '')
		PlayAnimPivot(animName,0.9+locMod, 0.1, pivot); //CyberP: 0.9 added
}


// ----------------------------------------------------------------------
// PlayWeaponSwitch()
// ----------------------------------------------------------------------

function PlayWeaponSwitch(Weapon newWeapon)
{
//	ClientMessage("PlayWeaponSwitch()");
}


// ----------------------------------------------------------------------
// PlayDying()
// ----------------------------------------------------------------------

function PlayDying(name damageType, vector hitLoc)
{
	local Vector X, Y, Z;
	local float dotp;
	local float multa;

//	ClientMessage("PlayDying()");
    if (bFlyer && Physics == PHYS_Flying)
       multa= 1.45;
    else
       multa= 1;

	if (Region.Zone.bWaterZone)
		PlayAnimPivot('WaterDeath',, 0.1);
	else if (bSitting)  // if sitting, always fall forward
		PlayAnimPivot('DeathFront',1.1, 0.1);  //CyberP:
	else if (AnimSequence == 'PushButton' )
	    PlayAnimPivot('DeathBack',1.05*multa, 0.1);
	else
	{
		GetAxes(Rotation, X, Y, Z);
		dotp = (Location - HitLoc) dot X;

		// die from the correct side
		if (dotp < 0.0)		// shot from the front, fall back
			PlayAnimPivot('DeathBack',1.05*multa, 0.1);   //cyberP: sped up death back
		else				// shot from the back, fall front
			PlayAnimPivot('DeathFront',1.05*multa, 0.1);  //CyberP: sped up death front
	}

	// don't scream if we are stunned
	if ((damageType == 'Stunned') || (damageType == 'KnockedOut') ||
	    (damageType == 'Poison') || (damageType == 'PoisonEffect'))
	{
		bStunned = True;
		if (bIsFemale)  //CyberP: lets add a bit of variety to K.O sounds.
		{
		    if (FRand() < 0.5)
			PlaySound(Sound'FemaleUnconscious', SLOT_Pain,,,, RandomPitch());
			else
			{
			}
		}
		else if (IsA('MJ12Commando'))
		    PlaySound(Sound'CloakDown', SLOT_Pain,,,, RandomPitch());
		else if ((IsA('HKMilitary') || IsA('TriadLumPath')) && (FRand() < 0.7))
            PlaySound(Sound'Death07', SLOT_Pain);
        else if (FRand() < 0.25)
			PlaySound(Sound'Death09', SLOT_Pain);
		else if (FRand() < 0.4)
			{
            }
		else
            PlaySound(Sound'MaleUnconscious', SLOT_Pain,,,, RandomPitch());
	}
	else
	{
		bStunned = False;
		if (DamageType != 'Exploded') //|| (DamageType == 'Burned' && !bOnFire))
            PlayDyingSound();
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// FIRE ROUTINES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// CatchFire()
// ----------------------------------------------------------------------

//ok, this is going to be completely replaced with a system devised by smoke39, who also
//discovered the renderoverlays trick. Which is nice. -DDL

function CatchFire()
{
	local Fire f;
	local int i;
	local vector loc;

	if (bOnFire || Region.Zone.bWaterZone || (BurnPeriod <= 0) || bInvincible)
		return;

	bOnFire = True;
	burnTimer = 0;

	EnableCloak(false);

//	for (i=0; i<8; i++)
//	{
//		loc.X = 0.5*CollisionRadius * (1.0-2.0*FRand());
//		loc.Y = 0.5*CollisionRadius * (1.0-2.0*FRand());
//		loc.Z = 0.6*CollisionHeight * (1.0-2.0*FRand());
//		loc += Location;
//		f = Spawn(class'Fire', Self,, loc);
//		if (f != None)
//		{
//			f.DrawScale = 0.5*FRand() + 1.0;
//
//			// turn off the sound and lights for all but the first one
//			if (i > 0)
//			{
//				f.AmbientSound = None;
//				f.LightType = LT_None;
//			}
//
//			// turn on/off extra fire and smoke
//			if (FRand() < 0.5)
//				f.smokeGen.Destroy();
//			if (FRand() < 0.5)
//				f.AddFire();
//		}
//	}
	//smoke39's system
	Spawn(class'FireMesh', self);
	// set the burn timer
	SetTimer(1.0, True);
}

// ----------------------------------------------------------------------
// ExtinguishFire()
// ----------------------------------------------------------------------

function ExtinguishFire()
{
	local FireMesh f;

	bOnFire = False;
	burnTimer = 0;
	SetTimer(0, False);

//	foreach BasedActors(class'Fire', f)
//		f.Destroy();
	foreach BasedActors(class'FireMesh', f)
	{
		// Smoke39 - don't destroy it, just make it smoke
	//	f.Destroy();
		if(Health <= 0)
			f.bDying = true;
		f.Smoke();
	}
}

// ----------------------------------------------------------------------
// UpdateFire()
// ----------------------------------------------------------------------

function UpdateFire()
{
	// continually burn and do damage
	HealthTorso -= 5 + (HealthTorso * 0.1);
	if (IsA('MIB'))
	   HealthTorso -= 20;
	GenerateTotalHealth();
	if (Health <= 0)
	{
		TakeDamage(20, None, Location, vect(0,0,0), 'Burned');
		ExtinguishFire();
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// CONVERSATION FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// CanConverse()
// ----------------------------------------------------------------------

function bool CanConverse()
{
	// Return True if this NPC is in a conversable state
	return (bCanConverse && bInterruptState && ((Physics == PHYS_Walking) || (Physics == PHYS_Flying)));
}


// ----------------------------------------------------------------------
// CanConverseWithPlayer()
// ----------------------------------------------------------------------

function bool CanConverseWithPlayer(DeusExPlayer dxPlayer)
{
	local name alliance1, alliance2, carcname;  // temp vars

	if (GetPawnAllianceType(dxPlayer) == ALLIANCE_Hostile)
		return false;
	else if ((GetStateName() == 'Fleeing') && (Enemy != dxPlayer) && (IsValidEnemy(Enemy, false)))  // hack
		return false;
	else if (GetCarcassData(dxPlayer, alliance1, alliance2, carcname))
		return false;
	else
		return true;
}


// ----------------------------------------------------------------------
// EndConversation()
// ----------------------------------------------------------------------

function EndConversation()
{
	Super.EndConversation();

	if ((GetStateName() == 'Conversation') || (GetStateName() == 'FirstPersonConversation'))
	{
		bConversationEndedNormally = True;

		if (!bConvEndState)
			FollowOrders();
	}

	bInConversation = False;
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// STIMULI AND AGITATION ROUTINES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// LoudNoiseScore()
// ----------------------------------------------------------------------

function float LoudNoiseScore(actor receiver, actor sender, float score)
{
	local Pawn pawnSender;

	// Cull events received from friends
	pawnSender = Pawn(sender);
	if (pawnSender == None)
		pawnSender = sender.Instigator;
	if (pawnSender == None)
		score = 0;
	else if (!IsValidEnemy(pawnSender))
		score = 0;

	return score;
}


// ----------------------------------------------------------------------
// WeaponDrawnScore()
// ----------------------------------------------------------------------

function float WeaponDrawnScore(actor receiver, actor sender, float score)
{
	local Pawn pawnSender;

	// Cull events received from enemies
	pawnSender = Pawn(sender);
	if (pawnSender == None)
		pawnSender = Pawn(sender.Owner);
	if (pawnSender == None)
		pawnSender = sender.Instigator;
	if (pawnSender == None)
		score = 0;
	else if (IsValidEnemy(pawnSender))
		score = 0;

	return score;
}


// ----------------------------------------------------------------------
// DistressScore()
// ----------------------------------------------------------------------

function float DistressScore(actor receiver, actor sender, float score)
{
	local ScriptedPawn scriptedSender;
	local Pawn         pawnSender;

	// Cull events received from enemies
	sender         = InstigatorToPawn(sender);  // hack
	pawnSender     = Pawn(sender);
	scriptedSender = ScriptedPawn(sender);
	if (pawnSender == None)
		score = 0;
	else if ((GetPawnAllianceType(pawnSender) != ALLIANCE_Friendly) && !bFearDistress)
		score = 0;
	else if ((scriptedSender != None) && !scriptedSender.bDistressed)
		score = 0;

	return score;
}


// ----------------------------------------------------------------------
// UpdateReactionCallbacks()
// ----------------------------------------------------------------------

function UpdateReactionCallbacks()
{
	if (bReactFutz && bLookingForFutz)
		AISetEventCallback('Futz', 'HandleFutz', , true, true, false, true);
	else
		AIClearEventCallback('Futz');

	if ((bHateHacking || bFearHacking) && bLookingForHacking)
		AISetEventCallback('MegaFutz', 'HandleHacking', , true, true, true, true);
	else
		AIClearEventCallback('MegaFutz');

	if ((bHateWeapon || bFearWeapon) && bLookingForWeapon)
		AISetEventCallback('WeaponDrawn', 'HandleWeapon', 'WeaponDrawnScore', true, true, false, true);
	else
		AIClearEventCallback('WeaponDrawn');

	if ((bReactShot || bFearShot || bHateShot) && bLookingForShot)
		AISetEventCallback('WeaponFire', 'HandleShot', , true, true, false, true);
	else
		AIClearEventCallback('WeaponFire');

/*
	if ((bHateCarcass || bReactCarcass || bFearCarcass) && bLookingForCarcass)
		AISetEventCallback('Carcass', 'HandleCarcass', 'CarcassScore', true, true, false, true);
	else
		AIClearEventCallback('Carcass');
*/

	if (bReactLoudNoise && bLookingForLoudNoise)
	{
		AISetEventCallback('LoudNoise', 'HandleLoudNoise', 'LoudNoiseScore');
		//GMDX: more generic noise, like whats that a rock!
		//AISetEventCallback('GenericNoise', 'HandleGenericNoise');
	}
	else
	{
		AIClearEventCallback('LoudNoise');
		//AIClearEventCallback('GenericNoise');
	}
	if ((bReactAlarm || bFearAlarm) && bLookingForAlarm)
		AISetEventCallback('Alarm', 'HandleAlarm');
	else
		AIClearEventCallback('Alarm');

	if ((bHateDistress || bReactDistress || bFearDistress) && bLookingForDistress)
		AISetEventCallback('Distress', 'HandleDistress', 'DistressScore', true, true, false, true);
	else
		AIClearEventCallback('Distress');

	if ((bFearProjectiles || bReactProjectiles) && bLookingForProjectiles)
		AISetEventCallback('Projectile', 'HandleProjectiles', , false, true, false, true);
	else
		AIClearEventCallback('Projectile');
}


// ----------------------------------------------------------------------
// SetReactions()
// ----------------------------------------------------------------------

function SetReactions(bool bEnemy, bool bLoudNoise, bool bAlarm, bool bDistress,
					  bool bProjectile, bool bFutz, bool bHacking, bool bShot, bool bWeapon, bool bCarcass,
					  bool bInjury, bool bIndirectInjury)
{
	bLookingForEnemy          = bEnemy;
	bLookingForLoudNoise      = bLoudNoise;
	bLookingForAlarm          = bAlarm;
	bLookingForDistress       = bDistress;
	bLookingForProjectiles    = bProjectile;
	bLookingForFutz           = bFutz;
	bLookingForHacking        = bHacking;
	bLookingForShot           = bShot;
	bLookingForWeapon         = bWeapon;
	bLookingForCarcass        = bCarcass;
	bLookingForInjury         = bInjury;
	bLookingForIndirectInjury = bIndirectInjury;

	UpdateReactionCallbacks();

}


// ----------------------------------------------------------------------
// BlockReactions()
// ----------------------------------------------------------------------

function BlockReactions(optional bool bBlockInjury)
{
	SetReactions(false, false, false, false, false, false, false, false, false, false, !bBlockInjury, !bBlockInjury);
}


// ----------------------------------------------------------------------
// ResetReactions()
// ----------------------------------------------------------------------

function ResetReactions()
{
	SetReactions(true, true, true, true, true, true, true, true, true, true, true, true);
}


// ----------------------------------------------------------------------
// HandleFutz()
// ----------------------------------------------------------------------

function HandleFutz(Name event, EAIEventState state, XAIParams params)
{
local Pawn pawnActor;
local DeusExPlayer dxPlayer;
local AdaptiveArmor armor;

    if (bLookingForFutz && bReactFutz)
    {
	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
	pawnActor = GetPlayerPawn();
	dxPlayer = DeusExPlayer(GetPlayerPawn());

	if (pawnActor != None && dxPlayer != none && dxPlayer.AugmentationSystem.GetAugLevelValue(class'AugCloak') <= -1.0)
	{
	   foreach AllActors(class'AdaptiveArmor', armor) //CyberP: thermoptic camo hides us from detection
						if ((armor.Owner == dxPlayer) && armor.bActive)
                        	    return;

       ReactToFutz();  // only players can futz
     /*if (dxplayer.bHardcoreAI3 && FRand() < 0.4)
     {
       if (!IsA('ThugMale') && !IsA('NicoletteDuClare') && (IsA('HumanThug') || IsA('HumanMilitary')))
       {
       IncreaseAgitation(pawnActor, 1.0);
       if (SetEnemy(pawnActor))
	   {
				SetDistressTimer();
				HandleEnemy();
	   }
	   }
	 }*/
	}
	}
	}
}


// ----------------------------------------------------------------------
// HandleHacking()
// ----------------------------------------------------------------------

function HandleHacking(Name event, EAIEventState state, XAIParams params)
{
	// Fear, Hate

	local Pawn pawnActor;
    local DeusExPlayer dxPlayer;
    local AdaptiveArmor armor;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		pawnActor = GetPlayerPawn();
		dxPlayer = DeusExPlayer(GetPlayerPawn());
		if (pawnActor != None && dxPlayer != none && dxPlayer.AugmentationSystem.GetAugLevelValue(class'AugCloak') <= -1.0)
		{
		    foreach AllActors(class'AdaptiveArmor', armor) //CyberP: thermoptic camo hides us
						if ((armor.Owner == dxPlayer) && armor.bActive)
                        	    return;
			if (bHateHacking)
				IncreaseAgitation(pawnActor, 1.0);
			if (bFearHacking)
				IncreaseFear(pawnActor, 0.51);
			if (SetEnemy(pawnActor))
			{
				SetDistressTimer();
				HandleEnemy();
			}
			else if (bFearHacking && IsFearful())
			{
				SetDistressTimer();
				SetEnemy(pawnActor, , true);
				GotoState('Fleeing');
			}
			else  // only players can hack
				ReactToFutz();
		}
	}
}


// ----------------------------------------------------------------------
// HandleWeapon()
// ----------------------------------------------------------------------

function HandleWeapon(Name event, EAIEventState state, XAIParams params)
{
	// Fear, Hate

	local Pawn pawnActor;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		pawnActor = InstigatorToPawn(params.bestActor);
		if (pawnActor != None)
		{
			if (bHateWeapon)
				IncreaseAgitation(pawnActor);
			if (bFearWeapon)
				IncreaseFear(pawnActor, 1.0);

			// Let presence checking handle enemy sighting

			if (!IsValidEnemy(pawnActor))
			{
				if (bFearWeapon && IsFearful())
				{
					SetDistressTimer();
					SetEnemy(pawnActor, , true);
					GotoState('Fleeing');
				}
				else if (pawnActor.bIsPlayer)
					ReactToFutz();
			}
		}
	}
}


// ----------------------------------------------------------------------
// HandleShot()
// ----------------------------------------------------------------------

function HandleShot(Name event, EAIEventState state, XAIParams params)
{
	// React, Fear, Hate

	local Pawn pawnActor;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		pawnActor = InstigatorToPawn(params.bestActor);
		if (pawnActor != None)
		{
			if (bHateShot)
				IncreaseAgitation(pawnActor);
			if (bFearShot)
				IncreaseFear(pawnActor, 1.0);
            if (SetEnemy(pawnActor))
			{
				SetDistressTimer();
				HandleEnemy();
			}
			else if (bFearShot && IsFearful())
			{
				SetDistressTimer();
				SetEnemy(pawnActor, , true);
				GotoState('Fleeing');
			}
			else if (pawnActor.bIsPlayer)
				ReactToFutz();
		}
	}
}


// ----------------------------------------------------------------------
// HandleLoudNoise()
// ----------------------------------------------------------------------

function HandleLoudNoise(Name event, EAIEventState state, XAIParams params)
{
	// React

	local Actor bestActor;
	local Pawn  instigator;


	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		bestActor = params.bestActor;
		if (bestActor != None)
		{
			instigator = Pawn(bestActor);
			if (instigator == None)
				instigator = bestActor.Instigator;
			if (instigator != None)
			{
				if (IsValidEnemy(instigator))
				{
					SetSeekLocation(instigator, bestActor.Location, SEEKTYPE_Sound);
					HandleEnemy();
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// GMDX: HandleGenericNoise()
// ----------------------------------------------------------------------

function HandleGenericNoise(Name event, EAIEventState state, XAIParams params)
{
	// React

	local Actor bestActor;
	local Pawn  instigator;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		bestActor = params.bestActor;
		if (bestActor != None)
		{
			instigator = Pawn(bestActor);
			if (instigator == None)
				instigator = bestActor.Instigator;
			if (instigator != None)
			{
//				if (IsValidEnemy(instigator))
//				{
					SetSeekLocation(instigator, bestActor.Location, SEEKTYPE_Sound);
					if (Enemy == None)
			         GotoState('Seeking','GoToLocation');
		             else if (RaiseAlarm == RAISEALARM_BeforeAttacking)
			            GotoState('Alerting');
//                        else
//			                  GotoState('Attacking');
//				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// HandleProjectiles()
// ----------------------------------------------------------------------

function HandleProjectiles(Name event, EAIEventState state, XAIParams params)
{
	// React, Fear

	local DeusExProjectile dxProjectile;


	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
		if (params.bestActor != None)
			ReactToProjectiles(params.bestActor);
}


// ----------------------------------------------------------------------
// HandleAlarm()
// ----------------------------------------------------------------------

function HandleAlarm(Name event, EAIEventState state, XAIParams params)
{
	// React, Fear

	local AlarmUnit      alarm;
	local LaserTrigger   laser;
	local SecurityCamera camera;
	local Computers      computer;
	local Pawn           alarmInstigator;
	local vector         alarmLocation;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		alarmInstigator = None;
		alarm    = AlarmUnit(params.bestActor);
		laser    = LaserTrigger(params.bestActor);
		camera   = SecurityCamera(params.bestActor);
		computer = Computers(params.bestActor);
		if (alarm != None)
		{
			alarmInstigator = alarm.alarmInstigator;
			alarmLocation   = alarm.alarmLocation;
		}
		else if (laser != None)
		{
			alarmInstigator = Pawn(laser.triggerActor);
			if (alarmInstigator == None)
				alarmInstigator = laser.triggerActor.Instigator;
			alarmLocation   = laser.actorLocation;
		}
		else if (camera != None)
		{
			alarmInstigator = GetPlayerPawn();  // player is implicit for cameras
			alarmLocation   = camera.playerLocation;
		}
		else if (computer != None)
		{
			alarmInstigator = GetPlayerPawn();  // player is implicit for computers
			alarmLocation   = computer.Location;
		}

		if (bFearAlarm)
		{
			IncreaseFear(alarmInstigator, 2.0);
			if (IsFearful())
			{
				SetDistressTimer();
				SetEnemy(alarmInstigator, , true);
				GotoState('Fleeing');
			}
		}

		//if (alarmInstigator != None) //CyberP: don't ignore alarms. If there's an alarm, react no matter what
		//{
			//if (alarmInstigator.Health > 0)
			//{
				//if (IsValidEnemy(alarmInstigator))
				//{
				    //BroadcastMessage("Heard Alarm");
				    if (enemy == None && (IsA('HumanMilitary') || IsA('HumanThug') || IsA('Robot')))
				    {
					AlarmTimer = 120;
					SetDistressTimer();
					if ((IsA('HumanMilitary') || IsA('HumanThug')) && !bAlarmStatIncrease)  //CyberP: AI get better stats if alarm is triggered.
					{
					bAlarmStatIncrease=True;
					if (SurprisePeriod > 0.5)
					SurprisePeriod -= 0.100000;
					if (VisibilityThreshold > 0.002000)
                    VisibilityThreshold -= 0.000500;
                    if (walkAnimMult == default.walkAnimMult && FRand() < 0.1)
                    {
                        WalkingSpeed *= 1.15;
                        walkAnimMult *= 1.15;
					}
                    if (BaseAccuracy > 0.010000)
					BaseAccuracy -= 0.010000;  //CyberP: So, the result is improved accuracy, reload speed, cooldown time,
                    }                         //vision & reaction time.
                    if (FRand() < 0.4)
                    {
                        bSeekPostCombat = True;
					    SetSeekLocation(alarmInstigator, alarmLocation, SEEKTYPE_Guess);  //CyberP: different reaction
					}
                    else
					    SetSeekLocation(alarmInstigator, alarmLocation, SEEKTYPE_Sound);
					//if (enemy == None)

                       GoToState('Seeking');
                    //else
                    //   HandleEnemy();
                    }
				//}
			//}
		//}
	}
}


// ----------------------------------------------------------------------
// HandleDistress()
// ----------------------------------------------------------------------

function HandleDistress(Name event, EAIEventState state, XAIParams params)
{
	// React, Fear, Hate

	local float        seeTime;
	local Pawn         distressee;
	local DeusExPlayer distresseePlayer;
	local ScriptedPawn distresseePawn;
	local Pawn         distressor;
	local DeusExPlayer distressorPlayer;
	local ScriptedPawn distressorPawn;
	local bool         bDistresseeValid;
	local bool         bDistressorValid;
	local float        distressVal;
	local name         stateName;
	local bool         bAttacking;
	local bool         bFleeing;

	bAttacking = false;
	seeTime    = 0;

	if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
	{
		distressee = InstigatorToPawn(params.bestActor);
		if (distressee != None)
		{
			if (bFearDistress)
				IncreaseFear(distressee.Enemy, 1.0);
			bDistresseeValid = false;
			bDistressorValid = false;
			distresseePlayer = DeusExPlayer(distressee);
			distresseePawn   = ScriptedPawn(distressee);
			if (GetPawnAllianceType(distressee) == ALLIANCE_Friendly)
			{
				if (distresseePawn != None)
				{
					if (distresseePawn.bDistressed && (distresseePawn.EnemyLastSeen <= EnemyTimeout))
					{
						bDistresseeValid = true;
						seeTime          = distresseePawn.EnemyLastSeen;
					}
				}
				else if (distresseePlayer != None)
					bDistresseeValid = true;
			}
			if (bDistresseeValid)
			{
				distressor       = distressee.Enemy;
				distressorPlayer = DeusExPlayer(distressor);
				distressorPawn   = ScriptedPawn(distressor);
				if (distressorPawn != None)
				{
					if (bHateDistress || (distressorPawn.GetPawnAllianceType(distressee) == ALLIANCE_Hostile))
						bDistressorValid = true;
				}
				else if (distresseePawn != None)
				{
					if (bHateDistress || (distresseePawn.GetPawnAllianceType(distressor) == ALLIANCE_Hostile))
						bDistressorValid = true;
				}

				// Finally, react
				if (bDistressorValid)
				{
					if (bHateDistress)
						IncreaseAgitation(distressor, 1.0);
					if (SetEnemy(distressor, seeTime))
					{
						SetDistressTimer();
						HandleEnemy();
						bAttacking = true;
					}
				}
				// BOOGER! Make NPCs react by seeking if distressor isn't an enemy?
			}

			if (!bAttacking && bFearDistress)
			{
				distressVal = 0;
				bFleeing    = false;
				if (distresseePawn != None)
				{
					stateName = distresseePawn.GetStateName();
					if (stateName == 'Fleeing')  // hack -- to prevent infinite fleeing
					{
						if (distresseePawn.DistressTimer >= 0)
						{
							if (FearSustainTime - distresseePawn.DistressTimer >= 1)
							{
								IncreaseFear(distressee.Enemy, 1.0, distresseePawn.DistressTimer);
								distressVal = distresseePawn.DistressTimer;
								bFleeing    = true;
							}
						}
					}
					else
					{
						IncreaseFear(distressee.Enemy, 1.0);
						bFleeing = true;
					}
				}
				else
				{
					IncreaseFear(distressee.Enemy, 1.0);
					bFleeing = true;
				}
				if (bFleeing && IsFearful())
				{
					if ((DistressTimer > distressVal) || (DistressTimer < 0))
						DistressTimer = distressVal;
					SetEnemy(distressee.Enemy, , true);
					GotoState('Fleeing');
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// IncreaseFear()
// ----------------------------------------------------------------------

function IncreaseFear(Actor actorInstigator, float addedFearLevel,
					  optional float newFearTimer)
{
	local DeusExPlayer player;
	local Pawn         instigator;

	instigator = InstigatorToPawn(actorInstigator);
	if (instigator != None)
	{
		if (FearTimer < (FearSustainTime-newFearTimer))
			FearTimer = FearSustainTime-newFearTimer;
		if (FearTimer > 0)
		{
			if (addedFearLevel > 0)
			{
				FearLevel += addedFearLevel;
				if (FearLevel > 1.0)
					FearLevel = 1.0;
			}
		}
	}
}


// ----------------------------------------------------------------------
// IncreaseAgitation()
// ----------------------------------------------------------------------

function IncreaseAgitation(Actor actorInstigator, optional float AgitationLevel)
{
	local Pawn  instigator;
	local float minLevel;

	instigator = InstigatorToPawn(actorInstigator);
	if (instigator != None)
	{
		AgitationTimer = AgitationSustainTime;
		if (AgitationCheckTimer <= 0)
		{
			AgitationCheckTimer = 1.5;  // hardcoded for now
			if (AgitationLevel == 0)
			{
				if (MaxProvocations < 0)
					MaxProvocations = 0;
				AgitationLevel = 1.0/(MaxProvocations+1);
			}
			if (AgitationLevel > 0)
			{
				bAlliancesChanged    = True;
				bNoNegativeAlliances = False;
				AgitateAlliance(instigator.Alliance, AgitationLevel);
			}
		}
	}

}


// ----------------------------------------------------------------------
// DecreaseAgitation()
// ----------------------------------------------------------------------

function DecreaseAgitation(Actor actorInstigator, float AgitationLevel)
{
	local float        newLevel;
	local DeusExPlayer player;
	local Pawn         instigator;

	player = DeusExPlayer(GetPlayerPawn());

	if (Inventory(actorInstigator) != None)
	{
		if (Inventory(actorInstigator).Owner != None)
			actorInstigator = Inventory(actorInstigator).Owner;
	}
	else if (DeusExDecoration(actorInstigator) != None)
		actorInstigator = player;

	instigator = Pawn(actorInstigator);
	if ((instigator == None) || (instigator == self))
		return;

	AgitationTimer  = AgitationSustainTime;
	if (AgitationLevel > 0)
	{
		bAlliancesChanged    = True;
		bNoNegativeAlliances = False;
		AgitateAlliance(instigator.Alliance, -AgitationLevel);
	}

}


// ----------------------------------------------------------------------
// UpdateAgitation()
// ----------------------------------------------------------------------

function UpdateAgitation(float deltaSeconds)
{
	local float mult;
	local float decrement;
	local int   i;

	if (AgitationCheckTimer > 0)
	{
		AgitationCheckTimer -= deltaSeconds;
		if (AgitationCheckTimer < 0)
			AgitationCheckTimer = 0;
	}

	decrement = 0;
	if (AgitationTimer > 0)
	{
		if (AgitationTimer < deltaSeconds)
		{
			mult = 1.0 - (AgitationTimer/deltaSeconds);
			AgitationTimer = 0;
			decrement = mult * (AgitationDecayRate*deltaSeconds);
		}
		else
			AgitationTimer -= deltaSeconds;
	}
	else
		decrement = AgitationDecayRate*deltaSeconds;

	if (bAlliancesChanged && (decrement > 0))
	{
		bAlliancesChanged = False;
		for (i=15; i>=0; i--)
		{
			if ((AlliancesEx[i].AllianceName != '') && (!AlliancesEx[i].bPermanent))
			{
				if (AlliancesEx[i].AgitationLevel > 0)
				{
					bAlliancesChanged = true;
					AlliancesEx[i].AgitationLevel -= decrement;
					if (AlliancesEx[i].AgitationLevel < 0)
						AlliancesEx[i].AgitationLevel = 0;
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// UpdateFear()
// ----------------------------------------------------------------------

function UpdateFear(float deltaSeconds)
{
	local float mult;
	local float decrement;
	local int   i;

	decrement = 0;
	if (FearTimer > 0)
	{
		if (FearTimer < deltaSeconds)
		{
			mult = 1.0 - (FearTimer/deltaSeconds);
			FearTimer = 0;
			decrement = mult * (FearDecayRate*deltaSeconds);
		}
		else
			FearTimer -= deltaSeconds;
	}
	else
		decrement = FearDecayRate*deltaSeconds;

	if ((decrement > 0) && (FearLevel > 0))
	{
		FearLevel -= decrement;
		if (FearLevel < 0)
			FearLevel = 0;
	}
}


// ----------------------------------------------------------------------
// IsFearful()
// ----------------------------------------------------------------------

function bool IsFearful()
{
	if (FearLevel >= 1.0)
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// ShouldBeStartled()  [stub function, overridden by subclasses]
// ----------------------------------------------------------------------

function bool ShouldBeStartled(Pawn startler)
{
	return false;
}


// ----------------------------------------------------------------------
// ShouldPlayTurn()
// ----------------------------------------------------------------------

function bool ShouldPlayTurn(vector lookdir)
{
	local Rotator rot;

	rot = Rotator(lookdir);
	rot.Yaw = (rot.Yaw - Rotation.Yaw) & 65535;
	if (rot.Yaw > 32767)
		rot.Yaw = 65536 - rot.Yaw;  // negate
	if (rot.Yaw > 4096)
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// ShouldPlayWalk()
// ----------------------------------------------------------------------

function bool ShouldPlayWalk(vector movedir)
{
	local vector diff;

	if (Physics == PHYS_Falling)
		return true;
	else if (Physics == PHYS_Walking)
	{
		diff = (movedir - Location) * vect(1,1,0);
		if (VSize(diff) < 4)  //CyberP: was 16
			return false;
		else
			return true;
	}
	else if (VSize(movedir-Location) < 4)  //CyberP: was 16
		return false;
	else
		return true;
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ALLIANCE ROUTINES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// SetAlliance()
// ----------------------------------------------------------------------

function SetAlliance(Name newAlliance)
{
	Alliance = newAlliance;
}


// ----------------------------------------------------------------------
// ChangeAlly()
// ----------------------------------------------------------------------

function ChangeAlly(Name newAlly, optional float allyLevel, optional bool bPermanent, optional bool bHonorPermanence)
{
	local int i;

	// Members of the same alliance will ALWAYS be friendly to each other
	if (newAlly == Alliance)
	{
		allyLevel  = 1;
		bPermanent = true;
	}

	if (bHonorPermanence)
	{
		for (i=0; i<16; i++)
			if (AlliancesEx[i].AllianceName == newAlly)
				if (AlliancesEx[i].bPermanent)
					break;
		if (i < 16)
			return;
	}

	if (allyLevel < -1)
		allyLevel = -1;
	if (allyLevel > 1)
		allyLevel = 1;

	for (i=0; i<16; i++)
		if ((AlliancesEx[i].AllianceName == newAlly) || (AlliancesEx[i].AllianceName == ''))
			break;

	if (i >= 16)
		for (i=15; i>0; i--)
			AlliancesEx[i] = AlliancesEx[i-1];

	AlliancesEx[i].AllianceName         = newAlly;
	AlliancesEx[i].AllianceLevel        = allyLevel;
	AlliancesEx[i].AgitationLevel       = 0;
	AlliancesEx[i].bPermanent           = bPermanent;

	bAlliancesChanged    = True;
	bNoNegativeAlliances = False;
}


// ----------------------------------------------------------------------
// AgitateAlliance()
// ----------------------------------------------------------------------

function AgitateAlliance(Name newEnemy, float agitation)
{
	local int   i;
	local float oldLevel;
	local float newLevel;

	if (newEnemy != '')
	{
		for (i=0; i<16; i++)
			if ((AlliancesEx[i].AllianceName == newEnemy) || (AlliancesEx[i].AllianceName == ''))
				break;

		if (i < 16)
		{
			if ((AlliancesEx[i].AllianceName == '') || !(AlliancesEx[i].bPermanent))
			{
				if (AlliancesEx[i].AllianceName == '')
					AlliancesEx[i].AllianceLevel = 0;
				oldLevel = AlliancesEx[i].AgitationLevel;
				newLevel = oldLevel + agitation;
				if (newLevel > 1.0)
					newLevel = 1.0;
				AlliancesEx[i].AllianceName   = newEnemy;
				AlliancesEx[i].AgitationLevel = newLevel;
				if ((newEnemy == 'Player') && (oldLevel < 1.0) && (newLevel >= 1.0))  // hack
					PlayerAgitationTimer = 2.0;
				bAlliancesChanged = True;
			}
		}
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ATTACKING FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// AISafeToShoot()
// ----------------------------------------------------------------------

function bool AISafeToShoot(out Actor hitActor, vector traceEnd, vector traceStart,
							optional vector extent, optional bool bIgnoreLevel)
{
	local Actor            traceActor;
	local Vector           hitLocation;
	local Vector           hitNormal;
	local Pawn             tracePawn;
	local DeusExDecoration traceDecoration;
	local DeusExMover      traceMover;
	local bool             bSafe;
    local float            dista, dista2;
	// Future improvement:
	// Ideally, this should use the ammo type to determine how many shots
	// it will take to destroy an obstruction, and call it unsafe if it takes
	// more than x shots.  Also, if the ammo is explosive, and the
	// obstruction is too close, it should never be safe...

	bSafe    = true;
	hitActor = None;

	foreach TraceActors(Class'Actor', traceActor, hitLocation, hitNormal,
	                    traceEnd, traceStart, extent)
	{
		if (hitActor == None)
			hitActor = traceActor;
		if (traceActor == Level)
		{
		    if (sFire > 0)  //CyberP: supressive fire
		    {
		        //dista = Abs(VSize(enemy.Location - Location));
		        //dista2 = Abs(VSize(enemy.Location - hitLocation));
		        dista2 = Abs(VSize(hitLocation - Location));
		        if (dista2 < 224)
		        {
		            sFire = 0;
		            return false;
                }
                else
                    return true;
            }
            else if (Extent != vect(0,0,0))  //CyberP: 5% chance to switch weapon if using projectile wep that trace-hit a wall
            {
                if (FRand() < 0.05)
                    SwitchToBestWeapon();
            }

			if (!bIgnoreLevel)
				bSafe = false;
			break;
		}
		tracePawn = Pawn(traceActor);
		if (tracePawn != None)
		{
			if (tracePawn != self)
			{
				if (GetPawnAllianceType(tracePawn) == ALLIANCE_Friendly)
				{
                    if (tracePawn.IsInState('Dying') && tracePawn.IsA('ScriptedPawn') && ScriptedPawn(tracePawn).DeathTimer2 <= 0)
                        bSafe = True;  //CyberP: ignore dying allies a few feet away or more
                    else
					    bSafe = false;
				}
                break;
			}
		}
		traceDecoration = DeusExDecoration(traceActor);
		if (traceDecoration != None)
		{
		    if (sFire > 0)  //CyberP: supressive fire
		    {
		        //dista = Abs(VSize(enemy.Location - Location));
		        //dista2 = Abs(VSize(enemy.Location - hitLocation));
		        dista2 = Abs(VSize(hitLocation - Location));
		        if (dista2 < 224)
		        {
		            sFire = 0;
		            return false;
                }
                else
                    return true;
            }
			if (traceDecoration.bExplosive)
			{
			    dista2 = Abs(VSize(hitLocation - Location));  //CyberP: shoot explosives, if they are reasonably far away
		        if (dista2 > 224)
		            return true;
                bSafe = false;
				break;
			}
			else if (weapon != None && traceDecoration.IsA('CrateUnbreakableMed'))
			{
			    if (FRand() < 0.2 && EnemyLastSeen < 4.0) //CyberP: shoot if you can see enemy but the trace is failing to connect, even if you can't break the object
			    {                                         //Restrict to CrateUnbreakableMed, the object most commonly causing problems
			    dista2 = Abs(VSize(enemy.Location - Location));
		        if (dista2 < 512 && enemy != None && AICanSee(enemy, ComputeActorVisibility(enemy), false, true, true, true) > 0)
		            return true;
				}
				bSafe = false;
				break;
			}
		}
		traceMover = DeusExMover(traceActor);
		if (traceMover != None)
		{
			if (!traceMover.bBreakable)
			{
				bSafe = false;
				break;
			}
			else if (traceMover.minDamageThreshold < 4)  // hack  //CyberP: get them to shoot through breakable glass
			{
				return true;
				//break;
			}
			else  // hack
			{
			    bSafe = False;
				break;
			}
		}
		//if (Inventory(traceActor) != None) //CyberP: cut this out since inventory is breakable or moves when shot
		//{
		//	bSafe = false;
		//	break;
		//}
	}

	return (bSafe);
}

function bool AISafeToShootMovers(out Actor hitActor, vector traceEnd, vector traceStart,
							optional vector extent, optional bool bIgnoreLevel)
{
	local Actor            traceActor;
	local Vector           hitLocation;
	local Vector           hitNormal;
	local DeusExMover      traceMover;
	local bool             bSafe;

	// Future improvement:
	// Ideally, this should use the ammo type to determine how many shots
	// it will take to destroy an obstruction, and call it unsafe if it takes
	// more than x shots.  Also, if the ammo is explosive, and the
	// obstruction is too close, it should never be safe...

	bSafe    = false;
	hitActor = None;

	foreach TraceActors(Class'Actor', traceActor, hitLocation, hitNormal,
	                    traceEnd, traceStart, extent)
	{
		if (hitActor == None)
			hitActor = traceActor;

		traceMover = DeusExMover(traceActor);
		if (traceMover != None)
		{
			if (!traceMover.bBreakable)
			{
				bSafe = false;
				break;
			}
			else if (traceMover.minDamageThreshold < 4)  // hack  //CyberP: get them to shoot through breakable glass
			{
				return true;
				//break;
			}
			else  // hack
			{
			    bSafe = False;
				break;
			}
		}
	}
	return (bSafe);
}


// ----------------------------------------------------------------------
// ComputeThrowAngles()
// ----------------------------------------------------------------------

function bool ComputeThrowAngles(vector traceEnd, vector traceStart,
								 float speed,
								 out Rotator angle1, out Rotator angle2)
{
	local float   deltaX, deltaY;
	local float   x, y;
	local float   tanAngle1, tanAngle2;
	local float   A, B, C;
	local float   m, n;
	local float   sqrtTerm;
	local float   gravity;
	local float   traceYaw;
	local bool    bValid;

	bValid = false;

	// Reduce our problem to two dimensions
	deltaX = traceEnd.X - traceStart.X;
	deltaY = traceEnd.Y - traceStart.Y;
	x = sqrt(deltaX*deltaX + deltaY*deltaY);
	y = traceEnd.Z - traceStart.Z;

	gravity = -Region.Zone.ZoneGravity.Z;
	if ((x > 0) && (gravity > 0))
	{
		A = -gravity*x*x;
		B = 2*speed*speed*x;
		C = -gravity*x*x - 2*y*speed*speed;

		sqrtTerm = B*B - 4*A*C;
		if (sqrtTerm >= 0)
		{
			m = -B/(2*A);
			n = sqrt(sqrtTerm)/(2*A);

			tanAngle1 = atan(m+n);
			tanAngle2 = atan(m-n);

			angle1 = Rotator(traceEnd - traceStart);
			angle2 = angle1;
			angle1.Pitch = tanAngle1*32768/Pi;
			angle2.Pitch = tanAngle2*32768/Pi;

			bValid = true;
		}
	}

	return bValid;
}


// ----------------------------------------------------------------------
// AISafeToThrow()
// ----------------------------------------------------------------------

function bool AISafeToThrow(vector traceEnd, vector traceStart,
							float throwAccuracy,
							optional vector extent)
{
	local float                   time1, time2, tempTime;
	local vector                  pos1,  pos2,  tempPos;
	local rotator                 rot1,  rot2,  tempRot;
	local rotator                 bestAngle;
	local bool                    bSafe;
	local DeusExWeapon            dxWeapon;
	local Class<ThrownProjectile> throwClass;

	// Someday, we should check for nearby friendlies within the blast radius
	// before throwing...

	// Sanity checks
	throwClass = None;
	dxWeapon = DeusExWeapon(Weapon);
	if (dxWeapon != None)
		throwClass = Class<ThrownProjectile>(dxWeapon.ProjectileClass);
	if (throwClass == None)
		return false;

	if (extent == vect(0,0,0))
	{
		extent = vect(1,1,0) * throwClass.Default.CollisionRadius;
		extent.Z = throwClass.Default.CollisionHeight;
	}

	if (throwAccuracy < 0.01)
		throwAccuracy = 0.01;

	bSafe = false;
	if (ComputeThrowAngles(traceEnd, traceStart, dxWeapon.ProjectileSpeed, rot1, rot2))
	{
		time1 = ParabolicTrace(pos1, Vector(rot1)*dxWeapon.ProjectileSpeed, traceStart,
		                       true, extent, 5.0,
		                       throwClass.Default.Elasticity, throwClass.Default.bBounce,
		                       60, throwAccuracy);
		time2 = ParabolicTrace(pos2, Vector(rot2)*dxWeapon.ProjectileSpeed, traceStart,
		                       true, extent, 5.0,
		                       throwClass.Default.Elasticity, throwClass.Default.bBounce,
		                       60, throwAccuracy);
		if ((time1 > 0) || (time2 > 0))
		{
			if ((time1 > time2) && (time2 > 0))
			{
				tempTime = time1;
				time1    = time2;
				time2    = tempTime;
				tempPos  = pos1;
				pos1     = pos2;
				pos2     = tempPos;
				tempRot  = rot1;
				rot1     = rot2;
				rot2     = tempRot;
			}
			if (VSize(pos1-traceEnd) <= throwClass.Default.blastRadius)
			{
				if (FastTrace(traceEnd, pos1))
				{
					if ((VSize(pos1-Location) > throwClass.Default.blastRadius*0.5) ||
					    !FastTrace(Location, pos1))
					{
						bestAngle = rot1;
						bSafe     = true;
					}
				}
			}
		}
		if (!bSafe && (time2 > 0))
		{
			if (VSize(pos2-traceEnd) <= throwClass.Default.blastRadius)
			{
				if (FastTrace(traceEnd, pos2))
				{
					if ((VSize(pos2-Location) > throwClass.Default.blastRadius*0.5) ||
					    !FastTrace(Location, pos2))
					{
						bestAngle = rot2;
						bSafe     = true;
					}
				}
			}
		}

	}

	if (bSafe)
		ViewRotation = bestAngle;

	return (bSafe);

}


// ----------------------------------------------------------------------
// AICanShoot()
// ----------------------------------------------------------------------

function bool AICanShoot(pawn target, bool bLeadTarget, bool bCheckReadiness,
						 optional float throwAccuracy, optional bool bDiscountMinRange)
{
	local DeusExWeapon dxWeapon;
	local Vector X, Y, Z;
	local Vector projStart, projEnd;
	local float  tempMinRange, tempMaxRange;
	local float  temp;
	local float  dist;
	local float  extraDist;
	local actor  hitActor;
	local Vector hitLocation, hitNormal;
	local Vector extent;
	local bool   bIsThrown;
	local float  elevation;
	local bool   bSafe;

	if (target == None)
		return false;
	if (target.bIgnore)
		return false;

	dxWeapon = DeusExWeapon(Weapon);
	if (dxWeapon == None)
		return false;
	if (bCheckReadiness && !dxWeapon.bReadyToFire)
		return false;

	if (dxWeapon.ReloadCount > 0)
	{
		if (dxWeapon.AmmoType == None)
			return false;
		if (dxWeapon.AmmoType.AmmoAmount <= 0)
			return false;
	}
	if (FireElevation > 0)
	{
		elevation = FireElevation + (CollisionHeight+target.CollisionHeight);
		if (elevation < 10)
			elevation = 10;
		if (Abs(Location.Z-target.Location.Z) > elevation)
			return false;
	}
	bIsThrown = IsThrownWeapon(dxWeapon);

	extraDist = target.CollisionRadius;
	//extraDist = 0;

	GetPawnWeaponRanges(self, tempMinRange, tempMaxRange, temp);
    //GetPawnWeaponRanges(self, tempMinRange, temp, tempMaxRange);              //RSD: option to have AI fire at max range instead of accurate range

	if (bDiscountMinRange)
		tempMinRange = 0;

	if (tempMinRange >= tempMaxRange)
		return false;

	ViewRotation = Rotation;
	GetAxes(ViewRotation, X, Y, Z);
	projStart = dxWeapon.ComputeProjectileStart(X, Y, Z);
	if (bLeadTarget && !dxWeapon.bInstantHit && (dxWeapon.ProjectileSpeed > 0) && sFire <= 0)
	{
		if (bIsThrown)
		{
			// compute target's position 1.5 seconds in the future
			projEnd = target.Location + (target.Velocity*1.5);
		}
		else
		{
			// projEnd = target.Location + (target.Velocity*dist/dxWeapon.ProjectileSpeed);
			if (!ComputeTargetLead(target, projStart, dxWeapon.ProjectileSpeed,
			                       5.0, projEnd))
				return false;
		}
	}
	else if (sFire > 0)  //CyberP: suppressive fire
	    projEnd = GMDXEnemyLastSeenPos;
	else
		projEnd = target.Location;

	if (bIsThrown)
		projEnd += vect(0,0,-1)*(target.CollisionHeight-5);

	dist = VSize(projEnd - Location);
	if (dist < 0)
		dist = 0;

	if ((dist < tempMinRange) || (dist-extraDist > tempMaxRange))
		return false;

	if (!bIsThrown)
	{
		bSafe = FastTrace(target.Location, projStart);
		if (!bSafe && target.bIsPlayer)  // players only... hack
		{
			projEnd += vect(0,0,1)*target.BaseEyeHeight;
			bSafe = FastTrace(target.Location + vect(0,0,1)*target.BaseEyeHeight, projStart);
		}
		if (!bSafe && sFire == 0)
		{
		    if (FRand() < 0.05) //CyberP: trace 5 out of 100 times exclusively for breakable glass
		    {
		        if (dxWeapon.bInstantHit)
                    return (AISafeToShootMovers(hitActor, projEnd, projStart,, true));
                else
			        return false;
		    }
		    else
			    return false;
		}
	}

	if (dxWeapon.bInstantHit)
		return (AISafeToShoot(hitActor, projEnd, projStart,, true));
	else
	{
		extent.X = dxWeapon.ProjectileClass.default.CollisionRadius;
		extent.Y = dxWeapon.ProjectileClass.default.CollisionRadius;
		extent.Z = dxWeapon.ProjectileClass.default.CollisionHeight;
		if (bIsThrown && (throwAccuracy > 0))
			return (AISafeToThrow(projEnd, projStart, throwAccuracy, extent));
		else if (dxWeapon.IsA('WeaponMiniCrossbow')) // CyberP: lesser trace extent for xbow
        	return (AISafeToShoot(hitActor, projEnd, projStart, extent*1.2));
		else
			return (AISafeToShoot(hitActor, projEnd, projStart, extent*3)); //CyberP: was 3
	}
}


// ----------------------------------------------------------------------
// ComputeTargetLead()
// ----------------------------------------------------------------------

function bool ComputeTargetLead(pawn target, vector projectileStart,
								float projectileSpeed,
								float maxTime,
								out Vector hitPos)
{
	local vector targetLoc;
	local vector targetVel;
	local float  termA, termB, termC;
	local float  temp;
	local float  base, range;
	local float  time1, time2;
	local bool   bSuccess;

	bSuccess = true;

	targetLoc = target.Location - projectileStart;
	targetVel = target.Velocity;
	if (target.Physics == PHYS_Falling)
		targetVel.Z = 0;

	// Given a target position and velocity, and a projectile speed,
	// compute the position at which a projectile will hit the
	// target if the target continues at its current velocity

	// (Warning: messy computations follow.  I can't believe I remembered
	// enough algebra to figure this out on my own... :)

	termA = targetVel.X*targetVel.X +
	        targetVel.Y*targetVel.Y +
	        targetVel.Z*targetVel.Z -
	        projectileSpeed*projectileSpeed;
	termB = 2*targetLoc.X*targetVel.X +
	        2*targetLoc.Y*targetVel.Y +
	        2*targetLoc.Z*targetVel.Z;
	termC = targetLoc.X*targetLoc.X +
	        targetLoc.Y*targetLoc.Y +
	        targetLoc.Z*targetLoc.Z;

	if ((termA < 0.000001) && (termA > -0.000001))  // avoid divide-by-zero errors...
		termA = 0.000001;  // fudge a little when velocities are equal
	temp = termB*termB - 4*termA*termC;
	if (temp < 0)
		bSuccess = false;

	if (bSuccess)
	{
		base = -termB/(2*termA);
		range = sqrt(temp)/(2*termA);
		time1 = base+range;
		time2 = base-range;
		if ((time1 > time2) || (time1 < 0))  // best time first
			time1 = time2;
		if ((time1 < 0) || (time1 >= maxTime))
			bSuccess = false;
	}

	if (bSuccess)
		hitPos = target.Location + target.Velocity*time1;

	return (bSuccess);

}


// ----------------------------------------------------------------------
// GetPawnWeaponRanges()
// ----------------------------------------------------------------------

function GetPawnWeaponRanges(Pawn other, out float minRange,
							 out float maxAccurateRange, out float maxRange)
{
	local DeusExWeapon            pawnWeapon;
	local Class<DeusExProjectile> projectileClass;

	pawnWeapon = DeusExWeapon(other.Weapon);
	if (pawnWeapon != None)
	{
		pawnWeapon.GetWeaponRanges(minRange, maxAccurateRange, maxRange);
		if (IsThrownWeapon(pawnWeapon))  // hack
			minRange = 0;
	}
	else
	{
		minRange         = 0;
		maxAccurateRange = other.CollisionRadius;
		maxRange         = maxAccurateRange;
	}

	if (maxAccurateRange > maxRange)
		maxAccurateRange = maxRange;
	if (minRange > maxRange)
		minRange = maxRange;

}


// ----------------------------------------------------------------------
// GetWeaponBestRange()
// ----------------------------------------------------------------------

function GetWeaponBestRange(DeusExWeapon dxWeapon, out float bestRangeMin,
							out float bestRangeMax)
{
	local float temp;
	local float minRange,   maxRange;
	local float AIMinRange, AIMaxRange;

	if (dxWeapon != None)
	{
		dxWeapon.GetWeaponRanges(minRange, maxRange, temp);
		if (IsThrownWeapon(dxWeapon))  // hack
			minRange = 0;
		AIMinRange = dxWeapon.AIMinRange;
		AIMaxRange = dxWeapon.AIMaxRange;

		if ((AIMinRange > 0) && (AIMinRange >= minRange) && (AIMinRange <= maxRange))
			bestRangeMin = AIMinRange;
		else
			bestRangeMin = minRange;
		if ((AIMaxRange > 0) && (AIMaxRange >= minRange) && (AIMaxRange <= maxRange))
			bestRangeMax = AIMaxRange;
		else
			bestRangeMax = maxRange;

		if (bestRangeMin > bestRangeMax)
			bestRangeMin = bestRangeMax;
	}
	else
	{
		bestRangeMin = 0;
		bestRangeMax = 0;
	}
}


// ----------------------------------------------------------------------
// ReadyForNewEnemy()
// ----------------------------------------------------------------------

function bool ReadyForNewEnemy()
{
	if ((Enemy == None) || (EnemyTimer > 6.0))  //CyberP: was 5.0 - this number is how often we check for a new enemy
		return True;
	else
		return False;
}


// ----------------------------------------------------------------------
// CheckEnemyParams()  [internal use only]
// ----------------------------------------------------------------------

function CheckEnemyParams(Pawn checkPawn,
						  out Pawn bestPawn, out int bestThreatLevel, out float bestDist)
{
	local ScriptedPawn sPawn;
	local bool         bReplace;
	local float        dist;
	local int          threatLevel;
	local bool         bValid;

	bValid = IsValidEnemy(checkPawn);
	if (bValid && (Enemy != checkPawn))
	{
		// Honor cloaking, radar transparency, and other augs if this guy isn't our current enemy
		if (ComputeActorVisibility(checkPawn) < 0.1)
			bValid = false;
	}

	if (bValid)
	{
		sPawn = ScriptedPawn(checkPawn);

		dist = VSize(checkPawn.Location - Location);
		if (checkPawn.IsA('Robot'))
			dist *= 0.5;  // arbitrary
		if (Enemy == checkPawn)
			dist *= 0.75;  // arbitrary

		if (sPawn != None)
		{
			if (sPawn.bAttacking)
			{
				if (sPawn.Enemy == self)
					threatLevel = 2;
				else
					threatLevel = 1;
			}
			else if (sPawn.GetStateName() == 'Alerting')
				threatLevel = 3;
			else if ((sPawn.GetStateName() == 'Fleeing') || (sPawn.GetStateName() == 'Burning'))
				threatLevel = 0;
			else if (sPawn.Weapon != None)
				threatLevel = 1;
			else
				threatLevel = 0;
		}
		else  // player
		{
			if (checkPawn.Weapon != None)
				threatLevel = 2;
			else
				threatLevel = 1;
		}

		bReplace = false;
		if (bestPawn == None)
			bReplace = true;
		else if (bestThreatLevel < threatLevel)
			bReplace = true;
		else if (bestDist > dist)
			bReplace = true;

		if (bReplace)
		{
			if ((Enemy == checkPawn) || (AICanSee(checkPawn, , false, false, true, true) > 0))
			{
				bestPawn        = checkPawn;
				bestThreatLevel = threatLevel;
				bestDist        = dist;
			}
		}
	}

}


// ----------------------------------------------------------------------
// FindBestEnemy()
// ----------------------------------------------------------------------

function FindBestEnemy(bool bIgnoreCurrentEnemy)
{
	local Pawn  nextPawn;
	local Pawn  bestPawn;
	local float bestDist;
	local int   bestThreatLevel;
	local float newSeenTime;

	bestPawn        = None;
	bestDist        = 0;
	bestThreatLevel = 0;

	if (!bIgnoreCurrentEnemy && (Enemy != None))
		CheckEnemyParams(Enemy, bestPawn, bestThreatLevel, bestDist);

	if (!bSpottedPlayer)
		    UpdateActorVisibility(GetPlayerPawn(),0.0,0.0,True);

	foreach RadiusActors(Class'Pawn', nextPawn, 2000)  // arbitrary
		if (enemy != nextPawn)
		    if (nextPawn.IsA('DeusExPlayer') && !bSpottedPlayer) //CyberP:
		        break;
		    else
			    CheckEnemyParams(nextPawn, bestPawn, bestThreatLevel, bestDist);

	if (bestPawn != Enemy)
		newSeenTime = 0;
	else
		newSeenTime = EnemyLastSeen;

	SetEnemy(bestPawn, newSeenTime, true);

	EnemyTimer = 0;
}


// ----------------------------------------------------------------------
// ShouldStrafe()
// ----------------------------------------------------------------------

function bool ShouldStrafe()
{
    local bool bSafe;
	// This may be overridden from subclasses
	//return (AICanSee(enemy, 1.0, false, true, true, true) > 0);
	if (IsA('HumanMilitary') || IsA('HumanThug'))
	{
	    if (CombatSeeTimer > 0 && CombatSeeTimer < 1.0) //CyberP: alright, stop stupidly strafing out of sight all the time
	    {
	       if (LineOfSightTo(Enemy))   //CyberP: the strafer should have line of sight to the enemy for this to apply
	       {
           if (destPoint != None)      //CyberP: the strafe destination should have line of sight to the enemy.
	       {
              bSafe = fastTrace(enemy.Location, destPoint.Location+Vect(0,0,32));
              if (!bSafe)
                 return false;
	       }
           else
	       {
              bSafe = fastTrace(enemy.Location, destLoc+Vect(0,0,16));
              if (!bSafe)
                 return false;
	       }
	       }
	    }
	    if (AICanShoot(enemy, false, false, 0.025, true))
	    {
	        if (FRand() < 0.9)
	        {
	            bCanFire = True;
                return true;
            }
            else
                return false;
	    }
	    else if (VSize(Enemy.Location - Location) < 1536 && bSmartStrafe)
	        return true;
 	   else
            return false;
	}
    else
    {
	    return (AICanShoot(enemy, false, false, 0.025, true));
	}
}


// ----------------------------------------------------------------------
// ShouldFlee()
// ----------------------------------------------------------------------

function bool ShouldFlee()
{
	// This may be overridden from subclasses
	if (MinHealth > 0)
	{
		if (Health <= MinHealth)
			return true;
		else if (HealthArmLeft <= 0)
			return true;
		else if (HealthArmRight <= 0)
			return true;
		else if (HealthLegLeft <= 0)
			return true;
		else if (HealthLegRight <= 0)
			return true;
		else
			return false;
	}
	else
		return false;
}


// ----------------------------------------------------------------------
// ShouldDropWeapon()
// ----------------------------------------------------------------------

function bool ShouldDropWeapon()
{
	if (IsA('MIB')||IsA('WIB')||bTank) return false;
	if (((HealthArmLeft <= 0) || (HealthArmRight <= 0)) && (Health > 0))
		return true;
	else
		return false;
}


// ----------------------------------------------------------------------
// TryLocation()
// ----------------------------------------------------------------------

function bool TryLocation(out vector position, optional float minDist, optional bool bTraceActors,
						  optional NearbyProjectileList projList)
{
	local float   magnitude;
	local vector  normalPos;
	local Rotator rot;
	local float   dist;
	local bool    bSuccess;

	normalPos = position-Location;
	magnitude = VSize(normalPos);
	if (minDist > magnitude)
		minDist = magnitude;
	rot = Rotator(position-Location);
	bSuccess = AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, position);

	if (bSuccess)
	{
		if (bDefendHome && !IsNearHome(position))
			bSuccess = false;
		else if (bAvoidHarm && IsLocationDangerous(projList, position))
			bSuccess = false;
	}

	return (bSuccess);
}


// ----------------------------------------------------------------------
// ComputeBestFiringPosition()
// ----------------------------------------------------------------------

function EDestinationType ComputeBestFiringPosition(out vector newPosition)
{
	local float            selfMinRange, selfMaxRange;
	local float            enemyMinRange, enemyMaxRange;
	local float            temp;
	local float            dist;
	local float            innerRange[2], outerRange[2];
	local Rotator          relativeRotation;
	local float            hAngle, vAngle;
	local int              acrossDist;
	local float            awayDist;
	local float            extraDist;
	local float            fudgeMargin;
	local int              angle;
	local float            maxDist;
	local float            distDelta;
	local bool             bInnerValid, bOuterValid;
	local vector           tryVector;
	local EDestinationType destType;
	local float            moveMult;
	local float            reloadMult;
	local float            minArea;
	local float            minDist;
	local float            range;
	local float            margin;

	local NearbyProjectileList projList;
	local vector               projVector;
	local bool                 bUseProjVector;

	local rotator              sprintRot;
	local vector               sprintVect;
	local bool                 bUseSprint;

	destType = DEST_Failure;

	extraDist   = enemy.CollisionRadius*0.5;
	fudgeMargin = 100;
	minArea     = 35;

	GetPawnWeaponRanges(self, selfMinRange, selfMaxRange, temp);
	GetPawnWeaponRanges(enemy, enemyMinRange, temp, enemyMaxRange);

	if (selfMaxRange > 1200)
		selfMaxRange = 1200;
	if (enemyMaxRange > 1200)
		enemyMaxRange = 1200;

	// hack, to prevent non-strafing NPCs from trying to back up
	if (!bCanStrafe)
		selfMinRange  = 0;

	minDist = enemy.CollisionRadius + CollisionRadius - (extraDist+1);
	if (selfMinRange < minDist)
		selfMinRange = minDist;
	if (selfMinRange < MinRange)
		selfMinRange = MinRange;
	if (selfMaxRange > MaxRange)
		selfMaxRange = MaxRange;

	dist = VSize(enemy.Location-Location);

	innerRange[0] = selfMinRange;
	innerRange[1] = selfMaxRange;
	outerRange[0] = selfMinRange;
	outerRange[1] = selfMaxRange;

	// hack, to prevent non-strafing NPCs from trying to back up

	if (selfMaxRange > enemyMinRange)
		innerRange[1] = enemyMinRange;
	if ((selfMinRange < enemyMaxRange) && bCanStrafe)  // hack, to prevent non-strafing NPCs from trying to back up
		outerRange[0] = enemyMaxRange;

	range = outerRange[1]-outerRange[0];
	if (range < minArea)
	{
		outerRange[0] = 0;
		outerRange[1] = 0;
	}
	range = innerRange[1]-innerRange[0];
	if (range < minArea)
	{
		innerRange[0] = outerRange[0];
		innerRange[1] = outerRange[1];
		outerRange[0] = 0;
		outerRange[1] = 0;
	}

	// If the enemy can reach us through our entire weapon range, just use the range
	if ((innerRange[0] >= innerRange[1]) && (outerRange[0] >= outerRange[1]))
	{
		innerRange[0] = selfMinRange;
		innerRange[1] = selfMaxRange;
	}

	innerRange[0] += extraDist;
	innerRange[1] += extraDist;
	outerRange[0] += extraDist;
	outerRange[1] += extraDist;

	if (innerRange[0] >= innerRange[1])
		bInnerValid = false;
	else
		bInnerValid = true;
	if (outerRange[0] >= outerRange[1])
		bOuterValid = false;
	else
		bOuterValid = true;

	if (!bInnerValid)
	{
		// ugly
		newPosition = Location;
//		return DEST_SameLocation;
		return destType;
	}

	relativeRotation = Rotator(Location - enemy.Location);

	hAngle = (relativeRotation.Yaw - enemy.Rotation.Yaw) & 65535;
	if (hAngle > 32767)
		hAngle -= 65536;
	// ignore vertical angle for now

	awayDist   = dist;
	acrossDist = 0;
	maxDist    = GroundSpeed*0.6;  // distance covered in 6/10 second

	if (bInnerValid)
	{
		margin = (innerRange[1]-innerRange[0]) * 0.5;
		if (margin > fudgeMargin)
			margin = fudgeMargin;
		if (awayDist < innerRange[0])
			awayDist = innerRange[0]+margin;
		else if (awayDist > innerRange[1])
			awayDist = innerRange[1]-margin;
	}
	if (bOuterValid)
	{
		margin = (outerRange[1]-outerRange[0]) * 0.5;
		if (margin > fudgeMargin)
			margin = fudgeMargin;
		if (awayDist > outerRange[1])
			awayDist = outerRange[1]-margin;
	}

	if (awayDist > dist+maxDist)
		awayDist = dist+maxDist;
	if (awayDist < dist-maxDist)
		awayDist = dist-maxDist;

	// Used to determine whether NPCs should sprint/avoid aim
	moveMult = 1.0;
	if ((dist <= 512) && enemy.bIsPlayer && (enemy.Weapon != None) && (enemyMaxRange < 180))
		moveMult = CloseCombatMult;

	if (bAvoidAim && !enemy.bIgnore && (FRand() <= AvoidAccuracy*moveMult))
	{
		if ((awayDist < enemyMaxRange+maxDist+50) && (awayDist < 800) && (Enemy.Weapon != None))
		{
			if (dist > 0)
				angle = int(atan(CollisionRadius*2.0/dist)*32768/Pi);
			else
				angle = 16384;

			if ((hAngle >= -angle) && (hAngle <= angle))
			{
				if (hAngle < 0)
					acrossDist = (-angle-hAngle)-128;
				else
					acrossDist = (angle-hAngle)+128;
				if (Rand(20) == 0)
					acrossDist = -acrossDist;
			}
		}
	}

// projList is implicitly initialized to null...

	bUseProjVector = false;
	if (bAvoidHarm && (FRand() <= HarmAccuracy))
	{
		if (GetProjectileList(projList, Location) > 0)
		{
			if (IsLocationDangerous(projList, Location))
			{
				projVector = ComputeAwayVector(projList);
				bUseProjVector = true;
			}
		}
	}

	reloadMult = 1.0;
	if (IsWeaponReloading() && Enemy.bIsPlayer)
		reloadMult = 0.5;

	bUseSprint = false;
	if (!bUseProjVector && bSprint && bCanStrafe && !enemy.bIgnore && (FRand() <= SprintRate*0.5*moveMult*reloadMult))
	{
		if (bOuterValid || (innerRange[1] > 100))  // sprint on long-range weapons only
		{
			sprintRot = Rotator(enemy.Location - Location);
			if (Rand(2) == 1)
				sprintRot.Yaw += 16384;
			else
				sprintRot.Yaw += 49152;
			sprintRot = RandomBiasedRotation(sprintRot.Yaw, 0.5, 0, 0);
			sprintRot.Pitch = 0;
			sprintVect = Vector(sprintRot)*GroundSpeed*(FRand()+0.5);
			bUseSprint = true;
		}
	}

	if ((acrossDist != 0) || (awayDist != dist) || bUseProjVector || bUseSprint)
	{
		if (Rand(40) != 0)
		{
			if ((destType == DEST_Failure) && bUseProjVector)
			{
				tryVector = projVector + Location;
				if (TryLocation(tryVector, CollisionRadius+16))
					destType = DEST_NewLocation;
			}
			if ((destType == DEST_Failure) && (acrossDist != 0) && (awayDist != dist))
			{
				tryVector = Vector(relativeRotation+(rot(0, 1, 0)*acrossDist))*awayDist + enemy.Location;
				if (TryLocation(tryVector, CollisionRadius+16, , projList))
					destType = DEST_NewLocation;
			}
			if ((destType == DEST_Failure) && (awayDist != dist))
			{
				tryVector = Vector(relativeRotation)*awayDist + enemy.Location;
				if (TryLocation(tryVector, CollisionRadius+16, , projList))
					destType = DEST_NewLocation;
			}
			if ((destType == DEST_Failure) && (acrossDist != 0))
			{
				tryVector = Vector(relativeRotation+(rot(0, 1, 0)*acrossDist))*dist + enemy.Location;
				if (TryLocation(tryVector, CollisionRadius+16, , projList))
					destType = DEST_NewLocation;
			}
			if ((destType == DEST_Failure) && bUseSprint)
			{
				tryVector = sprintVect + Location;
				if (TryLocation(tryVector, CollisionRadius+16))
					destType = DEST_NewLocation;
			}
		}
		if (destType == DEST_Failure)
		{
			if ((moveMult >= 0.5) || (FRand() <= moveMult))
			{
				if (AIPickRandomDestination(CollisionRadius+16, maxDist,
				                            relativeRotation.Yaw+32768, 0.6, -relativeRotation.Pitch, 0.6, 2,
				                            0.9, tryVector))
					if (!bDefendHome || IsNearHome(tryVector))
						if (!bAvoidHarm || !IsLocationDangerous(projList, tryVector))
							destType = DEST_NewLocation;
			}
			else
				destType = DEST_SameLocation;
		}
		if (destType != DEST_Failure)
			newPosition = tryVector;
	}
	else
		destType = DEST_SameLocation;

	return destType;
}


// ----------------------------------------------------------------------
// SetAttackAngle()
//
// Sets the angle from which an asynchronous attack will occur
// (hack needed for DeusExWeapon)
// ----------------------------------------------------------------------

function SetAttackAngle()
{
	local bool bCanShoot;

	bCanShoot = false;
	if (Enemy != None)
		if (AICanShoot(Enemy, true, false, 0.025))
			bCanShoot = true;

	if (!bCanShoot)
		ViewRotation = Rotation;
}


// ----------------------------------------------------------------------
// AdjustAim()
//
// Adjust the aim at target
// ----------------------------------------------------------------------

function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool leadTarget, bool warnTarget)
{
	local rotator     FireRotation;
	local vector      FireSpot;
	local actor       HitActor;
	local vector      HitLocation, HitNormal;
	local vector      vectorArray[3];
	local vector      tempVector;
	local int         i;
	local int         swap;
	local Rotator     rot;
	local bool        bIsThrown;
	local DeusExMover dxMover;
	local actor       Target;  // evil fix -- STM

	bIsThrown = IsThrownWeapon(DeusExWeapon(Weapon));

// took this line out for evil fix...
//	if ( Target == None )

	Target = Enemy;
	if ( Target == None )
		return Rotation;
	if ( !Target.IsA('Pawn') )
		return rotator(Target.Location - Location);

	FireSpot = Target.Location;

	if (leadTarget && FRand() < 0.5 && sFire == 0 && (projSpeed > 0))  //CyberP: added frand for variation
	{                                                                           //RSD: now FRand < 0.5 instead 0.7 (see change below)
		if (bIsThrown)
		{
			// compute target's position 1.5 seconds in the future
			FireSpot = target.Location + (target.Velocity*1.5);
		}
		else
		{
			//FireSpot += (Target.Velocity * VSize(Target.Location - ProjStart)/projSpeed);
			ComputeTargetLead(Pawn(Target), ProjStart, projSpeed, 20.0, FireSpot);
		}
	}
    else    //CyberP: don't always target lead for variation
    {
    if (sFire > 0)
       FireSpot = GMDXEnemyLastSeenPos;
    else
    {
       ComputeTargetLead(Pawn(Target), ProjStart, projSpeed, 20.0, FireSpot);
       FireSpot = target.Location + FRand()*(FireSpot-target.Location);         //RSD: random "degree of lead" between 0 and 1
    }
    }

	if (bIsThrown)
	{
		vectorArray[0] = FireSpot - vect(0,0,1)*(Target.CollisionHeight-5);  // floor
		vectorArray[1] = vectorArray[0] + Vector(rot(0,1,0)*Rand(65536))*CollisionRadius*1.2;
		vectorArray[2] = vectorArray[0] + Vector(rot(0,1,0)*Rand(65536))*CollisionRadius*1.2;

		for (i=0; i<3; i++)
		{
			if (AISafeToThrow(vectorArray[i], ProjStart, 0.025))
				break;
		}
		if (i < 3)
		{
			FireSpot = vectorArray[i];
			FireRotation = ViewRotation;
		}
		else
			FireRotation = Rotator(FireSpot - ProjStart);
	}
	else
	{
		dxMover = DeusExMover(Target.Base);
		if ((dxMover != None) && dxMover.bBreakable)
		{
			tempVector = Normal((Location-Target.Location)*vect(1,1,0))*(Target.CollisionRadius*1.01) -
			             vect(0,0,1)*(Target.CollisionHeight*1.01);
			vectorArray[0] = FireSpot + tempVector;
		}
		else if (bAimForHead)
			vectorArray[0] = FireSpot + vect(0,0,1)*(Target.CollisionHeight*0.85);    // head
		else
			vectorArray[0] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);
		vectorArray[1] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);
		vectorArray[2] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);

		for (i=0; i<3; i++)
		{
			if (IsA('SecurityBot4'))                                            //RSD: Special case for SecurityBot4 so it doesn't only shoot at your damn legs
			{
			    vectorArray[i] = FireSpot + vect(0,0,1)*0.5*Target.CollisionHeight;
			}
            if (AISafeToShoot(HitActor, vectorArray[i], ProjStart))
				break;
		}
		if (i < 3)
			FireSpot = vectorArray[i];

		FireRotation = Rotator(FireSpot - ProjStart);
	}

	if (warnTarget && Pawn(Target) != None)
		Pawn(Target).WarnTarget(self, projSpeed, vector(FireRotation));

	FireRotation.Yaw = FireRotation.Yaw & 65535;
	if ( (Abs(FireRotation.Yaw - (Rotation.Yaw & 65535)) > 8192)
		&& (Abs(FireRotation.Yaw - (Rotation.Yaw & 65535)) < 57343) )
	{
		if ( (FireRotation.Yaw > Rotation.Yaw + 32768) ||
			((FireRotation.Yaw < Rotation.Yaw) && (FireRotation.Yaw > Rotation.Yaw - 32768)) )
			FireRotation.Yaw = Rotation.Yaw - 8192;
		else
			FireRotation.Yaw = Rotation.Yaw + 8192;
	}
	viewRotation = FireRotation;
	return FireRotation;
}


// ----------------------------------------------------------------------
// IsThrownWeapon()
// ----------------------------------------------------------------------

function bool IsThrownWeapon(DeusExWeapon testWeapon)
{
	local Class<ThrownProjectile> throwClass;
	local bool                    bIsThrown;

	bIsThrown = false;
	if (testWeapon != None)
	{
		if (!testWeapon.bInstantHit)
		{
			throwClass = class<ThrownProjectile>(testWeapon.ProjectileClass);
			if (throwClass != None)
				bIsThrown = true;
		}
	}

	return bIsThrown;

}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// CALLBACKS AND OVERRIDDEN FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	local float        dropPeriod;
	local float        adjustedRate;
	local DeusExPlayer player;
	local name         stateName;
	local vector       loc;
	local bool         bDoLowPriority;
	local bool         bCheckOther;
	local bool         bCheckPlayer;
	 local float         ModDistance;

	player = DeusExPlayer(GetPlayerPawn());
    
    //If we shouldn't be created, abort
    if (!bFirstTickDone && !ShouldCreate(player))
        Destroy();


	bDoLowPriority = true;
	bCheckPlayer   = true;
	bCheckOther    = true;

	if (bTickVisibleOnly)
	{
	 	if (DistanceFromPlayer > 1200)
			bDoLowPriority = false;

		  if (player !=None && player.bHardCoreMode) //CyberP: realistic & hardcore have realistic vision
				ModDistance=4096.0;
		  else if (player !=None && player.CombatDifficulty > 2)
                ModDistance=3200.0;
          else
                ModDistance=2590.0;

		if (DistanceFromPlayer > ModDistance)
			bCheckPlayer = false;
		if ((DistanceFromPlayer > 600) && (LastRendered() >= 5.0))
			bCheckOther = false;
	}

/*
	if (bDisappear && (InStasis() || (LastRendered() > 5.0)))
	{
		Destroy();
		return;
	}

	if (PrePivotTime > 0)
	{
		if (deltaTime < PrePivotTime)
		{
			PrePivot = PrePivot + (DesiredPrePivot-PrePivot)*deltaTime/PrePivotTime;
			PrePivotTime -= deltaTime;
		}
		else
		{
			PrePivot = DesiredPrePivot;
			PrePivotTime = 0;
		}
	}

	if (bDoLowPriority)
		Super.Tick(deltaTime);

	UpdateAgitation(deltaTime);
	UpdateFear(deltaTime);

	AlarmTimer -= deltaTime;
	if (AlarmTimer < 0)
		AlarmTimer = 0;

	if (Weapon != None)
		WeaponTimer += deltaTime;
	else if (WeaponTimer != 0)
		WeaponTimer = 0;

	if ((ReloadTimer > 0) && (Weapon != None))
		ReloadTimer -= deltaTime;
	else
		ReloadTimer = 0;

	if (AvoidWallTimer > 0)
	{
		AvoidWallTimer -= deltaTime;
		if (AvoidWallTimer < 0)
			AvoidWallTimer = 0;
	}

	if (AvoidBumpTimer > 0)
	{
		AvoidBumpTimer -= deltaTime;
		if (AvoidBumpTimer < 0)
			AvoidBumpTimer = 0;
	}

	if (CloakEMPTimer > 0)
	{
		CloakEMPTimer -= deltaTime;
		if (CloakEMPTimer < 0)
			CloakEMPTimer = 0;
	}

	if (TakeHitTimer > 0)
	{
		TakeHitTimer -= deltaTime;
		if (TakeHitTimer < 0)
			TakeHitTimer = 0;
	}

	if (CarcassCheckTimer > 0)
	{
		CarcassCheckTimer -= deltaTime;
		if (CarcassCheckTimer < 0)
			CarcassCheckTimer = 0;
	}

	if (PotentialEnemyTimer > 0)
	{
		PotentialEnemyTimer -= deltaTime;
		if (PotentialEnemyTimer <= 0)
		{
			PotentialEnemyTimer    = 0;
			PotentialEnemyAlliance = '';
		}
	}

	if (BeamCheckTimer > 0)
	{
		BeamCheckTimer -= deltaTime;
		if (BeamCheckTimer < 0)
			BeamCheckTimer = 0;
	}

	if (FutzTimer > 0)
	{
		FutzTimer -= deltaTime;
		if (FutzTimer < 0)
			FutzTimer = 0;
	}

	if (PlayerAgitationTimer > 0)
	{
		PlayerAgitationTimer -= deltaTime;
		if (PlayerAgitationTimer < 0)
			PlayerAgitationTimer = 0;
	}

	if (DistressTimer >= 0)
	{
		DistressTimer += deltaTime;
		if (DistressTimer > FearSustainTime)
			DistressTimer = -1;
	}

	if (bHasCloak)
		EnableCloak(Health <= CloakThreshold);

	if (bAdvancedTactics)
	{
		if ((Acceleration == vect(0,0,0)) || (Physics != PHYS_Walking) ||
		    (TurnDirection == TURNING_None))
		{
			bAdvancedTactics = false;
			if (TurnDirection != TURNING_None)
				MoveTimer -= 4.0;
			ActorAvoiding    = None;
			NextDirection    = TURNING_None;
			TurnDirection    = TURNING_None;
			bClearedObstacle = true;
			ObstacleTimer    = 0;
		}
	}

	if (bOnFire)
	{
		burnTimer += deltaTime;
		if (burnTimer >= BurnPeriod)
			ExtinguishFire();
	}

	if (bDoLowPriority)
	{
		if ((bleedRate > 0) && bCanBleed)
		{
			adjustedRate = (1.0-FClamp(bleedRate, 0.0, 1.0))*1.0+0.1;  // max 10 drops per second
			dropPeriod = adjustedRate / FClamp(VSize(Velocity)/512.0, 0.05, 1.0);
			dropCounter += deltaTime;
			while (dropCounter >= dropPeriod)
			{
				SpurtBlood();
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
*/

	if (bStandInterpolation)
		UpdateStanding(deltaTime);

	// this is UGLY!
	if (bOnFire && (health > 0))
	{
		stateName = GetStateName();
		if ((stateName != 'Burning') && (stateName != 'TakingHit') && (stateName != 'RubbingEyes'))
			GotoState('Burning');
	}
	else
	{
		if (bDoLowPriority)
		{
			// Don't allow radius-based convos to interupt other conversations!
			if ((player != None) && (GetStateName() != 'Conversation') && (GetStateName() != 'FirstPersonConversation'))
				player.StartConversation(Self, IM_Radius);
		}

		if (CheckEnemyPresence(deltaTime, bCheckPlayer, bCheckOther))
			HandleEnemy();
		else
		{
			CheckBeamPresence(deltaTime);
			if (bDoLowPriority || LastRendered() < 5.0)
				CheckCarcassPresence(deltaTime);  // hacky -- may change state!
		}
	}

	// Randomly spawn an air bubble every 0.2 seconds if we're underwater
	if (HeadRegion.Zone.bWaterZone && bSpawnBubbles && bDoLowPriority)
	{
		swimBubbleTimer += deltaTime;
		if (swimBubbleTimer >= 0.2)
		{
			swimBubbleTimer = 0;
			if (FRand() < 0.4)
			{
				loc = Location + VRand() * 4;
				loc.Z += CollisionHeight * 0.9;
				Spawn(class'AirBubble', Self,, loc);
			}
		}
	}

	// Handle poison damage
	UpdatePoison(deltaTime);

    //SARGE: Handle Blinking
    HandleBlink(deltaTime);

    bFirstTickDone = true;
}


// ----------------------------------------------------------------------
// SpurtBlood()
// ----------------------------------------------------------------------

function SpurtBlood()
{
	local vector bloodVector;

	bloodVector = vect(0,0,1)*CollisionHeight*0.5;  // so folks don't bleed from the crotch
	spawn(Class'BloodDrop',,,bloodVector+Location);
}


// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
	TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);
}


// ----------------------------------------------------------------------
// Timer()
// ----------------------------------------------------------------------

function Timer()
{
	//SARGE: Was previously using 'HDTPWeaponCrowbarTex2', vanilla used 'WhiteStatic'
	//Imported the high-quality one from HDTP, since WhiteStatic is WAY too visible!
	if (bCloakOn)           //CyberP: for new cloaking effect.
	{
			 if (IsA('SecurityBot4'))
				SetSkinStyle(STY_Translucent, Texture'RSDCrap.Skins.CloakingTex', 0.4);
			 else
				SetSkinStyle(STY_Translucent, Texture'RSDCrap.Skins.CloakingTex', 0.15);
			 LightRadius = 0;
			 AmbientGlow = 0;
	}
	else
	{
	UpdateFire();
	}
}


// ----------------------------------------------------------------------
// ZoneChange()
// ----------------------------------------------------------------------

function ZoneChange(ZoneInfo newZone)
{
	local vector jumpDir;

	if (!bInWorld)
		return;

	if (newZone.bWaterZone)
	{
		EnableShadow(false);
		if (IsA('Doberman'))     //CyberP: Doberman have no swim animations, so kill them.
		    TakeDamage(health,self,vect(0,0,0),vect(0,0,0),'Shot');
		if (!bCanSwim)
			MoveTimer = -1.0;
		else if (Physics != PHYS_Swimming)
		{
			if (bOnFire)
				ExtinguishFire();

			PlaySwimming();
			setPhysics(PHYS_Swimming);
		}
		swimBubbleTimer = 0;
	}
	else if (Physics == PHYS_Swimming)
	{
		EnableShadow(true);
		if ( bCanFly )
			 SetPhysics(PHYS_Flying);
		else
		{
			SetPhysics(PHYS_Falling);
			if ( bCanWalk && (Abs(Acceleration.X) + Abs(Acceleration.Y) > 0) && CheckWaterJump(jumpDir) )
				JumpOutOfWater(jumpDir);
		}
	}
}


// ----------------------------------------------------------------------
// BaseChange()
// ----------------------------------------------------------------------

singular function BaseChange()
{
	Super.BaseChange();

	if (bSitting && !IsSeatValid(SeatActor))
	{
		StandUp();
		if (GetStateName() == 'Sitting')
			GotoState('Sitting', 'Begin');
	}
}


// ----------------------------------------------------------------------
// PainTimer()
// ----------------------------------------------------------------------

event PainTimer()
{
	local float       depth;
	local PointRegion painRegion;

	if ((Health <= 0) || (Level.NetMode == NM_Client))
		return;

	painRegion = HeadRegion;
	if (!painRegion.Zone.bPainZone || (painRegion.Zone.DamageType == ReducedDamageType))
		painRegion = Region;
	if (!painRegion.Zone.bPainZone || (painRegion.Zone.DamageType == ReducedDamageType))
		painRegion = FootRegion;

	if (painRegion.Zone.bPainZone && (painRegion.Zone.DamageType != ReducedDamageType))
	{
		depth = 0;
		if (FootRegion.Zone.bPainZone)
			depth += 0.3;
		if (Region.Zone.bPainZone)
			depth += 0.3;
		if (HeadRegion.Zone.bPainZone)
			depth += 0.4;

		if (painRegion.Zone.DamagePerSec > 0)
			TakeDamage(int(float(painRegion.Zone.DamagePerSec) * depth), None, Location, vect(0,0,0), painRegion.Zone.DamageType);
		// took out healing for NPCs -- we don't use healing zones anyway
		/*
		else if ( Health < Default.Health )
			Health = Min(Default.Health, Health - depth * FootRegion.Zone.DamagePerSec);
		*/

		if (Health > 0)
			PainTime = 1.0;
	}
	else if (HeadRegion.Zone.bWaterZone && (UnderWaterTime > 0))
	{
		TakeDamage(5, None, Location, vect(0,0,0), 'Drowned');
		if (Health > 0)
			PainTime = 2.0;
	}
}

// ----------------------------------------------------------------------
// CheckWaterJump()
// ----------------------------------------------------------------------

function bool CheckWaterJump(out vector WallNormal)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, checkpoint, start, checkNorm, Extent;

	if (CarriedDecoration != None)
		return false;
	checkpoint = vector(Rotation);
	checkpoint.Z = 0.0;
	checkNorm = Normal(checkpoint);
	checkPoint = Location + CollisionRadius * checkNorm;
	Extent = CollisionRadius * vect(1,1,0);
	Extent.Z = CollisionHeight;
	HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false, Extent);
	if ( (HitActor != None) && (Pawn(HitActor) == None) )
	{
		WallNormal = -1 * HitNormal;
		start = Location;
		start.Z += 1.1 * MaxStepHeight + CollisionHeight;
		checkPoint = start + 2 * CollisionRadius * checkNorm;
		HitActor = Trace(HitLocation, HitNormal, checkpoint, start, true, Extent);
		if (HitActor == None)
			return true;
	}

	return false;
}


// ----------------------------------------------------------------------
// SetMovementPhysics()
// ----------------------------------------------------------------------

function SetMovementPhysics()
{
	// re-implement SetMovementPhysics() in subclass for flying and swimming creatures
	if (Physics == PHYS_Falling)
		return;

	if (Region.Zone.bWaterZone && bCanSwim)
		SetPhysics(PHYS_Swimming);
	else if (Default.Physics == PHYS_None)
		SetPhysics(PHYS_Walking);
	else
		SetPhysics(Default.Physics);
}


// ----------------------------------------------------------------------
// PreSetMovement()
// ----------------------------------------------------------------------

function PreSetMovement()
{
	// Copied from Pawn.uc and overridden so Pawn doesn't erase our walking/swimming/flying physics
	if (JumpZ > 0)
		bCanJump = true;
	// No, no, no!!!
	/*
	bCanWalk = true;
	bCanSwim = false;
	bCanFly = false;
	MinHitWall = -0.6;
	if (Intelligence > BRAINS_Reptile)
		bCanOpenDoors = true;
	if (Intelligence == BRAINS_Human)
		bCanDoSpecial = true;
	*/
}


// ----------------------------------------------------------------------
// ChangedWeapon()
// ----------------------------------------------------------------------

function ChangedWeapon()
{
	// do nothing
}


// ----------------------------------------------------------------------
// SwitchToBestWeapon()
// ----------------------------------------------------------------------

function bool SwitchToBestWeapon()
{
	local Inventory    inv;
	local DeusExWeapon curWeapon;
	local float        score;
	local DeusExWeapon dxWeapon;
	local DeusExWeapon bestWeapon;
	local float        bestScore;
	local int          fallbackLevel;
	local int          curFallbackLevel;
	local bool         bBlockSpecial;
	local bool         bValid;
	local bool         bWinner;
	local float        minRange, accRange;
	local float        range, centerRange;
	local float        cutoffRange;
	local float        enemyRange;
	local float        minEnemy, accEnemy, maxEnemy;
	local ScriptedPawn enemyPawn;
	local Robot        enemyRobot;
	local DeusExPlayer enemyPlayer;
	local float        enemyRadius;
	local bool         bEnemySet;
	local int          loopCount, i;  // hack - check for infinite inventory
	local Inventory    loopInv;       // hack - check for infinite inventory

	if (ShouldDropWeapon())
	{
		DropWeapon();
		return false;
	}

	bBlockSpecial = false;
	dxWeapon = DeusExWeapon(Weapon);
	if (dxWeapon != None)
	{
		if (dxWeapon.AITimeLimit > 0)
		{
			if (SpecialTimer <= 0)
			{
				bBlockSpecial = true;
				FireTimer = dxWeapon.AIFireDelay;
			}
		}
	}

	bestWeapon      = None;
	bestScore       = 0;
	fallbackLevel   = 0;
	inv             = Inventory;

	bEnemySet   = false;
	minEnemy    = 0;
	accEnemy    = 0;
	enemyRange  = 400;  // default
	enemyRadius = 0;
	enemyPawn   = None;
	enemyRobot  = None;
	if (Enemy != None)
	{
		bEnemySet   = true;
		enemyRange  = VSize(Enemy.Location - Location);
		enemyRadius = Enemy.CollisionRadius;
		if (DeusExWeapon(Enemy.Weapon) != None)
			DeusExWeapon(Enemy.Weapon).GetWeaponRanges(minEnemy, accEnemy, maxEnemy);
		enemyPawn   = ScriptedPawn(Enemy);
		enemyRobot  = Robot(Enemy);
		enemyPlayer = DeusExPlayer(Enemy);
	}

	loopCount = 0;
	while (inv != None)
	{
		// THIS IS A MAJOR HACK!!!
		loopCount++;
		if (loopCount == 9999)
		{
			log("********** RUNAWAY LOOP IN SWITCHTOBESTWEAPON ("$self$") **********");
			loopInv = Inventory;
			i = 0;
			while (loopInv != None)
			{
				i++;
				if (i > 300)
					break;
				log("   Inventory "$i$" - "$loopInv);
				loopInv = loopInv.Inventory;
			}
		}

		curWeapon = DeusExWeapon(inv);
		if (curWeapon != None)
		{
			bValid = true;
			if (curWeapon.ReloadCount > 0)
			{
				if (curWeapon.AmmoType == None)
					bValid = false;
				else if (curWeapon.AmmoType.AmmoAmount < 1)
					bValid = false;
			}

			// Ensure we can actually use this weapon here
			if (bValid)
			{
				// lifted from DeusExWeapon...
				if ((curWeapon.EnviroEffective == ENVEFF_Air) || (curWeapon.EnviroEffective == ENVEFF_Vacuum) ||
				    (curWeapon.EnviroEffective == ENVEFF_AirVacuum))
					if (curWeapon.Region.Zone.bWaterZone)
						bValid = false;
			}

			if (bValid)
			{
                GetWeaponBestRange(curWeapon, minRange, accRange);
				cutoffRange = minRange+(CollisionRadius+enemyRadius);
				range = (accRange - minRange) * 0.5;
				centerRange = minRange + range;
				if (range < 50)
					range = 50;
				if (enemyRange < centerRange)
					score = (centerRange - enemyRange)/range;
				else
					score = (enemyRange - centerRange)/range;
				if ((minRange >= minEnemy) && (accRange <= accEnemy))
					score += 0.5;  // arbitrary
				if ((cutoffRange >= enemyRange-CollisionRadius) && (cutoffRange >= 256)) // do not use long-range weapons on short-range targets
					score += 10000;

				curFallbackLevel = 3;
				if (curWeapon.bFallbackWeapon && !bUseFallbackWeapons)
					curFallbackLevel = 2;
				if (!bEnemySet && !curWeapon.bUseAsDrawnWeapon)
					curFallbackLevel = 1;
				if ((curWeapon.AIFireDelay > 0) && (FireTimer > 0))
					curFallbackLevel = 0;
				if (bBlockSpecial && (curWeapon.AITimeLimit > 0) && (SpecialTimer <= 0))
					curFallbackLevel = 0;

				// Adjust score based on opponent and damage type.
				// All damage types are listed here, even the ones that aren't used by weapons... :)
				// (hacky...)

				switch (curWeapon.WeaponDamageType())
				{
					case 'Exploded':
						// Massive explosions are always good
						score -= 0.2;
						if (IsA('SpiderBot')) //CyberP: increase chances of spiderbots firing rockets
						   score -= 0.4;
						break;

					case 'Stunned':
						if (enemyPawn != None)
						{
							if (enemyPawn.bStunned)
								score += 1000;
							else
								score -= 1.5;
						}
						if (enemyPlayer != None)
							score += 10;
						break;

					case 'TearGas':
						if (enemyPawn != None)
						{
							if (enemyPawn.bStunned)
								//score += 1000;
								bValid = false;
                            else
								score -= 5.0;
						}
						if (enemyRobot != None)
							//score += 10000;
							bValid = false;
						if (enemyPlayer != None) //CyberP: don't prioritise gas grenades now that we have better nade throwing
						    score += 10000;
						break;

					case 'HalonGas':
						if (enemyPawn != None)
						{
							if (enemyPawn.bStunned)
								//score += 1000;
								bValid = false;
							else if (enemyPawn.bOnFire)
								//score += 10000;
								bValid = false;
							else
								score -= 3.0;
						}
						if (enemyRobot != None)
							//score += 10000;
							bValid = false;
						break;

					case 'PoisonGas':
					case 'Poison':
					case 'PoisonEffect':
					case 'Radiation':
						if (enemyRobot != None)
							//score += 10000;
							bValid = false;
						break;

					case 'Flamed':
					     if (enemyRobot != None && IsA('Robot')) //CyberP: bots don't use flamethrower on other bots
							score += 2000.0;
						break;

                    case 'Burned':
					case 'Shot':
						if (enemyRobot != None)
							score += 0.5;
						else if (IsA('Greasel') && enemyRange < 320)
                            score -= 10000.0;
						break;

					case 'Sabot':
						if (enemyRobot != None)
							score -= 0.5;
						break;

					case 'EMP':
					case 'NanoVirus':
						if (enemyRobot != None)
							score -= 10.0;
						else if (enemyPlayer != None)
							score -= 10.0; //CyberP: was 10.0
						else
							//score += 10000;
							bValid = false;
						break;

					case 'Drowned':
					default:
						break;
				}

				// Special case for current weapon
				if ((curWeapon == Weapon) && (WeaponTimer < 10.0))
				{
					// If we last changed weapons less than five seconds ago,
					// keep this weapon
					if (WeaponTimer < 5.0)
						score = -10;

					// If between five and ten seconds, use a sliding scale
					else
						score -= (10.0 - WeaponTimer)/5.0;
				}

				// Throw a little randomness into the computation...
				else
				{
					score += FRand()*0.1 - 0.05;
					if (score < 0)
						score = 0;
				}

				if (bValid)
				{
					// ugly
					if (bestWeapon == None)
						bWinner = true;
					else if (curFallbackLevel > fallbackLevel)
						bWinner = true;
					else if (curFallbackLevel < fallbackLevel)
						bWinner = false;
					else if (bestScore > score)
						bWinner = true;
					else
						bWinner = false;
					if (bWinner)
					{
						bestScore     = score;
						bestWeapon    = curWeapon;
						fallbackLevel = curFallbackLevel;
					}
				}
			}
		}
		inv = inv.Inventory;
	}

	// If we're changing weapons, reset the weapon timers
	if (Weapon != bestWeapon)
	{
		if (!bEnemySet)
			WeaponTimer = 10;  // hack
		else
			WeaponTimer = 0;
		if (bestWeapon != None)
			if (bestWeapon.AITimeLimit > 0)
				SpecialTimer = bestWeapon.AITimeLimit;
		ReloadTimer = 0;
	}

	SetWeapon(bestWeapon);

	return false;
}


// ----------------------------------------------------------------------
// LoopBaseConvoAnim()
// ----------------------------------------------------------------------

function LoopBaseConvoAnim()
{
	// Special case for sitting
	if (bSitting)
	{
		if (!IsAnimating())
			PlaySitting();
	}

	// Special case for dancing
	else if (bDancing)
	{
		if (!IsAnimating())
			PlayDancing();
	}

	// Otherwise, just do the usual shit
	else
		Super.LoopBaseConvoAnim();

}


// ----------------------------------------------------------------------
// BackOff()
// ----------------------------------------------------------------------

function BackOff()
{
	SetNextState(GetStateName(), 'ContinueFromDoor');  // MASSIVE hackage
	SetState('BackingOff');
}


// ----------------------------------------------------------------------
// CheckDestLoc()
// ----------------------------------------------------------------------

function CheckDestLoc(vector newDestLoc, optional bool bPathnode)
{
	if (VSize(newDestLoc-LastDestLoc) <= 16)  // too close
		DestAttempts++;
	else if (!IsPointInCylinder(self, newDestLoc))
		DestAttempts++;
	else if (bPathnode && (VSize(newDestLoc-LastDestPoint) <= 16))  // too close
		DestAttempts++;
	else
		DestAttempts = 0;
	LastDestLoc = newDestLoc;
	if (bPathnode && (DestAttempts == 0))
		LastDestPoint = newDestLoc;

	if (bEnableCheckDest && (DestAttempts >= 4))   //CyberP: hmm...was >=4
		BackOff();
}


// ----------------------------------------------------------------------
// ResetDestLoc()
// ----------------------------------------------------------------------

function ResetDestLoc()
{
	DestAttempts  = 0;
	LastDestLoc   = vect(9999,9999,9999);  // hack
	LastDestPoint = LastDestLoc;
}


// ----------------------------------------------------------------------
// EnableCheckDestLoc()
// ----------------------------------------------------------------------

function EnableCheckDestLoc(bool bEnable)
{
//	if (bEnableCheckDest && !bEnable)
		ResetDestLoc();
	bEnableCheckDest = bEnable;
}


// ----------------------------------------------------------------------
// HandleTurn()
// ----------------------------------------------------------------------

function bool HandleTurn(actor Other)
{
	local bool             bHandle;
	local bool             bHackState;
	local DeusExDecoration dxDecoration;
	local ScriptedPawn     scrPawn;

	// THIS ENTIRE SECTION IS A MASSIVE HACK TO GET AROUND PATHFINDING PROBLEMS
	// WHEN AN OBSTACLE COMPLETELY BLOCKS AN NPC'S PATH...

	bHandle    = true;
	bHackState = false;
	if (bEnableCheckDest)
	{
		if (DestAttempts >= 2)
		{
			dxDecoration = DeusExDecoration(Other);
			scrPawn      = ScriptedPawn(Other);
			if (dxDecoration != None)
			{
				if (!dxDecoration.bInvincible && !dxDecoration.bExplosive)
				{
					dxDecoration.HitPoints = 0;
					dxDecoration.TakeDamage(1, self, dxDecoration.Location, vect(0,0,0), 'Kick');
					bHandle = false;
				}
				else if (DestAttempts >= 3)
				{
					bHackState = true;
					bHandle    = false;
				}
			}
			else if (scrPawn != None)
			{
				if (DestAttempts >= 3) //CyberP: was >= 3
				{
					if (scrPawn.GetStateName() != 'BackingOff')
					{
						bHackState = true;
						bHandle    = false;
					}
				}
			}
		}

		if (bHackState)
			BackOff();
	}

	return (bHandle);
}


// ----------------------------------------------------------------------
// Bump()
// ----------------------------------------------------------------------

function Bump(actor Other)
{
	local Rotator      rot1, rot2;
	local int          yaw;
	local ScriptedPawn avoidPawn;
	local DeusExPlayer dxPlayer;
	local bool         bTurn;
    local AugIcarus icar;
	// Handle futzing and projectiles
	if (Other.Physics == PHYS_Falling)
	{
		if (DeusExProjectile(Other) != None)
			ReactToProjectiles(Other);
		else
		{
			dxPlayer = DeusExPlayer(Other.Instigator);
			if ((Other != dxPlayer) && (dxPlayer != None))
				ReactToFutz();
			else if (Other == dxPlayer)
			{
               if (dxPlayer.RocketTargetMaxDistance==40001.000000)
			   {
			      if (bIsHuman)
			      {
                     bIcarused = True;
                     PlaySound(sound'pl_fallpain3',SLOT_None);
                  }
                  TakeDamageBase(120, dxPlayer, (vector(ViewRotation)*CollisionRadius), vect(0,0,0), 'shot', false);
                  icar = AugIcarus(dxPlayer.AugmentationSystem.FindAugmentation(class'AugIcarus'));
                  icar.incremental = 2;
               }
            }
		}
	}

	// Have we walked into another (non-level) actor?
	bTurn = false;
	if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)) && bWalkAround && (Other != Level) && !Other.IsA('Mover'))
		if ((TurnDirection == TURNING_None) || (AvoidBumpTimer <= 0) && (Other.CollisionHeight > MaxStepHeight*0.75)) //CyberP: also check for small objects, which we ignore
			if (HandleTurn(Other))
				bTurn = true;

    /*if ((bSeekPostCombat || IsInState('Wandering')) && Other.IsA('DeusExDecoration'))
    {
        EnableCheckDestLoc(false);
        destPoint = None;
        bTurn = False;
        Destination = Location;
        destLoc = Location;
        useLoc = Location;
        MoveTarget = None;
        velocity = vect(0,0,0);
        Acceleration = vect(0,0,0);
        StopBlendAnims();
        PlayWaiting();
    }*/

	// Turn away from the actor
	if (bTurn)
	{
		// If we're not already turning, start
		if (TurnDirection == TURNING_None)
		{
			// Give ourselves a little extra time
			MoveTimer += 4.0;

			rot1 = Rotator(Other.Location-Location);  // direction of object being bumped
			rot2 = Rotator(Acceleration);  // direction we wish to go
			yaw  = (rot2.Yaw - rot1.Yaw) & 65535;
			if (yaw > 32767)
				yaw -= 65536;

			// Depending on the angle we bump the actor, turn left or right
			if (yaw < 0)
			{
				TurnDirection = TURNING_Left;
				NextDirection = TURNING_Right;
			}
			else
			{
				TurnDirection = TURNING_Right;
				NextDirection = TURNING_Left;
			}
			bClearedObstacle = false;

			// Enable AlterDestination()
			bAdvancedTactics = true;
		}

		// Ignore multiple bumps in a row
		// BOOGER! Ignore same bump actor?
		if (AvoidBumpTimer <= 0)
		{
			AvoidBumpTimer   = 0.2;
			ActorAvoiding    = Other;
			bClearedObstacle = false;

			avoidPawn = ScriptedPawn(ActorAvoiding);

			// Avoid pairing off
			if (avoidPawn != None)
			{
				if ((avoidPawn.Acceleration != vect(0,0,0)) && (avoidPawn.Physics == PHYS_Walking) &&
				    (avoidPawn.TurnDirection != TURNING_None) && (avoidPawn.ActorAvoiding == self))
				{
					if ((avoidPawn.TurnDirection == TURNING_Left) && (TurnDirection == TURNING_Right))
					{
						TurnDirection = TURNING_Left;
						if (NextDirection != TURNING_None)
							NextDirection = TURNING_Right;
					}
					else if ((avoidPawn.TurnDirection == TURNING_Right) && (TurnDirection == TURNING_Left))
					{
						TurnDirection = TURNING_Right;
						if (NextDirection != TURNING_None)
							NextDirection = TURNING_Left;
					}
				}
			}
		}
	}
}


// ----------------------------------------------------------------------
// HitWall()
// ----------------------------------------------------------------------

function HitWall(vector HitLocation, Actor hitActor)
{
	local ScriptedPawn avoidPawn;

	// We only care about HitWall as it pertains to level geometry
	if (hitActor != Level)
		return;

	// Are we walking?
	if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)) && bWalkAround &&
	    (AvoidWallTimer <= 0))
	{
		// Are we turning?
		if (TurnDirection != TURNING_None)
		{
			AvoidWallTimer = 1.0;

			// About face
			TurnDirection    = NextDirection;
			NextDirection    = TURNING_None;
			bClearedObstacle = false;

			// Avoid pairing off
			avoidPawn = ScriptedPawn(ActorAvoiding);
			if (avoidPawn != None)
			{
				if ((avoidPawn.Acceleration != vect(0,0,0)) && (avoidPawn.Physics == PHYS_Walking) &&
				    (avoidPawn.TurnDirection != TURNING_None) && (avoidPawn.ActorAvoiding == self))
				{
					if ((avoidPawn.TurnDirection == TURNING_Left) && (TurnDirection == TURNING_Right))
						TurnDirection = TURNING_None;
					else if ((avoidPawn.TurnDirection == TURNING_Right) && (TurnDirection == TURNING_Left))
						TurnDirection = TURNING_None;
				}
			}

			// Stopped turning?  Shut down
			if (TurnDirection == TURNING_None)
			{
				ActorAvoiding = None;
				bAdvancedTactics = false;
				MoveTimer -= 4.0;
				ObstacleTimer = 0;
			}
		}
	}
}


// ----------------------------------------------------------------------
// AlterDestination()
// ----------------------------------------------------------------------

function AlterDestination()
{
	local Rotator  dir;
	local int      avoidYaw;
	local int      destYaw;
	local int      moveYaw;
	local int      angle;
	local bool     bPointInCylinder;
	local float    dist1, dist2;
	local bool     bAround;
	local vector   tempVect;
	local ETurning oldTurnDir;

	oldTurnDir = TurnDirection;

	// Sanity check -- are we done walking around the actor?
	if (TurnDirection != TURNING_None)
	{
		if (!bWalkAround)
			TurnDirection = TURNING_None;
		else if (bClearedObstacle)
			TurnDirection = TURNING_None;
		else if (ActorAvoiding == None)
			TurnDirection = TURNING_None;
		else if (ActorAvoiding.bDeleteMe)
			TurnDirection = TURNING_None;
		else if (!IsPointInCylinder(ActorAvoiding, Location,
		                            CollisionRadius*2, CollisionHeight*2))
			TurnDirection = TURNING_None;
	}

	// Are we still turning?
	if (TurnDirection != TURNING_None)
	{
		bAround = false;

		// Is our destination point inside the actor we're walking around?
		bPointInCylinder = IsPointInCylinder(ActorAvoiding, Destination,
		                                     CollisionRadius-8, CollisionHeight-8);
		if (bPointInCylinder)
		{
			dist1 = VSize((Location - ActorAvoiding.Location)*vect(1,1,0));
			dist2 = VSize((Location - Destination)*vect(1,1,0));

			// Are we on the right side of the actor?
			if (dist1 > dist2)
			{
				// Just make a beeline, if possible
				tempVect = Destination - ActorAvoiding.Location;
				tempVect.Z = 0;
				tempVect = Normal(tempVect) * (ActorAvoiding.CollisionRadius + CollisionRadius);
				if (tempVect == vect(0,0,0))
					Destination = Location;
				else
				{
					tempVect += ActorAvoiding.Location;
					tempVect.Z = Destination.Z;
					Destination = tempVect;
				}
			}
			else
				bAround = true;
		}
		else
			bAround = true;

		// We have a valid destination -- continue to walk around
		if (bAround)
		{
			// Determine the destination-self-obstacle angle
			dir      = Rotator(ActorAvoiding.Location-Location);
			avoidYaw = dir.Yaw;
			dir      = Rotator(Destination-Location);
			destYaw  = dir.Yaw;

			if (TurnDirection == TURNING_Left)
				angle = (avoidYaw - destYaw) & 65535;
			else
				angle = (destYaw - avoidYaw) & 65535;
			if (angle < 0)
				angle += 65536;

			// If the angle is between 90 and 180 degrees, we've cleared the obstacle
			if (bPointInCylinder || (angle < 16384) || (angle > 32768))  // haven't cleared the actor yet
			{
				if (TurnDirection == TURNING_Left)
					moveYaw = avoidYaw - 16384;
				else
					moveYaw = avoidYaw + 16384;
				Destination = Location + Vector(rot(0,1,0)*moveYaw)*400;
			}
			else  // cleared the actor -- move on
				TurnDirection = TURNING_None;
		}
	}

	if (TurnDirection == TURNING_None)
	{
		if (ObstacleTimer > 0)
		{
			TurnDirection = oldTurnDir;
			bClearedObstacle = true;
		}
	}
	else
		ObstacleTimer = 1.5;

	// Reset if done turning
	if (TurnDirection == TURNING_None)
	{
		NextDirection    = TURNING_None;
		ActorAvoiding    = None;
		bAdvancedTactics = false;
		ObstacleTimer    = 0;
		bClearedObstacle = true;

		if (oldTurnDir != TURNING_None)
			MoveTimer -= 4.0;
	}
}


// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------

function Frob(Actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	// Check to see if the Frobber is the player.  If so, then
	// check to see if we need to start a conversation.

	if (DeusExPlayer(Frobber) != None)
	{
		if (DeusExPlayer(Frobber).StartConversation(Self, IM_Frob))
		{
			ConversationActor = Pawn(Frobber);
			return;
		}
	}
}


// ----------------------------------------------------------------------
// StopBlendAnims()
// ----------------------------------------------------------------------

function StopBlendAnims()
{
	AIAddViewRotation = rot(0, 0, 0);
	Super.StopBlendAnims();
	PlayTurnHead(LOOK_Forward, 1.0, 1.0);
}


// ----------------------------------------------------------------------
// Falling()
// ----------------------------------------------------------------------

singular function Falling()
{
	if (bCanFly)
	{
		SetPhysics(PHYS_Flying);
		return;
	}
	// SetPhysics(PHYS_Falling); //note - done by default in physics
 	if (health > 0)
		SetFall();
}


// ----------------------------------------------------------------------
// SetFall()
// ----------------------------------------------------------------------

function SetFall()
{
	GotoState('FallingState');
}


// ----------------------------------------------------------------------
// LongFall()
// ----------------------------------------------------------------------

function LongFall()
{
	SetFall();
	GotoState('FallingState', 'LongFall');
}


// ----------------------------------------------------------------------
// HearNoise()
// ----------------------------------------------------------------------

function HearNoise(float Loudness, Actor NoiseMaker)
{
	// Do nothing
}


// ----------------------------------------------------------------------
// SeePlayer()
// ----------------------------------------------------------------------

function SeePlayer(Actor SeenPlayer)
{
	// Do nothing
}


// ----------------------------------------------------------------------
// Trigger()
// ----------------------------------------------------------------------

function Trigger( actor Other, pawn EventInstigator )
{
	// Do nothing
}


// ----------------------------------------------------------------------
// Reloading()
// ----------------------------------------------------------------------

function Reloading(DeusExWeapon reloadWeapon, float reloadTime)
{
	if (reloadWeapon == Weapon)
		ReloadTimer = reloadTime;
}


// ----------------------------------------------------------------------
// DoneReloading()
// ----------------------------------------------------------------------

function DoneReloading(DeusExWeapon reloadWeapon)
{
	if (reloadWeapon == Weapon)
		ReloadTimer = 0;
}


// ----------------------------------------------------------------------
// IsWeaponReloading()
// ----------------------------------------------------------------------

function bool IsWeaponReloading()
{
	return (ReloadTimer >= 0.1);
}


// ----------------------------------------------------------------------
// HandToHandAttack()
// ----------------------------------------------------------------------

function HandToHandAttack()
{
	local DeusExWeapon dxWeapon;

	dxWeapon = DeusExWeapon(Weapon);
	if (dxWeapon != None)
		dxWeapon.OwnerHandToHandAttack();
}


// ----------------------------------------------------------------------
// Killed()
// ----------------------------------------------------------------------

function Killed(pawn Killer, pawn Other, name damageType)
{
	if ((Enemy == Other) && (Other != None) && !Other.bIsPlayer)
		Enemy = None;
}


// ----------------------------------------------------------------------
// Died()
// ----------------------------------------------------------------------

function Died(pawn Killer, name damageType, vector HitLocation)
{
	local DeusExPlayer player;
	local name flagName;

	// Set a flag when NPCs die so we can possibly check it later
	player = DeusExPlayer(GetPlayerPawn());

	ExtinguishFire();

	// set the instigator to be the killer
	Instigator = Killer;

	if (player != None)
	{
		// Abort any conversation we may have been having with the NPC
		if (bInConversation)
			player.AbortConversation();

		// Abort any barks we may have been playing
		if (player.BarkManager != None)
			player.BarkManager.ScriptedPawnDied(Self);
	}

	Super.Died(Killer, damageType, HitLocation);  // bStunned is set here

	if (player != None)
	{
		if (bImportant)
		{
			flagName = player.rootWindow.StringToName(BindName$"_Dead");
			player.flagBase.SetBool(flagName, True);

			// make sure the flag never expires
			player.flagBase.SetExpiration(flagName, FLAG_Bool, 0);

			if (bStunned)
			{
				flagName = player.rootWindow.StringToName(BindName$"_Unconscious");
				player.flagBase.SetBool(flagName, True);

				// make sure the flag never expires
				player.flagBase.SetExpiration(flagName, FLAG_Bool, 0);
			}
		}
	}
}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
	bNotFirstDiffMod = true;
}

function RandomizeMods()                                                        //RSD: swap weapon mods in inventory
{
	local bool bMatchFound;
    local int i, invCount, weightCount, rnd;
    local class<Inventory> itemClass;
    local LootTableModGeneral LT;
    LT = Spawn(class'LootTableModGeneral');

    for (invCount=0;invCount<8;invCount++)
    {
    	bMatchFound = false;
        itemClass = InitialInventory[invCount].Inventory;

    	weightCount = 0;
    	for (i=0;i<ArrayCount(LT.entries);i++)
    	{
    	    weightCount += LT.entries[i].weight;
    	    if (itemClass != None && itemClass == LT.entries[i].item)
    	        bMatchFound = true;
    	}
    	if (bMatchFound)
    	{
    	    if (FRand() > LT.slotChance)
    	        break;
    	    rnd = Rand(weightCount);
    	    weightCount = 0;
    	    for (i=0;i<ArrayCount(LT.entries);i++)
    	    {
    	        weightCount += LT.entries[i].weight;
    	        if (rnd < weightCount)
    	        {
    	           InitialInventory[invCount].Inventory = LT.entries[i].item;
     	           break;
     	       }
    	    }
    	}
    }

    LT.Destroy();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// STATES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// state StartUp
//
// Initial state
// ----------------------------------------------------------------------

auto state StartUp
{
	function BeginState()
	{
		bInterruptState = true;
		bCanConverse = false;

		SetMovementPhysics();
		if (Physics == PHYS_Walking)
			SetPhysics(PHYS_Falling);

		bStasis = False;
		SetDistress(false);
		BlockReactions();
		ResetDestLoc();
	}

	function EndState()
	{
		bCanConverse = true;
		bStasis = True;
		ResetReactions();
	}

	function Tick(float deltaSeconds)
	{
		Global.Tick(deltaSeconds);
		if (LastRendered() <= 1.0)
		{
			PlayWaiting();
			InitializePawn();
			FollowOrders();
		}
	}

Begin:
	InitializePawn();

	Sleep(FRand()+0.2);
	WaitForLanding();

Start:
	FollowOrders();
}


// ----------------------------------------------------------------------
// state Paralyzed
//
// Do nothing -- ignore all
// (this state lets ViewModel work correctly)
// ----------------------------------------------------------------------

state Paralyzed
{
	ignores bump, frob, reacttoinjury;
	function BeginState()
	{
		StandUp();
		BlockReactions(true);
		bCanConverse = False;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}
	function EndState()
	{
		ResetReactions();
		bCanConverse = True;
	}

Begin:
	Acceleration=vect(0,0,0);
	PlayAnimPivot('Still');
}


// ----------------------------------------------------------------------
// state Idle
//
// Do nothing
// ----------------------------------------------------------------------

state Idle
{
	ignores bump, frob, reacttoinjury;
	function BeginState()
	{
		StandUp();
		BlockReactions(true);
		bCanConverse = False;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}
	function EndState()
	{
		ResetReactions();
		bCanConverse = True;
	}

Begin:
	Acceleration=vect(0,0,0);
	DesiredRotation=Rotation;
	PlayAnimPivot('Still');

Idle:
}


// ----------------------------------------------------------------------
// state Conversation
//
// Just sit here until the conversation is over
// ----------------------------------------------------------------------

state Conversation
{
	function Tick(float deltaTime)
	{
		Global.Tick(deltaTime);

		LipSynch(deltaTime);

		// Keep turning towards the person we're speaking to
		if (ConversationActor != None)
		{
			if (bSitting)
			{
				if (SeatActor != None)
					LookAtActor(ConversationActor, true, true, true, 0, 0.5, SeatActor.Rotation.Yaw+49152, 5461);
				else
					LookAtActor(ConversationActor, false, true, true, 0, 0.5);
			}
			else
				LookAtActor(ConversationActor, true, true, true, 0, 0.5);
		}
	}

	function LoopHeadConvoAnim()
	{
	}

	function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
	{
		local DeusExPlayer dxPlayer;

		dxPlayer = DeusExPlayer(GetPlayerPawn());
		if (dxPlayer != None)
			if (dxPlayer.ConPlay != None)
				if (dxPlayer.ConPlay.GetForcePlay())
				{
					Global.SetOrders(orderName, newOrderTag, bImmediate);
					return;
				}

		ConvOrders   = orderName;
		ConvOrderTag = newOrderTag;
	}

	function FollowOrders(optional bool bDefer)
	{
		local name tempConvOrders, tempConvOrderTag;

		// hack
		tempConvOrders   = ConvOrders;
		tempConvOrderTag = ConvOrderTag;
		ResetConvOrders();  // must do this before calling SetOrders(), or recursion will result

		if (tempConvOrders != '')
			Global.SetOrders(tempConvOrders, tempConvOrderTag, true);
		else
			Global.FollowOrders(bDefer);
	}

	function BeginState()
	{
		local DeusExPlayer dxPlayer;
		local bool         bBlock;

		ResetConvOrders();
		EnableCheckDestLoc(false);

		bBlock = True;
		dxPlayer = DeusExPlayer(GetPlayerPawn());
		if (dxPlayer != None)
			if (dxPlayer.ConPlay != None)
				if (dxPlayer.ConPlay.CanInterrupt())
					bBlock = False;

		bInterruptState = True;
		if (bBlock)
		{
			bCanConverse = False;
			MakePawnIgnored(true);
			BlockReactions(true);
		}
		else
		{
			bCanConverse = True;
			MakePawnIgnored(true);
			BlockReactions(false);
		}

		// Check if the current state is "WaitingFor", "RunningTo" or "GoingTo", in which case
		// we want the orders to be 'Standing' after the conversation is over.  UNLESS the
		// ScriptedPawn was going somewhere else (OrderTag != '')

		if (((Orders == 'WaitingFor') || (Orders == 'RunningTo') || (Orders == 'GoingTo')) && (OrderTag == ''))
			SetOrders('Standing');

		bConversationEndedNormally = False;
		bInConversation = True;
		bStasis = False;
		SetDistress(false);
		SeekPawn = None;
	}

	function EndState()
	{
		local DeusExPlayer player;
		local bool         bForcePlay;

		bForcePlay = false;
		player = DeusExPlayer(GetPlayerPawn());
		if (player != None)
			if (player.conPlay != None)
				bForcePlay = player.conPlay.GetForcePlay();

		bConvEndState = true;
		if (!bForcePlay && (bConversationEndedNormally != True))
			player.AbortConversation();
		bConvEndState = false;
		ResetConvOrders();

		StopBlendAnims();
		bInterruptState = true;
		bCanConverse    = True;
		MakePawnIgnored(false);
		ResetReactions();
		bStasis = True;
		ConversationActor = None;
	}

Begin:

	Acceleration = vect(0,0,0);

	DesiredRotation.Pitch = 0;
	if (!bSitting && !bDancing)
		PlayWaiting();

	// we are now idle
}


// ----------------------------------------------------------------------
// state FirstPersonConversation
//
// Just sit here until the conversation is over
// ----------------------------------------------------------------------

state FirstPersonConversation
{
	function Tick(float deltaTime)
	{
		Global.Tick(deltaTime);

		LipSynch(deltaTime);

		// Keep turning towards the person we're speaking to
		if (ConversationActor != None)
		{
			if (bSitting)
			{
				if (SeatActor != None)
					LookAtActor(ConversationActor, true, true, true, 0, 1.0, SeatActor.Rotation.Yaw+49152, 5461);
				else
					LookAtActor(ConversationActor, false, true, true, 0, 1.0);
			}
			else
				LookAtActor(ConversationActor, true, true, true, 0, 1.0);
		}
	}

	function LoopHeadConvoAnim()
	{
	}

	function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
	{
		ConvOrders   = orderName;
		ConvOrderTag = newOrderTag;
	}

	function FollowOrders(optional bool bDefer)
	{
		local name tempConvOrders, tempConvOrderTag;

		// hack
		tempConvOrders   = ConvOrders;
		tempConvOrderTag = ConvOrderTag;
		ResetConvOrders();  // must do this before calling SetOrders(), or recursion will result

		if (tempConvOrders != '')
			Global.SetOrders(tempConvOrders, tempConvOrderTag, true);
		else
			Global.FollowOrders(bDefer);
	}

	function BeginState()
	{
		local DeusExPlayer dxPlayer;
		local bool         bBlock;

		ResetConvOrders();
		EnableCheckDestLoc(false);

		dxPlayer = DeusExPlayer(GetPlayerPawn());
		/*
		bBlock = True;
		if (dxPlayer != None)
			if (dxPlayer.ConPlay != None)
				if (dxPlayer.ConPlay.CanInterrupt())
					bBlock = False;
		*/

		// 1st-person conversations will no longer block;
		// left old code in here in case people change their minds :)

		bBlock = false;

		bInterruptState = True;
		if (bBlock)
		{
			bCanConverse = False;
			MakePawnIgnored(true);
			BlockReactions(true);
		}
		else
		{
			bCanConverse = True;
			MakePawnIgnored(false);
			if ((dxPlayer != None) && (dxPlayer.conPlay != None) &&
			    dxPlayer.conPlay.con.IsSpeakingActor(dxPlayer))
				SetReactions(false, false, false, false, true, false, false, true, false, false, true, true);
			else
				ResetReactions();
		}

		bConversationEndedNormally = False;
		bInConversation = True;
		bStasis = False;
		SetDistress(false);
		SeekPawn = None;
	}

	function EndState()
	{
		local DeusExPlayer player;

		bConvEndState = true;
		if (bConversationEndedNormally != True)
		{
			player = DeusExPlayer(GetPlayerPawn());
			player.AbortConversation();
		}
		bConvEndState = false;
		ResetConvOrders();

		StopBlendAnims();
		bInterruptState = true;
		bCanConverse    = True;
		MakePawnIgnored(false);
		ResetReactions();
		bStasis = True;
		ConversationActor = None;
	}

Begin:

	Acceleration = vect(0,0,0);

	DesiredRotation.Pitch = 0;
	if (!bSitting && !bDancing)
		PlayWaiting();

	// we are now idle
}


// ----------------------------------------------------------------------
// EnterConversationState()
// ----------------------------------------------------------------------

function EnterConversationState(bool bFirstPerson, optional bool bAvoidState)
{
	// First check to see if we're already in a conversation state,
	// in which case we'll abort immediately

	if ((GetStateName() == 'Conversation') || (GetStateName() == 'FirstPersonConversation'))
		return;

	SetNextState(GetStateName(), 'Begin');

	// If bAvoidState is set, then we don't want to jump into the conversaton state
	// for the ScriptedPawn, because bad things might happen otherwise.

	if (!bAvoidState)
	{
		if (bFirstPerson)
			GotoState('FirstPersonConversation');
		else
			GotoState('Conversation');
	}
}


// ----------------------------------------------------------------------
// state Standing
//
// Just kinda stand there and do nothing.
// (similar to Wandering, except the pawn doesn't actually move)
// ----------------------------------------------------------------------

state Standing
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Standing', 'ContinueStand');
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Tick(float deltaSeconds)
	{
		animTimer[1] += deltaSeconds;
		Global.Tick(deltaSeconds);
	}

	function BeginState()
	{
		StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;

		bStasis = False;

		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;
		bStasis = True;

		StopBlendAnims();
	}

Begin:
	WaitForLanding();
	if (!bUseHome)
		Goto('StartStand');

MoveToBase:
	if (!IsPointInCylinder(self, HomeLoc, 16-CollisionRadius))
	{
		EnableCheckDestLoc(true);
		while (true)
		{
			if (PointReachable(HomeLoc))
			{
				if (ShouldPlayWalk(HomeLoc))
					PlayWalking();
				MoveTo(HomeLoc, GetWalkingSpeed());
				CheckDestLoc(HomeLoc);
				break;
			}
			else
			{
				MoveTarget = FindPathTo(HomeLoc);
				if (MoveTarget != None)
				{
					if (ShouldPlayWalk(MoveTarget.Location))
						PlayWalking();
					MoveToward(MoveTarget, GetWalkingSpeed());
					CheckDestLoc(MoveTarget.Location, true);
				}
				else
					break;
			}
		}
		EnableCheckDestLoc(false);
	}
	TurnTo(Location+HomeRot);

StartStand:
	Acceleration=vect(0,0,0);
	Goto('Stand');

ContinueFromDoor:
	Goto('MoveToBase');

Stand:
ContinueStand:
	// nil
	bStasis = True;

	PlayWaiting();
	if (!bPlayIdle)
		Goto('DoNothing');
	Sleep(FRand()*14+8);

Fidget:
	if (FRand() < 0.5)
	{
		PlayIdle();
		FinishAnim();
	}
	else
	{
		if (FRand() > 0.5)
		{
			PlayTurnHead(LOOK_Up, 1.0, 1.0);
			Sleep(2.0);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
		else if (FRand() > 0.5)
		{
			PlayTurnHead(LOOK_Left, 1.0, 1.0);
			Sleep(1.5);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.9);
			PlayTurnHead(LOOK_Right, 1.0, 1.0);
			Sleep(1.2);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
		else
		{
			PlayTurnHead(LOOK_Right, 1.0, 1.0);
			Sleep(1.5);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.9);
			PlayTurnHead(LOOK_Left, 1.0, 1.0);
			Sleep(1.2);
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
	}
	if (FRand() < 0.3)
		PlayIdleSound();
	Goto('Stand');

DoNothing:
	// nil
}


// ----------------------------------------------------------------------
// state Dancing
//
// Dance in place.
// (Most of this code was ripped from Standing)
// ----------------------------------------------------------------------

state Dancing
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Dancing', 'ContinueDance');
	}

	function AnimEnd()
	{
		PlayDancing();
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function BeginState()
	{
		if (bSitting && !bDancing)
			StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;

		bStasis = False;

		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;
		bStasis = True;

		StopBlendAnims();
	}

Begin:
	WaitForLanding();
	if (bDancing)
	{
		if (bUseHome)
			TurnTo(Location+HomeRot);
		Goto('StartDance');
	}
	if (!bUseHome)
		Goto('StartDance');

MoveToBase:
	if (!IsPointInCylinder(self, HomeLoc, 16-CollisionRadius))
	{
		EnableCheckDestLoc(true);
		while (true)
		{
			if (PointReachable(HomeLoc))
			{
				if (ShouldPlayWalk(HomeLoc))
					PlayWalking();
				MoveTo(HomeLoc, GetWalkingSpeed());
				CheckDestLoc(HomeLoc);
				break;
			}
			else
			{
				MoveTarget = FindPathTo(HomeLoc);
				if (MoveTarget != None)
				{
					if (ShouldPlayWalk(MoveTarget.Location))
						PlayWalking();
					MoveToward(MoveTarget, GetWalkingSpeed());
					CheckDestLoc(MoveTarget.Location, true);
				}
				else
					break;
			}
		}
		EnableCheckDestLoc(false);
	}
	TurnTo(Location+HomeRot);

StartDance:
	Acceleration=vect(0,0,0);
	Goto('Dance');

ContinueFromDoor:
	Goto('MoveToBase');

Dance:
ContinueDance:
	// nil
	bDancing = True;
	PlayDancing();
	bStasis = True;
	if (!bHokeyPokey)
		Goto('DoNothing');

Spin:
	Sleep(FRand()*5+5);
	useRot = DesiredRotation;
	if (FRand() > 0.5)
	{
		TurnTo(Location+1000*vector(useRot+rot(0,16384,0)));
		TurnTo(Location+1000*vector(useRot+rot(0,32768,0)));
		TurnTo(Location+1000*vector(useRot+rot(0,49152,0)));
	}
	else
	{
		TurnTo(Location+1000*vector(useRot+rot(0,49152,0)));
		TurnTo(Location+1000*vector(useRot+rot(0,32768,0)));
		TurnTo(Location+1000*vector(useRot+rot(0,16384,0)));
	}
	TurnTo(Location+1000*vector(useRot));
	Goto('Spin');

DoNothing:
	// nil
}


// ----------------------------------------------------------------------
// state Sitting
//
// Just kinda sit there and do nothing.
// (doubles as a shitting state)
// ----------------------------------------------------------------------

state Sitting
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Sitting', 'ContinueSit');
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		if (!bAcceptBump)
			NextDirection = TURNING_None;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool HandleTurn(Actor Other)
	{
		if (Other == SeatActor)
			return true;
		else
			return Global.HandleTurn(Other);
	}

	function Bump(actor bumper)
	{
		// If we hit our chair, move to the right place
		if ((bumper == SeatActor) && bAcceptBump)
		{
			bAcceptBump = false;
			GotoState('Sitting', 'CircleToFront');
		}

		// Handle conversations, if need be
		else
			Global.Bump(bumper);
	}

	function Tick(float deltaSeconds)
	{
		local vector endPos;
		local vector newPos;
		local float  delta;

		Global.Tick(deltaSeconds);

		if (bSitInterpolation && (SeatActor != None))
		{
			endPos = SitPosition(SeatActor, SeatSlot);
			if ((deltaSeconds < remainingSitTime) && (remainingSitTime > 0))
			{
				delta = deltaSeconds/remainingSitTime;
				newPos = (endPos-Location)*delta + Location;
				remainingSitTime -= deltaSeconds;
			}
			else
			{
				remainingSitTime = 0;
				bSitInterpolation = false;
				newPos = endPos;
				Acceleration = vect(0,0,0);
				Velocity = vect(0,0,0);
				SetBase(SeatActor);
				bSitting = true;
			}
			SetLocation(newPos);
			DesiredRotation = SeatActor.Rotation+Rot(0, -16384, 0);
		}
	}

	function Vector SitPosition(Seat seatActor, int slot)
	{
		local float newAssHeight;

		newAssHeight = GetDefaultCollisionHeight() + BaseAssHeight;
		newAssHeight = -(CollisionHeight - newAssHeight);

		return ((seatActor.sitPoint[slot]>>seatActor.Rotation)+seatActor.Location+(vect(0,0,-1)*newAssHeight));
	}

	function vector GetDestinationPosition(Seat seatActor, optional float extraDist)
	{
		local Rotator seatRot;
		local Vector  destPos;

		if (seatActor == None)
			return (Location);

		seatRot = seatActor.Rotation + Rot(0, -16384, 0);
		seatRot.Pitch = 0;
		destPos = seatActor.Location;
		destPos += vect(0,0,1)*(CollisionHeight-seatActor.CollisionHeight);
		destPos += Vector(seatRot)*(seatActor.CollisionRadius+CollisionRadius+extraDist);

		return (destPos);
	}

	function bool IsIntersectingSeat()
	{
		local bool   bIntersect;
		local vector testVector;

		bIntersect = false;
		if (SeatActor != None)
			bIntersect = IsOverlapping(SeatActor);

		return (bIntersect);
	}

	function int FindBestSlot(Seat seatActor, out float slotDist)
	{
		local int   bestSlot;
		local float dist;
		local float bestDist;
		local int   i;

		bestSlot = -1;
		bestDist = 100;
		if (!seatActor.Region.Zone.bWaterZone)
		{
			for (i=0; i<seatActor.numSitPoints; i++)
			{
				if (seatActor.sittingActor[i] == None)
				{
					dist = VSize(SitPosition(seatActor, i) - Location);
					if ((bestSlot < 0) || (bestDist > dist))
					{
						bestDist = dist;
						bestSlot = i;
					}
				}
			}
		}

		slotDist = bestDist;

		return (bestSlot);
	}

	function FindBestSeat()
	{
		local Seat  curSeat;
		local Seat  bestSeat;
		local float curDist;
		local float bestDist;
		local int   curSlot;
		local int   bestSlot;
		local bool  bTry;

		if (bUseFirstSeatOnly && bSeatHackUsed)
		{
			bestSeat = SeatHack;  // use the seat hack
			bestSlot = -1;
			if (!IsSeatValid(bestSeat))
				bestSeat = None;
			else
			{
				if (GetNextWaypoint(bestSeat) == None)
					bestSeat = None;
				else
				{
					bestSlot = FindBestSlot(bestSeat, curDist);
					if (bestSlot < 0)
						bestSeat = None;
				}
			}
		}
		else
		{
			bestSeat = Seat(OrderActor);  // try the ordered seat first
			if (bestSeat != None)
			{
				if (!IsSeatValid(OrderActor))
					bestSeat = None;
				else
				{
					if (GetNextWaypoint(bestSeat) == None)
						bestSeat = None;
					else
					{
						bestSlot = FindBestSlot(bestSeat, curDist);
						if (bestSlot < 0)
							bestSeat = None;
					}
				}
			}
			if (bestSeat == None)
			{
				bestDist = 10001;
				bestSlot = -1;
				foreach RadiusActors(Class'Seat', curSeat, 10000)
				{
					if (IsSeatValid(curSeat))
					{
						curSlot = FindBestSlot(curSeat, curDist);
						if (curSlot >= 0)
						{
							if (bestDist > curDist)
							{
								if (GetNextWaypoint(curSeat) != None)
								{
									bestDist = curDist;
									bestSeat = curSeat;
									bestSlot = curSlot;
								}
							}
						}
					}
				}
			}
		}

		if (bestSeat != None)
		{
			bestSeat.sittingActor[bestSlot] = self;
			SeatLocation       = bestSeat.Location;
			bSeatLocationValid = true;
		}
		else
			bSeatLocationValid = false;

		if (bUseFirstSeatOnly && !bSeatHackUsed)
		{
			SeatHack      = bestSeat;
			bSeatHackUsed = true;
		}

		SeatActor = bestSeat;
		SeatSlot  = bestSlot;
	}

	function FollowSeatFallbackOrders()
	{
		FindBestSeat();
		if (IsSeatValid(SeatActor))
			GotoState('Sitting', 'Begin');
		else
			GotoState('Wandering');
	}

	function BeginState()
	{
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;

		bAcceptBump = True;

		if (SeatActor == None)
			FindBestSeat();

		bSitInterpolation = false;

		bStasis = False;

		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		if (!bSitting)
			StandUp();

		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;

		bSitInterpolation = false;

		bStasis = True;
	}

Begin:
	WaitForLanding();
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	if (!bSitting)
		WaitForLanding();
	else
	{
		TurnTo(Vector(SeatActor.Rotation+Rot(0, -16384, 0))*100+Location);
		Goto('ContinueSitting');
	}

MoveToSeat:
	if (IsIntersectingSeat())
		Goto('MoveToPosition');
	bAcceptBump = true;
	while (true)
	{
		if (!IsSeatValid(SeatActor))
			FollowSeatFallbackOrders();
		destLoc = GetDestinationPosition(SeatActor);
		if (PointReachable(destLoc))
		{
			if (ShouldPlayWalk(destLoc))
				PlayWalking();
			MoveTo(destLoc, GetWalkingSpeed());
			CheckDestLoc(destLoc);

			if (IsPointInCylinder(self, GetDestinationPosition(SeatActor), 16, 16))
			{
				bAcceptBump = false;
				Goto('MoveToPosition');
				break;
			}
		}
		else
		{
			MoveTarget = GetNextWaypoint(SeatActor);
			if (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
				CheckDestLoc(MoveTarget.Location, true);
			}
			else
				break;
		}
	}

CircleToFront:
	bAcceptBump = false;
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	if (ShouldPlayWalk(GetDestinationPosition(SeatActor, 16)))
		PlayWalking();
	MoveTo(GetDestinationPosition(SeatActor, 16), GetWalkingSpeed());

MoveToPosition:
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	bSitting = true;
	EnableCollision(false);
	Acceleration=vect(0,0,0);

Sit:
	Acceleration=vect(0,0,0);
	Velocity=vect(0,0,0);
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	remainingSitTime = 0.8;
	PlaySittingDown();
	SetBasedPawnSize(CollisionRadius, GetSitHeight());
	SetPhysics(PHYS_Flying);
	StopStanding();
	bSitInterpolation = true;
	while (bSitInterpolation)
		Sleep(0);
	FinishAnim();
	Goto('ContinueSitting');

ContinueFromDoor:
	Goto('MoveToSeat');

ContinueSitting:
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	SetBasedPawnSize(CollisionRadius, GetSitHeight());
	SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
	PlaySitting();
	bStasis  = True;
	// nil

}


// ----------------------------------------------------------------------
// state HandlingEnemy
//
// Fight-or-flight state
// ----------------------------------------------------------------------

state HandlingEnemy
{
	function BeginState()
	{
		if (Enemy == None)
			GotoState('Seeking');
		else if (RaiseAlarm == RAISEALARM_BeforeAttacking)
			GotoState('Alerting');
		else
			GotoState('Attacking');
	}

Begin:

}

// ----------------------------------------------------------------------
// state Wandering
//
// Meander from place to place, occasionally gazing into the middle
// distance.
// ----------------------------------------------------------------------

state Wandering
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Wandering', 'ContinueWander');
	}

	function Bump(actor bumper)
	{
		if (bAcceptBump)
		{
			// If we get bumped by another actor while we wait, start wandering again
			bAcceptBump = False;
			Disable('AnimEnd');
			GotoState('Wandering', 'Wander');
		}

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool GoHome()
	{
		if (bUseHome && !IsNearHome(Location))
		{
			destLoc   = HomeLoc;
			destPoint = None;
			if (PointReachable(destLoc))
				return true;
			else
			{
				MoveTarget = FindPathTo(destLoc);
				if (MoveTarget != None)
					return true;
				else
					return false;
			}
		}
		else
			return false;
	}

	function PickDestination()
	{
		local WanderCandidates candidates[5];
		local int              candidateCount;
		local int              maxCandidates;
		local int              maxLastPoints;

		local WanderPoint curPoint;
		local Actor       wayPoint;
		local int         i;
		local int         openSlot;
		local float       maxDist;
		local float       dist;
		local float       angle;
		local float       magnitude;
		local int         iterations;
		local bool        bSuccess;
		local Rotator     rot;

		maxCandidates = 4;  // must be <= size of candidates[] array
		maxLastPoints = 2;  // must be <= size of lastPoints[] array

		for (i=0; i<maxCandidates; i++)
			candidates[i].dist = 100000;
		candidateCount = 0;

		// A certain percentage of the time, we want to angle off to a random direction...
		if ((RandomWandering < 1) && (FRand() > RandomWandering))
		{
			// Fill the candidate table
			foreach RadiusActors(Class'WanderPoint', curPoint, 3000*wanderlust+1000)  // 1000-4000
			{
				// Make sure we haven't been here recently
				for (i=0; i<maxLastPoints; i++)
				{
					if (lastPoints[i] == curPoint)
						break;
				}

				if (i >= maxLastPoints)
				{
					// Can we get there from here?
					wayPoint = GetNextWaypoint(curPoint);

					if ((wayPoint != None) && !IsNearHome(curPoint.Location))
						wayPoint = None;

					// Yep
					if (wayPoint != None)
					{
						// Find an empty slot for this candidate
						openSlot = -1;
						dist     = VSize(curPoint.location - location);
						maxDist  = dist;

						// This candidate will only replace more distant candidates...
						for (i=0; i<maxCandidates; i++)
						{
							if (maxDist < candidates[i].dist)
							{
								maxDist  = candidates[i].dist;
								openSlot = i;
							}
						}

						// Put the candidate in the (unsorted) list
						if (openSlot >= 0)
						{
							candidates[openSlot].point    = curPoint;
							candidates[openSlot].waypoint = wayPoint;
							candidates[openSlot].dist     = dist;
							if (candidateCount < maxCandidates)
								candidateCount++;
						}
					}
				}
			}
		}

		// Shift our list of recently visited points
		for (i=maxLastPoints-1; i>0; i--)
			lastPoints[i] = lastPoints[i-1];
		lastPoints[0] = None;

		// Do we have a list of candidates?
		if (candidateCount > 0)
		{
			// Pick a candidate at random
			i = Rand(candidateCount);
			curPoint = candidates[i].point;
			wayPoint = candidates[i].waypoint;
			lastPoints[0] = curPoint;
			MoveTarget    = wayPoint;
			destPoint     = curPoint;
		}

		// No candidates -- find a random place to go
		else
		{
			MoveTarget = None;
			destPoint  = None;
			iterations = 6;  // try up to 6 different directions
			while (iterations > 0)
			{
				// How far will we go?
				magnitude = (wanderlust*400+200) * (FRand()*0.2+0.9); // 200-600, +/-10%

				// Choose our destination, based on whether we have a home base
				if (!bUseHome)
					bSuccess = AIPickRandomDestination(100, magnitude, 0, 0, 0, 0, 1,
					                                   FRand()*0.4+0.35, destLoc);
				else
				{
					if (magnitude > HomeExtent)
						magnitude = HomeExtent*(FRand()*0.2+0.9);
					rot = Rotator(HomeLoc-Location);
					bSuccess = AIPickRandomDestination(50, magnitude, rot.Yaw, 0.25, rot.Pitch, 0.25, 1,
					                                   FRand()*0.4+0.35, destLoc);
				}

				// Success?  Break out of the iteration loop
				if (bSuccess)
					if (IsNearHome(destLoc))
						break;

				// We failed -- try again
				iterations--;
			}

			// If we got a destination, go there
			if (iterations <= 0)
				destLoc = Location;
		}
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;
		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		local int i;
		bAcceptBump = True;

		EnableCheckDestLoc(false);

		// Clear out our list of last visited points
		for (i=0; i<ArrayCount(lastPoints); i++)
			lastPoints[i] = None;

		if (JumpZ > 0)
			bCanJump = true;
	}

Begin:
	destPoint = None;

GoHome:
	bAcceptBump = false;
	WaitForLanding();
	if (!GoHome())
		Goto('WanderInternal');

MoveHome:
	EnableCheckDestLoc(true);
	while (true)
	{
		if (PointReachable(destLoc))
		{
			if (ShouldPlayWalk(destLoc))
				PlayWalking();
			MoveTo(destLoc, GetWalkingSpeed());
			CheckDestLoc(destLoc);
			break;
		}
		else
		{
			MoveTarget = FindPathTo(destLoc);
			if (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
				CheckDestLoc(MoveTarget.Location, true);
			}
			else
				break;
		}
	}
	EnableCheckDestLoc(false);
	Goto('Pausing');

Wander:
	WaitForLanding();
WanderInternal:
	PickDestination();

Moving:
	// Move from pathnode to pathnode until we get where we're going
	// (ooooold code -- no longer used)
	if (destPoint != None)
	{
		if (ShouldPlayWalk(MoveTarget.Location))
			PlayWalking();
		MoveToward(MoveTarget, GetWalkingSpeed());
		while ((MoveTarget != None) && (MoveTarget != destPoint))
		{
			MoveTarget = FindPathToward(destPoint);
			if (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
			}
		}
	}
	else if (destLoc != Location)
	{
		if (ShouldPlayWalk(destLoc))
			PlayWalking();
		MoveTo(destLoc, GetWalkingSpeed());
	}
	else
		Sleep(0.5);

Pausing:
	Acceleration = vect(0, 0, 0);

	// Turn in the direction dictated by the WanderPoint, if there is one
	sleepTime = 6.0;
	if (WanderPoint(destPoint) != None)
	{
		if (WanderPoint(destPoint).gazeItem != None)
		{
			TurnToward(WanderPoint(destPoint).gazeItem);
			sleepTime = WanderPoint(destPoint).gazeDuration;
		}
		else if (WanderPoint(destPoint).gazeDirection != vect(0, 0, 0))
			TurnTo(Location + WanderPoint(destPoint).gazeDirection);
	}
	Enable('AnimEnd');
	TweenToWaiting(0.2);
	bAcceptBump = True;
	PlayScanningSound();
	sleepTime *= (-0.9*restlessness) + 1;
	Sleep(sleepTime);
	Disable('AnimEnd');
	bAcceptBump = False;
	FinishAnim();
	Goto('Wander');

ContinueWander:
ContinueFromDoor:
	FinishAnim();
	PlayWalking();
	Goto('Wander');
}


// ----------------------------------------------------------------------
// state Leaving
//
// Just like Patrolling, but make the pawn transient.
// ----------------------------------------------------------------------

State Leaving
{
	function BeginState()
	{
		bTransient = True;  // this pawn will be destroyed when it gets out of range
		bDisappear = True;
		GotoState('Patrolling');
	}

Begin:
	// shouldn't ever reach this point
}


// ----------------------------------------------------------------------
// state Patrolling
//
// Move from point to point in a predescribed pattern.
// ----------------------------------------------------------------------

State Patrolling
{
	function SetFall()
	{
		StartFalling('Patrolling', 'ContinuePatrol');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function PatrolPoint PickStartPoint()
	{
		local NavigationPoint nav;
		local PatrolPoint     curNav;
		local float           curDist;
		local PatrolPoint     closestNav;
		local float           closestDist;

		nav = Level.NavigationPointList;
		while (nav != None)
		{
			nav.visitedWeight = 0;
			nav = nav.nextNavigationPoint;
		}

		closestNav  = None;
		closestDist = 100000;
		nav = Level.NavigationPointList;
		while (nav != None)
		{
			curNav = PatrolPoint(nav);
			if ((curNav != None) && (curNav.Tag == OrderTag))
			{
				while (curNav != None)
				{
					if (curNav.visitedWeight != 0)  // been here before
						break;
					curDist = VSize(Location - curNav.Location);
					if ((closestNav == None) || (closestDist > curDist))
					{
						closestNav  = curNav;
						closestDist = curDist;
					}
					curNav.visitedWeight = 1;
					curNav = curNav.NextPatrolPoint;
				}
			}
			nav = nav.nextNavigationPoint;
		}

		return (closestNav);
	}

	function PickDestination()
	{
		if (PatrolPoint(destPoint) != None)
			destPoint = PatrolPoint(destPoint).NextPatrolPoint;
		else
			destPoint = PickStartPoint();
		if (destPoint == None)  // can't go anywhere...
			GotoState('Standing');
	}

	function BeginState()
	{
		StandUp();
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		SetupWeapon(false);
		SetDistress(false);
		bStasis = false;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		Enable('AnimEnd');
		bStasis = true;
	}

Begin:
	destPoint = None;

Patrol:
	//Disable('Bump');
	WaitForLanding();
	PickDestination();

Moving:
	// Move from pathnode to pathnode until we get where we're going
	if (destPoint != None)
	{
		if (!IsPointInCylinder(self, destPoint.Location, 16-CollisionRadius))
		{
			EnableCheckDestLoc(true);
			MoveTarget = FindPathToward(destPoint);
			while (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
				CheckDestLoc(MoveTarget.Location, true);
				if (MoveTarget == destPoint)
					break;
				MoveTarget = FindPathToward(destPoint);
			}
			EnableCheckDestLoc(false);
		}
	}
	else
		Goto('Patrol');

Pausing:
	if (!bAlwaysPatrol)
		bStasis = true;
	Acceleration = vect(0, 0, 0);

	// Turn in the direction dictated by the WanderPoint, or a random direction
	if (PatrolPoint(destPoint) != None)
	{
		if ((PatrolPoint(destPoint).pausetime > 0) || (PatrolPoint(destPoint).NextPatrolPoint == None))
		{
			if (ShouldPlayTurn(Location + PatrolPoint(destPoint).lookdir))
				PlayTurning();
			TurnTo(Location + PatrolPoint(destPoint).lookdir);
			Enable('AnimEnd');
			TweenToWaiting(0.2);
			PlayScanningSound();
			//Enable('Bump');
			sleepTime = PatrolPoint(destPoint).pausetime * ((-0.9*restlessness) + 1);
			Sleep(sleepTime);
			Disable('AnimEnd');
			//Disable('Bump');
			FinishAnim();
		}
	}
	Goto('Patrol');

ContinuePatrol:
ContinueFromDoor:
	FinishAnim();
	PlayWalking();
	Goto('Moving');

}


// ----------------------------------------------------------------------
// state Seeking
//
// Look for enemies in the area
// ----------------------------------------------------------------------

State Seeking
{

	function SetFall()
	{
		StartFalling('Seeking', 'ContinueSeek');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool GetNextLocation(out vector nextLoc)
	{
		local float   dist;
		local rotator rotation;
		local bool    bDone;
		local float   seekDistance;
		local Actor   hitActor;
		local vector  HitLocation, HitNormal;
		local vector  diffVect;
		local bool    bLOS;

		if (bSeekLocation)
		{
			if (SeekType == SEEKTYPE_Guess)
				seekDistance = (200+FClamp(GroundSpeed*EnemyLastSeen*0.5, 0, 1000));
			else
				seekDistance = 300;
		}
		else
			seekDistance = 60;

		dist  = VSize(Location-destLoc);
		bDone = false;
		bLOS  = false;

		if (dist < seekDistance)
		{
			bLOS = true;
			foreach TraceVisibleActors(Class'Actor', hitActor, hitLocation, hitNormal,
			                           destLoc, Location+vect(0,0,1)*BaseEyeHeight)
			{
				if (hitActor != self)
				{
					if (hitActor == Level)
						bLOS = false;
					else if (IsPointInCylinder(hitActor, destLoc, 16, 16))
						break;
					else if (hitActor.bBlockSight && !hitActor.bHidden)
						bLOS = false;
				}
				if (!bLOS)
					break;
			}
		}

		if (!bLOS)
		{
			if (PointReachable(destLoc))
			{
				rotation = Rotator(destLoc - Location);
				if (seekDistance == 0)
					nextLoc = destLoc;
				else if (!AIDirectionReachable(destLoc, rotation.Yaw, rotation.Pitch, 0, seekDistance, nextLoc))
					bDone = true;
				if (!bDone && bDefendHome && !IsNearHome(nextLoc))
					bDone = true;
				if (!bDone)  // hack, because Unreal's movement code SUCKS
				{
					diffVect = nextLoc - Location;
					if (Physics == PHYS_Walking)
						diffVect *= vect(1,1,0);
					if (VSize(diffVect) < 20)
						bDone = true;
					else if (IsPointInCylinder(self, nextLoc, 10, 10))
						bDone = true;
				}
			}
			else
			{
				MoveTarget = FindPathTo(destLoc);
				if (MoveTarget == None)
					bDone = true;
				else if (bDefendHome && !IsNearHome(MoveTarget.Location))
					bDone = true;
				else
					nextLoc = MoveTarget.Location;
			}
		}
		else
			bDone = true;

		return (!bDone);
	}

	function bool PickDestination()
	{
		local bool bValid;

		bValid = false;
		if (/*(EnemyLastSeen <= 25.0) &&*/ (SeekLevel > 0))
		{
			if (bSeekLocation)
			{
				bValid  = true;
				destLoc = LastSeenPos;
			}
			else
			{
				bValid = AIPickRandomDestination(130, 320, 0, 0, 0, 0, 2, 1.0, destLoc);  //CyberP: param 2 was 250
				if (!bValid)
				{
					bValid  = true;
					destLoc = Location + VRand()*50;
				}
				else
					destLoc += vect(0,0,1)*BaseEyeHeight;
			}
		}

		return (bValid);
	}

	function NavigationPoint GetOvershootDestination(float randomness, optional float focus)
	{
		local NavigationPoint navPoint, bestPoint;
		local float           distance;
		local float           score, bestScore;
		local int             yaw;
		local rotator         rot;
		local float           yawCutoff;

		if (focus <= 0)
			focus = 0.6;

		yawCutoff = int(32768*focus);
		bestPoint = None;
		bestScore = 0;

		foreach ReachablePathnodes(Class'NavigationPoint', navPoint, None, distance)
		{
			if (distance < 1)
				distance = 1;
			rot = Rotator(navPoint.Location-Location);
			yaw = rot.Yaw + (16384*randomness);
			yaw = (yaw-Rotation.Yaw) & 0xFFFF;
			if (yaw > 32767)
				yaw  -= 65536;
			yaw = abs(yaw);
			if (yaw <= yawCutoff)
			{
				score = yaw/distance;
				if ((bestPoint == None) || (score < bestScore))
				{
					bestPoint = navPoint;
					bestScore = score;
				}
			}
		}

		return bestPoint;
	}

	function Tick(float deltaSeconds)
	{
		animTimer[1] += deltaSeconds;
		Global.Tick(deltaSeconds);
		UpdateActorVisibility(Enemy, deltaSeconds, 0.5, true); //CyberP: was 1.0
	}

	function HandleLoudNoise(Name event, EAIEventState state, XAIParams params)
	{
		local Actor bestActor;
		local Pawn  instigator;
        local float locDiff;

		if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
		{
			bestActor = params.bestActor;
			if ((bestActor != None) && (EnemyLastSeen > 2.0))
			{
				instigator = Pawn(bestActor);
				if (instigator == None)
					instigator = bestActor.Instigator;
				if (instigator != None)
				{
					if (IsValidEnemy(instigator))
					{
						SetSeekLocation(instigator, bestActor.Location, SEEKTYPE_Sound);
						destLoc = LastSeenPos;
						locDiff = Abs(VSize(instigator.Location - Location));
						if (bInterruptSeek && locDiff > 416) //CyberP: only turn around when close range
							GotoState('Seeking', 'GoToLocation');
					}
				}
			}
		}
	}
//GMDX: HandleGenericNoise test
	function HandleGenericNoise(Name event, EAIEventState state, XAIParams params)
	{
		local Actor bestActor;
		local Pawn  instigator;

		if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
		{
			bestActor = params.bestActor;

			if ((bestActor != None) && (EnemyLastSeen > 2.0))
			{
				instigator = Pawn(bestActor);



				if (instigator == None)
					instigator = bestActor.Instigator;

				if (instigator != None)
				{
					SetSeekLocation(instigator, bestActor.Location, SEEKTYPE_Sound);
					destLoc = LastSeenPos;
					if (bInterruptSeek)
						GotoState('Seeking', 'GoToLocation');
				}
			}
		}
	}

	function HandleSighting(Pawn pawnSighted)
	{
		if ((EnemyLastSeen > 2.0) && IsValidEnemy(pawnSighted))
		{
		    if (bReactFlareBeam)
                SetSeekLocation(pawnSighted, pawnSighted.Location + VRand() * 3200, SEEKTYPE_Sight);
            else
			    SetSeekLocation(pawnSighted, pawnSighted.Location, SEEKTYPE_Sight);
			destLoc = LastSeenPos;
			if (bInterruptSeek)
				GotoState('Seeking', 'GoToLocation');
		}
	}

    function checkFlareThrow() //CyberP: self-explanatory. Should we throw a flare?
    {
    local DeusExPlayer playa;
    local float dista, visi;
    local int casted;

    bCanFlare = False;

    playa = DeusExPlayer(GetPlayerPawn());
    if (playa != none && playa.CombatDifficulty > 0.5)
    {
     if (FastTrace(destLoc,Location))
     {
     dista = Abs(VSize(playa.Location - Location));
   		if (dista < 800 && (Abs(Location.Z-playa.Location.Z) < 160)) //CyberP: make sure we are close and without much height diff.
        {
             visi = Playa.AIVisibility(false);
             casted = (int(visi*100));
             if (casted < 10)
                 bCanFlare = True;
        }
      }
    }
    }

    function flareThrow()
    {
    local flare flared;
    local vector flareOffset;

    flareOffset = Location;
    flareOffset.Z += 50;
    flareOffset.X += CollisionRadius;
     flared = Spawn(class'Flare',self,,flareOffset,ViewRotation);
     if (flared != None)
     {
        flared.LightFlare();
        flared.Velocity = Vector(Rotation)*1000;
        flared.Velocity.Z += 100;
     }
    }

    function bool checkNearbyHidePoints() //CyberP AKA Totalitarian: called when enemies are seeking post-combat
	{
		local HidePoint   HideP;
		local vector doorPoint;
		local bool   bValid;

		destPoint = None;
		destLoc   = vect(0,0,0);
		bValid    = false;

        ForEach RadiusActors(class'HidePoint',HideP, 2048)
        {
            if (HideP.ChosenPawn == None)
            {
                HideP.ChosenPawn = self;
                HideP.SetTimer(20.0,false);
            }
            if (HideP.ChosenPawn != None && HideP.ChosenPawn == self)
            {
			doorPoint = HideP.Location;
			if (PointReachable(doorPoint))
			{
				destPoint = HideP;
				bValid = true;
				break;
			}
			else
			{
				MoveTarget = FindPathTo(doorPoint);
				if (MoveTarget != None)
				{
					destPoint = MoveTarget;
					bValid = true;
					break;
				}
			}
			}
        }
        if (Abs(Vsize(doorPoint - Location)) < 128)
		    return false;
		return (bValid);
    }

    function bool checkNearbyDoors() //CyberP AKA Totalitarian: called when enemies are seeking post-combat
	{
		local DeusExMover DXM;
		local vector doorPoint;
		local bool   bValid;

		destPoint = None;
		destLoc   = vect(0,0,0);
		bValid    = false;

		if (!bValid)
		{
		    ForEach RadiusActors(class'DeusExMover',DXM, 1536)
            {
            if (DXM.bIsDoor && !DXM.bLocked)
            {
            if (DXM.ChosenPawn == None)
            {
                DXM.ChosenPawn = self;
            }
            if (DXM.ChosenPawn != None && DXM.ChosenPawn == self)
            {
			doorPoint = DXM.Location - vect(0,0,32);
			if (PointReachable(doorPoint))
			{
				destPoint = DXM;
				bValid = true;
				break;
			}
			else
			{
				MoveTarget = FindPathTo(doorPoint);
				if (MoveTarget != None)
				{
					destPoint = MoveTarget;
					bValid = true;
					break;
				}
			}
			}
			}
		    }
		}
		if (Abs(Vsize(doorPoint - Location)) < 128)
		    return false;
		return (bValid);
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		destLoc = LastSeenPos;
		if (SeekLevel == 0 && enemy == None && !bSeekLocation)
		   SetReactions(true, true, true, true, true, true, true, true, true, false, true, true);
		else
		   SetReactions(true, true, false, true, true, true, true, true, true, false, true, true);
        bCanConverse = False;
		bStasis = False;
		SetupWeapon(true);
		SetDistress(false);
        bInterruptState=True;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		Enable('AnimEnd');
		ResetReactions();
		bCanConverse = True;
		bStasis = True;
		StopBlendAnims();
		SeekLevel = 0;
		bReactToBeamGlobal = False;
		if (bHasCloak && bCloakOn)
	    {
	         if (Health == default.Health)
	             CloakThreshold = default.CloakThreshold;
             else
                 CloakThreshold = Health*0.4;
             EnableCloak(false);
        }
	}

Begin:
	WaitForLanding();
	PlayWaiting();
	if ((Weapon != None) && bKeepWeaponDrawn && (Weapon.CockingSound != None) && !bSeekPostCombat)
		PlaySound(Weapon.CockingSound, SLOT_None,,, 1024);
	Acceleration = vect(0,0,0);
	if (!PickDestination())
		Goto('DoneSeek');

GoToLocation:
    bInterruptSeek = true;

	Acceleration = vect(0,0,0);

	if ((DeusExWeapon(Weapon) != None) && DeusExWeapon(Weapon).CanReload() && !Weapon.IsInState('Reload'))
		DeusExWeapon(Weapon).ReloadAmmo();

	if (bSeekPostCombat)
		PlayPostAttackSearchingSound();
	else if (SeekType == SEEKTYPE_Sound)
	{
		PlayPreAttackSearchingSound();
		disturbanceCount++;
		if (FRand() < 0.4 && SeekLevel >= 3) //CyberP: sometimes just turn to the source of the sound instead of running around
		{
		SeekLevel = 0;
		GoTo('TurnToLocation');
		}
	}
	else if (SeekType == SEEKTYPE_Sight)
	{
		if (ReactionLevel > 0.5 && !bReactToBeamGlobal)
			PlayPreAttackSightingSound();
		disturbanceCount++;
	}
	else if ((SeekType == SEEKTYPE_Carcass) && bSeekLocation)
		PlayCarcassSound();

	StopBlendAnims();

	if ((SeekType == SEEKTYPE_Sight) && bSeekLocation)
		Goto('TurnToLocation');

	EnableCheckDestLoc(true);
	if (SeekType == SEEKTYPE_Sound && FRand() < 0.1 && SeekLevel >=3)
	{
	Sleep(0.2);
	while (GetNextLocation(useLoc))
	{
		            if (ShouldPlayWalk(useLoc))
		                        PlayWalking();
                              		MoveTo(useLoc, GetWalkingSpeed());
		         		CheckDestLoc(useLoc);

	}
	}
	else
	{
	while (GetNextLocation(useLoc))
	{
		            if (ShouldPlayWalk(useLoc))
		                        PlayRunning();
                              		MoveTo(useLoc, MaxDesiredSpeed);
		         		CheckDestLoc(useLoc);

	}
	}
	EnableCheckDestLoc(false);

	if ((SeekType == SEEKTYPE_Guess) && bSeekLocation)
	{
		MoveTarget = GetOvershootDestination(0.5);
		if (MoveTarget != None)
		{
		   sleep(0.2);
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);

		}

		if (AIPickRandomDestination(CollisionRadius*2, 200+FRand()*200, Rotation.Yaw, 0.75, Rotation.Pitch, 0.75, 2,
		                            0.4, useLoc))
		{
			if (ShouldPlayWalk(useLoc))
			{
                PlayRunning();
			MoveTo(useLoc, MaxDesiredSpeed);
			}


	}
 }

TurnToLocation:
	Acceleration = vect(0,0,0);
	PlayTurning();
	if ((SeekType == SEEKTYPE_Guess) && bSeekLocation)
		destLoc = Location + Vector(Rotation+(rot(0,1,0)*(Rand(16384)-8192)))*1000;
	if (bCanTurnHead)
	{
		Sleep(0);  // needed to turn head
		LookAtVector(destLoc, true, false, true);
		TurnTo(Vector(DesiredRotation)*1000+Location);
	}
	else
		TurnTo(destLoc);
	bSeekLocation = false;
	bInterruptSeek = True;  //CyberP: was false


	PlayWaiting();
	if (SeekType == SEEKTYPE_Sound)
	{
	    if (SeekLevel == 0)
	    {
	       Sleep(FRand()*2+3);
           GoTo('LookAroundAgain');
	    }
	    else if (FRand() < 0.4)
	    {
	       SeekType = SEEKTYPE_Guess;
	       GoTo('GoToLocation');
	    }
    }
	/*if (disturbanceCount > 16 && disturbanceCount < 19)
    {
        if (RaiseAlarm != RAISEALARM_Never)
        {
        RaiseAlarm = RAISEALARM_BeforeAttacking;  //CyberP: pawns that witness too many disturbances go for alarm
	    GotoState('Alerting');
	    }
    }*/
        if (SeekType == SEEKTYPE_Sight)     //CyberP: if type sight, sleep for FRand()+1.
        {
            if (IsA('Doberman') && FRand() < 0.5)
            PlaySound(sound'DogAttack2',SLOT_None,,,1024);
            if ((IsA('HumanMilitary') || IsA('HumanThug')) && Weapon != None && !bGunVisual)
            {
                if (FRand() < 0.2 && (Abs(Location.Z-DeusExPlayer(GetPlayerPawn()).Location.Z) < 128))
                {
                    TweenToShoot(0.2);
                    bGunVisual = True;
                    Sleep(FRand()+0.5);
                }
            }
            Sleep(FRand()+1.0);
            if (FRand() < 0.4 && !bReactToBeamGlobal && !IsA('Robot'))    //CyberP: This makes pawns sometimes seek the location
            {
                if (bHasCloak && FRand() < 0.4 && !bCloakOn)
                {
                    CloakThreshold = default.Health;
                    EnableCloak(True);
                    Sleep(FRand()*0.5);
                }
                SeekType = SEEKTYPE_Guess;
                GoTo('GoToLocation');
            }
            else
            {
              if ((IsA('Terrorist') || IsA('MJ12Troop') || IsA('UNATCOTroop') || IsA('MJ12Elite')) && !bHasThrownFlare) //CyberP: flare throw
                checkFlareThrow();
              if (bCanFlare)
              {
                FinishAnim();
                PlayAnimPivot('Attack',,0.1);
                Sleep(0.3);
                flareThrow();
                bHasThrownFlare = True;
                bCanFlare = False;
                FinishAnim();
                PlayWaiting();
                Sleep(FRand()+0.1);
                if (FRand() < 0.5)    //CyberP: sometimes go over to where you threw the flare too
                {
                SeekType = SEEKTYPE_Guess;
                GoTo('GoToLocation');
                }
              }
            }
        }
        else
	Sleep((FRand()*2)+0.5); //CyberP: else we don't want much sleeping on the job. :)

FindAnotherPlaceNew:               //CyberP: New label for another run around
    if (FRand() < 0.85)  //CyberP: sometimes seek level isn't decremented
	    SeekLevel--;
	if (PickDestination())
		Goto('GoToLocation');

LookAround:              //CyberP: look around now takes less time to execute
	if (bCanTurnHead)
	{
		if (FRand() < 0.5)
		{
         	if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Left, 1.0, 1.0);
				Sleep(1.0);
			}
		}
		else
		{
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Right, 1.0, 1.0);
				Sleep(1.0);
			}
		}
		PlayTurnHead(LOOK_Forward, 1.0, 1.0);
		Sleep(0.5);
		StopBlendAnims();
	}
	else
	{
		if (!bSeekLocation)
			Sleep(1.0);
	}
    if (SeekType == SEEKTYPE_Carcass)
    {
        if (RaiseAlarm != RAISEALARM_Never)
        {
        RaiseAlarm = RAISEALARM_BeforeAttacking;  //CyberP: pawns that spot carcasses go for alarm
	    GotoState('Alerting');
	    }
    }

FindAnotherPlace:               //CyberP: New label for another run around
	SeekLevel--;
	if (PickDestination())
		Goto('GoToLocation');


LookAroundAgain:
	if (bCanTurnHead)
	{
		if (FRand() < 0.3)
		{
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Left, 1.0, 1.0);
				Sleep(1.0);
			}
		}
		else
		{
			if (!bSeekLocation)
			{
				PlayTurnHead(LOOK_Right, 1.0, 1.0);
				Sleep(1.0);
			}
		}
		PlayTurnHead(LOOK_Forward, 1.0, 1.0);
		Sleep(FRand()+1.0);
		StopBlendAnims();
		if (FRand() < 0.2 && !bSeekLocation)
	    {
	    TurnTo(VRand()*70);
        Sleep(FRand()+1.5);
        }
	}
	else
	{
		if (!bSeekLocation)
			Sleep(1.0);
	}

	if (bSeekPostCombat && SeekLevel > 0) //CyberP: more elaborate searching post-combat.
	{
	    bKeepWeaponDrawn = True;
	    sleep(0.5);
	    if (FRand() < 0.5 && bIsHuman)
	    {
            if (checkNearbyHidePoints())
	        {
	            //BroadcastMessage("hide");
                EnableCheckDestLoc(true);
	            while (true)
	           {
		       if (destPoint != None)
		       {
		     	if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
		    	MoveToward(MoveTarget, MaxDesiredSpeed);
	    		CheckDestLoc(MoveTarget.Location, true);
	   	       }
		       else
		       {
		    	if (ShouldPlayWalk(destLoc))
				PlayRunning();
			    MoveTo(destLoc, MaxDesiredSpeed);
			    CheckDestLoc(destLoc);
		        }
                if (!checkNearbyHidePoints())
			       break;
	            }
	            EnableCheckDestLoc(false);
	        }
	        else
	        {
	            sleep(2.5+FRand());
                SeekLevel++;
	        }
	    }
	    else if (FRand() < 0.5 && bIsHuman)
	    {
	        if (checkNearbyDoors())
	        {
	            //BroadcastMessage("door");
                EnableCheckDestLoc(true);
	            while (true)
	           {
		       if (destPoint != None)
		       {
		     	if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
		    	MoveToward(MoveTarget, MaxDesiredSpeed);
	    		CheckDestLoc(MoveTarget.Location, true);
	   	       }
		       else
		       {
		    	if (ShouldPlayWalk(destLoc))
				PlayRunning();
			    MoveTo(destLoc, MaxDesiredSpeed);
			    CheckDestLoc(destLoc);
		        }
                if (!checkNearbyDoors())
			       break;
	            }
	            EnableCheckDestLoc(false);
	        }
	        else
	        {
	            sleep(2.5+FRand());
                SeekLevel++;
	        }
	    }
	    else if (FRand() < 0.25 && bIsHuman)
	    {
	        if (RaiseAlarm != RAISEALARM_Never)
            {
               RaiseAlarm = RAISEALARM_BeforeAttacking;  //CyberP: pawns that spot carcasses go for alarm
	           GotoState('Alerting');
	        }
	        else
	        {
	           sleep(2.5+FRand());
               SeekLevel++;
	        }
	    }
	    else if (FRand() < 0.25 && bIsHuman && FastTrace(vector(rotation)*320,Location)) //CyberP: toss flares
	    {
	         Sleep(FRand()+0.1);
	         if ((IsA('Terrorist') || IsA('MJ12Troop') || IsA('UNATCOTroop') || IsA('MJ12Elite')) && !bHasThrownFlare) //CyberP: flare throw
                checkFlareThrow();
              if (bCanFlare)
              {
                FinishAnim();
                PlayAnimPivot('Attack',,0.1);
                Sleep(0.3);
                flareThrow();
                bHasThrownFlare = True;
                bCanFlare = False;
                FinishAnim();
                PlayWaiting();
                Sleep(FRand()+2.0);
                SeekLevel++;
              }
	    }
        else
        {
            sleep(FRand()+0.1);
            TurnTo(VRand()*3200);
            sleep(FRand());
            TurnTo(VRand()*3200);
            sleep(FRand()+0.1);
            TurnTo(VRand()*3200);
            if (FastTrace(vector(rotation)*320,Location))
            {
                TweenToShoot(0.2);
                sleep(FRand()+0.5);
            }
            else
                sleep(FRand());
            TurnTo(VRand()*3200);
            if (FRand() < 0.3)
            {
                sleep(FRand()+0.1);
                TurnTo(VRand()*3200);
            }
            if (FastTrace(vector(rotation)*320,Location))
                sleep(1.5+FRand());
            else
                sleep(FRand());

            SeekLevel++;
        }
	}

FindAnotherPlaceAgain:               //CyberP: New label for another run around
	SeekLevel--;
	if (PickDestination())
		Goto('GoToLocation');

DoneSeek:
	if (bSeekPostCombat)
		PlayTargetLostSound();
	else if (RaiseAlarm != RAISEALARM_BeforeAttacking && (SeekType != SEEKTYPE_Sight || FRand() < 0.4)) //CyberP: don't say anything after alarm trigger
		PlaySearchGiveUpSound();
	SeekPawn = None;
	if (bSeekPostCombat && bIsHuman && FRand() < 0.1)  //CyberP: sometimes wander the area after combat
	{
	    bSeekPostCombat = False;
	    GotoState('Wandering');
	}
	else if (Orders != 'Seeking')
	{
	    bSeekPostCombat = False;
		FollowOrders();
	}
	else
	{
	    bSeekPostCombat = False;
		GotoState('Wandering');
    }

ContinueSeek:
ContinueFromDoor:
	FinishAnim();
	if (FRand() < 0.7)   //CyberP: continue seeking post-opening a door, you dumbasses.
	{
	    SeekType = SEEKTYPE_Guess;
	    Goto('GoToLocation');
	}
	else
	    Goto('FindAnotherPlace');

}


// ----------------------------------------------------------------------
// state Fleeing
//
// Run like a bat outta hell away from an actor.
// ----------------------------------------------------------------------

State Fleeing
{
	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		local Name currentState;
		local Pawn oldEnemy;
		local name newLabel;
		local bool bHateThisInjury;
		local bool bFearThisInjury;
		local bool bAttack;

		if ((health > 0) && (bLookingForInjury || bLookingForIndirectInjury))
		{
			currentState = GetStateName();

			bHateThisInjury = ShouldReactToInjuryType(damageType, bHateInjury, bHateIndirectInjury);
			bFearThisInjury = ShouldReactToInjuryType(damageType, bFearInjury, bFearIndirectInjury);

			if (bHateThisInjury)
				IncreaseAgitation(instigatedBy);
			if (bFearThisInjury)
				IncreaseFear(instigatedBy, 2.0);

			oldEnemy = Enemy;

			bAttack = false;
			if (SetEnemy(instigatedBy))
			{
				if (!ShouldFlee())
				{
					SwitchToBestWeapon();
					if (Weapon != None)
						bAttack = true;
				}
			}
			else
				SetEnemy(instigatedBy, , true);
            if (bHackFear)
            {
               bHackFear = False;
               HackFearTimer = 0;
               minHealth = 0;
               bAttack = True;
            }
			if (bAttack)
			{
				SetDistressTimer();
				SetNextState('HandlingEnemy');
			}
			else
			{
				SetDistressTimer();
				if (oldEnemy != Enemy)
					newLabel = 'Begin';
				else
					newLabel = 'ContinueFlee';
				SetNextState('Fleeing', newLabel);
			}
			GotoDisabledState(damageType, hitPos);
		}
	}

	function SetFall()
	{
		StartFalling('Fleeing', 'ContinueFlee');
	}

	function FinishFleeing()
	{
		if (bLeaveAfterFleeing)
			GotoState('Wandering');
		else
			FollowOrders();
	}

	function bool InSeat(out vector newLoc)  // hack
	{
		local Seat curSeat;
		local bool bSeat;

		bSeat = false;
		foreach RadiusActors(Class'Seat', curSeat, 200)
		{
			if (IsOverlapping(curSeat))
			{
				bSeat = true;
				newLoc = curSeat.Location + vector(curSeat.Rotation+Rot(0, -16384, 0))*(CollisionRadius+curSeat.CollisionRadius+20);
				break;
			}
		}

		return (bSeat);
	}

	function Tick(float deltaSeconds)
	{
		UpdateActorVisibility(Enemy, deltaSeconds, 0.0, false);
		if (IsValidEnemy(Enemy))
		{
			if (EnemyLastSeen > FearSustainTime)
				FinishFleeing();
			if (bHackFear)
            {
               HackFearTimer+=deltaSeconds;
               if (HackFearTimer > 8)
               {
                  minHealth = 0;
                  bHackFear = False;
                  HackFearTimer = 0;
                  SetDistressTimer();
                  if (EnemyLastSeen == 0 && enemy != None)
                     GoToState('Attacking');
                  else
				     FollowOrders();
               }
            }
		}
		else if (!IsValidEnemy(Enemy, false))
			FinishFleeing();
		else if (!IsFearful())
			FinishFleeing();
		Global.Tick(deltaSeconds);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function PickDestination()
	{
		local HidePoint      hidePoint;
		local Actor          waypoint;
		local float          dist;
		local float          score;
		local Vector         vector1, vector2;
		local Rotator        rotator1;
		local float          tmpDist;

		local float          bestDist;
		local float          bestScore;

		local FleeCandidates candidates[5];
		local int            candidateCount;
		local int            maxCandidates;

		local float          maxDist;
		local int            openSlot;
		local float          maxScore;
		local int            i;
		local bool           bReplace;

		local float          angle;
		local float          magnitude;
		local int            iterations;

		local NearbyProjectileList projList;
		local bool                 bSuccess;

        maxCandidates  = 3;  // must be <= size of candidates[] arrays
		maxDist        = 10000;

		// Initialize the list of candidates
		for (i=0; i<maxCandidates; i++)
		{
			candidates[i].score = -1;
			candidates[i].dist  = maxDist+1;
		}
		candidateCount = 0;

		MoveTarget = None;
		destPoint  = None;

		if (bAvoidHarm)
		{
			GetProjectileList(projList, Location);
			if (IsLocationDangerous(projList, Location))
			{
				vector1 = ComputeAwayVector(projList);
				rotator1 = Rotator(vector1);
				if (AIDirectionReachable(Location, rotator1.Yaw, rotator1.Pitch, CollisionRadius+24, VSize(vector1), destLoc))
					return;   // eck -- hack!!!
			}
		}

        if (Enemy != None)
		{
			foreach RadiusActors(Class'HidePoint', hidePoint, maxDist)
			{
				// Can the boogeyman see our hiding spot?
				if (!enemy.LineOfSightTo(hidePoint))
				{
					// More importantly, can we REACH our hiding spot?
					waypoint = GetNextWaypoint(hidePoint);
					if (waypoint != None)
					{
						// How far is it to the hiding place?
						dist = VSize(hidePoint.Location - Location);

						// Determine vectors to the waypoint and our enemy
						vector1 = enemy.Location - Location;
						vector2 = waypoint.Location - Location;

						// Strip out magnitudes from the vectors
						tmpDist = VSize(vector1);
						if (tmpDist > 0)
							vector1 /= tmpDist;
						tmpDist = VSize(vector2);
						if (tmpDist > 0)
							vector2 /= tmpDist;

						// Add them
						vector1 += vector2;

						// Compute a score (a function of angle)
						score = VSize(vector1);
						score = 4-(score*score);

						// Find an empty slot for this candidate
						openSlot  = -1;
						bestScore = score;
						bestDist  = dist;

						for (i=0; i<maxCandidates; i++)
						{
							// Can we replace the candidate in this slot?
							if (bestScore > candidates[i].score)
								bReplace = TRUE;
							else if ((bestScore == candidates[i].score) &&
							         (bestDist < candidates[i].dist))
								bReplace = TRUE;
							else
								bReplace = FALSE;
							if (bReplace)
							{
								bestScore = candidates[i].score;
								bestDist  = candidates[i].dist;
								openSlot = i;
							}
						}

						// We found an open slot -- put our candidate here
						if (openSlot >= 0)
						{
							candidates[openSlot].point    = hidePoint;
							candidates[openSlot].waypoint = waypoint;
							candidates[openSlot].location = waypoint.Location;
							candidates[openSlot].score    = score;
							candidates[openSlot].dist     = dist;
							if (candidateCount < maxCandidates)
								candidateCount++;
						}
					}
				}
			}

			// Any candidates?
			if (candidateCount > 0)
			{
				// Find a random candidate
				// (candidates moving AWAY from the enemy have a higher
				// probability of being chosen than candidates moving
				// TOWARDS the enemy)

				maxScore = 0;
				for (i=0; i<candidateCount; i++)
					maxScore += candidates[i].score;
				score = FRand() * maxScore;
				for (i=0; i<candidateCount; i++)
				{
					score -= candidates[i].score;
					if (score <= 0)
						break;
				}
				destPoint  = candidates[i].point;
				MoveTarget = candidates[i].waypoint;
				destLoc    = candidates[i].location;
			}
			else
			{
				iterations = 4;
				magnitude = 400*(FRand()*0.4+0.8);  // 400, +/-20%
				rotator1 = Rotator(Location-Enemy.Location);
				if (!AIPickRandomDestination(100, magnitude, rotator1.Yaw, 0.6, rotator1.Pitch, 0.6, iterations,
				                             FRand()*0.4+0.35, destLoc))
					destLoc = Location+(VRand()*1200);  // we give up
			}
		}
		else
			destLoc = Location+(VRand()*1200);  // we give up
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		//Disable('Bump');
		BlockReactions();
		if (!bCower)
			bCanConverse = False;
		bStasis = False;
		SetupWeapon(false, true);
		SetDistress(true);
		EnemyReadiness = 1.0;
		//ReactionLevel  = 1.0;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		Enable('AnimEnd');
		//Enable('Bump');
		ResetReactions();
		if (!bCower)
			bCanConverse = True;
		bStasis = True;
	}

Begin:
	//EnemyLastSeen = 0;
	destPoint = None;

Surprise:
	if ((1.0-ReactionLevel)*SurprisePeriod < 0.25)
		Goto('Flee');
	Acceleration=vect(0,0,0);
	PlaySurpriseSound();
	PlayWaiting();
	Sleep(FRand()*0.5);
	if (Enemy != None)
		TurnToward(Enemy);
	if (bCower)
		Goto('Flee');
	Sleep(FRand()*0.5+0.5);

Flee:
	if (bLeaveAfterFleeing)
	{
		bTransient = true;
		bDisappear = true;
	}
	if (bCower)
		Goto('Cower');
	WaitForLanding();
	PickDestination();

Moving:
	Sleep(0.0);

	if (enemy == None)
	{
		Acceleration = vect(0,0,0);
		PlayWaiting();
		Sleep(2.0);
		FinishFleeing();
	}

	// Move from pathnode to pathnode until we get where we're going
	if (destPoint != None)
	{
		EnableCheckDestLoc(true);
		while (MoveTarget != None)
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
			if (enemy.bDetectable && enemy.AICanSee(destPoint, 1.0, false, false, false, true) > 0)
			{
				PickDestination();
				EnableCheckDestLoc(false);
				Goto('Moving');
			}
			if (MoveTarget == destPoint)
				break;
			MoveTarget = FindPathToward(destPoint);
		}
		EnableCheckDestLoc(false);
	}
	else if (PointReachable(destLoc))
	{
		if (ShouldPlayWalk(destLoc))
			PlayRunning();
		MoveTo(destLoc, MaxDesiredSpeed);
		if (enemy.bDetectable && enemy.AICanSee(Self, 1.0, false, false, true, true) > 0)
		{
			PickDestination();
			Goto('Moving');
		}
	}
	else
	{
		PickDestination();
		Goto('Moving');
	}

Pausing:
	Acceleration = vect(0,0,0);

	if (enemy != None)
	{
		if (HidePoint(destPoint) != None)
		{
			if (ShouldPlayTurn(Location + HidePoint(destPoint).faceDirection))
				PlayTurning();
			TurnTo(Location + HidePoint(destPoint).faceDirection);
		}
		Enable('AnimEnd');
		TweenToWaiting(0.2);
		while (AICanSee(enemy, 1.0, false, false, true, true) <= 0)
			Sleep(0.25);
		Disable('AnimEnd');
		FinishAnim();
	}

	Goto('Flee');

Cower:
	if (!InSeat(useLoc))
		Goto('CowerContinue');
    FinishAnim();  //CyberP: fix cowering NPCs not animating.
	PlayRunning();
	MoveTo(useLoc, MaxDesiredSpeed);

CowerContinue:
	Acceleration = vect(0,0,0);
	PlayCowerBegin();
	FinishAnim();
	PlayCowering();

	// behavior 3 - cower and occasionally make short runs
	while (true)
	{
		Sleep(FRand()*4+6);

		PlayCowerEnd();
		FinishAnim();
		if (AIPickRandomDestination(60, 150, 0, 0, 0, 0,
		                            2, FRand()*0.3+0.6, useLoc))
		{
			if (ShouldPlayWalk(useLoc))
				PlayRunning();
			MoveTo(useLoc, MaxDesiredSpeed);
		}
		PlayCowerBegin();
		FinishAnim();
		PlayCowering();
	}

	/* behavior 2 - cower forever
	// don't stop cowering
	while (true)
		Sleep(1.0);
	*/

	/* behavior 1 - cower only when enemy watching
	if (enemy != None)
	{
		while (AICanSee(enemy, 1.0, false, false, true, true) > 0)
			Sleep(0.25);
	}
	PlayCowerEnd();
	FinishAnim();
	Goto('Pausing');
	*/

ContinueFlee:
ContinueFromDoor:
	FinishAnim();
	PlayRunning();
	if (bCower)
		Goto('Cower');
	else
		Goto('Moving');

}


// ----------------------------------------------------------------------
// state Attacking
//
// Kill!  Kill!  Kill!  Kill!
// ----------------------------------------------------------------------

State Attacking
{
	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		local Pawn oldEnemy;
		local bool bHateThisInjury;
		local bool bFearThisInjury;

		if ((health > 0) && (bLookingForInjury || bLookingForIndirectInjury))
		{
		    if (instigatedBy != None && Enemy != instigatedBy && instigatedBy != self)
		        SetEnemy(instigatedBy, 0, true);
			oldEnemy = Enemy;

			bHateThisInjury = ShouldReactToInjuryType(damageType, bHateInjury, bHateIndirectInjury);
			bFearThisInjury = ShouldReactToInjuryType(damageType, bFearInjury, bFearIndirectInjury);

			if (bHateThisInjury)
				IncreaseAgitation(instigatedBy, 1.0);
			if (bFearThisInjury)
				IncreaseFear(instigatedBy, 2.0);

			if (instigatedBy != None && ReadyForNewEnemy() && instigatedBy != self)
				SetEnemy(instigatedBy);                     //Hurt themselves in combat then give up attacking the player

			if (ShouldFlee())
			{
				SetDistressTimer();
				PlayCriticalDamageSound();
				if (RaiseAlarm == RAISEALARM_BeforeFleeing)
					SetNextState('Alerting');
				else
					SetNextState('Fleeing');
			}
			else
			{
				SetDistressTimer();
				if (oldEnemy != Enemy)
					PlayNewTargetSound();
				SetNextState('Attacking', 'ContinueAttack');
			}
			GotoDisabledState(damageType, hitPos);
		}
	}

	function SetFall()
	{
		StartFalling('Attacking', 'ContinueAttack');
	}

    function bool ArePawnsNearby(float radi)
    {
     local ScriptedPawn nearby;
     local int i;
     local float dista;

     if (enemy != None)
     {
     dista = Abs(Vsize(enemy.Location - Location));
     if (dista < 900)
     {
       ForEach RadiusActors(class'ScriptedPawn', nearby, radi)
       {
         i++;
       }
     }
     BroadcastMessage("i = " $ i);
     }
     if (i == 0)
         return false;
     else
         return true;
    }

	function Bump(actor bumper)
	{
	   //CyberP: (otherwise known as |Totalitarian|) stop attempting to move to location if bump enemy
       if (Enemy != None && bumper == Enemy && Weapon != None)
       {
	   if (AnimSequence != 'Strafe2H' && AnimSequence != 'Strafe' && AnimSequence != 'Attack')
        if (VSize(Velocity) > 0)
        {
             GoToState('Attacking','Fire');
             return;
        }
       }
      Global.Bump(bumper);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Reloading(DeusExWeapon reloadWeapon, float reloadTime)
	{
		Global.Reloading(reloadWeapon, reloadTime);
		if (bReadyToReload)
			if (IsWeaponReloading())
				if (!IsHandToHand())
					TweenToShoot(0);
	}

	function EDestinationType PickDestination()
	{
		local vector               distVect;
		local vector               tempVect;
		local rotator              enemyDir;
		local float                magnitude, dista;
		local float                calcMagnitude;
		local int                  iterations;
		local EDestinationType     destType;
		local NearbyProjectileList projList;

        local NavigationPoint      navPoint;
        local NavigationPoint      bestPoint;
        local float                dista2, dist;
        local bool                 bSafe;

		destPoint = None;
		destLoc   = vect(0, 0, 0);
		destType  = DEST_Failure;

		if (enemy == None)
			return (destType);

        if ((bCrouching && (CrouchTimer > 0)))
            destType = DEST_SameLocation;
        else if (bDefensiveStyle) //CyberP: added: enemies don't ALWAYS rush your position when in close proximity
        {
          dista = Abs(VSize(Enemy.Location - Location));
          if (dista < 768)
             if (EnemyTimer < EnemyTimeout*0.3 && EnemyTimer > 0 && Weapon.IsA('DeusExWeapon') && DeusExWeapon(Weapon).AccurateRange > 768)
			    destType = DEST_SameLocation;
			    //CyberP: huh? What code did I write way back? Shouldn't it be EnemyLastSeen, not EnemyTimer???
                //CyberP: I guess EnemyTimer results in less predictable camping, which is probably better.
        }

        //CyberP: flanking (far from complete)
        /*if (destType == DEST_Failure && weapon.ReloadCount > 1 && bIsHuman)
        {
        if (enemy.IsA('DeusExPlayer') && EnemyLastSeen > 0 && FRand() < 0.6 && !bDefendHome)
		{
		   BroadcastMessage("Ready!");
		   if (VSize(DeusExPlayer(enemy).Location - Location) < 1536 )// && ActorReachable(enemy))
		   {
		       bestPoint = None;
		       foreach ReachablePathnodes(Class'NavigationPoint', navPoint, self, dist, true)
		       {
		          BroadcastMessage("Iterating!");
		          dista2 = VSize(navPoint.Location - DeusExPlayer(enemy).Location);
		          if (dista2 < 1024 && dista2 > 128 && !navPoint.taken)
			      {
			         if (FRand() < 0.6)// || (dista2 > 192 && dista2 < 512))
                     {
                        bSafe = FastTrace(DeusExPlayer(enemy).location, navPoint.location+vect(0,0,96));
		                if (bSafe)
			            {
			                BroadcastMessage("FLANKING!");
			                spawn(class'FleshFragmentNub',,,navPoint.location);
				            bestPoint = navPoint;
						    break;
			            }
			         }
			      }
		       }
               if (bestPoint != None)
               {
                  MoveTarget = FindPathToward(bestPoint);
			      if (MoveTarget != None)
			      {
					   if (bAvoidHarm)
						   GetProjectileList(projList, MoveTarget.Location);
					   if (!bAvoidHarm || !IsLocationDangerous(projList, MoveTarget.Location))
					   {
					    	destPoint = MoveTarget;
						    destType  = DEST_NewLocation;
					    }
	              }
               }
            }
        }
        } */
        //flanking end

		if (destType == DEST_Failure)
		{
			if (AICanShoot(enemy, true, false, 0.025) || ActorReachable(enemy))
			{
				destType = ComputeBestFiringPosition(tempVect);
				if (destType == DEST_NewLocation)
					destLoc = tempVect;
			}
		}

		if (destType == DEST_Failure)
		{
			MoveTarget = FindPathToward(enemy);
			if (MoveTarget != None)
			{
				if (!bDefendHome || IsNearHome(MoveTarget.Location))
				{
					if (bAvoidHarm)
						GetProjectileList(projList, MoveTarget.Location);
					if (!bAvoidHarm || !IsLocationDangerous(projList, MoveTarget.Location))
					{
						destPoint = MoveTarget;
						destType  = DEST_NewLocation;
					}
				}
			}
		}

        /*if (destType == DEST_Failure) //CyberP: enemies who are melee and can't reach the target run away
		{
		  if (IsA('Karkian'))  //Karkian only for now
		  {
		    if (enemy.LineOfSightTo(self))
    		{
		        minHealth=Health+1;
		        FearSustainTime=8;
		        bHackFear = True;
 	    	}
	      }
		}*/

		// Default behavior, so they don't just stand there...
		if (destType == DEST_Failure)
		{
		    if (FRand() < 0.1)
		    {
			enemyDir = Rotator(Enemy.Location - Location);
			if (AIPickRandomDestination(60, 150,
			                            enemyDir.Yaw, 0.5, enemyDir.Pitch, 0.5,
			                            2, FRand()*0.4+0.35, tempVect))
			{
				if (!bDefendHome || IsNearHome(tempVect))
				{
					destType = DEST_NewLocation;
					destLoc  = tempVect;
				}
			}
			}
		}

		return (destType);
	}

	function bool FireIfClearShot()
	{
		local DeusExWeapon dxWeapon;
        local float vista;
        local HumanMilitary ham;

		dxWeapon = DeusExWeapon(Weapon);
		if (dxWeapon != None)
		{
		    if (dxWeapon.bHandToHand)
		        bDefendHome = False; //CyberP: campers no longer camp if out of ammo
			if ((dxWeapon.AIFireDelay > 0) && (FireTimer > 0))
				return false;
			else if (dxWeapon.IsA('WeaponRifle') && FRand() < 0.8)
                return false;  //CyberP: rand as to whether snipers can fire, to simulate taking variable time to aim.
			else if (AICanShoot(enemy, true, true, 0.025))
			{
                if (currentReactTime > 0)
                {
                    //Waiting to fire...
                    return false;
                }
			    vista = VSize(Enemy.velocity);
			    if (vista > 400)
			    {
			         dxWeapon.PawnAccuracyModifier = 0.15;
			         if (Enemy.Physics == PHYS_Falling)
			            dxWeapon.PawnAccuracyModifier = 0.4;
			    }
                else if (vista > 100)
                     dxWeapon.PawnAccuracyModifier = 0.075;
                else
                     dxWeapon.PawnAccuracyModifier = 0.0;
                if (dxWeapon.IsA('WeaponMiniCrossbow') || dxWeapon.IsA('WeaponPistol')) //CyberP: since NPCs suck at hitting you with xbow.
                    dxWeapon.PawnAccuracyModifier += -0.2;
                else if (IsInState('Dying'))
                    dxWeapon.PawnAccuracyModifier += 0.4;
				Weapon.Fire(0);
				/*if (CombatSeeTimer < 0.75)
				{
				   ForEach RadiusActors(class'HumanMilitary',ham,512)
				   {
				       if (ham.sFire <= 0 && ham.Enemy != None && FRand() < 0.6 && ham.CombatSeeTimer == 0)
				           ham.GMDXEnemyLastSeenPos = enemy.Location;
				   }
				}*/
				FireTimer = dxWeapon.AIFireDelay;
				return true;
			}
			else
            {
                currentReactTime = GetFireReactTime();
				return false;
            }
		}
		else
			return false;
	}

    //SARGE: Reset the minimum firing time when we lose LOS, based on factors like difficulty and weapon used
    function float GetFireReactTime()
    {
        local float add;
        local DeusExPlayer player;
	    local DeusExWeapon W;

        player = DeusExPlayer(GetPlayerPawn());    
        W = DeusExWeapon(Weapon);

        if (W != None && player != None)
        {
            if (player.CombatDifficulty < 2) //On lower difficulties, increase the timer
                add += 0.2;
            
            if (W.GoverningSkill == class'SkillWeaponPistol') //Pistols are slightly faster
                add -= 0.1;
            
            else if (W.GoverningSkill == class'SkillWeaponRifle') //Rifles are slightly slow
                add += 0.1;
            
            else if (W.GoverningSkill == class'SkillWeaponHeavy') //Heavy Weapons are very slow
                add += 0.3;

            if (W.isA('WeaponRifle'))
                add += 0.2;
        }

        //Add some randomness
        add += FRand() * 0.1;

        return FMIN(0.75,fireReactTime+add);
    }

	function CheckAttack(bool bPlaySound)
	{
		local bool bCriticalDamage;
		local bool bOutOfAmmo;
		local Pawn oldEnemy;
		local bool bAllianceSwitch;

		oldEnemy = enemy;

		bAllianceSwitch = false;
		if (!IsValidEnemy(enemy))
		{
			if (IsValidEnemy(enemy, false))
				bAllianceSwitch = true;
			SetEnemy(None, 0, true);
		}

		if (enemy == None)
		{
			if (Orders == 'Attacking')
			{
				FindOrderActor();
				SetEnemy(Pawn(OrderActor), 0, true);
			}
		}
		if (ReadyForNewEnemy())
			FindBestEnemy(false);
		if (enemy == None)
		{
			Enemy = oldEnemy;  // hack
			if (bPlaySound)
			{
				if (bAllianceSwitch)
					PlayAllianceFriendlySound();
				else
					PlayAreaSecureSound();
			}
			Enemy = None;
			if (Orders != 'Attacking')
				FollowOrders();
			else
				GotoState('Wandering');
			return;
		}

		SwitchToBestWeapon();
		if (bCrouching && (CrouchTimer <= 0) && !ShouldCrouch())
		{
			EndCrouch();
			TweenToShoot(0.15);
		}
		bCriticalDamage = False;
		bOutOfAmmo      = False;
		if (ShouldFlee())
			bCriticalDamage = True;
		else if (Weapon == None)
			bOutOfAmmo = True;
		else if (Weapon.ReloadCount > 0)
		{
			if (Weapon.AmmoType == None)
				bOutOfAmmo = True;
			else if (Weapon.AmmoType.AmmoAmount < 1)
				bOutOfAmmo = True;
		}
		if (bCriticalDamage || bOutOfAmmo)
		{
			if (bPlaySound)
			{
				if (bCriticalDamage)
					PlayCriticalDamageSound();
				else if (bOutOfAmmo)
					PlayOutOfAmmoSound();
			}
			if (RaiseAlarm == RAISEALARM_BeforeFleeing)
				GotoState('Alerting');
			else
				GotoState('Fleeing');
		}
		else if (bPlaySound && (oldEnemy != Enemy))
			PlayNewTargetSound();
	}

	function Tick(float deltaSeconds)
	{
		local bool   bCanSee;
		local float  yaw;
		local vector lastLocation;
		local Pawn   lastEnemy;
		local float  surpriseTime;
        local float  distan;

        currentReactTime = FMAX(0.0,currentReactTime - deltaSeconds);

		Global.Tick(deltaSeconds);
		if (CrouchTimer > 0)
		{
			CrouchTimer -= deltaSeconds;
			if (CrouchTimer < 0)
				CrouchTimer = 0;
		}
		EnemyTimer += deltaSeconds;
		UpdateActorVisibility(Enemy, deltaSeconds, 0.3, false);
		if (IsA('Greasel'))
	          ShouldGreaselMelee();
		if ((Enemy != None) && HasEnemyTimedOut())
		{
			lastLocation = Enemy.Location;
			lastEnemy    = Enemy;
			FindBestEnemy(true);
			if (Enemy == None)
			{
				SetSeekLocation(lastEnemy, lastLocation, SEEKTYPE_Guess, true);
				GotoState('Seeking');
			}
		}
		else if (bCanFire && (Enemy != None))
		{
		    if (sFire > 0) //CyberP: suppresive fire
			    ViewRotation = Rotator(GMDXEnemyLastSeenPos-Location);
			else
                ViewRotation = Rotator(Enemy.Location-Location);
			if (bFacingTarget || (sFire > 0 && vSize(Velocity) == 0))
				FireIfClearShot();
			else if (!bMustFaceTarget)
			{
				yaw = (ViewRotation.Yaw-Rotation.Yaw) & 0xFFFF;
				if (yaw >= 32768)
					yaw -= 65536;
				yaw = Abs(yaw)*360/32768;  // 0-180 x 2
				if (yaw <= FireAngle)
					FireIfClearShot();
			}
		}
		if (bIsHuman && FRand() < 0.05)  //CyberP: interrupt moving to destination if player is in view + range.
        {
            if ((animSequence == 'RunShoot2H' || animSequence == 'Run') && CombatSeeTimer > 0 && CombatSeeTimer < 0.5 && EnemyLastSeen < 0.5)
            {
                distan = Abs(VSize(Enemy.Location - Location));
                if (weapon != None && weapon.IsA('DeusExWeapon') && bSpottedPlayer && !DeusExWeapon(Weapon).bFiring && distan < DeusExWeapon(Weapon).AccurateRange && PlayerCanSeeMe())
                {
                   if (FRand() < 0.5)
                       GoToState('Attacking', 'Fire');
                   else
                       GoToState('Attacking', 'ContinueAttack');
                }
            }
        }
		//UpdateReactionLevel(true, deltaSeconds);
	}

	function bool IsHandToHand()
	{
		if (Weapon != None)
		{
			if (DeusExWeapon(Weapon) != None)
			{
				if (DeusExWeapon(Weapon).bHandToHand && !DeusExWeapon(Weapon).IsA('WeaponHideAGun') && !DeusExWeapon(Weapon).IsA('WeaponLAW'))
					return true;
				else
					return false;
			}
			else
				return false;
		}
		else
			return false;
	}

	function bool ReadyForWeapon()
	{
		local bool bReady;

		bReady = false;
		if (DeusExWeapon(weapon) != None)
		{
			if (DeusExWeapon(weapon).bReadyToFire)
				if (!IsWeaponReloading())
					bReady = true;
		}
		if (!bReady)
			if (enemy == None)
				bReady = true;
		if (!bReady)
			if (!AICanShoot(enemy, true, false, 0.025))
				bReady = true;

		return (bReady);
	}

	function bool ShouldCrouch()
	{
		if (bCanCrouch && !Region.Zone.bWaterZone && !IsHandToHand() &&
		    ((enemy != None) && (VSize(enemy.Location-Location) > 100)) &&  //CyberP: 300
		    ((DeusExWeapon(Weapon) == None) || DeusExWeapon(Weapon).bUseWhileCrouched))
			return true;
		else
			return false;
	}

	function StartCrouch()
	{
		if (!bCrouching)
		{
			bCrouching = true;
			SetBasedPawnSize(CollisionRadius, GetCrouchHeight());
			CrouchTimer = 1.0+FRand()*0.5;
		}
	}

	function EndCrouch()
	{
		if (bCrouching)
		{
			bCrouching = false;
			ResetBasedPawnSize();
		}
	}
   function SystemShocked()
   {
    local Vector vec;
    local ShockRingProjectile shock;

     if (AnimSequence == 'Pickup')
      {
      vec = Location;
      vec.Z += 10;
      shock = Spawn(class'ShockRingProjectile',,, vec, rot(16384,0,0));
      if (shock!=none)
      {shock.ScaleGlow=0.0001; shock.bUnlit=False;}

       shock = Spawn(class'ShockRingProjectile',,, vec, rot(16384,0,0));
      if (shock!=none)
      {shock.ScaleGlow=0.0001; shock.bUnlit=False;}

	  Spawn(class'ShockRingProjectile',,, vec, rot(16384,0,0));
	  Spawn(class'SphereEffectShield',,, vec);
	  PlaySound(sound'shootrail',SLOT_None,2,,2048);
	   }
	   bRadialBlastClamp=True;
       //SetPhysics(PHYS_Walking);
   }

   function ShouldMelee()
   {
   local DeusExPlayer dxPlayer;
   local vector HitNormal, HitLocation, StartTrace, EndTrace;
   local float dista;

   if (enemy == None)                                                           //RSD
     return;

   //dxPlayer = DeusExPlayer(GetPlayerPawn());
   dista = Abs(VSize(enemy.Location - Location));
   //CyberP: this should be a return function, duh.
   if (dista < 128)
   {
   StartTrace = Location;
   EndTrace = Location + (Vector(Rotation)) * (CollisionRadius+40);
   EndTrace.Z-= 18;
   if (Trace(HitLocation, HitNormal, EndTrace, StartTrace, True) == enemy)
   {
    if (Physics == PHYS_Walking && !Region.Zone.bWaterZone)
	{
            bCommandoMelee = True;
            if (IsA('MJ12Commando'))
               PlaySound(Sound'TurretLocked',SLOT_None,0.5,,512,1.2);
	}
	}
	}
   }

   function ShouldGreaselMelee() //CyberP: TODO: trace a few feet up for geometry so greasel doesn't jump in vents etc?
   {
   local vector HitNormal, HitLocation, StartTrace, EndTrace;
   local float dista;

   bGreaselShould = False;
   if (enemy != None)
   {
   if (!Region.Zone.bWaterZone && Physics != PHYS_Falling && AnimSequence != 'Attack')
   {
       dista = Abs(VSize(enemy.Location - Location));
       if (dista < 288 && dista > 96 && FRand() < 0.85)
       {
          StartTrace = Location;
          EndTrace = Location + (Vector(Rotation)) * 288;
          if (Trace(HitLocation, HitNormal, EndTrace, StartTrace, True, vect(8,8,8)) == enemy)
          {
             bGreaselShould = True;
          }
       }
   }
   }
   }

   function ShouldRadialBlast()
   {
    local float dist;
    local vector HitNormal, HitLocation, StartTrace, EndTrace;

    if (GroundSpeed > default.GroundSpeed && FRand() < 0.015)
    {
    if (bRadialBlastClamp)
	{
	if (Enemy!=none)
        {
   		dist = Abs(VSize(Enemy.Location - Location));
   		if (dist < 320 && (Abs(Location.Z-Enemy.Location.Z) < 96))
   		     {
   		        StartTrace = Location;
                EndTrace = Enemy.Location;
                if (Trace(HitLocation, HitNormal, EndTrace, StartTrace, True) == enemy)
                {
                    bRadialBlastClamp=False;
                    Velocity = vect(0,0,1);
                    PlayAnimPivot('Pickup',0.6,0.1);
                }
             }
        }
	}
	}
    }

    function checkNadeThrow()   //CyberP: needs a rewrite to be based on checking for enemy, not player. Even though nobody will notice as pawns rarely fight eachother, only the player.
    {                           //CyberP: also it should be a return function, duh. Never mind.
    local DeusExPlayer playa;
    local HumanMilitary P;
    local float dista;
    local Vector HitNormal, HitLocation, StartTrace, EndTrace, offset;
    local int i;
    local bool bSafe, bSafe2;

    if (Enemy != None && Enemy.IsA('DeusExPlayer'))
        playa = DeusExPlayer(Enemy);
    if (playa != none && bCanNade == False && bSpottedPlayer)
    {
     //CyberP: If we manage to trace NEAR the player AND there are no other allied pawns close to that location, then we can throw.
    dista = Abs(VSize(playa.Location - Location));
    if (dista > 640 && dista < 1792 && Abs(Location.Z-playa.Location.Z) < 640 && !playa.bOnLadder)
    {
     StartTrace = Location;
     StartTrace.Z += 10;
     if (sFire > 0)
         EndTrace = GMDXEnemyLastSeenPos;
     else
         EndTrace = playa.Location;

        ForEach Trace(HitLocation, HitNormal, EndTrace, StartTrace, True, vect(4,4,4)).RadiusActors(Class'DeusExPlayer',playa,192,HitLocation)
        {
          i++;
          if (i == 1)
          {
              i = 0;
              ForEach playa.RadiusActors(Class'HumanMilitary',P,224,playa.Location)
              {
                 i++;
              }
             if (i < 1)
             {
                 StartTrace = playa.Location + (vector(Rotation) * (CollisionRadius+64));
                 EndTrace = StartTrace + vect(0,0,-196);
                 bSafe = FastTrace(EndTrace, StartTrace);
                 //Spawn(class'FireExtinguisher',,,EndTrace);
                 StartTrace = playa.Location - (vector(Rotation) * (CollisionRadius+64));
                 EndTrace = StartTrace + vect(0,0,-196);
                 bSafe2 = FastTrace(EndTrace, StartTrace);
                 if (bSafe && bSafe2)
                 {
                 }
                 else
                     bCanNade=True;
             }
          }

        }
     }
    }
    }

    singular function nadeThrow() //CyberP: this is awful. rewrite it ffs
    {
    local GasGrenade gasNade;
    local EMPGrenade empNade;
    local LAM        lamNade;
    local vector flareOffset;
    local DeusExPlayer playa;
    local float dista;
    local bool bSafe;

    flareOffset = Location;
    flareOffset.Z += 50;
    playa = DeusExPlayer(GetPlayerPawn());
    dista = Abs(VSize(playa.Location - Location));

    if (IsA('Terrorist') || IsA('UNATCOTroop') || IsA('RiotCop') || IsA('HKMilitary'))
    {
     gasNade = Spawn(class'GasGrenade',self,,flareOffset);
     if (gasNade != None)
     {
        if (playa != None && playa.CombatDifficulty > 2)
            gasNade.blastRadius = 512;
        else
            gasNade.blastRadius = 352;
       if (dista < 1000)
       {
       if (FRand() < 0.1)
           gasNade.Velocity = Vector(Rotation)*1000 + (VRand()*140);
       else
           gasNade.Velocity = Vector(Rotation)*1000 + (VRand()*60);
       gasNade.Velocity.Z += 300;
       }
       else if (dista < 1300)
       {
       if (FRand() < 0.1)
           gasNade.Velocity = Vector(Rotation)*1150 + (VRand()*140);
       else
           gasNade.Velocity = Vector(Rotation)*1150 + (VRand()*60);
       gasNade.Velocity.Z += 350;
       }
       else
       {
       if (FRand() < 0.1)
           gasNade.Velocity = Vector(Rotation)*1300 + (VRand()*140);
       else
           gasNade.Velocity = Vector(Rotation)*1300 + (VRand()*60);
       gasNade.Velocity.Z += 420;
       }
       gasNade.Velocity.Z -= ((Location.Z-playa.Location.Z)*1.1);
       if (Location.Z-playa.Location.Z > 160)
           gasNade.Velocity*=0.6;
     }
    }
    else if (IsA('MJ12Troop') || IsA('Soldier') || IsA('MJ12Elite'))
    {
      if (FRand() < 0.3)
      {
      gasNade = Spawn(class'GasGrenade',self,,flareOffset);
       if (gasNade != None)
      {
        if (playa != None && playa.CombatDifficulty > 2)
            gasNade.blastRadius = 512;
        else
            gasNade.blastRadius = 352;
        if (dista < 900)
       {
       gasNade.Velocity = Vector(Rotation)*1000 + (VRand()*60);
       gasNade.Velocity.Z += 300;
       }
       else if (dista < 1300)
       {
       gasNade.Velocity = Vector(Rotation)*1150 + (VRand()*60);
       gasNade.Velocity.Z += 350;
       }
       else
       {
       gasNade.Velocity = Vector(Rotation)*1300 + (VRand()*60);
       gasNade.Velocity.Z += 420;
       }
       gasNade.Velocity.Z -= ((Location.Z-playa.Location.Z)*1.1);
       if (Location.Z-playa.Location.Z > 160)
           gasNade.Velocity*=0.6;
      }
      }
      else if (FRand() < 0.6)
      {
        empNade = Spawn(class'EMPGrenade',self,,flareOffset);
       if (empNade != None)
      {
        if (playa != None && playa.CombatDifficulty > 2)
            empNade.blastRadius = 512;
        else
            empNade.blastRadius = 352;
        if (dista < 900)
       {
       empNade.Velocity = Vector(Rotation)*1000 + (VRand()*60);
       empNade.Velocity.Z += 300;
       }
       else if (dista < 1300)
       {
       empNade.Velocity = Vector(Rotation)*1150 + (VRand()*60);
       empNade.Velocity.Z += 350;
       }
       else
       {
       empNade.Velocity = Vector(Rotation)*1300 + (VRand()*60);
       empNade.Velocity.Z += 420;
       }
       empNade.Velocity.Z -= ((Location.Z-playa.Location.Z)*1.1);
       if (Location.Z-playa.Location.Z > 160)
           empNade.Velocity*=0.6;
      }
      }
      else
      {
        lamNade = Spawn(class'LAM',self,,flareOffset);
       if (lamNade != None)
      {
        if (playa != None && playa.CombatDifficulty > 2)
            lamNade.blastRadius = 512;
        else
            lamNade.blastRadius = 352;
        if (dista < 900)
       {
       lamNade.Velocity = Vector(Rotation)*1000 + (VRand()*60);
       lamNade.Velocity.Z += 300;
       }
       else if (dista < 1300)
       {
       lamNade.Velocity = Vector(Rotation)*1150 + (VRand()*60);
       lamNade.Velocity.Z += 350;
       }
       else
       {
       lamNade.Velocity = Vector(Rotation)*1300 + (VRand()*60);
       lamNade.Velocity.Z += 420;
       }
       lamNade.Velocity.Z -= ((Location.Z-playa.Location.Z)*1.1);
       if (Location.Z-playa.Location.Z > 160)
           lamNade.Velocity*=0.6;
      }
      }
    }
    bSafe = FastTrace(Location + vect(0,0,160), Location + vect(0,0,1)*CollisionHeight);
    if (!bSafe)
    {
       if (lamNade != None)
          lamNade.Velocity.Z *= 0.6;
       else if (gasNade != None)
          gasNade.Velocity.Z *= 0.6;
       else if (empNade != None)
          empNade.Velocity.Z *= 0.6;
    }
    }

	function BeginState()
	{
		StandUp();

		// hack
		if (MaxRange < MinRange+10)
			MaxRange = MinRange+10;
		bCanFire      = false;
		bFacingTarget = false;

		SwitchToBestWeapon();

        if (Weapon != None && (Weapon.IsA('WeaponFlamethrower') ||
        Weapon.IsA('WeaponMiniCrossbow') || Weapon.IsA('WeaponSawedOffShotgun') || Weapon.IsA('WeaponAssaultShotgun')))
		    nadeMult = 0.015;
		if (bHasCloak)
            nadeMult += 0.01;
        //EnemyLastSeen = 0;
		BlockReactions();
		bCanConverse = False;
		bAttacking = True;
		bStasis = False;
		SetDistress(true);

		CrouchTimer = 0;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bCanFire      = false;
		bFacingTarget = false;

		ResetReactions();
		bCanConverse = True;
		bAttacking = False;
		bStasis = True;
		bReadyToReload = false;

        bSpottedPlayer = False;
	    CombatSeeTimer = 0;
	    sFire = 0;
	    bGunVisual = False;
		EndCrouch();
	}

Begin:
	if (Enemy == None)
		GotoState('Seeking');
	//EnemyLastSeen = 0;
	CheckAttack(false);

Surprise:
	if ((1.0-ReactionLevel)*SurprisePeriod < 0.25)
		Goto('BeginAttack');
	Acceleration=vect(0,0,0);
	PlaySurpriseSound();
	PlayWaiting();
	while (ReactionLevel < 1.0)
	{
		TurnToward(Enemy);
		Sleep(0);
	}

BeginAttack:
	EnemyReadiness = 1.0;
	ReactionLevel  = 1.0;
	if (PlayerAgitationTimer > 0)
		PlayAllianceHostileSound();
	else
		PlayTargetAcquiredSound();
	if (PlayBeginAttack())
	{
		Acceleration = vect(0,0,0);
		TurnToward(enemy);
		FinishAnim();
	}

RunToRange:
	bCanFire       = false;
	bFacingTarget  = false;
	bReadyToReload = false;
	EndCrouch();
	if (Physics == PHYS_Falling)
		TweenToRunning(0.05);
	WaitForLanding();
	if (!IsWeaponReloading() || bCrouching)
	{
		if (ShouldPlayTurn(Enemy.Location))
			PlayTurning();
		TurnToward(enemy);
	}
	else
		Sleep(0);
	bCanFire = true;
	if (bCanStrafe && FRand() < smartStrafeRate && EnemyLastSeen < EnemyTimeout - 1.5)
	{
	    bSmartStrafe = True;
	    //if (FRand() < 0.9) //Sarge: Remove this, let them always fire.
	       bCanFire = True;
	    //if (!ActorReachable(Enemy))
        //    bSmartStrafe = False;
	}
	else
        bSmartStrafe = False;
	while (PickDestination() == DEST_NewLocation)
	{
		if (bCanStrafe && ShouldStrafe())
		{
			PlayRunningAndFiring();
			if (destPoint != None)
		        StrafeFacing(destPoint.Location, enemy);
			else
				StrafeFacing(destLoc, enemy);
			bFacingTarget = true;
			if (bGrenadier) //CyberP: nade throw
	        {
              if (FRand() < 0.02 + nadeMult)
                    checkNadeThrow();
              if (bCanNade)
              {
                CheckAttack(false);
                if (sFire > 0)
                   TurnTo(GMDXEnemyLastSeenPos);
                else
                   TurnToward(enemy);
                FinishAnim();
                PlayAnimPivot('Attack',1.1,0.1);
                Sleep(0.3);
                if (animSequence == 'Attack')
                    nadeThrow();
                bCanNade = False;
                Sleep(0.2);
                FinishAnim();
                PlayWaiting();
             }
             }
		}
		else
		{
			bFacingTarget = false;
			PlayRunning();
			if (IsA('Greasel'))
	        {
	        if (bGreaselShould)
            {
                   //FinishAnim();
	               //CheckAttack(false);
	               bBiteClamp = False;
                   bCanFire = False;
                   RotationRate.Yaw = 2;
                   switchToBestWeapon();
                   PlayAnimPivot('Attack',2.6,0.05);
                   SetPhysics(PHYS_Falling);
                   Velocity = (Vector(Rotation)) * 400;
                   Velocity.Z = 230 + (FRand()*20);
                   bGreaselShould=False;
                   Sleep(0.3);
                   FinishAnim();
                   LoopAnimPivot('Run',runAnimMult,0.1);
                 }
                 if (Physics != PHYS_Swimming && Abs(VSize(enemy.Location -Location)) < 252 && FRand() < 0.8)
                 {
                     TurnToward(enemy);
                 }
                 else if (destPoint != None)
				     MoveToward(destPoint, MaxDesiredSpeed);
			     else
				     MoveTo(destLoc, MaxDesiredSpeed);
             }
			 else if (destPoint != None)
				 MoveToward(destPoint, MaxDesiredSpeed);
			 else
				 MoveTo(destLoc, MaxDesiredSpeed);
		}
		CheckAttack(true);
	}
             if (IsA('Gray'))
             {
                if (enemy != None && !Gray(self).bPsychicAttack && FRand() < 0.4)
		        {
		          if (enemy.IsA('DeusExPlayer') && DeusExPlayer(enemy).bHardCoreMode && DeusExPlayer(enemy).bExtraHardcore &&
                  Abs(VSize(enemy.Location -Location)) > 416 && Abs(VSize(enemy.Location -Location)) < 1536 && enemy.Physics != PHYS_Falling)
		          {
		            if (velocity.X > 0 || velocity.Y > 0 && Physics == PHYS_Walking)
		            {
		                Gray(self).bPsychicAttack = True;
                    }
		          }
		        }
                if (!FastTrace(Enemy.Location, Location))
                    Gray(self).bPsychicAttack = False;
                if (!FastTrace(Enemy.Location+vect(0,0,160), enemy.Location))
                    Gray(self).bPsychicAttack = False;
                if (Gray(self).bPsychicAttack)
                {
                   FinishAnim();
                   bShowPain = False;
                   Gray(self).psychoTime = 0;
                   TurnTo(enemy.Location);
                   PlayAnimPivot('HitFront',0.6,0.1);
                   AmbientSound = sound'GMDXSFX.Ambient.grayradiation';
                   SoundRadius = 255;
                   SoundVolume = 255;
                   bCanFire = False;
                   Velocity = vect(0,0,0);
                   Enemy.Velocity.Z = 100;
                   if (Enemy.IsA('DeusExPlayer'))
                   {
                       DeusExPlayer(enemy).ClientFlash(1,vect(64,64,64));
                       DeusExPlayer(enemy).IncreaseClientFlashLength(6);
                   }
                   Enemy.SetPhysics(PHYS_Falling);
                   Gray(self).bPsychicConfirm = True;
                   FinishAnim();
                   LoopAnimPivot('shoot',0.3,0.1);
                   Sleep(6.0);
                   if (FRand() < 0.7)
                   {
                      FinishAnim();
                      CheckAttack(false);
                      PlayAnimPivot('Attack',1.4,0.1);
                      Sleep(0.4);
                      Gray(self).bPsychicConfirm = False;
                      DeusExPlayer(enemy).ClientFlash(1,vect(64,64,64));
                      enemy.Velocity = vector(ViewRotation) * 2000;
                      enemy.PlaySound(sound'GrayIdle2');
                   }
                   else
                       Gray(self).bPsychicConfirm = False;
                   SoundRadius = default.SoundRadius;
                   SoundVolume = default.SoundVolume;
                   AmbientSound = default.AmbientSound;
                   FinishAnim();
                   LoopAnimPivot('Run',runAnimMult,0.1);
                   bCanFire = True;
                   Gray(self).bPsychicAttack = False;
                }
             }

Fire:
	bCanFire      = false;
	bFacingTarget = false;
	Acceleration = vect(0, 0, 0);

	SwitchToBestWeapon();
	if (FRand() > 0.5)
		bUseSecondaryAttack = true;
	else
		bUseSecondaryAttack = false;
	if (IsHandToHand())
		TweenToAttack(0.15);      //CyberP: 0.15
	else if (ShouldCrouch() && (FRand() < CrouchRate))
	{
		TweenToCrouchShoot(0.15);
		FinishAnim();
		StartCrouch();
	}
	else
		TweenToShoot(0.15);
	if (!IsWeaponReloading() || bCrouching)  //CyberP: gmm
	{
	    /*if ((bIsHuman && sFire > 0 && EnemyLastSeen > 1.5) || (bIsHuman && EnemyLastSeen > 1.5 && !ActorReachable(Enemy)))
	    {
		    TurnTo(GMDXEnemyLastSeenPos);
        }
        else*/
		    TurnToward(enemy);
	}
    FinishAnim();
	if (IsA('HumanMilitary'))
	{
	   if (FRand() < 0.7)
           ShouldMelee();
	   if (bCommandoMelee)
	   {
	   bCommandoMelee = False;
	   FinishAnim();
	   if (IsA('MJ12Commando'))
	      PlayAnimPivot('Attack',1.8,0.1);
	   else
	      PlayAnimPivot('Attack',1.4,0.1);
	   sleep(0.3);
	   if (!IsInState('Dying') && !IsInState('TakingHit'))
	   {
	   if (Abs(VSize(Enemy.Location - Location)) < 112)
       {
	   Enemy.TakeDamage(7,self,Enemy.Location,vect(0,0,0),'Shot');
	   if (Enemy.IsA('DeusExPlayer'))
	   {
           DeusExPlayer(Enemy).ShakeView(0.2,512,12);
           if (Enemy.Weapon != None && Enemy.Weapon.IsA('DeusExWeapon') && DeusExWeapon(Enemy.Weapon).bAimingDown)
	              DeusExWeapon(Enemy.Weapon).ScopeToggle();

       Enemy.SetPhysics(PHYS_Falling);
       if (IsA('MJ12Commando'))
          Enemy.Velocity -= Vector(Enemy.Rotation) * 900;
       else
          Enemy.Velocity -= Vector(Enemy.Rotation) * 300;
       Enemy.Velocity.Z = 20;
       }
       Enemy.PlaySound(sound'pl_fallpain3',SLOT_None,2.0,,,1.2);
       }
	   sleep(0.05);
	   FinishAnim();
	   }
	   }
	}
	if (IsA('Greasel'))
    {
	     if (bGreaselShould)
         {
	               //FinishAnim();
	               //CheckAttack(false);
	               bBiteClamp = False;
                   bCanFire = False;
                   RotationRate.Yaw = 2;
                   switchToBestWeapon();
                   PlayAnimPivot('Attack',2.6,0.05);
                   SetPhysics(PHYS_Falling);
                   Velocity = (Vector(Rotation)) * 400;
                   Velocity.Z = 230 + (FRand()*20);
                   bGreaselShould=False;
                   Sleep(0.3);
                   FinishAnim();
                   LoopAnimPivot('Run',runAnimMult,0.1);
         }
    }
	else if (bGrenadier) //CyberP: nade throw
	{
              if (FRand() < 0.02 + nadeMult)
                    checkNadeThrow();
              if (bCanNade)
              {
                CheckAttack(false);
			    if (sFire > 0)
                   TurnTo(GMDXEnemyLastSeenPos);
                else
                   TurnToward(enemy);
			    FinishAnim();
                PlayAnimPivot('Attack',1.1,0.1);
                Sleep(0.3);
                if (animSequence == 'Attack')
                    nadeThrow();
                bCanNade = False;
                Sleep(0.2);
                FinishAnim();
                PlayWaiting();
             }
    }
    else if (IsA('MIB'))
    {
		   ShouldRadialBlast();
		   if (AnimSequence == 'Pickup')
		   {
		   sleep(0.7);
		   SystemShocked();
		   }
	}
	bReadyToReload = true;

ContinueFire:
	while (!ReadyForWeapon())
	{
		if (PickDestination() != DEST_SameLocation)
			Goto('RunToRange');
		CheckAttack(true);
		if (!IsWeaponReloading() || bCrouching)
		{
		    /*if ((bIsHuman && sFire > 0 && EnemyLastSeen > 1.5) || (bIsHuman && EnemyLastSeen > 1.5 && !ActorReachable(Enemy)))
		    {
		        TurnTo(GMDXEnemyLastSeenPos);
            }
            else*/
			    TurnToward(enemy);
		}
        else
			Sleep(0);
	}

	CheckAttack(true);
	if (!FireIfClearShot())
		Goto('ContinueAttack');
	bReadyToReload = false;
	if (bCrouching)
		PlayCrouchShoot();
	else if (IsHandToHand())
		PlayAttack();
	else
		PlayShoot();
	FinishAnim();
	if (IsA('Greasel'))
    {
	     if (bGreaselShould)
         {
	               //FinishAnim();
	               //CheckAttack(false);
	               bBiteClamp = False;
                   bCanFire = False;
                   RotationRate.Yaw = 2;
                   switchToBestWeapon();
                   PlayAnimPivot('Attack',2.6,0.05);
                   SetPhysics(PHYS_Falling);
                   Velocity = (Vector(Rotation)) * 400;
                   Velocity.Z = 230 + (FRand()*20);
                   bGreaselShould=False;
                   Sleep(0.3);
                   FinishAnim();
                   LoopAnimPivot('Run',runAnimMult,0.1);
         }
    }
	else if (IsA('MIB'))
        {
		   ShouldRadialBlast();
		   if (AnimSequence == 'Pickup')
		   {
		   sleep(0.7);
		   SystemShocked();
		   }
		}
    if (IsA('HumanMilitary'))
	{
	   if (FRand() < 0.7)
	       ShouldMelee();
	   if (bCommandoMelee)
	   {
	   bCommandoMelee = False;
	   FinishAnim();
	   if (IsA('MJ12Commando'))
	      PlayAnimPivot('Attack',1.8,0.1);
	   else
	      PlayAnimPivot('Attack',1.5,0.1);
	   sleep(0.35);
	   if (!IsInState('Dying') && !IsInState('TakingHit'))
	   {
	   if (Abs(VSize(Enemy.Location - Location)) < 112)
       {
	   Enemy.TakeDamage(8,self,Enemy.Location,vect(0,0,0),'Shot');
	   if (Enemy.IsA('DeusExPlayer') && !DeusExPlayer(Enemy).RestrictInput())
	   {
           DeusExPlayer(Enemy).ShakeView(0.2,512,12);
           if (Enemy.Weapon != None && Enemy.Weapon.IsA('DeusExWeapon') && DeusExWeapon(Enemy.Weapon).bAimingDown)
	              DeusExWeapon(Enemy.Weapon).ScopeToggle();
       Enemy.SetPhysics(PHYS_Falling);
       if (IsA('MJ12Commando'))
          Enemy.Velocity -= Vector(Enemy.Rotation) * 900;
       else
          Enemy.Velocity -= Vector(Enemy.Rotation) * 400;
       Enemy.Velocity.Z = 20;
       }
       Enemy.PlaySound(sound'pl_fallpain3',SLOT_None,2.0,,,1.2);
       }
	   sleep(0.05);
	   FinishAnim();
	   }
	   }
	}
	if (bGrenadier) //CyberP: nade throw
	{
              if (FRand() < 0.02 + nadeMult)
                    checkNadeThrow();
              if (bCanNade)
              {
                CheckAttack(false);
                if (sFire > 0)
                   TurnTo(GMDXEnemyLastSeenPos);
                else
                   TurnToward(enemy);
                FinishAnim();
                PlayAnimPivot('Attack',1.1,0.1);
                Sleep(0.3);
                if (animSequence == 'Attack')
                    nadeThrow();
                bCanNade = False;
                Sleep(0.2);
                FinishAnim();
                PlayWaiting();
             }
    }
	if (FRand() > 0.5)
		bUseSecondaryAttack = true;
	else
		bUseSecondaryAttack = false;
	bReadyToReload = true;
	if (!IsHandToHand())
	{
		if (bCrouching)
			TweenToCrouchShoot(0);
		else
			TweenToShoot(0);
	}
	CheckAttack(true);
	if (PickDestination() != DEST_NewLocation)
	{
		if (!IsWeaponReloading() || bCrouching)
		{
		    /*if ((bIsHuman && sFire > 0 && EnemyLastSeen > 1.5) || (bIsHuman && EnemyLastSeen > 1.5 && !ActorReachable(Enemy)))
		    {
		        TurnTo(GMDXEnemyLastSeenPos);
            }
            else*/
			    TurnToward(enemy);
		}
		else
			Sleep(0);
		Goto('ContinueFire');
	}
	Goto('RunToRange');

ContinueAttack:
ContinueFromDoor:
    CheckAttack(true);
    if (PickDestination() != DEST_NewLocation)
		Goto('Fire');
	else
		Goto('RunToRange');

}


// ----------------------------------------------------------------------
// state Alerting
//
// Warn other NPCs that an enemy is about
// ----------------------------------------------------------------------

State Alerting
{
	function SetFall()
	{
		StartFalling('Alerting', 'ContinueAlert');
	}

	function Tick(float deltaSeconds)
	{
		Global.Tick(deltaSeconds);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Bump(actor bumper)
	{

	    if (bAcceptBump && bumper.IsA('DeusExPlayer'))      //CyberP: attack player blocking alarm
        {
	    if (weapon != None && AnimSequence != 'PushButton')
          if (VSize(Velocity) > 0 && GetPawnAllianceType(DeusExPlayer(bumper)) == ALLIANCE_Hostile)
          {
             GoToState('Attacking','Fire');
             return;
          }
        }
		if (bAcceptBump)
		{
			if (bumper == AlarmActor)
			{
				bAcceptBump = False;
				GotoState('Alerting', 'SoundAlarm');
			}
		}

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function bool IsAlarmReady(Actor actorAlarm)
	{
		local bool      bReady;
		local AlarmUnit alarm;

		bReady = false;
		alarm = AlarmUnit(actorAlarm);
		if ((alarm != None) && !alarm.bDeleteMe)
			if (!alarm.bActive)
				if ((alarm.associatedPawn == None) ||
				    (alarm.associatedPawn == self))
					bReady = true;

		return bReady;
	}

	function TriggerAlarm()
	{
	local DeusExPlayer playa;

		if ((AlarmActor != None) && !AlarmActor.bDeleteMe)
		{
		    playa = DeusExPlayer(GetPlayerPawn());

			if (AlarmActor.hackStrength > 0)  // make sure the alarm hasn't been hacked
				AlarmActor.Trigger(self, Enemy);
			else if (playa != None &&  playa.PerkManager.GetPerkWithClass(class'DeusEx.PerkSabotage').bPerkObtained == true)  //CyberP: shock the pawn
                TakeDamage(200,self,vect(0,0,0),vect(0,0,0),'Stunned');
		}
	}

	function bool IsAlarmInRange(AlarmUnit alarm)
	{
		local bool bInRange;

		bInRange = false;
		if ((alarm != None) && !alarm.bDeleteMe)
			if ((VSize((alarm.Location-Location)*vect(1,1,0)) <
			     (CollisionRadius+alarm.CollisionRadius+24)) &&
			    (Abs(alarm.Location.Z-Location.Z) < (CollisionHeight+alarm.CollisionHeight)))
				bInRange = true;

		return (bInRange);
	}

	function vector FindAlarmPosition(Actor alarm)
	{
		local vector alarmPos;

		alarmPos = alarm.Location;
		alarmPos += vector(alarm.Rotation.Yaw*rot(0,1,0))*(CollisionRadius+alarm.CollisionRadius);

		return (alarmPos);
	}

	function bool GetNextAlarmPoint(AlarmUnit alarm)
	{
		local vector alarmPoint;
		local bool   bValid;

		destPoint = None;
		destLoc   = vect(0,0,0);
		bValid    = false;

		if ((alarm != None) && !alarm.bDeleteMe)
		{
			alarmPoint = FindAlarmPosition(alarm);
			if (PointReachable(alarmPoint))
			{
				destLoc = alarmPoint;
				bValid = true;
			}
			else
			{
				MoveTarget = FindPathTo(alarmPoint);
				if (MoveTarget != None)
				{
					destPoint = MoveTarget;
					bValid = true;
				}
			}
		}

		return (bValid);
	}

	function AlarmUnit FindTarget()
	{
		local ScriptedPawn pawnAlly;
		local AlarmUnit    alarm;
		local float        dist;
		local AlarmUnit    bestAlarm;
		local float        bestDist;

		bestAlarm = None;

		// Do we have any allies on this level?
		foreach AllActors(Class'ScriptedPawn', pawnAlly)
			if (GetPawnAllianceType(pawnAlly) == ALLIANCE_Friendly)
				break;

		// Yes, so look for an alarm box that isn't active...
		if (pawnAlly != None)
		{
			foreach RadiusActors(Class'AlarmUnit', alarm, 3200) //CyberP: was 2400
			{
				if (GetAllianceType(alarm.Alliance) != ALLIANCE_Hostile)
				{
					dist = VSize((Location-alarm.Location)*vect(1,1,2));  // use squished sphere
					if ((bestAlarm == None) || (dist < bestDist))
					{
						bestAlarm = alarm;
						bestDist  = dist;
					}
				}
			}

			// Is the nearest alarm already going off?  And can we reach it?
			if (!IsAlarmReady(bestAlarm) || !GetNextAlarmPoint(bestAlarm))
				bestAlarm = None;
		}

		// Return our target alarm box
		return (bestAlarm);
	}

	function bool PickDestination()
	{
		local bool      bDest;
		local AlarmUnit alarm;

		// Init
		destPoint = None;
		destLoc   = vect(0, 0, 0);
		bDest     = false;

		// Find an alarm we can trigger
		alarm = FindTarget();
		if (alarm != None)
		{
			// Find a way to get there
			AlarmActor = alarm;
			alarm.associatedPawn = self;
			bDest = true;  // if alarm != none, we've already computed the route to the alarm
		}

		// Return TRUE if we were successful
		return (bDest);
	}

	function BeginState()
	{
		StandUp();
		//Disable('AnimEnd');
		bAcceptBump = False;
		bCanConverse = False;
		AlarmActor = None;
		bStasis = False;
		BlockReactions();
		//SetupWeapon(false);
		SetDistress(false);
		EnemyReadiness = 1.0;
		ReactionLevel  = 1.0;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		ResetReactions();
		bAcceptBump = False;
		//Enable('AnimEnd');
		bCanConverse = True;
		if (AlarmActor != None)
			if (AlarmActor.associatedPawn == self)
				AlarmActor.associatedPawn = None;
		AlarmActor = None;
		bStasis = True;
	}

Begin:
	//if (Enemy == None && RaiseAlarm != RAISEALARM_BeforeAttacking && Health > minHealth) //CyberP: added extra condition for pawns who spot carci
	//	GotoState('Seeking');
	//EnemyLastSeen = 0;
	destPoint = None;
	if (RaiseAlarm == RAISEALARM_Never)
		GotoState('Fleeing');
	if (AlarmTimer == 0 && Health > MinHealth && Weapon != None) //(AlarmTimer > 0)
		PlayGoingForAlarmSound();

Alert:
	if (AlarmTimer > 0)
		Goto('Done');

	WaitForLanding();
	if (!PickDestination())
		Goto('Done');

Moving:
	// Can we go somewhere?
	bAcceptBump = True;
	EnableCheckDestLoc(true);
	while (true)
	{
		if (destPoint != None)
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
		}
		else
		{
			if (ShouldPlayWalk(destLoc))
				PlayRunning();
			MoveTo(destLoc, MaxDesiredSpeed);
			CheckDestLoc(destLoc);
		}
		if (IsAlarmInRange(AlarmActor))
			break;
		else if (!GetNextAlarmPoint(AlarmActor))
			break;
	}
	EnableCheckDestLoc(false);

SoundAlarm:
	Acceleration=vect(0,0,0);
	bAcceptBump = False;
	if (IsAlarmInRange(AlarmActor))
	{
		TurnToward(AlarmActor);
		PlayPushing();
		FinishAnim();
		TriggerAlarm();
	}

Done:
	bAcceptBump = False;
	//if (RaiseAlarm == RAISEALARM_BeforeAttacking && enemy != None && Health > minHealth && EnemyLastSeen < 6.0)
	//	GotoState('Attacking');
    //if (RaiseAlarm == RAISEALARM_BeforeAttacking && Health > minHealth)
	//{
	//    bReactAlarm=True;
	//    GoToState('Seeking');
	//}
    if (Weapon == None || Health <= MinHealth)
		GotoState('Fleeing');
	else if (RaiseAlarm == RAISEALARM_BeforeAttacking && Weapon != None && enemy != None && Health > minHealth && EnemyLastSeen < 6.0)
		GotoState('Attacking');
	//else if (Weapon != None && Enemy != None && EnemyLastSeen < 5.0)
    //    GotoState('Attacking');
	else if (Enemy == None && Weapon != None)
        GoToState('Seeking');
    else
        GotoState('Fleeing');

ContinueAlert:
ContinueFromDoor:
	Goto('Alert');

}


// ----------------------------------------------------------------------
// state Shadowing
//
// Quietly tail another character
// ----------------------------------------------------------------------

State Shadowing
{
	function SetFall()
	{
		StartFalling('Shadowing', 'ContinueShadow');
	}

	function Tick(float deltaSeconds)
	{
		local bool  bMove;
		local float deltaValue;

		Global.Tick(deltaSeconds);

		deltaValue = deltaSeconds;

		// If we're running, and we can see our target, STOP RUNNING!
		if (bRunningStealthy)
		{
			UpdateActorVisibility(orderActor, deltaValue, 0.0, false);
			deltaValue = 0;
			if (EnemyLastSeen <= 0)
			{
				bRunningStealthy = False;
				PlayWalking();
				DesiredSpeed = GetWalkingSpeed();
			}
		}

		// Are we stopped?
		if (bPausing)
		{
			// Can we see our target?
			bMove = False;
			UpdateActorVisibility(orderActor, deltaValue, 0.5, false);
			deltaValue = 0;

			// No -- move toward him!
			if (EnemyLastSeen > 0.5)
				bMove = True;

			// We can see him, and we're staring...
			else if (bStaring)
			{
				// ...can he see us staring at him?
				if ((Pawn(orderActor) != None) &&
				    (Pawn(orderActor).AICanSee(self, , false, true, false, false) > 0))
					bMove = True;  // Time to look inconspicuous
			}

			// Move if we need to
			if (bMove)
			{
				if (bStaring)
					GotoState('Shadowing', 'StopStaring');
				else
					GotoState('Shadowing', 'StopPausing');
				bPausing = False;
				bStaring = False;
			}
		}
	}

	function Bump(actor bumper)
	{
		if (bAcceptBump)
		{
			// If we get bumped by another actor while we wait, start wandering again
			bAcceptBump = False;
			bPausing = False;
			bStaring = False;
			Disable('AnimEnd');
			GotoState('Shadowing', 'Shadow');
		}

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function float DistanceToTarget()
	{
		return (VSize(Location-orderActor.Location));
	}

	function bool PickDestination()
	{
		local Actor   destActor;
		local Vector  distVect;
		local Rotator relativeRotation;
		local float   magnitude;
		local float   minDist;
		local float   maxDist;
		local float   bestDist;
		local bool    bDest;
		local float   dist;

		// Init
		destPoint = None;
		destLoc   = vect(0, 0, 0);

		// Conveniences
		destActor = orderActor;
		minDist   = 400;
		maxDist   = 700;
		bestDist  = (maxDist+minDist)*0.5;

		distVect  = Location - destActor.Location;
		magnitude = VSize(distVect);

		bDest = False;

		// Can we see the target?
		if (AICanSee(destActor, , false, false, false, true) > 0)
		{
			relativeRotation = Rotator(distVect);

			// How far will we go?
			dist = (wanderlust*300+150) * (FRand()*0.2+0.9); // 150-450, +/-10%

			// Move around inconspicuously, like we're just wandering
			if (magnitude < minDist)  // too close -- move away
				bDest = AIPickRandomDestination(100, dist,
				                                relativeRotation.Yaw, 0.8, relativeRotation.Pitch, 0.8,
				                                3, FRand()*0.4+0.35, destLoc);

			else if (magnitude < maxDist)  // just right -- move normally
				bDest = AIPickRandomDestination(100, dist,
				                                relativeRotation.Yaw+32768, 0, -relativeRotation.Pitch, 0,
				                                2, FRand()*0.4+0.35, destLoc);

			else  // too far -- move closer
				bDest = AIPickRandomDestination(100, dist,
				                                relativeRotation.Yaw+32768, 0.8, -relativeRotation.Pitch, 0.8,
				                                3, FRand()*0.4+0.35, destLoc);
		}

		// Nope -- find a path towards him
		else
		{
			MoveTarget = FindPathToward(destActor);
			if (MoveTarget != None)
			{
				if (!MoveTarget.Region.Zone.bWaterZone && (MoveTarget.Physics != PHYS_Falling))
				{
					destPoint = MoveTarget;
					bDest = True;
				}
			}
		}

		// Return TRUE if we found a place to go
		return (bDest);

	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bRunningStealthy = False;
		bPausing = False;
		bStaring = False;
		bStasis = False;
		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = False;
		Enable('AnimEnd');
		bRunningStealthy = False;
		bPausing = False;
		bStaring = False;
		bStasis = True;
	}

Begin:
	EnemyLastSeen = 0;
	destPoint = None;

Shadow:
	WaitForLanding();

Moving:
	Sleep(0.0);

	// Can we go somewhere?
	if (PickDestination())
	{
		// Are we going to a navigation point?
		if (destPoint != None)
		{
			if (MoveTarget != None)
			{
				// Run if we're too far away, and we can't see our target
				if ((DistanceToTarget() > 900) &&
				    (AICanSee(orderActor, , false, true, true, true) <= 0))
				{
					bRunningStealthy = True;
					if (ShouldPlayWalk(MoveTarget.Location))
						PlayRunning();
					MoveToward(MoveTarget, MaxDesiredSpeed);
				}

				// Otherwise, walk nonchalantly
				else
				{
					bRunningStealthy = False;
					if (ShouldPlayWalk(MoveTarget.Location))
						PlayWalking();
					MoveToward(MoveTarget, GetWalkingSpeed());
				}
			}
		}

		// No pathnode, so walk to a point
		else
		{
			bRunningStealthy = False;
			if (ShouldPlayWalk(destLoc))
				PlayWalking();
			MoveTo(destLoc, GetWalkingSpeed());
		}
	}

	// Can we see the target?  If not, keep walking
	if (AICanSee(orderActor, , false, false, false, true) <= 0)
		Goto('Moving');

Pausing:
	// Stop
	bRunningStealthy = False;
	Acceleration = vect(0, 0, 0);

	// Can the target see us?  If not, stare!
	if (orderActor.IsA('Pawn') && Pawn(orderActor).AICanSee(self, , false, true, false, false) <= 0)
		Goto('Staring');

	// Stop normally
	sleepTime = 6.0;
	Enable('AnimEnd');
	TweenToWaiting(0.2);
	bAcceptBump = True;
	sleepTime *= (-0.9*restlessness) + 1;
	bStaring = False;
	bPausing = True;
	Sleep(sleepTime);

StopPausing:
	// Time to move again
	bPausing = False;
	bStaring = False;
	Disable('AnimEnd');
	bAcceptBump = False;
	FinishAnim();
	Goto('Shadow');

Staring:
	// Stare at the target
	PlayTurning();
	TurnToward(orderActor);

	Enable('AnimEnd');
	TweenToWaiting(0.2);

	// Don't move 'til he looks at us
	bAcceptBump = True;
	bStaring = True;
	bPausing = True;
	while (true)
	{
		PlayTurning();
		TurnToward(orderActor);
		TweenToWaiting(0.2);
		Sleep(0.25);
	}

StopStaring:
	// He's looking, or we can't see him -- time to move
	bPausing = False;
	bStaring = False;
	Disable('AnimEnd');
	bAcceptBump = False;
	FinishAnim();
	Goto('Shadow');

ContinueShadow:
ContinueFromDoor:
	FinishAnim();
	PlayRunning();
	Goto('Moving');
}


// ----------------------------------------------------------------------
// state Following
//
// Follow an actor
// ----------------------------------------------------------------------

state Following
{
	function SetFall()
	{
		StartFalling('Following', 'ContinueFollow');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Tick(float deltaSeconds)
	{
		Global.Tick(deltaSeconds);

		if (BackpedalTimer >= 0)
			BackpedalTimer += deltaSeconds;

		animTimer[1] += deltaSeconds;
		if ((Physics == PHYS_Walking) && (orderActor != None))
		{
			if (Acceleration == vect(0,0,0))
				LookAtActor(orderActor, true, true, true, 0, 0.25);
			else
				PlayTurnHead(LOOK_Forward, 1.0, 0.25);
		}
	}

	function bool PickDestination()
	{
		local float   dist;
		local float   extra;
		local float   distMax;
		local int     dir;
		local rotator rot;
		local bool    bSuccess;

		bSuccess = false;
		destPoint = None;
		destLoc   = vect(0, 0, 0);
		extra = orderActor.CollisionRadius + CollisionRadius;
		dist = VSize(orderActor.Location - Location);
		dist -= extra;
		if (dist < 0)
			dist = 0;

		if ((dist > 180) || (AICanSee(orderActor, , false, false, false, true) <= 0))
		{
			if (ActorReachable(orderActor))
			{
				rot = Rotator(orderActor.Location - Location);
				distMax = (dist-180)+45;
				if (distMax > 80)
					distMax = 80;
				bSuccess = AIDirectionReachable(Location, rot.Yaw, rot.Pitch, 0, distMax, destLoc);
			}
			else
			{
				MoveTarget = FindPathToward(orderActor);
				if (MoveTarget != None)
				{
					destPoint = MoveTarget;
					bSuccess = true;
				}
			}
			BackpedalTimer = -1;
		}
		else if (dist < 60)
		{
			if (BackpedalTimer < 0)
				BackpedalTimer = 0;
			if (BackpedalTimer > 1.0)  // give the player enough time to converse, if he wants to
			{
				rot = Rotator(Location - orderActor.Location);
				bSuccess = AIDirectionReachable(orderActor.Location, rot.Yaw, rot.Pitch, 60+extra, 120+extra, destLoc);
			}
		}
		else
			BackpedalTimer = -1;

		return (bSuccess);
	}

	function BeginState()
	{
		StandUp();
		//Disable('AnimEnd');
		bStasis = False;
		SetupWeapon(false);
		SetDistress(false);
		BackpedalTimer = -1;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = False;
		//Enable('AnimEnd');
		bStasis = True;
		StopBlendAnims();
	}

Begin:
	Acceleration = vect(0, 0, 0);
	destPoint = None;
	if (orderActor == None)
		GotoState('Standing');

	if (!PickDestination())
		Goto('Wait');

Follow:
	if (destPoint != None)
	{
		if (MoveTarget != None)
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
		}
		else
			Sleep(0.0);  // this shouldn't happen
	}
	else
	{
		if (ShouldPlayWalk(destLoc))
			PlayRunning();
		MoveTo(destLoc, MaxDesiredSpeed);
		CheckDestLoc(destLoc);
	}
	if (PickDestination())
		Goto('Follow');

Wait:
	//PlayTurning();
	//TurnToward(orderActor);
	PlayWaiting();

WaitLoop:
	Acceleration=vect(0,0,0);
	Sleep(0.0);
	if (!PickDestination())
		Goto('WaitLoop');
	else
		Goto('Follow');

ContinueFollow:
ContinueFromDoor:
	Acceleration=vect(0,0,0);
	if (PickDestination())
		Goto('Follow');
	else
		Goto('Wait');

}


// ----------------------------------------------------------------------
// state WaitingFor
//
// Wait for a pawn to become visible, then move to it
// ----------------------------------------------------------------------

state WaitingFor
{
	function SetFall()
	{
		StartFalling('WaitingFor', 'ContinueFollow');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Bump(actor bumper)
	{
		// If we hit the guy we're going to, end the state
		if (bumper == OrderActor)
			GotoState('WaitingFor', 'Done');

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function Touch(actor toucher)
	{
		// If we hit the guy we're going to, end the state
		if (toucher == OrderActor)
			GotoState('WaitingFor', 'Done');

		// Handle conversations, if need be
		Global.Touch(toucher);
	}

	function BeginState()
	{
		StandUp();
		//BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = True;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}
	function EndState()
	{
		EnableCheckDestLoc(false);
		//ResetReactions();
		bStasis = True;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		GotoState('Idle');
	PlayWaiting();

Wait:
	Sleep(1.0);
	if (AICanSee(orderActor, 1.0, false, true, false, true) <= 0)
		Goto('Wait');
	bStasis = False;

Follow:
	if (IsOverlapping(orderActor))
		Goto('Done');
	MoveTarget = GetNextWaypoint(orderActor);
	if ((MoveTarget != None) && (!MoveTarget.Region.Zone.bWaterZone) &&
	    (MoveTarget.Physics != PHYS_Falling))
	{
		if ((MoveTarget == orderActor) && MoveTarget.IsA('Pawn'))
		{
			if (GetNextVector(orderActor, useLoc))
			{
				if (ShouldPlayWalk(useLoc))
					PlayRunning();
				MoveTo(useLoc, MaxDesiredSpeed);
				CheckDestLoc(useLoc);
			}
			else
				Goto('Pause');
		}
		else
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
		}
		if (IsOverlapping(orderActor))
			Goto('Done');
		else
			Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	GotoState('Standing');

ContinueFollow:
ContinueFromDoor:
	PlayRunning();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state GoingTo
//
// Move to an actor.
// ----------------------------------------------------------------------

state GoingTo
{
	function SetFall()
	{
		StartFalling('GoingTo', 'ContinueGo');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Bump(actor bumper)
	{
		// If we hit the guy we're going to, end the state
		if (bumper == OrderActor)
			GotoState('GoingTo', 'Done');

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function Touch(actor toucher)
	{
		// If we hit the guy we're going to, end the state
		if (toucher == OrderActor)
			GotoState('GoingTo', 'Done');

		// Handle conversations, if need be
		Global.Touch(toucher);
	}

	function BeginState()
	{
		StandUp();
		//BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = False;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		//ResetReactions();
		bStasis = True;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		Goto('Done');

Follow:
	if (IsOverlapping(orderActor))
		Goto('Done');
	MoveTarget = GetNextWaypoint(orderActor);
	if ((MoveTarget != None) && (!MoveTarget.Region.Zone.bWaterZone) &&
	    (MoveTarget.Physics != PHYS_Falling))
	{
		if ((MoveTarget == orderActor) && MoveTarget.IsA('Pawn'))
		{
			if (GetNextVector(orderActor, useLoc))
			{
				if (ShouldPlayWalk(useLoc))
					PlayWalking();
				MoveTo(useLoc, GetWalkingSpeed());
				CheckDestLoc(useLoc);
			}
			else
				Goto('Pause');
		}
		else
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayWalking();
			MoveToward(MoveTarget, GetWalkingSpeed());
			CheckDestLoc(MoveTarget.Location, true);
		}
		if (IsOverlapping(orderActor))
			Goto('Done');
		else
			Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	if (orderActor.IsA('PatrolPoint'))
		TurnTo(Location + PatrolPoint(orderActor).lookdir);
	GotoState('Standing');

ContinueGo:
ContinueFromDoor:
	PlayWalking();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state RunningTo
//
// Move to an actor really fast.
// ----------------------------------------------------------------------

state RunningTo
{
	function SetFall()
	{
		StartFalling('RunningTo', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function Bump(actor bumper)
	{
		// If we hit the guy we're going to, end the state
		if (bumper == OrderActor)
			GotoState('RunningTo', 'Done');

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function Touch(actor toucher)
	{
		// If we hit the guy we're going to, end the state
		if (toucher == OrderActor)
			GotoState('RunningTo', 'Done');

		// Handle conversations, if need be
		Global.Touch(toucher);
	}

	function BeginState()
	{
		StandUp();
		//BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = False;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}
	function EndState()
	{
		EnableCheckDestLoc(false);
		//ResetReactions();
		bStasis = True;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		Goto('Done');

Follow:
	if (IsOverlapping(orderActor))
		Goto('Done');
	MoveTarget = GetNextWaypoint(orderActor);
	if ((MoveTarget != None) && (!MoveTarget.Region.Zone.bWaterZone) &&
	    (MoveTarget.Physics != PHYS_Falling))
	{
		if ((MoveTarget == orderActor) && MoveTarget.IsA('Pawn'))
		{
			if (GetNextVector(orderActor, useLoc))
			{
				if (ShouldPlayWalk(useLoc))
					PlayRunning();
				MoveTo(useLoc, MaxDesiredSpeed);
				CheckDestLoc(useLoc);
			}
			else
				Goto('Pause');
		}
		else
		{
			if (ShouldPlayWalk(MoveTarget.Location))
				PlayRunning();
			MoveToward(MoveTarget, MaxDesiredSpeed);
			CheckDestLoc(MoveTarget.Location, true);
		}
		if (IsOverlapping(orderActor))
			Goto('Done');
		else
			Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	if (orderActor.IsA('PatrolPoint'))
		TurnTo(Location + PatrolPoint(orderActor).lookdir);
	GotoState('Standing');

ContinueRun:
ContinueFromDoor:
	PlayRunning();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state DebugFollowing
//
// Following state used for pathnode testing
// ----------------------------------------------------------------------

state DebugFollowing
{
	function SetFall()
	{
		StartFalling('DebugFollowing', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function BeginState()
	{
		StandUp();
		BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = false;
		EnableCheckDestLoc(false);
	}
	function EndState()
	{
		EnableCheckDestLoc(false);
		ResetReactions();
		bStasis = true;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		Goto('Done');

Follow:
	MoveTarget = GetNextWaypoint(orderActor);
	if (MoveTarget != None)
	{
		if (ShouldPlayWalk(MoveTarget.Location))
			PlayRunning();
		MoveToward(MoveTarget, 1.0);
		Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Standing');

ContinueRun:
ContinueFromDoor:
	PlayRunning();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state DebugPathfinding
//
// Following state used for pathnode testing
// ----------------------------------------------------------------------

state DebugPathfinding
{
	function SetFall()
	{
		StartFalling('DebugPathfinding', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function BeginState()
	{
		StandUp();
		BlockReactions();
		SetupWeapon(false);
		SetDistress(false);
		bStasis = false;
		EnableCheckDestLoc(false);
	}
	function EndState()
	{
		EnableCheckDestLoc(false);
		ResetReactions();
		bStasis = true;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	if (orderActor == None)
		Goto('Done');

Follow:
	MoveTarget = FindPathToward(orderActor);
	if (MoveTarget != None)
	{
		if (ShouldPlayWalk(MoveTarget.Location))
			PlayRunning();
		MoveToward(MoveTarget, 1.0);
		Goto('Follow');
	}

Pause:
	Acceleration = vect(0, 0, 0);
	TurnToward(orderActor);
	PlayWaiting();
	Sleep(1.0);
	Goto('Follow');

Done:
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Standing');

ContinueRun:
ContinueFromDoor:
	PlayRunning();
	Goto('Follow');
}


// ----------------------------------------------------------------------
// state Burning
//
// Whoa-oh-oh, I'm on fire.
// ----------------------------------------------------------------------

state Burning
{
	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		local name newLabel;

		if (health > 0)
		{
			if (enemy != instigatedBy)
			{
				SetEnemy(instigatedBy);
				newLabel = 'NewEnemy';
			}
			else
				newLabel = 'ContinueBurn';

			if ( Enemy != None )
				LastSeenPos = Enemy.Location;
			SetNextState('Burning', newLabel);
			if ((damageType != 'TearGas') && (damageType != 'HalonGas') && (damageType != 'Stunned'))
				GotoDisabledState(damageType, hitPos);
		}
	}

	function SetFall()
	{
		StartFalling('Burning', 'ContinueBurn');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		//Global.HitWall(HitNormal, Wall);
		//BroadcastMessage("Hitwall");
		//PickDestination(); //CyberP: stop running into walls
		CheckOpenDoor(HitNormal, Wall);
	}

	function PickDestination()
	{
		local float           magnitude;
		local float           distribution;
		local int             yaw, pitch;
		local Rotator         rotator1;
		local NavigationPoint nav;
		local float           dist;
		local NavigationPoint bestNav;
		local float           bestDist;

		destPoint = None;
		bestNav   = None;
		bestDist  = 2000;   // max distance to water

		// Seek out water

		if (bCanSwim)
		{
			nav = Level.NavigationPointList;
			while (nav != None)
			{
				if (nav.Region.Zone.bWaterZone)
				{
					dist = VSize(Location - nav.Location);
					if (dist < bestDist)
					{
						bestNav  = nav;
						bestDist = dist;
					}
				}
				nav = nav.nextNavigationPoint;
			}
		}

		if (bestNav != None)
		{
			// It'd be nice if we could traverse all pathnodes and figure out their
			// distances...  unfortunately, it's too slow.  :(

			MoveTarget = FindPathToward(bestNav);
			if (MoveTarget != None)
			{
				destPoint = bestNav;
				destLoc   = bestNav.Location;
			}
		}
		if (bestNav == None)
		{
        //CyberP: enemies who can't find water now simply run to any far away navigation nodes in the list to stop them blindly running into walls
        nav = Level.NavigationPointList;
			while (nav != None)
			{
				if (VSize(Location - nav.Location) > 128 && VSize(Location - nav.Location) < 1024)
				    bestNav  = nav;
				nav = nav.nextNavigationPoint;
			}

	     	if (bestNav != None)
	    	{
			// It'd be nice if we could traverse all pathnodes and figure out their
			// distances...  unfortunately, it's too slow.  :(

			MoveTarget = FindPathToward(bestNav);
			if (MoveTarget != None)
			{
				destPoint = bestNav;
				destLoc   = bestNav.Location;
			}
	     	}
        }
		// Can't get to water -- run willy-nilly
		if (destPoint == None)
		{
			if (Enemy == None)
			{
				yaw = 0;
				pitch = 0;
				distribution = 0;
			}
			else
			{
				rotator1 = Rotator(Location-Enemy.Location);
				yaw = rotator1.Yaw;
				pitch = rotator1.Pitch;
				distribution = 0.5;
			}

			magnitude = 300*(FRand()*0.4+0.8);  // 400, +/-20%
			if (!AIPickRandomDestination(100, magnitude, yaw, distribution, pitch, distribution, 4,
			                             FRand()*0.4+0.35, destLoc))
				destLoc = Location+(VRand()*200);  // we give up
		}
	}

	function BeginState()
	{
		StandUp();
		BlockReactions();
		bCanConverse = False;
		SetupWeapon(false, true);
		bStasis = False;
		SetDistress(true);
		EnemyLastSeen = 0;
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		ResetReactions();
		bCanConverse = True;
		bStasis = True;
	}

Begin:
	if (!bOnFire)
		Goto('Done');
	PlayOnFireSound();

NewEnemy:
	Acceleration = vect(0, 0, 0);

Run:
	if (!bOnFire)
		Goto('Done');
	PlayPanicRunning();
	PickDestination();
	if (destPoint != None)
	{
		MoveToward(MoveTarget, MaxDesiredSpeed);
		while ((MoveTarget != None) && (MoveTarget != destPoint))
		{
			MoveTarget = FindPathToward(destPoint);
			if (MoveTarget != None)
				MoveToward(MoveTarget, MaxDesiredSpeed);
		}
	}
	else
		MoveTo(destLoc, MaxDesiredSpeed);
	Goto('Run');

Done:
	if (IsValidEnemy(Enemy))
		HandleEnemy();
	else
		FollowOrders();

ContinueBurn:
ContinueFromDoor:
	Goto('Run');
}


// ----------------------------------------------------------------------
// state AvoidingProjectiles
//
// Run away from a projectile.
// ----------------------------------------------------------------------

state AvoidingProjectiles
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('RunningTo', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function PickDestination(bool bGotoWatch)
	{
		local NearbyProjectileList projList;
		local bool                 bMove;
		local vector               projVector;
		local rotator              projRot;
		local int                  i;
		local int                  bestSlot;
		local float                bestDist;

		destLoc   = vect(0,0,0);
		destPoint = None;
		bMove = false;

		if (GetProjectileList(projList, Location) > 0)
		{
			if (IsLocationDangerous(projList, Location))
			{
				projVector = ComputeAwayVector(projList);
				projRot    = Rotator(projVector);
				if (AIDirectionReachable(Location, projRot.Yaw, projRot.Pitch, CollisionRadius+24, VSize(projVector), destLoc))
				{
					useLoc = Location + vect(0,0,1)*BaseEyeHeight;  // hack
					bMove = true;
				}
			}
		}

		if (bMove)
			GotoState('AvoidingProjectiles', 'RunAway');
		else if (bGotoWatch)
			GotoState('AvoidingProjectiles', 'Watch');
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bCanJump = false;
		SetReactions(true, true, true, true, false, true, true, true, true, true, true, true);
		bStasis = False;
		useLoc = Location + vect(0,0,1)*BaseEyeHeight + Vector(Rotation);
		bCanConverse = False;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		if (JumpZ > 0)
			bCanJump = true;
		ResetReactions();
		bStasis = True;
		bCanConverse = True;
	}

Begin:
	Acceleration = vect(0,0,0);
	PickDestination(true);

RunAway:
	PlayTurnHead(LOOK_Forward, 1.0, 0.0001);
	if (ShouldPlayWalk(destLoc))
		PlayRunning();
	MoveTo(destLoc, MaxDesiredSpeed);
	PickDestination(true);

Watch:
	Acceleration = vect(0,0,0);
	PlayWaiting();
	LookAtVector(useLoc, true, false, true);
	TurnTo(Vector(DesiredRotation)*1000+Location);
	sleepTime = 3.0;
	while (sleepTime > 0)
	{
		sleepTime -= 0.5;
		Sleep(0.5);
		PickDestination(false);
	}

Done:
	if (Orders != 'AvoidingProjectiles')
		FollowOrders();
	else
		GotoState('Wandering');

ContinueRun:
ContinueFromDoor:
	PickDestination(false);
	Goto('Done');

}


// ----------------------------------------------------------------------
// state AvoidingPawn
//
// Run away from an onrushing pawn (used for small, dumb critters only).
// ----------------------------------------------------------------------

state AvoidingPawn
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('AvoidingPawn', 'ContinueAvoid');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function PickDestination()
	{
		local int     iterations;
		local float   magnitude;
		local rotator rot;
		local float   speed;
		local float   time;
		local vector  newPos;
		local float   minDist;

		minDist = 20;
		speed = VSize(Enemy.Velocity);
		if (speed == 0)
			time = 1;
		else
			time  = VSize(Location - Enemy.Location)/speed;
		newPos = Enemy.Location + Enemy.Velocity*(time*0.98);

		magnitude  = 100*(FRand()*0.2+0.9);  // 120, +/-10%
		rot        = Rotator(Location-newPos);
		iterations = 2;
		if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, destLoc))
		{
			rot = Rotator(Location - Enemy.Location);
			if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, destLoc))
			{
				if (speed > 0)
					rot = Rotator(Enemy.Velocity);
				else
					rot = Enemy.Rotation;
				if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, destLoc))
				{
					rot.Yaw   = -rot.Yaw;
					rot.Pitch = -rot.Pitch;
					if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, destLoc))
						destLoc = Location;  // we give up
				}
			}
		}
	}

	function BeginState()
	{
		StandUp();
		bCanJump = false;
		bStasis = False;
		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = True;
		if (JumpZ > 0)
			bCanJump = true;
		bStasis = True;
	}

Begin:
	if (!ShouldBeStartled(Enemy))
		Goto('Done');
	Goto('Avoid');

ContinueFromDoor:
	Goto('Avoid');

Avoid:
ContinueAvoid:
	if (!ShouldBeStartled(Enemy))
		Goto('Done');
	PickDestination();
	if (destLoc == Location)
		Goto('Pause');
	if (ShouldPlayWalk(destLoc))
		PlayRunning();
	MoveTo(destLoc, MaxDesiredSpeed);
	Goto('Avoid');

Pause:
	PlayWaiting();
	Sleep(0.0);
	Goto('Avoid');

Done:
	if (Orders != 'AvoidingPawn')
		FollowOrders();
	else
		GotoState('Wandering');
}


// ----------------------------------------------------------------------
// state BackingOff
//
// Hack state used to back off when the NPC gets stuck.
// ----------------------------------------------------------------------

state BackingOff
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('BackingOff', 'ContinueRun');
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool PickDestination()
	{
		local bool    bSuccess;
		local float   magnitude;
		local rotator rot;

		magnitude = 300;

		rot = Rotator(Destination-Location);
		bSuccess = AIPickRandomDestination(64, magnitude, rot.Yaw+32768, 0.8, -rot.Pitch, 0.8, 3,
		                                   0.9, useLoc);

		return bSuccess;
	}

	function bool HandleTurn(Actor Other)
	{
		GotoState('BackingOff', 'Pause');
		return false;
	}

	function BeginState()
	{
		StandUp();
		BlockReactions();
		bStasis = False;
		bInTransientState = True;
		EnableCheckDestLoc(false);
		bCanJump = false;
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		if (JumpZ > 0)
			bCanJump = true;
		ResetReactions();
		bStasis = True;
		bInTransientState = false;
	}

Begin:
	useRot = Rotation;
	if (!PickDestination())
		Goto('Pause');
	Acceleration = vect(0,0,0);

MoveAway:
	if (ShouldPlayWalk(useLoc))
		PlayRunning();
	MoveTo(useLoc, MaxDesiredSpeed);

Pause:
	Acceleration = vect(0,0,0);
	PlayWaiting();
	Sleep(FRand()*2+2);

Done:
	if (HasNextState())
		GotoNextState();
	else
		FollowOrders();  // THIS IS BAD!!!

ContinueRun:
ContinueFromDoor:
	Goto('Done');

}


// ----------------------------------------------------------------------
// state OpeningDoor
//
// Open a door.
// ----------------------------------------------------------------------

state OpeningDoor
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling(NextState, NextLabel);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		if (Target == Wall)
			CheckOpenDoor(HitNormal, Wall);
	}

	function bool DoorEncroaches()
	{
		local bool        bEncroaches;
		local DeusExMover dxMover;

		bEncroaches = true;
		dxMover = DeusExMover(Target);
		if (dxMover != None)
		{
			if (IsDoor(dxMover) && (dxMover.MoverEncroachType == ME_IgnoreWhenEncroach) && PlayerCanSeeMe())
				bEncroaches = false;
		}

		return bEncroaches;
	}

	function FindBackupPoint()
	{
		local vector hitNorm;
		local rotator rot;
		local vector center;
		local vector area;
		local vector relPos;
		local float  distX, distY;
		local float  dist;

		hitNorm = Normal(destLoc);
		rot = Rotator(hitNorm);
		DeusExMover(Target).ComputeMovementArea(center, area);
		area.X += CollisionRadius + 30;
		area.Y += CollisionRadius + 30;
		//area.Z += CollisionHeight + 30;
		relPos = Location - center;
		if ((relPos.X < area.X) && (relPos.X > -area.X) &&
		    (relPos.Y < area.Y) && (relPos.Y > -area.Y))
		{
			// hack
			if (hitNorm.Y == 0)
				hitNorm.Y = 0.00000001;
			if (hitNorm.X == 0)
				hitNorm.X = 0.00000001;
			if (hitNorm.X > 0)
				distX = (area.X - relPos.X)/hitNorm.X;
			else
				distX = (-area.X - relPos.X)/hitNorm.X;
			if (hitNorm.Y > 0)
				distY = (area.Y - relPos.Y)/hitNorm.Y;
			else
				distY = (-area.Y - relPos.Y)/hitNorm.Y;
			dist = FMin(distX, distY);
			if (dist < 45)
				dist = 45;
			else if (dist > 700)
				dist = 700;  // sanity check
			if (!AIDirectionReachable(Location, rot.Yaw, rot.Pitch, 40, dist, destLoc))
				destLoc = Location;
		}
		else
			destLoc = Location;
	}

	function vector FocusDirection()
	{
		return (Vector(Rotation)*30+Location);
	}

	function StopWaiting()
	{
		GotoState('OpeningDoor', 'DoorOpened');
	}

	function AnimEnd()
	{
	local DeusExMover moved;

	    moved = DeusExMover(Target);
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bCanJump = false;
		BlockReactions();
		bStasis = False;
		bInTransientState = True;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;

		ResetReactions();
		bStasis = True;
		bInTransientState = false;
	}

Begin:
	destLoc = vect(0,0,0);

BeginHitNormal:
	Acceleration = vect(0,0,0);
	FindBackupPoint();

	if (!DoorEncroaches())
		if (!FrobDoor(Target))
			Goto('DoorOpened');
	if (DoorEncroaches())
    {
	FinishAnim();
	PlayRunning();
	StrafeTo(destLoc, FocusDirection());
	}
	if (DoorEncroaches())
		if (!FrobDoor(Target))
			Goto('DoorOpened');
	PlayWaiting();
	//CyberP A.K.A Totalitarian: added this block, because Sleeping for 5 secs in combat is bad.
	if (target != None && target.IsA('DeusExMover') && DeusExMover(target).MoveTime < 5.0 && DeusExMover(target).bIsDoor)
	{
       if (enemy != None && !DoorEncroaches())
       {
          Sleep(DeusExMover(target).MoveTime*0.35);
	   }
	   else
          Sleep(DeusExMover(target).MoveTime*0.55);
    }
	else
	   Sleep(5.0);

DoorOpened:
	  if (HasNextState())
 	    GotoNextState();
	else
	    FollowOrders();  // THIS IS BAD!!!

}


// ----------------------------------------------------------------------
// state TakingHit
//
// React to a hit.
// ----------------------------------------------------------------------

state TakingHit
{
	ignores seeplayer, hearnoise, bump, hitwall, reacttoinjury;

	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation,
	                    Vector momentum, name damageType)
	{
		TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}

	function Landed(vector HitNormal)
	{
		if (Velocity.Z < -1.4 * JumpZ)
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		bJustLanded = true;
	}

	function BeginState()
	{
	local DeusExPlayer player;

		StandUp();
		LastPainTime = Level.TimeSeconds;
		LastPainAnim = AnimSequence;
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetDistress(true);
        //hack
        player = DeusExPlayer(GetPlayerPawn());
        if (player != None && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkPiercing').bPerkObtained == true && player.inHand != None)
        {
           if (player.inHand.IsA('DeusExWeapon') && DeusExWeapon(player.InHand).bHandToHand)
           {
              if (IsA('Gray') || IsA('Karkian'))
                  TakeHitTimer = 3.0;
              else
		          TakeHitTimer = 1.3;
		   }
		   else if (IsA('Gray') || IsA('Karkian'))   //CyberP: grays and karkians are formidable
              TakeHitTimer = 10.0;
           else
              TakeHitTimer = 2.25;
		}
		else if (IsA('Gray') || IsA('Karkian'))   //CyberP: grays and karkians are formidable
		     TakeHitTimer = 10.0;
		else
		     TakeHitTimer = 2.25;   //CyberP: was 2.0

		EnemyReadiness = 1.0;
		ReactionLevel  = 1.0;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bInterruptState = true;
		ResetReactions();
		bCanConverse = True;
		bStasis = True;
		bInTransientState = false;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	FinishAnim();
	if ( (Physics == PHYS_Falling) && !Region.Zone.bWaterZone )
	{
		Acceleration = vect(0,0,0);
		GotoState('FallingState', 'Ducking');
	}
	else if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');
}


// ----------------------------------------------------------------------
// state RubbingEyes
//
// React to evil things like pepper spray.
// ----------------------------------------------------------------------

state RubbingEyes
{
	ignores seeplayer, hearnoise, bump, hitwall;

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
						Vector momentum, name damageType)
	{
		TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}

	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		if ((damageType != 'TearGas') && (damageType != 'HalonGas') && (damageType != 'Stunned'))
			Global.ReactToInjury(instigatedBy, damageType, hitPos);
	}

	function SetFall()
	{
		StartFalling(NextState, NextLabel);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
//		LastPainTime = Level.TimeSeconds;
//		LastPainAnim = AnimSequence;
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetupWeapon(false, true);
		SetDistress(true);
		bStunned = True;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bInterruptState = true;
		ResetReactions();
		bCanConverse = True;
		bStasis = True;
		if (Health > 0)
			bStunned = False;
		bInTransientState = false;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	PlayTearGasSound();

RubEyes:
	PlayRubbingEyesStart();
	FinishAnim();
	PlayRubbingEyes();
	Sleep(15);
	PlayRubbingEyesEnd();
	FinishAnim();
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');
}


// ----------------------------------------------------------------------
// state Stunned
//
// React to being stunned.
// ----------------------------------------------------------------------

state Stunned
{
	ignores seeplayer, hearnoise, bump, hitwall;

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
						Vector momentum, name damageType)
	{
		TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}

	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		if ((damageType != 'TearGas') && (damageType != 'HalonGas') && (damageType != 'Stunned'))
			Global.ReactToInjury(instigatedBy, damageType, hitPos);
	}

	function SetFall()
	{
		StartFalling(NextState, NextLabel);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetupWeapon(false);
		SetDistress(true);
		bStunned = True;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bInterruptState = true;
		ResetReactions();
		bCanConverse = True;
		bStasis = True;

		// if we're dead, don't reset the flag
		if (Health > 0)
			bStunned = False;
		bInTransientState = false;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	PlayStunned();
	/*if (enemy != None && enemy.IsA('DeusExPlayer'))                           //RSD: Reworked stun duration mechanics
	{
	    if (DeusExPlayer(enemy).inHand != None && DeusExPlayer(enemy).inHand.IsA('WeaponRiotProd')) //CyberP: flawless hack! :/
	        Sleep(15);
	    else
            Sleep(7.5);
	}*/
	if (bStunTimeAltered)                                                       //RSD: set in DeusExWeapon.uc for trace weapons and DeusExProjectile.uc for projectiles
        Sleep(stunSleepTime);
    else
        Sleep(15);
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');
}


// ----------------------------------------------------------------------
// state Dying
//
// Why does the Unreal Dying state suck?
// ----------------------------------------------------------------------

state Dying
{
	ignores SeePlayer, EnemyNotVisible, HearNoise, KilledBy, Trigger, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, WarnTarget, Died, Timer, TakeDamage;

	event Landed(vector HitNormal)
	{
		SetPhysics(PHYS_Walking);
	}

	function Tick(float deltaSeconds)
	{
		Global.Tick(deltaSeconds);

		if (DeathTimer > 0)
		{
			DeathTimer -= deltaSeconds;
			if ((DeathTimer <= 0) && (Physics == PHYS_Walking))
			{
				Acceleration = vect(0,0,0);
            }
        }
        if (DeathTimer2 > 0)
		{
			DeathTimer2 -= deltaSeconds;
			if ((DeathTimer2 <= 0) && (Physics == PHYS_Walking))
			{
				SetCollision(false,false,false);
            }
        }
	}

	function MoveFallingBody()
	{
		local Vector moveDir;
		local float  totalTime;
		local float  speed;
		local float  stopTime;
		local int    numFrames;

		if ((AnimRate > 0) && !IsA('Robot'))
		{
			totalTime = 1.0/AnimRate;  // determine how long the anim lasts
			numFrames = int((1.0/(1.0-AnimLast))+0.1);  // count frames (hack)

			// defaults
			moveDir   = vect(0,0,0);
			stopTime  = 0.01;

			ComputeFallDirection(totalTime, numFrames, moveDir, stopTime);

			speed = VSize(moveDir)/stopTime;  // compute speed

			// Set variables necessary for movement when walking
			if (moveDir == vect(0,0,0))
				Acceleration = vect(0,0,0);
			else
				Acceleration = Normal(moveDir)*AccelRate;
			GroundSpeed  = speed;
			DesiredSpeed = 1.0;
			bIsWalking   = false;
			DeathTimer   = stopTime;
			DeathTimer2 = 0.4;
		}
		else
			Acceleration = vect(0,0,0);
	}

	function BeginState()
	{
		EnableCheckDestLoc(false);
		StandUp();

        if (Weapon != None && Weapon.IsA('WeaponRifle')) //CyberP: hack: set back rifle stats
        {
          WeaponRifle(Weapon).BaseAccuracy = WeaponRifle(Weapon).default.BaseAccuracy;
          WeaponRifle(Weapon).maxRange = WeaponRifle(Weapon).default.MaxRange;
          WeaponRifle(Weapon).AccurateRange = WeaponRifle(Weapon).default.AccurateRange;
          WeaponRifle(Weapon).ShotTime = WeaponRifle(Weapon).default.ShotTime;
        }
		// don't do that stupid timer thing in Pawn.uc
		AIClearEventCallback('Futz');
		AIClearEventCallback('MegaFutz');
		AIClearEventCallback('Player');
		AIClearEventCallback('WeaponDrawn');
		AIClearEventCallback('LoudNoise');
		AIClearEventCallback('WeaponFire');
		AIClearEventCallback('Carcass');
		AIClearEventCallback('Distress');
		AIClearEventCallback('Projetile');

		bInterruptState = false;
		BlockReactions(true);
		bCanConverse = False;
		bStasis = False;
		SetDistress(true);
		DeathTimer = 0;
	}

Begin:
	WaitForLanding();
	MoveFallingBody();

	DesiredRotation.Pitch = 0;
	DesiredRotation.Roll  = 0;
	RotationRate.Yaw = 50000;
	// if we don't gib, then wait for the animation to finish
	if ((Health > -100) && !IsA('Robot'))
	 {
      //if (!IsA('Animal'))
      //   SetCollisionSize(0.001000,Default.CollisionHeight); //CyberP: massive hack. May have to remove (all in this block and then uncomment finishAnim())
      FinishAnim();
      //if (!IsA('Animal'))
      //   SetCollisionSize(Default.CollisionRadius,Default.CollisionHeight);
     }
    //FinishAnim();
	SetWeapon(None);

	if (IsA('Robot') && Health > -100 && FRand() < 0.3) //CyberP: sometimes play disabled anim
	{
	    if (IsA('MilitaryBot') || IsA('SecurityBot2'))
	    {
	        FinishAnim();
	        PlayAnim('Disabled1',0.6);
	        FinishAnim();
	    }
	}

	bHidden = True;

	Acceleration = vect(0,0,0);
	SpawnCarcass();
	Destroy();
}


// ----------------------------------------------------------------------
// state FallingState
//
// Fall!
// ----------------------------------------------------------------------

state FallingState
{
	ignores Bump, Hitwall, WarnTarget, ReactToInjury;

	function ZoneChange(ZoneInfo newZone)
	{
		Global.ZoneChange(newZone);
		if (newZone.bWaterZone)
			GotoState('FallingState', 'Splash');
	}

	//choose a jump velocity
	function AdjustJump()
	{
		local float velZ;
		local vector FullVel;

		velZ = Velocity.Z;
		FullVel = Normal(Velocity) * GroundSpeed;

		If (Location.Z > Destination.Z + CollisionHeight + 2 * MaxStepHeight)
		{
			Velocity = FullVel;
			Velocity.Z = velZ;
			Velocity = EAdjustJump();
			Velocity.Z = 0;
			if ( VSize(Velocity) < 0.9 * GroundSpeed )
			{
				Velocity.Z = velZ;
				return;
			}
		}

		Velocity = FullVel;
		Velocity.Z = JumpZ + velZ;
		Velocity = EAdjustJump();
	}

	singular function BaseChange()
	{
		local float minJumpZ;

		Global.BaseChange();

		if (Physics == PHYS_Walking)
		{
			minJumpZ = FMax(JumpZ, 150.0);
			bJustLanded = true;
			if (Health > 0)
			{
				if ((Velocity.Z < -0.8 * minJumpZ) || bUpAndOut)
					GotoState('FallingState', 'Landed');
				else if (Velocity.Z < -0.8 * JumpZ)
					GotoState('FallingState', 'FastLanded');
				else
					GotoState('FallingState', 'Done');
			}
		}
	}

	function Landed(vector HitNormal)
	{
		local float landVol, minJumpZ;
		local vector legLocation;

		minJumpZ = FMax(JumpZ, 150.0);

		if ( (Velocity.Z < -0.8 * minJumpZ) || bUpAndOut)
		{
			PlayLanded(Velocity.Z);
			if (Velocity.Z < -700)
			{
				legLocation = Location + vect(-1,0,-1);			// damage left leg
				TakeDamage(-0.14 * (Velocity.Z + 700), Self, legLocation, vect(0,0,0), 'fell');
				legLocation = Location + vect(1,0,-1);			// damage right leg
				TakeDamage(-0.14 * (Velocity.Z + 700), Self, legLocation, vect(0,0,0), 'fell');
				legLocation = Location + vect(0,0,1);			// damage torso
				TakeDamage(-0.04 * (Velocity.Z + 700), Self, legLocation, vect(0,0,0), 'fell');
			}
			landVol = Velocity.Z/JumpZ;
			landVol = 0.005 * Mass * FMin(5, landVol * landVol);
			if ( !FootRegion.Zone.bWaterZone )
				PlaySound(Land, SLOT_Interact, FMin(20, landVol));
		}
		else if ( Velocity.Z < -0.8 * JumpZ )
			PlayLanded(Velocity.Z);
	}

	function SetFall()
	{
		if (!bUpAndOut)
			GotoState('FallingState');
	}

	function BeginState()
	{
		StandUp();
		if (Enemy == None)
			Disable('EnemyNotVisible');
		else
		{
			Disable('HearNoise');
			Disable('SeePlayer');
		}
		bInterruptState = false;
		bCanConverse = False;
		bStasis = False;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bUpAndOut = false;
		bInterruptState = true;
		bCanConverse = True;
		bStasis = True;
		bInTransientState = false;
	}

LongFall:
	if ( bCanFly )
	{
		SetPhysics(PHYS_Flying);
		Goto('Done');
	}
	Sleep(0.7);
	PlayFalling();
	if ( Velocity.Z > -150 ) //stuck
	{
		SetPhysics(PHYS_Falling);
		if ( Enemy != None )
			Velocity = groundspeed * normal(Enemy.Location - Location);
		else
			Velocity = groundspeed * VRand();

		Velocity.Z = FMax(JumpZ, 250);
	}
	Goto('LongFall');

FastLanded:
	FinishAnim();
	TweenToWaiting(0.15);
	Goto('Done');

Landed:
	if ( !bIsPlayer ) //bots act like players
		Acceleration = vect(0,0,0);
	FinishAnim();
	TweenToWaiting(0.2);
	if ( !bIsPlayer )
		Sleep(0.08);

Done:
	bUpAndOut = false;
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');

Splash:
	bUpAndOut = false;
	FinishAnim();
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');

Begin:
	if (Enemy == None)
		Disable('EnemyNotVisible');
	else
	{
		Disable('HearNoise');
		Disable('SeePlayer');
	}
	if (bUpAndOut) //water jump
	{
		if ( !bIsPlayer )
		{
			DesiredRotation = Rotation;
			DesiredRotation.Pitch = 0;
			Velocity.Z = 440;
		}
	}
	else
	{
		if (Region.Zone.bWaterZone)
		{
			SetPhysics(PHYS_Swimming);
			GotoNextState();
		}
		if ( !bJumpOffPawn )
			AdjustJump();
		else
			bJumpOffPawn = false;

PlayFall:
		PlayFalling();
		FinishAnim();
	}

	if (Physics != PHYS_Falling)
		Goto('Done');
	Sleep(2.0);
	Goto('LongFall');

Ducking:

}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// OBSOLETE
// ----------------------------------------------------------------------

function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	log("ERROR - PlayHit should not be called!");
}

function PlayHitAnim(vector HitLocation, float Damage)
{
	log("ERROR - PlayHitAnim should not be called!");
}

function PlayDeathHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	log("ERROR - PlayDeathHit should not be called!");
}

function PlayChallenge()
{
	log("ERROR - PlayChallenge should not be called!");
}

function JumpOffPawn()
{
	/*
	Velocity += (60 + CollisionRadius) * VRand();
	Velocity.Z = 180 + CollisionHeight;
	SetPhysics(PHYS_Falling);
	bJumpOffPawn = true;
	SetFall();
	*/
	//log("ERROR - JumpOffPawn should not be called!");
}

// ----------------------------------------------------------------------
// LipSynch()
// Copied over from Engine/Pawn.uc
// SARGE: Attempts to fix the janky DX lipsynching
// Based on the idea from https://www.youtube.com/watch?v=oxTWU2YgzfQ, but
// doesn't use any code from it.
// Also split out the Blink functionality
// ----------------------------------------------------------------------

//Blink is handled slightly differently for scriptedpawns.
//They can blink outside of conversations, and so have to have a separate blink timer
function HandleBlink(float deltaTime)
{
    if (!bIsHuman)
        return;
    
    blinkTimer += deltaTime;

	// blink randomly
	if (blinkTimer > 3.5)
	{
		if (FRand() < 0.4 && class'DeusExPlayer'.default.bEnableBlinking)
        {
			PlayBlendAnim('Blink', 0.2, 0.1, 1);
            blinkTimer = 0;
        }
        else
            blinkTimer = 2; //Make them more likely to blink again sooner
	}
}

function LipSynch(float deltaTime)
{
	local name animseq;
	local float rnd;
	local float tweentime;

    local int iEnhancedLipSync;
    iEnhancedLipSync = class'DeusExPlayer'.default.iEnhancedLipSync;
    
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

	LoopHeadConvoAnim();
	LoopBaseConvoAnim();
}

// ----------------------------------------------------------------------
// RandomiseSounds()
// SARGE: GMDX Adds many new death sounds,
// This attempts to give some more variety and make
// them less hard-coded, by allowing us to pick from a list
// ----------------------------------------------------------------------

function Sound GetDeathSoundFromIndex(int index)
{
    if (bIsFemale && index < ArrayCount(randomDeathSoundsF))
        return randomDeathSoundsF[index];
    else if (!bIsFemale && index < ArrayCount(randomDeathSoundsM))
        return randomDeathSoundsM[index];

    return None;
}

function Sound GetPainSoundFromIndex(int index)
{
    if (bIsFemale && index < ArrayCount(randomPainSoundsF))
        return randomPainSoundsF[index];
    else if (!bIsFemale && index < ArrayCount(randomPainSoundsM))
        return randomPainSoundsM[index];

    return None;
}

//Gets this characters death sound, based on our settings
function Sound GetDeathSound()
{
    //If sound has been set to something else, get it instead
    if (deathSoundOverride != None)
        return deathSoundOverride;

    //If we're using our original sound, or not valid, use the default
    else if (Class'DeusExPlayer'.default.iDeathSoundMode == 1 || !bIsHuman || bDontChangeDeathPainSounds)
        return default.Die;

    //Otherwise do vanilla sounds, if set
    else if (Class'DeusExPlayer'.default.iDeathSoundMode == 0)
    {
        // change the sounds for chicks
        if (bIsFemale)
            return Sound'FemaleDeath';
        else
            return Sound'DeusExSounds.Player.MaleDeath';
    }

    else
        return randomDeathSoundChoice;
}

//Gets one of this characters two hit sounds
function Sound GetRandomHitSound()
{
    if (FRand() < 0.15)
		return GetHitSound(true);
    else
		return GetHitSound();            //CyberP: more lax conditions for hitsound2
}

//Gets on of this characters his sounds, based on our settings
function Sound GetHitSound(optional bool sound2)
{
    //If we're using our original sound, or not valid, use the default
    if (Class'DeusExPlayer'.default.iDeathSoundMode == 1 || !bIsHuman || bDontChangeDeathPainSounds)
    {
        if (sound2)
            return default.HitSound2;
        else
            return default.HitSound1;
    }

    //Otherwise do vanilla sounds, if set
    else if (Class'DeusExPlayer'.default.iDeathSoundMode == 0)
    {
        // change the sounds for chicks
        if (bIsFemale)
        {
            if (sound2)
                return Sound'FemalePainSmall';
            else
                return Sound'FemalePainMedium';
        }
        else
        {
            if (sound2)
                return Sound'DeusExSounds.Player.MalePainMedium';
            else
                return Sound'DeusExSounds.Player.MalePainSmall';
        }
    }

    //Otherwise, use our pain sound choices
    if (sound2)
        return randomPainSoundChoice2;
    else
        return randomPainSoundChoice1;

}

function RandomiseSounds()
{
    local int dyingSounds, painSounds, i;
    
    //hack
    //if (HitSound1 == Sound'DeusExSounds.Generic.ArmorRicochet')
    if (bDontChangeDeathPainSounds)
        return;

    if (bSetupRandomSounds || !bIsHuman)
        return;
    
    bSetupRandomSounds = true;
    
    while (GetDeathSoundFromIndex(dyingSounds) != None)
        dyingSounds++;
    while (GetPainSoundFromIndex(painSounds) != None)
        painSounds++;

    if (dyingSounds > 0)
    {
        randomDeathSoundChoice = GetDeathSoundFromIndex(int(FRand() * (dyingSounds-1)));
    }
    if (painSounds > 0)
    {
        randomPainSoundChoice1 = GetPainSoundFromIndex(int(FRand() * (painSounds-1)));
        randomPainSoundChoice2 = GetPainSoundFromIndex(int(FRand() * (painSounds-1)));
    }
}


//SARGE: Called when the Weapon Swap gameplay modifier for this entity has been called
function WeaponSwap(ScriptedPawn SwappedFrom)
{
}

//SARGE: Set up the Shenanigans gameplay modifier for this entity
function Shenanigans(bool bEnabled)
{
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Restlessness=0.500000
     Wanderlust=0.500000
     Cowardice=0.500000
     maxRange=4000.000000
     MinHealth=30.000000
     RandomWandering=1.000000
     bAlliancesChanged=True
     Orders=Wandering
     HomeExtent=800.000000
     WalkingSpeed=0.450000
     bCanBleed=True
     ClotPeriod=30.000000
     bShowPain=True
     bCanSit=True
     bLikesNeutral=True
     bUseFirstSeatOnly=True
     bCanConverse=True
     bAvoidAim=True
     AvoidAccuracy=0.400000
     bAvoidHarm=True
     HarmAccuracy=0.700000
     CloseCombatMult=0.300000
     bHateShot=True
     bHateInjury=True
     bReactPresence=True
     bReactProjectiles=True
     bEmitDistress=True
     RaiseAlarm=RAISEALARM_BeforeFleeing
     bMustFaceTarget=True
     FireAngle=360.000000
     MaxProvocations=1
     AgitationSustainTime=50.000000
     AgitationDecayRate=0.050000
     FearSustainTime=25.000000
     FearDecayRate=0.500000
     SurprisePeriod=1.000000
     SightPercentage=0.500000
     bHasShadow=True
     ShadowScale=1.000000
     BaseAssHeight=-26.000000
     EnemyTimeout=4.000000
     bTickVisibleOnly=True
     bInWorld=True
     bHighlight=True
     bHokeyPokey=True
     InitialInventory(0)=(Count=1)
     InitialInventory(1)=(Count=1)
     InitialInventory(2)=(Count=1)
     InitialInventory(3)=(Count=1)
     InitialInventory(4)=(Count=1)
     InitialInventory(5)=(Count=1)
     InitialInventory(6)=(Count=1)
     InitialInventory(7)=(Count=1)
     bSpawnBubbles=True
     bWalkAround=True
     BurnPeriod=40.000000
     DistressTimer=-1.000000
     CloakThreshold=50
     walkAnimMult=0.700000
     runAnimMult=1.050000
     bRadialBlastClamp=True
     bCanStrafe=True
     bCanWalk=True
     bCanSwim=True
     bCanOpenDoors=True
     bIsHuman=True
     bCanGlide=False
     AirSpeed=320.000000
     AccelRate=200.000000
     JumpZ=120.000000
     MinHitWall=9999999827968.000000
     HearingThreshold=0.150000
     Skill=2.000000
     AIHorizontalFov=160.000000
     AspectRatio=2.300000
     bForceStasis=True
     ScaleGlow=0.600000
     CollisionRadius=21.000000
     BindName="ScriptedPawn"
     FamiliarName="DEFAULT FAMILIAR NAME - REPORT THIS AS A BUG"
     UnfamiliarName="DEFAULT UNFAMILIAR NAME - REPORT THIS AS A BUG"
     fireReactTime=0.4
     iHDTPModelToggle=0
     randomDeathSoundsF(0)=Sound'DeusExSounds.Player.FemaleDeath';
     randomDeathSoundsF(1)=Sound'DeusExSounds.Player.FemaleUnconscious';
     randomDeathSoundsF(2)=Sound'GMDXSFX.Player.fem1grunt1';
     //
     randomDeathSoundsM(0)=Sound'DeusExSounds.Player.MaleDeath';
     randomDeathSoundsM(1)=Sound'DeusExSounds.Player.MaleUnconscious';
     randomDeathSoundsM(2)=Sound'GMDXSFX.Human.Death01';
     randomDeathSoundsM(3)=Sound'GMDXSFX.Human.Death02';
     randomDeathSoundsM(4)=Sound'GMDXSFX.Human.Death03';
     randomDeathSoundsM(5)=Sound'GMDXSFX.Human.Death05';
     randomDeathSoundsM(6)=Sound'GMDXSFX.Human.Death06';
     randomDeathSoundsM(7)=Sound'GMDXSFX.Human.Death07';
     randomDeathSoundsM(8)=Sound'GMDXSFX.Human.Death09';
     randomDeathSoundsM(9)=Sound'GMDXSFX.Human.Death11';
     randomDeathSoundsM(10)=Sound'GMDXSFX.Player.male1grunt2';
     //
     randomPainSoundsF(0)=Sound'DeusExSounds.Player.FemalePainSmall'
     randomPainSoundsF(1)=Sound'DeusExSounds.Player.FemalePainMedium'
     randomPainSoundsF(2)=Sound'DeusExSounds.Player.FemalePainLarge'
     randomPainSoundsF(3)=Sound'GMDXSFX.Player.fem2grunt1'
     randomPainSoundsF(4)=Sound'GMDXSFX.Player.fem2grunt2'
     //
     randomPainSoundsM(0)=Sound'DeusExSounds.Player.MalePainSmall'
     randomPainSoundsM(1)=Sound'DeusExSounds.Player.MalePainMedium'
     randomPainSoundsM(2)=Sound'DeusExSounds.Player.MalePainBig'
     randomPainSoundsM(3)=Sound'GMDXSFX.Human.PainSmall01'
     randomPainSoundsM(4)=Sound'GMDXSFX.Human.PainSmall02'
     randomPainSoundsM(5)=Sound'GMDXSFX.Human.PainSmall03'
     randomPainSoundsM(6)=Sound'GMDXSFX.Human.PainSmall04'
     randomPainSoundsM(7)=Sound'GMDXSFX.Human.PainSmall06'
     randomPainSoundsM(8)=Sound'GMDXSFX.Human.PainSmall07'
     randomPainSoundsM(9)=Sound'GMDXSFX.Human.PainSmall08'
     randomPainSoundsM(10)=Sound'GMDXSFX.Human.PainBig01'
     randomPainSoundsM(11)=Sound'GMDXSFX.Human.PainBig02'
     randomPainSoundsM(12)=Sound'GMDXSFX.Human.PainBig04'
     randomPainSoundsM(13)=Sound'GMDXSFX.Human.PainBig05'
     randomPainSoundsM(14)=Sound'GMDXSFX.Human.PainBig06'
     randomPainSoundsM(15)=Sound'GMDXSFX.Human.MGrunt1'
     randomPainSoundsM(16)=Sound'GMDXSFX.Human.MGrunt3'
     randomPainSoundsM(17)=Sound'GMDXSFX.Player.malegrunt2'
     randomPainSoundsM(18)=Sound'GMDXSFX.Player.malegrunt3'
     randomPainSoundsM(19)=Sound'DeusExSounds.Player.MaleLand' //WTF?
     randomPainSoundsM(19)=Sound'DeusExSounds.Player.MaleGrunt'
}
