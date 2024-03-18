//-----------------------------------------------------------
//GMDX:
//-----------------------------------------------------------
class MenuChoice_FirstPersonDeath extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bRemoveVanillaDeath));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bRemoveVanillaDeath = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bRemoveVanillaDeath));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="If set to Enabled, death event is in first person perspective, else third person."
     actionText="|&Death Perspective"
}
