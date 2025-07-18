//=============================================================================
// MenuScreenNewGame
//=============================================================================

class MenuScreenNewGame expands MenuUIScreenWindow;

var MenuUIInfoButtonWindow   winNameBorder;
var MenuUIEditWindow         editCodeName;
var MenuUIEditWindow         editName;
var MenuUIListWindow         lstSkills;
var MenuUISkillInfoWindow    winSkillInfo;
var MenuUIStaticInfoWindow   winSkillPoints;

var MenuUIActionButtonWindow btnUpgrade;
var MenuUIActionButtonWindow btnDowngrade;
var ButtonWindow             btnLeftArrow;
var ButtonWindow             btnRightArrow;
var ButtonWindow             btnPortrait;

var Texture texPortraits[10]; //LDDP, 10/26/21: We're expanding this array to 10, and doing some swoocey bullshit after the fact.
var int     portraitIndex;
var Skill   selectedSkill;
var int		selectedRowId;
var int     saveSkillPointsAvail;
var int     saveSkillPointsTotal;
var float   combatDifficulty;

//---------------
//LDDP, 10/26/21: Other stuff added here for convenience.
//---------------
var NewGameCheckBoxWindow MorpheusCheckBox, MaleInteractionsCheckbox;

struct LDDPButtonPos {
	var int X;
	var int Y;
};

var LDDPButtonPos MorpheusCheckboxPos, MaleInteractionsCheckboxPos;
var localized string MorpheusCheckboxLabel, MaleInteractionsCheckboxLabel,
			CheckboxTipHeader, CheckboxTipText;

//---------------
//LDDP end.
//---------------

var String filterString;

// An array of local skills that we can use to manipulate without
// actually changing the skills in the game.  This is important so the
// player can back out of this screen and return to the game in progress.

var Skill			localSkills[32];

var localized string ButtonUpgradeLabel;
var localized string ButtonDowngradeLabel;
var localized string HeaderNameLabel;
var localized string HeaderCodeNameLabel;
var localized string HeaderAppearanceLabel;
var localized string HeaderSkillsLabel;
var localized string HeaderSkillPointsLabel;
var localized string HeaderSkillLevelLabel;
var localized string HeaderPointsNeededLabel;
var localized string NameBlankTitle;
var localized string NameBlankPrompt;

var bool bHardCoreMode; //GMDX: menu holder for player
var bool bRandomizeCrates;                                                      //RSD: Same for these
var bool bRandomizeMods;
var bool bRandomizeAugs;
var bool bRandomizeEnemies;
var bool bAddictionSystem;
var bool bRestrictedSaving;
var int iNoKeypadCheese;
var bool bExtraHardcore;
var bool bMoreLDDPNPCs;
//var bool bRestrictedMetabolism;
var bool bPrisonStart;
var bool bDisableConsoleAccess;
var bool bWeaponRequirementsMatter;
var bool bRealKillswitch;
var bool bCameraDetectUnconscious;
var bool bShenanigans;
var bool bRandomizeCrap;
var bool bCutInteractions;
var bool bA51Camera;
var bool bCollectibles;

//LDDP
var bool bFemaleEnabled;

