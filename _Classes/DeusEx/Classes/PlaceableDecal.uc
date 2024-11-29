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

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (!IsHDTP())
    {
        Skin = texture'PinkMaskTex'; //Go invisible
        return;
    }
	switch(TextureSetup)
	{
			//case E_Blood1:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex2"); break;
			case E_Blood2:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex3"); break;
			case E_Blood3:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex5"); break;
			case E_Blood4:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex6"); break;
			case E_Ambrosia:	Skin = class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.FlatFXtex48"); break;
			case E_Water:		Skin = class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.FlatFXtex47"); break;
			case E_Burn1:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex38"); break;
			case E_Burn2:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex39"); break;
			case E_Burn3:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex40"); break;
			case E_Hole:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex9"); break;
			default:		Skin = class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPFlatFXtex2"); break;
	}
}

defaultproperties
{
     bHighlight=False
     bPushable=False
     bStatic=True
     Physics=PHYS_None
     Style=STY_Modulated
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
