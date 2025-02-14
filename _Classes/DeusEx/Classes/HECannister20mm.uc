//=============================================================================
// HECannister20mm.
//=============================================================================
class HECannister20mm extends DeusExProjectile;

var ParticleGenerator smokeGen;
var ParticleGenerator smokeGen2;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Level.NetMode == NM_DedicatedServer)
		return;

	//SpawnSmokeEffects();
}

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	if (Role != ROLE_Authority)
		SpawnSmokeEffects();
}

simulated function SpawnSmokeEffects()
{
	smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
		smokeGen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen.particleDrawScale = 0.2;
		smokeGen.checkTime = 0.02;
		smokeGen.riseRate = 8.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 1.2;
		smokeGen.bRandomEject = True;
		smokeGen.SetBase(Self);
		smokeGen.RemoteRole = ROLE_None;
	}
	smokeGen2 = Spawn(class'ParticleGenerator', Self);
	if (smokeGen2 != None)
	{
		smokeGen2.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		smokeGen2.particleDrawScale = 0.23;
		smokeGen2.checkTime = 0.025;
		smokeGen2.riseRate = 8.0;
		smokeGen2.ejectSpeed = 4.0;
		smokeGen2.particleLifeSpan = 1.23;
		smokeGen2.bRandomEject = True;
		smokeGen2.SetBase(Self);
		smokeGen2.RemoteRole = ROLE_None;
	}
}

simulated function Destroyed()
{
	if (smokeGen != None)
		smokeGen.DelayedDestroy();
     if (smokeGen2 != None)
		smokeGen2.DelayedDestroy();
	Super.Destroyed();
}

function UpdateHDTPSettings()
{
    super.UpdateHDTPSettings();
    MultiSkins[0]=class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPminicrossbowtex3","DeusExItems.Skins.MiniCrossbowTex3",IsHDTP());
}

defaultproperties
{
     bExplodes=True
     bBlood=True
     bDebris=True
     blastRadius=352.000000
     DamageType=exploded
     AccurateRange=350
     maxRange=1000
     ItemName="HE 20mm Shell"
     ItemArticle="a"
     gravMult=0.600000
     HDTPMesh="HDTPItems.HDTPShotguncasing"
     hdtpReference=Class'DeusEx.WeaponAssaultGun'
     speed=1400.000000
     MaxSpeed=1400.000000
     Damage=200.000000
     MomentumTransfer=40000
     SpawnSound=Sound'DeusExSounds.Generic.SmallExplosion1'
     ImpactSound=Sound'DeusExSounds.Generic.MediumExplosion2'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Mesh=LodMesh'DeusExItems.ShellCasing'
     DrawScale=2.400000
}
