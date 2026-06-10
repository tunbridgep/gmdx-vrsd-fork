//=============================================================================
// PersonaInventoryInfoWindow
//=============================================================================

class PersonaInventoryInfoWindow extends PersonaInfoWindow;

var TileWindow winTileAmmo;
var localized String AmmoLabel;
var localized String AmmoRoundsLabel;
var localized String ShowAmmoDescriptionsLabel;

var PersonaAmmoDetailButton      selectedAmmoButton;
var PersonaInfoItemWindow        lastAmmoLoaded;
var PersonaInfoItemWindow	     lastAmmoTypes;
var PersonaNormalLargeTextWindow lastAmmoDescription;
var PersonaLevelIconWindow       winIcons;
var PersonaButtonBarWindow       winActionButtons;
var Inventory                    assignThis;

// ----------------------------------------------------------------------
// AddAmmoInfoWindow()
// ----------------------------------------------------------------------
function AddAmmoInfoWindow(DeusExAmmo ammo, bool bShowDescriptions)
{
	local AlignWindow winAmmo;
	local PersonaNormalTextWindow winText;
	local Window winIcon;
    local string outOf;

	if (ammo != None)
	{
	    outOf = "/";
		winAmmo = AlignWindow(winTile.NewChild(class'AlignWindow'));
		winAmmo.SetChildVAlignment(VALIGN_Top);
		winAmmo.SetChildSpacing(4);

		// Add icon
		winIcon = winAmmo.NewChild(class'Window');
		winIcon.SetBackground(ammo.static.GetHDTPIcon());
		winIcon.SetBackgroundStyle(DSTY_Masked);
		winIcon.SetSize(42, 37);

		// Add description
		winText = PersonaNormalTextWindow(winAmmo.NewChild(class'PersonaNormalTextWindow'));
		winText.SetWordWrap(true);
		winText.SetTextMargins(0, 0);
		winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);

		if (bShowDescriptions)
		{
			winText.SetText(ammo.itemName @ "(" $ AmmoRoundsLabel @ ammo.AmmoAmount $ outOf $ player.GetAdjustedMaxAmmo(ammo) $ ")|n|n"); //RSD: Replaced ammo.MaxAmmo with adjusted
			winText.AppendText(ammo.description);
		}
		else
		{
            //SARGE: Updated to show Ammo / MaxAmmo, rather than just the number of rounds
			winText.SetText(ammo.itemName $ "|n|n" $ AmmoRoundsLabel @ ammo.AmmoAmount $ outOf $ player.GetAdjustedMaxAmmo(ammo));
		}
	}

	AddLine();
}

// ----------------------------------------------------------------------
// AddAmmoCheckbox()
// ----------------------------------------------------------------------

function AddAmmoCheckbox(bool bChecked)
{
	local PersonaCheckboxWindow winCheck;

	winCheck = PersonaCheckboxWindow(winTile.NewChild(Class'PersonaCheckboxWindow'));
	winCheck.SetFont(player.FontManager.GetFont(TT_FontMenuSmall));
	winCheck.SetText(ShowAmmoDescriptionsLabel);
	winCheck.SetToggle(bChecked);
}

// ----------------------------------------------------------------------
// CreateAmmoTileWindow()
// ----------------------------------------------------------------------

function CreateAmmoTileWindow()
{
	local PersonaNormalTextWindow winText;

	if (winTileAmmo == None)
	{
		winTileAmmo = TileWindow(winTile.NewChild(Class'TileWindow'));
		winTileAmmo.SetChildAlignments(HALIGN_Left, VALIGN_Full);
		winTileAmmo.SetWindowAlignments(HALIGN_Full, VALIGN_Top);
		winTileAmmo.MakeWidthsEqual(false); //False
		winTileAmmo.MakeHeightsEqual(true);
		winTileAmmo.SetMargins(0, 0);
		winTileAmmo.SetMinorSpacing(1);  //4

		winText = PersonaNormalTextWindow(winTileAmmo.NewChild(Class'PersonaNormalTextWindow'));
		winText.SetWidth(36); //70
		winText.SetTextMargins(0, 6);
		winText.SetTextAlignments(HALIGN_Right, VALIGN_Center);
		winText.SetText(AmmoLabel);
	}
}

// ----------------------------------------------------------------------
// AddAmmo()
// ----------------------------------------------------------------------

function AddAmmo(Class<Ammo> ammo, bool bHasIt, optional int newRounds)
{
	local PersonaAmmoDetailButton ammoButton;

	if (winTileAmmo == None)
		CreateAmmoTileWindow();

	ammoButton = PersonaAmmoDetailButton(winTileAmmo.NewChild(Class'PersonaAmmoDetailButton'));
	if(ammoButton != None)
		ammoButton.SetAmmo(ammo, bHasIt, newRounds);
}

// ----------------------------------------------------------------------
// AddAmmoLoadedItem()
// ----------------------------------------------------------------------

function AddAmmoLoadedItem(String newLabel, String newText)
{
	lastAmmoLoaded = AddInfoItem(newLabel, newText);
}

// ----------------------------------------------------------------------
// UpdateAmmoLoaded()
// ----------------------------------------------------------------------

function UpdateAmmoLoaded(String newText)
{
	if (lastAmmoLoaded != None)
		lastAmmoLoaded.SetItemText(newText);
}

// ----------------------------------------------------------------------
// AddAmmoTypesItem()
// ----------------------------------------------------------------------

function AddAmmoTypesItem(String newLabel, String newText)
{
	lastAmmoTypes = AddInfoItem(newLabel, newText);
}

// ----------------------------------------------------------------------
// UpdateAmmoTypes()
// ----------------------------------------------------------------------

function UpdateAmmoTypes(String newText)
{
	if (lastAmmoTypes != None)
		lastAmmoTypes.SetItemText(newText);
}

// ----------------------------------------------------------------------
// AddAmmoDescription()
// ----------------------------------------------------------------------

function AddAmmoDescription(String newDesc)
{
	lastAmmoDescription = SetText(newDesc);
}

// ----------------------------------------------------------------------
// UpdateAmmoDescription()
// ----------------------------------------------------------------------

function UpdateAmmoDescription(String newDesc)
{
	if (lastAmmoDescription != None)
		lastAmmoDescription.SetText(newDesc);
}

// ----------------------------------------------------------------------
// GetSelectedAmmo()
// ----------------------------------------------------------------------

function Class<Ammo> GetSelectedAmmo()
{
	local Window currentWindow;

	if (selectedAmmoButton != None)
	{
		return selectedAmmoButton.GetAmmo();
	}
	else
	{
		currentWindow = winTileAmmo.GetTopChild();
		while(currentWindow != None)
		{
			if (PersonaAmmoDetailButton(currentWindow) != None)
			{
				if (PersonaAmmoDetailButton(currentWindow).IsLoaded())
				{
					return PersonaAmmoDetailButton(currentWindow).GetAmmo();
					break;
				}
			}
			currentWindow = currentWindow.GetLowerSibling();
		}
	}

	return None;
}

// ----------------------------------------------------------------------
// SetLoaded()
//
// Loops through all the ammo, setting the background color to green if
// the ammo is loaded, otherwise black.
// ----------------------------------------------------------------------

