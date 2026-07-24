//=============================================================================
// ViewmodelFOVManager.
// Handles Viewmodel FOV adjustments
// Split into a separate class so we can use it for SkilledTools as well as Weapons.
// Based on code from DXR
//=============================================================================
class ViewmodelFOVManager extends Object;

var vector offsets;
var travel vector oldOffsets;
var globalconfig float weaponFOV;

function private vector GetDefaultWeaponOffsets(Inventory item)
{
    if (DeusExPickup(item) != None)
        return DeusExPickup(item).default.PlayerViewOffset;
    else if (DeusExWeapon(item) != None)
        return DeusExWeapon(item).default.PlayerViewOffset;
}

function private vector GetWeaponOffsets(Inventory item)
{
    if (SkilledTool(item) != None)
        return SkilledTool(item).weaponOffsets;
    else if (POVCorpse(item) != None)
        return POVCorpse(item).weaponOffsets;
    else if (DeusExWeapon(item) != None)
        return DeusExWeapon(item).weaponOffsets;
}

function private vector SetWeaponOffsets(Inventory item, vector newVal)
{
    if (DeusExPickup(item) != None)
        DeusExPickup(item).PlayerViewOffset = newVal;
    else if (DeusExWeapon(item) != None)
    {
        DeusExWeapon(item).PlayerViewOffset = newVal;
        DeusExWeapon(item).FireOffset = -newVal;
    }
}

function private vector SetDefaultWeaponOffsets(Inventory item, vector newVal)
{
    if (DeusExPickup(item) != None)
        DeusExPickup(item).default.PlayerViewOffset = newVal;
    else if (DeusExWeapon(item) != None)
    {
        DeusExWeapon(item).default.PlayerViewOffset = newVal;
        DeusExWeapon(item).default.FireOffset = -newVal;
    }
}

// convert horizontal FOV (deg) -> vertical FOV (deg) for an aspect ratio
//SARGE: This is greek to me
function private float H2V(float hdeg, float asp)
{
    local float hrad, vrad;
    hrad = hdeg * 3.14159265 / 180.0;
    vrad = 2.0 * ATan( Tan(hrad * 0.5) / asp );
    return vrad * 180.0 / 3.14159265;
}

function private float GetRatio(Inventory item)
{
	local int resX;
	local int resWidth, resHeight;
	local string CurrentRes;

	CurrentRes   = item.GetPlayerPawn().ConsoleCommand("GetCurrentRes");

	resX      = InStr(CurrentRes,"x");
	resWidth  = int(Left(CurrentRes, resX));
    resHeight = int(Mid(CurrentRes, resX+1));

    //l(CurrentRes $ " ratio == " $ (float(resWidth) / float(resHeight)) @ Left(CurrentRes, resX) @ Mid(CurrentRes, resX+1));

    if(resWidth<1 || resHeight<1)
        return 1.777;

	return float(resWidth) / float(resHeight);
}

function SetViewmodelOffset(Inventory item, optional bool bUpdateIndividualScale)
{
    local vector v;
    local float n, w, ratio; // narrow and wide multipliers
    local bool bDoOffsets;

    if (item == None/* || DeusExPlayer(item.Owner) == None*/)
        return;
    
    if (VSize(oldOffsets) == 0)
        oldOffsets = GetDefaultWeaponOffsets(item);

    bDoOffsets = class'DeusExPlayer'.default.bEnhancedWeaponOffsets;

    if (bDoOffsets)
    {
        offsets = GetWeaponOffsets(item);
        ratio = 1.777; // 16:9
        if(item.GetPlayerPawn() != None)
            ratio = GetRatio(item);

        w = H2V(class'DeusExPlayer'.default.DefaultFOV, ratio);

        w = (w - 46.710377) / (88.532219 - 46.710377); // interopolate from 75 degrees to 120 degrees
        w = FClamp(w, 0, 1);
        w *= 1.0+(1.0-(weaponFOV / 75.0));
        n = 1.0 - w;

        // interpolate between 75 FOV and 120 FOV, multiply vanilla values by n and wide FOV values by w
        // wide values provided by Tundoori https://discord.com/channels/823629359931195394/823629360929046530/1282526555536625778
        // X is distance from camera, Y is left/right, Z is up/down
        v =  oldOffsets * n;
        v += offsets * w;
    }
    else
    {
        v = oldOffsets;
    }
        
    SetDefaultWeaponOffsets(item,v);

    if (bUpdateIndividualScale)
    {
        v *= 100;
        SetWeaponOffsets(item,v);
    }
    
    DeusExPlayer(item.GetPlayerPawn()).DebugMessage("Applying Offsets for " $ item $ ": " $ v);
}

defaultproperties
{
     weaponFOV=75
}
