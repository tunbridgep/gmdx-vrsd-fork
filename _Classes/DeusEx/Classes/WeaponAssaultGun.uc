//=============================================================================
// WeaponAssaultGun.
//=============================================================================
class WeaponAssaultGun extends DeusExWeapon;

#exec OBJ LOAD FILE=RSDCrap                                                //RSD: reimported vanilla/HDTP model

var float	mpRecoilStrength;
var int muznum; //loop through muzzleflashes

var vector axesX;//fucking weapon rotation fix
var vector axesY;
var vector axesZ;
var DeusExPlayer player;
var bool bFlipFlopCanvas;
var bool bGEPjit;
var float GEPinout;
var bool bGEPout;
var vector MountedViewOffset;
var float scopeTime;
var int lerpClamp;

simulated function DrawScopeAnimation()
{
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector unX,unY,unZ;

    if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=6912*Fmin(1.0,GEPinout);
	rfs.Pitch=2912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);
    
    player = DeusExPlayer(Owner);

	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);
	SetRotation(rfs);

	PlayerViewOffset=Default.PlayerViewOffset*100;//meh
	SetHand(player.Handedness); //meh meh

    if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkMarksman').bPerkObtained == true)                                          //RSD: Was PerkNamesArray[12], now PerkNamesArray[23] (merged Advanced with Master Rifles perk)
    {
        PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
        PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
        PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.2*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	}
	else
	{
        PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
        PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
        PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	}

	SetLocation(player.Location+ CalcDrawOffset());
	scopeTime+=1;


    if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkMarksman').bPerkObtained == true)                                          //RSD: Was PerkNamesArray[12], now PerkNamesArray[23] (merged Advanced with Master Rifles perk)
    {
        if (scopeTime>=17)
        {
            activateAn = False;
            scopeTime = 0;
            ScopeToggle();
            GEPinout = 0;
            axesX = vect(0,0,0);
            axesY = vect(0,0,0);
            axesZ = vect(0,0,0);
            PlayerViewOffset=Default.PlayerViewOffset*100;
            SetHand(player.Handedness);
        }
    }
    else if (scopeTime>=25)
    {
        activateAn = False;
        scopeTime = 0;
        ScopeToggle();
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        SetHand(player.Handedness);
    }
}

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
	if (Owner != None && Owner.IsA('AnnaNavarre'))
	    bHasSilencer = True;
}

function DisplayWeapon(bool overlay)
{
    super.DisplayWeapon(overlay);

    if (IsHDTP())                                                  //RSD: Need this off for vanilla model
    {
        if (overlay)
        {
            multiskins[7]=handsTex;
            ShowWeaponAddon(3,bHasScope);
            ShowWeaponAddon(4,bHasSilencer);
            ShowWeaponAddon(1,bHasLaser);
            ShowWeaponAddon(5,bLasing);
        }
        else
        {
            //These are completely different on the third person model.
            ShowWeaponAddon(6,bHasScope);
            ShowWeaponAddon(2,bHasSilencer);
            ShowWeaponAddon(3,bHasLaser);
        }
    }
    else if (overlay)
    {
        multiskins[0]=handsTex;
    }


}

//TODO: Use the base class version
simulated function SwapMuzzleFlashTexture()
{
    if (ClipCount == 0)
       PlaySound(Sound'GMDXSFX.Weapons.G36DryFire',SLOT_None);
	else
	   MuzzleFlashLight();

	if (!bHasMuzzleFlash || bHasSilencer)
		return;

	if(playerpawn(owner) != none)      //diff meshes, see
        //SARGE NOTE: HDTP Muzzle Flash was Broken by RSD HDTP 3-round-burst edit
		MuzzleSlot=2;
	else
		MuzzleSlot=4;
    
    if (GetMuzzleTex() != None && MuzzleSlot < 8 && MuzzleSlot > -1)
        MultiSkins[MuzzleSlot] = GetMuzzleTex();
	SetTimer(0.1, False);
}

/*
simulated function texture GetMuzzleTex()
{
	local int i;
	local texture tex;

	//i = muznum;
	if (ClipCount == 0)
	{
     return texture'pinkmasktex';
	}

	muznum++;
	if(muznum > 7)
		muznum = 0;
	switch(muznum)
	{
		case 0: tex = texture'ef_HitMuzzle001'; break;
		case 1: tex = texture'ef_HitMuzzle002'; break;
		case 2: tex = texture'ef_HitMuzzle003'; break;
		case 3: tex = texture'ef_HitMuzzle001'; break;
		case 4: tex = texture'ef_HitMuzzle002'; break;
		case 5: tex = texture'ef_HitMuzzle003'; break;
		case 6: tex = texture'ef_HitMuzzle001'; break;
		case 7: tex = texture'ef_HitMuzzle002'; break;
	}

	return tex;
}
*/

