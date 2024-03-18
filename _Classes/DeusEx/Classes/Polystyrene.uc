//=============================================================================
// PaperFragment.
//=============================================================================
class Polystyrene expands DeusExFragment;

function PostBeginPlay()
{
 super.PostBeginPlay();

 DrawScale += (FRand()*0.1);
 Velocity = VRand() * 150;
 Velocity.Z += 50;
 if (FRand() < 0.7)
   ImpactSound = None;
}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.FleshFragment1'
     Fragments(1)=LodMesh'DeusExItems.FleshFragment2'
     Fragments(2)=LodMesh'DeusExItems.FleshFragment3'
     numFragmentTypes=3
     elasticity=0.250000
     ImpactSound=Sound'DeusExSounds.Generic.PaperHit1'
     LifeSpan=30.000000
     Skin=Texture'HDTPDecos.Skins.HDTPBoneFemurTex'
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     DrawScale=0.200000
     CollisionRadius=0.500000
     CollisionHeight=0.500000
     Mass=0.100000
     Buoyancy=3.000000
}
