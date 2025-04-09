//-----------------------------------------------------------
// HUDRadialMenuItem.
//-----------------------------------------------------------
class HUDRadialMenuItem extends Window;


var Augmentation augmentation;
var Color colInactive;
var Color colActive;
var EDrawStyle iconMask;
var float iconSize;
var bool isActive;
var bool isHighlighted;
var HUDRadialMenuItemHighlight highlt;


event InitWindow() {
	Super.InitWindow();
    bTickEnabled = false;
	SetSize(iconSize, iconSize);
	SetBackgroundStyle(iconMask);
    SetTileColor(colInactive);

	if (augmentation != none)                         //RSD: ensure we are actually using the correct color
    {
        UpdateDisplayColor();
		isActive = augmentation.IsActive();
    }

	highlt = HUDRadialMenuItemHighlight(NewChild(Class'HUDRadialMenuItemHighlight'));
	highlt.SetSize(iconSize, iconSize);
	highlt.Hide();
}

//SARGE: New function to update the display colour independently.
//Called every tick while the menu is open, since we can now have augs changing
//colors independently (ie via recharging)
function UpdateDisplayColor()
{
	if (augmentation != none)                         //RSD: ensure we are actually using the correct color
    {
        //DeusExPlayer(GetPlayerPawn()).ClientMessage("Updating Aug " $ Augmentation.Name);
        SetTileColor(Augmentation.GetAugColor());
    }
}

function int CompareTo(HUDRadialMenuItem item) {
	local int hk1, hk2;
	hk1 = item.augmentation.HotKeyNum;
	hk2 = augmentation.HotKeyNum;

	if (hk1 > hk2) return 1;
	if (hk1 == hk2) return 0;
	if (hk1 < hk2) return -1;
}

function Activate() {

    if (!augmentation.CanBeActivated())
        return;

    // check if the augmentation needs to be activated (it can be already activated in some circumstances!)
	if (!augmentation.IsActive())
        augmentation.Activate();

    // prevent the aug from beeing rendered active despite of it beeing not activatable atm.
    //if (!augmentation.IsInState('Active')) return;                            //RSD: This lead to already active augs not displaying as such
    if (!augmentation.bIsActive)                                                //RSD: So check bIsActive instead
        return;

    UpdateDisplayColor();
    isActive=true;

}

function Deactivate() {
    if (!augmentation.CanBeActivated())
        return;

	if (augmentation.IsActive())
	   augmentation.Deactivate();

    if (augmentation.bIsActive)                                                 //RSD: If still active after attempting to deactivate (e.g. reactivating Spy Drone from being set), abort
        return;

    UpdateDisplayColor();
	isActive=false;
}



function Highlight() {
	if (isHighlighted) return;
	// draw border around icon
	highlt.Show();
	PlaySound(Sound'Menu_Focus', 0.25); // use this as item focus sound
	isHighlighted = true;
}


function Unhighlight() {
	if (!isHighlighted) return;
	highlt.Hide();
	//GetBottomChild().SetBackgroundStyle(DSTY_Translucent);

	isHighlighted = false;
}

function drawIcon() {
	SetBackground(augmentation.icon);
}


function SetItem(Augmentation aug) {
    if (aug != None)
    {
        augmentation = aug;
        drawIcon();
    }
}

/**
 * Returns the size of this window.
 */
function int GetSize() {
	return iconSize;
}

/**
 * Uses the passed vector to determine its new position relative to this vector.
 */
function SetRelativePos(Vector pos) {
	// Move win in a manner so that the vector points at its center
	SetPos(pos.X-iconSize/2, pos.Y-iconSize/2);
}

function Tick()
{
    UpdateDisplayColor();
}

event VisibilityChanged(bool isVis)
{
	bTickEnabled = isVis;
}

function Vector GetRelativePos() {
	local Vector v;
	v.X = x+width/2;
	v.Y = y+height/2;
	return v;
}

defaultproperties
{
     colInactive=(R=255,G=255,B=255)
     colActive=(R=255,G=255)
     iconMask=DSTY_Translucent
     iconSize=52.000000
}
