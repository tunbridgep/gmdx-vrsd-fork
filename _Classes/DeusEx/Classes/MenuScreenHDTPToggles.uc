//=============================================================================
// MenuScreenHDTPToggles                                                        //RSD: Adapted from MenuScreenCustomizeKeys.uc so I can steal the scrolling window
//=============================================================================

class MenuScreenHDTPToggles expands MenuUIScreenWindow;

var MenuUIListHeaderButtonWindow btnHeaderAction;
var MenuUIListHeaderButtonWindow btnHeaderAssigned;
var MenuUIScrollAreaWindow		 winScroll;

var localized string			  NoneText;
var int					selection;

var localized string strHeaderActionLabel;
var localized string strHeaderAssignedLabel;
var localized string HelpText;
var localized string ReassignedFromLabel;

var string AssetClasses[22];                                                    //RSD: Asset Classes
var localized string AssetText[22];                                             //RSD: Asset Names
var int MenuValues[22];                                                         //RSD: What's the model setting (0 = vanilla, 1 = HDTP, 2 = Clyzm)
var int MaxMenuValues[22];                                                      //RSD: What's the max model setting possible (some assets have no HDTP or Clyzm model)
var int DefaultMenuValues[22];                                                  //RSD: What's the default model setting
var MenuUIListWindow lstAssets;
var localized string vanillaText;
var localized string HDTPText;
var localized string FOMODText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	Selection = -1;
	//BuildKeyBindings();
    BuildModelToggles();

	//CreateKeyList();
	CreateAssetList();
	CreateHeaderButtons();
	//PopulateKeyList();
	PopulateAssetList();
	ShowHelp(HelpText);
}

// ----------------------------------------------------------------------
// ListRowActivated()
//
// User double-clicked on one of the rows, meaning he/she/it wants
// to redefine one of the functions
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
	selection = lstAssets.RowIdToIndex(rowId);

    CycleModelType();

	return True;
}

// ----------------------------------------------------------------------
// BuildModelToggles()
// ----------------------------------------------------------------------

function BuildModelToggles()
{
	local int i, j, pos;
	//local class<actor> assetClass;

	for(i=0; i<arrayCount(MenuValues); i++)
	{
		if (class<DeusExWeapon>(DynamicLoadObject(AssetClasses[i],class'Class')) != none) //RSD: Error handling, make sure it's a valid DeusExWeapon class
        	MenuValues[i] = int(player.ConsoleCommand("get" @ AssetClasses[i] @ "iHDTPModelToggle"));
 	    else
 	    {
 	    	MenuValues[i] = -1;
log("MenuScreenHDTPToggles.uc Unrecognized DeusExWeapon Class Name:" @ AssetClasses[i]);
 	    }
//log(AssetClasses[i] $ ":" @ MenuValues[i]);
	}
}

// ----------------------------------------------------------------------
// CreateAssetList()
//
// Creates the listbox containing the asset toggles
// ----------------------------------------------------------------------

function CreateAssetList()
{
	winScroll = CreateScrollAreaWindow(winClient);

	winScroll.SetPos(11, 23);
	winScroll.SetSize(369, 268);

	lstAssets = MenuUIListWindow(winScroll.clipWindow.NewChild(Class'MenuUIListWindow'));
	lstAssets.EnableMultiSelect(False);
	lstAssets.EnableAutoExpandColumns(False);
	lstAssets.EnableHotKeys(False);

	lstAssets.SetNumColumns(2);

	lstAssets.SetColumnWidth(0, 164);
	lstAssets.SetColumnType(0, COLTYPE_String);
	lstAssets.SetColumnWidth(1, 205);
	lstAssets.SetColumnType(1, COLTYPE_String);
}

// ----------------------------------------------------------------------
// PopulateAssetList()
// ----------------------------------------------------------------------

