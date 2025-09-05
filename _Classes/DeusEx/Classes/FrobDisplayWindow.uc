//=============================================================================
// FrobDisplayWindow.
//=============================================================================
class FrobDisplayWindow extends Window;

var float margin;
var float barLength;
var DeusExPlayer player;
//Ygll var to use for alternate frob display
var string strDash;
var string strDoubleDot;
var string strOpenValue;
var string strCloseValue;

var localized string msgLocked;
var localized string msgUnlocked;
var localized string msgLockStr;
var localized string msgDoorStr;
var localized string msgHackStr;
var localized string msgInf;
var localized string msgHacked;
var localized string msgPick;
var localized string msgPicks;
var localized string msgTool;
var localized string msgTools;
var localized string msgDisabled;
var localized string msgTrackAll;
var localized string msgTrackAllies;
var localized string msgTrackEnemies;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colText;
var const Color colNotEnough;
var const Color colJustEnough;
var const Color colWireless;
var const Color colHasKey;
var const Color colBadAug;

var localized string msgDoorThreshold; //CyberP: these two vars are for damage threshold display
var localized string msgObjThreshold;
var localized string msgMass;
var localized string msgHP;
var localized string msgHP2;

//SARGE: This is performance heavy, so only check this when the frobtarget changes
var Actor prevFrobTarget;
var Color outlineColour;
var bool bForceRefreshOutlineColour;

//var to stock value during the calculation of the window
var float boxTLX, boxTLY, boxBRX, boxBRY;


// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------
event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colText       = theme.GetColorFromName('HUDColor_HeaderText');
}

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------
function InitWindow()
{
	Super.InitWindow();

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);
	
	boxTLX = 0.0; 
	boxTLY = 0.0; 
	boxBRX = 0.0; 
	boxBRY = 0.0;
	
	StyleChanged();
}

// ----------------------------------------------------------------------
// FormatString()
// ----------------------------------------------------------------------
function string FormatString(float num)
{
	local string tempstr;

	// round up
	num += 0.5;

	tempstr = Left(String(num), 3);

	if (num < 100.0)
		tempstr = Left(String(num), 2);
	if (num < 10.0)
		tempstr = Left(String(num), 1);

	return tempstr;
}

