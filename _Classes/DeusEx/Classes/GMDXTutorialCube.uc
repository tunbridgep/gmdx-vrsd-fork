//=============================================================================
// GMDXTutorialCube //CyberP: simple display text. Doesn't fuck around with text packages
// SARGE: Now not a total piece of shit
//=============================================================================
class GMDXTutorialCube extends DataCube;

//These are offset by 1
//We really should use an int here, instead of an enum,
//but the original GMDX implementation absolutely sucked, and I don't
//want to have to go through every map and change the datacubes to use the right numbers.
//So, we will just add to this instead. Ugh....
enum EHackText
{
	HText1,
	HText2,
	HText3,
	HText4,
	HText5,
	HText6,
	HText7,
	HText8,
	HText9,
	HText10,
	HText11,
	HText12,
	HText13,
	HText14,
	HText15,
	HText16,
	HText17,
	HText18,
	HText19,
	HText20,
	HText21,
	HText22,
	HText23,
	HText24
};

var() EHackText HackText;
var Localized String StringTable[25];

function bool DarkenScreen()
{
    return bRead;
}

function GetText()
{
	local DeusExRootWindow rootWindow;
    local string text;
    local Name noteLabel;
    local DeusExNote note;

    rootWindow = DeusExRootWindow(aReader.rootWindow);
			
    infoWindow = rootWindow.hud.ShowInfoWindow();
    infoWindow.ClearTextWindows();

    winText = infoWindow.AddTextWindow();
    
    //Set the text
    text = StringTable[HackText];
    winText.SetText(text);

    // Check to see if we need to save this string in the DataVault
    // SARGE: Now we always add it, but hide it if it's not supposed to be added
    noteLabel = rootWindow.StringToName("GMDXCustom"$HackText);
    note = aReader.GetNote(noteLabel);

    if (note == None)
        aReader.NoteAdd(text, False, !bAddToVault, noteLabel);
}

