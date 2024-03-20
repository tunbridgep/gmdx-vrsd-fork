//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptions2 expands MenuUIScreenWindow;

var localized string ss1, ss2, ss3, ss4, ss5;
var localized string ss6, ss7, ss8, ss9, ss10;
var localized string ss11, ss12, ss13, ss14, ss15;
var localized string ss16, ss17, ss18, ss19, ss20;

event InitWindow()
{
	Super.InitWindow();

	actionButtons[3].btn.colButtonFace.R = 255;
	actionButtons[3].btn.colButtonFace.G = 255;
	actionButtons[3].btn.colButtonFace.B = 255;
	actionButtons[3].btn.colText[0].R = 128;
	actionButtons[3].btn.colText[0].G = 0;
	actionButtons[3].btn.colText[0].B = 0;
}

function SaveSettings()
{
   Super.SaveSettings();
	player.SaveConfigOverride();
}

function ProcessAction(String actionKey)
{
	if (actionKey == "TIPS")
	{
	CreateTips();
    }
    Super.ProcessAction(actionKey);
}

function CreateTips()
{
    local float rnd;

    rnd = FRand();

    if (rnd < 0.05)
    ShowHelp(ss1);
    else if (rnd < 0.1)
    ShowHelp(ss2);
    else if (rnd < 0.15)
    ShowHelp(ss3);
    else if (rnd < 0.2)
    ShowHelp(ss4);
    else if (rnd < 0.25)
    ShowHelp(ss5);
    else if (rnd < 0.3)
    ShowHelp(ss6);
    else if (rnd < 0.35)
    ShowHelp(ss7);
    else if (rnd < 0.4)
    ShowHelp(ss8);
    else if (rnd < 0.45)
    ShowHelp(ss9);
    else if (rnd < 0.5)
    ShowHelp(ss10);
    else if (rnd < 0.55)
    ShowHelp(ss11);
    else if (rnd < 0.6)
    ShowHelp(ss12);
    else if (rnd < 0.65)
    ShowHelp(ss13);
    else if (rnd < 0.7)
    ShowHelp(ss14);
    else if (rnd < 0.75)
    ShowHelp(ss15);
    else if (rnd < 0.8)
    ShowHelp(ss16);
    else if (rnd < 0.85)
    ShowHelp(ss17);
    else if (rnd < 0.9)
    ShowHelp(ss18);
    else if (rnd < 0.95)
    ShowHelp(ss19);
    else
    ShowHelp(ss20);
}

defaultproperties
{
     ss1="TIP: You can rebind augmentation activation keys in the 'Keyboard/Mouse' settings menu."
     ss2="TIP: A sneak attack from behind grants you a damage multiplier of twelve with any weapon."
     ss3="TIP: A headshot with a tranquilizer dart is an instant non-lethal takedown to any unarmoured human NPC."
     ss4="TIP: Standing still for a variable period of time grants an accuracy bonus."
     ss5="TIP: Some surfaces when stepped on are louder than others. Metal is the loudest."
     ss6="TIP: Assign weapons to use as secondary weapons via the inventory. The default keybind to use secondary weapons is 'F'"
     ss7="ADVANCED TIP: When hacking, press ESC immediately if detected to disconnect without consequence."
     ss8="ADVANCED TIP: Variations of mouse clicking on items in the inventory acts as shortcuts. Right click to equip or use, middle mouse to drop."
     ss9="ADVANCED TIP: Out of ammo? Throw your held weapon at the enemy (DEFAULT: Middle Mouse Button). Especially effective if you have the Microfibral Muscle augmentation installed."
     ss10="TIP: Only drop combat knives when your inventory is full."
     ss11="TIP: Double press interact (DEFAULT: Right Mouse Button) to pick up a corpse regardless of inventory limitations."
     ss12="TIP: Press jump whilst airbourne to mantle onto nearby objects."
     ss13="TIP: Apparel such as Hazmat and ballistic vests only degrade with sustained damage. Aim to keep one equipped at all times."
     ss14="ADVANCED TIP: Next Belt Item/Prev Belt Item (DEFAULT: Mousewheel) can be used to zoom in/out when looking through scopes."
     ss15="ADVANCED TIP: With two hands free, press fire (DEFAULT: Left Mouse Button) whilst looking at objects to use them where they stand."
     ss16="TIP: GMDX features extensive difficulty modes that caters to newbies, veterans and everything in between. Choose wisely."
     ss17="ADVANCED TIP: CTRL + C/V applies when highlighting datavault notes. Useful to copy & paste computer passwords."
     ss18="ADVANCED TIP: Leaning is better than strafing under certain circumstances as whilst leaning your standing accuracy bonus is retained."
     ss19="TIP: There are many ways in which you can distract the enemy."
     ss20="Your Deus Ex is Augmented."
     choices(0)=Class'DeusEx.MenuChoice_GMDXBeltOption'
     choices(1)=Class'DeusEx.MenuChoice_RealTimeUI'
     choices(3)=Class'DeusEx.MenuChoice_DoubleClickHolster'
     choices(4)=Class'DeusEx.MenuChoice_AnimatedBar1'
     choices(5)=Class'DeusEx.MenuChoice_AnimatedBar2'
     choices(6)=Class'DeusEx.MenuChoice_StaminaSystem'
     choices(7)=Class'DeusEx.MenuChoice_Hitmarker'
     choices(8)=Class'DeusEx.MenuChoice_AutoSaving'
     choices(9)=Class'DeusEx.MenuChoice_AutoSaveSlots'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     actionButtons(3)=(Align=HALIGN_Right,Action=AB_Other,Text="Show Tips",Key="TIPS")
     Title="GMDX Advanced Options"
     ClientWidth=537
     ClientHeight=406
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.MenuGameOptionsBackground_6'
     bHelpAlwaysOn=True
     helpPosY=354
}
