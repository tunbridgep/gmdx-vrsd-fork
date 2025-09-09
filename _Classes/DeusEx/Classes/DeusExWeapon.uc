//=============================================================================
// DeusExWeapon.
//=============================================================================
class DeusExWeapon extends Weapon
	abstract;

#exec obj load file="..\DeusEx\Textures\GameEffects.utx" package=GameEffects
//
// enums for weapons (duh)
//
enum EEnemyEffective
{
	ENMEFF_All,
	ENMEFF_Organic,
	ENMEFF_Robot
};

enum EEnviroEffective
{
	ENVEFF_All,
	ENVEFF_Air,
	ENVEFF_Water,
	ENVEFF_Vacuum,
	ENVEFF_AirWater,
	ENVEFF_AirVacuum,
	ENVEFF_WaterVacuum
};

enum EConcealability
{
	CONC_None,
	CONC_Visual,
	CONC_Metal,
	CONC_All
};

enum EAreaType
{
	AOE_Point,
	AOE_Cone,
	AOE_Sphere
};

enum ELockMode
{
	LOCK_None,
	LOCK_Invalid,
	LOCK_Range,
	LOCK_Acquire,
	LOCK_Locked
};

var bool				bReadyToFire;			// true if our bullets are loaded, etc.
var() travel int				LowAmmoWaterMark;		// critical low ammo count
var travel int			ClipCount;				// number of bullets remaining in current clip
var travel int			ARClipSize;
var travel int			ARLoaded;
var travel int			ARGLLoaded;

var() Name		FireAnim[2];

var() class<Skill>		GoverningSkill;			// skill that affects this weapon
var() travel float		NoiseLevel;				// amount of noise that weapon makes when fired
var() EEnemyEffective	EnemyEffective;			// type of enemies that weapon is effective against
var() EEnviroEffective	EnviroEffective;		// type of environment that weapon is effective in
var() EConcealability	Concealability;			// concealability of weapon
var() travel bool		bAutomatic;				// is this an automatic weapon?
var() travel float		ShotTime;				// number of seconds between shots
var() travel float		ReloadTime;				// number of seconds needed to reload the clip
var() int				HitDamage;				// damage done by a single shot (or for shotguns, a single slug)
var() travel int		MaxRange;				// absolute maximum range in world units (feet * 16) //RSD: Added travel since it can be changed now
var() travel int		AccurateRange;			// maximum accurate range in world units (feet * 16)
var() travel float		BaseAccuracy;			// base accuracy (0.0 is dead on, 1.0 is far off)

//IRONOUT var bool          bInIronSight;         //GMDX iron sight active, removing bZoomed . test to see if bZoomed hides weapon

var bool				bCanHaveScope;			// can this weapon have a scope?
var() travel bool		bHasScope;				// does this weapon have a scope?
var() int				ScopeFOV;				// FOV while using scope
var bool				bZoomed;				// are we currently zoomed?
var bool				bWasZoomed;				// were we zoomed? (used during reloading)

var travel bool         bLaserToggle;           // Remembers the toggle state of our laser independent of whether it has been turned on or off by the game

var bool				bCanHaveLaser;			// can this weapon have a laser sight?
var() travel bool		bHasLaser;				// does this weapon have a laser sight?
var travel bool			bLasing;				// is the laser sight currently on?
var LaserEmitter		Emitter;				// actual laser emitter - valid only when bLasing == True

var bool				bCanHaveSilencer;		// can this weapon have a silencer?
var() travel bool		bHasSilencer;			// does this weapon have a silencer?

var() bool				bCanTrack;				// can this weapon lock on to a target?
var() float				LockTime;				// how long the target must stay targetted to lock
var float				LockTimer;				// used for lock checking
var float            MaintainLockTimer;   // Used for maintaining a lock even after moving off target.
var Actor            LockTarget;          // Used for maintaining a lock even after moving off target.
var Actor				Target;					// actor currently targetted
var ELockMode			LockMode;				// is this target locked?
var string				TargetMessage;			// message to print during targetting
var float				TargetRange;			// range to current target
var() Sound				LockedSound;			// sound to play when locked
var() Sound				TrackingSound;			// sound to play while tracking a target
var float				SoundTimer;				// to time the sounds correctly

var() class<Ammo>		AmmoNames[4];			// three possible types of ammo per weapon   //CyberP ammo part 1
var() class<Projectile> ProjectileNames[4];		// projectile classes for different ammo     //CyberP ammo part 1
var() EAreaType			AreaOfEffect;			// area of effect of the weapon
var() bool				bPenetrating;			// shot will penetrate and cause blood
var() float				StunDuration;			// how long the shot stuns the target
var() bool				bHasMuzzleFlash;		// does this weapon have a flash when fired?
var() bool				bHandToHand;			// is this weapon hand to hand (no ammo)?
var globalconfig vector SwingOffset;     // offsets for this weapon swing.
var() travel float		recoilStrength;			// amount that the weapon kicks back after firing (0.0 is none, 1.0 is large)
var bool				bFiring;				// True while firing, used for recoil
var bool				bOwnerWillNotify;		// True if firing hand-to-hand weapons is dependent on the owner's animations
var bool				bFallbackWeapon;		// If True, only use if no other weapons are available
var bool				bNativeAttack;			// True if weapon represents a native attack
var bool				bEmitWeaponDrawn;		// True if drawing this weapon should make NPCs react
var bool				bUseWhileCrouched;		// True if NPCs should crouch while using this weapon
var bool				bUseAsDrawnWeapon;		// True if this weapon should be carried by NPCs as a drawn weapon
var bool				bWasInFiring;

var bool bNearWall;								// used for prox. mine placement
var Vector placeLocation;						// used for prox. mine placement
var Vector placeNormal;							// used for prox. mine placement
var Mover placeMover;							// used for prox. mine placement

var float ShakeTimer;
var float ShakeYaw;
var float ShakePitch;

var float AIMinRange;							// minimum "best" range for AI; 0=default min range
var float AIMaxRange;							// maximum "best" range for AI; 0=default max range
var float AITimeLimit;							// maximum amount of time an NPC should hold the weapon; 0=no time limit
var float AIFireDelay;							// Once fired, use as fallback weapon until the timeout expires; 0=no time limit

var float standingTimer;						// how long we've been standing still (to increase accuracy)
var float currentAccuracy;						// what the currently calculated accuracy is (updated every tick)

var MuzzleFlash flash;							// muzzle flash actor

var float MinSpreadAcc;        // Minimum accuracy for multiple slug weapons (shotgun).  Affects only multiplayer,
							   // keeps shots from all going in same place (ruining shotgun effect)
var float MinProjSpreadAcc;
var float MinWeaponAcc;        // Minimum accuracy for a weapon at all.  Affects only multiplayer.
var bool bNeedToSetMPPickupAmmo;

var bool	bDestroyOnFinish;

var float	mpReloadTime;
var int		mpHitDamage;
var float	mpBaseAccuracy;
var int		mpAccurateRange;
var int		mpMaxRange;
var int		mpReloadCount;
var int		mpPickupAmmoCount;

// Used to track weapon mods accurately.
var bool bCanHaveModBaseAccuracy;
var bool bCanHaveModReloadCount;
var bool bCanHaveModAccurateRange;
var bool bCanHaveModReloadTime;
var bool bCanHaveModRecoilStrength;

var travel float ModBaseAccuracy;
var travel float ModReloadCount;
var travel float ModAccurateRange;
var travel float ModReloadTime;
var travel float ModRecoilStrength;

var localized String msgCannotBeReloaded;
var localized String msgOutOf;
var localized String msgNowHas;
var localized String msgAlreadyHas;
var localized String msgGLModeActivated;
var localized String msgRifleModeActivated;
var localized String msgNone;
var localized String msgLockInvalid;
var localized String msgLockRange;
var localized String msgLockAcquire;
var localized String msgLockLocked;
var localized String msgRangeUnit;
var localized String msgTimeUnit;
var localized String msgMassUnit;
var localized String msgNotWorking;

//
// strings for info display
//
var localized String msgInfoAmmoLoaded;
var localized String msgInfoAmmo;
var localized String msgInfoDamage;
var localized String msgInfoClip;
var localized String msgInfoReload;
var localized String msgInfoRecoil;
var localized String msgInfoAccuracy;
var localized String msgInfoAccRange;
var localized String msgInfoMaxRange;
var localized String msgInfoMass;
var localized String msgInfoLaser;
var localized String msgInfoScope;
var localized String msgInfoSilencer;
var localized String msgInfoNA;
var localized String msgInfoYes;
var localized String msgInfoNo;
var localized String msgInfoAuto;
var localized String msgInfoSingle;
var localized String msgInfoRounds;
var localized String msgInfoRoundsPerSec;
var localized String msgInfoSkill;
var localized String msgInfoWeaponStats;

var bool		bClientReadyToFire, bClientReady, bInProcess, bFlameOn, bLooping;
var int		SimClipCount, flameShotCount, SimAmmoAmount;
var float	TimeLockSet;

var() sound FireSilentSound;
//GMDX:
var travel bool bIsCloaked;
var travel bool bContactDeton; //CyberP: toggle contact detonation
var vector RecoilShaker; //cosmetic shaking per shot, amount +/- added to dxplayers current as frand
var int maxiAmmo;  //CyberP: for frobbing weapon pickups when we have max ammo
var bool bInvisibleWhore; //CyberP: emulating the weapon movement if player near wall
var travel bool bSuperheated;  //unused
var bool bCanHaveModShotTime;
var bool bCanHaveModDamage;
var bool bCanHaveModFullAuto;
var travel float ModShotTime;
var travel float ModDamage;
var travel bool  bFullAuto; //CyberP: this is different to bAutomatic.
var localized String msgInfoROF;
var localized String msgInfoFullAuto;
var localized String msgSemi;
var localized String msgFull;
var localized String msgPump;
var localized String msgHeadMultiplier;
var localized String msgLethality;
var localized String msgNon;
var localized String msgLethal;
var localized String msgVar;
var localized String msgSecondary;
var localized String msgAllMods;
var localized String msgStamDrain;
var localized String msgSpeedR;
var localized String msgNoise;
var localized String msgSpec;
var localized String msgSpec2;
var localized String msgSlow;
var localized String msgModerate;
var localized String msgFast;
var localized String msgVeryFast;
var localized String msgRelo;
var localized String msgReco;
var localized String msgAccu;
var localized String msgRang;
var localized String msgClip;
var localized String msgDama;
var localized String msgRate;
var bool bExtraShaker;
var() sound ReloadMidSound;
var bool bCancelLoading;
var float negTime;
var bool bBeginQuickMelee;
var bool bAlreadyQuickMelee;                                                    //RSD
var float quickMeleeCombo;
var vector ironSightLoc;     //unused
var float meleeStaminaDrain;
var bool activateAn;
var float lerpAid;
var texture NormalPlayerViewSkins[10];
var texture CamoPlayerViewSkins[10];
var float sustainedRecoil;
var bool bJustUncloaked;
var bool bMantlingEffect;
var float PawnAccuracyModifier;
var float burstTimer;
var string AmmoTag;
var int addYaw;
var int addPitch;
var bool bAimingDown;
var float LaserYaw;                                                             //RSD
var float LaserPitch;                                                           //RSD
var bool bDoExtraSlugDamage;                                                    //RSD
var int ClipModAdd;                                                             //RSD
var bool bBeginAmmoSelectLoad;                                                  //RSD
var class<Ammo> ammoSelectClass;                                                //RSD
var bool bAmmoSelectWait;                                                       //RSD
var float slugSpreadAcc;                                                        //RSD
var() int		NPCMaxRange;			                                        //RSD: for NPC engagement distance and accuracy
var() int		NPCAccurateRange;                           			        //RSD: for NPC engagement distance and accuracy
var travel bool bIsRadar;                                                       //RSD: for splitting cloak/radar texture functionality
var bool bJustUnRadar;                                                          //RSD: for splitting cloak/radar texture functionality
var float attackSpeedMult;                                                      //RSD: to differentiate melee weapon attack speeds, only used on crowbar (0.8 for 20% reduction)
var bool bPerShellReload;                                                       //RSD: To avoid convoluted class checking (Sawed-Off, Assault Shotgun, Mini-Crossbow, and GEP)
var localized string abridgedName;                                              //RSD: For weapons with 30+ char names in MenuScreenHDTPToggles.uc
var texture largeIconRot;                                                       //RSD: rotated inventory icon
var texture largeIconUnrot;                                                     //RSD: unrotated inventory icon
var travel bool bRotated;                                                      //Is this item rotated?
var travel int invSlotsXtravel;                                                 //RSD: since Inventory invSlotsX doesn't travel through maps
var travel int invSlotsYtravel;                                                 //RSD: since Inventory invSlotsY doesn't travel through maps
var travel float previousAccuracy;                                              //Sarge: Used to limit standing accuracy bonus from increasing past your max accuracy                                                                                

//SARGE: Weapon Offset Stuff
//TODO: Replace this with a generic implementation
var const vector weaponOffsets;                                                 //Sarge: Our weapon offsets. Leave at (0,0,0) to disable using offsets
var travel vector oldOffsets;                                                   //Sarge: Stores our old default offsets
var travel bool bOldOffsetsSet;                                                 //Sarge: Stores whether or not old default offsets have been remembered
var travel bool givenFreeReload;                                                //Sarge: Give a free reload when selecting the weapon for the first time, otherwise it starts empty

var float sleeptime;                                                              //Sarge: Used by per shell reload weapons to store how long they have been sleeping during reload, to allow us to cancel mid-reload in a far more responsive way.

//SARGE: HDTP Model toggles
var config int iHDTPModelToggle;
var globalconfig bool bHDTPMuzzleFlashes;                                       //SARGE: If set, all weapons will use HDTP muzzle flashes all the time
var string HDTPSkin;
var string HDTPTexture;
var string HDTPPlayerViewMesh;
var string HDTPPickupViewMesh;
var string HDTPThirdPersonMesh;
var string HDTPIcon;
var string HDTPLargeIcon;
var string HDTPLargeIconRot;
var Texture handsTex;                                        //SARGE: Store the hands texture for performance

var int MuzzleSlot;                                                 //SARGE: Slot where the muzzle tex will go
var bool bBigMuzzleFlash;                                            //SARGE: Allow non-automatic weapons to have big muzzle flashes

var bool bDisposableWeapon;                                         //SARGE: Used for disposable weapons, such as grenades, PS20s, LAWs, etc. Disposable weapons can't be reloaded, and track ammo differently to regular weapons when dropped/picked up. Their ammo doesn't show up when being looted, either - The weapon is shown instead.

//SARGE: Show Modified
var travel bool bModified;                                                             //SARGE: Keeps track of whether or not a particular weapon has been modified
var localized string strModified;

//SARGE: Weapon Requirements Matter
var int minSkillRequirement;                                          //SARGE: Minimum skill requirement to use this weapon
var localized String msgRequires;                                     //Sarge: "Requires" for weapon info screen

//SARGE: Scoping Toggle Stuff
var float GEPinout;
var bool bGEPout;
var vector MountedViewOffset;
var float scopeTime;
var vector axesX;//fucking weapon rotation fix
var vector axesY;
var vector axesZ;
var bool bFancyScopeAnimation;

//SARGE: String when weapon mods are copies from another weapon
var localized String msgModsCopied;

//SARGE: Sounds for various things
var const Sound CopyModsSound;
var const Sound ClassicFireSound;

//SARGE: Some weapons are marked "hand to hand" but actually aren't hand to hand weapons
//we need a hacky variable to distinguish them, so we don't give them combat strength etc
var const bool bFakeHandToHand;

//END GMDX:

//
// network replication
//
replication
{
	// server to client
	reliable if ((Role == ROLE_Authority) && (bNetOwner))
		ClipCount, bZoomed, bHasSilencer, bHasLaser, ModBaseAccuracy, ModReloadCount, ModAccurateRange, ModReloadTime, ModRecoilStrength;

	// Things the client should send to the server
	//reliable if ( (Role<ROLE_Authority) )
		//LockTimer, Target, LockMode, TargetMessage, TargetRange, bCanTrack, LockTarget;

	// Functions client calls on server
	reliable if ( Role < ROLE_Authority )
		ReloadAmmo, LoadAmmo, CycleAmmo, LaserOn, LaserOff, LaserToggle, ScopeOn, ScopeOff, ScopeToggle, PropagateLockState, ServerForceFire,
		  ServerGenerateBullet, ServerGotoFinishFire, ServerHandleNotify, StartFlame, StopFlame, ServerDoneReloading, DestroyOnFinish;

	// Functions Server calls in client
	reliable if ( Role == ROLE_Authority )
	  RefreshScopeDisplay, ReadyClientToFire, SetClientAmmoParams, ClientDownWeapon, ClientActive, ClientReload;
}

// ----------------------------------------------------------------------
// GetAddonPenalty()
//
// SARGE: Gets the penalty for using a Scope, Silencer or Laser Sight
// FUCK ME this is overengineered....
// ----------------------------------------------------------------------
function float GetAddonPenalty(EAddonPenaltyType penaltyType)
{
    local float mod;
    local DeusExPlayer player;

    player = DeusExPlayer(Owner);

    //Only enabled on Hardcore or if we have the drawbacks setting enabled
    if (player != None && !(player.bAddonDrawbacks || player.bHardcoreMode))
        return 0;
    
    //Wetwork perk removes all penalties
    if (player != None && player.PerkManager != None && player.PerkManager.GetPerkWithClass(class'PerkWetwork').bPerkObtained)
        return 0;

    if (bHasLaser && bHadLaser && penaltyType == Laser)
        mod += addonPenalties[penaltyType];
    if (bHasScope && bHadScope && penaltyType == Scope)
        mod += addonPenalties[penaltyType];
    if (bHasSilencer && bHadSilencer && penaltyType == Silencer)
        mod += addonPenalties[penaltyType];

    return mod;
}

// ----------------------------------------------------------------------
// SARGE: Functions for attaching/detaching addons
// ----------------------------------------------------------------------

function ToggleAttachedLaser(bool bRealtime)
{
    if (bHadLaser)
    {
        LaserOff();
        if (bRealtime)
        {
            bSwitchingToLaser = true;
            GotoState('SwitchAttachment');
        }
        else
            bHasLaser = !bHasLaser;
    }
}

function ToggleAttachedScope(bool bRealtime)
{
    if (bHadScope)
    {
        if (bRealtime)
        {
            bSwitchingToScope = true;
            GotoState('SwitchAttachment');
        }
        else
            bHasScope = !bHasScope;
    }
}

function ToggleAttachedSilencer(bool bRealtime)
{
    if (bHadSilencer)
    {
        if (bRealtime)
        {
            bSwitchingToSilencer = true;
            GotoState('SwitchAttachment');
        }
        else
            bHasSilencer = !bHasSilencer;
    }
}

// ----------------------------------------------------------------------
// GetDefaultFireSound()
//
// SARGE: Returns the default fire sound (standard or classic), based on the players options
// ----------------------------------------------------------------------
function Sound GetDefaultFireSound()
{
    if (Ammo20mm(AmmoType) != None) //Hack for 20mm grenade launcher
        return Sound'AssaultGunFire20mm';
    else if ( AmmoRocketWP(AmmoType) != None )
        return Sound'GEPGunFireWP';
    else if ( AmmoRocket(AmmoType) != None )
        return Sound'GEPGunFire';
    else if (class'DeusExPlayer'.default.bImprovedWeaponSounds || default.ClassicFireSound == None)
        return default.FireSound;
    else
        return default.ClassicFireSound;
}

// ----------------------------------------------------------------------
// GetPrimaryAmmoType()
//
// SARGE: Returns the main ammo type of the weapon, since we can't pick up secondaries usually
// ----------------------------------------------------------------------
function class<Ammo> GetPrimaryAmmoType()
{
    if ( AmmoNames[0] == None )
        return AmmoName;
    else
        return AmmoNames[0];

}

// ----------------------------------------------------------------------
// LootWeaponAmmo()
//
// SARGE: Refactored this out of the Carcass Frob function so it was hopefully less horribly long,
// and it was repeated everywhere, all over the codebase. For shame, GMDX!!!
// ----------------------------------------------------------------------
function bool LootAmmo(DeusExPlayer P, bool bDisplayMsg, bool bDisplayWindow, optional bool bLootSound, optional bool bNoRemoveClipAmmo, optional bool bOverflow, optional bool bOverflowWindow)
{
    local class<Ammo> defAmmoClass;
    local int intj;
    local Texture overrideTexture;

    if (P == None)
        return false;
			
    // Only add ammo of the default type
    // There was an easy way to get 32 20mm shells, buy picking up another assault rifle with 20mm ammo selected
    // Add to default ammo only
    defAmmoClass = GetPrimaryAmmoType();

    //hack
    if (defAmmoClass == class'AmmoNone' || self.PickupAmmoCount <= 0)
        return false;

    //Shuriken hack
    if (IsA('WeaponShuriken') && WeaponShuriken(self).bImpaled)
        overrideTexture = Texture'RSDCrap.Icons.BeltIconShurikenBloody';

    intj = P.LootAmmo(defAmmoClass,PickupAmmoCount,bDisplayMsg,bDisplayWindow,bLootSound,!bDisposableWeapon,bDisposableWeapon,bOverflow && !bDisposableWeapon,bOverflowWindow,overrideTexture);

    if (intj > 0)
    {
        if (!bNoRemoveClipAmmo && !bDisposableWeapon)
            self.ClipCount = MAX(self.ClipCount - intj,0);
        PickupAmmoCount = MAX(PickupAmmoCount - intj,0);
        //P.ClientMessage("intj is > 0: " $ intj $ ", with pickupammocount: " $ pickupammocount);
        return true;
    }
    return false;
}

//Sarge: Update weapon frob display when we have a mod applied
function string GetFrobString(DeusExPlayer player)
{
    //Disposable weapons show their ammo count, if above 1 (which should only ever happen in the MJ12 prison facility)
    if (bDisposableWeapon && PickupAmmoCount > 1 && player.bShowItemPickupCounts)
        return itemName @ "(" $ PickupAmmoCount $ ")";
    //Modified weapons show their modified state
    else if (bModified && player != None && player.bBeltShowModified)
        return itemName @ "(" $ strModified $ ")";
    else
        return itemName;
}

//Sarge: Update weapon description/display when we have a mod applied
function string GetBeltDescription(DeusExPlayer player)
{
    if (bModified && player != None && player.bBeltShowModified)
        return beltDescription $ "+";
    else
        return beltDescription;
}

function bool CanUseWeapon(DeusExPlayer player, optional bool noMessage)
{
    local int skill;
    
    if (player == None || player.SkillSystem == None)
        return false;

    //NOTE: Order matters here, we need to short circuit to avoid the CheckSkill message
    return !player.bWeaponRequirementsMatter || player.SkillSystem.CheckSkill(GoverningSkill,minSkillRequirement,noMessage);
}

//SARGE: Added "Left Click Frob" and "Right Click Frob" support
//Return true to use the default frobbing mechanism (right click), or false for custom behaviour
function bool DoLeftFrob(DeusExPlayer frobber)
{
    Unrotate();
    return true;
}
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    Unrotate();
    return true;
}

function Unrotate()
{
    bRotated = false;
    invSlotsX=default.invSlotsX;
    invSlotsY=default.invSlotsy;
    largeIcon = default.largeIcon;
    UpdateLargeIcon();
}

//Updates the LargeIcon based on whether or not we're rotated
function UpdateLargeIcon()
{
    if (bRotated)
        largeIcon = largeIconRot;
    else
        largeIcon = largeIconUnrot;
}

//SARGE: Resize heavy weapons
function ResizeHeavyWeapon(DeusExPlayer player)
{
    local PerkMobileOrdnance perk;
    
    perk = PerkMobileOrdnance(player.PerkManager.GetPerkWithClass(class'DeusEx.PerkMobileOrdnance'));
    if (perk != None && perk.bPerkObtained)
    {
        //Inventory rotation hack.
        if (!bRotated)
        {
            invSlotsX=3;
            invSlotsY=1;
            invSlotsXTravel=3;
            invSlotsYTravel=1;
        }
        else
        {
            invSlotsX=1;
            invSlotsY=3;
            invSlotsXTravel=1;
            invSlotsYTravel=3;
            largeIcon = largeIconRot;
        }
    }
}

//Function to fix weapon offsets
function DoWeaponOffset(DeusExPlayer player)
{
    local bool bDoOffsets;
        
    if (player == None)
        return;

    if ((weaponOffsets.x != 0.0 || weaponOffsets.y != 0.0 || weaponOffsets.z != 0.0))
    {
    
        //Remember our old weapon offsets
        if (!bOldOffsetsSet)
        {
            //player.ClientMessage("Setting old offsets");
            oldOffsets.x = default.PlayerViewOffset.x;
            oldOffsets.y = default.PlayerViewOffset.y;
            oldOffsets.z = default.PlayerViewOffset.z;
            bOldOffsetsSet = true;
        }

        bDoOffsets = player.iEnhancedWeaponOffsets == 2 || (player.iEnhancedWeaponOffsets == 1 && player.defaultFOV >= 110);

        if (bDoOffsets && !IsClyzmModel())
        {
            default.PlayerViewOffset.x = weaponOffsets.x;
            default.PlayerViewOffset.y = weaponOffsets.y;
            default.PlayerViewOffset.z = weaponOffsets.z;
        }
        else if (bOldOffsetsSet)
        {
            default.PlayerViewOffset.x = oldOffsets.x;
            default.PlayerViewOffset.y = oldOffsets.y;
            default.PlayerViewOffset.z = oldOffsets.z;
        }
    }
}

//SARGE: Called when the item is added to the players hands
function Draw(DeusExPlayer frobber)
{
    //frobber.clientMessage("Draw!");

    //Fix allowing more in the clip than we have
	if(AmmoType != None)
		ClipCount = min(ClipCount,AmmoType.AmmoAmount);
    
    SetWeaponHandTex();

    DoWeaponOffset(frobber);
}

// ---------------------------------------------------------------------
// PropagateLockState()
// ---------------------------------------------------------------------
simulated function PropagateLockState(ELockMode NewMode, Actor NewTarget)
{
	LockMode = NewMode;
	LockTarget = NewTarget;
}

function Landed(Vector HitNormal)
{
	local Rotator rot;

	Super.Landed(HitNormal);

	bFixedRotationDir = False;
    rot = Rotation;
    rot.Pitch = 0;
    rot.Roll = 0;
    SetRotation(rot);
}

event Bump( Actor Other )
{
local float speed2, mult;
local DeusExPlayer player;
local vector any;

if (Physics == PHYS_None)
return;

player = DeusExPlayer(GetPlayerPawn());

if (player!=none && player.AugmentationSystem!=none)
mult = player.AugmentationSystem.GetAugLevelValue(class'AugMuscle');
if (mult == -1.0)
mult = 1.0;

speed2 = VSize(Velocity);

if (speed2 > 500)
{
if (Other.IsA('Pawn') || Other.IsA('Pickup') || (Other.IsA('DeusExDecoration') && DeusExDecoration(Other).minDamageThreshold < 30 && DeusExDecoration(Other).fragType != class'MetalFragment'))
  /*if (IsA('WeaponCrowbar'))
    Other.TakeDamage((Mass*0.225)*mult*2,player,Location,0.8*Velocity,'Shot');
  else
    Other.TakeDamage((Mass*0.225)*mult,player,Location,0.8*Velocity,'Shot');*/
  Other.TakeDamage((Mass*0.225)*mult,player,Location,0.8*Velocity,'Shot');      //RSD: No more extra thrown damage on Crowbar

if (Other.IsA('Pawn') && !Other.IsA('Robot'))
{
    if (!Other.IsA('ScriptedPawn') || ScriptedPawn(Other).bCanBleed)
        SpawnBlood(Location,any);
    PlaySound(Misc1Sound,SLOT_None,,,1024);
}
}
}
// ---------------------------------------------------------------------
// SetLockMode()
// ---------------------------------------------------------------------
simulated function SetLockMode(ELockMode NewMode)
{
	if ((LockMode != NewMode) && (Role != ROLE_Authority))
	{
	  if (NewMode != LOCK_Locked)
		 PropagateLockState(NewMode, None);
	  else
		 PropagateLockState(NewMode, Target);
	}
	TimeLockSet = Level.Timeseconds;
	LockMode = NewMode;
}

// ---------------------------------------------------------------------
// PlayLockSound()
// Because playing a sound from a simulated function doesn't play it
// server side.
// ---------------------------------------------------------------------
function PlayLockSound()
{
    if (!bLasing)
	    Owner.PlaySound(LockedSound, SLOT_None, 0.5);
}

//
// install the correct projectile info if needed
//
function TravelPostAccept()
{
	local int i;

	Super.TravelPostAccept();
	// make sure the AmmoName matches the currently loaded AmmoType
	if (AmmoType != None)
		AmmoName = AmmoType.Class;

	if (!bInstantHit || AmmoType.IsA('AmmoRubber'))
	{
		if (ProjectileClass != None)
			ProjectileSpeed = ProjectileClass.Default.speed;

		// make sure the projectile info matches the actual AmmoType
		// since we can't "var travel class" (AmmoName and ProjectileClass)
		if (AmmoType != None)
		{
			FireSound = None;
			for (i=0; i<ArrayCount(AmmoNames); i++)
			{
				if (AmmoNames[i] == AmmoName)
				{
					ProjectileClass = ProjectileNames[i];
					break;
				}
			}
		}
	}
}


//
// PreBeginPlay
//

function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Default.mpPickupAmmoCount == 0 )
	{
		Default.mpPickupAmmoCount = Default.PickupAmmoCount;
	}

    UpdateHDTPSettings();
    if (Owner != None && Owner.IsA('DeusExPlayer'))
        DoWeaponOffset(DeusExPlayer(Owner));
}

function SupportActor( actor StandingActor )
{
   if (!standingActor.IsA('RubberBullet')) //CyberP:
	StandingActor.SetBase( self );
}

function DropFrom(vector StartLocation)
{
	if ( !SetLocation(StartLocation) )
		return;
    UpdateHDTPSettings();
	//checkweaponskins();                                                       //RSD
    if (bIsCloaked || bIsRadar)                                                 //RSD: Overhauled cloak/radar routines
	 SetCloakRadar(false,false,true);//SetCloak(false,true);
	bMantlingEffect = False;
    BobDamping=default.BobDamping;
	bAimingDown=False;
	//EraseWeaponHandTex();                                                       //RSD: To ensure we don't get hand tex on dropped weapons
     //if (IsA('WeaponFlamethrower'))
      // if (Owner.IsA('DeusExPlayer'))
       //   DeusExPlayer(Owner).UpdateSensitivity(DeusExPlayer(Owner).default.MouseSensitivity);
    ScaleGlow = default.ScaleGlow;                                              //RSD: Also reset ScaleGlow so we don't get dim/bright due to cloak/radar

	super.dropfrom(startlocation);
	checkweaponskins();                                                         //RSD: Need to do this after so we know mesh for Clyzm model check
}

