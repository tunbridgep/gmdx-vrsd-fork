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

function UpdateHDTPSettings()
{
	Super.UpdateHDTPSettings();

    if (IsHDTP())
    {
        switch (SkinColor)
        {
            case SC_Clean:	MultiSkins[1] = class'HDTPLoader'.static.GetTexture("HDTPDecos.CleanHDTPToiletTex1");
                            MultiSkins[2] = class'HDTPLoader'.static.GetTexture("HDTPDecos.CleanHDTPToiletTex2");
                            MultiSkins[3] = class'HDTPLoader'.static.GetTexture("HDTPDecos.CleanToiletWaterTex"); break;

            case SC_Filthy:	MultiSkins[1] = class'HDTPLoader'.static.GetTexture("HDTPDecos.DirtyDTPToiletTex1");
                            MultiSkins[2] = class'HDTPLoader'.static.GetTexture("HDTPDecos.DirtyDTPToiletTex2");
                            MultiSkins[3] = class'HDTPLoader'.static.GetTexture("HDTPDecos.DirtyToiletWaterTex"); break;
        }
    }
    else
    {
        switch (SkinColor)
        {
            case SC_Clean:	Skin = class'HDTPLoader'.static.GetTexture("DeusExDeco.ToiletTex1"); break;
            case SC_Filthy: Skin = class'HDTPLoader'.static.GetTexture("DeusExDeco.ToiletTex2"); break;
        }
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
     HDTPMesh="HDTPDecos.HDTPToilet"
     Mesh=LodMesh'DeusExDeco.Toilet'
     CollisionRadius=28.000000
     CollisionHeight=23.000000
     Mass=100.000000
     Buoyancy=5.000000
	 bHDTPFailsafe=False
}
