//=============================================================================
// ChargedPickup.
// modded by dasraiser for GMDX : Stackable upto Environ Skill Level
// Now overhauled entirely by CyberP.                                           //RSD: and me!
//=============================================================================
class ChargedPickup extends DeusExPickup
	abstract;

var() class<Skill> skillNeeded;
var() bool bOneUseOnly;
var() sound ActivateSound;
var() sound DeactivateSound;
var() sound UsedUpSound;
var() sound LoopSound;
var Texture ChargedIcon;
var travel bool bIsActive;
var localized String ChargeRemainingLabel;
var localized String ChargeRemainingLabelSmall;
var localized String DurabilityRemainingLabel;
var localized String CanOnlyBeOne;
var localized String PickupInfo1;
var localized String PickupInfo2;
//var localized String PickupInfo3;                                             //RSD: Removed
//var localized String PickupInfo4;                                             //RSD: Removed
var localized String PickupInfo5;                                               //RSD: Added to make system generic
var float chargeMult;                                                           //RSD: Mult for how much of total charge you get back from biocells

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local DeusExPlayer player;
	local String outText;

	winInfo = PersonaInfoWindow(winObject);
	//winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return False;

	player = DeusExPlayer(Owner);

	if (player != None)
	{
		winInfo.SetTitle(itemName);
		if (IsA('TechGoggles'))
			winInfo.AddSecondaryButton(self);                                   //RSD: Can now equip Tech Goggles as secondaries
		winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());
        if (IsA('HazMatSuit') || IsA('BallisticArmor'))
        outText = DurabilityRemainingLabel $ Int(GetCurrentCharge()) $ "%";
        else
		outText = ChargeRemainingLabel @ Int(GetCurrentCharge()) $ "%";
		if (IsA('HazMatSuit'))
		outText = outText $ winInfo.CR() $ PickupInfo1;
		else if (IsA('BallisticArmor'))
		outText = outText $ winInfo.CR() $ PickupInfo2;
		/*if (IsA('AdaptiveArmor') || IsA('Rebreather'))
		outText = outText $ winInfo.CR() $ PickupInfo3;
		else
		outText = outText $ winInfo.CR() $ PickupInfo3;*/
		if (DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkFieldRepair').bPerkObtained == true)                         //RSD: New Repairman perk
			outText = outText $ winInfo.CR() $ PickupInfo5 @ int(150*(default.chargeMult))$"%";
		else
			outText = outText $ winInfo.CR() $ PickupInfo5 @ int(100*default.chargeMult)$"%"; //RSD: Generic now that chargeMult is stored in each class, not hacked
		winInfo.AppendText(outText);
	}
	return True;
}

// ----------------------------------------------------------------------
// GetCurrentCharge()
// ----------------------------------------------------------------------

