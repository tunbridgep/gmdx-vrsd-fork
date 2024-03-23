//=============================================================================
// WeaponBaton.
//=============================================================================
class WeaponBaton extends DeusExWeapon;

simulated function renderoverlays(Canvas canvas)
{
	if (iHDTPModelToggle == 1)
    {
    multiskins[2] = Getweaponhandtex();
    if (!bIsCloaked && !bIsRadar)                                               //RSD: Overhauled cloak/radar routines
       multiskins[1] = none;
    }
    else
    {
       multiskins[1]=GetWeaponHandTex();                                        //RSD: Fix vanilla hand tex
       multiskins[2]=GetWeaponHandTex();
    }
	super.renderoverlays(canvas);

	if (iHDTPModelToggle == 1)
       multiskins[2] = none;
    else
    {
       multiskins[1]=none;                                                      //RSD: Fix vanilla hand tex
       multiskins[2]=none;
    }
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPWeaponBaton';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.Baton';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

/*Function CheckWeaponSkins()
{
}*/

function name WeaponDamageType()
{
	return 'KnockedOut';
}

defaultproperties
{
    //bIsMeleeWeapon = true //SARGE: Not really a good melee weapon for breaking crates with.
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     reloadTime=0.000000
     HitDamage=7
     maxRange=90
     AccurateRange=90
     BaseAccuracy=1.000000
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     bEmitWeaponDrawn=False
     RecoilShaker=(X=4.000000,Y=0.000000,Z=4.000000)
     msgSpec="Silent Attack"
     meleeStaminaDrain=1.000000
     NPCMaxRange=90
     NPCAccurateRange=90
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-24.000000,Y=14.000000,Z=17.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.BatonFire'
     SelectSound=Sound'DeusExSounds.Weapons.BatonSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.BatonHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.BatonHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.BatonHitSoft'
     InventoryGroup=24
     ItemName="Baton"
     PlayerViewOffset=(X=24.000000,Y=-14.000000,Z=-17.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Baton'
     PickupViewMesh=LodMesh'DeusExItems.BatonPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Baton3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconBaton'
     largeIcon=Texture'DeusExUI.Icons.LargeIconBaton'
     largeIconWidth=46
     largeIconHeight=47
     Description="A hefty looking baton, typically used by riot police and national security forces to discourage civilian resistance."
     beltDescription="BATON"
     Mesh=LodMesh'DeusExItems.BatonPickup'
     CollisionRadius=14.000000
     CollisionHeight=1.000000
}
