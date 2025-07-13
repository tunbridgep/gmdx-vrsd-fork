//SARGE: Since we can't modify the Effects class directly,
//Make a new one that incorporates all of our special HDTP code
class GMDXEffect expands Effects abstract;

//SARGE: HDTP Model toggles
var string HDTPSkin;
var string HDTPTexture;
var string HDTPMesh;
//The weapon we're looking at to determine if we should draw as HDTP or not
var class<DeusExWeapon> hdtpReference;

static function bool IsHDTP(optional bool bAllowEffects)
{
    if (!class'DeusExPlayer'.static.IsHDTPInstalled())
        return false;
    return default.hdtpReference == None || default.hdtpReference.default.iHDTPModelToggle > 0 || (bAllowEffects && class'DeusExPlayer'.default.bHDTPEffects);
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
    UpdateHDTPSettings();
}

function UpdateHDTPSettings()
{
    if (HDTPMesh != "")
        Mesh = class'HDTPLoader'.static.GetMesh2(HDTPMesh,string(default.Mesh),IsHDTP());
    if (HDTPSkin != "")
        Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());
    if (HDTPTexture != "")
        Texture = class'HDTPLoader'.static.GetTexture2(HDTPTexture,string(default.Texture),IsHDTP());
}
