//=============================================================================
// HUDAmmoDisplay
//=============================================================================
class HUDAmmoDisplay expands HUDRightSidedWindow;

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
var transient Inventory curr;
var transient DeusExWeapon weapon;

// Defaults
var Texture texBackground;
var Texture texBorder;
var Texture texBorderRight;
var localized String LaserLabel;
var localized String RemoteLabel;

var const Color colIcon;

//SARGE: Colour for the "Max Ammo" counter
var Color			colAmmoTextMax;
var bool            bMaxAmmo;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

    SetRightSide(false);

	bTickEnabled = true;

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
    
    if (!bVisible)
    {
        Hide();
        return;
    }

    curr = GetWeapon();
    weapon = DeusExWeapon(curr);
    
    //it's visible if we have a valid weapon
    validWeap = player.inHand != None && weapon != None && (weapon.ReloadCount > 0 || (weapon.IsA('WeaponNanoSword') && (player.bNanoswordEnergyUse || player.bHardcoreMode)));
    hasTool = curr != None && weapon == None;

    UpdateMaxAmmo();

	if (curr != None && curr.Owner == player && (validweap || hastool))
		Show();
	else
		Hide();

}

function UpdateMaxAmmo()
{
    local bool validWeap;
    validWeap = player.inHand != None && weapon != None && (weapon.ReloadCount > 0 || (weapon.IsA('WeaponNanoSword')));

    //player.DebugMessage("Updating Ammo Display");

    bMaxAmmo = validWeap && player.bShowFullAmmoInHUD && weapon.AmmoType != None && weapon.AmmoType.AmmoAmount == player.GetAdjustedMaxAmmo(weapon.AmmoType);
}

// ----------------------------------------------------------------------
// GetWeapon()
// ----------------------------------------------------------------------

