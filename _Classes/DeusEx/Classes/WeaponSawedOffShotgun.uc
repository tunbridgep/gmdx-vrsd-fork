//=============================================================================
// WeaponSawedOffShotgun.
//=============================================================================
class WeaponSawedOffShotgun extends DeusExWeapon;

var int lerpClamp;

function ScopeToggle()
{
    return;       //CyberP: Hey fellow modders. Remove comments and the return call to renable iron sights on the shotgun.
	//if(IsInState('Idle'))
	//{
	//	GoToState('ADSToggle');
	//}
}

state ADSToggle
{
	ignores Fire, AltFire, PutDown, ReloadAmmo, DropFrom; // Whee! We can't do sweet F.A. in this state! :D
	Begin:
		If(bAimingDown)
		{
			PlayAnim('SupressorOn',,0.1);
			if (Owner.IsA('DeusExPlayer'))
                DeusExPlayer(Owner).SetCrosshair(DeusExPlayer(Owner).bWasCrosshair,false); //RSD: true to bWasCrosshair
		}
		else
		{
			PlayAnim('SuperssorOff',,0.1);
			if (Owner.IsA('DeusExPlayer'))
                DeusExPlayer(Owner).SetCrosshair(false,false);
		}
		bAimingDown=!bAimingDown;
		FinishAnim();
		GoToState('Idle');
}

simulated function SawedPump()
{
      SawedOffCockSound();
}

