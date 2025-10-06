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
var() Bool bAddToVault;					// True if we need to add this text to the DataVault
var String vaultString;
var DeusExPlayer aReader;				// who is reading this?
var localized String msgNoText;
var Bool bFirstParagraph;
var localized String ImageLabel;
var localized String AddedToDatavaultLabel;
var localized String msgNextPage;                   //Text to go to the next page
var localized String msgRead;                       //Text to add to name if it's been read
var localized String msgEmpty;                      //Text to add to name if it's empty.

//SARGE: Set to true when we have read this once. Used for blanking datacubes
var travel bool bRead;

//SARGE: For datacubes with both images and text, allow paging through them.
var transient bool bPageTwo;

//SARGE: Frob string handling
var string itemTitle;
struct Title
{
    var string textTag;
    var localized string replacement;
};

var const Title bookTitles[20];
var const Title newspaperTitles[20];
var const Title datacubeTitles[150];
var const Title shenanigansTitles[10];
var const string titleIgnored[100];
var const string titlePrefixes[100];
var const string upcases[100];
var const localized bool bShowNamePrefix;
var const localized int minParagraphs;

// Called when the device is read
function OnBeginRead(DeusExPlayer reader) { }
function OnEndRead(DeusExPlayer reader) { }

function bool IsRead(optional DeusExPlayer player, optional bool bIndividual)
{
    if (player == None)
        player = DeusExPlayer(GetPlayerPawn());

    if (bIndividual)
        return bRead || textTag == '';
    else
        return bRead || textTag == '' || (player != None && player.GetNote(textTag) != None);
}

//HUGE list of hardcoded *ugh!!* object titles.
//This idea is very similar to the same idea in DXRando, so credit
//goes to them for thinking of this. Except I just use the first line,
//since it fits in most cases, with some exceptions defined for specific instances.
function string GetItemTitle()
{
    local string tag, text, textPart;
	local DeusExTextParser parser;
    local int i;
    local bool bWrite, bPrefix, bWritten;
    local bool bMatch;
	local byte T;
    local int paragraphs;
    local DeusExPlayer player;
	
    if ( textTag == '' && imageClass == None)
        return msgEmpty;
    else if (textTag == '' && imageClass != None)
        return imageClass.default.imageDescription;

    //Some objects need special handling
    tag = textPackage $ "." $ texttag;
    player = DeusExPlayer(GetPlayerPawn());

    if (player != None && player.bShenanigans)
    {
        for (i = 0; i < ArrayCount(shenanigansTitles);i++)
        {
            if (shenanigansTitles[i].textTag == tag)
                return shenanigansTitles[i].replacement;
        }
    }
    for (i = 0; i < ArrayCount(datacubeTitles);i++)
    {
        if (IsA('DataCube') && datacubeTitles[i].textTag == tag)
            return datacubeTitles[i].replacement;
    }
    for (i = 0; i < ArrayCount(bookTitles);i++)
    {
        if ((IsA('BookOpen') || IsA('BookClosed')) && bookTitles[i].textTag == tag)
            return bookTitles[i].replacement;
    }
    for (i = 0; i < ArrayCount(newspaperTitles);i++)
    {
        if ((IsA('Newspaper') || IsA('NewspaperOpen')) && newspaperTitles[i].textTag == tag)
            return bookTitles[i].replacement;
    }

    //If we didn't return, use the generic solution
    //Get the first line of the text
    parser = new(None) Class'DeusExTextParser';
    parser.OpenText(textTag,TextPackage);
    while(parser.ProcessText())
    {
        bWrite = true;
        bPrefix = false;
        textPart = parser.GetText();
        T = parser.GetTag();
        
        //Log("----");

        //Log("Tag: " $ T);

        if (T == 18 && bWritten)
        {
            paragraphs++;
            if (paragraphs >= minParagraphs)
                break;
        }

        //Log("TextPart (pre-trim): [" $ TextPart $ "]");

        //Fix the text having leading/trailing spaces
        textPart = class'DeusExPlayer'.static.Trim(textPart);
        textPart = class'DeusExPlayer'.static.RTrim(textPart);
        
        //Log("TextPart (post-trim): [" $ TextPart $ "]");
            
        //If the line is empty, ignore it
        if (TextPart == "")
        {
            bWrite = false;
        }
        else
        {
            //if this is an ignored line, pretend it doesn't exist
            for(i = 0;i < ArrayCount(titleIgnored);i++)
            {
                if (titleIgnored[i] != "" && titleIgnored[i] ~= Left(textPart,Len(titleIgnored[i])))
                //if (titleIgnored[i] ~= textPart)
                {
                    bWrite = false;
                    break;
                }
            }
        
            //if this is a prefix line, add it to the string but continue
            for(i = 0;i < ArrayCount(titlePrefixes);i++)
            {
                if (titlePrefixes[i] != "" && titlePrefixes[i] ~= Left(textPart,Len(titlePrefixes[i])))
                //if (titlePrefixes[i] ~= textPart)
                {
                    bPrefix = true;
                    break;
                }
            }
        }
        
        //Log("TextPart: [" $ TextPart $ "] - " $ bWrite $ ", " $ bPrefix $ " [" $ Text $ "]");

        if (bWrite)
        {
            //Convert to title case
            textPart = class'DeusExPlayer'.static.TitleCase(textPart);

            if (text != "")
                text = text $ " - " $ textPart;
            else
                text = textPart;

            if (!bPrefix)
                bWritten = true;
        }
    }
    parser.CloseText();
    CriticalDelete(parser);
        
    //Log("Text (Before case conversion): " $ Text);
    
    //Log("Text (After case conversion): " $ Text);

    //Text Replacements
    for(i = 0;i < ArrayCount(upcases);i++)
    {
        if (upcases[i] != "")
            text = class'DeusExPlayer'.static.StrRepl(text,upcases[i],Caps(upcases[i]));
    }
    
    //Log("Text (After replacements): " $ Text);

    //Strip off anything more than 100 characters
    text = Left(text,100);
    
    //Log("Text (Final): " $ Text);

    if (text == "")
        return msgEmpty;
    else
        return text;
}


