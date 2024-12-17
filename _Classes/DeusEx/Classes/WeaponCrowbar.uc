//=============================================================================
// WeaponCrowbar.
//=============================================================================
class WeaponCrowbar extends DeusExWeapon;

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
	if (IsHDTP())
    {
        multiskins[1] = Getweaponhandtex();
    }
    else
    {
       multiskins[1]=GetWeaponHandTex();                                        //RSD: Fix vanilla hand tex
       multiskins[2]=GetWeaponHandTex();
    }
}

defaultproperties
{
     weaponOffsets=(X=26.000000,Y=-15.000000,Z=-10.000000)
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     ShotTime=0.400000
     reloadTime=0.000000
     HitDamage=8
     maxRange=90
     AccurateRange=90
     BaseAccuracy=1.000000
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     bEmitWeaponDrawn=False
     mpHitDamage=12
     mpBaseAccuracy=1.000000
     mpAccurateRange=96
     mpMaxRange=96
     RecoilShaker=(X=4.000000,Y=0.000000,Z=4.000000)
     msgSpec="+5 damage to doors, crates, and other static objects"
     meleeStaminaDrain=1.000000
     NPCMaxRange=90
     NPCAccurateRange=90
     iHDTPModelToggle=1
     attackSpeedMult=0.800000
     largeIconRot=Texture'GMDXSFX.Icons.HDTPLargeIconRotCrowbar'
     invSlotsXtravel=2
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-40.000000,Y=15.000000,Z=8.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.CrowbarFire'
     SelectSound=Sound'DeusExSounds.Weapons.CrowbarSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.CrowbarHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CrowbarHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CrowbarHitSoft'
     InventoryGroup=10
     ItemName="Crowbar"
     PlayerViewOffset=(X=38.000000,Y=-15.000000,Z=-10.000000)
     HDTPPlayerViewMesh="HDTPItems.HDTPWeaponCrowbar"
     HDTPPickupViewMesh="HDTPItems.HDTPCrowbarPickup"
     HDTPThirdPersonMesh="HDTPItems.HDTPCrowbar3rd"
     PlayerViewMesh=LodMesh'DeusExItems.Crowbar';
     PickupViewMesh=LodMesh'DeusExItems.CrowbarPickup';
     ThirdPersonMesh=LodMesh'DeusExItems.Crowbar3rd';
     LandSound=Sound'DeusExSounds.Weapons.CrowbarHitHard'
     Icon=Texture'DeusExUI.Icons.BeltIconCrowbar'
     largeIcon=Texture'RSDCrap.Icons.LargeIconCrowbar'
     largeIconWidth=101
     largeIconHeight=43
     invSlotsX=2
     Description="A crowbar. Hit someone or something with it. Repeat.|n|n<UNATCO OPS FILE NOTE GH010-BLUE> Many crowbars we call 'murder of crowbars.'  Always have one for kombat. Ha. -- Gunther Hermann <END NOTE>"
     beltDescription="CROWBAR"
     HDTPTexture="HDTPItems.Skins.HDTPWeaponCrowbarTex2"
     CollisionRadius=19.000000
     CollisionHeight=1.050000
     Mass=16.000000
     minSkillRequirement=1;
}
