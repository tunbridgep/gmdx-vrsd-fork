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
     items(0)=(HelpText="Cameras detect downed NPCs in their field of view and sound an alarm.",actionText="Camera Carcass Detection",variable="bCameraSensors");
     items(1)=(HelpText="Nearby human AI notice when a camera is beeping at you and seek in the direction it is facing.",actionText="Advanced Enemy Detection",variable="bHardcoreAI1");
     items(2)=(HelpText="Security Terminals will disable access after being hacked a certain number of times, and Cameras and Turrets will reboot after a short time.",actionText="Advanced Security System",variable="bHackLockouts",defaultValue=1);
     items(3)=(HelpText="Crossbow Darts are no longer recoverable after hitting walls.",actionText="Fragile Darts",variable="iFragileDarts",valueText1="Tranquiliser Darts",valueText2="Tranquiliser and Taser Darts",valueText3="All Darts except Flare Darts",valueText4="Everything");
     items(4)=(HelpText="Immersion/simulation option. If enabled, carried objects are no longer translucent.",actionText="Immersive Carryables",variable="bNoTranslucency");
     items(6)=(HelpText="Corpses can only be destroyed by realistic means and do not deal throw damage with the muscle aug.",actionText="Persistent Corpses",variable="bRealisticCarc",defaultValue=1);
     items(7)=(HelpText="If enabled, time is not paused whilst in the inventory & during general UI navigation.",actionText="Real Time UI",variable="bRealUI");
     items(8)=(HelpText="JC can only eat/drink so much before getting full, and withdrawal symptoms occur twice as quickly.",actionText="Restricted Metabolism",variable="bRestrictedMetabolism",defaultValue=1);
     items(9)=(HelpText="Reloading will reset your standing accuracy",actionText="Reloading resets accuracy.",variable="bReloadingResetsAim");
     items(10)=(HelpText="If enabled, running and jumping will drain stamina over time.",actionText="Stamina System",variable="bStaminaSystem");
     items(11)=(HelpText="If enabled, reloading with a full magazine is possible.",actionText="Trick Reloads",variable="bTrickReloading");
     items(12)=(HelpText="If enabled, rearming grenades depends on your Demolitions skill.",actionText="Skill-based grenade rearming",variable="bRearmSkillRequired",defaultValue=1);
     items(13)=(HelpText="If enabled, Lasers won't be able to be bypassed using pepper spray and other blockers.",actionText="Improved Laser Detection.",variable="bImprovedLasers",defaultValue=1);
     items(14)=(HelpText="Enable or disable mantling. This is not forced on in Hardcore mode. IT IS HIGHLY RECOMMENDED THAT YOU LEAVE THIS ENABLED!",actionText="Mantling",variable="bMantleOption",defaultValue=1);
     items(18)=(HelpText="The Dragons Tooth Sword will require energy to attack, and is recharged with biocells.",actionText="Strategic Dragon's Tooth",variable="bNanoswordEnergyUse",defaultValue=1);
     msgText="The settings available in this menu are always active as part of Hardcore difficulty.|nYou may still edit them freely, but they will have no effect when playing in Hardcore mode."
     msgTitle="Hardcore Mode"
     Title="GMDX Gameplay Options"
     bShowDefaults=true
}