simulated function Float GetCurrentCharge()
{
	return (Float(Charge) / Float(Default.Charge)) * 100.0;
}

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin(DeusExPlayer Player)
{
	local int DisplayCount;

	Player.AddChargedDisplay(Self);
	Player.PlaySound(ActivateSound, SLOT_Pain);
	if (LoopSound != None)
		AmbientSound = LoopSound;

	//DEUS_EX AMSD In multiplayer, remove it from the belt if the belt
	//is the only inventory.
	if ((Level.NetMode != NM_Standalone) && (Player.bBeltIsMPInventory))
	{
		if (DeusExRootWindow(Player.rootWindow) != None)
			DeusExRootWindow(Player.rootWindow).DeleteInventory(self);

		bInObjectBelt=False;
		BeltPos=default.BeltPos;
	}
    if (IsA('AdaptiveArmor'))
    class'DeusExPlayer'.default.bCloakEnabled=true;

	bIsActive = True;
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

function ChargedPickupEnd(DeusExPlayer Player)
{
	Player.RemoveChargedDisplay(Self);

	if (Charge > 0 && DeactivateSound != None)	// Trash: If charge is more than 0 and there's a deactivation sound, play it instead
		Player.PlaySound(DeactivateSound, SLOT_Pain);
	else
		Player.PlaySound(UsedUpSound, SLOT_None);
	
	if (LoopSound != None)
		AmbientSound = None;

	// remove it from our inventory if none left
	if (NumCopies<=0)
		Player.DeleteInventory(Self);
	/*else
	{//remove from hands, should really never get here!
		if (player.inHand == Self)
			player.PutInHand(None);
	}  */
    if (IsA('AdaptiveArmor'))
    {
    class'DeusExPlayer'.default.bCloakEnabled=False;
    class'DeusExPlayer'.default.bRadarTran=False;
    }
	bIsActive = False;
	Player.RefreshChargedPickups(); //SARGE: Now we need to refresh, rather than remove, because an item can be still be assigned to the special weapon slot
}

// ----------------------------------------------------------------------
// IsActive()
// ----------------------------------------------------------------------

simulated function bool IsActive()
{
	return bIsActive;
}

// ----------------------------------------------------------------------
// ChargedPickupUpdate()
// ----------------------------------------------------------------------

function ChargedPickupUpdate(DeusExPlayer Player)
{
    UpdateBeltText(); //Sarge: Now we need to update the belt position because it shows charge amounts
}

// ----------------------------------------------------------------------
// CalcChargeDrain()
// ----------------------------------------------------------------------

simulated function int CalcChargeDrain(DeusExPlayer Player)
{
	local DeusExPlayer Pplayer;
	local float skillValue;
	local float drain;

	drain = 4.0;
	skillValue = 1.0;
	if (skillNeeded != None)
		skillValue = Player.SkillSystem.GetSkillLevelValue(skillNeeded);
	drain *= skillValue;

	Pplayer = DeusExPlayer(Owner);

	//if (IsA('AdaptiveArmor') && Pplayer.PerkManager.GetPerkWithClass(class'DeusEx.PerkChameleon').bPerkObtained == true && Pplayer.GetCurrentGroundSpeed() == 0)
	//	drain -= (drain * 0.5);	// Trash: This won't work because Charge is an int, not a float.

	return Max(1,Int(drain));
}

// ----------------------------------------------------------------------
// function UsedUp()
//
// copied from Pickup, but modified to keep items from
// automatically switching
// ----------------------------------------------------------------------

function UsedUp()
{
	local DeusExPlayer Player;
    local int x;

    /*if (IsA('BallisticArmor'))
        x = 0;
    else if (IsA('Hazmat'))
        x = 1;
    else if (IsA('AdaptiveArmor'))
        x = 2;
    else if (IsA('TechGoggles'))
        x = 3;
    else
        x = 4;*/

	NumCopies--;   //GMDX

	if ( Pawn(Owner) != None )
	{
	    //bActivatable = false;
		Pawn(Owner).ClientMessage(ExpireMessage);
	}
	Owner.PlaySound(UsedUpSound);
	Player = DeusExPlayer(Owner);

	if (Player != None)
	{
		if (Player.inHand == Self)
		{
			ChargedPickupEnd(Player);
		}
	}
	if (NumCopies<=0)
	{
		bActivatable = false;
		//Destroy();  //GMDX                                                    //RSD: Bottom one left at 0% mostly so new repair bot features aren't hell
		NumCopies=1;                                                            //RSD: Stuff
		Charge = 0;                                                             //RSD: To ensure we don't have slightly negative charges
		GotoState('DeActivated');
		UpdateBeltText();
		DimIcon();
	}
	else
	{
		GotoState('DeActivated');                                               //RSD: Deactivate when the top one in the stack runs out (default)
		//GotoState('Activated');                                                 //RSD: Automatically activate the next one in the stack
		Charge=default.Charge;  //give back charge and make activatable
		UpdateBeltText();
		//if (Player != None)
		//    Player.topCharge[x]=default.Charge;
	}
}

/*function DropFrom(vector StartLocation)
{
local DeusExPlayer Player;
local int x;

    if (IsA('BallisticArmor'))
        x = 0;
    else if (IsA('Hazmat'))
        x = 1;
    else if (IsA('AdaptiveArmor'))
        x = 2;
    else if (IsA('TechGoggles'))
        x = 3;
    else
        x = 4;

    if (bIsCloaked || bIsRadar)                                                 //RSD: Overhauled cloak/radar routines
	 SetCloakRadar(false,false,true);//SetCloak(false,true);
    Player = DeusExPlayer(Owner);
    if (Player != None && Charge < default.Charge && Player.topCharge[x] > Charge && Player.topCharge[x] != 0)
        Player.topCharge[x] = Charge;

	super.DropFrom(StartLocation);

}*/

/*function inventory SpawnCopy( pawn Other )
{
	local inventory Copy;
    local int x;

    if (IsA('BallisticArmor'))
        x = 0;
    else if (IsA('Hazmat'))
        x = 1;
    else if (IsA('AdaptiveArmor'))
        x = 2;
    else if (IsA('TechGoggles'))
        x = 3;
    else
        x = 4;

    Copy = Super.SpawnCopy(Other);
	if (Other.IsA('DeusExPlayer') && DeusExPlayer(Other).topCharge[x] != 0)
	    Copy.Charge = DeusExPlayer(Other).topCharge[x];
	return Copy;
}*/

// ----------------------------------------------------------------------
// state DeActivated
// ----------------------------------------------------------------------

state DeActivated
{
}

// ----------------------------------------------------------------------
// state Activated
// ----------------------------------------------------------------------

state Activated
{
	function Timer()
	{
		local DeusExPlayer Player;

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			ChargedPickupUpdate(Player);
			if (!IsA('HazMatSuit') && !IsA('BallisticArmor')) //CyberP: start to make new armor system
			Charge -= CalcChargeDrain(Player);
            if (IsA('AdaptiveArmor'))
            class'DeusExPlayer'.default.bCloakEnabled=true;

			if (Charge <= 0)
			{
                UsedUp();
				if (IsA('AdaptiveArmor'))
                 class'DeusExPlayer'.default.bCloakEnabled=False;
			}
		}
	}

	function BeginState()
	{
		local DeusExPlayer Player;
        local ChargedPickup char;
        local int i;

        ForEach AllActors(class'ChargedPickup',char)
           if (char.IsInState('Activated') && (char.IsA('BallisticArmor') || char.IsA('HazMatSuit') || char.IsA('AdaptiveArmor')))
           {   //i++;
              if (char != self && (self.IsA('BallisticArmor') || self.IsA('HazMatSuit') || self.IsA('AdaptiveArmor')))
                 char.GotoState('DeActivated');                                 //RSD: Automtically switches to the other armor instead of yelling at you
           }
        /*if (i > 1)                                                            //RSD: Removed by above
        {
          Player = DeusExPlayer(Owner);
          DeusExPlayer(Owner).ClientMessage(CanOnlyBeOne);
          bActive=False;
          ChargedPickupEnd(Player);
          GotoState('DeActivated');
          return;
        }*/

		Super.BeginState();

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{

			if (player.inHand == Self)
			   player.PutInHand(None);

			//SetOwner(Player);  //CyberP: did I comment this out, and if so, why? :/

			ChargedPickupBegin(Player);
			SetTimer(0.1, True);
		}
	}

	function EndState()
	{
		local DeusExPlayer Player;

		Super.EndState();

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			ChargedPickupEnd(Player);
			SetTimer(0.1, False);
		}
	}

	function Activate()
	{
		//do not allow re-activation if no copies or one is active
		//if ((NumCopies<=0)||(bIsActive))
		if (bOneUseOnly)
            return;

		Super.Activate();
	}
}


