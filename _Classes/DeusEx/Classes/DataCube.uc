//=============================================================================
// DataCube.
//=============================================================================
class DataCube extends InformationDevices;

var const bool bSkipDarkenCheck;

function bool DarkenScreen()
{
    return bRead || (textTag == '' && imageClass == None && !bSkipDarkenCheck);
}

exec function UpdateHDTPsettings()
{
    local DeusExPlayer player;
    super.UpdateHDTPsettings();

    player = DeusExPlayer(GetPlayerPawn());

    //Blank the screen once it's been read
    if (DarkenScreen() && player != None && player.bShowDataCubeRead)
        DoDarkenScreen();
    else if (IsHDTP())
        MultiSkins[2]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPDatacubetex1");
    else
        MultiSkins[2]=class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.Datacubetex1");
}

function OnBeginRead(DeusExPlayer reader)
{
    if (reader != None && reader.bShowDataCubeRead)
        DoDarkenScreen();
}

//Turn off the light and darken the screen
function DoDarkenScreen()
{
    LightType=LT_None;
    MultiSkins[2]=Texture'PinkMaskTex';
}

defaultproperties
{
     bAddToVault=True
     bInvincible=True
     bCanBeBase=True
     ItemName="DataCube"
     HDTPSkin="HDTPItems.Skins.HDTPDatacubetex1"
     Skin=Texture'DeusExItems.Skins.Datacubetex1';
     Mesh=LodMesh'DeusExItems.DataCube'
     Texture=Texture'Effects.Corona.Corona_G';
     CollisionRadius=7.000000
     CollisionHeight=1.270000
     Mass=2.000000
     LightType=LT_Steady
     LightRadius=3
     LightBrightness=48
     LightSaturation=32
     LightHue=140
     Buoyancy=3.000000
}
