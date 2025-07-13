//=============================================================================
// AmmoDartFlare.
//=============================================================================
class AmmoDartFlare extends DeusExAmmo;

defaultproperties
{
     bShowInfo=True
     altDamage=7
     AmmoAmount=1
     ammoSkill=Class'DeusEx.SkillWeaponPistol'
     MaxAmmo=30
     ItemArticle="some"
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     largeIconWidth=20
     largeIconHeight=47
     PlayerViewMesh=LodMesh'DeusExItems.AmmoDart'
     PickupViewMesh=LodMesh'DeusExItems.AmmoDart'
     ThirdPersonMesh=LodMesh'DeusExItems.AmmoDart'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
     ItemName="Flare Darts"
     HDTPIcon="GMDXSFX.Icons.BeltIconFlareDart"
     HDTPLargeIcon="GMDXSFX.Icons.LargeIconFlareDart"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoDartsFlare'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoDartsFlare'
     Description="Mini-crossbow flare darts use a slow-burning incendiary device, ignited on impact, to provide illumination of a targeted area."
     beltDescription="FLR DART"
     HDTPSkin="GMDXSFX.Skins.FlareAmmo"
     //HDTPSkin="HDTPItems.Skins.HDTPAmmoDartTex2"
     Skin=Texture'DeusExItems.Skins.AmmoDartTex2'
     Mesh=LodMesh'DeusExItems.AmmoDart'
     ammoHUDColor=(R=255,G=64)
}
