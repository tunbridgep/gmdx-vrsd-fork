//=============================================================================
// FleshFragment.
//=============================================================================
class FleshFragmentSmall expands DeusExFragment;

var float TwitchyS;
var float TwitchyE;
var bool bWasUnconscious;


auto state Flying
{
	function BeginState()
	{
		Super.BeginState();

		Velocity = VRand() * 80; //300
		DrawScale = FRand() * 0.65;

		if (FRand() < 0.04)
            Skin=Texture'HDTPItems.Skins.HDTPFleshFragTex1';
        else
            Skin=None;
	}
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (!IsInState('Dying'))
		if (FRand() < 0.01)
			Spawn(class'BloodDropWall',,, Location);

   //if ((bWasUnconscious)&&(FRand()<0.1))
   //   DrawScale=FRand()*TwitchyE+TwitchyS;

}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.FleshFragment1'
     Fragments(1)=LodMesh'DeusExItems.FleshFragment2'
     Fragments(2)=LodMesh'DeusExItems.FleshFragment3'
     Fragments(3)=LodMesh'DeusExItems.FleshFragment4'
     numFragmentTypes=4
     elasticity=0.400000
     ImpactSound=Sound'DeusExSounds.Generic.FleshHit1'
     MiscSound=Sound'DeusExSounds.Generic.FleshHit2'
     LifeSpan=60.000000
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     CollisionRadius=0.010000
     CollisionHeight=0.050000
     Mass=5.000000
     Buoyancy=5.500000
     bVisionImportant=True
}
