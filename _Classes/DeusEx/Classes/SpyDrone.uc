//=============================================================================
// SpyDrone.
//=============================================================================
class SpyDrone extends ThrownProjectile;

var bool bCloaked;                                                              //SARGE: Whether or not this drone is cloaked

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
    SetCloak();

	// cause enemies to search for the source if it's not cloaked.
    if (bCloaked)
    {
        Style=STY_Translucent;
        AIEndEvent('Projectile', EAITYPE_Visual);
    }
    else
    {
        Style=STY_Normal;
        AIStartEvent('Projectile', EAITYPE_Visual);
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
    Skin = Texture'HDTPDecos.Skins.HDTPAlarmLightTex6';
    //PlaySound(Sound'CloakUp', SLOT_Pain, 0.85, ,768,1.0);
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

function Destroyed()
{
	if ( DeusExPlayer(Owner) != None )
	{
		DeusExPlayer(Owner).aDrone = None;
        DeusExPlayer(Owner).ForceDroneOff();                                    //RSD: Added
    }
	Super.Destroyed();
}

defaultproperties
{
     elasticity=0.200000
     fuseLength=0.000000
     proxRadius=128.000000
     bHighlight=False
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
}
