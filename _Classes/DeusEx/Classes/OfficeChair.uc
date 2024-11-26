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

function UpdateHDTPsettings()
{
	Super.UpdateHDTPsettings();

	switch (SkinColor)
	{
		case SC_GrayLeather:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPOfficeChairTex1","DeusExDeco.OfficeChairTex1",iHDTPModelToggle > 0); break;
		case SC_BrownLeather:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPOfficeChairTex2","DeusExDeco.OfficeChairTex2",iHDTPModelToggle > 0); break;
		case SC_BrownCloth: 	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPOfficeChairTex3","DeusExDeco.OfficeChairTex3",iHDTPModelToggle > 0); break;
		case SC_GrayCloth:   	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPOfficeChairTex4","DeusExDeco.OfficeChairTex4",iHDTPModelToggle > 0); break;
	}
}

defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-4.000000,Z=0.000000)
     HitPoints=30
     ItemName="Swivel Chair"
     HDTPMesh="HDTPDecos.HDTPOfficeChair"
     Mesh=LodMesh'DeusExDeco.OfficeChair'
     CollisionRadius=16.000000
     CollisionHeight=25.549999
     Mass=40.000000
     Buoyancy=5.000000
}
