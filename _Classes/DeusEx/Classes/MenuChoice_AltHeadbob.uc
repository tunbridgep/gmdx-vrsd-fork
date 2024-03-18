//-----------------------------------------------------------
//CyberP: Enable Disable alternate headbob
//-----------------------------------------------------------
class MenuChoice_AltHeadbob extends MenuChoice_EnabledDisabled;
// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!player.bModdedHeadBob));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.bModdedHeadBob = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!player.bModdedHeadBob));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=98
     HelpText="Alternate realistic headbobbing effect. True = On. False = Original headbob. To disable headbobbing outright, see the vanilla options."
     actionText="|&Realistic Headbob"
}
