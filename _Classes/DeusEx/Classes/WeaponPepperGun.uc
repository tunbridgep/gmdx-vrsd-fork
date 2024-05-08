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

simulated function renderoverlays(Canvas canvas)
{
	multiskins[0] = Getweaponhandtex();

	super.renderoverlays(canvas);

	multiskins[0] = none;
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPPepperGun';
          PickupViewMesh=LodMesh'HDTPItems.HDTPpeppergunpickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPpeppergun3rd';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.PepperGun';
          PickupViewMesh=LodMesh'DeusExItems.PepperGunPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.PepperGun3rd';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

/*Function CheckWeaponSkins()
{
}*/

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
     PlayerViewMesh=LodMesh'HDTPItems.HDTPPepperGun'
     PickupViewMesh=LodMesh'HDTPItems.HDTPpeppergunpickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPpeppergun3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconPepperSpray'
     largeIcon=Texture'DeusExUI.Icons.LargeIconPepperSpray'
     largeIconWidth=46
     largeIconHeight=40
     Description="The pepper gun will accept a number of commercially available riot control agents in cartridge form and disperse them as a fine aerosol mist that can cause blindness or blistering at short-range."
     beltDescription="PEPPER"
     Mesh=LodMesh'HDTPItems.HDTPpeppergunpickup'
     CollisionRadius=7.000000
     CollisionHeight=1.500000
     Mass=7.000000
     Buoyancy=2.000000
}
