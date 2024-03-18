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

/*simulated function renderoverlays(Canvas canvas)
{
	multiskins[0] = Getweaponhandtex();
    if (!bIsCloaked)
       multiskins[1] = none;

	super.renderoverlays(canvas);

	multiskins[0] = none;
}*/

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPProd';
          PickupViewMesh=LodMesh'HDTPItems.HDTPProdPickup';
          ThirdPersonMesh=LodMesh'HDTPItems.HDTPProd3rd';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.Prod';
          PickupViewMesh=LodMesh'DeusExItems.ProdPickup';
          ThirdPersonMesh=LodMesh'DeusExItems.Prod3rd';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

Function CheckWeaponSkins()
{
     if (iHDTPModelToggle != 1)
     {
          multiskins[0]=none;                                                   //RSD: Needed so 3rd person mesh isn't covered with hand tex dropped with cloak/radar active
     }
}

function texture GetWeaponHandTex()                                             //RSD: overwritten from DeusExWeapon.uc, see below
{
	local deusexplayer p;
	local texture tex;

    if (iHDTPModelToggle == 0 && (bIsCloaked || bIsRadar))                      //RSD: Need this for some unfathomable reason so the cloak/radar textures animate on the vanilla version. Who fucking knows
        return Texture'PinkMaskTex';//FireTexture'GameEffects.CamoEffect';
    else return Super.GetWeaponHandTex();
}

simulated function renderoverlays(Canvas canvas)                                //RSD: Attempt to fix cloak/radar skins for vanilla prod
{
    if (iHDTPModelToggle == 1)
        multiskins[0] = Getweaponhandtex();
    else                                                                        //RSD: Vanilla model needs special help for animated cloak/radar
    {
    multiskins[0] = Getweaponhandtex();
    multiskins[3] = Getweaponhandtex();
    if (!bIsCloaked && !bIsRadar)
    {
       multiskins[1] = none;
       multiskins[2] = none;
       //multiskins[3] = none;
       multiskins[4] = none;
    }
    else
    {
	   if (bIsRadar)
	   {
          Multiskins[1] = Texture'Effects.Electricity.WEPN_EMPG_SFX';//none;
          Multiskins[2] = none;
          Multiskins[3] = Texture'Effects.Electricity.Xplsn_EMPG';
          Multiskins[4] = Texture'Effects.Electricity.Xplsn_EMPG';
	   }
	   else
	   {
	      Multiskins[1] = Texture'Effects.Electricity.WEPN_EMPG_SFX';//Texture'pinkmasktex';
          Multiskins[2] = none;
          Multiskins[3] = FireTexture'GameEffects.InvisibleTex';
          Multiskins[4] = FireTexture'GameEffects.InvisibleTex';
       }
    }
    }
	super.renderoverlays(canvas);

	if (iHDTPModelToggle == 1)
        multiskins[0] = none;
    else
    {
    multiskins[0] = none;
    multiskins[3] = none;
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
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=1.000000
     reloadTime=3.000000
     HitDamage=16
     maxRange=120
     AccurateRange=120
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
     Icon=Texture'DeusExUI.Icons.BeltIconProd'
     largeIcon=Texture'DeusExUI.Icons.LargeIconProd'
     largeIconWidth=49
     largeIconHeight=48
     Description="The riot prod has been extensively used by security forces who wish to keep what remains of the crumbling peace and have found the prod to be an valuable tool. Its short range tetanizing effect is most effective when applied to the torso or when the subject is taken by surprise."
     beltDescription="PROD"
     CollisionRadius=8.750000
     CollisionHeight=1.350000
}
