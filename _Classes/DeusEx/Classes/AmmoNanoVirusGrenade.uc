//=============================================================================
// AmmoNanoVirusGrenade.
//=============================================================================
class AmmoNanoVirusGrenade extends DeusExAmmo;

defaultproperties
{
     ammoSkill=Class'DeusEx.SkillDemolition'
     AmmoAmount=1
     MaxAmmo=5
     ItemArticle="a"
     ItemName="Scramble Grenade"
     PickupViewMesh=LodMesh'DeusExItems.TestBox'
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponNanoVirus'
     beltDescription="SCRM GREN"
     Mesh=LodMesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
     bHarderScaling=True
}
