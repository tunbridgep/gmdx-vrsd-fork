//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptions expands MenuUIScreenWindow;

// Keep a pointer to the root window handy
var DeusExRootWindow root;

// Keep a pointer to the player for easy reference
var DeusExPlayer player;

var localized string tips[255];
var int totalTips;
var int previousTip; //Sarge: Used to prevent rolling the same tip twice.

event InitWindow()
{
    local int i;

    previousTip = -1;

    root = DeusExRootWindow(GetRootWindow());
    player = DeusExPlayer(root.parentPawn);

	Super.InitWindow();
	
    actionButtons[3].btn.colButtonFace.R = 255;
	actionButtons[3].btn.colButtonFace.G = 255;
	actionButtons[3].btn.colButtonFace.B = 255;
	actionButtons[3].btn.colText[0].R = 128;
	actionButtons[3].btn.colText[0].G = 0;
	actionButtons[3].btn.colText[0].B = 0;

    //Count total tips
    for (i = 0; i < ArrayCount(tips);i++)
    {
        if (tips[i] == "")
            break;
        totalTips++;
    }
}

function CreateChoices()
{
	local int choiceIndex;
	local MenuUIChoice newChoice;
	local DeusExLevelInfo info;

	// Loop through the Menu Choices and create the appropriate buttons
	for(choiceIndex=0; choiceIndex<arrayCount(choices); choiceIndex++)
	{
		if (choices[choiceIndex] != None)
		{
			newChoice = MenuUIChoice(winClient.NewChild(choices[choiceIndex]));
			newChoice.SetPos(choiceStartX, choiceStartY + (choiceCount * choiceVerticalGap) - newChoice.buttonVerticalOffset);
			choiceCount++;
            newChoice.SetSensitivity(true);

            //SARGE: If HDTP is not installed, disable the button
            if (!class'DeusExPlayer'.static.IsHDTPInstalled(true) && choiceCount == 3)
                newChoice.SetSensitivity(False);

         }
    }
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
    local int rnd;

    do
    {
        rnd = Rand(totalTips);
    }
    until (rnd != previousTip)

    previousTip = rnd;

    ShowHelp(tips[rnd]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     tips(0)="TIP: You can rebind augmentation activation keys in the 'Keyboard/Mouse' settings menu."
     tips(1)="TIP: A sneak attack from behind grants you a damage multiplier of twelve with any weapon."
     tips(2)="TIP: A headshot with a tranquilizer dart is an instant non-lethal takedown to any unarmoured human NPC."
     tips(3)="TIP: Standing still for a variable period of time grants an accuracy bonus."
     tips(4)="TIP: Some surfaces when stepped on are louder than others. Metal is the loudest."
     tips(5)="TIP: Assign weapons to use as secondary weapons via the inventory. The default keybind to use secondary weapons is 'F'"
     tips(6)="ADVANCED TIP: When hacking, press ESC immediately if detected to disconnect without consequence."
     tips(7)="ADVANCED TIP: Variations of mouse clicking on items in the inventory acts as shortcuts. Right click to equip or use, middle mouse to drop."
     tips(8)="ADVANCED TIP: Out of ammo? Throw your held weapon at the enemy (DEFAULT: Middle Mouse Button). Especially effective if you have the Microfibral Muscle augmentation installed."
     tips(9)="TIP: Only drop combat knives when your inventory is full."
     tips(10)="TIP: Double press interact (DEFAULT: Right Mouse Button) to pick up a corpse regardless of inventory limitations."
     tips(11)="TIP: Press jump whilst airbourne to mantle onto nearby objects."
     tips(12)="TIP: Apparel such as Hazmat and ballistic vests only degrade with sustained damage. Aim to keep one equipped at all times."
     tips(13)="ADVANCED TIP: Next Belt Item/Prev Belt Item (DEFAULT: Mousewheel) can be used to zoom in/out when looking through scopes."
     tips(14)="ADVANCED TIP: With two hands free, press fire (DEFAULT: Left Mouse Button) whilst looking at objects to use them where they stand."
     tips(15)="TIP: GMDX features extensive difficulty modes that caters to newbies, veterans and everything in between. Choose wisely."
     tips(16)="ADVANCED TIP: CTRL + C/V applies when highlighting datavault notes. Useful to copy & paste computer passwords."
     tips(17)="ADVANCED TIP: Leaning is better than strafing under certain circumstances as whilst leaning your standing accuracy bonus is retained."
     tips(18)="TIP: There are many ways in which you can distract the enemy."
     tips(19)="Your Deus Ex is Augmented."
     //New tips added by Sarge
     tips(20)="TIP: Hacking security computers will disable devices for a limited time. Multitools are the only permanent solution."
     tips(21)="TIP: With the Locksport perk, you can lock any door you have previously picked. Use this to control enemy movements."
     tips(22)="TIP: The Spy Drone has a long recharge time between uses. Look for the red icon to know when it's unavailable, or interact with it while it's in standby mode to pick it up without destroying it."
     tips(23)="ADVANCED TIP: Augmentations can be added and removed from the Augmentation Wheel using MIDDLE-MOUSE while in the Augmentation screen."
     tips(24)="TIP: The Assault Rifle comes with an equipped grenade launcher. Use the swap ammo key to quickly use the grenade launcher in the heat of battle."
     tips(25)="TIP: Left-Clicking while looking at a corpse will always pick it up rather than searching it."
     tips(26)="TIP: Food items, tech goggles and drugs can be assigned as secondary items for quick healing or buffs during combat situations."
     tips(27)="TIP: If you're having trouble managing a lot of augmentations, try using the augmentation wheel."
     tips(28)="TIP: When left-clicking on a locked object, you can use the right mouse button to cycle between lockpicks, the nanokey, and your best melee weapon."
     tips(29)="TIP: Some weapons reload a single shot at a time. Press the FIRE button at any time to cancel the animation, allowing you to quickly return fire."
     tips(30)="TIP: The GEP gun is not actually the most silent way to eliminate Manderley."
     tips(31)="TIP: You can right-click on the icon in the inventory screen to select your nano-keyring."
     tips(32)="ADVANCED TIP: Augmentations can be added and removed from the Augmentation Wheel using MIDDLE-MOUSE while in the Augmentation screen."
     choices(0)=Class'DeusEx.MenuChoice_GMDXQoLOptions'
     choices(1)=Class'DeusEx.MenuChoice_GMDXGameplayOptions'
     //choices(2)=Class'DeusEx.MenuChoice_CreateCustomColor'
     //choices(3)=Class'DeusEx.MenuChoice_ColorCodedAmmo'
     choices(2)=Class'DeusEx.MenuChoice_HDTPToggles'
     //choices(5)=Class'DeusEx.MenuChoice_FirstPersonDeath'
     //choices(6)=Class'DeusEx.MenuChoice_AutomaticHolster'
     //choices(7)=Class'DeusEx.MenuChoice_AltHeadbob'
     //choices(8)=Class'DeusEx.MenuChoice_Mantling'
     choices(3)=Class'DeusEx.MenuChoice_AutoSaveSlots'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     //actionButtons(3)=(Align=HALIGN_Right,Action=AB_Other,Text="Video Setup",Key="VIDEO")
     //actionButtons(4)=(Align=HALIGN_Right,Action=AB_Other,Text="Show Tips",Key="TIPS")
     actionButtons(3)=(Align=HALIGN_Right,Action=AB_Other,Text="Show Tips",Key="TIPS")
     Title="GMDX Options"
     ClientWidth=537
     ClientHeight=228
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuControlsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuControlsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuControlsBackground_3'
     textureRows=1
     helpPosY=174
     //texturesSetting="ini:Engine.Engine.GameRenderDevice UseS3TC"
     //reflectionsSetting="ini:Engine.Engine.GameRenderDevice ShinySurfaces"
     //precacheSetting="ini:Engine.Engine.GameRenderDevice UsePrecache"
     //classicLighting="ini:Engine.Engine.GameRenderDevice ClassicLighting"
}
