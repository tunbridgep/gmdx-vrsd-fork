//=============================================================================
// HUDRightSidedWindow
// SARGE: Manages an offset so that it can be used on the left or right side of the screen.
// This class is very basic, most stuff happens in the actual windows themselves.
//=============================================================================
class HUDRightSidedWindow expands HUDBaseWindow;

//SARGE: Right side of screen stuff
var bool bRightSided;

var int offset;

var const int leftSideOffset;
var const int rightSideOffset;

// ----------------------------------------------------------------------
// SetRightSide()
// SARGE: Set up the display to work on the right side of the screen
// ----------------------------------------------------------------------
function SetRightSide(bool rightSide)
{
    bRightSided = rightSide;
    
    if (rightSide)
        offset = rightSideOffset;
    else
        offset = leftSideOffset;
}
