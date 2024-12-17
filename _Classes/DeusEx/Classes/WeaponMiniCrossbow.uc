//=============================================================================
// WeaponMiniCrossbow.
//=============================================================================
class WeaponMiniCrossbow extends DeusExWeapon;

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

//SARGE: This overwrites the one in DeusExWeapon.uc, we need a special one here with a strap
function Texture GetWeaponHandTex()
{
    local Texture tex;
    local DeusExPlayer P;
	
    P = deusexplayer(owner);
	if(P == none)
        return texture'MiniCrossbowTex1';

	if ((P.FlagBase != None) && (P.FlagBase.GetBool('LDDPJCIsFemale')))
    {
        switch(P.PlayerSkin)
        {
            case 0:
                tex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex0Fem", class'Texture', false));
                break;
            case 1:
                tex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex4Fem", class'Texture', false));
                break;
            case 2:
                tex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex5Fem", class'Texture', false));
                break;
            case 3:
                tex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex6Fem", class'Texture', false));
                break;
            case 4:
                tex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex7Fem", class'Texture', false));
                break;
        }
    }
    //For male, return the basic ones
    else if(p != none)
	{
		switch(p.PlayerSkin)
		{
			//default, black, latino, ginger, albino, respectively
			case 0: tex = texture'MiniCrossbowTex1'; break;
			case 1: tex = texture'HDTPItems.skins.crossbowhandstexblack'; break;
			case 2: tex = texture'HDTPItems.skins.crossbowhandstexlatino'; break;
			case 3: tex = texture'HDTPItems.skins.crossbowhandstexginger'; break;
			case 4: tex = texture'HDTPItems.skins.crossbowhandstexalbino'; break;
		}
	}

    if (tex == None)
        tex = texture'weaponhandstex'; //White hands texture by default
                                       
    return tex;
}

