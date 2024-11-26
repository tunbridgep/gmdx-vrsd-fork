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
     Mesh=LodMesh'DeusExItems.AmmoDart'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
     ItemName="Flare Darts"
     Icon=Texture'GMDXSFX.Icons.BeltIconFlareDart'
     largeIcon=Texture'GMDXSFX.Icons.LargeIconFlareDart'
     Description="Mini-crossbow flare darts use a slow-burning incendiary device, ignited on impact, to provide illumination of a targeted area."
     beltDescription="FLR DART"
     HDTPSkin="GMDXSFX.Skins.FlareAmmo"
     Skin=Texture'DeusExItems.Skins.AmmoDartTex2'
}
