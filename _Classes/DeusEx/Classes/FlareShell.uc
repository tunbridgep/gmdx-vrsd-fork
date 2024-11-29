//=============================================================================
// Flareshell.
//=============================================================================
class FlareShell extends DeusExDecoration;

//Depend on Flare settings
function bool IsHDTP()
{
    return class'Flare'.default.iHDTPModelToggle > 0 && class'HDTPLoader'.static.HDTPInstalled();
}


defaultproperties
{
     FragType=Class'DeusEx.PaperFragment'
     bFlammable=True
     bCanBeBase=True
     ItemName="Used Flare"
     HDTPMesh="HDTPItems.HDTPflare"
     Mesh=LodMesh'DeusExItems.Flare'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=6.200000
     CollisionHeight=2.300000
     Mass=2.000000
     Buoyancy=1.000000
}
