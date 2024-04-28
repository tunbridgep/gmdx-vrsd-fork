//=============================================================================
// PersonaInfoWindow
//=============================================================================

class PersonaInfoWindow expands PersonaBaseWindow;

var PersonaScrollAreaWindow      winScroll;
var TileWindow                   winTile;
var PersonaHeaderTextWindow      winTitle;
var PersonaNormalLargeTextWindow winText;			// Last text

var int textVerticalOffset;
//Totalitarian: perks and stuff
//var PersonaActionButtonWindow buttonUpgrade;
//var PersonaActionButtonWindow buttonUpgrade2;
//var PersonaActionButtonWindow buttonUpgrade3;
var PersonaActionButtonWindow    buttonUpgradeSecond;                           //RSD
var localized String UpgradeButtonLabel;
//var PersonaButtonBarWindow winActionButtons;
//var PersonaButtonBarWindow winActionButtons2;
//var PersonaButtonBarWindow winActionButtons3;
//var PersonaButtonBarWindow       winActionButtonsSecond;                        //RSD

//var PersonaButtonBarWindow winActionButtons4;
//var PersonaButtonBarWindow winActionButtons5;
//var PersonaButtonBarWindow winActionButtons6;
//var Window                 winSkillIconP;
//var Window                 winSkillIconP2;
//var Window                 winSkillIconP3;
//var TextWindow WinSkillText;
//var TextWindow WinSkillText2;
//var TextWindow WinSkillText3;
//var TextWindow WinPerkTitle;
//var TextWindow WinPerkTitle2;
//var TextWindow WinPerkTitle3;

var Inventory                    assignThis;                                    //RSD: Added

var localized String PassedSkillName;
var localized string RequiredPoints;
var localized string PerkTitle;
var localized string ob;
var localized string msgAssign;                                                 //RSD: Added
var localized string msgConf;                                                   //RSD: Added
var localized string msgAssigned;                                               //RSD: Added
var localized string msgUnassigned;                                             //RSD: Added

var bool bStylization;
var bool bStylization2;
var bool bStylization3;
var bool bMedBotCall;

var Texture PassedSkillIcon;

var PersonaButtonBarWindow winActionButtons1[10];
var TextWindow WinPerkTitle[10];
var TextWindow WinSkillText[10];
var PersonaButtonBarWindow winActionButtons[10];
var PersonaButtonBarWindow winActionButtonsSecondary;
var PersonaActionButtonWindow buttonUpgrade[10];
var Window winSkillIconP[10];

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winTitle = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winTitle.SetTextMargins(2, 1);

	winScroll = PersonaScrollAreaWindow(NewChild(Class'PersonaScrollAreaWindow'));

	winTile = TileWindow(winScroll.ClipWindow.NewChild(Class'TileWindow'));
	winTile.SetOrder(ORDER_Down);
	winTile.SetChildAlignments(HALIGN_Full, VALIGN_Top);
	winTile.MakeWidthsEqual(True);
	winTile.MakeHeightsEqual(False);
	winTile.SetMargins(4, 1);
	winTile.SetMinorSpacing(0);
	winTile.SetWindowAlignments(HALIGN_Full, VALIGN_Top);
}

// ----------------------------------------------------------------------
// CreatePerkOverview()
// ----------------------------------------------------------------------

