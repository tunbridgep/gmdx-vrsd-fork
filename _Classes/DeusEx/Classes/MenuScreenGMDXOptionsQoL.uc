//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptionsQoL expands MenuScreenListWindow;

//Update crosshair when closing the menu
function SaveSettings()
{
    Super.SaveSettings();
    player.UpdateCrosshairStyle();
    player.UpdateHUD();
}

defaultproperties
{
     items(0)=(HelpText="Enable/Disable the 'Disable All' button on the Augmentaiton Wheel.",actionText="Augmentation Wheel: 'Disable All'",variable="bAugWheelDisableAll",defaultValue=1);
     items(1)=(HelpText="Enable/Disable the highlighted augmentation when closing the augmentation wheel without requiring left-click. Cancel with right click.",actionText="Augmentation Wheel: Quick Select",variable="bQuickAugWheel");
     items(2)=(HelpText="Automtically add newly-acquired items to the toolbelt.",actionText="Belt: Autofill Belt",variable="bBeltAutofill",defaultValue=1);
     items(3)=(HelpText="After consuming the last item in a belt slot, it's position will be preserved.|nIf Autofill is off, dropped items will also be preserved. Right-Click to clear.",actionText="Belt: Belt Memory",variable="bBeltMemory",defaultValue=1);
     items(4)=(HelpText="Right-click confirms belt selection, removing the need to cycle through items to reach desired slot. Classic mode makes right-click switch back after using the number keys.",actionText="Belt: Invisible War Toolbelt",variable="bAlternateToolbelt",valueText2="Classic");
     items(5)=(HelpText="Keyring is selected when left-clicking on locked doors. Belt slot 0 is made available to general items.",actionText="Belt: Smart Keyring",variable="bSmartKeyring");
     items(6)=(HelpText="Modified weapons will have a '+' added to their name in the belt.",actionText="Belt: Show Modified Weapons",variable="bBeltShowModified");
     items(7)=(HelpText="Adjust the Field-of-View during dialog scenes to more closely match the original game.",actionText="Conversations: FOV Adjustment",variable="bCutsceneFOVAdjust",defaultValue=1);
     items(8)=(HelpText="Enable Subtitles in full-screen cinematics. This is independent of the regular Subtitles setting.",actionText="Conversations: Subtitles",variable="bSubtitlesCutscene",defaultValue=1);
     items(9)=(HelpText="Use the number keys to select dialog choices.",actionText="Conversations: Numbered Replies",variable="bNumberedDialog",defaultValue=1);
     items(10)=(HelpText="Show Credits Balance in the Dialog Window.",actionText="Conversations: Show Credits",variable="bCreditsInDialog",defaultValue=1);
     items(11)=(HelpText="Use selected HUD Theme in dialog menus.",actionText="Conversations: Use HUD Colours",variable="bDialogHUDColors");
     items(12)=(HelpText="If enabled, the intro cutscene is not loaded.",actionText="Game: Skip Intro",variable="bSkipNewGameIntro");
     items(13)=(HelpText="Enable/disable level transition autosaving.",actionText="Player: Autosave on Level Change",variable="bTogAutoSave",defaultValue=1);
     items(14)=(HelpText="Always display the total amount of ammo available, rather than the number of magazines. Some weapons always show total ammo count.",actionText="HUD: Accurate Ammo Display",variable="bDisplayTotalAmmo");
     items(15)=(HelpText="Change weapon viewmodels to display better on some widescreen resolutions.",actionText="HUD: Alternate Weapon Offsets",variable="bEnhancedWeaponOffsets");
     items(16)=(HelpText="Display CLIPS or MAGS in the Ammo window. Has no effect for weapons that don't use magazines, or if Accurate Ammo Display is turned on.",actionText="HUD: Ammo Text Display",variable="bDisplayClips",valueText0="MAGS",valueText1="CLIPS",defaultValue=1);
     items(17)=(HelpText="Enable alternate visuals for the bioenergy bar.",actionText="HUD: Animated Bioenergy Bar",variable="bAnimBar1",defaultValue=1);
     items(18)=(HelpText="Enable alternate visuals for the stamina bar.",actionText="HUD: Animated Stamina Bar",variable="bAnimBar2",defaultValue=1);
     items(19)=(HelpText="If Enabled, alternate ammo is color-coded in the toolbelt.",actionText="HUD: Color Coded Ammo",variable="bColorCodedAmmo",defaultValue=1);
     items(20)=(HelpText="Use a small dot-crosshair (or no crosshair) when no weapon is equipped, and in a few other cases.",actionText="HUD: Dynamic Crosshair",variable="dynamicCrosshair",valueText1="Dot",valueText2="Box",valueText3="Julian",valueText4="Hidden",defaultValue=1);
     items(21)=(HelpText="Breakable objects display hitpoints & throwable objects display mass. Not recommended for the sake of consistency.",actionText="HUD: Extra Object Details",variable="bExtraObjectDetails");
     items(22)=(HelpText="If enabled, a marker appears within your crosshair when dealing damage.",actionText="HUD: Hit Markers",variable="bHitMarkerOn",defaultValue=1);
     items(23)=(HelpText="Display Lockpicking/Bypassing tooltips with yellow text if you only just meet the tool requirement, and red text if you don't meet the requirement.",actionText="HUD: Tool Window Colors",variable="bColourCodeFrobDisplay",defaultValue=1);
     items(24)=(HelpText="If enabled, the crosshair will turn blue when attempting to attach a mine to a surface.",actionText="HUD: Wall Placement Helper",variable="bWallPlacementCrosshair",defaultValue=1);
     items(25)=(HelpText="If Enabled, attempting to pick up carryable objects will automatically holster your held weapon, enabling you to pick up the object.",actionText="Interaction: Auto-Holster",variable="bAutoHolster");
     items(26)=(HelpText="If enabled, you never retrieve combat knives from corpses.",actionText="Interaction: Decline Knives",variable="bNoKnives");
     items(27)=(HelpText="If enabled, double-right click to holster/unholster items in hand. Prevents accidentally putting away items when attempting to interact with the world.",actionText="Interaction: Double-Click Holstering",variable="bDblClickHolster");
     items(28)=(HelpText="If enabled, right clicking a corpse for the first time will never pick it up, to stop accidentally picking up corpses while searching for items.",actionText="Interaction: Enhanced Looting",variable="bEnhancedCorpseInteractions",defaultValue=1);
     items(29)=(HelpText="Append [Searched] text to corpses when they are interacted with.",actionText="Interaction: Show Searched Labels",variable="bSearchedCorpseText");
     items(30)=(HelpText="Changes lighting on some maps to reduce strobing and flickering.",actionText="Lighting: Lighting Accessibility",variable="bLightingAccessibility");
     items(31)=(HelpText="When dying, switch to a first or third person camera.",actionText="Player: Death Perspective",variable="bRemoveVanillaDeath",valueText0="Third Person",valueText1="First Person");
     items(32)=(HelpText="Alternate realistic headbobbing effect. To disable headbobbing outright, see the standard Settings menu.",actionText="Player: Realistic Head-Bobbing",variable="bModdedHeadBob",defaultValue=1);
     Title="GMDX Quality of Life Options"
}
