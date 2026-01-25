//=============================================================================
// HUDRechargeWindow
//
// Used to allow the user to recharge energy
//=============================================================================

class HUDRechargeWindow extends DeusExBaseWindow;

var DeusExPlayer player;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color colText;

//var Texture texBackground[2];
var Texture texBackground[4];                                                   //RSD: New background textures
//var Texture texBorder[2];
var Texture texBorder[4];                                                       //RSD: New border textures

var PersonaHeaderTextWindow winTitle;
var PersonaNormalTextWindow winInfo;

var PersonaActionButtonWindow btnRecharge;
var PersonaActionButtonWindow btnClose;
var RepairBot repairBot;
var Float lastRefresh;
var Float refreshInterval;

var ProgressBarWindow winBioBar;
var TextWindow winBioBarText;
var PersonaNormalTextWindow winBioInfoText;

var ProgressBarWindow winRepairBotBar;
var TextWindow winRepairBotBarText;
var PersonaNormalTextWindow winRepairBotInfoText;

var localized String RechargeButtonLabel;
var localized String CloseButtonLabel;
var localized String RechargeTitle;
var localized String RepairBotInfoText;
var localized String RepairBotStatusLabel;
var localized String ReadyLabel;
var Localized String SecondsPluralLabel;
var Localized String SecondsSingularLabel;
var Localized String BioStatusLabel;
var Localized String RepairBotRechargingLabel;
var Localized String RepairBotReadyLabel;
var Localized String RepairBotYouAreHealed;

var Localized String OfflineLabel;
var Localized String RepairBotOfflineLabel;

//RSD: For equipment recharging system
var ProgressBarWindow winEquipBar[5];
var TextWindow winEquipBarText[5];
var PersonaNormalTextWindow winEquipInfoText[5], winEquipRechargeText[5];
var int addedSize;                                                              //RSD: size of added window so I don't go insane
var Color colIcon;
var class<ChargedPickup> possibleEquipment[5];
var Inventory equipmentList[5];
var PersonaActionButtonWindow btnEquip[5];
var Localized String NoEquipLabel, NoEquipInfoText;
var Localized String EquipRechargeLabel1, EquipRechargeLabel2, EquipRechargeLabel3;
var Localized String EquipButtonLabel1, EquipButtonLabel2, EquipButtonLabel3;

var Color    colBlue; //SARGE: Added
var Color    colWhite; //SARGE: Added

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	SetSize(265, 153+addedSize+4);                                                          //RSD: Was 265, 153

	getEquipmentList();                                                         //RSD: Added
	CreateControls();
	EnableButtons();

	bTickEnabled = TRUE;

	StyleChanged();
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Let the RepairBot go about its business.
// ----------------------------------------------------------------------

event DestroyWindow()
{
	if (repairBot != None)
	{
		repairBot.PlayAnim('Stop');
		repairBot.PlaySound(sound'RepairBotLowerArm', SLOT_None);
		repairBot.FollowOrders();
	}

	Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	// First draw the background then the border
	DrawBackground(gc);

	// Don't call the DrawBorder routines if
	// they are disabled
	if (bDrawBorder)
		DrawBorder(gc);

	DrawEquipmentIcons(gc);                                                     //RSD
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	if (bBackgroundTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);

	gc.SetTileColor(colBackground);

	//gc.DrawTexture(0,   0, 256, height, 0, 0, texBackground[0]);
	//gc.DrawTexture(256, 0, 9,   height, 0, 0, texBackground[1]);

	//RSD: New background textures
	gc.DrawTexture(0,   0, 256, height, 0, 0, texBackground[0]);
	gc.DrawTexture(256, 0, 9,   height, 0, 0, texBackground[1]);
	gc.DrawTexture(0, 256, 256, 128,    0, 0, texBackground[2]);
	gc.DrawTexture(256, 256, 9, 128,    0, 0, texBackground[3]);

}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		if (bBorderTranslucent)
			gc.SetStyle(DSTY_Translucent);
		else
			gc.SetStyle(DSTY_Masked);

		gc.SetTileColor(colBorder);

		//gc.DrawTexture(0,   0, 256, height, 0, 0, texBorder[0]);
		//gc.DrawTexture(256, 0, 9,   height, 0, 0, texBorder[1]);

		//RSD: New border textures
		gc.DrawTexture(0,   0, 256,   height, 0, 0, texBorder[0]);
		gc.DrawTexture(256, 0, 9,     height, 0, 0, texBorder[1]);
		gc.DrawTexture(0,   256, 256, 128,    0, 0, texBorder[2]);
		gc.DrawTexture(256, 256, 9,   128,    0, 0, texBorder[3]);
	}
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	if (lastRefresh >= refreshInterval)
	{
		lastRefresh = 0.0;
		UpdateBioWindows();                                                     //RSD: Added
		UpdateRepairBotWindows();
		UpdateInfoText();
		UpdateEquipmentWindows();                                               //RSD
		EnableButtons();
	}
	else
	{
		lastRefresh += deltaSeconds;
	}
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateTitleWindow();
	CreateInfoWindow();
	CreateEquipmentWindows();
	CreateBioWindows();
	CreateRepairbotWindows();
	CreateButtons();
}

