//=============================================================================
// BoneFemurBloodyFragment.
//=============================================================================
class BoneFemurbloodyFragment extends DeusExFragment;

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (IsHDTP())
    {
        Fragments[0]=class'HDTPLoader'.static.GetMesh("HDTPDecos.HDTPbonefemur");
        Fragments[0]=class'HDTPLoader'.static.GetMesh("HDTPDecos.HDTPbonefemur");
    }
    else
    {
        Fragments[0]=LodMesh'DeusExDeco.BoneFemur';
        Fragments[1]=LodMesh'DeusExDeco.BoneFemur';
    }
}

defaultproperties
{
     numFragmentTypes=2
     elasticity=0.400000
     ImpactSound=Sound'DeusExSounds.Generic.WoodHit1'
     MiscSound=Sound'DeusExSounds.Generic.WoodHit2'
     Skin=Texture'DeusExItems.Skins.FleshFragmentTex1'
     Mesh=LodMesh'DeusExDeco.BoneFemur'
     CollisionRadius=2.000000
     CollisionHeight=0.780000
     Mass=3.000000
     Buoyancy=10.000000
     bVisionImportant=True
}
