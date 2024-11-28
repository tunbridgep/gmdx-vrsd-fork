//=============================================================================
// WeaponNanoVirusGrenade.
//=============================================================================
class WeaponNanoVirusGrenade extends DeusExWeapon;

var float swingTime;

function DisplayWeapon(bool overlay)
{
	super.DisplayWeapon(overlay);
	if (IsHDTP())
    	multiskins[0] = Getweaponhandtex();
	else
    {
       multiskins[0]=GetWeaponHandTex();                                        //RSD: Fix vanilla hand tex
       multiskins[3]=GetWeaponHandTex();
    }
}

function Fire(float Value)
{
	// if facing a wall, affix the NanoVirusGrenade to the wall
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

simulated function TakeDamage(int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name damageType)
{
	local ThrownProjectile tp;

	if ((DamageType == 'TearGas') || (DamageType == 'PoisonGas') || (DamageType == 'Radiation') || (DamageType == 'EMP'))
		return;

	if ((DamageType == 'NanoVirus') || (DamageType == 'HalonGas') || Owner != None)
		return;

    tp= spawn(class'NanoVirusGrenade');
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
     weaponOffsets=(X=18.000000,Y=-15.000000,Z=-20.000000)
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnemyEffective=ENMEFF_Robot
     Concealability=CONC_All
     ShotTime=0.300000
     reloadTime=0.100000
     HitDamage=0
     maxRange=4800
     AccurateRange=2400
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=3.500000
     AIFireDelay=5.000000
     NPCMaxRange=4800
     NPCAccurateRange=2400
     iHDTPModelToggle=1
     AmmoName=Class'DeusEx.AmmoNanoVirusGrenade'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.NanoVirusGrenade'
     shakemag=50.000000
     SelectSound=Sound'DeusExSounds.Weapons.NanoVirusGrenadeSelect'
     InventoryGroup=23
     ItemName="Scramble Grenade"
     PlayerViewOffset=(X=24.000000,Y=-15.000000,Z=-19.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPNanovirusGrenade"
     HDTPPickupViewMesh="HDTPItems.HDTPNanovirusGrenadePickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPNanovirusGrenade3rd"
     PlayerViewMesh=LodMesh'DeusExItems.NanovirusGrenade'
     PickupViewMesh=LodMesh'DeusExItems.NanovirusGrenadePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.NanovirusGrenade3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponNanoVirus'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponNanoVirus'
     largeIconWidth=24
     largeIconHeight=49
     Description="The detonation of a GUARDIAN scramble grenade broadcasts a short-range, polymorphic broadband assault on the command frequencies used by almost all bots manufactured since 2028. The ensuing electronic storm causes bots within its radius of effect to indiscriminately attack other bots until command control can be re-established. Like a LAM, scramble grenades can be attached to any surface."
     beltDescription="SCRM GREN"
     CollisionRadius=3.000000
     CollisionHeight=2.430000
     Mass=5.000000
     Buoyancy=2.000000
}
