//=============================================================================
// WeaponGEPGun.
//=============================================================================
class WeaponGEPGun extends DeusExWeapon;

var localized String shortName;

//GMDX:vars for(&from) gep mounted
var DeusExPlayer player;
var GMDXFlickerLight lightFlicker;
var vector axesX;//fucking weapon rotation fix
var vector axesY;
var vector axesZ;
var bool bFlipFlopCanvas;
var texture GEPVid;
var texture GEPNoise;
var texture GEPAtlas;
var bool bGEPjit;
var float GEPinout;
var bool bGEPout;
var vector MountedViewOffset;

var rotator SAVErotation;
var vector SAVElocation;
var bool bStaticFreeze;
var rotator OldRotation;
var int lerpClamp;
//GMDX:finish vars


function SetMount(DeusExPlayer dxp)
{
//	local vector ofs;

	bGEPout=dxp==none;

	if (!bGEPout)
	  player=dxp;


	if ((!bGEPout)&&(GEPinout==0)) GEPinout=0.001;

//	SetCollision(false,false,false);
//	bCollideWorld=false;

	/*if (lightFlicker==none)
	{
	  lightFlicker=Spawn(class'DeusEx.GMDXFlickerLight',self);
	  if (lightFlicker!=none)
	  {
	     lightFlicker.UpdateLocation(player);
	  }
	}*/
}

/*
function PreRender2()
{
	if(bHasScope)
	  multiskins[3] = none;
	else
	  multiskins[3] = texture'pinkmasktex';
	if(bHasLaser)
	  multiskins[1] = none;
	else
	  multiskins[1] = texture'pinkmasktex';
	if(bLasing)
	  multiskins[2] = none;
	else
	  multiskins[2] = texture'pinkmasktex';
}
*/

function LaserOn(optional bool IgnoreSound)
{
   super.LaserOn(IgnoreSound);

   if (bHasLaser)
       LockTime=0.100000;
}

function LaserOff(bool forced)
{
   super.LaserOff(forced);

   LockTime=default.LockTime;
}

function RenderME(Canvas canvas,bool bSetWire,optional bool bClearZ)
{
	local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector		DrawOffset, WeaponBob;
	local vector unX,unY,unZ;

	if(!bGEPout)
	{
		if (GEPinout<1) GEPinout=Fmin(1.0,GEPinout+0.04);
	} else
		if (GEPinout<1) GEPinout=Fmax(0,GEPinout-0.04);//do Fmax(0,n) @ >0<=1

	rfs.Yaw=2912*Fmin(1.0,GEPinout);
	rfs.Pitch=-2912*sin(Fmin(1.0,GEPinout)*Pi);
	GetAxes(rfs,axesX,axesY,axesZ);
/*
	if(!bStaticFreeze)
	{
*/
	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);

	PlayerViewOffset=Default.PlayerViewOffset*100;//meh
	SetHand(PlayerPawn(Owner).Handedness); //meh meh

	PlayerViewOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.X,MountedViewOffset.X*100);
	PlayerViewOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Y,MountedViewOffset.Y*100);
	PlayerViewOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),PlayerViewOffset.Z,cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z*100);

	FireOffset.X=Smerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.X,-MountedViewOffset.X);
	FireOffset.Y=Smerp(1.0-cos(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Y,-MountedViewOffset.Y);
	FireOffset.Z=Lerp(sin(FMin(1.0,GEPinout)*0.5*Pi),Default.FireOffset.Z,-cos(FMin(1.0,GEPinout)*2*Pi)*MountedViewOffset.Z);

	SetLocation(player.Location+ CalcDrawOffset());// layer.BaseEyeHeight*vect(0,0,1)+(PlayerViewOffset>>player.ViewRotation));
/*
	if (player.bStaticFreeze)
	{
		SAVElocation=player.SAVElocation+CalcDrawOffset();
		SAVErotation=rfs;
		bStaticFreeze=true;
	}
	} else
	{
		if (player.bStaticFreeze)
		{
			DrawOffset = ((0.9/player.Default.FOVAngle * PlayerViewOffset) >> SAVERotation);
			DrawOffset += (player.EyeHeight * vect(0,0,1));
		 / *  WeaponBob = BobDamping * player.WalkBob;
			WeaponBob.Z = (0.45 + 0.55 * BobDamping) * player.WalkBob.Z;
			DrawOffset += WeaponBob;* /
			SetRotation(SAVErotation);

		   if (VSize(player.RecoilShake)>0.0)
		   {
			GetAxes(SAVErotation,unX,unY,unZ);
			unX*=DeusExPlayer(Owner).RecoilShake.X*0.75;
			unY*=DeusExPlayer(Owner).RecoilShake.Y*0.75;
			unZ*=DeusExPlayer(Owner).RecoilShake.Z*0.75;
			DrawOffset+=(unX+unY+unZ);
		   }

			SetLocation(SAVElocation+unX+unY+unZ);
		} else
			bStaticFreeze=false;
	}
*/
//  PlayerViewOffset=default.PlayerViewOffset*100;
//   SetHand(PlayerPawn(Owner).Handedness); //meh meh
	Canvas.DrawActor(self, bSetWire,bClearZ);

	if (lightFlicker!=none) lightFlicker.UpdateLocation(player);
}

