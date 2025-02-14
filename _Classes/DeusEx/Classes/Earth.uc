//=============================================================================
// Earth.
//=============================================================================
class Earth expands OutdoorThings;

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    MultiSkins[0]=class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPEarthTex1","",IsHDTP());
    MultiSkins[1]=class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPEarthTex2","",IsHDTP());
}

defaultproperties
{
     bStatic=False
     Physics=PHYS_Rotating
     Mesh=LodMesh'DeusExDeco.Earth'
     CollisionRadius=48.000000
     CollisionHeight=48.000000
     bCollideActors=False
     bCollideWorld=False
     bFixedRotationDir=True
     Mass=10.000000
     Buoyancy=5.000000
     RotationRate=(Yaw=-128)
}
