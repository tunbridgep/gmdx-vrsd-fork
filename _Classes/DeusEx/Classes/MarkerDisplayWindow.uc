//=============================================================================
// MarkerDisplayWindow
// SARGE: This is designed to display markers on the HUD
//=============================================================================
class MarkerDisplayWindow expands Window;

var const Color markerColor;
var const Color noteColor;

var transient DeusExPlayer player;
var transient bool bDisplay;

var transient DeusExLevelInfo dxInfo;

var transient MarkerInfo markers;

const MAX_BOX_SIZE = 10;
const MIN_BOX_SIZE = 4;
const MIN_DISTANCE_TO_SHOW = 50; //Multiplied by 16. Should be in feet.

//Store info about teleporters so we're not endlessly redoing work
struct TeleportInfo
{
    var Vector location;
    var string newURL;
    var float boxSize;      //Ugh, it sucks that we have to do this...
};

var transient TeleportInfo teleporters[10];
var transient int numTeleporters;

var const localized string msgMultipleMarkers; //SARGE: Name for when we have a map transition with multiple markers on the other side.

function bool Setup(bool bShow, DeusExPlayer P, bool bRegenerateTeleporters)
{
    player = P;
    bDisplay = bShow;
    dxInfo = player.GetLevelInfo();
    GenerateMarkerList();
    if (bRegenerateTeleporters)
        GenerateTeleporterList();
}

//Strip the bad parts from the URL
function private string FixURL(string url)
{
    local int pos;
    local string newURL;

    newURL = url;
    pos = InStr(newURL,"#");
    if (pos > 0)
        newURL = Left(newURL,pos);
    pos = InStr(newURL,"/");
    if (pos > 0)
        newURL = Left(newURL,pos);

    //make the name generic (remove the starting mission number)
    newURL = Right(newURL,Len(newURL)-2);

    return newURL;
}

function GenerateTeleporterList()
{
    local Teleporter tele;
    local MapExit exit;
    local Actor connectedActor;

    //Don't even bother if we don't have any markers
    if (player.markers == None)
        return;

    numTeleporters = 0;

    foreach player.AllActors(class'Teleporter',tele)
    {
        if (tele.url ~= "" || numTeleporters >= 10)
            continue;

        teleporters[numTeleporters].newURL = FixURL(tele.URL);
        teleporters[numTeleporters].location = tele.location;
        numTeleporters++;
    }

    foreach player.AllActors(class'MapExit',exit)
    {
        if (exit.DestMap ~= "" || exit.bPlayTransition || numTeleporters >= 10)
            continue;

        //Horrible filthy hack
        if (exit.Tag != '')
        {
            foreach player.AllActors(class'Actor',connectedActor)
            {
                if (connectedActor.Event == exit.Tag)
                {
                    break;
                }
            }
        }
        if (connectedActor == None)
            connectedActor = exit;

        teleporters[numTeleporters].newURL = FixURL(exit.DestMap);
        teleporters[numTeleporters].location = connectedActor.location;
        numTeleporters++;
    }
}

//SARGE: TODO: Make a list once here, so we aren't repeating a bunch of ifs constantly...
function GenerateMarkerList()
{
}

function DrawWindow(GC gc)
{
    Super.DrawWindow(gc);
    
    gc.EnableDrawing(true);
    gc.SetStyle(DSTY_Translucent);
    gc.SetTileColor(markerColor);

    DrawMarkers(gc);
    DrawTeleporters(gc);
}

//Now for the tricky part...
function DrawMarkers(GC gc)
{
    local MarkerInfo marker;
    local float centerX, centerY;
    local bool bFail;
    local float distance;

    if (player == None || !bDisplay || dxInfo == None)
        return;
    
    marker = player.markers;

    while (marker != None)
    {
        bFail = false;
		
        if (!ConvertVectorToCoordinates(marker.Position, centerX, centerY))
            bFail = true;

        if (marker.mapName != dxInfo.GetMapNameGeneric())
            bFail = true;

        if (!bFail)
        {
            DrawSpot(gc,marker.associatedNote.text,centerx,centery,GetBoxSizeMarker(marker));
        }

        marker = marker.next;
    }
}


