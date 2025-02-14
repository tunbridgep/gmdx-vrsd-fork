//=============================================================================
// PersonaScreenAugmentations
//=============================================================================

class PersonaScreenAugmentations extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow			btnActivate;
var PersonaActionButtonWindow			btnUpgrade;
var PersonaActionButtonWindow			btnUseCell;
var PersonaInfoWindow					winInfo;
var PersonaAugmentationBodyWindow		winBody;
var PersonaAugmentationOverlaysWindow	winOverlays;
var PersonaItemDetailWindow             winBioCells;
var PersonaItemDetailWindow             winAugCans;
var ProgressBarWindow					winBioEnergy;
var TextWindow                          winBioEnergyText;

// Currently selected button, either a skill or augmentation
var Augmentation      selectedAug;
var PersonaItemButton selectedAugButton;

struct AugLoc_S
{
	var int x;
	var int y;
};

var AugLoc_S augLocs[7];
var PersonaAugmentationItemButton augItems[13];                                 //RSD: We have 13 slots now
var Texture                       augHighlightTextures[6], AugHighlightTexturesFemale[6]; //LDDP, 10/28/21: Load these during InitWindow, please.
var Window                        augHighlightWindows[6];

var int augSlotSpacingX;
var int augSlotSpacingY;

var Color colBarBack;

var localized String AugmentationsTitleText;
var localized String UpgradeButtonLabel;
var localized String ActivateButtonLabel;
var localized String DeactivateButtonLabel;
var localized String UseCellButtonLabel;
var localized String AugCanUseText;
var localized String BioCellUseText;

var Localized string AugLocationDefault;
var Localized string AugLocationCranial;
var Localized string AugLocationEyes;
var Localized string AugLocationArms;
var Localized string AugLocationLegs;
var Localized string AugLocationTorso;
var Localized string AugLocationSubdermal;

var bool augButtonPressed;
var bool bAllIconsReset;
var bool bSwitchFluctuation;
var float fluctuate;
var int randCap;
var int randCap2;
var PersonaActionButtonWindow btnAugStats;
var PersonaActionButtonWindow btnDeactivateAll;
var ProgressBarWindow winBar;
var ProgressBarWindow winBar2;
var ProgressBarWindow winBar3;
var ProgressBarWindow winBar4;
var PersonaNormalTextWindow winLabelGlobal;
var Localized string titString;
var Localized string BioString;
var Localized string curBioString;
var Localized string augTimeRem;
var Localized string AugsString;
var Localized string btnAugStatusLabel;
var Localized string btnDeactAll;
var Localized string circuitLabel;
var Localized string overviewLabel;
var Localized string activeLabel;
var Localized string passiveLabel;
var Localized string automaticLabel;
var Localized string toggleLabel;

var Localized string BarString;
var Localized string BarStringRes;

//SARGE: UnrealScript sucks and doesn't let us access enums from other classes
enum EAugmentationType
{
    Aug_Passive,
    Aug_Active,
    Aug_Automatic,
    Aug_Toggle
};

//LDDP, 10/28/21: Store this assessment for later.
var bool bFemale;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
    local int i;
	local Texture TTex; 

	Super.InitWindow();

	//LDDP
	for (i=0; i<ArrayCount(AugHighlightTextures); i++)
	{
		AugHighlightTexturesFemale[i] = AugHighlightTextures[i];
	}
	
	TTex = Texture(DynamicLoadObject("FemJC.AugmentationsLocationCerebralFem", class'Texture', false));
	if (TTex != None) AugHighlightTexturesFemale[0] = TTex;
	TTex = Texture(DynamicLoadObject("FemJC.AugmentationsLocationEyesFem", class'Texture', false));
	if (TTex != None) AugHighlightTexturesFemale[1] = TTex;
	TTex = Texture(DynamicLoadObject("FemJC.AugmentationsLocationTorsoFem", class'Texture', false));
	if (TTex != None) AugHighlightTexturesFemale[2] = TTex;
	TTex = Texture(DynamicLoadObject("FemJC.AugmentationsLocationArmsFem", class'Texture', false));
	if (TTex != None) AugHighlightTexturesFemale[3] = TTex;
	TTex = Texture(DynamicLoadObject("FemJC.AugmentationsLocationLegsFem", class'Texture', false));
	if (TTex != None) AugHighlightTexturesFemale[4] = TTex;
	TTex = Texture(DynamicLoadObject("FemJC.AugmentationsLocationSubdermalFem", class'Texture', false));
	if (TTex != None) AugHighlightTexturesFemale[5] = TTex;

	EnableButtons();

	PlaySound(Sound'GMDXSFX.Generic.biomodscreenselect',0.5);

	//if (player.bRealUI || player.bHardCoreMode)
	   bTickEnabled = True;
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	local DeusExPlayer DXP;
	
	Super.CreateControls();
	
    //LDDP
	DXP = DeusExPlayer(GetPlayerPawn());
	if ((DXP != None) && (DXP.FlagBase != None) && (DXP.FlagBase.GetBool('LDDPJCIsFemale')))
	{
		bFemale = true;
	}

	CreateTitleWindow(9, 5, AugmentationsTitleText);
	CreateInfoWindow();
	CreateButtons();
	CreateAugmentationLabels();
	CreateAugmentationHighlights();
	CreateAugmentationButtons();
	CreateOverlaysWindow();
	CreateBodyWindow();
	CreateBioCellBar();
	CreateAugCanWindow();
	CreateBioCellWindow();
	CreateStatusWindow();

	PersonaNavBarWindow(winNavBar).btnAugs.SetSensitivity(False);
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(348, 240);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

    winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(13, 407);
	winActionButtons.SetWidth(299);
	winActionButtons.FillAllSpace(true);

	btnAugStats = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
    btnAugStats.SetButtonText(btnAugStatusLabel);

    btnDeactivateAll = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
    btnDeactivateAll.SetButtonText(btnDeactAll);

	btnUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUpgrade.SetButtonText(UpgradeButtonLabel);

	btnActivate = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnActivate.SetButtonText(ActivateButtonLabel);

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(346, 387);
	winActionButtons.SetWidth(97);
	winActionButtons.FillAllSpace(False);

	btnUseCell = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUseCell.SetButtonText(UseCellButtonLabel);
}

