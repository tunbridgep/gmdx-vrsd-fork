//=============================================================================
// CrateBreakableMedCombat.
//=============================================================================
class CrateBreakableMedCombat extends BreakableContainers;

defaultproperties
{
     FragType=Class'DeusEx.WoodFragment'
     ItemName="Combat Supply Crate"
     contents=Class'DeusEx.Ammo10mm'
     bBlockSight=True
     Skin=Texture'HDTPDecos.Skins.HDTPCrateBreakableAmmoTex1'
     Mesh=LodMesh'HDTPDecos.HDTPCrateBreakableMed'
     CollisionRadius=34.000000
     CollisionHeight=24.000000
     Mass=50.000000
     Buoyancy=60.000000
}
