//=============================================================================
// MenuScreenOptionsHidden
// GMDX:AE Hidden Options
//=============================================================================

class MenuScreenGMDXOptionsHidden expands MenuUIScreenWindow;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_GMDXPerkConfig'
     //choices(1)=Class'DeusEx.MenuChoice_GMDXGameplayOptions'
     //choices(2)=Class'DeusEx.MenuChoice_HDTPToggles'
     choices(3)=Class'DeusEx.MenuChoice_AmmoMod'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     Title="GMDX Hidden Options"
     ClientWidth=537
     ClientHeight=228
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuControlsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuControlsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuControlsBackground_3'
     textureRows=1
     helpPosY=174
}
