//=============================================================================
// MenuScreenThemesSave
//=============================================================================

class MenuScreenThemesSave expands MenuScreenThemesLoad;

var ColorTheme theme;

function PopulateThemesList()
{
	// First erase the old list
	lstThemes.DeleteAllRows();

	theme = player.ThemeManager.GetFirstTheme(themeType);

	while(theme != None)
	{
	    if (theme.themeName == "CustomHUD" || theme.themeName == "CustomMENU")
		lstThemes.AddRow(theme.GetThemeName());
		theme = player.ThemeManager.GetNextTheme();
	}
}

function ProcessAction(String actionKey)
{
local string themeNames;

	if (actionKey == "SAVE")
	{
	if (lstThemes.GetNumSelectedRows() == 1)
	{
	   themeNames = lstThemes.GetField(lstThemes.GetSelectedRow(), 0);
	   if (theme.themeName == "CustomHUD" || theme.themeName == "CustomMENU")
        {  theme.SaveConfig(); log("WE SAVED"); }
    }
	else
	{
	   theme.PlaySound(sound'bouncemetal',SLOT_None);
    }
  }
  Super.ProcessAction(actionKey);
}

/*function SaveThemeByName(String themeStringName)
{
	local ColorTheme theme;

	if (themeMode == CTT_Menu)
		theme = player.ThemeManager.SetMenuThemeByName(themeStringName);
	else
		theme = player.ThemeManager.SetHUDThemeByName(themeStringName);

	SetTheme(theme);
}*/
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     LoadHelpText="Choose the color theme to save"
     actionButtons(1)=(Text="Save Theme",Key="SAVE")
     Title="Save Theme"
}
