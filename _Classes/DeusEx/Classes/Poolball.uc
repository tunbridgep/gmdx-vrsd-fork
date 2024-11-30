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

exec function UpdateHDTPsettings()
{
    local Texture tex;
	Super.UpdateHDTPsettings();

	switch (SkinColor)
	{
		case SC_1:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex1","DeusExDeco.PoolballTex1",IsHDTP()); break;
		case SC_2:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex2","DeusExDeco.PoolballTex2",IsHDTP()); break;
		case SC_3:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex3","DeusExDeco.PoolballTex3",IsHDTP()); break;
		case SC_4:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex4","DeusExDeco.PoolballTex4",IsHDTP()); break;
		case SC_5:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex5","DeusExDeco.PoolballTex5",IsHDTP()); break;
		case SC_6:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex6","DeusExDeco.PoolballTex6",IsHDTP()); break;
		case SC_7:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex7","DeusExDeco.PoolballTex7",IsHDTP()); break;
		case SC_8:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex8","DeusExDeco.PoolballTex8",IsHDTP()); break;
		case SC_9:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex9","DeusExDeco.PoolballTex9",IsHDTP()); break;
		case SC_10:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex10","DeusExDeco.PoolballTex10",IsHDTP()); break;
		case SC_11:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex11","DeusExDeco.PoolballTex11",IsHDTP()); break;
		case SC_12:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex12","DeusExDeco.PoolballTex12",IsHDTP()); break;
		case SC_13:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex13","DeusExDeco.PoolballTex13",IsHDTP()); break;
		case SC_14:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex14","DeusExDeco.PoolballTex14",IsHDTP()); break;
		case SC_15:		tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex15","DeusExDeco.PoolballTex15",IsHDTP()); break;
		case SC_Cue:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPPoolballTex16","DeusExDeco.PoolballTex16",IsHDTP()); break;
	}
    if (IsHDTP())
        Multiskins[1] = tex;
    else
        Skin = tex;
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
     HDTPMesh="HDTPDecos.HDTPPoolball"
     Mesh=LodMesh'DeusExDeco.Poolball'
     CollisionRadius=1.700000
     CollisionHeight=1.700000
     bBounce=True
     Mass=5.000000
     Buoyancy=2.000000
	 bHDTPFailsafe=False
}
