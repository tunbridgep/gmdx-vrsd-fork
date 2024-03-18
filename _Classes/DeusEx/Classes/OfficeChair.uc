//=============================================================================
// OfficeChair.
//=============================================================================
class OfficeChair extends Seat;

enum ESkinColor
{
	SC_GrayLeather,
	SC_BrownLeather,
	SC_BrownCloth,
	SC_GrayCloth
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_GrayLeather:	Skin = Texture'HDTPOfficeChairTex1'; break;
		case SC_BrownLeather:	Skin = Texture'HDTPOfficeChairTex2'; break;
		case SC_BrownCloth:		Skin = Texture'HDTPOfficeChairTex3'; break;
		case SC_GrayCloth:		Skin = Texture'HDTPOfficeChairTex4'; break;
	}
}

defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-4.000000,Z=0.000000)
     HitPoints=30
     ItemName="Swivel Chair"
     Mesh=LodMesh'HDTPDecos.HDTPOfficeChair'
     CollisionRadius=16.000000
     CollisionHeight=25.549999
     Mass=40.000000
     Buoyancy=5.000000
}
