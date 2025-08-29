//=============================================================================
// SARGE: PersonaNotesViewWindow
// Non-editable version of the standard Note Edit window
//=============================================================================
class PersonaNotesViewWindow expands TextWindow;

var Color colBracket;

var Texture texBordersNormal[9];
var Texture texBordersFocus[9];

var bool bUseMenuColors;

event DrawWindow(GC gc)
{	
	// Draw the Gamma Scale
	gc.SetTileColor(colBracket);
	gc.SetStyle(DSTY_Masked);

	// Draw background
	gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texBordersNormal);
}

function SetTheme(DeusExPlayer player)
{
	local ColorTheme theme;
    local Color colText;
    local Color colHighlight;
    local Color colCursor;
    
    if (bUseMenuColors)
    {
	    theme = player.ThemeManager.GetCurrentMenuColorTheme();

        colBracket = theme.GetColorFromName('MenuColor_ButtonFace');
        
        // Title colors
        colText          = theme.GetColorFromName('MenuColor_ButtonTextFocus');
        colHighlight     = theme.GetColorFromName('MenuColor_ButtonFace');
    }
    else
    {

        theme = player.ThemeManager.GetCurrentHUDColorTheme();

        colBracket = theme.GetColorFromName('HUDColor_HeaderText');
        
        // Title colors
        colText          = theme.GetColorFromName('HUDColor_ListText');
        colHighlight     = theme.GetColorFromName('HUDColor_ListHighlight');
    }

	SetTextColor(colText);
	SetTileColor(colHighlight);
}

defaultproperties
{
     texBordersNormal(0)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_TL'
     texBordersNormal(1)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_TR'
     texBordersNormal(2)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_BL'
     texBordersNormal(3)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_BR'
     texBordersNormal(4)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Left'
     texBordersNormal(5)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Right'
     texBordersNormal(6)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Top'
     texBordersNormal(7)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Bottom'
     texBordersNormal(8)=Texture'DeusExUI.UserInterface.PersonaNoteNormal_Center'
     texBordersFocus(0)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_TL'
     texBordersFocus(1)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_TR'
     texBordersFocus(2)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_BL'
     texBordersFocus(3)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_BR'
     texBordersFocus(4)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Left'
     texBordersFocus(5)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Right'
     texBordersFocus(6)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Top'
     texBordersFocus(7)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Bottom'
     texBordersFocus(8)=Texture'DeusExUI.UserInterface.PersonaNoteFocus_Center'
}
