//-----------------------------------------------------------
//GMDX: Enable Disable New Game Intro
//-----------------------------------------------------------
class MenuChoice_NewGameIntro extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bSkipNewGameIntro));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bSkipNewGameIntro = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bSkipNewGameIntro));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="If enabled, the new game intro is not loaded."
     actionText="|&Skip Intro"
}
