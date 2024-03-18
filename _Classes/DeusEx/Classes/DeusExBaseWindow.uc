//=============================================================================
// DeusExBaseWindow
//
// Contains screen type as well as base colors and other info
//=============================================================================

class DeusExBaseWindow extends ModalWindow;

// Possible Event Actions
enum EScreenType
{
	ST_Menu,
	ST_MenuScreen,
	ST_Persona,
	ST_DataVault,
	ST_Computer,
	ST_Conversation,
	ST_HUD,
	ST_Popup,
	ST_Tool,
	ST_Credits,
	ST_Other
};

var EScreenType ScreenType;

// Keep a pointer to the root window handy
var DeusExRootWindow root;

// Keep a pointer to the player for easy reference
var DeusExPlayer player;

// Primary Colors
var Color colRed;
var Color colDarkRed;
var Color colGreen;
var Color colDarkGreen;
var Color colWhite;
var Color colBlack;
var Color colGrey;
var Color colCyan;
var Color colDarkCyan;
var Color colBlue;
var Color colLightBlue;
var Color colDarkBlue;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Set default mouse focus mode
	SetMouseFocusMode(MFocus_Enter);

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());

	// Get a pointer to the player
	player = DeusExPlayer(root.parentPawn);

	//CyberP: update custom colors
	if (player.ThemeManager.currentMenuTheme.themeName == "CustomMenu")
	{
		//CyberP: hacky failsafe checks to make sure that colors do not ALL go completely black (players cannot navigate if everything is black).
		if (player.customColorsMenu[4].R <= 5 && player.customColorsMenu[4].G <= 5 && player.customColorsMenu[4].B <= 5)
		   player.customColorsMenu[4].R = 255;
		if (player.customColorsMenu[12].R <= 3 && player.customColorsMenu[12].G <= 3 && player.customColorsMenu[12].B <= 3)
		   player.customColorsMenu[12].R = 255;

	    player.ThemeManager.currentMenuTheme.colors[0] = player.customColorsMenu[0];
	    player.ThemeManager.currentMenuTheme.colors[1] = player.customColorsMenu[1];
		player.ThemeManager.currentMenuTheme.colors[2] = player.customColorsMenu[2];
	    player.ThemeManager.currentMenuTheme.colors[3] = player.customColorsMenu[3];
		player.ThemeManager.currentMenuTheme.colors[4] = player.customColorsMenu[4];
		player.ThemeManager.currentMenuTheme.colors[5] = player.customColorsMenu[5];
		player.ThemeManager.currentMenuTheme.colors[6] = player.customColorsMenu[6];
		player.ThemeManager.currentMenuTheme.colors[7] = player.customColorsMenu[7];
		player.ThemeManager.currentMenuTheme.colors[8] = player.customColorsMenu[8];
		player.ThemeManager.currentMenuTheme.colors[9] = player.customColorsMenu[9];
		player.ThemeManager.currentMenuTheme.colors[10] = player.customColorsMenu[10];
		player.ThemeManager.currentMenuTheme.colors[11] = player.customColorsMenu[11];
		player.ThemeManager.currentMenuTheme.colors[12] = player.customColorsMenu[12];
		player.ThemeManager.currentMenuTheme.colors[13] = player.customColorsMenu[13];
		ChangeStyle();
		}
		if (player.ThemeManager.currentHUDTheme.themeName == "CustomHUD")
		{
	    player.ThemeManager.currentHUDTheme.colors[0] = player.customColorsHUD[0];
	    player.ThemeManager.currentHUDTheme.colors[1] = player.customColorsHUD[1];
	    player.ThemeManager.currentHUDTheme.colors[2] = player.customColorsHUD[2];
	    player.ThemeManager.currentHUDTheme.colors[3] = player.customColorsHUD[3];
	    player.ThemeManager.currentHUDTheme.colors[4] = player.customColorsHUD[4];
	    player.ThemeManager.currentHUDTheme.colors[5] = player.customColorsHUD[5];
	    player.ThemeManager.currentHUDTheme.colors[6] = player.customColorsHUD[6];
	    player.ThemeManager.currentHUDTheme.colors[7] = player.customColorsHUD[7];
	    player.ThemeManager.currentHUDTheme.colors[8] = player.customColorsHUD[8];
	    player.ThemeManager.currentHUDTheme.colors[9] = player.customColorsHUD[9];
	    player.ThemeManager.currentHUDTheme.colors[10] = player.customColorsHUD[10];
	    player.ThemeManager.currentHUDTheme.colors[11] = player.customColorsHUD[11];
	    player.ThemeManager.currentHUDTheme.colors[12] = player.customColorsHUD[12];
	    player.ThemeManager.currentHUDTheme.colors[13] = player.customColorsHUD[13];
	    ChangeStyle();
	}

	// Center this window
	SetWindowAlignments(HALIGN_Center, VALIGN_Center);
}

