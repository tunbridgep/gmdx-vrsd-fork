//=============================================================================
// Flareshell.
//=============================================================================
class FlareShell extends DeusExDecoration;

var const Texture burnTex;

//Depend on Flare settings
static function bool IsHDTP()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && class'Flare'.default.iHDTPModelToggle > 0;
}

//We need to apply a burn tex manually because
//we're using the vanilla model and HDTP explodes if I use the default Skin.
exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (IsHDTP())
        Skin = None;
    else
        Skin = burnTex;
}

defaultproperties
{
     FragType=Class'DeusEx.PaperFragment'
     bFlammable=True
     bCanBeBase=True
     ItemName="Used Flare"
     HDTPMesh="HDTPItems.HDTPflare"
     Mesh=LodMesh'DeusExItems.Flare'
     BurnTex=Texture'RSDCrap.Skins.FlareTex2'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=6.200000
     CollisionHeight=2.300000
     Mass=2.000000
     Buoyancy=1.000000
     bHDTPFailsafe=false
}