function PopulateAssetList()
{
	local int assetIndex;
	local string assetName;

	// First erase the old list
	lstAssets.DeleteAllRows();

	for(assetIndex=0; assetIndex<arrayCount(assetClasses); assetIndex++ )
	{
    	if (class<DeusExWeapon>(DynamicLoadObject(AssetClasses[assetIndex],class'Class')) != none) //RSD: Error handling, make sure it's a valid DeusExWeapon class
    	{
			assetName = class<DeusExWeapon>(DynamicLoadObject(AssetClasses[assetIndex],class'Class')).default.ItemName;
			if (len(assetName) > 30)
				assetName = class<DeusExWeapon>(DynamicLoadObject(AssetClasses[assetIndex],class'Class')).default.abridgedName;
            lstAssets.AddRow(assetName $ ";" $ GetModelTypeDisplayText(assetIndex));
	    }
    	else
    		lstAssets.AddRow("ERROR! REPORT BUG" $ ";" $ GetModelTypeDisplayText(assetIndex));
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

function String GetModelTypeDisplayText(int assetIndex)
{
	switch (Menuvalues[assetIndex])
	{
		case 0:
			return vanillaText;
		case 1:
		    return HDTPText;
        case 2:
            return FOMODText;
    }
    return noneText;                                                            //RSD: Failsafe
}

// ----------------------------------------------------------------------
// RefreshAssetList()
// ----------------------------------------------------------------------

function RefreshAssetList()
{
	local int assetIndex;
	local int rowId;

	for(assetIndex=0; assetIndex<arrayCount(assetClasses); assetIndex++ )
	{
		rowId = lstAssets.IndexToRowId(assetIndex);
		lstAssets.SetField(rowId, 1, self.GetModelTypeDisplayText(assetIndex));
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
		if (class<DeusExWeapon>(DynamicLoadObject(AssetClasses[i],class'Class')) != none) //RSD: Error handling, make sure it's a valid DeusExWeapon class
        {
            MenuValues[i] = Min(DefaultMenuValues[i],MaxMenuValues[i]);         //RSD: Make sure defaults don't go past max allowed
        	player.ConsoleCommand("set" @ AssetClasses[i] @ "iHDTPModelToggle" @ MenuValues[i]);
//log(AssetClasses[i] @ "set to" @ MenuValues[i]);
		}
	}

	//BuildModelToggles();
	//PopulateAssetList();
	RefreshAssetList();
	UpdateModels();
}

function CycleModelType()
{
    if (class<DeusExWeapon>(DynamicLoadObject(AssetClasses[selection],class'Class')) != none) //RSD: Error handling, make sure it's a valid DeusExWeapon class
    {
        MenuValues[selection] = (MenuValues[selection]+1) % (MaxMenuValues[selection]+1); //RSD: Try to increment MenuValues, cycle around if we get past MaxMenuValues (hence +1)
        player.ConsoleCommand("set" @ AssetClasses[selection] @ "iHDTPModelToggle" @ MenuValues[selection]);
//log(AssetClasses[selection] @ "set to" @ MenuValues[selection]);
	}
 	else
log("Unrecognized Class Name:" @ AssetClasses[selection]);

    RefreshAssetList();
    UpdateModels();
}

function UpdateModels()
{
    player.HDTP();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     NoneText="[None]"
     strHeaderActionLabel="Weapon"
     strHeaderAssignedLabel="Model"
     HelpText="Select the model you wish to change and then press [Enter] or Double-Click to cycle through available models"
     AssetClasses(0)="DeusEx.WeaponAssaultGun"
     AssetClasses(1)="DeusEx.WeaponAssaultShotgun"
     AssetClasses(2)="DeusEx.WeaponBaton"
     AssetClasses(3)="DeusEx.WeaponCombatKnife"
     AssetClasses(4)="DeusEx.WeaponCrowbar"
     AssetClasses(5)="DeusEx.WeaponEMPGrenade"
     AssetClasses(6)="DeusEx.WeaponFlamethrower"
     AssetClasses(7)="DeusEx.WeaponGasGrenade"
     AssetClasses(8)="DeusEx.WeaponGEPGun"
     AssetClasses(9)="DeusEx.WeaponLAM"
     AssetClasses(10)="DeusEx.WeaponLAW"
     AssetClasses(11)="DeusEx.WeaponMiniCrossbow"
     AssetClasses(12)="DeusEx.WeaponNanoSword"
     AssetClasses(13)="DeusEx.WeaponNanoVirusGrenade"
     AssetClasses(14)="DeusEx.WeaponPepperGun"
     AssetClasses(15)="DeusEx.WeaponPistol"
     AssetClasses(16)="DeusEx.WeaponPlasmaRifle"
     AssetClasses(17)="DeusEx.WeaponProd"
     AssetClasses(18)="DeusEx.WeaponRifle"
     AssetClasses(19)="DeusEx.WeaponSawedOffShotgun"
     AssetClasses(20)="DeusEx.WeaponStealthPistol"
     AssetClasses(21)="DeusEx.WeaponSword"
     MaxMenuValues(0)=1
     MaxMenuValues(1)=1
     MaxMenuValues(2)=1
     MaxMenuValues(3)=1
     MaxMenuValues(4)=1
     MaxMenuValues(5)=1
     MaxMenuValues(6)=1
     MaxMenuValues(7)=1
     MaxMenuValues(8)=1
     MaxMenuValues(9)=1
     MaxMenuValues(10)=1
     MaxMenuValues(11)=1
     MaxMenuValues(12)=1
     MaxMenuValues(13)=1
     MaxMenuValues(14)=1
     MaxMenuValues(15)=1
     MaxMenuValues(16)=1
     MaxMenuValues(17)=1
     MaxMenuValues(18)=2
     MaxMenuValues(19)=2
     MaxMenuValues(20)=2
     MaxMenuValues(21)=1
     DefaultMenuValues(0)=1
     DefaultMenuValues(1)=1
     DefaultMenuValues(3)=1
     DefaultMenuValues(4)=1
     DefaultMenuValues(6)=1
     DefaultMenuValues(8)=1
     DefaultMenuValues(10)=1
     DefaultMenuValues(11)=1
     DefaultMenuValues(12)=1
     DefaultMenuValues(14)=1
     DefaultMenuValues(15)=1
     DefaultMenuValues(16)=1
     DefaultMenuValues(18)=1
     DefaultMenuValues(19)=2
     DefaultMenuValues(20)=1
     DefaultMenuValues(21)=1
     vanillaText="Vanilla"
     HDTPText="HDTP"
     FOMODText="FOMOD Beta"
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(1)=(Action=AB_Reset)
     Title="Item Model Options"
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
