//=============================================================================
// SpyDrone.
//=============================================================================
class SpyDrone extends ThrownProjectile;

var bool bCloaked;                                                              //SARGE: Whether or not this drone is cloaked

var float detectionRange;                                                       //SARGE: Range at which enemies can detect the drone

var bool bEMPDeath;                                                              //SARGE: Track if we were destroyed by EMP. The death is delayed, so it needs to not reset our view afterwards.

var localized string msgDroneRecovered;                                         //SARGE: Message when reclaiming a drone

auto state Flying
{
	function ProcessTouch (Actor Other, Vector HitLocation)
	{
	}
	simulated function HitWall (vector HitNormal, actor HitWall)
	{
		// do nothing
		// Added elasticity - DEUS_EX CNN
	    if (HitWall == Level)
	      Velocity = 0.4*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	}
}

function SetCloak()
{
    local DeusExPlayer player;
    player = DeusExPlayer(Owner);
    
    if (player != None && player.bSpyDroneSet || player.spyDroneLevel > 2)
        bCloaked = true;
    else
        bCloaked = false;
}

function Tick(float deltaTime)
{
    local ScriptedPawn pawn;

    SetCloak();

	// cause enemies to search for the source if it's not cloaked.
    if (bCloaked)
        Style=STY_Translucent;
    else
    {
        Style=STY_Normal;

        //SARGE: AISendEvent has a seemingly unlimited range, and the radius variable does nothing
        //So, we need to do this manually.
        //This is gross, but ehh, it works.
        //AISendEvent('Projectile', EAITYPE_Visual);
        foreach VisibleActors(class'ScriptedPawn', pawn, detectionRange)
        {
            if ((pawn.bFearProjectiles || pawn.bReactProjectiles) && pawn.bLookingForProjectiles)
            {
                pawn.ReactToProjectiles(self);
                //If one person knows about it, everyone knows about it
                AISendEvent('Projectile', EAITYPE_Audio);
            }
        }
    }
}

function Timer()
{
Skin = None;
Style=STY_Normal;
ScaleGlow=default.ScaleGlow;
LightRadius = 0;
AmbientGlow = default.AmbientGlow;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name damageType)
{
	// fall to the ground if EMP'ed
	if ((DamageType == 'EMP') && !bDisabled)
	{
		SetPhysics(PHYS_Falling);
		bBounce = True;
		LifeSpan = 10.0;
		Style = Default.Style;
        ScaleGlow = 1;
        LightRadius = 0;
        bEMPDeath = true;
        ForceDroneOff();
	}

	if ( Level.NetMode != NM_Standalone )
	{
		if ( DeusExPlayer(Owner) != None )
			DeusExPlayer(Owner).ForceDroneOff();
		else
			log("Warning:Drone with no owner?" );
	}
	Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, damageType);
}

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ExplosionLight light;
	local int i;
	local Rotator rot;
	local SphereEffect sphere;
	local ExplosionSmall expeffect;
    local SphereEffectPlasma sphere2;

    AISendEvent('LoudNoise',EAITYPE_Audio,,1024); //CyberP: drone exploding mades noise
	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, HitLocation);
	if (light != None)
	{
		if (!bDamaged)
			light.RemoteRole = ROLE_None;
		light.size = 8;
		light.LightHue = 128;
		light.LightSaturation = 96;
		light.LightEffect = LE_Shell;
	}

    PlaySound(Sound'DeusExSounds.Weapons.EMPGrenadeExplode',SLOT_None,,,blastRadius*4);

	expeffect = Spawn(class'ExplosionSmall',,, HitLocation);
	if ((expeffect != None) && (!bDamaged))
		expeffect.RemoteRole = ROLE_None;

	// draw a cool light sphere
	sphere = Spawn(class'SphereEffect',,, HitLocation);
	if (sphere != None)
	{
		if (!bDamaged)
			sphere.RemoteRole = ROLE_None;
		sphere.size = blastRadius / 28.0;
	}
	sphere2 = Spawn(class'SphereEffectPlasma',,, HitLocation);
	if (sphere2 != None)
	{
		if (!bDamaged)
			sphere2.RemoteRole = ROLE_None;
		sphere2.Skin=Texture'Effects.Electricity.Xplsn_EMPG';
		sphere2.size = blastRadius / 46.0;
	}
}

function BeginPlay()
{
	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPAlarmLightTex6","DeusExDeco.Skins.AlarmLightTex6",IsHDTP());
    PlaySound(Sound'CloakUp', SLOT_Pain, 0.85, ,768,1.0);
    //Spawn(class'SpoofedCoronaSmall');
    ScaleGlow=0.1;
    LightType = LT_Strobe;
    LightBrightness = 64;
    LightHue = 160;
    LightSaturation = 96;
    LightRadius = 6;
    AmbientGlow = 224;
	SetTimer(0.4,false);
}

function ForceDroneOff()
{
	if ( DeusExPlayer(Owner) != None )
	{
		DeusExPlayer(Owner).aDrone = None;
        DeusExPlayer(Owner).ForceDroneOff();                                    //RSD: Added
    }
}

function Destroyed()
{
    if (!bEMPDeath) //EMP Death is delayed, so we need to not reset the players view, etc.
        ForceDroneOff();
	Super.Destroyed();
}

function Frob(Actor Frobber, Inventory frobWith)
{
    local DeusExPlayer player;
    local Augmentation droneAug;

    player = DeusExPlayer(frobber);

    if (player != None && player.AugmentationSystem != None)
    {
        droneAug = player.AugmentationSystem.FindAugmentation(class'AugDrone');

        if (droneAug != None) //This should never fail
        {
            player.ClientMessage(msgDroneRecovered);
            droneAug.bSilentDeactivation = true; //Don't show message or play sound.
            Destroy();
            droneAug.GiveFullRecharge();
        }
    }

    super.Frob(Frobber,frobWith);
}

defaultproperties
{
     elasticity=0.200000
     fuseLength=0.000000
     proxRadius=128.000000
     bHighlight=True
     bBlood=False
     bDebris=False
     blastRadius=128.000000
     DamageType=EMP
     bEmitDanger=False
     ItemName="Remote Spy Drone"
     MaxSpeed=0.000000
     Damage=20.000000
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion2'
     Physics=PHYS_Projectile
     RemoteRole=ROLE_DumbProxy
     LifeSpan=0.000000
     Mesh=LodMesh'DeusExCharacters.SpyDrone'
     DrawScale=0.350000 //SARGE: Was 0.75
     SoundRadius=24
     SoundVolume=192
     AmbientSound=Sound'DeusExSounds.Augmentation.AugDroneLoop'
     CollisionRadius=9.750000
     CollisionHeight=2.070000
     Mass=10.000000
     Buoyancy=2.000000
     detectionRange=350
     msgDroneRecovered="Spy Drone Reclaimed"
}