function CreatePerkOverview(Perk Perk, int index)	//Trash: Creates the description, upgrade button, etc for each perk
{
	local Perk PerkInManager;
	local DeusExPlayer player;

	PerkInManager = player.PerkManager.GetPerkName(Perk.PerkName);

    winActionButtons1[index] = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
    winActionButtons1[index].SetWidth(0);
    winActionButtons1[index].SetHeight(26);
    winActionButtons1[index].FillAllSpace(false);
    WinPerkTitle[index] = TextWindow(winActionButtons1[index].NewChild(class'TextWindow'));
	WinPerkTitle[index].SetText(Perk.PerkName);
	WinPerkTitle[index].SetFont(Font'FontMenuSmall');
    WinPerkTitle[index].SetTextColor(colText);
    WinPerkTitle[index].SetTextMargins(6,4);
    winSkillIconP[index] = winActionButtons1[index].NewChild(Class'Window');
    winSkillIconP[index].SetPos(192, 0);
	winSkillIconP[index].SetSize(24, 24);
	winSkillIconP[index].SetBackgroundStyle(DSTY_Normal);
	winSkillIconP[index].SetBackground(PassedSkillIcon); // CHECK THIS LATER, TRASH!
	WinSkillText[index] = TextWindow(winSkillIconP[index].NewChild(class'TextWindow'));
	WinSkillText[index].SetFont(Font'FontConversationLargeBold');
	//if (pName == "MODDER")
	//   WinSkillText[index].SetTextColorRGB(96,96,96);
	//else
    WinSkillText[index].SetTextColorRGB(192,192,192);
	WinSkillText[index].SetText("0");

    SetText(Perk.PerkDescription);
    SetText(RequiredPoints $ Perk.PerkCost);
	winActionButtons[index] = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons[index].SetWidth(32); //149
	winActionButtons[index].FillAllSpace(false);
	buttonUpgrade[index] = PersonaActionButtonWindow(winActionButtons[index].NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade[index].SetButtonText(UpgradeButtonLabel);
	buttonUpgrade[index].PerkNamed = Perk.PerkName;
	buttonUpgrade[index].PerkSkillCost = Perk.PerkCost;
	buttonUpgrade[index].ButtonPerk = Perk;
	if (Player.SkillPointsAvail < Perk.PerkCost)
	   buttonUpgrade[index].SetSensitivity(False);
    AddLine();

	if ((Player.SkillSystem.GetSkillLevel(PerkInManager.PerkSkill) < (PerkInManager.PerkLevelRequirement + 1) || PerkInManager.bPerkObtained == True))
		buttonUpgrade[index].SetSensitivity(False);
	if (PerkInManager.bPerkObtained == false && PerkInManager.PerkCost != 0 && Player.SkillPointsAvail >= PerkInManager.PerkCost)
		buttonUpgrade[index].SetSensitivity(True);

	//ButtonActivated(buttonUpgrade[index]); // Trash: Do I even need this here?
}

//////////////////////////////////////////////////
//  //Totalitarian: CreatePerkButtons
//////////////////////////////////////////////////
function CreatePerkButtons(Skill Skill)
{
    local int i, index, indexPerkThingy;

	local Perk perksTrained[5];
	local Perk perksAdvanced[5];
	local Perk perksMaster[5];

                          //Totalitarian: WARNING! THE WHOLE PERK SYSTEM PASSES PERK NAME! DO NOT CHANGE THE NAME OF PERKS
    AddLine();            //Totalitarian: INSTEAD CHANGE THE LocalizedPerkName VAR
    SetText(PerkTitle);	  // Trash: Ignore the warning above - actually this file entirely, perk system has been overhauled so no more hardcoded perks
    AddLine();

	for (index = 0; index < ArrayCount(Player.PerkManager.PerkList); index++)
	{
		if (Player.PerkManager.PerkList[index].PerkSkill  == Skill.class && Player.PerkManager.PerkList[index].PerkLevelRequirement == 0)
		{
			CreatePerkOverview(Player.PerkManager.PerkList[index], indexPerkThingy);
			indexPerkThingy++;
		}
	}
	for (index = 0; index < ArrayCount(Player.PerkManager.PerkList); index++)
	{
		if (Player.PerkManager.PerkList[index].PerkSkill == Skill.class && Player.PerkManager.PerkList[index].PerkLevelRequirement == 1)
		{
			CreatePerkOverview(Player.PerkManager.PerkList[index], indexPerkThingy);
			indexPerkThingy++;
		}
	}
	for (index = 0; index < ArrayCount(Player.PerkManager.PerkList); index++)
	{
		if (Player.PerkManager.PerkList[index].PerkSkill== Skill.class && Player.PerkManager.PerkList[index].PerkLevelRequirement == 2)
		{
			CreatePerkOverview(Player.PerkManager.PerkList[index], indexPerkThingy);
			indexPerkThingy++;
		}
	}
	

	//string PerkInfo, string PerkInfo2, string PerkInfo3, int Costs, int Costs2, int Costs3,
//string pName, string pName2, string pName3, string localizedpName, string localizedpName2, string localizedpName3, Texture PassedSkillIcon

	/*
    if (Costs != 0)
    {
    winActionButtons4 = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
    winActionButtons4.SetWidth(0);
    winActionButtons4.SetHeight(26);
    winActionButtons4.FillAllSpace(false);
    WinPerkTitle = TextWindow(winActionButtons4.NewChild(class'TextWindow'));
	WinPerkTitle.SetText(localizedpName);
	WinPerkTitle.SetFont(Font'FontMenuSmall');
    WinPerkTitle.SetTextColor(colText);
    WinPerkTitle.SetTextMargins(6,4);
    winSkillIconP = winActionButtons4.NewChild(Class'Window');
    winSkillIconP.SetPos(192, 0);
	winSkillIconP.SetSize(24, 24);
	winSkillIconP.SetBackgroundStyle(DSTY_Normal);
	winSkillIconP.SetBackground(PassedSkillIcon);
	WinSkillText = TextWindow(winSkillIconP.NewChild(class'TextWindow'));
	WinSkillText.SetFont(Font'FontConversationLargeBold');
	if (pName == "MODDER")
	   WinSkillText.SetTextColorRGB(96,96,96);
	else
       WinSkillText.SetTextColorRGB(192,192,192);
	WinSkillText.SetText("1");

    SetText(PerkInfo);
    SetText(RequiredPoints $ Costs);
	winActionButtons = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetWidth(32); //149
	winActionButtons.FillAllSpace(false);
	buttonUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade.SetButtonText(UpgradeButtonLabel);
	buttonUpgrade.PerkNamed=pName;
	buttonUpgrade.LocalizedPerkNamed=LocalizedpName;
	buttonUpgrade.PerkSkillCost=Costs;
	if (Player.SkillPointsAvail < Costs)
	   buttonUpgrade.SetSensitivity(False);
    AddLine();
    }

    if (Costs2 != 0)
    {
    winActionButtons5 = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
    winActionButtons5.SetWidth(0);
    winActionButtons5.SetHeight(26);
    winActionButtons5.FillAllSpace(false);
    WinPerkTitle2 = TextWindow(winActionButtons5.NewChild(class'TextWindow'));
	WinPerkTitle2.SetText(localizedpName2);
	WinPerkTitle2.SetFont(Font'FontMenuSmall');
    WinPerkTitle2.SetTextColor(colText);
    WinPerkTitle2.SetTextMargins(6,4);
    winSkillIconP2 = winActionButtons5.NewChild(Class'Window');
    winSkillIconP2.SetPos(192, 0);
	winSkillIconP2.SetSize(24, 24);
	winSkillIconP2.SetBackgroundStyle(DSTY_Normal);
	winSkillIconP2.SetBackground(PassedSkillIcon);
	WinSkillText2 = TextWindow(winSkillIconP2.NewChild(class'TextWindow'));
	WinSkillText2.SetFont(Font'FontConversationLargeBold');
	if (pName == "MODDER")
	   WinSkillText2.SetTextColorRGB(96,96,96);
	else
       WinSkillText2.SetTextColorRGB(192,192,192);
	WinSkillText2.SetText("2");

    SetText(PerkInfo2);
    SetText(RequiredPoints $ Costs2);
	winActionButtons2 = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons2.SetWidth(32); //149
	//winActionButtons2.SetHeight(24);
	winActionButtons2.FillAllSpace(false);
	buttonUpgrade2 = PersonaActionButtonWindow(winActionButtons2.NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade2.SetButtonText(UpgradeButtonLabel);
	buttonUpgrade2.PerkNamed2=pName2;
	buttonUpgrade2.LocalizedPerkNamed2=LocalizedpName2;
	buttonUpgrade2.PerkSkillCost2=Costs2;
	if (Player.SkillPointsAvail < Costs2)
	buttonUpgrade2.SetSensitivity(False);
    AddLine();
    }
    if (Costs3 != 0)
    {
    winActionButtons6 = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
    winActionButtons6.SetWidth(0);
    winActionButtons6.SetHeight(26);
    winActionButtons6.FillAllSpace(false);
    WinPerkTitle3 = TextWindow(winActionButtons6.NewChild(class'TextWindow'));
	WinPerkTitle3.SetText(localizedpName3);
	WinPerkTitle3.SetFont(Font'FontMenuSmall');
    WinPerkTitle3.SetTextColor(colText);
    WinPerkTitle3.SetTextMargins(6,4);
    winSkillIconP3 = winActionButtons6.NewChild(Class'Window');
    winSkillIconP3.SetPos(192, 0);
	winSkillIconP3.SetSize(24, 24);
	winSkillIconP3.SetBackgroundStyle(DSTY_Normal);
	winSkillIconP3.SetBackground(PassedSkillIcon);
	WinSkillText3 = TextWindow(winSkillIconP3.NewChild(class'TextWindow'));
	WinSkillText3.SetFont(Font'FontConversationLargeBold');
	if (pName == "MODDER")
	   WinSkillText3.SetTextColorRGB(96,96,96);
	else
       WinSkillText3.SetTextColorRGB(192,192,192);
	WinSkillText3.SetText("3");

    SetText(PerkInfo3);
    SetText(RequiredPoints $ Costs3);
	winActionButtons3 = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons3.SetWidth(32); //149
	winActionButtons3.FillAllSpace(False);
	buttonUpgrade3 = PersonaActionButtonWindow(winActionButtons3.NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade3.SetButtonText(UpgradeButtonLabel);
	buttonUpgrade3.PerkNamed3=pName3;
	buttonUpgrade3.LocalizedPerkNamed3=LocalizedpName3;
	buttonUpgrade3.PerkSkillCost3=Costs3;
	if (Player.SkillPointsAvail < Costs3)
	buttonUpgrade3.SetSensitivity(False);
	AddLine();
	}

	switch(pName3)
	{
            case "CREEPER":
			    if ((Player.SkillSystem.GetSkillLevel(class'SkillStealth') < 1 || Player.PerkNamesArray[9] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillStealth') < 2 || Player.PerkNamesArray[18] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[9] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[18] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillStealth') < 3 || Player.PerkNamesArray[29] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            case "ENDURANCE":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillSwimming') < 1 || Player.PerkNamesArray[5] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillSwimming') < 2 || Player.PerkNamesArray[17] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[5] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[17] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillSwimming') < 3 || Player.PerkNamesArray[27] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "CRACKED":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillTech') < 1  || Player.PerkNamesArray[10] == 1)&& Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillTech') < 2 || Player.PerkNamesArray[16] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[10] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[16] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillTech') < 3 || Player.PerkNamesArray[31] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "H.E ROCKET":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy') < 1 || Player.PerkNamesArray[3] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy') < 2 || Player.PerkNamesArray[13] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[3] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[13] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy') < 3 || Player.PerkNamesArray[24] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "INVENTIVE":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech') < 1 || Player.PerkNamesArray[4] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech') < 2 || Player.PerkNamesArray[14] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[4] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[14] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech') < 3 || Player.PerkNamesArray[25] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "PERFECT STANCE: PISTOLS":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponPistol') < 1 || Player.PerkNamesArray[1] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponPistol') < 2 || Player.PerkNamesArray[11] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[1] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[11] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponPistol') < 3 || Player.PerkNamesArray[22] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "PERFECT STANCE: RIFLES":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponRifle') < 1 || Player.PerkNamesArray[2] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponRifle') < 2 || Player.PerkNamesArray[12] == 1)&& Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[2] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[12] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillWeaponRifle') < 3 || Player.PerkNamesArray[23] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "KNOCKOUT GAS":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillDemolition') < 1 || Player.PerkNamesArray[0] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillDemolition') < 2 || Player.PerkNamesArray[15] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[0] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[15] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillDemolition') < 3 || Player.PerkNamesArray[26] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            case "LOCKSPORT":
                //if (Player.PerkNamesArray[35] == 1 && Costs != 0)             //RSD: No more Artificial Lock
				//buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillLockpicking') < 1 || Player.PerkNamesArray[36] == 1) && Costs != 0) //RSD: Replaced Artificial lock [35] with Sleight of Hand [36]
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillLockpicking') < 2 || Player.PerkNamesArray[34] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[34] != 1  && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillLockpicking') < 3 || Player.PerkNamesArray[32] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            case "TECH SPECIALIST":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillEnviro') < 1 || Player.PerkNamesArray[6] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillEnviro') < 2 || Player.PerkNamesArray[20] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[6] != 1 && Player.PerkNamesArray[35] == 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[20] != 1 && Player.PerkNamesArray[35] == 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillEnviro') < 3 || Player.PerkNamesArray[28] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            case "COMBAT MEDIC'S BAG":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillMedicine') < 1 || Player.PerkNamesArray[8] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillMedicine') < 2 || Player.PerkNamesArray[19] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[8] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[19] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillMedicine') < 3 || Player.PerkNamesArray[30] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

			case "NEAT HACK":
                if ((Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 1 || Player.PerkNamesArray[7] == 1) && Costs != 0)
				buttonUpgrade.SetSensitivity(False);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 2 || Player.PerkNamesArray[21] == 1) && Costs2 != 0)
				buttonUpgrade2.SetSensitivity(False);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[7] != 1 && Costs != 0 && Player.SkillPointsAvail >= Costs)
				   buttonUpgrade.SetSensitivity(True);
				if (Player.PerkNamesArray[35] == 1 && Player.PerkNamesArray[21] != 1 && Costs2 != 0 && Player.SkillPointsAvail >= Costs2)
				   buttonUpgrade2.SetSensitivity(True);
				if ((Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 3 || Player.PerkNamesArray[33] == 1) && Costs3 != 0)
				buttonUpgrade3.SetSensitivity(False);
				break;

            default:
                buttonUpgrade.SetSensitivity(False);
                buttonUpgrade2.SetSensitivity(False);
                buttonUpgrade3.SetSensitivity(False);
                break;
     }
	 */


     SetText(ob);
     AddLine();
     for (i=0;i<ArrayCount(Player.BoughtPerks);i++)
    {
     if (Player.BoughtPerks[i] != "")
     SetText(Player.BoughtPerks[i]);
    }
}

  // ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
    local DeusExBaseWindow TopWin;
	local DeusExPlayer player;
    local int i, index;
	local Perk PerkInManager;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

    topWin = DeusExRootWindow(GetRootWindow()).GetTopWindow();
	// Check if this is one of our Skills buttons
	/*if (buttonPressed.IsA('PersonaActionButtonWindow'))
	{
		SelectSkillButton(PersonaSkillButtonWindow(buttonPressed));
	}
	else
	{*/
	for (index = 0; index < ArrayCount(buttonUpgrade); index++)
	{
		PerkInManager = player.PerkManager.GetPerkName(buttonUpgrade[index].ButtonPerk.PerkName);

		if (buttonPressed == buttonUpgrade[index])
		{
			if (player.SkillPointsAvail >= (buttonUpgrade[index].ButtonPerk.PerkCost))
			{
				//Player.PlaySound(Sound'GMDXSFX.Generic.codelearned',SLOT_None,,,,0.8);
				//Player.SkillPointsAvail-= buttonUpgrade.PerkSkillCost;
				//Player.perksManager(buttonUpgrade.PerkNamed,1);
				player.PerkManager.GetPerkName(buttonUpgrade[index].ButtonPerk.PerkName).PurchasePerk();
				buttonUpgrade[index].SetSensitivity(False);
				SetText(buttonUpgrade[index].LocalizedPerkNamed);
				if ( TopWin!=None )
					TopWin.RefreshWindow( 0.0 );
				if (Player.SkillPointsAvail < buttonUpgrade[index].ButtonPerk.PerkCost)
						buttonUpgrade[index].SetSensitivity(False);
				//if (Player.SkillPointsAvail < buttonUpgrade2.PerkSkillCost2)
				//     buttonUpgrade2.SetSensitivity(False);
				//if (Player.SkillPointsAvail < buttonUpgrade3.PerkSkillCost3)
				//     buttonUpgrade3.SetSensitivity(False);
			}
			else
				buttonUpgrade[index].SetSensitivity(False);
		}
	}


		switch(buttonPressed)
		{
			/* 
			case buttonUpgrade:
			    if (Player.SkillPointsAvail >= (buttonUpgrade.ButtonPerk.PerkCost))
			    {
			    //Player.PlaySound(Sound'GMDXSFX.Generic.codelearned',SLOT_None,,,,0.8);
				//Player.SkillPointsAvail-= buttonUpgrade.PerkSkillCost;
				//Player.perksManager(buttonUpgrade.PerkNamed,1);
				buttonUpgrade.ButtonPerk.PurchasePerk();
				buttonUpgrade.SetSensitivity(False);
				SetText(buttonUpgrade.LocalizedPerkNamed);
				if ( TopWin!=None )
                   TopWin.RefreshWindow( 0.0 );
                if (Player.SkillPointsAvail < buttonUpgrade.PerkSkillCost)
	                 buttonUpgrade.SetSensitivity(False);
                //if (Player.SkillPointsAvail < buttonUpgrade2.PerkSkillCost2)
	            //     buttonUpgrade2.SetSensitivity(False);
                //if (Player.SkillPointsAvail < buttonUpgrade3.PerkSkillCost3)
	            //     buttonUpgrade3.SetSensitivity(False);
				}
				else
				buttonUpgrade.SetSensitivity(False);
				/*if (buttonUpgrade.PerkNamed == "ARTIFICIAL LOCK" && player.PerkNamesArray[34] != 1 && Player.SkillPointsAvail >= buttonUpgrade2.PerkSkillCost)
				    buttonUpgrade2.SetSensitivity(true);*/                      //RSD: No more Artificial Lock
				for (i=0;i<ArrayCount(Player.BoughtPerks);i++)
				{
				 if (Player.BoughtPerks[i] == "")
				 {
				 Player.BoughtPerks[i] = buttonUpgrade.LocalizedPerkNamed;
				 break;
				 }
				}
				break;
			*/

			/* 
            case buttonUpgrade2:
                if (Player.SkillPointsAvail >= buttonUpgrade2.PerkSkillCost2)
                {
                Player.PlaySound(Sound'GMDXSFX.Generic.codelearned',SLOT_None,,,,0.8);
				Player.SkillPointsAvail-= buttonUpgrade2.PerkSkillCost2;
				buttonUpgrade2.SetSensitivity(False);
				Player.perksManager(buttonUpgrade2.PerkNamed2,2);
				SetText(buttonUpgrade2.LocalizedPerkNamed2);
				if ( TopWin!=None )
                   TopWin.RefreshWindow( 0.0 );
                if (Player.SkillPointsAvail < buttonUpgrade.PerkSkillCost)
	                 buttonUpgrade.SetSensitivity(False);
                if (Player.SkillPointsAvail < buttonUpgrade2.PerkSkillCost2)
	                 buttonUpgrade2.SetSensitivity(False);
                if (Player.SkillPointsAvail < buttonUpgrade3.PerkSkillCost3)
	                 buttonUpgrade3.SetSensitivity(False);
				}
				else
				buttonUpgrade2.SetSensitivity(False);
				for (i=0;i<ArrayCount(Player.BoughtPerks);i++)
				{
				 if (Player.BoughtPerks[i] == "")
				 {
				 Player.BoughtPerks[i] = buttonUpgrade2.LocalizedPerkNamed2;
				 break;
				 }
				}
                break;

            case buttonUpgrade3:
                if (Player.SkillPointsAvail >= buttonUpgrade3.PerkSkillCost3)
                {
                Player.PlaySound(Sound'GMDXSFX.Generic.codelearned',SLOT_None,,,,0.8);
				Player.SkillPointsAvail-= buttonUpgrade3.PerkSkillCost3;
				buttonUpgrade3.SetSensitivity(False);
				Player.perksManager(buttonUpgrade3.PerkNamed3,3);
				SetText(buttonUpgrade3.LocalizedPerkNamed3);
				if ( TopWin!=None )
                   TopWin.RefreshWindow( 0.0 );
	            if (Player.SkillPointsAvail < buttonUpgrade.PerkSkillCost)
	                 buttonUpgrade.SetSensitivity(False);
                if (Player.SkillPointsAvail < buttonUpgrade2.PerkSkillCost2)
	                 buttonUpgrade2.SetSensitivity(False);
                if (Player.SkillPointsAvail < buttonUpgrade3.PerkSkillCost3)
	                 buttonUpgrade3.SetSensitivity(False);
				}
				else
				    buttonUpgrade3.SetSensitivity(False);
				for (i=0;i<ArrayCount(Player.BoughtPerks);i++)
				{
				 if (Player.BoughtPerks[i] == "")
				 {
				 Player.BoughtPerks[i] = buttonUpgrade3.LocalizedPerkNamed3;
				 break;
				 }
				}
                break;
				*/

            case buttonUpgradeSecond:

               if (assignThis != None && player.assignedWeapon != None && player.assignedWeapon == assignThis)
               {
                   player.AssignSecondary(None);
                   player.ClientMessage(msgUnassigned);
               }
               else if (assignThis != None)
               {
                   player.AssignSecondary(assignThis);
                   player.ClientMessage(msgAssigned);
               }
			   break;

			default:
				bHandled = False;
				break;
		}

    return bHandled;
}