// --------------------------------------------------------------------
// maxCopies
// by dasraiser for GMDX: return maxcopies and promote var in script to call funcion :)
// ----------------------------------------------------------------------
function int RetMaxCopies()
{
	local DeusExPlayer player;
	local int skval;
	player = DeusExPlayer(Owner);
	skval = Player.SkillSystem.GetSkillLevel(skillNeeded)+1;

	return skval;
}

function DimIcon() //RSD: When an item runs out of charge, dim the inv/belt icon in real time
{
	local HUDObjectBelt hudbelt;
	local DeusExRootWindow root;
	local PersonaScreenInventory winInv;
	//local PersonaInventoryItemButton invbutton;
	local int objectNum;

    root = DeusExRootWindow(DeusExPlayer(Owner).rootWindow);
	winInv = PersonaScreenInventory(root.GetTopWindow());                       //RSD: Might be none
	hudBelt = root.hud.belt;

    if (!bActivatable)
    {
    if (bInObjectBelt)
	{
        objectNum = beltPos;
        //hudbelt.objects[beltPos].bDimIcon = true;
        hudbelt.RefreshHUDDisplay(0.0);
	}
	if (winInv != none)
	{
        winInv.CreateObjectBelt();
        winInv.RefreshInventoryItemButtons();
    }
	}
}