function SetLoaded(Class<Ammo> ammo, optional bool bNoSelectSound)              //RSD: Added bNoSelectSound
{
	local Window currentWindow;

	currentWindow = winTileAmmo.GetTopChild();
	while(currentWindow != None)
	{
		if (PersonaAmmoDetailButton(currentWindow) != None)
		{
			if (bNoSelectSound)                                                 //RSD: Hack to stop ammo load buttons from multiply playing selectbutton sounds
				PersonaAmmoDetailButton(currentWindow).bNoSelectSound = true;
			else
			    PersonaAmmoDetailButton(currentWindow).bNoSelectSound = false;
            PersonaAmmoDetailButton(currentWindow).SetLoaded(currentWindow.GetClientObject() == ammo);
			PersonaAmmoDetailButton(currentWindow).SelectButton(currentWindow.GetClientObject() == ammo);

			// Keep track of the selected button
			if (currentWindow.GetClientObject() == ammo)
				selectedAmmoButton = PersonaAmmoDetailButton(currentWindow);
		}
		currentWindow = currentWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// SelectAmmoButton()
// ----------------------------------------------------------------------

function SelectAmmoButton(PersonaAmmoDetailButton selectedButton)
{
	local Window currentWindow;

	currentWindow = winTileAmmo.GetTopChild();
	while(currentWindow != None)
	{
		if (PersonaAmmoDetailButton(currentWindow) != None)
		{
			PersonaAmmoDetailButton(currentWindow).SetLoaded(selectedButton == currentWindow);
			PersonaAmmoDetailButton(currentWindow).SelectButton(selectedButton == currentWindow);
		}
		currentWindow = currentWindow.GetLowerSibling();
	}

	// Keep track of the selected button
	selectedAmmoButton = selectedButton;
}

// ----------------------------------------------------------------------
// Clear()
// ----------------------------------------------------------------------

function Clear()
{
	Super.Clear();
	winTileAmmo = None;
}


// BuildPercentString()
final function String BuildPercentString(Float value)
{
	local string str;

	str = String(Int(Abs(value * 100.0)+0.5));                                  //RSD: Added 0.5 for proper rounding
	if (value < 0.0)
		str = "-" $ str;
	else
		str = "+" $ str;

	return ("(" $ str $ "%)");
}

function DoNanoSwordAmmoInfo(DeusExWeapon weapon)
{
    if (!player.bNanoswordEnergyUse && !player.bHardcoreMode)
        return;

	SetText(sprintf(WeaponNanoSword(weapon).chargeManager.ChargeRemainingLabel,WeaponNanoSword(weapon).chargeManager.GetCurrentCharge()));
    SetText(sprintf(WeaponNanoSword(weapon).chargeManager.BiocellRechargeAmountLabel,WeaponNanoSword(weapon).chargeManager.GetRechargeAmountDisplay()));
    AddLine();
}

function bool DrawAmmoButtons(DeusExWeapon weapon)
{
	local bool bAmmoAvailable;
	local Ammo weaponAmmo;
	local int  ammoAmount;
	local bool bHasAmmo;
    local int i;

	bAmmoAvailable = false;

	// Create the ammo buttons.  Start with the AmmoNames[] array,
	// which is used for weapons that can use more than one
	// type of ammo.
	if (weapon.AmmoNames[0] != None)
	{
		for (i=0; i<ArrayCount(weapon.AmmoNames); i++)
		{
			if (weapon.AmmoNames[i] != None)
			{
				// Check to make sure the player has this ammo type
				// *and* that the ammo isn't empty
				weaponAmmo = Ammo(player.FindInventoryType(weapon.AmmoNames[i]));

				if (weaponAmmo != None)
				{
					ammoAmount = weaponAmmo.AmmoAmount;
					bHasAmmo = (weaponAmmo.AmmoAmount > 0);
				}
				else
				{
					ammoAmount = 0;
					bHasAmmo = false;
				}

				AddAmmo(weapon.AmmoNames[i], bHasAmmo, ammoAmount);
				bAmmoAvailable = true;

				if (weapon.AmmoNames[i] == weapon.AmmoName)
                    SetLoaded(weapon.AmmoName, true);                          //RSD: Added bAmmoSelectWait hack
			}
		}
	}
	else
	{
		// Now peer at the AmmoName variable, but only if the AmmoNames[]
		// array is empty
		if ((weapon.AmmoName != class'AmmoNone') && (!weapon.bHandToHand) && (weapon.ReloadCount != 0))
		{
			weaponAmmo = Ammo(player.FindInventoryType(weapon.AmmoName));

			if (weaponAmmo != None)
			{
				ammoAmount = weaponAmmo.AmmoAmount;
				bHasAmmo = (weaponAmmo.AmmoAmount > 0);
			}
			else
			{
				ammoAmount = 0;
				bHasAmmo = false;
			}

			AddAmmo(weapon.AmmoName, bHasAmmo, ammoAmount);
			SetLoaded(weapon.AmmoName, true);                                  //RSD: Added true hack
			bAmmoAvailable = true;
		}
	}

	return bAmmoAvailable;
}

//Do the Ammo Display in the Inventory Window
function DoAmmoInfoWindow(DeusExWeapon weapon)
{
	local bool bAmmoAvailable;
	local string str;
    local int i;

	bAmmoAvailable = DrawAmmoButtons(weapon);

	// Only draw another line if we actually displayed ammo.
	if (bAmmoAvailable)
		AddLine();

	// Ammo loaded
	if ((weapon.AmmoName != class'AmmoNone') && (!weapon.bHandToHand) && (weapon.ReloadCount != 0))
		AddAmmoLoadedItem(weapon.msgInfoAmmoLoaded, weapon.AmmoType.itemName);

	// ammo info
	if ((weapon.AmmoName == class'AmmoNone') || (weapon.ReloadCount == 0))
		str = weapon.msgInfoNA;
	else
		str = weapon.AmmoName.default.ItemName;

	for (i=0; i<ArrayCount(weapon.AmmoNames); i++)
		if ((weapon.AmmoNames[i] != None) && (weapon.AmmoNames[i] != weapon.AmmoName))
			str = str $ "|n" $ weapon.AmmoNames[i].default.ItemName;

    if (!weapon.bHandToHand || weapon.IsA('WeaponProd'))
		AddAmmoTypesItem(weapon.msgInfoAmmo, str);
}

//Do the Ammo Display in the Inventory Window
function DoAmmoInfoExtended(DeusExWeapon weapon)
{
	local bool bAmmoAvailable;
	local string str;
	local float mod;

	bAmmoAvailable = DrawAmmoButtons(weapon);

	// Only draw another line if we actually displayed ammo.
	if (bAmmoAvailable)
		AddLine();

	//-- clip size
	if ((weapon.Default.ReloadCount == 0) || weapon.bHandToHand)
		str = weapon.msgInfoNA;
	else
	{
		if ( weapon.Level.NetMode != NM_Standalone )
			str = weapon.Default.mpReloadCount @ weapon.msgInfoRounds;
		else
			str = weapon.Default.ReloadCount @ weapon.msgInfoRounds;
	}

	if (weapon.HasClipMod())
	{
		str = str @ BuildPercentString(weapon.ModReloadCount);
		str = str @ "=" @ weapon.ReloadCount @ weapon.msgInfoRounds;
	}
    if (!weapon.bHandToHand || weapon.IsA('WeaponProd') || weapon.IsA('WeaponPepperGun'))
		AddInfoItem(weapon.msgInfoClip, str, weapon.HasClipMod());

	//-- reload time
	if ((weapon.Default.ReloadCount == 0) || weapon.bHandToHand)
		str = weapon.msgInfoNA;
	else
	{
        mod = 0.0;
		if (weapon.Level.NetMode != NM_Standalone )
			str = FormatFloatString(weapon.Default.mpReloadTime, 0.1) @ weapon.msgTimeUnit;
		else if (weapon.bPerShellReload)
			str = FormatFloatString(1 / weapon.Default.ReloadTime, 0.1) @ weapon.msgInfoRoundsPerSec;
		else
			str = FormatFloatString(weapon.Default.ReloadTime, 0.1) @ weapon.msgTimeUnit;
	}

    mod = weapon.GetAddonPenalty(Scope); //SARGE: Penalties for addons
	if (weapon.HasReloadMod() || mod > 0.0)
	{
		str = str @ BuildPercentString(weapon.ModReloadTime + mod);
		if (weapon.bPerShellReload)
			str = str @ "=" @ FormatFloatString(1 / (weapon.ReloadTime + mod), 0.1) @ weapon.msgInfoRoundsPerSec;
		else
            str = str @ "=" @ FormatFloatString(weapon.ReloadTime + mod, 0.1) @ weapon.msgTimeUnit;
	}

    if (!weapon.bHandToHand || weapon.IsA('WeaponPepperGun') || weapon.IsA('WeaponProd'))
		AddInfoItem(weapon.msgInfoReload, str, weapon.HasReloadMod() || mod >= 0.01);

	// Only draw another line if we actually displayed ammo.
	if (bAmmoAvailable)
		AddLine();
}

function bool WeaponInfoExtended(DeusExWeapon weapon)
{
	local string str;
	local int dmg, numMods;
	local float mod, stamDrain;
	local float hh;
    local string noiseLev, msgMultiplier;
    local float prec;                                                           //RSD: Floating point precision
    local float vol,rad;                                                        //SARGE: Added

	//-- New mod toggle buttons for weapon
	if (weapon.bHadLaser || weapon.bHadSilencer || weapon.bHadScope)
	{
		AddWeaponModButtons(weapon);
		AddLine();
	}

	//-- Do a specific ammo info log for nano sword, refactoring from the WeaponNanoSword to let the persona window handle the code
	if(weapon.IsA('WeaponNanoSword'))
		DoNanoSwordAmmoInfo(weapon);
	else
		DoAmmoInfoExtended(weapon);

	//-- Installed mod
    if (weapon.bCanHaveModBaseAccuracy || weapon.bCanHaveModReloadCount || weapon.bCanHaveModAccurateRange || weapon.bCanHaveModReloadTime || weapon.bCanHaveModRecoilStrength || weapon.bCanHaveModShotTime || weapon.bCanHaveModDamage)
	{
		SetText(weapon.msgAllMods);
		AddLine();

		if (weapon.bCanHaveScope) //CyberP: uncomment to add scope, laser, silencer and full-auto for extra fun
		{
			if (weapon.bHasScope)
				AddModInfo(weapon.msgInfoScope, 1, (numMods == 1), 4);
			else
				AddModInfo(weapon.msgInfoScope, 0, (numMods == 1), 4);
		}
		if (weapon.bCanHaveLaser)
		{
			if (weapon.bHasLaser)
				AddModInfo(weapon.msgInfoLaser, 1, (numMods == 1), 4);
			else
				AddModInfo(weapon.msgInfoLaser, 0, (numMods == 1), 4);
		}
		if (weapon.bCanHaveSilencer)
		{
			if (weapon.bHasSilencer)
				AddModInfo(weapon.msgInfoSilencer, 1, (numMods == 1), 4);
			else
				AddModInfo(weapon.msgInfoSilencer, 0, (numMods == 1), 4);
		}
		if (weapon.bCanHaveModFullAuto)
		{
			if (weapon.bFullAuto)
				AddModInfo(weapon.msgInfoFullAuto, 1, (numMods == 1), 4);
			else
				AddModInfo(weapon.msgInfoFullAuto, 0, (numMods == 1), 4);
		}

		if (weapon.bCanHaveModBaseAccuracy)
		{
			numMods = Int(Abs(weapon.ModBaseAccuracy) * 10);
			if (weapon.IsA('WeaponSawedOffShotgun'))
				AddModInfo(weapon.msgAccu, numMods, (numMods == 2), 3);
			else
				AddModInfo(weapon.msgAccu, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModDamage)
		{
			numMods = Int(Abs(weapon.ModDamage) * 10);
			AddModInfo(weapon.msgDama, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModShotTime)
		{
			numMods = Int(Abs(weapon.ModShotTime) * 10);
			if (weapon.IsA('WeaponAssaultGun'))
				AddModInfo(weapon.msgRate, numMods, (numMods == 3), 2);
			else
				AddModInfo(weapon.msgRate, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModRecoilStrength)
		{
			numMods = Int(Abs(weapon.ModRecoilStrength) * 10);
			AddModInfo(weapon.msgReco, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModAccurateRange)
		{
			numMods = Int(Abs(weapon.ModAccurateRange) * 10);
			AddModInfo(weapon.msgRang, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModReloadCount)
		{
			numMods = Int(Abs(weapon.ModReloadCount) * 10);
			if (weapon.IsA('WeaponProd'))
				AddModInfo(weapon.msgClip, numMods, (numMods == 4), 1);
			else
				AddModInfo(weapon.msgClip, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModReloadTime)
		{
			numMods = Int(Abs(weapon.ModReloadTime) * 10);
			AddModInfo(weapon.msgRelo, numMods, (numMods == 5));
		}

		AddLine();
	}

	SetText(weapon.msgInfoWeaponStats);
	AddLine();

	//-- Governing Skill
    if (weapon.minSkillRequirement > 0 && player.bWeaponRequirementsMatter)
        AddInfoItem(weapon.msgInfoSkill, weapon.GoverningSkill.default.SkillName @ "(" $ weapon.msgRequires @  player.SkillSystem.GetSkillFromClass(weapon.GoverningSkill).GetLevelString(weapon.minSkillRequirement) $ ")");
    else
        AddInfoItem(weapon.msgInfoSkill, weapon.GoverningSkill.default.SkillName);

	//-- Lethality
    if (weapon.IsA('WeaponMiniCrossbow') || weapon.IsA('WeaponSawedOffShotgun') || weapon.IsA('WeaponAssaultShotgun'))
		str= weapon.msgVar;
    else if (weapon.bPenetrating || weapon.IsA('WeaponCrowbar'))
		str= weapon.msgLethal;
    else
		str= weapon.msgNon;

    AddInfoItem(weapon.msgLethality, str);

	//-- Fire type
    if (!weapon.bHandToHand)
    {
		if (weapon.IsA('WeaponSawedOffShotgun'))
		{
				str = weapon.msgSpec;
				AddInfoItem(weapon.msgSpec2,str); //-- Special for sawedShotgun
				str = weapon.msgPump;
		}
		else if (weapon.bFullAuto || weapon.bAutomatic)
		{
				str = weapon.msgFull;
		}
		else
		{
			   str = weapon.msgSemi;
		}
		AddInfoItem(weapon.msgInfoFullAuto, str, weapon.bCanHaveModFullAuto && weapon.bFullAuto && (weapon.Default.bFullAuto != weapon.bFullAuto));
    }

	//-- Special, speed rating, stamina
    if (weapon.meleeStaminaDrain != 0 && !weapon.IsA('WeaponShuriken'))
    {
		mod = player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
        if (mod < 3)
          mod = 1;
        else
          mod = 0.5;

		//-- Special
		str = weapon.msgSpec;
		AddInfoItem(weapon.msgSpec2,str);

		stamDrain = weapon.meleeStaminaDrain*mod;
		if (weapon.IsA('WeaponSword'))
		{
			if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
			 msgMultiplier = weapon.msgModerate;
			else
			 msgMultiplier = weapon.msgFast;
		}
		else if (weapon.IsA('WeaponCrowbar'))
		{
		  if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 msgMultiplier = weapon.msgFast;
		  else
			 msgMultiplier = weapon.msgVeryFast;
		}
		else if (weapon.IsA('WeaponBaton'))
		{
		  if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 msgMultiplier = weapon.msgSlow;
		  else
			 msgMultiplier = weapon.msgModerate;
		}
		else if (weapon.IsA('WeaponCombatKnife'))
		{
		  if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 msgMultiplier = weapon.msgFast;
		  else
			 msgMultiplier = weapon.msgVeryFast;
		}
		else if (weapon.IsA('WeaponNanoSword'))
		{
		  if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 msgMultiplier = weapon.msgModerate;
		  else
			 msgMultiplier = weapon.msgFast;
		}

		if (player.AugmentationSystem != None && player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 AddInfoItem(weapon.msgSpeedR, msgMultiplier,false);
		else
			 AddInfoItem(weapon.msgSpeedR, msgMultiplier,true);

		if (mod != 1)
			AddInfoItem(weapon.msgStamDrain, FormatFloatString(stamDrain,0.01), true);
		else
			AddInfoItem(weapon.msgStamDrain, FormatFloatString(stamDrain,0.01), false);
    }

	//-- Noise level
	if (!weapon.bHandToHand || weapon.IsA('WeaponProd') || weapon.IsA('WeaponHideAGun') || weapon.IsA('WeaponPepperGun') || weapon.IsA('WeaponLAW'))
	{
		noiseLev="dB";

		//SARGE: Now we just read it's actual noise level, rather than this dumb bullshit
		weapon.GetAIVolume(vol,rad);
		if (vol == 0)
			vol = 1;
		AddInfoItem(weapon.msgNoise,FormatFloatString(vol * 30,1.0) @ noiseLev); 
    }

	//-- Headshot multiplier
    str = "x8";
    if (weapon.IsA('WeaponProd') || weapon.IsA('WeaponBaton') || weapon.AmmoName==class'AmmoRubber') //RSD: Moved to top of branch so Rubber Bullets dominate Sawed-Off Shotgun
		str = "x5";
    else if (weapon.ItemName == "USP.10" || weapon.IsA('WeaponSawedOffShotgun') || weapon.IsA('WeaponShuriken')) //RSD: Added WeaponShuriken
		str = "x9";
    else if (weapon.IsA('WeaponNanoSword') || weapon.IsA('WeaponCrowbar'))
		str = "x6";

    if (!weapon.IsA('WeaponPepperGun'))
		AddInfoItem(weapon.msgHeadMultiplier, str);

	//-- base damage
	if (weapon.AreaOfEffect == AOE_Cone)
	{
		if (weapon.bInstantHit)
		{
			if (weapon.Level.NetMode != NM_Standalone)
				dmg = weapon.Default.mpHitDamage * 5;
			else
				dmg = weapon.Default.HitDamage;
		}
		else
		{
			if (weapon.Level.NetMode != NM_Standalone)
				dmg = weapon.Default.mpHitDamage * 3;
			else
                dmg = weapon.Default.HitDamage;
		}
	}
	else
	{
		if (weapon.Level.NetMode != NM_Standalone)
			dmg = weapon.Default.mpHitDamage;
		else
			dmg = weapon.Default.HitDamage;
	}
	if (weapon.AmmoName != None)                                                       //RSD: Gotta totally rework this stuff
    {
        if (weapon.AmmoName == class'AmmoDartPoison')
            dmg = 15;
        else if (weapon.AmmoName == class'AmmoDart')
            dmg = 18;
        else if (weapon.AmmoName == class'AmmoDartFlare')
            dmg = 7;
        else if (weapon.AmmoName == class'AmmoDartTaser')
            dmg = 10;                                                           //RSD Was 15
        else if (weapon.AmmoName == class'Ammo20mm')
            dmg = 200;
        else if (weapon.AmmoName == class'AmmoRocketWP')
            dmg = 50;
        else if (weapon.Ammoname == class'AmmoSabot')                                  //RSD: Sabot are now slug rounds
            dmg = 18;
        else if (weapon.AmmoName == class'AmmoRubber')
            dmg = 18;                                                           //RSD Was 12 (actually 13/19)
    }
    if (player.AugmentationSystem != None) //RSD: accessed none?
        hh = player.AugmentationSystem.GetAugLevelValue(class'AugCombatStrength');

	str = String(dmg);
	if (weapon.AreaOfEffect == AOE_Cone)                                               //RSD: Tell us if we're using a multi-slug weapon
	{
		if (weapon.isA('WeaponSawedOffShotgun') && weapon.AmmoName!=class'AmmoSabot' && weapon.AmmoName!=class'AmmoRubber')
			str = str $ "x9";
        else if (weapon.bInstantHit && weapon.AmmoName!=class'AmmoSabot' && weapon.AmmoName!=class'AmmoRubber')
			str = str $ "x8";
		else if (!weapon.bInstantHit && weapon.AmmoName!=class'AmmoRubber')
			str = str $ "x3";
	}

    if (hh < 1.0)
		hh = 0.0;
    else
		hh -= 1.0;                                                              //RSD: Simple formula! Wow!

    if (player.AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost, accessed none?
		hh += 0.5;

	//G-Flex: display the correct damage bonus
	mod = 1.0 - (2.0 * weapon.GetWeaponSkill()) + weapon.ModDamage;  //CyberP: damage mods
    mod *= 1.0 - weapon.GetAddonPenalty(Silencer);
	if (weapon.IsA('WeaponSawedoffShotgun') && weapon.AmmoName==class'AmmoRubber')            //RSD: Sawed-off gets +30% damage on rubber bullets
	   mod += 0.30;
	if (weapon.bHandToHand)
       mod = 1.0 - (2.0 * weapon.GetWeaponSkill()) + hh;
	if (weapon.IsA('WeaponNanoSword'))                                                 //RSD: Can mod damage of DTS now
       mod = 1.0 - (2.0 * weapon.GetWeaponSkill()) + hh + weapon.ModDamage;
    if (mod != 1.0 || weapon.HasDAMMod())
	{
		str = str @ BuildPercentString(mod - 1.0);
		if (float(dmg)*mod-int(dmg*mod) >= 0.1)                                 //RSD: Print more decimals if there's roundoff
			prec = 0.1;
		else
		    prec = 1.0;
		str = str @ "=" @ FormatFloatString(float(dmg) * mod, prec);            //RSD: Now float with 0.1 precision because damage increases are now distributed continously

		if (weapon.AreaOfEffect == AOE_Cone)                                               //RSD: Tell us if we're using a multi-slug weapon
		{
			if (weapon.isA('WeaponSawedOffShotgun') && weapon.AmmoName!=class'AmmoSabot' && weapon.AmmoName!=class'AmmoRubber')
				str = str $ "x9";
			else if (weapon.bInstantHit && weapon.AmmoName!=class'AmmoSabot' && weapon.AmmoName!=class'AmmoRubber')
				str = str $ "x8";
			else if (!weapon.bInstantHit && weapon.AmmoName!=class'AmmoRubber')
				str = str $ "x3";
		}
	}

    AddInfoItem(weapon.msgInfoDamage, str, (mod != 1.0));

	//-- base accuracy (2.0 = 0%, 0.0 = 100%)
	if ( weapon.Level.NetMode != NM_Standalone )
	{
		str = Int((2.0 - weapon.Default.mpBaseAccuracy)*50.0) $ "%";
		mod = (weapon.Default.mpBaseAccuracy - (weapon.BaseAccuracy + weapon.GetWeaponSkill())) * 0.5;
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - weapon.Default.mpBaseAccuracy)*50.0)) $ "%";
		}
	}
	else
	{
		str = Int((2.0 - weapon.Default.BaseAccuracy)*50.0) $ "%";
		mod = (weapon.Default.BaseAccuracy - (weapon.BaseAccuracy + weapon.GetWeaponSkill())) * 0.5;

		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - weapon.Default.BaseAccuracy)*50.0)) $ "%";
		}
	}

	if (!weapon.bHandToHand || weapon.IsA('WeaponProd') || weapon.IsA('WeaponShuriken') || weapon.GoverningSkill == class'DeusEx.SkillDemolition')
		AddInfoItem(weapon.msgInfoAccuracy, str, (mod != 0.0));

	//-- rate of fire
	if ((weapon.Default.ReloadCount == 0) || weapon.bHandToHand)
	{
		str = weapon.msgInfoNA;
	}
	else
	{
		if (weapon.bAutomatic || weapon.bFullAuto)
			str = weapon.msgInfoAuto;
		else
			str = weapon.msgInfoSingle;

		str = str $ "," @ FormatFloatString(1.0/weapon.Default.ShotTime, 0.1) @ weapon.msgInfoRoundsPerSec;
		if(weapon.HasROFMod())
		{
			str = str @ BuildPercentString(-weapon.ModShotTime);                       //RSD: negative because we subtract ShotTime, but display ROF... numbers are a lie!
			str = str @ "=" @ FormatFloatString(1.0/weapon.ShotTime, 0.1) @ weapon.msgInfoRoundsPerSec;
		}
	}

	if (!weapon.bHandToHand || weapon.IsA('WeaponProd'))
		AddInfoItem(weapon.msgInfoROF, str, weapon.HasROFMod());

	//-- recoil
    mod = weapon.GetRecoilPenaltyMod(); //SARGE: Penalties for addons
	str = FormatFloatString(weapon.Default.recoilStrength, 0.01);
	if (weapon.HasRecoilMod() || mod > 0.0)
	{
		str = str @ BuildPercentString(weapon.ModRecoilStrength + mod);
		str = str @ "=" @ FormatFloatString(weapon.recoilStrength + mod, 0.01);
	}

    if (!weapon.bHandToHand)
		AddInfoItem(weapon.msgInfoRecoil, str, weapon.HasRecoilMod() || mod > 0.0);

	//-- Range
	mod = weapon.GetAddonPenalty(Silencer);
	if ( weapon.Level.NetMode != NM_Standalone )
		str = FormatFloatString((weapon.Default.mpAccurateRange)/16.0, 1.0) @ weapon.msgRangeUnit;
	else
		str = FormatFloatString((weapon.Default.AccurateRange)/16.0, 1.0) @ weapon.msgRangeUnit;

	if (weapon.HasRangeMod() || mod > 0.0)
	{
		str = str @ BuildPercentString(weapon.ModAccurateRange-mod);
		str = str @ "=" @ FormatFloatString((weapon.AccurateRange*(1.0-mod))/16.0, 1.0) @ weapon.msgRangeUnit;
	}
	if (!weapon.bHandToHand || weapon.IsA('WeaponShuriken'))
		AddInfoItem(weapon.msgInfoAccRange, str, weapon.HasRangeMod() || mod > 0.0);

	mod = weapon.GetAddonPenalty(Silencer);
	if ( weapon.Level.NetMode != NM_Standalone )
		str = FormatFloatString((weapon.Default.mpMaxRange)/16.0, 1.0) @ weapon.msgRangeUnit;
	else
		str = FormatFloatString((weapon.Default.MaxRange)/16.0, 1.0) @ weapon.msgRangeUnit;

	if (weapon.HasRangeMod() || mod > 0.0)                                                          //RSD: Added because we can now mod MaxRange
	{
		str = str @ BuildPercentString(weapon.ModAccurateRange-mod);
		str = str @ "=" @ FormatFloatString((weapon.MaxRange*(1.0-mod))/16.0, 1.0) @ weapon.msgRangeUnit;
	}

	AddInfoItem(weapon.msgInfoMaxRange, str,weapon.HasRangeMod() || mod > 0.0);                    //RSD: Added HasRangeMod()

	//-- mass
	AddInfoItem(weapon.msgInfoMass, FormatFloatString(weapon.Default.Mass, 1.0) @ weapon.msgMassUnit);

	//-- New mod penalties description
	if (weapon.bHadLaser || weapon.bHadSilencer || weapon.bHadScope)
		AddWeaponModDrawbacks(weapon);

	//-- weapon description
	AddLine();
	SetText(weapon.Description);

	return true;
}

function bool WeaponInfoVanilla(DeusExWeapon weapon)
{
	local string str;
	local int dmg, numMods;
	local float mod, stamDrain;
	local float hh;
    local string noiseLev, msgMultiplier;
    local float prec;                                                           //RSD: Floating point precision
    local float vol,rad;                                                        //SARGE: Added

	SetText(weapon.msgInfoWeaponStats);
	AddLine();

	if(weapon.IsA('WeaponNanoSword'))
		DoNanoSwordAmmoInfo(weapon);
	else
		DoAmmoInfoWindow(weapon);

	// base damage
	if (weapon.AreaOfEffect == AOE_Cone)
	{
		if (weapon.bInstantHit)
		{
			if (weapon.Level.NetMode != NM_Standalone)
				dmg = weapon.Default.mpHitDamage * 5;
			else
				dmg = weapon.Default.HitDamage;
		}
		else
		{
			if (weapon.Level.NetMode != NM_Standalone)
				dmg = weapon.Default.mpHitDamage * 3;
			else
                dmg = weapon.Default.HitDamage;
		}
	}
	else
	{
		if (weapon.Level.NetMode != NM_Standalone)
			dmg = weapon.Default.mpHitDamage;
		else
			dmg = weapon.Default.HitDamage;
	}
	if (weapon.AmmoName != None)                                                       //RSD: Gotta totally rework this stuff
    {
        if (weapon.AmmoName == class'AmmoDartPoison')
            dmg = 15;
        else if (weapon.AmmoName == class'AmmoDart')
            dmg = 18;
        else if (weapon.AmmoName == class'AmmoDartFlare')
            dmg = 7;
        else if (weapon.AmmoName == class'AmmoDartTaser')
            dmg = 10;                                                           //RSD Was 15
        else if (weapon.AmmoName == class'Ammo20mm')
            dmg = 200;
        else if (weapon.AmmoName == class'AmmoRocketWP')
            dmg = 50;
        else if (weapon.Ammoname == class'AmmoSabot')                                  //RSD: Sabot are now slug rounds
            dmg = 18;
        else if (weapon.AmmoName == class'AmmoRubber')
            dmg = 18;                                                           //RSD Was 12 (actually 13/19)
    }
    if (player.AugmentationSystem != None) //RSD: accessed none?
        hh = player.AugmentationSystem.GetAugLevelValue(class'AugCombatStrength');

	str = String(dmg);
	if (weapon.AreaOfEffect == AOE_Cone)                                               //RSD: Tell us if we're using a multi-slug weapon
	{
		if (weapon.isA('WeaponSawedOffShotgun') && weapon.AmmoName!=class'AmmoSabot' && weapon.AmmoName!=class'AmmoRubber')
			str = str $ "x9";
        else if (weapon.bInstantHit && weapon.AmmoName!=class'AmmoSabot' && weapon.AmmoName!=class'AmmoRubber')
			str = str $ "x8";
		else if (!weapon.bInstantHit && weapon.AmmoName!=class'AmmoRubber')
			str = str $ "x3";
	}

    if (hh < 1.0)
		hh = 0.0;
    else
		hh -= 1.0;                                                              //RSD: Simple formula! Wow!

    if (player.AddictionManager.addictions[2].drugTimer > 0) //RSD: Zyme gives its own +50% boost, accessed none?
		hh += 0.5;

	//G-Flex: display the correct damage bonus
	mod = 1.0 - (2.0 * weapon.GetWeaponSkill()) + weapon.ModDamage;  //CyberP: damage mods
    mod *= 1.0 - weapon.GetAddonPenalty(Silencer);
	if (weapon.IsA('WeaponSawedoffShotgun') && weapon.AmmoName==class'AmmoRubber')            //RSD: Sawed-off gets +30% damage on rubber bullets
	   mod += 0.30;
	if (weapon.bHandToHand)
       mod = 1.0 - (2.0 * weapon.GetWeaponSkill()) + hh;
	if (weapon.IsA('WeaponNanoSword'))                                                 //RSD: Can mod damage of DTS now
       mod = 1.0 - (2.0 * weapon.GetWeaponSkill()) + hh + weapon.ModDamage;
    if (mod != 1.0 || weapon.HasDAMMod())
	{
		str = str @ BuildPercentString(mod - 1.0);
		if (float(dmg)*mod-int(dmg*mod) >= 0.1)                                 //RSD: Print more decimals if there's roundoff
			prec = 0.1;
		else
		    prec = 1.0;
		str = str @ "=" @ FormatFloatString(float(dmg) * mod, prec);            //RSD: Now float with 0.1 precision because damage increases are now distributed continously

		if (weapon.AreaOfEffect == AOE_Cone)                                               //RSD: Tell us if we're using a multi-slug weapon
		{
			if (weapon.isA('WeaponSawedOffShotgun') && weapon.AmmoName!=class'AmmoSabot' && weapon.AmmoName!=class'AmmoRubber')
				str = str $ "x9";
			else if (weapon.bInstantHit && weapon.AmmoName!=class'AmmoSabot' && weapon.AmmoName!=class'AmmoRubber')
				str = str $ "x8";
			else if (!weapon.bInstantHit && weapon.AmmoName!=class'AmmoRubber')
				str = str $ "x3";
		}
	}

    AddInfoItem(weapon.msgInfoDamage, str, (mod != 1.0));

    //Headshot multiplier
    str = "x8";
    if (weapon.IsA('WeaponProd') || weapon.IsA('WeaponBaton') || weapon.AmmoName==class'AmmoRubber') //RSD: Moved to top of branch so Rubber Bullets dominate Sawed-Off Shotgun
		str = "x5";
    else if (weapon.ItemName == "USP.10" || weapon.IsA('WeaponSawedOffShotgun') || weapon.IsA('WeaponShuriken')) //RSD: Added WeaponShuriken
		str = "x9";
    else if (weapon.IsA('WeaponNanoSword') || weapon.IsA('WeaponCrowbar'))
		str = "x6";

    if (!weapon.IsA('WeaponPepperGun'))
		AddInfoItem(weapon.msgHeadMultiplier, str);
	// clip size
	if ((weapon.Default.ReloadCount == 0) || weapon.bHandToHand)
		str = weapon.msgInfoNA;
	else
	{
		if ( weapon.Level.NetMode != NM_Standalone )
			str = weapon.Default.mpReloadCount @ weapon.msgInfoRounds;
		else
			str = weapon.Default.ReloadCount @ weapon.msgInfoRounds;
	}

	if (weapon.HasClipMod())
	{
		str = str @ BuildPercentString(weapon.ModReloadCount);
		str = str @ "=" @ weapon.ReloadCount @ weapon.msgInfoRounds;
	}
    if (!weapon.bHandToHand || weapon.IsA('WeaponProd') || weapon.IsA('WeaponPepperGun'))
		AddInfoItem(weapon.msgInfoClip, str, weapon.HasClipMod());

	// rate of fire
	if ((weapon.Default.ReloadCount == 0) || weapon.bHandToHand)
	{
		str = weapon.msgInfoNA;
	}
	else
	{
		if (weapon.bAutomatic || weapon.bFullAuto)
			str = weapon.msgInfoAuto;
		else
			str = weapon.msgInfoSingle;

		str = str $ "," @ FormatFloatString(1.0/weapon.Default.ShotTime, 0.1) @ weapon.msgInfoRoundsPerSec;
		if(weapon.HasROFMod())
		{
			str = str @ BuildPercentString(-weapon.ModShotTime);                       //RSD: negative because we subtract ShotTime, but display ROF... numbers are a lie!
			str = str @ "=" @ FormatFloatString(1.0/weapon.ShotTime, 0.1) @ weapon.msgInfoRoundsPerSec;
		}
	}

	if (!weapon.bHandToHand || weapon.IsA('WeaponProd'))
		AddInfoItem(weapon.msgInfoROF, str, weapon.HasROFMod());

	// reload time
	if ((weapon.Default.ReloadCount == 0) || weapon.bHandToHand)
		str = weapon.msgInfoNA;
	else
	{
        mod = 0.0;
		if (weapon.Level.NetMode != NM_Standalone )
			str = FormatFloatString(weapon.Default.mpReloadTime, 0.1) @ weapon.msgTimeUnit;
		else if (weapon.bPerShellReload)
			str = FormatFloatString(1 / weapon.Default.ReloadTime, 0.1) @ weapon.msgInfoRoundsPerSec;
		else
			str = FormatFloatString(weapon.Default.ReloadTime, 0.1) @ weapon.msgTimeUnit;
	}

    mod = weapon.GetAddonPenalty(Scope); //SARGE: Penalties for addons
	if (weapon.HasReloadMod() || mod > 0.0)
	{
		str = str @ BuildPercentString(weapon.ModReloadTime + mod);
		if (weapon.bPerShellReload)
			str = str @ "=" @ FormatFloatString(1 / (weapon.ReloadTime + mod), 0.1) @ weapon.msgInfoRoundsPerSec;
		else
            str = str @ "=" @ FormatFloatString(weapon.ReloadTime + mod, 0.1) @ weapon.msgTimeUnit;
	}
    if (!weapon.bHandToHand || weapon.IsA('WeaponPepperGun') || weapon.IsA('WeaponProd'))
		AddInfoItem(weapon.msgInfoReload, str, weapon.HasReloadMod() || mod >= 0.01);

	// recoil
	mod = weapon.GetRecoilPenaltyMod(); //SARGE: Penalties for addons
	str = FormatFloatString(weapon.Default.recoilStrength, 0.01);
	if (weapon.HasRecoilMod() || mod > 0.0)
	{
		str = str @ BuildPercentString(weapon.ModRecoilStrength + mod);
		str = str @ "=" @ FormatFloatString(weapon.recoilStrength + mod, 0.01);
	}

    if (!weapon.bHandToHand)
		AddInfoItem(weapon.msgInfoRecoil, str, weapon.HasRecoilMod() || mod > 0.0);

	// base accuracy (2.0 = 0%, 0.0 = 100%)
	if ( weapon.Level.NetMode != NM_Standalone )
	{
		str = Int((2.0 - weapon.Default.mpBaseAccuracy)*50.0) $ "%";
		mod = (weapon.Default.mpBaseAccuracy - (weapon.BaseAccuracy + weapon.GetWeaponSkill())) * 0.5;
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - weapon.Default.mpBaseAccuracy)*50.0)) $ "%";
		}
	}
	else
	{
		str = Int((2.0 - weapon.Default.BaseAccuracy)*50.0) $ "%";
		mod = (weapon.Default.BaseAccuracy - (weapon.BaseAccuracy + weapon.GetWeaponSkill())) * 0.5;

		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - weapon.Default.BaseAccuracy)*50.0)) $ "%";
		}
	}
	if (!weapon.bHandToHand || weapon.IsA('WeaponProd') || weapon.IsA('WeaponShuriken') || weapon.GoverningSkill == class'DeusEx.SkillDemolition')
		AddInfoItem(weapon.msgInfoAccuracy, str, (mod != 0.0));

	mod = weapon.GetAddonPenalty(Silencer);
	if ( weapon.Level.NetMode != NM_Standalone )
		str = FormatFloatString((weapon.Default.mpAccurateRange)/16.0, 1.0) @ weapon.msgRangeUnit;
	else
		str = FormatFloatString((weapon.Default.AccurateRange)/16.0, 1.0) @ weapon.msgRangeUnit;

	if (weapon.HasRangeMod() || mod > 0.0)
	{
		str = str @ BuildPercentString(weapon.ModAccurateRange-mod);
		str = str @ "=" @ FormatFloatString((weapon.AccurateRange*(1.0-mod))/16.0, 1.0) @ weapon.msgRangeUnit;
	}
	if (!weapon.bHandToHand || weapon.IsA('WeaponShuriken'))
		AddInfoItem(weapon.msgInfoAccRange, str, weapon.HasRangeMod() || mod > 0.0);

	mod = weapon.GetAddonPenalty(Silencer);
	if ( weapon.Level.NetMode != NM_Standalone )
		str = FormatFloatString((weapon.Default.mpMaxRange)/16.0, 1.0) @ weapon.msgRangeUnit;
	else
		str = FormatFloatString((weapon.Default.MaxRange)/16.0, 1.0) @ weapon.msgRangeUnit;

	if (weapon.HasRangeMod() || mod > 0.0)                                                          //RSD: Added because we can now mod MaxRange
	{
		str = str @ BuildPercentString(weapon.ModAccurateRange-mod);
		str = str @ "=" @ FormatFloatString((weapon.MaxRange*(1.0-mod))/16.0, 1.0) @ weapon.msgRangeUnit;
	}

	AddInfoItem(weapon.msgInfoMaxRange, str,weapon.HasRangeMod() || mod > 0.0);                    //RSD: Added HasRangeMod()

	//Noise level
	if (!weapon.bHandToHand || weapon.IsA('WeaponProd') || weapon.IsA('WeaponHideAGun') || weapon.IsA('WeaponPepperGun') || weapon.IsA('WeaponLAW'))
	{
		noiseLev="dB";

		//SARGE: Now we just read it's actual noise level, rather than this dumb bullshit
		weapon.GetAIVolume(vol,rad);
		if (vol == 0)
			vol = 1;
		AddInfoItem(weapon.msgNoise,FormatFloatString(vol * 30,1.0) @ noiseLev); 
    }

    if (weapon.meleeStaminaDrain != 0 && !weapon.IsA('WeaponShuriken'))  //CyberP: display special, speed rating & stamina drain
    {
		mod = player.SkillSystem.GetSkillLevel(class'SkillWeaponLowTech');
        if (mod < 3)
          mod = 1;
        else
          mod = 0.5;

		str = weapon.msgSpec;
		stamDrain = weapon.meleeStaminaDrain*mod;
		if (weapon.IsA('WeaponSword'))
		{
			if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0)
			 msgMultiplier = weapon.msgModerate;
			else
			 msgMultiplier = weapon.msgFast;
		}
		else if (weapon.IsA('WeaponCrowbar'))
		{
		  if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 msgMultiplier = weapon.msgFast;
		  else
			 msgMultiplier = weapon.msgVeryFast;
		}
		else if (weapon.IsA('WeaponBaton'))
		{
		  if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 msgMultiplier = weapon.msgSlow;
		  else
			 msgMultiplier = weapon.msgModerate;
		}
		else if (weapon.IsA('WeaponCombatKnife'))
		{
		  if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 msgMultiplier = weapon.msgFast;
		  else
			 msgMultiplier = weapon.msgVeryFast;
		}
		else if (weapon.IsA('WeaponNanoSword'))
		{
		  if (player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 msgMultiplier = weapon.msgModerate;
		  else
			 msgMultiplier = weapon.msgFast;
		}

		if (player.AugmentationSystem != None && player.AugmentationSystem.GetAugLevelValue(class'AugCombat') == -1.0) //RSD: accessed none?
			 AddInfoItem(weapon.msgSpeedR, msgMultiplier,false);
		else
			 AddInfoItem(weapon.msgSpeedR, msgMultiplier,true);

		if (mod != 1)
			AddInfoItem(weapon.msgStamDrain, FormatFloatString(stamDrain,0.01), true);
		else
			AddInfoItem(weapon.msgStamDrain, FormatFloatString(stamDrain,0.01), false);

		AddInfoItem(weapon.msgSpec2,str);
    }

	// mass
	AddInfoItem(weapon.msgInfoMass, FormatFloatString(weapon.Default.Mass, 1.0) @ weapon.msgMassUnit);

	// laser mod
	if (weapon.bCanHaveLaser)
	{
		if (weapon.bHasLaser)
			str = weapon.msgInfoYes;
		else
			str = weapon.msgInfoNo;
	}
	else
	{
		str = weapon.msgInfoNA;
	}
	if (!weapon.bHandToHand)
		AddInfoItem(weapon.msgInfoLaser, str, weapon.bCanHaveLaser && weapon.bHasLaser && (weapon.Default.bHasLaser != weapon.bHasLaser));

	// scope mod
	if (weapon.bCanHaveScope)
	{
		if (weapon.bHasScope)
			str = weapon.msgInfoYes;
		else
			str = weapon.msgInfoNo;
	}
	else
	{
		str = weapon.msgInfoNA;
	}
	if (!weapon.bHandToHand)
		AddInfoItem(weapon.msgInfoScope, str, weapon.bCanHaveScope && weapon.bHasScope && (weapon.Default.bHasScope != weapon.bHasScope));

	// silencer mod
	if (weapon.bCanHaveSilencer)
	{
		if (weapon.bHasSilencer)
			str = weapon.msgInfoYes;
		else
			str = weapon.msgInfoNo;
	}
	else
	{
		str = weapon.msgInfoNA;
	}
	if (!weapon.bHandToHand)
		AddInfoItem(weapon.msgInfoSilencer, str, weapon.bCanHaveSilencer && weapon.bHasSilencer && (weapon.Default.bHasSilencer != weapon.bHasSilencer));

    //CyberP: full-auto mod
    if (!weapon.bHandToHand)
    {
    if (weapon.IsA('WeaponSawedOffShotgun'))
    {
            str = weapon.msgSpec;
            AddInfoItem(weapon.msgSpec2,str);
			str = weapon.msgPump;
    }
	else if (weapon.bFullAuto || weapon.bAutomatic)
	{
			str = weapon.msgFull;
	}
	else
	{
	       str = weapon.msgSemi;
	}
		AddInfoItem(weapon.msgInfoFullAuto, str, weapon.bCanHaveModFullAuto && weapon.bFullAuto && (weapon.Default.bFullAuto != weapon.bFullAuto));
    }
    //Lethality
    if (weapon.IsA('WeaponMiniCrossbow') || weapon.IsA('WeaponSawedOffShotgun') || weapon.IsA('WeaponAssaultShotgun'))
		str= weapon.msgVar;
    else if (weapon.bPenetrating || weapon.IsA('WeaponCrowbar'))
		str= weapon.msgLethal;
    else
		str= weapon.msgNon;

    AddInfoItem(weapon.msgLethality, str);

    //secondary weapon
    if (weapon.bHandToHand && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkInventive').bPerkObtained)
       str = weapon.msgInfoYes;
    else if (weapon.bHandToHand && weapon.GoverningSkill != class'DeusEx.SkillDemolition' && !weapon.IsA('WeaponHideAGun') && !weapon.IsA('WeaponShuriken'))
       str = weapon.msgInfoNo;
    else if (weapon.bHandToHand)
       str = weapon.msgInfoYes;
    else
       str = weapon.msgInfoNo;

    AddInfoItem(weapon.msgSecondary, str);

	// Governing Skill
    //SARGE: Also Weapon requirement
    if (weapon.minSkillRequirement > 0 && player.bWeaponRequirementsMatter)
        AddInfoItem(weapon.msgInfoSkill, weapon.GoverningSkill.default.SkillName @ "(" $ weapon.msgRequires @  player.SkillSystem.GetSkillFromClass(weapon.GoverningSkill).GetLevelString(weapon.minSkillRequirement) $ ")");
    else
        AddInfoItem(weapon.msgInfoSkill, weapon.GoverningSkill.default.SkillName);

    if (weapon.bCanHaveModBaseAccuracy || weapon.bCanHaveModReloadCount || weapon.bCanHaveModAccurateRange || weapon.bCanHaveModReloadTime || weapon.bCanHaveModRecoilStrength || weapon.bCanHaveModShotTime || weapon.bCanHaveModDamage)
	{
		AddLine();
		SetText(weapon.msgAllMods);
		AddLine();

		if (weapon.bCanHaveModReloadCount)
		{
				numMods = Int(Abs(weapon.ModReloadCount) * 10);
				if (weapon.IsA('WeaponProd'))
					AddModInfo(weapon.msgClip, numMods, (numMods == 4), 1);
				else
					AddModInfo(weapon.msgClip, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModShotTime)
		{
				numMods = Int(Abs(weapon.ModShotTime) * 10);
				//winInfo.AddInfoItem("Rate of Fire:", numMods $ "/5", (numMods == 5));
				if (weapon.IsA('WeaponAssaultGun'))
					AddModInfo(weapon.msgRate, numMods, (numMods == 3), 2);
				else
					AddModInfo(weapon.msgRate, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModReloadTime)
		{
				numMods = Int(Abs(weapon.ModReloadTime) * 10);
				//winInfo.AddInfoItem("Reload:", numMods $ "/5", (numMods == 5));
				AddModInfo(weapon.msgRelo, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModDamage)
		{
				numMods = Int(Abs(weapon.ModDamage) * 10);
				AddModInfo(weapon.msgDama, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModRecoilStrength)
		{
				numMods = Int(Abs(weapon.ModRecoilStrength) * 10);
				//winInfo.AddInfoItem("Recoil:", numMods $ "/5", (numMods == 5));
				AddModInfo(weapon.msgReco, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModBaseAccuracy)
		{
				numMods = Int(Abs(weapon.ModBaseAccuracy) * 10);
				if (weapon.IsA('WeaponSawedOffShotgun'))
					AddModInfo(weapon.msgAccu, numMods, (numMods == 2), 3);
				else
					AddModInfo(weapon.msgAccu, numMods, (numMods == 5));
		}

		if (weapon.bCanHaveModAccurateRange)
		{
				numMods = Int(Abs(weapon.ModAccurateRange) * 10);
				//winInfo.AddInfoItem("Range:", numMods $ "/5", (numMods == 5));
				AddModInfo(weapon.msgRang, numMods, (numMods == 5));
		}
		if (weapon.bCanHaveScope) //CyberP: uncomment to add scope, laser, silencer and full-auto for extra fun
		{
		if (weapon.bHasScope)
			AddModInfo(weapon.msgInfoScope, 1, (numMods == 1), 4);
		else
			AddModInfo(weapon.msgInfoScope, 0, (numMods == 1), 4);
		}
		if (weapon.bCanHaveLaser)
		{
		if (weapon.bHasLaser)
			AddModInfo(weapon.msgInfoLaser, 1, (numMods == 1), 4);
		else
			AddModInfo(weapon.msgInfoLaser, 0, (numMods == 1), 4);
		}
		if (weapon.bCanHaveSilencer)
		{
		if (weapon.bHasSilencer)
			AddModInfo(weapon.msgInfoSilencer, 1, (numMods == 1), 4);
		else
			AddModInfo(weapon.msgInfoSilencer, 0, (numMods == 1), 4);
		}
		if (weapon.bCanHaveModFullAuto)
		{
		if (weapon.bFullAuto)
			AddModInfo(weapon.msgInfoFullAuto, 1, (numMods == 1), 4);
		else
			AddModInfo(weapon.msgInfoFullAuto, 0, (numMods == 1), 4);
		}
	}

    if (weapon.bHadLaser || weapon.bHadSilencer || weapon.bHadScope)
    {
        AddLine();
        AddWeaponModButtons(weapon);
        AddWeaponModDrawbacks(weapon);
    }

	AddLine();
	SetText(weapon.Description);

	return true;
}

function bool UpdateWeaponInfo(DeusExWeapon weapon)
{
	if(player == None)
		return false;

    //SARGE: Show modified weapons in title
    if (weapon.bModified && player.bBeltShowModified)
        SetTitle(weapon.ItemName @ "(" $ weapon.strModified $ ")");
    else
        SetTitle(weapon.ItemName);

	if(player.iAltFrobDisplay == 2)
		AddDeclineSecondButtons(weapon, weapon.CanAssignSecondary(player));
	else
	{
		//SARGE: Add Decline Button
		AddDeclineButton(weapon.class);

		//SARGE: Add Secondary Button
		if (weapon.CanAssignSecondary(player))
		   AddSecondaryButton(weapon);
	}

	//SARGE: Add Skins Button
	if (player.WeaponSkinManager.GetSkinCountFor(weapon) > 1)
		AddSkinsButtons(weapon);

	if(player.iAltFrobDisplay == 2)
		WeaponInfoExtended(weapon);
	else
		WeaponInfoVanilla(weapon);
}

function UpdateWpnAmmoInfo(DeusExWeapon weapon, Class<DeusExAmmo> ammoClass)
{
	local string str;
	local int i;

	// Ammo loaded
	if ((weapon.AmmoName != class'AmmoNone') && (!weapon.bHandToHand) && (weapon.ReloadCount != 0))
		UpdateAmmoLoaded(weapon.AmmoType.itemName);

	// ammo info
	if ((weapon.AmmoName == class'AmmoNone') || weapon.bHandToHand || (weapon.ReloadCount == 0))
		str = weapon.msgInfoNA;
	else
		str = weapon.AmmoName.Default.ItemName;

	for (i=0; i<ArrayCount(weapon.AmmoNames); i++)
		if ((weapon.AmmoNames[i] != None) && (weapon.AmmoNames[i] != weapon.AmmoName))
			str = str $ "|n" $ weapon.AmmoNames[i].Default.ItemName;

	UpdateAmmoTypes(str);

	// If this weapon has ammo info, display it here
	if (ammoClass != None)
		UpdateAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);
}

// ----------------------------------------------------------------------

defaultproperties
{
     AmmoLabel="Ammo:"
     AmmoRoundsLabel="Rounds:"
     ShowAmmoDescriptionsLabel="Show Ammo Descriptions"
}
