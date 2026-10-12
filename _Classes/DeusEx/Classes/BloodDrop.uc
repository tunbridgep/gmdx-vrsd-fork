//=============================================================================
// BloodDrop.
//=============================================================================
class BloodDrop extends BaseDroplet;

function SpawnHitWallDecal(Rotator rotator)
{
	Spawn(class'BloodSplat',,, Location, rotator);
}

function SpawnHitWaterDecal()
{
	Spawn(class'WaterRingBlood',,, Location + CollisionHeight * Vect(0,0,1));
}

simulated function PreBeginPlay()
{
	if (Level.Game.bLowGore || Level.Game.bVeryLowGore) 	// Gore check
	{
		Destroy();
		return;
	}

	Super.PreBeginPlay();

	Velocity = VRand() * 200; //CyberP: faster blood
	if(Velocity == Vect(0.0,0.0,0.0))
		Velocity = Vect(1.0,1.0,1.0) + (Location * 100.0);

	if (Instigator != None)
		Velocity += Instigator.Velocity / 2;

	DrawScale = 0.75 + FRand();
	SetRotation(Rotator(Velocity));
}

defaultproperties
{
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.BloodDrop'
     DrawScale=0.750000
     ScaleGlow=0.700000
}