simulated function renderoverlays(Canvas canvas)
{
    super.renderoverlays(canvas);
	if(GEPinout==0.0)
	{
		PlayerViewOffset=Default.PlayerViewOffset*100;
		FireOffset=Default.FireOffset;
		SetHand(PlayerPawn(Owner).Handedness);
		if (player!=none)
		{
			player.GEPmounted=none;
			player=none;
		}
	} else
	     RenderMe(canvas,false);

	if (GEPinout>=1) RenderPortal(canvas);

}
function DisplayWeapon(bool overlay)
{
    super.DisplayWeapon(overlay);
    if (IsHDTP())
    {
        if (overlay)
        {
            ShowWeaponAddon(1,bHasScope);
            ShowWeaponAddon(2,bHasLaser);
            ShowWeaponAddon(3,bLasing);
        }
        else
        {
            ShowWeaponAddon(1,bHasLaser);
            ShowWeaponAddon(2,bLasing);
            ShowWeaponAddon(3,bHasScope);
        }
    }

    if (ammoType == none)
    {
    }
	else if(ammotype.isA('AmmoRocketWP'))
	{
		multiskins[4] = texture'pinkmasktex';
		multiskins[5] = none;
		multiskins[6] = none;
	}
	else if(ammotype.isA('AmmoRocket'))
	{
		multiskins[4] = none;
		multiskins[5] = texture'pinkmasktex';
		multiskins[6] = texture'pinkmasktex';
	}
//	else //bleh??
//	{
//		multiskins[4] = texture'pinkmasktex';
//		multiskins[5] = texture'pinkmasktex';
//		multiskins[6] = texture'pinkmasktex';
//	}

}

function BecomePickup()
{
	if (player!=none)
	{
		player.GEPmounted=none;
		GEPinout=0;
		bFlipFlopCanvas=false;
	}
	super.BecomePickup();
}

