//=============================================================================
// DeusExDecoration.
//=============================================================================
class DeusExDecoration extends Decoration
	abstract
	native;

#exec OBJ LOAD FILE=Effects

// for destroying them
var() travel int HitPoints;
var() int minDamageThreshold;
var() bool bInvincible;
var() class<Fragment> fragType;

// information for floating/bobbing decorations
var() bool bFloating;
var rotator origRot;

// lets us attach a decoration to a mover
var() name moverTag;

// object properties
var() bool bFlammable;				// can this object catch on fire?
var() float Flammability;			// how long does the object burn?
var() bool bExplosive;				// does this object explode when destroyed?
var() int explosionDamage;			// how much damage does the explosion cause?
var() float explosionRadius;		// how big is the explosion?

var() bool bHighlight;				// should this object not highlight when focused?

var() bool bCanBeBase;				// can an actor stand on this decoration?

var() bool bGenerateFlies;			// does this actor generate flies?

var int pushSoundId;				// used to stop playing the push sound

var int gradualHurtSteps;			// how many separate explosions for the staggered HurtRadius
var int gradualHurtCounter;			// which one are we currently doing

var name NextState;					// for queueing states
var name NextLabel;					// for queueing states

var FlyGenerator flyGen;			// fly generator

var localized string itemArticle;
var localized string itemName;		// human readable name

var bool stickaround;
var float DamageScaler; //used for calculating GMDXprojectile scale
var bool bStoodOn; //CyberP: is a heavy actor on this actor?
var actor standingActorGlobal; //CyberP: Global access to standing actors
var float psychoLiftTime;
var bool bPsychoBump;
var() bool bDoNotResetRotationOnLanded;
var bool bWrapped;
var bool bLeftGrab;               //Sarge: Can this object be picked up with left click
var bool bEMPHitMarkers;          //Sarge: Show hitmarkers for all EMP damage, for things like cameras
var bool bHitMarkers;             //Sarge: Show hitmarkers when damaged. For things like glass panes

var bool bFirstTickDone;                                                        //SARGE: Set to true after the first tick. Allows us to do stuff on the first frame

//SARGE: HDTP Model toggles
var config int iHDTPModelToggle;
var string oldSkin;                                                             //SARGE: Can optionally set the vanilla skin, for objects that change skins. Will use default.Skin if left out, which is recommended most of the time.
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;

//Sarge: LDDP Stuff
var(GMDX) const bool requiresLDDP;                                              //Delete this character LDD is uninstalled
var(GMDX) const bool LDDPExtra;                                                 //Delete this character we don't have the "Extra LDDP Characters" playthrough modifier
var(GMDX) const bool deleteIfMale;                                              //Delete this character if we're male
var(GMDX) const bool deleteIfFemale;                                            //Delete this character if we're female

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

native(2101) final function ConBindEvents();

//
// network replication
//
replication
{
	// Things the server should send to the client.
	reliable if( Role==ROLE_Authority )
		HitPoints, bInvincible, fragType, bFloating, origRot, moverTag;
/*
	// Things the client should send to the server
	reliable if ( Role<ROLE_Authority )
		WeaponPriority, Password;

	// Functions client can call.
	reliable if( Role<ROLE_Authority )
		Fire, AltFire, ServerRequestScores;

	// Functions server can call.
	reliable if( Role==ROLE_Authority )
		ClientAdjustGlow, ClientTravel, ClientSetMusic, SetDesiredFOV;
*/
}

//SARGE: Added "Left Click Frob" and "Right Click Frob" support
//Return true to use the default frobbing mechanism (right click), or false for custom behaviour
function bool DoLeftFrob(DeusExPlayer frobber)
{
    //Don't allow frobbing while swimming, and only allow objects grabbable via left click
    if (bLeftGrab && frobber.swimTimer > 1)
    {
        frobber.GrabDecoration();
        return false;
    }
    else if (minDamageThreshold > 0)
    {
        frobber.SelectMeleePriority(minDamageThreshold);
        return false;
    }
    return true;
}
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    //Don't allow frobbing while swimming, and only allow pushable objects
    if (bPushable && frobber.swimTimer > 1 && !objectInHand)
    {
        frobber.GrabDecoration();
        return false;
    }
    return true;
}

exec function UpdateHDTPsettings()                                              //SARGE: New function to update model meshes (specifics handled in each class)
{
    if (HDTPMesh != "")
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),iHDTPModelToggle > 0);
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),iHDTPModelToggle > 0);
    if (HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),iHDTPModelToggle > 0);
}

// ----------------------------------------------------------------------
// PreBeginPlay()
// ----------------------------------------------------------------------

function PreBeginPlay()
{
	Super.PreBeginPlay();

	// Bind any conversation events to this Decoration
//	ConBindEvents();

	if (bGenerateFlies && (FRand() < 0.2))
		flyGen = Spawn(Class'FlyGenerator', , , Location, Rotation);
	else
		flyGen = None;
    
    UpdateHDTPSettings();                                                       //SARGE: Update HDTP
}

// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{
	Super.PostPostBeginPlay();

    if (!bUnlit && ScaleGlow > 0.5 && !IsA('Lamp') && !IsA('CageLight'))
        ScaleGlow = 0.5;
    else if (IsA('CageLight'))
        ScaleGlow = 1.0;

    if (IsA('Barrel1') || IsA('TrashCan3') || IsA('TrashCan4'))
        LODBias=3.000000;
	// Bind any conversation events to this DeusExPlayer
	ConBindEvents();

    //SARGE: Attempted fix for the case where objects have no itemName, for whatever reason
    if (itemName == "" && bHighlight)
        itemName = default.itemName;
}

// ----------------------------------------------------------------------
// BeginPlay()
//
// if we are already floating, then set our ref points
// ----------------------------------------------------------------------

