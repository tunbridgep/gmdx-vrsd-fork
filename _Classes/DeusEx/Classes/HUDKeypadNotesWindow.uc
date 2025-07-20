//=============================================================================
// HUDKeypadNotesWindow
// SARGE: Shows notes next to keypad/login input
//=============================================================================

class HUDKeypadNotesWindow extends HUDInformationDisplay;
//class HUDKeypadNotesWindow extends TileWindow;
//class HUDKeypadNotesWindow extends DeusExBaseWindow;

var TextWindow winNotesText;

var localized string msgRelevantNote;

//Use the Menu theme instead of the HUD Theme
var bool bUseMenuColors;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();
}

function AddNote(DeusExNote Note)
{
    winNotesText = AddTextWindow();
    winNotesText.SetText(Note.text);
}

event DestroyWindow()
{
    if (winNotesText != None)
    {
        winNotesText.DestroyAllChildren();
        winNotesText.DestroyWindow();
        winNotesText.Destroy();
        winNotesText = None;
    }
    DestroyAllChildren();
}

// ----------------------------------------------------------------------
// StyleChanged()
// SARGE: Use menu colors
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

    if (bUseMenuColors)
    {
	    theme = player.ThemeManager.GetCurrentMenuColorTheme();

        coLBackground = theme.GetColorFromName('MenuColor_Background');
        colBorder     = theme.GetColorFromName('MenuColor_ButtonFace');
        colText       = theme.GetColorFromName('MenuColor_ButtonTextFocus');
        colHeaderText = theme.GetColorFromName('MenuColor_HeaderText');

        bDrawBorder = true;

        if (player.GetMenuTranslucency())
        {
            borderDrawStyle = DSTY_Translucent;
            backgroundDrawStyle = DSTY_Translucent;
        }
        else
        {
            borderDrawStyle = DSTY_Masked;
            backgroundDrawStyle = DSTY_Masked;
        }
    }
    else
        super.StyleChanged();
}

defaultproperties
{
    msgRelevantNote="Relevant Note:"
}
