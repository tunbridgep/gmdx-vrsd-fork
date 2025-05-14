//=============================================================================
// RocketWP.
//=============================================================================
class RocketWP extends Rocket;

var float mpExplodeDamage;

#exec OBJ LOAD FILE=Effects

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ExplosionLight light;
	local ParticleGenerator gen;
	local ExplosionSmall expeffect;
	local ExplosionMedium expeffectMed;

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, HitLocation);
	if (light != None)
	{
		light.RemoteRole = ROLE_None;
		light.size = 12;
	}

	expeffect = Spawn(class'ExplosionSmall',,, HitLocation);
	if (expeffect != None)
		expeffect.RemoteRole = ROLE_None;

    expeffectMed = Spawn(class'ExplosionMedium',,, HitLocation);
	if (expeffectMed != None)
		expeffectMed.RemoteRole = ROLE_None;

 	// create a particle generator shooting out white-hot fireballs
	gen = Spawn(class'ParticleGenerator',,, HitLocation, Rotator(HitNormal));
	if (gen != None)
	{
		gen.RemoteRole = ROLE_None;
		gen.particleDrawScale = 0.8;
		gen.checkTime = 0.04;
		gen.frequency = 0.7;
		gen.ejectSpeed = 200.0;
		gen.bGravity = true;
		gen.bRandomEject = true;
		gen.particleTexture = Texture'Effects.Fire.FireballWhite';
		gen.LifeSpan = 1.8;
	}
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( ( Level.NetMode != NM_Standalone ) )
	{
		speed = 2000.0000;
		SetTimer(5,false);
		Damage = mpExplodeDamage;
		blastRadius = mpBlastRadius;
		SoundRadius=76;
	}
}

defaultproperties
{
     mpExplodeDamage=75.000000
     mpBlastRadius=768.000000
     bBlood=True
     bDebris=True
     blastRadius=224.000000
     DamageType=Flamed
     ItemName="WP Rocket"
     HDTPMesh="HDTPItems.HDTPRocketHE"
     hdtpReference=Class'DeusEx.WeaponGEPGun'
     Damage=60.000000
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion2'
     Mesh=LodMesh'DeusExItems.RocketHE'
     AmbientSound=Sound'DeusExSounds.Weapons.WPApproach'
}
