//=============================================================================
// MenuUIHeaderWindow
//=============================================================================

class MenuUIHeaderWindow extends MenuUILabelWindow;

//SARGE: Now we need to actually do this with a function, a property is no longer good enough!
event InitWindow()
{
	Super.InitWindow();
	SetFont(player.FontManager.GetFont(TT_FontMenuHeaders));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