//SARGE: This is slightly complicated...
//That's the price we pay for having it feel """nice"""
function Inventory GetWeapon()
{
    if (player == None)
        return None;

    if (player.inHandPending != None && player.inHandPending.IsA('DeusExPickup') && !player.inHandPending.IsA('SkilledTool'))
        return None;

    //SARGE: Hack...
    if (player.inHandPending != None && string(player.inHandPending.Class) == player.assignedWeapon.itemClass && player.bLastWasEmpty) //If we're using our secondary weapon, hide the ammo display.
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
    local float ammopostop, ammoposbtm, posX, posY, addonOffset;             //SARGE: Added

	Super.DrawWindow(gc);

    if (curr == None || !IsVisible() || curr.Owner != player)
        return;
    
    //SARGE: Make the text and icons fade out sooner than the background
    if (GetOpacity() <= 0.15)
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
        gc.SetTileColor(GetColorWithOpacity(colIcon));
		gc.DrawTexture(9+offset, 20, 40, 35, 0, 0, SkilledTool(curr).icon);

		gc.SetStyle(DSTY_Translucent);
		// Draw the ammo count
		gc.SetFont(player.FontManager.GetFont(TT_AmmoCount)); //CyberP: hud scaling Font'FontTiny'
		gc.SetAlignments(HALIGN_Center, VALIGN_Top);   //CyberP: Valignment
		gc.EnableWordWrap(false);
         
        gc.SetTextColor(GetColorWithOpacity(colAmmoText));
        gc.DrawText(infoX+offset, ammopostop, 20, 9, SkilledTool(curr).numCopies);
        gc.DrawText(infoX+offset, ammoposbtm, 20, 9, NotAvailable);
    }
	else if ( weapon != None )
	{
		// Draw the weapon icon
		gc.SetStyle(DSTY_Masked);
        gc.SetTileColor(GetColorWithOpacity(colIcon));
		gc.DrawTexture(9+offset, 20, 40, 35, 0, 0, weapon.icon);

		// Draw the ammo count
		gc.SetStyle(DSTY_Translucent);
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
                
        gc.SetTextColor(GetColorWithOpacity(colAmmoText));

        //Draw DTS Charge
        if (weapon.IsA('WeaponNanoSword') && (player.bNanoswordEnergyUse || player.bHardcoreMode))
        {
            gc.SetTextColor(GetColorWithOpacity(colAmmoText));
            ammoInClip = WeaponNanoSword(weapon).ChargeManager.GetCurrentCharge();
            gc.DrawText(infoX+offset, ammopostop, 20, 9, ammoInClip);
			gc.DrawText(infoX+offset, ammoposbtm, 20, 9, NotAvailable);
        }
		// Ammo count drawn differently depending on user's setting
		else if (weapon.ReloadCount > 1 || weapon.IsA('WeaponGEPGun') || weapon.AmmoName == Class'Ammo20mm')
		{

			if (weapon.bPerShellReload || (player.bDisplayTotalAmmo && !player.bHardCoreMode))
				clipsRemaining = weapon.NumRounds();
			else
				clipsRemaining = weapon.NumClips();
		
            if ((weapon.reloadCount > 1 && ammoInClip <= weapon.reloadCount / 2.0) || ammoInClip == 0)
                gc.SetTextColor(GetColorWithOpacity(colAmmoLowText));
            else
                gc.SetTextColor(GetColorWithOpacity(colAmmoText));

			if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
				gc.DrawText(infoX+offset, ammopostop, 20, 9, msgReloading);
			else
				gc.DrawText(infoX+offset, ammopostop, 20, 9, ammoInClip);

			if (bMaxAmmo) //SARGE: Show ammo in Yellow at max ammo
                gc.SetTextColor(GetColorWithOpacity(colAmmoTextMax));
			// if there are no clips (or a partial clip) remaining, color me red
			else if (( clipsRemaining == 0 ) || (( clipsRemaining == 1 ) && ( ammoRemaining < 2 * weapon.ReloadCount )))
                gc.SetTextColor(GetColorWithOpacity(colAmmoLowText));
			else
                gc.SetTextColor(GetColorWithOpacity(colAmmoText));

			if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
				gc.DrawText(infoX+offset, ammoposbtm, 20, 9, msgReloading);
			else
				gc.DrawText(infoX+offset, ammoposbtm, 20, 9, clipsRemaining);
		}
		else
		{
			gc.DrawText(infoX+offset, ammoposbtm, 20, 9, NotAvailable);

			if (weapon.ReloadCount == 0)
			{
				gc.DrawText(infoX+offset, ammopostop, 20, 9, NotAvailable);
			}
			else
			{
				if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
					gc.DrawText(infoX+offset, ammopostop, 20, 9, msgReloading);
				else
					gc.DrawText(infoX+offset, ammopostop, 20, 9, ammoRemaining);
			}
		}		
		
		gc.SetFont(player.FontManager.GetFont(TT_FontTiny)); //CyberP: hud scaling Font'FontTiny' //SARGE: always force the tiny font for this text display section
		gc.SetAlignments(HALIGN_Center, VALIGN_Top);   //Ygll: make the text alignment to the left for a consistant display
		
		posX = offset+9;
		posY = 57;

		// Now, let's draw the targetting information
		if (weapon.bCanTrack)
		{
			if (weapon.LockMode == LOCK_Locked)
                gc.SetTextColor(GetColorWithOpacity(colLockedText));
			else if (weapon.LockMode == LOCK_Acquire)
                gc.SetTextColor(GetColorWithOpacity(colTrackingText));
			else
                gc.SetTextColor(GetColorWithOpacity(colNormalText));
			
			if (weapon.bLasing)
		        gc.DrawText(posX, posY, 65, 8, LaserLabel);
            else if (weapon.bZoomed)
                gc.DrawText(posX, posY, 65, 8, RemoteLabel);
            else
			    gc.DrawText(posX, posY, 65, 8, weapon.TargetMessage);
		}
        //SARGE: Otherwise, print the ammo type. This is useful when we "use" items from the inventory
        //that aren't on our belt, which normally would give us no idea what is in our weapon if we change ammo types,
        //especially if an infolink is playing.
        else if (player.bShowAmmoTypeInAmmoHUD && !weapon.bDisposableWeapon)
        {
			gc.SetFont(player.FontManager.GetFont(TT_FontTiny)); //CyberP: hud scaling Font'FontTiny'
            gc.SetTextColor(GetColorWithOpacity(GetAmmoTextColor()));
            gc.DrawText(posX, posY, 65, 8, DeusExAmmo(weapon.AmmoType).beltDescription);
        }

        //SARGE: Show Silencer/Laser/Scope since it's way more important in GMDX
        if (player.bDrawAddonsOnAmmoDisplay)
        {
            addonOffset = 47;
            gc.SetAlignments(HALIGN_Left, VALIGN_Top);
            if (weapon.bHadLaser)
            {
                if (weapon.bHasLaser)
                    gc.SetTextColor(GetColorWithOpacity(colAmmoText));
                else
                    gc.SetTextColor(GetColorWithOpacity(colAmmoLowText));

                gc.DrawText(offset+9, addonOffset, 16, 8, "L");
                addonOffset -= 6;
            }
            if (weapon.bHadScope)
            {
                if (weapon.bHasScope)
                    gc.SetTextColor(GetColorWithOpacity(colAmmoText));
                else
                    gc.SetTextColor(GetColorWithOpacity(colAmmoLowText));

                gc.DrawText(offset+9, addonOffset, 16, 8, "S");
                addonOffset -= 6;
            }
            if (weapon.bHadSilencer)
            {
                if (weapon.bHasSilencer)
                    gc.SetTextColor(GetColorWithOpacity(colAmmoText));
                else
                    gc.SetTextColor(GetColorWithOpacity(colAmmoLowText));

                gc.DrawText(offset+9, addonOffset, 16, 8, "S");
                addonOffset -= 6;
            }
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
    
    //SARGE: Make the text and icons fade out sooner than the background
    if (GetOpacity() <= 0.15)
        return;

	gc.SetStyle(backgroundDrawStyle);
    gc.SetTileColor(GetColorWithOpacity(colBackground));
    gc.DrawTexture(offset, 13, 80, 54, 0, 0, texBackground);

	// Draw the Ammo and Clips text labels
    gc.SetStyle(DSTY_Translucent);
	gc.SetFont(player.FontManager.GetFont(TT_FontTiny));
    gc.SetTextColor(GetColorWithOpacity(colText));
	gc.SetAlignments(HALIGN_Center, VALIGN_Top);

    if (player != None)
    {
        if (weapon != None && weapon.IsA('WeaponNanoSword'))
            gc.DrawText(53+offset, 17, 21, 8, ChargeLabel);
        else
            gc.DrawText(53+offset, 17, 21, 8, AmmoLabel);

        if (weapon != None && (weapon.bPerShellReload || weapon.AmmoName == Class'Ammo20mm' || (player.bDisplayTotalAmmo && !player.bHardCoreMode)))
            gc.DrawText(53+offset, 48, 21, 8, RoundsLabel);
        else if (player.bDisplayClips)
            gc.DrawText(53+offset, 48, 21, 8, ClipsLabel);
        else
            gc.DrawText(53+offset, 48, 21, 8, MagsLabel);
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
        gc.SetTileColor(GetColorWithOpacity(colBorder));
        if (bRightSided)
            gc.DrawTexture(0, 0, 95, 77, 0, 0, texBorderRight);
        else
            gc.DrawTexture(0, 0, 95, 77, 0, 0, texBorder);
	}
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )
{
	bVisible = bNewVisibility;
    UpdateVisibility();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colAmmoText=(G=255);
     colAmmoTextMax=(G=255,B=255);
     colAmmoLowText=(R=255,G=32);
     colNormalText=(G=255);
     colTrackingText=(R=255,G=255);
     colLockedText=(R=255);
     infoX=53;
     NotAvailable="N/A";
     msgReloading="---";
     AmmoLabel="AMMO";
     MagsLabel="MAGS";
     ClipsLabel="CLIPS";
     ChargeLabel="CHARG";
	 RoundsLabel="RDS";
     texBackground=Texture'DeusExUI.UserInterface.HUDAmmoDisplayBackground_1';
     texBorder=Texture'DeusExUI.UserInterface.HUDAmmoDisplayBorder_1';
     texBorderRight=Texture'RSDCrap.UserInterface.HUDAmmoDisplayBorder_1F';
     LaserLabel="LASER GUIDANCE";
     RemoteLabel="REMOTE GUIDANCE";
     leftSideOffset=13;
     rightSideOffset=2;
     colIcon=(R=255,G=255,B=255)
     bFadeEnabled=true
}
