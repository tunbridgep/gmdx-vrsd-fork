//=============================================================================
// EMPGrenade.
//=============================================================================
class EMPGrenade extends ThrownProjectile;

var float	mpBlastRadius;
var float	mpProxRadius;
var float	mpEMPDamage;
var float	mpFuselength;

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ExplosionLight light;
	local int i;
	local Rotator rot;
	local SphereEffect sphere;
	local ExplosionSmall expeffect;
    local SphereEffectPlasma sphere2;

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

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		blastRadius=mpBlastRadius;
		proxRadius=mpProxRadius;
		Damage=mpEMPDamage;
		fuseLength=mpFuselength;
		bIgnoresNanoDefense=True;
	}
}

defaultproperties
{
     mpBlastRadius=768.000000
     mpProxRadius=128.000000
     mpEMPDamage=200.000000
     mpFuselength=1.500000
     fuseLength=3.000000
     proxRadius=176.000000
     AISoundLevel=0.200000
     bBlood=False
     bDebris=False
     DamageType=EMP
     spawnWeaponClass=Class'DeusEx.WeaponEMPGrenade'
     ItemName="Electromagnetic Pulse (EMP) Grenade"
     speed=1200.000000
     MaxSpeed=1200.000000
     Damage=100.000000
     MomentumTransfer=50000
     ImpactSound=Sound'DeusExSounds.Weapons.EMPGrenadeExplode'
     LifeSpan=0.000000
     HDTPMesh="HDTPItems.HDTPEMPGrenadePickup"
     Mesh=LodMesh'DeusExItems.EMPGrenadePickup'
     CollisionRadius=3.000000
     CollisionHeight=1.900000
     Mass=5.000000
     Buoyancy=2.000000
     rearmSkillRequired=2
}