function Timer()
{
    GiveTip(false);
}

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
    local DeusExPlayer player;
    player = DeusExPlayer(GetPlayerPawn());

	if (player != None && player.FemaleEnabled())
	{
        bFemaleEnabled = true;
		TexPortraits[0] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonMale_1", class'Texture', false));
		TexPortraits[1] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonFemale_1", class'Texture', false));
		TexPortraits[2] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonMale_2", class'Texture', false));
		TexPortraits[3] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonFemale_2", class'Texture', false));
		TexPortraits[4] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonMale_3", class'Texture', false));
		TexPortraits[5] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonFemale_3", class'Texture', false));
		TexPortraits[6] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonMale_4", class'Texture', false));
		TexPortraits[7] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonFemale_4", class'Texture', false));
		TexPortraits[8] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonMale_5", class'Texture', false));
		TexPortraits[9] = Texture(DynamicLoadObject("FemJC.MenuPlayerSetupJCDentonFemale_5", class'Texture', false));
	}
    else
    {
        actionButtons[4].action = AB_None;
    }
	
    Super.InitWindow();

	SaveSkillPoints();
	ResetToDefaults();

	// Need to do this because of the edit control used for
	// saving games.
	SetMouseFocusMode(MFOCUS_Click);

	Show();
	SetFocusWindow(editName);
	editName.SetSelectedArea(0, Len(editName.GetText()));
	combatDifficulty = player.Default.CombatDifficulty;
	bHardCoreMode=false;
    bRandomizeCrates=false;                                                     //RSD
    bRandomizeMods=false;                                                       //RSD
    bRandomizeAugs=false;                                                       //RSD
    bAddictionSystem=false;                                                     //RSD
    bRestrictedSaving=false;                                                    //Sarge
    iNoKeypadCheese=0;      	                                                //Sarge
    bRandomizeEnemies=false;                                                    //Sarge
    bExtraHardcore=false;                                                       //Sarge
    bMoreLDDPNPCs=false;                                                        //Sarge
    bDisableConsoleAccess=false;                                                //Sarge
    bWeaponRequirementsMatter=false;                                            //Sarge
    bRealKillswitch=false;                                                      //Sarge
  	bCameraDetectUnconscious=false;
    bShenanigans=false;                                                         //Sarge
    bRandomizeCrap=false;                                                       //Sarge
    bCutInteractions=false;                                                     //Sarge
    bA51Camera=false;                                                           //Sarge
    bCollectibles=false;                                                        //Sarge
    //bRestrictedMetabolism=false;                                              //Sarge
    default.bRandomizeCrates=false;                                             //RSD: Also need default values! Otherwise get command in modifier menu takes the wrong value
    default.bRandomizeMods=false;                                               //RSD
    default.bRandomizeAugs=false;                                               //RSD
    default.bAddictionSystem=false;                                             //RSD
    default.bRestrictedSaving=false;                                            //Sarge
    default.iNoKeypadCheese=0;                                                  //Sarge
    default.bRandomizeEnemies=false;                                            //Sarge
    default.bExtraHardcore=false;                                               //Sarge
    default.bMoreLDDPNPCs=false;                                                //Sarge
    //default.bRestrictedMetabolism=false;                                      //Sarge
    default.bPrisonStart=false;                                                 //Sarge
    default.bDisableConsoleAccess=false;                                        //Sarge
    default.bWeaponRequirementsMatter=false;                                    //Sarge
    default.bRealKillswitch=false;                                              //Sarge
	default.bCameraDetectUnconscious=false;
    default.bShenanigans=false;                                                 //Sarge
    default.bRandomizeCrap=false;                                               //Sarge
    default.bCutInteractions=false;                                             //Sarge
    default.bA51Camera=false;                                                   //Sarge
    default.bCollectibles=false;                                                //Sarge

	StyleChanged();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
	DestroyLocalSkills();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreatePortraitButton();
	CreateLeftArrowButton();
	CreateRightArrowButton();
	CreateSkillButtons();
	CreateTextHeaders();
	CreateCodeNameEditWindow();
	CreateNameEditWindow();
	CreateSkillsListWindow();
	CreateSkillInfoWindow();
	CreateSkillPointsButton();

    //LDDP
    //SARGE: Only create these if LDDP is actually loaded
    if (bFemaleEnabled)
    {
        CreateLDDPCheckboxes();
        //LDDP, 10/28/21: Modders: I suggest you do this, but for now we're using an Exec command for it.
    	AddTimer(0.1, false,, 'GiveTip');
    }
}

// ----------------------------------------------------------------------
// CreatePortraitButton()
// ----------------------------------------------------------------------

function CreatePortraitButton()
{
	btnPortrait = ButtonWindow(winClient.NewChild(Class'ButtonWindow'));

	btnPortrait.SetSize(114, 161);
	btnPortrait.SetPos(18, 152);

	btnPortrait.SetBackgroundStyle(DSTY_Masked);
}

// ----------------------------------------------------------------------
// CreateLeftArrowButton()
// ----------------------------------------------------------------------

function CreateLeftArrowButton()
{
	btnLeftArrow = ButtonWindow(winClient.NewChild(Class'ButtonWindow'));

	btnLeftArrow.SetPos(102, 316);
	btnLeftArrow.SetSize(14, 15);

	btnLeftArrow.SetButtonTextures(
		Texture'MenuLeftArrow_Normal',
		Texture'MenuLeftArrow_Pressed');
}

