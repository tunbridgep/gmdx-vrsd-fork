//=============================================================================
// DeusExNote
//=============================================================================
class DeusExNote extends Object;

var travel String text;				// Note text stored here.

var travel Bool bUserNote;			// True if this is a user-entered note
var travel DeusExNote next;			// Next note

// Text tag, used for DataCube notes to prevent 
// the same note fromgetting added more than once
var travel Name textTag;

var travel bool bHidden;            //SARGE: Allow us to add "hidden" notes that don't show up
                                    //Use these for codes given by emails

// ----------------------------------------------------------------------
// SetUserNote()
// ----------------------------------------------------------------------

function SetUserNote( Bool bNewUserNote )
{
	bUserNote = bNewUserNote;
}

// ----------------------------------------------------------------------
// SetTextTag()
// ----------------------------------------------------------------------

function SetTextTag( Name newTextTag )
{
	textTag = newTextTag;
}

function SetHidden( bool bNewHidden )
{
    bHidden = bNewHidden;
}

defaultproperties
{
}
