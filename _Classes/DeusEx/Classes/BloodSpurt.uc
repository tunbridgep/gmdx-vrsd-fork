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

		PlayAnim('Spurt');
	}
}

function Tick(float deltaTime)
{
	SetRotation(Rotator(Velocity));
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	Velocity = VRand(); //CyberP: faster blood
	if(Velocity == Vect(0.0,0.0,0.0))
		Velocity = Vect(1.0,1.0,1.0) + (Location * 100.0);

	DrawScale += 0.2 + FRand();
	SetRotation(Rotator(Velocity));

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
     LifeSpan=0.450000
     DrawType=DT_Mesh
     Style=STY_Modulated
     Mesh=LodMesh'DeusExItems.BloodSpurt'
     ScaleGlow=1.000000
     bFixedRotationDir=True
     NetUpdateFrequency=5.000000
}
