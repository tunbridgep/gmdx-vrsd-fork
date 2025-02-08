//=============================================================================
// PersonaInfoWindow
//=============================================================================

class PersonaInfoWindow expands PersonaBaseWindow;

var PersonaScrollAreaWindow      winScroll;
var TileWindow                   winTile;
var PersonaHeaderTextWindow      winTitle;
var PersonaNormalLargeTextWindow winText;			// Last text

var int textVerticalOffset;
var PersonaActionButtonWindow    buttonUpgradeSecond;                           //RSD
var localized String UpgradeButtonLabel;
var localized String PurchasedButtonLabel;
var localized String UnobtainableButtonLabel;

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

var int numPerkButtons;

var Texture PassedSkillIcon;

var PersonaButtonBarWindow winActionButtons1[10];
var TextWindow WinPerkTitle[10];
var TextWindow WinSkillText[10];
var PersonaButtonBarWindow winActionButtons[10];
var PersonaButtonBarWindow winActionButtonsSecondary;
var PersonaActionButtonWindow buttonUpgrade[10];
var Window winSkillIconP[10];

//Perk Stuff
var localized String GeneralPerksTitleText;
var localized String PerkRequiredSkill;
var localized String PerkRequiredPoints;

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

//SARGE: Using sprintf shows floats as 1.00000000000 etc,
//So we need to remove some of the digits.
//This is absolutely awful.
function string TextDisplayHack(float value, int digits)
{
    //if it's a whole number, just return the number
    if (int(value) == value)
        return string(int(value));

    return Left(value, digits);
}

function CreatePerkOverview(Skill skill, Perk Perk, int index)	//Trash: Creates the description, upgrade button, etc for each perk
{
	local DeusExPlayer player;
    local string perkDescModified;

	player = DeusExPlayer(GetPlayerPawn());

	PassedSkillIcon = Perk.GetPerkIcon();

    winActionButtons1[index] = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
    winActionButtons1[index].SetWidth(0);
    winActionButtons1[index].SetHeight(26);
    winActionButtons1[index].FillAllSpace(false);
    WinPerkTitle[index] = TextWindow(winActionButtons1[index].NewChild(class'TextWindow'));
	WinPerkTitle[index].SetText(Caps(Perk.PerkName));
	WinPerkTitle[index].SetFont(Font'FontMenuSmall');
    WinPerkTitle[index].SetTextColor(colText);
    WinPerkTitle[index].SetTextMargins(6,4);
    winSkillIconP[index] = winActionButtons1[index].NewChild(Class'Window');
    winSkillIconP[index].SetPos(192, 0);
	winSkillIconP[index].SetSize(24, 24);
	winSkillIconP[index].SetBackgroundStyle(DSTY_Normal);
	winSkillIconP[index].SetBackground(PassedSkillIcon); // CHECK THIS LATER, TRASH!
    if (Perk.PerkValueDisplay == Delta_Percentage)
        SetText(sprintf(Perk.PerkDescription,int(Perk.PerkValue * 100 - 100)));
    else if (Perk.PerkValueDisplay == Percentage)
        SetText(sprintf(Perk.PerkDescription,int(Perk.PerkValue * 100)));
    else
        SetText(sprintf(Perk.PerkDescription,TextDisplayHack(Perk.PerkValue,3)));
    SetText("");
    if (skill != None)
        SetText(sprintf(PerkRequiredSkill,skill.SkillName,skill.GetLevelString(Perk.PerkLevelRequirement)));
    SetText(RequiredPoints $ Perk.PerkCost);
	winActionButtons[index] = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons[index].SetWidth(32); //149
	winActionButtons[index].FillAllSpace(false);
	buttonUpgrade[index] = PersonaActionButtonWindow(winActionButtons[index].NewChild(Class'PersonaActionButtonWindow'));
	buttonUpgrade[index].ButtonPerk = Perk;
    AddLine();

    UpdateButton(buttonUpgrade[index], Perk);
}

