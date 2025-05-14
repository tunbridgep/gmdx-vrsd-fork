//=============================================================================
// WeaponRobotPlasmaGun.
//=============================================================================
class WeaponRobotPlasmaGun extends WeaponNPCRanged;

 //fire weapons out of alternating sides
function Fire(float Value)
{
	PlayerViewOffset.Y = -PlayerViewOffset.Y;
	Super.Fire(Value);
}

defaultproperties
{
     ShotTime=0.150000
     HitDamage=15
     BaseAccuracy=0.000000
     AIMinRange=1000.000000
     AIMaxRange=4000.000000
     AmmoName=Class'DeusEx.AmmoPlasma'
     PickupAmmoCount=20
     ProjectileClass=Class'DeusEx.PlasmaRobot'
     FireSound=Sound'DeusExSounds.Weapons.HideAGunFire'
     SelectSound=Sound'MoverSFX.door.MachineDoor6'
     PlayerViewOffset=(Y=-22.000000,Z=-12.000000)
}
