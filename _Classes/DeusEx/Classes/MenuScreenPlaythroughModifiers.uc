//=============================================================================
// MenuScreenPlaythroughModifiers                                               //RSD: Adapted from MenuScreenCustomizeKeys.uc so I can steal the scrolling window
//=============================================================================

class MenuScreenPlaythroughModifiers expands MenuScreenListWindow;

var bool bHardcoreSelected;                             //SARGE: Set by the new game menu to tell this menu we are playing in Hardcore mode

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

//We need to change options depending on Hardcore mode
function BuildModifierList()
{
    //remove Extra Hardcore when not in hardcore mode
    if (!bHardcoreSelected)
        RemoveItem("bExtraHardcore");

    //Remove Restricted Saving and Restricted Metabolism on Hardcore
    else
    {
        RemoveItem("bRestrictedSaving");
        //RemoveItem("bRestrictedMetabolism");
    }

    //Remove LDDP Option when LDDP is not installed
    if (!player.FemaleEnabled())
        RemoveItem("bMoreLDDPNPCs");

    //Remove Shenanigans until we finish the game
    if (!player.bHardcoreUnlocked)
        RemoveItem("bShenanigans");
	
    CreateChoices();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     strHeaderSettingLabel="Modifier"
     items(0)=(HelpText="Hardcore mode's save points require 100 credits to use, among other new rules such as -10% base accuracy for all weapons. For veterans only.",actionText="Hardcore Mode+",variable="bExtraHardcore");
     items(1)=(HelpText="Randomizes crate contents. Items are swapped for other items of the same class (e.g. 10mm ammo for steel darts) based on in-game item distribution.",actionText="Crate Randomization",variable="bRandomizeCrates");
     items(2)=(HelpText="Randomizes weapon mods. Mods are swapped for related types (e.g. accuracy for range) based on in-game item distribution.",actionText="Weapon Mod Randomization",variable="bRandomizeMods");
     items(3)=(HelpText="Shuffles the order of aug canisters in the game. Total number of each aug canister type is unchanged.",actionText="Aug Canister Shuffle",variable="bRandomizeAugs");
     items(4)=(HelpText="Equipped weapons will be swapped randomly between hostile enemies. Total number of weapons remains the same.",actionText="Enemy Weapon Shuffle",variable="bRandomizeEnemies");
     items(5)=(HelpText="Replaces drug effects with temporary buffs on use and debuffs on withdrawal. Addiction accumulates with use and depreciates through play.",actionText="Addiction System",variable="bAddictionSystem");
     items(6)=(HelpText="Prevents manually saving and adds single-use save points to the level. Autosaves still occur as normal. Always enabled in Hardcore mode.",actionText="Restricted Saving",variable="bRestrictedSaving");
     items(7)=(HelpText="Prevents using keypads and logins unless you have them in your notes. No Plot Skips setting also prevents certain sequence breaks.",actionText="Undiscovered Codes",variable="iNoKeypadCheese",valueText2="Enabled + No Plot Skips",valueText3="Enabled + NPS + Keypad Length Unknown");
     items(8)=(HelpText="Start the game in the MJ12 Prison facility. Not recommended for new players! Also skips the intro cutscene.",actionText="Alternate Start",variable="bPrisonStart");
     items(9)=(HelpText="Disable the use of the console.",actionText="Disable Console Access",variable="bDisableConsoleAccess");
     items(10)=(HelpText="Most weapons will require a minimum skill investment in order to be used.",actionText="Weapon Requirements Matter",variable="bWeaponRequirementsMatter");
     items(11)=(HelpText="When imprisoned by UNATCO, your killswitch will be activated, exactly how it's described by Paul",actionText="Killswitch Engaged",variable="bRealKillswitch");
  	 items(12)=(HelpText="Enable cameras to detect unconscious bodies. Realism option - Not recommended for normal play.",actionText="Cameras Detect Unconscious",variable="bCameraDetectUnconscious");
     items(13)=(HelpText="Enable additional NPC's added by the Lay-D Denton mod. By default only the most relevant ones are enabled.",actionText="Add extra Lay-D Denton NPCs",variable="bMoreLDDPNPCs");
     items(14)=(HelpText="We shall partake in a miniscule amount of tomfoolery.",actionText="Shenanigans",variable="bShenanigans");
     Title="Playthrough Modifiers"
     consoleTarget="MenuScreenNewGame"
     bNoSort=true
}
