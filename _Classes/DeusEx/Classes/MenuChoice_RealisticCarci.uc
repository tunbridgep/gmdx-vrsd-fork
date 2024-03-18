//-----------------------------------------------------------
//CyberP: Enable Disable double click holstering
//-----------------------------------------------------------
class MenuChoice_RealisticCarci extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bRealisticCarc));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bRealisticCarc= !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bRealisticCarc));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="Corpses can only be destroyed by realistic means and do not deal throw damage with the muscle aug. Note: hardcore mode features this by default."
     actionText="|&Persistent Corpses"
}
