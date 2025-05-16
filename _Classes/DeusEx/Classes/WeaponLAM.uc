//=============================================================================
// WeaponLAM.
//=============================================================================
class WeaponLAM extends DeusExWeapon;

var float swingTime;
var localized String shortName;

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
		   multiskins[2]=handsTex;
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
	}
}


function PostBeginPlay()
{
   Super.PostBeginPlay();
   bWeaponStay=False;
}

function Fire(float Value)
{
	// if facing a wall, affix the LAM to the wall
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

simulated function TakeDamage(int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name damageType)
{
	local ThrownProjectile tp;

	if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation') || (DamageType == 'EMP'))
		return;

	if ((DamageType == 'NanoVirus') || (DamageType == 'HalonGas') || Owner != None)
		return;

    tp= spawn(class'LAM');
    destroy();
    if (tp != none)
    tp.Explode(Location, vect(0,0,1));
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return (BeltSpot == 6);
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
     weaponOffsets=(X=18.000000,Y=-15.000000,Z=-19.000000)
     ShortName="LAM"
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnviroEffective=ENVEFF_AirWater
     Concealability=CONC_All
     ShotTime=0.300000
     reloadTime=0.100000
     HitDamage=200
     maxRange=4800
     AccurateRange=2400
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=3.500000
     AIFireDelay=5.000000
     bNeedToSetMPPickupAmmo=False
     mpReloadTime=0.100000
     mpHitDamage=50
     mpBaseAccuracy=1.000000
     mpAccurateRange=2400
     mpMaxRange=2400
     NPCMaxRange=4800
     NPCAccurateRange=2400
     iHDTPModelToggle=1
     abridgedName="LAM"
     AmmoName=Class'DeusEx.AmmoLAM'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.LAM'
     shakemag=50.000000
     SelectSound=Sound'DeusExSounds.Weapons.LAMSelect'
     InventoryGroup=20
     ItemName="Lightweight Attack Munitions (LAM)"
     PlayerViewOffset=(X=24.000000,Y=-15.000000,Z=-17.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPLAM"
     HDTPPickupViewMesh="HDTPItems.HDTPLAMPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPLAM3rd"
     PlayerViewMesh=LodMesh'DeusExItems.LAM'
     PickupViewMesh=LodMesh'DeusExItems.LAMPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.LAM3rd'
     Mesh=LodMesh'DeusExItems.LAMPickup'
     Icon=Texture'DeusExUI.Icons.BeltIconLAM'
     largeIcon=Texture'DeusExUI.Icons.LargeIconLAM'
     largeIconWidth=35
     largeIconHeight=45
     Description="A multi-functional explosive with electronic priming system that can either be thrown or attached to any surface with its polyhesive backing and used as a proximity mine.|n|n<UNATCO OPS FILE NOTE SC093-BLUE> Disarming a proximity device should only be attempted with the proper demolitions training. Trust me on this. -- Sam Carter <END NOTE>"
     beltDescription="LAM"
     CollisionRadius=3.800000
     CollisionHeight=3.500000
     bBlockPlayers=True
     Mass=5.000000
     Buoyancy=2.000000
     bDisposableWeapon=true
}