// ----------------------------------------------------------------------
// SetTitle()
//
// Assume that if we're setting the title we're looking at another
// item and to clear the existing contents.
// ----------------------------------------------------------------------

function SetTitle(String newTitle)
{
	Clear();
	winTitle.SetText(newTitle);
	PassedSkillName = newTitle; //Totalitarian: perks
}

// ----------------------------------------------------------------------
// SetText()
// ----------------------------------------------------------------------

function PersonaNormalLargeTextWindow SetText(String newText)
{
	winText = PersonaNormalLargeTextWindow(winTile.NewChild(Class'PersonaNormalLargeTextWindow'));
    //winText.SetBackground(Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_1');
    if (bStylization)
    {
       if (winScroll != None)
       {
          winScroll.EnableScrolling(false,false);
          winScroll.EnableWindow(false);
       }
       winText.SetTextColorRGB(224,224,244);
       winText.SetVerticalSpacing(3);
       winText.SetFont(Font'Engine.SmallFont');
       winText.SetBackgroundStyle(DSTY_Masked);
       //winText.SetBackground(Texture'DeusExUI.UserInterface.ComputerHackBorder');
       winText.SetBackground(Texture'GMDXSFX.UI.pedometerTex1');
    }
    else if (bStylization2)
    {
       if (winScroll != None)
       {
          winScroll.EnableScrolling(false,false);
          winScroll.EnableWindow(false);
       }
       //winText.SetTextColorRGB(224,224,244);
       winText.SetFont(Font'FontMenuSmall');
       //winText.SetFont(Font'FontConversation');
       //winText.SetBackgroundStyle(DSTY_Translucent);
       //winText.SetBackground(Texture'DeusExUI.UserInterface.GoalsBackground_5');
       //winText.SetBackground(Texture'DeusExUI.UserInterface.HealthButtonNormal_Center');
       //winText.SetBackground(Texture'DeusExUI.UserInterface.HUDInfolinkBackground_1');
       winScroll.EnableScrolling(false,false);
    }
    else if (bStylization3)
    {
       if (winScroll != None)
       {
          winScroll.EnableScrolling(false,false);
          winScroll.EnableWindow(false);
       }
       winText.SetTextColorRGB(224,224,244);
       winText.SetFont(Font'FontComputer8x20_B');
       //winText.SetBackgroundStyle(DSTY_Masked);
       //winText.SetBackground(Texture'DeusExUI.UserInterface.ComputerHackBorder');
       //winText.SetBackground(Texture'GMDXSFX.UI.pedometerTex1');
    }
    else
    {
       winText.SetFont(Font'FontMenuSmall');
       winText.SetBackground(None);
    }
	winText.SetTextMargins(0, 0);
	winText.SetWordWrap(True);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winText.SetText(newText);

	return winText;
}

