//=============================================================================
// PlasmaBolt.
//=============================================================================
class PlasmaRobot extends DeusExProjectile;

var ParticleGenerator pGen1;
var ParticleGenerator pGen2;
var() sound	   ImpactSound1;	                                                //RSD: For randomized impact sounds
var() sound	   ImpactSound2;	                                                //RSD: For randomized impact sounds
var() sound	   ImpactSound3;	                                                //RSD: For randomized impact sounds

var float mpDamage;
var float mpBlastRadius;

#exec OBJ LOAD FILE=Effects

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ParticleGenerator gen;
	local ExplosionLight bright;

	// create a particle generator shooting out plasma spheres
	//Spawn(class'SphereEffectPlasma');                                         //RSD: No sphere effect to represent smaller blast radius
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	Spawn(class'PlasmaParticleSpoof');
	gen = Spawn(class'ParticleGenerator',,, HitLocation, Rotator(HitNormal));
	if (gen != None)
	{
		bright = Spawn(class'ExplosionLight',,,HitLocation+(Vector(Rotation)*4.5), Rotation);
		bright.size = 12;


     		bright.LightBrightness=224;
     		bright.LightHue=80;
     		bright.LightSaturation=128;

		gen.RemoteRole = ROLE_None;
		gen.particleDrawScale = 1.0;
		gen.checkTime = 0.10;
		gen.frequency = 1.0;
		gen.ejectSpeed = 200.0;
		gen.bGravity = True;
		gen.bRandomEject = True;
		gen.particleLifeSpan = 0.75;
		gen.particleTexture =Texture'Effects.Fire.Proj_PRifle';
		gen.LifeSpan = 1.3;

	}
}

/*function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ((Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer))
		SpawnPlasmaEffects();
} */

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	//Damage = mpDamage;                                                        //RSD: Get out of here
	//blastRadius = mpBlastRadius;
}

simulated function Destroyed()
{
	if (pGen1 != None)
		pGen1.DelayedDestroy();
	if (pGen2 != None)
		pGen2.DelayedDestroy();

	Super.Destroyed();
}

function PlayImpactSound()                                                      //RSD: Overwrites the function in DeusExProjectile.uc for randomized impact sounds
{
	local float rad, num;

	rad = Max(blastRadius*28, 2048); //CyberP: was *4
	num = FRand();

    if (num < 0.33)
        PlaySound(ImpactSound1, SLOT_None, 2.0,, rad);
    else if (num < 0.66)
        PlaySound(ImpactSound2, SLOT_None, 2.0,, rad);
    else
        PlaySound(ImpactSound3, SLOT_None, 2.0,, rad);
}

defaultproperties
{
     ImpactSound1=Sound'GMDXSFX.Weapons.GMDX_Plasma1'
     ImpactSound2=Sound'GMDXSFX.Weapons.GMDX_Plasma2'
     ImpactSound3=Sound'GMDXSFX.Weapons.GMDX_Plasma3'
     mpDamage=20.000000
     mpBlastRadius=300.000000
     bExplodes=True
     blastRadius=96.000000
     DamageType=Burned
     AccurateRange=14400
     maxRange=24000
     bIgnoresNanoDefense=True
     ItemName="Plasma Bolt"
     ItemArticle="a"
     speed=6600.000000
     Damage=15.000000
     MomentumTransfer=5000
     ImpactSound=Sound'DeusExSounds.Weapons.PlasmaRifleHit'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex4'
     Mesh=LodMesh'DeusExItems.PlasmaBolt'
     DrawScale=0.800000
     bUnlit=True
     SoundRadius=128
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=224
     LightHue=80
     LightSaturation=128
     LightRadius=6
     bFixedRotationDir=True
}