//SARGE: Determine the border colour as follows:
//A green border if we know the code (or have the key) to our frob target.
//A Blue Border when using the wireless strength perk
//A Blue Border when looking at a searched carcass
//A Red Border when picking up and aug canister for an aug we can't use.
//Note: This is a semi-expensive function, so is only called when the frob target changes.
function Color GetFrobDisplayBorderColor(Actor frobTarget)
{
    local Computers C;
    local ATM ATM;
    local DeusExCarcass Carc;
    local DeusExMover M;
    local Keypad K;
    local InformationDevices ID;
    local NanoKey N;
    local DeusExAmmo AM;
    local DeusExWeapon WE;
    local ThrownProjectile TP;
    local int i;
    local int capacity, myammo;
    local Inventory Inv;
    
    //Aug Can stuff
    local AugmentationCannister A;
    local Augmentation aug;
    local bool h1, h2, f1, f2;

    Carc = DeusExCarcass(frobTarget);
    ATM = ATM(frobTarget);
    C = Computers(frobTarget);
    K = Keypad(frobTarget);
    M = DeusExMover(frobTarget);
    A = AugmentationCannister(frobTarget);
    ID = InformationDevices(frobTarget);
    N = NanoKey(frobTarget);
    AM = DeusExAmmo(frobTarget);
    WE = DeusExWeapon(frobTarget);
    TP = ThrownProjectile(frobTarget);
    Inv = Inventory(frobTarget);
    
    //Carcass Searched
    if (Carc != None && player.iSearchedCorpseText >= 2 && Carc.bSearched && !Carc.bAnimalCarcass)
        return colWireless;
    
    //Duplicate Keys
    else if (player.iToolWindowShowDuplicateKeys >= 2 && N != None && player.KeyRing != None && player.KeyRing.HasKey(N.KeyID))
        return colBadAug;
        //return colWireless;
    
    //Wireless Perk
    else if (frobTarget == player.HackTarget)
        return colWireless;

    //uninstallable aug - either we already have both, or the slot is full
    else if (player.bToolWindowShowAugState && A != None && player.AugmentationSystem != None)
    {
        aug = A.GetAugGeneric(0,player);
        h1 = aug.bHasIt;
        f1 = player.AugmentationSystem.AreSlotsFull(aug);
        aug = A.GetAugGeneric(1,player);
        h2 = aug.bHasIt;
        f2 = player.AugmentationSystem.AreSlotsFull(aug);

        //player.ClientMessage("Augie: " $ h1 $ ":" $ f1 $ ", " $ h2 $ ":" $ f2);
        
        //If we have both augs, and slots are full, then the can is unusable, so return red
        if (h1 && f1 && h2 && f2)
            return colBadAug;

        //if we have only one of them, and slots are full, then we can replace, so return blue
        if ((h1 && f2) || (h2 && f1))
            return colWireless;
    }

    //Cannot disarm grenade
    else if (TP != None && !TP.CanRearm(player))
        return colBadAug;

    //Book/Datacube/etc has been read.
    else if (player.bToolWindowShowRead && ID != None && ID.IsRead(player))
        return colWireless;
    
    //Show red for invalid item pickups (not enough space, stack full, etc)
    //This has to go pretty late in the list because most other things are Inventory items as well
    if (player.bToolWindowShowInvalidPickup && Inv != None)
    {
        //Some items need special handling
        if (Inv.IsA('Credits') || Inv.IsA('NanoKey'))
        {
            //Do Nothing
        }
        
        //Stack is full and we can't recharge
        else if (Inv.IsA('ChargedPickup') && player.GetInventoryCount(Inv.class.name) >= ChargedPickup(Inv).RetMaxCopies() && ChargedPickup(Inv).GetCurrentCharge() > 99)
            return colBadAug;

        //Stack is full
        else if (Inv.IsA('DeusExPickup') && player.GetInventoryCount(Inv.class.name) >= DeusExPickup(Inv).RetMaxCopies() && DeusExPickup(Inv).bCanHaveMultipleCopies)
            return colBadAug;
        
        //Weapons and Ammo show BLUE when able to be patially looted, and Red if they can't be looted at all.
        else if (AM != None)
        {
            capacity = player.GetAdjustedMaxAmmo(AM);
            myammo = player.GetInventoryCount(AM.class.name);

            //player.ClientMessage("Capacity: " $ capacity $ ", myAmmo: " $ myAmmo $ " (" $ AM.class $ ")");

            if (myammo == capacity)
                return colBadAug;
            else if (capacity - myammo < AM.AmmoAmount)
                return colWireless;
        }
        else if (WE != None && WE.PickupAmmoCount > 0)
        {
            AM = DeusExAmmo(player.FindInventoryType(WE.AmmoName));
            if (AM != None)
                capacity = player.GetAdjustedMaxAmmo(AM);
            
            //player.ClientMessage("Capacity: " $ capacity $ ", myAmmo: " $ AM $ " (" $ AM.class $ ")");
            if (capacity > 0)
            {
                myammo = AM.AmmoAmount;

                if (myammo == capacity)
                    return colBadAug;
                else if (capacity - myammo < WE.PickupAmmoCount)
                    return colWireless;
            }
        }

        //Not enough space
        if (capacity == 0 && player.FindInventoryType(Inv.Class) == None && !player.FindInventorySlot(Inv, True))
            return colBadAug;

        //Can carry only 1
        if (WE != None && player.FindInventoryType(WE.Class) != None && (WE.AmmoName == None || WE.AmmoName == class'DeusEx.AmmoNone'))
            return colBadAug;
    }


    else if (player.bToolWindowShowKnownCodes && !player.bHardcoreMode && player.iNoKeypadCheese == 0)
    {
        //We have code for Keypad
        if (K != None && K.bHackable && K.hackStrength > 0.0 && K.IsDiscovered(player,K.validCode,,true))
            return colHasKey;

        //We have Key for Door
        else if (M != None && M.bLocked && M.HasKey(player))
            return colHasKey;
    
        //We have computer login
        if (C != None)
        {
            for(i = 0;i < 8;i++)
                if (C.IsDiscovered(player,C.GetUsername(i),C.GetPassword(i),true))
                    return colHasKey;
        }
        
        //We have ATM login (why the fuck does this not extend Computers?)
        if (ATM != None)
        {
            for(i = 0;i < 8;i++)
                if (ATM.IsDiscovered(player,ATM.GetAccountNumber(i),ATM.GetPIN(i),true))
                    return colHasKey;
        }
    }

    return colBackground;
}

//Ygll: utility function to draw the dark backbround of the hud window
function DrawDarkBackground(GC gc, float infoX, float infoY, float infoW, float infoH)
{
	// draw a dark background
	gc.SetStyle(DSTY_Modulated);
	gc.SetTileColorRGB(0, 0, 0);
	gc.DrawPattern(infoX, infoY, infoW, infoH, 0, 0, Texture'ConWindowBackground');
}

