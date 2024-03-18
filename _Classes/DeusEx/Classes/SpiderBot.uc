//=============================================================================
// SpiderBot.
//=============================================================================
class SpiderBot extends Robot;

function PlayDisabled()
{
	PlayAnim('Disabled1', 0.5);
}

defaultproperties
{
     EMPHitPoints=200
     maxRange=2000.000000
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponSpiderBot')
     InitialInventory(1)=(Inventory=Class'DeusEx.AmmoBattery',Count=99)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponRobotSpiderLauncher')
     InitialInventory(3)=(Inventory=Class'DeusEx.WeaponMJ12Rocket')
     WalkSound=Sound'DeusExSounds.Robot.SpiderBotWalk'
     walkAnimMult=1.500000
     runAnimMult=1.500000
     bTank=True
     GroundSpeed=200.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=500
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'GMDXSFX.Generic.bouncemetal'
     DrawType=DT_Mesh
     Mesh=LodMesh'HDTPCharacters.HDTPspiderbot'
     CollisionRadius=111.930000
     CollisionHeight=50.790001
     Mass=1000.000000
     Buoyancy=100.000000
     BindName="SpiderBot"
     FamiliarName="SpiderBot"
     UnfamiliarName="SpiderBot"
}
