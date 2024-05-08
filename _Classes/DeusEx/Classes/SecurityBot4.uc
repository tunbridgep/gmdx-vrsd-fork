//=============================================================================
// SecurityBot4.
//=============================================================================
class SecurityBot4 extends Robot;

//singular function Explode(vector HitLocation)
//{
//   super.Explode(HitLocation);
//   EMPHitPoints = 0;
//}

State Attacking
{
   //function BeginState()
   //{
   //  if (enemy != None && enemy.IsA('DeusExPlayer'))
   //      if (!DeusExPlayer(enemy).bHardCoreMode)
   //          bHasCloak = False;
   //}
   function EndState()
   {
	if (bHasCloak && bCloakOn && Orders != 'Attacking')
	{
      CloakThreshold = Health*0.4;
      EnableCloak(false);
    }
      super.EndState();
   }
}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
             if (bHardCoreMode)
             {
                EnemyTimeout = 12.000000;
                GroundSpeed = 280.000000;
                bReactLoudNoise = True;
                CloakThreshold = 110;
                if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
                {
                    Health = 200;
                    EMPHitPoints = 120;
                }
             }
             bNotFirstDiffMod = true;
}

/*function bool ShouldStrafe()                                                    //RSD: Hacked so we can get the robot backing up but not generally actually strafing
{
     local Rotator StrafeRot;
     local float yaw;

     if (destPoint != None)
     {
          strafeRot = Rotator(destPoint.Location - Location);
          yaw = modulo(strafeRot.Yaw+32768-Rotation.Yaw,65536)-32768;
          yaw = yaw*360.0/32768;
          BroadcastMessage(yaw);
          if (yaw < 7 || yaw > -7)
               return (AICanShoot(enemy, false, false, 0.025, true));
          else
               return false;
     }
     else
          return false;
}*/

function int modulo(int A, int B)                                               //RSD: Correct modular arithmetic on negative numbers
{
  if( A % B >= 0 )
    return A % B ;
  else
    return ( A % B ) + B ;
}

defaultproperties
{
     SpeechTargetAcquired=Sound'DeusExSounds.Robot.SecurityBot3TargetAcquired'
     SpeechTargetLost=Sound'DeusExSounds.Robot.SecurityBot3TargetLost'
     SpeechOutOfAmmo=Sound'DeusExSounds.Robot.SecurityBot3OutOfAmmo'
     SpeechCriticalDamage=Sound'DeusExSounds.Robot.SecurityBot3CriticalDamage'
     SpeechScanning=Sound'DeusExSounds.Robot.SecurityBot3Scanning'
     EMPHitPoints=60
     maxRange=3000.000000
     WalkingSpeed=1.000000
     bAvoidHarm=True
     bReactShot=True
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponRobotPlasmaGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.AmmoPlasma',Count=50)
     bHasCloak=True
     bTank=True
     GroundSpeed=220.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     MaxStepHeight=40.000000
     Health=140
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.SecurityBot4'
     SoundRadius=32
     SoundVolume=160
     AmbientSound=Sound'DeusExSounds.Robot.SpyBotMove'
     CollisionRadius=27.500000
     CollisionHeight=28.500000
     Mass=1000.000000
     Buoyancy=100.000000
     BindName="SecurityBot4"
     FamiliarName="Security Bot"
     UnfamiliarName="Security Bot"
}