//Ygll: utility function to draw hightlight box
function DrawHightlightBox(GC gc, float infoX, float infoY, float infoW, float infoH)
{
	// draw the two highlight boxes
	gc.SetStyle(DSTY_Translucent);
	gc.SetTileColor(colBorder);
	gc.DrawBox(infoX, infoY, infoW, infoH, 0, 0, 1, Texture'Solid');

    //Set color
    gc.SetTileColor(outlineColour);

	gc.DrawBox(infoX+1, infoY+1, infoW-2, infoH-2, 0, 0, 1, Texture'Solid');
}

//Ygll: some refactoring...! new function to handle window target hud draw
function DrawTargetingBox(GC gc, actor frobTarget)
{
	local Mover 	M;
	local int		i, j, k, offset;
	local float		corner, x, y;
	local float		boxCX, boxCY, boxW, boxH;
	local Vector	centerLoc, v1, v2;
	
	// move the box in and out based on time
	offset = (24.0 * (frobTarget.Level.TimeSeconds % 0.3));

	// draw a cornered targetting box
	// get the center of the object
	M = Mover(frobTarget);
	if (M != None)
	{
		M.GetBoundingBox(v1, v2, False, M.KeyPos[M.KeyNum]+M.BasePos, M.KeyRot[M.KeyNum]+M.BaseRot);
		centerLoc = v1 + (v2 - v1) * 0.5;
		v1.X = 16;
		v1.Y = 16;
		v1.Z = 16;
	}
	else
	{
		centerLoc = frobTarget.Location;
		v1.X = frobTarget.CollisionRadius;
		v1.Y = frobTarget.CollisionRadius;
		v1.Z = frobTarget.CollisionHeight;
	}

	ConvertVectorToCoordinates(centerLoc, boxCX, boxCY);

	boxTLX = boxCX;
	boxTLY = boxCY;
	boxBRX = boxCX;
	boxBRY = boxCY;

	// get the smallest box to enclose actor
	// modified from Scott's ActorDisplayWindow
	for (i=-1; i<=1; i+=2)
	{
		for (j=-1; j<=1; j+=2)
		{
			for (k=-1; k<=1; k+=2)
			{
				v2 = v1;
				v2.X *= i;
				v2.Y *= j;
				v2.Z *= k;
				v2.X += centerLoc.X;
				v2.Y += centerLoc.Y;
				v2.Z += centerLoc.Z;

				if (ConvertVectorToCoordinates(v2, x, y))
				{
					boxTLX = FMin(boxTLX, x);
					boxTLY = FMin(boxTLY, y);
					boxBRX = FMax(boxBRX, x);
					boxBRY = FMax(boxBRY, y);
				}
			}
		}
	}

	if (!frobTarget.IsA('Mover'))
	{
		boxTLX += frobTarget.CollisionRadius / 3.5;     //CyberP: all was 4
		boxTLY += frobTarget.CollisionHeight / 3.5;
		boxBRX -= frobTarget.CollisionRadius / 3.5;
		boxBRY -= frobTarget.CollisionHeight / 3.5;
	}

	boxTLX = FClamp(boxTLX, margin, width-margin);
	boxTLY = FClamp(boxTLY, margin, height-margin);
	boxBRX = FClamp(boxBRX, margin, width-margin);
	boxBRY = FClamp(boxBRY, margin, height-margin);

	boxW = boxBRX - boxTLX;
	boxH = boxBRY - boxTLY;

	// scale the corner based on the size of the box
	corner = FClamp((boxW + boxH) * 0.1, 4.0, 40.0);

	// make sure the box doesn't invert itself
	if (boxBRX - boxTLX < corner)
	{
		boxTLX -= (corner+4);
		boxBRX += (corner+4);
	}
	
	if (boxBRY - boxTLY < corner)
	{
		boxTLY -= (corner+4);
		boxBRY += (corner+4);
	}

	// draw the drop shadow first, then normal
	gc.SetTileColorRGB(0,0,0);
	
	for (i=1; i>=0; i--)
	{
		gc.DrawBox(boxTLX+i+offset, boxTLY+i+offset, corner, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxTLX+i+offset, boxTLY+i+offset, 1, corner, 0, 0, 1, Texture'Solid');

		gc.DrawBox(boxBRX+i-corner-offset, boxTLY+i+offset, corner, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxBRX+i-offset, boxTLY+i+offset, 1, corner, 0, 0, 1, Texture'Solid');

		gc.DrawBox(boxTLX+i+offset, boxBRY+i-offset, corner, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxTLX+i+offset, boxBRY+i-corner-offset, 1, corner, 0, 0, 1, Texture'Solid');

		gc.DrawBox(boxBRX+i-corner+1-offset, boxBRY+i-offset, corner, 1, 0, 0, 1, Texture'Solid');
		gc.DrawBox(boxBRX+i-offset, boxBRY+i-corner-offset, 1, corner, 0, 0, 1, Texture'Solid');

		gc.SetTileColor(colText);
	}
}

