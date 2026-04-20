//=============================================================================
// ProgressBarWindow
//=============================================================================

class ProgressBarWindow extends Window;

var Float lowValue;
var Float highValue;
var Float currentValue;
var Int   barSize;
var Color colBackground;
var Color colForeground;
var Bool  bVertical;
var Bool  bUseScaledColor;
var Bool  bDrawBackground;
var Float scaleColorModifier;
var Bool bSpecialFX, bSpecialFX2;
var bool bInvertFill;               //SARGE: Fill it up from the opposite direction

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
    local Texture tex;
	Super.DrawWindow(gc);

	// First draw the background
	if (bDrawBackground)
	{
		gc.SetTileColor(colBackground);
        gc.DrawPattern(0, 0, width, height, 0, 0, Texture'Solid');
	}

	// Now draw the foreground
	gc.SetTileColor(colForeground);
	    
    if (bSpecialFX)
        tex = Texture'Effects.Electricity.Nano_SFX';
    else if (bSpecialFX2)
        tex = Texture'PersonaItemHighlight_Top';
    else
        tex = Texture'Solid';

	if (bVertical && bInvertFill)
        gc.DrawPattern(0, 0, width, barSize, 0, 0, tex);
	else if (bVertical)
        gc.DrawPattern(0, height - barSize, width, barSize, 0, 0, tex);
	else if (bInvertFill)
		gc.DrawPattern(width - barSize, 0, barSize, height, 0, 0, tex);
	else
		gc.DrawPattern(0, 0, barSize, height, 0, 0, tex);
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	UpdateBars();
}

// ----------------------------------------------------------------------
// SetValues()
// ----------------------------------------------------------------------

function SetValues(float newLow, float newHigh)
{
	lowValue  = newLow;
	highValue = newHigh;

	// Update bars
	UpdateBars();
}

// ----------------------------------------------------------------------
// SetCurrentValue()
// ----------------------------------------------------------------------

function SetCurrentValue(Float newValue)
{
	// First clamp the value
	newValue = Max(lowValue, newValue);
	newValue = Min(highValue, newValue);

	currentValue = newValue;

	UpdateBars();
}

// ----------------------------------------------------------------------
// UpdateBars()
// ----------------------------------------------------------------------

function UpdateBars()
{
	local Float valuePercent;
    local color colLoc;
	// Now calculate how large the bar is
	valuePercent = currentValue / Abs(highValue - lowValue);

	if (bVertical)
		barSize = valuePercent * height;
	else
		barSize = valuePercent * width;

	// Calculate the bar color
	if (bUseScaledColor)
	{
	    if (bSpecialFX)
	    {
	    colForeground.R = 255;
	    colForeground.G = 255;
	    colForeground.B = 255;
	    }
	    else
	    {
		colForeground = GetColorScaled(valuePercent);

		colForeground.r = Int(Float(colForeground.r) * scaleColorModifier);
		colForeground.g = Int(Float(colForeground.g) * scaleColorModifier);
		colForeground.b = Int(Float(colForeground.b) * scaleColorModifier);
		}
	}
    /* //SARGE: Why was this here?
	else
	{
		colForeground = Default.colForeground;
	}
    */
}

// ----------------------------------------------------------------------
// SetColors()
// ----------------------------------------------------------------------

function SetColors(Color newBack, Color newFore)
{
	colBackground = newBack;
	colForeground = newFore;
}

// ----------------------------------------------------------------------
// SetBackColor()
// ----------------------------------------------------------------------

function SetBackColor(Color newBack)
{
	colBackground = newBack;
}

// ----------------------------------------------------------------------
// SetScaleColorModifier()
// ----------------------------------------------------------------------

function SetScaleColorModifier(Float newModifier)
{
	scaleColorModifier = newModifier;
}

// ----------------------------------------------------------------------
// SetVertical()
// ----------------------------------------------------------------------

function SetVertical(Bool bNewVertical)
{
	bVertical = bNewVertical;
}

// ----------------------------------------------------------------------
// SetDrawBackground()
// ----------------------------------------------------------------------

function SetDrawBackground(Bool bNewDraw)
{
	bDrawBackground = bNewDraw;
}

// ----------------------------------------------------------------------
// UseScaledColor()
// ----------------------------------------------------------------------

function UseScaledColor(Bool bNewScaled)
{
	bUseScaledColor = bNewScaled;
}

// ----------------------------------------------------------------------
// SARGE: UseInvertedFill()
// ----------------------------------------------------------------------

function UseInvertedFill(Bool bNewInvert)
{
	bInvertFill = bNewInvert;
}

// ----------------------------------------------------------------------
// GetBarColor()
// ----------------------------------------------------------------------

function Color GetBarColor()
{
	return colForeground;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colBackground=(R=255,G=255,B=255)
     colForeground=(R=32,G=32,B=32)
     scaleColorModifier=1.000000
}
