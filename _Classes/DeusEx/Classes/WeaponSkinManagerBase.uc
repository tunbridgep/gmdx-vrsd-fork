//This class is a stub.
//It is here to work as an interface for the actual Weapon Skin Manager
//See the included documentation for more information
class WeaponSkinManagerBase extends Object;

function Init(DeusExPlayer newPlayer) {}
function bool UnlockSkin(string id, optional bool bNoMessage) {}
function UpdateWeaponSkinTextures(DeusExWeapon wep) {}
function SelectPreviousSkin(DeusExWeapon wep) {}
function SelectNextSkin(DeusExWeapon wep) {}
function string GetSkinName(DeusExWeapon wep) { return ""; }
function int GetSkinCountFor(DeusExWeapon wep, optional bool bCountLocked) { return 1; }
function RefreshAllWeapons() {}
function TransferSkin(DeusExWeapon wep) {}

//Apply Default Skin to Weapon
function SetDefaultSkin(DeusExWeapon weapon, Actor Owner) {}
function GetSkinFromCarcass(DeusExPlayer P, DeusExWeapon weapon, DeusExCarcass carc) {}

//Skin Additions
function AddSkin(string id, string className, string skinName, optional bool bUnlocked) {}
function AddSkinOwnerClass(string ownerClass) {}
function AddSkinTex(int texNum, string tex) {}
function Add3rdSkinTex(int texNum, string tex) {}
function AddSkinIcons(string beltIconTex, string largeIconTex) {}

//AUGMENTIQUE: Once our weapons are created, we need to update their skins
static function UpdateWeaponSkinsForPawn(ScriptedPawn P)
{
    local WeaponSkinManagerBase M;
    local Inventory I;
    foreach P.AllObjects(class'WeaponSkinManagerBase', M)
    {
        if (DeusExWeapon(P.Weapon) != None)
            M.SetDefaultSkin(DeusExWeapon(P.Weapon),P);

        I = P.Inventory;
        while (I != None)
        {
            if (I.IsA('DeusExWeapon'))
                M.SetDefaultSkin(DeusExWeapon(I),P);

            I = I.Inventory;
        }
        return;
    }
}

//Detect HDTP model using mesh path. Disgusting
function static bool IsHDTP(DeusExWeapon wep)
{
    return InStr(caps(string(wep.Mesh)),"HDTPItems.") == 0;
}

function static bool IsFomod(DeusExWeapon wep)
{
    return InStr(caps(string(wep.Mesh)),"FOMOD.") == 0;
}

static function ApplyWeaponSkin(DeusExWeapon wep, bool firstPerson)
{
    local int i;

    //Don't change non-default models (HDTP etc...)
    //if (wep.Mesh != wep.default.PlayerViewMesh && wep.Mesh != wep.default.PickupViewMesh && wep.Mesh != wep.default.ThirdPersonMesh)
    if (IsHDTP(wep) || IsFomod(wep))
        return;

    for(i = 0;i < 8;i++)
    {
        if (firstPerson)
        {
            //Log(wep.currentWeaponSkin @ "Skin: " $ wep.skinTextures[i]);
            if (wep.multiSkins[i] == None)
                wep.multiSkins[i] = wep.skinTextures[i];
        }
        else
        {
            //Log(wep.currentWeaponSkin @ "Skin: " $ wep.skinTextures3rd[i]);
            if (wep.multiSkins[i] == None)
                wep.multiSkins[i] = wep.skinTextures3rd[i];
        }
    }

    if (firstPerson)
    {
        //Log(wep.currentWeaponSkin @ "Skin: " $ wep.Skin);
        if (wep.Skin == None)
            wep.Skin = wep.skinTextures[0];
        if (wep.Texture == None)
            wep.Texture = wep.skinTextures[8];
    }
    else
    {
        //Log(wep.currentWeaponSkin @ "Skin: " $ wep.Skin);
        if (wep.Skin == None)
            wep.Skin = wep.skinTextures3rd[0];
        if (wep.Texture == None)
            wep.Texture = wep.skinTextures3rd[8];
    }

}
