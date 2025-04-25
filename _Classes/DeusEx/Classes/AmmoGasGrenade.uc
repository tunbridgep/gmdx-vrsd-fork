//=============================================================================
// AmmoGasGrenade.
//=============================================================================
class AmmoGasGrenade extends DeusExAmmo;

defaultproperties
{
     ammoSkill=Class'DeusEx.SkillDemolition'
     AmmoAmount=1
     MaxAmmo=5
     ItemName="Gas Grenade"
     ItemArticle="a"
     PickupViewMesh=LodMesh'DeusExItems.TestBox'
     Icon=Texture'DeusExUI.Icons.BeltIconGasGrenade'
     beltDescription="GAS GREN"
     Mesh=LodMesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
     bHarderScaling=True
}
