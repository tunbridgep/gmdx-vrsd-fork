//=============================================================================
// WeaponNanoSword.
//=============================================================================
class WeaponNanoSword extends DeusExWeapon;

var bool bWasCrosshair;

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
//	if (!bLasing&&(Owner!=none)&&(Owner.IsA('DeusExPlayer')))
//	  DeusExPlayer.LaserToggle();
}


simulated function renderoverlays(Canvas canvas)
{
	if (iHDTPModelToggle == 1)                                                  //RSD: Need this off for vanilla model
	{
    multiskins[5] = Getweaponhandtex();
    if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
    {
       multiskins[4] = Texture'Effects.Electricity.WavyBlade';                  //RSD: Added so we get the right blade texture when switching from HDTP -> vanilla
       multiskins[3] = Texture'Effects.Electricity.WavyBlade';                  //RSD
       multiskins[2] = none;
       multiskins[1] = none;
       multiskins[0] = none;
    }
    }
    else if (!bIsCloaked && !bIsRadar)                                          //RSD: Overhauled cloak/radar routines
    {
    	multiskins[0] = Getweaponhandtex();
    	multiskins[1] = none;
    	multiskins[2] = none;
    	multiskins[3] = none;
    	multiskins[4] = none;
    	multiskins[5] = none;
    	multiskins[6] = none;
    	multiskins[7] = none;
    }
	super.renderoverlays(canvas);

    if (iHDTPModelToggle == 1)                                                  //RSD: Need this off for vanilla model
		multiskins[5] = none;
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPDragonTooth';
          PickupViewMesh=LodMesh'HDTPItems.HDTPDragonToothPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPDragonTooth3rd';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.NanoSword';
          PickupViewMesh=LodMesh'DeusExItems.NanoSwordPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.NanoSword3rd';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

/*Function CheckWeaponSkins()
{=
}*/

state DownWeapon
{
	function BeginState()
	{
//	   if (bLasing&&(Owner!=none)&&(Owner.IsA('DeusExPlayer')))
//         DeusExPlayer(Owner).ToggleLaser();
		Super.BeginState();
		LightType = LT_None;
	}
}

state Idle
{
	function BeginState()
	{
		Super.BeginState();
		LightType = LT_Steady;
       AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 416);  //CyberP: drawing the sword makes noise
//		if (!bLasing&&(Owner!=none)&&(Owner.IsA('DeusExPlayer')))
//         DeusExPlayer(Owner).ToggleLaser();
//      if (Owner.IsA('DeusExPlayer')) LaserOn();
	}
}

auto state Pickup
{
	function EndState()
	{
		Super.EndState();
		LightType = LT_None;
	}
}
/*
state Active
{
   function BeginState()
   {
      if (!bLasing&&(Owner!=none)&&(Owner.IsA('DeusExPlayer')))
         DeusExPlayer(Owner).ToggleLaser();
      super.BeginState();
   }
   function EndState()
   {
      if (bLasing&&(Owner!=none)&&(Owner.IsA('DeusExPlayer')))
         DeusExPlayer(Owner).ToggleLaser();
      super.EndState();
   }
}

*/

defaultproperties
{
     bIsMeleeWeapon=True
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     reloadTime=0.000000
     HitDamage=20
     maxRange=100
     AccurateRange=100
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     SwingOffset=(X=24.000000,Z=2.000000)
     mpHitDamage=10
     mpBaseAccuracy=1.000000
     mpAccurateRange=150
     mpMaxRange=150
     RecoilShaker=(X=4.000000,Y=0.000000,Z=4.000000)
     bCanHaveModDamage=True
     msgSpec="Emits Light"
     meleeStaminaDrain=1.750000
     NPCMaxRange=100
     NPCAccurateRange=100
     iHDTPModelToggle=1
     largeIconRot=Texture'GMDXSFX.Icons.LargeIconRotDragonTooth'
     invSlotsXtravel=4
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-21.000000,Y=16.000000,Z=27.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.NanoSwordFire'
     SelectSound=Sound'DeusExSounds.Weapons.NanoSwordSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.NanoSwordHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.NanoSwordHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.NanoSwordHitSoft'
     InventoryGroup=14
     ItemName="Dragon's Tooth Sword"
     ItemArticle="the"
     PlayerViewOffset=(X=21.000000,Y=-16.000000,Z=-27.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPDragonTooth'
     PickupViewMesh=LodMesh'HDTPItems.HDTPDragonToothPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPDragonTooth3rd'
     LandSound=Sound'DeusExSounds.Weapons.NanoSwordHitHard'
     Icon=Texture'DeusExUI.Icons.BeltIconDragonTooth'
     largeIcon=Texture'DeusExUI.Icons.LargeIconDragonTooth'
     largeIconWidth=205
     largeIconHeight=46
     invSlotsX=4
     Description="The true weapon of a modern warrior, the Dragon's Tooth is not a sword in the traditional sense, but a nanotechnologically constructed blade that is dynamically 'forged' on command into a non-eutactic solid. Nanoscale whetting devices insure that the blade is both unbreakable and lethally sharp."
     beltDescription="DRAGON"
     Mesh=LodMesh'HDTPItems.HDTPDragonToothPickup'
     MultiSkins(2)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(3)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(4)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(5)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(6)=WetTexture'Effects.Electricity.WavyBlade'
     MultiSkins(7)=WetTexture'Effects.Electricity.WavyBlade'
     CollisionRadius=32.000000
     CollisionHeight=2.400000
     LightType=LT_Steady
     LightEffect=LE_WateryShimmer
     LightBrightness=192
     LightHue=160
     LightSaturation=64
     LightRadius=4
     Mass=20.000000
}