// ----------------------------------------------------------------------
// CreateBodyWindow()
// ----------------------------------------------------------------------

function CreateBodyWindow()
{
	winBody = PersonaAugmentationBodyWindow(winClient.NewChild(Class'PersonaAugmentationBodyWindow'));
	winBody.SetPos(72, 28);
	winBody.Lower();
}

// ----------------------------------------------------------------------
// CreateOverlaysWindow()
// ----------------------------------------------------------------------

function CreateOverlaysWindow()
{
	winOverlays = PersonaAugmentationOverlaysWindow(winClient.NewChild(Class'PersonaAugmentationOverlaysWindow'));
	winOverlays.SetPos(72, 28);
	winOverlays.Lower();
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	local int timeRem;
	local float maxEnergy, actualMaxEnergy;

	winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winInfo.SetPos(348, 14);
	winInfo.SetSize(238, 218);

    if (player.bShowAugStatus)
    {
    if (!augButtonPressed && !winInfo.bMedBotCall)
    {
    winClient.SetClientTexture(1,Texture'GMDXSFX.UI.AugInterface2');
    //winClient.SetClientTexture(2,Texture'GMDXSFX.UI.AugInterface3');
    winInfo.bStylization2 = True;
	winInfo.SetTitle(" " $ titString);
	winInfo.AddLine();
    winInfo.SetText(" " $ overviewLabel);
    winInfo.AddLine();
	winInfo.SetText(" " $ AugsString $ string(GetAugCount()));
	winInfo.SetText(" " $ activeLabel @ GetAugsByType(Aug_Active));
	winInfo.SetText(" " $ passiveLabel @ GetAugsByType(Aug_Passive));
	winInfo.SetText(" " $ automaticLabel @ GetAugsByType(Aug_Automatic));
	winInfo.SetText(" " $ toggleLabel @ GetAugsByType(Aug_Toggle));
	//winInfo.bStylization2 = False;
    //winInfo.bStylization3 = True;
    winInfo.AddLine();
    winInfo.SetText(" " $ circuitLabel);
    winInfo.AddLine();
    //winInfo.SetText("          " $ "Circuit Activity");
	maxEnergy = player.GetMaxEnergy();
	actualMaxEnergy = player.GetMaxEnergy(true);
	if (maxEnergy != actualMaxEnergy)
		winInfo.SetText(" " $ BioString $ int(player.Energy) $ "/" $ int(maxEnergy) $ "(" $ int(actualMaxEnergy - maxEnergy) $ " Reserved )" $ CR());
	else
		winInfo.SetText(" " $ BioString $ int(player.Energy) $ "/" $ int(maxEnergy) $ CR());
	timeRem = player.AugmentationSystem.CalcEnergyUse(0.06*1000);
    winInfo.AppendText(Sprintf(curBioString, timeRem));
    if (timeRem != 0 && player.Energy != 0)
    {
        timeRem = (player.Energy * 60) / timeRem;
     	winInfo.SetText(" " $ AugTimeRem @ timeRem $ "s");
    }
    else
    {
        winInfo.SetText(" " $ AugTimeRem @ "0" $ "s");
    }
    //CreateWinBars();
    //winLabelGlobal = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
	//winLabelGlobal.SetPos(401, 95);
	//winLabelGlobal.SetSize(112, 11);//(52, 11);
	//winLabelGlobal.SetText(circuitLabel);
	//winLabelGlobal.SetTextMargins(2, 1);
	}
	else
    {
	   winClient.SetClientTexture(1,Texture'DeusExUI.UserInterface.AugmentationsBackground_2');
	   //winClient.SetClientTexture(2,Texture'DeusExUI.UserInterface.AugmentationsBackground_3');
    }
	}
	else
	{
	   winClient.SetClientTexture(1,Texture'DeusExUI.UserInterface.AugmentationsBackground_2');
	   //winClient.SetClientTexture(2,Texture'DeusExUI.UserInterface.AugmentationsBackground_3');
    }
}

