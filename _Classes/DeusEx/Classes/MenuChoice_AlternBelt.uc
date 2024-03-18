//-----------------------------------------------------------
//CyberP: IW=like belt behaviour
//-----------------------------------------------------------
class MenuChoice_AlternBelt extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bAlternateToolbelt));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bAlternateToolbelt = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bAlternateToolbelt));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="If true, belt selection uses 'interact' (default: right click) to confirm selection, eliminating the act of cycling multiple items before reaching the desired. Default belt is also improved so experiment to form a preference."
     actionText="|&Invisible War Toolbelt"
}
