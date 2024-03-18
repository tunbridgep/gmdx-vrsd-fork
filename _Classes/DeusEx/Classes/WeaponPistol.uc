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

simulated function renderoverlays(Canvas canvas)
{
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector		DrawOffset, WeaponBob;
	local vector unX,unY,unZ;

    if (iHDTPModelToggle == 1)                                                  //RSD: Need this off for vanilla model
    {
    if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
    {
	/*if(bHasSilencer)
	  multiskins[6] = none;
	else
	  multiskins[6] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[5] = none;
	else
	  multiskins[5] = texture'pinkmasktex';
	if(bHasScope)
	  multiskins[4] = none;
	else
	  multiskins[4] = texture'pinkmasktex';*/
	  multiskins[1] = none;
    }
    else                                                                        //RSD: Not sure if I need to add this, but I did
    {
	   if (bIsRadar)
	      Multiskins[1] = Texture'Effects.Electricity.Xplsn_EMPG';
	   else
          Multiskins[1] = FireTexture'GameEffects.InvisibleTex';
    }

    //RSD: Added all this to make elements render properly
    if(bHasSilencer)
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
		    multiskins[5] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[5] = Texture'Effects.Electricity.Xplsn_EMPG';
	     else
             Multiskins[5] = FireTexture'GameEffects.InvisibleTex';
        }
	}
	else
		multiskins[5] = texture'pinkmasktex';
    if(bHasScope)
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

	multiskins[2] = Getweaponhandtex();
    }
    else                                                                        //RSD: Vanilla model needs special help for animated cloak/radar
    {
    multiskins[0] = Getweaponhandtex();
    multiskins[1] = Getweaponhandtex();
    if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
    {
       //multiskins[1] = none;
       //multiskins[2] = none;
       multiskins[3] = none;
    }
    else
    {
	   if (bIsRadar)
	   {
          Multiskins[1] = Texture'Effects.Electricity.Xplsn_EMPG';
          Multiskins[3] = Texture'Effects.Electricity.Xplsn_EMPG';
	   }
       else
	   {
          Multiskins[1] = FireTexture'GameEffects.InvisibleTex';
          Multiskins[3] = FireTexture'GameEffects.InvisibleTex';
       }
    }

    }
	super.renderoverlays(canvas);

    if (iHDTPModelToggle == 1)                                                  //RSD
	    multiskins[2] = none;
	else
	{
        multiskins[0] = none;
        multiskins[1] = none;
    }

	if (activateAn == True)
    {
	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

    if (!bHasScope)
    {
    BobDamping=0.990000;
    if (scopeTime < 17)
    {
    PlayerViewOffset=Default.PlayerViewOffset*100;//meh
        SetHand(player.Handedness); //meh meh
	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
    }
    rfs.Yaw=6912*Fmin(1.0,GEPinout);
	rfs.Pitch=2912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);

    player = DeusExPlayer(Owner);
    //if (scopeTime >= 2)
       //player.DesiredFOV = player.default.DesiredFOV + 4;
	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);
    SetLocation(player.Location+ CalcDrawOffset());
    }
    else
    {
        PlayerViewOffset=Default.PlayerViewOffset*100;//meh
        SetHand(player.Handedness); //meh meh

	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);

    rfs.Yaw=2912*Fmin(1.0,GEPinout);
	rfs.Pitch=-62912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);

    player = DeusExPlayer(Owner);

	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);
    SetLocation(player.Location+ CalcDrawOffset());
    }

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
}

function BecomePickup()
{
	activateAn = False;
        scopeTime = 0;
        GEPinout = 0;
        axesX = vect(0,0,0);
        axesY = vect(0,0,0);
        axesZ = vect(0,0,0);
        PlayerViewOffset=Default.PlayerViewOffset*100;

	super.BecomePickup();
}

/*simulated function ScopeToggle()
{
	if (bHasScope)
	{
	ScopeFOV=40;
	super.ScopeToggle();
	}
	else if (ScopeFOV==41)
	{
    ScopeFOV=40;
    }
    else
    {
    ScopeFOV=41;
    }
}*/

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          if (AnimSequence == 'ReloadBegin' || AnimSequence == 'ReloadEnd')     //RSD: Don't have these
          {
               animSequence = 'Idle';
          }
          PlayerViewMesh=LodMesh'HDTPItems.HDTPWeaponPistol';
          PickupViewMesh=LodMesh'HDTPItems.HDTPGlockPickUp';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPGlock3rd';
          addYaw=250;
          addPitch=-150;
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.Glock';
          PickupViewMesh=LodMesh'DeusExItems.GlockPickUp';
          ThirdPersonMesh=LodMesh'DeusExItems.Glock3rd';
          addYaw=0;
          addPitch=0;
     }
     //RSD: HDTP Toggle End
     Super.UpdateHDTPsettings();
}