function Tick(float deltaTime)
{
local int timeRem;

  UpdateBioEnergyBar();

  //CyberP: Update the status bar
  if (player.bShowAugStatus)
  {
    if (!augButtonPressed && !winInfo.bMedBotCall)
    {
    winInfo.bStylization2 = True;
	winInfo.SetTitle(" " $ titString);
    winInfo.AddLine();
    winInfo.SetText(" " $ overviewLabel);
    winInfo.AddLine();
	winInfo.SetText(" " $ AugsString $ string(GetAugCount()));
	winInfo.SetText(" " $ activeLabel @ GetAugsByType(Aug_Active));
	winInfo.SetText(" " $ passiveLabel @ GetAugsByType(Aug_Passive));
	winInfo.SetText(" " $ automaticLabel @ GetAugsByType(Aug_Automatic));
	winInfo.SetText(" " $ toggleLabel @ GetAugsByType(Aug_Toggle));
	//winInfo.bStylization2 = False;
    //winInfo.bStylization3 = True;
    winInfo.AddLine();
    winInfo.SetText(" " $ circuitLabel);
    winInfo.AddLine();
	winInfo.SetText(" " $ BioString $ int(player.Energy) $ "/" $ int(player.GetMaxEnergy()) $ CR());
	timeRem = player.AugmentationSystem.CalcEnergyUse(0.06*1000);
    winInfo.AppendText(Sprintf(curBioString, timeRem));
    if (timeRem != 0 && player.Energy != 0)
    {
        timeRem = (player.Energy * 60) / timeRem;
     	winInfo.SetText(" " $ AugTimeRem @ timeRem $ "s");
    }
    else
    {
        winInfo.SetText(" " $ AugTimeRem @ "0" $ "s");
    }

    if (winBar != None && winBar2 != None && winBar3 != None && winBar4 != None)
    {
    if (!bSwitchFluctuation)
    {
        fluctuate += deltaTime*45;
        if (fluctuate > 70 + randCap)
        {
           bSwitchFluctuation = True;
           if (randCap != 0)
           randCap = 0;
        }
        else if (fluctuate > 60)
           fluctuate += deltaTime*18;
        else if (randCap > 25)
        {
           if (fluctuate > 30 && fluctuate > 55)
               fluctuate -= deltaTime*30;
        }
        if (bSwitchFluctuation)
           randCap = FRand()*30;
    }
    else
    {
        fluctuate -= deltaTime*45;
        if (fluctuate < 50 - randCap2)
        {
           bSwitchFluctuation = False;
           if (randCap2 != 0)
              randCap2 = 0;
        }
        else if (fluctuate < 70 && fluctuate > 60)
            fluctuate -= deltaTime*16;
        else if (randCap > 25)
        {
          if (fluctuate < 40 && fluctuate > 30)
            fluctuate -= deltaTime*26;
        }
        if (!bSwitchFluctuation)
           randCap2 = 10 + FRand()*40;
    }
        winBar.SetCurrentValue((99+FRand())-player.Energy);
        winBar2.SetCurrentValue(10+ FRand()*3);
        winBar3.SetCurrentValue(fluctuate);
        winBar4.SetCurrentValue(player.AugmentationSystem.CalcEnergyUse(0.06*1000));
    }
	}
  }

  //CyberP: reset the damn icons
  if (selectedAug != None)
  {
     if (selectedAug.CanBeActivated())
        if (PersonaAugmentationItemButton(selectedAugButton) != None)
           PersonaAugmentationItemButton(selectedAugButton).SetActive(selectedAug);
  }
  if (player.Energy == 0 && !bAllIconsReset)
  {
    bAllIconsReset = True;
    RefreshAugmentationButtons();
  }
}

function int GetAugCount()
{
	local Augmentation anAug;
	local int augCount;

	anAug = player.AugmentationSystem.FirstAug;
	while(anAug != None)
	{
		if (( anAug.AugmentationName != "" ) && ( anAug.bHasIt ))
		{
			augCount++;
		}

		anAug = anAug.next;
	}
	return augCount;
}

function int GetAugsByType(EAugmentationType augType)
{
	local Augmentation anAug;
	local int augCount;

	anAug = player.AugmentationSystem.FirstAug;
	while(anAug != None)
	{
		if (anAug.AugmentationName != ""  && anAug.AugmentationType == augType && anAug.bHasIt)
		{
            augCount++;
		}

		anAug = anAug.next;
	}
	return augCount;
}

function RefreshAugmentationButtons()
{
	local Augmentation anAug;
	local int augCount;

	anAug = player.AugmentationSystem.FirstAug;
	while(anAug != None)
	{
		if (( anAug.AugmentationName != "" ) && ( anAug.bHasIt ))
		{
			augItems[augCount].SetActive(anAug);
			augCount++;
		}

		anAug = anAug.next;
	}
}

function CreateWinBars()
{
  	winBar = ProgressBarWindow(winClient.NewChild(Class'ProgressBarWindow'));
    winBar2 = ProgressBarWindow(winClient.NewChild(Class'ProgressBarWindow'));
    winBar3 = ProgressBarWindow(winClient.NewChild(Class'ProgressBarWindow'));
    winBar4 = ProgressBarWindow(winClient.NewChild(Class'ProgressBarWindow'));

    //winBar.bSpecialFX2 = True;
    winBar.SetPos(374, 172);
	winBar.SetSize(76, 7);
	winBar.SetValues(0, 100);
	winBar.SetVertical(False);
	winBar.SetDrawBackground(True);
    winbar.UseScaledColor(True);
    winBar.SetScaleColorModifier(0.5);
    winBar.SetBackColor(colBarBack);

    //winBar2.bSpecialFX2 = True;
	winBar2.SetPos(374, 184);
	winBar2.SetSize(76, 7);
	winBar2.SetValues(0, 100);
    winBar2.SetVertical(False);
	winBar2.SetDrawBackground(True);
	winBar2.UseScaledColor(True);
	winBar2.SetScaleColorModifier(0.5);
	winBar2.SetBackColor(colBarBack);

    //winBar3.bSpecialFX2 = True;
	winBar3.SetPos(374, 196);
	winBar3.SetSize(76, 7);
	winBar3.SetValues(0, 100);
    winBar3.SetVertical(False);
	winBar3.SetDrawBackground(True);
	winBar3.UseScaledColor(True);
	winBar3.SetScaleColorModifier(0.5);
	winBar3.SetBackColor(colBarBack);

    //winBar4.bSpecialFX2 = True;
	winBar4.SetPos(374, 208);
	winBar4.SetSize(76, 7);
	winBar4.SetValues(0, 100);
    winBar4.SetVertical(False);
	winBar4.SetDrawBackground(True);
	winBar4.UseScaledColor(True);
	winBar4.SetScaleColorModifier(0.5);
	winBar4.SetBackColor(colBarBack);
}
// ----------------------------------------------------------------------
// CreateAugmentationLabels()
// ----------------------------------------------------------------------

