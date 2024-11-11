//=============================================================================
// ChargeManager.
// modded by dasraiser for GMDX : Stackable upto Environ Skill Level
// Now overhauled entirely by CyberP.                                           //RSD: and me!                  //SARGE: And me!
// SARGE: This used to be a subclass of DeusExPickup, but now,
// since it's also used by the DTS, we have moved it to a separate class.
//=============================================================================
class ChargeManager extends Object;

//SARGE: Make DTS require Bioenergy to function
var travel int charge;
var travel float chargeMult;                           //Amount restored by Biocells. Increases to 150% with Field Repair perk.
var travel int maxCharge;                              //Maximum Charge

var DeusExPlayer owner;                         //The owner of the charged device
var Inventory target;                           //The charged device
var travel class<Skill> skillNeeded;                   //The governing skill for the charged device

//Strings
var localized String ChargeRemainingLabel;
var localized String ChargeRemainingLabelSmall;
var localized String BiocellRechargeAmountLabel;
var localized String msgFullyCharged;
var localized String msgRecharged;

function int SetMaxCharge(int amount, optional bool resetCharge)
{
    maxCharge = amount;
    if (resetCharge)
        charge = amount;
}

function int GetCurrentCharge()
{
	return int((Float(charge) / Float(maxCharge)) * 100.0);
}

//Gets the recharge amount per biocell
function float GetRechargeAmount()
{
    if (owner != None && owner.PerkManager != None && owner.PerkManager.GetPerkWithClass(class'DeusEx.PerkFieldRepair').bPerkObtained == true)                         //RSD: New Repairman perk
        return 1.5 * chargeMult;
    else 
        return chargeMult;
}

//Gets the recharge amount per biocell in a nice format
function int GetRechargeAmountDisplay()
{
    return GetRechargeAmount() * 100;
}

function Setup(DeusExPlayer newOwner, Inventory newTarget)
{
    owner = newOwner;
    target = newTarget;
    owner.UpdateBeltText(target);
}

//Recharges the item, and returns a relevant charge message
function bool Recharge(optional out string msg)
{
    local float mult;

    if (target == None)
        return false;

    mult = GetRechargeAmount();
    charge += mult * maxCharge;
    if (charge >= maxCharge)
    {
        Charge = maxCharge;
        msg = msgFullyCharged;
    }
    else
    {
        msg = sprintf(msgRecharged,GetRechargeAmount());
    }
    //ChargedTarget.bActivatable=true;                                //RSD: Since now you can hold one at 0%
    unDimIcon();                                      //RSD
    owner.UpdateBeltText(target);
    return true;
}

function bool IsFull()
{
    return charge >= maxCharge;
}

function bool IsUsedUp()
{
    return charge <= 0;
}

function DimIcon() //RSD: When an item runs out of charge, dim the inv/belt icon in real time
{
	local HUDObjectBelt hudbelt;
	local DeusExRootWindow root;
	local PersonaScreenInventory winInv;
    local DeusExPickup pickup;
	local int objectNum;

    if (owner == None || target == None)
        return;

    root = DeusExRootWindow(owner.rootWindow);
	winInv = PersonaScreenInventory(root.GetTopWindow());                       //RSD: Might be none
	hudBelt = root.hud.belt;

    if (target.bInObjectBelt)
    {
        hudbelt.objects[target.beltPos].bDimIcon = true;
        hudbelt.RefreshHUDDisplay(0.0);
        owner.UpdateBeltText(target);
    }
}

function unDimIcon() //RSD: When a biocell is used to charge an item, check if it was dead (dimmed inv/belt icon) and undim it
{
	local HUDObjectBelt hudbelt;
	local DeusExRootWindow root;
	local PersonaScreenInventory winInv;
    local DeusExPickup pickup;

	//local PersonaInventoryItemButton invbutton;
	local int objectNum;

    root = DeusExRootWindow(owner.rootWindow);
	winInv = PersonaScreenInventory(root.GetTopWindow());                       //RSD: Might be none
	hudBelt = root.hud.belt;
    
    if (owner == None || target == None)
        return;

    if (target.bInObjectBelt)
    {
        hudbelt.objects[target.beltPos].bDimIcon = false;
        hudbelt.RefreshHUDDisplay(0.0);
        owner.UpdateBeltText(target);
    }
}

function int CalcChargeDrain()
{
	local float skillValue;
	local float drain;
    
    if (owner == None)
        return 0;

	drain = 4.0;
	skillValue = 1.0;
	if (skillNeeded != None)
		skillValue = owner.SkillSystem.GetSkillLevelValue(skillNeeded);
	drain *= skillValue;

	return Max(1,Int(drain));
}

function Drain(int drainAmount)
{
    charge -= drainAmount;
    if (charge <= 0)
    {
        charge = 0;
        UsedUp();
    }
    //owner.UpdateHUD();
    owner.UpdateBeltText(target);
}

//Assuming draining at 0.1sec intervals
function DrainOverTime()
{
    charge -= CalcChargeDrain();
    if (charge <= 0)
    {
        charge = 0;
        UsedUp();
    }
    //owner.UpdateHUD();
    owner.UpdateBeltText(target);
}

function UsedUp()
{
    DimIcon();
}

defaultproperties
{
     ChargeRemainingLabel="Charge remaining: %d%%"
     ChargeRemainingLabelSmall="%d%%"
     BiocellRechargeAmountLabel="Biocell Recharge Amount: %d%%"
     msgFullyCharged="Fully Recharged"
     msgRecharged="Recharged by %d%%"
     charge=2000
     maxCharge=2000
     chargeMult=0.200000
}
