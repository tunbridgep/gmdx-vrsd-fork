//=============================================================================
// MenuSelectDifficulty
//=============================================================================

class MenuSelectDifficulty expands MenuUIMenuWindow;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

enum EMessageBoxModes
{
	MB_Hardcore,
	MB_Realistic,
	MB_Information,
	MB_Cancel,
	MB_None
};

var localized String HardCoreTitle;
var localized String HardCoreDescription;
var localized String InfoTitle;
var localized String InfoDescription;
var localized String HardcoreUnlockInfo;
var localized String HardcoreUnlockDescription;
var localized String HardcoreEnabled;
var localized String HardcoreDisabled;
var localized String RealisticDescription;
var localized String RealisticTitle;

var EMessageBoxModes	msgBoxMode;

event InitWindow()
{
	Super.InitWindow();
}

// ----------------------------------------------------------------------
// WindowReady()
// ----------------------------------------------------------------------

event WindowReady()
{
	// Set focus to the Medium button
	SetFocusWindow(winButtons[1]);
	if (!player.bHardcoreUnlocked)
	   InvokeMessageDialog2();
}

// ----------------------------------------------------------------------
// ProcessCustomMenuButton()
// ----------------------------------------------------------------------

function ProcessCustomMenuButton(string key)
{
	switch(key)
	{
		case "EASY":
			InvokeNewGameScreen(0.5,false);  //CyberP: was 1
			break;

		case "MEDIUM":
			InvokeNewGameScreen(1.5,false);
			break;

		case "HARD":
			InvokeNewGameScreen(2.0,false);
			break;

		case "REALISTIC":
		    if (player.bHardcoreUnlocked)
			InvokeNewGameScreen(3.0,false);    //cyberP: was 4
			else
			InvokeMessageDialog4();
			break;

		case "HARDCORE":
            if (player.bHardcoreUnlocked)                         //CyberP: combat difficulty is 3
			InvokeMessageDialog();
			else
			InvokeMessageDialog3();
			break;
	}
}

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	local string newName;

	// Destroy the msgbox!
	root.PopWindow();

	switch(msgBoxMode)
	{
		case MB_HardCore:
			if ( buttonNumber == 0 )
			{
				msgBoxMode = MB_None;
				InvokeNewGameScreen(3.0,true);
			}
			break;

		case MB_Realistic:
			if ( buttonNumber == 0 )
			{
				msgBoxMode = MB_None;
				InvokeNewGameScreen(3.0,false);
			}
			break;

        case MB_Information:
            if ( buttonNumber == 0 )
            {
				msgBoxMode = MB_Cancel;
			}
			break;

		default:
			msgBoxMode = MB_None;
   }

	return true;
}

function InvokeMessageDialog()
{
	msgBoxMode = MB_HardCore;
	root.MessageBox(HardCoreTitle, HardCoreDescription, 0, False, Self);
}

function InvokeMessageDialog2()
{
	msgBoxMode = MB_Information;
	root.MessageBox(InfoTitle, InfoDescription, 1, False, Self);
}

function InvokeMessageDialog3()
{
	msgBoxMode = MB_HardCore;
	root.MessageBox(HardcoreUnlockInfo, HardcoreUnlockDescription, 0, False, Self);
}

function InvokeMessageDialog4()
{
	msgBoxMode = MB_Realistic;
	root.MessageBox(RealisticTitle, RealisticDescription, 0, False, Self);
}

function InvokeMessageDialog5()
{
	msgBoxMode = MB_HardCore;
	root.MessageBox(HardCoreTitle, HardCoreDescription, 0, False, Self);
}

// ----------------------------------------------------------------------
// InvokeNewGameScreen()
// ----------------------------------------------------------------------

function InvokeNewGameScreen(float difficulty,bool bSetHardCore)
{
	local MenuScreenNewGame newGame;

	newGame = MenuScreenNewGame(root.InvokeMenuScreen(Class'MenuScreenNewGame'));

	if (newGame != None)
		newGame.SetDifficulty(difficulty,bSetHardCore);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HardCoreTitle="Enable Hardcore Mode?"
     HardCoreDescription="Disables manual saving, enables save points. |nAdditional rules: disabled console access, real-time inventory use, greater stamina drain, no weapon auto-reload, less ammo and more."
     InfoTitle="GMDX Difficulty Information"
     InfoDescription="Difficulty levels primarily influence stealth, combat & exploration. You cannot change the difficulty in-game, so choose wisely. 'Medium' is recommended for a first-time playthrough of GMDX."
     HardcoreUnlockInfo="Are you sure?"
     HardcoreUnlockDescription="Hardcore difficulty will be extremely unforgiving and is not recommended for those new to GMDX.|nIt is strongly recommended that you choose a lower diffiuculty!|nProceed?"
     RealisticDescription="Realistic difficulty will be a testing challenge and is not recommended for those new to GMDX.|nProceed?"
     RealisticTitle="Warning"
     ButtonNames(0)="Easy"
     ButtonNames(1)="Medium"
     ButtonNames(2)="Hard"
     ButtonNames(3)="Realistic"
     ButtonNames(4)="Hardcore"
     ButtonNames(5)="Previous Menu"
     buttonXPos=7
     buttonWidth=245
     buttonDefaults(0)=(Y=13,Action=MA_Custom,Key="EASY")
     buttonDefaults(1)=(Y=49,Action=MA_Custom,Key="MEDIUM")
     buttonDefaults(2)=(Y=85,Action=MA_Custom,Key="HARD")
     buttonDefaults(3)=(Y=121,Action=MA_Custom,Key="REALISTIC")
     buttonDefaults(4)=(Y=157,Action=MA_Custom,Key="HARDCORE")
     buttonDefaults(5)=(Y=214,Action=MA_Previous)
     Title="Select Difficulty"
     ClientWidth=258
     ClientHeight=287
     clientTextures(0)=Texture'GMDXSFX.UI.DiffBack'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuDifficultyBackground_2'
     textureRows=1
     textureCols=2
}
