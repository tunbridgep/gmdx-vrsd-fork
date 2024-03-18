//=============================================================================
// PersonaScreenSkills
//=============================================================================

class PersonaScreenSkills extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow btnUpgrade, btnPerks; //CyberP: btnPerks
var PersonaActionButtonWindow btnLevels;                                        //RSD: Added btnLevels
var TileWindow                winTile;
var Skill			          selectedSkill;
var PersonaSkillButtonWindow  selectedSkillButton;
var PersonaHeaderTextWindow   winSkillPoints;
var PersonaInfoWindow         winInfo;
var Bool                      bPerksMenu;                                       //RSD: Whether we're in the perks menu or not

// Keep track so we can use the arrow keys to navigate
var PersonaSkillButtonWindow  skillButtons[15];

var localized String SkillsTitleText;
var localized String UpgradeButtonLabel;
var localized String PerksButtonLabel;  //CyberP: perks
var localized String LevelsButtonLabel;                                         //RSD: Added
var localized String PointsNeededHeaderText;
var localized String SkillLevelHeaderText;
var localized String SkillPointsHeaderText;
var localized String SkillUpgradedLevelLabel;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	PersonaNavBarWindow(winNavBar).btnSkills.SetSensitivity(False);

	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, SkillsTitleText);
	CreateInfoWindow();
	CreateButtons();
	CreateSkillsHeaders();
	CreateSkillsTileWindow();
	CreateSkillsList();
	CreateSkillPointsWindow();
	CreateStatusWindow();
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(356, 329);      //329
}

// ----------------------------------------------------------------------
// CreateSkillsTileWindow()
// ----------------------------------------------------------------------

function CreateSkillsTileWindow()
{
	winTile = TileWindow(winClient.NewChild(Class'TileWindow'));

	winTile.SetPos(12, 39);
	winTile.SetSize(302, 324);    //297 GMDX:- set the skill list hight (font size is 27) , also have to mod the update button position
	winTile.SetMinorSpacing(0);
	winTile.SetMargins(0, 0);
	winTile.SetOrder(ORDER_Down);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winInfo.SetPos(356, 22);
	winInfo.SetSize(238, 299);      //299 GMDX
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(10, 365); //338 GMDX:-
	winActionButtons.SetWidth(149);                                             //RSD: Was 149, then 174 for separate info button
	winActionButtons.FillAllSpace(False);


    btnPerks = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow')); //CyberP: perks
    if (bPerksMenu)                                                             //RSD: Dynamically swap between perks and levels button
    	btnLevels.SetButtonText(LevelsButtonLabel);                             //RSD: Levels Button
    else
    	btnPerks.SetButtonText(PerksButtonLabel); //CyberP: perks
    /*if (bPerksMenu)                                                             //RSD: Gray out the active menu
    {
    	btnPerks.SetSensitivity(false);
    	btnLevels.SetSensitivity(true);
    }
    else
    {
    	btnPerks.SetSensitivity(true);
    	btnLevels.SetSensitivity(false);
    }*/

	btnUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUpgrade.SetButtonText(UpgradeButtonLabel);
}

// ----------------------------------------------------------------------
// CreateSkillsHeaders()
// ----------------------------------------------------------------------

function CreateSkillsHeaders()
{
	local PersonaNormalTextWindow winText;

	winText = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
	winText.SetPos(177, 24);
	winText.SetText(SkillLevelHeaderText);

	winText = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
	winText.SetPos(247, 24);
	winText.SetText(PointsNeededHeaderText);
}

// ----------------------------------------------------------------------
// CreateSkillsList()
// ----------------------------------------------------------------------

function CreateSkillsList()
{
	local Skill aSkill;
	local int   buttonIndex;
	local PersonaSkillButtonWindow skillButton;
	local PersonaSkillButtonWindow firstButton;

	// Iterate through the skills, adding them to our list
	aSkill = player.SkillSystem.FirstSkill;
	while(aSkill != None)
	{
		if (aSkill.SkillName != "")
		{
			skillButton = PersonaSkillButtonWindow(winTile.NewChild(Class'PersonaSkillButtonWindow'));
			skillButton.SetSkill(aSkill);

			skillButtons[buttonIndex++] = skillButton;

			if (firstButton == None)
				firstButton = skillButton;
		}
		aSkill = aSkill.next;
	}

	// Select the first skill
	SelectSkillButton(skillButton);
}

