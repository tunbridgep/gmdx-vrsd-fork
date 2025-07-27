//=============================================================================
// AmmoRocketWP.
//=============================================================================
class AmmoRocketWP extends DeusExAmmo;

function UpdateHDTPSettings()
{
    super.UpdateHDTPSettings();
    if (IsHDTP())
        MultiSkins[1]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPgepammotex2");
    else
        MultiSkins[1]=None;
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponHeavy'
     LandSound=Sound'DeusExSounds.Generic.WoodHit2'
     altDamage=50
     AmmoAmount=6
     MaxAmmo=12
     ItemArticle="some"
     ItemName="WP Rockets"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoWPRockets'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoWPRockets'
     largeIconWidth=45
     largeIconHeight=37
     Description="The white-phosphorus rocket, or 'wooly peter,' was designed to expand the mission profile of the GEP gun. While it does minimal damage upon detonation, the explosion will spread a cloud of particularized white phosphorus that ignites immediately upon contact with the air."
     beltDescription="WP ROCKET"
     Skin=Texture'DeusExItems.Skins.GEPAmmoTex2'
     HDTPSkin="HDTPItems.Skins.HDTPgepammotex2"
     PickupViewMesh=LodMesh'DeusExItems.GEPAmmo'
     PlayerViewMesh=LodMesh'DeusExItems.GEPAmmo'
     ThirdPersonMesh=LodMesh'DeusExItems.GEPAmmo'
     Mesh=LodMesh'DeusExItems.GEPAmmo'
     CollisionRadius=18.000000
     CollisionHeight=7.800000
     bCollideActors=True
     //bHarderScaling=True
     ammoHUDColor=(R=255,G=64)
}
