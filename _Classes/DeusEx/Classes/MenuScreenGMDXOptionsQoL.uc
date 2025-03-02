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
     items(0)=(HelpText="Enable a free cursor in the augmentation wheel, rather than being locked to a circular motion.",actionText="Augmentation Wheel: Free Cursor",variable="bAugWheelFreeCursor",defaultValue=1);
     items(1)=(HelpText="Enable/Disable the highlighted augmentation when closing the augmentation wheel without requiring left-click. Cancel with right click.",actionText="Augmentation Wheel: Quick Select",variable="bQuickAugWheel");
     items(2)=(HelpText="Remember the Cursor Position in the Augmentation Wheel",actionText="Augmentation Wheel: Remember Cursor Position",variable="bAugWheelRememberCursor");
     items(3)=(HelpText="Enable/Disable the 'Disable All' button on the Augmentaiton Wheel.",actionText="Augmentation Wheel: Show 'Disable All'",variable="bAugWheelDisableAll",defaultValue=1);
     items(4)=(HelpText="Automtically add newly-acquired items to the toolbelt.",actionText="Belt: Autofill Belt",variable="bBeltAutofill",defaultValue=1);
     items(5)=(HelpText="After consuming the last item in a belt slot, it's position will be preserved.|nIf Autofill is off, dropped items will also be preserved. Right-Click to clear.",actionText="Belt: Belt Memory",variable="bBeltMemory",defaultValue=1);
     items(6)=(HelpText="Right-click confirms belt selection, removing the need to cycle through items to reach desired slot. Classic mode makes right-click switch back after using the number keys.",actionText="Belt: Invisible War Toolbelt",variable="bAlternateToolbelt",valueText2="Classic");
     items(7)=(HelpText="Keyring is selected when left-clicking on locked doors. Belt slot 0 is made available to general items.",actionText="Belt: Smart Keyring",variable="bSmartKeyring");
     items(8)=(HelpText="Adjust the Field-of-View during dialog scenes to more closely match the original game.",actionText="Conversations: FOV Adjustment",variable="bCutsceneFOVAdjust",defaultValue=1);
     items(9)=(HelpText="Enable Subtitles in full-screen cinematics. This is independent of the regular Subtitles setting.",actionText="Conversations: Subtitles",variable="bSubtitlesCutscene",defaultValue=1);
     items(10)=(HelpText="Use the number keys to select dialog choices.",actionText="Conversations: Numbered Replies",variable="bNumberedDialog",defaultValue=1);
     items(11)=(HelpText="Show Credits Balance in the Dialog Window.",actionText="Conversations: Show Credits",variable="bCreditsInDialog",defaultValue=1);
     items(12)=(HelpText="Use selected HUD Theme in dialog menus.",actionText="Conversations: Use HUD Colours",variable="bDialogHUDColors");
     items(13)=(HelpText="If enabled, the intro cutscene is not loaded.",actionText="Game: Skip Intro",variable="bSkipNewGameIntro");
     items(14)=(HelpText="In Restricted mode, Combat Music will require at least 2 enemies to be in combat before music plays.",actionText="Game: Play Combat Music",variable="iAllowCombatMusic",defaultValue=1,valueText2="Restricted",);
     items(15)=(HelpText="Show outer crosshairs at 100% accuracy. Disable this if they get in the way.",actionText="HUD: 100% Accuracy Crosshairs",variable="bFullAccuracyCrosshair",defaultValue=1);
     items(16)=(HelpText="Always display the total amount of ammo available, rather than the number of magazines. Some weapons always show total ammo count. Disabled on Hardcore.",actionText="HUD: Accurate Ammo Display",variable="bDisplayTotalAmmo");
     items(17)=(HelpText="Change weapon viewmodels to display better on some widescreen resolutions.",actionText="HUD: Alternate Weapon Offsets",variable="bEnhancedWeaponOffsets");
     items(18)=(HelpText="Display CLIPS or MAGS in the Ammo window. Has no effect for weapons that don't use magazines, or if Accurate Ammo Display is turned on.",actionText="HUD: Ammo Text Display",variable="bDisplayClips",valueText0="MAGS",valueText1="CLIPS",defaultValue=1);
     items(19)=(HelpText="Always show the accuracy crosshairs for your currently held weapon.",actionText="HUD: Always Show Bloom",variable="bAlwaysShowBloom");
     items(20)=(HelpText="Enable alternate visuals for the bioenergy bar.",actionText="HUD: Animated Bioenergy Bar",variable="bAnimBar1",defaultValue=1);
     items(21)=(HelpText="Enable alternate visuals for the stamina bar.",actionText="HUD: Animated Stamina Bar",variable="bAnimBar2",defaultValue=1);
     items(22)=(HelpText="If Enabled, alternate ammo is color-coded in the toolbelt.",actionText="HUD: Color Coded Ammo",variable="bColorCodedAmmo",defaultValue=1);
     items(23)=(HelpText="Use a small dot-crosshair (or no crosshair) when no weapon is equipped, and in a few other cases.",actionText="HUD: Dynamic Crosshair",variable="dynamicCrosshair",valueText1="Dot",valueText2="Box",valueText3="Julian",valueText4="Hidden",defaultValue=1);
     items(24)=(HelpText="Breakable objects display hitpoints & throwable objects display mass. Not recommended for the sake of consistency.",actionText="HUD: Extra Object Details",variable="bExtraObjectDetails");
     items(25)=(HelpText="Spy Drone View will use the main camera, with the picture-in-picture window for the Player's view",actionText="HUD: Fullscreen Drone View",variable="bBigDroneView",defaultValue=1);
     items(26)=(HelpText="If enabled, a marker appears within your crosshair when dealing damage.",actionText="HUD: Hit Markers",variable="bHitMarkerOn",defaultValue=1);
     items(27)=(HelpText="Display Lockpicking/Bypassing tooltips with yellow text if you only just meet the tool requirement, and red text if you don't meet the requirement.",actionText="HUD: Tool Window Colors",variable="bColourCodeFrobDisplay",defaultValue=1);
     items(28)=(HelpText="When displaying the Tool window, show how many tools or lockpicks you have on the panel.",actionText="HUD: Tool Window Style",variable="iFrobDisplayStyle",defaultValue=1,valueText0="Original",valueText1="Current/Required Tools",valueText2="Required/Current Tools");
     items(29)=(HelpText="Modified weapons will have a '+' added to their name in the belt and inventory screens.",actionText="HUD: Show Modified Weapons",variable="bBeltShowModified",defaultValue=1);
     items(30)=(HelpText="Augmentation descriptions will be simplified. Disable to show the difference between Energy Reserving (toggle) augmentations and conditional energy using (Automatic) augmentations.",actionText="HUD: Simplified Aug Categories",variable="bSimpleAugSystem",defaultValue=1);
     items(31)=(HelpText="Use smaller fonts for some HUD Elements.",actionText="HUD: Use Classic Fonts",variable="bClassicFont",consoleTarget="DeusEx.FontManager",defaultValue=0);
     items(32)=(HelpText="If enabled, the crosshair will turn blue when attempting to attach a mine to a surface.",actionText="HUD: Wall Placement Helper",variable="bWallPlacementCrosshair",defaultValue=1);
     items(33)=(HelpText="If enabled, attempting to pick up carryable objects will automatically holster your held weapon, enabling you to pick up the object.",actionText="Interaction: Auto-Holster",variable="bAutoHolster");
     items(34)=(HelpText="If enabled, Data Cubes will show when they have been interacted with.",actionText="Interaction: Darken Data-Cube Screens",variable="bShowDataCubeRead",defaultValue=1);
     items(35)=(HelpText="If enabled, double-right click to holster/unholster items in hand. Prevents accidentally putting away items when attempting to interact with the world.",actionText="Interaction: Double-Click Holstering",variable="dblClickHolster",valueText2="Holstering and Unholstering",defaultValue=2);
     items(36)=(HelpText="If enabled, right clicking a corpse for the first time will never pick it up, to stop accidentally picking up corpses while searching for items.",actionText="Interaction: Enhanced Carcass Searching",variable="bEnhancedCorpseInteractions",defaultValue=1);
     items(37)=(HelpText="If enabled, left-clicking with nothing targeted will unholster your last item.",actionText="Interaction: Left-Click Unholstering",variable="bLeftClickUnholster");
     items(38)=(HelpText="Append [Searched] text to corpses when they are interacted with.",actionText="Interaction: Show Searched Labels",variable="bSearchedCorpseText");
     items(39)=(HelpText="Loot will not be declined from corpses if the Walk/Run key is held.",actionText="Interaction: Smart Declining",variable="bSmartDecline");
     items(40)=(HelpText="Changes lighting on some maps to reduce strobing and flickering.",actionText="Lighting: Lighting Accessibility",variable="bLightingAccessibility");
     items(41)=(HelpText="Enable/disable level transition autosaving.",actionText="Player: Autosave on Level Change",variable="bTogAutoSave",defaultValue=1);
     items(42)=(HelpText="When dying, switch to a first or third person camera.",actionText="Player: Death Perspective",variable="bRemoveVanillaDeath",valueText0="Third Person",valueText1="First Person");
     items(43)=(HelpText="Active Augmentations no longer play their ambient sounds.",actionText="Player: Quiet Augmentations",variable="bQuietAugs",defaultValue=0);
     items(44)=(HelpText="Alternate realistic headbobbing effect. To disable headbobbing outright, see the standard Settings menu.",actionText="Player: Realistic Head-Bobbing",variable="bModdedHeadBob",defaultValue=1);
     items(45)=(HelpText="Prevent accidentally killing domesticated animals by stomping on them.",actionText="Player: Stomp Domestic Animals",variable="bStompDomesticAnimals",defaultValue=0);
     items(46)=(HelpText="Prevent accidentally killing vac-bots by stomping on them.",actionText="Player: Stomp Vac Bots",variable="bStompDomesticAnimals",defaultValue=0);
     items(47)=(HelpText="Always use the female hands with male JC. This setting does nothing if LDDP is not installed.",actionText="Player: Use Female Hands",variable="bFemaleHandsAlways",defaultValue=0);
     items(42)=(HelpText="If Enabled, music will not restart upon map changes using the same track. Extended mode also stops conversation music in bars and clubs.",actionText="Music: More Immersive Music",variable="bEnhancedMusicSystem",valueText2="Extended",defaultValue=1);
     items(39)=(HelpText="When using a medical bot, automatically switch to the Health screen after using the last Aug canister.",actionText="Interaction: Medbot Auto Switch",variable="bMedbotAutoswitch",defaultValue=1);
     items(9)=(HelpText="Smooths out the lip-synching animations in conversations. Setting it to 'chunky' intentionally removes blending.",actionText="Conversations: Improved Lip Synch",variable="iEnhancedLipSync",defaultValue=1,valueText2="Chunky");
     items(14)=(HelpText="If enabled, characters (including the player) will blink randomly.",actionText="Game: Enable Blinking",variable="bEnableBlinking",defaultValue=1);
     Title="GMDX Quality of Life Options"
}
