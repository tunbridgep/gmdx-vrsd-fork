//=============================================================================
// DeusExHUD.
//=============================================================================
class DeusExHUD expands Window;

var Crosshair						cross;
var Crosshair						hitmarker;
var TimerDisplay					timer;
var FrobDisplayWindow				frobDisplay;
var DamageHUDDisplay				damageDisplay;
var AugmentationDisplayWindow		augDisplay;
//var HUDGEPProjectile             gepDisplay;//GMDX

// NEW STUFF!

var HUDHitDisplay					hit;
var HUDCompassDisplay               compass;
var HUDAmmoDisplay					ammo;
var HUDObjectBelt					belt;
var HUDInformationDisplay           info;
var HUDInfoLinkDisplay				infolink;
var HUDLogDisplay					msgLog;
var HUDConWindowFirst				conWindow;
var HUDMissionStartTextDisplay      startDisplay;
var HUDActiveItemsDisplay			activeItems;
var HUDBarkDisplay					barkDisplay;
var HUDReceivedDisplay				receivedItems;

var HUDMultiSkills					hms;
var HUDAmmoDisplay2					ammo2;
var HUDRadialMenu				    radialAugMenu;
// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	local DeusExRootWindow root;
	local DeusExPlayer player;

	Super.InitWindow();

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());

	// Get a pointer to the player
	player = DeusExPlayer(root.parentPawn);

	SetFont(Font'TechMedium');
	SetSensitivity(false);

	//gepDisplay	= HUDGEPProjectile(NewChild(Class'HUDGEPProjectile'));
	//gepDisplay.SetWindowAlignments(HALIGN_Full, VALIGN_Full);
	//gepDisplay.SetBackground(texture'GMDXUI.Skins.GEPScopeOverlay');
	//gepDisplay.SetBackgroundStretching(true);
	//gepDisplay.SetBackgroundStyle(DSTY_None);
	//gepDisplay.DisableWindow();


	ammo			= HUDAmmoDisplay(NewChild(Class'HUDAmmoDisplay'));
	ammo2			= HUDAmmoDisplay2(NewChild(Class'HUDAmmoDisplay2'));
	hit				= HUDHitDisplay(NewChild(Class'HUDHitDisplay'));
	cross			= Crosshair(NewChild(Class'Crosshair'));
	hitmarker		= Crosshair(NewChild(Class'Crosshair'));
	//belt			= HUDObjectBelt(NewChild(Class'HUDObjectBelt'));
    RecreateBelt();
	activeItems		= HUDActiveItemsDisplay(NewChild(Class'HUDActiveItemsDisplay'));
	damageDisplay	= DamageHUDDisplay(NewChild(Class'DamageHUDDisplay'));
	compass     	= HUDCompassDisplay(NewChild(Class'HUDCompassDisplay'));
	hms				= HUDMultiSkills(NewChild(Class'HUDMultiSkills'));
	radialAugMenu   = HUDRadialMenu(NewChild(Class'HUDRadialMenu')); // HUDRadialMenu(root.InvokeUIScreen(Class'HUDRadialMenu', True));

	// Create the InformationWindow
	info = HUDInformationDisplay(NewChild(Class'HUDInformationDisplay', False));

    //Set hitmarker texture
	hitmarker.SetBackground(Texture'GMDXSFX.Icons.Hitmarker');


	// Create the log window
	msgLog	= HUDLogDisplay(NewChild(Class'HUDLogDisplay', False));
	msgLog.SetLogTimeout(player.GetLogTimeout());

	frobDisplay = FrobDisplayWindow(NewChild(Class'FrobDisplayWindow'));
	frobDisplay.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	augDisplay	= AugmentationDisplayWindow(NewChild(Class'AugmentationDisplayWindow'));
	augDisplay.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	startDisplay = HUDMissionStartTextDisplay(NewChild(Class'HUDMissionStartTextDisplay', False));
