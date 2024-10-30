//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptionsGameplay expands MenuScreenListWindow;

defaultproperties
{
     items(0)=(HelpText="If enabled, time is not paused whilst in the inventory & during general UI navigation.",actionText="Real Time UI",variable="bRealUI");
     items(1)=(HelpText="If enabled, running and jumping will drain stamina over time.",actionText="Stamina System",variable="bStaminaSystem");
     items(2)=(HelpText="Security Terminals will disable access after being hacked a certain number of times, based on Computer skill.",actionText="Hacking Lockouts",variable="bHackLockouts");
     items(3)=(HelpText="Cameras detect downed NPCs in their field of view and sound an alarm.",actionText="Advanced Camera Detection",variable="bCameraSensors");
     items(4)=(HelpText="All cameras behave as those encountered in Area 51: beep only once upon target aquisition, and are more durable.",actionText="Advanced Camera Security",variable="bA51Camera");
     items(5)=(HelpText="Nearby human AI notice when a camera is beeping at you and seek in the direction it is facing.",actionText="Advanced Enemy Detection",variable="bHardcoreAI1");
     items(6)=(HelpText="JC can only eat/drink so much before getting full, and withdrawal symptoms occur twice as quickly.",actionText="Restricted Metabolism",variable="bRestrictedMetabolism");
     items(7)=(HelpText="In hardcore mode you face enemies in greater numbers. Enable this option to have this feature in other difficulty modes.",actionText="Overwhelming Odds",variable="bHardcoreFilterOption");
     items(8)=(HelpText="Corpses can only be destroyed by realistic means and do not deal throw damage with the muscle aug.",actionText="Persistent Corpses",variable="bRealisticCarc");
     items(9)=(HelpText="Immersion/simulation option. If enabled, carried objects are no longer translucent.",actionText="Immersive Carryables",variable="bNoTranslucency");
     Title="GMDX Gameplay Options"
}