simulated function renderoverlays(Canvas canvas)
{
    local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;
	local vector		DrawOffset, WeaponBob;
	local vector unX,unY,unZ;

    if (iHDTPModelToggle == 1)                                                  //RSD: HDTP Model
    {
	if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
	{
	   Multiskins[1] = none;
	   Multiskins[0] = getweaponhandtex();
	}
	else
	{
	   if (bIsRadar)
	   {
          Multiskins[1] = Texture'Effects.Electricity.Xplsn_EMPG';
          Multiskins[0] =  Texture'Effects.Electricity.Xplsn_EMPG';
       }
	   else
	   {
	      Multiskins[1] = FireTexture'GameEffects.InvisibleTex';
	      Multiskins[0] =  FireTexture'GameEffects.InvisibleTex';;
	   }
    }

	if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount > 0) && !bIsCloaked && !bIsRadar) //RSD: Overhauled cloak/radar routines
	{
        /*
	    if (IsInState('Reload'))
	    {
	       if (AnimSequence == 'ReloadEnd')
	       {
	          if(AmmoType.isA('AmmoDartPoison'))
                 Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex2';
		      else if(Ammotype.isA('AmmoDartFlare'))
		       	Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex3';
		      else if(Ammotype.isA('AmmoDartTaser'))
		        Multiskins[2] = texture'HDTPItems.Skins.HDTPAmmoProdTex1';
		      else
		    	Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex1';
	       }
	       else
	        Multiskins[2] = texture'pinkmasktex';
	    }
        */
		if(AmmoType.isA('AmmoDartPoison'))
			Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex2';
		else if(Ammotype.isA('AmmoDartFlare'))
			Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex3';
		else if(Ammotype.isA('AmmoDartTaser'))
		    Multiskins[2] = texture'HDTPItems.Skins.HDTPAmmoProdTex1';
		else
			Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex1';
	}
	else
		Multiskins[2] = texture'pinkmasktex';
	if(bHasScope)
	{
		if (!bIsCloaked && !bIsRadar)                                           //RSD: Overhauled cloak/radar routines
		    multiskins[3] = none;
		else
        {
         if (bIsRadar)
	         Multiskins[3] = Texture'Effects.Electricity.Xplsn_EMPG';
	     else
             Multiskins[3] = FireTexture'GameEffects.InvisibleTex';
        }
	}
	else
		multiskins[3] = texture'pinkmasktex';
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

	super.renderoverlays(canvas); //(weapon)

	multiskins[0] = none;

	if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount > 0))
	{
		if(AmmoType.isA('AmmoDartPoison'))
			Multiskins[1] = texture'HDTPItems.skins.HDTPminicrossbowtex2';
		else if(Ammotype.isA('AmmoDartFlare'))
			Multiskins[1] = texture'HDTPItems.skins.HDTPminicrossbowtex3';
		else
			Multiskins[1] = texture'HDTPItems.skins.HDTPminicrossbowtex1';
	}
	else
		Multiskins[1] = texture'pinkmasktex';
   if(bHasScope)
      multiskins[2] = none;
   else
      multiskins[2] = texture'pinkmasktex';
   if(bHasLaser)
      multiskins[3] = none;
   else
      multiskins[3] = texture'pinkmasktex';
   if(bLasing)
      multiskins[4] = none;
   else
      multiskins[4] = texture'pinkmasktex';
    }
    else                                                                        //RSD: Vanilla Model
    {
        Multiskins[0] = Getweaponhandtex();

        if (!bIsCloaked && !bIsRadar)
        {
            if (MultiSkins[3] != None)                                          //RSD: Copied from vanilla Tick()
			    if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount > 0))
				    MultiSkins[3] = None;
            multiskins[1] = None;                                               //RSD: So we don't get colored stripe textures when switching from HDTP -> vanilla
            multiskins[2] = None;                                               //RSD
        }
		else
		{
		    if (bIsRadar)
		        MultiSkins[3] = Texture'Effects.Electricity.Xplsn_EMPG';
            else
                Multiskins[3] = FireTexture'GameEffects.InvisibleTex';
		}

    	super.renderoverlays(canvas); //(weapon)

    	Multiskins[0] = none;
   	}

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

	super.BecomePickup();
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
	 //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPMiniCrossbow';
          PickupViewMesh=LodMesh'HDTPItems.HDTPminicrossbowPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPminicrossbow3rd';
          addYaw=400;
          addPitch=-1800;
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.MiniCrossbow';
          PickupViewMesh=LodMesh'DeusExItems.MiniCrossbowPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.MiniCrossbow3rd';
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
    if(bHasScope)
      multiskins[2] = none;
   else
      multiskins[2] = texture'pinkmasktex';
   if(bHasLaser)
      multiskins[3] = none;
   else
      multiskins[3] = texture'pinkmasktex';
   if(bLasing)
      multiskins[4] = none;
   else
      multiskins[4] = texture'pinkmasktex';
     }
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Owner != none && Owner.IsA('ScriptedPawn'))
	{
    ScriptedPawn(Owner).MaxRange = 1120;
	ScriptedPawn(Owner).BaseAccuracy = 0.000000;
	}
}

// pinkmask out the arrow when we're out of ammo or the clip is empty
state NormalFire
{
    function BeginState()
	{
	    local int numSkin;                                                      //RSD: Added because vanilla and HDTP mask different skins

		if(playerpawn(owner) != none) //just in case :)
		{
            if (iHDTPModelToggle == 1)                                          //RSD
                numSkin = 2;
            else
                numSkin = 3;

            if (ClipCount == 0)
				MultiSkins[numSkin] = Texture'PinkMaskTex';                     //RSD: changed 2 to numSkin

			if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0))
				MultiSkins[numSkin] = Texture'PinkMaskTex';                     //RSD: changed 2 to numSkin
		}
		else if (iHDTPModelToggle == 1) //fuck me, A)does this get called by NPCs, and B)would anyone even notice? Fuck it: we do insano-detail here //RSD: Only if HDTP
		{
			if (ClipCount == 0)
				MultiSkins[1] = Texture'PinkMaskTex';

			if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0))
				MultiSkins[1] = Texture'PinkMaskTex';
		}
		Super.BeginState();
	}
}