// ----------------------------------------------------------------------
// CreateTitleWindow()
// ----------------------------------------------------------------------

function CreateTitleWindow()
{
	winTitle = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winTitle.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winTitle.SetText(RechargeTitle);
	winTitle.SetPos(20, 20);
	winTitle.SetSize(233, 14);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winInfo.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winInfo.SetPos(20, 39);
	winInfo.SetSize(233, 44);
}

// ----------------------------------------------------------------------
// CreateBioWindows()
// ----------------------------------------------------------------------

function CreateBioWindows()
{
	winBioBar = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));

	winBioBar.SetPos(114, 91+addedSize);                                                  //RSD: was 114, 91
	winBioBar.SetSize(140, 12);
	winBioBar.SetValues(0, 100);
	//winBioBar.UseScaledColor(True); //SARGE: Disabled since the purely blue bar looks way better
    if (player.bAnimBar1)
        winBioBar.SetColors(colWhite,colWhite);
    else
        winBioBar.SetColors(colBlue,colBlue);
	if (player.bAnimBar1)
	    winBioBar.bSpecialFX = True;
	winBioBar.SetVertical(False);
	winBioBar.SetScaleColorModifier(0.5);
	winBioBar.SetDrawBackground(False);

	winBioBarText = TextWindow(NewChild(Class'TextWindow'));
	winBioBarText.SetPos(114, 93+addedSize);                                              //RSD: was 114, 93
	winBioBarText.SetSize(140, 12);
	winBioBarText.SetTextMargins(0, 0);
	winBioBarText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winBioBarText.SetFont(Font'FontMenuSmall_DS');
	winBioBarText.SetTextColorRGB(255, 255, 255);

	winBioInfoText = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winBioInfoText.SetPos(20, 92+addedSize);                                              //RSD: was 20, 92
	winBioInfoText.SetSize(90, 12);
	winBioInfoText.SetTextMargins(0, 0);

	UpdateBioWindows();
}

// ----------------------------------------------------------------------
// CreateRepairbotWindows()
// ----------------------------------------------------------------------

function CreateRepairbotWindows()
{
	winRepairBotBar = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));

	winRepairBotBar.SetPos(114, 111+addedSize);                                           //RSD: was 114, 111
	winRepairBotBar.SetSize(140, 12);
	winRepairBotBar.SetValues(0, 100);
	winRepairBotBar.UseScaledColor(True);
	winRepairBotBar.SetVertical(False);
	winRepairBotBar.SetScaleColorModifier(0.5);
	winRepairBotBar.SetDrawBackground(False);

	winRepairBotBarText = TextWindow(NewChild(Class'TextWindow'));
	winRepairBotBarText.SetPos(114, 113+addedSize);                                       //RSD: was 114, 113
	winRepairBotBarText.SetSize(140, 12);
	winRepairBotBarText.SetTextMargins(0, 0);
	winRepairBotBarText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winRepairBotBarText.SetFont(Font'FontMenuSmall_DS');
	winRepairBotBarText.SetTextColorRGB(255, 255, 255);

	winRepairBotInfoText = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winRepairBotInfoText.SetPos(20, 112+addedSize);                                       //RSD: was 20, 112
	winRepairBotInfoText.SetSize(90, 12);
	winRepairBotInfoText.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// UpdateInfoText()
// ----------------------------------------------------------------------

function UpdateInfoText()
{
	local String infoText;

	if (repairBot != None)
	{
		infoText = Sprintf(RepairBotInfoText, repairBot.chargeAmount, repairBot.chargeRefreshTime);

      if (repairBot.chargeMaxTimes>repairBot.lowerThreshold)                    //RSD: 0 changed to lowerThreshold
      {
		if (player.Energy >= player.GetMaxEnergy())
			infoText = infoText $ RepairBotYouAreHealed;
		else if (repairBot.CanCharge())
			infoText = infoText $ RepairBotReadyLabel;
		else
			infoText = infoText $ RepairBotRechargingLabel;
		} else
		infoText = infoText $ RepairBotOfflineLabel;

		winInfo.SetText(infoText);
	}
}

