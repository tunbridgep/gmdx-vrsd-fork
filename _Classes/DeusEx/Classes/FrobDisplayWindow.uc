//=============================================================================
// FrobDisplayWindow.
//=============================================================================
class FrobDisplayWindow extends Window;

var float margin;
var float barLength;

var DeusExPlayer player;

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

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colText;
var const Color colNotEnough;
var const Color colJustEnough;

var localized string msgDoorThreshold; //CyberP: these two vars are for damage threshold display
var localized string msgObjThreshold;
var localized string msgMass;
var localized string msgHP;
var localized string msgHP2;

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
	gc.SetTileColor(colBackground);
	gc.DrawBox(infoX+1, infoY+1, infoW-2, infoH-2, 0, 0, 1, Texture'Solid');
}

//Ygll: some refactoring...! new function to handle window target hud draw
function DrawTargettingBox(GC gc, actor frobTarget)
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
	local float				infoX, infoY, infoW, infoH;
	local string			strInfo, strThreshold;
	local DeusExMover		dxMover;	
	local Color				col;
	local int				numTools;
	local int				ownedTools; //Sarge: How many tools the player owns in their inventory
	
	// get the door's lock and strength info
	dxMover = DeusExMover(frobTarget);
	
	if ((dxMover != None) && dxMover.bLocked)
	{
		strInfo = msgLocked $ CR() $ " " $ msgLockStr;
		
		if (dxMover.bPickable)
			strInfo = strInfo $ "(" $ FormatString(dxMover.lockStrength * 100.0) $ "%)";
		else
			strInfo = strInfo $ "(" $ msgInf $ ")";

		strInfo = strInfo $ CR() $ " " $ msgDoorStr;
		
		if (dxMover.bBreakable)
			strInfo = strInfo $ "(" $ FormatString(dxMover.doorStrength * 100.0) $ "%)";
		else
			strInfo = strInfo $ "(" $ msgInf $ ")";

		//CyberP begin:                                             //RSD: Cool, but only do it if we have the Doorsman perk
		//if (dxMover.bPerkApplied)
		//{
		strInfo = strInfo $ CR() $ " " $ msgDoorThreshold;
		
		if (dxMover.bBreakable)
			strThreshold = "[ " $ FormatString(dxMover.minDamageThreshold) $ " ]";
		else
			strThreshold = "[ " $ msgInf $ " ]";
		//}
		//else strInfo = strInfo $ Cr();
		//CyberP End
	}
	else
	{
		strInfo = msgUnlocked;
		strThreshold = "";
	}

	infoX = boxTLX + 10; //CyberP: both +10
	infoY = boxTLY + 10;

	gc.SetFont(Font'FontMenuSmall_DS');
	gc.GetTextExtent(0, infoW, infoH, strInfo $ strThreshold);
	infoW += 8;
	if ((dxMover != None) && dxMover.bLocked)
		infoW += barLength + 2;
	infoH += 8;
	infoX = FClamp(infoX, infoW/2+10, width-10-infoW/2);
	infoY = FClamp(infoY, infoH/2+10, height-10-infoH/2);

	// draw a dark background
	DrawDarkBackground(gc, infoX, infoY, infoW, infoH);

	// draw the info text
	gc.SetTextColor(colText);
	gc.DrawText(infoX+4, infoY+4, infoW-8, infoH-8, strInfo);
	
	// draw the two highlight boxes
	DrawHightlightBox(gc, infoX, infoY, infoW, infoH);	
		
	if ((dxMover != None) && dxMover.bLocked)
	{
		// draw colored bars for each value
		gc.SetStyle(DSTY_Translucent);
		
		col = GetColorScaled(dxMover.lockStrength);
		gc.SetTileColor(col);
		gc.DrawPattern(infoX+(infoW-barLength-9), infoY+3+(infoH-8)/4, barLength*dxMover.lockStrength, ((infoH-8)/4)-2, 0, 0, Texture'ConWindowBackground');
		
		col = GetColorScaled(dxMover.doorStrength);
		gc.SetTileColor(col);
		gc.DrawPattern(infoX+(infoW-barLength-9), infoY+3+2*(infoH-8)/4, barLength*dxMover.doorStrength, ((infoH-8)/4)-2, 0, 0, Texture'ConWindowBackground');
	
		//Draw the info Door Damage Threshold number
		if ( !dxMover.bBreakable || ( player.bColourCodeFrobDisplay && dxMover.bBreakable &&
				( DeusExWeapon(player.Weapon) == None || ( DeusExWeapon(player.Weapon) != None && !player.BreaksDamageThreshold(DeusExWeapon(player.Weapon),dxMover.minDamageThreshold) ) ) ) )							
		{
			gc.SetTextColor(colNotEnough);
		}
		else
			gc.SetTextColor(colText);

		gc.DrawText(infoX+(infoW-barLength-6), infoY+28+(infoH-8)/4, barLength, ((infoH-8)/4)-2, strThreshold);
		
		// draw the absolute number of lockpicks on top of the colored bar
		if (dxMover.bPickable)
		{
			ownedTools = player.GetInventoryCount('Lockpick');
			numTools = int((dxMover.lockStrength / player.SkillSystem.GetSkillLevelValue(class'SkillLockpicking')) + 0.99);
			
			if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkLocksport').bPerkObtained == true)
				numTools = 1;
			
			if (numTools == 1 && player.iFrobDisplayStyle == 0)
				strInfo = numTools @ msgPick;
			else if (player.iFrobDisplayStyle == 0)
				strInfo = numTools @ msgPicks;
			else if (player.iFrobDisplayStyle == 1)
				strInfo = ownedTools $ "/" $ numTools @ msgPicks;
			else if (player.iFrobDisplayStyle == 2)
				strInfo = numTools $ "/" $ ownedTools @ msgPicks;
			//if (dxMover.bPerkApplied)  
				//RSD: Doorsman perk
			if (ownedTools < numTools && player.bColourCodeFrobDisplay)
				gc.SetTextColor(colNotEnough);
			else if (ownedTools == numTools && player.bColourCodeFrobDisplay)
				gc.SetTextColor(colJustEnough);
			else
				gc.SetTextColor(colText);
			
			gc.DrawText(infoX+(infoW-barLength-3), infoY+4+(infoH-8)/4, barLength, ((infoH-8)/4)-2, strInfo);
			//else
			//	gc.DrawText(infoX+(infoW-barLength-2), infoY+4+(infoH-8)/3, barLength, ((infoH-8)/3)-2, strInfo);
		}
	}
}

