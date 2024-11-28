//=============================================================================
// WeaponProd.
//=============================================================================
class WeaponProd extends DeusExWeapon;

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
        {
            multiskins[0] = Getweaponhandtex();
        }
        else
        {
            //RSD: Need this for some unfathomable reason so the cloak/radar textures animate on the vanilla version. Who fucking knows
            if (bIsCloaked || bIsRadar)
            {
                multiskins[0] = texture'PinkMaskTex';
                multiskins[3] = texture'PinkMaskTex';
            }
            else
            {
                multiskins[0] = Getweaponhandtex();
                multiskins[3] = Getweaponhandtex();
            }
        }
    }
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
     //if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
     //{
     if (AnimSequence == 'ReloadBegin')
     {
        DeusExPlayer(Owner).ViewRotation.Yaw += deltaTime*30;
        lerpClamp += 1;
        if (lerpClamp >= 4)
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*180;
        else
           DeusExPlayer(Owner).ViewRotation.Pitch -= deltaTime*380;
     }
     else if (AnimSequence == 'ReloadEnd')
     {
        DeusExPlayer(Owner).ViewRotation.Pitch += deltaTime*280;
        DeusExPlayer(Owner).ViewRotation.Yaw -= deltaTime*30;
     }
     if ((DeusExPlayer(Owner).ViewRotation.Pitch > 16384) && (DeusExPlayer(Owner).ViewRotation.Pitch < 32768))
				DeusExPlayer(Owner).ViewRotation.Pitch = 16384;
     //}
    }
    }
}

defaultproperties
{
     weaponOffsets=(X=11.000000,Y=-12.000000,Z=-19.000000)
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=1.000000
     reloadTime=3.000000
     HitDamage=16
     maxRange=150
     AccurateRange=150
     bPenetrating=False
     StunDuration=10.000000
     bHasMuzzleFlash=False
     mpReloadTime=3.000000
     mpHitDamage=15
     mpBaseAccuracy=0.500000
     mpAccurateRange=80
     mpMaxRange=80
     mpReloadCount=4
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     RecoilShaker=(Y=1.000000)
     bCanHaveModShotTime=True
     bCanHaveModDamage=True
     AmmoTag="Prod Charger"
     ClipModAdd=1
     NPCMaxRange=120
     NPCAccurateRange=120
     AmmoName=Class'DeusEx.AmmoBattery'
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-21.000000,Y=12.000000,Z=19.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.ProdFire'
     AltFireSound=Sound'DeusExSounds.Weapons.ProdReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.ProdReload'
     SelectSound=Sound'DeusExSounds.Weapons.ProdSelect'
     InventoryGroup=19
     ItemName="Riot Prod"
     PlayerViewOffset=(X=21.000000,Y=-12.000000,Z=-19.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Prod'
     PickupViewMesh=LodMesh'DeusExItems.ProdPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Prod3rd'
     HDTPPlayerViewMesh="HDTPItems.HDTPProd"
     HDTPPickupViewMesh="HDTPItems.HDTPProdPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPProd3rd"
     Icon=Texture'DeusExUI.Icons.BeltIconProd'
     largeIcon=Texture'DeusExUI.Icons.LargeIconProd'
     largeIconWidth=49
     largeIconHeight=48
     Description="The riot prod has been extensively used by security forces who wish to keep what remains of the crumbling peace and have found the prod to be an valuable tool. Its short range tetanizing effect is most effective when applied to the torso or when the subject is taken by surprise."
     beltDescription="PROD"
     CollisionRadius=8.750000
     CollisionHeight=1.350000
}
