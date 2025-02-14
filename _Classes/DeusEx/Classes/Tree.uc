//=============================================================================
// Tree.
//=============================================================================
class Tree extends OutdoorThings
	abstract;

var string Altmesh;

var() float soundFreq;		// chance of making a sound every 5 seconds

function Timer()
{
	if (FRand() < soundFreq)
	{
		// play wind sounds at random pitch offsets
		if (FRand() < 0.5)
			PlaySound(sound'WindGust1', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
		else
			PlaySound(sound'WindGust2', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(4.0 + 2.0 * FRand(), True);
}

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (IsHDTP() && altmesh != "")
    {
        if(location.X + location.Y %2 > 0)
        {
            mesh = class'HDTPLoader'.static.GetMesh(altmesh);
            multiskins[2] = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPTreeTex3");
        }
        else
            multiskins[2] = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPTreeTex2");
    }
}

defaultproperties
{
     soundFreq=0.200000
     ItemName="Tree"
     bStatic=False
     Mass=2000.000000
     Buoyancy=5.000000
	 bHDTPFailsafe=False
}
