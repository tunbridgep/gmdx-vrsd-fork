//-----------------------------------------------------------
//CyberP: Enable Disable translucency for carried deco
//-----------------------------------------------------------
class MenuChoice_ObjectTranslucency extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bNoTranslucency));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bNoTranslucency = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bNoTranslucency));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="Immersion/simulation option. If set to Enabled, carried objects are no longer translucent."
     actionText="|&Toggle Object Translucency"
}