function BeginPlay()
{
	local Mover M;
	local float Volume,temp;

	Super.BeginPlay();

	if (bFloating)
		origRot = Rotation;

	// attach us to the mover that was tagged
	if (moverTag != '')
		foreach AllActors(class'Mover', M, moverTag)
		{
			SetBase(M);
			SetPhysics(PHYS_None);
			bInvincible = True;
			bCollideWorld = False;
		}
//GMDX
	//log(self);
	if ((!bInvincible)&&(!IsA('AutoTurret'))&&(!IsA('ElectronicDevices'))&&(!IsA('Barrel1'))&&bHighlight&&!bExplosive&&bPushable)
	{
	  Volume=3.1415*CollisionRadius*CollisionRadius*CollisionHeight;
	  temp=1.0-Sqrt(Mass/Volume);
	  temp*=temp;

      //if (!IsA('BoxSmall'))
	  //HitPoints=lerp(FClamp(Sqrt(Volume)/500,0,1),5,30);

	  switch fragType
	  {
		 case class'GlassFragment' :
		        minDamageThreshold=1;
			    DamageScaler=2; //temp*0.3;  //CyberP: always break
			    HitPoints=1.0;
      	        break;
		 case class'PaperFragment' :
			if(IsA('Pillow'))
			{
			minDamageThreshold=2;
			DamageScaler=temp*0.3;       //CyberP: all minDamagethreshold = 2
			}
			else if (IsA('Basketball'))
            {
            DamageScaler=temp; minDamageThreshold=25;
            }
            else
			{
			minDamageThreshold=1;
			DamageScaler=temp*1.2;
			}
			break;
		 case class'PlasticFragment' :
			minDamageThreshold=1;
			DamageScaler=temp;
			break;
		 case class'WoodFragment' :
			minDamageThreshold=2;
			DamageScaler=temp*0.7;
        	break;
		 case class'Rockchip' :
			minDamageThreshold=2;
			DamageScaler=1.1;
			break;
		 case class'MetalFragment' :
			minDamageThreshold=2;
			DamageScaler=temp*0.6;
			if (HitPoints == default.HitPoints)
               HitPoints=default.HitPoints+40;
			if (IsA('Trophy') || IsA('Pinball'))
             minDamageThreshold=22;
			else if (IsA('CrateUnbreakableMed') || IsA('WaterFountain') || IsA('HKBuddha'))
            { HitPoints=250; minDamageThreshold=40; }
            else if (IsA('CrateUnbreakableLarge'))
            { HitPoints=300; minDamageThreshold=40;}
			else if (IsA('CrateUnbreakableSmall'))
			{ HitPoints=150; minDamageThreshold=25; }
			break;
		 case class'FleshFragment' :
			DamageScaler=temp*0.4;
			break;
	  }

	  //log("DECO:-"@self@" temp="@temp@" DamageScaler="@DamageScaler@" Volume="@Volume@" Mass="@Mass@" Vol / Mass="@(Volume/Mass)@" Mass / Vol="@(Mass/Volume)@" minDamageThreshold="@minDamageThreshold@" Type="@fragType.Name);
	  //log("DECO:-"@self@HitPoints@" "@minDamageThreshold@" "@DamageScaler@" "@fragType@" Vol:"@Volume);
	} else
	{
	  DamageScaler=1;
    }

//end GMDX


	if (fragType == class'GlassFragment')
		pushSound = sound'PushPlastic';
	else if (fragType == class'MetalFragment')
		pushSound = sound'PushMetal';
	else if (fragType == class'PaperFragment')
		pushSound = sound'PushPlastic';
	else if (fragType == class'PlasticFragment')
		pushSound = sound'PushPlastic';
	else if (fragType == class'WoodFragment')
		pushSound = sound'PushWood';
	else if (fragType == class'Rockchip')
		pushSound = sound'PushPlastic';
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

function TravelPostAccept()
{
}

// ----------------------------------------------------------------------
// Landed()
//
// Called when we hit the ground
// ----------------------------------------------------------------------

function Landed(vector HitNormal)
{
	local Rotator rot;
	local sound hitSound;

	// make it lay flat on the ground
	if (!bDoNotResetRotationOnLanded)
	{
	bFixedRotationDir = False;
	rot = Rotation;
	rot.Pitch = 0;
	rot.Roll = 0;
	SetRotation(rot);
    }
    if (IsA('BoxRectangle') && fragType == class'MetalFragment') TakeDamage(1000,none,Location,vect(0,0,0),'Shot'); //CyberP: special case for vents on liberty island
	// play a sound effect if it's falling fast enough
	if (Velocity.Z <= -150)
	{
		if (fragType == class'WoodFragment')
		{
			if (Mass <= 20)
				hitSound = sound'WoodHit1';
			else
				hitSound = sound'WoodHit2';
		}
		else if (fragType == class'MetalFragment')
		{
		    if (IsA('FireExtinguisherEmpty'))
                hitSound = sound'GlassDrop';
            else if (Mass <= 20)
				hitSound = sound'GMDXSFX.Generic.DropSmallMetal';
			else if (Mass <= 40)
				hitSound = sound'MetalHit1';
			else
				hitSound = sound'MetalHit2';
		}
		else if (fragType == class'PlasticFragment')
		{
			if (Mass <= 20)
				hitSound = sound'PlasticHit1';
			else
				hitSound = sound'PlasticHit2';
			if (IsA('Plant3') || IsA('Flowers'))
                TakeDamage(20,none,Location,vect(0,0,0),'Shot'); //CyberP: always destroy when thrown
		}
		else if (fragType == class'GlassFragment')
		{
			if (Mass <= 20)
				hitSound = sound'GlassHit1';
			else
				hitSound = sound'GlassHit2';
			TakeDamage(20,none,Location,vect(0,0,0),'Shot'); //CyberP: always destroy when thrown
		}
		else	// paper sound
		{
			if (Mass <= 20)
				hitSound = sound'PaperHit1';
			else
				hitSound = sound'PaperHit2';
		}

		if (hitSound != None)
			PlaySound(hitSound, SLOT_None);

		// alert NPCs that I've landed
		AISendEvent('LoudNoise', EAITYPE_Audio,,320+(Mass*3)); //CyberP: mass factors into radius
	}

	bWasCarried = false;
	bBobbing    = false;

	// The crouch height is higher in multiplayer, so we need to be more forgiving on the drop velocity to explode
	if ( Level.NetMode != NM_Standalone )
	{
		if ((bExplosive && (VSize(Velocity) > 478)) || (!bExplosive && (Velocity.Z < -500)))
			TakeDamage((1-Velocity.Z/30), Instigator, Location, vect(0,0,0), 'fell');
	}
	else
	{
		if ((bExplosive && (VSize(Velocity) > 500)) || (!bExplosive && (Velocity.Z < -600) &&
      !IsA('FireExtinguisherEmpty') && !IsA('CrateUnbreakableSmall') && !IsA('CrateUnbreakableMed')))
			TakeDamage((1-Velocity.Z/35), Instigator, Location, vect(0,0,0), 'fell');
	}             //CyberP: more forgiving in SP too
}

// ----------------------------------------------------------------------
// SupportActor()
//
// Called when somebody lands on us
// ----------------------------------------------------------------------

singular function SupportActor(Actor standingActor)
{
	local vector newVelocity;
	local float  angle;
	local float  zVelocity;
	local float  baseMass;
	local float  standingMass;
	local DeusExPlayer player;

	player = DeusExPlayer(GetPlayerPawn());

	zVelocity = standingActor.Velocity.Z;
	// We've been stomped!

	if (standingActor.IsA('DeusExPlayer') && !IsA('ElectronicDevices') && !IsA('WaterCooler') && (FragType == class'GlassFragment' || FragType == class'PlasticFragment'))
	TakeDamage(20,none,Location,vect(0,0,0),'Stomped');                                                  //CyberP: new block of code to check for fragile stuff if player

    if (zVelocity < -50 && (FragType == class'GlassFragment' || FragType == class'PlasticFragment'))     //CyberP: new block of code to check for fragile stuff if other obj
    {
         if (!IsA('ElectronicDevices'))
         {
         standingMass = FMax(1, standingActor.Mass);
		 baseMass     = FMax(1, Mass);
         TakeDamage((1 - standingMass/baseMass * zVelocity/10),
		           standingActor.Instigator, standingActor.Location, 0.2*standingActor.Velocity, 'stomped');
         }
    }
    else if (zVelocity < -700 && standingActor.Mass >= 40 && FragType != class'MetalFragment' && !IsA('ElectronicDevices'))
	{
		standingMass = FMax(1, standingActor.Mass);
		baseMass     = FMax(1, Mass);
		TakeDamage((1 - standingMass/baseMass * zVelocity/30),
		           standingActor.Instigator, standingActor.Location, 0.2*standingActor.Velocity, 'stomped');
	}

	if (!bCanBeBase)
	{
		angle = FRand()*Pi*2;
		newVelocity.X = cos(angle);
		newVelocity.Y = sin(angle);
		newVelocity.Z = 0;
		newVelocity *= FRand()*25 + 50; //CyberP: was + 25
		newVelocity += standingActor.Velocity;
		newVelocity.Z = 60;   //CyberP: was 50
		standingActor.Velocity = newVelocity;
		standingActor.SetPhysics(PHYS_Falling);
	}
	else
	{
		standingActor.SetBase(self);
		if (StandingCount == 1)
		    standingActorGlobal = standingActor;
    }
	if (standingActor != none && standingActor.Mass >= 40)
    bStoodOn = True;
    else
    bStoodOn = False;
}


// ----------------------------------------------------------------------
// ResetScaleGlow()
//
// Reset the ScaleGlow to the default
// Decorations modify ScaleGlow using damage
// ----------------------------------------------------------------------

function ResetScaleGlow()
{
local float HP;

	if (!bInvincible)
	{
	    if (ScaleGlow > 0.5)
	        ScaleGlow = float(HitPoints) / float(Default.HitPoints) * 0.9 + 0.1;
	    else if (ScaleGlow > 0.15)
            ScaleGlow -= 0.1;
	}
}

// ----------------------------------------------------------------------
// BaseChange()
//
// Ripped out most of the code from the original BaseChange; the equivalent
// functionality has been moved to Landed() and SupportActor()
// ----------------------------------------------------------------------

singular function BaseChange()
{
	bBobbing = false;

	if( (base == None) && (bPushable || IsA('Carcass')) && (Physics == PHYS_None) )
		SetPhysics(PHYS_Falling);

	// make sure if a decoration is accidentally dropped,
	// we reset it's parameters correctly
	SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
	Style = Default.Style;
	bUnlit = Default.bUnlit;
}

// ----------------------------------------------------------------------
// Tick()
//
// Make the decoration act like it is floating
// ----------------------------------------------------------------------

simulated function Tick(float deltaTime)
{
	local float        ang;
	local rotator      rot;
	local DeusExPlayer player;
		
    player = DeusExPlayer(GetPlayerPawn());

    //If we shouldn't be created, abort
    if (!bFirstTickDone && !ShouldCreate(player))
        Destroy();

	Super.Tick(deltaTime);

	if (bFloating)
	{
		ang = 2 * Pi * Level.TimeSeconds / 4.0;
		rot = origRot;
		if (IsA('NYPoliceBoat'))
		{
		rot.Pitch += Sin(ang) * 256;
		rot.Roll += Cos(ang) * 256;
		rot.Yaw += Sin(ang) * 128;
		}
		else
		{
		rot.Pitch += Sin(ang) * 512;
		rot.Roll += Cos(ang) * 512;
		rot.Yaw += Sin(ang) * 256;
		}
		SetRotation(rot);
	}

	// BOOGER!  This is a hack!
	// Ideally, we'd set the base of the fly generator to this decoration,
	// but unfortunately this prevents the player from picking up the
	// decoration... need to fix!

	if (flyGen != None)
	{
		if ((flyGen.Location != Location) || (flyGen.Rotation != Rotation))
		{
			flyGen.SetLocation(Location);
			flyGen.SetRotation(Rotation);
		}
	}

	// If we have any conversations, check to see if we're close enough
	// to the player to start one (and all the other checks that take place
	// when a valid conversation can be started);

	if (conListItems != None)
	{
		if (player != None)
			player.StartConversation(Self, IM_Radius);
	}

	if ((Level.Netmode != NM_Standalone) && (VSize(Velocity) > 0) && (VSize(Velocity) < 5))
	{
	  Velocity *= 0;
	}
    
    bFirstTickDone = true;
}

// ----------------------------------------------------------------------
// ZoneChange()
// this decoration will now float with cool bobbing if it is
// buoyant enough
// ----------------------------------------------------------------------

function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	if (bFloating && !NewZone.bWaterZone)
	{
		bFloating = False;
		SetRotation(origRot);
		return;
	}

	if (NewZone.bWaterZone)
		{
        ExtinguishFire();
        RotationRate.Pitch = default.RotationRate.Pitch;
        RotationRate.Yaw = default.RotationRate.Yaw;
		if ((Mass > 15) && (Velocity.Z < -130))         //CyberP: water splash effect
		{
		Spawn(class'WaterRing',,,Location+ CollisionHeight * vect(0,0,1));
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        if ((Mass > 50) && (Velocity.Z < -130))         //CyberP: water splash effect
		{
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash2');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
        spawn(class'WaterSplash3');
		}

        }
      }
	if (NewZone.bWaterZone && !bFloating && (Buoyancy > Mass))
	{
		bFloating = True;
		origRot = Rotation;
	}
}

