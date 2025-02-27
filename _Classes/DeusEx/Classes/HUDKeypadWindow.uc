//=============================================================================
// HUDKeypadWindow
//=============================================================================

class HUDKeypadWindow extends DeusExBaseWindow;

var bool bFirstFrameDone;

var HUDKeypadButton btnKeys[12];
var TextWindow winText;
var string inputCode;

var bool bInstantSuccess;		// we had the skill, so grant access immediately
var bool bWait;

var Keypad keypadOwner;			// what keypad owns this window?

var Texture texBackground;
var Texture texBorder;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;

var localized string msgEnterCode;
var localized string msgAccessDenied;
var localized string msgAccessGranted;

var bool jumpOut;

var globalconfig bool bNumberPadStyle;                                               //SARGE: False for standard (phone pad) style, true for number pad style
var globalconfig bool bDigitDisplay;                                                 //SARGE: Show numbers as we enter them.
var globalconfig bool bReplaceSymbols;                                               //SARGE: Replace the * and # keys with < and C, which remove 1 character or all characters

var bool bIgnore;                                                                    //SARGE: Ignore the next button press

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetWindowAlignments(HALIGN_Center, VALIGN_Center);
	SetSize(103, 162);
	SetMouseFocusMode(MFocus_EnterLeave);

	inputCode="";

	// Create the buttons
	CreateKeypadButtons();
	CreateInputTextWindow();

	bTickEnabled = True;

	StyleChanged();
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------

event DestroyWindow()
{
	Super.DestroyWindow();

	keypadOwner.keypadwindow = None;
}

// ----------------------------------------------------------------------
// InitData()
//
// Do the post-InitWindow stuff
// ----------------------------------------------------------------------

