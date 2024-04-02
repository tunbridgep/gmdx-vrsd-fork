//=============================================================================
// MenuScreenPlaythroughModifiers                                               //RSD: Adapted from MenuScreenCustomizeKeys.uc so I can steal the scrolling window
//=============================================================================

class MenuScreenPlaythroughModifiers expands MenuUIScreenWindow;

var MenuUIListHeaderButtonWindow btnHeaderAction;
var MenuUIListHeaderButtonWindow btnHeaderAssigned;
var MenuUIScrollAreaWindow		 winScroll;

var localized string			  NoneText;
var int					selection;

var localized string strHeaderActionLabel;
var localized string strHeaderAssignedLabel;
var localized string ReassignedFromLabel;

var string modifierBools[7];
var localized string modifierText[7];
var localized string modifierDesc[7];
var int MenuValues[7];
var MenuUIListWindow lstModifiers;
var localized string EnabledText;
var localized string DisabledText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	Selection = -1;

    BuildModifierList();
	CreateModifierList();
	CreateHeaderButtons();
	PopulateModifierList();

    if (Selection != -1)
		ShowHelp(modifierDesc[lstModifiers.RowIdToIndex(lstModifiers.GetSelectedRow())]);
}

// ----------------------------------------------------------------------
// ListRowActivated()
//
// User double-clicked on one of the rows, meaning he/she/it wants
// to redefine one of the functions
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	selection = lstModifiers.RowIdToIndex(rowId);

    //CycleModelType();
    CycleSetting();

	return True;
}

// ----------------------------------------------------------------------
// BuildModifierList()
// ----------------------------------------------------------------------

function BuildModifierList()
{
	local int i, j, pos;
	//local class<actor> assetClass;

	for(i=0; i<arrayCount(MenuValues); i++)
	{
		MenuValues[i] = int(bool(player.ConsoleCommand("get" @ "MenuScreenNewGame" @ modifierBools[i])));
//log(modifierBools[i] $ ":" @ MenuValues[i]);
	}
}

// ----------------------------------------------------------------------
// createModifierList()
//
// Creates the listbox containing the modifiers
// ----------------------------------------------------------------------

