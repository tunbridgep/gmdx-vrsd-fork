//=============================================================================
// BloodSpurt.
//=============================================================================
class BloodSpurt extends Effects;

var bool bEna;

auto state Flying
{
	function BeginState()
	{
		Velocity = vect(0,0,0);
		DrawScale -= FRand();
		PlayAnim('Spurt');

		// Gore check
		if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
		{
			Destroy();
			return;
		}
	}
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		ScaleGlow = 1.0;
		DrawScale *= 0.9;
		LifeSpan *= 1.0;
		//bUnlit=True;
	}
}

defaultproperties
{
     LifeSpan=0.400000
     DrawType=DT_Mesh
     Style=STY_Modulated
     Mesh=LodMesh'DeusExItems.BloodSpurt'
     ScaleGlow=0.200000
     bFixedRotationDir=True
     NetUpdateFrequency=5.000000
}
