//=============================================================================
// MenuChoice_MenuColor
//=============================================================================

class MenuChoice_MenuColor extends MenuChoice_ThemeColor;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	// Populate the enums!
	PopulateThemes(0);

	currentTheme = player.ThemeManager.GetCurrentMenuColorTheme();
	SetValueFromString(currentTheme.GetThemeName());
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.MenuThemeNameGMDX = enumText[GetValue()];
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
	player.ThemeManager.SetCurrentMenuColorTheme(currentTheme);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	local ColorTheme theme;

	player.MenuThemeNameGMDX = defaultTheme;
	theme = player.ThemeManager.SetMenuThemeByName(defaultTheme);
	theme.ResetThemeToDefault();

	SetValueFromString(player.MenuThemeNameGMDX);

	ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	Super.CycleNextValue();
	player.ThemeManager.SetMenuThemeByName(enumText[GetValue()]);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	Super.CyclePreviousValue();
	player.ThemeManager.SetMenuThemeByName(enumText[GetValue()]);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultTheme="CustomMenu"
     defaultInfoWidth=97
     HelpText="Color scheme used in all menus."
     actionText="|&Menu Color Scheme"
}