// ----------------------------------------------------------------------
// CreateRightArrowButton()
// ----------------------------------------------------------------------

function CreateRightArrowButton()
{
	btnRightArrow = ButtonWindow(winClient.NewChild(Class'ButtonWindow'));

	btnRightArrow.SetPos(117, 316);
	btnRightArrow.SetSize(14, 15);

	btnRightArrow.SetButtonTextures(
		Texture'MenuRightArrow_Normal',
		Texture'MenuRightArrow_Pressed');
}

// ----------------------------------------------------------------------
// CreateSkillButtons()
// ----------------------------------------------------------------------

function CreateSkillButtons()
{
	btnUpgrade = MenuUIActionButtonWindow(winClient.NewChild(Class'MenuUIActionButtonWindow'));
	btnUpgrade.SetButtonText(ButtonUpgradeLabel);
	btnUpgrade.SetPos(164, 341);
	btnUpgrade.SetWidth(74);

	btnDowngrade = MenuUIActionButtonWindow(winClient.NewChild(Class'MenuUIActionButtonWindow'));
	btnDowngrade.SetButtonText(ButtonDowngradeLabel);
	btnDowngrade.SetPos(241, 341);
	btnDowngrade.SetWidth(90);
}

// ----------------------------------------------------------------------
// CreateTextHeaders()
// ----------------------------------------------------------------------

function CreateTextHeaders()
{
	local MenuUILabelWindow winLabel;

	CreateMenuLabel( 21,  17, HeaderCodeNameLabel,     winClient);
	CreateMenuLabel( 21,  73, HeaderNameLabel,         winClient);
	CreateMenuLabel( 21, 133, HeaderAppearanceLabel,   winClient);
	CreateMenuLabel(172,  17, HeaderSkillsLabel,       winClient);

	winLabel = CreateMenuLabel(430,  18, HeaderSkillLevelLabel,   winClient);
	winLabel.SetFont(Font'FontMenuSmall');

	winLabel = CreateMenuLabel(505,  18, HeaderPointsNeededLabel, winClient);
	winLabel.SetFont(Font'FontMenuSmall');

	CreateMenuLabel(409, 344, HeaderSkillPointsLabel,  winClient);
}

// ----------------------------------------------------------------------
// CreateCodeNameEditWindow()
// ----------------------------------------------------------------------