function bool IsClyzmModel()
{
    return IsHDTP() && iHDTPModelToggle == 2;
}

//Shorthand for accessing hands tex
function SetWeaponHandTex()
{
	local deusexplayer p;
	
    p = deusexplayer(owner);
	
    //FOMOD weapons use the FOMOD hands
    if (p != None && IsClyzmModel())
    {
        switch (p.PlayerSkin)
        {
			//default, black, latino, ginger, albino, respectively
			case 0: handsTex = class'HDTPLoader'.static.GetTexture("FOMOD.HandTexFinal"); break;
			case 1: handsTex = class'HDTPLoader'.static.GetTexture("FOMOD.HandTexFinalB"); break;
			case 2: handsTex = class'HDTPLoader'.static.GetTexture("FOMOD.HandTexFinalL"); break;
			case 3: handsTex = class'HDTPLoader'.static.GetTexture("FOMOD.HandTexFinalG"); break;
			case 4: handsTex = class'HDTPLoader'.static.GetTexture("FOMOD.HandTexFinalA"); break;
        }
    }
    else if(p != None)
        handsTex = p.GetWeaponHandTex();
    else
        handsTex = None;
    //p.ClientMessage("Skin Tex: " $ handsTex);
}

function SetCloakRadar(bool bEnableCloak, bool bEnableRadar, optional bool bForce) //RSD: Overhauled cloak/radar routines
{
	local bool bCheckCloak, bCheckRadar;

    if ((Owner==none)||(!Owner.IsA('DeusExPlayer'))) return;
	if (Owner!=none && Owner.IsA('DeusExPlayer'))
	{
	//DeusExPlayer(Owner).BroadcastMessage("Owner");
	//DeusExPlayer(Owner).BroadcastMessage(bIsRadar);
	if(!bEnableCloak&&(bIsCloaked||bForce))
	{
 	  //if (ScaleGlow==10.500001)                                               //RSD: Bad implementation and also no longer needed
      //   Style=default.Style;

	  bJustUncloaked = True;
	  if (bIsCloaked)
	     HideCamo();
	  bIsCloaked=false;
	  bCheckRadar=true;
	  CheckWeaponSkins();
	  //DeusExPlayer(Owner).BroadcastMessage("Cloak Off");
	}
	if (!bEnableRadar&&(bIsRadar||bForce))
	{
 	  //if (ScaleGlow==10.500001)                                               //RSD: Bad implementation and also no longer needed
      //    Style=default.Style;

	  bJustUnradar = True;
	  if (bIsRadar)
	     HideCamo();
	  bIsRadar=false;
	  bCheckCloak=true;
	  CheckWeaponSkins();
	  //DeusExPlayer(Owner).BroadcastMessage("Radar Off");
	}
	if (bEnableRadar &&(!bIsRadar||bForce||bCheckRadar))
	{
	  //AmbientGlow=255;                                                        //RSD: Removed ambient glow for proper stacking effect
	  bIsRadar=true;
 	  CheckWeaponSkins();
 	  ShowCamo();
 	  //DeusExPlayer(Owner).BroadcastMessage("Radar On");
	}
    if (bEnableCloak&&(!bIsCloaked||bForce||bCheckCloak))
	{
	  //AmbientGlow=255;
	  bIsCloaked=true;
	  CheckWeaponSkins();
	  ShowCamo();
	  //DeusExPlayer(Owner).BroadcastMessage("Cloak On");
	}
    }
}

function ShowCamo()
{
	local int     i;
	local texture curSkin;

		for (i=0; i<8; i++)
		{
			curSkin = GetMeshTexture(i);
			CamoPlayerViewSkins[i] = GetGridTexture(curSkin);
		}

		for (i=0; i<8; i++)
		{
		    if (i==MuzzleSlot && bHasMuzzleFlash)
		    {
		    }
		    else
			    MultiSkins[i] = CamoPlayerViewSkins[i];
        }

        //RSD: Overhauled cloak/radar routines
        if (bIsCloaked && !bIsRadar)
        {
		    Skin = FireTexture'GameEffects.InvisibleTex';
		    Texture = FireTexture'GameEffects.InvisibleTex';
		    Style = STY_Translucent;
		    ScaleGlow=0.500000;                                                 //RSD: If only cloak on, use cloak ScaleGlow
        }
        else if (bIsRadar && !bIsCloaked)
        {
            Skin = Texture'Effects.Electricity.Xplsn_EMPG';
		    Texture = Texture'Effects.Electricity.Xplsn_EMPG';
		    Style = STY_Normal;                                                 //RSD: Going for a solid texture here
		    ScaleGlow=10.500001;                                                //RSD: If only radar on, use radar ScaleGlow
        }
        else
        {
            Skin = Texture'Effects.Electricity.Xplsn_EMPG';
		    Texture = Texture'Effects.Electricity.Xplsn_EMPG';
		    Style = STY_Translucent;                                            //RSD: But translucent if we have cloak + radar
		    ScaleGlow=default.ScaleGlow;                                        //RSD: If both are on, default to cloak ScaleGlow
        }
}

function HideCamo()
{
    UpdateHDTPSettings();
}

function Texture GetGridTexture(Texture tex)
{
	if (tex == None)
		return Texture'BlackMaskTex';
	else if (tex == Texture'BlackMaskTex')
		return Texture'BlackMaskTex';
	else if (tex == Texture'GrayMaskTex')
		return Texture'BlackMaskTex';
	else if (tex == Texture'PinkMaskTex')
		return Texture'BlackMaskTex';
	else if (bIsCloaked && !bIsRadar)                                           //RSD: Overhauled cloak/radar routines
	    return FireTexture'GameEffects.InvisibleTex';
	else if (bIsRadar)//class'DeusExPlayer'.default.bRadarTran==True)           //RSD
        return Texture'Effects.Electricity.Xplsn_EMPG';
	/*else                                                                      //RSD
		return FireTexture'GameEffects.InvisibleTex';*/
}
//=============================================================================
// Weapon rendering
// Draw first person view of inventory
//=============================================================================

simulated event RenderOverlays( canvas Canvas )
{
	local rotator NewRot, ExRot, rfs;                                           //RSD: Added rfs
	local bool bPlayerOwner;
	local int Hand;
	local DeusExPlayer PlayerOwner;
    local int newPitch;
    local vector dx, dy, dz;                                                    //RSD: Added

	if ( bHideWeapon || (Owner == None) )
		return;

	PlayerOwner = DeusExPlayer(Owner);

	if ( PlayerOwner != None )
	{
		//if ( PlayerOwner.DesiredFOV != PlayerOwner.DefaultFOV )
		//	return;
		//if (bZoomed || (PlayerOwner.bSpyDroneActive && !PlayerOwner.bSpyDroneSet && !PlayerOwner.bBigDroneView))
		if (bZoomed)
		    return;

		bPlayerOwner = true;
		Hand = PlayerOwner.Handedness;

		if (  (Level.NetMode == NM_Client) && (Hand == 2) )
		{
			bHideWeapon = true;
			return;
		}
    
        DisplayWeapon(true);
    
        if (bIsRadar || bIsCloaked)
        {
            ShowCamo();
        }
	}

	if ( !bPlayerOwner || (PlayerOwner.Player == None) )
		Pawn(Owner).WalkBob = vect(0,0,0);

	if ( (bMuzzleFlash > 0) && bDrawMuzzleFlash && Level.bHighDetailMode && (MFTexture != None) )
	{
		MuzzleScale = Default.MuzzleScale * Canvas.ClipX/640.0;
		if ( !bSetFlashTime )
		{
			bSetFlashTime = true;
			FlashTime = Level.TimeSeconds + FlashLength;
		}
		else if ( FlashTime < Level.TimeSeconds )
			bMuzzleFlash = 0;
		if ( bMuzzleFlash > 0 )
		{
			if ( Hand == 0 )
				Canvas.SetPos(Canvas.ClipX/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipX * (-0.2 * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipY * (FlashY + FlashC));
			else
				Canvas.SetPos(Canvas.ClipX/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipX * (Hand * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipY * FlashY);

			Canvas.Style = 3;
			Canvas.DrawIcon(MFTexture, MuzzleScale);
			Canvas.Style = 1;
		}
	}
	else
		bSetFlashTime = false;

	SetLocation( Owner.Location + CalcDrawOffset() );
    NewRot = Pawn(Owner).ViewRotation;

	if (PlayerOwner != none)
    {
        //RSD: New adjustment to rotation without being pitch-dependent
        rfs.Yaw=addYaw;
        rfs.Pitch=addPitch;
        GetAxes(rfs,dx,dy,dz);
        dx=dx>>PlayerOwner.GetCurrentViewRotation();
        dy=dy>>PlayerOwner.GetCurrentViewRotation();
        dz=dz>>PlayerOwner.GetCurrentViewRotation();
        rfs=OrthoRotation(dx,dy,dz);
        NewRot = rfs;

        //RSD: Overhauled cloak/radar routines
        SetCloakRadar(class'DeusExPlayer'.default.bCloakEnabled,class'DeusExPlayer'.default.bRadarTran);
    }
    
    setRotation(NewRot);
    Canvas.DrawActor(self, false);

    if (activateAn && bHasScope)
        DrawScopeAnimation();
    else
        activateAn = false;

    //Reset weapon to standard display
    DisplayWeapon(false);
}

//
// Draw the scope view
//

function DrawScopeAnimation()
{
    ScopeToggle(); 
    activateAn = false;
}

simulated function DrawFancyScopeAnimation()
{
    local DeusExPlayer player;
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector unX,unY,unZ;
    local int totalScopeTime;

	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=6912*Fmin(1.0,GEPinout);
	rfs.Pitch=2912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);
    
    player = DeusExPlayer(Owner);

	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);

	PlayerViewOffset=Default.PlayerViewOffset*100;//meh
	SetHand(player.Handedness); //meh meh

    //SARGE: This probably shouldn't be hardcoded!
    if (GoverningSkill == Class'DeusEx.SkillWeaponRifle' && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkMarksman').bPerkObtained == true)                                          //RSD: Was PerkNamesArray[12], now PerkNamesArray[23] (merged Advanced with Master Rifles perk)
    {
        PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
        PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
        PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
        totalScopeTime = 17;
	}
	else
	{
        PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
        PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
        PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
        totalScopeTime = 25;
	}

	SetLocation(player.Location+ CalcDrawOffset());
	scopeTime+=1;

	if (scopeTime>=totalScopeTime)
	{
        activateAn = False;
        scopeTime = 0;
        ScopeToggle();
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        SetHand(player.Handedness);
    }
}


//
// PostBeginPlay
//

function PostBeginPlay()
{
local DeusExPlayer playa;

	Super.PostBeginPlay();
	if (Level.NetMode != NM_Standalone)
	{
	  bWeaponStay = True;
	  if (bNeedToSetMPPickupAmmo)
	  {
		 PickupAmmoCount = PickupAmmoCount * 3;
		 bNeedToSetMPPickupAmmo = False;
	  }
	}
    playa = DeusExPlayer(GetPlayerPawn());
    if (playa != None && playa.bExtraHardcore && playa.bHardCoreMode && Owner == None)
            BaseAccuracy = default.BaseAccuracy + 0.2;

    //RSD: Failsafe in case we don't have these set; use the original ranges for NPC AI
	if (NPCmaxRange == 0)
	  NPCmaxRange = default.MaxRange;
    if (NPCAccurateRange == 0)
      NPCAccurateRange = default.AccurateRange;

    if (!givenFreeReload && (Owner == None || Owner.IsA('ScriptedPawn')))
    {
        ClipCount = ReloadCount;
        givenFreeReload = true;
    }

}

function ReloadMaxAmmo()
{
    if (AmmoType != None)
        ClipCount = Min(ReloadCount,AmmoType.AmmoAmount);
}

//SARGE: Fix a really horrible ammo giving bug where weapons won't give ammo if there's not
//enough room to spawn their corresponding ammo actor.
//Copied from Weapon.uc
function GiveAmmo( Pawn Other )
{
	if ( AmmoName == None || Other == None )
		return;

	AmmoType = Ammo(Other.FindInventoryType(AmmoName));

	if ( AmmoType != None )
		AmmoType.AddAmmo(PickUpAmmoCount);
	else
	{
        //SARGE: Here's the nasty bug!
        //Spawn will fail if there's not enough room to spawn the relevant ammo...
		AmmoType = Ammo(class'SpawnUtils'.static.SpawnSafe(AmmoName,self));	// Create ammo type required		

		if ( AmmoType != None )
		{
			Other.AddInventory(AmmoType);		// and add to player's inventory
			AmmoType.BecomeItem();
			AmmoType.AmmoAmount = PickUpAmmoCount; 
			AmmoType.GotoState('Idle2');
		}
	}
}	

function PostPostBeginPlay()
{
	Super.PostPostBeginPlay();

    if (!bUnlit && ScaleGlow > 0.5)
        ScaleGlow = 0.5;
}

singular function BaseChange()
{
	// Make sure we fall if we don't have a base
	if ((base == None) && (Owner == None))
		SetPhysics(PHYS_Falling);

	Super.BaseChange();
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
        local float dammult, massmult;

		if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation'))
			return;

		if ((DamageType == 'EMP') || (DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
			return;

		if (DamageType == 'HalonGas')
			return;

    if (Owner == None)
    {
    dammult = damage*0.1;
    if (dammult < 1.1)
    dammult = 1.1;
    else if (dammult > 2.5)                                                     //RSD: Was 20
    dammult = 2.5;  //capped so objects do not fly about at light speed.        //RSD: Was 20


    if (mass < 10)
    massmult = 1.2;
    else if (mass < 20)
    massmult = 1.1;
    else if (mass < 30)
    massmult = 1;
    else if (mass < 50)
    massmult = 0.7;
    else if (mass < 80)
    massmult = 0.4;
    else
    massmult = 0.2;

    SetPhysics(PHYS_Falling);
    Velocity = (Momentum*0.25)*dammult*massmult;
    if (VSize(Momentum) > 1000)                                                 //RSD: Damp out super high momentum
      Velocity *= 1000/VSize(Momentum);
    if (Velocity.Z <= 0)
    Velocity.Z = 80;
    bFixedRotationDir = True;
    if (mass < 40)
    {
	RotationRate.Pitch = (32768 - Rand(65536)) * dammult;
	RotationRate.Yaw = (32768 - Rand(65536)) * dammult;
	}
	}
}

//SARGE: Moved this to a new function so that it can be used
//even at full ammo.
function CopyModsFrom(DeusExWeapon W, optional bool bNotify)
{
    if (W.ModBaseAccuracy > ModBaseAccuracy)
        ModBaseAccuracy = W.ModBaseAccuracy;
    if (W.ModReloadCount > ModReloadCount)
        ModReloadCount = W.ModReloadCount;
    if (W.ModAccurateRange > ModAccurateRange)
        ModAccurateRange = W.ModAccurateRange;

    // these are negative
    if (W.ModReloadTime < ModReloadTime)
        ModReloadTime = W.ModReloadTime;
    if (W.ModRecoilStrength < ModRecoilStrength)
        ModRecoilStrength = W.ModRecoilStrength;

    if (W.bHasLaser)
        bHasLaser = True;
    if (W.bHasSilencer)
        bHasSilencer = True;
    if (W.bHasScope)
        bHasScope = True;
    if (W.bFullAuto)     //CyberP:
        bFullAuto = True;

    // copy the actual stats as well
    if (W.ReloadCount > ReloadCount)
        ReloadCount = W.ReloadCount;
    if (W.AccurateRange > AccurateRange)
        AccurateRange = W.AccurateRange;

    // these are negative
    if (W.BaseAccuracy < BaseAccuracy)
        BaseAccuracy = W.BaseAccuracy;
    if (W.ReloadTime < ReloadTime)
        ReloadTime = W.ReloadTime;
    if (W.RecoilStrength < RecoilStrength)
        RecoilStrength = W.RecoilStrength;

    //ROF mod
        if(W.ModShotTime < ModShotTime)
            ModShotTime = W.ModShotTime;
    //DAM mod
        if(W.ModDamage > ModDamage)
            ModDamage = W.ModDamage;
    
    if (W.bModified && !bModified && bNotify)
    {
        if (Owner != None && Owner.IsA('DeusExPlayer'))
            DeusExPlayer(Owner).ClientMessage(sprintf(msgModsCopied,W.ItemName));
        PlaySound(CopyModsSound,SLOT_None,0.8);
    }

    if (W.bModified)
        bModified = true;

}

function bool HandlePickupQuery(Inventory Item)
{
	local DeusExWeapon W;
	local DeusExPlayer player;
	local bool bResult;
	local class<Ammo> defAmmoClass;
	local Ammo defAmmo;
	local int tempmaxammo, intj;                                                //RSD

	// make sure that if you pick up a modded weapon that you
	// already have, you get the mods
	W = DeusExWeapon(Item);
	if ((W != None) && (W.Class == Class))
	{
        CopyModsFrom(W,true);
	}
    
	player = DeusExPlayer(Owner);
    if (player != None)
    {
        player.UpdateHUD(); //SARGE: Required now because weapons can have + icons in the HUD
		
    }

	if (Item.Class == Class)
	{
	  if (!( (Weapon(item).bWeaponStay && (Level.NetMode == NM_Standalone)) && (!Weapon(item).bHeldItem || (Weapon(item).bTossedOut))))
		{
            if ( Level.NetMode != NM_Standalone )
            {
                if (( player != None ) && ( player.InHand != None ))
                {
                    if ( DeusExWeapon(item).class == DeusExWeapon(player.InHand).class )
                        ReadyToFire();
                }
            }
		}
	}

	//bResult = Super.HandlePickupQuery(Item);
	bResult = HandlePickupQuerySuper(Item);                                     //RSD: optimized pickup messages

	// Notify the object belt of the new ammo
	if (player != None)
		player.UpdateBeltText(Self);
            
	return bResult;
}

function bool HandlePickupQuerySuper( inventory Item )                          //RSD: To be used in place of Super.HandlePickupQuery(item) for optimized pickup messages
{
	local Pawn P;
    local DeusExAmmo DXAmmoType;
    local bool bResult;
	if (Item.Class == Class)
	{

		if ( Weapon(item).bWeaponStay && (!Weapon(item).bHeldItem || Weapon(item).bTossedOut) )
			return true;
		P = Pawn(Owner);
//		if ( AmmoType != None )
//		{
//			OldAmmo = AmmoType.AmmoAmount;
//
//			// DEUS_EX CNN - never switch weapons automatically, but do add the ammo
//			AmmoType.AddAmmo(Weapon(Item).PickupAmmoCount);
//			if ( AmmoType.AddAmmo(Weapon(Item).PickupAmmoCount) && (OldAmmo == 0)
//				&& (P.Weapon.class != item.class) && !P.bNeverSwitchOnPickup )
//					WeaponSet(P);
//		}
        if (AmmoNames[0] == None)                                               //RSD: Get the ammo type
        	DXAmmoType = DeusExAmmo(P.FindInventoryType(AmmoName));
        else
        	DXAmmoType = DeusExAmmo(P.FindInventoryType(AmmoNames[0]));

		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
        /*
		if (DeusExWeapon(item) != none && DeusExWeapon(item).bDisposableWeapon) //RSD: Only print pickup message if it's a grenade
		{
            if (Item.PickupMessageClass == None)
            {
                // DEUS_EX CNN - use the itemArticle and itemName
                P.ClientMessage(PickupMessage @ itemArticle @ itemName, 'Pickup');
            }
            else
                P.ReceiveLocalizedMessage( Item.PickupMessageClass, 0, None, None, item.Class );
		}
        */
		Item.PlaySound(Item.PickupSound);
		Item.SetRespawn();
		
        return true;
	}
	if ( Inventory == None )
		return false;
        
	return Inventory.HandlePickupQuery(Item);
}

function SetDroppedAmmoCount(int amountPassed) //RSD: Added optional int amountPassed for initialization in MissionScript.uc //SARGE: Generified this for corpses too, now takes an optional impale count
{
    if (amountPassed == 0) //RSD: If we didn't get anything, set to old formula
        amountPassed = Rand(4) + 1;

    // Any weapons have their ammo set to a random number of rounds (1-4)
	// unless it's a grenade, in which case we only want to dole out one.
	// DEUS_EX AMSD In multiplayer, give everything away.
	// Grenades and LAMs always pickup 1
                        
    //Handle impales.
    //Impales have their pickupammocount set manually, so don't change it
    if (IsA('WeaponShuriken') && WeaponShuriken(Self).bImpaled)
        return;

    // Grenades and LAMs always pickup 1
    else if (bDisposableWeapon && !IsA('WeaponShuriken'))
        PickupAmmoCount = 1;
    else if (IsA('WeaponShuriken'))
        PickupAmmoCount = MAX(1,amountPassed / 2);                //SARGE: capped at 2
    else if (IsA('WeaponFlamethrower'))
        PickupAmmoCount = (amountPassed * 5);                    //SARGE: Now 5-25 rounds with initialization in MissionScript.uc on first map load
    else if (IsA('WeaponPepperGun'))
        PickupAmmoCount = 35 + (amountPassed * 3);               //SARGE: Now 38-50 rounds with initialization in MissionScript.uc on first map load
    else if (IsA('WeaponAssaultGun'))
        //PickupAmmoCount = Rand(5) + 1.5;                          //RSD
        PickupAmmoCount = amountPassed + 2;                      //RSD: Now 2-5 rounds with initialization in MissionScript.uc on first map load //SARGE: Now 3-6
    else if (IsA('WeaponGepGun'))
        PickupAmmoCount = 2;
    else if (amountPassed > 0)
        PickupAmmoCount = amountPassed;                            //RSD
    //SARGE: Failsafe??? Originally CyberP's code but made no sense
    else if (default.PickupAmmoCount != 0)
        PickupAmmoCount = 1; //CyberP: hmm

    clipcount = MIN(PickupAmmoCount,ReloadCount);
}

function BringUp()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( False );

	// alert NPCs that I'm whipping it out
	if (!bNativeAttack && bEmitWeaponDrawn)
		AIStartEvent('WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	//standingTimer = 0;                                                        //RSD: we grab from savedStandingTimer in DeusExPlayer now for Sidearm perk
	if (Owner.IsA('DeusExPlayer'))
		standingTimer = DeusExPlayer(Owner).savedStandingTimer;
	else
	    standingTimer = 0.0;
    lerpAid = 0;
    bMantlingEffect = False;
	CheckWeaponSkins();

	Super.BringUp();
}

function PlaySelect()
{
    local DeusExPlayer player;
    local float p, mod;
    local Projectile firedProjectile;

     player = DeusExPlayer(Owner);

     if (bBeginQuickMelee)
     {
       if (IsA('WeaponNanoSword') && !bAlreadyQuickMelee)
       {
             Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
             AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 416);
       }
       if (ReloadCount > 0)
			AmmoType.UseAmmo(1);

       if (meleeStaminaDrain != 0)
       {
       if (player != none)
       {
		mod = player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
        if (mod < 3)
          mod = 1;
        else
          mod = 0.5;
        if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme cancels all melee stamina drain
          mod = 0.0;

        player.swimTimer -= meleeStaminaDrain*mod;
          if (player.swimTimer < 0)
		     player.swimTimer = 0;
        }
        }

		bReadyToFire = False;
		GotoState('NormalFire');
		bPointing=True;
		if (IsA('WeaponHideAGun') || IsA('WeaponLAW'))
        {
            firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
            OnProjectileFired(firedProjectile);
        }
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
     }
     else if (bBeginAmmoSelectLoad)                                             //RSD: For ammo load queued by LoadAmmo() or WeaponChangeAmmo() in PersonaScreenInventory.uc
     {
		bAmmoSelectWait = true;                                                 //RSD: Need to wait one tick to load ammo otherwise the reload state doesn't engage (???)
		//LoadAmmoClass(ammoSelectClass);
		bBeginAmmoSelectLoad = false;
     }
     else
     {
     if (player != none && player.AugmentationSystem != none)
     {
        if (!NearWallCheck())
           bInvisibleWhore=False;
        p = player.AugmentationSystem.GetAugLevelValue(class'AugCombat');
        if (p < 1.0)
        {
           p = 1.0;
           if (IsA('WeaponMiniCrossbow') || IsA('WeaponSawedOffShotgun') || IsA('WeaponLAW'))
               p = 1.2;
        }
        if (player != None && IsA('WeaponSawedOffShotgun'))
           player.ShakeView(0.1, 96, 4);
     }
    PlayAnim('Select',p,0.0);
    bAimingDown=False;
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
	negTime = 0;
	
    if (player != none && bLaserToggle) //Sarge: Add laser check to re-enable laser if we turned it on
	{                                   //Sarge: The block for mantling checks was also removed, now it uses this directly
	   LaserOn(true);
	}
	}
}

static function bool IsHDTP()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && default.iHDTPModelToggle > 0;
}

function bool IsHDTPMuzzle()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && (default.iHDTPModelToggle > 0 || bHDTPMuzzleFlashes);
}

function CheckWeaponSkins()
{
    DisplayWeapon(false);
}


function bool PutDown()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( False );

	// alert NPCs that I'm putting away my gun
	AIEndEvent('WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	standingTimer = 0;

	return Super.PutDown();
}

function ReloadAmmo()
{
local string msgEKEToggle;
local string msgPlasmaToggle;
local string msgContactOn;
local string msgContactOff;

	// single use or hand to hand weapon if ReloadCount == 0
	if (ReloadCount == 0 || bDisposableWeapon)
	{
	    //if (Owner.IsA('DeusExPlayer'))
		//    DeusExPlayer(Owner).ClientMessage(msgCannotBeReloaded); //SARGE: Disabled. This message is annoying as fuck!
		return;
	}
	else if (activateAn == True)
	{
	    return;
	}

	//if ((IsA('WeaponHideAGun') || GoverningSkill==class'DeusEx.SkillDemolition') && Pawn(Owner).IsA('ScriptedPawn'))
	//   return;

	if (AmmoType.AmmoAmount > 0 && ReloadCount > 0 && !bDisposableWeapon) //GMDX: fix the finish anim->state idle anim //SARGE: Don't allow reloading weapons with a reload count of 0 or disposables
	{
		if (!IsInState('Reload'))
		{
            TweenAnim('Still', 0.1);
			GotoState('Reload');
		}
	}
}

//
// Note we need to control what's calling this...but I'll get rid of the access nones for now
//
simulated function float GetWeaponSkill()
{
	local DeusExPlayer player;
	local float value;

	value = 0;

	if ( Owner != None )
	{
		player = DeusExPlayer(Owner);
		if (player != None)
		{
			if ((player.AugmentationSystem != None ) && ( player.SkillSystem != None ))
			{
				// get the target augmentation
                if (!bHandToHand || IsA('WeaponShuriken'))
                {
                    value = player.AugmentationSystem.GetAugLevelValue(class'AugTarget');
                    if (value == -1.0)
                        value = 0;
                }

				// get the skill
				value += player.SkillSystem.GetSkillLevelValue(GoverningSkill);
			}
		}
	}
	return value;
}

