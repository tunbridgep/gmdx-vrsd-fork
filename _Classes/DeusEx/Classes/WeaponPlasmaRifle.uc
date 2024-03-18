//=============================================================================
// WeaponPlasmaRifle.
//=============================================================================
class WeaponPlasmaRifle extends DeusExWeapon;

var int lerpClamp;

/*simulated function Tick(float deltaTime)
{
super.Tick(deltaTime);

    if (Owner == None || !Owner.IsA('DeusExPlayer'))
    return;
    else if (Owner.IsA('DeusExPlayer'))
	{
	  if (largeIconHeight!=34 && DeusExPlayer(Owner).PerkNamesArray[24]==1)
	    {
        invSlotsX=3;
        invSlotsY=2;
        largeIconWidth=161;
        largeIconHeight=66;
        largeIcon=Texture'GMDXSFX.Icons.Plasma';
        }
	}
} */

simulated function renderoverlays(Canvas canvas)
{
	if (iHDTPModelToggle == 1)
	{
    if(bHasScope)
	{
		if (!bIsCloaked && !bIsRadar)                                           //RSD: Overhauled cloak/radar routines
		    multiskins[6] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[6] = Texture'Effects.Electricity.Xplsn_EMPG';
	     else
             Multiskins[6] = FireTexture'GameEffects.InvisibleTex';
        }
	}
	else
		multiskins[6] = texture'pinkmasktex';
	if(bHasLaser)
	{
		if (!bIsCloaked && !bIsRadar)                                           //RSD: Overhauled cloak/radar routines
		    multiskins[4] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[4] = Texture'Effects.Electricity.Xplsn_EMPG';
	     else
             Multiskins[4] = FireTexture'GameEffects.InvisibleTex';
        }
	}
	else
		multiskins[4] = texture'pinkmasktex';
	if(bLasing)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';

	//hah! Multiskins 3 wasn't autoresetting, of course, so you only got green when a laser was installed -_-
	//multiskins[3]=none;                                                       //RSD: I don't know what you're talking about dude

	if (bIsCloaked)
	{
		multiskins[0] = texture'pinkmasktex';
        multiskins[3] = texture'pinkmasktex';
	}
	else if (bIsRadar)
	{
	    multiskins[0] = none;
	    multiskins[3] = none;
    }

	super.renderoverlays(canvas);

	if(bHasScope)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bLasing)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';

	}
	else
	{
	if (bIsCloaked || bIsRadar)
		multiskins[1] = texture'pinkmasktex';

	super.renderoverlays(canvas);

	}

}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPPlasmaRifle';
          PickupViewMesh=LodMesh'HDTPItems.HDTPplasmariflePickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPplasmarifle3rd';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.PlasmaRifle';
          PickupViewMesh=LodMesh'DeusExItems.PlasmaRiflePickup';
          ThirdPersonMesh=LodMesh'DeusExItems.PlasmaRifle3rd';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

function CheckWeaponSkins()
{
    if(bHasScope)
		multiskins[5] = none;
	else
		multiskins[5] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bLasing)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
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
     PlayerViewMesh=LodMesh'HDTPItems.HDTPPlasmaRifle'
     PickupViewMesh=LodMesh'HDTPItems.HDTPplasmariflePickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPplasmarifle3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconPlasmaRifle'
     largeIcon=Texture'GMDXSFX.Icons.Plasma'
     largeIconWidth=161
     largeIconHeight=66
     invSlotsX=3
     invSlotsY=2
     Description="An experimental weapon that is currently being produced as a series of one-off prototypes, the plasma gun superheats slugs of magnetically-doped plastic and accelerates the resulting gas-liquid mix using an array of linear magnets. The resulting plasma stream is deadly when used against slow-moving targets."
     beltDescription="PLASMA"
     Mesh=LodMesh'HDTPItems.HDTPplasmariflePickup'
     CollisionRadius=15.600000
     CollisionHeight=5.200000
     Mass=40.000000
}
