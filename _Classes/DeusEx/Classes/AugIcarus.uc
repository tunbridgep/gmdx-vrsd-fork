//=============================================================================
// AugIcarus.
//=============================================================================
class AugIcarus extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
var bool bDashing;
var float incremental;
var bool bDashed;
var bool bCooldown;

function Timer()
{
  bCooldown = False;
}

function PostBeginPlay()
{
  bCooldown = False;
}

state Active
{

function BeginState()
{
  super.BeginState();
  bCooldown = True;
}

function Tick(float deltaTime)
{
local vector EndTrace, StartTrace, HitLocation, HitNormal;
local LaserSpot spot;
local actor HitActor;

 if (!bDashing && !bDashed)
 {
 incremental +=  player.FrobTime;
 player.HeadRegion.Zone.ViewFog.Z = incremental * 0.125;
 player.Spawn(class'SphereEffectShield2');
 player.bCrosshairVisible = False;
 StartTrace = Player.Location;
 StartTrace.Z += Player.BaseEyeHeight;
 EndTrace = StartTrace + 96 * Vector(player.ViewRotation);
 HitActor = Trace(HitLocation, HitNormal, EndTrace);
 spot = Spawn(class'LaserSpot',player,,EndTrace, player.ViewRotation);
 if (spot != None)
 {
     spot.Skin=FireTexture'Effects.Laser.LaserSpot2';
     spot.DrawScale*= 0.3;
     spot.LightBrightness = 255;
     spot.LightHue = 156;
     spot.LightType = LT_Steady;
     spot.LightSaturation = 16;
     spot.LightRadius = 6;
     spot.LifeSpan = 0.05;
 }
 if (incremental >= 1.5 - player.AugmentationSystem.GetAugLevelValue(class'DeusEx.AugIcarus'))
 {
     bDashing = True;
     player.ClientFlash(900000,vect(0,0,255));
     player.PlaySound(Sound'GMDXSFX.Weapons.laserrfire',SLOT_None,,,,1.2);
     player.RocketTargetMaxDistance=40001.000000;
     player.DesiredFOV = player.default.DesiredFOV;
     player.Energy -= 3;
     player.bCrosshairVisible = True;
     if (player.Energy < 0)
         player.Energy = 0;
 }
 //if (incremental >= 1.0)
    //player.DesiredFOV = (incremental*3)+player.default.DesiredFOV;
 //else
    player.DesiredFOV = (incremental*4)+player.default.DesiredFOV;
 }
 else if (bDashing)
 {
    incremental += player.FrobTime;
    player.Velocity += Vector(player.ViewRotation) * 2150;
    if (player.Velocity.Z < 20 && player.Velocity.Z > -500)
       player.Velocity.Z = 20;
    else if (player.Velocity.Z > 1800)
       player.Velocity.Z = 1800;
    player.SetPhysics(PHYS_Falling);
    //player.Spawn(class'SphereEffectShield2');
    if (incremental >= 2.0 - player.AugmentationSystem.GetAugLevelValue(class'DeusEx.AugIcarus'))
    {
       bDashing = false;
       bDashed = False;
       incremental = 0;
       player.bIcarusClimb = True;
       player.RecoilShaker(vect(8,2,4));
       player.RocketTargetMaxDistance=40000.000000;
       player.DesiredFOV = player.default.DesiredFOV;
       player.HeadRegion.Zone.ViewFog.Z = 0;
       player.InstantFog = vect(0.1,0.1,0.1);
	   player.InstantFlash = 0.01;
	   player.ViewFlash(1.0);
	   player.Velocity = vect(0,0,0);
	   player.bInterpolating = true;
	   player.SetPhysics(PHYS_Interpolating);
	   player.bInterpolating = false;
	   player.SetPhysics(PHYS_Falling);
	   player.bInterpolating = true;
	   player.SetPhysics(PHYS_Interpolating);
	   player.bInterpolating = false;
	   player.SetPhysics(PHYS_Falling);
       Deactivate();
    }
 }
}

Begin:
player.PlaySound(sound'GMDXSFX.Generic.biomodoff',SLOT_None,1.2,,,0.4);
}

function Deactivate()
{
    if (bDashing)
       return;

    bDashing = false;
    bDashed = False;
    incremental = 0;
    player.DesiredFOV = player.default.DesiredFOV;
    player.HeadRegion.Zone.ViewFog.Z = 0;
    player.InstantFog   = vect(0.1,0.1,0.1);
    player.InstantFlash = 0.01;
    player.ViewFlash(1.0);
    SetTimer(1.5,false);
	Super.Deactivate();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
	}
}

defaultproperties
{
     mpAugValue=0.050000
     mpEnergyDrain=5.000000
     EnergyRate=340.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconEMP'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEMP_Small'
     AugmentationName="EMSP (Active)"
     Description="Electromagnetic Self-Propulsion|n|nCooled nanomachines assemble via the arms, spherically align and form a magnetic field that suspends the host, whereupon the field is electrified. The resulting deep frequency resonation and pole shift accelerates the suspended host with directed velocity. Test results have been exceptionally accurate and consistent in nanoscale measurement. |n|nCooldown Time: 1.5 Seconds|n|nTECH ONE: Charge time and energy drain is reduced slightly.|n|nTECH TWO: Charge time and energy drain is reduced moderately.|n|nTECH THREE: Charge time and energy drain is reduced significantly.|n|nTECH FOUR: Charge time and energy drain is optimal."
     MPInfo="When active, you only take 5% damage from EMP attacks.  Energy Drain: None"
     LevelValues(1)=0.500000
     LevelValues(2)=1.000000
     LevelValues(3)=1.480000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=3
}
