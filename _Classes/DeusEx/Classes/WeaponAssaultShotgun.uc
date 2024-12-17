//=============================================================================
// WeaponAssaultShotgun.
//=============================================================================
class WeaponAssaultShotgun extends DeusExWeapon;

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

function DisplayWeapon(bool overlay)
{
	super.DisplayWeapon(overlay);
    if (overlay)
    {
        if (IsHDTP())
            multiskins[0] = Getweaponhandtex();
        else
            multiskins[1] = GetWeaponHandTex();
    }
}

exec function UpdateHDTPsettings()
{
     if (IsHDTP())
          addPitch=-500;
     else
          addPitch=0;

     Super.UpdateHDTPsettings();
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
        if (lerpClamp > 0)
        {
          lerpClamp = 0;
          DeusExPlayer(Owner).RecoilShaker(vect(0,1,1));
        }
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*300;
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*180;
     }
     //}
    }
    }
}

defaultproperties
{
     weaponOffsets=(X=23.000000,Y=-10.000000,Z=-16.500000)
     LowAmmoWaterMark=12
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=10.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=0.400000
     reloadTime=1.200000
     HitDamage=3
     maxRange=2000
     AccurateRange=1000
     BaseAccuracy=0.700000
     AmmoNames(0)=Class'DeusEx.AmmoShell'
     AmmoNames(1)=Class'DeusEx.AmmoSabot'
     AmmoNames(2)=Class'DeusEx.AmmoRubber'
     ProjectileNames(2)=Class'DeusEx.RubberBullet'
     AreaOfEffect=AOE_Cone
     recoilStrength=1.160000
     mpReloadTime=0.500000
     mpHitDamage=5
     mpBaseAccuracy=0.200000
     mpAccurateRange=1800
     mpMaxRange=1800
     mpReloadCount=12
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     RecoilShaker=(X=3.000000,Y=0.000000,Z=2.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     bCanHaveModFullAuto=True
     bExtraShaker=True
     negTime=0.365000
     AmmoTag="12 Gauge Buckshot Shells"
     addPitch=-500
     ClipModAdd=1
     slugSpreadAcc=0.400000
     NPCMaxRange=2800
     NPCAccurateRange=1400
     iHDTPModelToggle=1
     bPerShellReload=True
     invSlotsXtravel=2
     invSlotsYtravel=2
     AmmoName=Class'DeusEx.AmmoShell'
     ReloadCount=12
     PickupAmmoCount=6
     bInstantHit=True
     FireOffset=(X=-30.000000,Y=10.000000,Z=12.000000)
     shakemag=640.000000
     FireSound=Sound'GMDXSFX.Weapons.JackhammerFire'
     AltFireSound=Sound'GMDXSFX.Weapons.M79ReloadEnd'
     CockingSound=Sound'GMDXSFX.Weapons.JackhammerReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultShotgunSelect'
     Misc1Sound=Sound'GMDXSFX.Weapons.weapempty'
     InventoryGroup=7
     ItemName="Assault Shotgun"
     ItemArticle="an"
     PlayerViewOffset=(Y=-11.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.AssaultShotgun'
     PickupViewMesh=LodMesh'DeusExItems.AssaultShotgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.AssaultShotgun3rd'
     HDTPPlayerViewMesh="HDTPItems.HDTPAssaultShotgun"
     HDTPPickupViewMesh="HDTPItems.HDTPAssaultShotgunPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPAssaultShotgun3rd"
     BobDamping=0.750000
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconAssaultShotgun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAssaultShotgun'
     largeIconWidth=99
     largeIconHeight=55
     invSlotsX=2
     invSlotsY=2
     Description="The Striker 2 (sometimes referred to as a 'street sweeper 2') combines the best traits of The original model of Striker with a rapid-loading feed that can clear an area of hostiles in a matter of seconds. Particularly effective in urban combat, the assault shotgun accepts either buckshot or sabot shells."
     beltDescription="STRIKER"
     Mesh=LodMesh'DeusExItems.AssaultShotgunPickup'
     CollisionRadius=15.000000
     CollisionHeight=8.000000
     Mass=30.000000
     bBigMuzzleFlash=true
     minSkillRequirement=1;
}
