//=============================================================================
// HUDAmmoDisplay
//=============================================================================
class HUDAmmoDisplay2 expands HUDBaseWindow;

var Bool			bVisible;
var DeusExPlayer	player;
var int             infoX;

var localized String NotAvailable;
var localized String msgReloading;
var localized String AmmoLabel;
var localized String ClipsLabel;
var localized String InvLabel;

// Used by DrawWindow
var int clipsRemaining;
var int ammoRemaining;
var int ammoInClip;
var DeusExWeapon weapon;
var DeusExPickup item;                                                             //RSD: Added

// Defaults
var Texture texBackground;
var Texture texBorder;

var Color colIconDimmed;

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
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	if ((player.assignedWeapon != None) && ( bVisible ))
		Show();
	else
		Hide();
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
    local int amount, chargeLevel;
    local Texture icon;

	Super.DrawWindow(gc);

	// No need to draw anything if the player doesn't have
	// a weapon selected

	if (player != None && player.assignedWeapon != none && player.assignedWeapon.IsA('DeusExWeapon')) //RSD: Added IsA weapon check
	{
		weapon = DeusExWeapon(player.assignedWeapon);
		item = none;                                                            //RSD: Fix for the last weapon assigned icon always showing up
        amount = weapon.AmmoType.AmmoAmount;
        icon = weapon.icon;
	}
    else if (player != None && player.assignedWeapon != none && player.assignedWeapon.IsA('DeusExPickup')) //RSD: Extended to include general inventory items
    {
    	item = DeusExPickup(player.assignedWeapon);
    	weapon = none;                                                          //RSD: Fix for the last weapon assigned icon always showing up
        amount = item.numCopies;
        icon = item.icon;
   	}
        
    gc.SetTileColorRGB(255, 255, 255);
    
    if (item != None && item.isA('ChargedPickup'))
        chargeLevel = int(ChargedPickup(item).GetCurrentCharge());
    else if (weapon != None && weapon.isA('WeaponNanoSword'))
        chargeLevel = WeaponNanoSword(weapon).ChargeManager.GetCurrentCharge();

	if ( weapon != None || item != None)
	{
        if (!IsCharged(item))
            gc.SetTileColor(colIconDimmed);

		// Draw the weapon icon
		gc.SetStyle(DSTY_Masked);
		gc.DrawTexture(22, 20, 40, 35, 0, 0, icon);

        if ((amount > 0 || chargeLevel > 0) && (item == None || !item.isA('Binoculars')))
        {
            // Draw the ammo count
            gc.SetFont(player.FontManager.GetFont(TT_SecondaryDisplay)); //CyberP: hud scaling Font'FontTiny'
            gc.SetAlignments(HALIGN_Center, VALIGN_Top);   //CyberP: Valignment
            gc.EnableWordWrap(false);
            gc.SetFont(Font'FontTiny');
            gc.SetTextColor(colText);

            if (amount > 0)
                gc.DrawText(28, 56, 32, 8, InvLabel @ amount); //Position below icon
            //gc.DrawText(28, 48, 32, 8, InvLabel @ amount); //Position at bottom of icon
        
            if (chargeLevel > 0)
                gc.DrawText(28, 34, 32, 8, Sprintf("%d%%", chargeLevel)); //Position center of icon
        }
	}
}

//Returns TRUE if this is not a charged item, or if it has charge left
function bool IsCharged(DeusExPickup item)
{
    local ChargedPickup charged;
    local int chargeLevel;

    if (item != None && item.IsA('ChargedPickup'))
    {
        charged = ChargedPickup(item);
        chargeLevel = int(charged.GetCurrentCharge());

        return (charged.numCopies > 1 || chargeLevel > 0);
    }
    else if (weapon != None && weapon.isA('WeaponNanoSword'))
        return WeaponNanoSword(weapon).ChargeManager.GetCurrentCharge() > 0;

    //Otherwise, it's charged
    return true;
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(13, 13, 80, 54, 0, 0, texBackground);
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
     infoX=66
     InvLabel="COUNT:"
     texBackground=Texture'RSDCrap.UserInterface.HudAmmoDisplayBackgroundSecondary'
     texBorder=Texture'RSDCrap.UserInterface.HudAmmoDisplayBorderSecondary'
     colIconDimmed=(R=64,G=64,B=64)
}
