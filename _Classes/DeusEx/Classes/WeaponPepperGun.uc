//=============================================================================
// WeaponPepperGun.
//=============================================================================
class WeaponPepperGun extends DeusExWeapon;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		HitDamage = mpHitDamage;
		BaseAccuracy = mpBaseAccuracy;
		ReloadTime = mpReloadTime;
		AccurateRange = mpAccurateRange;
		MaxRange = mpMaxRange;
	}
}

function DisplayWeapon(bool overlay)
{
    super.DisplayWeapon(overlay);
	if (overlay)
		multiskins[0] = handstex;
}

defaultproperties
{
     weaponOffsets=(X=8.000000,Y=-10.000000,Z=-16.000000)
     LowAmmoWaterMark=25
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.200000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_AirVacuum
     Concealability=CONC_Visual
     bAutomatic=True
     ShotTime=0.150000
     reloadTime=4.000000
     HitDamage=0
     maxRange=130
     AccurateRange=130
     bPenetrating=False
     StunDuration=12.000000
     bHasMuzzleFlash=False
     mpReloadTime=4.000000
     mpBaseAccuracy=0.700000
     mpAccurateRange=100
     mpMaxRange=100
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     RecoilShaker=(X=0.000000,Z=0.000000)
     AmmoTag="Pepper Cartridge"
     ClipModAdd=5
     NPCMaxRange=130
     NPCAccurateRange=130
     iHDTPModelToggle=1
     AmmoName=Class'DeusEx.AmmoPepper'
     ReloadCount=50
     PickupAmmoCount=50
     FireOffset=(X=8.000000,Y=4.000000,Z=14.000000)
     ProjectileClass=Class'DeusEx.TearGas'
     shakemag=10.000000
     AltFireSound=Sound'DeusExSounds.Weapons.PepperGunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.PepperGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.PepperGunSelect'
     InventoryGroup=18
     ItemName="Pepper Gun"
     PlayerViewOffset=(X=16.000000,Y=-10.000000,Z=-16.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPPepperGun"
     HDTPPickupViewMesh="HDTPItems.HDTPpeppergunpickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPpeppergun3rd"
     PlayerViewMesh=LodMesh'DeusExItems.PepperGun';
     PickupViewMesh=LodMesh'DeusExItems.PepperGunPickup';
     ThirdPersonMesh=LodMesh'DeusExItems.PepperGun3rd';
     Icon=Texture'DeusExUI.Icons.BeltIconPepperSpray'
     largeIcon=Texture'DeusExUI.Icons.LargeIconPepperSpray'
     largeIconWidth=46
     largeIconHeight=40
     Description="The pepper gun will accept a number of commercially available riot control agents in cartridge form and disperse them as a fine aerosol mist that can cause blindness or blistering at short-range."
     beltDescription="PEPPER"
     CollisionRadius=7.000000
     CollisionHeight=1.500000
     Mass=7.000000
     Buoyancy=2.000000
     minSkillRequirement=1
}