//	startDisplay.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	// Bark display
	barkDisplay = HUDBarkDisplay(NewChild(Class'HUDBarkDisplay', False));

	// Received Items Display
	receivedItems = HUDReceivedDisplay(NewChild(Class'HUDReceivedDisplay', False));

	if (player.ThemeManager.currentHUDTheme.themeName == "CustomHUD")
	{
	    player.ThemeManager.currentHUDTheme.colors[0] = player.customColorsHUD[0];
	    player.ThemeManager.currentHUDTheme.colors[1] = player.customColorsHUD[1];
	    player.ThemeManager.currentHUDTheme.colors[2] = player.customColorsHUD[2];
	    player.ThemeManager.currentHUDTheme.colors[3] = player.customColorsHUD[3];
	    player.ThemeManager.currentHUDTheme.colors[4] = player.customColorsHUD[4];
	    player.ThemeManager.currentHUDTheme.colors[5] = player.customColorsHUD[5];
	    player.ThemeManager.currentHUDTheme.colors[6] = player.customColorsHUD[6];
	    player.ThemeManager.currentHUDTheme.colors[7] = player.customColorsHUD[7];
	    player.ThemeManager.currentHUDTheme.colors[8] = player.customColorsHUD[8];
	    player.ThemeManager.currentHUDTheme.colors[9] = player.customColorsHUD[9];
	    player.ThemeManager.currentHUDTheme.colors[10] = player.customColorsHUD[10];
	    player.ThemeManager.currentHUDTheme.colors[11] = player.customColorsHUD[11];
	    player.ThemeManager.currentHUDTheme.colors[12] = player.customColorsHUD[12];
	    player.ThemeManager.currentHUDTheme.colors[13] = player.customColorsHUD[13];
	    ChangeStyle();
	}
}

//SARGE: Updates the Assigned Weapon
//Used for refreshing it when the HUD needs to change
function UpdateAssigned()
{
    if (ammo2 != None)
        ammo2.UpdateAssigned();
}

//SARGE: Recreates the belt. Used for refreshing it
//with the larger belt option
function RecreateBelt()
{
	local DeusExRootWindow root;
	local DeusExPlayer player;
    local bool bRightSide;
	
	root = DeusExRootWindow(GetRootWindow());

    if (root == None)
        return;

    player = DeusExPlayer(root.parentPawn);
    bRightSide = player != None && player.bAmmoDisplayOnRight;

    if (belt == None)
        belt = HUDObjectBelt(NewChild(Class'HUDObjectBelt'));
    else
    {
        belt.SetRightSide(!bRightSide);
        belt.RecreateBelt();
    }
}

//SARGE: Update the aug display window
function RefreshActiveAugs()
{
    activeItems.UpdateAllIcons();
}

// ----------------------------------------------------------------------
// DescendantRemoved()
// ----------------------------------------------------------------------