// ----------------------------------------------------------------------
// Bump()
// copied from Engine\Classes\Decoration.uc
// modified so we can have strength modify what you can push
// ----------------------------------------------------------------------

function Bump(actor Other)
{
	local int augLevel, augMult;
	local float maxPush, velscale;
	local DeusExPlayer player;
	local Rotator rot;
    local AugIcarus icar;

	player = DeusExPlayer(Other);

	// if we are bumped by a burning pawn, then set us on fire
	if (Other.IsA('Pawn') && Pawn(Other).bOnFire && !Other.IsA('Robot') && !Region.Zone.bWaterZone && bFlammable)
		GotoState('Burning');

	// if we are bumped by a burning decoration, then set us on fire
	if (Other.IsA('DeusExDecoration') && DeusExDecoration(Other).IsInState('Burning') &&
		DeusExDecoration(Other).bFlammable && !Region.Zone.bWaterZone && bFlammable)
		GotoState('Burning');
    if (bPsychoBump)
    {
       if (VSize(Velocity) > 400)
       {
          Other.TakeDamage(Vsize(Velocity)*0.1,None, Location, velocity*0.5,'shot');
          TakeDamage(Vsize(Velocity)*2,None, Location, velocity*0.5,'shot');
          bPsychoBump = False;
       }
    }
	// Check to see if the actor touched is the Player Character
	if (player != None)
	{
		// if we are being carried, ignore Bump()
		if (player.CarriedDecoration == Self)
			return;
        else if (player.RocketTargetMaxDistance == 40001.000000)
        {
            if (!IsA('HackableDevices'))
                TakeDamage(500,none,Location,vect(1000,1000,1000),'Exploded');
            if (Mass >= 100)
            {
            icar = AugIcarus(player.AugmentationSystem.FindAugmentation(class'AugIcarus'));
            icar.incremental = 2;
            }
        }
        else if (player.IsInState('Mantling'))
            return;
		// check for convos
		// NO convos on bump
//		if ( player.StartConversation(Self, IM_Bump) )
//			return;
	}
	//if (Mass >= 150 && Velocity.Z < -200 && (Other.IsA('Pawn') && !Other.IsA('Robot'))) //CyberP: large crates falling on head = insta-gib
    //   Other.TakeDamage(5000,Instigator,Location,Vect(0,0,0),'Exploded');
     if (Mass >= 40 && (abs(Velocity.Z) > 200) && !Other.IsA('Flare') && (Other.IsA('ScriptedPawn') || Other.Mass < 40))
       Other.TakeDamage(Mass/6,Instigator,Location,Vect(0,0,0),'Shot');

    if (IsA('BoxRectangle') && HitPoints == 15) TakeDamage(1000,none,Location,vect(0,0,0),'Shot'); //CyberP: special case for vents on liberty island

	if (bPushable && (PlayerPawn(Other)!=None) && (Other.Mass > 40))// && (Physics != PHYS_Falling))
	{
		// A little bit of a hack...
		// Make sure this decoration isn't being bumped from above or below
		if (abs(Location.Z-Other.Location.Z) < (CollisionHeight+Other.CollisionHeight-1))
		{
			maxPush = 100;
			augMult = 1;
			if (player != None)
			{
				if (player.AugmentationSystem != None)
				{
					augLevel = player.AugmentationSystem.GetClassLevel(class'AugMuscle');
					if (augLevel >= 0)
						augMult = augLevel+1;
					maxPush *= augMult;
				}
			}

			if (Mass <= maxPush)
			{
				// slow it down based on how heavy it is and what level my augmentation is
				velscale = FClamp((50.0 * augMult) / Mass, 0.0, 1.0);
				if (velscale < 0.25)
					velscale = 0;

				// apply more velocity than normal if we're floating
				if (bFloating)
					Velocity = Other.Velocity;
				else
					Velocity = Other.Velocity * velscale;

				if (Physics != PHYS_Falling)
					Velocity.Z = 0;

				if (!bFloating && !bPushSoundPlaying && (Mass > 15))
				{
					pushSoundId = PlaySound(PushSound, SLOT_Misc,,, 128);
					AIStartEvent('LoudNoise', EAITYPE_Audio, , 128);
					bPushSoundPlaying = True;
				}

				if (!bFloating && (Physics != PHYS_Falling))
					SetPhysics(PHYS_Rolling);

				SetTimer(0.2, False);
				Instigator = Pawn(Other);

				// Impart angular velocity (yaw only) based on where we are bumped from
				// NOTE: This is faked, but it looks cool
				rot = Rotator((Other.Location - Location) << Rotation);
				rot.Pitch = 0;
				rot.Roll = 0;

				// ignore which side we're pushing from
				if (rot.Yaw >= 24576)
					rot.Yaw -= 32768;
				else if (rot.Yaw >= 8192)
					rot.Yaw -= 16384;
				else if (rot.Yaw <= -24576)
					rot.Yaw += 32768;
				else if (rot.Yaw <= -8192)
					rot.Yaw += 16384;

				// scale it down based on mass and apply the new "rotational force"
				rot.Yaw *= velscale * 0.025;
				SetRotation(Rotation+rot);
			}
		}
	} else if ((bPushable)&&(PlayerPawn(Other)==None)&&(!IsA('CrateUnbreakableLarge'))&&
	((!Other.IsA('Animal'))||(Other.IsA('Karkian')||(Other.IsA('Gray')))&&(!Other.IsA('SpiderBot2'))))
        bump2(Other);
}

