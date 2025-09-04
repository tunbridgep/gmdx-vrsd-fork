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
var PersonaActionButtonWindow    buttonAddRemoveLaser; //SARGE: Weapon mod buttons
var PersonaActionButtonWindow    buttonAddRemoveScope; //SARGE: Weapon mod buttons
var PersonaActionButtonWindow    buttonAddRemoveSilencer; //SARGE: Weapon mod buttons
var localized String UpgradeButtonLabel;
var localized String PurchasedButtonLabel;
var localized String UnobtainableButtonLabel;

var localized String LaserLabel;
var localized String ScopeLabel;
var localized String SilencerLabel;

var Inventory                    assignThis;                                    //RSD: Added
var DeusExWeapon                 modifyThis;                                    //SARGE: Added

var localized String PassedSkillName;
var localized string RequiredPoints;
var localized string ob;
var localized string msgAssign;                                                 //RSD: Added
var localized string msgAssigned;                                               //RSD: Added
var localized string msgDoAssign;
var localized string msgDoUnassign;
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
var PersonaButtonBarWindow winActionButtonsWeaponMods;
var PersonaActionButtonWindow buttonUpgrade[10];
var Window winSkillIconP[10];

//Perk Stuff
var localized String GeneralPerksTitleText;
var localized String PerkRequiredSkill;
var localized String PerkRequiredPoints;

//Decline Manager stuff
var localized string msgDecline;
var localized string msgRemoveDecline;
var localized String DeclinedTitleLabel;
var localized String DeclinedDesc;
var localized String DeclinedDesc2;

//Weapon Mod Penalties
var localized String AccuracyPenaltyLabel;
var localized String ReloadPenaltyLabel;
var localized String RecoilPenaltyLabel;
var localized String RangePenaltyLabel;
var localized String DamagePenaltyLabel;
var localized String AttachDetachLabel;
var localized String WeaponModEffectsLabel;

//Ygll new var
var string strDash;
var PersonaButtonBarWindow winActionButtonRemove;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	if(player.iAltFrobDisplay == 2)
		strDash = "+ ";
	else
		strDash = "";

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
	winTile.MakeWidthsEqual(true);
	winTile.MakeHeightsEqual(false);
	winTile.SetMargins(4, 1);
	winTile.SetMinorSpacing(0);
	winTile.SetWindowAlignments(HALIGN_Full, VALIGN_Top);
}

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

// ----------------------------------------------------------------------
// CreatePerkOverview()
// ----------------------------------------------------------------------
function CreatePerkOverview(Skill skill, Perk Perk, int index)	//Trash: Creates the description, upgrade button, etc for each perk
{
	local DeusExPlayer player;
	player = DeusExPlayer(GetPlayerPawn());

	PassedSkillIcon = Perk.GetPerkIcon();

	if(player.iAltFrobDisplay == 2) //Ygll: French LOVE their line :D
		AddLine();

	winActionButtons1[index] = PersonaButtonBarWindow(winTile.NewChild(class'PersonaButtonBarWindow'));
	winActionButtons1[index].SetWidth(0);
	winActionButtons1[index].SetHeight(28);
	winActionButtons1[index].FillAllSpace(false);
	WinPerkTitle[index] = TextWindow(winActionButtons1[index].NewChild(class'TextWindow'));
	WinPerkTitle[index].SetText(Caps(Perk.PerkName));
	WinPerkTitle[index].SetFont(Font'FontMenuSmall');
	WinPerkTitle[index].SetTextColor(colText);
	WinPerkTitle[index].SetTextMargins(6,4);
	winSkillIconP[index] = winActionButtons1[index].NewChild(class'Window');
	winSkillIconP[index].SetPos(191, 2);
	winSkillIconP[index].SetSize(24, 24);
	winSkillIconP[index].SetBackgroundStyle(DSTY_Normal);
	winSkillIconP[index].SetBackground(PassedSkillIcon);
	if(player.iAltFrobDisplay == 2) //Ygll: French LOVE their line :D
		AddLine();
		
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
	SetText("");
	winActionButtons[index] = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons[index].SetWidth(32); //149
	winActionButtons[index].FillAllSpace(false);
	buttonUpgrade[index] = PersonaActionButtonWindow(winActionButtons[index].NewChild(class'PersonaActionButtonWindow'));
	buttonUpgrade[index].ButtonPerk = Perk;
	UpdateButton(buttonUpgrade[index], Perk);
	AddLine();
}

