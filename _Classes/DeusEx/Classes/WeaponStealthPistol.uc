//=============================================================================
// WeaponStealthPistol.
//=============================================================================
class WeaponStealthPistol extends DeusExWeapon;

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
    if(bHasScope)
	{
		if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
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

    if(bHasLaser)
	{
		if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
		    multiskins[7] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[7] = Texture'Effects.Electricity.Xplsn_EMPG';//FireTexture'GameEffects.InvisibleTex'; //RSD: Was using the wrong texture
	     else
             Multiskins[7] = FireTexture'GameEffects.InvisibleTex';//FireTexture'GameEffects.CamoEffect'; //RSD: Was using the wrong texture
        }
	}
	else
		multiskins[7] = texture'pinkmasktex';
	if(bLasing)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	}
	//RSD: Clyzm Model End
    else if (iHDTPModelToggle == 1 || (iHDTPModelToggle == 2 && Mesh != PlayerViewMesh)) //RSD: HDTP stuff
    {
	Multiskins[0] = getweaponhandtex();
	if (!bIsCloaked && !bIsRadar)
	   Multiskins[1] = None;//Texture'GMDXSFX.Skins.HDTPStealthPistolTexAlt';//none;
	else
	{
	   if (bIsRadar)
	      Multiskins[1] = Texture'Effects.Electricity.Xplsn_EMPG';//FireTexture'GameEffects.InvisibleTex'; //RSD: Was using the wrong texture
	   else
          Multiskins[1] = FireTexture'GameEffects.InvisibleTex';//FireTexture'GameEffects.CamoEffect'; //RSD: Was using the wrong texture
    }

	if(bHasScope)
	{
		if (!bIsCloaked && !bIsRadar)
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
		    multiskins[2] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[2] = Texture'Effects.Electricity.Xplsn_EMPG';//FireTexture'GameEffects.InvisibleTex'; //RSD: Was using the wrong texture
	     else
             Multiskins[2] = FireTexture'GameEffects.InvisibleTex';//FireTexture'GameEffects.CamoEffect'; //RSD: Was using the wrong texture
        }
	}
	else
		multiskins[2] = texture'pinkmasktex';
	if(bLasing)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
    }
    else
    {
        multiskins[0] = Getweaponhandtex();
        multiskins[1] = Getweaponhandtex();
        if (!bIsCloaked && !bIsRadar)
            multiskins[3] = none;
    }

	super.renderoverlays(canvas); //(weapon)

    //RSD: Clyzm Model Begin
    if (iHDTPModelToggle == 2 && DeusExPlayer(Owner) != none)
    {
    if(bHasScope)
	{
		if (!bIsCloaked)
		    multiskins[3] = none;
        else
        {
         if (class'DeusExPlayer'.default.bRadarTran==false)
	         Multiskins[3] = FireTexture'GameEffects.InvisibleTex';
         else
             Multiskins[3] = Texture'Effects.Electricity.Xplsn_EMPG';
        }
	}
	else
		multiskins[3] = texture'pinkmasktex';

    if(bHasLaser)
	{
		if (!bIsCloaked)
		    multiskins[7] = none;
		else
        {
         if (class'DeusExPlayer'.default.bRadarTran==false)
	         Multiskins[7] = FireTexture'GameEffects.InvisibleTex';
	     else
             Multiskins[7] = Texture'Effects.Electricity.Xplsn_EMPG';
        }
	}
	else
		multiskins[7] = texture'pinkmasktex';
	if(bLasing)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	}
	//RSD: Clyzm Model End
    else if (iHDTPModelToggle == 0)
    {
        multiskins[0] = Getweaponhandtex();
        multiskins[1] = Getweaponhandtex();
    }
	/*multiskins[0] = None;//Texture'GMDXSFX.Skins.HDTPStealthPistolTexAlt';//none;

	if(bHasScope)
		multiskins[1] = none;
	else
		multiskins[1] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
	if(bLasing)
		multiskins[3] = none;
	else
		multiskins[3] = texture'pinkmasktex';
	multiskins[4]=none;*/

	if (activateAn == True)
    {
	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=2912*Fmin(1.0,GEPinout);
	rfs.Pitch=-62912*sin(Fmin(1.0,GEPinout)*Pi);
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

    //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[12]== 1)
    //{
	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout*1.5)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout*1.25)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	//}
	//else
	//{
	//PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	//PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	//PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.05*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);
	//}
    //PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);

	//FireOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.X,-MountedViewOffset.X);
	//FireOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Y,-MountedViewOffset.Y);
	//FireOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Z,-cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z);

	SetLocation(player.Location+ CalcDrawOffset());
	scopeTime+=1;

	//IsInState('DownWeapon')
    /*
    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PerkNamesArray[12]== 1)
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
        SetHand(PlayerPawn(Owner).Handedness);
    }
    }  */
    if (scopeTime>=18)
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

    multiskins[3] = texture'pinkmasktex';                                       //RSD: So we don't get lingering

	super.BecomePickup();
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
		        PlayAnim('SupressorOn',,0.1);                                   //RSD: Was mispelled 'SuperssorOn', good lord
		        ScopeOff();
            }
            else
            {
			    PlayAnim('SupressorOn',,0.1);
		    }
		}
		else
		{
		    if (bHasScope)
		        PlayAnim('SuperssorOff',,0.1);
		    else
		    {
			    PlayAnim('SuperssorOff',,0.1);
		    }
		}
		bAimingDown=!bAimingDown;
		FinishAnim();
		if (bHasScope && !bZoomed && bAimingDown)
		    ScopeOn();
		GoToState('Idle');
}
simulated function StealthMag()                                                 //RSD: Clyzm model
{
      Owner.PlaySound(Sound'GMDXSFX.Weapons.Stealth_MagInsert', SLOT_None,,, 1024);
}
simulated function StealthClick()                                               //RSD: Clyzm model
{
      Owner.PlaySound(Sound'DeusExSounds.Weapons.StealthPistolReloadEnd', SLOT_None,,, 1024);
}
simulated function PlaySelectiveFiring()                                        //RSD: Clyzm model
{
	local Pawn aPawn;
	local float rnd;
	local Name anim;
	//local int animNum;
	local float mod;
    local float hhspeed;
    if (iHDTPModelToggle != 2)
    {
        Super.PlaySelectiveFiring();
        return;
    }
    if(!bAimingDown)
	{
		anim = 'Shoot';
		mod = 1.500000 - ModShotTime;
		//if (self.AmmoLeftInClip() == 0)
		//    anim = 'ShootLast';
	}
    else
	{
    	anim = 'Shoot2';
    	mod = 1.000000 - ModShotTime;
    }
	if (( Level.NetMode == NM_Standalone ) || ( DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
	{
		if (bAutomatic)
		{
		    //if (IsA('WeaponAssaultGun'))
		    //   LoopAnim(anim,1 * (mod*0.5), 0.1);
            //else
		       //LoopAnim(anim,1 * mod, 0.1);
		      //LoopAnim(anim,1 * mod, 0.1);
		      mod = 1.500000 - 1.5*ModShotTime;
		      PlayAnim(anim, 1.65*mod, 0.0);
		}
		else
        {
            if (anim == 'Shoot')
                PlayAnim(anim,1 * mod,0.0);
            else
			    PlayAnim(anim,1 * mod,0.0);
			//SetTimer(0.4,false);
		}
	}
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
      PlayAnim('still2',,0.1);
	}
	else
    {
		if (rnd < 0.03)
			PlayAnim('Idle',,0.2);
        //else if (rnd < 0.04)
        //    PlayAnim('Idle3',,0.1);
	}
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
	 local name animToSet;

     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 2)
     {
          if (AnimSequence == 'Idle1' || AnimSequence == 'Idle2' || AnimSequence == 'Idle3')
          {
               animToSet = 'Idle';
               animSequence = '';
          }
          PlayerViewMesh=LodMesh'FOMOD.stealthF1st';
          PickupViewMesh=LodMesh'HDTPItems.HDTPstealthpistolPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPstealthpistol3rd';
          addYaw=0;
          addPitch=0;
     }
     else if (iHDTPModelToggle == 1)
     {
          if (AnimSequence == 'Idle')
          {
               animToSet = 'Idle1';
               animSequence = '';
          }
          PlayerViewMesh=LodMesh'HDTPItems.HDTPStealthPistol';
          PickupViewMesh=LodMesh'HDTPItems.HDTPstealthpistolPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPstealthpistol3rd';
          addYaw=800;
          addPitch=-500;
     }
     else
     {
          if (AnimSequence == 'Idle')
          {
               animToSet = 'Idle1';
               animSequence = '';
          }
          PlayerViewMesh=LodMesh'DeusExItems.StealthPistol';
          PickupViewMesh=LodMesh'DeusExItems.StealthPistolPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.StealthPistol3rd';
          addYaw=0;
          addPitch=0;
     }
     if (animToSet != '')
          animSequence = animToSet;
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

function CheckWeaponSkins()
{
     if (iHDTPModelToggle == 2 && DeusExPlayer(Owner) != none)                       //RSD: Clyzm model
     {
          if (!bIsCloaked && !bIsRadar)
          {
               multiskins[0]=none;                                              //RSD: Needed so 3rd person mesh isn't covered with hand tex when switching from HDTP
               multiskins[1]=none;                                              //RSD
               multiskins[2]=none;                                              //RSD
          }
    if(bHasScope)
	{
		if (!bIsCloaked && !bIsRadar)                                           //RSD: Overhauled cloak/radar routines
		{
		    multiskins[3] = none;
		}
        else
        {
         if (bIsRadar)
         {
	         Multiskins[3] = FireTexture'GameEffects.InvisibleTex';
         }
         else
         {
             Multiskins[3] = Texture'Effects.Electricity.Xplsn_EMPG';
         }
        }
	}
	else
	{
		multiskins[3] = texture'pinkmasktex';
	}
    if(bHasLaser)
	{
		if (!bIsCloaked && !bIsRadar)                                           //RSD: Overhauled cloak/radar routines
		    multiskins[7] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[7] = FireTexture'GameEffects.InvisibleTex';
	     else
             Multiskins[7] = Texture'Effects.Electricity.Xplsn_EMPG';
        }
	}
	else
		multiskins[7] = texture'pinkmasktex';
	if(bLasing)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';
     }
     else if (iHDTPModelToggle == 1 || (iHDTPModelToggle == 2 && Mesh != PlayerViewMesh))
     {
    multiskins[0]=none;
	if(bHasScope)
		multiskins[1] = none;
	else
		multiskins[1] = texture'pinkmasktex';
	if(bHasLaser)
		multiskins[2] = none;
	else
		multiskins[2] = texture'pinkmasktex';

	multiskins[3] = texture'pinkmasktex';
	multiskins[4]=none;
     }
     else
     {
          if (!bIsCloaked && !bIsRadar)
          {
               multiskins[0]=none;                                              //RSD: Needed so 3rd person mesh isn't covered with hand tex when switching from HDTP
               multiskins[1]=none;                                              //RSD
               multiskins[2]=none;                                              //RSD
               multiskins[3]=none;                                              //RSD
          }
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
        bAimingDown = False;                                                    //RSD: from v9 beta
        BobDamping=default.BobDamping;                                          //RSD: from v9 beta
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
	bAimingDown=False;		                                                    //RSD: from v9 beta
    BobDamping=default.BobDamping;                                              //RSD: from v9 beta
   }

   /*function Tick(float deltaTime)                                             //RSD: Restored code from v9 beta
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
        lerpClamp += 1;
        if (lerpClamp >= 6)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*40;
           DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*120;
        }
        else
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*60;
           DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*45;
        }
     }
     else if (AnimSequence == 'ReloadEnd')
     {
        DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*20;
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*220;
     }
     if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
				DeusExPlayer(Owner).ViewRotation.Pitch = 16384;
     //}
    }
    }*/

    function Tick(float deltaTime)                                              //RSD: Restored code from v9 beta
   {
        Super.Tick(deltaTime);

    //BroadCastMessage(lerpClamp);
    if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
    {
     //BroadcastMessage(AnimFrame);
     if (AnimSequence == 'Reload')
		{
			ShakeYaw = 0.06 * (Rand(4096) - 2048);
			ShakePitch = 0.06 * (Rand(4096) - 2048);

        LerpClamp = 35;
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime * ShakeYaw;
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime * ShakePitch;
        }
     if (AnimSequence == 'ReloadBegin')
     {
        lerpClamp += 1;
        if (lerpClamp <= 3)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*120;
           DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*40;
        }
        else if (lerpClamp > 30)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*120;
           DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*40;
        }
        else
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*90;
           DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*20;
        }
     }
     else if (AnimSequence == 'ReloadEnd')
     {
        if (AnimFrame <= 0.44)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*160;
           DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*40;
        }
        else if (AnimFrame <= 0.49)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*420;
           DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*220;
        }
        else if (AnimFrame >= 0.88 && AnimFrame < 0.9)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*2220;
           DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*220;
        }
        else
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*60;
           DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*40;
        }
     }
     if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
				DeusExPlayer(Owner).ViewRotation.Pitch = 16384;
     //}
    }
    }
}