function UpdateButton(PersonaActionButtonWindow button, Perk P)
{
    if (P.bPerkObtained)
        button.SetButtonText(PurchasedButtonLabel);
    else if (P.IsPurchasable())
        button.SetButtonText(UpgradeButtonLabel);
    else
        button.SetButtonText(UnobtainableButtonLabel);

    button.SetSensitivity(P.IsPurchasable());

}

//////////////////////////////////////////////////
//  //Totalitarian: CreatePerkButtons
//////////////////////////////////////////////////
function CreatePerkButtons(Skill Skill)
{
    local int index;
	local DeusExPlayer player;
    local Perk currPerk;

    AddLine();
    SetText(PerkTitle);
    AddLine();

	player = DeusExPlayer(GetPlayerPawn());

    numPerkButtons = 0;
    currPerk = player.PerkManager.GetPerkForSkill(Skill.class,numPerkButtons);
    while (currPerk != None)
    {
        CreatePerkOverview(skill, currPerk, numPerkButtons);
        numPerkButtons++;
        currPerk = player.PerkManager.GetPerkForSkill(Skill.class,numPerkButtons);
    }

    /*
    SetText(ob $ ": " $ player.PerkManager.GetNumObtainedPerks());
    AddLine();
	
    for (index = 0; index < player.PerkManager.numPerks; index++)
    {
		if (player.PerkManager.PerkList[index].bPerkObtained == true)
			SetText(player.PerkManager.PerkList[index].PerkName);
    }
    */
}

//SARGE: Create general perk buttons
function CreateGeneralPerkButtons()
{
	local DeusExPlayer player;
    local Perk currPerk;

    Clear();
    SetTitle(GeneralPerksTitleText);
    AddLine();
    SetText(PerkTitle);
    AddLine();
	
    player = DeusExPlayer(GetPlayerPawn());

    numPerkButtons = 0;
    currPerk = player.PerkManager.GetGeneralPerk(numPerkButtons);
    while (currPerk != None)
    {
        CreatePerkOverview(None, currPerk, numPerkButtons);
        numPerkButtons++;
        currPerk = player.PerkManager.GetGeneralPerk(numPerkButtons);
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
    local bool boughtPerk;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;
	player = DeusExPlayer(GetPlayerPawn());

    topWin = DeusExRootWindow(GetRootWindow()).GetTopWindow();
	// Check if this is one of our Skills buttons
	/*if (buttonPressed.IsA('PersonaActionButtonWindow'))
	{
		SelectSkillButton(PersonaSkillButtonWindow(buttonPressed));
	}
	else
	{*/
	for (index = 0; index < numPerkButtons; index++)
	{
		if (buttonPressed == buttonUpgrade[index])
		{
            boughtPerk = true;
			player.PerkManager.PurchasePerk(buttonUpgrade[index].ButtonPerk.Class);
			buttonUpgrade[index].SetSensitivity(False);
            buttonUpgrade[index].SetButtonText(PurchasedButtonLabel);
			SetText(buttonUpgrade[index].ButtonPerk.PerkName);
			if ( TopWin!=None )
				TopWin.RefreshWindow( 0.0 );
		}
	}

    //SARGE: If we bought a perk, we need to update all the perk buttons in case we don't have enough
    //skill points left to buy them anymore
    if (boughtPerk)
    {
        for (index = 0; index < numPerkButtons; index++)
            UpdateButton(buttonUpgrade[index], buttonUpgrade[index].ButtonPerk);
    }

		switch(buttonPressed)
		{
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
     UpgradeButtonLabel="|&Purchase"
     PurchasedButtonLabel="|&Already Purchased"
     UnobtainableButtonLabel="|&Cannot Purchase"
     RequiredPoints="Points Needed: "
     PerkTitle="PERKS"
     ob="OBTAINED PERKS"
     msgAssign="Assign as secondary item:"
     msgConf="Assign"
     msgAssigned="Secondary Item Assigned"
     msgUnassigned="Secondary Item Unassigned"
     GeneralPerksTitleText="Perks - General"
     PerkRequiredSkill="Requires: %s: %s"
}
