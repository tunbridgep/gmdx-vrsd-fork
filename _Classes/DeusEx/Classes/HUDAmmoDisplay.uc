//=============================================================================
// HUDAmmoDisplay
//=============================================================================
class HUDAmmoDisplay expands HUDBaseWindow;

var Bool			bVisible;
var Color			colAmmoText;		// Ammo count text color
var Color			colAmmoLowText;		// Color when ammo low
var Color			colNormalText;		// color for normal weapon messages
var Color			colTrackingText;	// color when weapon is tracking
var Color			colLockedText;		// color when weapon is locked
var DeusExPlayer	player;
var int             infoX;

var localized String NotAvailable;
var localized String msgReloading;
var localized String AmmoLabel;
var localized String ChargeLabel;
var localized String ClipsLabel;
var localized String MagsLabel;
var localized String RoundsLabel;

// Used by DrawWindow
var int clipsRemaining;
var int ammoRemaining;
var int ammoInClip;

//Stores a reference to our currently relevant weapon
var Inventory curr;
var DeusExWeapon weapon;

// Defaults
var Texture texBackground;
var Texture texBorder;
var localized String LaserLabel;
var localized String RemoteLabel;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	bTickEnabled = TRUE;

	Hide();

	player = DeusExPlayer(DeusExRootWindow(GetRootWindow()).parentPawn);

	SetSize(95, 77);
}

// ----------------------------------------------------------------------
// UpdateVisibility()
// ----------------------------------------------------------------------

function UpdateVisibility()
{
    local bool validWeap, hastool;

    curr = GetWeapon();
    weapon = DeusExWeapon(curr);
    
    //player.ClientMessage("UpdateVisibility: " $ curr $ ", " $ weapon);

    //it's visible if we have a valid weapon
    validWeap = player.inHand != None && weapon != None && (weapon.ReloadCount > 0 || (weapon.IsA('WeaponNanoSword')));
    hasTool = curr != None && weapon == None;

	if (curr != None && curr.Owner == player && (validweap || hastool) && bVisible )
		Show();
	else
		Hide();

}

// ----------------------------------------------------------------------
// GetWeapon()
// ----------------------------------------------------------------------

//SARGE: This is slightly complicated...
//That's the price we pay for having it feel """nice"""
function Inventory GetWeapon()
{
    if (player.inHandPending != None && player.inHandPending.IsA('DeusExPickup') && !player.inHandPending.IsA('SkilledTool'))
        return None;

    //SARGE: Hack...
    if (string(player.inHandPending.Class) == player.assignedWeapon && player.bLastWasEmpty) //If we're using our secondary weapon, hide the ammo display.
        //return player.assignedWeapon;
        return None;
    //SARGE: ...Even worse hack...
    if (player.inHand != None && (player.inHand.isA('Multitool') || player.inHand.isA('Lockpick')) && player.iFrobDisplayStyle != 0 && player.bLastWasEmpty) //Hide the ammo counter when we have tools, unless we're using the classic tool window display.
        return None;
    //SARGE: ...And again...
    if (player.inHandPending == None) //Hide the empty ammo counter when we have nothing selected
        return None;
    //SARGE: ...Oh god it just keeps going!...
    if (player.inHand != None && (player.inHand.isA('Multitool') || player.inHand.isA('Lockpick')) && player.iFrobDisplayStyle == 0) //Return our current tool rather than our primary weapon, if we're using the classic tool window display.
        return player.inHand;
    return player.primaryWeapon;
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
}

// ----------------------------------------------------------------------
// GetAmmoTextColor()
// SARGE: Get the ammo color()
// ----------------------------------------------------------------------

