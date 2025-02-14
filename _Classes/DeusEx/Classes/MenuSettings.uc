//=============================================================================
// MenuSettings
//=============================================================================

class MenuSettings expands MenuUIMenuWindow;

var localized string NewButtonNames[10]; //because the localizations were fucking us

function CreateMenuButtons()
{
	local int buttonIndex;

	for(buttonIndex=0; buttonIndex<arrayCount(buttonDefaults); buttonIndex++)
	{
		if (NewButtonNames[buttonIndex] != "")
		{
			winButtons[buttonIndex] = MenuUIMenuButtonWindow(winClient.NewChild(Class'MenuUIMenuButtonWindow'));

			winButtons[buttonIndex].SetButtonText(NewButtonNames[buttonIndex]);
			winButtons[buttonIndex].SetPos(buttonXPos, buttonDefaults[buttonIndex].y);
			winButtons[buttonIndex].SetWidth(buttonWidth);
		}
		else
		{
			break;
		}
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NewButtonNames(0)="Keyboard/Mouse"
     NewButtonNames(1)="Controls"
     NewButtonNames(2)="Game Options"
     NewButtonNames(3)="GMDX Options"
     NewButtonNames(4)="Display"
     NewButtonNames(5)="Colors"
     NewButtonNames(6)="Sound"
     NewButtonNames(7)="Previous Menu"
     buttonXPos=7
     buttonWidth=282
     buttonDefaults(0)=(Y=13,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenCustomizeKeys')
     buttonDefaults(1)=(Y=49,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenControls')
     buttonDefaults(2)=(Y=85,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenOptions')
     buttonDefaults(3)=(Y=121,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenGMDXOptions')
     buttonDefaults(4)=(Y=157,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenDisplay')
     buttonDefaults(5)=(Y=193,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenAdjustColors')
     buttonDefaults(6)=(Y=229,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenSound')
     buttonDefaults(7)=(Y=302,Action=MA_Previous)
     Title="Settings"
     ClientWidth=294
     ClientHeight=335
     clientTextures(0)=Texture'RSDCrap.UserInterface.HDTPMenuOptionsBackground_1'
     clientTextures(1)=Texture'RSDCrap.UserInterface.HDTPMenuOptionsBackground_2'
     clientTextures(2)=Texture'RSDCrap.UserInterface.HDTPMenuOptionsBackground_3'
     clientTextures(3)=Texture'RSDCrap.UserInterface.HDTPMenuOptionsBackground_4'
     textureCols=2
}