event DescendantRemoved(Window descendant)
{
	if      (descendant == ammo)
		ammo  = None;
	else if (descendant == hit)
		hit   = None;
	else if (descendant == cross)
		cross = None;
	else if (descendant == belt)
		belt  = None;
	else if (descendant == activeItems)
		activeItems = None;
	else if (descendant == damageDisplay)
		damageDisplay = None;
	else if (descendant == infolink)
		infolink = None;
	else if (descendant == timer)
		timer = None;
	else if (descendant == msgLog)
		msgLog = None;
	else if (descendant == info)
		info = None;
	else if (descendant == conWindow)
		conWindow = None;
	else if (descendant == frobDisplay)
		frobDisplay = None;
	else if (descendant == augDisplay)
		augDisplay = None;
	else if (descendant == compass)
		compass = None;
	else if (descendant == startDisplay)
		startDisplay = None;
	else if (descendant == barkDisplay)
		barkDisplay = None;
	else if (descendant == receivedItems)
		receivedItems = None;
	else if ( descendant == hms )
		hms = None;
	else if (descendant == ammo2)                                               //RSD: Was missing? No clue what this does
		ammo2 = none;
	else if ( descendant == radialAugMenu )
		radialAugMenu = None;

}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float qWidth, qHeight;
	local float compassWidth, compassHeight;
	local float beltWidth, beltHeight;
	local float ammoWidth, ammoHeight;
	local float hitWidth, hitHeight;
	local float infoX, infoY, infoTop, infoBottom;
	local float infoWidth, infoHeight, maxInfoWidth, maxInfoHeight;
	local float itemsWidth, itemsHeight;
	local float damageWidth, damageHeight;
	local float conHeight;
	local float barkWidth, barkHeight;
	local float recWidth, recHeight, recPosY;
	local float logTop;
	local float radMenuSize;
	local DeusExRootWindow root;
	local DeusExPlayer player;
    local bool bRightSide;
	
	root = DeusExRootWindow(GetRootWindow());

    if (root == None)
        return;

    player = DeusExPlayer(root.parentPawn);
    bRightSide = player != None && player.bAmmoDisplayOnRight;

	if (ammo != None)
	{
		if (ammo.IsVisible())
		{
            ammo.SetRightSide(bRightSide);                      //SARGE: Added
			ammo.QueryPreferredSize(ammoWidth, ammoHeight);
            //SARGE: Move the ammo display down by 1 unit because it's misaligned,
            //and was annoying me too much
            if (bRightSide)
                ammo.ConfigureChild(width-ammowidth, height-ammoHeight+1, ammoWidth, ammoHeight);
            else
                ammo.ConfigureChild(0, height-ammoHeight+1, ammoWidth, ammoHeight);
		}
		else
		{
			ammoWidth  = 0;
			ammoHeight = 0;
		}
	}

	if (ammo2 != None)
	{
		if (ammo2.IsVisible())
		{
            //SARGE: Disabled, clashes with active items display.
            //ammo2.SetRightSide(bRightSide);
			ammo2.QueryPreferredSize(ammoWidth, ammoHeight);
            //if (bRightSide)
            //    ammo2.ConfigureChild(width-ammowidth+26, height-ammoHeight-64, ammoWidth, ammoHeight);
            //else
                ammo2.ConfigureChild(0, height-ammoHeight-64, ammoWidth, ammoHeight);
		}
		else
		{
			ammoWidth  = 0;
			ammoHeight = 0;
		}
	}

	if (hit != None)
	{
		if (hit.IsVisible())
		{
			hit.QueryPreferredSize(hitWidth, hitHeight);
			hit.ConfigureChild(0, 0, hitWidth, hitHeight);
		}
	}

	// Stick the Compass directly under the Hit display
	if (compass != None)
	{
		compass.QueryPreferredSize(compassWidth, compassHeight);
		compass.ConfigureChild(0, hitHeight + 4, compassWidth, compassHeight);

		if (hitWidth == 0)
			hitWidth = compassWidth;
	}

	if (cross != None)
	{
		cross.QueryPreferredSize(qWidth, qHeight);
		cross.ConfigureChild((width-qWidth)*0.5+0.5, (height-qHeight)*0.5+0.5, qWidth, qHeight);
	}
	if (hitmarker != None)
	{
		hitmarker.QueryPreferredSize(qWidth, qHeight);
		hitmarker.ConfigureChild((width-qWidth)*0.5+0.5, (height-qHeight)*0.5+0.5, qWidth, qHeight);
	}
	if (belt != None)
	{
		belt.QueryPreferredSize(beltWidth, beltHeight);
        belt.SetRightSide(!bRightSide);
        if (bRightSide)
            belt.ConfigureChild(5, height - beltHeight, beltWidth, beltHeight);
        else
            belt.ConfigureChild(width - beltWidth, height - beltHeight, beltWidth, beltHeight);

		infoBottom = height - beltHeight;
	}
	else
	{
		infoBottom = height;
	}


	if (radialAugMenu != None) {
		radMenuSize = fmin(500, height-2*beltHeight-10);
		radialAugMenu.ConfigureChild((width-radMenuSize)/2, (height-radMenuSize)/2, radMenuSize, radMenuSize);
	}

	// Damage display
	//
	// Left side, under the compass

	if (damageDisplay != None)
	{
		// Doesn't check to see if it might bump into the Hit Display
		damageDisplay.QueryPreferredSize(damageWidth, damageHeight);
		damageDisplay.ConfigureChild(0, hitHeight + compassHeight + 4, damageWidth, damageHeight);
	}

	// Active Items, includes Augmentations and various charged Items
	//
	// Upper right corner

	if (activeItems != None)
	{
		itemsWidth = activeItems.QueryPreferredWidth(height - beltHeight);
		activeItems.ConfigureChild(width - itemsWidth, 0, itemsWidth, height - beltHeight);
	}

	// Display the Log in the upper-left corner, to the right of
	// the hit display.

	if (msgLog != None)
	{
		qHeight = msgLog.QueryPreferredHeight(width - hitWidth - itemsWidth - 40);
		msgLog.ConfigureChild(hitWidth + 20, 10, width - hitWidth - itemsWidth - 40, qHeight);

		if (msgLog.IsVisible())
			logTop = max(infoTop, 10 + qHeight);
	}

	// Display the infolink to the right of the hit display
	// and underneath the Log window if it's visible.

	if (infolink != None)
	{
		infolink.QueryPreferredSize(qWidth, qHeight);

		if ((msgLog != None) && (msgLog.IsVisible()))
			infolink.ConfigureChild(hitWidth + 20, msgLog.Height + 20, qWidth, qHeight);
		else
			infolink.ConfigureChild(hitWidth + 20, 0, qWidth, qHeight);

		if (infolink.IsVisible())
			infoTop = max(infoTop, 10 + qHeight);
	}

	// First-person conversation window

	if (conWindow != None)
	{
		qWidth  = Min(width - 100, 800);
		conHeight = conWindow.QueryPreferredHeight(qWidth);

		// Stick it above the belt
		conWindow.ConfigureChild(
			(width / 2) - (qwidth / 2), (infoBottom - conHeight) - 20,
			qWidth, conHeight);
	}

	// Bark Display.  Position where first-person convo window would
	// go, or above it if the first-person convo is visible
	if (barkDisplay != None)
	{
		qWidth = Min(width - 100, 800);
		barkHeight = barkDisplay.QueryPreferredHeight(qWidth);

		barkDisplay.ConfigureChild(
			(width / 2) - (qwidth / 2), (infoBottom - barkHeight - conHeight) - 20,
			qWidth, barkHeight);
	}

	// Received Items display
	//
	// Stick below the crosshair, but above any bark/convo windows that might
	// be visible.

	if (receivedItems != None)
	{
		receivedItems.QueryPreferredSize(recWidth, recHeight);

		recPosY = (height / 2) + 20;

		if ((barkDisplay != None) && (barkDisplay.IsVisible()))
			recPosY -= barkHeight;
		if ((conWindow != None) && (conWindow.IsVisible()))
			recPosY -= conHeight;

		receivedItems.ConfigureChild(
			(width / 2) - (recWidth / 2), recPosY,
			recWidth, recHeight);
	}

	// Display the timer above the object belt if it's visible

	if (timer != None)
	{
		timer.QueryPreferredSize(qWidth, qHeight);

		if ((belt != None) && (belt.IsVisible()))
			timer.ConfigureChild(width-qWidth, height-qHeight-beltHeight-10, qWidth, qHeight);
		else
			timer.ConfigureChild(width-qWidth, height-qHeight, qWidth, qHeight);
	}

	// Mission Start Text
	if (startDisplay != None)
	{
		// Stick this baby right in the middle of the screen.
		startDisplay.QueryPreferredSize(qWidth, qHeight);
		startDisplay.ConfigureChild(
			(width / 2) - (qWidth / 2), (height / 2) - (qHeight / 2) - 75,
			qWidth, qHeight);
	}

	// Display the Info Window sandwiched between all the other windows.  :)

	if ((info != None) && (info.IsVisible(False)))
	{
		// Must redo these formulas
		maxInfoWidth  = Min(width - 170, 800);
		maxInfoHeight = (infoBottom - infoTop) - 20;

		info.QueryPreferredSize(infoWidth, infoHeight);

		if (infoWidth > maxInfoWidth)
		{
			infoHeight = info.QueryPreferredHeight(maxInfoWidth);
			infoWidth  = maxInfoWidth;
		}

		infoX = (width / 2) - (infoWidth / 2);
		infoY = infoTop + (((infoBottom - infoTop) / 2) - (infoHeight / 2)) + 10;

		info.ConfigureChild(infoX, infoY, infoWidth, infoHeight);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	ConfigurationChanged();

	return TRUE;
}

