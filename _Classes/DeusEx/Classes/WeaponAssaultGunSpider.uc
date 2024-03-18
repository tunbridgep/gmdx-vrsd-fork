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


simulated function renderoverlays(Canvas canvas)
{
	if(bHasScope)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bHasSilencer)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[1] = none;
	else
		multiskins[1] = texture'pinkmasktex';
	if(bLasing)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	//assault gun uses so many differently assigned multiskins we need to keep flicking back between em or we get invisible gunz
	multiskins[0]=none;
	if(muztex != none && multiskins[2] != muztex) //don't overwrite the muzzleflash..this is fucking ugly, but I think we can spare some comp cycles for shit like this
		multiskins[2]=muztex;
	else
		multiskins[2]=none;

	multiskins[6]=none;
	multiskins[7]=Getweaponhandtex();

	super.renderoverlays(canvas); //(weapon)

	if(bHasScope)
		multiskins[6] = none;
	else
		multiskins[6] = texture'pinkmasktex';
	if(bHasSilencer)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	if(bLasing)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';

	multiskins[0]=none;
	multiskins[1]=none;
	if(muztex != none && multiskins[4] != muztex) //and here too! Ghaaa
		multiskins[4]=muztex;
	else
		multiskins[4]=none;
	multiskins[7]=none;
}

function CheckWeaponSkins()
{
	if(bHasScope)
		multiskins[6] = none;
	else
		multiskins[6] = texture'pinkmasktex';
	if(bHasSilencer)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	if(bLasing)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	multiskins[0]=none;
	multiskins[1]=none;
	multiskins[4]=none;
	multiskins[7]=none;
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

simulated function texture GetMuzzleTex()
{
	local int i;
	local texture tex;

	//i = muznum;
	muznum++;
	if(muznum > 7)
		muznum = 0;
	switch(muznum)
	{
		case 0: tex = texture'HDTPMuzzleflashlarge1'; break;
		case 1: tex = texture'HDTPMuzzleflashlarge2'; break;
		case 2: tex = texture'HDTPMuzzleflashlarge3'; break;
		case 3: tex = texture'HDTPMuzzleflashlarge4'; break;
		case 4: tex = texture'HDTPMuzzleflashlarge5'; break;
		case 5: tex = texture'HDTPMuzzleflashlarge6'; break;
		case 6: tex = texture'HDTPMuzzleflashlarge7'; break;
		case 7: tex = texture'HDTPMuzzleflashlarge8'; break;
	}
	return tex;
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
/*
//uses actual 5-shot silencer sound now, so as to be less stupid
simulated function PlayFiringSound()
{
	if (bHasSilencer)
		PlaySimSound( Sound'HDTPItems.weapons.AssaultSilenced', SLOT_None, TransientSoundVolume, 2048 );
	else
	{
		// The sniper rifle sound is heard to it's range in multiplayer
		if ( ( Level.NetMode != NM_Standalone ) &&  Self.IsA('WeaponRifle') )
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, class'WeaponRifle'.Default.mpMaxRange );
		else
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, 2048 );
	}
	UpdateRecoilShaker();
}
*/

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
     PlayerViewMesh=LodMesh'HDTPItems.HDTPAssaultGun'
     PickupViewMesh=LodMesh'HDTPItems.HDTPassaultGunPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPassaultGun3rd'
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
