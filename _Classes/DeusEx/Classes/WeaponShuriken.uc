//=============================================================================
// WeaponShuriken.
//=============================================================================
class WeaponShuriken extends DeusExWeapon;

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
      PickupAmmoCount = 7;
	}
}

simulated function renderoverlays(Canvas canvas)
{
	multiskins[0] = Getweaponhandtex();

	super.renderoverlays(canvas);

	multiskins[0] = none;
}

defaultproperties
{
     weaponOffsets=(X=16.000000,Y=-14.000000,Z=-22.000000)
     LowAmmoWaterMark=5
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.010000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_AirVacuum
     Concealability=CONC_Visual
     reloadTime=0.200000
     HitDamage=16
     maxRange=2048
     AccurateRange=840
     BaseAccuracy=0.600000
     bHasMuzzleFlash=False
     bHandToHand=True
     mpReloadTime=0.200000
     mpHitDamage=35
     mpBaseAccuracy=0.100000
     mpAccurateRange=640
     mpMaxRange=640
     mpPickupAmmoCount=7
     RecoilShaker=(X=-4.000000,Y=0.000000,Z=1.000000)
     meleeStaminaDrain=0.750000
     NPCMaxRange=2048
     NPCAccurateRange=840
     AmmoName=Class'DeusEx.AmmoShuriken'
     ReloadCount=1
     PickupAmmoCount=5
     FireOffset=(X=-10.000000,Y=14.000000,Z=22.000000)
     ProjectileClass=Class'DeusEx.Shuriken'
     shakemag=5.000000
     InventoryGroup=12
     ItemName="Throwing Knives"
     ItemArticle="some"
     PlayerViewOffset=(X=24.000000,Y=-12.000000,Z=-21.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPShuriken'
     PickupViewMesh=LodMesh'HDTPItems.HDTPShurikenPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPShuriken3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconShuriken'
     largeIcon=Texture'DeusExUI.Icons.LargeIconShuriken'
     largeIconWidth=36
     largeIconHeight=45
     Description="A favorite weapon of assassins in the Far East for centuries, throwing knives can be deadly when wielded by a master but are more generally used when it becomes desirable to send a message. The message is usually 'Your death is coming on swift feet.'"
     beltDescription="THW KNIFE"
     Mesh=LodMesh'HDTPItems.HDTPShurikenPickup'
     CollisionRadius=7.500000
     CollisionHeight=0.300000
     bDisposableWeapon=true
}