function Bump2( actor Other )
{
	local float speed, oldZ;
	if( bPushable && (Pawn(Other)!=None) && (Other.Mass > 20) )
	{
	    if (Other.IsA('ScriptedPawn') && ScriptedPawn(Other).bTank && Physics != PHYS_Falling)
	        TakeDamage(400,Pawn(Other),vect(0,0,0),vect(0,0,0),'shot');
		bBobbing = false;
		oldZ = Velocity.Z;
		speed = VSize(Other.Velocity);
		Velocity = Other.Velocity * FMin(120.0, 20 + speed)/speed;
		if ( Physics == PHYS_None ) {
			Velocity.Z = 10;
			if (!bPushSoundPlaying)
               pushSoundId = PlaySound(PushSound, SLOT_Misc,,, 128);
			bPushSoundPlaying = True;
		}
		else
			Velocity.Z = oldZ;
		SetPhysics(PHYS_Falling);
		SetTimer(0.2,False);
		Instigator = Pawn(Other);
	}
}

// ----------------------------------------------------------------------
// Timer() function for Bump
//
// shuts off the looping push sound
// ----------------------------------------------------------------------

function Timer()
{
	if (bPushSoundPlaying)
	{
		StopSound(pushSoundId);
		AIEndEvent('LoudNoise', EAITYPE_Audio);
		bPushSoundPlaying = False;
	}
}

