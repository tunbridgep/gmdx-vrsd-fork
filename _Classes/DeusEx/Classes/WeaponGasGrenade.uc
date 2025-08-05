//=============================================================================
// WeaponGasGrenade.
//=============================================================================
class WeaponGasGrenade extends DeusExWeapon;

var float swingTime;

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
	}
}

function DisplayWeapon(bool overlay)
{
	super.DisplayWeapon(overlay);
	if (overlay)
	{
		if (IsHDTP())
			multiskins[0] = handsTex;
		else
		{
		   multiskins[0]=handsTex;                                        //RSD: Fix vanilla hand tex
		   multiskins[1]=handsTex;
		}
	}
}

function PostBeginPlay()
{
   Super.PostBeginPlay();
   bWeaponStay=False;
}

function Fire(float Value)
{
	// if facing a wall, affix the GasGrenade to the wall
	if (Pawn(Owner) != None)
	{
		if (bNearWall)
		{
			bReadyToFire = False;
			GotoState('NormalFire');
			bPointing = True;
			PlayAnim('Place',, 0.1);
			return;
		}
	}

	// otherwise, throw as usual
	Super.Fire(Value);
}

// Become a pickup
// Weapons that carry their ammo with them don't vanish when dropped
function BecomePickup()
{
	Super.BecomePickup();
   if (Level.NetMode != NM_Standalone)
      if (bTossedOut)
         Lifespan = 0.0;
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return (BeltSpot == 5);
}

simulated function TakeDamage(int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name damageType)
{
	local ThrownProjectile tp;

	if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation') || (DamageType == 'EMP'))
		return;

	if ((DamageType == 'NanoVirus') || (DamageType == 'HalonGas') || Owner != None)
		return;

    tp= spawn(class'GasGrenade');
    destroy();
    if (tp != none)
    tp.Explode(Location, vect(0,0,1));
}

/*state NormalFire
{
 function BeginState()
 {
		swingTime = 0;
		Super.BeginState();
 }
 function Tick(float deltaTime)
 {
  local float augMod;

  super.Tick(deltaTime);

  if (Owner.IsA('DeusExPlayer'))
  {
    if (AnimSequence == 'Attack' || AnimSequence == 'Attack2' || AnimSequence == 'Attack3')
    {
      swingTime+=deltaTime;
      if (swingTime >= 0.7)
         swingTime = 0;
      augMod = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
      if (augMod < 1)
          augMod = 1;
      if (swingTime < 0.5 / augMod)
      {
          DeusExPlayer(Owner).ViewRotation.Pitch += 1+(swingTime*80);
          DeusExPlayer(Owner).ViewRotation.Yaw += 5+(swingTime*40);
      }
      else
      {
          DeusExPlayer(Owner).ViewRotation.Pitch -= 2+(swingTime*80);
          DeusExPlayer(Owner).ViewRotation.Yaw -= 10+(swingTime*40);
      }
    }
  }
  }
}*/

defaultproperties
{
     //weaponOffsets=(X=16.000000,Y=-13.000000,Z=-20.000000)
     weaponOffsets=(X=18.000000,Y=-15.000000,Z=-20.000000) //Sarge: Use EMP grenade offset instead, it looks better
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_All
     ShotTime=0.300000
     reloadTime=0.100000
     HitDamage=0
     maxRange=4800
     AccurateRange=2400
     bPenetrating=False
     StunDuration=60.000000
     bHasMuzzleFlash=False
     bUseAsDrawnWeapon=False
     AITimeLimit=4.000000
     AIFireDelay=20.000000
     bNeedToSetMPPickupAmmo=False
     mpReloadTime=0.100000
     mpHitDamage=2
     mpBaseAccuracy=1.000000
     mpAccurateRange=2400
     mpMaxRange=2400
     NPCMaxRange=4800
     NPCAccurateRange=2400
     iHDTPModelToggle=1
     AmmoName=Class'DeusEx.AmmoGasGrenade'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.GasGrenade'
     shakemag=50.000000
     SelectSound=Sound'DeusExSounds.Weapons.GasGrenadeSelect'
     InventoryGroup=21
     ItemName="Gas Grenade"
     PlayerViewOffset=(Y=-13.000000,Z=-19.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPGasGrenade"
     HDTPPickupViewMesh="HDTPItems.HDTPGasGrenadePickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPGasGrenade3rd"
     Mesh=LodMesh'DeusExItems.GasGrenadePickup'
     PlayerViewMesh=LodMesh'DeusExItems.GasGrenade'
     PickupViewMesh=LodMesh'DeusExItems.GasGrenadePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.GasGrenade3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconGasGrenade'
     largeIcon=Texture'DeusExUI.Icons.LargeIconGasGrenade'
     largeIconWidth=23
     largeIconHeight=46
     Description="Upon detonation, the gas grenade releases a large amount of CS (a military-grade 'tear gas' agent) over its area of effect. CS will cause irritation to all exposed mucous membranes leading to temporary blindness and uncontrolled coughing. Like a LAM, gas grenades can be attached to any surface."
     beltDescription="GAS GREN"
     CollisionRadius=2.300000
     CollisionHeight=3.300000
     Mass=5.000000
     Buoyancy=2.000000
     bDisposableWeapon=true
     minSkillRequirement=1
     bFakeHandToHand=true
}
