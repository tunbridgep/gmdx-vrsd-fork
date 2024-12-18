//=============================================================================
// WeaponPistol.
//=============================================================================
class WeaponPistol extends DeusExWeapon;

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
	
	rfs.Yaw=2912*Fmin(1.0,GEPinout);
	rfs.Pitch=-62912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);
    
    player = DeusExPlayer(Owner);

	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);

	PlayerViewOffset=Default.PlayerViewOffset*100;//meh
	SetHand(player.Handedness); //meh meh

	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);

	SetLocation(player.Location+ CalcDrawOffset());
	scopeTime+=1;

    if (scopeTime>=18 && bHasScope)
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
    if (IsHDTP())
        MuzzleSlot = 3;
    else
        MuzzleSlot = 2;
	super.DisplayWeapon(overlay);
    
    if (IsHDTP())
    {
		if (overlay)
			multiskins[2] = handstex;
        ShowWeaponAddon(4,bHasScope);
        ShowWeaponAddon(6,bHasSilencer);
        ShowWeaponAddon(5,bHasLaser);
    
        if (bHasLaser && bLasing)
            multiskins[3] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPGlockTex4");
        else
            multiskins[3] = texture'PinkMaskTex';
    }
    else if (overlay)
    {
        multiskins[1] = handstex;
    }
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (IsHDTP())
     {
          if (AnimSequence == 'ReloadBegin' || AnimSequence == 'ReloadEnd')     //RSD: Don't have these
          {
               animSequence = 'Idle';
          }
          addYaw=250;
          addPitch=-150;
     }
     else
     {
          addYaw=0;
          addPitch=0;
     }
     //RSD: HDTP Toggle End
     Super.UpdateHDTPsettings();
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
	}
}

simulated function Timer()
{
	 EraseMuzzleFlashTexture();
}

function LaserOn(optional bool IgnoreSound)
{
	if (bHasLaser && !bLasing)
    {
        Super.LaserOn(IgnoreSound);
        if (IsHDTP())                                              //RSD: Added iHDTPModelToggle
		    Multiskins[3] = class'HDTPLoader'.static.GetTexture("HDTPItems.HDTPGlockTex4");
    }
}

function LaserOff(bool forced)
{
	if (bHasLaser && bLasing)
	{
        Super.LaserOff(forced);
		if (IsHDTP())                                              //RSD: Added iHDTPModelToggle
            multiskins[3] = texture'PinkMaskTex';
	}
}


simulated function MuzzleFlashLight()
{
	 local Vector offset, X, Y, Z;
	 local Effects flash;

	  if (!bHasMuzzleFlash || bHasSilencer)
		  return;

	 if ((flash != None) && !flash.bDeleteMe)
		  flash.LifeSpan = flash.Default.LifeSpan;
	 else
	 {
		  GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		  offset = Owner.Location;
		  offset += X * Owner.CollisionRadius * 2;
		  flash = spawn(class'Muzzleflash',,, offset);
		  if (flash != None)
			   flash.SetBase(Owner);
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
        if (Owner != None && Owner.IsA('DeusExPlayer'))
        SetHand(DeusExPlayer(Owner).Handedness);
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
     //if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
     //{
     if (AnimSequence == 'Reload')
     {
        lerpClamp += 1;
        if (lerpClamp >= 8*ReloadTime && lerpClamp < 20*ReloadTime)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*120;
           DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*40;
        }
        else if (lerpClamp < 8*ReloadTime)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*80;
           DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*60;
        }
        else if (lerpClamp >= 20*ReloadTime && lerpClamp < 28*ReloadTime)
        {
          DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*70;
          DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*10;
        }
        else if (lerpClamp >= 28*ReloadTime && lerpClamp < 30*ReloadTime)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*830;
           DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*30;
        }
     }
     if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
				DeusExPlayer(Owner).ViewRotation.Pitch = 16384;
     //}
    }
    }
}

state Idle
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}
	function AnimEnd()
	{
	}
	function Timer()
	{
		PlayIdleAnim();
		 If(bAimingDown)
	    {
            BobDamping=0.9825;
	    }
		else if (!bNearWall && !activateAn)
		{
            BobDamping=default.BobDamping;
        }
	}
Begin:
	bFiring = False;
	ReadyToFire();
	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
	}
	else
	{
	    If(bAimingDown)
	    {
            PlayAnim('STILL2',,0.1);
            BobDamping=0.9825;
	    }
		else if (!bNearWall && !activateAn)
		{
		    PlayAnim('STILL',,0.1);
            BobDamping=default.BobDamping;
        }
		SetTimer(3.0, True);
	}
}

defaultproperties
{
     weaponOffsets=(X=18.000000,Y=-10.000000,Z=-17.000000)
     MountedViewOffset=(X=2.555000,Y=-6.703000,Z=-110.500000)
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=6.000000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=0.300000
     reloadTime=2.000000
     HitDamage=11
     maxRange=3600
     AccurateRange=1800
     BaseAccuracy=0.650000
     bCanHaveScope=True
     ScopeFOV=40
     bCanHaveLaser=True
     bCanHaveSilencer=True
     AmmoNames(0)=Class'DeusEx.Ammo10mm'
     AmmoNames(1)=Class'DeusEx.Ammo10mmAP'
     recoilStrength=0.625000
     mpReloadTime=2.000000
     mpHitDamage=20
     mpBaseAccuracy=0.200000
     mpAccurateRange=1200
     mpMaxRange=1200
     mpReloadCount=9
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'GMDXSFX.Weapons.USPSilencedFireB'
     RecoilShaker=(X=2.500000,Y=1.000000,Z=1.500000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     negTime=0.565000
     AmmoTag="10mm Ammo"
     addYaw=250
     addPitch=-150
     ClipModAdd=1
     NPCMaxRange=4800
     NPCAccurateRange=2400
     iHDTPModelToggle=1
     AmmoName=Class'DeusEx.Ammo10mm'
     ReloadCount=8
     PickupAmmoCount=8
     bInstantHit=True
     FireOffset=(X=-22.000000,Y=10.000000,Z=14.000000)
     shakemag=440.000000
     FireSound=Sound'GMDXSFX.Weapons.GlockFire'
     AltFireSound=Sound'GMDXSFX.Weapons.M4ClipOut'
     CockingSound=Sound'DeusExSounds.Weapons.PistolReload'
     SelectSound=Sound'DeusExSounds.Weapons.PistolSelect'
     InventoryGroup=2
     ItemName="Pistol"
     BobDamping=0.640000
     PlayerViewOffset=(X=22.000000,Y=-10.000000,Z=-14.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPWeaponPistol"
     HDTPPickupViewMesh="HDTPItems.HDTPGlockPickUp"
     HDTPThirdPersonMesh="HDTPItems.HDTPGlock3rd"
     PlayerViewMesh=LodMesh'DeusExItems.Glock'
     PickupViewMesh=LodMesh'DeusExItems.GlockPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Glock3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconPistol'
     //HDTPIcon="HDTPItems.Icons.HDTPBeltIconPistol" //HDTP-styled icon //DISABLED as it breaks belt memory
     HDTPlargeIcon="RSDCrap.Icons.LargeIconPistol" //HDTP-styled icon
     largeIcon=Texture'DeusExUI.Icons.LargeIconPistol'
     largeIconWidth=46
     largeIconHeight=28
     Description="A standard 10mm pistol."
     beltDescription="PISTOL"
     Mesh=LodMesh'DeusExItems.GlockPickUp'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(6)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=7.000000
     CollisionHeight=1.000000
     minSkillRequirement=1;
}
