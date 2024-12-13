//=============================================================================
// SARGE: DeclinedItemsManager
// Manages which items the player has declined
//=============================================================================
class DeclinedItemsManager extends Actor;

var globalconfig string declinedTypes[100];                           //SARGE: A list of classes for declined inventory items.

var DeusExPlayer player;

function Setup(DeusExPlayer P)
{
    Log("Manager Setup");
    player = P;
}

function RemoveDeclinedItem(class<Inventory> invClass)
{
    local int i;
    for (i = 0;i < ArrayCount(declinedTypes);i++)
    {
        if (declinedTypes[i] == string(invClass))
            declinedTypes[i] = "";
    }
    player.SaveConfig();
}

function AddDeclinedItem(class<Inventory> invClass)
{
    local int i;

    //First, search for existing entry
    if (IsDeclined(invClass))
        return;

    //Add it to the first slot
    for (i = 0;i < ArrayCount(declinedTypes);i++)
    {
        if (declinedTypes[i] == "")
        {
            declinedTypes[i] = string(invClass);
            break;
        }
    }

    player.SaveConfig();
}

function bool IsDeclined(class<Inventory> invClass)
{
    local int i;

    for (i = 0;i < ArrayCount(declinedTypes);i++)
    {
        if (declinedTypes[i] == string(invClass))
            return true;
    }
    return false;
}

function int GetDeclinedNumber()
{
    local int i, count;

    for (i = 0;i < ArrayCount(declinedTypes);i++)
    {
        if (declinedTypes[i] != "")
            count++;
    }
    return count;
}
