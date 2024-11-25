//=============================================================================
// HDTPLoader
// Dynamically loads HDTP assets
//=============================================================================
class HDTPLoader extends Object;

//Gets a texture
static function Texture GetTexture(string tex)
{
	return Texture(DynamicLoadObject(tex, class'Texture', false));
}

//Gets a mesh
static function LodMesh GetMesh(string m)
{
	return LodMesh(DynamicLoadObject(m, class'LodMesh', false));
}

//Gets a mesh, or a backup mesh if the first one fails
static function LodMesh GetMesh2(string m, string m2, bool first)
{
    local LodMesh MMesh;
    if (first)
        MMesh = LodMesh(DynamicLoadObject(m, class'LodMesh', true));
    if (MMesh == None)
        MMesh = LodMesh(DynamicLoadObject(m2, class'LodMesh', false));
    return MMesh;
}

//Gets a texture, or a backup texture if the first one fails
static function Texture GetTexture2(string tex, string alternative, bool first)
{
    local Texture TTex;
    if (first)
        TTex = Texture(DynamicLoadObject(tex, class'Texture', true));
    if (TTex == None)
        TTex = Texture(DynamicLoadObject(alternative, class'Texture', false));
	return TTex;
}

static function bool HDTPInstalled()
{
	return Texture(DynamicLoadObject("HDTPDecos.Skins.HDTPBarrel1Tex10", class'Texture', true)) != None;
}

