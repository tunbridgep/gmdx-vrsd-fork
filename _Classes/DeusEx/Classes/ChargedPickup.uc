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
var localized String BiocellRechargeAmountLabel;
var localized String EquipWhenEmptyLabel;                                       //SARGE: Added.
var localized String CanOnlyBeOne;
var localized String PickupInfo1;
var localized String PickupInfo2;
var localized String PickupInfo5;                                               //RSD: Added to make system generic
var float chargeMult;                                                           //RSD: Mult for how much of total charge you get back from biocells

//SARGE: Allow keeping this equipped when drained.
//This is only used for items that don't constantly drain.
//This means we don't keep constantly unequipping armour etc when it runs out.
//Instead, we keep it on, but it's drained, and once we charge it, it's available
//automatically.
//NOTE: When stacked, we still need to re-equip any additional ones, it won't auto-equip
//any other items in the stack by default.
var const bool bUnequipWhenDrained;
var travel bool bDrained;                                                              //SARGE: Stores if it was drained without a new one being equipped, even if the next one in the stack is at 100%. This means we no longer have to unequip

//Sarge: Update frob display to show charge and item count
function string GetFrobString(DeusExPlayer player)
{
    if (numCopies > 1 && player.bShowItemPickupCounts)
		return ItemName @ "(" $ numCopies @ "-" @  int(GetCurrentCharge()) $ "%" $ ")"; //SARGE: Append the current charge and num copies
	else
		return ItemName @ "(" $ int(GetCurrentCharge()) $ "%)"; //SARGE: Append the current charge only
}

function string GetDescription2(DeusExPlayer player)
{
    local string str;

    //Add Charge Amount
    str = AddLine(str,sprintf(ChargeRemainingLabel,int(GetCurrentCharge())));

    //Add Biocell Recharge Amount
    str = AddLine(str,sprintf(BiocellRechargeAmountLabel,GetRechargeAmount()));
    
    str = AddLine(str, super.GetDescription2(player));

    //Add "Wearable when drained" text
    if (!bUnequipWhenDrained)
        str = AddLine(str,EquipWhenEmptyLabel);
    
    return str;
}

// ----------------------------------------------------------------------
// GetCurrentCharge()
// ----------------------------------------------------------------------

simulated function Float GetCurrentCharge()
{
	return (Float(Charge) / Float(Default.Charge)) * 100.0;
}

