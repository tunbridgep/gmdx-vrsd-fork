//=============================================================================
// ConsumableItem
// SARGE: Base Class to handle Consumable objects (medkits, biocells, etc)
//=============================================================================

class ConsumableItem extends DeusExPickup abstract;

var localized String HealsLabel;
var localized String HealLabel;
var localized String RechargeLabel;
var localized String RechargesLabel;
var localized String CannotUse;

var int healAmount;                                                 //SARGE: Put healint amoung here to make the code more generic
var int bioenergyAmount;                                            //SARGE: Put recharge here to make code more generic

//Check whether we are allowed to use this consumable
function bool RestrictedUse(DeusExPlayer player)
{
    return false;
}

//Auto-use when left-clicking
function bool DoLeftFrob(DeusExPlayer frobber)
{
    if (frobber != None && RestrictedUse(frobber))
        frobber.ClientMessage(CannotUse);
    else
        OnActivate(frobber);
}

//Add Fullnes to description
function string GetDescription2(DeusExPlayer player)
{
    local string str;
    local int heals;

    heals = GetHealAmount(player);

    //Add heals amount
    if (heals == 1)
        str = AddLine(str,sprintf(HealLabel,heals));
    else if (heals > 1)
        str = AddLine(str,sprintf(HealsLabel,heals));
    
    //Add bioenergy amount
    if (bioenergyAmount == 1)
        str = AddLine(str,sprintf(RechargeLabel,bioenergyAmount));
    else if (bioenergyAmount > 1)
        str = AddLine(str,sprintf(RechargesLabel,bioenergyAmount));
    
    str = AddLine(str, super.GetDescription2(player));

    return str;
}

//What happens when we eat this.
function OnActivate(DeusExPlayer player)
{
    super.OnActivate(player);
    HealMe(player);
    UseOnce();
}

// ----------------------------------------------------------------------
// HealMe()
// ----------------------------------------------------------------------

//Give us healing/recharge when we eat it
function HealMe(DeusExPlayer player)
{
    local int heal;

    heal = GetHealAmount(player);
    if (heal > 0)
        player.HealPlayer(heal, False);
    if (bioenergyAmount > 0)
        player.ChargePlayer(bioenergyAmount,True);
}

function int GetHealAmount(DeusExPlayer player)
{
    return healAmount;
}

state Activated
{
	function Activate()
	{
        //Can't be turned off
	}

    function BeginState()
    {
        local DeusExPlayer player;
        player = DeusExPlayer(Owner);

        if (player != None && RestrictedUse(player))
        {
            player.ClientMessage(CannotUse);
            GotoState('Deactivated');                                               //RSD: Otherwise we try to activate again on map transition
            return;
        }
        else if (player != None && !player.IsInState('Dying'))
        {
            OnActivate(player);
        }
    }
Begin:
}

defaultproperties
{
     HealsLabel="Heals %d Points"
     HealLabel="Heals %d Point"
     RechargeLabel="Recharges %d Energy Unit"
     RechargesLabel="Recharges %d Energy Units"
     CannotUse="You cannot use it at this time"
}
