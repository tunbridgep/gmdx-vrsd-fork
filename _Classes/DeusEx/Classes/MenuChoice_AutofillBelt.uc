//-----------------------------------------------------------
//Sarge: Enable/disable belt autofill
//-----------------------------------------------------------
class MenuChoice_AutofillBelt extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bBeltAutofill));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bBeltAutofill = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bBeltAutofill));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Automtically add newly-acquired items to the toolbelt."
     actionText="|&Autofill Belt"
}
