//=============================================================================
// WoodFragment.
//=============================================================================
class WoodFragment expands DeusExFragment;

#exec obj load file=CoreTexWood

function SkinVariation()
{
     if (Skin == default.Skin || FRand() < 0.15)
        Multiskins[0]=Texture'BoatHouseWood_D';
}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.WoodFragment1'
     Fragments(1)=LodMesh'DeusExItems.WoodFragment2'
     Fragments(2)=LodMesh'DeusExItems.WoodFragment3'
     numFragmentTypes=3
     elasticity=0.400000
     ImpactSound=Sound'DeusExSounds.Generic.WoodHit1'
     MiscSound=Sound'DeusExSounds.Generic.WoodHit2'
     Skin=Texture'GMDXSFX.Skins.DamWoodTex'
     Mesh=LodMesh'DeusExItems.WoodFragment1'
     CollisionRadius=6.000000
     CollisionHeight=1.000000
     Mass=5.000000
     Buoyancy=6.000000
}