function float GetBoxSizeTeleporter(int index)
{
    local float boxSize;
    local float distance;

    boxSize = teleporters[index].boxSize;
    
    distance = abs(VSize(player.Location - teleporters[index].location));

    if (distance < MIN_DISTANCE_TO_SHOW * 16 && boxSize < MAX_BOX_SIZE)
        boxSize += 1;
    else if (distance > MIN_DISTANCE_TO_SHOW * 16 && boxSize > MIN_BOX_SIZE)
        boxSize -= 1;

    //Hack to fix it being reset on load
    teleporters[index].boxSize = FMax(4,boxSize);

    return boxSize;
}

function float GetBoxSizeMarker(MarkerInfo marker)
{
    local float boxSize;
    local float distance;

    boxSize = marker.boxSize;
    
    distance = abs(VSize(player.Location - marker.position));

    if (distance < MIN_DISTANCE_TO_SHOW * 16 && boxSize < MAX_BOX_SIZE)
        boxSize += 1;
    else if (distance > MIN_DISTANCE_TO_SHOW * 16 && boxSize > MIN_BOX_SIZE)
        boxSize -= 1;

    //Hack to fix it being reset on load
    marker.boxSize = FMax(4,boxSize);

    return boxSize;
}

//Draw all the teleporters which link to a map containing a given note.
function DrawTeleporters(GC gc)
{
    local int i;
    local string text;
    local float centerX, centerY;
    local MarkerInfo marker;
    local bool bDraw;
    local float distance;
    
    if (player == None || !bDisplay || dxInfo == None)
        return;

    for(i = 0;i < numTeleporters;i++)
    {
        bDraw = false;

        marker = player.markers;
        while (marker != None)
        {
            if (marker.mapName ~= teleporters[i].newURL && marker.associatedNote != None && !marker.associatedNote.bHidden)
            {
                //if there's more than one, just say "multiple markers"
                if (bDraw)
                {
                    text = msgMultipleMarkers;
                    break;
                }
                text = marker.associatedNote.text;
                bDraw = true;
            }
            marker = marker.next;
        }

        if (bDraw && ConvertVectorToCoordinates(teleporters[i].Location, centerX, centerY))
        {
            DrawSpot(gc,text,centerx,centery,GetBoxSizeTeleporter(i));
        }
    }
}

function DrawSpot(GC gc, string text, float centerx, float centery, float boxSize)
{
    local float leftx, rightx, topy, bottomy;
    local float alpha;
    local Color colBox;

    alpha = (boxSize) * 0.1;

    colBox.R = int(float(markerColor.R) * alpha);
    colBox.G = int(float(markerColor.G) * alpha);
    colBox.B = int(float(markerColor.B) * alpha);

    leftX = centerX-boxSize;
    rightX = centerX+boxSize;
    topY = centerY-boxSize;
    bottomY = centerY+boxSize;

    //Draw the edges of the box
    gc.SetTileColorRGB(colBox.R/4, colBox.G/4, colBox.B/4);
    gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');
    leftX += 1;
    rightX -= 1;
    topY += 1;
    bottomY -= 1;
    gc.SetTileColorRGB(colBox.R*3/16, colBox.G*3/16, colBox.B*3/16);
    gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');
    leftX += 1;
    rightX -= 1;
    topY += 1;
    bottomY -= 1;
    gc.SetTileColorRGB(colBox.R/8, colBox.G/8, colBox.B/8);
    gc.DrawBox(leftX, topY, 1+rightX-leftX, 1+bottomY-topY, 0, 0, 1, Texture'Solid');

    
    if (boxSize == MAX_BOX_SIZE)
    {
        //Draw the center point
        gc.SetTileColorRGB(255, 255, 255);
        gc.DrawPattern(centerX, centerY-3, 1, 7, 0, 0, Texture'Solid');
        gc.DrawPattern(centerX-3, centerY, 7, 1, 0, 0, Texture'Solid');

        //Draw the note text
        gc.SetTextColor(noteColor);
        gc.SetAlignments(HALIGN_Center, VALIGN_Bottom);
        gc.SetFont(Font'TechSmall');
        gc.DrawText(leftX-40, topY-140, 80+rightX-leftX, 135, text);
    }
}

defaultproperties
{
    msgMultipleMarkers="Multiple Markers"
    markerColor=(G=255)
    noteColor=(R=255,G=255,B=255)
}
