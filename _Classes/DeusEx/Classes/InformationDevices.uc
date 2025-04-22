//=============================================================================
// InformationDevices.
//=============================================================================
class InformationDevices extends DeusExDecoration
	abstract;

var() name					textTag, FemaleTextTag; //LDDP, 10/25/21: Added female equivalent text tag. Set automatically.
var() string				TextPackage;
var() class<DataVaultImage>	imageClass;

var transient HUDInformationDisplay infoWindow;		// Window to display the information in
var transient TextWindow winText;				// Last text window we added
var transient PersonaImageWindow winImages;     // Last image window we added
var Bool bSetText;
var Bool bAddToVault;					// True if we need to add this text to the DataVault
var String vaultString;
var DeusExPlayer aReader;				// who is reading this?
var localized String msgNoText;
var Bool bFirstParagraph;
var localized String ImageLabel;
var localized String AddedToDatavaultLabel;

//SARGE: Set to true when we have read this once. Used for blanking datacubes
var travel bool bRead;

// Called when the device is read
function OnBeginRead(DeusExPlayer reader) { }
function OnEndRead(DeusExPlayer reader) { }

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
    local DeusExPlayer player;

	// restore the crosshairs and the other hud elements
	if (aReader != None)
	{
        OnEndRead(aReader);
        aReader.UpdateCrosshair();
	}

	if (infoWindow != None)
	{
		infoWindow.ClearTextWindows();
		infoWindow.Hide();
	}

	infoWindow = None;
	winText = None;
    winImages = None;
	aReader = None;
}

// ----------------------------------------------------------------------
// Tick()
//
// Only display the window while the player is in front of the object
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	local DeusExPlayer player;
    player = DeusExPlayer(GetPlayerPawn());

	// if the reader strays too far from the object, kill the text window
	if ((aReader != None) && (infoWindow != None))
		if (aReader.FrobTarget != Self)
			DestroyWindow();
    
    //If we shouldn't be created, abort
    if (!bFirstTickDone && !ShouldCreate(player))
        Destroy();

    bFirstTickDone = true;
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
			if (infoWindow == None)
				player.ClientMessage(msgNoText);
            else
                player.UpdateCrosshair();
		}
		else
		{
			DestroyWindow();
            player.UpdateCrosshair();
		}
	}
}

//SARGE: Since we now support arrbitrary text, we need to get packages separately
function GetText()
{
	local DeusExTextParser parser;
    local name UseTextTag;
	local DeusExRootWindow rootWindow;
	local DeusExNote note;
	
    rootWindow = DeusExRootWindow(aReader.rootWindow);

    //LDDP, 10/25/21: Convert usage to female text flag when female.
	if ((aReader != None) && (aReader.FlagBase != None) && (aReader.FlagBase.GetBool('LDDPJCIsFemale')))
	{
		UseTextTag = FemaleTextTag;
	}
	if (!bool(UseTextTag)) UseTextTag = TextTag;

	// First check to see if we have a name
	if ( textTag != '' )
	{
		// Create the text parser
		parser = new(None) Class'DeusExTextParser';

		// Attempt to find the text object
		if ((aReader != None) && (parser.OpenText(textTag,TextPackage)))
		{
			parser.SetPlayerName(aReader.TruePlayerName);

			infoWindow = rootWindow.hud.ShowInfoWindow();
			infoWindow.ClearTextWindows();

			vaultString = "";
			bFirstParagraph = True;

			while(parser.ProcessText())
				ProcessTag(parser);

			parser.CloseText();

			// Check to see if we need to save this string in the
			// DataVault
            // SARGE: Now we always add it, but hide it if it's not supposed to be added
            note = aReader.GetNote(textTag);

            if (note == None)
                aReader.NoteAdd(vaultString, False, !bAddToVault, textTag);

            vaultString = "";
		}
		CriticalDelete(parser);
	}


}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	local DeusExRootWindow rootWindow;
	local DataVaultImage image;
	local bool bImageAdded;

    local bool bWon;

	rootWindow = DeusExRootWindow(aReader.rootWindow);
        
    bRead = true;
    OnBeginRead(aReader);

    GetText();
    
	// do we have any image data to give the player?
	if ((imageClass != None) && (aReader != None))
	{
		image = Spawn(imageClass, aReader);
		if (image != None)
		{
			image.GiveTo(aReader);
			image.SetBase(aReader);
			bImageAdded = aReader.AddImage(image);

			// Display a note to the effect that there's an image here,
			// but only if nothing else was displayed
			if (infoWindow == None)
			{
				infoWindow = rootWindow.hud.ShowInfoWindow();
				winText = infoWindow.AddTextWindow();
				winText.SetText(Sprintf(ImageLabel, image.imageDescription));
                winText.SetTextAlignments(HALIGN_Center, VALIGN_Top);               //SARGE: Added.

                //SARGE: Show data cube images.
                if (aReader.bShowDataCubeImages)
                {
                    winImages = infoWindow.AddImageWindow();
                    winImages.SetImage(image);
                }
			}

			// Log the fact that the user just got an image.
			if (bImageAdded)
			{
				aReader.ClientMessage(Sprintf(AddedToDatavaultLabel, image.imageDescription));
			}
		}
	}
}

