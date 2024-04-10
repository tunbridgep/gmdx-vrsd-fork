//=============================================================================
// ColorThemeManager
//=============================================================================
class ColorThemeManager extends Actor;

Enum EColorThemeTypes
{
	CTT_Menu,
	CTT_HUD
};

var travel ColorTheme FirstColorTheme;
var travel ColorTheme CurrentSearchTheme;
var travel EColorThemeTypes CurrentSearchThemeType;

var travel ColorTheme currentHUDTheme;
var travel ColorTheme currentMenuTheme;

var const Color colConTextFocus;
var const Color colConTextChoice;
var const Color colConTextSkill;

// ----------------------------------------------------------------------
// Sarge: Dialog Colour Functions
// ----------------------------------------------------------------------

//Sarge: If we're using HUD Colors for the dialogue menu, use them. Otherwise, use the built-in blue color

function Color GetDialogBackgroundColor()
{
    local DeusExPlayer player;
    local Color bgColor;

    player = DeusExPlayer(GetPlayerPawn());

    if (player.bDialogHUDColors)
        //return currentHUDTheme.GetColor(0); //HUDColor_Background
        return currentHUDTheme.GetColor(3); //HUDColor_ButtonFace
    else
        return colConTextChoice;
}

function Color GetDialogTextColor()
{
    local DeusExPlayer player;
    player = DeusExPlayer(GetPlayerPawn());

    if (player.bDialogHUDColors)
        return currentHUDTheme.GetColor(4); //HUDColor_ButtonTextNormal
    else
        return colConTextChoice;
}

function Color GetDialogHighlightColor()
{
    local DeusExPlayer player;
    player = DeusExPlayer(GetPlayerPawn());

    if (player.bDialogHUDColors)
        return currentHUDTheme.GetColor(5); //HUDColor_ButtonTextFocus
    else
        return colConTextFocus;
}


// ----------------------------------------------------------------------
// SetCurrentHUDColorTheme()
// ----------------------------------------------------------------------

simulated function SetCurrentHUDColorTheme(ColorTheme newTheme)
{
	if (newTheme != None)
		currentHUDTheme = newTheme;
}

// ----------------------------------------------------------------------
// SetCurrentMenuColorTheme()
// ----------------------------------------------------------------------

simulated function SetCurrentMenuColorTheme(ColorTheme newTheme)
{
	if (newTheme != None)
		currentMenuTheme = newTheme;
}

// ----------------------------------------------------------------------
// NextHUDColorTheme()
// ----------------------------------------------------------------------

simulated function NextHUDColorTheme()
{
	currentHUDTheme = GetNextThemeByType(currentHUDTheme, CTT_HUD);
}

// ----------------------------------------------------------------------
// NextMenuColorTheme()
// ----------------------------------------------------------------------

simulated function NextMenuColorTheme()
{
	currentMenuTheme = GetNextThemeByType(currentMenuTheme, CTT_Menu);
}

// ----------------------------------------------------------------------
// GetCurrentHUDColorTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme GetCurrentHUDColorTheme()
{
	return currentHUDTheme;
}

// ----------------------------------------------------------------------
// GetCurrentMenuColorTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme GetCurrentMenuColorTheme()
{
	return currentMenuTheme;
}

// ----------------------------------------------------------------------
// DeleteColorTheme()
// ----------------------------------------------------------------------

simulated function bool DeleteColorTheme(String themeName)
{
	local ColorTheme deleteTheme;
	local ColorTheme prevTheme;
	local Bool bDeleted;

	bDeleted    = False;
	prevTheme   = None;
	deleteTheme = FirstColorTheme;

	while(deleteTheme != None)
	{
		if ((deleteTheme.GetThemeName() == themeName) && (deleteTheme.IsSystemTheme() != True))
		{
			if (deleteTheme == FirstColorTheme)
				FirstColorTheme = deleteTheme.next;

			if (prevTheme != None)
				prevTheme.next = deleteTheme.next;

			bDeleted = True;
			break;
		}

		prevTheme   = deleteTheme;
		deleteTheme = deleteTheme.next;
	}
}

// ----------------------------------------------------------------------
// CreateTheme()
// ----------------------------------------------------------------------