// ----------------------------------------------------------------------
// UpdateBioWindows()
// ----------------------------------------------------------------------

function UpdateBioWindows()
{
	local float energyPercent;
    local float maxEnergy, actualMaxEnergy; //SARGE: Added
    local string text;                      //SARGE: Added
	
    energyPercent = 100.0 * (player.Energy / player.GetMaxEnergy());

	winBioBar.SetCurrentValue(energyPercent);
    maxEnergy = player.GetMaxEnergy();
	actualMaxEnergy = player.GetMaxEnergy(true);
	
    if (maxEnergy != actualMaxEnergy)
        text = Sprintf(class'PersonaScreenAugmentations'.default.BarStringRes,int(player.Energy),int(player.GetMaxEnergy()),int(energyPercent),int(player.AugmentationSystem.CalcEnergyReserve()));
    else
        //text = Sprintf(class'PersonaScreenAugmentations'.default.BarString,int(player.Energy),int(player.GetMaxEnergy()),int(energyPercent));
        text = Sprintf(class'PersonaScreenAugmentations'.default.BarString,int(energyPercent));

	//winBioBarText.SetText(String(Int(energyPercent)) $ "%"); //SARGE: Replaced with new version, see above
    winBioBarText.SetText(text);

	winBioInfoText.SetText(BioStatusLabel);
}

// ----------------------------------------------------------------------
// UpdateRepairBotWindows()
// ----------------------------------------------------------------------