//SARGE: Terrible function, this needs a rewrite.
//This is only used for updating the frob info in the tool window,
//and for picking a melee weapon to use for left-frobbing.
//It has absolutely no bearing on actually doing any damage,
//which is why it needs a rework.
function int CalculateTrueDamage()
{
	local int trueDamage;
    local DeusExPlayer P;
    local float mult;
    local float hit;

    P = DeusExPlayer(Owner);

    //SARGE: Factor in Targeting and Combat Strength
    //SARGE: NOTE: Targeting is handled in GetWeaponSkill, so not needed here.
    if (P != None && bHandToHand && !bFakeHandToHand)
    {
        if (P.AugmentationSystem != None)
            mult = P.AugmentationSystem.GetAugLevelValue(class'AugCombatStrength');

        if (mult < 1.0)
            mult = 0.0;
        else
            mult -= 1.0;
        
        if (P.AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost
            mult += 0.5;
	}

    //SARGE: I have no idea why the crossbow is so fucked...
    if (IsA('WeaponMiniCrossbow'))
        hit = HitDamage - 2;
    else
        hit = HitDamage;

    trueDamage = int(hit * (1.0 - (2.0 * GetWeaponSkill()) + mult + ModDamage));

    if (ammoType != None && ammoType.Class == class'AmmoRocketWP')
        trueDamage *= 0.25 * 0.25;

    //P.ClientMessage("Damage: " $ hit $ " - " $ trueDamage @ "(" $ mult @ GetWeaponSkill() @ ")" $ ", AmmoType is " $ ammoType.Class);
	return trueDamage;
}

// calculate the accuracy for this weapon and the owner's damage
simulated function float CalculateAccuracy()
{
	local float accuracy;	// 0 is dead on, 1 is pretty far off
	local float tempacc, div;
	local float weapskill; // so we don't keep looking it up (slower).
	local int HealthArmRight, HealthArmLeft, HealthHead;
	local int BestArmRight, BestArmLeft, BestHead;
	local bool checkit;
	local DeusExPlayer player;
	local int HealthArmHighest, BestArmHighest;                                 //RSD: Added
	local bool bCheckHighestHealthArm;                                          //RSD: Added

	accuracy = BaseAccuracy;		// start with the weapon's base accuracy
	weapskill = GetWeaponSkill();
    player = DeusExPlayer(Owner);

	if (player != None)
	{
		// check the player's skill
		// 0.0 = dead on, 1.0 = way off
		accuracy += weapskill;

        if (player.AddictionManager.addictions[1].bInWithdrawals)                                //RSD: If suffering from alcohol withdrawal, add 15% inaccuracy
        	accuracy += 0.4;

		// get the health values for the player
		HealthArmRight = player.HealthArmRight;
		HealthArmLeft  = player.HealthArmLeft;
		HealthHead     = player.HealthHead;
		BestArmRight   = player.Default.HealthArmRight;  //GMDX !TODO :check how this affects base accuracy, if overflow when health >100
		BestArmLeft    = player.Default.HealthArmLeft;
		BestHead       = player.Default.HealthHead;
		checkit = True;

		HealthArmHighest = Max(HealthArmLeft, HealthArmRight);                  //RSD: Get max
		BestArmHighest = Max(BestArmLeft, BestArmRight);                        //RSD: Get max
		bCheckHighestHealthArm = GoverningSkill == class'SkillWeaponPistol' && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkAmbidextrous').bPerkObtained; //RSD: New One-Handed perk for Pistols
	}
	else if (ScriptedPawn(Owner) != None)
	{
		// update the weapon's accuracy with the ScriptedPawn's BaseAccuracy
		// (BaseAccuracy uses higher values for less accuracy, hence we add)
		accuracy += ScriptedPawn(Owner).BaseAccuracy;

		// get the health values for the NPC
		HealthArmRight = ScriptedPawn(Owner).HealthArmRight;
		HealthArmLeft  = ScriptedPawn(Owner).HealthArmLeft;
		HealthHead     = ScriptedPawn(Owner).HealthHead;
		BestArmRight   = ScriptedPawn(Owner).Default.HealthArmRight;
		BestArmLeft    = ScriptedPawn(Owner).Default.HealthArmLeft;
		BestHead       = ScriptedPawn(Owner).Default.HealthHead;
		checkit = True;
	}
	else
		checkit = False;

	// Disabled accuracy mods based on health in multiplayer
	if ( Level.NetMode != NM_Standalone )
		checkit = False;

	if (checkit)
	{
		if (bCheckHighestHealthArm)                                             //RSD: Only check highest health arm if we have the One-Handed perk
		{
		if (HealthArmHighest < 1)
			accuracy += 0.5;
		else if (HealthArmHighest < BestArmHighest * 0.34)
			accuracy += 0.2;
		else if (HealthArmHighest < BestArmHighest * 0.67)
			accuracy += 0.1;
		}
        else                                                                    //RSD: Otherwise do the old routine
        {
        if (HealthArmRight < 1)
			accuracy += 0.5;
		else if (HealthArmRight < BestArmRight * 0.34)
			accuracy += 0.2;
		else if (HealthArmRight < BestArmRight * 0.67)
			accuracy += 0.1;

		if (HealthArmLeft < 1)
			accuracy += 0.5;
		else if (HealthArmLeft < BestArmLeft * 0.34)
			accuracy += 0.2;
		else if (HealthArmLeft < BestArmLeft * 0.67)
			accuracy += 0.1;
        }

		if (HealthHead < BestHead * 0.67)
			accuracy += 0.1;
	}

	// increase accuracy (decrease value) if we haven't been moving for awhile
	// this only works for the player, because NPCs don't need any more aiming help!
	if (player != None)
	{
        //SARGE: Add accuracy penalty for having weapon mods
        accuracy += GetAddonPenalty(Silencer);

		tempacc = accuracy;
		if (standingTimer > 0)
		{
			// higher skill makes standing bonus greater
			div = Max(15.0 + 29.0 * weapskill, 0.0);
			accuracy -= FClamp(standingTimer/div, 0.0, 0.6);

			// don't go too low
			if (accuracy < 0.1 && tempacc > 0.1)
				accuracy = 0.1;
		}
	}

	// make sure we don't go negative
	if (accuracy < 0.0)
		accuracy = 0.0;

	if (Level.NetMode != NM_Standalone)
	  if (accuracy < MinWeaponAcc)
		 accuracy = MinWeaponAcc;

	return accuracy;
}

//
// functions to change ammo types
//
function bool LoadAmmo(int ammoNum)
{
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	if ((ammoNum < 0) || (ammoNum > 3))      //CyberP: ammo part 6
		return False;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return False;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass != None)
	{
		if (newAmmoClass != AmmoName)
		{
			newAmmo = Ammo(P.FindInventoryType(newAmmoClass));
			if (newAmmo == None)
			{
				//P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.Default.ItemName)); //RSD: Annoying logspam if we've never picked up an ammo type
				return False;
			}
			else if (newAmmo.AmmoAmount <= 0)                                   //RSD: However, if we HAVE picked up the ammo type before, then definitely DO have a message!
			{
			    P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.Default.ItemName));
				return False;
			}


			// if we don't have a projectile for this ammo type, then set instant hit
			if (ProjectileNames[ammoNum] == None || ProjectileNames[ammoNum] == Class'DeusEx.RubberBullet')
			{
				bInstantHit = True;
				bAutomatic = (Default.bAutomatic || (bFullAuto && IsA('WeaponStealthPistol'))); //RSD: Added || bFullAuto so that stealth pistol ROF isn't fucked when loading alt ammo

				//New stuff -- ROF Mod

				if(HasROFMod())
				{
                    ShotTime = Default.ShotTime * (1.0+ModShotTime);
				}
				else
					ShotTime = Default.ShotTime;

				if ( Level.NetMode != NM_Standalone )
				{
					if (HasReloadMod())
						ReloadTime = mpReloadTime * (1.0+ModReloadTime);
					else
						ReloadTime = mpReloadTime;
				}
				else
				{
					if (HasReloadMod())
						ReloadTime = Default.ReloadTime * (1.0+ModReloadTime);
					else
						ReloadTime = Default.ReloadTime;
				}

				if (ProjectileNames[ammoNum] == Class'DeusEx.RubberBullet')
				{
					ProjectileClass = ProjectileNames[ammoNum];
					ProjectileSpeed = ProjectileClass.Default.Speed;
				}
				else
				ProjectileClass = None;
			}
			else
			{
				// otherwise, set us to fire projectiles
				bInstantHit = False;
				bAutomatic = False;
				//ShotTime = 1.0;
				//New stuff -- ROF Mod

				if(HasROFMod())
					ShotTime = Default.ShotTime * (1.0+ModShotTime);
				else
					ShotTime = Default.ShotTime;

                if (IsA('WeaponAssaultGun'))                                    //RSD: Defaulting everything to 2 for the AR's 20mm was messing up the crossobw reload time if you switched ammo types
                {
				if (HasReloadMod())
					ReloadTime = 2.0 * (1.0+ModReloadTime);
				else
					ReloadTime = 2.0;
				}
				else
				{
				if (HasReloadMod())
					ReloadTime = Default.ReloadTime * (1.0+ModReloadTime);
				else
					ReloadTime = Default.ReloadTime;
				}
				FireSound = None;		// handled by the projectile
				ProjectileClass = ProjectileNames[ammoNum];
				ProjectileSpeed = ProjectileClass.Default.Speed;
			}

			AmmoName = newAmmoClass;
			AmmoType = newAmmo;

            if (bPerShellReload)                                                //RSD: originally we checked this in the classes that call LoadAmmo(). was IsA(...), now done with a simple bool check
            {
                ClipCount = 0;
            }

			if ( Ammo20mm(newAmmo) != None || Ammo762mm(newAmmo) != None)
			{
				SwitchModes();
			}

            //P.BroadcastMessage(ClipCount);

			// AlexB had a new sound for 20mm but there's no mechanism for playing alternate sounds per ammo type
			// Same for WP rocket
			if ( Ammo20mm(newAmmo) != None )
				{
                    if (bHasSilencer)
                        FireSilentSound=Sound'AssaultGunFire20mm';     //CyberP: if silenced also
                }
            /*else if ( Ammo20mmEMP(newAmmo) != None )
				{
                FireSound=Sound'MediumExplosion1';
                if (bHasSilencer)
                   FireSilentSound=Sound'MediumExplosion1';     //CyberP: if silenced also
                }*/
            else if ( Ammo762mm(newAmmo) != None)
            {
                if (bHasSilencer)    //CyberP: revert back to norm
                   FireSilentSound=default.FireSilentSound;
            }
            /*else if ( AmmoPlasmaSuperheated(newAmmo) != None )
                {
                bSuperheated=True;
                //ShotTime=1.1;
                bAutomatic=true;
                ReloadCount=50;
                //recoilStrength=0.050000;
                AltFireSound=Sound'GMDXSFX.Weapons.freezepick';
                }
            else if (AmmoPlasma(newAmmo) != None)
            {
                bSuperheated=False;
                bAutomatic=false;
                //ShotTime=Default.ShotTime;
                ReloadCount=Default.ReloadCount;
                //recoilStrength=Default.recoilStrength;
                AltFireSound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd';
            }*/

			if ( Level.NetMode != NM_Standalone )
				SetClientAmmoParams( bInstantHit, bAutomatic, ShotTime, FireSound, ProjectileClass, ProjectileSpeed );

			// Notify the object belt of the new ammo
			if (DeusExPlayer(P) != None)
				DeusExPlayer(P).UpdateBeltText(Self);

			if (IsA('WeaponAssaultGun'))
			{
			}
			else
			{
				ReloadAmmo();
				P.ClientMessage(Sprintf(msgNowHas, ItemName, newAmmoClass.Default.ItemName));
			}

			return True;
		}
		else
		{
			P.ClientMessage(Sprintf(MsgAlreadyHas, ItemName, newAmmoClass.Default.ItemName)); //RSD: note msgAlreadyHas changed from "%s already has %s loaded" to "No other ammo to load" in DeusEx.int, the other arguments are for unchanged localization files
		}
	}

	return False;
}

// ----------------------------------------------------------------------
//
// ----------------------------------------------------------------------

simulated function SetClientAmmoParams( bool bInstant, bool bAuto, float sTime, Sound FireSnd, class<projectile> pClass, float pSpeed )
{
	bInstantHit = bInstant;
	bAutomatic = bAuto;
	ShotTime = sTime;
	FireSound = FireSnd;
	ProjectileClass = pClass;
	ProjectileSpeed = pSpeed;
}

// ----------------------------------------------------------------------
// CanLoadAmmoType()
//
// Returns True if this ammo type can be used with this weapon
// ----------------------------------------------------------------------

simulated function bool CanLoadAmmoType(Ammo ammo)
{
	local int  ammoIndex;
	local bool bCanLoad;

	bCanLoad = False;

	if (ammo != None)
	{
		// First check "AmmoName"

		if (AmmoName == ammo.Class)
		{
			bCanLoad = True;
		}
		else
		{
			for (ammoIndex=0; ammoIndex<4; ammoIndex++)  //CyberP: ammo pt 2
			{
				if (AmmoNames[ammoIndex] == ammo.Class)
				{
					bCanLoad = True;
					break;
				}
			}
		}
	}

	return bCanLoad;
}

// ----------------------------------------------------------------------
// LoadAmmoType()
//
// Load this ammo type given the actual object
// ----------------------------------------------------------------------

function LoadAmmoType(Ammo ammo)
{
	local int i;

	if (ammo != None)
		for (i=0; i<4; i++) //CyberP: ammo part 3
			if (AmmoNames[i] == ammo.Class)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// LoadAmmoClass()
//
// Load this ammo type given the class
// ----------------------------------------------------------------------

function LoadAmmoClass(Class<Ammo> ammoClass)
{
	local int i;

    //if (IsA('WeaponSawedOffShotgun') || IsA('WeaponMinicrossbow') || IsA('WeaponAssaultShotgun') || IsA('WeaponGEPGun')) //RSD: Added so shell-loading weaps don't instareload from the inventory ammo button
	//      ClipCount = ReloadCount;
    //RSD: Okay but actually let's do all of this in LoadAmmo() so we can first check if emptying our clip is a good idea

	if (ammoClass != None)
		for (i=0; i<4; i++)      //CyberP: ammo part 4
			if (AmmoNames[i] == ammoClass)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// CycleAmmo()
// ----------------------------------------------------------------------

function CycleAmmo()
{
	local int i, last;

	if (NumAmmoTypesAvailable() < 2)
		return;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == AmmoName)
			break;

	last = i;

	//if (IsA('WeaponSawedOffShotgun') || IsA('WeaponMinicrossbow'))// || IsA('WeaponAssaultShotgun')) //CyberP: cycling shottie ammo
	//      ClipCount = ReloadCount;                                              //RSD: Assault shotgun loads a clip at a time, Xbow a dart at a time
    //if (IsA('WeaponSawedOffShotgun') || IsA('WeaponMinicrossbow') || IsA('WeaponAssaultShotgun') || IsA('WeaponGEPGun')) //RSD: Reverted Assault shotty, added GEP
	//      ClipCount = ReloadCount;
    //RSD: Okay but actually let's do all of this in LoadAmmo() so we can first check if emptying our clip is a good idea

	do
	{
		if (++i >= 4)  //Cyberp: ammo part 5
			i = 0;

		if (LoadAmmo(i))
			break;
	} until (last == i);
}

simulated function bool CanCycleAmmo()                                          //RSD: Added to check if ammo loading is possible, used by WeaponChangeAmmo() in PersonaScreenInventory.uc when realtime UI is enabled
{                                                                               //RSD: Adapted from CycleAmmo() -- IF YOU CHANGE THE LOGIC IN THAT FUNCTION, CHANGE THIS LOGIC TOO. HAX HAX HAX
	local int i, last;

	if (NumAmmoTypesAvailable() < 2)
		return false;                                                           //RSD: Originally return

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == AmmoName)
			break;

	last = i;

	do
	{
		if (++i >= 4)  //Cyberp: ammo part 5
			i = 0;

		if (CanLoadAmmo(i))
			return true;                                                        //RSD: Originally break
	} until (last == i);
	return false;
}

simulated function bool CanLoadAmmo(int ammoNum)                                //RSD: Added to check if ammo loading is possible, used by WeaponChangeAmmo() in PersonaScreenInventory.uc when realtime UI is enabled
{                                                                               //RSD: Adapted from LoadAmmo() -- IF YOU CHANGE THE LOGIC IN THAT FUNCTION, CHANGE THIS LOGIC TOO. HAX HAX HAX
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	if ((ammoNum < 0) || (ammoNum > 3))      //CyberP: ammo part 6
		return False;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return False;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass != None)
	{
		if (newAmmoClass != AmmoName)
		{
			newAmmo = Ammo(P.FindInventoryType(newAmmoClass));
			if (newAmmo == None)
			{
				//P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.Default.ItemName)); //RSD: Annoying logspam if we've never picked up an ammo type
				return False;
			}
			else if (newAmmo.AmmoAmount <= 0)                                   //RSD: However, if we HAVE picked up the ammo type before, then definitely DO have a message!
			{
			    //P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.Default.ItemName)); //RSD: Don't want it printing to the log twice in case there's something later we can cycle to. msgAlreadyHas is good enough
				return False;
			}
			//P.ClientMessage(Sprintf(msgNowHas, ItemName, newAmmoClass.Default.ItemName)); //RSD: Don't print anything if we CAN reload -- that will be done by the real LoadAmmo() function. HAX HAX HAX
			return True;
		}
		else
		{
			P.ClientMessage(Sprintf(MsgAlreadyHas, ItemName, newAmmoClass.Default.ItemName)); //RSD: note msgAlreadyHas changed from "%s already has %s loaded" to "No other ammo to load" in DeusEx.int, the other arguments are for unchanged localization files
		}
	}

	return False;
}

simulated function bool CanReload()
{
	if (ClipCount < ReloadCount && ReloadCount != 0 && AmmoType != None && AmmoType.AmmoAmount > 0)
        return true;
	else
		return false;
}

simulated function bool MustReload()
{
	if (AmmoLeftInClip() == 0 && AmmoType != None && AmmoType.AmmoAmount > 0)
		return true;
	else
		return false;
}

simulated function int AmmoLeftInClip()
{
    return ClipCount;
}

simulated function int NumRounds()
{
	if (ReloadCount == 0)  // if this weapon is not reloadable
		return 0;
	else if (AmmoType == None)
		return 0;
	else  // compute remaining ammo
		return AmmoType.AmmoAmount - AmmoLeftInClip();
}

simulated function int NumClips()
{
    local int rnds;
	local int clips;
    rnds = NumRounds();
    if (rnds > 0)
	{
		clips = (rnds / reloadcount);
		
		if(clips*reloadcount < rnds)
			return clips+1;
		else
			return clips;
	}
    else
        return 0;
}

simulated function int AmmoAvailable(int ammoNum)
{
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return 0;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass == None)
		return 0;

	newAmmo = Ammo(P.FindInventoryType(newAmmoClass));

	if (newAmmo == None)
		return 0;

	return newAmmo.AmmoAmount;
}

simulated function SetMaxAmmo()
{
   maxiAmmo = AmmoType.MaxAmmo;  //CyberP:
}

simulated function int NumAmmoTypesAvailable()
{
	local int i;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == None)
			break;

	// to make Al fucking happy
	if (i == 0)
		i = 1;

	return i;
}

function name WeaponDamageType()
{
	local name                    damageType;
	local Class<DeusExProjectile> projClass;

	projClass = Class<DeusExProjectile>(ProjectileClass);
	if (bInstantHit)
	{
        if (AmmoType != None && AmmoType.IsA('AmmoRubber'))
			damageType = 'KnockedOut';
        else if (StunDuration > 0)
			damageType = 'Stunned';
		else
			damageType = 'Shot';

		if (AmmoType != None)
			if (AmmoType.IsA('AmmoSabot') || AmmoType.IsA('Ammo10mmAP'))
				damageType = 'Sabot';

	}
	else if (projClass != None)
		damageType = projClass.Default.damageType;
	else
		damageType = 'None';

	return (damageType);
}


//
// target tracking info
//
simulated function Actor AcquireTarget()
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor hit, retval;
	local Pawn p;

	p = Pawn(Owner);
	if (p == None)
		return None;

	StartTrace = p.Location;
	if (PlayerPawn(p) != None)
		EndTrace = p.Location + (10000 * Vector(p.ViewRotation));
	else
		EndTrace = p.Location + (10000 * Vector(p.Rotation));

	// adjust for eye height
	StartTrace.Z += p.BaseEyeHeight;
	EndTrace.Z += p.BaseEyeHeight;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
		if (!hit.bHidden && (hit.IsA('Decoration') || hit.IsA('Pawn')))
			return hit;

	return None;
}

//
// Used to determine if we are near (and facing) a wall for placing LAMs, etc.
//
simulated function bool NearWallCheck()
{
	local Vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor HitActor;

	// Scripted pawns can't place LAMs
	if (ScriptedPawn(Owner) != None)
		return False;

    if (IsA('WeaponHideAGun')) //CyberP
        return False;

	/*// Don't let players place grenades when they have something highlighted
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).frobTarget != None) )
		{
			if ( DeusExPlayer(Owner).IsFrobbable( DeusExPlayer(Owner).frobTarget ) )
				return False;
		}
	} */

	// trace out one foot in front of the pawn
	StartTrace = Owner.Location;
	EndTrace = StartTrace + Vector(Pawn(Owner).ViewRotation) * 32; //CyberP: was 32

	StartTrace.Z += Pawn(Owner).BaseEyeHeight;
	EndTrace.Z += Pawn(Owner).BaseEyeHeight;

	HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
	if ((HitActor == Level) || ((HitActor != None) && HitActor.IsA('Mover')))
	{
		placeLocation = HitLocation;
		placeNormal = HitNormal;
		placeMover = Mover(HitActor);
		return True;
	}

	return False;
}

//
// used to place a grenade on the wall
//
function PlaceGrenade()
{
	local ThrownProjectile gren;
	local float dmgX;

	gren = ThrownProjectile(spawn(ProjectileClass, Owner,, placeLocation, Rotator(placeNormal)));
	if (gren != None)
	{
		AmmoType.UseAmmo(1);
		if ( AmmoType.AmmoAmount <= 0 )
			bDestroyOnFinish = True;

		gren.PlayAnim('Open');
		gren.PlaySound(gren.MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		gren.SetPhysics(PHYS_None);
		gren.bBounce = False;
		gren.bProximityTriggered = True;
		gren.bStuck = True;
		if (placeMover != None)
			gren.SetBase(placeMover);

		// up the damage based on the skill
		// returned value from GetWeaponSkill is negative, so negate it to make it positive
		// dmgX value ranges from 1.0 to 2.4 (max demo skill and max target aug)
		dmgX = -2.0 * GetWeaponSkill() + 1.0;
		gren.Damage *= dmgX;

		// Update ammo count on object belt
		if (DeusExPlayer(Owner) != None)
			DeusExPlayer(Owner).UpdateBeltText(Self);
	}
}

//
// scope, laser, and targetting updates are done here
//
simulated function Tick(float deltaTime)
{
	local vector loc,vel;
	local rotator rot;
	local float beepspeed, recoil,size;
	local DeusExPlayer player;
	local Actor RealTarget;
	local Pawn pawn;
    local float perkMod, ADSmod, rnd;
    local float mult;

	player = DeusExPlayer(Owner);
	pawn = Pawn(Owner);

	Super.Tick(deltaTime);

	// don't do any of this if this weapon isn't currently in use
	if (pawn == None)
	{
	  LockMode = LOCK_None;
	  MaintainLockTimer = 0;
	  LockTarget = None;
	  LockTimer = 0;
		return;
	}

	if (pawn.Weapon != self)
	{
	  LockMode = LOCK_None;
	  MaintainLockTimer = 0;
	  LockTarget = None;
	  LockTimer = 0;
		return;
	}

    if (bAmmoSelectWait)                                                        //RSD: After one tick, engage ammo load queued by LoadAmmo() or WeaponChangeAmmo() in PersonaScreenInventory.uc
    {
    	if (ammoSelectClass == none)                                            //RSD: If no ammo type specified (as in WeaponChangeAmmo), simply cycle
    		CycleAmmo();
    	else                                                                    //RSD: Otherwise load the specified ammo type
        	LoadAmmoClass(ammoSelectClass);

    	//RSD: Then do this stuff from the original PersonaScreenInventory.uc inventory loading AFTER we've started
    	UpdateInventoryInfo();
    	bAmmoSelectWait = false;                                                //RSD: Note we do this last to hack sound effects
   	}


    if (quickMeleeCombo > 0)
        quickMeleeCombo -= deltaTime;
	//GMDX: ADD PROJECTILE TEST INFLIGHT
	if ((player!=none)&&player.bGEPprojectileInflight)//(player.aGEPProjectile!=none)) //RSD: Changed so it still updates laser position
		return;
    //CyberP: moves held item back if facing & standing next to a wall
   if (player != none && IsInState('Idle'))
   {
      if (NearWallCheck() && player.Physics != PHYS_Falling)
      {
         bInvisibleWhore=True;
      }
      else if (!NearWallCheck() && player.Physics != PHYS_Falling)
      {
         bInvisibleWhore=False;
      }
   }
	// all this should only happen IF you have ammo loaded
	if (ClipCount > 0)
	{
		// check for LAM or other placed mine placement
		if (bHandToHand && ProjectileClass != None && !Self.IsA('WeaponShuriken') && !Self.IsA('WeaponLAW') && !Self.IsA('WeaponHideAGun'))
		{
			if (NearWallCheck())
			{
				if (( Level.NetMode != NM_Standalone ) && IsAnimating() && (AnimSequence == 'Select'))
				{
				}
				else
				{
					if ((!bNearWall || (AnimSequence == 'Select')) && AnimSequence != 'Select')
					{
					    if (AnimSequence == 'Attack' || AnimSequence == 'Attack2' || AnimSequence == 'Attack3')
					    {
					    }
					    else
					    {
						    PlayAnim('PlaceBegin',, 0.1);
						    bNearWall = True;
						}
					}
				}
			}
			else
			{
				if (bNearWall)
				{
					PlayAnim('PlaceEnd',, 0.1);
					bNearWall = False;
				}
			}
		}

      burstTimer -= deltaTime;
	  SoundTimer += deltaTime;

	  if ( (Level.Netmode == NM_Standalone) || ( (Player != None) && (Player.PlayerIsClient()) ) )
	  {
         if (bCanTrack)
		 {
		    if (bZoomed || bLasing || (player != none && player.IsInState('Conversation'))) //RSD Added player != none for accessed none
		    {
		    }
            else
            {
			Target = AcquireTarget();
			RealTarget = Target;

			// calculate the range
			if (Target != None)
			   TargetRange = Abs(VSize(Target.Location - Location));

			// update our timers
			//SoundTimer += deltaTime;
			MaintainLockTimer -= deltaTime;

			// check target and range info to see what our mode is
			if ((Target == None) || IsInState('Reload'))
			{
			   if (MaintainLockTimer <= 0)
			   {
				  SetLockMode(LOCK_None);
				  MaintainLockTimer = 0;
				  LockTarget = None;
			   }
			   else if (LockMode == LOCK_Locked)
			   {
				  Target = LockTarget;
			   }
			}
			else if ((Target != LockTarget) && (Target.IsA('Pawn')) && (LockMode == LOCK_Locked))
			{
			   SetLockMode(LOCK_None);
			   LockTarget = None;
			}
			else if (!Target.IsA('Pawn'))
			{
			   if (MaintainLockTimer <=0 )
			   {
				  SetLockMode(LOCK_Invalid);
			   }
			}
			else if (Target.Style == STY_Translucent)
			{
			   //DEUS_EX AMSD Don't allow locks on cloaked targets.
			   SetLockMode(LOCK_Invalid);
			}
			else if ( (Target.IsA('DeusExPlayer')) && (Player.DXGame.IsA('TeamDMGame')) && (TeamDMGame(Player.DXGame).ArePlayersAllied(Player,DeusExPlayer(Target))) )
			{
			   //DEUS_EX AMSD Don't allow locks on allies.
			   SetLockMode(LOCK_Invalid);
			}
			else
			{
   			if (TargetRange > MaxRange)
			   {
				  SetLockMode(LOCK_Range);
			   }
			   else
			   {
				  // change LockTime based on skill
				  // -0.7 = max skill
				  // DEUS_EX AMSD Only do weaponskill check here when first checking.
				  if (LockTimer == 0)
				  {
				     if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bHardCoreMode)
				         LockTime = FMax(Default.LockTime + 5.0 * GetWeaponSkill(), 0.0);
                     else
					     LockTime = FMax(Default.LockTime + 3.0 * GetWeaponSkill(), 0.0);
					 if ((Level.Netmode != NM_Standalone) && (LockTime < 0.25))
						LockTime = 0.25;
				  }

				  LockTimer += deltaTime;
				  if (LockTimer >= LockTime)
				  {
					 SetLockMode(LOCK_Locked);
				  }
				  else
				  {
					 SetLockMode(LOCK_Acquire);
				  }
			   }
			}

			// act on the lock mode
			switch (LockMode)
			{
			case LOCK_None:
			   TargetMessage = msgNone;
			   LockTimer -= deltaTime;
			   break;

			case LOCK_Invalid:
			   TargetMessage = msgLockInvalid;
			   LockTimer -= deltaTime;
			   break;

			case LOCK_Range:
			   TargetMessage = msgLockRange @ Int(TargetRange/16) @ msgRangeUnit;
			   LockTimer -= deltaTime;
			   break;

			case LOCK_Acquire:
			   TargetMessage = msgLockAcquire @ Left(String(LockTime-LockTimer), 4) @ msgTimeUnit;
			   beepspeed = FClamp((LockTime - LockTimer) / Default.LockTime, 0.2, 1.0);
			   if (SoundTimer > beepspeed)
			   {
				  Owner.PlaySound(TrackingSound, SLOT_None, 0.5);
				  SoundTimer = 0;
			   }
			   break;

			case LOCK_Locked:
			   // If maintaining a lock, or getting a new one, increment maintainlocktimer
			   if ((RealTarget != None) && ((RealTarget == LockTarget) || (LockTarget == None)))
			   {
				  if (Level.NetMode != NM_Standalone)
					 MaintainLockTimer = default.MaintainLockTimer;
				  else
					 MaintainLockTimer = 0;
				  LockTarget = Target;
			   }
			   TargetMessage = msgLockLocked @ Int(TargetRange/16) @ msgRangeUnit;
			   // DEUS_EX AMSD Moved out so server can play it so that client knows for sure when locked.
			   /*if (SoundTimer > 0.1)
			   {
				  Owner.PlaySound(LockedSound, SLOT_None);
				  SoundTimer = 0;
			   }*/
			   break;
			}
		   }
		 }
		 else
		 {
			LockMode = LOCK_None;
			TargetMessage = msgNone;
			LockTimer = 0;
			MaintainLockTimer = 0;
			LockTarget = None;
		 }

		 if (LockTimer < 0)
			LockTimer = 0;
	  }
	}
	else
	{
	  LockMode = LOCK_None;
	  TargetMessage=msgNone;
	  MaintainLockTimer = 0;
	  LockTarget = None;
	  LockTimer = 0;
	}

	if ((LockMode == LOCK_Locked) && (SoundTimer > 0.1) && (Role == ROLE_Authority))
	{
	  PlayLockSound();
	  SoundTimer = 0;
	}

    previousAccuracy = currentAccuracy;
	currentAccuracy = CalculateAccuracy();

	if (player != None)
	{
		// reduce the recoil based on skill
		/*if (player.PerkNamesArray[22] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponPistol') //RSD: Removed Perfect Stance: Pistols
		   recoil = recoilStrength * 0.5; // + GetWeaponSkill() * 2.0; //CyberP: Removed Recoil based on skill level.
		else*/ if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkMarksman').bPerkObtained == true && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
           recoil = recoilStrength * 0.5;
		/*else if (player.PerkNamesArray[13] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponHeavy') //RSD: Removed Perfect Stance: Heavy
		   recoil = recoilStrength * 0.5;*/
		else
		   recoil = recoilStrength;

        recoil += GetAddonPenalty(Laser); //SARGE: Penalties for addons
        recoil += GetAddonPenalty(Scope); //SARGE: Penalties for addons

		if (recoil < 0.0)
			recoil = 0.0;

		if (bJustUncloaked && !bIsCloaked)
		{
		   ScaleGlow+=DeltaTime;
		   if (ScaleGlow >= default.ScaleGlow)
		   {
		       if (bIsRadar)                                                    //RSD: Need this so we still get gradual uncloaking but don't mess up ScaleGlow when Radar+Cloak-Cloak
		           ScaleGlow = 10.500001;
		       else
                   ScaleGlow = default.ScaleGlow;
		       bJustUncloaked = False;
		       Style = default.Style;
		       AmbientGlow=default.AmbientGlow;
		   }
		}

        if (bFiring)
        {
		// simulate recoil while firing  //CyberP: vastly overhauled recoil system
		if (recoil > 0.0 && player.RecoilTime > 0.0)
		{
		    if (IsA('WeaponAssaultGun'))
		    {
		     rnd = FRand();
              player.ViewRotation.Pitch += deltaTime * (Rand(2048) + 5000) * (recoil);
              player.ViewRotation.Yaw += deltaTime * (Rand(2048) + 4400) * (recoil);
              sustainedRecoil += deltaTime * 26 * recoil * 0.05;
             if (rnd < 0.5)
             {
              player.ViewRotation.Yaw -= deltaTime * (Rand(3096) + 2048) * (recoil);
                if (FRand() < 0.1)
			     player.ViewRotation.Pitch += deltaTime * (Rand(3096) + 2048) * (recoil*0.5);
             }
			 else
			 {
			  player.ViewRotation.Pitch -= deltaTime * (Rand(2048) + 2048) * (recoil*0.75);
			  player.ViewRotation.Yaw -= deltaTime * (Rand(2048) + 3096) * (recoil);
			  }
		    }
		    else
		    {
		    if (IsA('WeaponStealthPistol') || IsA('WeaponPistol') || IsA('WeaponAssaultShotgun'))
		    {
		      player.ViewRotation.Yaw += deltaTime * (Rand(2048) + 4096) * (recoil);
		      player.ViewRotation.Pitch += deltaTime * (Rand(2048) + 4096) * (recoil*1.5);
		    }
		    else
		    {
		    if (FRand() >=0.5)
			 player.ViewRotation.Yaw += deltaTime * (Rand(4096) + 2048) * (recoil*0.5);
			else
			 player.ViewRotation.Yaw -= deltaTime * (Rand(4096) + 2048) * (recoil*0.5);
			player.ViewRotation.Pitch += deltaTime * (Rand(4096) + 4096) * (recoil*1.5);
			}
			}
			if ((player.ViewRotation.Pitch > 16384) && (player.ViewRotation.Pitch < 32768))
				player.ViewRotation.Pitch = 16384;
		}
		else if (player.RecoilTime == 0.0 && recoil > 0.05 && negTime > 0)
		{
        player.ViewRotation.Pitch -= deltaTime * (Rand(256) + 1024) * (recoil*0.75);
		if (IsA('WeaponStealthPistol') || IsA('WeaponPistol') || IsA('WeaponAssaultShotgun'))
		    player.ViewRotation.Yaw -= deltaTime * (Rand(256) + 1024) * (recoil*0.5);
		negTime -= deltaTime;
		}
		}
		else if (sustainedRecoil > 0)
		{
             if (AnimSequence != 'shoot' || ClipCount == 0)
             {
             player.ViewRotation.Pitch -= deltaTime * (Rand(512) + 1534) + (sustainedRecoil*40) * recoil;
             player.ViewRotation.Yaw -= deltaTime * (Rand(256) + 640) + (sustainedRecoil*40) * recoil;
             sustainedRecoil -= deltaTime;
             if (sustainedRecoil < 0)
                sustainedRecoil = 0;
             }
        }
	}

	// if were standing still, increase the timer
	if (VSize(Owner.Velocity) < 15 && player != None)
	{
        mult = 1.0;                                                             //RSD: making this code a bit more general with a catch-all mult
        /*if (player.PerkNamesArray[1]==1 && GoverningSkill==Class'DeusEx.SkillWeaponPistol')
	       standingTimer += deltaTime*1.2;
	    else if (player.PerkNamesArray[2]==1 && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
           standingTimer += deltaTime*1.2;
	    else if (player.PerkNamesArray[3]==1 && GoverningSkill==Class'DeusEx.SkillWeaponHeavy')
	       standingTimer += deltaTime*1.2;
        else
		    standingTimer += deltaTime;
		if (player.CombatDifficulty < 1.0)  //CyberP: easy difficulty gets aiming boost
		    standingTimer += deltaTime*2;*/
        
		if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkSteady').bPerkObtained == true && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
            mult += player.PerkManager.GetPerkWithClass(class'DeusEx.PerkSteady').PerkValue;		//RSD: Now +25% bonus
        
		if (player.AddictionManager.addictions[0].drugTimer > 0)                                      //RSD: Cigarettes make you aim faster
	        mult += 1.0;
        if (player.CombatDifficulty < 1.0)                                      //RSD: Properly doubling on easy now
		    mult *= 2.0;
        if (previousAccuracy != currentAccuracy || standingTimer ~= 0.0)                                       //Sarge: Only increase standing timer if our accuracy has changed
            standingTimer += mult*deltaTime;
		if (standingTimer > 15.0) //CyberP: the devs forgot to cap the timer
		    standingTimer = 15.0;
        if ((player.bHardcoreMode || player.bReloadingResetsAim) && IsInState('Reload'))                        //RSD: reset accuracy when reloading in Hardcore //SARGE: Added new gameplay setting
            standingTimer = 0.0;
    }
	else	// otherwise, decrease it slowly based on velocity
		standingTimer = FMax(0, standingTimer - 0.03*deltaTime*VSize(Owner.Velocity)*0.5); //CyberP: slower

	if (bLasing || bZoomed || bAimingDown)
	{
		// shake our view to simulate poor aiming
		if (ShakeTimer > 0.25)
		{
		    /*if (player.PerkNamesArray[22] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponPistol') //RSD: Removed Perfect Stance: Pistols
		        perkMod = 0;
		    else*/ if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkMarksman').bPerkObtained == true && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
	            perkMod = 0;
			else if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkControlledBurn').bPerkObtained == true && GoverningSkill==Class'DeusEx.SkillWeaponHeavy')
                perkMod = 0;
			else
                perkMod = 0.04;
            if (bAimingDown)
            {
            ADSMod = 0.5 * currentAccuracy;
            if (currentAccuracy <= 0.1)
                ADSMod = 0.0;
            if (AreaOfEffect == AOE_Cone && currentAccuracy <= 0.1) //CyberP A.K.A Totalitarian: give shotguns some steadyness since they can never have 100% acc.
                ADSMod -= 0.05;
			}
            ShakeYaw = (currentAccuracy+perkMod+ADSMod) * (Rand(4096) - 2048);
			ShakePitch = (currentAccuracy+perkMod+ADSMod) * (Rand(4096) - 2048);

            ShakeTimer -= 0.25;
		}

		ShakeTimer += deltaTime;

		if (bLasing && (Emitter != None))
		{
			loc = Owner.Location;
			loc.Z += Pawn(Owner).BaseEyeHeight;

			// add a little random jitter - looks cool!
            if (player != none)
				rot = player.GetCurrentViewRotation(); //RSD: If radial menu active, don't copy the viewrotation as it's being screwed with
			else
            	rot = Pawn(Owner).ViewRotation;
			rot.Yaw += Rand(5) - 2;
			rot.Pitch += Rand(5) - 2;

            LaserYaw += ShakeYaw*deltaTime - 4.*LaserYaw*deltaTime;             //RSD: Laser waver from Shifter but with continual 1st-order drift towards center
            if(LaserYaw > currentAccuracy * 2048)
            {
                LaserYaw = currentAccuracy * 2048;
                ShakeYaw *= -1;
            }
            if(LaserYaw < currentAccuracy * 2048 * -1)
            {
                LaserYaw = currentAccuracy * 2048 * -1;
                ShakeYaw *= -1;
            }

            LaserPitch += ShakePitch*deltaTime - 4.*LaserPitch*deltaTime;
            if(LaserPitch > currentAccuracy * 2048)
            {
                LaserPitch = currentAccuracy * 2048;
                ShakePitch *= -1;
            }
            if(LaserPitch < currentAccuracy * 2048 * -1)
            {
                LaserPitch = currentAccuracy * 2048 * -1;
                ShakePitch *= -1;
            }

            if (!bZoomed)
            {
            	rot.Yaw += LaserYaw;
                rot.Pitch += LaserPitch;
            }
			Emitter.SetLocation(loc);
			Emitter.SetRotation(rot);
		}

		if ((player != None) && (bZoomed || bAimingDown))
		{
			player.ViewRotation.Yaw += deltaTime * ShakeYaw;
			player.ViewRotation.Pitch += deltaTime * ShakePitch;
		}
	}
}

