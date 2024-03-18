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

simulated function renderoverlays(Canvas canvas)
{
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector		DrawOffset, WeaponBob;
	local vector unX,unY,unZ;

    //RSD: Clyzm Model Begin
    if (iHDTPModelToggle == 2 && DeusExPlayer(Owner) != none)
    {
   if (bHasLaser)
   {
      if (!bIsCloaked && !bIsRadar)                                             //RSD: Overhauled cloak/radar routines
          multiskins[4] = None;
      if (bLasing)
          multiskins[2]=  None;
      else
          multiskins[2]=Texture'PinkMaskTex';
   }
   else
   {
       multiskins[2]=Texture'PinkMaskTex';
       multiskins[4]=Texture'PinkMaskTex';
   }
   if (bHasSilencer)
   {
       if (!bIsCloaked && !bIsRadar)                                             //RSD: Overhauled cloak/radar routines
           multiskins[5] = None;
       multiskins[6] = Texture'PinkMaskTex';
   }
   else
   {
       multiskins[5]= Texture'PinkMaskTex';
       if (!bIsCloaked && !bIsRadar)                                            //RSD: Overhauled cloak/radar routines
           multiskins[6]= none;
   }
   if (bIsCloaked)                                                              //RSD: This branch needed for some unknown reason
       multiskins[3]= FireTexture'GameEffects.InvisibleTex';
   else if (bIsRadar)
       multiskins[3]= Texture'Effects.Electricity.Xplsn_EMPG';
   else
       multiskins[3]= None;
   super.RenderOverlays(canvas);
   if (bHasLaser)
   {
      if (!bIsCloaked && !bIsRadar)                                             //RSD: Overhauled cloak/radar routines
          multiskins[4] = None;
      if (bLasing)
          multiskins[2]=  None;
      else
          multiskins[2]=Texture'PinkMaskTex';
   }
   else
   {
       multiskins[2]=Texture'PinkMaskTex';
       multiskins[4]=Texture'PinkMaskTex';
   }
   if (bHasSilencer)
   {
       if (!bIsCloaked && !bIsRadar)                                             //RSD: Overhauled cloak/radar routines
           multiskins[5] = None;
       multiskins[6] = Texture'PinkMaskTex';
   }
   else
   {
       multiskins[5]= Texture'PinkMaskTex';
       if (!bIsCloaked && !bIsRadar)                                             //RSD: Overhauled cloak/radar routines
           multiskins[6]= none;
   }
    }
    //RSD: Clyzm Model End
    else if (iHDTPModelToggle == 1)
    {
	if(bHasSilencer)
	{
		if (!bIsCloaked && !bIsRadar)                                           //RSD: Overhauled cloak/radar routines
		    multiskins[4] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[4] = Texture'Effects.Electricity.Xplsn_EMPG';//FireTexture'GameEffects.InvisibleTex'; //RSD: Was using the wrong texture
	     else
             Multiskins[4] = FireTexture'GameEffects.InvisibleTex';//FireTexture'GameEffects.CamoEffect'; //RSD: Was using the wrong texture
        }
	}
	else
	  multiskins[4] = texture'pinkmasktex';
	if(bHasLaser)
	{
		if (!bIsCloaked && !bIsRadar)                                           //RSD: Overhauled cloak/radar routines
		    multiskins[3] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[3] = Texture'Effects.Electricity.Xplsn_EMPG';//FireTexture'GameEffects.InvisibleTex'; //RSD: Was using the wrong texture
	     else
             Multiskins[3] = FireTexture'GameEffects.InvisibleTex';//FireTexture'GameEffects.CamoEffect'; //RSD: Was using the wrong texture
        }
	}
	else
	  multiskins[3] = texture'pinkmasktex';
    if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
    {
       multiskins[2] = none;
       multiskins[1] = none;
       multiskins[0] = none;
    }
	multiskins[6] = Getweaponhandtex();

	super.renderoverlays(canvas);

	if(bHasSilencer)
	  multiskins[3] = none;
	else
	  multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[4] = none;
	else
	  multiskins[4] = texture'pinkmasktex';

	multiskins[6] = none;
	if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
        Texture=Texture'HDTPItems.Skins.HDTPWeaponRifleShine';
    }
    else
    {
    multiskins[0]=Getweaponhandtex();

    super.renderoverlays(canvas);

    multiskins[0]=none;
    }

    if (activateAn == True)
    {
	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=6912*Fmin(1.0,GEPinout);
	rfs.Pitch=2912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);