function UpdateRepairBotWindows()
{
	local float barPercent;
	local String infoText;
	local float secondsRemaining;

	if (repairBot != None)
	{
		// Update the bar
		if (repairBot.CanCharge())
		{
			winRepairBotBar.SetCurrentValue(100);
			infoText = ReadyLabel;                                              //RSD
			if (player.CombatDifficulty > 1.0)                                  //RSD: Print number of uses remaining
            	infoText = infoText @ "(" $ repairBot.chargeMaxTimes - repairBot.lowerThreshold @ "charges)";
			winRepairBotBarText.SetText(infoText);                              //RSD: Was ReadyLabel
		}
		else
		{
         if (repairBot.chargeMaxTimes>repairBot.lowerThreshold || (player != None && player.CombatDifficulty < 1.0)) //RSD: 0 changed to lowerThreshold and <1.5 to <1.0
         {
			secondsRemaining = repairBot.GetRefreshTimeRemaining();

			barPercent = 100 * (1.0 - (secondsRemaining / Float(repairBot.chargeRefreshTime)));

			winRepairBotBar.SetCurrentValue(barPercent);

			if (secondsRemaining == 1)
				winRepairBotBarText.SetText(Sprintf(SecondsSingularLabel, Int(secondsRemaining)));
			else
				winRepairBotBarText.SetText(Sprintf(SecondsPluralLabel, Int(secondsRemaining)));
         } else
         {
            winRepairBotBarText.SetText(OfflineLabel);
            barPercent=0;
            winRepairBotBar.SetCurrentValue(barPercent);
         }
		}
		winRepairBotInfoText.SetText(RepairBotStatusLabel);
	}
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;
	local PersonaButtonBarWindow winEquipButtons[5];                            //RSD: Added
    local int i, offset;                                                        //RSD: Added
    local ChargedPickup armor;                                                  //RSD: Added
    local String btnEquipText;                                                  //RSD: Added

    offset = 38;                                                                //RSD

	winActionButtons = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(15, 126+addedSize+3);                                           //RSD: was 15, 126
	winActionButtons.SetSize(191, 16);
	winActionButtons.FillAllSpace(False);

	btnClose = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnClose.SetButtonText(CloseButtonLabel);

	btnRecharge = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnRecharge.SetButtonText(RechargeButtonLabel);

	for (i=0; i<5; i++)                                                         //RSD: for equipment recharging system
	{
        winEquipButtons[i] = PersonaButtonBarWindow(NewChild(Class'PersonaButtonBarWindow'));
    	winEquipButtons[i].SetPos(186, 109+i*offset);
    	winEquipButtons[i].SetSize(70, 16);
    	winEquipButtons[i].FillAllSpace(True);
        if(equipmentList[i] != none)
    	{
            armor = ChargedPickup(equipmentList[i]);
    		if (armor.IsA('BallisticArmor') || armor.IsA('HazMatSuit'))
    			btnEquipText = EquipButtonLabel1;
   			else
   				btnEquipText = EquipButtonLabel2;
    	}
    	else
    		btnEquipText = EquipButtonLabel3;
   		btnEquip[i] = PersonaActionButtonWindow(winEquipButtons[i].NewChild(Class'PersonaActionButtonWindow'));
   		btnEquip[i].SetButtonText(btnEquipText);
	}
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
		case btnClose:
			root.PopWindow();
			break;

		case btnRecharge:
			if (repairBot != None)
			{
				repairBot.ChargePlayer(player);

				// play a cool animation
				//repairBot.PlayAnim('Clamp');

				UpdateBioWindows();
				UpdateRepairBotWindows();
				UpdateInfoText();
				EnableButtons();
			}
			break;

        case btnEquip[0]:                                                       //RSD: For equipment recharging system
        	if (repairBot != None)
        	{
        		repairBot.ChargeEquipment(ChargedPickup(EquipmentList[0]), player);
        		UpdateEquipmentWindows();
                UpdateRepairBotWindows();
				UpdateInfoText();
				EnableButtons();
        	}
        	break;
        case btnEquip[1]:                                                       //RSD: For equipment recharging system
        	if (repairBot != None)
        	{
        		repairBot.ChargeEquipment(ChargedPickup(EquipmentList[1]), player);
        		UpdateEquipmentWindows();
                UpdateRepairBotWindows();
				UpdateInfoText();
				EnableButtons();
        	}
        	break;
        case btnEquip[2]:                                                       //RSD: For equipment recharging system
        	if (repairBot != None)
        	{
        		repairBot.ChargeEquipment(ChargedPickup(EquipmentList[2]), player);
        		UpdateEquipmentWindows();
                UpdateRepairBotWindows();
				UpdateInfoText();
				EnableButtons();
        	}
        	break;
        case btnEquip[3]:                                                       //RSD: For equipment recharging system
        	if (repairBot != None)
        	{
        		repairBot.ChargeEquipment(ChargedPickup(EquipmentList[3]), player);
        		UpdateEquipmentWindows();
                UpdateRepairBotWindows();
				UpdateInfoText();
				EnableButtons();
        	}
        	break;
        case btnEquip[4]:                                                       //RSD: For equipment recharging system
        	if (repairBot != None)
        	{
        		repairBot.ChargeEquipment(ChargedPickup(EquipmentList[4]), player);
        		UpdateEquipmentWindows();
                UpdateRepairBotWindows();
				UpdateInfoText();
				EnableButtons();
        	}
        	break;
	}

	if (!bHandled)
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	local int i;                                                                //RSD: Added

    if (repairBot != None)
	{
		if (player.Energy >= player.GetMaxEnergy())
			btnRecharge.EnableWindow(False);
		else
			btnRecharge.EnableWindow(repairBot.CanCharge());
		for (i=0; i<5; i++)                                                     //RSD: for equipment recharging system
		{
        	if(equipmentList[i] != none)
    		{
    			if (equipmentList[i].Charge >= equipmentList[i].default.Charge)
    				btnEquip[i].EnableWindow(False);
                else
                	btnEquip[i].EnableWindow(repairBot.CanCharge());
   			}
   			else
   			{
   				btnEquip[i].EnableWindow(False);
   			}
		}
	}
}

// ----------------------------------------------------------------------
// SetRepairBot()
// ----------------------------------------------------------------------