function createModifierList()
{
    winScroll = CreateScrollAreaWindow(winClient);

	winScroll.SetPos(11, 23);
	winScroll.SetSize(369, 268);

	lstModifiers = MenuUIListWindow(winScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	lstModifiers.EnableMultiSelect(False);
	lstModifiers.EnableAutoExpandColumns(False);
	lstModifiers.EnableHotKeys(False);

	lstModifiers.SetNumColumns(2);

	lstModifiers.SetColumnWidth(0, 164);
	lstModifiers.SetColumnType(0, COLTYPE_String);
	lstModifiers.SetColumnWidth(1, 205);
	lstModifiers.SetColumnType(1, COLTYPE_String);
}

// ----------------------------------------------------------------------
// PopulateModifierList()
// ----------------------------------------------------------------------

function PopulateModifierList()
{
	local int modIndex;
	local string modName;

	// First erase the old list
	lstModifiers.DeleteAllRows();

	for(modIndex=0; modIndex<arrayCount(modifierBools); modIndex++ )
	{
    	modName = self.modifierText[modIndex];
    	if (modName != "")
    	    lstModifiers.AddRow(modName $ ";" $ GetEnabledDisabledDisplayText(modIndex));
    	else
    		lstModifiers.AddRow("ERROR! REPORT BUG" $ ";" $ GetEnabledDisabledDisplayText(modIndex));
	}
}

// ----------------------------------------------------------------------
// CreateHeaderButtons()
// ----------------------------------------------------------------------

function CreateHeaderButtons()
{
	btnHeaderAction   = CreateHeaderButton(10,  3, 162, strHeaderActionLabel,   winClient);
	btnHeaderAssigned = CreateHeaderButton(175, 3, 157, strHeaderAssignedLabel, winClient);

	btnHeaderAction.SetSensitivity(False);
	btnHeaderAssigned.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// GetModelTypeDisplayText()
// ----------------------------------------------------------------------

function String GetEnabledDisabledDisplayText(int modIndex)
{
	switch (Menuvalues[modIndex])
	{
		case 0:
			return disabledText;
		case 1:
		    return enabledText;
    }
}

// ----------------------------------------------------------------------
// RefreshModifierList()
// ----------------------------------------------------------------------

function RefreshModifierList()
{
	local int modIndex;
	local int rowId;

	for(modIndex=0; modIndex<arrayCount(modifierBools); modIndex++ )
	{
		rowId = lstModifiers.IndexToRowId(modIndex);
		lstModifiers.SetField(rowId, 1, self.GetEnabledDisabledDisplayText(modIndex));
	}
}

// ----------------------------------------------------------------------
// ResetToDefaults()
// ----------------------------------------------------------------------

function ResetToDefaults()
{
	local int i, j, pos;

	Selection = -1;

	for(i=0; i<arrayCount(MenuValues); i++)
	{
		MenuValues[i] = 0;
        player.ConsoleCommand("set" @ "MenuScreenNewGame" @ modifierBools[i] @ bool(MenuValues[i]));
log(modifierBools[i] @ "set to" @ MenuValues[i]);
	}

	RefreshModifierList();
}

function CycleSetting()
{
    MenuValues[selection] = int(!bool(MenuValues[selection]));
    player.ConsoleCommand("set" @ "MenuScreenNewGame" @ modifierBools[selection] @ bool(MenuValues[selection]));
log("set" @ player.Class @ modifierBools[selection] @ bool(MenuValues[selection]));
log(modifierBools[selection] @ "set to" @ bool(MenuValues[selection]));

    RefreshModifierList();
    //UpdateModels();
}

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	local bool bResult;
    local int rowId;
    local int rowIndex;

    bResult = Super.ListSelectionChanged(list, numSelections, focusRowId);

    rowId = lstModifiers.GetSelectedRow();
    rowIndex = lstModifiers.RowIdToIndex(rowId);
    ShowHelp(modifierDesc[rowIndex]);

    return bResult;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NoneText="[None]"
     strHeaderActionLabel="Modifier"
     strHeaderAssignedLabel="Setting"
     modifierBools(0)="bRandomizeCrates"
     modifierBools(1)="bRandomizeMods"
     modifierBools(2)="bRandomizeAugs"
     modifierBools(3)="bRandomizeEnemies"
     modifierBools(4)="bAddictionSystem"
     modifierBools(5)="bRestrictedSaving"
     modifierBools(6)="bNoKeypadCheese"
     modifierText(0)="Crate Randomization"
     modifierText(1)="Weapon Mod Randomization"
     modifierText(2)="Aug Canister Shuffle"
     modifierText(3)="Enemy Weapon Shuffle"
     modifierText(4)="Addiction System"
     modifierText(5)="Restricted Saving"
     modifierText(6)="Undiscovered Codes"
     modifierDesc(0)="Randomizes crate contents. Items are swapped for other items of the same class (e.g. 10mm ammo for steel darts) based on in-game item distribution."
     modifierDesc(1)="Randomizes weapon mods. Mods are swapped for related types (e.g. accuracy for range) based on in-game item distribution."
     modifierDesc(2)="Shuffles the order of aug canisters in the game. Total number of each aug canister type is unchanged."
     modifierDesc(3)="Equipped weapons will be swapped randomly between hostile enemies. Total number of weapons remains the same."
     modifierDesc(4)="Replaces drug effects with temporary buffs on use and debuffs on withdrawal. Addiction accumulates with use and depreciates through play."
     modifierDesc(5)="Prevents manually saving and adds single-use save points to the level. Autosaves still occur as normal."
     modifierDesc(6)="Prevents using keypads and logins unless you have them in your notes."
     EnabledText="Enabled"
     DisabledText="Disabled"
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(1)=(Action=AB_Reset)
     Title="Playthrough Modifiers"
     ClientWidth=384
     ClientHeight=366
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_4'
     textureCols=2
     bHelpAlwaysOn=True
     helpPosY=312
}
