//=============================================================================
// HUDKeypadNotesWindow
// SARGE: Serves as a container window for Keypads as well as the Notes window, allowing input to both
//=============================================================================
class HUDKeypadContainerWindow extends DeusExBaseWindow;

var HUDKeypadWindow keypadwindow;
var HUDKeypadNotesWindow winNotes;

//Iterate through all the code notes, and return the first one matching our actual code
function GetAutofillCode(DeusExNote note, out string code1)
{
    local string valid, c1, c2;
    local int i;
    
    class'CodeUtils'.static.GetCodeFromNote(note,0,code1,c2);

    if (keypadWindow != None && keypadWindow.keypadOwner != None)
        valid = keypadWindow.keypadOwner.validCode;

    if (valid != "")
    {
        for (i = 0;i < 8;i++)
        {
            class'CodeUtils'.static.GetCodeFromNote(note,i,c1,c2);
            
            if (caps(c1) == caps(valid) && c2 == "")
            {
                code1 = c1;
                return;
            }
        }
    }
}

function AutofillNote(DeusExNote note)
{
    local string code;
    
    if (keypadwindow != None && !keypadWindow.bWait)
    {
        GetAutofillCode(note,code);
        if (code != "")
        {
            keypadWindow.inputCode = code;
            keypadWindow.ValidateCode(false);
        }
    }
}

event InitWindow()
{
	Super.InitWindow();
	SetMouseFocusMode(MFocus_click);
}

function InitKeypadWindow(Keypad owner, DeusExPlayer user, bool instantSuccess)
{
    keypadwindow = HUDKeypadWindow(NewChild(Class'HUDKeypadWindow'));
    if (keypadwindow != None)
    {
        keypadWindow.keypadOwner = owner;
        keypadWindow.player = user;
        keypadWindow.bInstantSuccess = instantSuccess;
        keypadWindow.InitData();
        keypadWindow.StyleChanged();
    }
}

//SARGE: Add a notes window showing all relevant notes.
function AddNotesWindow(DeusExPlayer player, DeusExNote codeNote, bool fakeDisplay)
{
    if (!player.bShowCodeNotes)
        return;

    //AWFUL hack!
    //If we have fakeDisplay on, pretend there are no notes.
    if (fakeDisplay && (!player.bHardcoreMode || player.bGMDXDebug) && player.iNoKeypadCheese == 0)
        codeNote = None;

    //SARGE: What an AWFUL conditional...
    if ((codeNote == None && (!player.bHardcoreMode || player.bGMDXDebug) && player.iNoKeypadCheese == 0) || !player.HasAnyNotes() || keypadWindow == None || keypadWindow.bInstantSuccess)
        return;

    //winNotes = root.hud.ShowInfowindow(); //Can't do this, HUD is hidden
    //winNotes = class'HUDKeypadNotesWindow'.static.CreateNotesWindow(root,keypadwindow.x, keypadwindow.width, 640/2, keypadwindow.height);
    winNotes = HUDKeypadNotesWindow(NewChild(Class'HUDKeypadNotesWindow'));
    winNotes.SetEditable(false);
    winNotes.SetPos(keypadwindow.x + 420, keypadwindow.y);
	winNotes.Resize(640/2, keypadwindow.height);
    winNotes.AddNote(codeNote);
    winNotes.CreateNotesList();
    winNotes.StyleChanged();
    winNotes.SetParentWindow(self);
}

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
    if (keypadwindow != None)
        keypadwindow.VirtualKeyPressed(key,bRepeat);
}

event StyleChanged()
{
    if (keypadwindow != None)
        keypadwindow.StyleChanged();
    if (winNotes != None)
        winNotes.StyleChanged();
}

event DestroyWindow()
{
    //DestroyAllChildren();
    //keypadwindow = None;
    //winNotes = None;

    
    /*
    if (keypadwindow != None)
    {
        //keypadWindow.keypadOwner.topWindow = None;
        keypadwindow.DestroyWindow();
        //keypadwindow.DestroyAllChildren();
        keypadwindow.Destroy();
        keypadwindow = None;
    }

    if (winNotes != None)
    {
        winNotes.DestroyWindow();
        //winNotes.DestroyAllChildren();
        winNotes.Destroy();
        winNotes = None;
    }
    */
    DestroyAllChildren();
	Super.DestroyWindow();
}
