//=============================================================================
// WaterDrop.
//=============================================================================
class WaterDrop extends DeusExFragment;

auto state Flying
{
	function HitWall(vector HitNormal, actor Wall)
	{
		Spawn(class'WaterPoolTiny',,, Location, Rotator(HitNormal));
		Destroy();
	}

	function BeginState()
	{
		if ((Region.Zone != None) && (Region.Zone.bWaterZone))
			Destroy();

		Velocity = VRand() * 1.1;
		if (Instigator != None)
		{
			Velocity += Instigator.Velocity / 2;
		}
		DrawScale = 0.8 + FRand();
	}

	simulated singular function ZoneChange( ZoneInfo NewZone )
	{
		if ((NewZone != None) && (NewZone.bWaterZone))
		{
			RotationRate = 0.2 * RotationRate;
			GotoState('Dying');
		}
	}
}

function Tick(float deltaTime)
{
	if (Velocity == Vect(0,0,0))
	{
		Spawn(class'WaterPoolTiny',,, Location, rot(16384,0,0));
		Destroy();
	}

	if ((Region.Zone != None) && (Region.Zone.bWaterZone))
		Destroy();
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
     Style=STY_Translucent
     Skin=Texture'Effects.Generated.WtrDrpSmall'
     Mesh=LodMesh'DeusExItems.BloodDrop'
     DrawScale=0.600000
     ScaleGlow=0.600000
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bBounce=False
     NetPriority=1.000000
     NetUpdateFrequency=5.000000
}