function UpdateInventoryInfo()                                                  //RSD: Added so real-time inventory systems can push updates BACK to the UI
{
	local PersonaScreenInventory winInv;
    local DeusExRootWindow root;

    if (Owner != none && Owner.IsA('DeusExPlayer'))
        root = DeusExRootWindow(DeusExPlayer(Owner).rootWindow);

    if (root == none)
        return;

    winInv = PersonaScreenInventory(root.GetTopWindow());                       //RSD: Might be none

    if (winInv != none && winInv.winInfo != none)
        winInv.WeaponUpdateInfo(self);
}

function ScopeOn()
{
	if (IsInState('Reload')) return;
	if (bHasScope && !bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		// Show the Scope View
		bZoomed = True;
		RefreshScopeDisplay(DeusExPlayer(Owner), False, bZoomed);
        if (IsA('WeaponRifle') || IsA('WeaponPlasmaRifle')) //CyberP: if sniper or plasma, play zoom sfx
                Owner.PlaySound(Sound'SniperZoom', SLOT_Misc, 0.85, ,768,1.0);
	}
}

function ScopeOff()
{
	if (bHasScope && bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		bZoomed = False;
		// Hide the Scope View
	  RefreshScopeDisplay(DeusExPlayer(Owner), False, bZoomed);
		//DeusExRootWindow(DeusExPlayer(Owner).rootWindow).scopeView.DeactivateView();
	}
}

simulated function ScopeToggle()
{
	//if (IsInState('Idle'))
	if (AnimSequence == 'Shoot'||IsInState('Idle'))//(!(bFiring && IsAnimating() && AnimSequence == 'Shoot')||IsInState('Idle'))
	{
		if (bHasScope && (Owner != None) && Owner.IsA('DeusExPlayer'))
		{
			if (bZoomed)
				ScopeOff();
			else
				ScopeOn();
            DeusExPlayer(Owner).UpdateCrosshair();
		}
	}
}

// ----------------------------------------------------------------------
// RefreshScopeDisplay()
// ----------------------------------------------------------------------

simulated function RefreshScopeDisplay(DeusExPlayer player, bool bInstant, bool bScopeOn)
{
	local bool bIsGEP;
    local DeusExRootWindow root;
    local DeusExScopeView scope;

    if (player == None) return;

	root = DeusExRootWindow(player.rootWindow);
    if (root == None) return;
    
    scope = root.scopeView;
    if (scope == None) return;

	bIsGEP=bHasScope&&(IsA('WeaponGEPGun'))&&(player.RocketTarget!=none);

	if (bScopeOn)
		// Show the Scope View
		scope.ActivateViewType(ScopeFOV, False, bInstant,bIsGEP);
	else
	    scope.DeactivateView();

    player.UpdateCrosshair();
}

// ----------------------------------------------------------------------
// SwitchModes()
// ----------------------------------------------------------------------

function SwitchModes()
{
	local Pawn p;

	p = Pawn(Owner);

	if (AmmoName == Class'Ammo20mm')
    {
        ARClipSize = ReloadCount;
        ARloaded = ClipCount;	// Save the original rifle's stats

        ReloadCount = 1; // Return the GL's stats
		ClipCount = ARGLLoaded;
		LowAmmoWaterMark = 1;

		p.ClientMessage(msgRifleModeActivated);
        PlaySound(Sound'GMDXSFX.Weapons.M4ClipOut');
    }
    else
    {
		ARGLLoaded = ClipCount; // Save the GL's stats

        ReloadCount = ARClipSize; // Return the original rifle's stats
        ClipCount = ARLoaded;
		LowAmmoWaterMark = 16;

		p.ClientMessage(msgGLModeActivated);
        PlaySound(Sound'GMDXSFX.Weapons.M4ClipOut');
    }
}

//
// laser functions for weapons which have them
//

function LaserOn(optional bool IgnoreSound)
{
	if (bHasLaser && !bLasing)
	{
		// if we don't have an emitter, then spawn one
		// otherwise, just turn it on
		if (Emitter == None)
		{
			Emitter = Spawn(class'LaserEmitter', Self, , Location, Pawn(Owner).ViewRotation);
			if (Emitter != None)
			{
			    if (default.ItemName == "UMP7.62c" || default.ItemName == "USP.10")
			    Emitter.bBlueBeam = True;
			    else
                Emitter.bBlueBeam = False;

				Emitter.SetHiddenBeam(True);
				Emitter.AmbientSound = None;
				Emitter.TurnOn();
			}
		}
		else
			Emitter.TurnOn();

        if (!IgnoreSound)
            Owner.PlaySound(sound'KeyboardClick3', SLOT_None,,, 1024,1.5); //CyberP: suitable laser on sfx //SARGE: Now has sound check
		bLasing = True;
        bLaserToggle = true;
	  }
	  LaserYaw = (currentAccuracy) * (Rand(4096) - 2048);                       //RSD: Reset laser position when turning on
	  LaserPitch = (currentAccuracy) * (Rand(4096) - 2048);
}

function LaserOff(bool forced)
{
	if (IsA('WeaponNanoSword')&&!IsInState('DownWeapon')) return;
	if (bHasLaser && bLasing)
	{
        if (Emitter != None)
            Emitter.TurnOff();
        if (!forced)
            Owner.PlaySound(sound'KeyboardClick2', SLOT_Misc,,, 1024,1.5); //CyberP: suitable laser off sfx
        bLasing = False;
        if (!forced)
            bLaserToggle = false;
	  if ((IsA('WeaponGEPGun'))&&(Owner.IsA('DeusExPlayer')))
	  {
	     if (DeusExPlayer(Owner).aGEPProjectile!=none)
	     {
	        Rocket(DeusExPlayer(Owner).aGEPProjectile).bGEPInFlight=false;
	        DeusExPlayer(Owner).aGEPProjectile.Target=none;
	        DeusExPlayer(Owner).aGEPProjectile.bTracking=false;
	        DeusExPlayer(Owner).aGEPProjectile=none;
	        if (DeusExPlayer(Owner).bAutoReload && AmmoLeftInClip()==0)
					ReloadAmmo();
	     }
	  }
	}
}

function LaserToggle()
{
	if (IsInState('Idle'))
	{
		if (bHasLaser)
		{
			if (bLasing)
            {
				LaserOff(false);
            }
			else
            {
				LaserOn();
            }
		}

	}
}

simulated function SawedOffCockSound()
{
local float shakeTime, shakeRoll, shakeVert;

	if ((AmmoType.AmmoAmount >= 0) && (WeaponSawedOffShotgun(Self) != None))  //CyberP: bugfix: was > 0, now >=
	{
    	Owner.PlaySound(SelectSound, SLOT_None,,, 1024);
    	if (Owner.IsA('DeusExPlayer')) //CyberP: add a camera effect
    	  {
    	   shakeTime = 0.1;
    	   shakeRoll = 48+48;
    	   shakeVert = 2+2;
           DeusExPlayer(Owner).ShakeView(shakeTime, shakeRoll, shakeVert);
    	  }
    }
}

//
// called from the MESH NOTIFY
//
simulated function SwapMuzzleFlashTexture()
{
	if(!bHasMuzzleflash || bHasSilencer)
		return;
	
    //Multiskins[MuzzleSlot] = GetMuzzleTex();
    if (GetMuzzleTex() != None && MuzzleSlot < 8 && MuzzleSlot > -1)
        MultiSkins[MuzzleSlot] = GetMuzzleTex();

    //DeusExPlayer(GetPlayerPawn()).clientMessage("Swapping Muzzle Tex into slot " $ MuzzleSlot);

	MuzzleFlashLight();
	SetTimer(0.1, False);
}

//ADDED
simulated function texture GetMuzzleTex()
{
	local int i;
	local texture tex;

    if (!IsHDTPMuzzle())                                                  //RSD: If using the vanilla model, use vanilla muzzle flash
    {
        if (FRand() < 0.5)
            tex = Texture'FlatFXTex34';
        else
            tex = Texture'FlatFXTex37';
    }
	else if(bAutomatic || bBigMuzzleFlash)
	{
		i = rand(8);
		switch(i)
		{
			case 0: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge1"); break;
			case 1: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge2"); break;
			case 2: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge3"); break;
			case 3: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge4"); break;
			case 4: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge5"); break;
			case 5: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge6"); break;
			case 6: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge7"); break;
			case 7: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashlarge8"); break;
		}
	}
	else
	{
		i = rand(3);
		switch(i)
		{
			case 0: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall1"); break;
			case 1: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall2"); break;
			case 2: tex = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall3"); break;
		}
	}

	return tex;
}

//SARGE: Lets clean up some of this shit...
//This one sets either "none" or "pinkmasktex" for a weapon part
function ShowWeaponAddon(int slot, bool condition)
{
    if (!condition)
        multiskins[slot] = texture'pinkmasktex';
    else
        multiskins[slot] = none;
}
function DisplayWeapon(bool overlay)
{
    local int i;
    for (i = 0;i < 8;i++)
    {
        if (bHasMuzzleFlash && i == muzzleslot && !bHasSilencer)
        {
            //DeusExPlayer(GetPlayerPawn()).ClientMessage("Display Weapon: Not clearing slot " $ i);
            continue;
        }

        if (IsHDTP())
            multiskins[i] = none;
        else
            multiskins[i] = default.multiskins[i];
    }
}

simulated function EraseMuzzleFlashTexture()
{
	if(!bHasMuzzleflash || bHasSilencer)
		return;
		
    if (MuzzleSlot > -1 && muzzleSlot < 8)
        MultiSkins[MuzzleSlot] = None;
}

simulated function Timer()
{
	EraseMuzzleFlashTexture();
}

simulated function MuzzleFlashLight()
{
	local Vector offset, X, Y, Z;
    local PlasmaParticleSpoof spoof;
    local FireSmoke smoke;
    local int i;

 	if (!bHasMuzzleFlash)
		return;

	if ((flash != None) && !flash.bDeleteMe)
		flash.LifeSpan = flash.Default.LifeSpan;
	else
	{
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		offset = Owner.Location;
		offset += X * Owner.CollisionRadius * 2;
		flash = spawn(class'MuzzleFlash',,, offset);
		if (flash != None)
			flash.SetBase(Owner);

        if ((IsA('WeaponSawedOffShotgun') || IsA('WeaponAssaultShotgun')) && Owner.IsA('DeusExPlayer'))
    {    //CyberP: hacky, sub-optimal new muzzleflash effects.
    offset.Z += Owner.CollisionHeight * 0.7;
    if (IsA('WeaponAssaultShotgun'))
    offset += Y * Owner.CollisionRadius * 0.75;
    else
    offset += Y * Owner.CollisionRadius * 0.25;
    if (DeusExPlayer(Owner).IsCrouching())
        offset.Z *= (Owner.CollisionHeight * 0.8);
    /*smoke = spawn(class'FireSmoke',,, offset, Pawn(Owner).ViewRotation);
    if (smoke!=none)
    {
    smoke.LifeSpan=0.24;
    smoke.DrawScale=0.400000;
    smoke.ScaleGlow=0.400000;
    smoke.bRelinquished2=True;
    }*/
	if (IsHDTP())
	{
		for(i=0;i<13;i++)
		{
			spoof = spawn(class'PlasmaParticleSpoof',,, offset, Pawn(Owner).ViewRotation);
			if (spoof!=none)
			{
				spoof.DrawScale=0.006;
				spoof.LifeSpan=0.2;
				spoof.Texture= class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall2");
				spoof.Velocity=360*vector(Rotation);//vect(0,0,0);
				//spoof.Velocity.X = FRand() * 700;
				//spoof.Velocity.Z = FRand() * 60;

				if (FRand() < 0.3)
				{
				spoof.Velocity.Z += FRand() * 80;
				spoof.Velocity.X += FRand() * 65;
				spoof.Velocity.Y += FRand() * 65;
				}
				else if (FRand() < 0.6)
				{
				spoof.Velocity.Z -= FRand() * 20;
				spoof.Velocity.X -= FRand() * 55;
				spoof.Velocity.Y -= FRand() * 65;
				}
			}
		}
    }
	}
	}
}

function ServerHandleNotify( bool bInstantHit, class<projectile> ProjClass, float ProjSpeed, bool bWarn )
{
    local Projectile firedProjectile;

	if (bInstantHit)
		TraceFire(0.0);
	else
    {
        firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
        OnProjectileFired(firedProjectile);
    }
}

//
// HandToHandAttack
// called by the MESH NOTIFY for the H2H weapons
//
simulated function HandToHandAttack()
{
	local bool bOwnerIsPlayerPawn;
    local Projectile firedProjectile;

	if (bOwnerWillNotify)
		return;

	// The controlling animator should be the one to do the tracefire and projfire
	if ( Level.NetMode != NM_Standalone )
	{
		bOwnerIsPlayerPawn = (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()));

		if (( Role < ROLE_Authority ) && bOwnerIsPlayerPawn )
			ServerHandleNotify( bInstantHit, ProjectileClass, ProjectileSpeed, bWarnTarget );
		else if ( !bOwnerIsPlayerPawn )
			return;
	}

	if (ScriptedPawn(Owner) != None)
		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		TraceFire(0.0);
	else
    {
        firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
        OnProjectileFired(firedProjectile);
    }

	// if we are a thrown weapon and we run out of ammo, destroy the weapon
	if ( bHandToHand && (ReloadCount > 0) && (SimAmmoAmount <= 0))
	{
		DestroyOnFinish();
		if ( Role < ROLE_Authority )
		{
			ServerGotoFinishFire();
			GotoState('SimQuickFinish');
		}
	}
}

//
// OwnerHandToHandAttack
// called by the MESH NOTIFY for this weapon's owner
//
simulated function OwnerHandToHandAttack()
{
	local bool bOwnerIsPlayerPawn;
    local Projectile firedProjectile;

	if (!bOwnerWillNotify)
		return;

	// The controlling animator should be the one to do the tracefire and projfire
	if ( Level.NetMode != NM_Standalone )
	{
		bOwnerIsPlayerPawn = (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()));

		if (( Role < ROLE_Authority ) && bOwnerIsPlayerPawn )
			ServerHandleNotify( bInstantHit, ProjectileClass, ProjectileSpeed, bWarnTarget );
		else if ( !bOwnerIsPlayerPawn )
			return;
	}

	if (ScriptedPawn(Owner) != None)
		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		TraceFire(0.0);
	else
    {
        firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
        OnProjectileFired(firedProjectile);
    }
}

function ForceFire()
{
	Fire(0);
}

function ForceAltFire()
{
	AltFire(0);
}

//
// ReadyClientToFire is called by the server telling the client it's ok to fire now
//

simulated function ReadyClientToFire( bool bReady )
{
	bClientReadyToFire = bReady;
}

//
// ClientReFire is called when the client is holding down the fire button, loop firing
//

simulated function ClientReFire( float value )
{
	bClientReadyToFire = True;
	bLooping = True;
	bInProcess = False;
	ClientFire(0);
}

function StartFlame()
{
	flameShotCount = 0;
	bFlameOn = True;
	GotoState('FlameThrowerOn');
}

function StopFlame()
{
	bFlameOn = False;
}

//
// ServerForceFire is called from the client when loop firing
//
function ServerForceFire()
{
	bClientReady = True;
	Fire(0);
}

//SARGE: Handle special cases after we fire a projectile
function OnProjectileFired(Projectile firedProjectile)
{
    //do nothing
}

simulated function int PlaySimSound( Sound snd, ESoundSlot Slot, float Volume, float Radius )
{
	if ( Owner != None )
	{
		if ( Level.NetMode == NM_Standalone )
			return ( Owner.PlaySound( snd, Slot, Volume, , Radius ) );
		else
		{
			Owner.PlayOwnedSound( snd, Slot, Volume, , Radius );
			return 1;
		}
	}
	return 0;
}

//
// ClientFire - Attempts to play the firing anim, sounds, and trace fire hits for instant weapons immediately
//				on the client.  The server may have a different interpretation of what actually happen, but this at least
//				cuts down on preceived lag.
//
simulated function bool ClientFire( float value )
{
	local bool bWaitOnAnim;
	local vector shake;
    local Projectile firedProjectile;

	// check for surrounding environment
	if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
	{
		if (Region.Zone.bWaterZone)
		{
			if (Pawn(Owner) != None)
			{
				Pawn(Owner).ClientMessage(msgNotWorking);
				if (!bHandToHand)
					PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );
			}
			return false;
		}
	}

    if (Pawn(Owner) != None && Pawn(Owner).IsInState('Dying'))
    {bClientReadyToFire = False; bClientReady = False;} //CyberP: cannot shoot when dying

	if ( !bLooping ) // Wait on animations when not looping
	{
		bWaitOnAnim = ( IsAnimating() && ((AnimSequence == 'Select') || (AnimSequence == FireAnim[0]) || (AnimSequence == FireAnim[1]) || (AnimSequence == 'ReloadBegin') || (AnimSequence == 'Reload') || (AnimSequence == 'ReloadEnd') || (AnimSequence == 'Down')));
	}
	else
	{
		bWaitOnAnim = False;
		bLooping = False;
	}

	if ( (Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01)) ||
		  (!bClientReadyToFire) || bInProcess || bWaitOnAnim )
	{
		DeusExPlayer(Owner).bJustFired = False;
		bPointing = False;
		bFiring = False;
		return false;
	}

	if ( !Self.IsA('WeaponFlamethrower') )
		ServerForceFire();

	if (bHandToHand)
	{
		SimAmmoAmount = AmmoType.AmmoAmount - 1;

		bClientReadyToFire = False;
		bInProcess = True;
		GotoState('ClientFiring');
		bPointing = True;
		if ( PlayerPawn(Owner) != None )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
	}
	else if ((ClipCount > 0) || (ReloadCount == 0))
	{
		if ((ReloadCount == 0) || (AmmoType.AmmoAmount > 0))
		{
			SimClipCount = ClipCount - 1;

			if ( AmmoType != None )
				AmmoType.SimUseAmmo();

			bFiring = True;
			bPointing = True;
			bClientReadyToFire = False;
			bInProcess = True;
			GotoState('ClientFiring');
			if ( PlayerPawn(Owner) != None )
			{
				shake.X = 0.0;
				shake.Y = 100.0 * (ShakeTime*0.5);  //CyberP: was 100
				shake.Z = 100.0 * -(currentAccuracy * ShakeVert);
				PlayerPawn(Owner).ClientShake( shake );
				PlayerPawn(Owner).PlayFiring();
			}
			// Don't play firing anim for 20mm
			//if ( Ammo20mm(AmmoType) == None && Ammo20mmEMP(AmmoType) == None)
				//PlaySelectiveFiring();
			PlayFiringSound();

			if ( bInstantHit &&  (( Ammo20mm(AmmoType) == None ) && ( Ammo20mmEMP(AmmoType) == None )))
				TraceFire(currentAccuracy);
			else
			{
				if ( !bFlameOn && Self.IsA('WeaponFlamethrower'))
				{
					bFlameOn = True;
					StartFlame();
				}
				firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
                OnProjectileFired(firedProjectile);
			}
		}
		else
		{
			if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
			{
				if ( MustReload() && CanReload() )
				{
					bClientReadyToFire = False;
					bInProcess = False;
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();

					ReloadAmmo();
				}
			}
			PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );		// play dry fire sound
		}
	}
	else
	{
		if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
		{
			if ( MustReload() && CanReload() )
			{
				bClientReadyToFire = False;
				bInProcess = False;
				if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
					CycleAmmo();
				ReloadAmmo();
			}
		}
		PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );		// play dry fire sound
	}
	return true;
}

//
// from Weapon.uc - modified so we can have the accuracy in TraceFire
//
function Fire(float Value)
{
	local float sndVolume, mod;
	local bool bListenClient;
    local DeusExPlayer player;
    local Projectile firedProjectile;

    player = DeusExPlayer(Owner);

    //Sarge: Restrict fire if firing is blocked (used when detonating drone).
    if (player != None && player.bBlockNextFire)
    {
        player.bBlockNextFire = false;
        GotoState('Idle');  //SARGE: Needed to not break weapons
        return;
    }

    if (Pawn(Owner).IsInState('Dying') || (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bGEPprojectileInflight))
    {
      if (bAutomatic && Pawn(Owner).IsA('DeusExPlayer'))
      {
         bAutomatic = False;
      }
      return; //CyberP: cannot shoot when dying or GEPRemote control
    }
    if (burstTimer > 0)
        return;
	bListenClient = (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient());

	sndVolume = TransientSoundVolume;

	if ( Level.NetMode != NM_Standalone )  // Turn up the sounds a bit in mulitplayer
	{
		sndVolume = TransientSoundVolume * 2.0;
		if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01) || (!bClientReady && (!bListenClient)) )
		{
			DeusExPlayer(Owner).bJustFired = False;
			bReadyToFire = True;
			bPointing = False;
			bFiring = False;
			return;
		}
	}
	// check for surrounding environment
	if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
	{
		if (Region.Zone.bWaterZone)
		{
			if (Pawn(Owner) != None)
			{
				Pawn(Owner).ClientMessage(msgNotWorking);
				if (!bHandToHand)
					PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound
			}
			GotoState('Idle');
			return;
		}
	}

	if (bHandToHand)
	{
		if (ReloadCount > 0)
			AmmoType.UseAmmo(1);

       if (meleeStaminaDrain != 0 && !bFakeHandToHand)
       {
       if (Owner.IsA('DeusExPlayer') && Owner != none)
       {
		mod = DeusExPlayer(Owner).SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
        if (mod < 3)
          mod = 1;
        else
          mod = 0.5;
        if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme cancels all melee stamina drain
          mod = 0.0;

        DeusExPlayer(Owner).swimTimer -= meleeStaminaDrain*mod;
          if (DeusExPlayer(Owner).swimTimer < 0)
		     DeusExPlayer(Owner).swimTimer = 0;
        }
        }

		bReadyToFire = False;
		GotoState('NormalFire');
		bPointing=True;
		if (IsA('WeaponHideAGun') || IsA('WeaponLAW'))
        {
            firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
            OnProjectileFired(firedProjectile);
        }
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
	}
	// if we are a single-use weapon, then our ReloadCount is 0 and we don't use ammo
	else if ((ClipCount > 0) || (ReloadCount == 0))
	{
	    if (AmmoType.AmmoAmount == 0 && IsA('WeaponSawedOffShotgun')) //CyberP: hack for this weird bug on sawed off
	    {
	    PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound
	    }
		else if ((ReloadCount == 0) || AmmoType.UseAmmo(1))
		{
			if (( Level.NetMode != NM_Standalone ) && !bListenClient )
				bClientReady = False;

			ClipCount--;
			bFiring = True;
			bReadyToFire = False;

			GotoState('NormalFire');
			bPointing=True;
			/*if (bAimingDown)
            {
                currentAccuracy -= 0.2; //10%
			    // don't go too low
			    if (AreaOfEffect == AOE_Cone && currentAccuracy < 0.1)
				   currentAccuracy = 0.1;
				else if (currentAccuracy < 0)
                   currentAccuracy = 0.0;
			}*/
			if (AreaOfEffect == AOE_Cone && currentAccuracy < 0.1) //CyberP: cap shotguns and the plasma to 95%
		        currentAccuracy = 0.1;
			if ( bInstantHit )
				TraceFire(currentAccuracy);
			else
			{
				firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
                OnProjectileFired(firedProjectile);
				//if (IsA('WeaponFlamethrower'))
                //{
                // if (ReloadCount != ClipCount)
                //    DeusExPlayer(Owner).UpdateSensitivity(DeusExPlayer(Owner).default.MouseSensitivity*0.7);
                //}
            }
			if ( Owner.IsA('PlayerPawn') )
				PlayerPawn(Owner).PlayFiring();



            PlaySelectiveFiring();
			PlayFiringSound();
			if ( Owner.bHidden )
				CheckVisibility();
		}
		else
			PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound
	}
	else
		PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );		// play dry fire sound

    if (bAutomatic) //Hacky fix for pawns not reloading automatics for whatever reason.
    {
       if (Owner.IsA('ScriptedPawn'))
       {
          if (ClipCount == 0)
          {
              bReadyToFire = false;
              bFiring = False;
              ReloadAmmo();
          }
       }
    }
	// Update ammo count on object belt
	if (DeusExPlayer(Owner) != None)
		DeusExPlayer(Owner).UpdateBeltText(Self);
}

function ReadyToFire()
{
	if (!bReadyToFire)
	{
		// BOOGER!
		//if (ScriptedPawn(Owner) != None)
		//	ScriptedPawn(Owner).ReadyToFire();
		bReadyToFire = True;
		if ( Level.NetMode != NM_Standalone )
			ReadyClientToFire( True );
	}
}

