//=============================================================================
// MenuScreenExperimental
//=============================================================================

class MenuScreenExperimental expands MenuScreenListWindow;

var const localized string msgTitle;
var const localized string msgText;

var globalconfig bool bShownWindow;

event InitWindow()
{
	Super.InitWindow();
    
    bTickEnabled=true;
}

function Tick(float deltaTime)
{
    if (!bShownWindow)
    {
        root.MessageBox(msgTitle,msgText,1,false,self);
        bShownWindow = true;
        bTickEnabled=false;
        SaveConfig();
    }
}

event bool BoxOptionSelected(Window msgBoxWindow, int buttonNumber)
{
    // Destroy the msgbox!  
	root.PopWindow();
}

defaultproperties
{
     strHeaderSettingLabel="Feature"
     items(0)=(HelpText="Skill point gains are reduced by 10% in Realistic and 20% in Hardcore mode. Designed to make skill choices more meaningful and create less 'jack of all trades' characters with everything at Advanced",actionText="Skill Rebalance",variable="bExperimentalSkillRebalance");
     items(1)=(HelpText="To ensure the Athletics is not made obsolete, Rebreathers will be removed upon use, similar to GMDX v9",actionText="Disposable Rebreathers",variable="bExperimentalRebreathers");
     Title="Experimental Balance"
     consoleTarget="MenuScreenNewGame"
     msgTitle="Experimental Gameplay Options"
     msgText="These options allow experimenting with potential upcoming gameplay changes for balance testing and feedback. It's not recommended to use these options for typical play. In time, these options may either be removed or implemented as core gameplay elements."
     colWidths(0)=214
     colWidths(1)=155
     bShortHeaderButtons=false
     clientTextures(0)=Texture'RSDCrap.UserInterface.MenuQoLBackground_1'
     clientTextures(1)=Texture'RSDCrap.UserInterface.MenuQoLBackground_2'
     clientTextures(2)=Texture'RSDCrap.UserInterface.MenuQoLBackground_3'
     clientTextures(3)=Texture'RSDCrap.UserInterface.MenuQoLBackground_4'
     DescriptionPos=(X=8,Y=305)
     SearchPos=(X=224,Y=0)
     SearchSize=(X=140,Y=16)
}
