//=============================================================================
// HDTP menus
//=============================================================================

class MenuScreenHDTP expands MenuUIScreenWindow;

var localized string choicetext[11];
var localized string GMDXHelpMsg;

event InitWindow()
{
	Super.InitWindow();

	ShowHelp(GMDXHelpMsg);
}
// ----------------------------------------------------------------------
// CreateChoices()
// ----------------------------------------------------------------------

function CreateChoices()
{
	local int choiceIndex;
	local MenuChoiceHDTP newChoice;

	// Loop through the Menu Choices and create the appropriate buttons
	for(choiceIndex=0; choiceIndex<arrayCount(choicetext); choiceIndex++)
	{
		if (choicetext[choiceIndex] != "")
		{
			newChoice = MenuChoiceHDTP(winClient.NewChild(Class'MenuChoiceHDTP'));
			newChoice.SetPos(choiceStartX, choiceStartY + (choiceCount * choiceVerticalGap) - newChoice.buttonVerticalOffset);
			newchoice.actionText = choicetext[choiceindex];
			newchoice.btnAction.SetButtonText(choicetext[choiceindex]);
			newchoice.CreateInfoButton(); //do it here so the text works?
			choiceCount++;
		}
	}
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choiceText(0)="Global"
     choiceText(1)="JC"
     choiceText(2)="Paul"
     choiceText(3)="Gunther"
     choiceText(4)="Anna"
     choiceText(5)="Nicolette"
     choiceText(6)="NSF"
     choiceText(7)="Riot Cop"
     choiceText(8)="Simons"
     choiceText(9)="UNATCO"
     choiceText(10)="MJ12"
     GMDXHelpMsg="GMDX: if you have the 'Head Gibbing' option enabled you must disable all HDTP characters (GLOBAL = NONE) for it to take effect."
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Action=AB_OK)
     Title="HDTP Characters"
     ClientWidth=391
     ClientHeight=480
     clientTextures(0)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_1'
     clientTextures(1)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_2'
     clientTextures(2)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_3'
     clientTextures(3)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_4'
     textureCols=2
     bHelpAlwaysOn=True
     helpPosY=426
}
