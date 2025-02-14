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

exec function UpdateHDTPsettings()
{
    local Texture tex;
    super.UpdateHDTPsettings();

    switch (SkinColor)
    {
        case SC_1:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCageLightTex1","DeusExDeco.CageLightTex1",IsHDTP()); break;
        case SC_2:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCageLightTex2","DeusExDeco.CageLightTex2",IsHDTP()); break;
        case SC_3:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCageLightTex3","DeusExDeco.CageLightTex3",IsHDTP()); break;
        case SC_4:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCageLightTex4","DeusExDeco.CageLightTex4",IsHDTP()); break;
        case SC_5:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCageLightTex5","DeusExDeco.CageLightTex5",IsHDTP()); break;
        case SC_6:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPCageLightTex6","DeusExDeco.CageLightTex6",IsHDTP()); break;
    }

    if (IsHDTP())
    {
        MultiSkins[1] = tex;
        MultiSkins[2] = tex;
    }
    else
        Skin = tex;
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
     HDTPMesh="HDTPDecos.HDTPCageLight"
     Mesh=LodMesh'DeusExDeco.CageLight'
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
	 bHDTPFailsafe=False
     bHighlight=False
}