//Ygll: new function to handle window target for door classes
function DrawDoorHudInformation(GC gc, actor frobTarget)
{
	local float				infoX, infoY, infoW, infoH, infoHtemp, barSize; //Ygll: infoHtemp is only used to stock a value we don't want to use for the H value of the window
	local string			strInfo, strThreshold, strMessInf, strColInfo;
	local DeusExMover		dxMover;	
	local Color				col;
	local int				numTools;
	local int				ownedTools; //Sarge: How many tools the player owns in their inventory
	
	// get the door's lock and strength info
	dxMover = DeusExMover(frobTarget);
	barSize = barLength;
	strMessInf = msgInf;
	
	if ((dxMover != None) && dxMover.bLocked)
	{		
		strInfo = msgLocked $ strDoubleDot $ CR() $ strDash $ msgLockStr;
		strInfo = strInfo $ CR() $ strDash $ msgDoorStr;

		//CyberP begin:                                             //RSD: Cool, but only do it if we have the Doorsman perk
		strInfo = strInfo $ CR() $ strDash $ msgDoorThreshold;
		
		if (dxMover.bBreakable)
			strThreshold = strOpenValue $ FormatString(dxMover.minDamageThreshold) $ strCloseValue;
		else
			strThreshold = strOpenValue $ strMessInf $ strCloseValue;
		//CyberP End
		
		strColInfo = strDash $ msgLockStr $ CR() $ strDash $ msgDoorStr $ CR() $ strDash $ msgDoorThreshold; //Ygll: text block corresponding to the info lines of the object, to place properly value colone later
		
		if(!dxMover.bPickable && !dxMover.bBreakable)
			barSize = 35.000000;
	}
	else
	{
		barSize = -8.000000;
		strInfo = msgUnlocked;
		strThreshold = "";
	}

	infoX = boxTLX + 10; //CyberP: both +10
	infoY = boxTLY + 10;

	gc.SetFont(Font'FontMenuSmall_DS');
	gc.GetTextExtent(0, infoW, infoH, strInfo);
	infoH += 8;
	infoW += barSize + 16;
	infoX = FClamp(infoX, infoW/2+10, width-10-infoW/2);
	infoY = FClamp(infoY, infoH/2+10, height-10-infoH/2);

	// draw a dark background
	DrawDarkBackground(gc, infoX, infoY, infoW, infoH);
	// draw the two highlight boxes
	DrawHightlightBox(gc, infoX, infoY, infoW, infoH);

	// draw the info text
	gc.SetTextColor(colText);	
	gc.DrawText(infoX+4, infoY+4, infoW-8, infoH-8, strInfo);
		
	if ((dxMover != None) && dxMover.bLocked)
	{
		gc.GetTextExtent(0, infoW, infoHtemp, strColInfo);
		infoW += barSize + 16;

		// draw colored bars for each value
		gc.SetStyle(DSTY_Translucent);

		col = GetColorScaled(dxMover.lockStrength);
		gc.SetTileColor(col);
		gc.DrawPattern(infoX+(infoW-barSize-7), infoY+3+(infoH-8)/4, barSize*dxMover.lockStrength, ((infoH-8)/4)-2, 0, 0, Texture'ConWindowBackground');

		col = GetColorScaled(dxMover.doorStrength);
		gc.SetTileColor(col);
		gc.DrawPattern(infoX+(infoW-barSize-7), infoY+3+2*(infoH-8)/4, barSize*dxMover.doorStrength, ((infoH-8)/4)-2, 0, 0, Texture'ConWindowBackground');

		//Draw the info Door Damage Threshold number
		if ( !dxMover.bBreakable || ( player.bToolWindowShowQuantityColours && dxMover.bBreakable &&
				( DeusExWeapon(player.Weapon) == None || ( DeusExWeapon(player.Weapon) != None && !player.BreaksDamageThreshold(DeusExWeapon(player.Weapon),dxMover.minDamageThreshold) ) ) ) )							
		{
			gc.SetTextColor(colNotEnough);
		}
		else
			gc.SetTextColor(colText);

		gc.DrawText(infoX+(infoW-barSize-6), infoY+28+(infoH-8)/4, barSize, ((infoH-8)/4)-2, strThreshold);

		// draw the absolute number of lockpicks on top of the colored bar
		if (dxMover.bPickable)
		{
			ownedTools = player.GetInventoryCount('Lockpick');
			numTools = int((dxMover.lockStrength / player.SkillSystem.GetSkillLevelValue(class'SkillLockpicking')) + 0.99);

			if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkLocksport').bPerkObtained == true)
				numTools = 1;

			if (player.iFrobDisplayStyle == 1)
				strInfo = ownedTools $ "/" $ numTools @ msgPicks;
			else if (player.iFrobDisplayStyle == 2)
				strInfo = numTools $ "/" $ ownedTools @ msgPicks;
			else
			{
				if (numTools == 1)
					strInfo = numTools @ msgPick;
				else
					strInfo = numTools @ msgPicks;
			}

			if (ownedTools < numTools && player.bToolWindowShowQuantityColours)
				gc.SetTextColor(colNotEnough);
			else if (ownedTools == numTools && player.bToolWindowShowQuantityColours)
				gc.SetTextColor(colJustEnough);
			else
				gc.SetTextColor(colText);

			if(player.iAltFrobDisplay == 2)
			{
				strInfo =  strInfo $ " (" $ FormatString(dxMover.lockStrength * 100.0) $ "%)";
			}
			else
			{
				strInfo = FormatString(dxMover.lockStrength * 100.0) $ "% - " $ strInfo;
			}

			gc.DrawText(infoX+(infoW-barSize-3), infoY+4+(infoH-8)/4, barSize, ((infoH-8)/4)-2, strInfo);

			// draw the door strenght value
			if (dxMover.bBreakable)
				strInfo = FormatString(dxMover.doorStrength * 100.0) $ "%";
			else
				strInfo = strMessInf;			

			gc.SetTextColor(colText);
			gc.DrawText(infoX+(infoW-barSize-3), infoY+4+2*(infoH-8)/4, barSize, ((infoH-8)/4)-2, strInfo);
		}
		else
		{
			gc.SetTextColor(colText);
			
			// draw the absolute number of lockpicks on top of the colored bar
			strInfo = strMessInf;			
			gc.DrawText(infoX+(infoW-barSize-3), infoY+4+(infoH-8)/4, barSize, ((infoH-8)/4)-2, strInfo);
				
			// draw the door strenght value
			if (dxMover.bBreakable)
				strInfo = FormatString(dxMover.doorStrength * 100.0) $ "%";
			else
			{
				strInfo = strMessInf;				
			}			
						
			gc.DrawText(infoX+(infoW-barSize-3), infoY+4+2*(infoH-8)/4, barSize, ((infoH-8)/4)-2, strInfo);
		}
	}
}

