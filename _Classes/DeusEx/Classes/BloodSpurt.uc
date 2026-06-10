//=============================================================================
// BloodSpurt.
//=============================================================================
class BloodSpurt extends Effects;

auto state Flying
{
	function BeginState()
	{
		// Gore check
		if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
		{
			Destroy();
			return;
		}

		Velocity = vect(0,0,0);
		LifeSpan *= 1.15;
		DrawScale *= 1.15;
		//DrawScale -= FRand() * 0.5;
		PlayAnim('Spurt');
	}
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		ScaleGlow = 2.0;
		DrawScale *= 1.5;
		LifeSpan *= 2.0;
		bUnlit=True;
	}
}

defaultproperties
{
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Style=STY_Modulated
     Mesh=LodMesh'DeusExItems.BloodSpurt'
     bFixedRotationDir=True
     NetUpdateFrequency=5.000000
}