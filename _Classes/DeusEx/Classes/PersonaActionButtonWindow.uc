//=============================================================================
// PersonaActionButtonWindow
//=============================================================================

class PersonaActionButtonWindow extends PersonaBorderButtonWindow;

//TODO: Remove this, replace with tag
var perk ButtonPerk;

//SARGE: Allows defining custom tag text for a button we can read later, for identifying buttons
var string tags[10];
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;
	theme = player.ThemeManager.GetCurrentHUDColorTheme();
	bTranslucent  = player.GetHUDBackgroundTranslucency();
	colButtonFace = theme.GetColorFromName('HUDColor_ButtonFace');
	// Normal button color
	colText[0]    = theme.GetColorFromName('HUDColor_ButtonTextNormal');
	// Focus, pressed
	colText[1]    = colText[0];
	colText[2]    = theme.GetColorFromName('HUDColor_ButtonTextFocus');
	// Disabled button
	colText[3]    = theme.GetColorFromName('HUDColor_ButtonTextFocus');
}

defaultproperties
{
     Left_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.PersonaActionButtonNormal_Left',Width=4)
     Left_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.PersonaActionButtonPressed_Left',Width=4)
     Right_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.PersonaActionButtonNormal_Right',Width=8)
     Right_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.PersonaActionButtonPressed_Right',Width=8)
     Center_Textures(0)=(Tex=Texture'DeusExUI.UserInterface.PersonaActionButtonNormal_Center',Width=2)
     Center_Textures(1)=(Tex=Texture'DeusExUI.UserInterface.PersonaActionButtonPressed_Center',Width=2)
     buttonHeight=16
     minimumButtonWidth=20
     bBaseWidthOnText=true
     bCenterText=true
}