//Ygll: new function to handle window target for hacking device classes
function DrawDeviceHudInformation(GC gc, actor frobTarget)
{
	local float				infoX, infoY, infoW, infoH, infoHtemp, barSize, extendWName, extendHName, extendWInfo, extendHInfo, marginTextValue;
	local string			strInfo, strThreshold, strInfoBlock;
	local HackableDevices	device;	
	local Color				col;
	local int				numTools, ownedTools; //Sarge: How many tools the player owns in their inventory
	local Perk				perkCracked; //Sarge: Stores the Cracked perk
	
	// get the devices hack strength info
	device = HackableDevices(frobTarget);
	
	barSize = barLength;
	marginTextValue = barSize/3.0;
	//Ygll: case when the devise has not hack strength - prevent 'Inf' text misplace on specific situation
	if (!device.bHackable || device.hackStrength == 0.0)
		barSize = 45.00000;		

	strInfo = DeusExDecoration(frobTarget).itemName $ strDoubleDot;
	
	if( ( frobTarget.IsA('AutoTurretGun') && frobTarget.Owner != None && frobTarget.Owner.IsA('AutoTurret') && AutoTurret(frobTarget.Owner).bRebooting )
			|| ( frobTarget.IsA('SecurityCamera') && SecurityCamera(frobTarget).bRebooting ) )
	{
		strInfo = strInfo $ " (" $ msgDisabled $ ")";
		
		if (!device.bHackable || device.hackStrength == 0.0)
			marginTextValue = barSize/4.2;
		else
			marginTextValue = barSize/3.4;
	}	
	else if( frobTarget.IsA('AutoTurretGun') && frobTarget.Owner != None && frobTarget.Owner.IsA('AutoTurret') && !AutoTurret(frobTarget.Owner).bRebooting && AutoTurret(frobTarget.Owner).bActive && !AutoTurret(frobTarget.Owner).bDisabled)			
	{
		if( !AutoTurret(frobTarget.Owner).bTrackPlayersOnly && !AutoTurret(frobTarget.Owner).bTrackPawnsOnly )    //Ygll: the turret is actually tracking everyone
			strInfo = strInfo $ " (" $ msgTrackAll $ ")";
		else if( AutoTurret(frobTarget.Owner).bTrackPlayersOnly && !AutoTurret(frobTarget.Owner).bTrackPawnsOnly ) //Ygll: the turret track the player
			strInfo = strInfo $ " (" $ msgTrackAllies $ ")";
		else if( !AutoTurret(frobTarget.Owner).bTrackPlayersOnly && AutoTurret(frobTarget.Owner).bTrackPawnsOnly ) //Ygll: the turret track enemies
			strInfo = strInfo $ " (" $ msgTrackEnemies $ ")";

		if (!device.bHackable || device.hackStrength == 0.0)
			marginTextValue = barSize/1.6;
		else
			marginTextValue = barSize/3.0;
	}
	
	//We check the extend value for this text
	gc.GetTextExtent(0, extendWName, extendHName, strInfo);
	
	strInfoBlock = strDash $ msgHackStr $ CR() $ strDash $ msgObjThreshold;
	
	//CyberP begin:                                             //RSD: No damage thresholds on hackable objects, sorry!
	strInfo = strInfo $ CR() $ strInfoBlock;
	
	if (!device.bInvincible)
		strThreshold = strOpenValue $ FormatString(device.minDamageThreshold) $ strCloseValue;
	else
		strThreshold = strOpenValue $ msgInf $ strCloseValue;
	//CyberP End
	
	infoX = boxTLX + 10;
	infoY = boxTLY + 10;

	gc.SetFont(Font'FontMenuSmall_DS');
	gc.GetTextExtent(0, infoW, infoH, strInfo);		
	infoH += 8;	
	
	//We check the extend value for this text
	gc.GetTextExtent(0, extendWInfo, extendHInfo, strInfoBlock);
	
	infoW = extendWInfo + barSize + 14;
	if( infoW <= extendWName ) //here we test extendWName + 4 to think about margin
	{
		infoW = extendWName - marginTextValue;
	}
	
	infoX = FClamp(infoX, infoW/2+10, width-10-infoW/2);
	infoY = FClamp(infoY, infoH/2+10, height-10-infoH/2);
	
	// draw a dark background
	DrawDarkBackground(gc, infoX, infoY, infoW, infoH);
	// draw the two highlight boxes
	DrawHightlightBox(gc, infoX, infoY, infoW, infoH);
	
	// Draw the current text information	
	gc.SetTextColor(colText);
	gc.DrawText(infoX+4, infoY+4, infoW, infoH-8, strInfo);

	//Ygll: text block corresponding to the info lines of the object, to place properly value text next to it
	infoW = extendWInfo + barSize + 4;
	
	// Draw the Device Damage Threshold
	if ( device.bInvincible || ( player.bToolWindowShowQuantityColours && !device.bInvincible &&
			( DeusExWeapon(player.Weapon) == None || ( DeusExWeapon(player.Weapon) != None && !player.BreaksDamageThreshold(DeusExWeapon(player.Weapon),device.minDamageThreshold) ) ) ) )
	{
		gc.SetTextColor(colNotEnough);
	}
	else
		gc.SetTextColor(colText);

	gc.DrawText(infoX+(infoW-barSize+5), infoY+19+(infoH-8)/4, barSize, ((infoH-8)/4)+5, strThreshold);

	// draw the absolute number of multitools on top of the colored bar
	if (device.DisplayHackText())
	{
		// draw a colored bar
		gc.SetStyle(DSTY_Translucent);
		col = GetColorScaled(device.hackStrength);
		gc.SetTileColor(col);
		gc.DrawPattern(infoX+(infoW-barSize+4), infoY-1+infoH/2.7, barSize*device.hackStrength, ((infoH-8)/4), 0, 0, Texture'ConWindowBackground'); //CyberP: //RSD: reverted

		//SARGE: If we have Cracked, display 0 tools
		perkCracked = player.PerkManager.GetPerkWithClass(class'DeusEx.PerkCracked');
		ownedTools = player.GetInventoryCount('Multitool');

		if (device.hackStrength <= perkCracked.PerkValue && perkCracked.bPerkObtained == true)
			numTools = 0;
		else
			numTools = int((device.hackStrength / player.SkillSystem.GetSkillLevelValue(class'SkillTech')) + 0.99);		
		
		if (player.iFrobDisplayStyle == 1)
			strInfo = ownedTools $ "/" $ numTools @ msgTools;
		else if (player.iFrobDisplayStyle == 2)
			strInfo = numTools $ "/" $ ownedTools @ msgTools;
		else 
		{
			if (numTools == 1)
				strInfo = numTools @ msgTool;
			else
				strInfo = numTools @ msgTools;
		}

		if (ownedTools < numTools && player.bToolWindowShowQuantityColours)
			gc.SetTextColor(colNotEnough);
		else if (ownedTools == numTools && player.bToolWindowShowQuantityColours)
			gc.SetTextColor(colJustEnough);
		else
			gc.SetTextColor(colText);

		if(player.iAltFrobDisplay == 2)
		{
			strInfo =  strInfo $ " (" $ FormatString(device.hackStrength * 100.0) $ "%)";
		}
		else
		{
			strInfo = FormatString(device.hackStrength * 100.0) $ "% - " $ strInfo;
		}

		gc.DrawText(infoX+(infoW-barSize+8), infoY+infoH/2.7, barSize, ((infoH-8)/4)+4, strInfo);
	}
	else
	{
		if (device.bHackable)
		{
			strInfo = msgHacked;
		}
		else
		{	
			strInfo = msgInf;
		}
		
		gc.SetTextColor(colText);
		gc.DrawText(infoX+(infoW-barSize+4), infoY+infoH/2.8, barSize, ((infoH-8)/4)+4, strInfo);
	}	
}