function CreateCodeNameEditWindow()
{
	editCodeName = CreateMenuEditWindow(18, 36, 113, 32, winClient);

	editCodeName.SetText(player.FamiliarName);
	editCodeName.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// CreateNameEditWindow()
// ----------------------------------------------------------------------

function CreateNameEditWindow()
{
	editName = CreateMenuEditWindow(18, 92, 113, 32, winClient);

	editName.SetText(player.TruePlayerName);
	editName.MoveInsertionPoint(MOVEINSERT_End);
	editName.SetFilter(filterString);
}

// ----------------------------------------------------------------------
// CreateSkillsListWindow()
// ----------------------------------------------------------------------

function CreateSkillsListWindow()
{
	lstSkills = MenuUIListWindow(winClient.NewChild(Class'MenuUIListWindow'));

	lstSkills.SetSize(397, 150);
	lstSkills.SetPos(172,41);
	lstSkills.EnableMultiSelect(False);
	lstSkills.EnableAutoExpandColumns(False);
	lstSkills.SetNumColumns(3);

	lstSkills.SetColumnWidth(0, 262);
	lstSkills.SetColumnWidth(1,  66);
	lstSkills.SetColumnWidth(2,  60);
	lstSkills.SetColumnAlignment(2, HALIGN_Right);

	lstSkills.SetColumnFont(0, Font'FontMenuSmall'); //'FontMenuHeaders'
	lstSkills.SetSortColumn(0, False);
	lstSkills.EnableAutoSort(True);
}

// ----------------------------------------------------------------------
// CreateSkillInfoWindow()
// ----------------------------------------------------------------------

function CreateSkillInfoWindow()
{
	winSkillInfo = MenuUISkillInfoWindow(winClient.NewChild(Class'MenuUISkillInfoWindow'));
	winSkillInfo.SetPos(165, 208);
}

// ----------------------------------------------------------------------
// CreateSkillPointsButton()
// ----------------------------------------------------------------------

function CreateSkillPointsButton()
{
	winSkillPoints = MenuUIStaticInfoWindow(winClient.NewChild(Class'MenuUIStaticInfoWindow'));

	winSkillPoints.SetPos(487, 341);
	winSkillPoints.SetWidth(83);
	winSkillPoints.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// PopulateSkillsList()
// ----------------------------------------------------------------------

function PopulateSkillsList()
{
	local int skillIndex;
	local int rowIndex;

	lstSkills.DeleteAllRows();
	skillIndex = 0;

	// Iterate through the skills, adding them to our list
	while(localSkills[skillIndex] != None)
	{
		rowIndex = lstSkills.AddRow(BuildSkillString(localSkills[skillIndex]));
		lstSkills.SetRowClientObject(rowIndex, localSkills[skillIndex]);

		skillIndex++;
	}
	lstSkills.Sort();
	lstSkills.SetRow(lstSkills.IndexToRowId(0), False);
}

// ----------------------------------------------------------------------
// BuildSkillsString()
// ----------------------------------------------------------------------

function String BuildSkillString( Skill aSkill )
{
	local String skillString;
	local String levelCost;

	if ( aSkill.GetCurrentLevel() == 3 )
		levelCost = "--";
	else
		levelCost = String(aSkill.GetCost());

	skillString = aSkill.skillName $ ";" $
				  aSkill.GetCurrentLevelString() $ ";" $
				  levelCost;

	return skillString;
}

// ----------------------------------------------------------------------
// UpdateSkillPoints()
// ----------------------------------------------------------------------

function UpdateSkillPoints()
{
	winSkillPoints.SetButtonText(String(player.SkillPointsAvail));
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch( buttonPressed )
	{
		case btnUpgrade:
			UpgradeSkill();
			Player.Playsound(sound'Select',SLOT_None, 0.85,,0.8);
			break;

		case btnDowngrade:
			DowngradeSkill();
			break;

		case btnLeftArrow:
			PreviousPortrait();
			break;

		case btnRightArrow:
			NextPortrait();
			break;

		case btnPortrait:
			NextPortrait();
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// ListRowActivated()
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	local DeusExRootWindow root;
	root = DeusExRootWindow(player.rootWindow);
	if (root != None)
	{
		if (root.IsKeyDown(IK_Shift) || root.IsKeyDown(IK_Ctrl) || root.IsKeyDown(IK_Alt))
            DowngradeSkill();
        else
            UpgradeSkill();
    }
	return True;
}

// ----------------------------------------------------------------------
// ListSelectedChanged()
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	local Skill aSkill;

	selectedSkill = Skill(ListWindow(list).GetRowClientObject(focusRowId));
	selectedRowId = focusRowId;

	winSkillInfo.SetSkill(selectedSkill);

	EnableButtons();

	return True;
}

// ----------------------------------------------------------------------
// TextChanged()
// ----------------------------------------------------------------------

event bool TextChanged(window edit, bool bModified)
{
	EnableButtons();

	return false;
}

/*
   Took out because people were bitching (Waaaaaaaaaaaaaaah!) about
   how pressing Enter in the name box would start the game.

// ----------------------------------------------------------------------
// EditActivated()
//
// Allow the user to press [Return] to accept the username/password
// ----------------------------------------------------------------------

event bool EditActivated(window edit, bool bModified)
{
	if (IsActionButtonEnabled(AB_Other, "START"))
	{
		ProcessAction("START");
		return True;
	}
	else
	{
		return False;
	}
}
*/

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Abort if a skill item isn't selected
	if ( selectedSkill == None )
	{
		btnUpgrade.SetSensitivity( False );
		btnDowngrade.SetSensitivity( False );
	}
	else
	{
		// Upgrade Skill only available if the skill is not at
		// the maximum -and- the user has enough skill points
		// available to upgrade the skill

		btnUpgrade.EnableWindow(selectedSkill.CanAffordToUpgrade(player.SkillPointsAvail));
		btnDowngrade.EnableWindow(selectedSkill.GetCurrentLevel() > 0);
	}

	// Only enable the OK button if the player has entered a name
	if (editName != None)
	{
		if (editName.GetText() == "")
			EnableActionButton(AB_Other, False, "START");
		else
			EnableActionButton(AB_Other, True, "START");
	}
}

// ----------------------------------------------------------------------
// PreviousPortrait()
// ----------------------------------------------------------------------

function PreviousPortrait()
{
	portraitIndex--;

	//LDDP, 10/26/21: Hacky logic for array count wraparound based on load/did not load status.
	if (portraitIndex < 0)
		portraitIndex = arrayCount(texPortraits) - 1 - (5*int(!bFemaleEnabled));
	
	//Male? Hide male interactions checkbox.
	if (PortraitIndex%2 == 0)
	{
		MaleInteractionsCheckbox.SetPos(5000+MaleInteractionsCheckboxPos.X, MaleInteractionsCheckboxPos.Y);
	}
	else
	{
		MaleInteractionsCheckbox.SetPos(MaleInteractionsCheckboxPos.X, MaleInteractionsCheckboxPos.Y);
	}

	btnPortrait.SetBackground(texPortraits[portraitIndex]);
}

// ----------------------------------------------------------------------
// NextPortrait()
// ----------------------------------------------------------------------

function NextPortrait()
{
	portraitIndex++;

	//LDDP, 10/26/21: Hacky logic for array count wraparound based on load/did not load status.
	if (portraitIndex == arrayCount(texPortraits)/(1+int(!bFemaleEnabled)))
		portraitIndex = 0;
	
	//Male? Hide male interactions checkbox.
	if (PortraitIndex%2 == 0)
	{
		MaleInteractionsCheckbox.SetPos(5000+MaleInteractionsCheckboxPos.X, MaleInteractionsCheckboxPos.Y);
	}
	else
	{
		MaleInteractionsCheckbox.SetPos(MaleInteractionsCheckboxPos.X, MaleInteractionsCheckboxPos.Y);
	}

	btnPortrait.SetBackground(texPortraits[portraitIndex]);
}

// ----------------------------------------------------------------------
// UpgradeSkill()
// ----------------------------------------------------------------------

function UpgradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.IncLevel(player);
	lstSkills.ModifyRow(selectedRowId, BuildSkillString( selectedSkill ));

	UpdateSkillPoints();
	EnableButtons();
}

