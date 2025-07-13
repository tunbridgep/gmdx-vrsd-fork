//=============================================================================
// HUDActiveItemBase
//=============================================================================

class HUDActiveItemBase extends HUDBaseWindow;

var Color colItemIcon;

var EDrawStyle iconDrawStyle;
var int	iconWidth;
var int iconHeight;

var Texture icon;
var Texture texBackground;

var ProgressBarWindow winEnergy; //SARGE: Moved to the base class, so augs can use it too.


// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetSize(iconWidth, iconHeight);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	Super.DrawWindow(gc);

	if (icon != None)
	{
		// Now draw the icon
		gc.SetStyle(iconDrawStyle);
		gc.SetTileColor(colItemIcon);
        if (DrawDim())
            gc.SetTileColorRGB(64,64,64);
		gc.DrawTexture(2, 2, 32, 32, 0, 0, icon);
	}

	DrawHotKey(gc);
}

// ----------------------------------------------------------------------
// SARGE: DrawDim()
// Whether or not to dim the icon
// ----------------------------------------------------------------------

function bool DrawDim()
{
    return false;
}

// ----------------------------------------------------------------------
// DrawHotKey()
// ----------------------------------------------------------------------

function DrawHotKey(GC gc)
{
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(0, 0, width, height, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// SetIcon()
// ----------------------------------------------------------------------

function SetIcon(Texture newIcon)
{
	icon = newIcon;
}

// ----------------------------------------------------------------------
// SetIconMasked()
// ----------------------------------------------------------------------

function SetIconMasked(bool bNewMask)
{
	if (bNewMask)
		iconDrawStyle = DSTY_Masked;
	else
		iconDrawStyle = DSTY_Translucent;
}

// ----------------------------------------------------------------------
// SetObject()
//
// Had to write this because SetClientObject() is FINAL in Extension
// ----------------------------------------------------------------------

function SetObject(object newClientObject)
{
}

// ----------------------------------------------------------------------
// CreateEnergyBar()
// SARGE: Moved to Base Class
// ----------------------------------------------------------------------

function CreateEnergyBar()
{
	winEnergy = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));
	winEnergy.SetSize(32, 2);
	winEnergy.UseScaledColor(True);
	winEnergy.SetPos(1, 30);
	winEnergy.SetValues(0, 100);
	winEnergy.SetCurrentValue(0);
	winEnergy.SetVertical(False);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colItemIcon=(R=255,G=255,B=255)
     iconDrawStyle=DSTY_Translucent
     IconWidth=34
     IconHeight=34
     texBackground=Texture'DeusExUI.UserInterface.HUDIconsBackground'
}
