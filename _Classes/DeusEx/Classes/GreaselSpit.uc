//=============================================================================
// GreaselSpit.
//=============================================================================
class GreaselSpit extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects

simulated function Tick(float DeltaTime)
{
	local SmokeTrail s;

	Super.Tick(DeltaTime);

	time += DeltaTime;
	if ((time > FRand() * 0.02) && (Level.NetMode != NM_DedicatedServer))
	{
		time = 0;

        DrawScale=FRand()/2;

		// spawn some trails
		s = Spawn(class'SmokeTrail',,, Location);
		if (s != None)
		{
			s.DrawScale = FRand() * 0.5;  //CyberP: 0.05
			s.OrigScale = s.DrawScale;
			s.Texture = Texture'Effects.Smoke.Gas_Poison_A';
			s.Velocity = VRand() * 50;
			s.OrigVel = s.Velocity;
		}
	}
}

defaultproperties
{
     DamageType=Poison
     AccurateRange=2500
     maxRange=3000
     bIgnoresNanoDefense=True
     speed=800.000000
     MaxSpeed=1400.000000
     Damage=8.000000
     MomentumTransfer=400
     SpawnSound=Sound'DeusExSounds.Animal.GreaselAttack'
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.GreaselSpit'
     SoundRadius=255
     SoundVolume=96
     SoundPitch=48
}