simulated function PlayIdleAnim()
{
	local float rnd;

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
//Function Timer()
//{
//    SawedOffCockSound();
//}

simulated function PlaySelectiveFiring()
{
	local Pawn aPawn;
	local float rnd;
	local Name anim;
	//local int animNum;
	local float mod;
    local float hhspeed;

    if (iHDTPModelToggle != 2)                                                  //RSD: Special routine only for Clyzm model
    {
        Super.PlaySelectiveFiring();
        return;
    }

	if(!bAimingDown)
		anim = 'Shoot';
	else
		anim = 'Shoot2';

	if (( Level.NetMode == NM_Standalone ) || ( DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
	{
           mod = 1.000000 - ModShotTime;

		if (bAutomatic)
		{
		    //if (IsA('WeaponAssaultGun'))
		    //   LoopAnim(anim,1 * (mod*0.5), 0.1);
            //else
		       LoopAnim(anim,1 * mod, 0.1);
		      //PlayAnim(anim,1 * mod, 0.1);
		}
		else
        {
            if (anim == 'Shoot')
                PlayAnim(anim,0.9 * mod,0.1);
            else
			    PlayAnim(anim,1 * mod,0.1);
			//SetTimer(0.4,false);
		}
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
		PickupAmmoCount = 12; //to match assaultshotgun
	}
}

simulated function renderoverlays(Canvas canvas)                                //RSD: Reinstated for HDTP/vanilla models
{
	if (iHDTPModelToggle == 1)
    	multiskins[0] = Getweaponhandtex();
	else if (iHDTPModelToggle == 0)
    {
       multiskins[0]=GetWeaponHandTex();                                        //RSD: Fix vanilla hand tex
       multiskins[3]=GetWeaponHandTex();
    }

	super.renderoverlays(canvas);

	if (iHDTPModelToggle == 1)
    	multiskins[0] = none;
	else if (iHDTPModelToggle == 0)
    {
       multiskins[0]=none;                                                      //RSD: Fix vanilla hand tex
       multiskins[3]=none;
    }
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
    //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 2)
     {
          PlayerViewMesh=LodMesh'FOMOD.sawed1st';
          PickupViewMesh=LodMesh'DeusExItems.ShotgunPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.Shotgun3rd';
     }
     else if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPShotgun';
          PickupViewMesh=LodMesh'HDTPItems.HDTPsawedoff3rd';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPsawedoffpickup';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.Shotgun';
          PickupViewMesh=LodMesh'DeusExItems.ShotgunPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.Shotgun3rd';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

Function CheckWeaponSkins()
{
    //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 2)                                                 //RSD: Clyzm model
     {
    if (owner != None && Owner.IsA('DeusExPlayer'))
    {
       if (DeusExPlayer(Owner).inHand != None && DeusExPlayer(Owner).inHand == self)
           multiskins[1] = GetWeaponHandTex();
       else
           multiskins[1] = None;
    }
    else
       multiskins[1] = None;
     }
}

function texture GetWeaponHandTex()
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

//
// called from the MESH NOTIFY
//
simulated function SwapMuzzleFlashTexture()
{
	local int i;

	if (!bHasMuzzleFlash)
		return;
	if(playerpawn(owner) != none)      //currently diff meshes, see
		i=2;
	else
		i=1;

	MultiSkins[i] = GetMuzzleTex();

	MuzzleFlashLight();
	SetTimer(0.1, False);
}


simulated function EraseMuzzleFlashTexture()
{
	local int i;

	if(playerpawn(owner) != none)      //currently diff meshes, see
		i=2;
	else
		i=1;
	if(bHasMuzzleflash)
		MultiSkins[i] = None;
}

function EraseWeaponHandTex()
{
	multiskins[1] = None;                                                       //RSD: hand tex is slot 1
}

/*function Landed(Vector HitNormal)
{
	local Rotator rot;

	Super.Landed(HitNormal);

	bFixedRotationDir = False;
    rot = Rotation;
    rot.Pitch = 0;
    rot.Roll = 16384;                                                           //RSD
    SetRotation(rot);
}*/

state Reload
{
   function BeginState()
   {
    Super.BeginState();

    lerpClamp = 0;
    if (Owner.IsA('DeusExPlayer') && bAimingDown)
        DeusExPlayer(Owner).SetCrosshair(DeusExPlayer(Owner).bWasCrosshair,false); //RSD: true to bWasCrosshair
    bAimingDown=False;
    BobDamping=default.BobDamping;
   }

   simulated function SawedShell()
   {
     LoadShells();
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
        DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*100;
        DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*240;
        lerpClamp += 1;
        if (lerpClamp >= 5)
        {
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*230;
        }
     }
     else if (AnimSequence == 'ReloadEnd')
     {
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*300;
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*180;
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
            PlayAnim('still2',,0.1);
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

state downWeapon
{
simulated function TweenDown()
{
local DeusExPlayer player;
local float p;

     player = DeusExPlayer(Owner);

     if (player != None)
     p = player.AugmentationSystem.GetAugLevelValue(class'AugCombat');

     if (p < 1.0)
     p = 1.0;

	if ( (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else
	{
		if(!bAimingDown)
		{
				PlayAnim('Down', p, 0.05);
		}
		else
		{
				PlayAnim('Down2', p, 0.05);
		}
	}
	BobDamping=default.BobDamping;
	if (Owner.IsA('DeusExPlayer') && bAimingDown)
         DeusExPlayer(Owner).SetCrosshair(DeusExPlayer(Owner).bWasCrosshair,false); //RSD: true to bWasCrosshair
	bAimingDown=False; // Supresson defaults to off on deselect.
}

}

defaultproperties
{
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=8.000000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=1.300000
     reloadTime=1.200000
     HitDamage=3
     maxRange=3000
     AccurateRange=1500
     BaseAccuracy=0.550000
     AmmoNames(0)=Class'DeusEx.AmmoShell'
     AmmoNames(1)=Class'DeusEx.AmmoSabot'
     AmmoNames(2)=Class'DeusEx.AmmoRubber'
     ProjectileNames(2)=Class'DeusEx.RubberBullet'
     AreaOfEffect=AOE_Cone
     recoilStrength=1.230000
     mpReloadTime=0.500000
     mpHitDamage=9
     mpBaseAccuracy=0.200000
     mpAccurateRange=1200
     mpMaxRange=1200
     mpReloadCount=6
     mpPickupAmmoCount=12
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     RecoilShaker=(X=3.000000,Y=0.000000,Z=2.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     msgSpec="+35% Rubber Bullet Damage"
     bExtraShaker=True
     negTime=0.325000
     AmmoTag="12 Gauge Buckshot Shells"
     ClipModAdd=1
     slugSpreadAcc=0.400000
     NPCMaxRange=4800
     NPCAccurateRange=2400
     bPerShellReload=True
     largeIconRot=Texture'GMDXSFX.Icons.LargeIconRotShotgun'
     invSlotsXtravel=3
     AmmoName=Class'DeusEx.AmmoShell'
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-11.000000,Y=4.000000,Z=13.000000)
     shakemag=600.000000
     FireSound=Sound'GMDXSFX.Weapons.shottie'
     AltFireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReload'
     SelectSound=Sound'GMDXSFX.Weapons.ShotgunCock'
     Misc1Sound=Sound'GMDXSFX.Weapons.weapempty'
     InventoryGroup=6
     ItemName="Sawed-off Shotgun"
     PlayerViewOffset=(X=11.000000,Y=-4.000000,Z=-13.000000)
     PlayerViewMesh=LodMesh'FOMOD.sawed1st'
     PickupViewMesh=LodMesh'DeusExItems.ShotgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Shotgun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconShotgun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconShotgun'
     largeIconWidth=131
     largeIconHeight=45
     invSlotsX=3
     Description="The sawed-off, pump-action shotgun features a truncated barrel resulting in a wide spread at close range and will accept either buckshot, rubber or sabot shells."
     beltDescription="SAWED-OFF"
     Mesh=LodMesh'DeusExItems.ShotgunPickup'
     CollisionRadius=12.000000
     CollisionHeight=0.900000
     Mass=15.000000
}
