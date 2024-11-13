//=============================================================================
// GMDXTutorialCube //CyberP: simple display text. Doesn't fuck around with text packages
// SARGE: TODO: This needs a MAJOR rewrite! It should be generic, rather than having a whole big list of shit
//=============================================================================
class GMDXTutorialCube extends DeusExDecoration;

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
	HText23
	HText24
};

var() EHackText HackText;
var transient HUDInformationDisplay infoWindow;		// Window to display the information in
var transient TextWindow winText;				// Last text window we added
var Bool bSetText;
var DeusExPlayer aReader;				// who is reading this?
var Localized String GMDXText1;
var Localized String GMDXText2;
var Localized String GMDXText3;
var Localized String GMDXText4;
var Localized String GMDXText5;
var Localized String GMDXText6;
var Localized String GMDXText7;
var Localized String GMDXText8;
var Localized String GMDXText9;
var Localized String GMDXText10;
var Localized String GMDXText11;
var Localized String GMDXText12;
var Localized String GMDXText13;
var Localized String GMDXText14;
var Localized String GMDXText15;
var Localized String GMDXText16;
var Localized String GMDXText17;
var Localized String GMDXText18;
var Localized String GMDXText19;
var Localized String GMDXText20;
var Localized String GMDXText21;
var Localized String GMDXText22;
var Localized String GMDXText23;
var Localized String GMDXText24;
// ----------------------------------------------------------------------
// Destroyed()
//
// If the item is destroyed, make sure we also destroy the window
// if it happens to be visible!
// ----------------------------------------------------------------------

function Destroyed()
{
	DestroyWindow();

	Super.Destroyed();
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

function DestroyWindow()
{
	// restore the crosshairs and the other hud elements
	if (aReader != None)
	{
        aReader.UpdateCrosshair();
	}

	if (infoWindow != None)
	{
		infoWindow.ClearTextWindows();
		infoWindow.Hide();
	}

	infoWindow = None;
	winText = None;
	aReader = None;
}

// ----------------------------------------------------------------------
// Tick()
//
// Only display the window while the player is in front of the object
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	// if the reader strays too far from the object, kill the text window
	if ((aReader != None) && (infoWindow != None))
		if (aReader.FrobTarget != Self)
			DestroyWindow();
}

// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------

function Frob(Actor Frobber, Inventory frobWith)
{
	local DeusExPlayer player;

	Super.Frob(Frobber, frobWith);

	player = DeusExPlayer(Frobber);

	if (player != None)
	{
		if (infoWindow == None)
		{
			aReader = player;
			CreateInfoWindow();

			// hide the crosshairs if there's text to read, otherwise display a message
			if (infoWindow != None)
                player.UpdateCrosshair();
		}
		else
		{
			DestroyWindow();
		}
	}
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	local DeusExTextParser parser;
	local DeusExRootWindow rootWindow;
	local DeusExNote note;
	local DataVaultImage image;
	local bool bImageAdded;

	rootWindow = DeusExRootWindow(aReader.rootWindow);

	// First check to see if we have a name
	    infoWindow = rootWindow.hud.ShowInfoWindow();
	    infoWindow.ClearTextWindows();

	    if (winText == None)
	    {
		winText = infoWindow.AddTextWindow();
        winText.SetTextAlignments(HALIGN_Left, VALIGN_Center);
		Switch(HackText)
		{
		  case HText1: winText.SetText(GMDXText1); Break;
		  case HText2: winText.SetText(GMDXText2); Break;
		  case HText3: winText.SetText(GMDXText3); Break;
		  case HText4: winText.SetText(GMDXText4); Break;
		  case HText5: winText.SetText(GMDXText5); Break;
		  case HText6: winText.SetText(GMDXText6); Break;
		  case HText7: winText.SetText(GMDXText7); Break;
		  case HText8: winText.SetText(GMDXText8); winText.SetTextAlignments(HALIGN_Center, VALIGN_Center);Break;
		  case HText9: winText.SetText(GMDXText9); Break;
		  case HText10: winText.SetText(GMDXText10); Break;
		  case HText11: winText.SetText(GMDXText11); Break;
		  case HText12: winText.SetText(GMDXText12); Break;
		  case HText13: winText.SetText(GMDXText13); Break;
		  case HText14: winText.SetText(GMDXText14); Break;
		  case HText15: winText.SetText(GMDXText15); Break;
		  case HText16: winText.SetText(GMDXText16); Break;
		  case HText17: winText.SetText(GMDXText17); Break;
		  case HText18: winText.SetText(GMDXText18); Break;
		  case HText19: winText.SetText(GMDXText19); Break;
		  case HText20: winText.SetText(GMDXText20); Break;
		  case HText21: winText.SetText(GMDXText21); Break;
		  case HText22: winText.SetText(GMDXText22); Break;
		  case HText23: winText.SetText(GMDXText23); Break;
		}
		//winText.AppendText(text);
        //winText.SetTextColor(parser.GetColor());
	    }
}

