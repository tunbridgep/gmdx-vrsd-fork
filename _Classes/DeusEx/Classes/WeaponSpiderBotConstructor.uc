//=============================================================================
// WeaponNanoVirusGrenade.
//=============================================================================
class WeaponSpiderBotConstructor extends DeusExWeapon;

simulated function renderoverlays(Canvas canvas)
{
    multiskins[0] = handstex;
	multiskins[1] = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPAugUpCanTex0","DeusExItems.Skins.AugUpCanTex0",IsHDTP());

	super.renderoverlays(canvas);

	multiskins[0] = none;
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

	if ((DamageType == 'NanoVirus') || (DamageType == 'HalonGas'))
		return;

    tp= spawn(class'NanoVirusGrenade');
    destroy();
    if (tp != none)
    tp.Explode(Location, vect(0,0,1));
}

defaultproperties
{
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     Concealability=CONC_All
     ShotTime=0.300000
     reloadTime=0.100000
     HitDamage=0
     maxRange=4800
     AccurateRange=2400
     BaseAccuracy=1.000000
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=3.500000
     AIFireDelay=5.000000
     NPCMaxRange=4800
     NPCAccurateRange=2400
     AmmoName=Class'DeusEx.AmmoNanoVirusGrenade'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.SpiderBotConstructorGrenade'
     shakemag=50.000000
     SelectSound=Sound'DeusExSounds.Weapons.NanoVirusGrenadeSelect'
     InventoryGroup=129
     ItemName=""
     PlayerViewOffset=(X=24.000000,Y=-15.000000,Z=-19.000000)
     HDTPPlayerViewMesh"HDTPItems.HDTPNanoVirusGrenade"
     HDTPPickupViewMesh"HDTPItems.HDTPnanovirusgrenadePickup"
     HDTPThirdPersonMesh"HDTPItems.HDTPnanovirusgrenade3rd"
     PlayerViewMesh=LodMesh'DeusExItems.NanoVirusGrenade'
     PickupViewMesh=LodMesh'DeusExItems.nanovirusgrenadePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.nanovirusgrenade3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponNanoVirus'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponNanoVirus'
     largeIconWidth=24
     largeIconHeight=49
     Description="Self-assembles into a spiderbot, allied to the user. Will attack the nearest enemy, delivering electrical damage."
     beltDescription="CONSTRUCTOR"
     Skin=Texture'DeusExItems.Skins.AugUpCanTex0'
     Mesh=LodMesh'DeusExItems.NanoVirusGrenadePickup'
	 HDTPSkin="HDTPItems.Skins.HDTPAugUpCanTex0"
     CollisionRadius=3.000000
     CollisionHeight=2.430000
     Mass=5.000000
     Buoyancy=2.000000
}