// ----------------------------------------------------------------------
// DropThings()
//
// drops everything that is based on this decoration
// ----------------------------------------------------------------------

function DropThings()
{
	local actor A;

	// drop everything that is on us
	foreach BasedActors(class'Actor', A)
	{
		if (!A.IsA('ParticleGenerator'))
        {
		   if (A.Owner != None && A.Owner.IsA('DeusExPlayer'))
		   {
		   }
		   else
			A.SetPhysics(PHYS_Falling);
  }
	}
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

	NextState = GetStateName();

	// If bAvoidState is set, then we don't want to jump into the conversaton state
	// because bad things might happen otherwise.

	if (!bAvoidState)
	{
		if (bFirstPerson)
			GotoState('FirstPersonConversation');
		else
			GotoState('Conversation');
	}
}

// ----------------------------------------------------------------------
// EndConversation()
// ----------------------------------------------------------------------

function EndConversation()
{
	Super.EndConversation();

	Enable('Bump');

	GotoState(NextState);
}

// ----------------------------------------------------------------------
// state Conversation
//
// Just sit here until the conversation is over
// ----------------------------------------------------------------------

state Conversation
{
	ignores bump, frob;

Idle:
	Sleep(1.0);
	goto('Idle');

Begin:

	// Make sure we're not on fire!
	ExtinguishFire();

	goto('Idle');
}


// ----------------------------------------------------------------------
// state FirstPersonConversation
//
// Just sit here until the conversation is over
// ----------------------------------------------------------------------

state FirstPersonConversation
{
	ignores bump, frob;

Idle:
	Sleep(1.0);
	goto('Idle');

Begin:
	goto('Idle');
}

// ----------------------------------------------------------------------
// Explode()
// Blow it up real good!
// ----------------------------------------------------------------------
function Explode(vector HitLocation)
{
	local ShockRing ring;
	local ScorchMark s;
	local ExplosionLight light, light2;
	local int i;
    local vector loc;
    local actor acti;

    loc = HitLocation + VRand() * CollisionRadius;
	// make sure we wake up when taking damage
	bStasis = False;

	// alert NPCs that I'm exploding
	AISendEvent('LoudNoise', EAITYPE_Audio, , explosionRadius * 16); //CyberP: was 16

	if (explosionRadius <= 128)
		PlaySound(Sound'SmallExplosion1', SLOT_None,,, explosionRadius*32); //CyberP: was 16
	else
		PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*32); //CyberP: was 16

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, HitLocation);
	//light2 = Spawn(class'ExplosionLight',,, HitLocation+vect(0,0,8));
	if (explosionRadius < 128)
	{
		Spawn(class'ExplosionSmall',,, HitLocation);
		light.size = 6;
        //light2.size = 6;
	}
	else if (explosionRadius < 416)
	{
		Spawn(class'ExplosionMedium',,, HitLocation);
		Spawn(class'ExplosionMedium',,, loc);
		Spawn(class'ExplosionMedium',,, loc);
		light.size = 12;
        //light2.size = 12;
	}
	else
	{
		Spawn(class'ExplosionLarge',,, loc);
		Spawn(class'ExplosionLarge',,, loc);
		Spawn(class'ExplosionLarge',,, loc);
		Spawn(class'ExplosionMedium',,, loc);
		light.size = 24;
        //light2.size = 24;
	}

	// draw a pretty shock ring
	ring = Spawn(class'ShockRing',,, HitLocation, rot(16384,0,0));
	if (ring != None)
		ring.size = explosionRadius / 32.0;
	ring = Spawn(class'ShockRing',,, HitLocation, rot(0,0,0));
	if (ring != None)
		ring.size = explosionRadius / 32.0;
	ring = Spawn(class'ShockRing',,, HitLocation, rot(0,16384,0));
	if (ring != None)
		ring.size = explosionRadius / 32.0;

	// spawn a mark
	s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation+rot(16384,0,0));
	if (s != None)
	{
		s.DrawScale *= FClamp(explosionDamage/26, 0.1, 3.5); //CyberP: was 1st param was /30, 3rd was 3.0
		s.ReattachDecal();
	}
    /*ForEach RadiusActors(class'Actor',acti,explosionRadius*0.2)
    {
       if (acti.IsA('Inventory') && acti.Owner != None)
	   {
       }
       else
           acti.TakeDamage((2*explosionDamage) * 0.2,None,vect(0,0,0),vect(0,0,0),'Exploded');
    }*/
	// spawn some rocks
	for (i=0; i<explosionDamage/30+1; i++)
		spawn(class'Rockchip',,,HitLocation);

	GotoState('Exploding');
}

// ----------------------------------------------------------------------
// Exploding state
// ----------------------------------------------------------------------

state Exploding
{
	ignores Explode;

	function Timer()
	{
		local Pawn apawn;
		local float damageRadius;
		local Vector dist;

		if ( Level.NetMode != NM_Standalone )
		{
			damageRadius = (explosionRadius / gradualHurtSteps) * gradualHurtCounter;

			for ( apawn = Level.PawnList; apawn != None; apawn = apawn.nextPawn )
			{
				if ( apawn.IsA('DeusExPlayer') )
				{
					dist = apawn.Location - Location;
					if ( VSize(dist) < damageRadius )
						DeusExPlayer(apawn).myProjKiller = Self;
				}
			}
		}
		HurtRadius
		(
			(2 * explosionDamage) / gradualHurtSteps,
			(explosionRadius / gradualHurtSteps) * gradualHurtCounter,
			'Exploded',
			(explosionDamage / gradualHurtSteps) * 100,
			Location,gradualHurtCounter < 3
		);

		if (++gradualHurtCounter >= gradualHurtSteps)
			Destroy();
	}

Begin:
	// stagger the HurtRadius outward using Timer()
	// do five separate blast rings increasing in size
	gradualHurtCounter = 1;
	gradualHurtSteps = 5;
	bHidden = True;
	SetCollision(False, False, False);
	SetTimer(0.5/float(gradualHurtSteps), True);
}

