//=============================================================================
// WeaponSawedOffShotgun.
//=============================================================================
class WeaponSawedOffShotgun extends DeusExWeapon;

var int lerpClamp;

simulated function SawedPump()
{
      SawedOffCockSound();
}

simulated function PlayIdleAnim()
{
	local float rnd;

	if (bZoomed || bNearWall || !IsHDTP() || iHDTPModelToggle < 2)
		return;

	rnd = FRand();
    if (rnd < 0.03)
        PlayAnim('Idle',,0.2);
}

simulated function PlaySelectiveFiring()
{
	local Pawn aPawn;
	local float rnd;
	local Name anim;
	//local int animNum;
	local float mod;
    local float hhspeed;

    if (IsHDTP() && iHDTPModelToggle != 2)                                                  //RSD: Special routine only for Clyzm model
    {
        Super.PlaySelectiveFiring();
        return;
    }

    anim = 'Shoot';

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

function DisplayWeapon(bool overlay)
{
    super.DisplayWeapon(overlay);
    if (IsHDTP() && iHDTPModelToggle == 2 && overlay) //RSD: Clyzm Model
    {
        multiskins[1] = handstex;
    }
    /*
    else if (IsHDTP() && iHDTPModelToggle == 1 && overlay) //HDTP Model
    {
        multiskins[0] = handstex;
    }
    */
    else if (overlay)
    {
        multiskins[0] = handstex;
    }
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
    if (IsHDTP())
    {
        if (iHDTPModelToggle == 2)
        {
            HDTPPlayerViewMesh="FOMOD.sawed1st";
        }
        else if (iHDTPModelToggle == 1)
            HDTPPlayerViewMesh="HDTPItems.HDTPShotgun";
    }
    Super.UpdateHDTPsettings();
}

//
// called from the MESH NOTIFY
//
simulated function SwapMuzzleFlashTexture()
{
    //if(playerpawn(owner) != none)      //diff meshes, see
		MuzzleSlot=2;
	//else
	//	MuzzleSlot=4;
    
    super.SwapMuzzleFlashTexture();
}


state Reload
{
   function BeginState()
   {
    Super.BeginState();

    lerpClamp = 0;
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
		if (!bNearWall && !activateAn)
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
		if (!bNearWall && !activateAn)
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
            PlayAnim('Down', p, 0.05);
	}
	BobDamping=default.BobDamping;
}

}

defaultproperties
{
     weaponOffsets=(X=4.000000,Y=-4.000000,Z=-15.000000)
     //weaponOffsets=(X=9.000000,Y=-4.000000,Z=-15.000000)
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=8.000000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=1.200000
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
     ClassicFireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunFire'
     AltFireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReload'
     SelectSound=Sound'GMDXSFX.Weapons.ShotgunCock'
     Misc1Sound=Sound'GMDXSFX.Weapons.weapempty'
     InventoryGroup=6
     ItemName="Sawed-off Shotgun"
     PlayerViewOffset=(X=11.000000,Y=-4.000000,Z=-13.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Shotgun'
     PickupViewMesh=LodMesh'DeusExItems.ShotgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Shotgun3rd'
     HDTPPlayerViewMesh="HDTPItems.HDTPShotgun"
     //SARGE: Use the vanilla models, so things aren't misaligned
     //HDTPPickupViewMesh="HDTPItems.HDTPsawedoff3rd"
     //HDTPThirdPersonMesh="HDTPItems.HDTPsawedoffpickup"
     HDTPPickupViewMesh="DeusExItems.ShotgunPickup"
     HDTPThirdPersonMesh="DeusExItems.Shotgun3rd"
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
