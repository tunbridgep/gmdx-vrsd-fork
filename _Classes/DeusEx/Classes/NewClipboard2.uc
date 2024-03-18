//=============================================================================
// Flask.
//=============================================================================
class NewClipboard2 extends DeusExDecoration;

var Localized String				hackText;
var Localized String				hackText2;
var() bool              sClip;
var() bool              sClip2;
var transient HUDInformationDisplay infoWindow;		// Window to display the information in
var transient TextWindow winText;				// Last text window we added
var Bool bSetText;
var DeusExPlayer aReader;				// who is reading this?

// ----------------------------------------------------------------------
// Destroyed()
//
// If the item is destroyed, make sure we also destroy the window
// if it happens to be visible!
// ----------------------------------------------------------------------

function Destroyed()
{
	DestroyWindow();

	Super.Destroyed();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

function DestroyWindow()
{
	// restore the crosshairs and the other hud elements
	if (aReader != None)
	{
		DeusExRootWindow(aReader.rootWindow).hud.cross.SetCrosshair(aReader.bCrosshairVisible);
		DeusExRootWindow(aReader.rootWindow).hud.frobDisplay.Show();
	}

	if (infoWindow != None)
	{
		infoWindow.ClearTextWindows();
		infoWindow.Hide();
	}

	infoWindow = None;
	winText = None;
	aReader = None;
}

// ----------------------------------------------------------------------
// Tick()
//
// Only display the window while the player is in front of the object
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	// if the reader strays too far from the object, kill the text window
	if ((aReader != None) && (infoWindow != None))
		if (aReader.FrobTarget != Self)
			DestroyWindow();
}

// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------

function Frob(Actor Frobber, Inventory frobWith)
{
	local DeusExPlayer player;

	Super.Frob(Frobber, frobWith);

	player = DeusExPlayer(Frobber);

	if (player != None)
	{
		if (infoWindow == None)
		{
			aReader = player;
			CreateInfoWindow();

			// hide the crosshairs if there's text to read, otherwise display a message
			if (infoWindow != None)
			{
				DeusExRootWindow(player.rootWindow).hud.cross.SetCrosshair(False);
				DeusExRootWindow(player.rootWindow).hud.frobDisplay.Hide();
			}
		}
		else
		{
			DestroyWindow();
		}
	}
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	local DeusExTextParser parser;
	local DeusExRootWindow rootWindow;
	local DeusExNote note;
	local DataVaultImage image;
	local bool bImageAdded;

	rootWindow = DeusExRootWindow(aReader.rootWindow);

	// First check to see if we have a name
	if (sClip)
	{
	    infoWindow = rootWindow.hud.ShowInfoWindow();
	    infoWindow.ClearTextWindows();

	    if (winText == None)
	    {
		winText = infoWindow.AddTextWindow();
        winText.SetText(hackText);
		//winText.AppendText(text);
        //winText.SetTextColor(parser.GetColor());
        winText.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	    }
	}
	else if (sClip2)
	{
	    infoWindow = rootWindow.hud.ShowInfoWindow();
	    infoWindow.ClearTextWindows();

	    if (winText == None)
	    {
		winText = infoWindow.AddTextWindow();
        winText.SetText(hackText2);
		//winText.AppendText(text);
        //winText.SetTextColor(parser.GetColor());
        winText.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	    }
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

 //    TextPackage="DeusExText"
 //    msgNoText="It is blank"
 //    ImageLabel="[Image: %s]"
 //    AddedToDatavaultLabel="Image %s added to DataVault"
 //    FragType=Class'DeusEx.PaperFragment'
 //    bPushable=False

defaultproperties
{
     hackText2="Frank,|n|nAs you spilt coffee all over your computer (idiot) we'll have to do this the old fashioned way: pen and paper. |nYour orders are to send out an alert to all posted patrol employees of this sector -- I want all to guard the door leading to sector 3 indefinitely. |nThe order's come straight from the top, code red, so make sure nobody is slacking off in Rec. |nWe've an assault team on standby ready to react to the first alarm call, but if any assailants make it this far into the base don't expect to even see them coming, so assemble the troops and make sure they're prepared. |n|nF. Barose,|nChief Security Officer"
     HitPoints=10
     FragType=Class'DeusEx.WoodFragment'
     bCanBeBase=True
     ItemName="Clipboard"
     bPushable=False
     Mesh=LodMesh'GameMedia.Clipboard2'
     CollisionRadius=11.500000
     CollisionHeight=0.800000
     Mass=8.000000
     Buoyancy=3.000000
}