//Ygll: new function to handle window target for hacking device classes
function DrawDeviceHudInformation(GC gc, actor frobTarget)
{
	local float				infoX, infoY, infoW, infoH;
	local string			strInfo, strThreshold;
	local HackableDevices	device;	
	local Color				col;
	local int				numTools;
	local int				ownedTools; //Sarge: How many tools the player owns in their inventory
	local Perk				perkCracked; //Sarge: Stores the Cracked perk
	
	// get the devices hack strength info
	device = HackableDevices(frobTarget);
	strInfo = DeusExDecoration(frobTarget).itemName $ CR() $ " " $ msgHackStr;
	
	if (device.bHackable)
	{
		if (device.hackStrength != 0.0)
			strInfo = strInfo $ "(" $ FormatString(device.hackStrength * 100.0) $ "%)";
		else
			strInfo = strInfo $ msgHacked;
	}
	else
	{	
		strInfo = strInfo $ "[ " $ msgInf $ " ]";
	}

	//CyberP begin:                                             //RSD: No damage thresholds on hackable objects, sorry!
	strInfo = strInfo $ CR() $ " " $ msgObjThreshold;
	
	if (device.bInvincible==False)
		strThreshold = "[ " $ FormatString(device.minDamageThreshold) $ " ]";
	else
		strThreshold = "[ " $ msgInf $ " ]";
	//CyberP End				
	
	infoX = boxTLX + 10;
	infoY = boxTLY + 10;

	gc.SetFont(Font'FontMenuSmall_DS');
	gc.GetTextExtent(0, infoW, infoH, strInfo $ strThreshold);
	infoW += 8;
	
	if (device.hackStrength != 0.0)
	{
		infoW += barLength + 2;
	}
	else //Ygll: case when the devise has not hack strength - prevent 'Inf' text misplace on specific situation
	{
		infoW += 10;
	}
	
	infoH += 8;
	infoX = FClamp(infoX, infoW/2+10, width-10-infoW/2);
	infoY = FClamp(infoY, infoH/2+10, height-10-infoH/2);

	// draw a dark background
	DrawDarkBackground(gc, infoX, infoY, infoW, infoH);

	// draw a colored bar
	//Ygll: keep it draw even for 'INF' device to get some proper margin 
	gc.SetStyle(DSTY_Translucent);
	col = GetColorScaled(device.hackStrength);
	gc.SetTileColor(col);
	gc.DrawPattern(infoX+(infoW-barLength-7), infoY-1+infoH/2.7, barLength*device.hackStrength, infoH/2.7-6, 0, 0, Texture'ConWindowBackground'); //CyberP: //RSD: reverted

	// Draw the current text information
	gc.SetTextColor(colText);
	gc.DrawText(infoX+4, infoY+4, infoW-8, infoH-8, strInfo);
	
	// draw the two highlight boxes
	DrawHightlightBox(gc, infoX, infoY, infoW, infoH);
	
	// Draw the Device Damage Threshold
	if (device.hackStrength > 0.0)
	{
		if ( device.bInvincible || ( player.bColourCodeFrobDisplay && !device.bInvincible &&
				( DeusExWeapon(player.Weapon) == None || ( DeusExWeapon(player.Weapon) != None && !player.BreaksDamageThreshold(DeusExWeapon(player.Weapon),device.minDamageThreshold) ) ) ) )
		{
			gc.SetTextColor(colNotEnough);
		}
		else
			gc.SetTextColor(colText);

		gc.DrawText(infoX+(infoW-barLength-2), infoY+18+(infoH-8)/4, barLength, ((infoH-8)/4)-2+6, strThreshold);
	}
	else
	{
		gc.SetTextColor(colNotEnough);
		gc.DrawText(infoX+(infoW-barLength-2), infoY+19+(infoH-8)/4, barLength, ((infoH-8)/4)-2+6, strThreshold);
	}	

	// draw the absolute number of multitools on top of the colored bar
	if ((device.bHackable) && (device.hackStrength != 0.0))
	{
		//SARGE: If we have Cracked, display 0 tools
		perkCracked = player.PerkManager.GetPerkWithClass(class'DeusEx.PerkCracked');
		
		if (device.hackStrength <= perkCracked.PerkValue && perkCracked.bPerkObtained == true)
			numTools = 0;
		else
			numTools = int((device.hackStrength / player.SkillSystem.GetSkillLevelValue(class'SkillTech')) + 0.99);
		ownedTools = player.GetInventoryCount('Multitool');
		if (numTools == 1 && player.iFrobDisplayStyle == 0)
			strInfo = numTools @ msgTool;
		else if (player.iFrobDisplayStyle == 0)
			strInfo = numTools @ msgTools;
		else if (player.iFrobDisplayStyle == 1)
			strInfo = ownedTools $ "/" $ numTools @ msgTools;
		else if (player.iFrobDisplayStyle == 2)
			strInfo = numTools $ "/" $ ownedTools @ msgTools;
		
		if (ownedTools < numTools && player.bColourCodeFrobDisplay)
			gc.SetTextColor(colNotEnough);
		else if (ownedTools == numTools && player.bColourCodeFrobDisplay)
			gc.SetTextColor(colJustEnough);
		else
			gc.SetTextColor(colText);
		
		gc.DrawText(infoX+(infoW-barLength-1), infoY+infoH/2.7, barLength, infoH/2.7-6, strInfo);
		//gc.DrawText(infoX+(infoW-barLength-2), infoY+infoH/2, barLength, infoH/2-6, strInfo); //RSD: reverted
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
	else if (frobTarget.IsA('DeusExCarcass'))
		strInfo = DeusExCarcass(frobTarget).itemName;
	else if (frobTarget.IsA('DeusExAmmo'))                          //RSD: Append the ammo count
		strInfo = DeusExAmmo(frobTarget).itemName @ "(" $ DeusExAmmo(frobTarget).AmmoAmount $ ")";
	else if (frobTarget.IsA('ChargedPickup') && ChargedPickup(frobTarget).numCopies > 1 && player.bShowItemPickupCounts)
		strInfo = ChargedPickup(frobTarget).ItemName @ "(" $ int(ChargedPickup(frobTarget).GetCurrentCharge()) $ "%) (" $ ChargedPickup(frobTarget).numCopies $ ")"; //SARGE: Append the current charge and num copies
	else if (frobTarget.IsA('ChargedPickup'))
		strInfo = ChargedPickup(frobTarget).ItemName @ "(" $ int(ChargedPickup(frobTarget).GetCurrentCharge()) $ "%)"; //RSD: Append the current charge
	else if (frobTarget.IsA('DeusExWeapon'))                    //Sarge: Add "(Modified)" to weapons
		strInfo = DeusExWeapon(frobTarget).GetFrobString(player);
	else if (frobTarget.IsA('DeusExPickup') && DeusExPickup(frobTarget).numCopies > 1 && player.bShowItemPickupCounts)
		strInfo = Inventory(frobTarget).itemName @ "(" $ DeusExPickup(frobTarget).numCopies $ ")"; //SARGE: Append number of copies, if more than 1
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
				strInfo = strInfo $ CR() $ msgHP $ string(DeusExDecoration(frobTarget).HitPoints);
		   else if (frobTarget.IsA('DeusExPickup') && DeusExPickup(frobTarget).bBreakable)
				strInfo = strInfo $ CR() $ msgHP2;
			
		   if (frobTarget.IsA('DeusExDecoration') && DeusExDecoration(frobTarget).bPushable)
		   {
			  typecastIt = (int(frobTarget.Mass));
			  strInfo = strInfo $ CR() $ msgMass $ string(typecastIt) $ " lbs";
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

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------
function DrawWindow(GC gc)
{
	local actor	frobTarget;

	if (player != None)
	{
		frobTarget = player.FrobTarget;
		
		if (frobTarget != None && player.IsHighlighted(frobTarget))
		{
			// draw a cornered targetting box
			DrawTargettingBox(gc, frobTarget);

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
     margin=70.000000
     barLength=50.000000
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
}