function CreateAugmentationLabels()
{
	CreateLabel( 84,  25, AugLocationCranial);    //CreateLabel( 57,  27, AugLocationCranial);
	CreateLabel(212,  27, AugLocationEyes);
	CreateLabel( 19, 33, AugLocationArms);  //CreateLabel( 19, 103, AugLocationArms);
	CreateLabel( 19, 187, AugLocationSubdermal);
	CreateLabel(247, 109, AugLocationTorso);
	CreateLabel( 19, 330, AugLocationDefault);
	CreateLabel(247, 311, AugLocationLegs);
}

// ----------------------------------------------------------------------
// CreateLabel()
// ----------------------------------------------------------------------

function CreateLabel(int posX, int posY, String strLabel)
{
	local PersonaNormalTextWindow winLabel;

	winLabel = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
	winLabel.SetPos(posX, posY);
	winLabel.SetSize(112, 11);//(52, 11);
	winLabel.SetText(strLabel);
	winLabel.SetTextMargins(2, 1);
}

// ----------------------------------------------------------------------
// CreateAugCanWindow()
// ----------------------------------------------------------------------

function CreateAugCanWindow()
{
	winAugCans = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winAugCans.SetPos(346, 274);
	winAugCans.SetWidth(242);
    winAugCans.SetIcon(Class'AugmentationUpgradeCannister'.Default.LargeIcon);
	winAugCans.SetIconSize(
		Class'AugmentationUpgradeCannister'.Default.largeIconWidth,
		Class'AugmentationUpgradeCannister'.Default.largeIconHeight);

	UpdateAugCans();
}

// ----------------------------------------------------------------------
// CreateBioCellWindow()
// ----------------------------------------------------------------------

function CreateBioCellWindow()
{
	winBioCells = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winBioCells.SetPos(346, 332);
	winBioCells.SetWidth(242);
	winBioCells.SetIcon(Class'BioelectricCell'.Default.LargeIcon);
	winBioCells.SetIconSize(
		Class'BioelectricCell'.Default.largeIconWidth,
		Class'BioelectricCell'.Default.largeIconHeight);

	UpdateBioCells();
}

// ----------------------------------------------------------------------
// CreateBioCellBar()
// ----------------------------------------------------------------------

function CreateBioCellBar()
{
	winBioEnergy = ProgressBarWindow(winClient.NewChild(Class'ProgressBarWindow'));

	winBioEnergy.SetPos(446, 389);
	winBioEnergy.SetSize(140, 12);
	winBioEnergy.SetValues(0, 100);
	winBioEnergy.UseScaledColor(True);
	if (player.bAnimBar1)
	    winBioEnergy.bSpecialFX = True;
	winBioEnergy.SetVertical(False);
	winBioEnergy.SetScaleColorModifier(0.5);
	winBioEnergy.SetDrawBackground(True);
	winBioEnergy.SetBackColor(colBarBack);

	winBioEnergyText = TextWindow(winClient.NewChild(Class'TextWindow'));
	winBioEnergyText.SetPos(446, 391);
	winBioEnergyText.SetSize(140, 12);
	winBioEnergyText.SetTextMargins(0, 0);
	winBioEnergyText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winBioEnergyText.SetFont(Font'FontMenuSmall_DS');
	winBioEnergyText.SetTextColorRGB(255, 255, 255);

	UpdateBioEnergyBar();
}

// ----------------------------------------------------------------------
// UpdateBioEnergyBar()
// ----------------------------------------------------------------------

function UpdateBioEnergyBar()
{
	local float energyPercent, maxEnergy, actualMaxEnergy;
    local string text;

	energyPercent = 100.0 * (player.Energy / player.GetMaxEnergy());
	
    maxEnergy = player.GetMaxEnergy();
	actualMaxEnergy = player.GetMaxEnergy(true);
	
    if (maxEnergy != actualMaxEnergy)
        text = Sprintf(BarStringRes,int(player.Energy),int(player.GetMaxEnergy()),int(energyPercent),int(player.AugmentationSystem.CalcEnergyReserve()));
    else
        //text = Sprintf(BarString,int(player.Energy),int(player.GetMaxEnergy()),int(energyPercent));
        text = Sprintf(BarString,int(energyPercent));

    if (winBioEnergy != None)
    {
        winBioEnergy.SetCurrentValue(energyPercent);
        winBioEnergyText.SetText(text);
	}
}

// ----------------------------------------------------------------------
// UpdateAugCans()
// ----------------------------------------------------------------------

