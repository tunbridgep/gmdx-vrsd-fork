//=============================================================================
// AmmoDart.
//=============================================================================
class AmmoDart extends DeusExAmmo;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
      AmmoAmount = 6;
}

defaultproperties
{
     bShowInfo=True
     altDamage=20
     ammoSkill=Class'DeusEx.SkillWeaponPistol'
     AmmoAmount=3
     MaxAmmo=30
     ItemName="Darts"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.AmmoDart'
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     HDTPIcon="GMDXSFX.Icons.BeltIconSteelDart"
     HDTPLargeIcon="GMDXSFX.Icons.LargeIconSteelDart"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoDartsNormal'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoDartsNormal'
     largeIconWidth=20
     largeIconHeight=47
     Description="The mini-crossbow dart is a favored weapon for many 'wet' operations; however, silent kills require a high degree of skill."
     beltDescription="DART"
     HDTPSkin="GMDXSFX.Skins.DartAmmo"
     //HDTPSkin="HDTPItems.Skins.HDTPAmmoDartTex1"
     Skin=Texture'RSDCrap.Skins.AmmoDartTex1'
     Mesh=LodMesh'DeusExItems.AmmoDart'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
}
