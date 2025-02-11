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
var PersonaActionButtonWindow    buttonRemoveDecline[100];
var PersonaActionButtonWindow    buttonDecline;
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

var localized string msgDecline;
var localized string msgRemoveDecline;
var localized String DeclinedTitleLabel;
var localized String DeclinedDesc;
var localized String DeclinedDesc2;

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

	player = DeusExPlayer(GetPlayerPawn());
	PerkInManager = player.PerkManager.PerkList[player.PerkManager.GetPerkIndex(Perk)];
	PassedSkillIcon = PerkInManager.GetPerkIcon();

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
    SetText(Perk.PerkDescription);
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

    AddLine();
    SetText(PerkTitle);
    AddLine();

	player = DeusExPlayer(GetPlayerPawn());

    numPerkButtons = 0;

	for (index = 0; index < player.PerkManager.numPerks; index++)
	{
		if (player.PerkManager.PerkList[index].PerkSkill == Skill.class)
			CreatePerkOverview(player.PerkManager.PerkList[index], numPerkButtons++);
	}

    SetText(ob $ ": " $ player.PerkManager.GetNumObtainedPerks());
    AddLine();
	
    for (index = 0; index < player.PerkManager.numPerks; index++)
    {
		if (player.PerkManager.PerkList[index].bPerkObtained == true)
			SetText(player.PerkManager.PerkList[index].PerkName);
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
    local class<inventory> declineThis;

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
			buttonUpgrade[index].ButtonPerk.PurchasePerk();
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

            case buttonDecline:
                declineThis = class<Inventory>(DynamicLoadObject(buttonDecline.tags[0], class'Class', true));
                if (declineThis != None)
                    player.declinedItemsManager.AddDeclinedItem(declineThis);
                winActionButtonsSecondary.Hide();
                break;

			default:
				bHandled = False;
				break;
		}

        if (!bHandled)
        {
            //Handle the decline buttons separately
            for(i = 0; i < player.declinedItemsManager.GetDeclinedNumber();i++)
            {
                if (buttonPressed == buttonRemoveDecline[i])
                {
                    declineThis = class<Inventory>(DynamicLoadObject(buttonRemoveDecline[i].tags[0], class'Class', true));
                    if (declineThis != None)
                    {
                        player.declinedItemsManager.RemoveDeclinedItem(declineThis);
                        AddDeclinedInfoWindow();
                        return true;
                        //SignalRefresh();
                    }
                }
            }
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

function AddDeclineButton(class<Inventory> wep)
{
    if (wep != None)
    {
        //SetText(DeclinedDesc);
        winActionButtonsSecondary = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
        winActionButtonsSecondary.SetWidth(32); //149
        winActionButtonsSecondary.FillAllSpace(False);
        buttonDecline = PersonaActionButtonWindow(winActionButtonsSecondary.NewChild(Class'PersonaActionButtonWindow'));
        buttonDecline.SetButtonText(msgDecline);
        buttonDecline.tags[0] = string(wep);
        AddLine();
    }
}

// ----------------------------------------------------------------------
// SARGE: AddDeclinedInfoWindow()
// Based off the Ammo Info Window.
// ----------------------------------------------------------------------

function AddDeclinedInfoWindow()
{
	local AlignWindow winAmmo;
	local PersonaNormalTextWindow winText;
	local Window winIcon;
	local Class<Inventory> invClass;
    local int i, num;
    
    Clear();

    num = player.declinedItemsManager.GetDeclinedNumber();
    
    if (num == 0)
        return;

    SetTitle(DeclinedTitleLabel);
    if (player.bSmartDecline)
        SetText(DeclinedDesc2);
    else
        SetText(DeclinedDesc);
    AddLine();
    
    for(i = 0; i < ArrayCount(player.declinedItemsManager.declinedTypes);i++)
    {
        invClass = class<Inventory>(DynamicLoadObject(player.declinedItemsManager.declinedTypes[i], class'Class', true));
        if (invClass != None)
        {
            winAmmo = AlignWindow(winTile.NewChild(Class'AlignWindow'));
            winAmmo.SetChildVAlignment(VALIGN_Top);
            winAmmo.SetChildSpacing(4);

            // Add icon
            winIcon = winAmmo.NewChild(Class'Window');
            winIcon.SetBackground(invClass.default.Icon);
            winIcon.SetBackgroundStyle(DSTY_Masked);
            winIcon.SetSize(42, 37);
            
            // Add Item Name
            winText = PersonaNormalTextWindow(winAmmo.NewChild(Class'PersonaNormalTextWindow'));
            winText.SetWordWrap(False);
            winText.SetTextMargins(0, 0);
            winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
            winText.SetText(invClass.default.itemName);

            //Add "Remove From List" Button
            //winActionButtons = PersonaButtonBarWindow(winText.NewChild(Class'PersonaButtonBarWindow'));
            //winActionButtons.SetWidth(32); //149
            buttonRemoveDecline[i] = PersonaActionButtonWindow(winTile.NewChild(Class'PersonaActionButtonWindow'));
            //buttonUpgrade.SetWidth(32);
            buttonRemoveDecline[i].SetButtonText(msgRemoveDecline);
            buttonRemoveDecline[i].tags[0] = string(invClass);

            AddLine();
        }
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
     msgDecline="Add To Decline List"
     msgRemoveDecline="Remove From Decline List"
     DeclinedTitleLabel="Declined Items"
     DeclinedDesc="Declined Items will not be picked up."
     DeclinedDesc2="Declined Items will not be picked up, unless the Run/Walk key is held."
}
