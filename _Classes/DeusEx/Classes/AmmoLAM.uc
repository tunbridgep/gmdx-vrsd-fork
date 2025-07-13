//=============================================================================
// AmmoLAM.
//=============================================================================
class AmmoLAM extends DeusExAmmo;

defaultproperties
{
     ammoSkill=Class'DeusEx.SkillDemolition'
     AmmoAmount=1
     MaxAmmo=5
     ItemName="Lightweight Attack Munitions (LAM)"
     ItemArticle="a"
     PickupViewMesh=LodMesh'DeusExItems.TestBox'
     Icon=Texture'DeusExUI.Icons.BeltIconLAM'
     beltDescription="LAM"
     Mesh=LodMesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
     bHarderScaling=True
}
