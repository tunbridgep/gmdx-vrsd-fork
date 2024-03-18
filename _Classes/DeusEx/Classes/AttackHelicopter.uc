//=============================================================================
// AttackHelicopter.
//=============================================================================
class AttackHelicopter extends Vehicles;

auto state Flying
{
	function BeginState()
	{
		Super.BeginState();
		LoopAnim('Fly');
	}
}

function Tick(float deltaTime)
{
  local float        ang;
  local rotator      rot;

  super.Tick(deltaTime);

  if (!IsInState('Interpolating')) //CyberP/Totalitarian: subtle hover effect
  {
		ang = 2 * Pi * Level.TimeSeconds / 4.0;
		rot = origRot;

		rot.Pitch += Sin(ang) * 48;
		rot.Roll += Cos(ang) * 48;
		rot.Yaw += Sin(ang) * 32;

		SetRotation(rot);
  }
}

singular function SupportActor(Actor standingActor)
{
	// kill whatever lands on the blades
	if (standingActor != None)
		standingActor.TakeDamage(10000, None, standingActor.Location, vect(0,0,0), 'Exploded');
}

defaultproperties
{
     ItemName="Attack Helicopter"
     Mesh=LodMesh'DeusExDeco.AttackHelicopter'
     SoundRadius=160
     SoundVolume=255
     AmbientSound=Sound'Ambient.Ambient.Helicopter'
     CollisionRadius=461.230011
     CollisionHeight=87.839996
     Mass=6000.000000
     Buoyancy=1000.000000
}