function UpdateAugCans()
{
	local Inventory anItem;
	local int augCanCount;

	if (winAugCans != None)
	{
		winAugCans.SetText(AugCanUseText);

		// Loop through the player's inventory and count how many upgrade cans
		// the player has
		anItem = player.Inventory;

		while(anItem != None)
		{
			if (anItem.IsA('AugmentationUpgradeCannister'))
				augCanCount++;
			else if (anItem.IsA('AugmentationUpgradeCannisterOverdrive'))
                augCanCount++;
			anItem = anItem.Inventory;
		}

		winAugCans.SetCount(augCanCount);
	}
}

// ----------------------------------------------------------------------
// UpdateBioCells()
// ----------------------------------------------------------------------

function UpdateBioCells()
{
	local BioelectricCell bioCell;

	if (winBioCells != None)
	{
		winBioCells.SetText(BioCellUseText);

		bioCell = BioelectricCell(player.FindInventoryType(Class'BioelectricCell'));

		if (bioCell != None)
			winBioCells.SetCount(bioCell.NumCopies);
		else
			winBioCells.SetCount(0);
	}

	UpdateBioEnergyBar();
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
    UpdateAugCans();
    UpdateBioCells();
    UpdateBioEnergyBar();

    if (selectedAugButton != None)
    {
        PersonaAugmentationItemButton(selectedAugButton).SetLevel(selectedAug.GetCurrentLevel());
        PersonaAugmentationItemButton(selectedAugButton).SetHeartUpgraded(selectedAug.heartUpgraded);
        PersonaAugmentationItemButton(selectedAugButton).SetActive(selectedAug);
    }


    EnableButtons();

    Super.RefreshWindow(DeltaTime);
}

// ----------------------------------------------------------------------
// CreateAugmentationHighlights()
// ----------------------------------------------------------------------

function CreateAugmentationHighlights()
{
	if (bFemale)
	{
		AugHighlightWindows[0] = CreateHighlight(augHighlightTexturesFemale[0], 142,  45, 16, 19);
		AugHighlightWindows[1] = CreateHighlight(augHighlightTexturesFemale[1], 161,  63, 19, 12);
		AugHighlightWindows[2] = CreateHighlight(augHighlightTexturesFemale[2], 157, 108, 34, 48);
		AugHighlightWindows[3] = CreateHighlight(augHighlightTexturesFemale[3], 105, 110, 24, 43);
		AugHighlightWindows[4] = CreateHighlight(augHighlightTexturesFemale[4], 165, 222, 32, 94);
		AugHighlightWindows[5] = CreateHighlight(augHighlightTexturesFemale[5],  84, 160, 14, 36);
	}
	else
	{
		AugHighlightWindows[0] = CreateHighlight(augHighlightTextures[0], 142,  45, 16, 19);
		AugHighlightWindows[1] = CreateHighlight(augHighlightTextures[1], 161,  63, 19, 12);
		AugHighlightWindows[2] = CreateHighlight(augHighlightTextures[2], 157, 108, 34, 48);
		AugHighlightWindows[3] = CreateHighlight(augHighlightTextures[3], 105, 110, 24, 43);
		AugHighlightWindows[4] = CreateHighlight(augHighlightTextures[4], 165, 222, 32, 94);
		AugHighlightWindows[5] = CreateHighlight(augHighlightTextures[5],  84, 160, 14, 36);
	}
}

// ----------------------------------------------------------------------
// CreateHighlight()
// ----------------------------------------------------------------------

function Window CreateHighlight(
	Texture texHighlight,
	int posX, int posY,
	int sizeX, int sizeY)
{
	local Window newHighlight;

	newHighlight = winClient.NewChild(Class'Window');

	newHighlight.SetPos(posX, posY);
	newHighlight.SetSize(sizeX, sizeY);
	newHighlight.SetBackground(texHighlight);
	newHighlight.SetBackgroundStyle(DSTY_Masked);
	newHighlight.Hide();

	return newHighlight;
}

// ----------------------------------------------------------------------
// CreateAugmentationButtons()
//
// Loop through all the Augmentation items and draw them in our Augmentation grid as
// buttons
// ----------------------------------------------------------------------

function CreateAugmentationButtons()
{
	local Augmentation anAug;
	local int augX, augY;
	local int torsoCount;
	local int skinCount;
	local int armCount;
	local int defaultCount;
	local int slotIndex;
	local int augCount;

	augCount   = 0;
	torsoCount = 0;
	skinCount  = 0;
	armCount    = 0;
	defaultCount = 0;

	// Iterate through the augmentations, creating a unique button for each
	anAug = player.AugmentationSystem.FirstAug;
	while(anAug != None)
	{
		if (( anAug.AugmentationName != "" ) && ( anAug.bHasIt ))
		{
			slotIndex = 0;
			augX = augLocs[int(anAug.AugmentationLocation)].x;
			augY = augLocs[int(anAug.AugmentationLocation)].y;

			// Show the highlight graphic for this augmentation slot as long
			// as it's not the Default slot (for which there is no graphic)

			if (anAug.AugmentationLocation < arrayCount(augHighlightWindows))
				augHighlightWindows[anAug.AugmentationLocation].Show();

			if (int(anAug.AugmentationLocation) == 2)			// Torso
			{
				slotIndex = torsoCount;
				augY += (torsoCount++ * augSlotSpacingY);
			}

            if (int(anAug.AugmentationLocation) == 3)			// Arms
			{
				slotIndex = armCount;
                augY += (armCount++ * augSlotSpacingY);

			}

			if (int(anAug.AugmentationLocation) == 5)			// Subdermal
			{
				slotIndex = skinCount;
				augY += (skinCount++ * augSlotSpacingY);
			}

			if (int(anAug.AugmentationLocation) == 6)			// Default
				augX += (defaultCount++ * augSlotSpacingX);

			augItems[augCount] = CreateAugButton(anAug, augX, augY, slotIndex);

			// If the augmentation is active, make sure the button draws it
			// appropriately

			augItems[augCount].SetActive(anAug);
			augCount++;
		}

		anAug = anAug.next;
	}
}

