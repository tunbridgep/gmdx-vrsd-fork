//=============================================================================
// WaterDrop.
//=============================================================================
class WaterDrop extends BaseDroplet;

function SpawnHitWallDecal(Rotator rotator)
{
	Spawn(class'WaterPoolTiny',,, Location, rotator);
}

function SpawnHitWaterDecal()
{
	Spawn(class'WaterRingTiny',,, Location + CollisionHeight * Vect(0,0,1));
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	Velocity = VRand() * 1.1;
	if (Instigator != None)
		Velocity += Instigator.Velocity / 2;

	DrawScale = 0.8 + FRand();
	SetRotation(Rotator(Velocity));
}

defaultproperties
{
     Style=STY_Translucent
     Skin=Texture'Effects.Generated.WtrDrpSmall'
     Mesh=LodMesh'DeusExItems.BloodDrop'
     DrawScale=0.600000
     ScaleGlow=0.600000
}
