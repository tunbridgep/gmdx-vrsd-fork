//=============================================================================
// StaticWindow
//=============================================================================
class StaticInterlacedWindow expands Window;

// ----------------------------------------------------------------------
// Local Variables
// ----------------------------------------------------------------------

var Float lineInterval;
var Float lastLine;
var int currentLinePosY;
var Bool bLinePauseDelay;
var Bool bLineVisible;
var Float linePauseDelay;
var() Texture StaticTexture;
var() int linespeed;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	Hide();
}

// ----------------------------------------------------------------------
// RandomizeStatic()
// ----------------------------------------------------------------------

function RandomizeStatic()
{
	currentLinePosY = (Rand(hardcodedHeight) - 6);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	// First draw the static
	gc.SetStyle(DSTY_Modulated);
	gc.DrawPattern(0, 0, width, height, rand(64), 0, StaticTexture);

	// Now draw the line
	if (bLineVisible)
	{
		gc.SetStyle(DSTY_Modulated);
		gc.DrawPattern(0, currentLinePosY, width, 6, 0, 0, Texture'StaticLine');
	}
}

// ----------------------------------------------------------------------
// VisibilityChanged()
// ----------------------------------------------------------------------

event VisibilityChanged(bool bNewVisibility)
{
	bTickEnabled = (bNewVisibility && bLineVisible);
}

// ----------------------------------------------------------------------
// Tick()
//
// Used to update the energy bar
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
	lastLine += deltaSeconds;

	if (bLinePauseDelay)
	{
		if (lastLine > linePauseDelay)
		{
			bLinePauseDelay = False;
			lastLine = 0.0;
		}
	}
	else
	{
		if (lastLine > LineInterval)
		{
			lastLine = 0.0;

			currentLinePosY += linespeed;

			if (currentLinePosY > Height)
			{
				currentLinePosY = -6;
				bLinePauseDelay = True;

				if(FRand() > 0.60);
					currentLinePosY = -Height*FRand();
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     currentLinePosY=-6
     bLineVisible=True
     StaticTexture=Texture'GameMedia.UI.VisorLined'
     linespeed=15
}