defaultproperties
{
     GMDXText1="Excellent.|n|nRemember doors can also be unlocked if you have the matching door key, or there may be alternate ways around."
     GMDXText2="Ladders are not the only way to surface from water. Swim up to a ledge, look up and keep moving forward to 'dolphin jump' from the water."
     GMDXText3="Turn around and press the 'Jump' key to jump from the ladder. Moving forward as you do this will increase your reach.|n|nStruggling to reach the platform? Remember that you can mantle and climb anything within reach."
     GMDXText4="ACCURACY BREAKDOWN|n|nAccuracy is negatively modified by damage to your arms, head and/or torso.|n|nAccuracy is positively modified by standing/crouching still, modifying your weapon with accessories such as a laser sight, increasing your weapon skill level from the 'Skills/Perks' menu, and more. |n|nAgents do not usually become a crack shot without extensive field experience."
     GMDXText5="SECONDARY WEAPONS|n|nPick up the grenade from this table, open your inventory (default = TAB or F1), select the grenade and click the 'Assign' button, which will equip it as your secondary weapon. You can then use the grenade at any time by pressing the 'secondary weapon' key (default= F)."
     GMDXText6="WARNING|nBefore you is the final test of basic training. Now would be a good time to save your game (press 'Esc' key)."
     GMDXText7="DEFAULT WEAPON CONTROLS|n|nShoot: Left Mouse Button|nHolster: Right Mouse Button|nReload: ;|nChange Weapon: Mouse Wheel|nDrop Weapon: Middle Mouse Button|nChange Ammo Type: C|nToggle Scope: [|nToggle Laser Sight: ]|n|nAdvanced Controls: |n|nScope Zoom In/Out: Mouse Wheel (while scope is active)|nUse Secondary Weapon: F (if you have a Secondary Weapon)|nCancel Reload: Left Mouse Button (while reloading. Shotguns only)|n|nYou can rebind keys at any time from the 'Keyboard/Mouse' menu."
     GMDXText8="ADVANCED MOVEMENT TRAINING|n|nAttention Recruits,|n|nDue to a high rate of incidents the Advanced Movement Training Course is no longer required participation. Take the key from the table and exit the course to receive your evaluation, or venture forward if you think you have what it takes. Be warned, recruits receive no comms assistance on the course.|n|n-J.Reyes"
     GMDXText9="TAKEDOWNS|n|nPerform a takedown! To do so, equip a melee weapon, sneak right up behind the hologram and aim for the midsection or the back of the head, then press 'Fire Weapon' (default = Left Mouse Button). |n|nThe Baton or Riot Prod are best suited to this task as a result of their silent and non-lethal nature, though any weapon can be used. |n|nA takedown can only be performed if the target is unaware of your presence."
     GMDXText10="DOOR INTERACTIVITY|n|nDoors that can be interacted with will display relevant information before your eyes (via your HUD augmentation): |n|nLock Complexity: complexity of the lock (if any); the number of lockpicks required to pick the lock.|nDoor Durability: a representation of door sturdiness, simplified as a 'health bar'.|nDamage Threshold: if your weapon does not deal greater damage than this number you will not be able to break the door with that weapon.|n|nSee if you can bypass all three doors."
     GMDXText11="MANTLING|n|nYou can mantle onto objects by pressing the 'Jump' key (default = SPACE BAR) whilst airborne and facing the object. |n|nTo begin, mantle up the stack of crates, and from there climb up onto the ledge."
     GMDXText12="AMMO TYPES|n|nCycle through available ammo types by pressing the 'Cycle Ammo' key (default = C).|nAmmo types offer specific advantages and disadvatages depending on the situation at hand."
     GMDXText13="This is a tougher jump. Get a run-up. If you don't quite make it, you can mantle the ledge to save yourself from falling down."
     GMDXText14="You can mantle into crawl-spaces you'd have trouble getting into otherwise.|n|nCrouch, Jump then Mantle."
     GMDXText15="Walkway bridge code: 154"
     GMDXText16="Did you suffer a nasty fall? Keep an eye on your health monitor displayed in the upper-left hand corner of your field of view. If your legs are injured, apply the medkit on the table directly to your legs via the Health Interface (navigate to the health menu through your inventory, or bind a shortcut directly to it if you wish).|n|nBeware, critically injured body parts results in great consequences."
     GMDXText17="ADVANCED INTERACTIVITY|n|nWith two hands free, you can interact with inventory items where they stand with a left click. Holster your weapon, look at the items on the table and press the left mouse button."
     GMDXText18="Cousin,|n|nI'm just leaving the perimeter to shift some zyme. If you're in trouble press the alarm panel as instructed. |nYou try to hide it, but I know you're scared. We all have our part to play. Don't worry I'll hear the alarm, that thing is LOUD."
     GMDXText19="You Mantled from a Dolphin Jump, or found a cunning alternative to get up here.|n|nThis will amount positively toward your final evaluation."
     GMDXText20="STORAGE INVENTORY LEDGER|n|nBatch#    Units         Product                          Date|n|n 0001      x4     Sokolo Nano-Lithium Battery       01/24/2052|n 0001      x7     Catering Container                  01/24/2052|n 0001      x1      Augmentation Upgrade Cannister   01/24/2052|n 0001      x3     GDI Combat Supply Crate           01/24/2052|n 0001      x2     GDI Medical Supply Crate           01/24/2052|n 0001      x1      GDI General Supply Crate           01/24/2052|n 0001      x5     Lab Materials Container             01/24/2052|n 0001      x1      Universal Damage Modification        01/24/2052"
     GMDXText21="Welcome to your first shift in the lockup, newbie.|n|nSo, you're curious about the canister. You want to hold it, examine it, and think of the possibilities. Don't worry, we've all been there and we're not going to fire you if you do the same. It's unrealistic to expect extreme curiosity to be kept at bay, and we're pretty laid back and fun here. HOWEVER, you're going to have to earn the right to touch it by proving you're not an utter dimwit: |n|nSolve the following problems. Solving the first will give you the first portion of the nano-containment container code. Solve the second problem for the second portion of the code. IF you manage to get it open be gentle with the thing. Lord knows how much it costs to manufacture.|n|n1. How many times does a broken mechanical 12-hour clock display an accurate readout over a period of two weeks? |n|n2. [(12*6)/2]-1 = Second Passcode|n|nIf you attempt to run off with the thing it's your funeral -- the cameras are watching."
     GMDXText22="UNATCO MedDirectorate|nNano-Augmentation Guidelines|n|n...nano-augmentations, once 'installed,' irrevocably alter the physiological system they affect and in many cases cause all subsequent augmentations to be rejected; however, the exact number of augmentations each system can support varies. The various interdependencies between these systems can be seen in the following table that details possible nano-augmentation combinations.|n|nArms (1): Combat Speed or Microfibral Muscle|nArms (2): Combat Strength or Ammo Capacity|nLegs: Speed Enhancement or Run Silent|nSubdermal (1): Ballistic Protection or BPN-021|nSubdermal (2): Cloak or Radar Transparency|nTorso (1): Aqualung or Environmental Resistance|nTorso (2): Regeneration or Energy Resistance|nTorso (3): Synthetic Heart or Power Recirculator|nCranium: Aggressive Defense System or Spy Drone|nOptics: Targeting or Vision Enhancement|n|nSpecific nano-augmentations should be selected based on the mission profile of the particular agent..."
     GMDXText23="We've a request to send these up to level 1. Be careful with them, they are very expensive. Drop one and you'll likely face instant dismissal."
     GMDXText24="Dave,|n|nI understand we've all been working hard, but you can't keep ignoring your responsibilities. I know the camera doesn't beep when we're asleep, but that doesn't mean the base commander isn't going to come down here in person one day and find you asleep. If a real attack happens we don't want to be caught off guard because you weren't watching your post."
     bInvincible=True
     bCanBeBase=True
     ItemName="DataCube"
     bPushable=False
     Texture=Texture'Effects.Corona.Corona_G'
     Skin=Texture'HDTPItems.Skins.HDTPDatacubetex1'
     Mesh=LodMesh'DeusExItems.DataCube'
     MultiSkins(2)=Texture'HDTPItems.Skins.HDTPDatacubetex1'
     CollisionRadius=7.000000
     CollisionHeight=1.270000
     Mass=2.000000
     Buoyancy=3.000000
}
