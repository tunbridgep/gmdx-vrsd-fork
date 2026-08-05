//=============================================================================
// SARGE: A Generic scrolling window
// Based off the CustomizeKeys and Playthrough Modifiers (RSD) menus
//=============================================================================

class MenuScreenListWindow expands MenuUIScreenWindow;

var MenuUIListHeaderButtonWindow btnHeaderSetting;
var MenuUIListHeaderButtonWindow btnHeaderValue;

var Window ImageWindows[2];

var localized string strHeaderSettingLabel;
var localized string strHeaderValueLabel;

var MenuUIScrollAreaWindow winScroll;
var MenuUIListWindow lstItems;

var localized string disabledText;
var localized string enabledText;

var localized string confirmDefaultsTitle;
var localized string confirmDefaultsText;
var localized string currentValueText;

var Window messagebox;

var string consoleTarget;   //The entity we are changing variables on. This should normally be the player.
var string variable;        //The default value for variables. Usually is nothing
var string helpText;        //The default value for help text. Displayed if there's nothing defined for an entry.

var const int colWidths[2];

var bool bSortOrder;
var bool bLastPressedHeaderWasSetting;             //SARGE: If the last pressed header was the "Setting" header. Used to control if we should change the sort order.

var const bool bNoSort;                             //SARGE: If true, the contents of the list won't be sortable or sorted at all.

var const bool bShortHeaderButtons;                 //SARGE: The vanilla lists have a shortened header button on the right side to make both the header buttons equal length.

var const bool bShowDefaults;                       //SARGE: Shows "(Default: <Value>)" text in the help area when looking at an item in the list.
var localized string DefaultValueString;

Struct ObjectPos
{
    var int X;
    var int Y;
};

var const ObjectPos ScrollWindowPos;
var const ObjectPos ScrollWindowSize;
var const ObjectPos DescriptionPos;
var const ObjectPos DescriptionSize;
var const ObjectPos SearchPos;
var const ObjectPos SearchSize;

var const bool bHasHeaderButtons;
var const bool bHasImages;
var const bool bShowValueInHelp;
var const bool bShowNameInHelp;
var const bool bAltDefaultLocation; //Show the defaults right at the end, after the current value, on a new line, rather than at the end of the description text. Used by big list windows.

var int numItems;             //Recalculated every time we do a Refreshchoices
var bool bFocusedOnItemsList;   //Is our current focus on the list?

//SARGE: The help screen is busted, just use this one instead
var MenuUINormalLargeTextWindow winDesc;

//SARGE: Lets add a search bar, since these lists are getting LONG.
var localized string defaultSearchText;
var String filterString;
var MenuUIEditWindow         editSearch;
var const bool bAllowSearch;
var string lastSearch;
var string searchFilter;
var TextWindow winSearchText; //A window for a fake "Search..." text, since if we change the textbox, it steals focus from the list window.

var int lastSelected;

struct S_ListItem
{
	var localized string helpText;
	var localized string actionText;
	var localized Array<string> values;

    //dirty hack because I can't get arrays within structs to work in defaultproperties
    var localized string valueText0;
    var localized string valueText1;
    var localized string valueText2;
    var localized string valueText3;
    var localized string valueText4;
    var localized string valueText5;
    //dirty hack because I can't get arrays within structs to work in defaultproperties
    //These are appended to the help for the specific entry, so we can create "additive" help
    var localized string helpText0;
    var localized string helpText1;
    var localized string helpText2;
    var localized string helpText3;
    var localized string helpText4;
    var localized string helpText5;
	var string variable;
    var int value;
    var int defaultValue; //TODO: Find a way to reset to default value via console
    var string consoleTarget; //If not set, use the global one instead
    var string sortCategory;  //Will be prepended to the name in the third col, for sorting
    var string image1;         //Will be displayed in the first image box
    var string image2;         //Will be displayed in the second image box
    
    //The actual values that will be written to and from the config file.
    var float realValue0;
    var float realValue1;
    var float realValue2;
    var float realValue3;
    var float realValue4;
    var float realValue5;
};

var localized S_ListItem items[255];

event InitWindow()
{
	Super.InitWindow();
    LoadSettings();
    SetMouseFocusMode(MFocus_Click);
    CreateHeaderButtons();
    CreateSearchBar();
    CreateDescriptionWindow();
    CreateImageWindows();
    CreateChoices();
    ShowHelpString(-1);
}

