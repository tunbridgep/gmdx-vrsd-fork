//=============================================================================
// MenuScreenOnboarding
// A very simple menu that simply described GMDX:AE features.
// Replaces the "show tips" button in the GMDX Options Menu
//=============================================================================

class MenuScreenGMDXOnboarding expands MenuScreenListWindowBig;

event InitWindow()
{
    //Mark onboarding as complete the moment we open the menu
    player.bDoneGMDXOnboarding = true;
    player.SaveConfig();
	Super.InitWindow();
}

defaultproperties
{
     items(0)=(HelpText="A headshot with a tranquilizer dart is an instant non-lethal takedown to any unarmoured human NPC.",actionText="Crossbow Headshots")
     items(1)=(HelpText="Items can be assigned as Secondaries.|n|nSecondary items are quick-use items that can be used instantly with a single keypress.|n|nTo assign an item as a secondary, use the 'Assign Secondary' button or press the use secondary key (Default: F) in the Inventory screen.|n|nNOTE: Your accuracy bonus from standing still is not reset when using most secondary items.",actionText="Assigning Secondary Items",image1="OBM_Secondaries1",image2="OBM_Secondaries2")
     items(2)=(HelpText="Variations of mouse clicking on items in the inventory acts as shortcuts. Right click to equip or use, middle mouse to drop.",actionText="Extended Inventory Controls")
     items(3)=(HelpText="Double press interact (Default: Right Mouse Button) or use the Left Mouse button to pick up a corpse regardless of inventory limitations.",actionText="Enhanced Carcass Interactions")
     items(4)=(HelpText="You can interact with many objects by Left-Clicking while your hands are empty.|n|nInventory Items: You will put them in your hands or use them where they stand.|nDoors, Crates and Interactables: You will pull out a lockpick, multitool, a melee weapon or the Nanokey, depending on context.|nCarcasses: You will pick them up, regardless of inventory state.|n|nTry experimenting with left-click interactions for other object types!",actionText="Left-Click Interactions")
     items(5)=(HelpText="Open the Augmentation Wheel (Default: C) to see and use all of your available augmentations at a glance.|n|nAugmentations can be added or removed from the Augmentation Wheel using the Middle Mouse button while in the Augmentations screen.|n|nThe Augmentation Wheel has extensive configuration options, available in the settings menu.|n|nNote: By default, only Active augmentations are added to the wheel.",actionText="Augmentation Wheel",image1="OBM_AugWheel1",image2="OBM_AugWheel2")
     items(6)=(HelpText="Augmentations come in 4 distinct types:|n|n - Passive (Yellow): Always active, and drain no energy.|n - Active (Blue): Manually activated, use energy when in use.|n - Automatic (Light Blue): Manually Activated, will drain energy under certain conditions, such as when reducing radiation damage or when lifting heavy objects.|n - Toggle (Green): Manually activated, will immediately drain an energy reserve when activated, which lowers your maximum bioelectrical energy capacity, but drain no energy while active.",actionText="Augmentation Types")
     items(7)=(HelpText="The Keyring has it's own special slot on the toolbelt.|n|nThis slot can also be used for normal items, by dragging them onto the keyring.|nIf an item is removed from the slot, the keyring will become available once again.|n|nThe keyring can always be used via left-click interactions, the assigned keyboard key (Default: '), or by right-clicking the NanoKey icon in the inventory screen.",actionText="Using the Keyring Slot")
     Title="GMDX Help and Features"
     consoleTarget=""
     bShowDefaults=false
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_OK) //The cancel button becomes the OK button
     actionButtons(1)=(Action=AB_None) //SARGE: Remove the OK button
     actionButtons(2)=(Action=AB_None) //SARGE: Remove the Reset button
     bShowValueInHelp=false
     bLeftEdgeActive=false
}