function UpdateButton(PersonaActionButtonWindow button, Perk P)
{
	button.SetSensitivity(P.IsPurchasable());

    if (P.bPerkObtained)
        button.SetButtonText(PurchasedButtonLabel);
    else if (P.IsPurchasable())
        button.SetButtonText(UpgradeButtonLabel);
    else
        button.SetButtonText(UnobtainableButtonLabel);
}

function UpdateObtainedPerkList(DeusExPlayer player, string perkName)
{
	local int index, count;

	count = 0;

    for(index = 0; index < player.PerkManager.GetNumPerks(); index++)
    {
		if(player.PerkManager.GetPerkAtIndex(index).bPerkObtained)
			count++;

		if(count > 1) //don't need to check more obtained perk for the next step
			break;
    }

	if(count <= 1)
		CreateObtainedPerkList(player);
	else
		SetText(strDash $ Caps(perkName));
}

function CreateObtainedPerkList(DeusExPlayer player)
{
	local int index;
	local bool bSetTitle;

	bSetTitle = false;

    for (index = 0; index < player.PerkManager.GetNumPerks(); index++)
    {
		if (player.PerkManager.GetPerkAtIndex(index).bPerkObtained)
		{
			if(!bSetTitle)
			{
				SetText( CR() $ ob );
				AddLine();
				bSetTitle = true;
			}

			SetText(strDash $ Caps(player.PerkManager.GetPerkAtIndex(index).PerkName));
		}
    }

	if(bSetTitle)
		AddLine();
}

//////////////////////////////////////////////////
//  //Totalitarian: CreatePerkButtons
//////////////////////////////////////////////////
function CreatePerkButtons(Skill Skill)
{    
	local DeusExPlayer player;
    local Perk currPerk;

	player = DeusExPlayer(GetPlayerPawn());
	if(player != None)
	{
		numPerkButtons = 0;
		currPerk = player.PerkManager.GetPerkForSkill(Skill.class,numPerkButtons);

		while (currPerk != None)
		{
			CreatePerkOverview(skill, currPerk, numPerkButtons);
			numPerkButtons++;
			currPerk = player.PerkManager.GetPerkForSkill(Skill.class,numPerkButtons);
		}

		CreateObtainedPerkList(player);
	}
}

