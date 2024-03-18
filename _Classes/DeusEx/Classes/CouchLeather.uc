//=============================================================================
// CouchLeather.
//=============================================================================
class CouchLeather extends Seat;

enum ESkinColor
{
	SC_Black,
	SC_Blue,
	SC_Brown,
	SC_LitGray,
	SC_Tan
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	//blank this for now: when Phas or whoever makes HDTP versions of the other texes, then put back in

	//switch (SkinColor)
	//{
	//	case SC_Black:		Skin = Texture'CouchLeatherTex1'; break;
	//	case SC_Blue:		Skin = Texture'CouchLeatherTex1'; break;
	//	case SC_Brown:		Skin = Texture'CouchLeatherTex1'; break;
	//	case SC_LitGray:	Skin = Texture'CouchLeatherTex1'; break;
	//	case SC_Tan:		Skin = Texture'CouchLeatherTex1'; break;
	//}
}

defaultproperties
{
     sitPoint(0)=(X=-18.000000,Y=-8.000000,Z=0.000000)
     sitPoint(1)=(X=18.000000,Y=-8.000000,Z=0.000000)
     HitPoints=75
     ItemName="Leather Couch"
     Skin=Texture'HDTPDecos.Skins.HDTPCouchLeatherTex1'
     Mesh=LodMesh'HDTPDecos.HDTPcouchleather'
     CollisionRadius=47.880001
     CollisionHeight=23.250000
     Mass=218.000000
     Buoyancy=110.000000
}