// ----------------------------------------------------------------------
// ProcessTag()
// ----------------------------------------------------------------------

function ProcessTag(DeusExTextParser parser)
{
	local String text;
//	local EDeusExTextTags tag;
	local byte tag;
	local Name fontName;
	local String textPart;

	tag  = parser.GetTag();

	// Make sure we have a text window to operate on.
	if (winText == None)
	{
		winText = infoWindow.AddTextWindow();
		bSetText = True;
	}

	switch(tag)
	{
		// If a winText window doesn't yet exist, create one.
		// Then add the text
		case 0:				// TT_Text:
		case 9:				// TT_PlayerName:
		case 10:			// TT_PlayerFirstName:
			text = parser.GetText();

			// Add the text
			if (bSetText)
				winText.SetText(text);
			else
				winText.AppendText(text);

			vaultString = vaultString $ text;
			bSetText = False;
			break;

		// Create a new text window
		case 18:			// TT_NewParagraph:
			// Create a new text window
			winText = infoWindow.AddTextWindow();

			// Only add a return if this is not the *first*
			// paragraph.
			if (!bFirstParagraph)
				vaultString = vaultString $ winText.CR();

			bFirstParagraph = False;

			bSetText = True;
			break;

		case 13:				// TT_LeftJustify:
			winText.SetTextAlignments(HALIGN_Left, VALIGN_Center);
			break;

		case 14:			// TT_RightJustify:
			winText.SetTextAlignments(HALIGN_Right, VALIGN_Center);
			break;

		case 12:				// TT_CenterText:
			winText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
			break;

		case 26:			// TT_Font:
//			fontName = parser.GetName();
//			winText.SetFont(fontName);
			break;

		case 15:			// TT_DefaultColor:
		case 16:			// TT_TextColor:
		case 17:			// TT_RevertColor:
			winText.SetTextColor(parser.GetColor());
			break;
	}
}


function postbeginplay()
{
    local string TS;

    //LDDP, 10/25/21: We now have a female text tag variable. Conjure one based off our base text flag, assuming it's not blank.
	if (bool(TextTag))
	{
		TS = "FemJC"$string(TextTag);
		SetPropertyText("FemaleTextTag", TS);
	}


	super.postbeginplay();
}

