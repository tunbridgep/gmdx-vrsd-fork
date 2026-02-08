//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptionsQoLSimple expands MenuScreenListWindowBig;

//Update crosshair when closing the menu
function SaveSettings()
{
    Super.SaveSettings();
    player.UpdateCrosshairStyle();
    player.UpdateHUD();
    
    //We need to update the aug wheel
    player.RefreshAugmentationWheel();
    
    //We need to refresh our item icons too.
    player.UpdateItemIcons();
    
    //Show/Hide exits based on settings
    player.ShowExits();

    if (player.outfitManager != None)
        player.outfitManager.SaveConfig();
}

//We need to change options depending on Augmentique
function BuildModifierList()
{
    //Remove Augmentique options
    if (player.outfitManager == None || !player.OutfitManager.Installed())
    {
        RemoveItem("bEquipNPCs");
        RemoveItem("noDescriptions");
    }
}
	
// ----------------------------------------------------------------------
// ProcessAction()
// ----------------------------------------------------------------------

function ProcessAction(String actionKey)
{
	switch(CAPS(ActionKey))
	{
		case "ADVANCED":
			SaveSettings();
			root.InvokeMenuScreen(class'MenuScreenGMDXOptionsQoL');
		break;
		//case "HELP":
			//root.MessageBox(SpecializationTipHeader, SpecializationTipText, 1, False, Self);
		//break;
	}
}