function SetRepairBot(RepairBot newBot)
{
	repairBot = newBot;

	if (repairBot != None)
	{
		repairBot.StandStill();
		repairBot.PlayAnim('Start');
		repairBot.PlaySound(sound'RepairBotRaiseArm', SLOT_None);

		UpdateInfoText();
		UpdateRepairBotWindows();
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

    if (player != None)
    {
	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colText       = theme.GetColorFromName('HUDColor_NormalText');
	colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

	bBorderTranslucent     = player.GetHUDBorderTranslucency();
	bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
	bDrawBorder            = player.GetHUDBordersVisible();
	}
}

function CreateEquipmentWindows()
{
    local int i;
    local int offset;

    offset = 38;

    for (i=0; i<5; i++)
    {
   		winEquipInfoText[i] = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
		winEquipInfoText[i].SetPos(62, 102+i*offset);
		winEquipInfoText[i].SetSize(52, 12);
		winEquipInfoText[i].SetTextMargins(0, 0);
		winEquipInfoText[i].SetTextAlignments(HALIGN_Left, VALIGN_Center);
		winEquipInfoText[i].SetFont(Font'FontTiny');
		winEquipInfoText[i].SetTextColorRGB(255, 255, 255);

		winEquipRechargeText[i] = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
		winEquipRechargeText[i].SetPos(117, 113+i*offset);
		winEquipRechargeText[i].SetSize(100, 12);
		winEquipRechargeText[i].SetTextMargins(0, 0);
		winEquipRechargeText[i].SetTextAlignments(HALIGN_Left, VALIGN_Center);
		winEquipRechargeText[i].SetFont(Font'FontMenuSmall_DS');
		winEquipRechargeText[i].SetTextColorRGB(255, 255, 255);

		winEquipBar[i] = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));
        winEquipBar[i].SetPos(114, 91+i*offset);
		winEquipBar[i].SetSize(140, 12);
		winEquipBar[i].SetValues(0, 100);
		winEquipBar[i].UseScaledColor(True);
		winEquipBar[i].SetVertical(False);
		winEquipBar[i].SetScaleColorModifier(0.5);
		winEquipBar[i].SetDrawBackground(False);

		winEquipBarText[i] = TextWindow(NewChild(Class'TextWindow'));
		winEquipBarText[i].SetPos(114, 93+i*offset);
		winEquipBarText[i].SetSize(140, 12);
		winEquipBarText[i].SetTextMargins(0, 0);
		winEquipBarText[i].SetTextAlignments(HALIGN_Center, VALIGN_Center);
		winEquipBarText[i].SetFont(Font'FontMenuSmall_DS');
		winEquipBarText[i].SetTextColorRGB(255, 255, 255);
    }

    UpdateEquipmentWindows();

    /*winEquipInfoText1 = PersonaNormalTextWindow(NewChild(Class'PersonaNormalTextWindow'));
	winEquipInfoText1.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winEquipInfoText1.SetPos(20, 112);
	winEquipInfoText1.SetSize(233, addedSize);*/
}

