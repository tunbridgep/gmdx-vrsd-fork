//=============================================================================
// Doberman.
//=============================================================================
class Doberman extends Dog;

// fake a charge attack using bump
function Bump(actor Other)
{
	local DeusExWeapon dxWeapon;
	local DeusExPlayer dxPlayer;
	local float        damage;

	Super.Bump(Other);

	if (IsInState('Attacking') && (Other != None) && (Other == Enemy))
	{
		// damage both of the player's legs if the karkian "charges"
		// just use Shot damage since we don't have a special damage type for charged
		// impart a lot of momentum, also
		if (VSize(Velocity) > 40)
		{
			dxWeapon = DeusExWeapon(Weapon);
			if ((dxWeapon != None) && dxWeapon.IsA('WeaponDogBite') && (FireTimer <= 0))
			{
				FireTimer = DeusExWeapon(Weapon).AIFireDelay;
				damage = VSize(Velocity) / 6;
				if (FRand() < 0.5) //CyberP: only damage one leg per bump.
				{
				Other.TakeDamage(damage*0.8, Self, Other.Location+vect(1,1,-1), 100*Velocity, 'Shot');
				PlaySound(Sound'DeusExSounds.Animal.DogAttack2',SLOT_None);
				}
				else
				{
				Other.TakeDamage(damage*0.8, Self, Other.Location+vect(-1,-1,-1), 100*Velocity, 'Shot');
				PlaySound(Sound'DeusExSounds.Animal.DogAttack1',SLOT_None);
				}
				dxPlayer = DeusExPlayer(Other);
				if (dxPlayer != None)
					dxPlayer.ShakeView(0.1 + 0.002*damage*0.4, damage*16*0.4, 0.3*damage*0.4);
			}
		}
	}
}

function PlayDogBark()
{
	if (FRand() < 0.5)
		PlaySound(sound'DogLargeBark2', SLOT_None);
	else
		PlaySound(sound'DogLargeBark3', SLOT_None);
}

function PostBeginPlay()
{
super.PostBeginPlay();

if (GroundSpeed < 400)
GroundSpeed = 400;
if (RotationRate.Yaw != 90000)
    RotationRate.Yaw = 90000; //CyberP: turn faster
}

//Allow dobermen to be stomped always.
function bool WillTakeStompDamage(Actor stomper)
{
    return true;
}

defaultproperties
{
     CarcassType=Class'DeusEx.DobermanCarcass'
     WalkingSpeed=0.200000
     GroundSpeed=380.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Animal.DogLargeGrowl'
     HitSound2=Sound'DeusExSounds.Animal.DogLargeBark1'
     Die=Sound'DeusExSounds.Animal.DogLargeDie'
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.Doberman'
     CollisionRadius=31.000000
     CollisionHeight=28.000000
     Mass=25.000000
     BindName="Doberman"
     FamiliarName="Doberman"
     UnfamiliarName="Doberman"
}
