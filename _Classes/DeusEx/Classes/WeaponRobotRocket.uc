//=============================================================================
// WeaponRobotRocket.
//=============================================================================
class WeaponRobotRocket extends WeaponNPCRanged;

// fire weapons out of alternating sides
function Fire(float Value)
{
	PlayerViewOffset.Y = -PlayerViewOffset.Y;
	Super.Fire(Value);
}

defaultproperties
{
     ShotTime=0.600000
     HitDamage=200
     AIMinRange=500.000000
     AIMaxRange=4000.000000
     AmmoName=Class'DeusEx.AmmoRocketRobot'
     PickupAmmoCount=20
     ProjectileClass=Class'DeusEx.RocketRobot'
     PlayerViewOffset=(Y=-44.000000,Z=36.000000)
}
