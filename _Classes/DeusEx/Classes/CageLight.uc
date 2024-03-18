//=============================================================================
// CageLight.
//=============================================================================
class CageLight extends DeusExDecoration;

enum ESkinColor
{
	SC_1,
	SC_2,
	SC_3,
	SC_4,
	SC_5,
	SC_6
};

var() ESkinColor SkinColor;
var() bool bOn;
var bool bUsing;

function Trigger(Actor Other, Pawn Instigator)
{
	Super.Trigger(Other, Instigator);

	if (!bOn)
	{
		bOn = True;
		LightType = LT_Steady;
		bUnlit = True;
		ScaleGlow = 2.0;
	}
	else
	{
		bOn = False;
		LightType = LT_None;
		bUnlit = False;
		ScaleGlow = 1.0;
	}
}

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_1:	Multiskins[1] = Texture'HDTPCageLightTex1'; Multiskins[2] = Texture'HDTPCageLightTex1'; break;
		case SC_2:	Multiskins[1] = Texture'HDTPCageLightTex2'; Multiskins[2] = Texture'HDTPCageLightTex2'; break;
		case SC_3:	Multiskins[1] = Texture'HDTPCageLightTex3'; Multiskins[2] = Texture'HDTPCageLightTex3'; break;
		case SC_4:	Multiskins[1] = Texture'HDTPCageLightTex4'; Multiskins[2] = Texture'HDTPCageLightTex4'; break;
		case SC_5:	Multiskins[1] = Texture'HDTPCageLightTex5'; Multiskins[2] = Texture'HDTPCageLightTex5'; break;
		case SC_6:	Multiskins[1] = Texture'HDTPCageLightTex6'; Multiskins[2] = Texture'HDTPCageLightTex6'; break;
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (!bOn)
		LightType = LT_None;
}

/*function Frob(actor Frobber, Inventory frobWith)
{
local vector armLoc;

	Super.Frob(Frobber, frobWith);

	if (bUsing || !bHighlight)
		return;

	SetTimer(2.0, False);
	bUsing = True;

	if (Frobber.IsA('Pawn'))
	{
	    armLoc.X = Pawn(Frobber).Location.X + (CollisionRadius*0.5);
        armLoc.Y = Pawn(Frobber).Location.Y + (CollisionRadius*0.75);
	    armLoc.Z = Pawn(Frobber).Location.Z;
	    Pawn(Frobber).TakeDamage(3, Pawn(Frobber), armLoc, vect(0,0,0), 'Burned');
	}
}*/

function Timer()
{
	bUsing = False;
}

defaultproperties
{
     bOn=True
     bInvincible=True
     FragType=Class'DeusEx.GlassFragment'
     bCanBeBase=True
     ItemName="Light Fixture"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'HDTPDecos.HDTPCageLight'
     ScaleGlow=2.000000
     CollisionRadius=17.139999
     CollisionHeight=17.139999
     LightType=LT_Steady
     LightBrightness=255
     LightHue=32
     LightSaturation=224
     LightRadius=8
     Mass=20.000000
     Buoyancy=10.000000
}
