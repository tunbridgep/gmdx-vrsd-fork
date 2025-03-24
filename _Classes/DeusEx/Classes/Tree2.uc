//=============================================================================
// Tree2.
//=============================================================================
class Tree2 extends Tree;

enum ESkinColor
{
	SC_Tree1,
	SC_Tree2,
	SC_Tree3
};

var() ESkinColor SkinColor;

exec function UpdateHDTPsettings()
{
	Super.UpdateHDTPsettings();

	switch (SkinColor)
	{
		case SC_Tree1:	MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPTreeTex3","DeusExDeco.Tree2Tex1",IsHDTP() && closeEnough); break;
		case SC_Tree2:	MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPTreeTex3","DeusExDeco.Tree2Tex2",IsHDTP() && closeEnough); break;
		case SC_Tree3:	MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPTreeTex2","DeusExDeco.Tree2Tex3",IsHDTP() && closeEnough); break;
	}
}

defaultproperties
{
     Altmesh="HDTPDecos.HDTPtree02b"
     HDTPMesh="HDTPDecos.HDTPtree02"
     Mesh=LodMesh'DeusExDeco.Tree2'
     CollisionRadius=10.000000
     CollisionHeight=182.369995
}