defaultproperties
{
     weaponOffsets=(X=17.000000,Y=-10.000000,Z=-15.000000)
     MountedViewOffset=(X=4.000000,Y=3.500000,Z=-45.500000)
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_All
     ShotTime=0.300000
     reloadTime=4.000000
     HitDamage=9
     maxRange=2560
     AccurateRange=1280
     BaseAccuracy=0.750000
     bCanHaveScope=True
     ScopeFOV=30
     bCanHaveLaser=True
     AmmoNames(0)=Class'DeusEx.Ammo10mm'
     AmmoNames(1)=Class'DeusEx.Ammo10mmAP'
     bHasMuzzleFlash=False
     recoilStrength=0.290000
     mpReloadTime=1.500000
     mpHitDamage=12
     mpBaseAccuracy=0.200000
     mpAccurateRange=1200
     mpMaxRange=1200
     mpReloadCount=12
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     RecoilShaker=(X=1.500000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bCanHaveModFullAuto=True
     ReloadMidSound=Sound'GMDXSFX.Weapons.9mmBoltOpened1'
     negTime=0.565000
     AmmoTag="10mm Ammo"
     addYaw=800
     addPitch=-500
     ClipModAdd=1
     NPCMaxRange=4000
     NPCAccurateRange=2000
     iHDTPModelToggle=1
     AmmoName=Class'DeusEx.Ammo10mm'
     ReloadCount=15
     PickupAmmoCount=10
     bInstantHit=True
     FireOffset=(X=-24.000000,Y=10.000000,Z=14.000000)
     shakemag=96.000000
     FireSound=Sound'GMDXSFX.Weapons.stealth_fire'
     AltFireSound=Sound'DeusExSounds.Weapons.StealthPistolReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.StealthPistolReload'
     SelectSound=Sound'DeusExSounds.Weapons.StealthPistolSelect'
     InventoryGroup=3
     ItemName="Stealth Pistol"
     PlayerViewOffset=(X=24.000000,Y=-10.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPStealthPistol'
     BobDamping=0.760000
     PickupViewMesh=LodMesh'HDTPItems.HDTPstealthpistolPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPstealthpistol3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconStealthPistol'
     largeIcon=Texture'DeusExUI.Icons.LargeIconStealthPistol'
     largeIconWidth=47
     largeIconHeight=37
     Description="Designed for wet work, the stealth pistol is manufactured to boast a notably large clip, integrated silencer and recoil compensator. Excels performance-wise in all except raw stopping power."
     beltDescription="STEALTH"
     Mesh=LodMesh'HDTPItems.HDTPstealthpistolPickup'
     CollisionRadius=8.000000
     CollisionHeight=0.800000
     minSkillRequirement=2;
}
