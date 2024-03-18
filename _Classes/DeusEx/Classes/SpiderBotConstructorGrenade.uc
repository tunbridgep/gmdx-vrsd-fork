//=============================================================================
// NanoVirusGrenade.
//=============================================================================
class SpiderBotConstructorGrenade extends ThrownProjectile;

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ExplosionLight light;
	local int i;
	local Rotator rot;
	local SphereEffect sphere;
   local SpiderBot4 spiderbot;

   spiderbot = Spawn(class'SpiderBot4');
   if (spiderbot != None)
   {
   spiderbot.Health=30;
   }
	// draw a cool light sphere
	sphere = Spawn(class'SphereEffect',,, HitLocation);
	if (sphere != None)
   {
      if (!bDamaged)
         sphere.RemoteRole = ROLE_None;
		sphere.size = 5;
   }
}

defaultproperties
{
     fuseLength=0.700000
     proxRadius=128.000000
     AISoundLevel=0.100000
     bBlood=False
     bDebris=False
     blastRadius=96.000000
     DamageType=NanoVirus
     spawnWeaponClass=Class'DeusEx.WeaponSpiderBotConstructor'
     ItemName="Spiderbot Constructor Grenade"
     speed=1000.000000
     MaxSpeed=1000.000000
     MomentumTransfer=50000
     ImpactSound=Sound'DeusExSounds.Weapons.NanoVirusGrenadeExplode'
     LifeSpan=0.000000
     Skin=Texture'HDTPItems.Skins.HDTPAugUpCanTex0'
     Mesh=LodMesh'HDTPItems.HDTPnanovirusgrenadePickup'
     CollisionRadius=2.630000
     CollisionHeight=4.410000
     Mass=5.000000
     Buoyancy=2.000000
}
