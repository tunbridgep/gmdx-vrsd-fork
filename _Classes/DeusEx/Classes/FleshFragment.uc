//=============================================================================
// FleshFragment.
//=============================================================================
class FleshFragment expands DeusExFragment;

var bool bWasUnconscious;

auto state Flying                      //CyberP: modified to be more gory
{
	function BeginState()
	{
		local rotator      randRot;
        local float        rand;

		Super.BeginState();

		Velocity = VRand() * 275; //300
		DrawScale = FRand() + FRand() + 0.1;
		rand = FRand();
		SetRotation(Rotator(Velocity));

		if (rand < 0.03)
			spawn(class'BoneFemurLessBloody',,,,randRot);
        else if (rand <0.15)
            Skin=class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFleshFragTex1","DeusExItems.Skins.FleshFragmentTex1",IsHDTP());
		else if (rand < 0.19)
            spawn(class'BoneFemurBloody',,,,randRot);

        rand = FRand();

        if (rand < 0.02)
           Spawn(class'FleshFragmentArm',,,Location+vect(0,0,5));
        else if (rand <0.04)
           Spawn(class'FleshFragmentLeg',,,Location+vect(0,0,-3));
		else if (rand < 0.08)
           Spawn(class'FleshFragmentGuts',,,Location+vect(0,0,3));
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
