//=============================================================================
// WeaponRobotMachinegun.
//=============================================================================
class WeaponRobotMachinegun extends WeaponNPCRanged;

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
			flash.LightRadius = 5;
		}

		offset = Owner.Location + CalcDrawOffset();
		// randomly draw an effect
		if (FRand() < 0.6)
			Spawn(class'Tracer',,, offset, Pawn(Owner).ViewRotation);
	}
}

simulated function PlaySelectiveFiring()
{
	DrawMuzzleFlash();
    Super.PlaySelectiveFiring();
}

defaultproperties
{
     ShotTime=0.100000
     reloadTime=1.000000
     HitDamage=4
     BaseAccuracy=0.600000
     bHasMuzzleFlash=True
     AmmoName=Class'DeusEx.Ammo762mm'
     PickupAmmoCount=50
     bInstantHit=True
     FireSound=Sound'GMDXSFX.Weapons.botFire'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultGunReload'
     SelectSound=Sound'MoverSFX.door.MachineDoor6'
}
