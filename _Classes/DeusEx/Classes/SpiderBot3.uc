//=============================================================================
// SpiderBot2.
//=============================================================================
class SpiderBot3 extends Robot;

defaultproperties
{
     EMPHitPoints=15
     maxRange=1040.000000
     MinRange=200.000000
     WalkingSpeed=1.000000
     bHateInjury=False
     bEmitDistress=True
     MaxProvocations=10
     InitialAlliances(7)=(AllianceName=Player,AllianceLevel=-1.000000)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponSpiderBot3')
     InitialInventory(1)=(Inventory=Class'DeusEx.AmmoBattery',Count=99)
     WalkSound=Sound'DeusExSounds.Robot.SpiderBot2Walk'
     GroundSpeed=230.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=30
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'GMDXSFX.Generic.bouncemetal'
     Alliance=Bots
     DrawType=DT_Mesh
     Mesh=LodMesh'HDTPCharacters.HDTPspiderbot2'
     DrawScale=0.500000
     CollisionRadius=16.790001
     CollisionHeight=7.600000
     Mass=200.000000
     Buoyancy=50.000000
     BindName="MiniSpiderBot"
     FamiliarName="Mini-SpiderBot"
     UnfamiliarName="Mini-SpiderBot"
}