state Reload
{
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
        DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*400;
        DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*200;
        lerpClamp = 0;
     }
     else if (AnimSequence == 'Reload' && lerpClamp < 13)
     {
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*110;
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*160;
        if (lerpClamp == 12)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*1000;
           DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*300;
           DeusExPlayer(Owner).RecoilShaker(vect(0,1,1));
        }
        lerpClamp += 1;
     }
     else if (AnimSequence == 'ReloadEnd')
     {
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*250;
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*200;
     }
     if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
				DeusExPlayer(Owner).ViewRotation.Pitch = 16384;
     //}
    }
    }
}

defaultproperties
{
     weaponOffsets=(X=8.000000,Y=-5.000000,Z=-10.000000)
     MountedViewOffset=(X=2.000000,Y=-2.100000,Z=10.500000)
     LowAmmoWaterMark=16
     FireAnim(1)=None
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=7.000000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     bAutomatic=True
     ShotTime=0.100000
     reloadTime=3.500000
     HitDamage=3
     maxRange=4800
     AccurateRange=2400
     BaseAccuracy=0.650000
     bCanHaveScope=True
     ScopeFOV=40
     bCanHaveLaser=True
     bCanHaveSilencer=True
     AmmoNames(0)=Class'DeusEx.Ammo762mm'
     AmmoNames(1)=Class'DeusEx.Ammo20mm'
     ProjectileNames(1)=Class'DeusEx.HECannister20mm'
     recoilStrength=0.194000
     MinWeaponAcc=0.200000
     mpReloadTime=0.500000
     mpHitDamage=9
     mpBaseAccuracy=1.000000
     mpAccurateRange=2400
     mpMaxRange=2400
     mpReloadCount=30
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'GMDXSFX.Weapons.MP5_1p_Fired1'
     RecoilShaker=(X=0.000000,Y=0.000000,Z=0.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     ReloadMidSound=Sound'GMDXSFX.Weapons.MP5_MagIn1'
     negTime=0.000000
     ironSightLoc=(X=12.500000,Y=3.300000,Z=-10.900000)
     AmmoTag="7.62x51mm Ammo"
     addYaw=1200
     addPitch=-1100
     ClipModAdd=3
     NPCMaxRange=9600
     NPCAccurateRange=4800
     iHDTPModelToggle=1
     invSlotsXtravel=2
     invSlotsYtravel=2
     AmmoName=Class'DeusEx.Ammo762mm'
     ReloadCount=30
     PickupAmmoCount=30
     bInstantHit=True
     FireOffset=(X=-16.000000,Y=5.000000,Z=11.500000)
     shakemag=240.000000
     FireSound=Sound'GMDXSFX.Weapons.MP5Fire2'
     AltFireSound=Sound'GMDXSFX.Weapons.M4ClipIn'
     CockingSound=Sound'GMDXSFX.Weapons.M4ClipOut'
     SelectSound=Sound'GMDXSFX.Weapons.famasselect'
     Misc1Sound=Sound'GMDXSFX.Weapons.G36DryFire'
     InventoryGroup=4
     ItemName="Assault Rifle"
     ItemArticle="an"
     PlayerViewOffset=(X=12.500000,Y=-5.000000,Z=-12.000000)
     HDTPPlayerViewMesh="RSDCrap.HDTPAssaultGunRSD"
     //HDTPPlayerViewMesh="HDTPItems.HDTPAssaultGun"
     HDTPPickupViewMesh="HDTPItems.HDTPassaultGunPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPassaultGun3rd"
     //PlayerViewMesh=LodMesh'DeusExItems.AssaultGun'
     //PlayerViewMesh=LodMesh'HDTPEditsRSD.AssaultGunRSD' //Required for 3-shot burst
     PlayerViewMesh=LodMesh'RSDCrap.AssaultGunRSD'
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
     Mesh=LodMesh'DeusExItems.AssaultGunPickup'
     CollisionRadius=15.000000
     CollisionHeight=1.100000
     Mass=30.000000
     minSkillRequirement=3;
     bFancyScopeAnimation=true
     muzzleSlot=-1
}
