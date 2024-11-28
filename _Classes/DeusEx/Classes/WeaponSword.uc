//=============================================================================
// WeaponSword.
//=============================================================================
class WeaponSword extends DeusExWeapon;

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
	if (IsHDTP())
        multiskins[0] = Getweaponhandtex();
    else
    {
    	multiskins[0] = Getweaponhandtex();
    	multiskins[2] = Getweaponhandtex();
   	}
}

defaultproperties
{
     weaponOffsets=(X=20.000000,Y=-10.000000,Z=-32.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Sword'
     PickupViewMesh=LodMesh'DeusExItems.SwordPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Sword3rd'
     HDTPPlayerViewMesh="HDTPItems.HDTPSword"
     HDTPPickupViewMesh="HDTPItems.HDTPSwordPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPSword3rd"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     ShotTime=0.450000
     reloadTime=0.000000
     HitDamage=16
     maxRange=100
     AccurateRange=100
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     mpHitDamage=20
     mpBaseAccuracy=1.000000
     mpAccurateRange=100
     mpMaxRange=100
     RecoilShaker=(X=4.000000,Y=0.000000,Z=4.000000)
     msgSpec="3% chance to block bullets"
     meleeStaminaDrain=1.250000
     NPCMaxRange=100
     NPCAccurateRange=100
     iHDTPModelToggle=1
     largeIconRot=Texture'GMDXSFX.Icons.LargeIconRotSword'
     invSlotsXtravel=3
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-25.000000,Y=10.000000,Z=24.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.SwordFire'
     SelectSound=Sound'DeusExSounds.Weapons.SwordSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.SwordHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.SwordHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.SwordHitSoft'
     InventoryGroup=13
     ItemName="Sword"
     PlayerViewOffset=(X=25.000000,Y=-10.000000,Z=-24.000000)
     LandSound=Sound'DeusExSounds.Weapons.NanoSwordHitHard'
     Icon=Texture'DeusExUI.Icons.BeltIconSword'
     largeIcon=Texture'DeusExUI.Icons.LargeIconSword'
     largeIconWidth=130
     largeIconHeight=40
     invSlotsX=3
     Description="A rather nasty-looking sword."
     beltDescription="SWORD"
     Texture=Texture'DeusExItems.Skins.ReflectionMapTex1'
     Mesh=LodMesh'DeusExItems.SwordPickup'
     CollisionRadius=26.000000
     CollisionHeight=0.500000
     Mass=22.000000
}