//SARGE: Create general perk buttons
function CreateGeneralPerkButtons()
{
	local DeusExPlayer player;
    local Perk currPerk;

	Clear();
	SetTitle(GeneralPerksTitleText);

    player = DeusExPlayer(GetPlayerPawn());
	if(player != None)
	{
		numPerkButtons = 0;
		currPerk = player.PerkManager.GetGeneralPerk(numPerkButtons);

		while (currPerk != None)
		{
			CreatePerkOverview(None, currPerk, numPerkButtons);
			numPerkButtons++;
			currPerk = player.PerkManager.GetGeneralPerk(numPerkButtons);
		}

		CreateObtainedPerkList(player);
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
    local DeusExBaseWindow TopWin;
    local DeusExWeapon W;
	local DeusExPlayer player;
    local int i, index;
    local bool boughtPerk;
    local class<Inventory> declineThis;

	if (Super.ButtonActivated(buttonPressed))
		return true;

	bHandled = true;
	player = DeusExPlayer(GetPlayerPawn());

    topWin = DeusExRootWindow(GetRootWindow()).GetTopWindow();

	for (index = 0; index < numPerkButtons; index++)
	{
		if (buttonPressed == buttonUpgrade[index])
		{
            boughtPerk = true;
			player.PerkManager.PurchasePerk(buttonUpgrade[index].ButtonPerk.Class);
			UpdateObtainedPerkList(player, buttonUpgrade[index].ButtonPerk.PerkName);
			if ( TopWin != None )
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
        //SARGE: Weapon addon toggles.
		case buttonAddRemoveSilencer:
            if (modifyThis != None)
            {
                modifyThis.ToggleAttachedSilencer(player.bRealUI || player.bHardcoreMode);
                modifyThis.UpdateInventoryInfo();
            }
            break;
		case buttonAddRemoveLaser:
            if (modifyThis != None)
            {
                modifyThis.ToggleAttachedLaser(player.bRealUI || player.bHardcoreMode);
                modifyThis.UpdateInventoryInfo();
            }
            break;
		case buttonAddRemoveScope:
            if (modifyThis != None)
            {
                modifyThis.ToggleAttachedScope(player.bRealUI || player.bHardcoreMode);
                modifyThis.UpdateInventoryInfo();
            }
            break;

		case buttonUpgradeSecond:
		   if (assignThis != None && player.GetSecondaryClass() == assignThis.class)
			   player.AssignSecondary(None);
		   else if (assignThis != None)
			   player.AssignSecondary(assignThis);

		   UpdateSecondaryButton(assignThis.class);
		   break;
		case buttonDecline:
			declineThis = class<Inventory>(DynamicLoadObject(buttonDecline.tags[0], class'Class', true));
			if (declineThis != None)
			{
				if (player.declinedItemsManager.IsDeclined(declineThis))
					player.declinedItemsManager.RemoveDeclinedItem(declineThis);
				else
					player.declinedItemsManager.AddDeclinedItem(declineThis);
				UpdateDeclineButton(declineThis);
			}
			break;		
		default:
			bHandled = false;
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

	if(winText == None)
		return None;

    if (bStylization)
    {
       winText.SetTextColorRGB(224,224,244);
       winText.SetVerticalSpacing(3);
       winText.SetFont(Font'Engine.SmallFont');
       winText.SetBackgroundStyle(DSTY_Masked);
       winText.SetBackground(Texture'GMDXSFX.UI.pedometerTex1');
    }
    else if (bStylization2)
    {
       winText.SetFont(Font'FontMenuSmall');
    }
    else if (bStylization3)
    {
       winText.SetTextColorRGB(224,224,244);
       winText.SetFont(Font'FontComputer8x20_B');
    }
    else
    {
       winText.SetFont(Font'FontMenuSmall');
       winText.SetBackground(None);
    }

	if (winScroll != None && ( bStylization || bStylization2 || bStylization3 ) )
	{
		winScroll.EnableScrolling(false,false);
		winScroll.EnableWindow(false);
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
	buttonUpgradeSecond = None;
	buttonDecline = None;
    buttonAddRemoveSilencer = None;
    buttonAddRemoveLaser = None;
    buttonAddRemoveScope = None;
	winTile.DestroyAllChildren();
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

	return true;
}

function AddSecondaryButton(Inventory wep)                                      //RSD: Extending secondary items to more than just weapons
{
	if (wep != None)
	{
		SetText(msgAssign);
		winActionButtonsSecondary = PersonaButtonBarWindow(winTile.NewChild(class'PersonaButtonBarWindow'));
		winActionButtonsSecondary.SetWidth(32); //149
		winActionButtonsSecondary.FillAllSpace(false);
		buttonUpgradeSecond = PersonaActionButtonWindow(winActionButtonsSecondary.NewChild(class'PersonaActionButtonWindow'));
		assignThis = wep;
		UpdateSecondaryButton(wep.class);
		AddLine();
	}
}

function UpdateSecondaryButton(class<Inventory> item)
{
    if (player.GetSecondaryClass() != item)
		buttonUpgradeSecond.SetButtonText(msgDoAssign);
	else
		buttonUpgradeSecond.SetButtonText(msgDoUnassign);
}

function UpdateDeclineButton(class<Inventory> wep)
{
    if (wep != None)
    {
        buttonDecline.tags[0] = string(wep);
        if (player.declinedItemsManager.IsDeclined(wep))
            buttonDecline.SetButtonText(msgRemoveDecline);
        else
            buttonDecline.SetButtonText(msgDecline);
    }
}

function AddDeclineButton(class<Inventory> wep)
{
    if (wep != None)
    {
        AddLine();
        winActionButtonsSecondary = PersonaButtonBarWindow(winTile.NewChild(class'PersonaButtonBarWindow'));
        winActionButtonsSecondary.SetWidth(32); //149
        winActionButtonsSecondary.FillAllSpace(false);
        buttonDecline = PersonaActionButtonWindow(winActionButtonsSecondary.NewChild(class'PersonaActionButtonWindow'));
        UpdateDeclineButton(wep);
        AddLine();
    }
}

function UpdateWeaponModButtons(DeusExWeapon weapon)
{
    local string str;

    if (weapon != None)
    {
        if (buttonAddRemoveLaser != None)
        {
            buttonAddRemoveLaser.SetButtonText(LaserLabel);
            buttonAddRemoveLaser.SetSensitivity(weapon.bHadLaser);
        }
        if (buttonAddRemoveScope != None)
        {
            buttonAddRemoveScope.SetButtonText(ScopeLabel);
            buttonAddRemoveScope.SetSensitivity(weapon.bHadScope);
            //buttonAddRemoveScope.SetSensitivity(true);
        }
        if (buttonAddRemoveSilencer != None)
        {
            buttonAddRemoveSilencer.SetButtonText(SilencerLabel);
            buttonAddRemoveSilencer.SetSensitivity(weapon.bHadSilencer);
        }
    }

}

//SARGE: Add buttons to attach and detach bulky weapon mods.
function AddWeaponModButtons(DeusExWeapon weapon)
{
	local DeusExPlayer player;
    local bool bDrawLaser, bDrawScope, bDrawSilencer;
	
    player = DeusExPlayer(GetPlayerPawn());

    //Don't do anything if we have the feature disabled.
    if (player != None && !player.bHardcoreMode && !player.bAddonDrawbacks)
        return;

    if (weapon != None)
    {
        modifyThis = weapon;

        bDrawLaser = weapon.bHadLaser;
        bDrawScope = weapon.bHadScope;
        bDrawSilencer = weapon.bHadSilencer;

        //Don't add the buttons if we don't have any valid mods
        if (!bDrawLaser && !bDrawSilencer && !bDrawScope)
            return;
    
        SetText(AttachDetachLabel);

        winActionButtonsWeaponMods = PersonaButtonBarWindow(winTile.NewChild(class'PersonaButtonBarWindow'));
        winActionButtonsWeaponMods.SetWidth(32); //149
        winActionButtonsWeaponMods.FillAllSpace(false);

        //Add mod buttons
        buttonAddRemoveLaser = PersonaActionButtonWindow(winActionButtonsWeaponMods.NewChild(class'PersonaActionButtonWindow'));
        buttonAddRemoveScope = PersonaActionButtonWindow(winActionButtonsWeaponMods.NewChild(class'PersonaActionButtonWindow'));
        buttonAddRemoveSilencer = PersonaActionButtonWindow(winActionButtonsWeaponMods.NewChild(class'PersonaActionButtonWindow'));
        UpdateWeaponModButtons(weapon);
    }
}

//Add some information about the drawbacks of the current mods
function AddWeaponModDrawbacks(DeusExWeapon weapon)
{
    local bool bDrawLaser, bDrawScope, bDrawSilencer;

    bDrawLaser = weapon.bHasLaser && weapon.bHadLaser && weapon.GetAddonPenalty(Laser) > 0.0;
    bDrawScope = weapon.bHasScope && weapon.bHadScope && weapon.GetAddonPenalty(Scope) > 0.0;
    bDrawSilencer = weapon.bHasSilencer && weapon.bHadSilencer && weapon.GetAddonPenalty(Silencer) > 0.0;

    if (!bDrawLaser && !bDrawSilencer && !bDrawScope)
        return;
        
    AddLine();
    SetText(WeaponModEffectsLabel $ "|n");
    if (bDrawLaser)
    {
        SetText(LaserLabel $ ":");
        SetText("  " $ RecoilPenaltyLabel $ ": +" $ weapon.FormatFloatString(weapon.GetAddonPenalty(Laser) * 100, 0.1) $ "%");
    }
    if (bDrawScope)
    {
        SetText(ScopeLabel $ ":");
        SetText("  " $ RecoilPenaltyLabel $ ": +" $ int(weapon.GetAddonPenalty(Scope) * 100) $ "%");
        SetText("  " $ ReloadPenaltyLabel $ ": +" $ weapon.FormatFloatString(weapon.GetAddonPenalty(Scope), 0.1) $ " sec");
    }
    if (bDrawSilencer)
    {
        SetText(SilencerLabel $ ":");
        SetText("  " $ AccuracyPenaltyLabel $ ": -" $ int(weapon.GetAddonPenalty(Silencer) * 100) $ "%");
        SetText("  " $ DamagePenaltyLabel $ ": -" $ int(weapon.GetAddonPenalty(Silencer) * 100) $ "%");
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
	local class<Inventory> invClass;
    local int i, num;

    Clear();

    num = player.declinedItemsManager.GetDeclinedNumber();

    if (num == 0)
        return;

	SetTitle(DeclinedTitleLabel);
	if(player.iAltFrobDisplay == 2) //Ygll: French LOVE their line :D
		AddLine();

	if (player.bSmartDecline)
		SetText(DeclinedDesc2);
	else
		SetText(DeclinedDesc);

	if(player.iAltFrobDisplay == 2) //Ygll: French LOVE their space
		SetText("");

	AddLine();

    for(i = 0; i < ArrayCount(player.declinedItemsManager.declinedTypes);i++)
    {
        invClass = class<Inventory>(DynamicLoadObject(player.declinedItemsManager.declinedTypes[i], class'Class', true));
        if (invClass != None)
        {
			if(player.iAltFrobDisplay == 2) //Ygll: French LOVE their line :D
				AddLine();

			winAmmo = AlignWindow(winTile.NewChild(Class'AlignWindow'));
			winAmmo.SetChildVAlignment(VALIGN_Top);
			winAmmo.SetChildSpacing(4);

			// Add icon
			winIcon = winAmmo.NewChild(Class'Window');
			winIcon.SetBackground(invClass.default.Icon);
			winIcon.SetBackgroundStyle(DSTY_Masked);

			//SARGE: Holy dirty hack batman!
			if (invClass == class'SoftwareNuke' || invClass == class'SoftwareStop')
				winIcon.SetBackgroundStretching(true);

			winIcon.SetSize(42, 37);
			// Add Item Name
			winText = PersonaNormalTextWindow(winAmmo.NewChild(Class'PersonaNormalTextWindow'));
			winText.SetWordWrap(False);
			winText.SetTextMargins(0, 0);
			winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
			winText.SetText(invClass.default.itemName);

			//Add "Remove From List" Button
			winActionButtonRemove = PersonaButtonBarWindow(winTile.NewChild(Class'PersonaButtonBarWindow'));
			winActionButtonRemove.SetWidth(32); //149
			winActionButtonRemove.FillAllSpace(false);
			buttonRemoveDecline[i] = PersonaActionButtonWindow(winActionButtonRemove.NewChild(Class'PersonaActionButtonWindow'));
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
     ob="OBTAINED PERKS"
     GeneralPerksTitleText="Perks - General"
     PerkRequiredSkill="Requires: %s: %s"
     msgDecline="Add To Decline List"
     msgRemoveDecline="Remove From Decline List"
     DeclinedTitleLabel="Declined Items"
     DeclinedDesc="Declined Items will not be picked up."
     DeclinedDesc2="Declined Items will not be picked up, unless the Run/Walk key is held."
     msgAssign="Assign as Secondary Item:"
     msgDoAssign="Assign"
     msgDoUnassign="Unassign"
     msgAssigned="Secondary Item Assigned"
     msgUnassigned="Secondary Item Unassigned"
     strDash=""
     LaserLabel="Laser"
     ScopeLabel="Scope"
     SilencerLabel="Silencer"
     AccuracyPenaltyLabel="Accuracy"
     ReloadPenaltyLabel="Reload Speed"
     RecoilPenaltyLabel="Recoil"
     RangePenaltyLabel="Range"
     DamagePenaltyLabel="Damage"
     AttachDetachLabel="Attach/Detach Weapon Mods:"
     WeaponModEffectsLabel="Some weapon mods provide negative effects:"
}