// ----------------------------------------------------------------------
// CreateAugButton
// ----------------------------------------------------------------------

function PersonaAugmentationItemButton CreateAugButton(Augmentation anAug, int augX, int augY, int slotIndex)
{
	local PersonaAugmentationItemButton newButton;

	newButton = PersonaAugmentationItemButton(winClient.NewChild(Class'PersonaAugmentationItemButton'));
	newButton.SetPos(augX, augY);
	newButton.SetClientObject(anAug);
	newButton.SetIcon(anAug.icon);

	// set the hotkey number
	if (anAug.CanBeActivated())
    {
		newButton.SetHotkeyNumber(anAug.GetHotKey());
	    newButton.SetActive(anAug);
    }

	newButton.SetLevel(anAug.GetCurrentLevel());
    newButton.SetHeartUpgraded(anAug.heartUpgraded);

	return newButton;
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated(Window buttonPressed)
{
	local bool bHandled;

	if (Super.ButtonActivated(buttonPressed))
		return True;

	bHandled   = True;

	// Check if this is one of our Augmentation buttons
	if (buttonPressed.IsA('PersonaItemButton'))
	{
	    winInfo.bStylization2 = False;
	    winInfo.bStylization3 = False;
	    if (winInfo.bMedBotCall)
	        PersonaItemButton(buttonPressed).bMedBotCallPass = True;
        augButtonPressed = True;
        winInfo.Clear();
	    CreateInfoWindow();
		SelectAugmentation(PersonaItemButton(buttonPressed));
		if (winBar != None && winBar2 != None && winBar3 != None && winBar4 != None)
        {
             winBar.Hide();
             winBar2.Hide();
             winBar3.Hide();
             winBar4.Hide();
             //winLabelGlobal.Hide();
        }
        if (!PersonaItemButton(buttonPressed).IsA('HUDMedBotAugItemButton') && selectedAug != None)
	       PersonaItemButton(buttonPressed).bAugmentationBtn = True;
    }
	else
	{
		switch(buttonPressed)
		{
			case btnUpgrade:
				UpgradeAugmentation();
				break;

			case btnActivate:
				ActivateAugmentation();
				break;

            case btnDeactivateAll:
                player.AugmentationSystem.DeactivateAll();
                RefreshAugmentationButtons();
                if (SelectedAug != None)
                {
                        btnActivate.SetButtonText(ActivateButtonLabel);
                }
                break;

            case btnAugStats:
                if (augButtonPressed || !player.bShowAugStatus)
                {
                    player.bShowAugStatus = True;
                    augButtonPressed = False;
                     if (SelectedAug != None)
                    {
                        btnUpgrade.EnableWindow(False);
                        btnActivate.SetButtonText(ActivateButtonLabel);
                        btnActivate.EnableWindow(False);
                        SelectedAug = None;
                    }
                    if (selectedAugButton != None)
                    {
                        if (selectedAugButton.winVisionLines != None)
		                {
		                selectedAugButton.bTickEnabled = False;
		                selectedAugButton.winVisionLines.Destroy();
	                    selectedAugButton.winVisionLines = None;
                        }
                        selectedAugButton.SelectButton(False);
                        selectedAugButton = None;
                    }
                    winInfo.Clear();
                    PlaySound(Sound'MetalDrawerOpen',0.5);
                    CreateInfoWindow();
                }
                else
                {
                    player.bShowAugStatus = False;
                    augButtonPressed = True;
                    if (selectedAugButton != None)
                        selectedAugButton = None;
                    if (SelectedAug != None)
                    {
                        SelectedAug = None;
                        selectedAugButton.SelectButton(False);
                    }
                    winInfo.Clear();
                    winInfo.bStylization = False;
		            winInfo.bStylization2 = False;
		            winInfo.bStylization3 = False;
		            winInfo.SetBackground(winInfo.default.background);
                    winInfo.SetTitle(" ");
                    PlaySound(Sound'MetalDrawerOpen',0.5);
                    if (winBar != None && winBar2 != None && winBar3 != None && winBar4 != None)
                    {
                     winBar.Hide();
                     winBar2.Hide();
                     winBar3.Hide();
                     winBar4.Hide();
                     //winLabelGlobal.Hide();
                    }
                    CreateInfoWindow();
                }
                break;

			case btnUseCell:
				UseCell();
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
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local bool bKeyHandled;
	bKeyHandled = True;

	if (Super.VirtualKeyPressed(key, bRepeat))
		return True;

	switch( key )
	{
		case IK_F3:
			SelectAugByKey(0);
			break;
		case IK_F4:
			SelectAugByKey(1);
			break;
		case IK_F5:
			SelectAugByKey(2);
			break;
		case IK_F6:
			SelectAugByKey(3);
			break;
		case IK_F7:
			SelectAugByKey(4);
			break;
		case IK_F8:
			SelectAugByKey(5);
			break;
		case IK_F9:
			SelectAugByKey(6);
			break;
		case IK_F10:
			SelectAugByKey(7);
			break;
		case IK_F11:
			SelectAugByKey(8);
			break;
		case IK_F12:
			SelectAugByKey(9);
			break;

		// Enter will toggle an aug on/off
		case IK_Enter:
			ActivateAugmentation();
			break;

		default:
			bKeyHandled = False;
			break;
	}

	return bKeyHandled;
}

//CyberP: activate/deactivate selected augs with a right click.
event bool MouseButtonPressed(float pointX, float pointY, EInputKey button,
                              int numClicks)
{
	local Bool bResult;

	bResult = False;

    if (button == IK_RightMouse && SelectedAug != None)
    {
       ActivateAugmentation();
       bResult = True;
    }
    //SARGE: Allow adding to wheel, or removing from wheel, using MMB.
    else if (button == IK_MiddleMouse && SelectedAug != None && SelectedAug.CanBeActivated())
    {
        //TODO: Localization. Also do a strict "menu log" rather than a standard client message
        //Add to Wheel
        SelectedAug.bAddedToWheel = !SelectedAug.bAddedToWheel;
        if (SelectedAug.bAddedToWheel)
            player.ClientMessage(SelectedAug.GetName() $ " added to Augmentation Wheel");
        else
            player.ClientMessage(SelectedAug.GetName() $ " removed from Augmentation Wheel");
        bResult = True;
        player.AugmentationSystem.RefreshAugDisplay();
    }
    //else if (button == IK_LeftMouse && SelectedAug != None)
    //{
    //   ActivateAugmentation();
    //   bResult = True;
    //}
	return bResult;
}

// ----------------------------------------------------------------------
// SelectAugByKey()
// ----------------------------------------------------------------------

function SelectAugByKey(int keyNum)
{
	local int buttonIndex;
	local Augmentation anAug;

	for(buttonIndex=0; buttonIndex<arrayCount(augItems); buttonIndex++)
	{
		if (augItems[buttonIndex] != None)
		{
			anAug = Augmentation(augItems[buttonIndex].GetClientObject());

			if ((anAug != None) && (anAug.HotKeyNum - 3 == keyNum))
			{
				SelectAugmentation(augItems[buttonIndex]);
				ActivateAugmentation();
				break;
			}
		}
	}
}

// ----------------------------------------------------------------------
// SelectAugmentation()
// ----------------------------------------------------------------------

function SelectAugmentation(PersonaItemButton buttonPressed)
{
	// Don't do extra work.
	if (selectedAugButton != buttonPressed)
	{
		// Deselect current button
		if (selectedAugButton != None)
		{
			selectedAugButton.SelectButton(False);
			if (selectedAugButton.winVisionLines != None)
		    {
		       selectedAugButton.bTickEnabled = False;
		       selectedAugButton.winVisionLines.Destroy();
		       selectedAugButton.winVisionLines = None;
            }
        }
		selectedAugButton = buttonPressed;
		selectedAug       = Augmentation(selectedAugButton.GetClientObject());

		selectedAug.UpdateInfo(winInfo);
		selectedAugButton.SelectButton(True);
        selectedAugButton.bTickEnabled = True;
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// UpgradeAugmentation()
// ----------------------------------------------------------------------

function UpgradeAugmentation()
{
	local AugmentationUpgradeCannister augCan;
    local AugmentationUpgradeCannisterOverdrive augCan2;
	// First make sure we have a selected Augmentation
	if (selectedAug == None)
		return;

	// Now check to see if we have an upgrade cannister
	augCan = AugmentationUpgradeCannister(player.FindInventoryType(Class'AugmentationUpgradeCannister'));
    augCan2 = AugmentationUpgradeCannisterOverdrive(player.FindInventoryType(Class'AugmentationUpgradeCannisterOverdrive'));
    if (augCan2 != None)
	{
		// Increment the level and remove the aug cannister from
		// the player's inventory
        if (selectedAug.IsA('AugAqualung') || selectedAug.IsA('AugEnviro'))
        {
            player.bBoosterUpgrade = True;
        }
        else
            selectedAug.IncLevel();
		selectedAug.IncLevel();
		selectedAug.UpdateInfo(winInfo);
		player.PlaySound(sound'medkituse',SLOT_None,,,,1.3);
		augCan2.UseOnce();
        if (winAugCans != None)
        {
          winAugCans.SetIcon(Texture'DeusExUI.Icons.LargeIconAugmentationUpgrade');
        }
		// Update the level icons
		if (selectedAugButton != None)
        {
			PersonaAugmentationItemButton(selectedAugButton).SetLevel(selectedAug.GetCurrentLevel());
			PersonaAugmentationItemButton(selectedAugButton).SetHeartUpgraded(selectedAug.heartUpgraded);
        }
	}
	else if (augCan != None)
	{
		// Increment the level and remove the aug cannister from
		// the player's inventory

		selectedAug.IncLevel();
		selectedAug.UpdateInfo(winInfo);
		player.PlaySound(sound'medkituse',SLOT_None);

		augCan.UseOnce();

		// Update the level icons
		if (selectedAugButton != None)
        {
			PersonaAugmentationItemButton(selectedAugButton).SetLevel(selectedAug.GetCurrentLevel());
			PersonaAugmentationItemButton(selectedAugButton).SetHeartUpgraded(selectedAug.heartUpgraded);
        }

	}

    //if (SelectedAug.IsA('AugAmmoCap'))                                          //RSD: Update MaxAmmo
    //   player.ChangeAllMaxAmmo();

	UpdateAugCans();
	EnableButtons();
}

// ----------------------------------------------------------------------
// ActivateAugmentation()
// ----------------------------------------------------------------------

function ActivateAugmentation()
{
	if (selectedAug == None)
		return;

    player.AugmentationSystem.ActivateAug(selectedAug,!selectedAug.bIsActive);

	// If the augmentation activated or deactivated, set the
	// button appropriately.
	if (selectedAugButton != None)
	{
		PersonaAugmentationItemButton(selectedAugButton).SetActive(selectedAug);
    }
	selectedAug.UpdateInfo(winInfo);

	EnableButtons();
}

// ----------------------------------------------------------------------
// UseCell()
// ----------------------------------------------------------------------

function UseCell()
{
	local BioelectricCell bioCell;

	bioCell = BioelectricCell(player.FindInventoryType(Class'BioelectricCell'));

	if (bioCell != None)
		bioCell.Activate();

	if (bAllIconsReset)
        bAllIconsReset = False;

	UpdateBioCells();
	EnableButtons();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Upgrade can only be enabled if the player has an
	// AugmentationUpgradeCannister that allows this augmentation to
	// be upgraded

	if (selectedAug != None)
		btnUpgrade.EnableWindow(selectedAug.CanBeUpgraded());
	else
		btnUpgrade.EnableWindow(False);

	if (player.bSpecialUpgrade)
    {
       if (winAugCans != None)
       {
          winAugCans.SetIcon(Texture'GMDXSFX.UI.AugOverrideBelt');
       }
    }
    else
    {
       if (winAugCans != None)
       {
          winAugCans.SetIcon(Texture'DeusExUI.Icons.LargeIconAugmentationUpgrade');
       }
    }

	// Only allow btnActivate to be active if
	//
	// 1.  We have a selected augmentation
	// 2.  The player's energy is above 0
	// 3.  This augmentation isn't "AlwaysActive"

	btnActivate.EnableWindow((selectedAug != None) && (player.Energy > 0) && (selectedAug.CanBeActivated()));
    btnDeactivateAll.EnableWindow(player.AugmentationSystem.CalcEnergyUse(0.06) > 0);
	if ( selectedAug != None )
	{
		if ( selectedAug.bIsActive )
			btnActivate.SetButtonText(DeactivateButtonLabel);
		else
			btnActivate.SetButtonText(ActivateButtonLabel);
	}

	// Use Cell button
	//
	// Only active if the player has one or more Energy Cells and
	// BioElectricEnergy < 100%

	btnUseCell.EnableWindow(
		(player.Energy < player.GetMaxEnergy()) &&
		(player.FindInventoryType(Class'BioelectricCell') != None));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     AugLocs(0)=(X=83,Y=35)
     AugLocs(1)=(X=211,Y=38)
     AugLocs(2)=(X=246,Y=120)
     AugLocs(3)=(X=19,Y=43)
     AugLocs(4)=(X=246,Y=322)
     AugLocs(5)=(X=18,Y=198)
     AugLocs(6)=(X=18,Y=341)
     augHighlightTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsLocationCerebral'
     augHighlightTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsLocationEyes'
     augHighlightTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsLocationTorso'
     augHighlightTextures(3)=Texture'DeusExUI.UserInterface.AugmentationsLocationArms'
     augHighlightTextures(4)=Texture'DeusExUI.UserInterface.AugmentationsLocationLegs'
     augHighlightTextures(5)=Texture'DeusExUI.UserInterface.AugmentationsLocationSubdermal'
     augSlotSpacingX=53
     augSlotSpacingY=59
     AugmentationsTitleText="Augmentations"
     UpgradeButtonLabel="|&Upgrade"
     ActivateButtonLabel="Acti|&vate"
     DeactivateButtonLabel="Deac|&tivate"
     UseCellButtonLabel="Us|&e Cell"
     AugCanUseText="To upgrade an Augmentation, click on the Augmentation you wish to upgrade, then on the Upgrade button."
     BioCellUseText="To replenish Bioelectric Energy for your Augmentations, click on the Use Cell button."
     AugLocationDefault="Default"
     AugLocationCranial="Cranial"
     AugLocationEyes="Eyes"
     AugLocationArms="Arms"
     AugLocationLegs="Legs"
     AugLocationTorso="Torso"
     AugLocationSubdermal="Subdermal"
     fluctuate=40.000000
     titString="Augmentation Evaluation"
     BioString="Bioelectrical Energy: "
     curBioString=" Current Energy Usage: %d Units/Minute"
     augTimeRem="Time Until Energy Depletion:"
     AugsString="Installed Augmentations: "
     btnAugStatusLabel="|&Status"
     btnDeactAll="|&Deactivate All"
     circuitLabel="Circuit Activity"
     overviewLabel="Overview"
     activeLabel="Active:"
     passiveLabel="Passive:"
     automaticLabel="Automatic:"
     toggleLabel="Toggle:"
     BarString="%d%%"
     BarStringRes="%d/%d (%d%%) - %d Reserved"
     clientBorderOffsetY=32
     ClientWidth=596
     ClientHeight=427
     clientOffsetX=25
     clientOffsetY=5
     clientTextures(0)=Texture'GMDXSFX.UI.AugInterface'
     clientTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsBackground_3'
     clientTextures(3)=Texture'GMDXSFX.UI.AugInterface4'
     clientTextures(4)=Texture'GMDXSFX.UI.AugInterface5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.AugmentationsBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.AugmentationsBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.AugmentationsBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.AugmentationsBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