// ----------------------------------------------------------------------
// CreateSkillPointsWindow()
// ----------------------------------------------------------------------

function CreateSkillPointsWindow()
{
	local PersonaHeaderTextWindow winText;

	winText = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winText.SetPos(185, 368);   //341                                           //RSD: Was (180, 368)
	winText.SetHeight(15);                                                      //RSD: Was 15
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Center);                      //RSD: Align "Skill Points" text to the left
	winText.SetText(SkillPointsHeaderText);

	winSkillPoints = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winSkillPoints.SetPos(255, 368); //341                                      //RSD: Was (250, 368)
	winSkillPoints.SetSize(49, 15);                                             //RSD: Was (54, 15)
	winSkillPoints.SetTextAlignments(HALIGN_Right, VALIGN_Center);
	winSkillPoints.SetText(player.SkillPointsAvail);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

	// Check if this is one of our Skills buttons
	if (buttonPressed.IsA('PersonaSkillButtonWindow'))
	{
		SelectSkillButton(PersonaSkillButtonWindow(buttonPressed));
	}
	else
	{
		switch(buttonPressed)
		{
			case btnUpgrade:
                UpgradeSkill();
				break;

            /*case btnLevels:                                                     //RSD: Levels button
            	bPerksMenu=false;
            	selectedSkill.UpdateInfo(winInfo);
            	CreateButtons();
            	//btnLevels.SetSensitivity(false);
            	//btnPerks.SetSensitivity(true);
                break;*/

            case btnPerks:         //CyberP: perks
                if (bPerksMenu)                                                 //RSD: Dynamically swap between perks and levels button
                {
                    bPerksMenu=false;
            	    selectedSkill.UpdateInfo(winInfo);
            	    btnPerks.SetButtonText(PerksButtonLabel);
                }
                else
                {
                    bPerksMenu=true;
                    InvokePerksWindow();
                    btnPerks.SetButtonText(LevelsButtonLabel);
                }
                //btnPerks.SetSensitivity(false);
                //btnLevels.SetSensitivity(true);
                break;

			default:
				bHandled = False;
				break;
		}
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bHandled;

	bHandled = True;

	switch( key )
	{
		case IK_Up:
			SelectPreviousSkillButton();
			break;

		case IK_Down:
			SelectNextSkillButton();
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}

// ----------------------------------------------------------------------
// SelectSkillButton()
// ----------------------------------------------------------------------

function SelectSkillButton(PersonaSkillButtonWindow buttonPressed)
{
	// Don't do extra work.
	//if (selectedSkillButton != buttonPressed)
	//{
		// Deselect current button
		if (selectedSkillButton != None)
			selectedSkillButton.SelectButton(False);

		selectedSkillButton = buttonPressed;
		selectedSkill       = selectedSkillButton.GetSkill();

        if(!bPerksMenu)                                                         //RSD: Remembers if you were navigating Levels or Perks Menu
        	selectedSkill.UpdateInfo(winInfo);
       	else
       		InvokePerksWindow();
		selectedSkillButton.SelectButton(True);

		EnableButtons();
	//}
}

// ----------------------------------------------------------------------
// SelectPreviousSkillButton()
// ----------------------------------------------------------------------

function SelectPreviousSkillButton()
{
	local int skillIndex;

	skillIndex = GetCurrentSkillButtonIndex();

	if (--skillIndex < 0)
		skillIndex = GetSkillButtonCount() - 1;

	skillButtons[skillIndex].ActivateButton(IK_LeftMouse);
}

// ----------------------------------------------------------------------
// SelectNextSkillButton()
// ----------------------------------------------------------------------

function SelectNextSkillButton()
{
	local int skillIndex;

	skillIndex = GetCurrentSkillButtonIndex();

	if (++skillIndex >= GetSkillButtonCount())
		skillIndex = 0;

	skillButtons[skillIndex].ActivateButton(IK_LeftMouse);
}

// ----------------------------------------------------------------------
// GetCurrentSkillButtonIndex()
// ----------------------------------------------------------------------

function int GetCurrentSkillButtonIndex()
{
	local int buttonIndex;
	local int returnIndex;

	returnIndex = -1;

	for(buttonIndex=0; buttonIndex<arrayCount(skillButtons); buttonIndex++)
	{
		if (skillButtons[buttonIndex] == selectedSkillButton)
		{
			returnIndex = buttonIndex;
			break;
		}
	}

	return returnIndex;
}

// ----------------------------------------------------------------------
// GetSkillButtonCount()
// ----------------------------------------------------------------------

function int GetSkillButtonCount()
{
	local int buttonIndex;

	for(buttonIndex=0; buttonIndex<arrayCount(skillButtons); buttonIndex++)
	{
		if (skillButtons[buttonIndex] == None)
			break;
	}

	return buttonIndex;
}

function InvokePerksWindow()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

    selectedSkill.UpdatePerksInfo(winInfo);
	//selectedSkill.IncLevel();
	//selectedSkillButton.RefreshSkillInfo();

	// Send status message
	//winStatus.AddText(Sprintf(SkillUpgradedLevelLabel, selectedSkill.SkillName));

	//winSkillPoints.SetText(player.SkillPointsAvail);

	EnableButtons();
}
// ----------------------------------------------------------------------
// UpgradeSkill()
// ----------------------------------------------------------------------

function UpgradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.IncLevel();
	selectedSkillButton.RefreshSkillInfo();
	if (!bPerksMenu)                                                            //RSD: Only go to skill descriptions if not viewing perks
		selectedSkill.UpdateInfo(winInfo); //CyberP: Perks
    else                                                                        //RSD: Also make sure to update perk buttons (doh!)
    	selectedSkill.UpdatePerksInfo(winInfo);

	// Send status message
	winStatus.AddText(Sprintf(SkillUpgradedLevelLabel, selectedSkill.SkillName));

	winSkillPoints.SetText(player.SkillPointsAvail);

	EnableButtons();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Abort if a skill item isn't selected
	if ( selectedSkill == None )
	{
		btnUpgrade.SetSensitivity(False);
	}
	else
	{
		// Upgrade Skill only available if the skill is not at
		// the maximum -and- the user has enough skill points
		// available to upgrade the skill

		btnUpgrade.EnableWindow(selectedSkill.CanAffordToUpgrade(player.SkillPointsAvail));
	}
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
	if (selectedSkill != None)
	{
		selectedSkillButton.RefreshSkillInfo();
	}

	winSkillPoints.SetText(player.SkillPointsAvail);
	EnableButtons();
	Super.RefreshWindow(DeltaTime);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
//clientTextures(3)=Texture'DeusExUI.UserInterface.SkillsBackground_4'
// clientTextures(4)=Texture'DeusExUI.UserInterface.SkillsBackground_5'

//ClientHeight 361

defaultproperties
{
     SkillsTitleText="Skills"
     UpgradeButtonLabel="|&Upgrade"
     PerksButtonLabel="|&Perks"
     LevelsButtonLabel="|&Info"
     PointsNeededHeaderText="Points Needed"
     SkillLevelHeaderText="Skill Level"
     SkillPointsHeaderText="Skill Points"
     SkillUpgradedLevelLabel="%s upgraded"
     clientBorderOffsetY=33
     ClientWidth=604
     ClientHeight=401
     clientOffsetX=19
     clientOffsetY=12
     clientTextures(0)=Texture'DeusExUI.UserInterface.SkillsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.SkillsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.SkillsBackground_3'
     clientTextures(3)=Texture'GMDXUI.UserInterface.SkillsBGMDX_4'
     clientTextures(4)=Texture'GMDXUI.UserInterface.SkillsBGMDX_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.SkillsBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.SkillsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.SkillsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.SkillsBorder_3'
     clientBorderTextures(3)=Texture'GMDXSFX.UI.SkillsInterfaceBorder4'
     clientBorderTextures(4)=Texture'GMDXSFX.UI.SkillsInterfaceBorder5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.SkillsBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
