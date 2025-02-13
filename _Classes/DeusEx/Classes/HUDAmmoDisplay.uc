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
// GetWeapon()
// ----------------------------------------------------------------------

function Inventory GetWeapon()
{
    if (player.primaryWeapon != None)
        return player.primaryWeapon;
    else
        return player.Weapon;
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
    local bool validWeap, hastool;
    local Inventory curr;
    curr = GetWeapon();
    weapon = DeusExWeapon(curr);

    validWeap = player.inHand != None && weapon != None && (weapon.ReloadCount > 0 || (weapon.IsA('WeaponNanoSword')));
    hasTool = player.inHand != None && (curr.isA('Multitool') || curr.isA('Lockpick')) && player.iFrobDisplayStyle == 0;

	if ((validweap || hastool) && bVisible )
		Show();
	else
		Hide();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
    local DeusExWeapon weapon;
    local Inventory curr;
    curr = GetWeapon();
    weapon = DeusExWeapon(curr);

	Super.DrawWindow(gc);

	// No need to draw anything if the player doesn't have
	// a weapon selected

    //SARGE: Draw tool info if we have one
    //TODO: Refactor this
    if (player.inHand != None && (curr.isA('Multitool') || curr.isA('Lockpick')) && player.iFrobDisplayStyle == 0)
    {
		// Draw the weapon icon
		gc.SetStyle(DSTY_Masked);
		gc.SetTileColorRGB(255, 255, 255);
		gc.DrawTexture(22, 20, 40, 35, 0, 0, SkilledTool(curr).icon);

		// Draw the ammo count
		gc.SetFont(Font'TechMedium'); //CyberP: hud scaling Font'FontTiny'
		gc.SetAlignments(HALIGN_Center, VALIGN_Top);   //CyberP: Valignment
		gc.EnableWordWrap(false);
         
        gc.SetTextColor(colAmmoText);
        gc.DrawText(infoX, 27, 20, 9, SkilledTool(curr).numCopies);
        gc.DrawText(infoX, 39, 20, 9, NotAvailable);
    }

	if ( weapon != None )
	{
		// Draw the weapon icon
		gc.SetStyle(DSTY_Masked);
		gc.SetTileColorRGB(255, 255, 255);
		gc.DrawTexture(22, 20, 40, 35, 0, 0, weapon.icon);

		// Draw the ammo count
		gc.SetFont(Font'TechMedium'); //CyberP: hud scaling Font'FontTiny'
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
            ammoInClip = WeaponNanoSword(weapon).ChargeManager.GetCurrentCharge();
            gc.DrawText(infoX, 27, 20, 9, ammoInClip);
			gc.DrawText(infoX, 39, 20, 9, NotAvailable);
        }
		// Ammo count drawn differently depending on user's setting
		else if (weapon.ReloadCount > 1 || weapon.IsA('WeaponGEPGun') || weapon.AmmoName == Class'Ammo20mm')
		{

			if (weapon.bPerShellReload || player.bDisplayTotalAmmo)
				clipsRemaining = weapon.NumRounds();
			else
				clipsRemaining = weapon.NumClips();
		
            if ((weapon.reloadCount > 1 && ammoInClip <= weapon.reloadCount / 2) || ammoInClip == 0)
                gc.SetTextColor(colAmmoLowText);
            else
                gc.SetTextColor(colAmmoText);

			if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
				gc.DrawText(infoX, 27, 20, 9, msgReloading);
			else
				gc.DrawText(infoX, 27, 20, 9, ammoInClip);

			// if there are no clips (or a partial clip) remaining, color me red
			if (( clipsRemaining == 0 ) || (( clipsRemaining == 1 ) && ( ammoRemaining < 2 * weapon.ReloadCount )))
				gc.SetTextColor(colAmmoLowText);
			else
				gc.SetTextColor(colAmmoText);

			if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
				gc.DrawText(infoX, 39, 20, 9, msgReloading);
			else
				gc.DrawText(infoX, 39, 20, 9, clipsRemaining);
		}
		else
		{
			gc.DrawText(infoX, 39, 20, 9, NotAvailable);

			if (weapon.ReloadCount == 0)
			{
				gc.DrawText(infoX, 27, 20, 9, NotAvailable);
			}
			else
			{
				if (weapon.IsInState('Reload') && weapon.bPerShellReload == false)
					gc.DrawText(infoX, 27, 20, 9, msgReloading);
				else
					gc.DrawText(infoX, 27, 20, 9, ammoRemaining);
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
	}
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
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

        if (weapon != None && weapon.bPerShellReload || weapon.AmmoName == Class'Ammo20mm' || player.bDisplayTotalAmmo)
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