function CreateDescriptionWindow()
{
    winDesc = MenuUINormalLargeTextWindow(winClient.NewChild(Class'MenuUINormalLargeTextWindow'));
    winDesc.SetPos(DescriptionPos.X, DescriptionPos.Y);
    winDesc.SetSize(DescriptionSize.X, DescriptionSize.Y);
    winDesc.SetTextAlignments(HALIGN_Left, VALIGN_Top);
    winDesc.SetTextMargins(4, 2);
    winDesc.SetText("");
    winDesc.SetWordWrap(true);
}

function CreateSearchBar()
{
    if (bAllowSearch)
    {
        winSearchText = TextWindow(winClient.NewChild(Class'TextWindow'));
        winSearchText.SetPos(SearchPos.X + 4,SearchPos.Y + 2);
        winSearchText.SetSize(SearchSize.X,SearchSize.Y);
        winSearchText.SetFont(player.FontManager.GetFont(TT_FontMenuSmall));
        winSearchText.SetTextColor(player.ThemeManager.GetCurrentMenuColorTheme().GetColorFromName('MenuColor_HelpText'));
        winSearchText.SetTextAlignments(HALIGN_Left, VALIGN_Center);
        winSearchText.SetText(defaultSearchText);

        editSearch = CreateMenuEditWindow(SearchPos.X, SearchPos.Y, SearchSize.X, SearchSize.Y, winClient);
        editSearch.SetFilter(filterString);
    }
}

function ShowDescription(string desc)
{
    winDesc.SetText(desc);
}

function CreateImageWindows()
{
    if (bHasImages)
    {
        ImageWindows[0] = NewChild(class'Window');
        ImageWindows[0].SetPos(224,64);
        
        ImageWindows[1] = NewChild(class'Window');
        ImageWindows[1].SetPos(420, 64);

        //ImageWindows[0].SetBackground(Texture'RSDCrap.UserInterface.SpecializationsComputersLarge');
        //ImageWindows[1].SetBackground(Texture'RSDCrap.UserInterface.SpecializationsComputersLarge');
    }
}

function UpdateImageWindows(int id)
{
    if (id == -1)
    {
        ImageWindows[0].SetBackground(None);
        ImageWindows[1].SetBackground(None);
    }
    else if (bHasImages)
    {
        ImageWindows[0].SetBackground(None);
        ImageWindows[1].SetBackground(None);
        
        if (items[id].image1 != "")
            ImageWindows[0].SetBackground(Texture(DynamicLoadObject("RSDCrap.UserInterface." $ items[id].image1, class'Texture')));
        if (items[id].image2 != "")
            ImageWindows[1].SetBackground(Texture(DynamicLoadObject("RSDCrap.UserInterface." $ items[id].image2, class'Texture')));
    }
}

function DrawWindow(GC gc)
{
    local string str;

    str = editSearch.GetText();

    if (lastSearch != str /*&& str != "" && str != defaultSearchText*/)
    {
        searchFilter = str;
        lastSearch = str;
        RefreshChoices();
    }
    super.DrawWindow(gc);
}

//Prevent esc-key crash.
event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
    if (GetFocusWindow() == editSearch)
    {
        //Esc and Enter to leave the window
        if (key == IK_Escape)
        {
            SetFocusWindow(lstItems);
            return true;
        }
    }
    //Ctrl-F to search
    else
    {
        if (IsKeyDown( IK_Ctrl ) && key == IK_F)
        {
            SetFocusWindow(editSearch);
            return true;
        }
    }
    return super.VirtualKeyPressed(key, bRepeat);
}

function CreateChoices()
{
	local int i;

    if (lstItems == None)
    {
        log("lstItems is none!");
	    CreateOptionsList();
    }

    // Loop through the Menu Choices and create the appropriate menu items
	for(i = 0; i < arrayCount(items); i++)
	{
		if (items[i].actionText != "")
		{
            //Set to use "Disabled" and "Enabled" by default if we didn't set custom text
            if (items[i].valueText0 == "")
                items[i].valueText0 = disabledText;
            if (items[i].valueText1 == "")
                items[i].valueText1 = enabledText;

            //set to use the global consoleTarget if one is not set
            if (items[i].consoleTarget == "")
                items[i].consoleTarget = consoleTarget;
            
            //set to use the global variable if one is not set
            if (items[i].variable == "")
                items[i].variable = variable;
            
            //set to use the global help text if one is not set
            if (items[i].helpText == "")
                items[i].helpText = helpText;

            //If the real values are all zero, then set them to the proper values
            if (items[i].realvalue0 == 0 && items[i].realValue1 == 0 && items[i].realValue2 == 0  && items[i].realValue3 == 0 && items[i].realValue4 == 0 && items[i].realValue5 == 0)
            {
                items[i].realValue1 = 1;
                items[i].realValue2 = 2;
                items[i].realValue3 = 3;
                items[i].realValue4 = 4;
                items[i].realValue5 = 5;
            }
            
            //lstItems.AddRow(items[i].actionText @ items[i].variable $ ";" $ GetValueString(i) $ ", " $ items[i].value);
        }
    }

    RefreshChoices();
}

