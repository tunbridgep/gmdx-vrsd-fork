//=============================================================================
// MenuUIActionButtonWindow
//=============================================================================

class MenuUIActionButtonWindow extends MenuUIBorderButtonWindow;

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
     Left_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuActionButtonNormal_Left',Width=8)
     Left_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuActionButtonPressed_Left',Width=8)
     Right_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuActionButtonNormal_Right',Width=11)
     Right_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuActionButtonPressed_Right',Width=11)
     Center_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.MenuActionButtonNormal_Center',Width=2)
     Center_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.MenuActionButtonPressed_Center',Width=2)
     buttonHeight=19
     minimumButtonWidth=83
     textLeftMargin=8
}
