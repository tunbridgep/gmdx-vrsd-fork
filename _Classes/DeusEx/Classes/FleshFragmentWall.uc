//=============================================================================
// FleshFragmentWall.             //CyberP: guts up the wall
//=============================================================================
class FleshFragmentWall expands DeusExFragment;

auto state Flying

{

	function BeginState()
	{
	   local rotator rot;
       local float   randy;
       if (Level.Game.bLowGore || Level.Game.bVeryLowGore || Region.Zone.bWaterZone)
		{
			Destroy();
			return;
		}

       DrawScale = FRand() + 0.15;
       rot.Pitch = FRand()*18000;
   	   rot.Yaw =   FRand()*18000;
       rot.Roll =  FRand()*18000;
       SetRotation(rot);
       if (FRand() < 0.8)
       Skin=None;
    }

}



function Tick(float deltaSeconds)
{

	Super.Tick(deltaSeconds);

		if (FRand() < 0.024)
			{
            Spawn(class'BloodDropWall',,, Location);
            }

        if (FRand() < 0.002)
            {
            SetPhysics(PHYS_Falling);        //CyberP: I need everything in Tick() here to stop happening once the flesh falls off the wall and hits the floor
            Mass = 5.000000;
            LifeSpan = 5;
            }
}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.FleshFragment1'
     Fragments(1)=LodMesh'DeusExItems.FleshFragment2'
     Fragments(2)=LodMesh'DeusExItems.FleshFragment3'
     Fragments(3)=LodMesh'DeusExItems.FleshFragment4'
     numFragmentTypes=4
     elasticity=0.100000
     ImpactSound=Sound'DeusExSounds.Generic.FleshHit1'
     MiscSound=Sound'DeusExSounds.Generic.FleshHit2'
     Physics=PHYS_None
     LifeSpan=50.000000
     Skin=Texture'HDTPItems.Skins.HDTPFleshFragTex1'
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     CollisionRadius=0.010000
     CollisionHeight=0.010000
     Mass=0.000000
     Buoyancy=5.500000
     bVisionImportant=True
}