/*
	if(!bStaticFreeze)
	{
*/
    player = DeusExPlayer(Owner);

	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);

	PlayerViewOffset=Default.PlayerViewOffset*100;//meh
	SetHand(player.Handedness); //meh meh

    if (player.PerkNamesArray[23]== 1)                                          //RSD: Was PerkNamesArray[12], now PerkNamesArray[23] (merged Advanced with Master Rifles perk)
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
    //PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);

	//FireOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.X,-MountedViewOffset.X);
	//FireOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Y,-MountedViewOffset.Y);
	//FireOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Z,-cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z);

	SetLocation(player.Location+ CalcDrawOffset());
	scopeTime+=1;

	//IsInState('DownWeapon')

    if (player.PerkNamesArray[23]== 1)                                          //RSD: Was PerkNamesArray[12], now PerkNamesArray[23] (merged Advanced with Master Rifles perk)
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
}

function ScopeToggle()                                                          //RSD: Clyzm model
{
	/*if (iHDTPModelToggle != 2)                                                //RSD: Hey fellow modders. Restore this commented part and remove the Super.ScopeToggle() below to re-enable iron sights on the stealth pistol
	{                                                                           //RSD: WARNING - the HDTP model toggle menu has issues with ADS if you switch weapon models while using it
		super.ScopeToggle();
		return;
	}
    if(IsInState('Idle') //) // If we aren't doing anything flashy.             //RSD: less restrictive conditions from ToggleScope() in DeusExPlayer.uc
	                    || (!(bZoomed || bAimingDown) && AnimSequence == 'Shoot') || ((bZoomed || bAimingDown) && DeusExPlayer(Owner) != none && DeusExPlayer(Owner).RecoilTime==0))
    {
         GoToState('ADSToggle');
	}*/

	super.ScopeToggle();
}
state ADSToggle                                                                 //RSD: Clyzm model
{
	ignores Fire, AltFire, PutDown, ReloadAmmo, DropFrom; // Whee! We can't do sweet F.A. in this state! :D
	Begin:
		If(bAimingDown)
		{
		    if (bHasScope)
		    {
		        ScopeOff();
		        if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[12]== 1)
		            PlayAnim('SupressorOn',1.3,0.1);
		        else
		            PlayAnim('SupressorOn',,0.1);
            }
		}
		else
		{
		   if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[12]== 1)
               PlayAnim('SuperssorOff',1.3,0.1);
           else
               PlayAnim('SuperssorOff',,0.1);
		}
		bAimingDown=!bAimingDown;
		FinishAnim();
		if (bAimingDown)
		    ScopeOn();
		GoToState('Idle');
}
simulated function PlayIdleAnim()                                               //RSD: Clyzm model
{
    local float rnd;

	if (iHDTPModelToggle != 2)                                                  //RSD: Special routine only for Clyzm model
	{
		super.PlayIdleAnim();
		return;
	}

	if (bZoomed || bNearWall)
		return;
	rnd = FRand();
	If(bAimingDown)
	{
      //PlayAnim('still2',,0.1);
	}
	else
    {
		if (rnd < 0.03)
			PlayAnim('Idle',,0.2);
        //else if (rnd < 0.04)
        //    PlayAnim('Idle3',,0.1);
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

     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 2)                                                 //RSD: Clyzm model
     {
          if (AnimSequence == 'Idle1' || AnimSequence == 'Idle2' || AnimSequence == 'Idle3')
          {
               animToSet = 'Idle';
               animSequence = '';
          }
          PlayerViewMesh=LodMesh'fomod.sniper1st';
          PickupViewMesh=LodMesh'HDTPItems.HDTPSniperPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPSniper3rd';
          default.PlayerViewOffset.X=20.000000;
          default.PlayerViewOffset.Y=-2.000000;
          default.PlayerViewOffset.Z=-30.000000;
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
          PlayerViewMesh=LodMesh'HDTPItems.HDTPWeaponRifle';
          PickupViewMesh=LodMesh'HDTPItems.HDTPSniperPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPSniper3rd';
          default.PlayerViewOffset.X=15.000000;
          default.PlayerViewOffset.Y=-2.000000;
          default.PlayerViewOffset.Z=-29.000000;
     }
     else
     {
          if (AnimSequence == 'Idle')
          {
               animToSet = 'Idle1';
               animSequence = '';
          }
          PlayerViewMesh=LodMesh'DeusExItems.SniperRifle';
          PickupViewMesh=LodMesh'DeusExItems.SniperRiflePickup';
          ThirdPersonMesh=LodMesh'DeusExItems.SniperRifle3rd';
          default.PlayerViewOffset.X=15.000000;
          default.PlayerViewOffset.Y=-2.000000;
          default.PlayerViewOffset.Z=-29.000000;
     }
     if (animToSet != '')
          animSequence = animToSet;
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

function CheckWeaponSkins()
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 2 && DeusExPlayer(Owner) != none)                       //RSD: Clyzm model
     {
   multiskins[1] = GetWeaponHandTex();
   if (bHasLaser)
   {
      if (!bIsCloaked && !bIsRadar)                                             //RSD: Overhauled cloak/radar routines
          multiskins[4] = None;
      if (bLasing)
          multiskins[2]=  None;
      else
          multiskins[2]=Texture'PinkMaskTex';
   }
   else
   {
       multiskins[2]=Texture'PinkMaskTex';
       multiskins[4]=Texture'PinkMaskTex';
   }
   if (bHasSilencer)
   {
       if (!bIsCloaked && !bIsRadar)                                             //RSD: Overhauled cloak/radar routines
           multiskins[5] = None;
       multiskins[6] = Texture'PinkMaskTex';
   }
   else
   {
       multiskins[5]= Texture'PinkMaskTex';
       if (!bIsCloaked && !bIsRadar)                                             //RSD: Overhauled cloak/radar routines
           multiskins[6]= none;
   }
     }
     else if (iHDTPModelToggle == 1 || (iHDTPModelToggle == 2 && Mesh != PlayerViewMesh))
     {
    if(bHasSilencer)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
     }
     else
     {
    if (!bIsCloaked && !bIsRadar)
        multiskins[1] = none;
    if(bHasSilencer)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[4] = none;
	else
		multiskins[4] = texture'pinkmasktex';
     }
}


