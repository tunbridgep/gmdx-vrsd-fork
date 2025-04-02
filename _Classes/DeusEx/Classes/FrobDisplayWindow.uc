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
var localized string msgDisabled;

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
		strInfo = msgLocked $ CR() $ " " $ msgLockStr;
		strInfo = strInfo $ CR() $ " " $ msgDoorStr;

		//CyberP begin:                                             //RSD: Cool, but only do it if we have the Doorsman perk
		strInfo = strInfo $ CR() $ " " $ msgDoorThreshold;
		
		if (dxMover.bBreakable)
			strThreshold = "[ " $ FormatString(dxMover.minDamageThreshold) $ " ]";
		else
			strThreshold = "[ " $ strMessInf $ " ]";
		//CyberP End
		
		strColInfo = " " $ msgLockStr $ CR() $ " " $ msgDoorStr $ CR() $ " " $ msgDoorThreshold; //Ygll: text block corresponding to the info lines of the object, to place properly value colone later
		
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
		if ( !dxMover.bBreakable || ( player.bColourCodeFrobDisplay && dxMover.bBreakable &&
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

			if (ownedTools < numTools && player.bColourCodeFrobDisplay)
				gc.SetTextColor(colNotEnough);
			else if (ownedTools == numTools && player.bColourCodeFrobDisplay)
				gc.SetTextColor(colJustEnough);
			else
				gc.SetTextColor(colText);
			
			strInfo = FormatString(dxMover.lockStrength * 100.0) $ "% - " $ strInfo;
			
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
	local float				infoX, infoY, infoW, infoH, infoHtemp, barSize;
	local string			strInfo, strThreshold;
	local HackableDevices	device;	
	local Color				col;
	local int				numTools;
	local int				ownedTools; //Sarge: How many tools the player owns in their inventory
	local Perk				perkCracked; //Sarge: Stores the Cracked perk
	
	// get the devices hack strength info
	device = HackableDevices(frobTarget);
	
	barSize = barLength;
	//Ygll: case when the devise has not hack strength - prevent 'Inf' text misplace on specific situation
	if (device.hackStrength == 0.0)
	{
		barSize = 50.00000;		
	}

	strInfo = DeusExDecoration(frobTarget).itemName;
	
	if( ( frobTarget.IsA('AutoTurretGun') && frobTarget.Owner != None && frobTarget.Owner.IsA('AutoTurret') && AutoTurret(frobTarget.Owner).bRebooting )
			|| ( frobTarget.IsA('SecurityCamera') && SecurityCamera(frobTarget).bRebooting ) )
	{
		strInfo = strInfo $ " (" $ msgDisabled $ ")";
	}
	
	strInfo = strInfo $ CR() $ " " $ msgHackStr;
	
	//CyberP begin:                                             //RSD: No damage thresholds on hackable objects, sorry!
	strInfo = strInfo $ CR() $ " " $ msgObjThreshold;
	
	if (!device.bInvincible)
		strThreshold = "[ " $ FormatString(device.minDamageThreshold) $ " ]";
	else
		strThreshold = "[ " $ msgInf $ " ]";
	//CyberP End
	
	infoX = boxTLX + 10;
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
	
	// Draw the current text information	
	gc.SetTextColor(colText);
	gc.DrawText(infoX+4, infoY+4, infoW-8, infoH-8, strInfo);
	
	gc.GetTextExtent(0, infoW, infoHtemp, " " $ msgHackStr $ CR() $ " " $ msgObjThreshold);	//Ygll: text block corresponding to the info lines of the object, to place properly value text	
	infoW += barSize + 16;
	
	// Draw the Device Damage Threshold
	if ( device.bInvincible || ( player.bColourCodeFrobDisplay && !device.bInvincible &&
			( DeusExWeapon(player.Weapon) == None || ( DeusExWeapon(player.Weapon) != None && !player.BreaksDamageThreshold(DeusExWeapon(player.Weapon),device.minDamageThreshold) ) ) ) )
	{
		gc.SetTextColor(colNotEnough);
	}
	else
		gc.SetTextColor(colText);

	gc.DrawText(infoX+(infoW-barSize-6), infoY+19+(infoH-8)/4, barSize, ((infoH-8)/4)+4, strThreshold);

	// draw the absolute number of multitools on top of the colored bar
	if ((device.bHackable) && (device.hackStrength != 0.0))
	{
		// draw a colored bar
		gc.SetStyle(DSTY_Translucent);
		col = GetColorScaled(device.hackStrength);
		gc.SetTileColor(col);
		gc.DrawPattern(infoX+(infoW-barSize-7), infoY-1+infoH/2.7, barSize*device.hackStrength, ((infoH-8)/4)+1, 0, 0, Texture'ConWindowBackground'); //CyberP: //RSD: reverted
		
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
		
		if (ownedTools < numTools && player.bColourCodeFrobDisplay)
			gc.SetTextColor(colNotEnough);
		else if (ownedTools == numTools && player.bColourCodeFrobDisplay)
			gc.SetTextColor(colJustEnough);
		else
			gc.SetTextColor(colText);
		
		strInfo = FormatString(device.hackStrength * 100.0) $ "% - " $ strInfo;
		
		gc.DrawText(infoX+(infoW-barSize-3), infoY+infoH/2.7, barSize, ((infoH-8)/4)+4, strInfo);
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
		gc.DrawText(infoX+(infoW-barSize-7), infoY+infoH/2.7, barSize, ((infoH-8)/4)+4, strInfo);
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
				strInfo = strInfo $ CR() $ " " $ msgHP $ string(DeusExDecoration(frobTarget).HitPoints);
		   else if (frobTarget.IsA('DeusExPickup') && DeusExPickup(frobTarget).bBreakable)
				strInfo = strInfo $ CR() $ " " $ msgHP2;
			
		   if (frobTarget.IsA('DeusExDecoration') && DeusExDecoration(frobTarget).bPushable)
		   {
			  typecastIt = (int(frobTarget.Mass));
			  strInfo = strInfo $ CR() $ " " $ msgMass $ string(typecastIt) $ " lbs";
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
     margin=70.000000;
     barLength=78.000000;
     msgLocked="Locked";
     msgUnlocked="Unlocked";
     msgLockStr="Lock Str: ";
     msgDoorStr="Door Str: ";
     msgHackStr="Bypass Str: ";
     msgInf="INF";
     msgHacked="Bypassed";
     msgPick="pick";
     msgPicks="picks";
     msgTool="tool";
     msgTools="tools";
     msgDoorThreshold="Damage Threshold: ";
     msgObjThreshold="Damage Threshold: ";
     msgMass="Mass: ";
     msgHP="Hitpoints: ";
     msgHP2="Hitpoints: 3";
     colNotEnough=(R=255,G=50,B=50);
     colJustEnough=(R=255,G=255,B=50);
	 msgDisabled="Disabled";
}
