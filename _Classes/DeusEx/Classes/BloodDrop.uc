//=============================================================================
// BloodDrop.
//=============================================================================
class BloodDrop extends DeusExFragment;

auto state Flying
{
	function HitWall(vector HitNormal, actor Wall)
	{
		Spawn(class'BloodSplat',,, Location, Rotator(HitNormal));
		Destroy();
	}
	function BeginState()
	{
		// Gore check
		if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
			Destroy();
	}

	function ZoneChange(ZoneInfo NewZone)
	{
		if (NewZone != None && NewZone.bWaterZone)
			Destroy();

		Super.ZoneChange(NewZone);
	}
}

function Tick(float deltaTime)
{
	if (Velocity == Vect(0,0,0))
	{
		Spawn(class'BloodSplat',,, Location, rot(16384,0,0));
		Destroy();
	}
	else
		SetRotation(Rotator(Velocity));
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	Velocity = VRand() * 200; //CyberP: faster blood
	if(Velocity == Vect(0.0,0.0,0.0))
		Velocity = Vect(1.0,1.0,1.0) + (Location * 100.0);

	DrawScale = 0.75 + FRand();
	SetRotation(Rotator(Velocity));

	if ( Level.NetMode != NM_Standalone )
	{
		ScaleGlow = 2.0;
		DrawScale *= 1.5;
		LifeSpan *= 3.0;
		bUnlit=True;
	}
}

simulated function PostBeginPlay()
{
	if (Region.Zone.bWaterZone)
		Destroy();
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
     bCollideWorld=True
     ImpactSound=None
     MiscSound=None
     bVisionImportant=False
     ScaleGlow=1.000000
}
