//=============================================================================
// MenuChoice_AlwaysRun
//=============================================================================

class MenuChoice_TextureFilter extends MenuChoice_EnabledDisabled;

var TextureFilterer TF;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
    local DeusExGameInfo info;

	Super.InitWindow();

    info = DeusExGameInfo(player.Level.Game);

    if (info != None)
        TF = TextureFilterer(info.GetModule(class'TextureFilterer'));
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!TF.bSmartTextureFiltering));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	TF.bSmartTextureFiltering = !bool(GetValue());
    TF.SaveConfig();
    TF.RefreshTextureFiltering();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!TF.bSmartTextureFiltering));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If set to Enabled, textures will have a blurred smoothed look."
     actionText="|&Texture Filtering"
}
