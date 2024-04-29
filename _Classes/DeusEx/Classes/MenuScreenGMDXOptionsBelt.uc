//=============================================================================
// MenuScreenGMDXAIOptions
//=============================================================================

class MenuScreenGMDXOptionsBelt expands MenuUIScreenWindow;

function SaveSettings()
{
    Super.SaveSettings();
	player.SaveConfig();
}

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_AlternBelt'
     choices(1)=Class'DeusEx.MenuChoice_AutofillBelt'
     choices(2)=Class'DeusEx.MenuChoice_BeltMemory'
     choices(3)=Class'DeusEx.MenuChoice_SmartKeyring'
     choices(4)=Class'DeusEx.MenuChoice_DynamicCrosshair'
     choices(5)=Class'DeusEx.MenuChoice_NumberedReplies'
     choices(6)=Class'DeusEx.MenuChoice_DialogCredits'
     choices(7)=Class'DeusEx.MenuChoice_DialogHUDColors'
     choices(8)=Class'DeusEx.MenuChoice_QuickAugWheel'
     choices(9)=Class'DeusEx.MenuChoice_AugWheelDisableAllButton'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="GMDX Quality of Life Options"
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
