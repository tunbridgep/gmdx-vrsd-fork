//=============================================================================
// PersonaNotesEditWindow
//=============================================================================
class PersonaNotesEditWindow expands PersonaEditWindow;

var Color colBracket;

var Texture texBordersNormal[9];
var Texture texBordersFocus[9];

var Color colMarkerNote;            //SARGE: Added a new colour for borders of marker notes
var private bool bMarkerNote;

var private bool bNoteSet;          //SARGE: Hack.
var private bool bFakeReadOnly;     //SARGE: Block all input, but still allow selecting and copying
var private bool bPermanentFakeReadonly;    //SARGE: Read Only is no longer related to the player setting, just prevent it entirely.
var bool bUseMenuColors;                     //SARGE: Use the menu theme instead of the HUD theme

var bool bBlockEscape;                       //SARGE: This is a hacky fix for the game crashing when we press escape in the notes window.

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// We need to make this dynamic so it can handle if edit mode is turned on.
// ----------------------------------------------------------------------
event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
    //Stop crashing
    if (key == IK_Escape && bBlockEscape)
        return true;

    //If we're disabled, just passthrough to something else
    if (!bEditable)
        return false;

    if (bNoteSet && !bPermanentFakeReadonly)
        bFakeReadOnly = !player.bAllowNoteEditing;

    //when editing is turned off, we have to stop editing operations
    if (bFakeReadOnly)
    {
        //Send certain keys to our parent
        //like the C and V keys, so we can copy-paste,
        //but everything else should be ignored.
        switch (key)
        {
            case IK_C:  //Copy
            case IK_V:  //Pasta
            case IK_Left:  //Move
            case IK_Right:  //Move
            case IK_Up:  //Move
            case IK_Down:  //Move
            case IK_PageUp:
            case IK_PageDown:
            case IK_Home:
            case IK_End:
            return Super.VirtualKeyPressed(key,bRepeat);
        }
        return false;
    }
    
    return Super.VirtualKeyPressed(key,bRepeat);
}

// ----------------------------------------------------------------------
// SetReadOnly()
//
// Sets this as being permanently read only, regardless of the player note editing setting.
// "Read Only" means we can still select text and interact with it by moving the cursor around with the keys,
// we can copy paste etc as well.
// ----------------------------------------------------------------------
function SetReadOnly(bool bValue)
{
    bPermanentFakeReadonly = bValue;
    bFakeReadOnly = bValue;
}

// ----------------------------------------------------------------------
// SetMarkerNote()
//
// Sets this note window as being for a marker note, giving it a coloured border.
// ----------------------------------------------------------------------
function SetMarkerNote(bool bValue)
{
    bMarkerNote = bValue;
    StyleChanged();
}

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetTextMargins(10, 5);
}

// ----------------------------------------------------------------------
// DrawWindow()
//
// Draws the brackets around the note
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	// Draw the Gamma Scale
	gc.SetTileColor(colBracket);
	gc.SetStyle(DSTY_Masked);

	// Draw background
	gc.DrawBorders(0, 0, width, height, 0, 0, 0, 0, texBordersNormal);
}

// ----------------------------------------------------------------------
// FilterChar()
//
// Backslaces are EVIL and cannot be entered, because of 
// travel export/import issues (we use this backslash to represent
// the return character)
// ----------------------------------------------------------------------

function bool FilterChar(out string chStr)
{
    if (bNoteSet && !bPermanentFakeReadonly)
        bFakeReadOnly = !player.bAllowNoteEditing;

    if (bFakeReadOnly)
        return false;
	return (chStr != "\\");
}

// ----------------------------------------------------------------------
// SetNote()
// ----------------------------------------------------------------------

function SetNote( DeusExNote newNote )
{
	SetClientObject(newNote);

	SetText( newNote.text );

    bNoteSet = true;
}

// ----------------------------------------------------------------------
// GetNote()
// ----------------------------------------------------------------------

function DeusExNote GetNote()
{
	return DeusExNote(GetClientObject());
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	Super.StyleChanged();

    if (bUseMenuColors)
    {
        theme = player.ThemeManager.GetCurrentMenuColorTheme();
        colBracket = theme.GetColorFromName('MenuColor_ButtonFace');
        
        // Title colors
        colText          = theme.GetColorFromName('MenuColor_ButtonTextFocus');
        colHighlight     = theme.GetColorFromName('MenuColor_ButtonFace');
        colCursor        = theme.GetColorFromName('MenuColor_Cursor');
    }
    else if (bMarkerNote)
        colBracket = colMarkerNote;
    else
    {
        theme = player.ThemeManager.GetCurrentHUDColorTheme();
        colBracket = theme.GetColorFromName('HUDColor_HeaderText');
    }
	
    SetTextColor(colText);
	SetTileColor(colHighlight);
	SetSelectedAreaTexture(Texture'Solid', colText);
	SetSelectedAreaTextColor(colBlack);
	SetEditCursor(Texture'DeusExEditCursor', Texture'DeusExEditCursor_Shadow', colCursor);
	SetInsertionPointTexture(Texture'Solid', colCursor);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

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
     //colMarkerNote=(R=255,G=255,B=255)
     colMarkerNote=(G=255)
}