function PlayPostSelect()
{
	// let's not zero the ammo count anymore - you must always reload
    //TODO: Sarge: Add backpack reloading
//	ClipCount = 0;
}

simulated function PlaySelectiveFiring()
{
	local Pawn aPawn;
	local float rnd;
	local Name anim;
	//local int animNum;
	local float mod;
    local float hhspeed;

/*	animNum = 0;

	if(AmmoNames[1] != None || AmmoNames[2] != None)
	{
		for(animNum = 0; animNum < 2; animNum++)
		{
			if(ProjectileClass == ProjectileNames[animNum])
				break;
		}
		if(animNum >= 2)
			animNum = 0;
	}

	anim = FireAnim[animNum];
*/
    anim = 'Shoot';

//	if(anim == '\'')
//		anim = 'Shoot';

	if (bHandToHand)
	{
		rnd = FRand();
		if (IsA('WeaponHideAGun') || IsA('WeaponLAW'))
            anim = 'Shoot';
		else if (rnd < 0.33)
			anim = 'Attack';
		else if (rnd < 0.66)
			anim = 'Attack2';
		else
			anim = 'Attack3';
		if (IsA('WeaponNanoSword'))
           if (FRand() < 0.5)
               PlaySound(sound'GMDXSFX.Weapons.ebladeswipe1',SLOT_None,,,,1.3);
           else
               PlaySound(sound'GMDXSFX.Weapons.ebladeswipe2',SLOT_None,,,,1.3);
		//AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 64);
	}

	//if(anim == '')
	//	return;

	if (( Level.NetMode == NM_Standalone ) || ( DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
	{
	    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AugmentationSystem != none)
		   hhspeed = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
			
        if (hhspeed < 1.0)
            hhspeed = 1.0;

		//== Speed up the firing animation if we have the ROF mod
		//mod = 1.000000 - ModShotTime;

        if (IsA('WeaponSawedOffShotgun') || IsA('WeaponStealthPistol') || IsA('WeaponHideAGun')
         || IsA('WeaponMiniCrossbow') || IsA('WeaponAssaultShotgun'))
		   mod = 1.650000 - ModShotTime;
        else
           mod = 1.000000 - ModShotTime;

		if (bAutomatic)
		{
		    if (IsA('WeaponAssaultGun'))
		    {
	           //mod = 1.000000;
	           mod = 2.000000; // SARGE: speed increase, convert 5 round burst to 3 round burst
	           PlayAnim(anim,1 * (mod-6*ModShotTime), 0.1);
		    }
		    else if (IsA('WeaponStealthPistol'))
		    {
		       mod = 1.000000 - ModShotTime;
               PlayAnim(anim,1.30 * mod, 0.0);
		    }
            else
		       LoopAnim(anim,1 * mod, 0.1);
		      //PlayAnim(anim,1 * mod, 0.1);
		}
        //Assault gun grenade launcher
		else if (IsA('WeaponAssaultGun'))
        {
            //mod = 4.000000;
			//PlayAnim(anim,1 * mod,0.1);
            return;
        }            
		else if (bHandToHand && !bFakeHandToHand)
		{

            if (Owner.IsA('DeusExPlayer'))
            {
            	if (DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0)                 //RSD: Zyme gives its own +50% boost
                	hhspeed += 0.5;
                if (DeusExPlayer(Owner).bStunted)                               //RSD: Halve melee speed if we're out of breath
                	hhspeed *= 0.5;
               	hhspeed *= attackSpeedMult;                                     //RSD: to differentiate melee weapon attack speeds, only used on crowbar (0.8 for 20% reduction)
           	}

			PlayAnim(anim,1 * hhspeed,0.1); //CyberP: increase melee speed if augcombat
		}
		else if (bHandToHand && GoverningSkill == class'DeusEx.SkillDemolition') //SARGE: Hand to Hand speed used to work for grenades. Make it work again, but without the stamina and zyme changes
			PlayAnim(anim,1 * hhspeed,0.1);
		else
			PlayAnim(anim,1 * mod,0.1);
	}
	else if ( Role == ROLE_Authority )
	{
		for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
		{
			if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(Owner) != DeusExPlayer(aPawn) ) )
			{
				// If they can't see the weapon, don't bother
				if ( DeusExPlayer(aPawn).FastTrace( DeusExPlayer(aPawn).Location, Location ))
					DeusExPlayer(aPawn).ClientPlayAnimation( Self, anim, 0.1, bAutomatic );
			}
		}
	}
}

//GMDX: cosmetic shaking only
simulated function UpdateRecoilShaker()
{
	if(Owner.IsA('DeusExPlayer'))
	{
	  DeusExPlayer(Owner).RecoilShaker(RecoilShaker);
	  if (DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkMarksman').bPerkObtained == true && GoverningSkill==Class'DeusEx.SkillWeaponRifle')
	      negTime = (RecoilStrength * default.negTime)*0.75;
	  /*else if (DeusExPlayer(Owner).PerkNamesArray[22] == 1 && GoverningSkill==Class'DeusEx.SkillWeaponPistol') //RSD: Removed Perfect Stance: Pistols
	      negTime = (RecoilStrength * default.negTime)*0.75;*/
	  else if (DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkControlledBurn').bPerkObtained == true && GoverningSkill==Class'DeusEx.SkillWeaponHeavy')
	      negTime = (RecoilStrength * default.negTime)*0.75;
	  else
	      negTime = RecoilStrength * default.negTime;
	}
}

simulated function PlayFiringSound()
{
	if (bHasSilencer)
    {
        //SARGE: Very silly rat squeak silencers!
        if (Owner != None && Owner.IsA('DeusExPlayer') && DeusExPlayer(owner).bShenanigans)
            PlaySimSound(Sound'RatSqueak2', SLOT_None, TransientSoundVolume, 2048 );
        else
            PlaySimSound(FireSilentSound, SLOT_None, TransientSoundVolume, 2048 );
    }
	else
	{
        if (FireSound != None)
            FireSound = GetDefaultFireSound();
		// The sniper rifle sound is heard to it's range in multiplayer
		if ( ( Level.NetMode != NM_Standalone ) &&  Self.IsA('WeaponRifle') )
			PlaySimSound( FireSound, SLOT_Interface, TransientSoundVolume, class'WeaponRifle'.Default.mpMaxRange );
		else if (IsA('WeaponRifle'))
            PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, class'WeaponRifle'.Default.MaxRange );
        else if ((bHandToHand || IsA('WeaponPlasmaRifle')) && Level.NetMode == NM_Standalone)
            PlaySound( FireSound, SLOT_None, TransientSoundVolume, ,1024,0.95+(FRand()*0.1));
        else
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, 3074 ); //CyberP: All weapons can now be heard by the player at further distances. Sniper especially so.
	}
}

simulated function PlayIdleAnim()
{
	local float rnd;

	if ( (bZoomed&&bHasScope) || bNearWall || activateAn)
		return;

	rnd = FRand();
	if (Owner != None && Owner.IsA('DeusExPlayer'))
	{
		if (DeusExPlayer(Owner).IsCrouching() == False && (DeusExPlayer(Owner).Velocity.X != 0 || DeusExPlayer(Owner).Velocity.Y != 0))
		{
			if (rnd < 0.1)
			{
				if (IsClyzmModel()) //RSD: Clyzm model
					PlayAnim('Idle',1.5,0.1);
				else
					PlayAnim('Idle1',1.5,0.1);
			}
			else if (rnd < 0.2)
				PlayAnim('Idle2',1.5,0.1);
			else if (!DeusExPlayer(Owner).InHand.IsA('WeaponCrowbar') && rnd < 0.3)
				PlayAnim('Idle3',1.5,0.1);
		}
		else
		{
			if (rnd < 0.1)
			{
				if (IsClyzmModel()) //RSD: Clyzm model
					PlayAnim('Idle',,0.1);
				else
					PlayAnim('Idle1',,0.1);
			}
			else if (rnd < 0.2)
				PlayAnim('Idle2',,0.1);
			else if (rnd < 0.3)
				PlayAnim('Idle3',,0.1);
		}
    }
}

//
// SpawnBlood
//

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
	local BloodDrop drop;
	local int i;
	
	if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
	  return;

	spawn(class'BloodSpurt',,,HitLocation+HitNormal);
    spawn(class'BloodDrop',,,HitLocation+HitNormal);
    spawn(class'BloodDrop',,,HitLocation+HitNormal);
	spawn(class'BloodDrop',,,HitLocation+HitNormal);
	if (FRand() < 0.4)
		spawn(class'BloodDrop',,,HitLocation+HitNormal);

    if (!IsA('WeaponProd') && Owner != None && Owner.IsA('DeusExPlayer'))
    {
		for(i=0;i<25;i++)
		{
			if (FRand() < 0.5) //Ygll: taking the test from Carcass spawn blood. 
				continue;

			drop = spawn(class'BloodDrop',,,HitLocation+HitNormal);
			if (drop != None)
			{
				drop.LifeSpan=0.2;
				drop.Velocity*=0.8;
			}
		}
    }
}

////////////////////
//  function SpawnGMDXEffects //CyberP: so deco has impact effects. More sloppy code.
////////////////////
function SpawnGMDXEffects(Vector HitLocation, Vector HitNormal)
{
local int i;
local GMDXImpactSpark s;
local GMDXImpactSpark2 t;
local GMDXSparkFade fade;
local SFXExp puff2;
spawn(class'GMDXFireSmokeFade',,,HitLocation+HitNormal);
spawn(class'GMDXSparkFade',,,HitLocation+HitNormal);
		puff2 = spawn(class'SFXExp',,,HitLocation+HitNormal);
        if ( puff2 != None )
			{
		        puff2.scaleFactor=0.01;
		        puff2.scaleFactor2=3.5;
		        puff2.GlowFactor=0.2;
		        puff2.animSpeed=0.015;
			    puff2.RemoteRole = ROLE_None;
			}
		fade = spawn(class'GMDXSparkFade',,,HitLocation+HitNormal);
		 if (fade != None)
		 {
		 fade.DrawScale = 0.12;
		 }
       for (i=0;i<11;i++)
        {
        s = spawn(class'GMDXImpactSpark',,,HitLocation+HitNormal);
        t = spawn(class'GMDXImpactSpark2',,,HitLocation+HitNormal);
          if (s != none && t != none)
        {
        s.LifeSpan=FRand()*0.042;
        t.LifeSpan=FRand()*0.042;
        s.DrawScale = FRand() * 0.04;
        t.DrawScale = FRand() * 0.04;
        }
        }
}
//
// SelectiveSpawnEffects - Continues the simulated chain for the owner, and spawns the effects for other players that can see them
//			No actually spawning occurs on the server itself.
//
simulated function SelectiveSpawnEffects( Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
	local DeusExPlayer fxOwner;
	local Pawn aPawn;

	// The normal path before there was multiplayer
	if ( Level.NetMode == NM_Standalone )
	{
		SpawnEffects(HitLocation, HitNormal, Other, Damage);
		return;
	}

	fxOwner = DeusExPlayer(Owner);

	if ( Role == ROLE_Authority )
	{
		SpawnEffectSounds(HitLocation, HitNormal, Other, Damage );

		for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
		{
			if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(aPawn) != fxOwner ) )
			{
				if ( DeusExPlayer(aPawn).FastTrace( DeusExPlayer(aPawn).Location, HitLocation ))
					DeusExPlayer(aPawn).ClientSpawnHits( bPenetrating, bHandToHand, HitLocation, HitNormal, Other, Damage );
			}
		}
	}
	if ( fxOwner == DeusExPlayer(GetPlayerPawn()) )
	{
			fxOwner.ClientSpawnHits( bPenetrating, bHandToHand, HitLocation, HitNormal, Other, Damage );
			SpawnEffectSounds( HitLocation, HitNormal, Other, Damage );
	}
}

//
//	 SpawnEffectSounds - Plays the sound for the effect owner immediately, the server will play them for the other players
//
simulated function SpawnEffectSounds( Vector HitLocation, Vector HitNormal, Actor Other, float Damage )
{
	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlayOwnedSound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlayOwnedSound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlayOwnedSound(sound'GlassHit1', SLOT_None,,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlayOwnedSound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlayOwnedSound(Misc2Sound, SLOT_None,,, 1024);
	}
}

//
//	SpawnEffects - Spawns the effects like it did in single player
//
function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
	local TraceHitSpawner hitspawner;
	local Name damageType;

	damageType = WeaponDamageType();

//	log("weap"@Other@Damage@damageType);

	//GMDX:dasraiser fix vanilla bug with fast pc's, do i dare fix entire game spawn system....nfl
	class'TraceHitSpawner'.default.HitDamage=Damage;
	class'TraceHitSpawner'.default.damageType=damageType;

	if (IsA('WeaponNanoSword')) //hitSpawner.damageType='NanoSword';
	{
	  class'TraceHitSpawner'.default.bForceBulletHole=true;
	  class'TraceHitSpawner'.default.damageType='DTS_Strike';

	  //if ((Emitter!=none)&&(Emitter.proxy!=none))
//      {
//         HitLocation=Emitter.proxy.Location;
//      }
	} else
	  class'TraceHitSpawner'.default.damageType=damageType;

	if (bPenetrating)
	{
	  if (bHandToHand) //dasraiser meh i see why now :/   HandToHand
	  {
		 hitspawner = Spawn(class'TraceHitHandSpawner',Other,,HitLocation,Rotator(HitNormal));
		 if (Owner.IsInState('Dying'))
		 hitspawner = none; //CyberP: death overrides melee attacks
	  }
	  else
	  {
		 hitspawner = Spawn(class'TraceHitSpawner',Other,,HitLocation,Rotator(HitNormal));
	  }
	}
	else
	{
	  if (bHandToHand)  //bHandToHand
	  {
		 hitspawner = Spawn(class'TraceHitHandNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
	  }
	  else
	  {
		 hitspawner = Spawn(class'TraceHitNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
	  }
	}
//   if (hitSpawner != None)
//	{
//	  hitspawner.HitDamage = Damage;
//		hitSpawner.damageType = damageType;
//	}
	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlaySound(Misc3Sound, SLOT_None,,, 1024);
		else if (Owner.IsA('Doberman') && FRand() < 0.6)
            Owner.PlaySound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('DeusExCarcass'))
            Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlaySound(sound'GlassHit1', SLOT_None,,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlaySound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlaySound(Misc2Sound, SLOT_None,,, 1024);
	    if (Other != none && !Other.IsA('Pawn'))
	    {
	        if (Other == Level)
			    AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 640); //CyberP: AI hear us smacking things
			else
                AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 320);
		}
	}
}


function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
	local vector EndTrace, StartTrace;
	local actor target;
	local int texFlags;
	local name texName, texGroup;
    local Projectile firedProjectile;

	StartTrace = HitLocation + HitNormal*16;		// make sure we start far enough out
	EndTrace = HitLocation - HitNormal;

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
		if ((target == Level) || target.IsA('Mover'))
			break;

	return texGroup;
}

simulated function SimGenerateBullet()
{
    local Projectile firedProjectile;
	if ( Role < ROLE_Authority )
	{
		if ((ClipCount > 0) && (ReloadCount != 0))
		{
			if ( AmmoType != None )
				AmmoType.SimUseAmmo();

			if ( bInstantHit )
				TraceFire(currentAccuracy);
			else
            {
				firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
                OnProjectileFired(firedProjectile);
            }

			SimClipCount--;

			if ( !Self.IsA('WeaponFlamethrower') )
				ServerGenerateBullet();
		}
		else
			GotoState('SimFinishFire');
	}
}

function DestroyOnFinish()
{
	bDestroyOnFinish = True;
}

function ServerGotoFinishFire()
{
	GotoState('FinishFire');
}

function ServerDoneReloading()
{
    ReloadMaxAmmo();
}

function ServerGenerateBullet()
{
	if ( ClipCount > 0 )
		GenerateBullet();
}

function GenerateBullet()
{
    local Projectile firedProjectile;

	if (AmmoType.UseAmmo(1))
	{
		if ( bInstantHit )
			TraceFire(currentAccuracy);
        else
        {
            firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
            OnProjectileFired(firedProjectile);
        }

		ClipCount--;
		if (IsA('WeaponAssaultGun'))
		   PlayFiringSound();
	}
	else
		GotoState('FinishFire');
}


function PlayLandingSound()
{
    local Rotator rot;

	if (LandSound != None)
	{
		if (Velocity.Z <= -170)
		{
			PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 1024);
			AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 512+(Mass*3));
		}
	}
	bFixedRotationDir = False;
	rot = Rotation;
	rot.Pitch = 0;
	rot.Roll = 0;
	SetRotation(rot);
}


function GetWeaponRanges(out float wMinRange,
						 out float wMaxAccurateRange,
						 out float wMaxRange)
{
	local Class<DeusExProjectile> dxProjectileClass;

	dxProjectileClass = Class<DeusExProjectile>(ProjectileClass);
	if (dxProjectileClass != None)
	{
		wMinRange         = dxProjectileClass.Default.blastRadius;
		wMaxAccurateRange = dxProjectileClass.Default.AccurateRange;
		wMaxRange         = dxProjectileClass.Default.MaxRange;
		if (wMinRange > 64)  //CyberP: AI may shoot in close range
		{
		   if (FRand() < 0.3)
		      if (Owner != None && Owner.IsA('HumanMilitary'))
	             if (HumanMilitary(Owner).Health < HumanMilitary(Owner).default.Health * 0.2)
	                wMinRange = 16;
	    }
	}
	else
	{
		wMinRange         = 0;
		//wMaxAccurateRange = AccurateRange;
		//wMaxRange         = MaxRange;

        //RSD: hacks to keep AI hitscan ranges same as before I lowered weapon ranges
        //No need to worry about giving longer max range than is possible, since it's unused
        /*
		if(IsA('WeaponAssaultGun'))                                             //RSD: Assault Gun range was cut by 50%
		{
		   wMaxAccurateRange = 2.0*AccurateRange;
		   wMaxRange         = 2.0*MaxRange;
		}
		else if(IsA('WeaponRifle'))                                             //RSD: Sniper Rifle range was cut by 20%
		{
		   wMaxAccurateRange = 1.25*AccurateRange;
		   wMaxRange         = 1.25*MaxRange;
		}
		else if(IsA('WeaponSawedOffShotgun') || IsA('WeaponStealthPistol'))     //RSD: Sawed-off and stealth pistol ranges were cut by 37.5%
		{
		   wMaxAccurateRange = 1.6*AccurateRange;
		   wMaxRange         = 1.6*MaxRange;
		}
		else if(IsA('WeaponPistol'))                                            //RSD: Pistol range was cut by 10%
        {
		   wMaxAccurateRange = 1.1111*AccurateRange;
		   wMaxRange         = 1.1111*MaxRange;
		}
		else                                                                    //RSD: Shotgun ranges were cut by roughly 25% (Assault Shotgun a bit more, so now AI will walk a tad closer to use it)
        {
		   wMaxAccurateRange = 1.3333*AccurateRange;
		   wMaxRange         = 1.3333*MaxRange;
		}
		*/
		//RSD: Holy shit that's awful, instead let's use the new variables I created to decouple AI weapon range from player weapon range
		if (NPCAccurateRange == 0)                                              //RSD: Failsafe
			wMaxAccurateRange = AccurateRange;
		else
			wMaxAccurateRange = NPCAccurateRange;
		if (NPCMaxRange == 0)                                                   //RSD: Failsafe
			wMaxRange = MaxRange;
		else
			wMaxRange = NPCMaxRange;
	}
}

//
// computes the start position of a projectile/trace
//
simulated function Vector ComputeProjectileStart(Vector X, Vector Y, Vector Z)
{
	local Vector Start;

	// if we are instant-hit, non-projectile, then don't offset our starting point by PlayerViewOffset
	if (bInstantHit)
		Start = Owner.Location + Pawn(Owner).BaseEyeHeight * vect(0,0,1);// - Vector(Pawn(Owner).ViewRotation)*(0.9*Pawn(Owner).CollisionRadius);
	else
    {
        //SARGE: Filthy. dirty hack!!
        //We need to reset our offsets because otherwise projectiles can
        //spawn too close to the player, and collide with him!
        if (bOldOffsetsSet && Owner != None && Owner.IsA('DeusExPlayer'))
            default.PlayerViewOffset = oldOffsets;
		Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
        if (Owner != None && Owner.IsA('DeusExPlayer'))
            DoWeaponOffset(DeusExPlayer(Owner));
    }

	return Start;
}

/*simulated function Rotator CalcDeltaRotation(Rotator InRot)
{
local float DeltaTime;
local Rotator DeltaRot;
local int MaxDeltaAngle;
local DeusExPlayer PlayerOwner;

PlayerOwner = DeusExPlayer(Owner);

//HACK CHECK FOR FIRST CALCULATION INCLUDED!
//Last thing you want is Rot(0,0,0) being taken seriously.

if (PlayerOwner != None && LastWeaponRotation != Rot(0,0,0))
{
 // Update time.
 DeltaTime = Level.TimeSeconds - LastWeaponRotationUpdateTime;
 LastWeaponRotationUpdateTime = Level.TimeSeconds;

 // Calculate (signed) minimum deltas between ViewRotation and LastWeaponRotation. Just a bit special cases and modula. Keep in mind UnrealScript has no mathematic
 // modulo, but that shitty programmer one instead.
 // DeltaRot = [...]
 DeltaRot.Yaw = InRot.Yaw mod LastWeaponRotation.Yaw;
 DeltaRot.Pitch = InRot.Pitch mod LastWeaponRotation.Pitch;
 DeltaRot.Roll = InRot.Roll mod LastWeaponRotation.Roll;
 //Now calculate how much unreal degree change of the weapon is allowed.
 MaxDeltaAngle = DeltaTime * DELTAROTCLAMP;

 DeltaRot.Yaw = Clamp(DeltaRot.Yaw, MaxDeltaAngle*-1, MaxDeltaAngle);
 DeltaRot.Pitch = Clamp(DeltaRot.Pitch, MaxDeltaAngle*-1, MaxDeltaAngle);
 DeltaRot.Roll = Clamp(DeltaRot.Roll, MaxDeltaAngle*-1, MaxDeltaAngle);
 // Clamp DeltaRot components to MaxDeltaAngle (keep the sign!)
 // [...]

 // Add the clamped DeltaRot components to LastWeaponRotation.
 // [...]
 LastWeaponRotation = LastWeaponRotation + DeltaRot;

 // Render using LastWeaponRotation.
 // [..]

 LastWeaponRotation = InRot + DeltaRot;
}

 //Scripted pawns do boring crap. This is technically optimization.
 else if (Pawn(Owner) != None)
 {
  LastWeaponRotation = Pawn(Owner).ViewRotation;
  return InRot;
 }
 return LastWeaponRotation;
}
//Massive debate on unreal wiki about this one, but supposedly their % Mod operator is crap.
//Mostly on the topic of negative numbers. If you have major issues with one direction, but
//not the other. Heavily considering switching all "mod" operator statements to % operators.
static final operator(18) float mod ( float A, float B )
{
 if( A % B >= 0 )
  return A % B ;
 else
  return ( A % B ) + B;
}*/

//
// Modified to work better with scripted pawns
//
simulated function vector CalcDrawOffset()
{
	local vector		DrawOffset, WeaponBob;
	local ScriptedPawn	SPOwner;
	local Pawn			PawnOwner;
	local vector unX,unY,unZ;
    local Rotator vr;                       //SARGE: Added viewrotation variable

	SPOwner = ScriptedPawn(Owner);
	if (SPOwner != None)
	{
		DrawOffset = ((0.9/SPOwner.FOVAngle * PlayerViewOffset) >> SPOwner.ViewRotation);
		DrawOffset += (SPOwner.BaseEyeHeight * vect(0,0,1));
	}
	else
	{
	    if (activateAn == False && !IsA('WeaponGEPGun'))
	    {
		if (!bAimingDown && (bInvisibleWhore || bMantlingEffect))
	    {
	       lerpAid -= 8.4;
	       if (lerpAid < -100)
	           lerpAid = -100;
	       else
	           PlayerViewOffset.X += lerpAid;
	    }
        else
        {
	       lerpAid += 8.4;
	       if (lerpAid > 0)
	       {
	           lerpAid = 0;
	           PlayerViewOffset.X = default.PlayerViewOffset.X*100;
	       }
	       else
	           PlayerViewOffset.X -= lerpAid;
        }
        }       
        // copied from Engine.Inventory to not be FOVAngle dependent
		PawnOwner = Pawn(Owner);

        vr = PawnOwner.ViewRotation;
        if (PawnOwner.isa('DeusExPlayer'))
            vr = DeusExPlayer(PawnOwner).GetCurrentViewRotation();

		DrawOffset = ((0.9/PawnOwner.Default.FOVAngle * PlayerViewOffset) >> vr);
		DrawOffset += (PawnOwner.EyeHeight * vect(0,0,1));
		WeaponBob = BobDamping * PawnOwner.WalkBob;
		WeaponBob.Z = (0.45 + 0.55 * BobDamping) * PawnOwner.WalkBob.Z;
		DrawOffset += WeaponBob;
	}
	if (Owner.IsA('DeusExPlayer'))
	{
		if (VSize(DeusExPlayer(Owner).RecoilShake)>0.0)
		{
			GetAxes(Rotation,unX,unY,unZ);
			if (IsA('WeaponHideAGun') && bFiring)
			unX*=DeusExPlayer(Owner).RecoilShake.X*-2;
			else if (IsA('WeaponRifle') && bFiring)
			unX*=DeusExPlayer(Owner).RecoilShake.X*-1.0;
			else
			unX*=DeusExPlayer(Owner).RecoilShake.X*0.5;

			unY*=DeusExPlayer(Owner).RecoilShake.Y*0.75;
			unZ*=DeusExPlayer(Owner).RecoilShake.Z*0.75;
			DrawOffset+=(unX+unY+unZ);
		}
	}
	return DrawOffset;
}

function GetAIVolume(out float volume, out float radius, optional bool wakeUp)
{
    local DeusExPlayer player;
	local float NL;
    player = DeusExPlayer(Owner);

	volume = 0;
	radius = 0;

    if (Owner == None)
        return;

	NL = NoiseLevel;
	//NL = NoiseLevel * 0.451; //SARGE: Dirty hack to make guns quieter now that pawns can actually detect gunfire reliably.
	//NL = NoiseLevel; //SARGE: Now it's reduced in the WakeUpAI call instead

	if (!bHasSilencer && (!bHandToHand || IsA('WeaponHideAGun'))) //SARGE: Added PS20
	{
		volume = NL*Pawn(Owner).SoundDampening;
		if (player != None)
		{
		    if (player.CombatDifficulty < 1)
		        volume *= 0.65;  //CyberP: AI are less receptive to gunshots on lower difficulty levels. easy = -50% medium = -25%
		    else if (player.CombatDifficulty < 3)
                volume *= 0.8;
		}
		radius = volume * 800.0;
	}
	else if (bHasSilencer && NoiseLevel >= 0.1)                                 //RSD: Added quiet sound for silenced weapons
    {
        volume = 1.0*Pawn(Owner).SoundDampening;                                //RSD: Hardcoded value as specified in weapon info
		radius = volume * 800.0;
    }

    //SARGE: Wake up the AI
    if (wakeUp)
        class'PawnUtils'.static.WakeUpAI(Owner,radius * 0.3);
}

//Ygll: utility function to test the behaviour of the dart with Fragile dart gameplay option enabled
function DartStickToWall(DeusExProjectile proj)
{
    local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());

    if (player == None)
        return;

	//SARGE: Added new gameplay setting
	//Ygll: must test the class type of the projectile before testing the option value. proj.IsA('Dart') test can be true for all Dart type.
	if ( proj.IsA('DartPoison'))
	{
		//Poison Dart should be destroyable in hardcore even with the fragile option disabled
		if( player.bHardCoreMode || player.iFragileDarts >= 1 )
			proj.bSticktoWall = false;                      //RSD: Tranq darts won't stick to walls (for recovery) in Hardcore
	}
	else if (proj.IsA('DartTaser'))
	{
		if(player.iFragileDarts >= 2)
			proj.bSticktoWall = false;
	}	
	else if (proj.IsA('DartFlare'))
	{
		if(player.iFragileDarts >= 4)
			proj.bSticktoWall = false;
	}
	else
	{
		if (proj.IsA('Dart') && player.iFragileDarts >= 3)
			proj.bSticktoWall = false;
	}
}

//
// copied from Weapon.uc
//
simulated function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
    local float AddonRangeMod;
	local Vector Start, X, Y, Z;
	local DeusExProjectile proj;
	local float mult, speedMult, rangeMult, strengthMult;                       //RSD: Added strengthMult
	local float volume, radius;
	local float laserKick;                                                      //RSD: Added laserKick
	local int i, numProj;
	local Pawn aPawn;
    local PlasmaParticleSpoof spoof;
    local float TempAcc;                                                        //RSD
    local Rotator AdjustedAimCenter;                                            //RSD
    local int finalDamage;                                                      //RSD

	speedMult=1.0;
	// AugCombat increases our speed (distance) if hand to hand
	mult = 1.0;
	if (bHandToHand && !bFakeHandToHand && (DeusExPlayer(Owner) != None))
	{
		/*mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat'); //RSD: No more buffs to projectile speed from Combat Speed
		if (mult == -1.0)
			mult = 1.0;
		if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost
            mult += 0.5;
		ProjSpeed *= mult;*/

		mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombatStrength'); //RSD: Combat Speed was still doing this before
		if (mult == -1.0)
        	mult = 1.0;
        if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost
            mult += 0.5;
	}

	rangeMult = 1;

    if (GoverningSkill == class'DeusEx.SkillDemolition')
       PlaySound(sound'grenadethrow', SLOT_None,,, 640);
