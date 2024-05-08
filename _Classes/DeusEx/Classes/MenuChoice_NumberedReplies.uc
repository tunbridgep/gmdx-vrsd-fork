//-----------------------------------------------------------
//Sarge: Enable/disable numbered replies in conversations (select answers using number keys)
//-----------------------------------------------------------
class MenuChoice_NumberedReplies extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bNumberedDialog));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bNumberedDialog = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bNumberedDialog));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="Use the number keys to select dialog choices"
     actionText="|&Numbered Replies"
}