function RefreshChoices()
{
	local int i;
    local string s1, s2, s3;
	
    lstItems.Hide(); //Stop spamming messages during draw.
    
    //Remove all existing choices
    lstItems.DeleteAllRows();
    numItems = 0;

    // Loop through the Menu Choices and create the appropriate menu items
	for(i = 0; i < arrayCount(items); i++)
    {
		if (items[i].actionText != "")
        {
            s1 = CAPS(items[i].actionText);
            s2 = CAPS(items[i].helpText);
            s3 = CAPS(searchFilter);
            //Log("searchFilter: " $ searchFilter @ items[i].actionText @ items[i].helpText @ InStr(items[i].actionText,searchFilter) @ InStr(items[i].helpText,searchFilter));
            if (searchFilter != "" && searchFilter != defaultSearchText && InStr(s1,s3) == -1 && InStr(s2,s3) == -1)
                continue;
                
            //Log("searchFilter: " $ searchFilter @ " - " @ items[i].actionText @ items[i].helpText);

            lstItems.AddRow(items[i].actionText $ ";" $ GetValueString(i) $ ";" $ i $ ";" $ items[i].sortCategory $ items[i].actionText);
            numItems++;
        }
    }
    
    searchFilter = "";
    lstItems.Show();
}

event FocusEnteredDescendant(Window enterWindow)
{
    //Clear the search bar if we enter it and it's at default
    if (enterWindow == editSearch && winSearchText != None)
        winSearchText.Hide();
}

event FocusLeftDescendant(Window leaveWindow)
{
    //Reset the search bar if we leave it and it's empty
    if (leaveWindow == editSearch && editSearch != None && winSearchText != None && editSearch.GetText() == "")
        winSearchText.Show();

    /*
    if (leaveWindow == lstItems)
        ArtificiallySelectIndex(lastSelected);
        */
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
    local int re;

    if (items[index].consoleTarget == "")
        return 0;

    command = player.ConsoleCommand("get " $ items[index].consoleTarget @ items[index].variable);

    //Sometimes it can return True and False, convert it to numeric
    if (command == "True")
        re =  1;
    else if (command == "False")
        re = 0;
    else
        re = int(command);
    

    //Now turn it into an actual value
    if (re == items[index].realValue0)
        re = 0;
    else if (re == items[index].realValue1)
        re = 1;
    else if (re == items[index].realValue2)
        re = 2;
    else if (re == items[index].realValue3)
        re = 3;
    else if (re == items[index].realValue4)
        re = 4;
    else if (re == items[index].realValue5)
        re = 5;

    return re;
}

function SetConsoleValue(int index, int value)
{
    if (items[index].consoleTarget == "")
        return;

    switch (value)
    {
        case 0: value = items[index].realValue0; break;
        case 1: value = items[index].realValue1; break;
        case 2: value = items[index].realValue2; break;
        case 3: value = items[index].realValue3; break;
        case 4: value = items[index].realValue4; break;
        case 5: value = items[index].realValue5; break;
    }

    player.ConsoleCommand("set " $ items[index].consoleTarget @ items[index].variable @ value);
}

function string GetValueString(int index)
{
    local S_ListItem item;
    item = items[index];

    //This hack is required because defaultproperties sucks
    switch(item.value)
    {
        case 0:
            return item.valueText0;
            break;
        case 1:
            return item.valueText1;
            break;
        case 2:
            return item.valueText2;
            break;
        case 3:
            return item.valueText3;
            break;
        case 4:
            return item.valueText4;
            break;
        case 5:
            return item.valueText5;
            break;
    }

    //Otherwise, just return the number
    //return string(item.value);
    return "";
}

