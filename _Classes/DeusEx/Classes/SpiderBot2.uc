//=============================================================================
// SpiderBot2.
//=============================================================================
class SpiderBot2 extends Robot;

var() bool bUpsideDown;
var SpiderBotFake spot;
var float walkTim, animTim;

function PostPostBeginPlay()
{
  super.PostPostBeginPlay();

  if (bUpsideDown)
  {
    if (spot != none)
       spot.Destroy();
    spot = Spawn(class'DeusEx.SpiderBotFake',self,,Location-Vect(0,0,-64));
    if (spot != None)
    {
       KillShadow();
       DrawScale = 0.001;
       Mass = 0;
    }
  }
}

function Tick(float deltaTime)
{
  local rotator rota;

  super.Tick(deltaTime);

  if (bUpsideDown)
  {
     //rota.Yaw = desiredRotation.Yaw;
     //rota.Roll = 32770;
     //rota.Pitch = desiredRotation.Pitch;
     //desiredRotation.Pitch=32770;
     //bRotateToDesired=True;
     //SetRotation(rota);
     if (Health <= 0 || EMPHitPoints <= 0)
     {
       if (Spot != None)
       {
         DrawScale = default.DrawScale;
         Mass = default.Mass;
         if (EMPHitPoints <= 0)
            TakeDamage(1000,none,vect(0,0,0),vect(0,0,0),'Exploded');
         spawnBurnDecal2();
         spot.Destroy();
       }
     }
     if (spot != None)
     {
       //BroadCastMessage("spot != None");
       rota.Pitch = Rotation.pitch*0.001;
       rota.Roll = 32770;
       rota.Yaw = Rotation.Yaw;
       spot.SetRotation(rota);
       spot.SetLocation(Location);
       if (VSize(Velocity) > 15)
       {
           walkTim+=deltaTime;
           animTim+=deltaTime;
           if (walkTim > 0.125)
           {
             walkTim = 0;
             PlaySound(Sound'DeusExSounds.Robot.SpiderBot2Walk',SLOT_None,,,1578,1.25+(FRand()*0.1));
           }
           if (animTim > 0.23)
           {
              animTim = 0;
              spot.PlayAnim('Walk');
           }
           //if (AnimSequence != AnimSequence)
       }
     }
     velocity.Z = 100;
     SetPhysics(PHYS_Flying);
  }
}

function AddVelocity( vector NewVelocity)
{
  if (bUpsideDown)
  {
	//if (Physics == PHYS_Walking)
	//	SetPhysics(PHYS_Falling);
	//if ( (Velocity.Z > 380) && (NewVelocity.Z > 0) )
	//	NewVelocity.Z *= 0.5;
	NewVelocity.Z = 0;
	Velocity += NewVelocity;
  }
  else
  {
    super.AddVelocity(NewVelocity);
  }
}

function spawnBurnDecal2()
{
local Vector HitLocation, HitNormal, EndTrace;
local Actor hit;
local ScorchMark mark;

    //CyberP: spawn a burn mark on the ceiling
    EndTrace = Location + vect(0,0,100);
    hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);
    mark = Spawn(class'DeusEx.ScorchMark', Self,, HitLocation, Rotator(HitNormal));
		if (mark != None && CollisionRadius != 0)
		{
			mark.DrawScale = CollisionRadius / 120;
			mark.ReattachDecal();
		}
}

defaultproperties
{
     EMPHitPoints=25
     maxRange=1040.000000
     MinRange=200.000000
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialAlliances(7)=(AllianceName=Player,AllianceLevel=-1.000000)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponSpiderBot2')
     InitialInventory(1)=(Inventory=Class'DeusEx.AmmoBattery',Count=99)
     WalkSound=Sound'DeusExSounds.Robot.SpiderBot2Walk'
     HDTPMesh="HDTPCharacters.HDTPspiderbot2"
     GroundSpeed=300.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=100
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'GMDXSFX.Generic.bouncemetal'
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.SpiderBot2'
     CollisionRadius=33.580002
     CollisionHeight=15.240000
     Mass=200.000000
     Buoyancy=50.000000
     BindName="MiniSpiderBot"
     FamiliarName="Mini-SpiderBot"
     UnfamiliarName="Mini-SpiderBot"
}
