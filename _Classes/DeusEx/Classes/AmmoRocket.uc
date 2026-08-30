//=============================================================================
// AmmoRocket.
//=============================================================================
class AmmoRocket extends DeusExAmmo;

enum EPickupStyle
{
	E_Normal,
    E_Single,
};

var(GMDX) EPickupStyle style;

//Less ammo on Hardcore
function SetupDifficultyMod(DeusExPlayer P)
{
    super.SetupDifficultyMod(P);
    if (P.bHardCoreMode)
        AmmoAmount = 2;
}

//SARGE: Allow single style
exec function UpdateHDTPSettings()
{
    Super.UpdateHDTPSettings();
    if (style == E_Single)
    {
        ItemArticle=class'Rocket'.default.ItemArticle;
        FamiliarName=class'Rocket'.default.ItemName;
        UnfamiliarName=class'Rocket'.default.ItemName;
        AmmoAmount=1;
        ItemName=class'Rocket'.default.ItemName;
        SetCollisionSize(8.000000, 2.0000000);
        PickupViewMesh=LodMesh'DeusExItems.Rocket';
        PlayerViewMesh=LodMesh'DeusExItems.Rocket';
        ThirdPersonMesh=LodMesh'DeusExItems.Rocket';
        Mesh=LodMesh'DeusExItems.Rocket';
        DrawScale=0.250000;
        Mass=34.000000;
        Buoyancy=10.000000;
    }
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponHeavy'
     AmmoAmount=4
     MaxAmmo=4
     ItemName="HE Rockets"
     ItemArticle="some"
     LandSound=Sound'DeusExSounds.Generic.WoodHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoRockets'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoRockets'
     largeIconWidth=46
     largeIconHeight=36
     Description="A gyroscopically stabilized rocket with limited onboard guidance systems for in-flight course corrections. Engineered for use with the GEP gun."
     beltDescription="HE ROCKET"
     HDTPMesh="HDTPItems.HDTPgepammo"
     PickupViewMesh=LodMesh'DeusExItems.GEPAmmo'
     PlayerViewMesh=LodMesh'DeusExItems.GEPAmmo'
     ThirdPersonMesh=LodMesh'DeusExItems.GEPAmmo'
     Mesh=LodMesh'DeusExItems.GEPAmmo'
     CollisionRadius=18.000000
     CollisionHeight=7.800000
     bCollideActors=True
     //bHarderScaling=True
}
