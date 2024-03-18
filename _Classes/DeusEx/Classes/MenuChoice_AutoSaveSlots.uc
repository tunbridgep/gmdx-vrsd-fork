//=============================================================================
// MenuChoice_LogTimeoutValue
//=============================================================================

class MenuChoice_AutoSaveSlots extends MenuUIChoiceSlider;

var localized String msgSecond;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(player.QuickSaveTotal);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	player.QuickSaveTotal = int(GetValue());
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	local float timeOut;
	local int enumIndex;

	enumIndex=0;
	for(timeOut=1; timeOut<=21; timeOut+=1)
	{
		SetEnumeration(enumIndex++, enumIndex);//Left(String(timeOut), Instr(String(timeOut), ".") + 2) $ msgSecond);
	}
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(defaultValue);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     msgSecond="Slot"
     numTicks=20
     startValue=1.000000
     endValue=20.000000
     defaultValue=10.000000
     HelpText="Select how many autosave slots are cycled through."
     actionText="|&Autosave Slots"
}
