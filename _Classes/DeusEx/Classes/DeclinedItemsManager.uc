////=============================================================================
// SARGE: DeclinedItemsManager
// Manages which items the player has declined
//=============================================================================
class DeclinedItemsManager extends Actor;

var private globalconfig string declinedTypesSaved[100]; //Now we save our global declines separately
var private travel string declinedTypes[100];

//The combined list is repopulated every time we restart
var private transient string declinedListTemp[100];
var private transient int declinedListSize;

function RefreshFromGlobalList()
{
    local int i;

    DeusExPlayer(owner).DebugMessage("Refresh Declined Items");
    declinedListSize = 0;

    for (i = 0;i < ArrayCount(declinedTypesSaved);i++)
    {
        if (declinedTypesSaved[i] != "")
            declinedListTemp[declinedListSize++] = declinedTypesSaved[i];
    }
    
    for (i = 0;i < ArrayCount(declinedTypes);i++)
    {
        if (declinedTypes[i] != "")
            declinedListTemp[declinedListSize++] = declinedTypes[i];
    }
    
    for (i = 0;i < declinedListSize;i++)
        DeusExPlayer(owner).DebugMessage("Declined Item: " $ declinedListTemp[i]);
}

function private RemoveFromLists(class<Inventory> invClass)
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

    if (pos != -1)
    {
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
    }
    
    pos = -1;

    //find the item in the global list
    for (i = 0;i < ArrayCount(declinedTypesSaved);i++)
    {
        if (declinedTypesSaved[i] == string(invClass))
        {
            pos = i;
            break;
        }
    }

    if (pos != -1)
    {
        //Move everything down
        for (i = pos;i < ArrayCount(declinedTypesSaved);i++)
        {
            if (declinedTypesSaved[i] == "" && declinedTypesSaved[i+1] == "")
            {
                //do nothing
            }
            else if (i < 99)
                declinedTypesSaved[i] = declinedTypesSaved[i+1];
            else
                declinedTypesSaved[i] = "";
        }
        SaveConfig();
    }
}

function RemoveDeclinedItem(class<Inventory> invClass)
{
    RemoveFromLists(invClass);
    RefreshFromGlobalList();
}

function private _AddDeclinedItem(string invClass, bool bGlobal)
{
    local int i;
    local bool bAdded;

    //First, search for existing entry
    if (_IsDeclined(invClass) || invClass == "")
        return;

    if (!bGlobal)
    {
        //Add it to the first slot
        for (i = 0;i < ArrayCount(declinedTypes);i++)
        {
            //log("declinedTypes["$i$"] is <" $ declinedTypes[i] $ ">");
            if (declinedTypes[i] == "")
            {
                declinedTypes[i] = invClass;
                bAdded = true;
                //log("declinedTypes["$i$"] set to <" $ declinedTypes[i] $ ">");
                //log("Save Config");
                //log("declinedTypes["$i$"] check: <" $ declinedTypes[i] $ ">");
                break;
            }
        }
    }
    else
    {
        //Add it to the first slot in the global list
        for (i = 0;i < ArrayCount(declinedTypesSaved);i++)
        {
            if (declinedTypesSaved[i] == "")
            {
                DeusExPlayer(owner).DebugMessage("Add Global Declined Item");
                declinedTypesSaved[i] = invClass;
                bAdded = true;
                break;
            }
        }
        SaveConfig();
    }

    if (bAdded)
        declinedListTemp[declinedListSize++] = invClass;
}

function AddDeclinedItem(class<Inventory> invClass, optional bool bGlobal)
{
    _AddDeclinedItem(string(invClass),bGlobal);
}

function private bool _IsDeclined(string invClass)
{
    local int i;

    local DeusExPlayer player;
    player = DeusExPlayer(Owner);

    //Smart Decline - If player is holding Walk button, don't decline
    if (player.bRun != 0 && player.bSmartDecline)
        return false;

    for (i = 0;i < declinedListSize;i++)
    {
        if (declinedListTemp[i] ~= invClass)
            return true;
    }
    return false;
}

function bool IsDeclined(class<Inventory> invClass, optional bool bCheckBelt)
{
    local bool bBelt;

    bBelt = !bCheckBelt || DeusExPlayer(owner) == None || DeusExPlayer(owner).HasPlaceholderSlot(invClass) == -1;

    return bBelt && _IsDeclined(string(invClass));
}

function private bool _IsDeclinedGlobal(string invClass)
{
    local int i;
    for (i = 0;i < ArrayCount(declinedTypesSaved);i++)
    {
        if (declinedTypesSaved[i] ~= invClass)
            return true;
    }
    return false;
}

function private bool IsDeclinedGlobal(class<Inventory> invClass)
{
    return _IsDeclinedGlobal(string(invClass));
}

function int GetDeclinedNumber()
{
    return declinedListSize;
}

function string GetDeclinedItem(int index)
{
    if (index > declinedListSize)
        return "";
    else
        return declinedListTemp[index];
}

defaultproperties
{
     bHidden=True
     bTravel=True
}
