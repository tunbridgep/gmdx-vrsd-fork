//=============================================================================
// HUDBaseWindow
//=============================================================================
class HUDBaseWindow extends Window;

var DeusExPlayer player;

// Border and Background Translucency
var bool       bDrawBorder;
var EDrawStyle borderDrawStyle;
var EDrawStyle backgroundDrawStyle;

// Position/size of background
var int backgroundWidth;
var int backgroundHeight;
var int backgroundPosX;
var int backgroundPosY;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color colText;

//SARGE: HUD Object Fading
var config float fAutoFadeTime;        //SARGE: How long before the HUD elements fade out. Set to zero to disable.
var private travel float fAutoFadeTimeCountdown;    //SARGE: The countdown timer left before our HUD element disappears.
var const bool bFadeEnabled;                 //SARGE: Global sanity check for enabling fading.

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

    if (bFadeEnabled)
        bTickEnabled = true;

	StyleChanged();
}

// ----------------------------------------------------------------------
// DrawWindow()
// SARGE: Don't draw the belt at all if we've faded it out completely
// This is a hack because the IsVisible() function is native
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
    if (GetOpacity() == 0.0)
        return;

	// First draw the background then the border
	DrawBackground(gc);
	DrawBorder(gc);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
}

// ----------------------------------------------------------------------
// RefreshHUDDisplay()
// ----------------------------------------------------------------------

function RefreshHUDDisplay(float DeltaTime)
{
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colText       = theme.GetColorFromName('HUDColor_NormalText');
	colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

	bDrawBorder            = player.GetHUDBordersVisible();

	if (player.GetHUDBorderTranslucency())
		borderDrawStyle = DSTY_Translucent;
	else
		borderDrawStyle = DSTY_Masked;

	if (player.GetHUDBackgroundTranslucency())
		backgroundDrawStyle = DSTY_Translucent;
	else
		backgroundDrawStyle = DSTY_Masked;

    ResetHUDFadeTime();
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )                                   //RSD: Copied from HUDObjectBelt.uc for hiding the window when we open the inventory in realtime UI
{
	Show( bNewVisibility );
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// Fade Time Stuff
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetHUDFadeTime()
{
    fAutoFadeTimeCountdown = default.fAutoFadeTime;
}

function Tick(float deltaTime)
{
    fAutoFadeTimeCountdown = FMAX(0.0,fAutoFadeTimeCountdown - deltaTime);
}

// ----------------------------------------------------------------------
// GetOpacity()
// SARGE: Allow fading HUD panels
// ----------------------------------------------------------------------

//Overwrite this to mess with fade times
function float GetHUDFadeTime()
{
    return fAutoFadeTimeCountdown;
}

//Overwrite this to mess with fade enabling
function bool AllowFade()
{
    return bFadeEnabled && default.fAutoFadeTime > 0;
}

function float GetOpacity()
{
    local float opacity;
    local float timer;
	
    opacity = 1.0;

    timer = GetHUDFadeTime();
    if (AllowFade() && timer < 2.0)
    {
        opacity = timer * 0.5;
        opacity = FMIN(1.0,opacity);
        opacity = FMAX(0.0,opacity);
    }

    return opacity;
}

function Color GetColorWithOpacity(Color c)
{
    local float opacity;

    opacity = GetOpacity();
    c.r = c.r * opacity;
    c.g = c.g * opacity;
    c.b = c.b * opacity;
    c.a = c.a * opacity;

    return c;
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bDrawBorder=True
     colBackground=(R=128,G=128,B=128)
     colBorder=(R=128,G=128,B=128)
     colText=(R=255,G=255,B=255)
}
