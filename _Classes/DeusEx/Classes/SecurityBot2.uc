//=============================================================================
// SecurityBot2.
//=============================================================================
class SecurityBot2 extends Robot;

var bool bEnraged;
var float countdown;

enum ESkinColor
{
	SC_UNATCO,
	SC_Chinese
};

var() ESkinColor SkinColor;

exec function UpdateHDTPsettings()
{
	Super.UpdateHDTPsettings();

	switch (SkinColor)
	{
		case SC_UNATCO:		MultiSkins[1] = class'HDTPLoader'.static.GetTexture2("HDTPCharacters.HDTPSecbot2tex1","DeusExCharacters.SecurityBot2Tex1",IsHDTP()); break;
		case SC_Chinese:	MultiSkins[1] = class'HDTPLoader'.static.GetTexture2("HDTPCharacters.HDTPSecbot2tex2","DeusExCharacters.SecurityBot2Tex2",IsHDTP()); break;
	}
}

function PlayDisabled()
{
	local int rnd;

	rnd = Rand(3);
	if (rnd == 0)
		TweenAnimPivot('Disabled1', 0.2);
	else if (rnd == 1)
		TweenAnimPivot('Disabled2', 0.2);
	else
		TweenAnimPivot('Still', 0.2);
}

State Attacking
{
    function Tick(float deltaTime)
	{
	local float dista;
    local DeusExPlayer playa;

      super.Tick(deltaTime);

      if (Health < default.Health * 0.2 && !bEnraged && countdown == 0)
      {
         playa = DeusExPlayer(GetPlayerPawn());
               if (playa != None && playa.bHardCoreMode == False)
                   return;
         if (FRand() < 0.6)
         {
            countdown = -1;
            return;
         }
         if (enemy != None)
         {
            dista = Abs(VSize(Enemy.Location - Location));
            if (dista < 640 && Abs(Location.Z - Enemy.Location.Z) < 512)
            {
               PlaySound(SpeechCriticalDamage,SLOT_None,1.25,,1024);
               countdown = 6.0;
               bEnraged = True;
               GroundSpeed = default.GroundSpeed*3;
               WalkAnimMult = default.walkAnimMult*2;
               RunAnimMult = default.runAnimMult*2;
            }
         }
      }
      if (countdown > 0)
      {
         countdown-=deltaTime;
         if (countdown > 1.5 && countdown < 1.65)
         {
           if (GetStateName() != 'SelfDestruct')
           {
             GoToState('SelfDestruct');
             return;
           }
         }
      }
      if (bEnraged && countdown > 0)
      {
         if (Weapon != None && (Weapon.IsA('WeaponRobotMachineGun') || Weapon.IsA('WeaponFlamethrower')))
              Weapon.Destroy();
         dista = Abs(VSize(Enemy.Location - Location));
            if (dista < 288 && Abs(Enemy.Location.Z - Location.Z) < 512)
            {
              countdown = 1.45;
              bEnraged = false;
              if (GetStateName() != 'SelfDestruct')
                 GoToState('SelfDestruct');
            }

      }
	}
}

State SelfDestruct
{
 ignores bump, frob, reacttoinjury;

    function BeginState()
	{
		BlockReactions(true);
		bCanConverse = False;
		SeekPawn = None;
	}
   function Tick(float deltaTime)
   {
      local ThrownProjectile tp;

        Velocity.X = 0;
        Velocity.Y = 0;
        Acceleration = vect(0,0,0);
        countdown-=deltaTime;
        if (countdown < 0.4)
        {
          tp= spawn(class'LAM');
          if (tp != none)
          {
            tp.blastRadius = 756;
            tp.Explode(Location, vect(0,0,1));
          }
        }
   }
   Begin:
   PlaySound(Sound'TurretLocked',SLOT_None,1.25,,1024,0.4);
   Acceleration=vect(0,0,0);
   DesiredRotation=Rotation;
   FinishAnim();
   PlayAnim('disabled1',0.8,0.1);
}

defaultproperties
{
     SearchingSound=Sound'DeusExSounds.Robot.SecurityBot2Searching'
     SpeechTargetAcquired=Sound'DeusExSounds.Robot.SecurityBot2TargetAcquired'
     SpeechTargetLost=Sound'DeusExSounds.Robot.SecurityBot2TargetLost'
     SpeechOutOfAmmo=Sound'DeusExSounds.Robot.SecurityBot2OutOfAmmo'
     SpeechCriticalDamage=Sound'DeusExSounds.Robot.SecurityBot2CriticalDamage'
     SpeechScanning=Sound'DeusExSounds.Robot.SecurityBot2Scanning'
     EMPHitPoints=100
     explosionSound=Sound'DeusExSounds.Robot.SecurityBot2Explode'
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponRobotMachinegun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=50)
     WalkSound=Sound'DeusExSounds.Robot.SecurityBot2Walk'
     GroundSpeed=95.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     MaxStepHeight=18.000000
     Health=250
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawType=DT_Mesh
     HDTPMesh="HDTPCharacters.HDTPSecbot2"
     Mesh=LodMesh'DeusExCharacters.SecurityBot2'
     CollisionRadius=62.000000
     CollisionHeight=58.279999
     Mass=600.000000
     Buoyancy=100.000000
     BindName="SecurityBot2"
     FamiliarName="Security Bot"
     UnfamiliarName="Security Bot"
}
