//=============================================================================
// BloodDropWall. CyberP: blood that drips off of FleshFragmentWall
//=============================================================================
class BloodDropWall extends DeusExFragment;

auto state Flying
{
	function HitWall(vector HitNormal, actor Wall)
	{
	    if (FRand() < 0.3)
		spawn(class'BloodSplat',,, Location, Rotator(HitNormal));
		Destroy();
	}
	function BeginState()
	{
		Velocity.Z = -2;
		DrawScale = 1 + FRand();


		// Gore check
		if (Level.Game.bLowGore || Level.Game.bVeryLowGore || Region.Zone.bWaterZone)
		{
			Destroy();
			return;
		}
	}
}

function Tick(float deltaTime)
{
	if (Velocity == vect(0,0,0))
	{
        if (FRand() < 0.3)
		spawn(class'BloodSplat',,, Location, rot(16384,0,0));
		Destroy();
	}
	else
		SetRotation(Rotator(Velocity));
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		ScaleGlow = 2.0;
		DrawScale *= 1.5;
		LifeSpan *= 3.0;
		bUnlit=True;
	}
}

defaultproperties
{
     Style=STY_Modulated
     Mesh=LodMesh'DeusExItems.BloodDrop'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bBounce=False
     NetPriority=1.000000
     NetUpdateFrequency=5.000000
}