// ----------------------------------------------------------------------
// ChildRequestedVisibilityChange()
// ----------------------------------------------------------------------

function ChildRequestedVisibilityChange(window child, bool bNewVisibility)
{
	child.SetChildVisibility(bNewVisibility);

	ConfigurationChanged();
}

// ----------------------------------------------------------------------
// CreateInfoLinkWindow()
//
// Creates the InfoLink window used to display messages.  If a
// InfoLink window already exists, then return None.  If the Log window
// is visible, it hides it.
// ----------------------------------------------------------------------

function HUDInfoLinkDisplay CreateInfoLinkWindow()
{
	if ( infolink != None )
		return None;

	infolink = HUDInfoLinkDisplay(NewChild(Class'HUDInfoLinkDisplay'));

	// Hide Log window
	if ( msgLog != None )
		msgLog.HideLogWindow();                                                 //RSD: Was Hide(), new shell function so we can set bPlayingLog properly

	infolink.AskParentForReconfigure();

	return infolink;
}

// ----------------------------------------------------------------------
// DestroyInfoLinkWindow()
// ----------------------------------------------------------------------

function DestroyInfoLinkWindow()
{
	local DeusExRootWindow root;                                                //RSD
    local PersonaScreenBaseWindow winPersona;                                   //RSD

    root = DeusExRootWindow(GetRootWindow());                                   //RSD
    winPersona = PersonaScreenBaseWindow(root.GetTopWindow());                  //RSD

    if ( infoLink != None )
	{
		infoLink.Destroy();

		// If the msgLog window was visible, show it again
		if (( msgLog != None ) && ( msgLog.MessagesWaiting() ) && winPersona == none) //RSD: Added winPersona == none so it doesn't pop up when we're in realtime UI
			msgLog.ShowLogWindow();                                             //RSD: Was Show(), new shell function so we can set bPlayingLog properly
	}
}

