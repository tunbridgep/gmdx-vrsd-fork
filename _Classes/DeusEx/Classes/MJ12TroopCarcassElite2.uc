//=============================================================================
// MJ12TroopCarcass.
//=============================================================================
class MJ12TroopCarcassElite2 extends DeusExCarcass;

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPSettings();
    
    if (!IsHDTP())
    {
        if (class'DeusExPlayer'.default.bClassicMJ12Skin)
        {
            MultiSkins[5]=Texture'DeusExCharacters.Skins.MJ12TroopTex3';
            MultiSkins[6]=Texture'DeusExCharacters.Skins.MJ12TroopTex4';
        }
        else
        {
            MultiSkins[5]=default.MultiSkins[5];
            MultiSkins[6]=default.MultiSkins[6];
        }
    }
}

defaultproperties
{
     Mesh2=LodMesh'DeusExCharacters.GM_Jumpsuit_CarcassB'
     Mesh3=LodMesh'DeusExCharacters.GM_Jumpsuit_CarcassC'
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit_Carcass'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.SkinTex1'
     MultiSkins(1)=Texture'GMDXSFX.Skins.MJ12EliteTex2'
     MultiSkins(2)=Texture'GMDXSFX.Skins.MJ12EliteTex1'
     MultiSkins(3)=Texture'GMDXSFX.Skins.MJ12EliteTex0'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'GMDXSFX.Skins.MJ12TroopTex9'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=40.000000
}
