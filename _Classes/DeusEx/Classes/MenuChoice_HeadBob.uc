//=============================================================================
// MenuChoice_HeadBob
//=============================================================================

class MenuChoice_HeadBob extends MenuUIChoiceEnum;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(player.iModdedHeadBob);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    player.iModdedHeadBob = GetValue();
    player.SaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
    SetValue(player.default.iModdedHeadBob);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=88
     HelpText="If enabled, the player will bob up and down slightly while walking."
     actionText="|&Head Bob"
     enumText(0)="Disabled"
     enumText(1)="Vanilla"
     enumText(2)="GMDX v9"
     enumText(3)="GMDX AE"
}