//G-Flex: range mod previously did nothing for projectiles
//G-Flex: the game says range mods work on plasma rifles/flamethrowers, so let's make it so
//G-Flex: fireballs in particular need to go faster to go further, which makes sense
//G-Flex: don't do as much for the minicrossbow or whatever else
	if (HasRangeMod())
	{
		rangeMult += (ModAccurateRange*1.3333);
		if (IsA('WeaponPlasmaRifle') || IsA('WeaponFlamethrower') || IsA('WeaponGEPGun') || IsA('WeaponMiniCrossbow')
			|| IsA('WeaponSawedOffShotgun') || IsA('WeaponAssaultShotgun') || IsA('WeaponPepperGun')) //RSD: Added shotguns and pepper gun
		speedMult += (ModAccurateRange*1.3333);
	}

	ProjSpeed *= speedMult;

	// skill also affects our damage
	// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
	mult += -2.0 * GetWeaponSkill() + ModDamage; //CyberP: damage mod

    if (IsA('WeaponSawedoffShotgun') && projClass == class'RubberBullet')       //RSD: doing Sawed-Off damage increase properly
    	mult += 0.30;

	// make noise if we are not silenced
	if (!bHandToHand || IsA('WeaponHideAGun'))
	{
		GetAIVolume(volume, radius, true);
		Owner.AISendEvent('WeaponFire', EAITYPE_Audio, volume, radius);
		Owner.AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			Owner.AISendEvent('Distress', EAITYPE_Audio, volume, radius);
	}
    //if (bLasing || bZoomed)                                                   //RSD: Moved lower for simplicity with plasma exception
	//	currentAccuracy = 0.0;        //CyberP: laser & scope had no effect on xbow and plasma rifle

    if (Owner.IsA('ScriptedPawn') && !Owner.IsA('Robot')) //CyberP: pawns are slightly innaccurate if player is moving
    {
        currentAccuracy += PawnAccuracyModifier;
        if (currentAccuracy < 0.0)
            currentAccuracy = 0.0;
    }

    // should we shoot multiple projectiles in a spread?
	if (AreaOfEffect == AOE_Cone && IsA('WeaponGraySpit'))
	    numProj = 2+(4*FRand());
    else if (AreaOfEffect == AOE_Cone && !IsA('WeaponSawedOffShotgun') && !IsA('WeaponAssaultShotgun') && !bSuperheated)
		numProj = 3;
	else
		numProj = 1;

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = ComputeProjectileStart(X, Y, Z);
    if (IsA('WeaponFlamethrower') && Owner!=none && Owner.IsA('DeusExPlayer') && IsHDTP())
    {
    for(i=0;i<13;i++)
    {
    spoof = spawn(class'PlasmaParticleSpoof',,, start, Pawn(Owner).ViewRotation);
    if (spoof!=none)
    {
    spoof.DrawScale=0.005;
    spoof.LifeSpan=0.225;
    spoof.Texture= class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPMuzzleflashSmall2");
    spoof.Velocity=320*vector(Rotation);//vect(0,0,0);
    //spoof.Velocity.X = FRand() * 700;
    //spoof.Velocity.Z = FRand() * 60;

		if (FRand() < 0.3)
		{
		spoof.Velocity.Z += FRand() * 80;
		spoof.Velocity.X += FRand() * 65;
		spoof.Velocity.Y += FRand() * 65;
		}
		else if (FRand() < 0.6)
		{
		spoof.Velocity.Z -= FRand() * 20;
		spoof.Velocity.X -= FRand() * 55;
		spoof.Velocity.Y -= FRand() * 65;
		}
    }
    }
    }

    if (numProj > 1 && Owner.IsA('DeusExPlayer'))                               //RSD: For weapons with multiple shots (i.e. Plasma Rifle), spread from a consistent center
    {
    	TempAcc = FMax(0.0,currentAccuracy - 0.25*SlugSpreadAcc);
        AdjustedAimCenter = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);
		if (bLasing && Emitter != None && !bZoomed)                             //RSD: If we're using a laser but not scoped, shoot at the location of the laser
        {
          AdjustedAimCenter.Yaw += LaserYaw;
		  AdjustedAimCenter.Pitch += LaserPitch;
        }
        else                                                                    //RSD: Slightly lower inaccuracy here
        {
          AdjustedAimCenter.Yaw += TempAcc * (Rand(1750) - 875);
          AdjustedAimCenter.Pitch += TempAcc * (Rand(1750) - 875);
        }
        TempAcc = FClamp(0.0,currentAccuracy*SlugSpreadAcc,SlugSpreadAcc);
    }

    if (bLasing || bZoomed)                                                     //RSD: Moved lower for simplicity with plasma exception
		currentAccuracy = 0.0;        //CyberP: laser & scope had no effect on xbow and plasma rifle

	for (i=0; i<numProj; i++)
	{
	  // If we have multiple slugs, then lower our accuracy a bit after the first slug so the slugs DON'T all go to the same place
	  if ((i > 0) && (Level.NetMode != NM_Standalone))
		 if (currentAccuracy < MinProjSpreadAcc)
			currentAccuracy = MinProjSpreadAcc;

		AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);
		if (Pawn(Owner).IsA('ScriptedPawn'))
		{
		 AdjustedAim.Yaw += currentAccuracy * (Rand(1024) - 512);
		 AdjustedAim.Pitch += currentAccuracy * (Rand(1024) - 512);
        }
        else
        {
         if (numProj > 1)
         {
          AdjustedAim.Yaw = AdjustedAimCenter.Yaw + TempAcc*(Rand(1750) - 875);
          AdjustedAim.Pitch = AdjustedAimCenter.Pitch + TempAcc*(Rand(1750) - 875);
         }
         else if (bLasing && Emitter != None && !bZoomed)                       //RSD: If we're using a laser but not scoped, shoot at the location of the laser
         {
          AdjustedAim.Yaw += LaserYaw;
		  AdjustedAim.Pitch += LaserPitch;
         }
         else                                                                   //RSD: I need projectile inaccuracy to be just a biiiit more consequential for players
         {
          AdjustedAim.Yaw += currentAccuracy * (Rand(1750) - 875);
          AdjustedAim.Pitch += currentAccuracy * (Rand(1750) - 875);
         }
         /*else
         {
          AdjustedAim.Yaw += currentAccuracy * (Rand(1536) - 768);              //RSD: Strong rightward bias fixed (was Rand(1536) - 256)
          AdjustedAim.Pitch += currentAccuracy * (Rand(1536) - 768);            //RSD: Strong upward bias fixed (was Rand(1536) - 256)
         }*/
        }
       UpdateRecoilShaker();

		if (( Level.NetMode == NM_Standalone ) || ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
		{
			proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
			if (proj != None)
			{
				//SARGE: Added new gameplay setting //Ygll: Add more option to the fragile dart option
				DartStickToWall(proj);

                mult *= 1.0 - GetAddonPenalty(Silencer);
					
                //proj.Damage *= mult;                                          //RSD
                finalDamage = proj.Damage*mult;                                 //RSD: final input to TakeDamage is a truncated int
                if (FRand() < (proj.Damage*mult-finalDamage))                   //RSD: So randomly add +1 damage with probability equal to the remainder (0.0-1.0)
                {
                	finalDamage = finalDamage + 1.0;
                	proj.bPlusOneDamage = true;
               	}
                proj.Damage = finalDamage;                                      //RSD
                //if (Owner.IsA('DeusExPlayer'))
                //	Owner.BroadcastMessage(proj.Damage);
				//G-Flex: actually use the new projectile speed (ProjSpeed / proj.Default.Speed)
				proj.Speed *= speedMult;
				proj.MaxSpeed *= speedMult;
				proj.Velocity *= speedMult;
				//G-Flex: travel further since we're faster
				proj.MaxRange *= rangeMult;
				proj.AccurateRange *= rangeMult;
				if (IsA('WeaponPepperGun'))
					proj.LifeSpan *= rangeMult;

                if (GoverningSkill==class'DeusEx.SkillDemolition')
                {
                  if (Owner != None && Owner.IsA('DeusExPlayer'))
                  {
                  if (bContactDeton)
                     proj.bContactDetonation=True;
                  if (DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkShortFuse').bPerkObtained == true)
                  {
                     //proj.MaxSpeed=1650.000000;
                     //proj.Velocity*=1.4;
                     if (proj.IsA('ThrownProjectile'))
                     {
                      ThrownProjectile(proj).fuseLength = 2.0;
                      ThrownProjectile(proj).SetTimer(2.0, False);
                      }
                  }
                  }
                }
//GMDX player GEP
				if ((IsA('WeaponGEPGun'))&&(bLasing||bZoomed)&&(DeusExPlayer(Owner)!=none)&&(DeusExPlayer(Owner).RocketTarget!=none))
				{
				 //   LockTarget=DeusExPlayer(Owner).RocketTarget;
					if (bZoomed)
					{
						LockMode=LOCK_Locked; //needed?
						DeusExPlayer(Owner).aGEPProjectile=proj;
						proj.Target=none;
						proj.bRotateToDesired=true;
						proj.bTracking = False;
						DeusExPlayer(Owner).bGEPprojectileInflight=true;
						Rocket(proj).PostSpawnInit();

					} else
					{
						LockMode=LOCK_Locked; //needed?
						proj.Target = DeusExPlayer(Owner).RocketTarget;
						proj.bTracking = True;
						DeusExPlayer(Owner).bGEPprojectileInflight=false;
						DeusExPlayer(Owner).aGEPProjectile=proj;  //never both bGEPprojectileInflight with this if laser guided, this is just a ref to proj
						Rocket(proj).PostSpawnInit();
					}

				} else
				// send the targetting information to the projectile
				if (bCanTrack && (LockTarget != None) && (LockMode == LOCK_Locked))
				{
					proj.Target = LockTarget;
					proj.bTracking = True;
				}
				if (proj.IsA('PlasmaBolt'))                                     //RSD: To ensure we only use the Blast Energy perk with the plasma rifle
					PlasmaBolt(proj).weaponShotBy = self;
			}
		}
		else
		{
			if (( Role == ROLE_Authority ) || (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
			{
				// Do it the old fashioned way if it can track, or if we are a projectile that we could pick up again
				if ( bCanTrack || Self.IsA('WeaponShuriken') || Self.IsA('WeaponMiniCrossbow') || Self.IsA('WeaponLAM') || Self.IsA('WeaponEMPGrenade') || Self.IsA('WeaponGasGrenade'))
				{
					if ( Role == ROLE_Authority )
					{
						proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
						if (proj != None)
						{
                            // AugCombat increases our damage as well           //RSD: Actually it's Combat Strength now
								proj.Damage *= mult;
							// send the targetting information to the projectile
							if (bCanTrack && (LockTarget != None) && (LockMode == LOCK_Locked))
							{
								proj.Target = LockTarget;
								proj.bTracking = True;
							}
						}
					}
				}
				else
				{
					proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
					if (proj != None)
					{
					   proj.RemoteRole = ROLE_None;
						// AugCombat increases our damage as well
						if ( Role == ROLE_Authority )
							proj.Damage *= mult;
						else
							proj.Damage = 0;
					}
					if ( Role == ROLE_Authority )
					{
						for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
						{
							if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(aPawn) != DeusExPlayer(Owner) ))
								DeusExPlayer(aPawn).ClientSpawnProjectile( ProjClass, Owner, Start, AdjustedAim );
						}
					}
				}
			}
		}

	}
	/*LaserYaw = (currentAccuracy) * (Rand(3072) - 1536);                         //RSD: Reset laser position when firing (75% of cone width)
    LaserPitch = (currentAccuracy) * (Rand(3072) - 1536);*/                       //RSD: Swear to god I didn't mean to copy Shifter here, tried 100% width and it was too much

    //if (IsA('WeaponMiniCrossbow'))                                              //RSD: Full-auto needs a bit more kick for the laser
    	laserKick = 2.0*recoilStrength;
   	//else laserKick = 1.5*recoilStrength;

    LaserYaw += (currentAccuracy*laserKick) * (Rand(4096) - 2048);              //RSD: Bump laser position when firing (75% of cone width)
    LaserPitch += (currentAccuracy*laserKick) * (Rand(4096) - 2048);

	return proj;
}

//
// copied from Weapon.uc so we can add range information
//
simulated function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local Rotator rot;
	local actor Other;
	local float dist, alpha, degrade, laserKick;                                //RSD: Added laserKick
	local int i, numSlugs;
	local float volume, radius;
	local ScriptedPawn initialPawnHit;
	local int numSlugsHit;
    local tracer trcr;                                                          //RSD: Added
    local vector EndTraceCenter, moverStartTrace;                               //RSD: Added
    local float TempAcc;                                                        //RSD: Added
    local Projectile firedProjectile;

	// make noise if we are not silenced
	if (!bHandToHand || IsA('WeaponHideAGun'))
	{
		GetAIVolume(volume, radius, true);
		Owner.AISendEvent('WeaponFire', EAITYPE_Audio, volume, radius);
		Owner.AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			Owner.AISendEvent('Distress', EAITYPE_Audio, volume, radius);
	}

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	StartTrace = ComputeProjectileStart(X, Y, Z);
	AdjustedAim = pawn(owner).AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);

	// check to see if we are a shotgun-type weapon
	if (AreaOfEffect == AOE_Cone && !ammoType.IsA('AmmoSabot') && !ammoType.IsA('AmmoRubber'))                 //RSD: Special case to make Sabot rounds actually slugs
    {
        if (IsA('WeaponSawedOffShotgun'))
		    numSlugs = 9;  //Sarge: Give the sawed off an extra slug
        else
		    numSlugs = 8;  //CyberP: was 5
    }
	else
		numSlugs = 1;

    numSlugsHit = 0;

	// if there is a scope, but the player isn't using it, decrease the accuracy
	// so there is an advantage to using the scope
	//if (bHasScope && !bZoomed && !bLasing)
	//	{
    //    Accuracy += 0.2;  //CyberP: commented out. This was -20% accuracy even if game weapon info and xhairs showed 100%.
	//	}
	// if the laser sight is on, make this shot dead on
	// also, if the scope is on, zero the accuracy so the shake makes the shot inaccurate
	//else
    if (bLasing || bZoomed)
		Accuracy = 0.0;

	if (Owner.IsA('ScriptedPawn') && !Owner.IsA('Robot')) //CyberP: pawns are slightly innaccurate if player is moving
        Accuracy += PawnAccuracyModifier;

    UpdateRecoilShaker();//GMDX: bung it here, less intrusive

    if (numSlugs > 1 && Owner.IsA('DeusExPlayer'))
    {
    	TempAcc = FMax(0.0,Accuracy - 0.75*SlugSpreadAcc);
    	//TempAcc = FClamp(Accuracy*SlugSpreadAcc,0.1,SlugSpreadAcc);
        EndTraceCenter = StartTrace + TempAcc * (FRand()-0.5)*Y*1000 + TempAcc * (FRand()-0.5)*Z*1000;
		if (MaxRange >= 1024)
    	{
			EndTraceCenter += 4000.0 * vector(AdjustedAim);
    		//EndTraceCenter = (FMax(1024.0, MaxRange)/VSize(EndTraceCenter-StartTrace)*(EndTraceCenter-StartTrace))+StartTrace; //RSD: Extend length of vector to max range (doi!)
    	}
    	TempAcc = FClamp(Accuracy*SlugSpreadAcc,0.1,SlugSpreadAcc);
    }

	for (i=0; i<numSlugs; i++)
	{
	  // If we have multiple slugs, then lower our accuracy a bit after the first slug so the slugs DON'T all go to the same place
	  if ((i > 0) && (Level.NetMode != NM_Standalone) && !(bHandToHand))
		 if (Accuracy < MinSpreadAcc)
			Accuracy = MinSpreadAcc;

	  // Let handtohand weapons have a better swing
	  if ((bHandToHand) && (NumSlugs > 1) && (Level.NetMode != NM_Standalone))
	  {
		 StartTrace = ComputeProjectileStart(X,Y,Z);
		 StartTrace = StartTrace + (numSlugs/2 - i) * SwingOffset;
	  }

      if (bLasing && Emitter != None && !bZoomed)                               //RSD: If we're using a laser but not scoped, shoot at the location of the laser
  	      EndTrace = StartTrace + (FMax(1024.0, MaxRange)*vector(Emitter.Rotation));
      else if (numSlugs > 1 && Owner.IsA('DeusExPlayer'))                       //RSD: If we're using a shotgun, spread slugs from the defined aim center
      {
          EndTrace = EndTraceCenter + TempAcc * (FRand()-0.5)*Y*1000 + TempAcc * (FRand()-0.5)*Z*1000;
          EndTrace = (FMax(1024.0, MaxRange)*Normal(EndTrace-StartTrace))+StartTrace;
      }
      else                                                                      //RSD: Otherwise new standard accuracy routine
      {                                                                         //RSD: Bracketed this else statement entirely so we don't mess around with laser pointed shots
      EndTrace = StartTrace + Accuracy * (FRand()-0.5)*Y*1000 + Accuracy * (FRand()-0.5)*Z*1000;
      //EndTrace = StartTrace + Accuracy * (0.5)*Y*1000;                          //RSD: For testing
	  if (Owner.IsA('DeusExPlayer') && MaxRange >= 1024)
      {
	      EndTrace += 4000.0 * vector(AdjustedAim);                             //RSD: range no longer influences player accuracy (took old pistol range)
          EndTrace = (FMax(1024.0, MaxRange)*Normal(EndTrace-StartTrace))+StartTrace; //RSD: Extend length of vector to max range (doi!)
      }
      /*if ((IsA('WeaponAssaultGun') || IsA('WeaponRifle')) && Owner.IsA('DeusExPlayer'))
	      EndTrace += (FMax(1024.0, MaxRange*0.6) * vector(AdjustedAim));*/     //RSD: original player EndTrace code for AR and snipe
      //RSD: AI should still get improved accuracy from MaxRange
      /*
      else if(IsA('WeaponAssaultGun'))
	      EndTrace += (FMax(1024.0, 2.0*MaxRange) * vector(AdjustedAim));       //RSD: (AR range was halved)
      else if(IsA('WeaponSawedOffShotgun') || IsA('WeaponStealthPistol'))
	      EndTrace += (FMax(1024.0, 1.6*MaxRange) * vector(AdjustedAim));       //RSD: (sawed-off and stealth pistol ranges were cut by 3/8)
      else if(IsA('WeaponPistol'))
	      EndTrace += (FMax(1024.0, 1.1111*MaxRange) * vector(AdjustedAim));    //RSD: (pistol range was cut by 1/10)
      else
	      EndTrace += (FMax(1024.0, 1.3333*MaxRange) * vector(AdjustedAim));    //RSD: (other hitscan weapons were cut by roughly 25%)
      */
      //RSD: Holy shit that's awful, instead let's use the new variables I created to decouple AI weapon range from player weapon range
      else
          EndTrace += (FMax(1024.0, NPCMaxRange) * vector(AdjustedAim));
      }

	  Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);

      //RSD: Stopping Power perk for shotguns
      bDoExtraSlugDamage = false;
      if (numSlugs > 1 && Other != none && Other.IsA('ScriptedPawn') && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkStoppingPower').bPerkObtained == true)
      {
          if (i == 0)
              initialPawnHit = ScriptedPawn(Other);
          if (ScriptedPawn(Other) == initialPawnHit)
              numSlugsHit++;
          if (i == numSlugs-1 && numSlugsHit == numSlugs)
              bDoExtraSlugDamage = true;
      }

		// randomly draw a tracer for relevant ammo types
		// don't draw tracers if we're zoomed in with a scope - looks stupid
	  // DEUS_EX AMSD In multiplayer, draw tracers all the time.
		if ( ((Level.NetMode == NM_Standalone) && (/*!bZoomed && */(numSlugs >= 1) && (FRand() < 0.5))) ||
		   ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority)) )
		{
			if ((AmmoName == Class'Ammo10mm') || (AmmoName == Class'Ammo3006') ||
				(AmmoName == Class'Ammo762mm') || (AmmoName == Class'AmmoShell')) //CyberP: shotguns have tracers
			{
				if (VSize(HitLocation - StartTrace) > 250)
				{
					rot = Rotator(EndTrace - StartTrace);
			   if (Owner.IsA('DeusExPlayer') && AmmoName == Class'Ammo3006')
				  trcr = Spawn(class'SniperTracer',,, StartTrace + 96 * Vector(rot), rot);
			   else
				  trcr = Spawn(class'Tracer',,, StartTrace + 96 * Vector(rot), rot);   //StartTrace + 96 * Vector(rot) //RSD: Added pointer
				  if (bZoomed)                                                  //RSD: Invisible tracers if we're zoomed, woohoo
                  	trcr.DrawType = DT_None;
				}
			}
		}

		// check our range
		dist = Abs(VSize(HitLocation - Owner.Location));

		if (dist <= MaxRange)		// we hit just fine                         //RSD: changed to MaxRange
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		/*else if (dist <= MaxRange)                                            //RSD: fuck that actually just do damage dropoff in ProcessTraceHit
		{
			// simulate gravity by lowering the bullet's hit point
			// based on the owner's distance from the ground
			alpha = (dist - AccurateRange) / (MaxRange - AccurateRange);
			degrade = 0.5 * Square(alpha);
			HitLocation.Z += degrade * (Owner.Location.Z - Owner.CollisionHeight);
			ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		}*/

		//RSD: Hack to destroy glass and trace a new target for shots going "through"
		if (DeusExMover(Other) != none && DeusExMover(Other).bDestroyed)
		{
			moverStartTrace = HitLocation + 8*Normal(EndTrace-StartTrace);       //RSD: Start a little past the mover (6 is minimum necessary to go past, 8 is more reliable)
            Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,moverStartTrace); //RSD: Grab a new target and do it all again (minus Stopping Power perk and tracers)
			dist = Abs(VSize(HitLocation - Owner.Location));
			if (dist <= MaxRange)
				ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
		}

	}

    /*LaserYaw = (currentAccuracy) * (Rand(3072) - 1536);                         //RSD: Reset laser position when firing (75% of cone width)
    LaserPitch = (currentAccuracy) * (Rand(3072) - 1536);*/                       //RSD: Swear to god I didn't mean to copy Shifter here, tried 100% width and it was too much

    //if (IsA('WeaponStealthPistol'))                                             //RSD: Full-auto needs a bit more kick for the laser
    	laserKick = 2.0*recoilStrength;
   	//else laserKick = 1.5*recoilStrength;

	if (AmmoName == Class'AmmoRubber')
	{
        firedProjectile = ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
        OnProjectileFired(firedProjectile);
	}

    LaserYaw += (currentAccuracy*laserKick) * (Rand(4096) - 2048);              //RSD: Bump laser position when firing (75% of cone width)
    LaserPitch += (currentAccuracy*laserKick) * (Rand(4096) - 2048);

	// otherwise we don't hit the target at all
}

simulated function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local float        mult, dist, alpha, rnd;                                  //RSD: added dist, alpha, rnd
	local name         damageType;
	local DeusExPlayer dxPlayer;
	local vector offset, offy; //CyberP
    local Tracer tra;
    local BloodMeleeHit spoofer;
    local GMDXSparkFade faded;
    local int finalDamage;                                                      //RSD

    if (bHandToHand && Owner != None)
    {
      if (Owner.IsInState('Dying'))
           return;             //CyberP: death cancels melee attacks
      else if (Owner.IsA('ScriptedPawn'))
      {
        if (Owner.IsInState('TakingHit')) //CyberP: Pain animation cancels melee attacks
           return;
      }
      else if (Owner.IsA('DeusExPlayer') && AccurateRange < 200)
      {
         DeusExPlayer(Owner).ShakeView(0.1,156+(FRand()*(HitDamage*2)),4);
      }
    }

	if (Other != None)
	{
		// AugCombat increases our damage if hand to hand
		mult = 1.0;
		if (bHandToHand && !bFakeHandToHand && (DeusExPlayer(Owner) != None))
		{
			mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombatStrength');
			if (mult == -1.0)
				mult = 1.0;
			if (DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0)                     //RSD: Zyme gives its own +50% boost
                mult += 0.5;
		}

		// skill also affects our damage
		// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
		mult += -2.0 * GetWeaponSkill() + ModDamage;   //CyberP: damage mod

        mult *= 1.0 - GetAddonPenalty(Silencer);

        //RSD: check our range
        dist = Abs(VSize(HitLocation - Owner.Location));

        if (DeusExPlayer(Owner) != None && dist >= AccurateRange)               //RSD: != none instead of IsA
		{
			//RSD: Linear damage falloff up to MaxRange for the player
            alpha = (dist - AccurateRange) / (MaxRange - AccurateRange);
            mult = (1-alpha)*mult;
            //if (mult*float(HitDamage) < 1.0)
            //	mult = 1.1/float(HitDamage);                                    //RSD: Do at least 1 damage
            if (mult < 0.35)
            	mult = 0.35;                                                    //RSD: or cap falloff at 65% instead
		}

		// Determine damage type
		damageType = WeaponDamageType();

        if (AmmoSabot(ammoType) != none || AmmoRubber(ammoType) != none)                                        //RSD: Since Sabot rounds are slugs now, do 6x damage (18 total) // Trash: Now rubber too!
            {
				if (AmmoSabot(ammoType) != none || AmmoRubber(ammoType) != none)
					mult *= 6.;
				if (IsA('WeaponSawedOffShotgun') && AmmoRubber(ammoType) != none)
					mult *= 1.3;
			}
        if (bDoExtraSlugDamage)                                                 //RSD: Do two slug's worth of extra damage
            mult *= 3.;

        finalDamage = HitDamage*mult;                                           //RSD: multiplication by int HitDamage results in a truncated int
        if (Other.IsA('ScriptedPawn') && FRand() < (float(HitDamage)*mult-finalDamage)) //RSD: So randomly add +1 damage with probability equal to the remainder (0.0-1.0)
            finalDamage++;

		if (Other.IsA('Animal') && Ammo10mm(ammoType) != none &&DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkHollowPoints').bPerkObtained == true)
			finalDamage *= DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkHollowPoints').PerkValue;

        if (DeusExPlayer(Owner) != None) //cyberP: spawn a tracer               //RSD: != none instead of IsA
        {
         //Owner.BroadcastMessage(finalDamage);                                   //RSD: Testing
         if (!bHandToHand)                                                      //RSD: Removed && !bZoomed here so water splashing is intact
         {
          GetAxes(DeusExPlayer(Owner).ViewRotation,X,Y,Z);
		  offset = Owner.Location;
		  offset += X * Owner.CollisionRadius * 1.75;
		  if (DeusExPlayer(Owner).IsCrouching())
		  offset.Z += Owner.CollisionHeight * 0.25;
          else
		  offset.Z += Owner.CollisionHeight * 0.7;
		  offset += Y * Owner.CollisionRadius * 0.65;
          tra= Spawn(class'Tracer',,, offset, (Rotator(HitLocation - offset)));
          if (tra != None && bZoomed) //RSD: Added bZoomed here so we still get a tracer for water splashing
              tra.DrawType = DT_None;
		  }
		}

		if (Other != None)
		{
			if (Other.bOwned)
			{
				dxPlayer = DeusExPlayer(Owner);
				if (dxPlayer != None)
					dxPlayer.AISendEvent('Futz', EAITYPE_Visual);
			}
		}
		if ((Other == Level) || (Other.IsA('Mover')))
		{
			if ( Role == ROLE_Authority )
				Other.TakeDamage(finalDamage, Pawn(Owner), HitLocation, 1000.0*X, damageType); //Replaced HitDamage * mult with finalDamage

			SelectiveSpawnEffects( HitLocation, HitNormal, Other, finalDamage); //Replaced HitDamage * mult with finalDamage

            //SARGE: Drain energy when hitting things
            if (IsA('WeaponNanoSword') && WeaponNanoSword(self).chargeManager != None)
                WeaponNanoSword(self).DrainPower();
		}
		else if ((Other != self) && (Other != Owner))
		{
			if ( Role == ROLE_Authority )
			{
				if (Other.IsA('ScriptedPawn'))                                  //RSD: Putting headshot extraMult stuff here (see DeusExProjectile.uc for projectile weapons)
				{
                	if (IsA('WeaponNanoSword') || IsA('WeaponCrowbar'))
                		ScriptedPawn(Other).extraMult = -2;
               		else if (IsA('WeaponSawedOffShotgun'))
               			ScriptedPawn(Other).extraMult = 1;
 			        else
 			        	ScriptedPawn(Other).extraMult = 0;                      //RSD: pretty sure this was missing from original implementation! Agh!
   	                if (ScriptedPawn(Other).extraMult != 0)                     //RSD: Ensuring that no extraMult is added in edge cases
 			        	ScriptedPawn(Other).bHeadshotAltered = true;
			        else
                    	ScriptedPawn(Other).bHeadshotAltered = false;


                	if (IsA('WeaponProd'))                                      //RSD: Altered stun timer stuff here (see DeusExWeapon.uc for trace weapons)
                	{
                		//ScriptedPawn(Other).stunSleepTime = 15.0;
                		ScriptedPawn(Other).stunSleepTime = 0.5*finalDamage; //RSD: Stun time is 1/3 of damage
                		ScriptedPawn(Other).bStunTimeAltered = true;
                	}
                	else
                	{
                		ScriptedPawn(Other).bStunTimeAltered = false;
                	}
				}
                Other.TakeDamage(finalDamage, Pawn(Owner), HitLocation, 1000.0*X, damageType); //Replaced HitDamage * mult with finalDamage
                
                //SARGE: Drain energy when hitting things
                if (IsA('WeaponNanoSword') && WeaponNanoSword(self).chargeManager != None)
                    WeaponNanoSword(self).DrainPower();
			}
			if (bHandToHand)
				SelectiveSpawnEffects( HitLocation, HitNormal, Other, finalDamage); //Replaced HitDamage * mult with finalDamage
            else if (Other.IsA('DeusExDecoration'))
                 SpawnGMDXEffects(HitLocation, HitNormal);

			if ((bPenetrating || bHandToHand) && Other.IsA('ScriptedPawn') && !Other.IsA('Robot'))
			{
				offy = Other.Location;
				offy.Z += (Other.CollisionHeight * 0.93);
				if (HitLocation.Z > offy.Z && ScriptedPawn(Other).bHasHelmet == True)
                {
                }
                else
                {
				    if (!bHandToHand && !IsA('WeaponProd') && (!IsA('WeaponSawedOffShotgun') || AmmoRubber(ammoType) == none) && !Pawn(Other).IsA('DeusExPlayer') && !Pawn(Other).IsInState('Dying'))
                    {
                        if (ScriptedPawn(Other).bCanBleed)
                        {
                            SpawnBlood(HitLocation, HitNormal);
                            spoofer = Spawn(class'BloodMeleeHit',,,HitLocation);
                        }
                        if (spoofer != none)
                            spoofer.DrawScale= 0.14;
                    }
                    else if (bHandToHand)
					{
                        if (IsA('WeaponNanoSword') || IsA('WeaponCombatKnife') || IsA('WeaponSword') || IsA('WeaponCrowbar'))
                        {
                            if (ScriptedPawn(Other).bCanBleed)
                            {
                                SpawnBlood(HitLocation, HitNormal);
                                spoofer = Spawn(class'BloodMeleeHit',,,HitLocation);
                            }
                        }
					}
				}
			}
            else if (Other.IsA('DeusExCarcass') && !IsA('WeaponProd') && DamageType == 'shot')
           	{
                spoofer = Spawn(class'BloodMeleeHit',,,HitLocation+vect(0,0,1));
           	    if (spoofer != none)
                    spoofer.DrawScale= 0.13;
           	}
		}
	}
	if (DeusExMPGame(Level.Game) != None)
	{
	  if (DeusExPlayer(Other) != None)
		 DeusExMPGame(Level.Game).TrackWeapon(self,HitDamage * mult);
	  else
		 DeusExMPGame(Level.Game).TrackWeapon(self,0);
	}
}

