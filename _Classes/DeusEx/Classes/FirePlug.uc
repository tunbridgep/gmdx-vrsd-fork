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

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
	
    switch (SkinColor)
	{
		case SC_Red:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFirePlugTex1","DeusExDeco.FirePlugTex1",IsHDTP()); break;
		case SC_Orange:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFirePlugTex2","DeusExDeco.FirePlugTex2",IsHDTP()); break;
		case SC_Blue:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFirePlugTex3","DeusExDeco.FirePlugTex3",IsHDTP()); break;
		case SC_Gray:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFirePlugTex4","DeusExDeco.FirePlugTex4",IsHDTP()); break;
    }
}

defaultproperties
{
     HDTPMesh="HDTPDecos.HDTPfireplug"
     Mesh=LodMesh'DeusExDeco.FirePlug'
     CollisionRadius=8.000000
     CollisionHeight=16.500000
     Mass=50.000000
     Buoyancy=30.000000
	 bHDTPFailsafe=False
}
