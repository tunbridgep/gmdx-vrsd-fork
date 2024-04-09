//=============================================================================
// WeaponCombatKnife.
//=============================================================================
class WeaponCombatKnife extends DeusExWeapon;

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
    {
    multiskins[1] = Getweaponhandtex();
    if (!bIsCloaked && !bIsRadar)
       multiskins[2] = none;
    }
    else
       multiskins[1]=GetWeaponHandTex();                                        //RSD: Fix vanilla hand tex

	super.renderoverlays(canvas);

	if (iHDTPModelToggle == 1)
       multiskins[1] = none;
	else
       multiskins[1]=none;                                                      //RSD: Fix vanilla hand tex
}

exec function UpdateHDTPsettings()                                              //RSD: New function to update weapon model meshes (specifics handled in each class)
{
     //RSD: HDTP Toggle Routine
     //if (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).inHand == self)
     //     DeusExPlayer(Owner).BroadcastMessage(iHDTPModelToggle);
     if (iHDTPModelToggle == 1)
     {
          PlayerViewMesh=LodMesh'HDTPItems.HDTPCombatKnife';
          PickupViewMesh=LodMesh'HDTPItems.hdtpcombatknifepickup';
          ThirdPersonMesh=LodMesh'HDTPItems.hdtpcombatknife3rd';
     }
     else
     {
          PlayerViewMesh=LodMesh'DeusExItems.CombatKnife';
          PickupViewMesh=LodMesh'DeusExItems.CombatKnifePickup';
          ThirdPersonMesh=LodMesh'DeusExItems.CombatKnife3rd';
     }
     //RSD: HDTP Toggle End

     Super.UpdateHDTPsettings();
}

/*Function CheckWeaponSkins()
{
}*/

//using a mesh with the original hand textures now, since anims synch better and the hand is barely visible anyway
/*function texture GetWeaponHandTex()
{
	local deusexplayer p;
	local texture tex;

	tex = texture'HDTPCharacters.Skins.HDTPJCHandsTex0';

	p = deusexplayer(owner);
	if(p != none)
	{
		switch(p.PlayerSkin)
		{
			//default, black, latino, ginger, albino, respectively
			case 0: tex = texture'HDTPCharacters.Skins.HDTPJCHandsTex0'; break;
			case 1: tex = texture'HDTPCharacters.Skins.HDTPJCHandsTex1'; break;
			case 2: tex = texture'HDTPCharacters.Skins.HDTPJCHandsTex2'; break;
			case 3: tex = texture'HDTPCharacters.Skins.HDTPJCHandsTex3'; break;
			case 4: tex = texture'HDTPCharacters.Skins.HDTPJCHandsTex4'; break;
		}
	}

	return tex;
}*/

defaultproperties
{
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     Concealability=CONC_Visual
     ShotTime=0.350000
     reloadTime=0.000000
     HitDamage=5
     maxRange=79
     AccurateRange=79
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     mpHitDamage=20
     mpBaseAccuracy=1.000000
     mpAccurateRange=96
     mpMaxRange=96
     RecoilShaker=(X=4.000000,Y=0.000000,Z=4.000000)
     msgSpec="N/A"
     meleeStaminaDrain=0.750000
     NPCMaxRange=79
     NPCAccurateRange=79
     iHDTPModelToggle=1
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-6.000000,Y=8.000000,Z=15.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.CombatKnifeFire'
     SelectSound=Sound'DeusExSounds.Weapons.CombatKnifeSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitSoft'
     InventoryGroup=11
     ItemName="Combat Knife"
     PlayerViewOffset=(X=6.000000,Y=-8.000000,Z=-15.000000)
     PlayerViewMesh=LodMesh'HDTPItems.HDTPCombatKnife'
     PickupViewMesh=LodMesh'HDTPItems.hdtpcombatknifepickup'
     ThirdPersonMesh=LodMesh'HDTPItems.hdtpcombatknife3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconCombatKnife'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCombatKnife'
     largeIconWidth=49
     largeIconHeight=45
     Description="An ultra-high carbon stainless steel knife."
     beltDescription="KNIFE"
     Mesh=LodMesh'HDTPItems.hdtpcombatknifepickup'
     SoundPitch=96
     CollisionRadius=12.650000
     CollisionHeight=0.800000
}