defaultproperties
{
    StringTable(0)="Excellent.|n|nRemember doors can also be unlocked if you have the matching door key, or there may be alternate ways around."
    StringTable(1)="Ladders are not the only way to surface from water. Swim up to a ledge, look up and keep moving forward to 'dolphin jump' from the water."
    StringTable(2)="Turn around and press the 'Jump' key to jump from the ladder. Moving forward as you do this will increase your reach.|n|nStruggling to reach the platform? Remember that you can mantle and climb anything within reach."
    StringTable(3)="ACCURACY BREAKDOWN|n|nAccuracy is negatively modified by damage to your arms, head and/or torso.|n|nAccuracy is positively modified by standing/crouching still, modifying your weapon with accessories such as a laser sight, increasing your weapon skill level from the 'Skills/Perks' menu, and more. |n|nAgents do not usually become a crack shot without extensive field experience."
    StringTable(4)="SECONDARY ITEMS|n|nPick up the grenade from this table, open your inventory (default = TAB or F1), select the grenade and click the 'Assign' button, which will equip it as your secondary item. You can then use the grenade at any time by pressing the 'secondary item' key (default= F)."
    StringTable(5)="WARNING|nBefore you is the final test of basic training. Now would be a good time to save your game (press 'Esc' key)."
    StringTable(6)="DEFAULT WEAPON CONTROLS|n|nShoot: Left Mouse Button|nHolster: Right Mouse Button|nReload: R|nChange Weapon: Mouse Wheel|nDrop Weapon: Middle Mouse Button|nChange Ammo Type: C|nToggle Scope: CAPS|nToggle Laser Sight: \|n|nAdvanced Controls: |n|nScope Zoom In/Out: Mouse Wheel (while scope is active)|nUse Secondary Weapon: F (if you have a Secondary Weapon)|nCancel Reload: Left Mouse Button (while reloading. Shotguns only)|n|nYou can rebind keys at any time from the 'Keyboard/Mouse' menu."
    StringTable(7)="ADVANCED MOVEMENT TRAINING|n|nAttention Recruits,|n|nDue to a high rate of incidents the Advanced Movement Training Course is no longer required participation. Take the key from the table and exit the course to receive your evaluation, or venture forward if you think you have what it takes. Be warned, recruits receive no comms assistance on the course.|n|n-J.Reyes"
    StringTable(8)="TAKEDOWNS|n|nPerform a takedown! To do so, equip a melee weapon, sneak right up behind the hologram and aim for the midsection or the back of the head, then press 'Fire Weapon' (default = Left Mouse Button). |n|nThe Baton or Riot Prod are best suited to this task as a result of their silent and non-lethal nature, though any weapon can be used. |n|nA takedown can only be performed if the target is unaware of your presence."
    StringTable(9)="DOOR INTERACTIVITY|n|nDoors that can be interacted with will display relevant information before your eyes (via your HUD augmentation): |n|nLock Complexity: complexity of the lock (if any); the number of lockpicks required to pick the lock.|nDoor Durability: a representation of door sturdiness, simplified as a 'health bar'.|nDamage Threshold: if your weapon does not deal greater damage than this number you will not be able to break the door with that weapon.|n|nSee if you can bypass all three doors."
    StringTable(10)="MANTLING|n|nYou can mantle onto objects by pressing the 'Jump' key (default = SPACE BAR) whilst facing an object. |n|nTo begin, mantle up the stack of crates, and from there climb up onto the ledge."
    StringTable(11)="AMMO TYPES|n|nCycle through available ammo types by pressing the 'Cycle Ammo' key (default = C).|nAmmo types offer specific advantages and disadvatages depending on the situation at hand."
    StringTable(12)="This is a tougher jump. Get a run-up. If you don't quite make it, you can mantle the ledge to save yourself from falling down."
    StringTable(13)="You can mantle into crawl-spaces you'd have trouble getting into otherwise.|n|nCrouch, Jump then Mantle."
    StringTable(14)="Walkway bridge code: 154"
    StringTable(15)="Did you suffer a nasty fall? Keep an eye on your health monitor displayed in the upper-left hand corner of your field of view. If your legs are injured, apply the medkit on the table directly to your legs via the Health Interface (navigate to the health menu through your inventory, or bind a shortcut directly to it if you wish).|n|nBeware, critically injured body parts results in great consequences."
    StringTable(16)="ADVANCED INTERACTIVITY|n|nWith two hands free, you can interact with inventory items where they stand with a left click. Holster your weapon, look at the items on the table and press the left mouse button."
    StringTable(17)="Cousin,|n|nI'm just leaving the perimeter to shift some zyme. If you're in trouble press the alarm panel as instructed. |nYou try to hide it, but I know you're scared. We all have our part to play. Don't worry I'll hear the alarm, that thing is LOUD."
    StringTable(18)="You Mantled from a Dolphin Jump, or found a cunning alternative to get up here.|n|nThis will amount positively toward your final evaluation."
    StringTable(19)="STORAGE INVENTORY LEDGER|n|nBatch#    Units         Product                          Date|n|n 0001      x4     Sokolo Nano-Lithium Battery       01/24/2052|n 0001      x7     Catering Container                  01/24/2052|n 0001      x1      Augmentation Upgrade Cannister   01/24/2052|n 0001      x3     GDI Combat Supply Crate           01/24/2052|n 0001      x2     GDI Medical Supply Crate           01/24/2052|n 0001      x1      GDI General Supply Crate           01/24/2052|n 0001      x5     Lab Materials Container             01/24/2052|n 0001      x1      Universal Damage Modification        01/24/2052"
    StringTable(20)="Welcome to your first shift in the lockup, newbie.|n|nSo you're curious about the cannister. You want to hold it, examine it, and think of the possibilities. Don't worry, we've all been there and we're not going to fire you if you do the same. It's unrealistic to expect extreme curiosity to be kept at bay, and we're pretty laid back and fun here. HOWEVER, you're going to have to earn the right to touch it by proving you're not an utter dimwit: |n|nSolve the following problems. Solving the first will give you the first portion of the nano-containment container code. Solve the second problem for the second portion of the code. IF you manage to get it open be gentle with the thing. Lord knows how much it costs to manufacture.|n|n1. How many times does a broken mechanical 12-hour clock display an accurate readout over a period of two weeks? |n|n2. [(12*6)/2]-1 = Second Passcode|n|nIf you attempt to run off with the thing it's your funeral. The cameras are watching."
    StringTable(21)="UNATCO MedDirectorate|nNano-Augmentation Guidelines|n|n...nano-augmentations, once 'installed,' irrevocably alter the physiological system they affect and in many cases cause all subsequent augmentations to be rejected; however, the exact number of augmentations each system can support varies. The various interdependencies between these systems can be seen in the following table that details possible nano-augmentation combinations.|n|nArms (1): Combat Speed or Microfibral Muscle|nArms (2): Combat Strength or Ammo Capacity|nLegs: Speed Enhancement or Run Silent|nSubdermal (1): Ballistic Protection (Active) or Ballistic Protection (Passive)|nSubdermal (2): Cloak or Radar Transparency|nTorso (1): Aqualung or Environmental Resistance|nTorso (2): Regeneration or Energy Resistance|nTorso (3): Synthetic Heart or Power Recirculator|nCranium: Aggressive Defense System or Spy Drone|nOptics: Targeting or Vision Enhancement|n|nSpecific nano-augmentations should be selected based on the mission profile of the particular agent..."
    StringTable(22)="We've a request to send these up to level 1. Be careful with them as they are very expensive. Dropping one will likely be grounds for instant dismissal."
    StringTable(23)="Dave,|n|nI understand we've all been working hard, but you can't keep ignoring your responsibilities. I know the camera doesn't beep when we're asleep, but that doesn't mean the base commander isn't going to come down here in person one day and find you asleep. If a real attack happens we don't want to be caught off guard because you weren't watching your post."
}
