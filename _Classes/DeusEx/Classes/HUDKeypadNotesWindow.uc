//=============================================================================
// HUDKeypadNotesWindow
// SARGE: Shows notes next to keypad/login input
//=============================================================================

//class HUDKeypadNotesWindow extends HUDInformationDisplay;
//class HUDKeypadNotesWindow extends TileWindow;
class HUDKeypadNotesWindow extends HUDBaseWindow;
//class HUDKeypadNotesWindow extends Window;
//class HUDKeypadNotesWindow extends PersonaBaseWindow;

//var TextWindow winNotesText;
//var TileWindow winNotesText;
var HUDInformationDisplay winBackground;
var PersonaScrollAreaWindow winScroll;

var localized string msgRelevantNote;

//Use the Menu theme instead of the HUD Theme
var bool bUseMenuColors;

var DeusExNote Notes[10];
var int NotesCount;

var bool bEditableNotes;                //If the notes should be read only but selectable, or non-interactive entirely.

var PersonaNotesEditWindow firstNoteWindow;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	winBackground = HUDInformationDisplay(NewChild(Class'HUDInformationDisplay'));
}

function SetEditable(bool bValue)
{
    bEditableNotes = bValue;
}

function CreateNotesList()
{
	winScroll = CreateScrollTileWindow(20, 20, width - 40, height - 40);
}

function AddNote(DeusExNote Note)
{
    local int i;

    if (Note == None)
        return;

    //Check for already passed in notes, for
    //computers with multiple logins with the same password,
    //(fuck you Damocles!)
    for (i = 0;i < NotesCount;i++)
        if (Notes[i] == Note)
            return;

    Notes[NotesCount++] = Note;
}

function Resize(float width, float height)
{
    super.SetSize(width,height);

    if (winScroll != None)
    {
        winScroll.SetPos(20,20);
        winScroll.SetSize(width - 40,height - 40);
    }
    if (winBackground != None)
    {
        winBackground.SetPos(0,0);
        winBackground.SetSize(width,height);
    }
}

event DestroyWindow()
{
    super.DestroyWindow();
    DestroyAllChildren();
    winScroll = None;
    winBackground = None;
}

// ----------------------------------------------------------------------
// WindowReady()
// ----------------------------------------------------------------------

function ResetNotePosition()
{
    DeusExPlayer(GetPlayerPawn()).DebugMessage("ResetNotePosition");
	// Make sure the most recent note is scrolled to the top
	if (firstNoteWindow != None)
		firstNoteWindow.AskParentToShowArea();
}
// ----------------------------------------------------------------------
// CreateScrollTileWindow()
// ----------------------------------------------------------------------

function PersonaScrollAreaWindow CreateScrollTileWindow(
	int posX, int posY,
	int sizeX, int sizeY)
{
	local TileWindow tileWindow;
	local PersonaScrollAreaWindow winScroll;

	winScroll = PersonaScrollAreaWindow(NewChild(Class'PersonaScrollAreaWindow'));
	winScroll.SetPos(posX, posY);
	winScroll.SetSize(sizeX, sizeY);

	tileWindow   = CreateTileWindow(winScroll.clipWindow);
    PopulateNotes(tileWindow);

	return winScroll;
}

// ----------------------------------------------------------------------
// CreateTileWindow()
// ----------------------------------------------------------------------

function TileWindow CreateTileWindow(Window parent)
{
	local TileWindow tileWindow;

	// Create Tile Window inside the scroll window
	tileWindow = TileWindow(parent.NewChild(Class'TileWindow'));
	tileWindow.SetFont(Font'FontMenuSmall');
	tileWindow.SetOrder(ORDER_Down);
	tileWindow.SetChildAlignments(HALIGN_Full, VALIGN_Top);
	tileWindow.MakeWidthsEqual(False);
	tileWindow.MakeHeightsEqual(False);
	tileWindow.SetMinorSpacing(4);

	return tileWindow;
}

// ----------------------------------------------------------------------
// PopulateNotes()
//
// Loops through all the notes and displays them
// SARGE: Ignore hidden notes
// ----------------------------------------------------------------------

function PopulateNotes(TileWindow winTile)
{
	local PersonaNotesEditWindow noteWindow;
    local DeusExNote note;
	local bool   bWasVisible;
    local int i;

	// Hide the notes, so we don't flood the tile window with ConfigureChanged() events
	bWasVisible = winTile.IsVisible(FALSE);
	winTile.Hide();

	// First make sure there aren't already notes
	winTile.DestroyAllChildren();

    if (player.bHardcoreMode || player.iNoKeypadCheese > 0)
    {
        //All notes mode - simply display everything
        note = player.FirstNote;
        while(note != None)
        {
            if (!note.bHidden)
                noteWindow = CreateNoteEditWindow(winTile,note);
            note = note.next;

            if (noteWindow != None && firstNoteWindow == None)
                firstNoteWindow = noteWindow;
        }
    }
    else
    {
        //Relevant mode - Loop through all the relevant, passed-in notes
        for(i = 0;i < NotesCount;i++)
        {
            if (!Notes[i].bHidden)
                noteWindow = CreateNoteEditWindow(winTile,Notes[i]);
            
            if (noteWindow != None && firstNoteWindow == None)
                firstNoteWindow = noteWindow;
        }
    }

	// Show the notes again, if they were visible before
	winTile.Show(bWasVisible);

    ResetNotePosition();
}

// ----------------------------------------------------------------------
// Creates a note edit window
// ----------------------------------------------------------------------

function PersonaNotesEditWindow CreateNoteEditWindow(TileWindow winTile, DeusExNote note)
{
	local PersonaNotesEditWindow newNoteWindow;

	newNoteWindow = PersonaNotesEditWindow(winTile.NewChild(Class'PersonaNotesEditWindow'));
    newNoteWindow.SetNote(note);
    if (bEditableNotes)
    {
        newNoteWindow.SetReadOnly(true);
        newNoteWindow.bBlockEscape = true;
    }
    else
        newNoteWindow.EnableEditing(false);
    newNoteWindow.bUseMenuColors = bUseMenuColors;
    newNoteWindow.StyleChanged();
    //newNoteWindow.SetTextAlignments(HALIGN_Left, VALIGN_Center);
    //newNoteWindow.SetTheme(player);
    //newNoteWindow.SetText(note.text);

	return newNoteWindow;
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

    ApplyStyleToChildren();
}

//SARGE: Horrible hacks to make the child objects conform!
function ApplyStyleToChildren()
{
    if (winScroll != None)
    {
        winScroll.upButton.SetButtonColors(colBorder, colBorder, colBorder, colBorder, colBorder, colBorder);
        winScroll.downButton.SetButtonColors(colBorder, colBorder, colBorder, colBorder, colBorder, colBorder);

        winScroll.vScale.SetScaleColor(colBorder);
        winScroll.vScale.SetThumbColor(colBorder);
        winScroll.colButtonFace = colBorder;
    }

    if (winBackground != None)
    {
        winBackground.colBackground = colBackground;
        winBackground.colBorder = colBorder;
    }
}

defaultproperties
{
    msgRelevantNote="Relevant Note:"
    bEditableNotes=true
}