// ----------------------------------------------------------------------
// this is our normal, just sitting there state
// ----------------------------------------------------------------------
auto state Active
{
	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
		local float avg;
		local float rnd;
		local float dammult, massmult;
        local int i;
        local DeusExFragment s;
        local bool hit;

		stickaround=false;
		//log("IN STATE ACTIVE AND DAMAGED "@Damage@" "@EventInstigator@" "@Momentum@" "@DamageType@" "@bStatic@" "@(Damage >= minDamageThreshold)@" "@HitPoints);

		if (bStatic || bInvincible)
			return;

		if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation'))
			return;

		if ((DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
			return;

        if (DamageType == 'EMP')
        {
            //Sarge: Add EMP Hit Markers
            if (eventInstigator != None && eventInstigator.IsA('DeusExPlayer') && bEMPHitMarkers)
            {
                if (DeusExPlayer(eventInstigator).bHitmarkerOn)
                    DeusExPlayer(eventInstigator).hitmarkerTime = 0.2;
            }
            return;
        }
        
        //Sarge: Add Hit Markers
        if (bHitMarkers && hit && eventInstigator != None && eventInstigator.IsA('DeusExPlayer'))
        {
            if (DeusExPlayer(eventInstigator).bHitmarkerOn)
                DeusExPlayer(eventInstigator).hitmarkerTime = 0.2;
        }

        if (DamageType == 'KnockedOut' && IsA('ElectronicDevices'))
            Damage *= 0.5; //CyberP: less damage from baton, rubber bullets and gas grenade explosion.
                                                                                //RSD: note KnockedOut for gas grenade perk here
		if (DamageType == 'HalonGas')
			{
            ExtinguishFire();
            return;
            }

    if (Mass < 100 && Physics != PHYS_Projectile && !bWrapped && (bPushable || IsA('BookOpen') || IsA('BookClosed')))
    {
    dammult = damage*0.2;
    if (dammult < 0.8)
    dammult = 0.8;
    else if (dammult > 3)
    dammult = 3;

    if (Mass < 10)
    massmult = 1;
    else if (Mass < 20)
    massmult = 0.9;
    else if (Mass < 30)
    massmult = 0.7;
    else if (Mass < 50)
    massmult = 0.5;
    else if (Mass < 80)
    massmult = 0.3;
    else
    massmult = 0.2;

    if (EventInstigator != None && EventInstigator.Weapon != none)
    {
      if (EventInstigator.Weapon.IsA('WeaponSawedOffShotgun') || EventInstigator.Weapon.IsA('WeaponAssaultShotgun') || EventInstigator.Weapon.IsA('WeaponPlasmaRifle'))
      {
       damage*=1.5;      //CyberP: ensure shotguns send trivial objects flying and deal realistic damage.
       massMult+=0.1;  //CyberP: bPushable check above means objects are trivial (e.g no hackable devices) which is
       damMult=4;      //CyberP: relevant as we don't want to deal extra dam to turrets etc nor send them flying, of course!
      }
      else if (EventInstigator != none && EventInstigator.Weapon != none && EventInstigator.Weapon.IsA('WeaponCrowbar')) //RSD: New special effect for the crowbar: additional 5 damage vs inanimate objects
       damage += 5;
    }

    if (IsA('Basketball'))
    {
    SetPhysics(PHYS_Falling);
    Velocity = (Momentum*0.4)*dammult*massmult;
    if (Velocity.Z < 0)
    Velocity.Z = 150+(damMult*14);
    bFixedRotationDir = True;
	RotationRate.Pitch = (32768 - Rand(65536)) * 6.0;
	RotationRate.Yaw = (32768 - Rand(65536)) * 6.0;
    }
    else if (Mass <= 30 && !bStoodOn)
    {
    SetPhysics(PHYS_Falling);
    Velocity = (Momentum*0.25)*dammult*massmult;
    if (Velocity.Z < 0)
    Velocity.Z = 140;
    if (!IsA('Microscope') && !IsA('Trashbag'))
    {
    bFixedRotationDir = True;
	RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
	RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
	}
    }
    else
    {
    if (!bFloating && (Physics != PHYS_Falling))
       SetPhysics(PHYS_Rolling);
    Velocity = (Momentum*0.25)*dammult*massmult;
    if (self.IsA('Cart'))
       Cart(self).DamageForce(Damage);
    }
    }

          if (fragType == class'GlassFragment' || IsA('Plant3') || IsA('Flowers'))
          { Frag(fragType,Momentum/8,0.3,12);} //CyberP: meh

        if ((IsA('Containers') && fragType == class'MetalFragment') || IsA('Vehicles') || IsA('CarStripped') || IsA('CarBurned'))
        {
        rnd = FRand();
        if (DamageType == 'Sabot' || DamageType == 'AutoShot' || DamageType == 'Shot')
          {
	       if (rnd < 0.33)
		      PlaySound(sound'HMETAL2',SLOT_None,,, 1536, 1.1 - 0.2*FRand());
	       else if (rnd < 0.66)
	          PlaySound(sound'HMETAL3',SLOT_None,,, 1536, 1.1 - 0.2*FRand());
       	   else
	    	  PlaySound(sound'HMETAL4',SLOT_None,,, 1536, 1.1 - 0.2*FRand());
          }
        }
        else if (fragType == class'MetalFragment' && !IsA('ElectronicDevices') && (DamageType == 'Sabot' || DamageType == 'AutoShot' || DamageType == 'Shot'))
             PlaySound(sound'bouncemetal',SLOT_Interact,2.0,, 1536, 1.1 - 0.2*FRand());

		if ((DamageType == 'Exploded') && (HitPoints <= 0))       //CyberP: for blown up deco
            {
                        if (fragType == class'FleshFragment')
                        {
                        spawn(class'FleshFragmentSmoking');
                        spawn(class'FleshFragmentSmoking');
                        }
            }

		if ((DamageType == 'Burned') || (DamageType == 'Flamed'))
		{
			if (bExplosive)		// blow up if we are hit by fire
            {
				HitPoints = 0;
                hit = true;
            }
			else if (bFlammable && !Region.Zone.bWaterZone)
			{
				GotoState('Burning');
				return;
			}
		}

		//log("DXdeco.Active.TakeDamage:-"@DamageType@" "@Damage@" "@EventInstigator);
//GMDX
		/*if ((EventInstigator!=none)&&EventInstigator.IsA('DeusExPlayer')&&
		(DamageType=='shot')&&
	  (DeusExPlayer(EventInstigator).inHand!=none)&&
	  DeusExPlayer(EventInstigator).inHand.IsA('DeusExWeapon')&&
	  !DeusExWeapon(DeusExPlayer(EventInstigator).inHand).bHandToHand&&
	  !(IsA('AutoTurret')||IsA('AlarmUnit')||IsA('SecurityCamera')) )
	  {
		 Damage*=(0.1+0.7*FRand());
	  }
		if (DamageType=='throw') log("MY DAMAGE TYPE");

		if (DamageType=='throw')
		{
			if (IsA('AutoTurret')||IsA('AlarmUnit')||IsA('SecurityCamera')) //CyberP: this doesn't work. Look into it soon
				Damage=0;
		} */
		if ((Damage >= minDamageThreshold)||((DamageType!='throw')&&(DamageScaler>0)&&(Damage >= minDamageThreshold)))
        {
			HitPoints -= Damage;
            hit = true;
        }
		else
		{
			// sabot damage at 50%
			// explosion damage at 25%
			if (damageType == 'Sabot')
            {
				HitPoints -= Damage * 0.5;
                hit = true;
            }
			else if (damageType == 'Exploded')
            {
				HitPoints -= Damage * 0.3;   //CyberP: 0.25
                hit = true;
            }
		}
            
        //Sarge: Add Hit Markers
        if (hit && eventInstigator != None && eventInstigator.IsA('DeusExPlayer'))
        {
            if (DeusExPlayer(eventInstigator).bHitmarkerOn)
                DeusExPlayer(eventInstigator).hitmarkerTime = 0.2;
        }

//      log(HitPoints);
		if (HitPoints > 0)		// darken it to show damage (from 1.0 to 0.1 - don't go completely black)
		{
		    if (Damage >= minDamageThreshold)
			   ResetScaleGlow();
			//log("SCALE GLOW!!!");
			stickaround=true;
			avg = (CollisionRadius + CollisionHeight) / 2;
			if(bPushable&&!IsA('Basketball')&&FRand()<0.5&&fragType!=class'MetalFragment')
			{
			for (i=0 ; i<4 ; i++)   //CyberP: Deco spawns fragments when shot
         	{
	     	s = DeusExFragment(Spawn(FragType, Owner,,HitLocation));
		    if (s != None)
		    {
			s.Instigator = Instigator;
			s.CalcVelocity(Momentum,0);
			s.DrawScale = avg*0.01+0.01*1.2*FRand();
			if (Frand() < 0.5)
			s.Skin = GetMeshTexture();
			else
            s.Skin = GetMeshTexture(1);
	     	}
	        }
			}
		}
		else	// destroy it!
		{
		   //log("Ready to Frag");
			DropThings();

			// clear the event to keep Destroyed() from triggering the event
			Event = '';
			avg = (CollisionRadius + CollisionHeight) / 2;
			Instigator = EventInstigator;
			if (Instigator != None)
				MakeNoise(1.0);

			if (fragType == class'WoodFragment')
			{
				if (avg > 20)
				{
				    if (FRand() < 0.5)
					PlaySound(sound'WoodBreakLarge', SLOT_Misc,,, 640);
					else
					PlaySound(sound'woodsmash2', SLOT_Misc,,, 640);
					AISendEvent('LoudNoise', EAITYPE_Audio, , 512);
				}
				else
				{
				    if (FRand() < 0.5)
                	PlaySound(sound'WoodBreakSmall', SLOT_Misc,,, 640);
                	else
                	PlaySound(sound'woodsmash1', SLOT_Misc,,, 640);
                	AISendEvent('LoudNoise', EAITYPE_Audio, , 320);
                }
			}
			else if (IsA('BoxLarge') || IsA('BoxMedium'))
			    PlaySound(sound'flindercardboard1', SLOT_Misc,,, 640);

			// if we have been blown up, then destroy our contents
			// CNN - don't destroy contents now
//			if (DamageType == 'Exploded')
//			{
//				Contents = None;
//				Content2 = None;
//				Content3 = None;
//			}
		 //log("bExplosive");
			if (bExplosive)
			{
				Frag(fragType, Momentum * explosionRadius / 3, avg/20.0, avg/5 + 1);
				Explode(HitLocation);
			}
			else
			{
			if (Damage > 50)       //CyberP: high damage sends fragments flying further
			{
			    Momentum.Z *= (FRand()*400);
			    Frag(fragType, Momentum / 4.5, avg/20.0, avg/5 + 1);
			}
			else if (Damage > 30)
			{
			    Momentum.Z *= (FRand()*300);
			    Frag(fragType, Momentum / 6, avg/20.0, avg/5 + 1);
			}
			else if (Damage > 22)
			{
			    Momentum.Z *= (FRand()*200);
			    Frag(fragType, Momentum / 8, avg/20.0, avg/5 + 1);
			}
			else
				Frag(fragType, Momentum / 10, avg/20.0, avg/5 + 1);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ExtinguishFire()
// ----------------------------------------------------------------------

function ExtinguishFire()
{
	local Fire f;

	if (IsInState('Burning'))
	{
		foreach BasedActors(class'Fire', f)
			f.Destroy();

		GotoState('Active');
	}
}

// ----------------------------------------------------------------------
// state Burning
//
// We are burning and slowly taking damage
// ----------------------------------------------------------------------

state Burning
{
	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
		local float avg;

		if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation'))
			return;

		if ((DamageType == 'EMP') || (DamageType == 'NanoVirus') || (DamageType == 'Shocked'))
			return;

		if (DamageType == 'HalonGas')
			ExtinguishFire();

		// if we are already burning, we can't take any more damage
		if ((DamageType == 'Burned') || (DamageType == 'Flamed'))
		{
			HitPoints -= Damage/2;
		}
		else
		{
			if (Damage >= minDamageThreshold) //gmdx have to think on this a little :/
				HitPoints -= Damage;
		}

		if (bExplosive)
			HitPoints = 0;

		if (HitPoints > 0)		// darken it to show damage (from 1.0 to 0.1 - don't go completely black)
		{
			ResetScaleGlow();

			stickaround=true;
			avg = (CollisionRadius + CollisionHeight) / 2;
			if(!bExplosive&&bPushable&&Damage>2)
			   Frag(fragType, Momentum / 10, avg/60.0, 1);  //GMDX: Frags are spawned when damaged
		}
		else	// destroy it!
		{
			//DropThings();

			// clear the event to keep Destroyed() from triggering the event
			Event = '';
			avg = (CollisionRadius + CollisionHeight) / 2;
			Frag(fragType, Momentum / 10, avg/20.0, avg/5 + 1);
			Instigator = EventInstigator;
			if (Instigator != None)
				MakeNoise(1.0);

			// if we have been blown up, then destroy our contents
			if (bExplosive)
			{
				Contents = None;
				Content2 = None;
				Content3 = None;
				Explode(HitLocation);
			}
		}
	}

	// continually burn and do damage
	function Timer()
	{
		if (bPushSoundPlaying)
		{
			StopSound(pushSoundId);
			AIEndEvent('LoudNoise', EAITYPE_Audio);
			bPushSoundPlaying = False;
		}
		TakeDamage(2, None, Location, vect(0,0,0), 'Burned');
	}

	function BeginState()
	{
		local Fire f;
		local int i;
		local vector loc;

		for (i=0; i<8; i++)
		{
			loc.X = 0.9*CollisionRadius * (1.0-2.0*FRand());
			loc.Y = 0.9*CollisionRadius * (1.0-2.0*FRand());
			loc.Z = 0.9*CollisionHeight * (1.0-2.0*FRand());
			loc += Location;
			f = Spawn(class'Fire', Self,, loc);
			if (f != None)
			{
				f.DrawScale = FRand() + 1.0;
				f.LifeSpan = Flammability + 1.0;

				// turn off the sound and lights for all but the first one
				if (i > 0)
				{
					f.AmbientSound = None;
					f.LightType = LT_None;
				}

				// turn on/off extra fire and smoke
				if (FRand() < 0.5)
					f.smokeGen.Destroy();
				if (FRand() < 0.5)
					f.AddFire(1.5);
			}
		}

		// set the burn timer
		SetTimer(1.0, True);
	}
}

// ----------------------------------------------------------------------
// Frob()
//
// If we are frobbed, trigger our event
// ----------------------------------------------------------------------
function Frob(Actor Frobber, Inventory frobWith)
{
	local Actor A;
	local Pawn P;
	local DeusExPlayer Player;

	P = Pawn(Frobber);
	Player = DeusExPlayer(Frobber);

	Super.Frob(Frobber, frobWith);

	// First check to see if there's a conversation associated with this
	// decoration.  If so, trigger the conversation instead of triggering
	// the event for this decoration

	if ( Player != None )
	{
		if ( player.StartConversation(Self, IM_Frob) )
			return;
	}

	// Trigger event if we aren't hackable
	if (!IsA('HackableDevices'))
		if (Event != '')
			foreach AllActors(class 'Actor', A, Event)
				A.Trigger(Self, P);
}

// ----------------------------------------------------------------------
// Frag()
//
// copied from Engine.Decoration
// modified so fragments will smoke	and use the skin of their parent object
// ----------------------------------------------------------------------

simulated function Frag(class<fragment> FragType, vector Momentum, float DSize, int NumFrags)
{
	local int i;
	local actor A, Toucher;
	local DeusExFragment s;
	local vector vecta;

	//log("bOnlyTriggerable="@bOnlyTriggerable);
	if ( bOnlyTriggerable||bInvincible )
		return;
	if (Event!='')
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Toucher, pawn(Toucher) );
	if ( Region.Zone.bDestructive )
	{
	  //log("Destructive");
		Destroy();
		return;
	}

	if (IsA('Plant1') || IsA('Plant2') || IsA('Plant3') || IsA('Flowers'))
	{
	 for (i=0 ; i<NumFrags*14 ; i++)   //CyberP: plus 2
	{
	    vecta = Location;
	    vecta.Z -= (CollisionHeight * 0.4);
		s = Spawn(class'Rockchip', Owner,,vecta);
		if (s != None)
		{
			s.CalcVelocity(Momentum,0);
			s.DrawScale = DSize*0.2+0.7*DSize*FRand();
			s.Skin = Texture'GMDXSFX.Earth.ExpoLakeBed';
			if (stickaround)
			{
			 s.DrawScale*=0.375;
		     s.CalcVelocity(Momentum*0.1,0.8);
			}
		}
	}
	}

	for (i=0 ; i<NumFrags+6 ; i++)   //CyberP: plus 6
	{
		s = DeusExFragment(Spawn(FragType, Owner));
		if (s != None)
		{
			s.Instigator = Instigator;
			s.CalcVelocity(Momentum,0);
			s.DrawScale = DSize*0.5+0.2*DSize*FRand();
			//if (!s.IsA('GlassFragment'))
			//{
            if (Frand() < 0.5)
			s.Skin = GetMeshTexture();
			else
            s.Skin = GetMeshTexture(1); //CyberP: getMeshTexture multiskin 1
            s.SkinVariation();
		//	}
            if ((bExplosive)||(stickaround&&IsInState('Burning')))
		    {
				if (FRand() < 0.025)
                   s.bSmoking = True;
				if (stickaround)
				{
				  s.LifeSpan*=2;
				  s.DrawScale*=0.5;
			      s.CalcVelocity(Momentum,1.8);
				}
			}

		}
	}
    if (!bExplosive&&!stickaround)
		Destroy();

	stickaround=false;
}

// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------

function Destroyed()
{
	local DeusExPlayer player;

	if (bPushSoundPlaying)
	{
		StopSound(pushSoundId);
		AIEndEvent('LoudNoise', EAITYPE_Audio);
		bPushSoundPlaying = False;
	}

	if (flyGen != None)
	{
		flyGen.Burst();
		flyGen.StopGenerator();
		flyGen = None;
	}

	if (fragType == class'GlassFragment')
	PlaySound(sound'GlassBreakSmall',SLOT_Interact,2.0,,1024);

	// Pass a message to conPlay, if it exists in the player, that
	// this object has been destroyed.  This is used to prevent
	// bad things from happening in converseations.

	player = DeusExPlayer(GetPlayerPawn());

	if ((player != None) && (player.conPlay != None))
	{
		player.conPlay.ActorDestroyed(Self);
	}

	DropThings();

	if (!IsA('Containers'))
		Super.Destroyed();
}

// ----------------------------------------------------------------------
// Trigger()
//
// if we are triggered and explosive, then explode
// ----------------------------------------------------------------------

function Trigger(Actor Other, Pawn Instigator)
{
	if (bExplosive)
	{
		Explode(Location);
		Super.Trigger(Other, Instigator);
	}
}

/*event LostChild(Actor Other)
{
   if(Other == standingActorGlobal)
   {
      standingActorGlobal = None;
   }
   super.LostChild(Other);
}*/

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HitPoints=20
     FragType=Class'DeusEx.MetalFragment'
     Flammability=30.000000
     explosionDamage=100
     explosionRadius=768.000000
     bHighlight=True
     ItemArticle="a"
     ItemName="DEFAULT DECORATION NAME - REPORT THIS AS A BUG"
     bPushable=True
     PushSound=Sound'DeusExSounds.Generic.PushMetal'
     bStatic=False
     bTravel=True
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     iHDTPModelToggle=1
}
