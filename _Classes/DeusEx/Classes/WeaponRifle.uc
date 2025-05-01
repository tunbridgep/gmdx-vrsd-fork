//=============================================================================
// WeaponRifle.
//=============================================================================
class WeaponRifle extends DeusExWeapon;

var float	mpNoScopeMult;
var DeusExPlayer player;
var vector axesX;//fucking weapon rotation fix
var vector axesY;
var vector axesZ;
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
        PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
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

function DisplayWeapon(bool overlay)
{
    super.DisplayWeapon(overlay);
    if (IsHDTP() && iHDTPModelToggle == 2 && overlay) //Clyzm Model
    {
        multiskins[1] = handstex;
        ShowWeaponAddon(5,bHasSilencer);
        ShowWeaponAddon(6,!bHasSilencer);
        ShowWeaponAddon(4,bHasLaser);
        ShowWeaponAddon(2,bLasing);
    }
    else if (IsHDTP())
    {
        if (overlay)
        {
            //MuzzleSlot = 5;
            multiskins[6] = handsTex;
            ShowWeaponAddon(4,bHasSilencer);
            ShowWeaponAddon(3,bHasLaser);
        }
        else
        {
            ShowWeaponAddon(3,bHasSilencer);
            ShowWeaponAddon(4,bHasLaser);
        }
    }
    else if (overlay)
    {
        multiskins[0] = handsTex;
    }
}

simulated function PlayIdleAnim()                                               //RSD: Clyzm model
{
    local float rnd;

	if (!IsHDTP() || iHDTPModelToggle != 2)                                                  //RSD: Special routine only for Clyzm model
	{
		super.PlayIdleAnim();
		return;
	}

	if (bZoomed || bNearWall)
		return;

	rnd = FRand();
    if (rnd < 0.4)
        PlayAnim('Idle',,0.2);
}

simulated function SniperMagInsert()                                            //RSD: Clyzm Model
{
      Owner.PlaySound(Sound'GMDXSFX.Weapons.SniperMagInsert', SLOT_None,,, 1024);
}

simulated function SniperMagSlap()                                              //RSD: Clyzm model
{
      Owner.PlaySound(Sound'GMDXSFX.Weapons.SniperMagSlap', SLOT_None,,, 1024);
}

simulated function SniperCocking()                                              //RSD: Clyzm model
{
      Owner.PlaySound(Sound'DeusExSounds.Weapons.RifleReloadEnd', SLOT_None,,, 1024);
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
    local name animToSet;

    if (IsHDTP())
    {
        if (iHDTPModelToggle == 2)                                                 //RSD: Clyzm model
        {
            if (AnimSequence == 'Idle' || AnimSequence == 'Idle1' || AnimSequence == 'Idle2' || AnimSequence == 'Idle3')
            {
                animToSet = 'Idle';
                animSequence = '';
            }
            HDTPPlayerViewMesh="fomod.sniper1st";
        }
        else if (iHDTPModelToggle == 1)
        {
            if (AnimSequence == 'Idle')
            {
                animToSet = 'Idle1';
                animSequence = '';
            }
            else if (AnimSequence == 'ReloadBegin' || AnimSequence == 'ReloadEnd') //RSD: Don't have these
            {
                animSequence = 'Idle';
            }
            HDTPPlayerViewMesh="HDTPItems.HDTPWeaponRifle";
        }
    }
    else
    {
        if (AnimSequence == 'Idle')
        {
            animToSet = 'Idle1';
            animSequence = '';
        }
    }

    if (animToSet != '')
        animSequence = animToSet;

    Super.UpdateHDTPsettings();
}

function PostBeginPlay()   //CyberP: do I need to revise this shit?
{
	Super.PostBeginPlay();

	if (Owner != none && Owner.IsA('ScriptedPawn') && !Owner.IsA('PaulDenton'))
    {
    maxRange=48000;
    AccurateRange=24000;
    ShotTime=1.000000;
    BaseAccuracy=0.750000;
    }
}

state DownWeapon
{
	function EndState()
	{
	    Super.EndState();
	    activateAn = False;
        scopeTime = 0;
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;
        //RSD: Begin block from v9 beta
	    BobDamping=default.BobDamping;
        bAimingDown=False;
        //RSD: End block from v9 beta
        if (Owner != none && Owner.IsA('DeusExPlayer'))                         //RSD: accessed none?
            SetHand(DeusExPlayer(Owner).Handedness);
	}
}

state Reload
{
ignores Fire, AltFire;                                                          //RSD: Added from v9 beta (and also in base DeusExWeapon.uc?)

   function BeginState()
   {
    Super.BeginState();

    lerpClamp = 0;
    //RSD: Begin block from v9 beta
    bAimingDown=False;
    BobDamping=default.BobDamping;
    //RSD: End block from v9 beta
   }

   function Tick(float deltaTime)
   {
        Super.Tick(deltaTime);

    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
    {
     //if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
     //{
     if (AnimSequence == 'Reload')
     {
        lerpClamp += 1;
        if (lerpClamp < 8*ReloadTime)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*180;
           DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*260;
        }
        else if (lerpClamp >= 30*ReloadTime && lerpClamp < 38*ReloadTime)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*180;
           DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*260;
        }
        else
        {
          ShakeYaw = 0.06 * (Rand(4096) - 2048);
          ShakePitch = 0.06 * (Rand(4096) - 2048);

          DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime * ShakeYaw;
          DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime * ShakePitch;
        }
     }
     if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
				DeusExPlayer(Owner).ViewRotation.Pitch = 16384;
     //}
    }
    }
    //RSD: Begin block from v9 beta
