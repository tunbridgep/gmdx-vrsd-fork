//=============================================================================
// Poolball.
//=============================================================================
class Poolball extends DeusExDecoration;

enum ESkinColor
{
	SC_1,
	SC_2,
	SC_3,
	SC_4,
	SC_5,
	SC_6,
	SC_7,
	SC_8,
	SC_9,
	SC_10,
	SC_11,
	SC_12,
	SC_13,
	SC_14,
	SC_15,
	SC_Cue
};

var() ESkinColor SkinColor;
var bool bJustHit;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_1:		Multiskins[1] = Texture'HDTPPoolballTex1'; break;
		case SC_2:		Multiskins[1] = Texture'HDTPPoolballTex2'; break;
		case SC_3:		Multiskins[1] = Texture'HDTPPoolballTex3'; break;
		case SC_4:		Multiskins[1] = Texture'HDTPPoolballTex4'; break;
		case SC_5:		Multiskins[1] = Texture'HDTPPoolballTex5'; break;
		case SC_6:		Multiskins[1] = Texture'HDTPPoolballTex6'; break;
		case SC_7:		Multiskins[1] = Texture'HDTPPoolballTex7'; break;
		case SC_8:		Multiskins[1] = Texture'HDTPPoolballTex8'; break;
		case SC_9:		Multiskins[1] = Texture'HDTPPoolballTex9'; break;
		case SC_10:		Multiskins[1] = Texture'HDTPPoolballTex10'; break;
		case SC_11:		Multiskins[1] = Texture'HDTPPoolballTex11'; break;
		case SC_12:		Multiskins[1] = Texture'HDTPPoolballTex12'; break;
		case SC_13:		Multiskins[1] = Texture'HDTPPoolballTex13'; break;
		case SC_14:		Multiskins[1] = Texture'HDTPPoolballTex14'; break;
		case SC_15:		Multiskins[1] = Texture'HDTPPoolballTex15'; break;
		case SC_Cue:	Multiskins[1] = Texture'HDTPPoolballTex16'; break;
	}
}

function Tick(float deltaTime)
{
	local float speed;

	speed = VSize(Velocity);

	if ((speed >= 0) && (speed < 5))
	{
		bFixedRotationDir = False;
		Velocity = vect(0,0,0);
	}
	else if (speed >= 5)
	{
		bFixedRotationDir = True;
		SetRotation(Rotator(Velocity));
		RotationRate.Pitch = speed * 60000;
	}
}

event HitWall(vector HitNormal, actor HitWall)
{
	local Vector newloc;

	// if we hit the ground, make sure we are rolling
	if (HitNormal.Z == 1.0)
	{
		SetPhysics(PHYS_Rolling, HitWall);
		if (Physics == PHYS_Rolling)
		{
			bFixedRotationDir = False;
			Velocity = vect(0,0,0);
			return;
		}
	}

	Velocity = 0.9*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	Velocity.Z = 0;
	newloc = Location + HitNormal;	// move it out from the wall a bit
	SetLocation(newloc);
}

function Timer()
{
	bJustHit = False;
}

function Bump(actor Other)
{
	local Vector HitNormal;

	if (Other.IsA('Poolball'))
	{
		if (!Poolball(Other).bJustHit)
		{
			PlaySound(sound'PoolballClack', SLOT_None);
			HitNormal = Normal(Location - Other.Location);
			Velocity = HitNormal * VSize(Other.Velocity);
			Velocity.Z = 0;
			//bJustHit = True;
			//Poolball(Other).bJustHit = True;
			SetTimer(0.02, False);
			Poolball(Other).SetTimer(0.02, False);
		}
	}
}

function Frob(Actor Frobber, Inventory frobWith)
{
	Velocity = Normal(Location - Frobber.Location) * 500;
	Velocity.Z = 0;
}

defaultproperties
{
     bInvincible=True
     bCanBeBase=True
     ItemName="Poolball"
     bPushable=False
     Physics=PHYS_Rolling
     Mesh=LodMesh'HDTPDecos.HDTPPoolball'
     CollisionRadius=1.700000
     CollisionHeight=1.700000
     bBounce=True
     Mass=5.000000
     Buoyancy=2.000000
}
