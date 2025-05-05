//=============================================================================
// SARGE: DeclinedItemsManager
// Manages which items the player has declined
//=============================================================================
class DeclinedItemsManager extends Actor;

var globalconfig string declinedTypes[100];

function RemoveDeclinedItem(class<Inventory> invClass)
{
    local int i, pos;

    pos = -1;

    //find the item
    for (i = 0;i < ArrayCount(declinedTypes);i++)
    {
        if (declinedTypes[i] == string(invClass))
        {
            pos = i;
            break;
        }
    }

    if (pos == -1)
        return;

    //Move everything down
    for (i = pos;i < ArrayCount(declinedTypes);i++)
    {
        if (declinedTypes[i] == "" && declinedTypes[i+1] == "")
        {
            //do nothing
        }
        else if (i < 99)
            declinedTypes[i] = declinedTypes[i+1];
        else
            declinedTypes[i] = "";
    }

    SaveConfig();
}

function AddDeclinedItem(class<Inventory> invClass)
{
    local int i;

    //First, search for existing entry
    if (IsDeclined(invClass) || invClass == None)
        return;

    //Add it to the first slot
    for (i = 0;i < ArrayCount(declinedTypes);i++)
    {
        //log("declinedTypes["$i$"] is <" $ declinedTypes[i] $ ">");
        if (declinedTypes[i] == "")
        {
            declinedTypes[i] = string(invClass);
            //log("declinedTypes["$i$"] set to <" $ declinedTypes[i] $ ">");
            //log("Save Config");
            SaveConfig();
            //log("declinedTypes["$i$"] check: <" $ declinedTypes[i] $ ">");
            break;
        }
    }
}

function bool IsDeclined(class<Inventory> invClass)
{
    local int i;

    local DeusExPlayer player;
    player = DeusExPlayer(Owner);

    //Smart Decline - If player is holding Walk button, don't decline
    if (player.bRun != 0 && player.bSmartDecline)
        return false;

    for (i = 0;i < ArrayCount(declinedTypes);i++)
    {
        if (declinedTypes[i] ~= string(invClass))
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

defaultproperties
{
     bHidden=True
     bTravel=True
}
