//=============================================================================
// FleshFragment.
//=============================================================================
class FleshFragmentAnimal expands DeusExFragment;

var bool bWasUnconscious;
var bool bAnimalFlesh;
var texture PassedSkin;

auto state Flying                      //CyberP: modified to be more gory
{
	function BeginState()
	{
		local rotator      randRot;
        local float        rand;

		Super.BeginState();

		Velocity = VRand() * 300; //300
		DrawScale = FRand() + FRand() + 0.1;
		rand = FRand();
		SetRotation(Rotator(Velocity));

		if (rand < 0.02)
			spawn(class'BoneFemurLessBloody',,,,randRot);
        else if (rand <0.1)
            Skin=Texture'HDTPItems.Skins.HDTPFleshFragTex1';
		else if (rand < 0.13)
            spawn(class'BoneFemurBloody',,,,randRot);
        else if (rand < 0.19)
            Spawn(class'FleshFragmentGuts',,,Location+vect(0,0,2));

        rand = FRand();
	}
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (!IsInState('Dying') && Speed != 0)
			Spawn(class'BloodDrop',,, Location);
}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.FleshFragment1'
     Fragments(1)=LodMesh'DeusExItems.FleshFragment2'
     Fragments(2)=LodMesh'DeusExItems.FleshFragment3'
     Fragments(3)=LodMesh'DeusExItems.FleshFragment4'
     numFragmentTypes=4
     elasticity=0.300000
     ImpactSound=Sound'DeusExSounds.Generic.FleshHit1'
     MiscSound=Sound'DeusExSounds.Generic.FleshHit2'
     LifeSpan=60.000000
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     CollisionRadius=0.010000
     CollisionHeight=1.220000
     Mass=5.000000
     Buoyancy=5.500000
}
