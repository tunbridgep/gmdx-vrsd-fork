//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptionsGameplay expands MenuScreenListWindow;

var localized string msgText;
var localized string msgTitle;

var Window msgbox;
var bool shownWindow;

event InitWindow()
{
	Super.InitWindow();

    //Crashes, no idea why
    bTickEnabled=true;
}

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
    if (msgBoxWindow != msgbox)
        //return super.BoxOptionSelected(msgBoxWindow,buttonNumber);
        return HandleResetMessagebox(msgBoxWindow,buttonNumber);
	
    // Destroy the msgbox!  
	root.PopWindow();

    player.bGameplayMenuHardcoreMsgShown = true;


    //return true;
}

function Tick(float deltaTime)
{
    if (!shownWindow && (player.bHardCoreMode || !player.bGameplayMenuHardcoreMsgShown))
    {
        msgbox = root.MessageBox(msgTitle,msgText,1,false,self);
        shownWindow = true;
        player.bGameplayMenuHardcoreMsgShown = true;
    }
}


defaultproperties
{
     items(0)=(HelpText="Cameras detect downed NPCs in their field of view and sound an alarm.",actionText="Advanced Camera Detection",variable="bCameraSensors");
     items(1)=(HelpText="All cameras behave as those encountered in Area 51: beep only once upon target aquisition, and are more durable.",actionText="Advanced Camera Security",variable="bA51Camera");
     items(2)=(HelpText="Nearby human AI notice when a camera is beeping at you and seek in the direction it is facing.",actionText="Advanced Enemy Detection",variable="bHardcoreAI1");
     items(3)=(HelpText="Security Terminals will disable access after being hacked a certain number of times, and Cameras and Turrets will reboot after a short time.",actionText="Advanced Security System (NEW)",variable="bHackLockouts");
     items(4)=(HelpText="Poison Darts are no longer recoverable when hitting walls.",actionText="Fragile Darts",variable="iFragileDarts",valueText1="Poison Dart",valueText2="Poison and Taser",valueText3="All Darts except Flare",valueText4="All Darts",defaultValue=0);
     items(5)=(HelpText="Immersion/simulation option. If enabled, carried objects are no longer translucent.",actionText="Immersive Carryables",variable="bNoTranslucency");
     items(6)=(HelpText="In hardcore mode you face enemies in greater numbers. Enable this option to have this feature in other difficulty modes.",actionText="Overwhelming Odds",variable="bHardcoreFilterOption");
     items(7)=(HelpText="Corpses can only be destroyed by realistic means and do not deal throw damage with the muscle aug.",actionText="Persistent Corpses",variable="bRealisticCarc");
     items(8)=(HelpText="If enabled, time is not paused whilst in the inventory & during general UI navigation.",actionText="Real Time UI",variable="bRealUI");
     items(9)=(HelpText="JC can only eat/drink so much before getting full, and withdrawal symptoms occur twice as quickly.",actionText="Restricted Metabolism",variable="bRestrictedMetabolism");
     items(10)=(HelpText="Reloading will reset your standing accuracy",actionText="Reloading resets accuracy.",variable="bReloadingResetsAim");
     items(11)=(HelpText="If enabled, running and jumping will drain stamina over time.",actionText="Stamina System",variable="bStaminaSystem");
     items(12)=(HelpText="If enabled, reloading with a full magazine is possible.",actionText="Trick Reloads",variable="bTrickReloading");
     msgText="The settings available in this menu are always active as part of Hardcore difficulty.|nYou may still edit them freely, but they will have no effect when playing in Hardcore mode."
     msgTitle="Hardcore Mode"
     Title="GMDX Gameplay Options"
}
