//=============================================================================
// MenuScreenGMDXAIOptions
//=============================================================================

class MenuScreenGMDXAIOptions expands MenuUIScreenWindow;

function SaveSettings()
{
   Super.SaveSettings();
	player.SaveConfigOverride();
}

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_HackingLockouts'
     choices(1)=Class'DeusEx.MenuChoice_CameraState'
     choices(2)=Class'DeusEx.MenuChoice_CameraState2'
     choices(3)=Class'DeusEx.MenuChoice_HardcoreAI1'
     choices(4)=Class'DeusEx.MenuChoice_NewGameIntro'
     choices(5)=Class'DeusEx.MenuChoice_ExtraDetails'
     choices(6)=Class'DeusEx.MenuChoice_RestrictedMetabolism'
     choices(7)=Class'DeusEx.MenuChoice_HardcoreFilter'
     choices(8)=Class'DeusEx.MenuChoice_RealisticCarci'
     choices(9)=Class'DeusEx.MenuChoice_KnifeRemoval'
     choices(10)=Class'DeusEx.MenuChoice_ObjectTranslucency'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="GMDX Difficulty Options"
     ClientWidth=391
     ClientHeight=480
     clientTextures(0)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_1'
     clientTextures(1)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_2'
     clientTextures(2)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_3'
     clientTextures(3)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_4'
     textureCols=2
     bHelpAlwaysOn=True
     helpPosY=426
}
