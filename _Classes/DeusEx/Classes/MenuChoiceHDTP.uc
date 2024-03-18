class MenuChoiceHDTP extends MenuUIChoice;

// Defaults
var MenuUIInfoButtonWindow btnInfo;

var int    defaultInfoWidth;
var int    defaultInfoPosX;

// ----------------------------------------------------------------------
// CreateInfoButton()
// ----------------------------------------------------------------------

function CreateInfoButton()
{
	btnInfo = MenuUIInfoButtonWindow(NewChild(Class'MenuUIInfoButtonWindow'));

	btnInfo.SetSelectability(False);
	btnInfo.SetSize(defaultInfoWidth, 19);
	btnInfo.SetPos(defaultInfoPosX, 0);
	btnInfo.SetButtonText(GetTextVal());
}

function UpdateInfoButton()
{
	btnInfo.SetButtonText(GetTextVal());
}

function string GetTextVal()
{
	local int i;
	local string str;

	if(actiontext == "Global")
	{
		if(player != none)
		{
			i = player.bHDTP_ALL;
			if(i < 0)
				str = "None";
			else if(i > 0)
				str = "All";
			else
				str = "Custom";
		}
	}
	else if(actiontext == "JC")
	{
		if(player != none)
		{
			str = string(player.bHDTP_JC);
		}
	}
	else if(actiontext == "Paul")
	{
		if(player != none)
		{
			str = string(player.bHDTP_Paul);
		}
	}
	else if(actiontext == "Gunther")
	{
		if(player != none)
		{
			str = string(player.bHDTP_Gunther);
		}
	}
	else if(actiontext == "Anna")
	{
		if(player != none)
		{
			str = string(player.bHDTP_Anna);
		}
	}
	else if(actiontext == "Nicolette")
	{
		if(player != none)
		{
			str = string(player.bHDTP_Nico);
		}
	}
	else if(actiontext == "NSF")
	{
		if(player != none)
		{
			str = string(player.bHDTP_NSF);
		}
	}
	else if(actiontext == "Riot Cop")
	{
		if(player != none)
		{
			str = string(player.bHDTP_RiotCop);
		}
	}
	else if(actiontext == "Simons")
	{
		if(player != none)
		{
			str = string(player.bHDTP_Walton);
		}
	}
	else if(actiontext == "UNATCO")
	{
		if(player != none)
		{
			str = string(player.bHDTP_UNATCO);
		}
	}
	//else if(actiontext == "MJ12")
	//{
	//	if(player != none)
	//	{
	//		str = string(player.bHDTP_MJ12);
	//	}
	//}
	return str;
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	if(actiontext == "Global")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "ALL");
		}
	}
	else if(actiontext == "JC")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "JC");
		}
	}
	else if(actiontext == "Paul")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "PAUL");
		}
	}
	else if(actiontext == "Gunther")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "GUNTHER");
		}
	}
	else if(actiontext == "Anna")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "ANNA");
		}
	}
	else if(actiontext == "Nicolette")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "NICO");
		}
	}
	else if(actiontext == "NSF")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "NSF");
		}
	}
	else if(actiontext == "Riot Cop")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "COP");
		}
	}
	else if(actiontext == "Simons")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "WALTON");
		}
	}
	else if(actiontext == "UNATCO")
	{
		if(player != none)
		{
			player.ConsoleCommand("HDTP " $ "UNATCO");
		}
	}
	//else if(actiontext == "MJ12")
	//{
	//	if(player != none)
	//	{
	//		player.ConsoleCommand("HDTP " $ "MJ12");
	//	}
	//}
	else
		super.CycleNextValue();

	UpdateInfoButton();
	Player.SaveConfigOverride();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	CycleNextValue(); //fuck it
}

defaultproperties
{
     defaultInfoWidth=98
     defaultInfoPosX=270
     actionText=""
}