exec function UpdateHDTPsettings()
{
	local texture newtex, swaptex;
	local string str, tempstr;

	Super.UpdateHDTPsettings();

    //Only apply new book styles if we have HDTP enabled
    if (!IsHDTP())
    {
        skin = default.Skin;
        Multiskins[0] = default.Multiskins[0];
        Multiskins[1] = default.Multiskins[1];
        Multiskins[2] = default.Multiskins[2];
        Multiskins[3] = default.Multiskins[3];
        return;
    }

	//gah superclass badness
	if(Newspaper(self) != none)
	{
		//use daveyboy's custom text-specific skins (if found)! Woo!
		if(texttag != '')
		{
			str = "HDTPPapers.Papers.HDTP";
			str = str$string(texttag);
			newtex = texture(dynamicloadobject(str,class'texture'));
				if(newtex != none)
					skin = newtex;
				else
					log("fail!"$str,name);
		}
		//now use a random one from the list if we don't find a match
		if(newtex == none)
		{
			str = "HDTPPapers.Papers.HDTPExtra_Newspaper0";
			str = str$string(rand(4)+1);
			swaptex = texture(dynamicloadobject(str,class'texture'));
			if(swaptex != none)
				skin = swaptex;
		}
	}
	else if(NewspaperOpen(self) != none) //different textures for some of these
	{
		if(texttag != '')
		{
			str = "HDTPPapers.Papers.HDTP";
			str = str$string(texttag);
			str = str$"long";
			swaptex = texture(dynamicloadobject(str,class'texture'));
			if(swaptex != none)
				skin = swaptex;
			else
				log("fail!"$str,name);
		}
	}
	else if(BookClosed(self) != none)
	{
		if(texttag != '')
		{
			str = "HDTPBookClosed.Books.HDTP";
			str = str$GetString(string(texttag),true); //awful awful code
            if (iHDTPModelToggle >= 2) //SARGE: Only use "extra book covers" with the extended setting
            {
                newtex = texture(dynamicloadobject(str,class'texture'));
				if(newtex != none)
					skin = newtex;
				else
					log("fail!"$str,name);
            }
		}
	}
	else if(BookOpen(self) != none)
	{
		if(texttag != '')
		{
			str = "HDTPBookOpen.Books.HDTP";
			str = str$string(texttag);
            newtex = texture(dynamicloadobject(str,class'texture'));
            if(newtex != none)
            {
                Multiskins[2] = newtex;
                Multiskins[3] = newtex;
            }
            else
                log("fail!"$str,name);
			//and now backs
			str = "HDTPBookOpen.Books.HDTP";
			tempstr = GetString(string(texttag),false); //awful awful code
			//if(tempstr == string(texttag)) //nothing changed
			//{
				str = str$tempstr$"back";
                if (iHDTPModelToggle >= 1) //SARGE: Only use "extra book covers" with the extended setting
                {
                    newtex = texture(dynamicloadobject(str,class'texture'));
                    if(newtex != none)
                    {
                        Multiskins[0] = newtex;
                        Multiskins[1] = newtex;
                    }
                    else
                        log("fail!"$str,name);
                }
//			}
//			else //special case
//			{
//				str = str$tempstr;
//				log("looking for "$str,name);
//				newtex = texture(dynamicloadobject(str,class'texture'));
//				if(newtex != none)
//			    {
//					Multiskins[0] = newtex;
//					Multiskins[1] = newtex;
//				}
//				else
//					log("fail!",name);
//			}
		}
	}
}


function string GetString(string text, bool bClosed)
{
	if(bClosed)
	{
		if(Instr(text,"01_Book0") != -1)  //we might be a unatco book
		{
			if(Instr(text,"Book01") != -1)
				return "01_BookUNATCO";
			if(Instr(text,"Book02") != -1)
				return "01_BookUNATCO";
			if(Instr(text,"Book03") != -1)
				return "01_BookUNATCO";
			if(Instr(text,"Book04") != -1)
				return "01_BookUNATCO";
			if(Instr(text,"Book06") != -1)
				return "01_BookUNATCO";
			if(Instr(text,"Book07") != -1)
				return "01_BookUNATCO";
			if(Instr(text,"Book08") != -1)
				return "01_BookUNATCO";
			if(Instr(text,"Book09") != -1)
				return "01_BookUNATCO";
			return text;
		}
		return text;
	}
	else
	{
		//ok, we have UNATCO, we have jacobs shadow, and we have TMWWT too
		if((Instr(text,"00_Book01") != -1) || (Instr(text,"01_Book05") != -1) || (Instr(text,"01_Book06") != -1))//we might be a unatco book
			return "UNATCO";
		else if((Instr(text,"11_Book04") != -1) || (Instr(text,"11_Book05") != -1) || (Instr(text,"11_Book06") != -1) || (Instr(text,"11_Book07") != -1))
			return "06_Book04";
		else if((Instr(text,"06_Book02") != -1) || (Instr(text,"06_Book06") != -1))
			return "01_Book10"; //project dibbuk
		else if((Instr(text,"09_Book02") != -1) || (Instr(text,"12_Book01") != -1) || (Instr(text,"15_Book01") != -1))
			return "_BookShad"; //jacobs shadow
		else if(Instr(text,"06_Book07") != -1)
			return "06_Book01"; //mj12 back
		return text;
	}
	return text;
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     TextPackage="DeusExText"
     msgNoText="It is blank"
     ImageLabel="[Image: %s]"
     AddedToDatavaultLabel="Image %s added to DataVault"
     FragType=Class'DeusEx.PaperFragment'
     bPushable=False
	 bHDTPFailsafe=False
}
