//=============================================================================
// AmmoLAW.
//=============================================================================
class AmmoLAW extends DeusExAmmo;

defaultproperties
{
     ammoSkill=Class'DeusEx.SkillWeaponHeavy'
     AmmoAmount=1
     MaxAmmo=3
     ItemName="Light Anti-Tank Weapon (LAW)"
     ItemArticle="a"
     PickupViewMesh=LodMesh'DeusExItems.LAWPickup'
     Mesh=LodMesh'DeusExItems.LAWPickup'
     Icon=Texture'DeusExUI.Icons.BeltIconLAW'
     beltDescription="LAW"
     Mesh=LodMesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
}