// ----------------------------------------------------------------------
// DowngradeSkill()
// ----------------------------------------------------------------------

function DowngradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.DecLevel(True, Player);
	lstSkills.ModifyRow(selectedRowId, BuildSkillString( selectedSkill ));

	UpdateSkillPoints();
	EnableButtons();
}

// ----------------------------------------------------------------------
// ResetToDefaults()
//
// Meant to be called in derived class
// ----------------------------------------------------------------------

function ResetToDefaults()
{
	editName.SetText(player.TruePlayerName);

	//LDDP, 11/01/21: Set LDDP checkbox options to default, hide MI4FJC checkbox because we're male now.
	MorpheusCheckbox.SetToggle(false);
	MaleInteractionsCheckbox.SetToggle(false);
	MaleInteractionsCheckbox.SetPos(5000+MaleInteractionsCheckboxPos.X, MaleInteractionsCheckboxPos.Y);

	player.SkillPointsAvail = player.Default.SkillPointsAvail;
	player.SkillPointsTotal = player.Default.SkillPointsTotal;

	portraitIndex = 0;
	btnPortrait.SetBackground(texPortraits[portraitIndex]);

	CopySkills();
	PopulateSkillsList();
	UpdateSkillPoints();
	EnableButtons();
}

// ----------------------------------------------------------------------
// CopySkills()
//
// Makes a local copy of the skills so we can manipulate them without
// actually making changes to the ones attached to the player.
// ----------------------------------------------------------------------

function CopySkills()
{
	local Skill aSkill;
	local int skillIndex;

	skillIndex = 0;

	aSkill = player.SkillSystem.FirstSkill;
	while(aSkill != None)
	{
		localSkills[skillIndex] = player.Spawn(aSkill.Class);
		skillIndex++;
		aSkill = aSkill.next;
	}
}

// ----------------------------------------------------------------------
// ApplySkills()
//
// Apply our local skills to the real skills in the game.
// ----------------------------------------------------------------------

