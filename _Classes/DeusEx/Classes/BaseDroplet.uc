//=============================================================================
// BaseDroplet.
//=============================================================================
class BaseDroplet extends Actor;

function SpawnHitWallDecal(Rotator rotator) {}
function SpawnHitWaterDecal() {}

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

simulated function Tick(float deltaTime)
{
	if (Velocity == Vect(0,0,0))
	{
		SpawnHitWallDecal(rot(16384,0,0));
		Destroy();
	}
	else if (Region.Zone != None && Region.Zone.bWaterZone)
	{
		RotationRate = 0.2 * RotationRate;
		SpawnHitWaterDecal();
		Destroy();
	}
	else
		SetRotation(Rotator(Velocity));
}

auto state Flying
{
	simulated function HitWall(Vector HitNormal, Actor Wall)
	{
		SpawnHitWallDecal(Rotator(HitNormal));
		Destroy();
	}

	simulated function ZoneChange( ZoneInfo NewZone )
	{
		if ((NewZone != None) && (NewZone.bWaterZone))
		{
			RotationRate = 0.2 * RotationRate;
			SpawnHitWaterDecal();
			Destroy();
		}
	}

	simulated function BeginState()
    {
       	if (Region.Zone != None && Region.Zone.bWaterZone)
			Destroy();
    }
}

defaultproperties
{
     Style=None
     Mesh=None
     bCollideActors=False
     bCollideWorld=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bBounce=False
     NetPriority=0.250000
     NetUpdateFrequency=2.000000
     bVisionImportant=False
     ScaleGlow=1.000000
     bUnlit=False
     RemoteRole=ROLE_None
     bNetOptional=True
     Physics=PHYS_Falling
     bReplicateInstigator=False
     LifeSpan=20.000000
     bDirectional=True
     DrawType=DT_Mesh
     bGameRelevant=False
}
