//=============================================================================
// CrateBreakableMedMedical.
//=============================================================================
class CrateBreakableMedMedical extends Containers;

defaultproperties
{
     bVisionImportant=True
     bSelectMeleeWeapon=True
     FragType=Class'DeusEx.WoodFragment'
     ItemName="Medical Supply Crate"
     contents=Class'DeusEx.MedKit'
     bBlockSight=True
     Skin=Texture'DeusExDeco.Skins.CrateBreakableMedTex1'
     Mesh=LodMesh'DeusExDeco.CrateBreakableMed'
     CollisionRadius=34.000000
     CollisionHeight=24.000000
     Mass=50.000000
     Buoyancy=60.000000
     HDTPSkin="HDTPDecos.Skins.HDTPCrateBreakableMedTex1";
     HDTPMesh="HDTPDecos.HDTPCrateBreakableMed";
}
