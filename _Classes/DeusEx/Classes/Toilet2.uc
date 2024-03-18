//=============================================================================
// Toilet2.
//=============================================================================
class Toilet2 extends DeusExDecoration;

enum ESkinColor
{
	SC_Clean,
	SC_Filthy
};

var() ESkinColor SkinColor;
var bool bUsing;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_Clean:	MultiSkins[1] = Texture'CleanUrinalTex'; break;
		case SC_Filthy:	MultiSkins[1] = Texture'DirtyUrinalTex'; break;
	}
}

function Timer()
{
	bUsing = False;
}

function Frob(actor Frobber, Inventory frobWith)
{
	Super.Frob(Frobber, frobWith);

	if (bUsing)
		return;

	SetTimer(2.0, False);
	bUsing = True;

	PlaySound(sound'FlushUrinal',,,, 256);
	PlayAnim('Flush');
}

defaultproperties
{
     bInvincible=True
     bCanBeBase=True
     ItemName="Urinal"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'HDTPDecos.HDTPToilet2'
     CollisionRadius=18.000000
     CollisionHeight=23.000000
     Mass=100.000000
     Buoyancy=5.000000
}
