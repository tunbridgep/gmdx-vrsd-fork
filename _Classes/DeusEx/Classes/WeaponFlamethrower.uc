//=============================================================================
// WeaponFlamethrower.
//=============================================================================
class WeaponFlamethrower extends DeusExWeapon;

var int BurnTime, BurnDamage;

var int		mpBurnTime;
var int		mpBurnDamage;
var bool usedammo, genusedammo;
var int lerpClamp;

//SARGE: Resize if we have the Mobile Ordnance perk
function bool DoLeftFtob(DeusExPlayer frobber)
{
    local bool re;
    re = super.DoLeftFrob(Frobber);
    ResizeHeavyWeapon(frobber);
    return re;
}

//SARGE: Resize if we have the Mobile Ordnance perk
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    local bool re;
    re = super.DoRightFrob(Frobber,objectInHand);
    ResizeHeavyWeapon(frobber);
    return re;
}

function PostBeginPlay()
{
  super.PostBeginPlay();

  if (!(Owner != none && Owner.IsA('DeusExPlayer')))                            //RSD: accessed none?
    FireOffset=vect(30,9,4);
}

function DisplayWeaponBlood(bool overlay)
{
    super.DisplayWeaponBlood(overlay);
    
    if (!overlay)
        return;

    if (IsHDTP())
        multiskins[2] = Texture'PinkMaskTex';
    else
        multiskins[1] = Texture'PinkMaskTex';
}

function DisplayWeapon(bool overlay)
{
	super.DisplayWeapon(overlay);
	if (overlay)
		multiskins[0] = handsTex;

    if (clipcount == 0 || Pawn(Owner) == None || Pawn(Owner).HeadRegion.Zone.bWaterZone)
    {
        if (IsHDTP())
            multiskins[2] = texture'PinkMaskTex';
        else
            multiskins[1] = texture'PinkMaskTex';
    }
}

exec function UpdateHDTPsettings()
{
     Super.UpdateHDTPsettings();
     if (IsHDTP())
          addPitch=-500;
     else
          addPitch=0;
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

State NormalFire
{
  function BeginState()
  {
     super.BeginState();
     if (FireSound == None)
           FireSound = Sound'DeusExSounds.Weapons.FlamethrowerFire';
  }
}

state DownWeapon
{
	function BeginState()
	{
		Super.BeginState();
		LightType = LT_None;
	}
}

state Idle
{
	function BeginState()
	{
		Super.BeginState();
        if (clipCount > 0 && Owner != None)
            LightType = LT_Steady;
        else
            LightType = LT_None;
	}
}

function DropFrom(vector StartLocation)
{
    super.DropFrom(StartLocation);
    if (Owner == None)
        LightType = LT_None;
}

defaultproperties
{
     weaponOffsets=(X=12.000000,Y=-14.000000,Z=-12.000000)
     burnTime=10
     BurnDamage=10
     mpBurnTime=15
     mpBurnDamage=2
     LowAmmoWaterMark=50
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     NoiseLevel=2.500000
     EnviroEffective=ENVEFF_Air
     bAutomatic=True
     ShotTime=0.100000
     reloadTime=5.500000
     HitDamage=3
     maxRange=320
     AccurateRange=320
     BaseAccuracy=0.800000
     bHasMuzzleFlash=False
     recoilStrength=0.100000
     mpReloadTime=0.500000
     mpHitDamage=5
     mpBaseAccuracy=0.900000
     mpAccurateRange=320
     mpMaxRange=320
     mpReloadCount=100
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     RecoilShaker=(X=0.000000)
     bCanHaveModDamage=True
     negTime=0.000000
     AmmoTag="Napalm Canister"
     addPitch=-500
     ClipModAdd=5
     NPCMaxRange=640
     NPCAccurateRange=640
     iHDTPModelToggle=1
     largeIconRot=Texture'GMDXSFX.Icons.LargeIconRotNapalm'
     invSlotsXtravel=3
     invSlotsYtravel=2
     AmmoName=Class'DeusEx.AmmoNapalm'
     ReloadCount=50
     PickupAmmoCount=50
     FireOffset=(X=60.000000,Y=9.000000,Z=4.000000)
     ProjectileClass=Class'DeusEx.Fireball'
     shakemag=10.000000
     FireSound=Sound'DeusExSounds.Weapons.FlamethrowerFire'
     AltFireSound=Sound'DeusExSounds.Weapons.FlamethrowerReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.FlamethrowerReload'
     SelectSound=Sound'DeusExSounds.Weapons.FlamethrowerSelect'
     InventoryGroup=15
     ItemName="Flamethrower"
     OldPlayerViewOffset=(X=15.000000,Y=-16.000000,Z=-12.000000)
     PlayerViewOffset=(X=15.000000,Y=-16.000000,Z=-12.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPFlamethrower"
     HDTPPickupViewMesh="HDTPItems.HDTPflamethrowerPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPflamethrower3rd"
     Mesh=LodMesh'DeusExItems.FlamethrowerPickup'
     PlayerViewMesh=LodMesh'DeusExItems.Flamethrower'
     PickupViewMesh=LodMesh'DeusExItems.FlamethrowerPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Flamethrower3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconFlamethrower'
     largeIcon=Texture'GMDXSFX.Icons.Napalm'
     largeIconWidth=161
     largeIconHeight=66
     invSlotsX=3
     invSlotsY=2
     Description="A portable flamethrower that discards the old and highly dangerous backpack fuel delivery system in favor of pressurized canisters of napalm. Inexperienced agents will find that a flamethrower can be difficult to maneuver, however."
     beltDescription="FLAMETHWR"
     CollisionRadius=20.500000
     CollisionHeight=4.400000
     Mass=35.000000
     LightType=LT_None
     LightBrightness=48
     LightHue=22
     LightSaturation=96
     LightRadius=10
}
