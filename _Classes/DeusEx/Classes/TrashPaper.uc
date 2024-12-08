//=============================================================================
// TrashPaper.
//=============================================================================
class TrashPaper extends Trash;

//TBD
enum EPaperStyle
{
	E_Paper,
	E_Trash,
};

var() EPaperStyle PaperStyle;

function bool IsHDTP()
{
    return DeusExPlayer(GetPlayerPawn()) != None && DeusExPlayer(GetPlayerPawn()).bHDTPInstalled && class'DeusExDecal'.default.iHDTPModelToggle > 0;
}

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();

    /*
    //Stupid hack because sometimes trashpaper has the trashbag skin...
    if (Skin == Texture'DeusExDeco.Skins.TrashbagTex1' || string(skin) ~= "HDTPDecos.Skins.HDTPTrashbag1tex1")
        Skin = class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPTrashbag1tex1","DeusExDeco.Skins.TrashbagTex1",IsHDTP());
    
    //...And to make it even worse, it's applied inconsistently...
    if (MultiSkins[0] == Texture'DeusExDeco.Skins.TrashbagTex1' || string(MultiSkins[0]) ~= "HDTPDecos.Skins.HDTPTrashbag1tex1")
        MultiSkins[0] = class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPTrashbag1tex1","DeusExDeco.Skins.TrashbagTex1",IsHDTP());
     */

}

defaultproperties
{
     ItemName="Paper"
     HDTPSkin="HDTPDecos.Skins.HDTPTrashpaperTex1"
     Mesh=LodMesh'DeusExDeco.TrashPaper'
     CollisionRadius=6.000000
     CollisionHeight=6.000000
}
