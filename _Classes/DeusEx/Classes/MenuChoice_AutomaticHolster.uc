//-----------------------------------------------------------
//GMDX:
//-----------------------------------------------------------
class MenuChoice_AutomaticHolster extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bAutoHolster));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bAutoHolster = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bAutoHolster));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="If set to Enabled, right clicking on carryable objects will automatically holster your held weapon and thus enable you to pick up the object."
     actionText="|&Interaction Auto Holster"
}