// ----------------------------------------------------------------------
// AppendText()
// ----------------------------------------------------------------------

function AppendText(String newText)
{
	if (winText != None)
		winText.AppendText(newText);
	else
		SetText(newText);
}

// ----------------------------------------------------------------------
// AddInfoItem()
// ----------------------------------------------------------------------

function PersonaInfoItemWindow AddInfoItem(coerce String newLabel, coerce String newText, optional bool bHighlight)
{
	local PersonaInfoItemWindow winItem;

	winItem = PersonaInfoItemWindow(winTile.NewChild(Class'PersonaInfoItemWindow'));
	winItem.SetItemInfo(newLabel, newText, bHighlight);

	return winItem;
}

function PersonaInfoItemWindow AddModInfo(coerce String newLabel, int count, optional bool bHighlight, optional int count2)
{
        local PersonaInfoItemWindow winItem;

        //a: we create an instance of an InfoItem as a child to winTile,
        //which actually makes the winItem var the new row we want to create in DeusExWeapon.uc
        winItem = PersonaInfoItemWindow(winTile.NewChild(Class'PersonaInfoItemWindow'));

        //And since InfoItem on init event creates instances of left and right columns of our new row, let's populate them with our custom function
        winItem.SetModInfo(newLabel, count, bHighlight, count2);

}
// ----------------------------------------------------------------------
// AddLine()
// ----------------------------------------------------------------------