//Ygll: new function to handle window target for other type classes
function DrawOtherHudInformation(GC gc, actor frobTarget)
{
	local float				infoX, infoY, infoW, infoH;
	local string			strInfo;
	local int 				typecastIt;
	
	// TODO: Check familiar vs. unfamiliar flags	
	if (frobTarget.IsA('Pawn'))
		strInfo = player.GetDisplayName(frobTarget);
	else if (frobTarget.IsA('InformationDevices')) //SARGE: Show book title etc.
		strInfo = InformationDevices(frobTarget).GetFrobString(player);
	else if (frobTarget.IsA('DeusExCarcass'))
		strInfo = DeusExCarcass(frobTarget).GetFrobString(player);
    else if (frobTarget.IsA('AugmentationCannister'))                          //SARGE: Append the Augs to the display
        strInfo = GetAugCanInformation(AugmentationCannister(frobTarget));
	else if (frobTarget.IsA('DeusExPickup')) //SARGE: Show copies, nano key names, and much more
        strInfo = DeusExPickup(frobTarget).GetFrobString(player);
	else if (frobTarget.IsA('DeusExAmmo'))                          //RSD: Append the ammo count
		strInfo = DeusExAmmo(frobTarget).itemName @ "(" $ DeusExAmmo(frobTarget).AmmoAmount $ ")";
	else if (frobTarget.IsA('DeusExWeapon'))                    //Sarge: Add "(Modified)" to weapons
		strInfo = DeusExWeapon(frobTarget).GetFrobString(player);
	else if (frobTarget.IsA('Inventory'))
		strInfo = Inventory(frobTarget).itemName;
	else if (frobTarget.IsA('DeusExDecoration'))
		strInfo = player.GetDisplayName(frobTarget);
	else if (frobTarget.IsA('DeusExProjectile'))
		strInfo = DeusExProjectile(frobTarget).itemName;
	else
		strInfo = "DEFAULT ACTOR NAME - REPORT THIS AS A BUG - " $ frobTarget.GetItemName(String(frobTarget.Class));

	if (player.bExtraObjectDetails)
	{
		if (frobTarget.IsA('DeusExDecoration') || frobTarget.IsA('DeusExPickup'))
		{
		   if (frobTarget.IsA('DeusExDecoration') && DeusExDecoration(frobTarget).bInvincible == False)
				strInfo = strInfo $ strDoubleDot $ CR() $ strDash $ msgHP $ string(DeusExDecoration(frobTarget).HitPoints);
		   else if (frobTarget.IsA('DeusExPickup') && DeusExPickup(frobTarget).bBreakable)
				strInfo = strInfo $ strDoubleDot $ CR() $ strDash $ msgHP2;
			
		   if (frobTarget.IsA('DeusExDecoration') && DeusExDecoration(frobTarget).bPushable)
		   {
			  typecastIt = (int(frobTarget.Mass));
			  strInfo = strInfo $ CR() $ strDash $ msgMass $ string(typecastIt) $ " lbs";
		   }
		}
	}

	infoX = boxTLX + 10;
	infoY = boxTLY + 10;

	gc.SetFont(Font'FontMenuSmall_DS');
	gc.GetTextExtent(0, infoW, infoH, strInfo);
	infoW += 8;
	infoH += 8;
	infoX = FClamp(infoX, infoW/2+10, width-10-infoW/2);
	infoY = FClamp(infoY, infoH/2+10, height-10-infoH/2);

	// draw a dark background
	DrawDarkBackground(gc, infoX, infoY, infoW, infoH);	

	// draw the text
	gc.SetTextColor(colText);
	gc.DrawText(infoX+4, infoY+4, infoW-8, infoH-8, strInfo);

	// draw the two highlight boxes
	DrawHightlightBox(gc, infoX, infoY, infoW, infoH);	
}