// ----------------------------------------------------------------------
// CreateConWindowFirst()
// ----------------------------------------------------------------------

function HUDConWindowFirst CreateConWindowFirst()
{
	local DeusExRootWindow root;

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());

	conWindow = HUDConWindowFirst(NewChild(Class'HUDConWindowFirst', False));
	conWindow.AskParentForReconfigure();

	return conWindow;
}

// ----------------------------------------------------------------------
// VisibilityChanged()
//
// Used to display Log messages that were received while the HUD
// wasn't visible
// ----------------------------------------------------------------------

event VisibilityChanged(bool bNewVisibility)
{
	local DeusExRootWindow root;                                                //RSD
    local PersonaScreenBaseWindow winPersona;                                   //RSD

    root = DeusExRootWindow(GetRootWindow());                                   //RSD
    winPersona = PersonaScreenBaseWindow(root.GetTopWindow());                  //RSD

    Super.VisibilityChanged( bNewVisibility );

	if (( msgLog != None ) && ( bNewVisibility ))
	{
		if (( infoLink == None ) && ( msgLog.MessagesWaiting() ) && winPersona == none) //RSD: Added winPersona == none so it doesn't pop up when we're in realtime UI
			msgLog.ShowLogWindow();                                             //RSD: Was Show(), new shell function so we can set bPlayingLog properly
	}
}

// ----------------------------------------------------------------------
// CreateTimerWindow()
//
// Creates the Timer window used to display countdowns.  If a
// Timer window already exists, then return None.
// ----------------------------------------------------------------------

function TimerDisplay CreateTimerWindow()
{
	if ( timer != None )
		return None;

	timer = TimerDisplay(NewChild(Class'TimerDisplay'));
	timer.AskParentForReconfigure();

	return timer;
}

// ----------------------------------------------------------------------
// ShowInfoWindow()
// ----------------------------------------------------------------------

function HUDInformationDisplay ShowInfoWindow()
{
	if (info != None)
		info.Show();

	return info;
}

// ----------------------------------------------------------------------
// UpdateSettings()
//
// Show/Hide these items as dictated by settings in DeusExPlayer (until
// DeusExHUD can be serialized)
// ----------------------------------------------------------------------

function UpdateSettings( DeusExPlayer player , optional bool bNoBelt)
{
    local int i;

    if (!bNoBelt)
	     belt.SetVisibility(player.bObjectBeltVisible);
	hit.SetVisibility(player.bHitDisplayVisible);
	ammo.SetVisibility(player.bAmmoDisplayVisible);
	ammo2.SetVisibility(player.bAmmoDisplayVisible);
	activeItems.SetVisibility(player.bAugDisplayVisible);
	damageDisplay.SetVisibility(player.bHitDisplayVisible);
	compass.SetVisibility(player.bCompassVisible);
    UpdateCrosshair(player);
	radialAugMenu.Show(player.bRadialAugMenuVisible);
    hit.UpdateBars();

	//RSD: Also bring back any windows we may have closed in realtime UI
    if (msgLog != none)
        msgLog.SetVisibility(msgLog.bPlayingLog || (infoLink==None && msgLog.MessagesWaiting())); //RSD: Need to check if actually playing a log, otherwise an extra window will be drawn if a ConWindow is active. Also check if we were delayed by an infolink
    if (infoLink != none)
        infolink.SetVisibility(true);
    if (conWindow != none)
        conWindow.SetVisibility(true);
    if (barkDisplay != none)
        barkDisplay.SetVisibility(barkDisplay.barkCount>0);                     //RSD: Need to check if actually playing a bark, otherwise the window will always be drawn
    if (startDisplay != none)
        startDisplay.SetVisibility(startDisplay.bTickEnabled);                  //RSD: Need to check if actually playing mission start text, otherwise the window will always be drawn
    if (receivedItems != none)
        receivedItems.SetVisibility(receivedItems.bTickEnabled);                //RSD: Need to check if actually receiving items, otherwise the window will always be drawn

    //SARGE: If belt memory is disabled, clear any placeholders
     
    /*
    if (!player.bBeltMemory)
    {
        for (i = 0; i < 10;i++)
            player.ClearPlaceholder(i);
    }
    */
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function UpdateCrosshair(DeusExPlayer player)
{
	cross.SetCrosshair(player.GetCrosshairState());
	hitmarker.SetCrosshair(player.GetHitMarkerState());

    if (player.GetBracketsState())
        frobDisplay.Show();
    else
        frobDisplay.Hide();
}

defaultproperties
{
}
