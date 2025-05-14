//=============================================================================
// RocketLAW.
//=============================================================================
class RocketLAW extends Rocket;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if (( Level.NetMode != NM_Standalone ) && (Class == Class'RocketLAW'))
	{
		SoundRadius = 192;
	}
}

defaultproperties
{
     blastRadius=768.000000
     ItemName="LAW Rocket"
     MaxSpeed=1300.000000
     Damage=1000.000000
     MomentumTransfer=40000
     SpawnSound=Sound'DeusExSounds.Robot.RobotFireRocket'
     ImpactSound=Sound'DeusExSounds.Generic.LargeExplosion2'
     Mesh=LodMesh'DeusExItems.RocketLAW'
     DrawScale=1.000000
     AmbientSound=Sound'DeusExSounds.Weapons.LAWApproach'
}
