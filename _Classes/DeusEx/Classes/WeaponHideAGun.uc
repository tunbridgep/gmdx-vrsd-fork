//=============================================================================
// WeaponHideAGun.
//=============================================================================
class WeaponHideAGun extends DeusExWeapon;

function DisplayWeapon(bool overlay)
{
	super.DisplayWeapon(overlay);
	if (overlay)
	{
		multiskins[0] = handsTex;
		multiskins[3] = handsTex;
	}
}

defaultproperties
{
     weaponOffsets=(X=12.000000,Y=-10.000000,Z=-16.000000)
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=3.000000
     Concealability=CONC_All
     ShotTime=0.300000
     reloadTime=0.000000
     HitDamage=20
     maxRange=24000
     AccurateRange=14400
     BaseAccuracy=0.000000
     AreaOfEffect=AOE_Cone
     bHasMuzzleFlash=False
     bHandToHand=True
     recoilStrength=0.200000
     bEmitWeaponDrawn=False
     bUseAsDrawnWeapon=False
     RecoilShaker=(Y=2.000000,Z=1.000000)
     NPCMaxRange=24000
     NPCAccurateRange=14400
     AmmoName=Class'DeusEx.AmmoHideAGun'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(X=-20.000000,Y=10.000000,Z=16.000000)
     ProjectileClass=Class'DeusEx.PlasmaBolt'
     shakemag=280.000000
     FireSound=Sound'DeusExSounds.Generic.MediumExplosion1'
     SelectSound=Sound'DeusExSounds.Weapons.HideAGunSelect'
     InventoryGroup=205
     ItemName="PS20"
     PlayerViewOffset=(X=20.000000,Y=-10.000000,Z=-16.000000)
     PlayerViewMesh=LodMesh'DeusExItems.HideAGun'
     PickupViewMesh=LodMesh'DeusExItems.HideAGunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.HideAGun3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconHideAGun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconHideAGun'
     largeIconWidth=29
     largeIconHeight=47
     Description="The PS20 is a disposable, plasma-based weapon developed by an unknown security organization as a next generation stealth pistol.  Unfortunately, the necessity of maintaining a small physical profile restricts the weapon to a single shot.  Despite its limited functionality, the PS20 can be lethal at close range."
     beltDescription="PS20"
     Mesh=LodMesh'DeusExItems.HideAGunPickup'
     CollisionRadius=3.300000
     CollisionHeight=0.600000
     Mass=5.000000
     Buoyancy=2.000000
}