function string GetDefaultString(int index)
{
    local S_ListItem item;
    local string def;
    
    if (!bShowDefaults)
        return "";

    item = items[index];

    switch (item.defaultValue)
    {
        case 0:
            def = item.valueText0;
            break;
        case 1:
            def = item.valueText1;
            break;
        case 2:
            def = item.valueText2;
            break;
        case 3:
            def = item.valueText3;
            break;
        case 4:
            def = item.valueText4;
            break;
        case 5:
            def = item.valueText5;
            break;
    }

    if (def == "")
        return "";

    return sprintf(DefaultValueString,def);

}

function string GetHelpString(int index)
{
    local S_ListItem item;
    item = items[index];

    //This hack is required because defaultproperties sucks
    switch(item.value)
    {
        case 0:
            return item.helpText0;
            break;
        case 1:
            return item.helpText1;
            break;
        case 2:
            return item.helpText2;
            break;
        case 3:
            return item.helpText3;
            break;
        case 4:
            return item.helpText4;
            break;
        case 5:
            return item.helpText5;
            break;
    }

    //Otherwise, just return nothing
    return "";
}

// ----------------------------------------------------------------------
// ResetToDefaults()
// ----------------------------------------------------------------------

function ResetToDefaults()
{
    messagebox = root.MessageBox(confirmDefaultsTitle,confirmDefaultsText,0,false,self);
}

function bool HandleResetMessagebox(Window msgBoxWindow, int buttonNumber)
{
	local int i, id;

    if (msgBoxWindow != messagebox)
        return true;

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
        SaveSettings();
        RefreshChoices();
        ShowHelpString(-1);
    }
}

//A bit of a dodgy hack.
function ShowHelpString(int id)
{
    local string help1, help2, help3, h;

    //Show the default help text if it's -1
    if (id == -1)
    {
        ShowDescription(helpText);
        return;
    }

    //This is a bit of a hack
    help1 = items[id].helpText;
    help2 = GetHelpString(id);
    if (!bAltDefaultLocation)
        help3 = GetDefaultString(id);
    
    if (help1 != "" && (help2 != "" || help3 != ""))
        help2 = " " $ help2;
    if (help2 != "" && help2 != " " && help3 != "")
        help3 = " " $ help3;

    h = (help1 $ help2 $ help3);

    if (bShowNameInHelp)
        h = items[id].actionText $ "|n|n" $ h;
    if (bShowValueInHelp)
        h = h $ "|n|n" $ CurrentValueText $ GetValueString(id);
    if (bShowDefaults && bAltDefaultLocation) //SARGE: Bit of a hack...
        h = h $ "|n" $ GetDefaultString(id);

    ShowDescription(h);
}

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
    return HandleResetMessagebox(msgBoxWindow,buttonNumber);
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
    
    id = int(lstItems.GetFieldValue(rowId, 2));

    items[id].value += 1;

    //Wrap around when we get to the end of the possible values
    if (GetValueString(id) == "")
        items[id].value = 0;

    SetConsoleValue(id,items[id].value);

    ShowHelpString(id);

    //Refresh List
    lstItems.SetField(rowId, 1, GetValueString(id));
    //RefreshChoices();

	return True;
}

// ----------------------------------------------------------------------
// CreateHeaderButtons()
// ----------------------------------------------------------------------

function CreateHeaderButtons()
{
    if (bHasHeaderButtons)
    {
        btnHeaderSetting   = CreateHeaderButton(10,  3, colWidths[0]-2, strHeaderSettingLabel,   winClient);

        if (!bAllowSearch)
        {
            if (bShortHeaderButtons)
                btnHeaderValue = CreateHeaderButton(colWidths[0]+11, 3, 157, strHeaderValueLabel, winClient);
            else
                btnHeaderValue = CreateHeaderButton(colWidths[0]+11, 3, 380-(colWidths[0]+26), strHeaderValueLabel, winClient);
        }

        //Header buttons are disabled if we can't sort.
        if (bNoSort)
        {
            btnHeaderSetting.SetSensitivity(False);
            if (!bAllowSearch)
                btnHeaderValue.SetSensitivity(False);
        }
    }
}

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	switch( buttonPressed )
	{
		case btnHeaderSetting:
            if (bLastPressedHeaderWasSetting)
                bSortOrder = !bSortOrder;
			lstItems.SetSortColumn(3, bSortOrder);
			lstItems.Sort();
            bLastPressedHeaderWasSetting = true;
			break;

		case btnHeaderValue:
            if (!bLastPressedHeaderWasSetting)
                bSortOrder = !bSortOrder;
			lstItems.SetSortColumn(1, bSortOrder);
			lstItems.Sort();
            bLastPressedHeaderWasSetting = false;
			break;

		default:
			bHandled = False;
			break;
	}

	return bHandled;
}