function AddLine()
{
	winTile.NewChild(Class'PersonaInfoLineWindow');
}

// ----------------------------------------------------------------------
// Clear()
// ----------------------------------------------------------------------

function Clear()
{
	winTitle.SetText("");
	winTile.DestroyAllChildren();

	//Totalitarian: destroy perk upgrade buttons
	/*if (winActionButtons != None)
	    winActionButtons.DestroyAllChildren();
	if (winActionButtons2 != None)
	    winActionButtons2.DestroyAllChildren();
    if (winActionButtons3 != None)
	    winActionButtons3.DestroyAllChildren();      */
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float qWidth, qHeight;

	if (winTitle != None)
	{
		winTitle.QueryPreferredSize(qWidth, qHeight);
		winTitle.ConfigureChild(0, 0, width, qHeight);
	}

	if (winScroll != None)
	{
		winScroll.QueryPreferredSize(qWidth, qHeight);
		winScroll.ConfigureChild(0, textVerticalOffset, width, height - textVerticalOffset);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	ConfigurationChanged();

	return True;
}

function AddSecondaryButton(Inventory wep)                                      //RSD: Extending secondary items to more than just weapons
{
   if (wep != None)
   {
    SetText(msgAssign);
    winActionButtonsSecondary = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtonsSecondary.SetWidth(32); //149
	winActionButtonsSecondary.FillAllSpace(False);
	buttonUpgradeSecond = PersonaActionButtonWindow(winActionButtonsSecondary.NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgradeSecond.SetButtonText(msgConf);
	assignThis = wep;
   AddLine();
   }
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     textVerticalOffset=20
     UpgradeButtonLabel="|&Upgrade"
     RequiredPoints="Points Needed: "
     PerkTitle="PERKS"
     ob="OBTAINED PERKS"
     msgAssign="Assign as secondary item:"
     msgConf="Assign"
     msgAssigned="Secondary Item Assigned"
     msgUnassigned="Secondary Item Unassigned"
}
