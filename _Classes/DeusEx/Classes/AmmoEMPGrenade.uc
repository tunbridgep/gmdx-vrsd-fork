//=============================================================================
// AmmoEMPGrenade.
//=============================================================================
class AmmoEMPGrenade extends DeusExAmmo;

defaultproperties
{
     ammoSkill=Class'DeusEx.SkillDemolition'
     AmmoAmount=1
     MaxAmmo=5
     ItemName="Electromagnetic Pulse (EMP) Grenade"
     ItemArticle="an"
     PickupViewMesh=LodMesh'DeusExItems.TestBox'
     Icon=Texture'DeusExUI.Icons.BeltIconEMPGrenade'
     beltDescription="EMP GREN"
     Mesh=LodMesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
     bHarderScaling=True
}
