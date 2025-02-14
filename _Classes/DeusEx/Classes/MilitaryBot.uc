//=============================================================================
// MilitaryBot.
//=============================================================================
class MilitaryBot extends Robot;

var transient bool bPlayedSound1;
var transient bool bPlayedSound2;

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
		case SC_UNATCO:
            if (IsHDTP())
            {
                Skin = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPMilbottex1");
                Multiskins[1] = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPMilbottex2");
            }
            else
            {
                Skin = class'HDTPLoader'.static.GetTexture("DeusExCharacters.MilitaryBotTex1");
                Multiskins[1] = None;
            }
            break;

		case SC_Chinese:
            if (IsHDTP())
            {
                Skin = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPMilbottex1HK");
                Multiskins[1] = class'HDTPLoader'.static.GetTexture("HDTPCharacters.Skins.HDTPMilbottex2HK");
            }
            else
            {
                Skin = class'HDTPLoader'.static.GetTexture("DeusExCharacters.MilitaryBotTex2");
                Multiskins[1] = None;
            }
            break;
	}
}

function Tick(float deltaTime)
{
   Super.Tick(deltaTime);

   if ((AnimSequence=='Walk')||(AnimSequence=='Run'))
   {

      if ((AnimFrame>=0.05)&&(AnimFrame<0.5)&&(!bPlayedSound1))
      {
         bPlayedSound1=True;
         bPlayedSound2=False;
         PlayFootStep();
      }
      else if ((AnimFrame>=0.5)&&(!bPlayedSound2))
      {
         bPlayedSound2=True;
         bPlayedSound1=False;
         PlayFootStep();
      }
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
   function BeginState()
	{
	  local DeusExPlayer playa;

	  playa = DeusExPlayer(GetPlayerPawn());
	  if (playa != None && playa.bHardCoreMode)
	  {
      GroundSpeed = default.GroundSpeed*2;
      WalkAnimMult = default.walkAnimMult*1.6;
      RunAnimMult = default.runAnimMult*1.6;
      }
      super.BeginState();
	}
   function EndState()
	{
      GroundSpeed = default.GroundSpeed;
      WalkAnimMult = default.walkAnimMult;
      RunAnimMult = default.runAnimMult;
      super.EndState();
	}
}

defaultproperties
{
     SearchingSound=Sound'DeusExSounds.Robot.MilitaryBotSearching'
     SpeechTargetAcquired=Sound'DeusExSounds.Robot.MilitaryBotTargetAcquired'
     SpeechTargetLost=Sound'DeusExSounds.Robot.MilitaryBotTargetLost'
     SpeechOutOfAmmo=Sound'DeusExSounds.Robot.MilitaryBotOutOfAmmo'
     SpeechCriticalDamage=Sound'DeusExSounds.Robot.MilitaryBotCriticalDamage'
     SpeechScanning=Sound'DeusExSounds.Robot.MilitaryBotScanning'
     EMPHitPoints=200
     explosionSound=Sound'DeusExSounds.Robot.MilitaryBotExplode'
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponRobotMachinegun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=24)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponRobotRocket')
     InitialInventory(3)=(Inventory=Class'DeusEx.AmmoRocketRobot',Count=10)
     WalkSound=Sound'DeusExSounds.Robot.MilitaryBotWalk'
     bTank=True
     GroundSpeed=44.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=600
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawType=DT_Mesh
     HDTPMesh="HDTPCharacters.HDTPMilbot"
     Mesh=LodMesh'DeusExCharacters.MilitaryBot'
     SoundRadius=224
     SoundVolume=224
     CollisionRadius=80.000000
     CollisionHeight=79.000000
     Mass=2000.000000
     Buoyancy=100.000000
     RotationRate=(Yaw=10000)
     BindName="MilitaryBot"
     FamiliarName="Military Bot"
     UnfamiliarName="Military Bot"
}
