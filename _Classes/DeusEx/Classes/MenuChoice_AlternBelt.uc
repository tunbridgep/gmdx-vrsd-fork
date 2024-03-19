//-----------------------------------------------------------
//CyberP: IW=like belt behaviour
//-----------------------------------------------------------
class MenuChoice_AlternBelt extends MenuUIChoiceEnum;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(player.bAlternateToolbelt);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bAlternateToolbelt = GetValue();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(0);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="If true, belt selection uses 'interact' (default: right click) to confirm selection, eliminating the act of cycling multiple items before reaching the desired.|nClassic mode additionally makes right click switch back after using the number keys."
     actionText="|&Invisible War Toolbelt"
	 enumText(0)="Disabled"
     enumText(1)="Enabled"
     enumText(2)="Classic"
}
