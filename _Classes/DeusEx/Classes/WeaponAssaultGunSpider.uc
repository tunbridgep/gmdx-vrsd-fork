//=============================================================================
// WeaponAssaultGun.
//=============================================================================
class WeaponAssaultGunSpider extends DeusExWeapon;

var float	mpRecoilStrength;
var int muznum; //loop through muzzleflashes
var texture muztex; //sigh

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
		ReloadCount = mpReloadCount;

		// Tuned for advanced -> master skill system (Monte & Ricardo's number) client-side
		recoilStrength = 0.75;
	}
}


simulated function SwapMuzzleFlashTexture()
{
	local int i;

	if (!bHasMuzzleFlash || bHasSilencer)
		return;

	if(playerpawn(owner) != none)      //diff meshes, see
		i=2;
	else
		i=4;
	Muztex = GetMuzzleTex();
	Multiskins[i] = Muztex;
	MuzzleFlashLight();
	SetTimer(0.1, False);
}

simulated function EraseMuzzleFlashTexture()
{
	local int i;

	Muztex = none; //put this before the silencer check just in case we somehow add a silencer while mid shooting (it could happen!)
	if(!bHasMuzzleflash || bHasSilencer)
		return;

	if(playerpawn(owner) != none)      //diff meshes, see
		i=2;
	else
		i=4;

	MultiSkins[i] = None;
}

defaultproperties
{
     LowAmmoWaterMark=1
     FireAnim(1)=None
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=8.000000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=0.100000
     reloadTime=3.500000
     HitDamage=20
     BaseAccuracy=0.800000
     bCanHaveScope=True
     ScopeFOV=44
     bCanHaveLaser=True
     bCanHaveSilencer=True
     bPenetrating=False
     bHasMuzzleFlash=False
     recoilStrength=0.100000
     MinWeaponAcc=0.200000
     mpReloadTime=0.500000
     mpHitDamage=9
     mpBaseAccuracy=1.000000
     mpAccurateRange=2400
     mpMaxRange=2400
     mpReloadCount=30
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'GMDXSFX.Weapons.MP5FireSil'
     RecoilShaker=(X=4.000000,Y=2.000000)
     bCanHaveModShotTime=True
     invSlotsXtravel=2
     invSlotsYtravel=2
     AmmoName=Class'DeusEx.AmmoLAM'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(X=-16.000000,Y=5.000000,Z=11.500000)
     ProjectileClass=Class'DeusEx.SpiderConstructorLaunched2'
     shakemag=240.000000
     FireSound=Sound'DeusExSounds.Weapons.HideAGunFire'
     AltFireSound=Sound'GMDXSFX.Weapons.M4ClipIn'
     CockingSound=Sound'GMDXSFX.Weapons.M4ClipOut'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultGunSelect'
     InventoryGroup=149
     ItemName=""
     ItemArticle="an"
     PlayerViewOffset=(X=16.000000,Y=-5.000000,Z=-11.500000)
     HDTPPlayerViewMesh="HDTPeditsRSD.HDTPAssaultGunRSD"
     HDTPPickupViewMesh="HDTPItems.HDTPassaultGunPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPassaultGun3rd"
     PlayerViewMesh=LodMesh'DeusExItems.AssaultGun'
     PickupViewMesh=LodMesh'DeusExItems.AssaultGunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.AssaultGun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconAssaultGun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAssaultGun'
     largeIconWidth=94
     largeIconHeight=65
     invSlotsX=2
     invSlotsY=2
     Description="The 7.62x51mm assault rifle is designed for close-quarters combat, utilizing a shortened barrel and 'bullpup' design for increased maneuverability. An additional underhand 20mm HE launcher increases the rifle's effectiveness against a variety of targets."
     beltDescription="ASSAULT"
     Mesh=LodMesh'HDTPItems.HDTPassaultGunPickup'
     CollisionRadius=15.000000
     CollisionHeight=1.100000
     Mass=30.000000
}
