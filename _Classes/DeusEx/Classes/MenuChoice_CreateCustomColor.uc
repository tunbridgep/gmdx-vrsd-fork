//=============================================================================
// MenuChoice_Brightness
//=============================================================================

class MenuChoice_CreateCustomColor extends MenuUIChoiceAction;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Action=MA_MenuScreen
     Invoke=Class'DeusEx.MenuScreenRGB'
     HelpText="Create your own color theme for both the HUD & Menu. When finished, click the save button to save your custom theme."
     actionText="Create Custom Color Theme"
}