function ApplySkills()
{
	local Skill aSkill;
	local int skillIndex;

	skillIndex = 0;

	while(localSkills[skillIndex] != None)
	{
		aSkill = player.SkillSystem.FirstSkill;
		while(aSkill != None)
		{
			if (aSkill.SkillName == localSkills[skillIndex].SkillName)
			{
				// Copy the skill
				aSkill.CurrentLevel = localSkills[skillIndex].GetCurrentLevel();
				break;
			}
			aSkill = aSkill.next;
		}
		skillIndex++;
	}
}

// ----------------------------------------------------------------------
// DestroyLocalSkills()
// ----------------------------------------------------------------------

function DestroyLocalSkills()
{
	local int skillIndex;

	skillIndex = 0;

	while(localSkills[skillIndex] != None)
	{
		localSkills[skillIndex].Destroy();
		localSkills[skillIndex] = None;
		skillIndex++;
	}
}

// ----------------------------------------------------------------------
// ProcessAction()
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
	local DeusExPlayer		localPlayer;
	local String			localStartMap;
	local String            playerName;
    local MenuScreenPlaythroughModifiers modMenu;                               //RSD

	localPlayer   = player;
//	localStartMap = strStartMap;

	if (actionKey == "START")
	{
		// Make sure the name isn't blank
		playerName = TrimSpaceS(editName.GetText());

		if (playerName == "")
		{
			root.MessageBox(NameBlankTitle, NameBlankPrompt, 1, False, Self);
		}
		else
		{
			SaveSettings();

			// DEUS_EX_DEMO
			//
			// Don't show the intro for the demo since that map is not available
	//		localPlayer.bHardCoreMode=bHardCoreMode;
			localPlayer.ShowIntro(True);
//			localPlayer.StartNewGame(localPlayer.strStartMap);
		}
	}
	else if (actionKey == "MODIFIERS")                                          //RSD: New modifiers menu
    {
		modMenu = MenuScreenPlaythroughModifiers(root.InvokeMenuScreen(Class'MenuScreenPlaythroughModifiers'));
        modMenu.bHardcoreSelected = bHardCoreMode;
        modMenu.BuildModifierList();
    }
    else if (actionKey == "HELP")
    {
        //LDDP, 10/28/21: Optimized parsing. Also invoking new help window here.
        GiveTip(true);
    }
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
    local Human THuman;

    ApplySkills();
	player.TruePlayerName   = editName.GetText();
	player.CombatDifficulty = combatDifficulty;
	player.bHardCoreMode=bHardCoreMode;
	if (bHardCoreMode)
	  player.bAutoReload=false;
    player.bRandomizeCrates=bRandomizeCrates;                                   //RSD
    player.bRandomizeMods=bRandomizeMods;                                       //RSD
    player.bRandomizeAugs=bRandomizeAugs;                                       //RSD
    player.bRestrictedSaving=bRestrictedSaving;                                 //Sarge
    player.iNoKeypadCheese=iNoKeypadCheese;                                     //Sarge
    player.bRandomizeEnemies=bRandomizeEnemies;                                 //Sarge
    player.bPrisonStart=bPrisonStart;                                           //Sarge
    player.bRandomizeCrap=bRandomizeCrap;                                       //Sarge
    player.bCutInteractions=bCutInteractions;                                   //Sarge
    player.bA51Camera=bA51Camera;                                               //Sarge
    player.bCollectiblesEnabled=bCollectibles;                                  //Sarge
    if (player.bRandomizeAugs)                                                  //RSD: New aug randomization feature
        ScrambleAugOrderList();

    //Fix players still having killswitch if they had it previously
    if (!player.bRealKillswitch)
        player.killswitchTimer = -1;

    player.bAddictionSystem=bAddictionSystem;
    player.bExtraHardcore=bExtraHardcore;
    //player.bRestrictedMetabolism=bRestrictedMetabolism;
    player.bMoreLDDPNPCs=bMoreLDDPNPCs;                                         //Sarge
    player.bDisableConsoleAccess=bDisableConsoleAccess;                         //Sarge
    player.bWeaponRequirementsMatter=bWeaponRequirementsMatter;                 //Sarge
    player.bRealKillswitch=bRealKillswitch;                                     //Sarge
  	player.bCameraDetectUnconscious = bCameraDetectUnconscious;
    player.bShenanigans=bShenanigans;                                           //Sarge

    //LDDP
	THuman = Human(Player);
	if (THuman != None)
	{
		THuman.bRetroMorpheus = MorpheusCheckbox.GetToggle();
		THuman.bFemaleUsesMaleInteractions = MaleInteractionsCheckbox.GetToggle();
		THuman.bGaveNewGameTips = true;
		THuman.SaveConfig();
	}

	//LDDP, 10/26/21: Do some swoocey bullshit for indices.
	if (!bFemaleEnabled)
	{
		player.PlayerSkin = portraitIndex;
	}
	else
	{
		switch(PortraitIndex)
		{
			case 0:
			case 1:
				Player.PlayerSkin = 0;
			break;
			case 2:
			case 3:
				Player.PlayerSkin = 1;
			break;
			case 4:
			case 5:
				Player.PlayerSkin = 2;
			break;
			case 6:
			case 7:
				Player.PlayerSkin = 3;
			break;
			case 8:
			case 9:
				Player.PlayerSkin = 4;
			break;
		}
		
		//LDDP, 10/26/21: Save this as a boolean, since flags are about to be wiped. Add this boolean to human, modders.
		if (Human(Player) != None)
		{
			Human(Player).bMadeFemale = (PortraitIndex % 2 == 1);
		}
	}
}