function unDimIcon() //RSD: When a biocell is used to charge an item, check if it was dead (dimmed inv/belt icon) and undim it
{
	local HUDObjectBelt hudbelt;
	local DeusExRootWindow root;
	local PersonaScreenInventory winInv;

	//local PersonaInventoryItemButton invbutton;
	local int objectNum;

    root = DeusExRootWindow(DeusExPlayer(Owner).rootWindow);
	winInv = PersonaScreenInventory(root.GetTopWindow());                       //RSD: Might be none
	hudBelt = root.hud.belt;

    if (bActivatable)
    {
        if (bInObjectBelt)
        {
            objectNum = beltPos;
            //hudbelt.objects[beltPos].bDimIcon = false;
            hudbelt.RefreshHUDDisplay(0.0);
        }
        if (winInv != none)
        {
            winInv.CreateObjectBelt();
            winInv.RefreshInventoryItemButtons();
        }
	}
}

function Destroyed()                                                            //RSD: reboot any active repairbot window if we're deleted (on Hardcore)
{
	local DeusExPlayer player;
    local DeusExRootWindow root;
	local HUDRechargeWindow winCharge;
    local RepairBot bot;

    Super.Destroyed();

    player = DeusExPlayer(GetPlayerPawn());
    if (player == none)
    	return;
	root = DeusExRootWindow(DeusExPlayer(GetPlayerPawn()).rootWindow);
	if (root != None)
	{
		winCharge = HUDRechargeWindow(root.GetTopWindow());
		if (winCharge != none)
        {
            bot = winCharge.repairBot;
        	if (bot != none)
        	{
                root.PopWindow();
        		bot.ActivateRepairBotScreens(player);
        	}
        }
	}
}

event TravelPostAccept()
{
    if (Charge <= 0)                                                            //RSD: bActivatable in Inventory.uc is not a traveling var, need to reset every map load
    {
        bActivatable = false;
        UpdateBeltText();
		DimIcon();
    }

	Super.TravelPostAccept();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
//Charge=2000

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Pickup.PickupActivate'
     UsedUpSound=Sound'DeusExSounds.Pickup.PickupDeactivate'
     ChargeRemainingLabel="Charge remaining:"
     ChargeRemainingLabelSmall="%d%%"
     DurabilityRemainingLabel="Durability:"
     CanOnlyBeOne="You cannot equip more than one torso armor piece"
     PickupInfo1="Environmental Protection: 60%"
     PickupInfo2="Ballistic Protection: 35%"
     PickupInfo5="Biocell Recharge Amount:"
     chargeMult=0.200000
     CountLabel="Uses:"
     bCanHaveMultipleCopies=True
     bActivatable=True
     Charge=2000
}
