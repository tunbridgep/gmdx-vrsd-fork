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
// BeginPlay()
// ----------------------------------------------------------------------

function BeginPlay()
{
	Super.BeginPlay();

	SetSkin();
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

function TravelPostAccept()
{
	Super.TravelPostAccept();

	SetSkin();
}

// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------

function SetSkin()
{
	switch (SkinColor)
	{
		case SC_China:		MultiSkins[1] = Texture'HDTPFlagPoleTex1'; break;//all the same for now
		case SC_France:		MultiSkins[1] = Texture'HDTPFlagPoleTex1'; break;
		case SC_President:	MultiSkins[1] = Texture'HDTPFlagPoleTex1'; break;
		case SC_UNATCO:		MultiSkins[1] = Texture'HDTPFlagPoleTex5'; break;
		case SC_USA:		MultiSkins[1] = Texture'HDTPFlagPoleTex5'; break;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FragType=Class'DeusEx.WoodFragment'
     ItemName="Flag Pole"
     Mesh=LodMesh'HDTPDecos.HDTPFlagpole'
     CollisionRadius=17.000000
     CollisionHeight=56.389999
     Mass=40.000000
     Buoyancy=30.000000
}
