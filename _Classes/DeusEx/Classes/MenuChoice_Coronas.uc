//=============================================================================
// MenuChoice_Coronas
//=============================================================================

class MenuChoice_Coronas extends MenuChoice_EnabledDisabled;

//Dirty hack to convert
function int GetConsoleValue()
{
    local string settingValue;

    settingValue = player.ConsoleCommand("get D3D10Drv.D3D10RenderDevice Coronas");

    if (settingValue ~= "True")
        return 0;
    else
        return 1;
}

function SetConsoleValue(int value)
{
    if (value == 0)
    {
        player.ConsoleCommand("set D3D9Drv.D3D9RenderDevice Coronas True");
        player.ConsoleCommand("set D3D10Drv.D3D10RenderDevice Coronas True");
        player.ConsoleCommand("set OpenGLDrv.OpenGLRenderDevice Coronas True");
    }
    else
    {
        player.ConsoleCommand("set D3D9Drv.D3D9RenderDevice Coronas False");
        player.ConsoleCommand("set D3D10Drv.D3D10RenderDevice Coronas False");
        player.ConsoleCommand("set OpenGLDrv.OpenGLRenderDevice Coronas False");
    }
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(GetConsoleValue());
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    SetConsoleValue(GetValue());
    player.SaveConfig();
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	LoadSetting();
    player.SaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="Display coronas around light sources."
     actionText="|&Coronas"
}