function UpdateEquipmentWindows()
{
	local String infoText, outText, percentText;
    local int i;
    local float energyPercent;
    local ChargedPickup armor;

    for (i=0; i<5; i++)
    {
    	if(equipmentList[i] != none)
    	{
    		armor = ChargedPickup(equipmentList[i]);
    		if (armor != none)                                                  //RSD: accessed none?
    		{
            infoText=armor.beltDescription;

    		energyPercent = armor.GetCurrentCharge();
    		if (winEquipBar[i] != none)                                         //RSD: accessed none?
    		winEquipBar[i].SetCurrentValue(energyPercent);

            percentText = String(Int(energyPercent)) $ "%";

            if (armor.numCopies > 1)
                percentText = percentText @ "(" $ armor.numCopies $ ")";

            if (winEquipBarText[i] != none)                                     //RSD: accessed none?
    		winEquipBarText[i].SetText(percentText);

            /*if (armor.IsA('BallisticArmor') || armor.IsA('HazMatSuit'))
    		    outText = EquipRechargeLabel1 @ int(300*armor.default.chargeMult)$"%";
            else
                outText = EquipRechargeLabel2 @ int(300*armor.default.chargeMult)$"%";*/
            if (player != none && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkMisfeatureExploit').bPerkObtained == true)                //RSD: Misfeature Exploit perk
            	outText = EquipRechargeLabel3 @ int(450*armor.default.chargeMult)$"%";
           	else
           		outText = EquipRechargeLabel3 @ int(300*armor.default.chargeMult)$"%";

           	if (winEquipRechargeText[i] != none)                                //RSD: accessed none?
    		winEquipRechargeText[i].SetText(outText);
            }
   		}
   		else
   		{
   			infoText=NoEquipInfoText;

   			energyPercent = 0;
   			if (winEquipBar[i] != none)                                         //RSD: accessed none?
   			winEquipBar[i].SetCurrentValue(energyPercent);

            if (winEquipBarText[i] != none)                                     //RSD: accessed none?
   			winEquipBarText[i].SetText(NoEquipLabel);

   		}
   		if (winEquipInfoText[i] != none)                                        //RSD: accessed none?
   		winEquipInfoText[i].SetText(infoText);
    }
}

function DrawEquipmentIcons(GC gc)
{
	local int i;
    local int offset, startX, startY, sizeX, sizeY;

	offset = 38;
	startX = 15;
	startY = 89;

	sizeX = 42;
	sizeY = 36;

    gc.SetStyle(DSTY_Masked);
	gc.SetTileColor(colIcon);

    for (i=0; i<5; i++)
    {
    	if(equipmentList[i] != none)
    		gc.DrawTexture(startX,startY+i*offset, sizeX, sizeY, 0, 0, equipmentList[i].Icon);
    }
    /*gc.DrawTexture(startX,startY, sizeX, sizeY, 0, 0, Texture'DeusExUI.Icons.BeltIconHazMatSuit');
	gc.DrawTexture(startX,startY+offset, sizeX, sizeY, 0, 0, Texture'DeusExUI.Icons.BeltIconHazMatSuit');
	gc.DrawTexture(startX,startY+2*offset, sizeX, sizeY, 0, 0, Texture'DeusExUI.Icons.BeltIconHazMatSuit');
	gc.DrawTexture(startX,startY+3*offset, sizeX, sizeY, 0, 0, Texture'DeusExUI.Icons.BeltIconHazMatSuit');
	gc.DrawTexture(startX,startY+4*offset, sizeX, sizeY, 0, 0, Texture'DeusExUI.Icons.BeltIconHazMatSuit');*/
}

function getEquipmentList()
{
    local int i, currentIndex;
    local Inventory inv;

    currentIndex = 0;
    for (i=0; i<5; i++)
    {
        inv = player.FindInventoryType(possibleEquipment[i]);
        if (inv != none)
        {
            equipmentList[currentIndex] = inv;
            currentIndex++;
        }
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackground(0)=Texture'GMDXSFX.UI.HUDRepairBotBackground_1edit'
     texBackground(1)=Texture'GMDXSFX.UI.HUDRepairBotBackground_2edit'
     texBackground(2)=Texture'GMDXSFX.UI.HUDRepairBotBackground_3edit'
     texBackground(3)=Texture'GMDXSFX.UI.HUDRepairBotBackground_4edit'
     texBorder(0)=Texture'GMDXSFX.UI.HUDRepairBotBorder_1edit'
     texBorder(1)=Texture'GMDXSFX.UI.HUDRepairBotBorder_2edit'
     texBorder(2)=Texture'GMDXSFX.UI.HUDRepairBotBorder_3edit'
     texBorder(3)=Texture'GMDXSFX.UI.HUDRepairBotBorder_4edit'
     refreshInterval=0.200000
     RechargeButtonLabel="  |&Recharge  "
     CloseButtonLabel="  |&Close  "
     RechargeTitle="REPAIRBOT INTERFACE"
     RepairBotInfoText="The RepairBot can restore up to %d points of BioEnergy or restore equipment status every %d seconds."
     RepairBotStatusLabel="RepairBot Status:"
     ReadyLabel="Ready!"
     SecondsPluralLabel="Recharging: %d seconds"
     SecondsSingularLabel="Recharging: %d second"
     BioStatusLabel="Bio Energy:"
     RepairBotRechargingLabel="|n|nThe RepairBot is currently Recharging.  Please Wait."
     RepairBotReadyLabel="|n|nThe RepairBot is Ready, you may now Recharge."
     RepairBotYouAreHealed="|n|nYour BioElectric Energy is at Maximum."
     OfflineLabel="Offline!"
     RepairBotOfflineLabel="|n|nThe RepairBot charge has been depleted."
     addedSize=192
     colIcon=(R=255,G=255,B=255)
     possibleEquipment(0)=Class'DeusEx.BallisticArmor'
     possibleEquipment(1)=Class'DeusEx.HazMatSuit'
     possibleEquipment(2)=Class'DeusEx.AdaptiveArmor'
     possibleEquipment(3)=Class'DeusEx.TechGoggles'
     possibleEquipment(4)=Class'DeusEx.Rebreather'
     NoEquipLabel="No item to repair"
     NoEquipInfoText="N/A"
     EquipRechargeLabel1="Repairs"
     EquipRechargeLabel2="Recharges"
     EquipRechargeLabel3="Restores"
     EquipButtonLabel1="Repair"
     EquipButtonLabel2="Recharge"
     EquipButtonLabel3="N/A"
     ScreenType=ST_Popup
     colBlue=(R=20,G=20,B=255)
     colWhite=(R=255,G=255,B=255)
}
