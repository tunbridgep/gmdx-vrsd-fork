//=============================================================================
// AmmoRocket.
//=============================================================================
class AmmoRocket extends DeusExAmmo;

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponHeavy'
     AmmoAmount=4
     MaxAmmo=10
     ItemName="Rockets"
     ItemArticle="some"
     LandSound=Sound'DeusExSounds.Generic.WoodHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoRockets'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoRockets'
     largeIconWidth=46
     largeIconHeight=36
     Description="A gyroscopically stabilized rocket with limited onboard guidance systems for in-flight course corrections. Engineered for use with the GEP gun."
     beltDescription="ROCKET"
     HDTPMesh="HDTPItems.HDTPgepammo"
     PickupViewMesh=LodMesh'DeusExItems.GEPAmmo'
     PlayerViewMesh=LodMesh'DeusExItems.GEPAmmo'
     ThirdPersonMesh=LodMesh'DeusExItems.GEPAmmo'
     Mesh=LodMesh'DeusExItems.GEPAmmo'
     CollisionRadius=18.000000
     CollisionHeight=7.800000
     bCollideActors=True
}
