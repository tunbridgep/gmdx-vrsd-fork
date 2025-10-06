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

//SARGE: This overwrites the one in DeusExWeapon.uc, we need a special one here with a strap
function SetWeaponHandTex()
{
    local DeusExPlayer P;
	
    P = deusexplayer(owner);
	if(P != none)
    {
        if (P.FemaleEnabled() && (P.bFemaleHandsAlways || (P.FlagBase != None && P.FlagBase.GetBool('LDDPJCIsFemale'))))
        {
            switch(P.PlayerSkin)
            {
                case 0:
                    handsTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex0Fem", class'Texture', false));
                    break;
                case 1:
                    handsTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex4Fem", class'Texture', false));
                    break;
                case 2:
                    handsTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex5Fem", class'Texture', false));
                    break;
                case 3:
                    handsTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex6Fem", class'Texture', false));
                    break;
                case 4:
                    handsTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex7Fem", class'Texture', false));
                    break;
            }
        }
        //For male, return the basic ones
        else
        {
            switch(p.PlayerSkin)
            {
                //default, black, latino, ginger, albino, respectively
                case 0: handsTex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.crossbowhandstex0A"); break;
                case 1: handsTex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.crossbowhandstex1A"); break;
                case 2: handsTex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.crossbowhandstex2A"); break;
                case 3: handsTex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.crossbowhandstex3A"); break;
                case 4: handsTex = class'HDTPLoader'.static.GetTexture("RSDCrap.skins.crossbowhandstex4A"); break;
            }
        }
    }

    if (handsTex == None) //Final backup
        handsTex = texture'minicrossbowtex1';
    //p.ClientMessage("Skin Tex: " $ handsTex);
}


function DisplayWeapon(bool overlay)
{
    local Texture ammotex;
	super.DisplayWeapon(overlay);
    
    //Display Ammo Type
    if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount > 0) && !bIsCloaked && !bIsRadar) //RSD: Overhauled cloak/radar routines
    {
        if(AmmoType.isA('AmmoDartPoison'))
            ammotex = class'HDTPLoader'.static.GetTexture2("HDTPItems.skins.HDTPminicrossbowtex2","RSDCrap.Skins.MiniCrossbowTex2Dart2",IsHDTP());
        else if(Ammotype.isA('AmmoDartFlare'))
            ammotex = class'HDTPLoader'.static.GetTexture2("HDTPItems.skins.HDTPminicrossbowtex3","RSDCrap.Skins.MiniCrossbowTex2Dart1",IsHDTP());
        else if(Ammotype.isA('AmmoDartTaser'))
            ammotex = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPAmmoProdTex1","RSDCrap.Skins.MiniCrossbowTex2Dart3",IsHDTP());
        else //regular darts
            ammotex = class'HDTPLoader'.static.GetTexture2("HDTPItems.skins.HDTPminicrossbowtex1","RSDCrap.Skins.MiniCrossbowTex2Dart0",IsHDTP());
    }
    else
        ammotex = texture'pinkmasktex';

    if (IsHDTP())
    {
        
        //Show weapon addons
        if (overlay)
        {
            Multiskins[0] = handsTex;
            ShowWeaponAddon(3,bHasScope);
            ShowWeaponAddon(4,bHasLaser);
            ShowWeaponAddon(5,bLasing);
            //Show Weapon Ammo
            Multiskins[2] = ammoTex;
        }
        else
        {
            ShowWeaponAddon(2,bHasScope);
            ShowWeaponAddon(3,bHasLaser);
            ShowWeaponAddon(4,bLasing);
        }

    }
    else if (overlay)
    {
        //Show Darts
        MultiSkins[3] = ammoTex;
        Multiskins[0] = handsTex;
        
        if (bVanillaModelAttachments)
        {
            ShowWeaponAddon(4,bHasLaser);
            ShowWeaponAddon(5,bHasLaser && bLasing);
            ShowWeaponAddon(6,bHasScope);
        }
    }
    else if (bVanillaModelAttachments)
    {
        ShowWeaponAddon(2,bHasLaser);
        ShowWeaponAddon(3,bHasLaser);
        ShowWeaponAddon(4,bHasLaser && bLasing);
        ShowWeaponAddon(5,bHasScope);
    }
}

exec function UpdateHDTPsettings()
{
     if (IsHDTP())
     {
          addYaw=400;
          addPitch=-1800;
     }
     else
     {
          addYaw=0;
          addPitch=0;
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
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
            if (IsHDTP())                                          //RSD
                numSkin = 2;
            else
                numSkin = 3;

            if (ClipCount == 0)
				MultiSkins[numSkin] = Texture'PinkMaskTex';                     //RSD: changed 2 to numSkin

			if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0))
				MultiSkins[numSkin] = Texture'PinkMaskTex';                     //RSD: changed 2 to numSkin
		}
		else if (IsHDTP()) //fuck me, A)does this get called by NPCs, and B)would anyone even notice? Fuck it: we do insano-detail here //RSD: Only if HDTP
		{
			if (ClipCount == 0)
				MultiSkins[1] = Texture'PinkMaskTex';

			if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0))
				MultiSkins[1] = Texture'PinkMaskTex';
		}
		Super.BeginState();
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
     HDTPPlayerViewMesh="HDTPItems.HDTPMiniCrossbow"
     HDTPPickupViewMesh="HDTPItems.HDTPminicrossbowPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPminicrossbow3rd"
     VanillaAddonPlayerViewMesh="VisibleAttachments.MiniCrossbow_Mod"
     VanillaAddonPickupViewMesh="VisibleAttachments.MiniCrossbowPickup_Mod"
     VanillaAddonThirdPersonMesh="VisibleAttachments.MiniCrossbow3rd_Mod"
     PlayerViewMesh=LodMesh'DeusExItems.MiniCrossbow'
     PickupViewMesh=LodMesh'DeusExItems.MiniCrossbowPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.MiniCrossbow3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconCrossbow'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCrossbow'
     largeIconWidth=47
     largeIconHeight=46
     Description="The mini-crossbow was specifically developed for espionage work, and accepts a range of dart types (normal, tranquilizer, or flare) that can be changed depending upon the mission requirements."
     beltDescription="CROSSBOW"
     CollisionRadius=8.000000
     CollisionHeight=1.000000
     Mass=15.000000
     bFancyScopeAnimation=true
}
