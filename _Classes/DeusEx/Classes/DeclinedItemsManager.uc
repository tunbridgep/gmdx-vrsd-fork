//=============================================================================
// SARGE: DeclinedItemsManager
// Manages which items the player has declined
//=============================================================================
class DeclinedItemsManager extends Actor config(GMDX);

var globalconfig string declinedTypes[100];

var private travel DeusExPlayer player;

function Setup(DeusExPlayer P)
{
    //Log("Decline Manager Setup");
    player = P;
}

function RemoveDeclinedItem(class<Inventory> invClass)
{
    local int i, pos;

    //player.ClientMessage("Remove Item: " $ invClass);

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
        {
            //player.ClientMessage(declinedTypes[i] $ " is now " $ declinedTypes[i+1]);
            declinedTypes[i] = declinedTypes[i+1];
        }
        else
            declinedTypes[i] = "";
    }

    SaveConfig();
}

function AddDeclinedItem(class<Inventory> invClass)
{
    local int i;

    //player.clientMessage("invClass: " $ invClass $ ", " $ GetDeclinedNumber());
    
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
            //player.ClientMessage("Adding " $ string(invClass) $ " at " $i);
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