simulated function IdleFunction()
{
	PlayIdleAnim();
	bInProcess = False;
	if ( bFlameOn )
	{
		StopFlame();
		bFlameOn = False;
	}
}

simulated function SimFinish()
{
	ServerGotoFinishFire();

	bInProcess = False;
	bFiring = False;

	if ( bFlameOn )
	{
		StopFlame();
		bFlameOn = False;
	}

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
	{
		if ( (SimClipCount == 0) && CanReload() )
		{
			SimClipCount = Min(AmmoType.AmmoAmount,reloadcount);
			bClientReadyToFire = False;
			bInProcess = False;
			if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
				CycleAmmo();
			ReloadAmmo();
		}
	}

	if (Pawn(Owner) == None)
	{
		GotoState('SimIdle');
		return;
	}
	if ( PlayerPawn(Owner) == None )
	{
		if ( (Pawn(Owner).bFire != 0) && (FRand() < RefireRate) )
			ClientReFire(0);
		else
			GotoState('SimIdle');
		return;
	}
	if ( Pawn(Owner).bFire != 0 )
		ClientReFire(0);
	else
		GotoState('SimIdle');
}

// Finish a firing sequence (ripped off and modified from Engine\Weapon.uc)
function Finish()
{
    //BroadcastMessage("Finish()");
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( True );

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

    if (bBeginQuickMelee)
    {
            bFiring = False;
            if (Owner != None && Owner.IsA('DeusExPlayer'))
            {
               DeusExPlayer(Owner).StopFiring();
               if (quickMeleeCombo > 0)
               {
                 PlaySelect();
                 return;
               }
               //if (DeusExPlayer(Owner).primaryWeapon != None)                 //RSD: Always quickdraw
               //{
                  if (AccurateRange > 200)
                      Buoyancy=5.123456;
                  if (bHandToHand && (ReloadCount > 0) && (AmmoType.AmmoAmount <= 0))
                  {
                     bBeginQuickMelee = False;
				     DestroyMe();
				     return;
				  }
                  if (DeusExPlayer(Owner).CarriedDecoration == None)
                     DeusExPlayer(Owner).SelectLastWeapon(true);
                  GotoState('Idle');
                  return;
               //}
            }
    }

	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}

	if (( Level.NetMode != NM_Standalone ) && IsInState('Active'))
	{
		GotoState('Idle');
		return;
	}

	if (Pawn(Owner) == None)
	{
		GotoState('Idle');
		return;
	}
	if ( PlayerPawn(Owner) == None )
	{
		//bFireMem = false;
		//bAltFireMem = false;
		if ( ((AmmoType==None) || (AmmoType.AmmoAmount<=0)) && ReloadCount!=0 )
		{
			Pawn(Owner).StopFiring();
			Pawn(Owner).SwitchToBestWeapon();
		}
		else if ( (Pawn(Owner).bFire != 0) && (FRand() < RefireRate) )
			Global.Fire(0);
		else if ( (Pawn(Owner).bAltFire != 0) && (FRand() < AltRefireRate) )
			Global.AltFire(0);
		else
		{
			Pawn(Owner).StopFiring();
			GotoState('Idle');
		}
		return;
	}

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
		GotoState('Idle');
		return;
	}

	if ( (((AmmoType==None) || (AmmoType.AmmoAmount<=0)) && !bHandtoHand) || (Pawn(Owner).Weapon != self) ) //RSD: added bHandtoHand check for continuous hold-to-fire
		GotoState('Idle');
	else if ( /*bFireMem ||*/ Pawn(Owner).bFire!=0 )
	{
	  //if (DeusExPlayer(Owner)!=none) damn can 'other', not player/scripted fire!?
	  if (DeusExPlayer(Owner)!=None && (bFullAuto || (bHandtoHand && AmmoName==Class'DeusEx.AmmoNone')))  //CyberP: full auto //RSD: added bHandtoHand check for continuous hold-to-fire
	  Global.Fire(0);
	  else
	  GotoState('Idle'); //CyberP: click to stab satisfaction
	  //   else Global.Fire(0);
	}
	else if ( /*bAltFireMem ||*/ Pawn(Owner).bAltFire!=0 )
		GotoState('Idle'); //GMDX you got no semi-auto biatch >:)
	  //Global.AltFire(0);
	else
		GotoState('Idle');
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

//Do the Ammo Display in the Inventory Window
function string DoAmmoInfoWindow(Pawn P, PersonaInventoryInfoWindow winInfo)
{
	local bool bAmmoAvailable;
	local class<DeusExAmmo> ammoClass;
	local Ammo weaponAmmo;
	local int  ammoAmount;
	local bool bHasAmmo;
	local string str;
    local int i;
	local float hh;
    local DeusExPlayer player;
    local string noiseLev, msgMultiplier;
    local float prec;                                                           //RSD: Floating point precision

	// Create the ammo buttons.  Start with the AmmoNames[] array,
	// which is used for weapons that can use more than one
	// type of ammo.

	if (AmmoNames[0] != None)
	{
		for (i=0; i<ArrayCount(AmmoNames); i++)
		{
			if (AmmoNames[i] != None)
			{
				// Check to make sure the player has this ammo type
				// *and* that the ammo isn't empty
				weaponAmmo = Ammo(P.FindInventoryType(AmmoNames[i]));

				if (weaponAmmo != None)
				{
					ammoAmount = weaponAmmo.AmmoAmount;
					bHasAmmo = (weaponAmmo.AmmoAmount > 0);
				}
				else
				{
					ammoAmount = 0;
					bHasAmmo = False;
				}

				winInfo.AddAmmo(AmmoNames[i], bHasAmmo, ammoAmount);
				bAmmoAvailable = True;

				if (AmmoNames[i] == AmmoName)
				{
                    winInfo.SetLoaded(AmmoName, true);                          //RSD: Added bAmmoSelectWait hack
					ammoClass = class<DeusExAmmo>(AmmoName);
				}
			}
		}
	}
	else
	{
		// Now peer at the AmmoName variable, but only if the AmmoNames[]
		// array is empty
		if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		{
			weaponAmmo = Ammo(P.FindInventoryType(AmmoName));

			if (weaponAmmo != None)
			{
				ammoAmount = weaponAmmo.AmmoAmount;
				bHasAmmo = (weaponAmmo.AmmoAmount > 0);
			}
			else
			{
				ammoAmount = 0;
				bHasAmmo = False;
			}

			winInfo.AddAmmo(AmmoName, bHasAmmo, ammoAmount);
			winInfo.SetLoaded(AmmoName, true);                                  //RSD: Added true hack
			ammoClass = class<DeusExAmmo>(AmmoName);
			bAmmoAvailable = True;
		}
	}

	// If this weapon has ammo info, display it here
    /*
	if (ammoClass != None)
	{
		winInfo.AddLine();
		winInfo.AddAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);
	}
    */

	// Only draw another line if we actually displayed ammo.
	if (bAmmoAvailable)
		winInfo.AddLine();

	// Ammo loaded
	if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		winInfo.AddAmmoLoadedItem(msgInfoAmmoLoaded, AmmoType.itemName);

	// ammo info
	if ((AmmoName == class'AmmoNone') || (ReloadCount == 0))
		str = msgInfoNA;
	else
		str = AmmoName.Default.ItemName;
	for (i=0; i<ArrayCount(AmmoNames); i++)
		if ((AmmoNames[i] != None) && (AmmoNames[i] != AmmoName))
			str = str $ "|n" $ AmmoNames[i].Default.ItemName;
    if (!bHandToHand || IsA('WeaponProd'))
	winInfo.AddAmmoTypesItem(msgInfoAmmo, str);
}

//SARGE: TODO: Turn this horrible mess into generic functions that work with child classes
simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInventoryInfoWindow winInfo;
	local string str;
	local int dmg, numMods;
	local float mod, stamDrain;
	local Pawn P;
	local float hh;
    local DeusExPlayer player;
    local string noiseLev, msgMultiplier;
    local float prec;                                                           //RSD: Floating point precision
    local float vol,rad;                                                        //SARGE: Added

	P = Pawn(Owner);
	if (P == None)
		return False;

	winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return False;
    
    //SARGE: Show modified weapons in title
    if (bModified && DeusExPlayer(owner) != None && DeusExPlayer(owner).bBeltShowModified)
        winInfo.SetTitle(itemName @ "(" $ strModified $ ")");
    else
        winInfo.SetTitle(itemName);

    //SARGE: Add Decline Button
    if (P.IsA('DeusExPlayer'))
		winInfo.AddDeclineButton(class);

	if (bHandToHand && Owner.IsA('DeusExPlayer'))
	{
	   if (DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkInventive').bPerkObtained == true)
	   {
	      winInfo.AddSecondaryButton(self);
	   }
	   else if (GoverningSkill != class'DeusEx.SkillDemolition' && !IsA('WeaponCombatKnife') && !IsA('WeaponHideAGun') && !IsA('WeaponShuriken'))
	   {                                                                        //RSD: Throwing Knives now require the perk, c'mon //RSD: Or nah
	   }
	   else
	       winInfo.AddSecondaryButton(self);
	}

	winInfo.SetText(msgInfoWeaponStats);
	winInfo.AddLine();

    DoAmmoInfoWindow(P,winInfo);

	// base damage
	if (AreaOfEffect == AOE_Cone)
	{
		if (bInstantHit)
		{
			if (Level.NetMode != NM_Standalone)
				dmg = Default.mpHitDamage * 5;
			else
				dmg = Default.HitDamage;
		}
		else
		{
			if (Level.NetMode != NM_Standalone)
				dmg = Default.mpHitDamage * 3;
			else
                dmg = Default.HitDamage;
		}
	}
	else
	{
		if (Level.NetMode != NM_Standalone)
			dmg = Default.mpHitDamage;
		else
			dmg = Default.HitDamage;
	}
	if (AmmoName != None)                                                       //RSD: Gotta totally rework this stuff
    {
        if (AmmoName == class'AmmoDartPoison')
            dmg = 15;
        else if (AmmoName == class'AmmoDart')
            dmg = 18;
        else if (AmmoName == class'AmmoDartFlare')
            dmg = 7;
        else if (AmmoName == class'AmmoDartTaser')
            dmg = 10;                                                           //RSD Was 15
        else if (AmmoName == class'Ammo20mm')
            dmg = 200;
        else if (AmmoName == class'AmmoRocketWP')
            dmg = 50;
        else if (Ammoname == class'AmmoSabot')                                  //RSD: Sabot are now slug rounds
            dmg = 18;
        else if (AmmoName == class'AmmoRubber')
            dmg = 18;                                                           //RSD Was 12 (actually 13/19)
    }
    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AugmentationSystem != none) //RSD: accessed none?
        hh = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombatStrength');
	str = String(dmg);
	if (AreaOfEffect == AOE_Cone)                                               //RSD: Tell us if we're using a multi-slug weapon
	{
		if (isA('WeaponSawedOffShotgun') && AmmoName!=class'AmmoSabot' && AmmoName!=class'AmmoRubber')
			str = str $ "x9";
        else if (bInstantHit && AmmoName!=class'AmmoSabot' && AmmoName!=class'AmmoRubber')
			str = str $ "x8";
		else if (!bInstantHit && AmmoName!=class'AmmoRubber')
			str = str $ "x3";
	}

    if (hh < 1.0)
    	hh = 0.0;
    /*else if (hh == 1.250000)                                                  //RSD: How about no, WTF
    hh = 0.25;
    else if (hh == 1.500000)
    hh = 0.5;
    else if (hh == 1.750000)
    hh = 0.75;
    else if (hh == 2.000000)
    hh = 1.0;*/
    else
    	hh -= 1.0;                                                              //RSD: Simple formula! Wow!

    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost, accessed none?
    	hh += 0.5;

	//G-Flex: display the correct damage bonus
	mod = 1.0 - (2.0 * GetWeaponSkill()) + ModDamage;  //CyberP: damage mods
    mod *= 1.0 - GetAddonPenalty(Silencer);
	if (IsA('WeaponSawedoffShotgun') && AmmoName==class'AmmoRubber')            //RSD: Sawed-off gets +30% damage on rubber bullets
	   mod += 0.30;
	if (bHandToHand)
       mod = 1.0 - (2.0 * GetWeaponSkill()) + hh;
	if (IsA('WeaponNanoSword'))                                                 //RSD: Can mod damage of DTS now
       mod = 1.0 - (2.0 * GetWeaponSkill()) + hh + ModDamage;
    if (mod != 1.0 || HasDAMMod())
	{
		str = str @ BuildPercentString(mod - 1.0);
		if (float(dmg)*mod-int(dmg*mod) >= 0.1)                                 //RSD: Print more decimals if there's roundoff
			prec = 0.1;
		else
		    prec = 1.0;
		str = str @ "=" @ FormatFloatString(float(dmg) * mod, prec);            //RSD: Now float with 0.1 precision because damage increases are now distributed continously

		if (AreaOfEffect == AOE_Cone)                                               //RSD: Tell us if we're using a multi-slug weapon
		{
			if (isA('WeaponSawedOffShotgun') && AmmoName!=class'AmmoSabot' && AmmoName!=class'AmmoRubber')
				str = str $ "x9";
			else if (bInstantHit && AmmoName!=class'AmmoSabot' && AmmoName!=class'AmmoRubber')
				str = str $ "x8";
			else if (!bInstantHit && AmmoName!=class'AmmoRubber')
				str = str $ "x3";
		}
	}

    winInfo.AddInfoItem(msgInfoDamage, str, (mod != 1.0));

    //Headshot multiplier
    str = "x8";
    if (IsA('WeaponProd') || IsA('WeaponBaton') || AmmoName==class'AmmoRubber') //RSD: Moved to top of branch so Rubber Bullets dominate Sawed-Off Shotgun
    str = "x5";
    else if (ItemName == "USP.10" || IsA('WeaponSawedOffShotgun') || IsA('WeaponShuriken')) //RSD: Added WeaponShuriken
    str = "x9";
    else if (IsA('WeaponNanoSword') || IsA('WeaponCrowbar'))
    str = "x6";

    if (!IsA('WeaponPepperGun'))
    winInfo.AddInfoItem(msgHeadMultiplier, str);
	// clip size
	if ((Default.ReloadCount == 0) || bHandToHand)
		str = msgInfoNA;
	else
	{
		if ( Level.NetMode != NM_Standalone )
			str = Default.mpReloadCount @ msgInfoRounds;
		else
			str = Default.ReloadCount @ msgInfoRounds;
	}

	if (HasClipMod())
	{
		str = str @ BuildPercentString(ModReloadCount);
		str = str @ "=" @ ReloadCount @ msgInfoRounds;
	}
    if (!bHandToHand || IsA('WeaponProd') || IsA('WeaponPepperGun'))
	winInfo.AddInfoItem(msgInfoClip, str, HasClipMod());

	// rate of fire
	if ((Default.ReloadCount == 0) || bHandToHand)
	{
		str = msgInfoNA;
	}
	else
	{
		if (bAutomatic || bFullAuto)
			str = msgInfoAuto;
		else
			str = msgInfoSingle;

		str = str $ "," @ FormatFloatString(1.0/Default.ShotTime, 0.1) @ msgInfoRoundsPerSec;
		if(HasROFMod())
		{
			str = str @ BuildPercentString(-ModShotTime);                       //RSD: negative because we subtract ShotTime, but display ROF... numbers are a lie!
			str = str @ "=" @ FormatFloatString(1.0/ShotTime, 0.1) @ msgInfoRoundsPerSec;
		}
	}
	if (!bHandToHand || IsA('WeaponProd'))
	winInfo.AddInfoItem(msgInfoROF, str, HasROFMod());

	// reload time
	if ((Default.ReloadCount == 0) || bHandToHand)
		str = msgInfoNA;
	else
	{
        mod = 0.0;
		if (Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpReloadTime, 0.1) @ msgTimeUnit;
		else if (bPerShellReload)
			str = FormatFloatString(1 / Default.ReloadTime, 0.1) @ msgInfoRoundsPerSec;
		else
			str = FormatFloatString(Default.ReloadTime, 0.1) @ msgTimeUnit;
	}

    mod = GetAddonPenalty(Scope); //SARGE: Penalties for addons
	if (HasReloadMod() || mod > 0.0)
	{
		str = str @ BuildPercentString(ModReloadTime + mod);
		if (bPerShellReload)
			str = str @ "=" @ FormatFloatString(1 / (ReloadTime + mod), 0.1) @ msgInfoRoundsPerSec;
		else
            str = str @ "=" @ FormatFloatString(ReloadTime + mod, 0.1) @ msgTimeUnit;
	}
    if (!bHandToHand || IsA('WeaponPepperGun') || IsA('WeaponProd'))
	winInfo.AddInfoItem(msgInfoReload, str, HasReloadMod() || mod >= 0.01);

	// recoil
    mod = GetAddonPenalty(Scope); //SARGE: Penalties for addons
	str = FormatFloatString(Default.recoilStrength, 0.01);
	if (HasRecoilMod() || mod > 0.0)
	{
		str = str @ BuildPercentString(ModRecoilStrength + mod);
		str = str @ "=" @ FormatFloatString(recoilStrength + mod, 0.01);
	}
    if (!bHandToHand)
	winInfo.AddInfoItem(msgInfoRecoil, str, HasRecoilMod() || mod > 0.0);

	// base accuracy (2.0 = 0%, 0.0 = 100%)
	if ( Level.NetMode != NM_Standalone )
	{
		str = Int((2.0 - Default.mpBaseAccuracy)*50.0) $ "%";
		mod = (Default.mpBaseAccuracy - (BaseAccuracy + GetWeaponSkill())) * 0.5;
        mod -= GetAddonPenalty(Silencer);
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - Default.mpBaseAccuracy)*50.0)) $ "%";
		}
	}
	else
	{
		str = Int((2.0 - Default.BaseAccuracy)*50.0) $ "%";
		mod = (Default.BaseAccuracy - (BaseAccuracy + GetWeaponSkill())) * 0.5;
        mod -= GetAddonPenalty(Silencer);

		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - Default.BaseAccuracy)*50.0)) $ "%";
		}
	}
	if (!bHandToHand || IsA('WeaponProd') || IsA('WeaponShuriken') || GoverningSkill == class'DeusEx.SkillDemolition')
	winInfo.AddInfoItem(msgInfoAccuracy, str, (mod != 0.0));

	// accurate range
	//if (bHandToHand)
	//	str = msgInfoNA;
	//else
	//{
		if ( Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpAccurateRange/16.0, 1.0) @ msgRangeUnit;
		else
			str = FormatFloatString(Default.AccurateRange/16.0, 1.0) @ msgRangeUnit;
	//}

	if (HasRangeMod())
	{
		str = str @ BuildPercentString(ModAccurateRange);
		str = str @ "=" @ FormatFloatString(AccurateRange/16.0, 1.0) @ msgRangeUnit;
	}
	if (!bHandToHand || IsA('WeaponShuriken'))
	winInfo.AddInfoItem(msgInfoAccRange, str, HasRangeMod());

	// max range
	//if (bHandToHand)
	//	str = msgInfoNA;
	//else
	//{
		if ( Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpMaxRange/16.0, 1.0) @ msgRangeUnit;
		else
			str = FormatFloatString(Default.MaxRange/16.0, 1.0) @ msgRangeUnit;
	//}
	if (HasRangeMod())                                                          //RSD: Added because we can now mod MaxRange
	{
		str = str @ BuildPercentString(ModAccurateRange);
		str = str @ "=" @ FormatFloatString(MaxRange/16.0, 1.0) @ msgRangeUnit;
	}
	winInfo.AddInfoItem(msgInfoMaxRange, str,HasRangeMod());                    //RSD: Added HasRangeMod()

	//Noise level
	if (!bHandToHand || IsA('WeaponProd') || IsA('WeaponHideAGun') || IsA('WeaponPepperGun') || IsA('WeaponLAW'))
	{
	noiseLev="dB";

    //SARGE: Now we just read it's actual noise level, rather than this dumb bullshit

    GetAIVolume(vol,rad);
    if (vol == 0)
        vol = 1;
	winInfo.AddInfoItem(msgNoise,FormatFloatString(vol * 30,1.0) @ noiseLev);
    /*
	  if (bHasSilencer)
      {
         str = "1.0";                                                           //RSD: Was 0.5
         winInfo.AddInfoItem(msgNoise,str @ noiseLev);
      }
      else
	winInfo.AddInfoItem(msgNoise,FormatFloatString(NoiseLevel * 10,1.0) @ noiseLev); //SARGE: Multiplied by 10
    */
    }

    if (meleeStaminaDrain != 0 && !IsA('WeaponShuriken'))  //CyberP: display special, speed rating & stamina drain
    {
    player = DeusExPlayer(GetPlayerPawn());
		mod = player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
        if (mod < 3)
          mod = 1;
        else
          mod = 0.5;

    if (IsA('WeaponSword'))
    {
      str = msgSpec;
      if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
         msgMultiplier = msgModerate;
      else
         msgMultiplier = msgFast;
      stamDrain = meleeStaminaDrain*mod;
    }
    else if (IsA('WeaponCrowbar'))
    {
      str = msgSpec;
      if (player.AugmentationSystem != none && player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
         msgMultiplier = msgFast;
      else
         msgMultiplier = msgVeryFast;
      stamDrain = meleeStaminaDrain*mod;
    }
    else if (IsA('WeaponBaton'))
    {
      str = msgSpec;
      if (player.AugmentationSystem != none && player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
         msgMultiplier = msgSlow;
      else
         msgMultiplier = msgModerate;
      stamDrain = meleeStaminaDrain*mod;
    }
    else if (IsA('WeaponCombatKnife'))
    {
      str = msgSpec;
      if (player.AugmentationSystem != none && player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
         msgMultiplier = msgFast;
      else
         msgMultiplier = msgVeryFast;
      stamDrain = meleeStaminaDrain*mod;
    }
    else if (IsA('WeaponNanoSword'))
    {
      str = msgSpec;
      if (player.AugmentationSystem != none && player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
         msgMultiplier = msgModerate;
      else
         msgMultiplier = msgFast;
      stamDrain = meleeStaminaDrain*mod;
    }
    if (player.AugmentationSystem != none && player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
         winInfo.AddInfoItem(msgSpeedR,msgMultiplier,false);
    else
         winInfo.AddInfoItem(msgSpeedR,msgMultiplier,true);
    if (mod != 1)
        winInfo.AddInfoItem(msgStamDrain, FormatFloatString(stamDrain,0.01), true);
    else
        winInfo.AddInfoItem(msgStamDrain, FormatFloatString(stamDrain,0.01), false);
    winInfo.AddInfoItem(msgSpec2,str);
    }

	// mass
	winInfo.AddInfoItem(msgInfoMass, FormatFloatString(Default.Mass, 1.0) @ msgMassUnit);

	// laser mod
	if (bCanHaveLaser)
	{
		if (bHasLaser)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	if (!bHandToHand)
	winInfo.AddInfoItem(msgInfoLaser, str, bCanHaveLaser && bHasLaser && (Default.bHasLaser != bHasLaser));

	// scope mod
	if (bCanHaveScope)
	{
		if (bHasScope)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	if (!bHandToHand)
	winInfo.AddInfoItem(msgInfoScope, str, bCanHaveScope && bHasScope && (Default.bHasScope != bHasScope));

	// silencer mod
	if (bCanHaveSilencer)
	{
		if (bHasSilencer)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	if (!bHandToHand)
	winInfo.AddInfoItem(msgInfoSilencer, str, bCanHaveSilencer && bHasSilencer && (Default.bHasSilencer != bHasSilencer));

    //CyberP: full-auto mod
    if (!bHandToHand)
    {
    if (IsA('WeaponSawedOffShotgun'))
    {
            str = msgSpec;
            winInfo.AddInfoItem(msgSpec2,str);
			str = msgPump;
    }
	else if (bFullAuto || bAutomatic)
	{
			str = msgFull;
	}
	else
	{
	       str = msgSemi;
	}
	winInfo.AddInfoItem(msgInfoFullAuto, str, bCanHaveModFullAuto && bFullAuto && (Default.bFullAuto != bFullAuto));
    }
    //Lethality
    if (IsA('WeaponMiniCrossbow') || IsA('WeaponSawedOffShotgun') || IsA('WeaponAssaultShotgun'))
    str= msgVar;
    else if (bPenetrating || IsA('WeaponCrowbar'))
    str= msgLethal;
    else
    str= msgNon;
    winInfo.AddInfoItem(msgLethality, str);

    //secondary weapon
    if (bHandToHand && DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkInventive').bPerkObtained == true)
       str = msgInfoYes;
    else if (bHandToHand && GoverningSkill != class'DeusEx.SkillDemolition' && !IsA('WeaponHideAGun') && !IsA('WeaponShuriken'))
       str = msgInfoNo;
    else if (bHandToHand)
       str = msgInfoYes;
    else
       str = msgInfoNo;
    winInfo.AddInfoItem(msgSecondary, str);

	// Governing Skill
    //SARGE: Also Weapon requirement
    if (minSkillRequirement > 0 && DeusExPlayer(Owner) != None && DeusExPlayer(Owner).bWeaponRequirementsMatter)
        winInfo.AddInfoItem(msgInfoSkill, GoverningSkill.default.SkillName @ "(" $ msgRequires @  DeusExPlayer(Owner).SkillSystem.GetSkillFromClass(GoverningSkill).GetLevelString(minSkillRequirement) $ ")");
    else
        winInfo.AddInfoItem(msgInfoSkill, GoverningSkill.default.SkillName);

    if (bCanHaveModBaseAccuracy || bCanHaveModReloadCount || bCanHaveModAccurateRange || bCanHaveModReloadTime || bCanHaveModRecoilStrength || bCanHaveModShotTime || bCanHaveModDamage)
        {
            winInfo.AddLine();
            winInfo.SetText(msgAllMods);
            winInfo.AddLine();

                if (bCanHaveModReloadCount)
                {
                        numMods = Int(Abs(ModReloadCount) * 10);
                        if (IsA('WeaponProd'))
                            winInfo.AddModInfo(msgClip, numMods, (numMods == 4), 1);
                        else
                            winInfo.AddModInfo(msgClip, numMods, (numMods == 5));
                }

                if (bCanHaveModShotTime)
                {
                        numMods = Int(Abs(ModShotTime) * 10);
                        //winInfo.AddInfoItem("Rate of Fire:", numMods $ "/5", (numMods == 5));
                        if (IsA('WeaponAssaultGun'))
                            winInfo.AddModInfo(msgRate, numMods, (numMods == 3), 2);
                        else
                            winInfo.AddModInfo(msgRate, numMods, (numMods == 5));
                }

                if (bCanHaveModReloadTime)
                {
                        numMods = Int(Abs(ModReloadTime) * 10);
                        //winInfo.AddInfoItem("Reload:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo(msgRelo, numMods, (numMods == 5));
                }

                if (bCanHaveModDamage)
                {
                        numMods = Int(Abs(ModDamage) * 10);
                        winInfo.AddModInfo(msgDama, numMods, (numMods == 5));
                }

                if (bCanHaveModRecoilStrength)
                {
                        numMods = Int(Abs(ModRecoilStrength) * 10);
                        //winInfo.AddInfoItem("Recoil:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo(msgReco, numMods, (numMods == 5));
                }

                if (bCanHaveModBaseAccuracy)
                {
                        numMods = Int(Abs(ModBaseAccuracy) * 10);
                        if (IsA('WeaponSawedOffShotgun'))
                            winInfo.AddModInfo(msgAccu, numMods, (numMods == 2), 3);
                        else
                            winInfo.AddModInfo(msgAccu, numMods, (numMods == 5));
                }

                if (bCanHaveModAccurateRange)
                {
                        numMods = Int(Abs(ModAccurateRange) * 10);
                        //winInfo.AddInfoItem("Range:", numMods $ "/5", (numMods == 5));
                        winInfo.AddModInfo(msgRang, numMods, (numMods == 5));
                }
                if (bCanHaveScope) //CyberP: uncomment to add scope, laser, silencer and full-auto for extra fun
                {
                if (bHasScope)
                    winInfo.AddModInfo(msgInfoScope, 1, (numMods == 1), 4);
                else
                    winInfo.AddModInfo(msgInfoScope, 0, (numMods == 1), 4);
                }
                if (bCanHaveLaser)
                {
	            if (bHasLaser)
	         	    winInfo.AddModInfo(msgInfoLaser, 1, (numMods == 1), 4);
                else
                    winInfo.AddModInfo(msgInfoLaser, 0, (numMods == 1), 4);
                }
                if (bCanHaveSilencer)
                {
	            if (bHasSilencer)
	         	    winInfo.AddModInfo(msgInfoSilencer, 1, (numMods == 1), 4);
                else
                    winInfo.AddModInfo(msgInfoSilencer, 0, (numMods == 1), 4);
                }
                if (bCanHaveModFullAuto)
                {
	            if (bFullAuto)
	         	    winInfo.AddModInfo(msgInfoFullAuto, 1, (numMods == 1), 4);
                else
                    winInfo.AddModInfo(msgInfoFullAuto, 0, (numMods == 1), 4);
                }
         }
    if (bHadLaser || bHadSilencer || bHadScope)
    {
        winInfo.AddLine();
        winInfo.AddWeaponModButtons(self);
        winInfo.AddWeaponModDrawbacks(self);
    }
	winInfo.AddLine();
	winInfo.SetText(Description);

	return True;
}

// ----------------------------------------------------------------------
// UpdateAmmoInfo()
// ----------------------------------------------------------------------

simulated function UpdateAmmoInfo(Object winObject, Class<DeusExAmmo> ammoClass)
{
	local PersonaInventoryInfoWindow winInfo;
	local string str;
	local int i;

	winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return;

	// Ammo loaded
	if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		winInfo.UpdateAmmoLoaded(AmmoType.itemName);

	// ammo info
	if ((AmmoName == class'AmmoNone') || bHandToHand || (ReloadCount == 0))
		str = msgInfoNA;
	else
		str = AmmoName.Default.ItemName;
	for (i=0; i<ArrayCount(AmmoNames); i++)
		if ((AmmoNames[i] != None) && (AmmoNames[i] != AmmoName))
			str = str $ "|n" $ AmmoNames[i].Default.ItemName;

	winInfo.UpdateAmmoTypes(str);

	// If this weapon has ammo info, display it here
	if (ammoClass != None)
		winInfo.UpdateAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);
}

// ----------------------------------------------------------------------
// BuildPercentString()
// ----------------------------------------------------------------------

simulated final function String BuildPercentString(Float value)
{
	local string str;

	str = String(Int(Abs(value * 100.0)+0.5));                                  //RSD: Added 0.5 for proper rounding
	if (value < 0.0)
		str = "-" $ str;
	else
		str = "+" $ str;

	return ("(" $ str $ "%)");
}

// ----------------------------------------------------------------------
// FormatFloatString()
// ----------------------------------------------------------------------

simulated function String FormatFloatString(float value, float precision)
{
	local string str, numstr;                                                   //RSD: Added numstr
    local int i;                                                                //RSD

	if (precision == 0.0)
		return "ERR";

	// build integer part
	str = String(Int(value));

	// build decimal part
	if (precision < 1.0)
	{
		value += 0.5*precision;                                                 //RSD: Pre-round the value so we don't get e.g. 1.998 -> 1.10 with precision=0.01, but only for non-int values!
		str = String(Int(value));                                               //RSD: Redo this so we don't lose the base from truncation
        value -= Int(value);
		//str = str $ "." $ String(Int((0.5 * precision) + value * (1.0 / precision)));
		//RSD: Rest of this is to fix tenths etc. places being lost when equal to 0 for higher precision e.g. 1.05 -> 1.5
		numstr = String(Int(value * (1.0 / precision)));
        str = str $ ".";
        for (i=0;i<int(Loge(1.0/precision)/Loge(10.))-Len(numstr);i++)
        {
        	str = str $ '0';
        }
		str = str $ numstr;
	}

	return str;
}

// ----------------------------------------------------------------------
// CR()
// ----------------------------------------------------------------------

simulated function String CR()
{
	return Chr(13) $ Chr(10);
}

// ----------------------------------------------------------------------
// HasReloadMod()
// ----------------------------------------------------------------------

simulated function bool HasReloadMod()
{
	return (ModReloadTime != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxReloadMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxReloadMod()
{
	return (ModReloadTime == -0.5);
}

// ----------------------------------------------------------------------
// HasClipMod()
// ----------------------------------------------------------------------

simulated function bool HasClipMod()
{
	return (ModReloadCount != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxClipMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxClipMod()
{
    if (IsA('WeaponProd'))
        return (ModReloadCount == 0.4);
    else
	    return (ModReloadCount == 0.5);
}

// ----------------------------------------------------------------------
// HasRangeMod()
// ----------------------------------------------------------------------

simulated function bool HasRangeMod()
{
	return (ModAccurateRange != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxRangeMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxRangeMod()
{
	return (ModAccurateRange == 0.5);
}

// ----------------------------------------------------------------------
// HasAccuracyMod()
// ----------------------------------------------------------------------

simulated function bool HasAccuracyMod()
{
	return (ModBaseAccuracy != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxAccuracyMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxAccuracyMod()
{
    if (IsA('WeaponSawedOffShotgun'))
        return (ModBaseAccuracy == 0.2);
    else
	    return (ModBaseAccuracy == 0.5);
}

// ----------------------------------------------------------------------
// HasRecoilMod()
// ----------------------------------------------------------------------

simulated function bool HasRecoilMod()
{
	return (ModRecoilStrength != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxRecoilMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxRecoilMod()
{
	return (ModRecoilStrength == -0.5);
}

// ----------------------------------------------------------------------
// HasROFMod()
// ----------------------------------------------------------------------

simulated function bool HasROFMod()
{
	return (ModShotTime != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxROFMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxROFMod()
{
    if (IsA('WeaponAssaultGun'))
        return (ModShotTime == -0.3);
    else
	    return (ModShotTime == -0.5);
}

// ----------------------------------------------------------------------
// HasDAMMod()
// ----------------------------------------------------------------------

simulated function bool HasDAMMod()
{
	return (ModDamage != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxDAMMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxDAMMod()
{
    return (ModDamage == 0.5);
}
// ----------------------------------------------------------------------
// ClientDownWeapon()
// ----------------------------------------------------------------------

simulated function ClientDownWeapon()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimDownWeapon');
}

simulated function ClientActive()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimActive');
}

simulated function ClientReload()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimReload');
}

exec function UpdateHDTPsettings()
{
    local int slot;

    //DeusExPlayer(GetPlayerPawn()).ClientMessage("UpdateHDTP Settings");

    Skin = default.Skin;
    Texture = default.Texture;
    largeIconUnrot = default.largeIcon;

    if (HDTPLargeIcon != "")
        LargeIconUnrot = class'HDTPLoader'.static.GetTexture2(HDTPLargeIcon,string(default.LargeIcon),IsHDTP());
    if (HDTPLargeIconRot != "")
        LargeIconRot = class'HDTPLoader'.static.GetTexture2(HDTPLargeIconRot,string(default.LargeIconRot),IsHDTP());
    if (HDTPIcon != "")
        Icon = class'HDTPLoader'.static.GetTexture2(HDTPIcon,string(default.Icon),IsHDTP());
    if (HDTPPlayerViewMesh != "")
        PlayerViewMesh = class'HDTPLoader'.static.GetMesh2(HDTPPlayerViewMesh,string(default.PlayerViewMesh),IsHDTP());
    if (HDTPPickupViewMesh != "")
        PickupViewMesh = class'HDTPLoader'.static.GetMesh2(HDTPPickupViewMesh,string(default.PickupViewMesh),isHDTP());
    if (HDTPThirdPersonMesh != "")
        ThirdPersonMesh = class'HDTPLoader'.static.GetMesh2(HDTPThirdPersonMesh,string(default.ThirdPersonMesh),IsHDTP());
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());
    if (HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),IsHDTP());

    if (bCarriedItem)
        Mesh = PlayerViewMesh;
    else
        Mesh = PickupViewMesh;
    
    for (slot = 0; slot < 8;slot++)
    {
        //if (slot != MuzzleSlot || !overlay)
            if (IsHDTP())
                multiskins[slot] = none;
            else
                multiskins[slot] = default.multiskins[slot];
    }

    SetWeaponHandTex();
    UpdateLargeIcon();
    CheckWeaponSkins();
    if (Owner != None && Owner.IsA('DeusExPlayer'))
        DoWeaponOffset(DeusExPlayer(Owner));
}

//
// weapon states
//

state NormalFire
{
	function AnimEnd()
	{
		if (bAutomatic)
		{
		    //BroadcastMessage("AnimEnd()");
		    if (IsA('ScopedAssaultGun') && !bFullAuto)
		       burstTimer = 0.3 + (modShotTime*0.6);
		    //if (IsA('WeaponFlamethrower'))
		      // if (Owner.IsA('DeusExPlayer'))
	            //  DeusExPlayer(Owner).UpdateSensitivity(DeusExPlayer(Owner).default.MouseSensitivity);
			if ((Pawn(Owner).bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
				{
				    if (!IsA('ScopedAssaultGun'))
					   Global.Fire(0);
					else if (bFullAuto)
					   Global.Fire(0);
                    else
                       GotoState('FinishFire');
				}
				else
					GotoState('FinishFire');
			}
			else
				GotoState('FinishFire');
		}
		else
		{
			// if we are a thrown weapon and we run out of ammo, destroy the weapon
			if (bHandToHand && (ReloadCount > 0) && (AmmoType.AmmoAmount <= 0))
			{
				DestroyMe();
			}
		}
	}
	function float GetShotTime()
	{
		local float mult, sTime;

		if (Owner.IsA('ScriptedPawn'))
		{
			if (IsA('WeaponStealthPistol'))                                     //RSD: hack AI to shoot much faster with the stealth pistol
				mult = 0.5;
            else
            	mult = 1.0;
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1) * mult;    //RSD: added mult
		}
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				/*mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat'); //RSD: reworked for greater generality
				if (mult == -1.0)
					mult = 1.0;*/
				mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
				if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost
                    mult += 0.5;
                mult = 1.0/mult;
			}
			//if (IsA('WeaponAssaultGun'))
			//	mult = 0.800000;                                                //RSD: 3-round burst hackery
			sTime = ShotTime * mult;
			return (sTime);
		}
	}
	function float GetBurstTime()
    {
            return 0;//0.5 * modShotTime;
    }

Begin:
	if ((ClipCount == 0) && (ReloadCount != 0))
	{
		FinishAnim();
		bFiring = False;

		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;

				// should we autoreload?
				if ((DeusExPlayer(Owner).bAutoReload)&&(DeusExPlayer(Owner).aGEPProjectile==none)) //GMDX: no reload if inflight
				{
					// auto switch ammo if we're out of ammo and
					// we're not using the primary ammo
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();
					ReloadAmmo();
				}
				else
				if (!DeusExPlayer(Owner).bAutoReload)
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					GotoState('Idle');
				} else
				  GotoState('Idle');
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
			    //BroadcastMessage("Should be reloading...");
				bFiring = False;
				ReloadAmmo();
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			GotoState('Idle');
		}
	}
	if ( bAutomatic && (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient())))
		GotoState('Idle');

	Sleep(GetShotTime());
	if (IsA('ScopedAssaultGun') && !bFullAuto)
	    Sleep(GetBurstTime());
	if (bAutomatic)
	{
		GenerateBullet();	// In multiplayer bullets are generated by the client which will let the server know when
		Goto('Begin');
	}
	bFiring = False;
	if ((IsA('WeaponPistol') || IsA('WeaponMiniCrossbow')) && Owner.IsA('DeusExPlayer'))
	{
	}
	else
	{
	    FinishAnim();
    }
	ReadyToFire();
Done:
	bFiring = False;
	Finish();
}

state FinishFire
{
Begin:
	bFiring = False;

    //if (IsA('WeaponFlamethrower'))
    //   if (Owner.IsA('DeusExPlayer'))
	 //      DeusExPlayer(Owner).UpdateSensitivity(DeusExPlayer(Owner).default.MouseSensitivity);

	if ( bDestroyOnFinish )
		DestroyMe();
	else
		Finish();
}

state Pickup
{
	function BeginState()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);

		Super.BeginState();
	}
}

//SARGE: New state for attaching/detaching attachments
state SwitchAttachment
{
ignores Fire, AltFire;
    begin:
    //FinishAnim();
    //if(hasAnim('ReloadBegin'))
    //    PlayAnim('ReloadBegin',1.0-(ModReloadTime*0.8));
    //FinishAnim();
    TweenAnim('Reload',0.4);
    //PlayAnim('Reload',default.ReloadTime/ReloadTime);
    Sleep(ReloadTime);
    if (bSwitchingToLaser)
        bHasLaser = !bHasLaser;
    else if (bSwitchingToScope)
        bHasScope = !bHasScope;
    else if (bSwitchingToSilencer)
        bHasSilencer = !bHasSilencer;
    else if (bSwitchingToLaser)
        bHasLaser = !bHasLaser;
    Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);
    if(hasAnim('ReloadEnd'))
        PlayAnim('ReloadEnd',1.0-(ModReloadTime*0.8));
    FinishAnim();
    if (Owner.isA('DeusExPlayer'))
        DeusExPlayer(Owner).UpdateCrosshair();

    bSwitchingToLaser = false;
    bSwitchingToScope = false;
    bSwitchingToSilencer = false;
	GotoState('Idle');
}

state Reload
{
ignores Fire, AltFire;

	function float GetReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
			if (IsA('WeaponSawedOffShotgun') || IsA('WeaponAssaultShotgun'))    //RSD: Assault shotgun loads a clip at a time, Xbow a dart at a time
			   val*=0.25;                                                       //RSD: However, the assault shotgun needs the help. Xbow not so much
			else                                                                //RSD: Assault shotgun no longer loads a clip at a time, just FYI
			   val*=0.52; //GMDX: give them some chance
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			val = GetWeaponSkill();
			val = ReloadTime + (val*ReloadTime);
 
            val += GetAddonPenalty(Scope); //SARGE: Penalties for addons

			/*if (AmmoType.IsA('AmmoRubber'))                                   //RSD: Rubber rounds no longer load more quickly (huh?)
			   val *= 0.75;*/
		}

		return val;
	}

	function NotifyOwner(bool bStart)
	{
		local DeusExPlayer player;
		local ScriptedPawn pawn;

		player = DeusExPlayer(Owner);
		pawn   = ScriptedPawn(Owner);

		if (player != None)
		{
			if (bStart)
				player.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
			{
				player.DoneReloading(self);
			}
		}
		else if (pawn != None)
		{
			if (bStart)
				pawn.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
				pawn.DoneReloading(self);
		}
	}

	function LoadShells()
	{
	local float getIt, rnd;

	rnd = FRand();

    if (Owner.IsA('DeusExPlayer'))
       DeusExPlayer(Owner).ShakeView(0.1, 28+28, 0);

	if (rnd < 0.2)
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded1', SLOT_None,,, 1024);
	else if (rnd < 0.4)
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded2', SLOT_None,,, 1024);
	else if (rnd < 0.6)
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded3', SLOT_None,,, 1024);
	else if (rnd < 0.8)
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded4', SLOT_None,,, 1024);
	else
	Owner.PlaySound(sound'GMDXSFX.Weapons.ShellSGLoaded5', SLOT_None,,, 1024);
	}

Begin:
	FinishAnim();
	/*if (!bLasing && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bHardcoreMode) //RSD: Reset accuracy when starting a reloading cycle on Hardcore mode
	{
		StandingTimer = 0;
	}*/
	if (Emitter != none)                                                        //RSD: Puts laser down when reloading
		Emitter.TurnOff();
	LaserYaw = (currentAccuracy) * (Rand(4096) - 2048);                         //RSD: Reset laser position
    LaserPitch = (currentAccuracy) * (Rand(4096) - 2048);
	// only reload if we have ammo left
	if (AmmoType.AmmoAmount > 0)
	{
	    sustainedRecoil = 0;
		if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		{
			ClientReload();
			Sleep(GetReloadTime());
			ReadyClientToFire( True );
		}
		else
		{
			if (bAimingDown)                                                    //RSD: Hack fix for Clyzm zoom issue (check if ADS reimplemented!)
				bAimingDown = false;
            bWasZoomed = bZoomed;
			if (bWasZoomed)
				ScopeOff();

			Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
//HDTP pistol and rifle (sigh) //CyberP: updated.
if ((DeusExPlayer(Owner) != None) && (IsA('WeaponRifle') || IsA('WeaponPistol')) && IsHDTP()) //RSD: Need this off for vanilla model, added iHDTPModelToggle
{
    PlayAnim('Reload',default.ReloadTime/ReloadTime);
    Sleep(ReloadTime);
    Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);
    FinishAnim();
}
else
    {
            PlayAnim('ReloadBegin',1.0-(ModReloadTime*0.8));
			NotifyOwner(True);
			FinishAnim();
			if (IsA('WeaponSawedOffShotgun'))
			    LoopAnim('Reload',(1/GetReloadTime())*0.5);
            else
			    LoopAnim('Reload');
			Owner.PlaySound(ReloadMidSound, SLOT_None,,, 1024);   //CyberP: ReloadMidSound is middle of a reload
			if (bPerShellReload) //CyberP: load shells one at a time            //RSD: was IsA(...), now done with a simple bool check
			{                                                                   //RSD: load darts one at a time too, don't load Assault Shotgun one at a time
                while (ClipCount < ReloadCount && AmmoType.AmmoAmount > 0 && ClipCount < AmmoType.AmmoAmount)                //RSD: Reverted Assault shotty, added GEP
                {
                    sleeptime = 0;
                    if (IsA('WeaponAssaultShotgun') || (IsA('WeaponSawedOffShotgun') && (!IsClyzmModel()||!IsHDTP()))) //RSD: use normal sound routine if not using Clyzm's shotty
                        LoadShells();
                    //Sleep(GetReloadTime());
                    //SARGE: Changed to now check during reload, so it's more responsive
                    while (sleeptime < GetReloadTime() && !bCancelLoading)
                    {
                        sleeptime += 0.1;
                        Sleep(0.1);
                    }
                    
                    if (bCancelLoading)
                        break;

                    if (IsA('WeaponMiniCrossbow') && Owner.IsA('DeusExPlayer'))
                        Owner.PlaySound(sound'GMDXSFX.Weapons.PDxbowreload', SLOT_None,,, 1024); //RSD: New Xbow reload sound, play after waiting
                    ClipCount++;
                    //Owner.BroadcastMessage(ClipCount);                           //RSD: For testing
                    /*else if (IsA('WeaponGEPGun') && Owner.IsA('DeusExPlayer')) //RSD: need a new sound for rocket reloads
                    Owner.PlaySound(CockingSound, SLOT_None,,, 1024);*/
                }
            }
            else
			   Sleep(GetReloadTime());
			Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
			if(hasAnim('ReloadEnd'))
				PlayAnim('ReloadEnd',1.0-(ModReloadTime*0.8));
			FinishAnim();
			NotifyOwner(False);
         }
//			if (bWasZoomed)
//				ScopeOn();
            bCancelLoading = False;
            if (!bPerShellReload)                                               //RSD: was IsA(...), now done with a simple bool check
				ReloadMaxAmmo();                                                  //RSD: Assault shotgun loads a clip at a time, Xbow a dart at a time
		}                                                                       //RSD: Reverted Assault shotty, added GEP
	}
	if (bLasing)
    	Emitter.TurnOn();                                                       //RSD: Brings laser back up
	/*if (!bLasing && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bHardcoreMode) //RSD: Reset accuracy when finishing a reloading cycle on Hardcore mode
	{
		StandingTimer = 0;
	}*/
    if (Owner.isA('DeusExPlayer'))
        DeusExPlayer(Owner).UpdateCrosshair();
	GotoState('Idle');
}

simulated state ClientFiring
{
	simulated function AnimEnd()
	{
		bInProcess = False;

		if (bAutomatic)
		{
			if ((Pawn(Owner).bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
					ClientReFire(0);
				else
					GotoState('SimFinishFire');
			}
			else
				GotoState('SimFinishFire');
		}
	}
	simulated function float GetSimShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
				if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost
                    mult += 0.5;
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}
Begin:
	if ((ClipCount == 0) && (ReloadCount != 0))
	{
		if (!bAutomatic)
		{
			bFiring = False;
			FinishAnim();
		}
		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;
				if (DeusExPlayer(Owner).bAutoReload)
				{
					bClientReadyToFire = False;
					bInProcess = False;
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();
					ReloadAmmo();
					GotoState('SimQuickFinish');
				}
				else
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					IdleFunction();
					GotoState('SimQuickFinish');
				}
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
				bFiring = False;
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			IdleFunction();
			GotoState('SimQuickFinish');
		}
	}
	Sleep(GetSimShotTime());
	if (bAutomatic)
	{
		SimGenerateBullet();
		Goto('Begin');
	}
	bFiring = False;
	FinishAnim();
	bInProcess = False;
Done:
	bInProcess = False;
	bFiring = False;
	SimFinish();
}

simulated state SimQuickFinish
{
Begin:
	if ( IsAnimating() && (AnimSequence == FireAnim[0] || AnimSequence == FireAnim[1]) )
		FinishAnim();

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	bInProcess = False;
	bFiring=False;
}

simulated state SimIdle
{
	function Timer()
	{
		PlayIdleAnim();
	}
	
Begin:
	bInProcess = False;
	bFiring = False;
	if (!bNearWall)
	{
		if (IsClyzmModel()) //RSD: Clyzm model
			PlayAnim('Idle',,0.1);
		else
			PlayAnim('Idle1',,0.1);
	}
	SetTimer(3.0, True);
}


simulated state SimFinishFire
{
Begin:
	FinishAnim();

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).FinishAnim();

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	bInProcess = False;
	bFiring=False;
	SimFinish();
}

simulated state SimDownweapon
{
ignores Fire, AltFire, ClientFire, ClientReFire;

Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;
	TweenDown();
	FinishAnim();
}

simulated state SimActive
{
Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;
	PlayAnim('Select',1.0,0.0);
	FinishAnim();
	SimFinish();
}

simulated state SimReload
{
ignores Fire, AltFire, ClientFire, ClientReFire;

	simulated function float GetSimReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			val = GetWeaponSkill();
			val = ReloadTime + (val*ReloadTime);
		}
		return val;
	}
Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;

	bWasZoomed = bZoomed;
	if (bWasZoomed)
		ScopeOff();

	Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin

    if(hasAnim('ReloadBegin'))
		PlayAnim('ReloadBegin');
	FinishAnim();
	LoopAnim('Reload');
	Sleep(GetSimReloadTime());
	Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
	ServerDoneReloading();
	if(HasAnim('ReloadEnd'))
		PlayAnim('ReloadEnd');
	FinishAnim();

	if (bWasZoomed)
		ScopeOn();

	GotoState('SimIdle');
}


