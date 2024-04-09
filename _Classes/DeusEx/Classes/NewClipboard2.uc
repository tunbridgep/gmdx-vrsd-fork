//=============================================================================
// Flask.
//=============================================================================
class NewClipboard2 extends InformationDevices;

var Localized String				hackText;
var Localized String				hackText2;
var() bool              sClip;
var() bool              sClip2;

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
