//=============================================================================
// WeaponPlasmaRifle.
//=============================================================================
class WeaponPlasmaRifle extends DeusExWeapon;

var int lerpClamp;

/*
//SARGE: Resize if we have the Mobile Ordnance perk
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    ResizeHeavyWeapon(frobber);
    return super.DoRightFrob(Frobber,objectInHand);
}
*/

function DisplayWeapon(bool overlay)
{
    super.DisplayWeapon(overlay);

    if (IsHDTP())
    {
        //Show weapon addons
        if (overlay)
        {
            ShowWeaponAddon(6,bHasScope);
            ShowWeaponAddon(4,bHasLaser);
            ShowWeaponAddon(5,bLasing);
        }
        else
        {
            ShowWeaponAddon(5,bHasScope);
            ShowWeaponAddon(3,bHasLaser);
            ShowWeaponAddon(4,bLasing);
        }

    }
    else if (bVanillaModelAttachments)
    {
        if (overlay)
        {
            ShowWeaponAddon(3,bHasLaser);
            ShowWeaponAddon(4,bHasLaser && bLasing);
            ShowWeaponAddon(5,bHasScope);
        }
        else
        {
            ShowWeaponAddon(2,bHasLaser);
            ShowWeaponAddon(3,bHasLaser && bLasing);
            ShowWeaponAddon(4,bHasScope);
        }
    }
}

state Reload
{
   function BeginState()
   {
    Super.BeginState();

    lerpClamp = 0;
   }

   function Tick(float deltaTime)
   {
        Super.Tick(deltaTime);

    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
    {
     if (AnimSequence == 'Reload')
		{
			ShakeYaw = 0.06 * (Rand(4096) - 2048);
			ShakePitch = 0.06 * (Rand(4096) - 2048);

        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime * ShakeYaw;
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime * ShakePitch;
        }
     if (AnimSequence == 'ReloadBegin')
     {
        DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*100;
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*80;
        lerpClamp += 1;
        if (lerpClamp >= 5)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*230;
        }
     }
     else if (AnimSequence == 'ReloadEnd')
     {
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*300;
        DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*80;
     }
     if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
				DeusExPlayer(Owner).ViewRotation.Pitch = 16384;
     //}
    }
    }
}

defaultproperties
{
     weaponOffsets=(X=10.000000,Z=-7.000000)
     LowAmmoWaterMark=12
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     NoiseLevel=5.000000
     EnviroEffective=ENVEFF_AirVacuum
     reloadTime=3.000000
     HitDamage=20
     maxRange=12000
     AccurateRange=7200
     BaseAccuracy=0.700000
     bCanHaveScope=True
     ScopeFOV=30
     bCanHaveLaser=True
     AmmoNames(0)=Class'DeusEx.AmmoPlasma'
     ProjectileNames(0)=Class'DeusEx.PlasmaBolt'
     AreaOfEffect=AOE_Cone
     bHasMuzzleFlash=False
     recoilStrength=0.800000
     mpReloadTime=0.500000
     mpHitDamage=20
     mpBaseAccuracy=0.500000
     mpAccurateRange=8000
     mpMaxRange=8000
     mpReloadCount=12
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     RecoilShaker=(X=1.500000,Y=0.000000,Z=1.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bCanHaveModFullAuto=True
     bExtraShaker=True
     ReloadMidSound=Sound'GMDXSFX.Weapons.Optiwand_ScreenExtended1'
     negTime=0.465000
     AmmoTag="Plasma Clip"
     ClipModAdd=1
     slugSpreadAcc=0.500000
     NPCMaxRange=24000
     NPCAccurateRange=14400
     iHDTPModelToggle=1
     largeIconRot=Texture'GMDXSFX.Icons.LargeIconRotPlasma'
     invSlotsXtravel=3
     invSlotsYtravel=2
     AmmoName=Class'DeusEx.AmmoPlasma'
     ReloadCount=12
     PickupAmmoCount=12
     FireOffset=(Z=5.000000)
     ProjectileClass=Class'DeusEx.PlasmaBolt'
     shakemag=800.000000
     AltFireSound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.PlasmaRifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.PlasmaRifleSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd'
     InventoryGroup=8
     ItemName="Plasma Rifle"
     PlayerViewOffset=(X=18.000000,Z=-7.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPPlasmaRifle"
     HDTPPickupViewMesh="HDTPItems.HDTPplasmariflePickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPplasmarifle3rd"
     PlayerViewMesh=LodMesh'DeusExItems.PlasmaRifle';
     PickupViewMesh=LodMesh'DeusExItems.PlasmaRiflePickup';
     ThirdPersonMesh=LodMesh'DeusExItems.PlasmaRifle3rd';
     VanillaAddonPlayerViewMesh="VisibleAttachments.PlasmaRifle_Mod"
     VanillaAddonPickupViewMesh="VisibleAttachments.PlasmaRiflePickup_Mod"
     VanillaAddonThirdPersonMesh="VisibleAttachments.PlasmaRifle3rd_Mod"
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconPlasmaRifle'
     largeIcon=Texture'GMDXSFX.Icons.Plasma'
     largeIconWidth=161
     largeIconHeight=66
     invSlotsX=3
     invSlotsY=2
     Description="An experimental weapon that is currently being produced as a series of one-off prototypes, the plasma gun superheats slugs of magnetically-doped plastic and accelerates the resulting gas-liquid mix using an array of linear magnets. The resulting plasma stream is deadly when used against slow-moving targets."
     beltDescription="PLASMA"
     CollisionRadius=15.600000
     CollisionHeight=5.200000
     Mass=40.000000
     minSkillRequirement=1;
}
