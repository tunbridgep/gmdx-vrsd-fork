//=============================================================================
// WeaponLAW.
//=============================================================================
class WeaponLAW extends DeusExWeapon;

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

simulated function renderoverlays(Canvas canvas)
{
	multiskins[0] = Getweaponhandtex();

	super.renderoverlays(canvas);

	multiskins[0] = none;
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPLAW';
          PickupViewMesh=LodMesh'HDTPItems.HDTPLAWPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPLAW3rd';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.LAW';
          PickupViewMesh=LodMesh'DeusExItems.LAWPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.LAW3rd';
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

// Become a pickup
// Weapons that carry their ammo with them don't vanish when dropped
function BecomePickup()
{
	Super.BecomePickup();
	if (Level.NetMode != NM_Standalone)
		if (bTossedOut)
			Lifespan = 0.0;
}

event Destroyed()
{
   if ((bHasScope)&&(bZoomed)) ScopeToggle();
	Super.Destroyed();
}

defaultproperties
{
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     NoiseLevel=8.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=0.300000
     reloadTime=0.000000
     HitDamage=100
     maxRange=12000
     AccurateRange=7200
     BaseAccuracy=0.600000
     bCanHaveScope=True
     bHasScope=True
     ScopeFOV=30
     bHasMuzzleFlash=False
     recoilStrength=1.000000
     mpHitDamage=100
     mpBaseAccuracy=0.600000
     mpAccurateRange=14400
     mpMaxRange=14400
     RecoilShaker=(X=6.000000,Y=3.000000,Z=4.000000)
     negTime=0.565000
     NPCMaxRange=24000
     NPCAccurateRange=14400
     iHDTPModelToggle=1
     largeIconRot=Texture'GMDXSFX.Icons.LargeIconRotLAW'
     invSlotsXtravel=4
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     FireOffset=(X=26.000000,Y=12.000000,Z=4.000000)
     ProjectileClass=Class'DeusEx.RocketLAW'
     shakemag=500.000000
     FireSound=Sound'DeusExSounds.Weapons.LAWFire'
     SelectSound=Sound'DeusExSounds.Weapons.LAWSelect'
     InventoryGroup=16
     ItemName="Light Anti-Tank Weapon (LAW)"
     PlayerViewOffset=(X=14.000000,Y=-18.000000,Z=-7.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPLaw'
     PickupViewMesh=LodMesh'HDTPItems.HDTPLAWPickup'
     ThirdPersonMesh=LodMesh'HDTPItems.HDTPLAW3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconLAW'
     largeIcon=Texture'DeusExUI.Icons.LargeIconLAW'
     largeIconWidth=166
     largeIconHeight=47
     invSlotsX=4
     Description="The LAW provides cheap, dependable anti-armor capability in the form of an integrated one-shot rocket and delivery system, though at the expense of any laser guidance. Like other heavy weapons, the LAW can slow agents who have not trained with it extensively."
     beltDescription="LAW"
     Mesh=LodMesh'HDTPItems.HDTPLAWPickup'
     CollisionRadius=25.000000
     CollisionHeight=6.800000
     Mass=50.000000
}
