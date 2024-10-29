//=============================================================================
// MenuScreenGMDXAIOptions
//=============================================================================

class MenuScreenGMDXOptionsBelt expands MenuScreenListWindow;

function SaveSettings()
{
    Super.SaveSettings();
	player.SaveConfig();
}

defaultproperties
{
     items(0)=(HelpText="If true, belt selection uses 'interact' (default: right click) to confirm selection, eliminating the act of cycling multiple items before reaching the desired. Classic mode additionally makes right click switch back after using the number keys.",actionText="Invisible War Toolbelt",variable="bAlternateToolbelt",valueText3="Classic");
     items(1)=(HelpText="Automtically add newly-acquired items to the toolbelt.",actionText="Autofill Belt",variable="bBeltAutofill",defaultValue=1);
     items(2)=(HelpText="After consuming the last item in a belt slot, it's position will be preserved.|nIf Autofill is off, dropped items will also be preserved. Right-Click to clear.",actionText="Belt Memory",variable="bBeltMemory",defaultValue=1);
     items(3)=(HelpText="Keyring is selected when interacting with locked doors. Belt slot 0 is made available to general items.",actionText="Smart Keyring",variable="bSmartKeyring");
     items(4)=(HelpText="Use a small dot-crosshair (or no crosshair) when no weapon is equipped, and in a few other cases.",actionText="Dynamic Crosshair",variable="dynamicCrosshair",valueText2="Dot",valueText3="Box",valueText4="Julian",valueText5="Nothing",defaultValue=1);
     items(5)=(HelpText="Use the number keys to select dialog choices",actionText="Numbered Replies",variable="bNumberedDialog",defaultValue=1);
     items(6)=(HelpText="Show Credits Balance in the Dialog Window",actionText="Dialog Credits",variable="bCreditsInDialog",defaultValue=1);
     items(7)=(HelpText="Use selected HUD Theme in dialog menus",actionText="Dialog HUD Colours",variable="bDialogHUDColors",defaultValue=1);
     items(8)=(HelpText="Enable/Disable the highlighted augmentation when closing the augmentation wheel. Cancel with right click.",actionText="Quick Augmentation Wheel",variable="bQuickAugWheel",defaultValue=1);
     items(9)=(HelpText="Enable/Disable the 'Disable All' button on the Augmentaiton Wheel",actionText="'Disable All' on Augmentation Wheel",variable="bAugWheelDisableAll",defaultValue=1);
     items(10)=(HelpText="Change weapon viewmodels to display better on widescreen resolutions.",actionText="Enhanced Weapon Offsets",variable="bEnhancedWeaponOffsets");
     Title="GMDX Quality of Life Options"
}
