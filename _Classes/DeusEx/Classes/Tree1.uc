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

exec function UpdateHDTPsettings()
{
	Super.UpdateHDTPsettings();

	switch (SkinColor)
	{
		case SC_Tree1:	MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPTreeTex3","DeusExDeco.Tree2Tex1",iHDTPModelToggle > 0); break;
		case SC_Tree2:	MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPTreeTex3","DeusExDeco.Tree2Tex2",iHDTPModelToggle > 0); break;
		case SC_Tree3:	MultiSkins[2] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPTreeTex2","DeusExDeco.Tree2Tex3",iHDTPModelToggle > 0); break;
	}
}

defaultproperties
{
     Altmesh="HDTPDecos.HDTPtree01b"
     HDTPMesh="HDTPDecos.HDTPtree01"
     Mesh=LodMesh'DeusExDeco.Tree1'
     CollisionRadius=10.000000
     CollisionHeight=125.000000
}