function RenderPortal(canvas Canvas)
{
	local Actor actnul;
	local float ofy;
	local float ofy2;
	local rotator rdif;
	local vector rloc;

	if (!bFlipFlopCanvas)//stop self sustain
	{
		bFlipFlopCanvas=true;
		if(!bGEPout)
		{
			GEPinout=Fmin(2.0,GEPinout+0.15);
			if(FRand()<0.01) GEPinout*=(FRand()*0.05+0.95);
		} else
			GEPinout=GEPinout-0.2;//do Fmax(0,n) @ >0<=1

		ofy=Canvas.ClipY/Lerp(GEPinout-1.0,2,8);
		ofy2=(Canvas.ClipY*0.75)*(GEPinout-1.0);

		if (player.bGEPprojectileInflight)
		{
        /* rdif=player.aGEPProjectile.Rotation-OldRotation;
         rdif.Roll=rdif.Roll+(Frand()*2)-1;
         rdif.Roll=FMin(300,rdif.Roll);
         rdif.Roll=FMax(-300,rdif.Roll);
         OldRotation=player.aGEPProjectile.Rotation;*/

         rdif=player.aGEPProjectile.Rotation;
         rloc=player.aGEPProjectile.Location+(Rocket(player.aGEPProjectile).PortalOffset>>rdif);
         actnul=player.aGEPProjectile;
   	   //Canvas.DrawPortal(Canvas.ClipX/8,Canvas.ClipY/8,Canvas.ClipX*0.75,Canvas.ClipY/2,actnul,rloc,rdif, 100)
      } else
      {
         rloc=player.Location+CalcDrawOffset();
         rdif=player.ViewRotation;
         actnul=player;
      }
		PlayerViewOffset=MountedViewOffset*100;
		//if(FRand()>0.01) //(0.95-GEPinout))
	   Canvas.DrawPortal(Canvas.ClipX/8,ofy,Canvas.ClipX*0.75,ofy2,actnul, rloc, rdif,10+90*(GEPinout-1.0));
		PlayerViewOffset=Default.PlayerViewOffset*100;
		SetHand(PlayerPawn(Owner).Handedness);

//Render Screen
		if(bGEPjit)
			Canvas.SetPos(Canvas.ClipX/8,ofy+5);
			else
				Canvas.SetPos(Canvas.ClipX/8,ofy);
		Canvas.Style=4;
		Canvas.DrawRect(GEPVid,Canvas.ClipX*0.75,ofy2);

		Canvas.Style=3;//none,normal,masked,translucent,modulated
//Render "Fuel Bar" -bottom line right
		Canvas.SetPos(Canvas.ClipX*0.125+8,Canvas.ClipY*0.5);
		Canvas.DrawTile(GEPAtlas,32,Canvas.ClipY*0.875-8-Canvas.ClipY*0.5,0,0,32,64);

//Render "Fuel"
		//Canvas.SetPos(Canvas.ClipX*0.125+48,Canvas.ClipY*0.875-40);
		//Canvas.DrawTile(GEPAtlas,64,32,64,32,64,32);

//Render "Wait" (Fuel)
//		Canvas.SetPos(Canvas.ClipX*0.125+120,Canvas.ClipY*0.875-40); //CyberP: comment out start
//		Canvas.DrawTile(GEPAtlas,64,32,192,96,64,32);

//Render "Dry" (Fuel)
//		Canvas.SetPos(Canvas.ClipX*0.125+120,Canvas.ClipY*0.875-40);
//		Canvas.DrawTile(GEPAtlas,64,32,128,96,64,32);

//Render "Warning" (Fuel)
//		Canvas.SetPos(Canvas.ClipX*0.125+120,Canvas.ClipY*0.875-40);
//		Canvas.DrawTile(GEPAtlas,128,32,128,0,128,32);

//Render "Signal Bar" -bottom line left
		Canvas.SetPos(Canvas.ClipX*0.125+40,Canvas.ClipY*0.5);
		Canvas.DrawTile(GEPAtlas,32,Canvas.ClipY*0.875-8-Canvas.ClipY*0.5,32,0,32,64);

//Render "Wait" (Signl)
//		Canvas.SetPos(Canvas.ClipX*0.875-112,Canvas.ClipY*0.875-40);
//		Canvas.DrawTile(GEPAtlas,64,32,192,96,64,32);

//Render "Sync" (Signl)
		//Canvas.SetPos(Canvas.ClipX*0.875-112,Canvas.ClipY*0.875-40);
		//Canvas.DrawTile(GEPAtlas,64,32,192,64,64,32);

//Render "lost" (Signl)
//		Canvas.SetPos(Canvas.ClipX*0.875-112,Canvas.ClipY*0.875-40);
//		Canvas.DrawTile(GEPAtlas,64,32,128,64,64,32);

//Render "Host" (Signl)
//		Canvas.SetPos(Canvas.ClipX*0.875-112,Canvas.ClipY*0.875-40);
//		Canvas.DrawTile(GEPAtlas,64,32,192,32,64,32);

//Render "Signl"
//		Canvas.SetPos(Canvas.ClipX*0.875-184,Canvas.ClipY*0.875-40);
//		Canvas.DrawTile(GEPAtlas,64,32,128,32,64,32);

//Render "Rng.Warning" (signl)
//		Canvas.SetPos(Canvas.ClipX*0.875-376,Canvas.ClipY*0.875-40);
//		Canvas.DrawTile(GEPAtlas,192,32,64,0,192,32);

//Render "Loaded" -topline right
//		Canvas.SetPos(Canvas.ClipX*0.125+8,Canvas.ClipY*0.125+8);
//		Canvas.DrawTile(GEPAtlas,128,32,0,96,128,32);

//Render "*Reload*" -topline right
//		Canvas.SetPos(Canvas.ClipX*0.125+8,Canvas.ClipY*0.125+8);
//		Canvas.DrawTile(GEPAtlas,128,32,0,64,128,32);

//Render "Warhead" -topline right
//		Canvas.SetPos(Canvas.ClipX*0.125+18,Canvas.ClipY*0.125+8);
//		Canvas.DrawTile(GEPAtlas,131,32,0,128,131,32);

//Render "Explosive" (Loaded,Warhead=in flight)
//		Canvas.SetPos(Canvas.ClipX*0.125+162,Canvas.ClipY*0.125+8);
//		Canvas.DrawTile(GEPAtlas,135,32,0,160,135,32);

//Render "White P"+hosphor (Loaded,Warhead=in flight)
//		Canvas.SetPos(Canvas.ClipX*0.125+162,Canvas.ClipY*0.125+8);
//		Canvas.DrawTile(GEPAtlas,256-136,32,136,160,256-136,32);
		//"hosphor"
//		Canvas.SetPos(Canvas.ClipX*0.125+184+96,Canvas.ClipY*0.125+8);
//		Canvas.DrawTile(GEPAtlas,256-131,32,131,128,256-131,32);


//Render "GMDX#101" topline left
//		Canvas.SetPos(Canvas.ClipX*0.875-164,Canvas.ClipY*0.125+8);
//		Canvas.DrawTile(GEPAtlas,156,32,0,224,156,32);

//Render "GEP Online:ID" topline left
//		Canvas.SetPos(Canvas.ClipX*0.875-364,Canvas.ClipY*0.125+8);
//		Canvas.DrawTile(GEPAtlas,200,32,0,192,200,32);                //CyberP: comment out end


		//Canvas.DrawPortal(GEPtopX,GEPtopY,GEPwidth,GEPheight,actnul, Location, ViewRotation, 100);
		//GEPmounted.RenderMe(Canvas,true,true);

		bGEPjit=!bGEPjit;
		bFlipFlopCanvas=false;
        player.UpdateCrosshair();
	}
}

