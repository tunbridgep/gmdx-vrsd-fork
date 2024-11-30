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
	E_GlassCrack, //SARGE: Added
};

var() ETextureSetup TextureSetup;

exec function UpdateHDTPsettings()
{
    local int i;
    //There are many of these set in the game already, with Skink and MultiSkins[0] set
    //MultiSkins[0] takes priority over skin.
    //If Skin or MultiSkins[0] is already set, then do nothing.
    //Otherwise, find a new Skin based on our selected TextureSetup
    //NOTE: This object can use Skin or MultiSkins[0], but I want to simply use Skin for convenience

    if (Skin != default.Skin)
        return;

    for (i = 0;i < 8;i++)
        if (MultiSkins[i] != None)
            return;

    /*
    log("PlaceableDecal");
    log("   Skin: " $ Skin);
    log("   MultiSkins[0]: " $ MultiSkins[0]);
    log("   MultiSkins[1]: " $ MultiSkins[1]);
    log("   Texture: " $ Texture);
    */

    super.UpdateHDTPsettings();
	switch(TextureSetup)
	{
			case E_Blood1:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex2","DeusExItems.Skins.FlatFXTex1",IsHDTP()); break;
			case E_Blood2:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex3","DeusExItems.Skins.FlatFXTex3",IsHDTP()); break;
			case E_Blood3:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex5","DeusExItems.Skins.FlatFXTex5",IsHDTP()); break;
			case E_Blood4:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex6","DeusExItems.Skins.FlatFXTex6",IsHDTP()); break;
			case E_Ambrosia:	Skin = class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.FlatFXtex48"); break;
			case E_Water:		Skin = class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.FlatFXtex47"); break;
			case E_Burn1:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex38","DeusExItems.Skins.FlatFXTex38",IsHDTP()); break;
			case E_Burn2:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex39","DeusExItems.Skins.FlatFXTex39",IsHDTP()); break;
			case E_Burn3:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex40","DeusExItems.Skins.FlatFXTex40",IsHDTP()); break;
			case E_Hole:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex9","DeusExItems.Skins.FlatFXTex9",IsHDTP()); break;
			case E_GlassCrack:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex29","DeusExItems.Skins.FlatFXTex29",IsHDTP()); break;
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
	 bHDTPFailsafe=False
}