//SARGE: Draw Augmentation Cannister Information
function string GetAugCanInformation(AugmentationCannister can)
{
	local Augmentation aug;
	local Int canIndex;
	local string retStr;

    if (can == None)
        return "";

    retStr = can.itemName $ strDoubleDot;

	for(canIndex=0; canIndex<ArrayCount(can.AddAugs); canIndex++)
    {
        aug = can.GetAugGeneric(canIndex,player);
        retStr = retStr $ CR() $ strDash $ aug.GetName(true);
    }

    return retStr;
}


//Ygll utility function
function SetBarLength(DeusExPlayer player)
{
	boxTLX = 0.0; 
	boxTLY = 0.0; 
	boxBRX = 0.0; 
	boxBRY = 0.0;
			
	if(player.iFrobDisplayStyle > 0)
	{
		barLength = 82.000000;
	}
	else
	{
		barLength = 72.000000;
	}
}

function SetAtlDisplay(DeusExPlayer player)
{
	if(player.iAltFrobDisplay == 2)
	{
		strDash = "-";
		strDoubleDot = ":";
		strOpenValue = "[ ";
		strCloseValue = " ]";
	}
	else
	{
		if(player.iAltFrobDisplay == 1)
			strDash = " ";
		else
			strDash = "";
		
		strDoubleDot = "";
		strOpenValue = "";
		strCloseValue = "";
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------
function DrawWindow(GC gc)
{
	local actor	frobTarget;

	if (player != None)
	{
		frobTarget = player.FrobTarget;
        if (frobTarget != prevFrobTarget || bForceRefreshOutlineColour)
        {
            prevFrobTarget = frobTarget;
            outlineColour = GetFrobDisplayBorderColor(frobTarget);
            bForceRefreshOutlineColour = false;
        }
		
		if (frobTarget != None && player.IsHighlighted(frobTarget))
		{
			SetBarLength(player);
			SetAtlDisplay(player);
			
			// draw a cornered targeting box
			DrawTargetingBox(gc, frobTarget);

			// draw object-specific info
			if (frobTarget.IsA('Mover'))
			{
				DrawDoorHudInformation(gc, frobTarget);
			}
			else if (frobTarget.IsA('HackableDevices'))
			{
				DrawDeviceHudInformation(gc, frobTarget);
			}
			else if (!frobTarget.bStatic && player.bObjectNames)
			{
				DrawOtherHudInformation(gc, frobTarget);
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
	strDash=""
	strDoubleDot=""
	strOpenValue=""
	strCloseValue=""
    margin=70.000000
    barLength=78.000000
    msgLocked="Locked"
    msgUnlocked="Unlocked"
    msgLockStr="Lock Str: "
    msgDoorStr="Door Str: "
    msgHackStr="Bypass Str: "
	msgInf="INF"
	msgHacked="Bypassed"
	msgPick="pick"
	msgPicks="picks"
	msgTool="tool"
	msgTools="tools"
	msgDoorThreshold="Damage Threshold: "
	msgObjThreshold="Damage Threshold: "
	msgMass="Mass: "
	msgHP="Hitpoints: "
	msgHP2="Hitpoints: 3"
	colNotEnough=(R=255,G=50,B=50)
	colJustEnough=(R=255,G=255,B=50)
    colWireless=(B=255,G=50,R=50)
    colHasKey=(B=50,G=150,R=50)
    colBadAug=(B=50,G=50,R=255)
	msgDisabled="Rebooting"
	msgTrackAll="Target: All"
	msgTrackAllies="Target: Allies"
	msgTrackEnemies="Target: Enemies"
}
