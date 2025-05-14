//=============================================================================
// RocketRobot.
//=============================================================================
class RocketRobot extends Rocket;

function PostBeginPlay()                                                        //RSD: revert nerfed damage/blast radius on Hardcore
{
	local DeusExPlayer player;

    Super.PostBeginPlay();

	player = DeusExPlayer(GetPlayerPawn());

	if (player != None && player.bHardCoreMode)
	{
		Damage = 240;
		blastRadius = 384.000000;
	}
}

defaultproperties
{
     blastRadius=240.000000
     bTracking=False
     speed=1600.000000
     MaxSpeed=1600.000000
     Damage=100.000000
     SpawnSound=Sound'DeusExSounds.Robot.RobotFireRocket'
     Mesh=LodMesh'DeusExItems.RocketLAW'
     DrawScale=0.750000
     CollisionRadius=4.000000
     CollisionHeight=4.000000
}
