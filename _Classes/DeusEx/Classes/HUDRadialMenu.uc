//=============================================================================
// HUDRadialMenu
//=============================================================================
class HUDRadialMenu extends Window;

var DeusExPlayer player; // local reference to Jesus Christ
var DeusExRootWindow root;

const MAX_AUG_SLOTS = 11; // number of available aug slots in body
const FULL_CIRCLE = 65536; // in Unreal-thingy units

var vector screenCenter;
var vector center; // the center of the menu
var float radius; // the circle's radius
var vector pos; // a positional vector on the wheel. Like a needle on a tachometer
var vector tmpVec;
var Vector cursorPos;

var int maxItems; // maximum number of items
var int itemCount;
var Rotator itemAngle; // the angle between two items within the wheel
var HUDRadialMenuItem orderedItems[11]; // set the array length to something >= 10 if you want
var HUDRadialMenuItem highlightedItem;
var Window focusMarker;
var Color focusMarkerCol;
var EDrawStyle focusMarkerStyle;
var Texture focusMarkerTex;
var float markerDistanceToCenter;

var int activeItems;
var HUDRadialMenuItem power; // just a reference to a Child item. For conveniece. power is referenced as first item in orderedItems.
var Texture powerActive;
var Texture powerInactive;

var bool skipQuickToggle;            //Skip toggling augs on menu close if this is set
var bool bClicked;                   //Skip toggling augs on menu close if this is set

