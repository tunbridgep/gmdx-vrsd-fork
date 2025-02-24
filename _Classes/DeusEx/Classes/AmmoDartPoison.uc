//=============================================================================
// AmmoDartPoison.
//=============================================================================
class AmmoDartPoison extends DeusExAmmo;

defaultproperties
{
     bShowInfo=True
     altDamage=13
     ammoSkill=Class'DeusEx.SkillWeaponPistol'
     AmmoAmount=3
     MaxAmmo=30
     ItemArticle="some"
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     largeIconWidth=20
     largeIconHeight=47
     PlayerViewMesh=LodMesh'DeusExItems.AmmoDart'
     PickupViewMesh=LodMesh'DeusExItems.AmmoDart'
     ThirdPersonMesh=LodMesh'DeusExItems.AmmoDart'
     Mesh=LodMesh'DeusExItems.AmmoDart'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
     ItemName="Tranquilizer Darts"
     HDTPIcon="GMDXSFX.Icons.BeltIconTranqDart"
     HDTPLargeIcon="GMDXSFX.Icons.LargeIconTranqDart"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoDartsPoison'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoDartsPoison'
     Description="A mini-crossbow dart tipped with a succinylcholine-variant that causes complete skeletal muscle relaxation, effectively incapacitating a target in a non-lethal manner."
     beltDescription="TRQ DART"
     HDTPSkin="GMDXSFX.Skins.TranqAmmo"
     //HDTPSkin="HDTPItems.Skins.HDTPAmmoDartTex3"
     Skin=Texture'DeusExItems.Skins.AmmoDartTex3'
}
