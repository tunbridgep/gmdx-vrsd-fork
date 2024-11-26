//=============================================================================
// DataCube.
//=============================================================================
class DataCube extends InformationDevices;

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();

    //Blank the screen once it's been read
    if (bRead)
        MultiSkins[2]=Texture'PinkMaskTex';
    else if (IsHDTP())
        MultiSkins[2]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPDatacubetex1");
    else
        MultiSkins[2]=class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.Datacubetex1");
}

function OnBeginRead()
{
    MultiSkins[2]=Texture'PinkMaskTex';
}

defaultproperties
{
     bLeftGrab=True
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
     Buoyancy=3.000000
}
