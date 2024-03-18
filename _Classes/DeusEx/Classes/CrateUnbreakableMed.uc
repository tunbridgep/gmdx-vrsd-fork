//=============================================================================
// CrateUnbreakableMed.
//=============================================================================
class CrateUnbreakableMed extends Containers;

function PreBeginPlay()
{
         Super.PreBeginPlay();

         if (FRand() < 0.3)
         bGenerateTrash=True;
}

defaultproperties
{
     bFlammable=False
     ItemName="Metal Crate"
     bBlockSight=True
     Mesh=LodMesh'HDTPDecos.HDTPcrateUnbreakableMed'
     ScaleGlow=0.500000
     CollisionRadius=45.200001
     CollisionHeight=32.000000
     Mass=100.000000
     Buoyancy=110.000000
}
