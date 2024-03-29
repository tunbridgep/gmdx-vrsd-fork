//=============================================================================
// WeaponEMPGrenade.
//=============================================================================
class WeaponEMPGrenade extends DeusExWeapon;

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

simulated function renderoverlays(Canvas canvas)
{
	if (iHDTPModelToggle == 1)
    	multiskins[0] = Getweaponhandtex();
	else
    {
       multiskins[0]=GetWeaponHandTex();                                        //RSD: Fix vanilla hand tex
       multiskins[3]=GetWeaponHandTex();
    }

	super.renderoverlays(canvas);

	if (iHDTPModelToggle == 1)
    	multiskins[0] = none;
	else
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
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPEMPGrenade';
          PickupViewMesh=LodMesh'HDTPItems.HDTPEMPgrenadePickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPEMPgrenade3rd';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.EMPGrenade';
          PickupViewMesh=LodMesh'DeusExItems.EMPGrenadePickup';
          ThirdPersonMesh=LodMesh'DeusExItems.EMPGrenade3rd';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

/*Function CheckWeaponSkins()
{
}*/

function PostBeginPlay()
{
   Super.PostBeginPlay();
   bWeaponStay=False;
}

function Fire(float Value)
{
	// if facing a wall, affix the EMPGrenade to the wall
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

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Projectile proj;

	proj = Super.ProjectileFire(ProjClass, ProjSpeed, bWarn);

	if (proj != None)
		proj.PlayAnim('Open');
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

    tp= spawn(class'EMPGrenade');
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

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return (BeltSpot == 4);
}

defaultproperties
{
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnemyEffective=ENMEFF_Robot
     Concealability=CONC_Visual
     ShotTime=0.300000
     reloadTime=0.100000
     HitDamage=0
     maxRange=4800
     AccurateRange=2400
     bPenetrating=False
     StunDuration=60.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=3.500000
     AIFireDelay=5.000000
     bNeedToSetMPPickupAmmo=False
     mpReloadTime=0.100000
     mpBaseAccuracy=1.000000
     mpAccurateRange=2400
     mpMaxRange=2400
     NPCMaxRange=4800
     NPCAccurateRange=2400
     iHDTPModelToggle=1
     abridgedName="EMP Grenade"
     AmmoName=Class'DeusEx.AmmoEMPGrenade'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.EMPGrenade'
     shakemag=50.000000
     SelectSound=Sound'DeusExSounds.Weapons.EMPGrenadeSelect'
     InventoryGroup=22
     ItemName="Electromagnetic Pulse (EMP) Grenade"
     ItemArticle="an"
     PlayerViewOffset=(X=24.000000,Y=-15.000000,Z=-19.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPEMPGrenade'
     PickupViewMesh=LodMesh'HDTPItems.HDTPEMPgrenadePickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPEMPgrenade3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconEMPGrenade'
     largeIcon=Texture'DeusExUI.Icons.LargeIconEMPGrenade'
     largeIconWidth=31
     largeIconHeight=49
     Description="The EMP grenade creates a localized pulse that will temporarily disable all electronics within its area of effect, including cameras and security grids.|n|n<UNATCO OPS FILE NOTE JR134-VIOLET> While nanotech augmentations are largely unaffected by EMP, experiments have shown that it WILL cause the spontaneous dissipation of stored bioelectric energy. -- Jaime Reyes <END NOTE>"
     beltDescription="EMP GREN"
     Mesh=LodMesh'HDTPItems.HDTPEMPgrenadePickup'
     CollisionRadius=3.000000
     CollisionHeight=2.430000
     Mass=5.000000
     Buoyancy=2.000000
}