Begin:
	FinishAnim();
	/*if (!bLasing && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bHardcoreMode) //RSD: Reset accuracy when starting a reloading cycle on Hardcore mode
	{
		StandingTimer = 0;
	}*/
	if (Emitter != none)                                                        //RSD: Puts laser down when reloading
		Emitter.TurnOff();
	LaserYaw = (currentAccuracy) * (Rand(4096) - 2048);                         //RSD: Reset laser position
    LaserPitch = (currentAccuracy) * (Rand(4096) - 2048);
	// only reload if we have ammo left
	if (AmmoType.AmmoAmount > 0)
	{
		if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		{
			ClientReload();
			Sleep(GetReloadTime());
			ReadyClientToFire( True );
		}
		else
		{
			bWasZoomed = bZoomed;
			if (bWasZoomed)
				ScopeOff();
			Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
			if (iHDTPModelToggle == 2 && IsHDTP())                                          //RSD: Clyzm model
				PlayAnim('ReloadBegin2',1-(ModReloadTime*0.8));
			else
            	PlayAnim('ReloadBegin',1-(ModReloadTime*0.8));
			NotifyOwner(True);
			FinishAnim();
			if (iHDTPModelToggle == 2 && IsHDTP())
				PlayAnim('Reload2');
			else
				PlayAnim('Reload');
			Sleep(GetReloadTime());
			Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
			PlayAnim('ReloadEnd2',1-(ModReloadTime*0.8));
			FinishAnim();
			NotifyOwner(False);
			ReloadMaxAmmo();
		}
	}
	if (bLasing)
    	Emitter.TurnOn();                                                       //RSD: Brings laser back up
	/*if (!bLasing && Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bHardcoreMode) //RSD: Reset accuracy when finishing a reloading cycle on Hardcore mode
	{
		StandingTimer = 0;
	}*/
	GotoState('Idle');
	//RSD: End block from v9 beta
}

defaultproperties
{
     weaponOffsets=(X=13.000000,Y=-2.000000,Z=-29.000000)
     mpNoScopeMult=0.350000
     MountedViewOffset=(X=7.000000,Y=-6.800000,Z=-2.500000)
     LowAmmoWaterMark=3
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=10.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=1.100000
     reloadTime=2.000000
     HitDamage=25
     maxRange=8000
     AccurateRange=4000
     BaseAccuracy=0.800000
     bCanHaveScope=True
     bHasScope=True
     ScopeFOV=16
     bCanHaveLaser=True
     bCanHaveSilencer=True
     bHasMuzzleFlash=False
     recoilStrength=1.170000
     bUseWhileCrouched=False
     mpReloadTime=2.000000
     mpHitDamage=25
     mpAccurateRange=28800
     mpMaxRange=28800
     mpReloadCount=6
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'GMDXSFX.Weapons.SniperFiresilenced'
     RecoilShaker=(X=3.500000,Y=1.000000,Z=2.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bExtraShaker=True
     negTime=0.285000
     AmmoTag="30.06 Ammo"
     ClipModAdd=1
     NPCMaxRange=10000
     NPCAccurateRange=5000
     iHDTPModelToggle=2
     invSlotsXtravel=4
     AmmoName=Class'DeusEx.Ammo3006'
     ReloadCount=5
     PickupAmmoCount=5
     bInstantHit=True
     FireOffset=(X=-20.000000,Y=2.000000,Z=30.000000)
     shakemag=450.000000
     FireSound=Sound'GMDXSFX.Weapons.REV2FIRE'
     AltFireSound=Sound'DeusExSounds.Weapons.RifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.RifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.RifleSelect'
     Misc1Sound=Sound'GMDXSFX.Weapons.SniperDryFire'
     InventoryGroup=5
     ItemName="Sniper Rifle"
     PlayerViewOffset=(X=15.000000,Y=-2.000000,Z=-29.000000)
     PlayerViewMesh=LodMesh'DeusExItems.SniperRifle'
     PickupViewMesh=LodMesh'DeusExItems.SniperRiflePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.SniperRifle3rd'
     HDTPPlayerViewMesh="HDTPItems.HDTPWeaponRifle"
     HDTPPickupViewMesh="HDTPItems.HDTPSniperPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPSniper3rd"
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'RSDCrap.Icons.BeltIconRifle'
     largeIcon=Texture'RSDCrap.Icons.LargeIconRifle'
     largeIconRot=Texture'GMDXSFX.Icons.HDTPLargeIconRotRifle'
     largeIconWidth=159
     largeIconHeight=47
     invSlotsX=4
     Description="The military sniper rifle is the superior tool for the interdiction of long-range targets. When coupled with the proven 30.06 round, a marksman can achieve tight groupings at better than 1 MOA (minute of angle) depending on environmental conditions."
     beltDescription="SNIPER"
     HDTPTexture="HDTPItems.Skins.HDTPWeaponRifleShine"
     CollisionRadius=26.000000
     CollisionHeight=2.000000
     Mass=30.000000
     minSkillRequirement=2;
     bBigMuzzleFlash=true
     bFancyScopeAnimation=true
     muzzleSlot=-1 //doesn't have one
}
