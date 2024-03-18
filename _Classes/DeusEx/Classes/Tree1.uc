//=============================================================================
// Tree1.
//=============================================================================
class Tree1 extends Tree;

enum ESkinColor
{
	SC_Tree1,
	SC_Tree2,
	SC_Tree3
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Tree1:	MultiSkins[2] = Texture'HDTPDecos.HDTPTreeTex3'; break;
		case SC_Tree2:	MultiSkins[2] = Texture'HDTPDecos.HDTPTreeTex3'; break;
		case SC_Tree3:	MultiSkins[2] = Texture'HDTPDecos.HDTPTreeTex2'; break;
	}
}

defaultproperties
{
     Altmesh=LodMesh'HDTPDecos.HDTPtree01b'
     Mesh=LodMesh'HDTPDecos.HDTPtree01'
     CollisionRadius=10.000000
     CollisionHeight=125.000000
}
