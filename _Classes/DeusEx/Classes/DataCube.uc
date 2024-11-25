//=============================================================================
// DataCube.
//=============================================================================
class DataCube extends InformationDevices;

var travel bool bRead;

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (iHDTPModelToggle > 0)
    {
        MultiSkins[2]=class'HDTPLoader'.static.GetTexture("HDTPItems.Skins.HDTPDatacubetex1");
    }
    else
    {
        MultiSkins[2]=class'HDTPLoader'.static.GetTexture("DeusExItems.Skins.Datacubetex1");
    }

    if (bRead)
        MultiSkins[2]=Texture'PinkMaskTex';
}

//Called when this is opened for the first time
function void OnRead()
{
    bRead = true;
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