// unpinkmask the arrow when we reload...handled better in renderoverlays? probably yes.
/*
function Tick(float deltaTime)
{
	if(playerpawn(owner) != none)
	{
		if (MultiSkins[2] == texture'pinkmasktex')
			if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount > 0))
			{
				if(AmmoType.isA('AmmoDartPoison'))
					Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex2';
				else if(Ammotype.isA('AmmoDartFlare'))
					Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex3';
				else
					Multiskins[2] = texture'HDTPItems.skins.HDTPminicrossbowtex1';
			}
	}

	Super.Tick(deltaTime);
}
*/

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
     if (AnimSequence == 'Reload')
		{
			ShakeYaw = 0.06 * (Rand(4096) - 2048);
			ShakePitch = 0.06 * (Rand(4096) - 2048);

        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime * ShakeYaw;
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime * ShakePitch;
        }
     if (AnimSequence == 'ReloadBegin')
     {
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*30;
        lerpClamp += 1;
        if (lerpClamp >= 4)
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*380;
        else
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*160;
     }
     else if (AnimSequence == 'ReloadEnd')
     {
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*280;
        DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*30;
     }
     if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
				DeusExPlayer(Owner).ViewRotation.Pitch = 16384;
     //}
    }
    }
}

defaultproperties
{
     weaponOffsets=(X=15.000000,Y=-8.000000,Z=-14.000000)
     MountedViewOffset=(X=12.000000,Y=0.100000,Z=-65.500000)
     LowAmmoWaterMark=3
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     Concealability=CONC_All
     ShotTime=0.465000
     HitDamage=20
     maxRange=2400
     AccurateRange=1200
     BaseAccuracy=0.800000
     bCanHaveScope=True
     ScopeFOV=30
     bCanHaveLaser=True
     bHasSilencer=True
     AmmoNames(0)=Class'DeusEx.AmmoDartPoison'
     AmmoNames(1)=Class'DeusEx.AmmoDart'
     AmmoNames(2)=Class'DeusEx.AmmoDartFlare'
     AmmoNames(3)=Class'DeusEx.AmmoDartTaser'
     ProjectileNames(0)=Class'DeusEx.DartPoison'
     ProjectileNames(1)=Class'DeusEx.Dart'
     ProjectileNames(2)=Class'DeusEx.DartFlare'
     ProjectileNames(3)=Class'DeusEx.DartTaser'
     StunDuration=10.000000
     bHasMuzzleFlash=False
     recoilStrength=0.630000
     mpReloadTime=0.500000
     mpHitDamage=30
     mpBaseAccuracy=0.100000
     mpAccurateRange=2000
     mpMaxRange=2000
     mpReloadCount=6
     mpPickupAmmoCount=6
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     FireSilentSound=Sound'DeusExSounds.Weapons.MiniCrossbowFire'
     RecoilShaker=(X=2.500000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bCanHaveModFullAuto=True
     negTime=0.565000
     AmmoTag="Darts"
     addYaw=400
     addPitch=-1800
     ClipModAdd=1
     NPCMaxRange=3200
     NPCAccurateRange=1600
     iHDTPModelToggle=1
     bPerShellReload=True
     AmmoName=Class'DeusEx.AmmoDartPoison'
     ReloadCount=4
     PickupAmmoCount=4
     FireOffset=(X=-25.000000,Y=8.500000,Z=16.000000)
     ProjectileClass=Class'DeusEx.DartPoison'
     shakemag=200.000000
     FireSound=Sound'DeusExSounds.Weapons.MiniCrossbowFire'
     CockingSound=Sound'DeusExSounds.Weapons.MiniCrossbowReload'
     SelectSound=Sound'DeusExSounds.Weapons.MiniCrossbowSelect'
     Misc1Sound=Sound'DeusExSounds.Special.Switch1Click'
     InventoryGroup=9
     ItemName="Mini-Crossbow"
     PlayerViewOffset=(X=25.000000,Y=-8.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPMiniCrossbow'
     PickupViewMesh=LodMesh'HDTPItems.HDTPminicrossbowPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPminicrossbow3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconCrossbow'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCrossbow'
     largeIconWidth=47
     largeIconHeight=46
     Description="The mini-crossbow was specifically developed for espionage work, and accepts a range of dart types (normal, tranquilizer, or flare) that can be changed depending upon the mission requirements."
     beltDescription="CROSSBOW"
     Mesh=LodMesh'HDTPItems.HDTPminicrossbowPickup'
     CollisionRadius=8.000000
     CollisionHeight=1.000000
     Mass=15.000000
}
