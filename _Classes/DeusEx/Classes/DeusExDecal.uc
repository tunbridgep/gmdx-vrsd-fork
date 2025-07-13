//=============================================================================
// DeusExDecal
//=============================================================================
class DeusExDecal extends Decal
	abstract;

//SARGE: HDTP Model toggles
var globalconfig int iHDTPModelToggle;
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;
var float HDTPDrawScale; //Can resize the DrawScale for HDTP
var float drawScaleMult; //Can modify the drawscale in code and have it apply to both HDTP and non-hdtp versions.
var bool bInitialHDTPUpdate;            //SARGE: Is true when we're initially updating HDTP on object creation, rather than doing it later via changing HDTP settings.

var bool bAttached, bStartedLife, bImportant;

function BeginPlay()
{
    UpdateHDTPsettings();
    bInitialHDTPUpdate = false;
    super.BeginPlay();
}
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1.0, false);
}

simulated function Timer()
{
	// Check for nearby players, if none then destroy self

	if ( !bAttached )
	{
		Destroy();
		return;
	}

	if ( !bStartedLife )
	{
		RemoteRole = ROLE_None;
		bStartedLife = true;
        if (class'DeusExPlayer'.default.iPersistentDebris >= 2) //SARGE: Stick around forever, if we've enabled the setting.
            return;
		if ( Level.bDropDetail )
			SetTimer(5.0 + 2 * FRand(), false);
		else
			SetTimer(24.0 + 5 * FRand(), false);    //CyberP: decals last longer. Was 18.0 + 5
		return;
	}
	if ( Level.bDropDetail && (MultiDecalLevel < 6) )
	{
		if ( (Level.TimeSeconds - LastRenderedTime > 0.35)
			|| (!bImportant && (FRand() < 0.2)) )
			Destroy();
		else
		{
			SetTimer(1.0, true);
			return;
		}
	}
	else if ( Level.TimeSeconds - LastRenderedTime < 1 )
	{
		SetTimer(5.0, true);
		return;
	}
	Destroy();
}

function ReattachDecal(optional vector newrot)
{
	DetachDecal();
	if (newrot != vect(0,0,0))
		AttachDecal(32, newrot);
	else
		AttachDecal(32);
}

static function bool IsHDTP()
{
    return class'DeusExPlayer'.static.IsHDTPInstalled() && default.iHDTPModelToggle > 0;
}

//Need a new function so we can override while still doing the Reattach last;
function DoHDTP()
{
    DrawScale = default.DrawScale;
    if (IsHDTP() && HDTPDrawScale > 0.0 && (HDTPTexture != "" || HDTPSkin != ""))
        DrawScale = HDTPDrawScale;

    if (DrawScaleMult != 0.0)
        DrawScale *= DrawScaleMult;

    if (HDTPMesh != "")
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());
    if (HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),IsHDTP());

}

exec function UpdateHDTPsettings()
{
    DoHDTP();
    ReattachDecal();
}

defaultproperties
{
     bAttached=True
     bImportant=True
     MultiDecalLevel=3
     HDTPDrawScale=-1
     iHDTPModelToggle=1
     bInitialHDTPUpdate=true
}
