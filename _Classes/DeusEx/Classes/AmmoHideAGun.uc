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
     PickupViewMesh=LodMesh'DeusExItems.HideAGunPickup'
     Icon=Texture'DeusExUI.Icons.BeltIconHideAGun'
     beltDescription="PS20"
     Mesh=LodMesh'DeusExItems.HideAGunPickup'
     CollisionRadius=4.300000
     CollisionHeight=8.440000
     bCollideActors=True
}
