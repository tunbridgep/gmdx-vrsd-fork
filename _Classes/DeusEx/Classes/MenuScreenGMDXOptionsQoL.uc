//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptionsQoL expands MenuScreenListWindow;

//Update crosshair when closing the menu
function SaveSettings()
{
    Super.SaveSettings();
    player.UpdateCrosshairStyle();
}

defaultproperties
{
     items(0)=(HelpText="If true, belt selection uses 'interact' (default: right click) to confirm selection, eliminating the act of cycling multiple items before reaching the desired. Classic mode additionally makes right click switch back after using the number keys.",actionText="Invisible War Toolbelt",variable="bAlternateToolbelt",valueText2="Classic");
     items(1)=(HelpText="Automtically add newly-acquired items to the toolbelt.",actionText="Autofill Belt",variable="bBeltAutofill",defaultValue=1);
     items(2)=(HelpText="After consuming the last item in a belt slot, it's position will be preserved.|nIf Autofill is off, dropped items will also be preserved. Right-Click to clear.",actionText="Belt Memory",variable="bBeltMemory",defaultValue=1);
     items(3)=(HelpText="Keyring is selected when interacting with locked doors. Belt slot 0 is made available to general items.",actionText="Smart Keyring",variable="bSmartKeyring");
     items(4)=(HelpText="Use a small dot-crosshair (or no crosshair) when no weapon is equipped, and in a few other cases.",actionText="Dynamic Crosshair",variable="dynamicCrosshair",valueText1="Dot",valueText2="Box",valueText3="Julian",valueText4="Hidden",defaultValue=1);
     items(5)=(HelpText="Use the number keys to select dialog choices",actionText="Numbered Replies",variable="bNumberedDialog",defaultValue=1);
     items(6)=(HelpText="Show Credits Balance in the Dialog Window",actionText="Dialog Credits",variable="bCreditsInDialog",defaultValue=1);
     items(7)=(HelpText="Use selected HUD Theme in dialog menus",actionText="Dialog HUD Colours",variable="bDialogHUDColors");
     items(8)=(HelpText="Enable/Disable the highlighted augmentation when closing the augmentation wheel. Cancel with right click.",actionText="Quick Augmentation Wheel",variable="bQuickAugWheel");
     items(9)=(HelpText="Enable/Disable the 'Disable All' button on the Augmentaiton Wheel",actionText="'Disable All' on Augmentation Wheel",variable="bAugWheelDisableAll",defaultValue=1);
     items(10)=(HelpText="Change weapon viewmodels to display better on some widescreen resolutions and FOV values.",actionText="Alternate Weapon Offsets",variable="bEnhancedWeaponOffsets");
     items(11)=(HelpText="If Enabled, alternate ammo is color-coded in the toolbelt.",actionText="Color Coded Ammo",variable="bColorCodedAmmo",defaultValue=1);
     items(12)=(HelpText="When dying, use a first or third person camera.",actionText="Death Perspective",variable="bRemoveVanillaDeath",valueText0="Third Person",valueText1="First Person");
     items(13)=(HelpText="If Enabled, attempting to pick up carryable objects will automatically holster your held weapon, enabling you to pick up the object.",actionText="Interaction Auto-Holster",variable="bAutoHolster");
     items(14)=(HelpText="Alternate realistic headbobbing effect. To disable headbobbing outright, see the standard Settings menu.",actionText="Realistic Head-Bobbing",variable="bModdedHeadBob",defaultValue=1);
     items(15)=(HelpText="Enable Subtitles in full-screen cinematics. This is independent of the regular Subtitles setting.",actionText="Subtitles in Cinematics",variable="bSubtitlesCutscene",defaultValue=1);
     items(16)=(HelpText="Crosshair turns blue when attempting to attach a mine to a surface.",actionText="Wall Placement Helper",variable="bWallPlacementCrosshair",defaultValue=1);
     items(17)=(HelpText="Always display the total amount of ammo available, rather than the number of magazines. Some weapons always show total ammo count.",actionText="Accurate Ammo Display",variable="bDisplayTotalAmmo");
     //items(18)=(HelpText="Weirdo!",actionText="Show CLIPS instead of MAGS. ",variable="bDisplayClips");
     items(18)=(HelpText="Display Lockpicking/Bypassing tooltips with yellow text if you only just meet the tool requirement, and red text if you don't meet the requirement.",actionText="Tool Window Colors",variable="bColourCodeFrobDisplay",defaultValue=1);
     items(19)=(HelpText="If enabled, the intro cutscene is not loaded.",actionText="Skip Intro",variable="bSkipNewGameIntro");
     items(20)=(HelpText="Breakable objects display hitpoints & throwable objects display mass. Not recommended for the sake of consistency.",actionText="Extra Object Details",variable="bExtraObjectDetails");
     items(21)=(HelpText="If enabled, you never retrieve combat knives from corpses.",actionText="Decline Knives",variable="bNoKnives");
     items(22)=(HelpText="If enabled, double right click to holster items in hand. Prevents accidentally putting away items when attempting to interact with the world.",actionText="Double-Click Holstering",variable="bDblClickHolster");
     items(23)=(HelpText="Enable alternate visuals for the bioenergy bar.",actionText="Animated Bioenergy Bar",variable="bAnimBar1",defaultValue=1);
     items(24)=(HelpText="Enable alternate visuals for the stamina bar.",actionText="Animated Stamina Bar",variable="bAnimBar2",defaultValue=1);
     items(25)=(HelpText="If enabled, a marker appears within your crosshair when dealing damage.",actionText="Hit Markers",variable="bHitMarkerOn",defaultValue=1);
     items(26)=(HelpText="Enable/disable level transition autosaving.",actionText="Autosave on Level Transition",variable="bTogAutoSave",defaultValue=1);


     Title="GMDX Quality of Life Options"
}