//Sarge: Update with a horrible list of crap!
function string GetFrobString(DeusExPlayer player)
{
    local string frobString;
    local bool bShow;

    bShow = (player.iToolWindowShowBookNames >= 2 || (player.iToolWindowShowBookNames == 1 && IsRead(player)));
    
    if (itemTitle != "" && bShow)
    {
        if (bShowNamePrefix)
            frobString = itemName $ ": " $ itemTitle;
        else
            frobString = itemTitle;

        if (player.bGMDXDebug)
            frobString = "[Tag: " $ TextPackage $ "." $ textTag $ "]" @ frobString;
    }
    else
        frobString = itemName;

    return frobString;
}

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

    bPageTwo = false;
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
		if (infoWindow == None || bPageTwo)
		{
			aReader = player;
			CreateInfoWindow();

			// hide the crosshairs if there's text to read, otherwise display a message
			if (infoWindow == None)
				player.ClientMessage(msgNoText);
            else
            {
                player.UpdateCrosshair();
                player.ClearReceivedItems(); //SARGE: Clear received items window as it's blocking the reading window
            }
		}
		else
		{
			DestroyWindow();
            player.UpdateCrosshair();
		}

        //SARGE: Re-cache the fancy item name, to make testing easier.
        if (player.bGMDXDebug)
            itemTitle = GetItemTitle();
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

    if (!bPageTwo)
        GetText();
    
	// do we have any image data to give the player?
	if ((imageClass != None) && (aReader != None))
	{
        //SARGE: Images were being spawned every time we read??
        image = DataVaultImage(aReader.FindInventoryType(imageClass));

        if (image == None)
            image = Spawn(imageClass, aReader);

		if (image != None)
		{
			image.GiveTo(aReader);
			image.SetBase(aReader);
			bImageAdded = aReader.AddImage(image);

			// Display a note to the effect that there's an image here,
			// but only if nothing else was displayed
			if (infoWindow == None || bPageTwo)
			{
				infoWindow = rootWindow.hud.ShowInfoWindow();
                infoWindow.ClearTextWindows();
				winText = infoWindow.AddTextWindow();
				winText.SetText(Sprintf(ImageLabel, image.imageDescription));
                winText.SetTextAlignments(HALIGN_Center, VALIGN_Top);               //SARGE: Added.

                //SARGE: Show data cube images.
                if (aReader.bShowDataCubeImages)
                {
                    winImages = infoWindow.AddImageWindow();
                    winImages.SetImage(image);
                    bPageTwo = false;
                }
			}
            else if (aReader.bShowDataCubeImages)
            {
                bPageTwo = true;
				winText = infoWindow.AddTextWindow();
				winText.SetText("");
				winText.SetText(msgNextPage);
                winText.SetTextAlignments(HALIGN_Center, VALIGN_Top);               //SARGE: Added.
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

    //SARGE: Cache the fancy item name.
    itemTitle = GetItemTitle();

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
     bLeftGrab=True
     TextPackage="DeusExText"
     msgNoText="It is blank"
     msgEmpty="Empty"
     ImageLabel="[Image: %s]"
     AddedToDatavaultLabel="Image %s added to DataVault"
     FragType=Class'DeusEx.PaperFragment'
     bPushable=False
	 bHDTPFailsafe=False
     bShowNamePrefix=True
     msgNextPage="[Press again to view Image]"
     
     minParagraphs=2
     
     //These are now done automagically.
     //bookTitles(0)=(textTag="DeusExText.01_Book01",replacement="UNATCO Handbook - Welcome to UNATCO!")
     //bookTitles(1)=(textTag="DeusExText.01_Book02",replacement="UNATCO Handbook - UNATCO and the Public")
     //bookTitles(2)=(textTag="DeusExText.01_Book03",replacement="UNATCO Handbook - UNATCO and the Police")
     //bookTitles(4)=(textTag="DeusExText.01_Book05",replacement="UNATCO Handbook - UNATCO and the Future")
     bookTitles(0)=(textTag="DeusExText.01_Book08",replacement="UNATCO Handbook - Dedication")
     bookTitles(1)=(textTag="DeusExText.03_Book06",replacement="Curly's Journal")
     bookTitles(2)=(textTag="DeusExText.06_Book07",replacement="Scrawled Note")
     bookTitles(3)=(textTag="DeusExText.11_Book10",replacement="Journal")

     datacubeTitles(0)=(textTag="DeusExText.01_Datacube01",replacement="Joseph Manderley Password Change")
     datacubeTitles(1)=(textTag="DeusExText.01_Datacube03",replacement="Comm Van Code")
     datacubeTitles(2)=(textTag="DeusExText.01_Datacube04",replacement="Security Login")
     datacubeTitles(3)=(textTag="DeusExText.01_Datacube05",replacement="Password Change Request")
     datacubeTitles(4)=(textTag="DeusExText.01_Datacube06",replacement="Camera System Login")
     datacubeTitles(5)=(textTag="DeusExText.01_Datacube07",replacement="ATM Code")
     datacubeTitles(6)=(textTag="DeusExText.01_Datacube09",replacement="Janine's Bots - Medical Bot")
     datacubeTitles(7)=(textTag="DeusExText.02_Datacube01",replacement="Note from Commander Frase")
     datacubeTitles(8)=(textTag="DeusExText.02_Datacube02",replacement="New Access Codes")
     datacubeTitles(9)=(textTag="DeusExText.02_Datacube05",replacement="Net Account")
     datacubeTitles(10)=(textTag="DeusExText.02_Datacube07",replacement="Note from Paul")
     datacubeTitles(11)=(textTag="DeusExText.02_Datacube08",replacement="New Account Setup")
     datacubeTitles(12)=(textTag="DeusExText.02_Datacube10",replacement="New Office")
     datacubeTitles(13)=(textTag="DeusExText.02_Datacube11",replacement="Security Grid Online")
     datacubeTitles(14)=(textTag="DeusExText.02_Datacube13",replacement="Account Compromised")
     datacubeTitles(15)=(textTag="DeusExText.02_Datacube15",replacement="Note to Commander Grimaldi")
     datacubeTitles(16)=(textTag="DeusExText.02_Datacube16",replacement="Note to Commander Grimaldi")
     datacubeTitles(17)=(textTag="DeusExText.02_Datacube17",replacement="Note to Commander Frase")
     datacubeTitles(18)=(textTag="DeusExText.03_Datacube05",replacement="Ambrosia Delivery")
     datacubeTitles(19)=(textTag="DeusExText.03_Datacube06",replacement="Perimeter Survey")
     datacubeTitles(20)=(textTag="DeusExText.03_Datacube10",replacement="Hangar Code")
     datacubeTitles(21)=(textTag="DeusExText.03_Datacube11",replacement="Janine's Bots - Repair Bot")
     datacubeTitles(22)=(textTag="DeusExText.03_Datacube12",replacement="Helibase Computer Login")
     datacubeTitles(23)=(textTag="DeusExText.04_Datacube01",replacement="Message to Paul")
     datacubeTitles(24)=(textTag="DeusExText.04_Datacube02",replacement="Security Login")
     datacubeTitles(25)=(textTag="DeusExText.04_Datacube03",replacement="Account Summary")
     datacubeTitles(26)=(textTag="DeusExText.04_Datacube04",replacement="Halon Gas")
     datacubeTitles(27)=(textTag="DeusExText.04_Datacube05",replacement="UNATCO Dossier")
     datacubeTitles(28)=(textTag="DeusExText.05_Datacube01",replacement="Intrusion Attempt")
     datacubeTitles(29)=(textTag="DeusExText.05_Datacube02",replacement="New Password")
     datacubeTitles(30)=(textTag="DeusExText.05_Datacube04",replacement="Armory Code Change")
     datacubeTitles(31)=(textTag="DeusExText.05_Datacube05",replacement="Greasel Dissection")
     datacubeTitles(32)=(textTag="DeusExText.05_Datacube09",replacement="Janine's Bots - Page Bravo-3 Peacebringer")
     datacubeTitles(33)=(textTag="DeusExText.05_Datacube10",replacement="Prospectus - Series P Agents")
     datacubeTitles(34)=(textTag="DeusExText.06_Datacube01",replacement="Hong Kong Challenges")
     datacubeTitles(35)=(textTag="DeusExText.06_Datacube02",replacement="Security Code Reset")
     datacubeTitles(36)=(textTag="DeusExText.06_Datacube03",replacement="Re: Triad Report")
     datacubeTitles(37)=(textTag="DeusExText.06_Datacube04",replacement="Surveillance Report - Triads")
     datacubeTitles(38)=(textTag="DeusExText.06_Datacube05",replacement="I'm Sorry!")
     datacubeTitles(39)=(textTag="DeusExText.06_Datacube06",replacement="Interrogation Recording")
     datacubeTitles(40)=(textTag="DeusExText.06_Datacube08",replacement="VersaLife Sign-In")
     datacubeTitles(41)=(textTag="DeusExText.06_Datacube09",replacement="I Think Something is Going On")
     datacubeTitles(42)=(textTag="DeusExText.06_Datacube10",replacement="Security System Access")
     datacubeTitles(43)=(textTag="DeusExText.06_Datacube11",replacement="Corrupted Security Upgrade")
     datacubeTitles(44)=(textTag="DeusExText.06_Datacube12",replacement="New Server Node")
     datacubeTitles(45)=(textTag="DeusExText.06_Datacube13",replacement="Police Substation Code")
     datacubeTitles(46)=(textTag="DeusExText.06_Datacube14",replacement="Message to Party Leader Xan")
     datacubeTitles(47)=(textTag="DeusExText.06_Datacube15",replacement="Password Change")
     datacubeTitles(48)=(textTag="DeusExText.06_Datacube18",replacement="Password Update")
     datacubeTitles(49)=(textTag="DeusExText.06_Datacube19",replacement="Incident Report - Officer Tam")
     datacubeTitles(50)=(textTag="DeusExText.06_Datacube20",replacement="Instructions for Mort")
     datacubeTitles(51)=(textTag="DeusExText.06_Datacube21",replacement="Book Recommendations")
     datacubeTitles(52)=(textTag="DeusExText.06_Datacube22",replacement="Surveillance Report - Maggie Chow")
     datacubeTitles(53)=(textTag="DeusExText.06_Datacube23",replacement="Hong Kong Network Services - New Account")
     datacubeTitles(54)=(textTag="DeusExText.06_Datacube24",replacement="Superfreighter Refit")
     datacubeTitles(55)=(textTag="DeusExText.06_Datacube25",replacement="Regression Analysis")
     datacubeTitles(56)=(textTag="DeusExText.06_Datacube29",replacement="Augmentation Canister")
     datacubeTitles(57)=(textTag="DeusExText.06_Datacube30",replacement="Note to Self")
     datacubeTitles(58)=(textTag="DeusExText.06_Datacube31",replacement="Welcome to VersaLife!")
     datacubeTitles(59)=(textTag="DeusExText.06_Datacube32",replacement="New Security Procedure")
     datacubeTitles(60)=(textTag="DeusExText.08_Datacube01",replacement="Information for All Staff")
     datacubeTitles(61)=(textTag="DeusExText.09_Datacube01",replacement="Ship Access")
     datacubeTitles(62)=(textTag="DeusExText.09_Datacube03",replacement="Code Change")
     datacubeTitles(63)=(textTag="DeusExText.09_Datacube04",replacement="Note to Self")
     datacubeTitles(64)=(textTag="DeusExText.09_Datacube05",replacement="Message to Walton Simons (Draft)")
     datacubeTitles(65)=(textTag="DeusExText.09_Datacube07",replacement="Note for Doctor Liu")
     datacubeTitles(66)=(textTag="DeusExText.09_Datacube08",replacement="Security Review")
     datacubeTitles(67)=(textTag="DeusExText.09_Datacube09",replacement="Security Restrictions")
     datacubeTitles(68)=(textTag="DeusExText.09_Datacube10",replacement="BlueOS Installation Log")
     datacubeTitles(69)=(textTag="DeusExText.09_Datacube13",replacement="Note to Self")
     datacubeTitles(70)=(textTag="DeusExText.09_Datacube14",replacement="Security Restrictions")
     datacubeTitles(71)=(textTag="DeusExText.10_Datacube02",replacement="Dear Nicolette")
     datacubeTitles(72)=(textTag="DeusExText.10_Datacube03",replacement="Account Security")
     datacubeTitles(73)=(textTag="DeusExText.10_Datacube04",replacement="Get Some Cash!")
     datacubeTitles(74)=(textTag="DeusExText.10_Datacube05",replacement="Account Security")
     datacubeTitles(75)=(textTag="DeusExText.10_Datacube06",replacement="To Do List")
     datacubeTitles(76)=(textTag="DeusExText.10_Datacube07",replacement="Storeroom Code")
     datacubeTitles(77)=(textTag="DeusExText.10_Datacube09",replacement="Welcome to Paris!")
     datacubeTitles(78)=(textTag="DeusExText.10_Datacube10",replacement="Message for Chad")
     datacubeTitles(79)=(textTag="DeusExText.10_Datacube11",replacement="Security Login")
     datacubeTitles(80)=(textTag="DeusExText.11_Datacube02",replacement="Morpheus")
     datacubeTitles(81)=(textTag="DeusExText.11_Datacube03",replacement="Orders")
     datacubeTitles(82)=(textTag="DeusExText.12_Datacube02",replacement="Saddle Up (Draft)")
     datacubeTitles(83)=(textTag="DeusExText.14_Datacube01",replacement="Message for Nasir")
     datacubeTitles(84)=(textTag="DeusExText.14_Datacube02",replacement="Tunnel Code")
     datacubeTitles(85)=(textTag="DeusExText.14_Datacube05",replacement="Security Login")
     datacubeTitles(86)=(textTag="DeusExText.14_Datacube06",replacement="Ridley's Betrayal")
     datacubeTitles(87)=(textTag="DeusExText.15_Datacube01",replacement="Message for Julia")
     datacubeTitles(88)=(textTag="DeusExText.15_Datacube09",replacement="Coolant Door Lock")
     datacubeTitles(89)=(textTag="DeusExText.15_Datacube11",replacement="Message for Alain")
     datacubeTitles(90)=(textTag="DeusExText.15_Datacube12",replacement="Explosives")
     datacubeTitles(91)=(textTag="DeusExText.15_Datacube17",replacement="Security Login")
     datacubeTitles(92)=(textTag="DeusExText.15_Datacube18",replacement="Lab 12 Testing Regimen")
     datacubeTitles(93)=(textTag="DeusExText.15_Datacube19",replacement="Reactor Leak")
     datacubeTitles(94)=(textTag="DeusExText.15_Datacube20",replacement="Get Topside!")
     datacubeTitles(95)=(textTag="DeusExText.00_Datacube03",replacement="Quick Note")
     
     shenanigansTitles(0)=(textTag="DeusExText.06_Datacube17",replacement="Captains Log: Stardate 00.2345.2223")

     titleIgnored(0)="!=!==!==="
     titleIgnored(1)="* = * = * ="
     //titleIgnored(2)="By G. K."
     //titleIgnored(3)="By Andrew"
     //titleIgnored(4)="Report For The New York City Council"
     titleIgnored(5)="By " //Remove the author line from books.
     titleIgnored(6)="U.s. Army" //Way too long title

     titlePrefixes(0)="UNATCO HANDBOOK"

     upcases(0)="Sh-187"
     upcases(1)="Iii"
     upcases(2)=": a " //HACK
     //upcases(1)="Unatco"
     //upcases(2)=" Ny "
     //upcases(3)="Cia "
     //upcases(4)="U.s. "

}