function ScrambleAugOrderList()                                                 //RSD: Shuffle the order of aug canisters encountered throughout the game
{
    local int i,j,temp;

    for (i=0; i<ArrayCount(player.augOrderNums); i++)                           //RSD: Initialize ordered list
	    player.augOrderNums[i] = i;
    for (i=ArrayCount(player.augOrderNums)-1; i>0; i--)                         //RSD: Fisher–Yates shuffle algorithm
    {
        j = rand(i+1);                                                          //RSD: i+1 because Rand(i) produces a number between 0 and i-1, which is actually Sattolo's biased algorithm
        temp = player.augOrderNums[i];
        player.augOrderNums[i] = player.augOrderNums[j];
        player.augOrderNums[j] = temp;
    }
    for (i=0; i<ArrayCount(player.augOrderNums); i++)
log(player.augOrderNums[i]);
}

//LDDP
function CreateLDDPCheckboxes()
{
	local Human THuman;
	
	THuman = Human(GetPlayerPawn());
	
	MorpheusCheckbox = NewGameCheckBoxWindow(winClient.NewChild(Class'NewGameCheckBoxWindow'));
	MorpheusCheckbox.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 203, 424);
	MorpheusCheckbox.SetText(MorpheusCheckboxLabel);
	MorpheusCheckbox.SetToggle(false);
	MorpheusCheckbox.SetPos(MorpheusCheckboxPos.X, MorpheusCheckboxPos.Y);
	
	//Note: Add 5000 to default because default is MALE, and has no use for this checkbox.
	MaleInteractionsCheckbox = NewGameCheckBoxWindow(winClient.NewChild(Class'NewGameCheckBoxWindow'));
	MaleInteractionsCheckbox.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 203, 424);
	MaleInteractionsCheckbox.SetText(MaleInteractionsCheckboxLabel);
	MaleInteractionsCheckbox.SetToggle(false);
	MaleInteractionsCheckbox.SetPos(5000+MaleInteractionsCheckboxPos.X, MaleInteractionsCheckboxPos.Y);
	
	if (THuman != None)
	{
		MorpheusCheckbox.SetToggle(THuman.bRetroMorpheus);
		MaleInteractionsCheckbox.SetToggle(THuman.bFemaleUsesMaleInteractions);
	}
}

function GiveTip(bool always)
{
	if ((Human(Player) != None && !Human(Player).bGaveNewGameTips) || always)
	{
		root.MessageBox(CheckboxTipHeader, CheckboxTipText, 1, False, Self);
	}
}

// ----------------------------------------------------------------------
// CancelScreen()
// ----------------------------------------------------------------------

function CancelScreen()
{
	RestoreSkillPoints();
	Super.CancelScreen();
}

// ----------------------------------------------------------------------
// SaveSkillPoints()
// ----------------------------------------------------------------------

function SaveSkillPoints()
{
	saveSkillPointsAvail = player.SkillPointsAvail;
	saveSkillPointsTotal = player.SkillPointsAvail;
}