//Creates a list for the items to fill
function CreateOptionsList()
{
    winScroll = CreateScrollAreaWindow(winClient);

	winScroll.SetPos(ScrollWindowPos.X, ScrollWindowPos.Y);
	winScroll.SetSize(ScrollWindowSize.X, ScrollWindowSize.Y);

	lstItems = MenuUIListWindow(winScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	lstItems.EnableMultiSelect(False);
	lstItems.EnableAutoExpandColumns(False);
	lstItems.EnableHotKeys(False);

	lstItems.SetNumColumns(4);

	lstItems.SetColumnWidth(0, colWidths[0]);
	lstItems.SetColumnType(0, COLTYPE_String);
	lstItems.SetColumnWidth(1, colWidths[1]);
	lstItems.SetColumnType(1, COLTYPE_String);
    
    //Third Column is ID
	lstItems.SetColumnType(2, COLTYPE_Float);
	lstItems.HideColumn(2);

    //Fourth Column is for sorting
	lstItems.HideColumn(3);
	lstItems.SetColumnType(3, COLTYPE_String);
    if (!bNoSort)
    {
        lstItems.SetSortColumn(3, bSortOrder);
        lstItems.EnableAutoSort(True);
    }
    bLastPressedHeaderWasSetting = true;
}

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
	local bool bResult;
    local int rowIndex;

    if (lstItems.GetNumSelectedRows() == 0 || numSelections == 0)
        return true;

    bResult = Super.ListSelectionChanged(list, numSelections, focusRowId);
    rowIndex = int(lstItems.GetFieldValue(focusRowId, 2));
    
    lastSelected = focusRowId;
    
    ShowHelpString(rowIndex);
    UpdateImageWindows(rowIndex);
    
    return bResult;
}

/*
//Thanks to WCCC for this
function ArtificiallySelectIndex(int index)
{
    lstItems.SelectToRow(index);
    lstItems.SetFocusRow(index);
}
*/

function SaveSettings()
{
    Super.SaveSettings();
    player.SaveConfig();
}

//Add and Remove items
function AppendItem(S_ListItem newItem)
{
	local int i;
    //Add new item to first available slot
	for(i = 0; i < arrayCount(items); i++)
	{
		if (items[i].actionText == "")
            items[i] = newItem;
    }
}

//EDIT: Now takes a string, because things will move around in horrible ways otherwise
function RemoveItem(string variable)
{
	local int i,j;
    //Add new item to first available slot
	for(i = 0; i < arrayCount(items); i++)
    {
        if (items[i].actionText == "")
            return;

        if (items[i].variable == variable)
        {
            for(j = i; j < arrayCount(items) - 1; j++)
                items[j] = items[j+1];
            return;
        }
    }
}

defaultproperties
{
     strHeaderSettingLabel="Setting"
     strHeaderValueLabel="Value"
     ClientWidth=384
     ClientHeight=366
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuCustomizeKeysBackground_4'
     textureCols=2
     disabledText="Disabled"
     enabledText="Enabled"
     currentValueText="Current Value: "
     confirmDefaultsTitle="Reset to default settings?"
     confirmDefaultsText="Are you sure?|nThis action cannot be undone!"
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     consoleTarget="DeusExPlayer"
     colWidths(0)=164
     colWidths(1)=205
     bShortHeaderButtons=true
     DefaultValueString="(Default: %s)"
     ScrollWindowPos=(X=11,Y=23)
     ScrollWindowSize=(X=369,Y=268)
     DescriptionPos=(X=8,Y=310)
     DescriptionSize=(X=362,Y=200)
     //SearchPos=(X=0,Y=410)
     SearchPos=(X=174,Y=0)
     SearchSize=(X=160,Y=16)
     bHasHeaderButtons=true
     bHasImages=false
     bAllowSearch=true
     defaultSearchText="Search... (Ctrl-F)"
     filterString="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890:. "
     bTickEnabled=true
}
