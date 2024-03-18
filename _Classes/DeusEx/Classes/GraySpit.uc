//=============================================================================
// GraySpit.
//=============================================================================
class GraySpit extends DeusExProjectile;

simulated function Tick(float deltaTime)
{
	time += deltaTime;

	// scale it up as it flies
	DrawScale = FClamp(2.0*(time+1.0), 1.0, 20.0); //CyberP: modded
}

defaultproperties
{
     DamageType=Radiation
     maxRange=1400
     bIgnoresNanoDefense=True
     speed=1000.000000
     MaxSpeed=1200.000000
     Damage=20.000000
     MomentumTransfer=200
     SpawnSound=Sound'DeusExSounds.Animal.GrayShoot'
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.GraySpit'
     ScaleGlow=2.000000
     bFixedRotationDir=True
     RotationRate=(Pitch=0,Yaw=0,Roll=131071)
}
