//=============================================================================
// MenuUIInfoButtonWindow
//=============================================================================

class MenuUIInfoButtonWindow extends MenuUIBorderButtonWindow;

//SARGE: Now we need to actually do this with a function, a property is no longer good enough!
event InitWindow()
{
	Super.InitWindow();
    fontButtonText=player.FontManager.GetFont(TT_FontMenuTitle);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Left_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuInfoButton_Left',Width=6)
     Left_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuInfoButton_Left',Width=6)
     Right_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuInfoButton_Right',Width=11)
     Right_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuInfoButton_Right',Width=11)
     Center_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuInfoButton_Center',Width=2)
     Center_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuInfoButton_Center',Width=2)
     buttonHeight=19
     textLeftMargin=8
     bUseTextOffset=False
}
