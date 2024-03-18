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
	SetSize(iconSize, iconSize);
	SetBackgroundStyle(iconMask);

	if (augmentation !=none && augmentation.IsActive())                         //RSD: ensure we are actually using the correct color
	{
		SetTileColor(colActive);
		isActive = true;
	}
	else
	{
		SetTileColor(colInactive);
        isActive = false;
	}

	highlt = HUDRadialMenuItemHighlight(NewChild(Class'HUDRadialMenuItemHighlight'));
	highlt.SetSize(iconSize, iconSize);
	highlt.Hide();
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

    // check if the augmentation needs to be activated (it can be already activated in some circumstances!)
	if (!augmentation.IsActive())
        augmentation.Activate();

    // prevent the aug from beeing rendered active despite of it beeing not activatable atm.
    //if (!augmentation.IsInState('Active')) return;                            //RSD: This lead to already active augs not displaying as such
    if (!augmentation.bIsActive)                                                //RSD: So check bIsActive instead
        return;

    SetTileColor(colActive);
    isActive=true;

}

function Deactivate() {
	if (augmentation.IsActive())
	   augmentation.Deactivate();

    if (augmentation.bIsActive)                                                 //RSD: If still active after attempting to deactivate (e.g. reactivating Spy Drone from being set), abort
        return;

	SetTileColor(colInactive);
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
	augmentation = aug;
	drawIcon();
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