// ----------------------------------------------------------------------
// RestoreSkillPoints()
// ----------------------------------------------------------------------

function RestoreSkillPoints()
{
	player.SkillPointsAvail = saveSkillPointsAvail;
	player.SkillPointsAvail = saveSkillPointsTotal;
}

// ----------------------------------------------------------------------
// TrimSpaces()
// ----------------------------------------------------------------------

function String TrimSpaces(String trimString)
{
	local int trimIndex;
	local int trimLength;

	if ( trimString == "" )
		return trimString;

	trimIndex = Len(trimString) - 1;
	while ((trimIndex >= 0) && (Mid(trimString, trimIndex, 1) == " ") )
		trimIndex--;

	if ( trimIndex < 0 )
		return "";

	trimString = Mid(trimString, 0, trimIndex + 1);

	trimIndex = 0;
	while((trimIndex < Len(trimString) - 1) && (Mid(trimString, trimIndex, 1) == " "))
		trimIndex++;

	trimLength = len(trimString) - trimIndex;
	trimString = Right(trimString, trimLength);

	return trimString;
}

// ----------------------------------------------------------------------
// BoxOptionSelected()
// ----------------------------------------------------------------------

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	// Destroy the msgbox!
	root.PopWindow();

	//editName.SetText(player.TruePlayerName); //Resets the name!
	editName.MoveInsertionPoint(MOVEINSERT_End);
	editName.SetSelectedArea(0, Len(editName.GetText()));
	SetFocusWindow(editName);

	return True;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	local Color colButtonFace;

	Super.StyleChanged();

	theme = player.ThemeManager.GetCurrentMenuColorTheme();

	// Title colors
	colButtonFace = theme.GetColorFromName('MenuColor_ButtonFace');

	btnLeftArrow.SetButtonColors(colButtonFace, colButtonFace, colButtonFace,
	                             colButtonFace, colButtonFace, colButtonFace);
	btnRightArrow.SetButtonColors(colButtonFace, colButtonFace, colButtonFace,
	                              colButtonFace, colButtonFace, colButtonFace);
}

// ----------------------------------------------------------------------
// SetDifficulty()
// ----------------------------------------------------------------------

function SetDifficulty(float newDifficulty,bool bSetHardCore)
{
	combatDifficulty = newDifficulty;
	bHardCoreMode=bSetHardCore;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texPortraits(0)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_1'
     texPortraits(1)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_2'
     texPortraits(2)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_3'
     texPortraits(3)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_4'
     texPortraits(4)=Texture'DeusExUI.UserInterface.MenuNewGameJCDenton_5'
     filterString="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 "
     ButtonDowngradeLabel="|&Downgrade"
     HeaderNameLabel="Real Name"
     HeaderCodeNameLabel="Code Name"
     HeaderAppearanceLabel="Appearance"
     HeaderSkillsLabel="Skills"
     HeaderSkillPointsLabel="Skill Points"
     HeaderSkillLevelLabel="Skill Level"
     HeaderPointsNeededLabel="Points Needed"
     NameBlankTitle="Name Blank!"
     NameBlankPrompt="The Real Name cannot be blank, please enter a name."
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_Other,Text="|&Start Game",Key="START")
     actionButtons(2)=(Action=AB_Reset)
     actionButtons(3)=(Action=AB_Other,Text="Modifiers",Key="MODIFIERS")
     actionButtons(4)=(Action=AB_Other,Text="LDDP Help",Key="HELP")
     Title="Start New Game"
     ClientWidth=580
     ClientHeight=389
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuNewGameBackground_6'
     bUsesHelpWindow=False
     bEscapeSavesSettings=False
     
     //LDDP Settings
     MorpheusCheckboxPos=(X=3,Y=342)
     MaleInteractionsCheckboxPos=(X=3,Y=362)
     MorpheusCheckboxLabel="Original Morpheus?"
     MaleInteractionsCheckboxLabel="Original Interactions?"
     CheckboxTipHeader="LDDP 1.1 Checkbox Options"
     CheckboxTipText="'Original Morpheus' reverts to his old voiceover. 'Original interactions' reverts to the old dialogue for Mercedes, Camille, Mamasan, and CanalWhore."     ButtonUpgradeLabel="Upg|&rade"
}