defaultproperties
{
     items(0)=(HelpText="Enable a free cursor in the augmentation wheel, rather than being locked to a circular motion.",actionText="Augmentation Wheel: Free Cursor",variable="bAugWheelFreeCursor",defaultValue=1,image1="QoL_FreeCursor1",image2="QoL_FreeCursor2")
     items(1)=(HelpText="Enable/Disable the highlighted augmentation when closing the augmentation wheel without requiring left-click. Cancel with right click.",actionText="Augmentation Wheel: Quick Select",variable="bQuickAugWheel")
     items(2)=(HelpText="Automatically Add Augmentations to the Wheel when acquired. Augmentations can always be added or removed using middle-click in the Augmentation window.",actionText="Augmentation Wheel: Auto Add Augs.",variable="iAugWheelAutoAdd",defaultValue=1,valueText1="Active Augs Only",valueText2="All Augs")
     items(3)=(HelpText="Enable/Disable the 'Disable All' button on the Augmentation Wheel.",actionText="Augmentation Wheel: Show 'Disable All'",variable="bAugWheelDisableAll",defaultValue=1)
     items(4)=(HelpText="Automtically add newly-acquired items to the toolbelt.",actionText="Belt: Autofill Belt",variable="bBeltAutofill")
     items(5)=(HelpText="Right-click confirms belt selection, removing the need to cycle through items to reach desired slot.",actionText="Belt: Invisible War Toolbelt",variable="iAlternateToolbelt",valueText2="Classic",valueText3="Hybrid",helpText2="Classic mode makes right-click switch back after using the number keys.",helpText3="Hybrid mode only switches to the primary selection if the primary selection was initially unholstered.")
     items(6)=(HelpText="Shooting at walls will send sparks flying, and bullet holes are bigger!",actionText="Game: John Woo Mode",variable="bJohnWooSparks")
     items(7)=(HelpText="In Restricted mode, Combat Music will require at least 2 enemies to be in combat before music plays.",actionText="Audio: Play Combat Music",variable="iAllowCombatMusic",consoleTarget="DeusEx.MusicPlayer",defaultValue=1,valueText2="Restricted")
     items(8)=(HelpText="If set to Vanilla, only vanilla death/pain sounds play. Randomised randomises all death/pain sounds.",actionText="Audio: Pain/Death Sounds",variable="iDeathSoundMode",defaultValue=2,valueText0="Vanilla",valueText1="Pre-Set",valueText2="Randomised")
     items(9)=(HelpText="Makes all decals and fragments stick around forever.|nWARNING: High values may severely affect performance and lead to save instability!",actionText="Game: Persistent Debris",variable="iPersistentDebris",valueText1="Blood Pools Only",valueText2="Everything (2048 Decal Limit)",valuetext3="Everything (4096 Decal Limit)",valuetext4="Everything (8192 Decal Limit)",valuetext5="Everything (16384 Decal Limit)",defaultValue=1)
     items(10)=(HelpText="Always display the total amount of ammo available, rather than the number of magazines. Some weapons always show total ammo count. Disabled on Hardcore.",actionText="HUD: Accurate Ammo Display",variable="bDisplayTotalAmmo")
     items(11)=(HelpText="Shows the ammo display on the right side of the screen, and the belt on the left",actionText="HUD: Ammo Display on Right",variable="bAmmoDisplayOnRight")
     items(12)=(HelpText="If enabled, attempting to pick up carryable objects will automatically holster your held weapon, enabling you to pick up the object.",actionText="Holstering: Auto-Holster",variable="iAutoHolster",valueText1="Carcasses Only",valueText2="Everything")
     items(13)=(HelpText="If enabled, double-right click to holster items in hand. Prevents accidentally putting away items when attempting to interact with the world.",actionText="Holstering: Holstering Mode",variable="iHolsterMode",valueText0="Standard",valueText1="Double Click",defaultValue=1)
     items(14)=(HelpText="If enabled, left-clicking with nothing targeted will unholster your last item.",actionText="Interaction: Left-Click Unholstering",variable="bLeftClickUnholster")
     items(15)=(HelpText="With an item in your hand, Right-Clicking will pull out Lockpicks and Multitools, similar to Revision, and will also go back to previous item. Left-Clicking works when hands are empty.",actionText="Interaction: Right-Click Tool Selection.",variable="bRightClickToolSelection")
     items(16)=(HelpText="Changes lighting on some maps to reduce strobing and flickering.",actionText="Lighting: Lighting Accessibility",variable="bLightingAccessibility")
     items(17)=(HelpText="When dying, switch to a first or third person camera.",actionText="Player: Death Perspective",variable="bRemoveVanillaDeath",valueText0="Third Person",valueText1="First Person")
     items(18)=(HelpText="Always use the female hands with male JC. This setting does nothing if LDDP is not installed.",actionText="Player: Use Female Hands",variable="bFemaleHandsAlways",defaultValue=0)
     items(19)=(HelpText="If enabled, the Items Received window will be shown when looting partial ammo counts from weapons or ammo pickups without picking them up.",actionText="HUD: Show Items Window When Looting Ammo",variable="bAlwaysShowReceivedItemsWindow",defaultValue=1)
     items(20)=(HelpText="If enabled, killed enemies will drop their current weapon as they die. Realism option, not intended for general use.",actionText="Game: Enemies Drop Weapons on Death",variable="bDropWeaponsOnDeath",defaultValue=0)
     items(21)=(HelpText="Show darkened versions of ignored and declined items in the Items Received Window when searching carcasses.",actionText="HUD: Show Unlooted in Items Window",variable="bShowDeclinedInReceivedWindow")
     items(22)=(HelpText="When active, left-clicking on doors, crates, windows and other interactive items while holstered will select the appropriate tool or melee weapon.",actionText="Interaction: Left-Click Interactions",variable="bEnableLeftFrob",defaultValue=1)
     items(23)=(HelpText="If enabled, double-right click to unholster items in hand, or disable unholstering completely.",actionText="Holstering: Unholstering Mode",variable="iUnholsterMode",valueText1="Standard",valueText2="Double-Click",defaultValue=2);
     items(24)=(HelpText="If enabled, notes added by datacubes, books, etc can be edited.",actionText="HUD: Edit Default Notes",variable="bEditDefaultNotes",defaultValue=1)
     items(25)=(HelpText="NPC outfits will be randomised. Changes to this setting require a new map load.",actionText="Augmentique: NPC Outfit Randomisation",consoleTarget="OutfitManager",variable="iEquipNPCs",defaultValue=1,valueText1="Generic NPCs Only",valueText2="Generic and Unique NPCs")
     items(26)=(HelpText="If enabled, the Items Received Window will be cleared when interacting with objects, similar to vanilla.",actionText="HUD: Clear Items Received Window",variable="bClearReceivedDisplay",defaultValue=1);
     items(27)=(HelpText="The Change Ammo Key (default: X) will swap selected grenades, melee weapons, and other items, similar to Shifter.",actionText="Game: Change Ammo Swaps Items",variable="iShifterWeaponSwitch",valueText1="Swap Only",valueText2="Swap Belt",valueText3="Autoswap Belt",valueText4="Autoswap Belt and Autoselect",helpText1="In Swap Only mode, the belt is not considered when swapping items.",helpText2="Swap Belt mode also updates the belt with new items.",helpText3="Autoswap mode also updates the belt when using the last of an item.",helptext4="Autoswap And Select mode autoswaps the belt and selects the new item after autoswapping",defaultValue=2)
     items(28)=(HelpText="Using the Scope key with no item equipped will use any Binoculars in your inventory",actionText="Interaction: Smart Binocular Selection",variable="iSmartBinocs",defaultValue=1,valueText2="Select and Activate")
     items(29)=(HelpText="Item icons in the Inventory and Belt will reflect item skins. Otherwise the default icon is used.",actionText="HUD: Show Skinned Icons",variable="bSkinnedBeltIcons",defaultValue=1)
     items(30)=(HelpText="Enable or Disable smart texture filtering, which will filter only level and item textures while leaving decals, shadows and other elements filtered.",actionText="Game: Texture Filtering",variable="bSmartTextureFiltering",consoleTarget="DeusEx.TextureFilterer",defaultValue=1)
     items(31)=(HelpText="Items on the Augmentation Wheel will always be in preset positions, for maintaining muscle memory.",actionText="Augmentation Wheel: Preset Positions",variable="bAugWheelPresetPositions",defaultValue=0)

     Title="GMDX Quality of Life Options"
     actionButtons(3)=(Align=HALIGN_Right,Action=AB_Other,Text="Advanced Settings",Key="ADVANCED")
}
