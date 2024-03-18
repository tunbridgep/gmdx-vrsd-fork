//=============================================================================
// PlasmaBolt.
//=============================================================================
class PlasmaGamma extends DeusExProjectile;

var ParticleGenerator pGen1;
var ParticleGenerator pGen2;
var ParticleGenerator smokeGene;
var SpoofedCoronaSmall spoof;

var float mpDamage;
var float mpBlastRadius;

#exec OBJ LOAD FILE=Effects

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ParticleGenerator gen;
	local ExplosionLight bright;
    local SphereEffectPlasma shield;
    local PlasmaParticleSpoof spoofed;
    local int i;
    local SpoofedCorona cor;
	// create a particle generator shooting out plasma spheres
	shield = Spawn(class'SphereEffectPlasma');
	if (shield != none)
	{
	shield.size = 5.5;
	shield.LifeSpan= 0.4;
	shield.Skin = Texture'HDTPDecos.Skins.HDTPAlarmLightTex6';
	shield.LightHue=160;
	}
	cor = Spawn(class'SpoofedCorona',,,Location+Vector(Rotation)*1.5);
	if (cor != none)
	{
	cor.DrawScale=9.000000;
	cor.Skin=Texture'Effects.Corona.Corona_C';
	cor.LightRadius=0;
	}

	for (i=0;i<18;i++)
	{
	spoofed = Spawn(class'PlasmaParticleSpoof');
    if (spoofed != none)
    {
    spoofed.Texture=Texture'HDTPDecos.Skins.HDTPAlarmLightTex6';
    spoofed.LifeSpan=0.750000;
    spoofed.LightHue=160;
    }
    }

	gen = Spawn(class'ParticleGenerator',,, HitLocation, Rotator(HitNormal));
	if (gen != None)
	{
		bright = Spawn(class'ExplosionLight',,,HitLocation+(Vector(Rotation)*4.5), Rotation);
		bright.size = 16;


     		bright.LightBrightness=255;
     		bright.LightHue=156;
     		bright.LightSaturation=96;

		gen.RemoteRole = ROLE_None;
		gen.particleDrawScale = 0.1;
		gen.checkTime = 0.10;
		gen.frequency = 1.0;
		gen.ejectSpeed = 200.0;
		gen.bGravity = True;
		gen.bRandomEject = True;
		gen.particleLifeSpan = 0.75;
		gen.particleTexture =Texture'Effects.Fire.Spark_Electric';
		gen.LifeSpan = 1.3;

	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ((Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer))
		SpawnPlasmaEffects();
}

simulated function PostNetBeginPlay()
{
	if (Role < ROLE_Authority)
		SpawnPlasmaEffects();
}

// DEUS_EX AMSD Should not be called as server propagating to clients.
simulated function SpawnPlasmaEffects()
{
	local Rotator rot;
	rot = Rotation;
	rot.Yaw -= 32768;

    spoof = Spawn(class'SpoofedCoronaSmall', Self,, Location, rot);
    if (spoof != none)
    {
    spoof.bNoScale = True;
    spoof.Skin = Texture'Effects.Corona.Corona_A';
    spoof.DrawScale *= 0.5;
    spoof.LifeSpan=50.000000;
    spoof.SetBase(Self);
    }
	pGen2 = Spawn(class'ParticleGenerator', Self,, Location, rot);
	if (pGen2 != None)
	{
		pGen2.RemoteRole = ROLE_None;
		pGen2.particleTexture = Texture'Effects.Fire.Spark_Electric';
		pGen2.particleDrawScale = 0.05;
		pGen2.checkTime = 0.01; //Cyber: was 0.04
		pGen2.riseRate = 0.0;
		pGen2.ejectSpeed = 20.0;
		pGen2.particleLifeSpan = 0.5; //CyberP: was check
		pGen2.bRandomEject = False;
		pGen2.SetBase(Self);
	}
	SmokeGene = Spawn(class'ParticleGenerator', Self,, Location, rot);
	if (smokeGene != None)
	{
	  smokeGene.RemoteRole = ROLE_None;
		smokeGene.particleTexture = Texture'DeusExItems.Skins.FlatFXTex41';//'HDTPDecos.Skins.HDTPWaterFountaintex2';
		smokeGene.particleDrawScale = 0.08;
		smokeGene.checkTime = 0.04;
		smokeGene.riseRate = 0.0;
		smokeGene.ejectSpeed = 20.0;
		smokeGene.particleLifeSpan = 0.5;
		smokeGene.bRandomEject = False;
		smokeGene.SetBase(Self);
	}
}

simulated function Destroyed()
{
	if (pGen1 != None)
		pGen1.DelayedDestroy();
	if (pGen2 != None)
		pGen2.DelayedDestroy();
	if (smokeGene != none)
        smokeGene.DelayedDestroy();
    if (spoof != none)
        spoof.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     mpDamage=20.000000
     mpBlastRadius=288.000000
     bExplodes=True
     blastRadius=224.000000
     DamageType=exploded
     AccurateRange=14400
     maxRange=24000
     bIgnoresNanoDefense=True
     ItemName="Plasma Bolt"
     ItemArticle="a"
     speed=9000.000000
     Damage=11.000000
     MomentumTransfer=5000
     SpawnSound=Sound'GMDXSFX.Weapons.newfirelaser'
     ImpactSound=Sound'DeusExSounds.Robot.MilitaryBotExplode'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Skin=Texture'HDTPDecos.Skins.HDTPAlarmLightTex6'
     Mesh=LodMesh'DeusExItems.PlasmaBolt'
     DrawScale=2.000000
     ScaleGlow=0.600000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=224
     LightHue=156
     LightSaturation=32
     LightRadius=8
     bFixedRotationDir=True
}
