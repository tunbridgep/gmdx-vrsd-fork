//=============================================================================
// PlaceableDecal //CyberP: can be placed in the world in UED and will remain indefinately
//=============================================================================
class PlaceableDecal extends DeusExDecoration;

enum ETextureSetup
{
	E_Blood1,
	E_Blood2,
	E_Blood3,
	E_Blood4,
	E_Ambrosia,
	E_Water,
	E_Burn1,
	E_Burn2,
	E_Burn3,
	E_Hole,
};

var() ETextureSetup TextureSetup;

function BeginPlay()
{
	Super.BeginPlay();

	SetSkin(TextureSetup);
}

function SetSkin(ETextureSetup setup)
{
	switch(setup)
	{
			case E_Blood1:		Skin = default.Skin; break;
			case E_Blood2:		Skin = Texture'HDTPItems.Skins.HDTPFlatFXtex3'; break;
			case E_Blood3:		Skin = Texture'HDTPItems.Skins.HDTPFlatFXtex5'; break;
			case E_Blood4:		Skin = Texture'HDTPItems.Skins.HDTPFlatFXtex6'; break;
			case E_Ambrosia:	Skin = Texture'DeusExItems.Skins.FlatFXtex48'; break;
			case E_Water:		Skin = Texture'DeusExItems.Skins.FlatFXtex47'; break;
			case E_Burn1:		Skin = Texture'HDTPItems.Skins.HDTPFlatFXtex38'; break;
			case E_Burn2:		Skin = Texture'HDTPItems.Skins.HDTPFlatFXtex39'; break;
			case E_Burn3:		Skin = Texture'HDTPItems.Skins.HDTPFlatFXtex40'; break;
			case E_Hole:		Skin = Texture'HDTPItems.Skins.HDTPFlatFXtex9'; break;
			default:	Skin = default.skin; break;
	}
}

defaultproperties
{
     bHighlight=False
     bPushable=False
     bStatic=True
     Physics=PHYS_None
     Style=STY_Modulated
     Skin=Texture'HDTPItems.Skins.HDTPFlatFXtex2'
     Mesh=LodMesh'DeusExItems.FlatFX'
     DrawScale=2.000000
     ScaleGlow=1.500000
     bUnlit=True
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
}
