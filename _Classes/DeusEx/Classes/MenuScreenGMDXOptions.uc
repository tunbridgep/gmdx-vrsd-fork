//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptions expands MenuUIScreenWindow;

// Keep a pointer to the root window handy
var DeusExRootWindow root;

// Keep a pointer to the player for easy reference
var DeusExPlayer player;

event InitWindow()
{
    root = DeusExRootWindow(GetRootWindow());
    player = DeusExPlayer(root.parentPawn);
    if (!player.bHardcoreUnlocked)
        choices[1]=Class'DeusEx.MenuChoice_AIOptionsFake';

	Super.InitWindow();

}
// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------
//GMDX MODDED SO XHair SAVES CORRECT
//however player.SaveConfig() called by almost every menu option and as its final!
function SaveSettings()
{
   Super.SaveSettings();
	player.SaveConfigOverride();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_GMDXAdvancedOption'
     choices(1)=Class'DeusEx.MenuChoice_AIOptions'
     choices(2)=Class'DeusEx.MenuChoice_CreateCustomColor'
     choices(3)=Class'DeusEx.MenuChoice_ColorCodedAmmo'
     choices(4)=Class'DeusEx.MenuChoice_HDTPToggles'
     choices(5)=Class'DeusEx.MenuChoice_FirstPersonDeath'
     choices(6)=Class'DeusEx.MenuChoice_AutomaticHolster'
     choices(7)=Class'DeusEx.MenuChoice_AltHeadbob'
     choices(8)=Class'DeusEx.MenuChoice_Mantling'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="GMDX Options"
     ClientWidth=391
     ClientHeight=408
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuDisplayBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuDisplayBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuDisplayBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuDisplayBackground_4'
     textureCols=2
     helpPosY=354
}
