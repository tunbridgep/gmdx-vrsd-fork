//=============================================================================
// SecurityBot3.
//=============================================================================
class SecurityBot3 extends Robot;

enum ESkinColor
{
	SC_UNATCO,
	SC_Chinese
};

var() ESkinColor SkinColor;

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
             if (bHardCoreMode)
                 EnemyTimeout = 11.000000;
             else
             {
                 EnemyTimeout = 8.000000;
                 if (combatDifficulty < 2.0)
                 {
                     EnemyTimeout = 7.000000;
                     GroundSpeed=80.000000;
                 }
                 else
                     GroundSpeed=110.000000;
             }
             super.DifficultyMod(CombatDifficulty,bHardCoreMode,bExtraHardcore,bFirstLevelLoad);
}

defaultproperties
{
     SpeechTargetAcquired=Sound'DeusExSounds.Robot.SecurityBot3TargetAcquired'
     SpeechTargetLost=Sound'DeusExSounds.Robot.SecurityBot3TargetLost'
     SpeechOutOfAmmo=Sound'DeusExSounds.Robot.SecurityBot3OutOfAmmo'
     SpeechCriticalDamage=Sound'DeusExSounds.Robot.SecurityBot3CriticalDamage'
     SpeechScanning=Sound'DeusExSounds.Robot.SecurityBot3Scanning'
     EMPHitPoints=40
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponRobotMachinegun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=50)
     CloakThreshold=120
     GroundSpeed=160.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=101
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawType=DT_Mesh
     HDTPMesh="HDTPCharacters.HDTPSecurityBot3"
     Mesh=LodMesh'DeusExCharacters.SecurityBot3'
     SoundRadius=32
     SoundVolume=160
     AmbientSound=Sound'DeusExSounds.Robot.SecurityBot3Move'
     CollisionRadius=25.350000
     CollisionHeight=28.500000
     Mass=1000.000000
     Buoyancy=100.000000
     BindName="SecurityBot3"
     FamiliarName="Security Bot"
     UnfamiliarName="Security Bot"
}
