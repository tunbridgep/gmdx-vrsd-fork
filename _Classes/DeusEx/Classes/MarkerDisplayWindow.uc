//=============================================================================
// MarkerDisplayWindow
// SARGE: This is designed to display markers on the HUD
//=============================================================================
class MarkerDisplayWindow expands Window;

var const Color markerColor;
var const Color noteColor;

var DeusExPlayer player;
var bool bDisplay;

function bool Setup(bool bShow, DeusExPlayer P)
{
    player = P;
    bDisplay = bShow;
}

//Now for the tricky part...
function DrawWindow(GC gc)
{
    local Marker marker;
	
    local float centerX, centerY;
	local float topY, bottomY;
	local float leftX, rightX;
    local Vector tVect;

    Super.DrawWindow(gc);

    if (player == None || !bDisplay)
        return;
    
    gc.EnableDrawing(true);
    gc.SetStyle(DSTY_Translucent);
    gc.SetTileColor(markerColor);

    foreach player.AllActors(class'Marker', marker)
    {
        tVect = marker.Location;
				
        if (!ConvertVectorToCoordinates(tVect, centerX, centerY))
            continue;
        
        //if (marker.associatedNote == None)
        //    continue;

        leftX = centerX-10;
        rightX = centerX+10;
        topY = centerY-10;
        bottomY = centerY+10;
	
        //Draw the edges of the box
        gc.SetTileColorRGB(markerColor.R/4, markerColor.G/4, markerColor.B/4);
        gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');
        leftX += 1;
        rightX -= 1;
        topY += 1;
        bottomY -= 1;
        gc.SetTileColorRGB(markerColor.R*3/16, markerColor.G*3/16, markerColor.B*3/16);
        gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');
        leftX += 1;
        rightX -= 1;
        topY += 1;
        bottomY -= 1;
        gc.SetTileColorRGB(markerColor.R/8, markerColor.G/8, markerColor.B/8);
        gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');

        //Draw the center point
        gc.SetTileColorRGB(255, 255, 255);
        gc.DrawPattern(centerX, centerY-3, 1, 7, 0, 0, Texture'Solid');
        gc.DrawPattern(centerX-3, centerY, 7, 1, 0, 0, Texture'Solid');

        //Draw the note text
        gc.SetTextColor(noteColor);
        gc.SetAlignments(HALIGN_Center, VALIGN_Bottom);
        gc.SetFont(Font'TechSmall');
        if (marker.associatedNote == None)
            gc.DrawText(leftX-40, topY-140, 80+rightX-leftX, 135, "<No Note>");
        else
            gc.DrawText(leftX-40, topY-140, 80+rightX-leftX, 135, marker.associatedNote.text);
    }
}

defaultproperties
{
    markerColor=(G=255)
    noteColor=(R=255,G=255,B=255)
}
