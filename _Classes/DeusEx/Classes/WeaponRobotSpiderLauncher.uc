//=============================================================================
// WeaponRobotPlasmaGun.
//=============================================================================
class WeaponRobotSpiderLauncher extends WeaponNPCRanged;

defaultproperties
{
     ShotTime=0.500000
     HitDamage=20
     AIMinRange=200.000000
     AIMaxRange=4000.000000
     AmmoName=Class'DeusEx.AmmoSabot'
     PickupAmmoCount=6
     ProjectileClass=Class'DeusEx.SpiderConstructorLaunched'
     FireSound=Sound'DeusExSounds.Weapons.HideAGunFire'
     SelectSound=Sound'MoverSFX.door.MachineDoor4'
     PlayerViewOffset=(Y=-46.000000,Z=36.000000)
}
