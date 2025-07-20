//=============================================================================
// Keypad.
//=============================================================================
class Keypad extends HackableDevices
	abstract;

var() string validCode;
var() sound successSound;
var() sound failureSound;
var() name FailEvent;
var() bool bToggleLock;		// if True, toggle the lock state instead of triggering

var HUDKeypadWindow keypadwindow;
var HUDKeypadNotesWindow winNotes;

// ----------------------------------------------------------------------
// Network Replication
// ----------------------------------------------------------------------

replication
{
   //server to client variables
   reliable if ( Role == ROLE_Authority )
      bToggleLock, FailEvent, validCode;
}

// ----------------------------------------------------------------------
// HackAction()
// ----------------------------------------------------------------------

function HackAction(Actor Hacker, bool bHacked)
{
	local DeusExPlayer Player;

	// if we're already using this keypad, get out
	if (keypadwindow != None)
		return;

	Player = DeusExPlayer(Hacker);

	if (Player != None)
	{
      // DEUS_EX AMSD if we are in multiplayer, just act based on bHacked
      // if you want keypad windows to work in multiplayer, just get rid of this
      // if statement.  I've already got the windows working, they're just disabled.
      if (Level.NetMode != NM_Standalone)
      {
         if (bHacked)
         {
            ToggleLocks(Player);
            RunEvents(Player,True);
            RunUntriggers(Player);
         }
         return;
      }
      
      //DEUS_EX AMSD Must call in player for replication to work.
      Player.ActivateKeypadWindow(Self, bHacked);
	}
}

// ----------------------------------------------------------------------
// ActivateKeypadWindow
// DEUS_EX AMSD Bounce back call from player so function rep works right.
// ----------------------------------------------------------------------
simulated function ActivateKeypadWindow(DeusExPlayer Hacker, bool bHacked)
{
	local DeusExRootWindow root;

    root = DeusExRootWindow(Hacker.rootWindow);
   if (root != None)
   {
      keypadwindow = HUDKeypadWindow(root.InvokeUIScreen(Class'HUDKeypadWindow', True));
      AddNotesWindow(root,Hacker);
      root.MaskBackground(True);
      
      // copy the tag data to the actual class
      if (keypadwindow != None)
      {
         keypadWindow.keypadOwner = Self;
         keypadWindow.player = Hacker;
         keypadWindow.bInstantSuccess = bHacked;
         keypadWindow.InitData();
      }
   }
}

//SARGE: Add a notes window showing all relevant notes.
function AddNotesWindow(DeusExRootWindow root,DeusExPlayer player)
{
    local DeusExNote codeNote;

    if (!player.bShowCodeNotes)
        return;

    codeNote = player.GetCodeNote(validCode,true);

    if (codeNote == None)
        return;

    //winNotes = root.hud.ShowInfowindow(); //Can't do this, HUD is hidden
    //winNotes = class'HUDKeypadNotesWindow'.static.CreateNotesWindow(root,keypadwindow.x, keypadwindow.width, 640/2, keypadwindow.height);
    winNotes = HUDKeypadNotesWindow(root.NewChild(Class'HUDKeypadNotesWindow'));
    winNotes.SetPos(keypadwindow.x + keypadwindow.width, keypadwindow.y);
	winNotes.Resize(640/2, keypadwindow.height);
    winNotes.AddNote(codeNote);
    winNotes.CreateNotesList();
    winNotes.StyleChanged();
    if (keypadwindow != None)
        keypadWindow.notesDisplay = winNotes;
    winNotes = none;
}

// ----------------------------------------------------------------------
// RunUntriggers()
// DEUS_EX AMSD Bounce back call from player so function rep works right.
// ----------------------------------------------------------------------
function RunUntriggers(DeusExPlayer Player)
{
   local Actor A;
   local int i;

   for (i=0; i<ArrayCount(UnTriggerEvent); i++)
   {
      if (UnTriggerEvent[i] != '')
      {
         foreach AllActors(class 'Actor', A, UnTriggerEvent[i])
         {
            A.UnTrigger(Self, Player);
         }
      }
   }
}

// ----------------------------------------------------------------------
// RunEvents()
// ----------------------------------------------------------------------
function RunEvents(DeusExPlayer Player, bool bSuccess)
{
   local Actor A;

   if ((bSuccess) && (Event != ''))
   {
      foreach AllActors(class 'Actor', A, Event)
         A.Trigger(Self, Player);
   }
   else if ((!bSuccess) && (FailEvent != ''))
   {
      foreach AllActors(class 'Actor', A, FailEvent)
         A.Trigger(Self, Player);
   }
}

// ----------------------------------------------------------------------
// ToggleLocks()
// ----------------------------------------------------------------------
function ToggleLocks(DeusExPlayer Player)
{
   local Actor A;
   if (bToggleLock)
   {
      foreach AllActors(class 'Actor', A, Event)
         if (A.IsA('DeusExMover'))
            DeusExMover(A).bLocked = !DeusExMover(A).bLocked;
   }
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     validCode="1234"
     successSound=Sound'DeusExSounds.Generic.Beep2'
     failureSound=Sound'DeusExSounds.Generic.Buzz1'
     bToggleLock=True
     ItemName="Security Keypad"
     Mass=10.000000
     Buoyancy=5.000000
     bAllowRightClickToolSelection=False
}