var bool bDoneFirst;                //Center the cursor the first time we open the wheel

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow() {
	Super.InitWindow();
	root = DeusExRootWindow(GetRootWindow());
	player = DeusExPlayer(GetPlayerPawn());
	createFocusMarker();
	SetMaxItems(MAX_AUG_SLOTS);
	createPowerIcon();
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

event ConfigurationChanged() {
	radius = height/2;
	center.X = width/2;
	center.Y = height/2;
	screenCenter.X = root.width/2;
	screenCenter.Y = root.height/2;
	positionItems();
    positionPowerIcon();
    positionMarker(mouseToMarkerPos(cursorPos));
}

// ----------------------------------------------------------------------
// Tick()
//
// ATTENTION:   `pos` has a two tasks here: it's used as a positional vector AND
//              to save the cursor pos for the next Tick!
// ----------------------------------------------------------------------

event Tick(float deltaSeconds) {
    getCursorPosition(cursorPos.X, cursorPos.Y);
	if (cursorPos == pos) return;
	// mouse actually moved
	pos = mouseToMarkerPos(cursorPos);
	positionMarker(pos);
    if (!skipQuickToggle)
    	highlightSingleItem(getNearestItem(pos));
    else
        highlightSingleItem(None);

	pos = cursorPos; // save last mouse pos for next tick
}


/**
 * Hide/show the Menu
 */
event VisibilityChanged(bool isVis) {
	// enable tick event when visible
	bTickEnabled = isVis;
    player.bShowMenu=isVis;

	if (isVis)
    {
    
        //Reset cursor to center
        if (!player.bAugWheelRememberCursor || !bDoneFirst)
        {
            cursorPos = center;
            //positionMarker(mouseToMarkerPos(center+vect(0,1,0)));
            bDoneFirst = true;
        }

        positionItems();
        positionPowerIcon();
        if (!player.bQuickAugWheel)
            PlaySound(Sound'Menu_Activate', 0.25);
        skipQuickToggle = false;
        bClicked = false;
    }
	else
    {
        //Toggle aug on closing, if we have Quick Aug Menu on
        if (player.bQuickAugWheel && !skipQuickToggle && !bClicked)
            ToggleCurrent();
        else
    	    PlaySound(Sound'Menu_OK', 0.25);
    }
}

/**
 * Gets the mouse position from the mouse acceleration.
 */
function getCursorPosition(out float x, out float y) {
    local float tmpX, tmpY;
    tmpX = player.aMouseX*player.default.MouseSensitivity/(width * 0.0005);
    tmpY = player.aMouseY*player.default.MouseSensitivity/(height * -0.0005);

    if (x+tmpX < 0) x = 0;
    else x = fmin(tmpX+x, width);

    if (y+tmpY < 0) y=0;
    else y = fmin(tmpY+y, height);
}


/**
 * Highlight a single item on the wheel.
 */
function highlightSingleItem(HUDRadialMenuItem item) {
    local int i;

    if (highlightedItem == item) return;
    for (i = 0; i < itemCount; i++)
     if (orderedItems[i] != item)
    	// unhighlight all other items
    	orderedItems[i].Unhighlight();

    item.Highlight();
    highlightedItem = item;
}

/**
 * (De-)Activates the currently highlited aug.
 */
function ToggleCurrent() {

    //Left-click prevents quick-toggle
    bClicked = true;

    if (highlightedItem == power && activeItems > 0) {
        player.ForceDroneOff();
        player.DeactivateAllAugs();
        activeItems = player.augmentationSystem.NumAugsActive(); //SARGE: Was hardcoded to 0. Now that we aren't deactivating toggled augs, we need to re-read the number
        updatePowerStatus();
        return;
    }

    if (highlightedItem.isActive)
        highlightedItem.Deactivate();
    else
        highlightedItem.Activate();
}

/**
 * Determine which item is closest (has smallest angle) related to v.
 *
 * @param v - A vector sticking out from the center of the wheel
 */
function HUDRadialMenuItem getNearestItem(vector v) {
    local int i;
    local Vector minAngle, tmp;
    local HUDRadialMenuItem nearest;
    local int visible;

    visible = GetVisibleItems();
    
    if (visible == 1)
        return GetFirstVisibleItem();
    else if (visible == 0)
        return orderedItems[0];

    for (i = 0; i < itemCount; i++) {
        tmp = orderedItems[i].GetRelativePos()-v;
        if (nearest == None || VSize(tmp) < VSize(minAngle)) {
            minAngle = tmp;
            nearest = orderedItems[i];
        }
    }

    return nearest;
}


/**
 * The focus marker is the small white dot that indicates a relative position of
 * the cursor's on the wheel.
 */
function createFocusMarker() {
	focusMarker = NewChild(Class'Window');
	focusMarker.SetBackground(focusMarkerTex);
	focusMarker.SetTileColor(focusMarkerCol);
	focusMarker.SetBackgroundStyle(focusMarkerStyle);
}


/**
 * Converts a given x-y-mouse position to a point in the orbit of the marker.
 */
function Vector mouseToMarkerPos(Vector absPos) {
    if (player.bAugWheelFreeCursor)
        return absPos;
    return center+markerDistanceToCenter*(radius-focusMarker.height)*Normal(absPos-center);
}


/**
 * Positions the marker
 */
function Vector positionMarker(Vector pos) {
	focusMarker.SetPos(pos.X-focusMarker.width/2, pos.Y-focusMarker.height/2);
}


function createPowerIcon() {
    orderedItems[0] = HUDRadialMenuItem(NewChild(Class'HUDRadialMenuItem'));
    itemCount ++;
    power = orderedItems[0];
    updatePowerStatus();
}

function positionPowerIcon() {
    pos = center + (radius - power.iconSize)*vect(0,1,0);
    power.SetRelativePos(pos);
}


function updatePowerStatus() {
    if (activeItems > 0)
        power.SetBackground(powerActive);
    else
       power.SetBackground(powerInactive);
}

function bool IsItemVisible(int item)
{
    return orderedItems[item].augmentation.bAddedToWheel;
}

/**
 * Calculates all item positions depending on how many items there are.
 * SARGE: Rewrote a lot of this to support the custom Aug wheel
 */

function HUDRadialMenuItem GetFirstVisibleItem()
{
	local int i;
	for (i = 1; i < itemCount; i++)
    {
        if (IsItemVisible(i))
            return orderedItems[i];
	}
    //return power button if enabled
    if (player.bAugWheelDisableAll)
        return orderedItems[0];
    return None;
}

function int GetVisibleItems()
{
	local int i;
    local int visibleiTems;
    
    //calculate the number of visible items
	for (i = 1; i < itemCount; i++)
    {
        if (IsItemVisible(i))
            visibleItems++;
	}

    //add power button if enabled
    if (player.bAugWheelDisableAll)
        visibleItems += 1;

    return visibleItems;
}

function positionItems() {
    local float angle;
	local Rotator ro;
	local int i;
    local int visibleiTems;

	if (itemCount == 0) return;

    visibleItems = GetVisibleItems();

    //show power button if enabled
    if (player.bAugWheelDisableAll)
        orderedItems[0].Show();
    else
        orderedItems[0].Hide();
	
    // recalc items agle
	angle = FULL_CIRCLE/visibleItems;
	itemAngle.Pitch = angle;
	itemAngle.Yaw = angle;

	ro.Pitch = 0;
	ro.Yaw = 0;

    //Single item? Put it in the middle
    if (visibleItems == 1)
        pos = vect(0,0,0);
    else
    {
        // pull Rotator to the left side so that the middle of all shown items
        // lies at the top of the radial menu (items are distributed evenly at left
        // and right sides). Subtract the first item which is the power button.
        ro -= 0.5*(visibleItems-2)*itemAngle;
        pos = (radius - orderedItems[0].iconSize)*vect(0,-1,0);
    }

	// iterate through all items (the children of the current window) and set
	// their position
	for (i = 1; i < itemCount; i++) {
        if (IsItemVisible(i))
        {
            orderedItems[i].Show();
            orderedItems[i].SetRelativePos(center+(pos >> ro));
            ro += itemAngle;
        }
        else
            orderedItems[i].Hide();
	}
}


/**
 * Save the reference to a menu item in an sorted array.
 * The sorting criteria has to be implemented by the item class
 * via a CompareTo()-method.
 */
function insertSorted(HUDRadialMenuItem item) {
	local HUDRadialMenuItem tmp;
	local int i;

	orderedItems[itemCount] = item; // ins at end
	itemCount ++;

	i = itemCount-2;
	while (i >= 1 && orderedItems[i].CompareTo(orderedItems[i+1]) < 0) {
		// lower item is higher in order hierarchy -> swap!
		tmp = orderedItems[i];
		orderedItems[i] = orderedItems[i+1];
		orderedItems[i+1] = tmp;
		i--;
	}

}

function SetMaxItems(int max) {
	maxItems = max;
}


/**
 * Destroys all child-windows and hides their icons except for 'power';
 */
function Clear() {
	local int i;

	for (i=1; i < itemCount; i++) {
	    orderedItems[i].Destroy();
        orderedItems[i] = None;
    }

	itemCount = 1;
}


/**
 * Since proper object orientation with interfaces isn't possible in this quagmire
 * we need to explicitly handle augs here, which is awful design *facepalm*
 */
function AddItem(Augmentation aug) {
    local HUDRadialMenuItem item;

    if (itemCount == maxItems) return;

    item = HUDRadialMenuItem(NewChild(Class'HUDRadialMenuItem'));
    item.SetItem(aug);
    if (aug.IsActive()) item.Activate();
    // the following order of function calls is necessary for a correct item positioning.
    insertSorted(item);
    positionItems();
}

/**
 * Toggle activation state of ->aug.
 */
function UpdateItemStatus(Augmentation aug) {
	local int i;

	if (itemCount == 0) return;

	for (i = 1; i < itemCount; i++) {
		if (orderedItems[i].augmentation == aug)
			break;
	}
	if (aug.IsActive() && !orderedItems[i].isActive) {
        orderedItems[i].Activate();
        activeItems = player.augmentationSystem.NumAugsActive(); //SARGE: Was hardcoded to incrementing. Now that we aren't deactivating toggled augs, we need to re-read the number
    }
	else {
        orderedItems[i].Deactivate();
        activeItems = player.augmentationSystem.NumAugsActive(); //SARGE: Was hardcoded to incrementing. Now that we aren't deactivating toggled augs, we need to re-read the number
    }

    updatePowerStatus();
}

defaultproperties
{
     Radius=250.000000
     cursorPos=(Y=-1.000000)
     focusMarkerCol=(R=255,G=255,B=255)
     focusMarkerStyle=DSTY_Translucent
     focusMarkerTex=Texture'RSDCrap.UserInterface.WhiteDot'
     markerDistanceToCenter=0.500000
     powerActive=Texture'RSDCrap.UserInterface.PowerIconActive'
     powerInactive=Texture'RSDCrap.UserInterface.PowerIconInactive'
}