// Muzzle Flash Stuff
simulated function SwapMuzzleFlashTexture()
{
	 if (!bHasMuzzleFlash)
	 return;
	//if(frand() > 0.5)
		MultiSkins[7] = GetMuzzleTex();
	//else
	//	MultiSkins[7] = Texture'DeusExItems.Skins.FlatFXTex37';

	 MuzzleFlashLight();
	 SetTimer(0.1, False);
}

simulated function texture GetMuzzleTex()
{
	local int i;
	local texture tex;

	i = rand(8);
	switch(i)
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
	 if (iHDTPModelToggle != 2)                                                 //RSD: This was off for Clyzm's model
     MultiSkins[7] = None;
}

function texture GetWeaponHandTex()                                             //RSD: overwritten from DeusExWeapon.uc, see below
{
    local deusexplayer p;
	local texture tex;

    if (iHDTPModelToggle != 2)
		return Super.GetWeaponHandTex();

    if (bIsRadar)//class'DeusExPlayer'.default.bRadarTran==True)                //RSD: Overhauled cloak/radar routines
        return Texture'Effects.Electricity.Xplsn_EMPG';
    else if (bIsCloaked)
        return FireTexture'GameEffects.InvisibleTex';

	tex = texture'weaponhandstex';

	p = deusexplayer(owner);
	if(p != none)
	{
		switch(p.PlayerSkin)
		{
			//default, black, latino, ginger, albino, respectively
			case 0: tex = texture'FOMOD.HandTexFinal'; break;
			case 1: tex = texture'FOMOD.HandTexFinalB'; break;
			case 2: tex = texture'FOMOD.HandTexFinalL'; break;
			case 3: tex = texture'FOMOD.HandTexFinalG'; break;
			case 4: tex = texture'FOMOD.HandTexFinalA'; break;
		}
	}
	return tex;
}

simulated function Timer()
{
	 EraseMuzzleFlashTexture();
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

function EraseWeaponHandTex()
{
	multiskins[1] = None;                                                       //RSD: hand tex is slot 1
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
			if (iHDTPModelToggle == 2)                                          //RSD: Clyzm model
				PlayAnim('ReloadBegin2',1-(ModReloadTime*0.8));
			else
            	PlayAnim('ReloadBegin',1-(ModReloadTime*0.8));
			NotifyOwner(True);
			FinishAnim();
			if (iHDTPModelToggle == 2)
				PlayAnim('Reload2');
			else
				PlayAnim('Reload');
			Sleep(GetReloadTime());
			Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
			PlayAnim('ReloadEnd2',1-(ModReloadTime*0.8));
			FinishAnim();
			NotifyOwner(False);
			ClipCount = 0;
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
     largeIconRot=Texture'GMDXSFX.Icons.HDTPLargeIconRotRifle'
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
     PlayerViewMesh=LodMesh'HDTPItems.HDTPWeaponRifle'
     PickupViewMesh=LodMesh'HDTPItems.HDTPSniperPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPSniper3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'HDTPItems.HDTPBeltIconRifle'
     largeIcon=Texture'HDTPItems.HDTPLargeIconRifle'
     largeIconWidth=159
     largeIconHeight=47
     invSlotsX=4
     Description="The military sniper rifle is the superior tool for the interdiction of long-range targets. When coupled with the proven 30.06 round, a marksman can achieve tight groupings at better than 1 MOA (minute of angle) depending on environmental conditions."
     beltDescription="SNIPER"
     Texture=Texture'HDTPItems.Skins.HDTPWeaponRifleShine'
     Mesh=LodMesh'HDTPItems.HDTPSniperPickup'
     MultiSkins(3)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=26.000000
     CollisionHeight=2.000000
     Mass=30.000000
}
