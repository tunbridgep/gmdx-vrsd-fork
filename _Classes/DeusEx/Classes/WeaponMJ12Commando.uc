//=============================================================================
// WeaponMJ12Commando.
//=============================================================================
class WeaponMJ12Commando extends WeaponNPCRanged;

function DrawMuzzleFlash()
{
	local Vector offset, X, Y, Z;

	if(Pawn(Owner) == None)
		return;

	if ((flash != None) && !flash.bDeleteMe)
		flash.LifeSpan = flash.default.LifeSpan;
	else
	{
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		offset = Owner.Location;
		offset += X * Owner.CollisionRadius;
		flash = Spawn(class'MuzzleFlash',,, offset);
		if (flash != None)
		{
			flash.SetBase(Owner);
			flash.LightRadius = 3;
		}

		offset = Owner.Location + CalcDrawOffset();
		// randomly draw an effect
		if (FRand() < 0.5)
			Spawn(class'Tracer',,, offset, Pawn(Owner).ViewRotation);
	}
}

// fire weapons out of alternating sides
function Fire(float Value)
{
	PlayerViewOffset.Y = -PlayerViewOffset.Y;
	DrawMuzzleFlash();
	Super.Fire(Value);
}

defaultproperties
{
     ShotTime=0.200000
     reloadTime=1.000000
     HitDamage=4
     BaseAccuracy=0.400000
     bHasMuzzleFlash=True
     AmmoName=Class'DeusEx.Ammo762mm'
     PickupAmmoCount=50
     bInstantHit=True
     FireSound=Sound'DeusExSounds.Robot.RobotFireGun'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultGunSelect'
     PlayerViewOffset=(Y=-24.000000,Z=-12.000000)
}