//Gets the recharge amount per biocell
function int GetRechargeAmount()
{
    if (DeusExPlayer(Owner) != None && DeusExPlayer(Owner).PerkManager.GetPerkWithClass(class'DeusEx.PerkFieldRepair').bPerkObtained == true)                         //RSD: New Repairman perk
        return 150*default.chargeMult;
    else 
        return 100*default.chargeMult;
}

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin(DeusExPlayer Player)
{
	local int DisplayCount;

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
    if (!bIsActive)
        return;

    if ((Charge > 0 || bDrained) && DeactivateSound != None)	// Trash: If charge is more than 0 and there's a deactivation sound, play it instead
        Player.PlaySound(DeactivateSound, SLOT_Pain);
    else
        Player.PlaySound(UsedUpSound, SLOT_None);
	
	if (LoopSound != None)
		AmbientSound = None;

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

	if ( Pawn(Owner) != None && !bDrained)
	{
	    //bActivatable = false;
		Pawn(Owner).ClientMessage(sprintf(ExpireMessage,ItemName));
        Owner.PlaySound(UsedUpSound);
	}
	Player = DeusExPlayer(Owner);

	if (Player != None)
	{
        /*
		if (Player.inHand == Self)
		{
			ChargedPickupEnd(Player);
		}
        */
	}
	if (NumCopies<=0)
	{
		//Destroy();  //GMDX                                                    //RSD: Bottom one left at 0% mostly so new repair bot features aren't hell
		NumCopies=1;                                                            //RSD: Stuff
		Charge = 0;                                                             //RSD: To ensure we don't have slightly negative charges
        bDrained = true;
		UpdateBeltText();
        if (bUnequipWhenDrained)												//SARGE: No longer unequip. Now we allow wearing drained items.
        {
            GotoState('DeActivated');
            bActivatable = false;
        }
		DimIcon();
	}
	else
	{
        bDrained = true;
        if (bUnequipWhenDrained)												//SARGE: No longer unequip. Now we allow wearing drained items.
            GotoState('DeActivated');
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
	function Activate()
    {
		local DeusExPlayer Player;
		Player = DeusExPlayer(Owner);

        if (player != None)
            DeselectInHand(player);
        super.Activate();
    }

	function BeginState()
    {
        UpdateBeltText();
        if (Charge > 0)
        {
            bDrained = false;
            UnDimIcon();
        }
    }
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
            
            if (bDrained) //SARGE: Don't bother doing anything if it's drained
                return;

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

			//SetOwner(Player);  //CyberP: did I comment this out, and if so, why? :/
            if (bUnequipWhenDrained)
                bDrained = false;

            Player.PlaySound(ActivateSound, SLOT_Pain);

			if (!bDrained && Charge > 0)
				ChargedPickupBegin(Player);
            else if (bUnequipWhenDrained)
                return;
            else
                bIsActive = True;

            Player.RefreshChargedPickups();
            DeselectInHand(player);
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
		local DeusExPlayer Player;

		//do not allow re-activation if no copies or one is active
		//if ((NumCopies<=0)||(bIsActive))
		if (bOneUseOnly)
            return;
		
        Player = DeusExPlayer(Owner);

        //SARGE:Simply set us as undrained if we're re-activated while active.
        if (player != None)
        {
            DeselectInHand(player);
            if (bDrained && bActive && Charge > 0)
            {
                bDrained = false;
                Player.PlaySound(ActivateSound, SLOT_Pain);
                ChargedPickupBegin(Player);
                return;
            }
        }
        Super.Activate();
	}
}


// --------------------------------------------------------------------
// DeselectInHand()
// SARGE: Made the Hand Deselection generic
// ----------------------------------------------------------------------
function DeselectInHand(DeusExPlayer player)
{
    if (player.inHand == Self)// && !bUnequipWhenDrained)
        player.PutInHand(None);
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

    if (!bActivatable || Charge == 0)
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

//SARGE: WARNING!!
//THIS FUNCTION CRASHES THE GAME SOMETIMES WHEN USED
//IN THE INVENTORY SCREEN
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
        if (bUnequipWhenDrained)
            bActivatable = false;
        UpdateBeltText();
		DimIcon();
    }

	Super.TravelPostAccept();
}

//SARGE: Whether or not we should dim the icon for this charged pickup.
//This used to be easy, but now they can be activated and worn even when empty,
//so "Activatable" isn't usable anymore.
function bool ShouldDim()
{
    return !bActivatable || (Charge == 0 && NumCopies == 1);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Pickup.PickupActivate'
     UsedUpSound=Sound'DeusExSounds.Pickup.PickupDeactivate'
     ChargeRemainingLabel="Charge remaining: %d%%"
     ChargeRemainingLabelSmall="%d%%"
     //DurabilityRemainingLabel="Durability:"
     CanOnlyBeOne="You cannot equip more than one torso armor piece"
     //PickupInfo1="Environmental Protection: 60%"
     //PickupInfo2="Ballistic Protection: 35%"
     BiocellRechargeAmountLabel="Biocell Recharge Amount: %d%%"
     chargeMult=0.200000
     CountLabel="Uses:"
     bCanHaveMultipleCopies=True
     bActivatable=True
	 ExpireMessage="%s power supply used up"
     EquipWhenEmptyLabel="Remains Equipped when drained."
     Charge=2000
     bUnequipWhenDrained=true
}