function Color GetAmmoTextColor()
{
    if (weapon != None && DeusExAmmo(weapon.AmmoType) != None && DeusExAmmo(weapon.AmmoType).HasCustomAmmoColor() && player.bColorCodedAmmo)
        return DeusExAmmo(weapon.AmmoType).ammoHUDColor;
    else
        return colText;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
    local float ammopostop, ammoposbtm;             //SARGE: Added

	Super.DrawWindow(gc);

    if (!IsVisible() || curr.Owner != player)
        return;

    ammopostop = player.FontManager.GetTextPosition(27,26);
    ammoposbtm = player.FontManager.GetTextPosition(39,38);

	// No need to draw anything if the player doesn't have
	// a weapon selected
    
    //SARGE: Draw tool info if we have one
    //TODO: Refactor this
    if (curr != None && curr.IsA('SkilledTool'))
    {
		// Draw the weapon icon
		gc.SetStyle(DSTY_Masked);
		gc.SetTileColorRGB(255, 255, 255);
		gc.DrawTexture(22, 20, 40, 35, 0, 0, SkilledTool(curr).icon);

		// Draw the ammo count
		gc.SetFont(player.FontManager.GetFont(TT_AmmoCount)); //CyberP: hud scaling Font'FontTiny'
		gc.SetAlignments(HALIGN_Center, VALIGN_Top);   //CyberP: Valignment
		gc.EnableWordWrap(false);
         
        gc.SetTextColor(colAmmoText);
        gc.DrawText(infoX, ammopostop, 20, 9, SkilledTool(curr).numCopies);
        gc.DrawText(infoX, ammoposbtm, 20, 9, NotAvailable);
    }
	else if ( weapon != None )
	{
		// Draw the weapon icon
		gc.SetStyle(DSTY_Masked);
		gc.SetTileColorRGB(255, 255, 255);
		gc.DrawTexture(22, 20, 40, 35, 0, 0, weapon.icon);

		// Draw the ammo count
		gc.SetFont(player.FontManager.GetFont(TT_AmmoCount)); //CyberP: hud scaling Font'FontTiny'
		gc.SetAlignments(HALIGN_Center, VALIGN_Top);   //CyberP: Valignment
		gc.EnableWordWrap(false);
			
        // how much ammo is left in the current clip?
            ammoInClip = weapon.AmmoLeftInClip();

		// how much ammo of this type do we have left?
		if (weapon.AmmoType != None)
			ammoRemaining = weapon.AmmoType.AmmoAmount;
		else
			ammoRemaining = 0;
                
         gc.SetTextColor(colAmmoText);

        //Draw DTS Charge
        if (weapon.IsA('WeaponNanoSword'))
        {
            gc.SetTextColor(colAmmoText);
            ammoInClip = WeaponNanoSword(weapon).ChargeManager.GetCurrentCharge();
            gc.DrawText(infoX, ammopostop, 20, 9, ammoInClip);
			gc.DrawText(infoX, ammoposbtm, 20, 9, NotAvailable);
        }
		// Ammo count drawn differently depending on user's setting
		else if (weapon.ReloadCount > 1 || weapon.IsA('WeaponGEPGun') || weapon.AmmoName == Class'Ammo20mm')
		{

			if (weapon.bPerShellReload || (player.bDisplayTotalAmmo && !player.bHardCoreMode))
				clipsRemaining = weapon.NumRounds();
			else
				clipsRemaining = weapon.NumClips();
		
            if ((weapon.reloadCount > 1 && ammoInClip <= weapon.reloadCount / 2) || ammoInClip == 0)
                gc.SetTextColor(colAmmoLowText);
            else
                gc.SetTextColor(colAmmoText);

			if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
				gc.DrawText(infoX, ammopostop, 20, 9, msgReloading);
			else
				gc.DrawText(infoX, ammopostop, 20, 9, ammoInClip);

			// if there are no clips (or a partial clip) remaining, color me red
			if (( clipsRemaining == 0 ) || (( clipsRemaining == 1 ) && ( ammoRemaining < 2 * weapon.ReloadCount )))
				gc.SetTextColor(colAmmoLowText);
			else
                gc.SetTextColor(colAmmoText);

			if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
				gc.DrawText(infoX, ammoposbtm, 20, 9, msgReloading);
			else
				gc.DrawText(infoX, ammoposbtm, 20, 9, clipsRemaining);
		}
		else
		{
			gc.DrawText(infoX, ammoposbtm, 20, 9, NotAvailable);

			if (weapon.ReloadCount == 0)
			{
				gc.DrawText(infoX, ammopostop, 20, 9, NotAvailable);
			}
			else
			{
				if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
					gc.DrawText(infoX, ammopostop, 20, 9, msgReloading);
				else
					gc.DrawText(infoX, ammopostop, 20, 9, ammoRemaining);
			}
		}

		// Now, let's draw the targetting information
		if (weapon.bCanTrack)
		{
			if (weapon.LockMode == LOCK_Locked)
				gc.SetTextColor(colLockedText);
			else if (weapon.LockMode == LOCK_Acquire)
				gc.SetTextColor(colTrackingText);
			else
				gc.SetTextColor(colNormalText);
			gc.SetFont(Font'FontTiny'); //CyberP: hud scaling Font'FontTiny'
			if (weapon.bLasing)
		        gc.DrawText(25, 56, 65, 8, LaserLabel);
            else if (weapon.bZoomed)
                gc.DrawText(25, 56, 65, 8, RemoteLabel);
            else
			    gc.DrawText(25, 56, 65, 8, weapon.TargetMessage);
		}
        //SARGE: Otherwise, print the ammo type. This is useful when we "use" items from the inventory
        //that aren't on our belt, which normally would give us no idea what is in our weapon if we change ammo types,
        //especially if an infolink is playing.
        else if (player.bShowAmmoTypeInAmmoHUD)
        {
            gc.SetTextColor(GetAmmoTextColor());
            gc.DrawText(25, 56, 65, 8, DeusExAmmo(weapon.AmmoType).beltDescription);
        }
	}
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
    if (gc == None)
        return;

	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(13, 13, 80, 54, 0, 0, texBackground);

	// Draw the Ammo and Clips text labels
	gc.SetFont(Font'FontTiny');
	gc.SetTextColor(colText);
	gc.SetAlignments(HALIGN_Center, VALIGN_Top);

    if (player != None)
    {
        if (weapon != None && weapon.IsA('WeaponNanoSword'))
            gc.DrawText(66, 17, 21, 8, ChargeLabel);
        else
            gc.DrawText(66, 17, 21, 8, AmmoLabel);

        if (weapon != None && weapon.bPerShellReload || weapon.AmmoName == Class'Ammo20mm' || (player.bDisplayTotalAmmo && !player.bHardCoreMode))
            gc.DrawText(66, 48, 21, 8, RoundsLabel);
        else if (player.bDisplayClips)
            gc.DrawText(66, 48, 21, 8, ClipsLabel);
        else
            gc.DrawText(66, 48, 21, 8, MagsLabel);
    }
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);
		gc.DrawTexture(0, 0, 95, 77, 0, 0, texBorder);
	}
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )
{
	bVisible = bNewVisibility;
    if (bNewVisibility)
        UpdateVisibility();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colAmmoText=(G=255)
     colAmmoLowText=(R=255,G=32)
     colNormalText=(G=255)
     colTrackingText=(R=255,G=255)
     colLockedText=(R=255)
     infoX=66
     NotAvailable="N/A"
     msgReloading="---"
     AmmoLabel="AMMO"
     MagsLabel="MAGS"
     ClipsLabel="CLIPS"
     ChargeLabel="CHARG"
	 RoundsLabel="RDS"
     texBackground=Texture'DeusExUI.UserInterface.HUDAmmoDisplayBackground_1'
     texBorder=Texture'DeusExUI.UserInterface.HUDAmmoDisplayBorder_1'
     LaserLabel="LASER GUIDANCE"
     RemoteLabel="REMOTE GUIDANCE"
}
