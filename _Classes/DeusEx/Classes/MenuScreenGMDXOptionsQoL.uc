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
     items(2)=(HelpText="Automatically Add Augmentations to the Wheel when acquired. Augmentations can always be added or removed using middle-click in the Augmentation window.",actionText="Augmentation Wheel: Auto Add Augs.",variable="iAugWheelAutoAdd",defaultValue=1,valueText1="Active Augs Only",valueText2="All Augs");
     items(3)=(HelpText="Remember the Cursor Position in the Augmentation Wheel",actionText="Augmentation Wheel: Remember Cursor Position",variable="bAugWheelRememberCursor");
     items(4)=(HelpText="Enable/Disable the 'Disable All' button on the Augmentation Wheel.",actionText="Augmentation Wheel: Show 'Disable All'",variable="bAugWheelDisableAll",defaultValue=1);
     items(5)=(HelpText="Automtically add newly-acquired items to the toolbelt.",actionText="Belt: Autofill Belt",variable="bBeltAutofill");
     items(6)=(HelpText="After consuming the last item in a belt slot, its position will be preserved.|nIf Autofill is off, dropped items will also be preserved. Right-Click to clear.",actionText="Belt: Belt Memory",variable="bBeltMemory",defaultValue=1);
     items(7)=(HelpText="Right-click confirms belt selection, removing the need to cycle through items to reach desired slot.",actionText="Belt: Invisible War Toolbelt",variable="iAlternateToolbelt",valueText2="Classic",valueText3="Hybrid",helpText2="Classic mode makes right-click switch back after using the number keys.",helpText3="Hybrid mode only switches back to the primary selection if the primary belt selection was initially unholstered.");
     items(8)=(HelpText="Belt size is extended to 12 items. The - and = keys will be rebound to use the new belt slots.",actionText="Belt: Larger Belt",variable="bBiggerBelt",defaultValue=1);
     items(9)=(HelpText="Allows replacing the keyring in the toolbelt, making its slot available to general items. The keyring is always selectable via left-clicking on a locked object. No Keyring mode removes the keyring entirely.",actionText="Belt: Smart Keyring",variable="iSmartKeyring",valueText2="No Keyring",defaultValue=1);
     items(10)=(HelpText="Adjust the Field-of-View during dialog scenes to more closely match the original game.",actionText="Conversations: FOV Adjustment",variable="iCutsceneFOVAdjust",valueText1="75 FOV",valueText2="80 FOV",valueText3="85 FOV",valueText4="90 FOV",defaultValue=2);
     items(11)=(HelpText="Enable Subtitles in full-screen cinematics. This is independent of the regular Subtitles setting.",actionText="Conversations: Subtitles",variable="bSubtitlesCutscene",defaultValue=1);
     items(12)=(HelpText="Smooths out the lip-synching animations in conversations. Setting it to 'chunky' intentionally removes blending.",actionText="Conversations: Improved Lip Synch",variable="iEnhancedLipSync",defaultValue=1,valueText2="Chunky");
     items(13)=(HelpText="Use the number keys to select dialog choices.",actionText="Conversations: Numbered Replies",variable="bNumberedDialog",defaultValue=1);
     items(14)=(HelpText="Show Credits Balance in the Dialog Window.",actionText="Conversations: Show Credits",variable="bCreditsInDialog",defaultValue=1);
     items(15)=(HelpText="Use selected HUD Theme in dialog menus.",actionText="Conversations: Use HUD Colours",variable="bDialogHUDColors");
     items(16)=(HelpText="If enabled, blood pools will always be the same size for humans. Otherwise it's dependent on carcass size, which is somewhat arbitrary.",actionText="Game: Consistent Blood Pools",variable="bConsistentBloodPools",defaultValue=1);
     items(17)=(HelpText="If enabled, saving will be allowed while an infolink is playing. The infolink will be stopped.",actionText="Game: Allow Saving during Infolinks",variable="bAllowSaveWhileInfolinkPlaying");
     items(18)=(HelpText="If enabled, the game will return to the menu after dying, as in Vanilla.",actionText="Game: Death returns to menu",variable="bMenuAfterDeath");
     items(19)=(HelpText="If enabled, characters (including the player) will blink randomly.",actionText="Game: Enable Blinking",variable="bEnableBlinking",defaultValue=1);
     items(20)=(HelpText="Shooting at walls will send sparks flying, and bullet holes are bigger!",actionText="Game: John Woo Mode",variable="bJohnWooSparks");
     items(21)=(HelpText="In Restricted mode, Combat Music will require at least 2 enemies to be in combat before music plays.",actionText="Music: Play Combat Music",variable="iAllowCombatMusic",defaultValue=1,valueText2="Restricted",);
     items(22)=(HelpText="If set to Vanilla, only vanilla death/pain sounds play. Randomised randomises all death/pain sounds.",actionText="Audio: Pain/Death Sounds",variable="iDeathSoundMode",defaultValue=2,valueText0="Vanilla",valueText1="Pre-Set",valueText2="Randomised");
     items(23)=(HelpText="Makes all decals and fragments stick around forever.|nWARNING: High values may severely affect performance and lead to save instability!",actionText="Game: Persistant Debris",variable="iPersistentDebris",valueText1="Blood Pools Only",valueText2="Everything (2048 Decal Limit)",valuetext3="Everything (4096 Decal Limit)",valuetext4="Everything (8192 Decal Limit)",valuetext5="Everything (16384 Decal Limit)",defaultValue=1);
     items(24)=(HelpText="If enabled, the intro cutscene is not loaded.",actionText="Game: Skip Intro",variable="bSkipNewGameIntro");
     items(25)=(HelpText="Show outer crosshairs at 100% accuracy. Disable this if they get in the way.",actionText="HUD: 100% Accuracy Crosshairs",variable="bFullAccuracyCrosshair",defaultValue=1);
     items(26)=(HelpText="Always display the total amount of ammo available, rather than the number of magazines. Some weapons always show total ammo count. Disabled on Hardcore.",actionText="HUD: Accurate Ammo Display",variable="bDisplayTotalAmmo");
     items(27)=(HelpText="Change weapon viewmodels to display better at high FOV (110+).",actionText="HUD: Alternate Weapon Offsets",variable="iEnhancedWeaponOffsets",defaultValue=1,valueText1="Automatic",valueText2="Always");
     items(28)=(HelpText="Display CLIPS or MAGS in the Ammo window. Has no effect for weapons that don't use magazines, or if Accurate Ammo Display is turned on.",actionText="HUD: Ammo Text Display",variable="bDisplayClips",valueText0="MAGS",valueText1="CLIPS",defaultValue=0);
     items(29)=(HelpText="Always show the accuracy crosshairs for your currently held weapon.",actionText="HUD: Always Show Bloom",variable="bAlwaysShowBloom");
	 items(30)=(HelpText="Alternative tool display window with some minor text and spacing changes.",actionText="HUD: Alternate Tool Window Display",variable="iAltFrobDisplay",valueText1="Indented",valueText2="Extended",defaultValue=1);
	 items(31)=(HelpText="Shows the ammo display on the right side of the screen, and the belt on the left",actionText="HUD: Ammo Display on Right",variable="bAmmoDisplayOnRight");
     items(32)=(HelpText="Enable alternate visuals for the bioenergy bar.",actionText="HUD: Animated Bioenergy Bar",variable="bAnimBar1",defaultValue=1);
     items(33)=(HelpText="Enable alternate visuals for the stamina bar.",actionText="HUD: Animated Stamina Bar",variable="bAnimBar2",defaultValue=1);
     items(34)=(HelpText="Automatically minimise the Targeting augmentation when your hands are empty.",actionText="HUD: Auto-Minimise Targeting",variable="bOnlyShowTargetingWindowWithWeaponOut",defaultValue=1);
     items(35)=(HelpText="If Enabled, alternate ammo is color-coded in the toolbelt.",actionText="HUD: Color Coded Ammo",variable="bColorCodedAmmo",defaultValue=1);
     items(36)=(HelpText="Use a small dot-crosshair (or no crosshair) when no weapon is equipped, and in a few other cases.",actionText="HUD: Dynamic Crosshair",variable="dynamicCrosshair",valueText1="Dot",valueText2="Box",valueText3="Julian",valueText4="Hidden",defaultValue=1);
     items(37)=(HelpText="Breakable objects display hitpoints & throwable objects display mass. Not recommended for the sake of consistency.",actionText="HUD: Extra Object Details",variable="bExtraObjectDetails");
     items(38)=(HelpText="Spy Drone View will use the main camera, with the picture-in-picture window for the Player's view",actionText="HUD: Fullscreen Drone View",variable="bBigDroneView",defaultValue=1);
     items(39)=(HelpText="If enabled, a marker appears within your crosshair when dealing damage.",actionText="HUD: Hit Markers",variable="bHitMarkerOn",defaultValue=1);
     items(40)=(HelpText="Keypads will display a Clear and Backspace key in place of * and #. Asterisk, Hash, Backspace and Delete are all still available via the keyboard.",actionText="HUD: Keypad Replace Symbols",variable="bReplaceSymbols",consoleTarget="HUDKeypadWindow",defaultValue=1);
     items(41)=(HelpText="Keypads will display numbers as they are entered, instead of just dots.",actionText="HUD: Keypad Digit Display",variable="bDigitDisplay",consoleTarget="HUDKeypadWindow",defaultValue=1);
     items(42)=(HelpText="Switches Keypad windows to use Number Pad style rather than Phone Style Buttons.",actionText="HUD: Keypad Style",variable="bNumberPadStyle",consoleTarget="HUDKeypadWindow",defaultValue=0,valueText0="Vanilla",valueText1="Number Pad");
     items(43)=(HelpText="Display Lockpicking/Bypassing tooltips with yellow text if you only just meet the tool requirement, and red text if you don't meet the requirement.",actionText="HUD: Tool Window Colors",variable="bColourCodeFrobDisplay",defaultValue=1);
     items(44)=(HelpText="When displaying the Tool window, show how many tools or lockpicks you have on the panel.",actionText="HUD: Tool Window Number Display",variable="iFrobDisplayStyle",defaultValue=1,valueText0="Original",valueText1="Current/Required Tools",valueText2="Required/Current Tools");
     items(45)=(HelpText="If Enabled, ammo type is displayed at the bottom of the Ammo HUD.",actionText="HUD: Show Ammo Type in HUD",variable="bShowAmmoTypeInAmmoHUD",defaultValue=1);
     items(46)=(HelpText="Modified weapons will have a '+' added to their name in the belt and inventory screens.",actionText="HUD: Show Modified Weapons",variable="bBeltShowModified",defaultValue=1);
     items(47)=(HelpText="Don't show the Repair Bot interface if it's not currently charged.",actionText="HUD: Streamlined Repair Bot Interface",variable="bStreamlinedRepairBotInterface",defaultValue=1);
     //items(48)=(HelpText="Augmentation descriptions will be simplified. Disable to show the difference between Energy Reserving (toggle) augmentations and conditional energy using (Automatic) augmentations.",actionText="HUD: Simplified Aug Categories",variable="bSimpleAugSystem",defaultValue=1);
     items(48)=(HelpText="Use smaller fonts for some HUD Elements.",actionText="HUD: Use Classic Fonts",variable="bClassicFont",consoleTarget="DeusEx.FontManager",defaultValue=0);
     items(49)=(HelpText="If enabled, the crosshair will turn blue when attempting to attach a mine to a surface, or when highlighting with the Wireless Strength perk.",actionText="HUD: Wall Placement Helper",variable="bWallPlacementCrosshair",defaultValue=1);
     items(50)=(HelpText="If enabled, attempting to pick up carryable objects will automatically holster your held weapon, enabling you to pick up the object.",actionText="Holstering: Auto-Holster",variable="iAutoHolster",valueText1="Carcasses Only",valueText2="Everything");
     items(51)=(HelpText="If enabled, Data Cubes will show when they have been interacted with.",actionText="Interaction: Darken Data-Cube Screens",variable="bShowDataCubeRead",defaultValue=1);
     items(52)=(HelpText="If enabled, double-right click to holster items in hand. Prevents accidentally putting away items when attempting to interact with the world.",actionText="Holstering: Holstering Mode",variable="iHolsterMode",valueText0="Standard",valueText1="Double Click",defaultValue=1);
     items(53)=(HelpText="If enabled, right clicking a corpse for the first time will never pick it up, to stop accidentally picking up corpses while searching for items.",actionText="Interaction: Enhanced Carcass Searching",variable="bEnhancedCorpseInteractions",defaultValue=1);
     items(54)=(HelpText="If enabled, left-clicking with nothing targeted will unholster your last item.",actionText="Interaction: Left-Click Unholstering",variable="bLeftClickUnholster");
     items(55)=(HelpText="Append item counts to item pickup text, if more than 1 item is in the stack.",actionText="Interaction: Show Item Count Labels",variable="bShowItemPickupCounts");
     items(56)=(HelpText="Append [Searched] text to corpses when they are interacted with.",actionText="Interaction: Show Searched Labels",variable="bSearchedCorpseText",defaultValue=1);
     items(57)=(HelpText="With an item in your hand, Right-Clicking will pull out Lockpicks and Multitools, similar to Revision, and will also go back to previous item. Left-Clicking works when hands are empty.",actionText="Interaction: Right-Click Tool Selection.",variable="bRightClickToolSelection");
     items(58)=(HelpText="Loot will not be declined from corpses if the Walk/Run key is held.",actionText="Interaction: Smart Declining",variable="bSmartDecline");
     items(59)=(HelpText="When using a medical bot, automatically switch to the Health screen after using the last Aug canister.",actionText="Interaction: Medbot Auto Switch",variable="bMedbotAutoswitch",defaultValue=1);
     items(60)=(HelpText="Changes lighting on some maps to reduce strobing and flickering.",actionText="Lighting: Lighting Accessibility",variable="bLightingAccessibility");
     items(61)=(HelpText="If Enabled, music will not restart upon map changes using the same track. Extended mode also stops conversation music in bars and clubs.",actionText="Music: More Immersive Music",variable="iEnhancedMusicSystem",valueText2="Extended",defaultValue=1);
     items(62)=(HelpText="Enable/disable level transition autosaving.",actionText="Player: Autosave on Level Change",variable="bTogAutoSave",defaultValue=1);
     items(63)=(HelpText="When dying, switch to a first or third person camera.",actionText="Player: Death Perspective",variable="bRemoveVanillaDeath",valueText0="Third Person",valueText1="First Person");
	 items(64)=(HelpText="If enabled, the current player stance will be displayed on the HUD.",actionText="Player: Current Stance Display",variable="iStanceHud",defaultValue=3,valueText1="Walk/Run",valueText2="Everything except Default",valueText3="Everything");
	 items(65)=(HelpText="Disable the flash effect when healing or change the color.",actionText="Player: Healing Screen Effect",variable="iHealingScreen",defaultValue=1,valueText2="Classic");
     items(66)=(HelpText="Active Augmentations no longer play their ambient sounds.",actionText="Audio: Quiet Augmentations",variable="bQuietAugs",defaultValue=1);
     items(67)=(HelpText="Alternate realistic headbobbing effect. To disable headbobbing outright, see the standard Settings menu.",actionText="Player: Realistic Head-Bobbing",variable="bModdedHeadBob",defaultValue=1);
     items(68)=(HelpText="Prevent accidentally killing domesticated animals by stomping on them.",actionText="Player: Stomp Domestic Animals",variable="bStompDomesticAnimals",defaultValue=0);
     items(69)=(HelpText="Prevent accidentally killing vac-bots by stomping on them.",actionText="Player: Stomp Vac Bots",variable="bStompDomesticAnimals",defaultValue=0);
     items(70)=(HelpText="Always use the female hands with male JC. This setting does nothing if LDDP is not installed.",actionText="Player: Use Female Hands",variable="bFemaleHandsAlways",defaultValue=0)
     items(71)=(HelpText="If enabled, the New Game screen will automatically start with Pistols upgraded to Trained.",actionText="Player: Start with Pistols at Trained",variable="bPistolStartTrained",defaultValue=1)
     items(72)=(HelpText="If enabled, the Items Received window will be shown when looting partial ammo counts from weapons or ammo pickups without picking them up.",actionText="HUD: Show Items Window When Looting Ammo",variable="bAlwaysShowReceivedItemsWindow",defaultValue=0)
     items(73)=(HelpText="If enabled, the maximum number of a given item type will be shown on the inventory icon, instead of just the count.",actionText="HUD: Show Max Stacks",variable="iShowTotalCounts",defaultValue=1,valueText1="Limited",valueText2="Everything")
     items(74)=(HelpText="If enabled, Data Cubes will display images as they are read.",actionText="HUD: Data Cubes Show Images",variable="bShowDataCubeImages",defaultValue=1)
     //items(74)=(HelpText="If enabled, selecting an item that isn't on the toolbelt will clear the primary selection, allowing right-click to reselect it. Only applies to the Invisible War Toolbelt.",actionText="Belt: Auto-Clear Primary Selection",variable="bAllowSelectingOffAdvBelt",defaultValue=1)
     items(75)=(HelpText="If enabled, killed enemies will drop their current weapon as they die. Realism option, not intended for general use.",actionText="Game: Enemies Drop Weapons on Death",variable="bDropWeaponsOnDeath",defaultValue=0)
     items(76)=(HelpText="If enabled, the intro and ending cutscenes will play at preset volume ratios.",actionText="Game: Intro/Outro Volume Equalisation",variable="bCutsceneVolumeEqualiser",defaultValue=1)
     items(77)=(HelpText="Show darkened versions of ignored and declined items in the Items Received Window when searching carcasses.",actionText="HUD: Show Unlooted in Items Window",variable="bShowDeclinedInReceivedWindow")
     items(78)=(HelpText="When active, left-clicking on doors, crates, windows and other interactive items while holstered will select the appropriate tool or melee weapon.",actionText="Interaction: Left-Click Interactions",variable="bEnableLeftFrob",defaultValue=1)
     items(79)=(HelpText="If Enabled, JC will always keep their weapon drawn during conversations. JC will always keep weapons drawn in some circumstances.",actionText="Conversations: Keep Weapon Drawn",variable="bConversationKeepWeaponDrawn")
     items(80)=(HelpText="If Enabled, a smaller version of the messages window will display while an infolink is playing.",actionText="HUD: Enable Log during Infolinks",variable="bShowSmallLog")
     items(81)=(HelpText="When playing at certain resolutions, the outer crosshairs may become misaligned with the central crosshair. Use this setting to correct it.",actionText="HUD: Crosshair Adjustment",variable="iCrosshairOffByOne")
     items(82)=(HelpText="If enabled, double-right click to unholster items in hand, or disable unholstering completely.",actionText="Holstering: Unholstering Mode",variable="iUnholsterMode",valueText1="Standard",valueText2="Double-Click",defaultValue=2);
     items(83)=(HelpText="If enabled, weapons will use new high-quality sounds.",actionText="Audio: Improved Weapon Sounds",variable="bImprovedWeaponSounds",defaultValue=1);
     items(84)=(HelpText="If enabled, pressing the Run key while crouched will automatically uncrouch. Does nothing when Always Run is enabled.",actionText="Game: Auto Uncrouch",variable="bAutoUncrouch",defaultValue=1);
     items(85)=(HelpText="If enabled, always show the Playthrough Modifiers screen before the New Game screen.",actionText="Game: Always Show Playthrough Modifiers",variable="bAlwaysShowModifiers",defaultValue=1);
     items(86)=(HelpText="If enabled, right- and middle-clicking in the inventory and augmentations screens will effect the item under the cursor, rather than the currently selected item.",actionText="HUD: Enhanced Inventory/Aug Interaction",variable="bEnhancedPersonaScreenMouse",defaultValue=1);
     Title="GMDX Quality of Life Options"
     colWidths(0)=214
     colWidths(1)=155
     helpPosY=307
     bShortHeaderButtons=false
     defaultHelpHeight=37
     clientTextures(0)=Texture'RSDCrap.UserInterface.MenuQoLBackground_1'
     clientTextures(1)=Texture'RSDCrap.UserInterface.MenuQoLBackground_2'
     clientTextures(2)=Texture'RSDCrap.UserInterface.MenuQoLBackground_3'
     clientTextures(3)=Texture'RSDCrap.UserInterface.MenuQoLBackground_4'
}