state Idle
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);

		return Super.PutDown();
	}

	function AnimEnd()
	{
	}

	function Timer()
	{
		PlayIdleAnim();
	}

Begin:
	bFiring = False;
	ReadyToFire();

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
	}
	else
	{
		if (!bNearWall && !activateAn && (IsA('WeaponAssaultShotgun') || IsA('WeaponSawedOffShotgun')))
        	PlayAnim('Idle2',,0.1);
        else if (!bNearWall && !activateAn && IsA('WeaponPistol'))
        {
           if (FRand() < 0.5)
              PlayAnim('Idle2',,0.1);
           else
			{
				if (IsClyzmModel()) //RSD: Clyzm model
					PlayAnim('Idle',,0.1);
				else
					PlayAnim('Idle1',,0.1);
			}
        }
        else if (!bNearWall && !activateAn)
		{
			if (IsClyzmModel()) //RSD: Clyzm model
				PlayAnim('Idle',,0.1);
			else
				PlayAnim('Idle1',,0.1);
		}
		SetTimer(3.0, True);
	}
}

state FlameThrowerOn
{
	function float GetShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
				if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost
                    mult += 0.5;
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}
Begin:
	if ( (DeusExPlayer(Owner).Health > 0) && bFlameOn && (ClipCount > 0))
	{
		if (( flameShotCount == 0 ) && (Owner != None))
		{
			PlayerPawn(Owner).PlayFiring();
			PlaySelectiveFiring();
			PlayFiringSound();
			flameShotCount = 6;
		}
		else
			flameShotCount--;

		Sleep( GetShotTime() );
		GenerateBullet();
		goto('Begin');
	}
Done:
	bFlameOn = False;
	GotoState('FinishFire');
}

state Active
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}

Begin:
	// Rely on client to fire if we are a multiplayer client

	if ( (Level.NetMode==NM_Standalone) || (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
		bClientReady = True;
	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
		ClientActive();
		bClientReady = False;
	}

	//SetCloak(class'DeusExPlayer'.default.bCloakEnabled,true);//GMDX force cloak
    SetCloakRadar(class'DeusExPlayer'.default.bCloakEnabled,class'DeusExPlayer'.default.bRadarTran,true);//RSD: Overhauled cloak/radar routines

	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
    }
	bWeaponUp = True;
	PlayPostSelect();
	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	// reload the weapon if it's empty and autoreload is true
	if ((ClipCount == 0) && (ReloadCount != 0))
	{
		if (Owner.IsA('ScriptedPawn') || ((DeusExPlayer(Owner) != None) && DeusExPlayer(Owner).bAutoReload))
			ReloadAmmo();
	}
	Finish();
}


state DownWeapon
{
ignores Fire, AltFire;

	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}

    //CyberP begin
simulated function TweenDown()
{
local DeusExPlayer player;
local float p;

     player = DeusExPlayer(Owner);

     if (player != None)
     p = player.AugmentationSystem.GetAugLevelValue(class'AugCombat');

     if (p < 1.0)
     p = 1.0;

        if (IsA('WeaponNanoSword') && WeaponNanoSword(Self).chargeManager != None && !WeaponNanoSword(self).chargeManager.IsUsedUp()) //SARGE: Added sword energy level checks
            PlaySound(sound'GMDXSFX.Weapons.energybladeunequip2',SLOT_None);
        else if (IsA('WeaponProd'))
            PlaySound(sound'GMDXSFX.Weapons.produnequip',SLOT_None);
        else if (IsA('WeaponCombatKnife') || IsA('WeaponSword'))
            PlaySound(sound'GMDXSFX.Weapons.knifeunequip',SLOT_None);

	if ( (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else
	{
		// Have the put away animation play twice as fast in multiplayer
		if ( Level.NetMode != NM_Standalone )
			PlayAnim('Down', 2.0, 0.05);
		else
			PlayAnim('Down', p, 0.02);
	}
}
 //CyberP end
Begin:
    //if(!DeusExPlayer(Owner).assignedWeapon.IsA('Binoculars'));                   //RSD
	   ScopeOff();
    //if (Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).IsInState('Mantling'))
	   LaserOff(true);
    if (Owner.IsA('DeusExPlayer') && !bLasing)
	//if (!class'DeusExPlayer'.default.bRadarTran)                              //RSD: Overhauled cloak/radar routines
       SetCloakRadar(false,false);//SetCloak(false);                            //RSD: Overhauled cloak/radar routines

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		ClientDownWeapon();
    if (Buoyancy==5.123456) //CyberP: dumb hack/avoiding use of global vars
    {
        Buoyancy = default.Buoyancy;//5.000000;                                 //RSD: okay, but at least set to the correct value
    }
    else
    {
	   TweenDown();
	   FinishAnim();
	}
    bBeginQuickMelee = False;
    bAlreadyQuickMelee = False;                                                 //RSD: Added
	//if ( Level.NetMode != NM_Standalone )
	//{
	//	ReloadMaxAmmo();	// Auto-reload in multiplayer (when putting away)
	//}
	bOnlyOwnerSee = false;
	if (Pawn(Owner) != None)
		Pawn(Owner).ChangedWeapon();
}

state ADSToggle                                                                 //RSD: Taken from WeaponSawedOffShotgun.uc for inheritance
{
	ignores Fire, AltFire, PutDown, ReloadAmmo, DropFrom; // Whee! We can't do sweet F.A. in this state! :D
	Begin:
		If(bAimingDown)
			PlayAnim('SupressorOn',,0.1);
		else
			PlayAnim('SuperssorOff',,0.1);
		bAimingDown=!bAimingDown;
        if (Owner.IsA('DeusExPlayer'))
            DeusExPlayer(Owner).UpdateCrosshair();
		FinishAnim();
		GoToState('Idle');
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
	return ((BeltSpot <= 3) && (BeltSpot >= 1));
}

//SARGE: Destroys the object, and makes sure if it's in our belt, it becomes a placeholder
//I hate having to do this here, but I can't think of anywhere else to do it that doesn't suck equally as hard
//or works in a generic way.
function DestroyMe()
{
	local DeusExPlayer player;
	player = DeusExPlayer(GetPlayerPawn());

    player.RemoveObjectFromBelt(self);
    Destroy();
}

defaultproperties
{
     bReadyToFire=True
     LowAmmoWaterMark=10
     FireAnim(0)=Shoot
     FireAnim(1)=Shoot
     NoiseLevel=1.000000
     ShotTime=0.500000
     reloadTime=1.000000
     HitDamage=10
     maxRange=9600
     AccurateRange=4800
     BaseAccuracy=0.500000
     ScopeFOV=20
     MaintainLockTimer=1.000000
     bPenetrating=True
     bHasMuzzleFlash=True
     bEmitWeaponDrawn=True
     bUseWhileCrouched=True
     bUseAsDrawnWeapon=True
     MinSpreadAcc=0.200000
     MinProjSpreadAcc=0.250000
     bNeedToSetMPPickupAmmo=True
     msgCannotBeReloaded="This weapon can't be reloaded"
     msgOutOf="Out of %s"
     msgNowHas="%s now has %s loaded"
     msgAlreadyHas="No other ammo to load"
	 msgGLModeActivated="Switched to Rifle"
	 msgRifleModeActivated="Switched to Underbarrel Grenade Launcher"
     msgNone="NONE"
     msgLockInvalid="INVALID"
     msgLockRange="RANGE"
     msgLockAcquire="ACQUIRE"
     msgLockLocked="LOCKED"
     msgRangeUnit="FT"
     msgTimeUnit="SEC"
     msgMassUnit="LBS"
     msgNotWorking="This weapon doesn't work underwater"
     msgInfoAmmoLoaded="Ammo loaded:"
     msgInfoAmmo="Ammo type(s):"
     msgInfoDamage="Base damage:"
     msgInfoClip="Clip size:"
     msgInfoReload="Reload time:"
     msgInfoRecoil="Recoil:"
     msgInfoAccuracy="Base Accuracy:"
     msgInfoAccRange="Acc. range:"
     msgInfoMaxRange="Max. range:"
     msgInfoMass="Mass:"
     msgInfoLaser="Laser sight:"
     msgInfoScope="Scope:"
     msgInfoSilencer="Silencer:"
     msgInfoNA="N/A"
     msgInfoYes="YES"
     msgInfoNo="NO"
     msgInfoAuto="AUTO"
     msgInfoSingle="SINGLE"
     msgInfoRounds="RDS"
     msgInfoRoundsPerSec="RDS/SEC"
     msgInfoSkill="Skill:"
     msgInfoWeaponStats="Weapon Stats:"
     FireSilentSound=Sound'DeusExSounds.Weapons.StealthPistolFire'
     RecoilShaker=(X=2.000000,Y=0.500000,Z=0.500000)
     msgInfoROF="Rate of fire:"
     msgInfoFullAuto="Firing Type:"
     msgSemi="Semi-Automatic"
     msgFull="Fully-Automatic"
     msgPump="Pump-Action"
     msgHeadMultiplier="Head Multiplier:"
     msgLethality="Lethality:"
     msgNon="Non-Lethal"
     msgLethal="Lethal"
     msgVar="Variable"
     msgSecondary="Secondary:"
     msgAllMods="Installed Modifications:"
     msgStamDrain="Stamina Drain:"
     msgSpeedR="Speed Rating:"
     msgNoise="Noise Level:"
     msgSpec="ERROR: REPORT THIS AS A BUG"
     msgSpec2="Special:"
     msgSlow="Slow"
     msgModerate="Moderate"
     msgFast="Fast"
     msgVeryFast="Very Fast"
     msgRelo="Reload:"
     msgReco="Recoil:"
     msgAccu="Accuracy:"
     msgRang="Range:"
     msgClip="Clip:"
     msgDama="Damage:"
     msgRate="Rate of Fire:"
     msgRequires="Requires"
     negTime=0.765000
     attackSpeedMult=1.000000
     abridgedName="DEFAULT NAME - REPORT BUG"
     invSlotsXtravel=1
     invSlotsYtravel=1
     ReloadCount=10
     shakevert=10.000000
     Misc1Sound=Sound'DeusExSounds.Generic.DryFire'
     MuzzleScale=6.000000
     AutoSwitchPriority=0
	 ARGLLoaded=1
     bRotatingPickup=False
     PickupMessage="You found"
     ItemName="DEFAULT WEAPON NAME - REPORT THIS AS A BUG"
     strModified="Modified"
     BobDamping=0.840000
     LandSound=Sound'DeusExSounds.Generic.DropSmallWeapon'
     bNoSmooth=False
     bCollideWorld=True
     bProjTarget=True
     Mass=10.000000
     Buoyancy=5.000000
     muzzleSlot=2
     //CopyModsSound=sound'weaponmodinstall'
     CopyModsSound=sound'M4ClipOut'
     msgModsCopied="Weapon Modifications applied from %d"
     bVisionImportant=true
     addonPenalties(0)=0.1 //Scope
     addonPenalties(1)=0.2 //Silencer
     addonPenalties(2)=0.075 //Laser
}
