//=============================================================================
// SARGE: A Generic scrolling window
// Based off the CustomizeKeys and Playthrough Modifiers (RSD) menus
//=============================================================================

class MenuScreenListWindow expands MenuUIScreenWindow;

var MenuUIListHeaderButtonWindow btnHeaderAction;
var MenuUIListHeaderButtonWindow btnHeaderAssigned;

var localized string strHeaderActionLabel;
var localized string strHeaderAssignedLabel;

var MenuUIScrollAreaWindow winScroll;
var MenuUIListWindow lstItems;

var localized string disabledText;
var localized string enabledText;

var localized string confirmDefaultsTitle;
var localized string confirmDefaultsText;

struct S_ListItem
{
	var localized string helpText;
	var localized string actionText;
	var localized string values[255];

    //dirty hack because I can't get arrays within structs to work in defaultproperties
    var localized string valueText1;
    var localized string valueText2;
    var localized string valueText3;
    var localized string valueText4;
    var localized string valueText5;
	var string variable;
    var int value;
    var int defaultValue; //TODO: Find a way to reset to default value via console
};

var S_ListItem items[255];

event InitWindow()
{
	Super.InitWindow();

    LoadSettings();
    CreateHeaderButtons();
	CreateOptionsList();
    CreateChoices();
}
     
function CreateChoices()
{
	local int i;
	
    //Remove all existing choices
    lstItems.DeleteAllRows();

    // Loop through the Menu Choices and create the appropriate menu items
	for(i = 0; i < arrayCount(items); i++)
	{
		if (items[i].actionText != "")
		{
            //Set to use "Disabled" and "Enabled" by default if we didn't set custom text
            if (items[i].valueText1 == "")
                items[i].valueText1 = disabledText;
            if (items[i].valueText2 == "")
                items[i].valueText2 = enabledText;

            lstItems.AddRow(items[i].actionText $ ";" $ GetValueString(i));
            //lstItems.AddRow(items[i].actionText @ items[i].variable $ ";" $ GetValueString(i) $ ", " $ items[i].value);
        }
    }
}

function LoadSettings()
{
    local int i;

	for(i=0; i < arrayCount(items); i++)
    {
		if (items[i].actionText != "")
            items[i].value = GetConsoleValue(i);
    }
		
}

function int GetConsoleValue(int index)
{
    local string command;
    command = player.ConsoleCommand("get DeusExPlayer" @ items[index].variable);
    if (command == "True")
        return 1;
    else if (command == "False")
        return 0;
    player.clientMessage(command);
    return int(command);
}

function SetConsoleValue(int index, int value)
{
    player.ConsoleCommand("set DeusExPlayer" @ items[index].variable @ value);
}

function string GetValueString(int index)
{
    local S_ListItem item;
    item = items[index];

    //This hack is required because defaultproperties sucks
    switch(item.value)
    {
        case 0:
            return item.valueText1;
            break;
        case 1:
            return item.valueText2;
            break;
        case 2:
            return item.valueText3;
            break;
        case 3:
            return item.valueText4;
            break;
        case 4:
            return item.valueText5;
            break;
    }

    //Otherwise, just return the number
    //return string(item.value);
    return "";
}

// ----------------------------------------------------------------------
// ResetToDefaults()
// ----------------------------------------------------------------------

function ResetToDefaults()
{
    root.MessageBox(confirmDefaultsTitle,confirmDefaultsText,0,false,self);

}

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
	local int i, id;

    // Destroy the msgbox!
    root.PopWindow();

    //confirmed
    if (buttonNumber == 0)
    {
        for(i = 0; i < arrayCount(items); i++)
        {
            if (items[i].actionText != "")
            {
                SetConsoleValue(i,items[i].defaultValue);
                //items[i].value = items[i].defaultValue;
            }
        }
        LoadSettings();
        CreateChoices();
    }
}

// ----------------------------------------------------------------------
// ListRowActivated()
//
// User double-clicked on one of the rows, meaning he/she/it wants
// to redefine one of the functions
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
    local int id;
    local S_ListItem choice;
	id = lstItems.RowIdToIndex(rowId);

    items[id].value += 1;

    //Wrap around when we get to the end of the possible values
    if (GetValueString(id) == "")
        items[id].value = 0;

    SetConsoleValue(id,items[id].value);

    //Refresh List
    lstItems.SetField(rowId, 1, GetValueString(id));
    //CreateChoices();

	return True;
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


//Creates a list for the items to fill
function CreateOptionsList()
{
    winScroll = CreateScrollAreaWindow(winClient);

	winScroll.SetPos(11, 23);
	winScroll.SetSize(369, 268);

	lstItems = MenuUIListWindow(winScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	lstItems.EnableMultiSelect(False);
	lstItems.EnableAutoExpandColumns(False);
	lstItems.EnableHotKeys(False);

	lstItems.SetNumColumns(2);

	lstItems.SetColumnWidth(0, 164);
	lstItems.SetColumnType(0, COLTYPE_String);
	lstItems.SetColumnWidth(1, 205);
	lstItems.SetColumnType(1, COLTYPE_String);
}

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	local bool bResult;
    local int rowId;
    local int rowIndex;

    bResult = Super.ListSelectionChanged(list, numSelections, focusRowId);

    rowId = lstItems.GetSelectedRow();
    rowIndex = lstItems.RowIdToIndex(rowId);
    ShowHelp(items[rowIndex].helpText);

    return bResult;
}


defaultproperties
{
     strHeaderActionLabel="Setting"
     strHeaderAssignedLabel="Value"
     ClientWidth=384
     ClientHeight=366
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_4'
     textureCols=2
     bHelpAlwaysOn=True
     helpPosY=312
     disabledText="Disabled"
     enabledText="Enabled"
     confirmDefaultsTitle="Reset to default settings?"
     confirmDefaultsText="Are you sure?|nThis action cannot be undone!"
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
}