// ----------------------------------------------------------------------
// CanPushScreen()
//
// Checks to see if we can push another screen on top of this
// screen.
// ----------------------------------------------------------------------

function bool CanPushScreen(Class <DeusExBaseWindow> newScreen)
{
	local bool bCanPush;

	switch(ScreenType)
	{
		case ST_Menu:
			bCanPush = ((newScreen.default.ScreenType == ST_Menu) ||
						(newScreen.default.ScreenType == ST_MenuScreen));
			break;

		case ST_MenuScreen:
			bCanPush = (newScreen.default.ScreenType == ST_MenuScreen);
			break;

		case ST_Persona:
			bCanPush = TRUE;
			break;

		case ST_DataVault:
			bCanPush = TRUE;
			break;

		case ST_Conversation:
			bCanPush = FALSE;
			break;

		case ST_Computer:
			bCanPush = FALSE;
			break;

		case ST_HUD:
			bCanPush = TRUE;
			break;

		case ST_Popup:
			bCanPush = FALSE;
			break;

		case ST_Tool:
			bCanPush = (newScreen.default.ScreenType == ST_Tool);
			break;

		case ST_Credits:
			bCanPush = FALSE;
			break;

		case ST_Other:
			bCanPush = TRUE;
			break;
	}

	return bCanPush;
}

// ----------------------------------------------------------------------
// CanStack()
//
// Returns TRUE if this screen cannot remain while another screen
// is active
// ----------------------------------------------------------------------

function bool CanStack()
{
	local bool bCanStack;

	switch(ScreenType)
	{
		case ST_Menu:
			bCanStack = TRUE;
			break;

		case ST_MenuScreen:
			bCanStack = TRUE;
			break;

		case ST_Persona:
			bCanStack = FALSE;
			break;

		case ST_DataVault:
			bCanStack = FALSE;
			break;

		case ST_Conversation:
			bCanStack = FALSE;
			break;

		case ST_Computer:
			bCanStack = FALSE;
			break;

		case ST_HUD:
			bCanStack = TRUE;
			break;

		case ST_Popup:
			bCanStack = TRUE;
			break;

		case ST_Tool:
			bCanStack = TRUE;
			break;

		case ST_Other:
			bCanStack = TRUE;
			break;
	}

	return bCanStack;
}

// ----------------------------------------------------------------------
// RefreshWindow()
// DEUS_EX AMSD Here for multiplayer refreshing
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ScreenType=ST_Other
     colRed=(R=255)
     colDarkRed=(R=128)
     colGreen=(G=255)
     colDarkGreen=(G=128)
     colWhite=(R=255,G=255,B=255)
     colGrey=(R=128,G=128,B=128)
     colCyan=(G=200,B=200)
     colDarkCyan=(G=100,B=100)
     colBlue=(B=255)
     colLightBlue=(G=170,B=255)
     colDarkBlue=(G=85,B=128)
}
