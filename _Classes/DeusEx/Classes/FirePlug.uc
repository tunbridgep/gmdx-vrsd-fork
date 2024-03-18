//=============================================================================
// FirePlug.
//=============================================================================
class FirePlug expands OutdoorThings;

enum ESkinColor
{
	SC_Red,
	SC_Orange,
	SC_Blue,
	SC_Gray
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Red:	Skin = Texture'HDTPFirePlugTex1'; break;
		case SC_Orange:	Skin = Texture'HDTPFirePlugTex2'; break;
		case SC_Blue:	Skin = Texture'HDTPFirePlugTex3'; break;
		case SC_Gray:	Skin = Texture'HDTPFirePlugTex4'; break;
	}
}

defaultproperties
{
     Mesh=LodMesh'HDTPDecos.HDTPfireplug'
     CollisionRadius=8.000000
     CollisionHeight=16.500000
     Mass=50.000000
     Buoyancy=30.000000
}
