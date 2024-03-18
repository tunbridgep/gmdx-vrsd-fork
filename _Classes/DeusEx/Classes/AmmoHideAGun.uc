//=============================================================================
// AmmoPlasma.
//=============================================================================
class AmmoHideAGun extends DeusExAmmo;

defaultproperties
{
     ammoSkill=Class'DeusEx.SkillWeaponPistol'
     AmmoAmount=1
     MaxAmmo=5
     ItemName="PS20"
     ItemArticle="a"
     PickupViewMesh=LodMesh'DeusExItems.TestBox'
     Icon=Texture'DeusExUI.Icons.BeltIconHideAGun'
     beltDescription="Count:"
     Mesh=LodMesh'HDTPItems.HDTPAmmoPlasma'
     CollisionRadius=4.300000
     CollisionHeight=8.440000
     bCollideActors=True
}
