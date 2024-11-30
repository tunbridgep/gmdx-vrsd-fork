//=============================================================================
// FlagPole.
//=============================================================================
class FlagPole extends DeusExDecoration;

enum ESkinColor
{
	SC_China,
	SC_France,
	SC_President,
	SC_UNATCO,
	SC_USA
};

var() travel ESkinColor SkinColor;

// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------

function UpdateHDTPsettings()
{
    local Texture flagTex;
    super.UpdateHDTPsettings();
	switch (SkinColor)
	{
        case SC_China: flagTex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFlagPoleTex1","DeusExDeco.FlagPoleTex1",IsHDTP()); break;
        case SC_France: flagTex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFlagPoleTex1","DeusExDeco.FlagPoleTex2",IsHDTP()); break;
        case SC_President: flagTex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFlagPoleTex1","DeusExDeco.FlagPoleTex3",IsHDTP()); break;
        case SC_UNATCO: flagTex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFlagPoleTex5","DeusExDeco.FlagPoleTex4",IsHDTP()); break;
        case SC_USA: flagTex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPFlagPoleTex5","DeusExDeco.FlagPoleTex5",IsHDTP()); break;
	}
    if (IsHDTP())
        MultiSkins[1] = flagTex;
    else
        Skin = flagTex;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FragType=Class'DeusEx.WoodFragment'
     ItemName="Flag Pole"
     HDTPMesh="HDTPDecos.HDTPFlagpole"
     Mesh=LodMesh'DeusExDeco.Flagpole'
     CollisionRadius=17.000000
     CollisionHeight=56.389999
     Mass=40.000000
     Buoyancy=30.000000
	 bHDTPFailsafe=False
}
