//=============================================================================
// GoalsDisplayWindow
// SARGE: A new class to encapsulate the Goals display, so it can be used in multiple places.
//=============================================================================

class GoalsDisplayWindow extends HUDBaseWindow;

var tileWindow              mainWindow;

var Texture texBackground;
var Texture texBorder;
var Texture texBorderRight;

var Color colText, colCompletedText, colShadow;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

    //CreateControls();
	//PopulateGoals();
	
    SetSize(400, 400);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------
function DrawBackground(GC gc)
{
    if (gc == None)
        return;

	//gc.SetStyle(backgroundDrawStyle);
	//gc.SetTileColor(colBackground);
    //gc.DrawTexture(9, 13, 80, 54, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// DrawPinnedNotes()
// ----------------------------------------------------------------------

function int DrawPinnedNotes(GC gc, int initialOffset)
{
    local int offset;
    local float textW, textH;
	local DeusExNote note;
    local bool bDoneFirst;
	
    note = player.FirstNote;

    offset = initialOffset;

	while( note != None )
    {
		if (note.bPinned && !note.bHidden)
        {
            //We have a valid note, draw the header first.
            if (!bDoneFirst)
            {
                gc.EnableWordWrap(False);
                gc.SetFont(player.FontManager.GetFont(TT_FontMenuTitle));
                gc.SetTextColor(colShadow);
                gc.DrawText(1, offset+1, 400, 400, class'PersonaScreenGoals'.default.NotesTitleText);
                gc.SetTextColor(colText);
                gc.DrawText(0, offset, 400, 400, class'PersonaScreenGoals'.default.NotesTitleText);
                gc.SetFont(player.FontManager.GetFont(TT_FontMenuSmall));
                offset = offset + 20;
                bDoneFirst = true;
            }
            
            gc.EnableWordWrap(True);
            gc.GetTextExtent(250, textW, textH, note.text);
            
            gc.SetTextColor(colShadow);
            gc.DrawText(1, offset+1, textW, textH, note.text);

            gc.SetTextColor(colText);
            gc.DrawText(0, offset, textW, textH, note.text);

            offset = offset + 5 + textH;
        }

		note = note.next;
    }
    return offset;
}

// ----------------------------------------------------------------------
// DrawGoals()
// ----------------------------------------------------------------------

function int DrawGoals(GC gc, bool bPrimary, int initialOffset)
{
    local int offset;
    local float textW, textH;
	local DeusExGoal goal;
    local bool bDoneFirst;
    local string headerText, text;
	goal = player.FirstGoal;

    offset = initialOffset;

    if (bPrimary)
        headerText = class'PersonaScreenGoals'.default.PrimaryGoalsHeader;
    else
        headerText = class'PersonaScreenGoals'.default.SecondaryGoalsHeader;

	while( goal != None )
    {
		if ((goal.bPrimaryGoal && bPrimary) || (!goal.bPrimaryGoal && !bPrimary))
        {
            if (!goal.bCompleted || player.bDisplayCompletedGoals)
            {
                //We have a valid goal, draw the header first.
                if (!bDoneFirst)
                {
                    gc.EnableWordWrap(False);
                    gc.SetFont(player.FontManager.GetFont(TT_FontMenuTitle));
                    gc.SetTextColor(colShadow);
                    gc.DrawText(1, offset+1, 400, 400, headerText);
                    gc.SetTextColor(colText);
                    gc.DrawText(0, offset, 400, 400, headerText);
                    gc.SetFont(player.FontManager.GetFont(TT_FontMenuSmall));
                    offset = offset + 20;
                    bDoneFirst = true;
                }
                
                if (goal.bCompleted)
                    text = goal.text @ class'PersonaScreenGoals'.default.GoalCompletedText;
                else
                    text = goal.text;
                
                gc.EnableWordWrap(True);
                gc.GetTextExtent(250, textW, textH, text);
                
                gc.SetTextColor(colShadow);
                gc.DrawText(1, offset+1, textW, textH, text);

                if (goal.bCompleted)
                    gc.SetTextColor(colCompletedText);
                else
                    gc.SetTextColor(colText);

                gc.DrawText(0, offset, textW, textH, text);
                offset = offset + 5 + textH;
            }
        }

		goal = goal.next;
    }
    return offset;
}

function int DrawSecondaryGoals(int initialOffset)
{
    local int offset;
	local DeusExGoal goal;
	goal = player.FirstGoal;

    offset = initialOffset;
}

//SARGE TODO: Make this function more efficient since it runs every frame!
//Consider caching the goals and notes to show!
event DrawWindow(GC gc)
{
    local int offset; //Vertical offset. Will increase as notes are added.

    gc.SetAlignments(HALIGN_Left, VALIGN_Top);
    gc.EnableWordWrap(false);

    if (player.bShowGoalsOnScreen)
    {
        //Primary Goals
        offset = DrawGoals(gc,true,offset);

        //Secondary Goals
        offset = DrawGoals(gc,false,offset);
    }

    if (player.bShowPinnedNotesOnScreen)
    {
        //Pinned Notes
        offset = DrawPinnedNotes(gc,offset);
    }
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )
{
	Show( bNewVisibility );
}

defaultproperties
{
     texBackground=Texture'DeusExUI.UserInterface.HUDAmmoDisplayBackground_1'
     texBorder=Texture'DeusExUI.UserInterface.HUDAmmoDisplayBorder_1'
     texBorderRight=Texture'RSDCrap.UserInterface.HUDAmmoDisplayBorder_1F'
     colText=(R=250,G=250,B=250)
     colCompletedText=(R=150,G=150,B=150)
     colShadow=(R=0,G=0,B=0)
}
