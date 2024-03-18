//=============================================================================
// PersonaActionButtonWindow
//=============================================================================

class PersonaActionButtonWindow extends PersonaBorderButtonWindow;

var int PerkSkillCost;
var int PerkSkillCost2;
var int PerkSkillCost3;
var string PerkNamed;
var string PerkNamed2;
var string PerkNamed3;
var string LocalizedPerkNamed;
var string LocalizedPerkNamed2;
var string LocalizedPerkNamed3;
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

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
}
