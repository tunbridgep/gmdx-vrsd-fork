//=============================================================================
// FleshFragment.
//=============================================================================
class FleshFragmentArm expands DeusExFragment;

auto state Flying
{
	function BeginState()
	{
		Super.BeginState();

		Velocity = VRand() * 160;
	}
}

defaultproperties
{
     Fragments(0)=LodMesh'GameMedia.GibForearm'
     numFragmentTypes=1
     elasticity=0.350000
     ImpactSound=Sound'DeusExSounds.Generic.FleshHit1'
     MiscSound=Sound'DeusExSounds.Generic.FleshHit2'
     LifeSpan=60.000000
     Mesh=LodMesh'GameMedia.GibForearm'
     DrawScale=1.200000
     CollisionRadius=1.000000
     CollisionHeight=2.000000
     Mass=5.000000
     Buoyancy=5.500000
     bVisionImportant=True
}
