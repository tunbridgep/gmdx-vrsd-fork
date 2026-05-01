//=============================================================================
// SARGE: Skin Utils
// Functions to assist with skinning objects
// This replaces the horrible mess of spaghetti that dealt with HDTP updates,
// cloaking textures, blood, radar transparency, etc, across players, scriptedpawns,
// weapons, skilledtools, etc.
//=============================================================================
class SkinUtils extends Actor abstract;

// ----------------------------------------------------------------------
// GetStyleTexture()
// SARGE: Copied from ScriptedPawn
// ----------------------------------------------------------------------

static function Texture GetStyleTexture(ERenderStyle newStyle, optional texture oldTex, optional texture newTex)
{
	local texture defaultTex;

	if      (newStyle == STY_Translucent)
		defaultTex = Texture'BlackMaskTex';
	else if (newStyle == STY_Modulated)
		defaultTex = Texture'GrayMaskTex';
	else if (newStyle == STY_Masked)
		defaultTex = Texture'PinkMaskTex';
	else
		defaultTex = Texture'BlackMaskTex';

	if (oldTex == None)
		return defaultTex;
	else if (oldTex == Texture'BlackMaskTex')
		return Texture'BlackMaskTex';  // hack
	else if (oldTex == Texture'GrayMaskTex')
		return defaultTex;
	else if (oldTex == Texture'PinkMaskTex')
		return defaultTex;
	else if (newTex != None)
		return newTex;
	else
		return oldTex;

}

// ----------------------------------------------------------------------
// SetSkinStyle()
// SARGE: Copied from ScriptedPawn
// ----------------------------------------------------------------------

static function SetSkinStyle(Actor src, ERenderStyle newStyle, optional texture newTex, optional float newScaleGlow, optional bool bSetUnlit)
{
	local int     i;
	local texture curSkin;
	local texture oldSkin;

	if (newScaleGlow == 0)
		newScaleGlow = src.ScaleGlow;

	oldSkin = src.Skin;
	for (i=0; i<8; i++)
	{
		curSkin = src.GetMeshTexture(i);
        if (curSkin != None && curSkin.Name != 'PinkMaskTex')
        {
            src.MultiSkins[i] = GetStyleTexture(newStyle, curSkin, newTex);
            //Log("SetSkinStyle: " $ curSkin @ src.MultiSkins[i]);
        }
	}
	src.Skin      = GetStyleTexture(newStyle, src.Skin, newTex);
	src.ScaleGlow = newScaleGlow;
	src.Style     = newStyle;
}

// ----------------------------------------------------------------------
// ResetSkinStyle()
// SARGE: Copied from ScriptedPawn
// ----------------------------------------------------------------------

static function ResetSkinStyle(Actor src, optional bool bResetStyle)
{
	local int i;

	for (i=0; i<8; i++)
		src.MultiSkins[i] = src.Default.MultiSkins[i];
	src.Skin      = src.Default.Skin;
	src.ScaleGlow = src.Default.ScaleGlow;

    if (bResetStyle)
    {
        src.Style     = src.Default.Style;
        src.bUnlit     = src.Default.bUnlit;
    }
}

//SARGE: Remove glasses and frames textures for holograms and cloaked pawns.
//SARGE: For now only works with GM_Trench (checked in SetupSkin),
//but it makes things MUCH simpler. TODO: Make this generic, so that if
//Augmentique ever decides to implement random meshes for NPCs, this still works.
static function GlassesFix(Pawn P)
{
    //Log("Character: " $ P $ " doing glasses fix");

    if (P.Style == STY_Normal)
        return;

    if (P.Mesh == LodMesh'DeusExCharacters.GM_Trench' || P.Mesh == LodMesh'DeusExCharacters.GM_Trench_F' || string(P.Mesh) == "Augmentique.AMTGM_Trench")
    {
        //Log(P $ " Mesh: " $ string(P.Mesh));
        P.multiSkins[6] = GetStyleTexture(P.Style);
        P.multiSkins[7] = GetStyleTexture(P.Style);
        //Log(P $ " Multiskins[6]: " $ P.multiskins[6]);
    }
    else if (P.Mesh == LodMesh'RSDCrap.Fixed_Jumpsuit' || P.Mesh == LodMesh'DeusExCharacters.GM_Jumpsuit')
    {
        P.multiSkins[5] = GetStyleTexture(P.Style);
    }
    else if (P.Mesh == LodMesh'DeusExCharacters.GFM_TShirtPants')
    {
        P.multiSkins[3] = GetStyleTexture(P.Style);
        P.multiSkins[4] = GetStyleTexture(P.Style);
    }
    else if (P.Mesh == LodMesh'DeusExCharacters.GM_Suit')
    {
        P.multiSkins[5] = GetStyleTexture(P.Style);
        P.multiSkins[6] = GetStyleTexture(P.Style);
    }
    else if (P.Mesh == LodMesh'DeusExCharacters.GFM_SuitSkirt')
    {
        P.multiSkins[6] = GetStyleTexture(P.Style);
        P.multiSkins[7] = GetStyleTexture(P.Style);
    }
}
