//=============================================================================
// WeaponNPCRanged.
//=============================================================================
class WeaponNPCRanged extends DeusExWeapon
	abstract;

//SARGE: Add Ygll's Muzzle Flash fix.
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

defaultproperties
{
     LowAmmoWaterMark=0
     EnemyEffective=ENMEFF_Organic
     ShotTime=0.300000
     reloadTime=0.000000
     BaseAccuracy=0.300000
     bHasMuzzleFlash=False
     bOwnerWillNotify=True
     bNativeAttack=True
     ReloadCount=159
     shakemag=0.000000
     Misc1Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitSoft'
     InventoryGroup=99
     ItemName=""
     PlayerViewOffset=(X=0.000000,Z=0.000000)
     PlayerViewMesh=LodMesh'DeusExItems.InvisibleWeapon'
     PickupViewMesh=LodMesh'DeusExItems.InvisibleWeapon'
     ThirdPersonMesh=LodMesh'DeusExItems.InvisibleWeapon'
     Icon=None
     largeIconWidth=1
     largeIconHeight=1
     Mesh=LodMesh'DeusExItems.InvisibleWeapon'
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     Mass=5.000000
}
