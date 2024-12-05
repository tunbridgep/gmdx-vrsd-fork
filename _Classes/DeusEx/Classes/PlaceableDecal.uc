//=============================================================================
// PlaceableDecal //CyberP: can be placed in the world in UED and will remain indefinately
//=============================================================================
class PlaceableDecal extends DeusExDecoration;

enum ETextureSetup
{
	E_Blood1, //Actually unused
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
	E_Leaf, //SARGE: Added
	E_Leaf0, //SARGE: Added
	E_Leaf1, //SARGE: Added
	E_Leaf2, //SARGE: Added
	E_Leaf3, //SARGE: Added
	E_Piss, //SARGE: Added. Yes, GMDX added piss textures from HDTP to the maps....yuck....
	E_TrashBag, //SARGE: Added. Based off the trashbag texture.
	E_TrashPaper, //SARGE: Added. Originally used the TrashPaper texture, but now uses cardboard
    E_WaterWall,    //Sarge: Added. Originally the urinal texture from HDTP occasionally placed on walls to make them wet.
};

var() ETextureSetup TextureSetup;

function bool IsHDTP()
{
    return DeusExPlayer(GetPlayerPawn()).bHDTPInstalled && class'DeusExDecal'.default.iHDTPModelToggle > 0;
}

exec function UpdateHDTPsettings()
{
    local int i;
    //There are many of these set in the game already, with Skins and MultiSkins[0] set
    //MultiSkins[0] takes priority over skin.
    //If Skin or MultiSkins[0] is already set, then do nothing.
    //Interestingly, some have Multiskins[1] set, which does nothing.
    //Otherwise, find a new Skin based on our selected TextureSetup
    //NOTE: This object can use Skin or MultiSkins[0], but I want to simply use Skin for convenience

    //Remove default editor skin
    if (Skin == default.Skin)
        Skin = None;

    for (i = 0;i < 8;i++)
        if (MultiSkins[i] != None && MultiSkins[i] != Skin)
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
        case E_Blood1:		break;//Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex2","DeusExItems.Skins.FlatFXTex1",IsHDTP()); break;
        case E_Blood2:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex3","DeusExItems.Skins.FlatFXTex3",IsHDTP()); break;
        case E_Blood3:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex5","DeusExItems.Skins.FlatFXTex5",IsHDTP()); break;
        case E_Blood4:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex6","DeusExItems.Skins.FlatFXTex6",IsHDTP()); break;
        case E_Ambrosia:	Skin = class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.FlatFXtex48"); break;
        case E_Water:		Skin = class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.FlatFXtex47"); break;
        case E_Burn1:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex38","DeusExItems.Skins.FlatFXTex38",IsHDTP()); break;
        case E_Burn2:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex39","DeusExItems.Skins.FlatFXTex39",IsHDTP()); break;
        case E_Burn3:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex40","DeusExItems.Skins.FlatFXTex40",IsHDTP()); break;
        case E_Hole:		Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex9","DeusExItems.Skins.FlatFXTex9",IsHDTP()); break;
        case E_WaterWall:	Skin = class'HDTPLoader'.static.GetTexture("RSDCrap.Environment.WaterPuddle"); break;
        
        //Turns out the vanilla glass crack doesn't really look very good in most spots, so just disable it if we're not using HDTP
        //Since GMDX uses it almost like a generic "scratch" texture
        //EDIT: Exported it instead.
        //case E_GlassCrack:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex29","PinkMaskTex",IsHDTP()); break;
        //case E_GlassCrack:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex29","DeusExItems.Skins.FlatFXTex29",IsHDTP()); break;
        //case E_GlassCrack:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFlatFXtex29","DeusExItems.Skins.FlatFXTex7",IsHDTP()); break;
        case E_GlassCrack:	Skin = Texture'RSDCrap.Skins.HDTPFlatFXtex29'; break;

        //Added new low-quality Leaf textures.
        case E_Leaf:	Skin = class'HDTPLoader'.static.GetTexture2("GameMedia.Skins.LeafTex","RSDCrap.Environment.LeafTex",IsHDTP()); break;
        case E_Leaf0:	Skin = class'HDTPLoader'.static.GetTexture2("GameMedia.Skins.LeafTex0","RSDCrap.Environment.LeafTex0",IsHDTP()); break;
        case E_Leaf1:	Skin = class'HDTPLoader'.static.GetTexture2("GameMedia.Skins.LeafTex1","RSDCrap.Environment.LeafTex1",IsHDTP()); break;
        case E_Leaf2:	Skin = class'HDTPLoader'.static.GetTexture2("GameMedia.Skins.LeafTex2","RSDCrap.Environment.LeafTex2",IsHDTP()); break;
        case E_Leaf3:	Skin = class'HDTPLoader'.static.GetTexture2("GameMedia.Skins.LeafTex3","RSDCrap.Environment.LeafTex3",IsHDTP()); break;
        
        //For now we will use the HDTP tex, may change this later
        case E_Piss:	Skin = class'HDTPLoader'.static.GetTexture("RSDCrap.Environment.DirtyToiletWaterTex"); break;

        //GMDX reuses some textures that should have used other objects instead, like TrashPaper, but we should account for them anyway...
        case E_TrashBag:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPtrashbag1tex1","RSDCrap.Skins.TrashTex1",IsHDTP()); break;
        case E_TrashPaper:	Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPTrashpaperTex1","DeusExItems.Skins.PaperFragmentTex1",IsHDTP()); break;
	}
    //Bloody Minidisks...
    MultiSkins[1] = Skin;
}

defaultproperties
{
     Skin=Texture'DeusExDeco.AlarmLightTex2' //Make them visible in the editor
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