function ColorTheme CreateTheme(Class<ColorTheme> newThemeClass, String newThemeName)
{
	local ColorTheme newTheme;

	newTheme = AddTheme(newThemeClass);

	if (newTheme != None)
		newTheme.SetThemeName(newThemeName);

	return newTheme;
}

// ----------------------------------------------------------------------
// AddTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme AddTheme(Class<ColorTheme> newThemeClass)
{
	local ColorTheme newTheme;
	local ColorTheme theme;

	if (newThemeClass == None)
		return None;

	// Spawn the class
	newTheme = Spawn(newThemeClass, Self);

	if (FirstColorTheme == None)
	{
		FirstColorTheme = newTheme;
	}
	else
	{
		theme = FirstColorTheme;

		// Add at end for now
		while(theme.next != None)
			theme = theme.next;

		theme.next = newTheme;
	}

	return newTheme;
}

// ----------------------------------------------------------------------
// GetFirstTheme()
//
// Intended to be called from external classes since we can't freakin'
// pass in the EColorThemeTypes.  God I hate that.
// ----------------------------------------------------------------------

simulated function ColorTheme GetFirstTheme(int intThemeType)
{
	local EColorThemeTypes themeType;

	if (intThemeType == 0)
		themeType = CTT_Menu;
	else
		themeType = CTT_HUD;

	CurrentSearchThemeType = themeType;
	CurrentSearchTheme     = GetNextThemeByType(None, CurrentSearchThemeType);

	return CurrentSearchTheme;
}

// ----------------------------------------------------------------------
// GetNextTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme GetNextTheme()
{
	if (CurrentSearchTheme != None)
		CurrentSearchTheme = GetNextThemeByType(CurrentSearchTheme, CurrentSearchThemeType);

	return CurrentSearchTheme;
}

// ----------------------------------------------------------------------
// GetNextThemeByType()
// ----------------------------------------------------------------------

simulated function ColorTheme GetNextThemeByType(ColorTheme theme, EColorThemeTypes themeType)
{
	if (theme == None)
		theme = FirstColorTheme;
	else
		theme = theme.next;

	while(theme != None)
	{
		if (theme.themeType == themeType)
			break;

		theme = theme.next;
	}

	return theme;
}

// ----------------------------------------------------------------------
// FindTheme()
// ----------------------------------------------------------------------

simulated function ColorTheme FindTheme(String themeNamy)
{
	local ColorTheme theme;

	theme = FirstColorTheme;

    ForEach AllActors(Class'ColorTheme',theme)
    {
		if (theme.GetThemeName() == themeNamy)
			break;
	}

	return theme;
}

// ----------------------------------------------------------------------
// SetHUDThemeByName()
// ----------------------------------------------------------------------

simulated function ColorTheme SetHUDThemeByName(String themeName)
{
	local ColorTheme theme;
	local ColorTheme firstHUDTheme;

	theme = FirstColorTheme;

	while(theme != None)
	{
		if (theme.themeType == CTT_HUD)
			firstHUDTheme = theme;

		if ((theme.GetThemeName() == themeName) && (theme.themeType == CTT_HUD))
		{
			currentHUDTheme = theme;
			break;
		}

		theme = theme.next;
	}

	if (currentHUDTheme != None)
		return currentHUDTheme;
	else
		return firstHUDTheme;
}

// ----------------------------------------------------------------------
// SetMenuThemeByName()
// ----------------------------------------------------------------------

simulated function ColorTheme SetMenuThemeByName(String themeName)
{
	local ColorTheme theme;
	local ColorTheme firstMenuTheme;

	theme = FirstColorTheme;

	while(theme != None)
	{
		if (theme.themeType == CTT_Menu)
			firstMenuTheme = theme;

		if ((theme.GetThemeName() == themeName) && (theme.themeType == CTT_Menu))
		{
			currentMenuTheme = theme;
			break;
		}

		theme = theme.next;
	}

	if (currentMenuTheme != None)
		return currentMenuTheme;
	else
		return firstMenuTheme;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colConTextFocus=(R=255,G=255)
     colConTextChoice=(B=255)
     colConTextSkill=(R=255)
     bHidden=True
     bTravel=True
}
