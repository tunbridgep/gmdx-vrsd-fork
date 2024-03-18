//=============================================================================
// CyberP: is actually an EMP grenade
//=============================================================================
class SpiderConstructorLaunched2 extends DeusExProjectile;

var ParticleGenerator smokeGen;
var ParticleGenerator smokeGen2;
var ParticleGenerator smokeGen3;
var ParticleGenerator sparkGen3;
var ParticleGenerator sparkGen;
var ParticleGenerator sparkGen2;

function PostBeginPlay()
	{
	Super.PostBeginPlay();

	    PlaySound(sound'MediumExplosion1',SLOT_None,3.0,,3072);

        sparkGen = Spawn(class'ParticleGenerator', Self);
    if (sparkGen != None)
    {
	  sparkGen.RemoteRole = ROLE_None;
		sparkGen.particleTexture = Texture'Effects.Fire.Spark_Electric';
		sparkGen.particleDrawScale = 0.09;
		sparkGen.checkTime = 0.025; //CyberP: 0.02
		sparkGen.riseRate = 2.0;
		sparkGen.ejectSpeed = 10.0;
		sparkGen.particleLifeSpan = 0.7; //was 2.0
		sparkGen.bRandomEject = True;
		sparkGen.SetBase(Self);
	}
	sparkGen2 = Spawn(class'ParticleGenerator', Self);
    if (sparkGen2 != None)
    {
	  sparkGen2.RemoteRole = ROLE_None;
		sparkGen2.particleTexture = Texture'Effects.Fire.Spark_Electric';
		sparkGen2.particleDrawScale = 0.1;
		sparkGen2.checkTime = 0.02; //CyberP: 0.02
		sparkGen2.riseRate = 2.0;
		sparkGen2.ejectSpeed = 18.0;
		sparkGen2.particleLifeSpan = 0.72; //was 2.0
		sparkGen2.bRandomEject = True;
		sparkGen2.SetBase(Self);
		sparkGen2.frequency = 10;
	}
	sparkGen3 = Spawn(class'ParticleGenerator', Self);
    if (sparkGen3 != None)
    {
	  sparkGen3.RemoteRole = ROLE_None;
		sparkGen3.particleTexture = Texture'Effects.Fire.Spark_Electric';
		sparkGen3.particleDrawScale = 0.05;
		sparkGen3.checkTime = 0.02; //CyberP: 0.02
		sparkGen3.riseRate = 2.0;
		sparkGen3.ejectSpeed = 30.0;
		sparkGen3.particleLifeSpan = 0.8; //was 2.0
		sparkGen3.bRandomEject = True;
		sparkGen3.SetBase(Self);
	}
        smokeGen3 = Spawn(class'ParticleGenerator', Self);
	if (smokeGen3 != None)
	{
	  smokeGen3.RemoteRole = ROLE_None;
		smokeGen3.particleTexture = Texture'GMDXSFX.Effects.ef_ExLrg001';
		smokeGen3.particleDrawScale = 0.15;
		smokeGen3.checkTime = 0.02; //CyberP: 0.02
		smokeGen3.riseRate = 8.0;
		smokeGen3.ejectSpeed = 30.0;
		smokeGen3.particleLifeSpan = 1.5; //was 2.0
		smokeGen3.bRandomEject = True;
		smokeGen3.SetBase(Self);
	}
        smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
	  smokeGen.RemoteRole = ROLE_None;
		smokeGen.particleTexture = Texture'GMDXSFX.Effects.ef_ExLrg001';
		smokeGen.particleDrawScale = 0.175;
		smokeGen.checkTime = 0.02; //CyberP: 0.02
		smokeGen.riseRate = 8.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 1.5; //was 2.0
		smokeGen.bRandomEject = True;
		smokeGen.SetBase(Self);
	}
	smokeGen2 = Spawn(class'ParticleGenerator', Self); //CyberP Start
	if (smokeGen2 != None)
	{
	  smokeGen2.RemoteRole = ROLE_None;
		smokeGen2.particleTexture = Texture'GMDXSFX.Effects.ef_ExLrg001';
		smokeGen2.particleDrawScale = 0.2; //0.3
		smokeGen2.checkTime = 0.02; //CyberP: 0.02
		smokeGen2.riseRate = 8.0;
		smokeGen2.ejectSpeed = 20.0; //0
		smokeGen2.particleLifeSpan = 1.4;
		smokeGen2.bRandomEject = True;
		smokeGen2.SetBase(Self);
		smokeGen2.frequency = 10;
	}
	}

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local SphereEffect sphere;
	local ExplosionLight light;

   if (smokeGen != None)
		smokeGen.DelayedDestroy();
        if (smokeGen2 != None)
		smokeGen2.DelayedDestroy();
		if (smokeGen3 != None)
		smokeGen3.DelayedDestroy();
		if (sparkGen != None)
		sparkGen.DelayedDestroy();
        if (sparkGen2 != None)
		sparkGen2.DelayedDestroy();
		if (sparkGen3 != None)
		sparkGen3.DelayedDestroy();

    Spawn(class'ExplosionSmall',,, HitLocation);

	light = Spawn(class'ExplosionLight',,, HitLocation);
	if (light != None)
	{
		light.size = 8;
		light.LightHue = 128;
		light.LightSaturation = 96;
		light.LightEffect = LE_Shell;
	}

	// draw a cool light sphere
	sphere = Spawn(class'SphereEffect');
	if (sphere != None)
   {
		sphere.size = 10;
		sphere.bEmitElec=True;
   }
}

simulated function Destroyed()
{
	if (smokeGen != None)
		smokeGen.DelayedDestroy();
        if (smokeGen2 != None)
		smokeGen2.DelayedDestroy();
		 if (smokeGen3 != None)
		smokeGen3.DelayedDestroy();
		if (sparkGen != None)
		sparkGen.DelayedDestroy();
        if (sparkGen2 != None)
		sparkGen2.DelayedDestroy();
		if (sparkGen3 != None)
		sparkGen3.DelayedDestroy();
	Super.Destroyed();
}

defaultproperties
{
     bExplodes=True
     bDebris=True
     blastRadius=256.000000
     DamageType=EMP
     AccurateRange=2000
     maxRange=3000
     ItemName="HE 20mm Shell"
     ItemArticle="a"
     gravMult=0.450000
     speed=1200.000000
     Damage=80.000000
     MomentumTransfer=40000
     SpawnSound=Sound'DeusExSounds.Generic.SmallExplosion1'
     ImpactSound=Sound'DeusExSounds.Weapons.NanoVirusGrenadeExplode'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Skin=Texture'HDTPItems.Skins.HDTPAugUpCanTex0'
}