function CheckWeaponSkins()
{
     if (iHDTPModelToggle == 1)                                                 //RSD: Need this off for vanilla model
     {
    if(bHasSilencer)
	  multiskins[6] = none;
	else
	  multiskins[6] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[5] = none;
	else
	  multiskins[5] = texture'pinkmasktex';
	if(bHasScope)
	  multiskins[4] = none;
	else
	  multiskins[4] = texture'pinkmasktex';

          if (bHasLaser && bLasing)
               multiskins[3] = texture'HDTPGlockTex4';
          else
               multiskins[3] = none;

     }
     else
     {
          multiskins[0]=none;                                                   //RSD: Needed so 3rd person mesh isn't covered with hand tex dropped with cloak/radar active
     }
}

function texture GetWeaponHandTex()                                             //RSD: overwritten from DeusExWeapon.uc, see below
{
	local deusexplayer p;
	local texture tex;

    if (iHDTPModelToggle == 0 && (bIsCloaked || bIsRadar))                      //RSD: Need this for some unfathomable reason so the cloak/radar textures animate on the vanilla version. Who fucking knows
        return Texture'PinkMaskTex';//FireTexture'GameEffects.CamoEffect';
    else return Super.GetWeaponHandTex();
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

// Muzzle Flash Stuff
simulated function SwapMuzzleFlashTexture()
{
    if (iHDTPModelToggle == 1)
    {
    if (!bHasMuzzleFlash || bHasSilencer)
	{
		if(bLasing)// && !bIsCloaked && !bIsRadar)
		{
			MultiSkins[3] = texture'HDTPGlockTex4';
			setTimer(0.1, false);
		}
		return;
	}



	//if (FRand() < 0.5)
		MultiSkins[3] = GetMuzzleTex();
	//else
	//	MultiSkins[3] = Texture'FlatFXTex37';
    }
    else
    {
        if (!bHasMuzzleFlash || bHasSilencer)
		    return;
        MultiSkins[2] = GetMuzzleTex();
    }
	 MuzzleFlashLight();
	 SetTimer(0.1, False);
}

simulated function EraseMuzzleFlashTexture()
{
	if (iHDTPModelToggle == 1)
    {
    if(!bLasing)
		MultiSkins[3] = none;
	else// if (!bIsCloaked && !bIsRadar)
		MultiSkins[3] = texture'HDTPGlockTex4';
	}
	else
        MultiSkins[2] = none;
}

simulated function Timer()
{
	 EraseMuzzleFlashTexture();
}

function PistolLaserOn()
{
	if (bHasLaser && !bLasing)
	{
		// if we don't have an emitter, then spawn one
		// otherwise, just turn it on
		if (Emitter == None)
		{
			Emitter = Spawn(class'LaserEmitter', Self, , Location, Pawn(Owner).ViewRotation);
			if (Emitter != None)
			{
				Emitter.SetHiddenBeam(True);
				Emitter.AmbientSound = None;
				Emitter.TurnOn();
			}
		}
		else
			Emitter.TurnOn();
			Owner.PlaySound(sound'KeyboardClick3', SLOT_None,,, 1024,1.5);

        if (iHDTPModelToggle == 1)                                              //RSD: Added iHDTPModelToggle
		    Multiskins[3] = texture'HDTPGlockTex4';

		bLasing = True;
        bLaserToggle = true;
	}
}

function PistolLaserOff(bool forced)
{
	if (bHasLaser && bLasing)
	{
		if (Emitter != None)
			Emitter.TurnOff();
            Owner.PlaySound(sound'KeyboardClick2', SLOT_Misc,,, 1024,1.5);
		if (iHDTPModelToggle == 1)                                              //RSD: Added iHDTPModelToggle
            Multiskins[3] = none;

		bLasing = False;
        if (!forced)
            bLaserToggle = false;
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
     PlayerViewOffset=(X=22.000000,Y=-10.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPWeaponPistol'
     BobDamping=0.640000
     PickupViewMesh=LodMesh'HDTPItems.HDTPGlockPickUp'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPGlock3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconPistol'
     largeIcon=Texture'DeusExUI.Icons.LargeIconPistol'
     largeIconWidth=46
     largeIconHeight=28
     Description="A standard 10mm pistol."
     beltDescription="PISTOL"
     Mesh=LodMesh'HDTPItems.HDTPGlockPickUp'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(6)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=7.000000
     CollisionHeight=1.000000
}
