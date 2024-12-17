//=============================================================================
// WeaponBaton.
//=============================================================================
class WeaponBaton extends DeusExWeapon;

function DisplayWeapon(bool overlay)
{
    super.DisplayWeapon(overlay);
	if (overlay)
	{
		if (IsHDTP())
		{
			multiskins[2] = handsTex;
		}
		else
		{
		   multiskins[1]=handsTex;                                        //RSD: Fix vanilla hand tex
		   multiskins[2]=handsTex;
		}
	}
}

function name WeaponDamageType()
{
	return 'KnockedOut';
}

defaultproperties
{
     weaponOffsets=(X=18.000000,Y=-14.000000,Z=-22.000000)
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     reloadTime=0.000000
     HitDamage=7
     maxRange=90
     AccurateRange=90
     BaseAccuracy=1.000000
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     bEmitWeaponDrawn=False
     RecoilShaker=(X=4.000000,Y=0.000000,Z=4.000000)
     msgSpec="Silent Attack"
     meleeStaminaDrain=1.000000
     NPCMaxRange=90
     NPCAccurateRange=90
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-24.000000,Y=14.000000,Z=17.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.BatonFire'
     SelectSound=Sound'DeusExSounds.Weapons.BatonSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.BatonHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.BatonHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.BatonHitSoft'
     InventoryGroup=24
     ItemName="Baton"
     HDTPPlayerViewMesh="HDTPItems.HDTPWeaponBaton"
     PlayerViewOffset=(X=24.000000,Y=-14.000000,Z=-17.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Baton'
     PickupViewMesh=LodMesh'DeusExItems.BatonPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Baton3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconBaton'
     largeIcon=Texture'DeusExUI.Icons.LargeIconBaton'
     largeIconWidth=46
     largeIconHeight=47
     Description="A hefty looking baton, typically used by riot police and national security forces to discourage civilian resistance."
     beltDescription="BATON"
     Mesh=LodMesh'DeusExItems.BatonPickup'
     CollisionRadius=14.000000
     CollisionHeight=1.000000
}
