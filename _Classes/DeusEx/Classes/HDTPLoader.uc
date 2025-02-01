//=============================================================================
// HDTPLoader
// Dynamically loads HDTP assets
//=============================================================================
class HDTPLoader extends Object;

//Gets a texture
static function Texture GetTexture(string tex)
{
    //log("Getting firetexture: " $ tex);
	return Texture(DynamicLoadObject(tex, class'Texture', true));
}

static function Texture GetWetTexture(string tex)
{
    //log("Getting wettexture: " $ tex);
	return WetTexture(DynamicLoadObject(tex, class'WetTexture', true));
}

static function Texture GetFireTexture(string tex)
{
    //log("Getting texture: " $ tex);
	return FireTexture(DynamicLoadObject(tex, class'FireTexture', true));
}

//Gets a mesh
static function LodMesh GetMesh(string m)
{
    //log("Getting mesh: " $ m);
	return LodMesh(DynamicLoadObject(m, class'LodMesh', true));
}

//Gets a mesh, or a backup mesh if the first one fails
static function LodMesh GetMesh2(string m, string m2, bool first, optional bool debug)
{
    local LodMesh MMesh;
    if (first)
        MMesh = LodMesh(DynamicLoadObject(m, class'LodMesh', !debug));
    if (MMesh == None)
        MMesh = LodMesh(DynamicLoadObject(m2, class'LodMesh', !debug));
    if (debug)
        log("Getting mesh: " $ m $ ", " $ m2 $ ", " $ first);
    return MMesh;
}

//Gets a texture, or a backup texture if the first one fails
static function Texture GetTexture2(string tex, string alternative, bool first, optional bool debug)
{
    local Texture TTex;

    //Dirty hack
    if (alternative == "Engine.S_Inventory")
        alternative = "";

    if (first)
        TTex = Texture(DynamicLoadObject(tex, class'Texture', !debug));
    if (TTex == None)
        TTex = Texture(DynamicLoadObject(alternative, class'Texture', !debug));
    //log("Getting tex: " $ tex $ ", " $ alternative $ ", " $ first);
	return TTex;
}

static function bool HDTPInstalled(optional bool debug)
{
    if (debug)
        log("Checking HDTP installed");
	return Texture(DynamicLoadObject("HDTPDecos.Skins.HDTPBarrel1Tex10", class'Texture', true)) != None;
}