simulated function ScopeToggle()
{
	//log("Start: ScopeToggle()InState="@GetStateName());
	super.ScopeToggle();

	//log("End: ScopeToggle()InState="@GetStateName());
}

exec function UpdateHDTPsettings()
{
     if (IsHDTP())
          addPitch=600;
     else
          addPitch=0;

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
	  bHasScope = True;
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
        DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*80;
        DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*30;
        lerpClamp += 1;
        if (lerpClamp >= 12)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*220;
        }
     }
     else if (AnimSequence == 'ReloadEnd')
     {
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*300;
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*180;
     }
     //}
    }
    }
}

defaultproperties
{
     weaponOffsets=(X=34.000000,Y=-22.000000,Z=-10.000000)
     ShortName="GEP Gun"
     GEPvid=Texture'GMDXUI.Skins.GEPOverlayDiamond'
     GEPnoise=Texture'GMDXUI.Skins.GEPnoise'
     GEPAtlas=Texture'GMDXUI.UserInterface.GEPatlesA'
     bGEPout=True
     MountedViewOffset=(X=24.000000,Y=7.200000,Z=-4.500000)
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     NoiseLevel=9.000000
     EnviroEffective=ENVEFF_Air
     reloadTime=1.500000
     HitDamage=240
     maxRange=12000
     AccurateRange=7200
     BaseAccuracy=0.800000
     bCanHaveScope=True
     bCanHaveLaser=True
     bCanTrack=True
     LockTime=3.000000
     LockedSound=Sound'DeusExSounds.Weapons.GEPGunLock'
     TrackingSound=Sound'DeusExSounds.Weapons.GEPGunTrack'
     AmmoNames(0)=Class'DeusEx.AmmoRocket'
     AmmoNames(1)=Class'DeusEx.AmmoRocketWP'
     ProjectileNames(0)=Class'DeusEx.Rocket'
     ProjectileNames(1)=Class'DeusEx.RocketWP'
     bHasMuzzleFlash=False
     recoilStrength=1.100000
     bUseWhileCrouched=False
     mpHitDamage=40
     mpAccurateRange=14400
     mpMaxRange=14400
     mpReloadCount=1
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     RecoilShaker=(X=6.000000,Y=2.000000,Z=6.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     negTime=0.365000
     AmmoTag="Rockets"
     addPitch=600
     ClipModAdd=1
     NPCMaxRange=24000
     NPCAccurateRange=14400
     iHDTPModelToggle=1
     bPerShellReload=True
     abridgedName="GEP Gun"
     largeIconRot=Texture'GMDXSFX.Icons.LargeIconRotGEP'
     invSlotsXtravel=3
     invSlotsYtravel=2
     AmmoName=Class'DeusEx.AmmoRocket'
     ReloadCount=1
     PickupAmmoCount=3
     FireOffset=(X=-52.000000,Y=16.000000,Z=6.000000)
     ProjectileClass=Class'DeusEx.Rocket'
     shakemag=600.000000
     FireSound=Sound'DeusExSounds.Weapons.GEPGunFire'
     AltFireSound=Sound'GMDXSFX.Weapons.M4A1MagOut1'
     CockingSound=Sound'DeusExSounds.Weapons.GEPGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.GEPGunSelect'
     Misc1Sound=Sound'DeusExSounds.Special.Switch2ClickOff'
     InventoryGroup=17
     ItemName="Guided Explosive Projectile (GEP) Gun"
     PlayerViewOffset=(X=42.000000,Y=-22.000000,Z=-10.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPGEPgun"
     HDTPPickupViewMesh="HDTPItems.HDTPGEPgunPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPGEPgun3rd"
     PlayerViewMesh=LodMesh'DeusExItems.GEPgun'
     PickupViewMesh=LodMesh'DeusExItems.GEPgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.GEPgun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconGEPGun'
     largeIcon=Texture'GMDXSFX.Icons.GEP'
     largeIconWidth=161
     largeIconHeight=66
     invSlotsX=3
     invSlotsY=2
     Description="The GEP gun is a relatively recent invention in the field of armaments: a portable, shoulder-mounted launcher that can fire rockets and laser guide them to their target with pinpoint accuracy. While suitable for high-threat combat situations, it can be bulky for those agents who have not grown familiar with it."
     beltDescription="GEP GUN"
     CollisionRadius=27.000000
     CollisionHeight=6.600000
     Mass=50.000000
}