function InitData()
{
	GenerateKeypadDisplay();

	winText.SetTextColor(colHeaderText);
	winText.SetText(msgEnterCode);
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if (!bFirstFrameDone)
	{
		SetCursorPos(width, height);
		bFirstFrameDone = True;

		if (bInstantSuccess)
		{
			inputCode = keypadOwner.validCode;
			ValidateCode(false);
		}
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
//
// DrawWindow event (called every frame)
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	// First draw the background then the border
	DrawBackground(gc);
	DrawBorder(gc);

	Super.DrawWindow(gc);
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	if (bBackgroundTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);

	gc.SetTileColor(colBackground);

	gc.DrawTexture(0, 0, width, height, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		if (bBorderTranslucent)
			gc.SetStyle(DSTY_Translucent);
		else
			gc.SetStyle(DSTY_Masked);

		gc.SetTileColor(colBorder);

		gc.DrawTexture(0, 0, width, height, 0, 0, texBorder);
	}
}

// ----------------------------------------------------------------------
// SARGE: TransposeNumber()
// Now that the keys can be out of order, we need to
// be able to transpose the numbers from the top row to the bottom row
// ----------------------------------------------------------------------

function int TransposeNumber(int number)
{
    if (number < 3 && bNumberPadStyle)
        return 6 + number;
    else if (number > 8 || number < 6 || !bNumberPadStyle)
        return number;
    else
        return number - 6;

}

// ----------------------------------------------------------------------
// CreateKeypadButtons()
// ----------------------------------------------------------------------

function CreateKeypadButtons()
{
	local int i, x, y;

    //SARGE: Rewritten to work as a keypad or a number pad

    //place the buttons
	for (y=0; y<4; y++)
	{
		for (x=0; x<3; x++)
		{
			i = x + y * 3;
			btnKeys[i] = HUDKeypadButton(NewChild(Class'HUDKeypadButton'));
			btnKeys[i].SetPos((x * 26) + 16, (y * 28) + 35);
            btnKeys[i].num = TransposeNumber(i);
		}
	}

    //Vanilla code is below - the non-numberpad version

    /*
	for (y=0; y<4; y++)
	{
		for (x=0; x<3; x++)
		{
			i = x + y * 3;
			btnKeys[i] = HUDKeypadButton(NewChild(Class'HUDKeypadButton'));
			btnKeys[i].SetPos((x * 26) + 16, (y * 28) + 35);
			btnKeys[i].num = i;
		}
	}
    */
}

// ----------------------------------------------------------------------
// CreateInputTextWindow()
// ----------------------------------------------------------------------

function CreateInputTextWindow()
{
	winText = TextWindow(NewChild(Class'TextWindow'));
	winText.SetPos(17, 21);
	winText.SetSize(75, 11);
	winText.SetTextMargins(0, 0);
	winText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winText.SetFont(Font'FontMenuSmall');
	winText.SetTextColor(colHeaderText);
	winText.SetText(msgEnterCode);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local int i;

	bHandled = False;

	for (i=0; i<12; i++)
	{
		if (buttonPressed == btnKeys[i])
		{
            if (!bIgnore)
                PressButton(i);
            bIgnore = false;
			bHandled = True;
			break;
		}
	}

	if (!bHandled)
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
    local int n;               //SARGE: Holds our pressed number, so we can manipulate it.

	bKeyHandled = True;

	if (IsKeyDown(IK_Alt) || IsKeyDown(IK_Ctrl) || bRepeat)
		return False;

    n = -1;

    //SARGE: Allow shift-keying the asterisk and hash keys
    if (IsKeyDown(IK_Shift) && key == IK_3)
        n = -11;
    else if (IsKeyDown(IK_Shift) && key == IK_8)
        n = -9;
    else
	{
		switch(key)
		{
			case IK_0:
			case IK_NUMPAD0:    	n = 10; break;
			case IK_1:
			case IK_NUMPAD1:    	n = 0; break;
			case IK_2:
			case IK_NUMPAD2:    	n = 1; break;
			case IK_3:
			case IK_NUMPAD3:    	n = 2; break;
			case IK_4:
			case IK_NUMPAD4:    	n = 3; break;
			case IK_5:
			case IK_NUMPAD5:    	n = 4; break;
			case IK_6:
			case IK_NUMPAD6:    	n = 5; break;
			case IK_7:
			case IK_NUMPAD7:    	n = 6; break;
			case IK_8:
			case IK_NUMPAD8:    	n = 7; break;
			case IK_9:
			case IK_NUMPAD9:    	n = 8; break;

            //Handle Asterisks and Stars
            //These need to be handled specially, because we still need to
            //differentiate between them, regardless of our keypad button settings
            case IK_GreyStar:   	n = -9; break; //SARGE: Add number pad star
			case IK_SingleQuote:	n = -11; break; //SARGE: Add number pad Hash
            
            //Handle removing characters with Backspace and Delete
            case IK_Backspace:      DoBackspace(); break;
            case IK_Delete:         DoDelete(); break;
            
			default:
				bKeyHandled = False;
		}
	}

	if (!bKeyHandled)
		return Super.VirtualKeyPressed(key, bRepeat);
	else if (n > -1)
    {
        n = TransposeNumber(n);        
        btnKeys[n].PressButton();
    }
    else if (n != -1)
        PressButton(n);
    return bKeyHandled;
}

//SARGE: Allow text deletion
function DoDelete(optional bool skipButton)
{
    //Press the keypad key if we have the keys showing
    //HOLY HARDCODE BATMAN!
    if (bReplaceSymbols && !skipButton)
    {
        bIgnore = true;
        btnKeys[11].PressButton();
    }

    inputCode = "";

    FinishSendKey(sound'Touchtone11');
}

//SARGE: Allow text deletion
function DoBackspace(optional bool skipButton)
{
    //Press the keypad key if we have the keys showing
    //HOLY HARDCODE BATMAN!
    if (bReplaceSymbols && !skipButton)
    {
        bIgnore = true;
        btnKeys[9].PressButton();
    }

    if (Len(inputCode) > 0)
        inputCode = Left(inputCode,Len(inputCode) - 1);

    FinishSendKey(sound'Touchtone10');
}

// ----------------------------------------------------------------------
// PressButton()
//
// User pressed a keypad button
// ----------------------------------------------------------------------

function PressButton(int num)
{
	local sound tone;

	if (bWait)
		return;

    //Deletion and Backspace is handled manually
    if (bReplaceSymbols && num == 9)
    {
        DoBackspace(true);
        return;
    }
    else if (bReplaceSymbols && num == 11)
    {
        DoDelete(true);
        return;
    }

    //Allow for manual asterisks/hashes, by inverting the number
    num = abs(num);

	if (Len(inputCode) < 16)
	{
        num = TransposeNumber(num);
        inputCode = inputCode $ IndexToString(num,true);

		switch (num)
		{
			case 0:		tone = sound'Touchtone1'; break;
			case 1:		tone = sound'Touchtone2'; break;
			case 2:		tone = sound'Touchtone3'; break;
			case 3:		tone = sound'Touchtone4'; break;
			case 4:		tone = sound'Touchtone5'; break;
			case 5:		tone = sound'Touchtone6'; break;
			case 6:		tone = sound'Touchtone7'; break;
			case 7:		tone = sound'Touchtone8'; break;
			case 8:		tone = sound'Touchtone9'; break;
			case 9:		tone = sound'Touchtone10'; break;
			case 10:	tone = sound'Touchtone0'; break;
			case 11:	tone = sound'Touchtone11'; break;
		}

	}

    FinishSendKey(tone);
}


function FinishSendKey(Sound tone)
{
    if (tone != None)
		player.PlaySound(tone, SLOT_None);

	GenerateKeypadDisplay();
	winText.SetTextColor(colHeaderText);
	winText.SetText(msgEnterCode);

	if (Len(inputCode) == Len(keypadOwner.validCode))
		ValidateCode(true);
}

// ----------------------------------------------------------------------
// ValidateCode()
//
// Check for correct code entry
// ----------------------------------------------------------------------

function ValidateCode(bool checkDiscovery)
{
	local Actor A;
	local int i;
    local bool discovered;
    discovered = !checkDiscovery || keypadOwner.IsDiscovered(player,keypadOwner.validCode);

	if (inputCode == keypadOwner.validCode && discovered)
	{
		if (keypadOwner.Event != '')
		{
			if (keypadOwner.bToggleLock)
			{
				// Toggle the locked/unlocked state of the DeusExMover
			player.KeypadToggleLocks(keypadOwner);
			}
			else
			{
				// Trigger the successEvent
			player.KeypadRunEvents(keypadOwner, True);
			}
		}

		// UnTrigger event (if used)
	  // DEUS_EX AMSD Export to player(and then to keypad), for multiplayer.
	  player.KeypadRunUntriggers(keypadOwner);

		player.PlaySound(keypadOwner.successSound, SLOT_None);
		winText.SetTextColor(colGreen);
        if (bDigitDisplay)
            winText.SetText(inputCode);
        else
            winText.SetText(msgAccessGranted);
        jumpOut = true;
	}
	else
	{
		//Trigger failure event
	  if (keypadOwner.FailEvent != '')
		 player.KeypadRunEvents(keypadOwner, False);

		player.PlaySound(keypadOwner.failureSound, SLOT_None);
		winText.SetTextColor(colRed);

        //SARGE: Easter egg from my childhood....
        //...damn I'm getting old...
        if (inputCode == "*10#")
            player.ClientMessage("Your Telstra call waiting feature is on");

        if (bDigitDisplay)
            winText.SetText(inputCode);
        else
            winText.SetText(msgAccessDenied);
        jumpOut = false;
	}

	bWait = True;
	AddTimer(0.5, False, 0, 'KeypadDelay');
}

// ----------------------------------------------------------------------
// KeypadDelay()
//
// timer function to pause after code entry
// ----------------------------------------------------------------------

function KeypadDelay(int timerID, int invocations, int clientData)
{
	bWait = False;	

	// if we entered a valid code, get out
	if (jumpOut)
		root.PopWindow();
	else
	{
		inputCode = "";
		GenerateKeypadDisplay();
		winText.SetTextColor(colHeaderText);
		winText.SetText(msgEnterCode);
	}

    jumpOut = false;
}

// ----------------------------------------------------------------------
// IndexToString()
//
// Convert the numbered button to a character
// ----------------------------------------------------------------------

function string IndexToString(int num, optional bool forceOldSymbols)
{
	local string str;

	// buttons 0-8 are ok as is (text 1-9)
	// button 9 is *
	// button 10 is 0
	// button 11 is #
	switch (num)
	{
		case 9:
            if (bReplaceSymbols && !forceOldSymbols)
                str = "<";
            else
                str = "*";
            break;
		case 10:	str = "0"; break;
		case 11:
            if (bReplaceSymbols && !forceOldSymbols)
                str = "C";
            else
                str = "#";
            break;
		default:	str = String(num+1); break;
	}

	return str;
}

// ----------------------------------------------------------------------
// GenerateKeypadDisplay()
//
// Generate the keypad's display
// SARGE: Modified in the following ways:
// 1. Show numbers instead of dots, if the setting is enabled.
// 2. Reverse the dots from vanilla, because it looks better (white -> as we enter, instead of blue -> white)
// 3. Disable all colours if we're using numbers mode
// ----------------------------------------------------------------------

function GenerateKeypadDisplay()
{
	local int i;
    local string c;         //SARGE: The character we are comparing. Unrealscript doesn't give us access to the characters of a string...what a shitty engine!

    //SARGE: Instead of doing all blue squares, and making them white as we enter.
    //instead, start with white squares and make them blue as we enter...
    if (!bDigitDisplay)
        msgEnterCode = "|p5"; //p5 = dark blue. p4 = yellow and p7 = cyan both look great too.
    else
        msgEnterCode = "";

	for (i=0; i<Len(keypadOwner.validCode); i++)
	{
        if (i == Len(inputCode) && !bDigitDisplay)
            msgEnterCode = msgEnterCode $ "|p1";

        c = Mid(inputCode,i,1);
        
        //SARGE: Now we show the actual numbers...
        if (c != "" && bDigitDisplay)
            msgEnterCode = msgEnterCode $ c;
        //else if (bDigitDisplay)
        //    msgEnterCode = msgEnterCode $ "-";
        else
            msgEnterCode = msgEnterCode $ "~";
	}
}


// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

	bBorderTranslucent     = player.GetHUDBorderTranslucency();
	bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
	bDrawBorder            = player.GetHUDBordersVisible();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackground=Texture'DeusExUI.UserInterface.HUDKeypadBackground'
     texBorder=Texture'DeusExUI.UserInterface.HUDKeypadBorder'
     msgAccessDenied="~~DENIED~~"
     msgAccessGranted="~~GRANTED~~"
     bNumberPadStyle=true
     bDigitDisplay=true
     bReplaceSymbols=true
}
