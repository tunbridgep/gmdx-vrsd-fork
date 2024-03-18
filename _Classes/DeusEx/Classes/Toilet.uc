//=============================================================================
// Toilet.
//=============================================================================
class Toilet extends DeusExDecoration;

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
		case SC_Clean:	MultiSkins[1] = Texture'CleanHDTPToiletTex1';
                        MultiSkins[2] = Texture'CleanHDTPToiletTex2';
                        MultiSkins[3] = Texture'CleanToiletWaterTex'; break;

		case SC_Filthy: MultiSkins[1] = Texture'DirtyHDTPToiletTex1';
                        MultiSkins[2] = Texture'DirtyHDTPToiletTex2';
                        MultiSkins[3] = Texture'DirtyToiletWaterTex'; break;
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

	SetTimer(9.0, False);
	bUsing = True;

	PlaySound(sound'FlushToilet',,,, 256);
	PlayAnim('Flush');
}

defaultproperties
{
     bInvincible=True
     bCanBeBase=True
     ItemName="Toilet"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'HDTPDecos.HDTPToilet'
     CollisionRadius=28.000000
     CollisionHeight=23.000000
     Mass=100.000000
     Buoyancy=5.000000
}
