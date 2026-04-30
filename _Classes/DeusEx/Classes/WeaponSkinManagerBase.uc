//This class is a stub.
//It is here to work as an interface for the actual Weapon Skin Manager
//See the included documentation for more information
class WeaponSkinManagerBase extends Object;

static function WeaponSkinManagerBase GetManager(Actor A)
{
    local WeaponSkinManagerBase Man;
    
    foreach A.AllObjects(class'WeaponSkinManagerBase',Man)
        return Man;
    return None;
}

function Init(DeusExPlayer newPlayer) {}
function bool UnlockSkinByID(string id, optional bool bNoMessage, optional string messageExtra) {}
function bool UnlockSkin(DeusExWeapon weapon, optional bool bNoMessage) {}
function SelectPreviousSkin(DeusExWeapon wep) {}
function SelectNextSkin(DeusExWeapon wep) {}
function string GetSkinName(DeusExWeapon wep) { return "default"; }
function int GetSkinCountFor(DeusExWeapon wep, optional bool bCountLocked) { return 1; }

//Apply Default Skin to Weapon
function SetDefaultSkin(DeusExWeapon weapon, Actor Owner) {}
function GetSkinFromCarcass(DeusExPlayer P, DeusExWeapon weapon, DeusExCarcass carc) {}

//Skin Additions
function AddSkin(string id, string className, string skinName, optional bool bUnlocked) {}
function AddSkinOwnerClass(string ownerClass) {}
function AddSkinTex(int texNum, string tex) {}
function Add3rdSkinTex(int texNum, string tex) {}
function AddSkinIcons(string beltIconTex, string largeIconTex) {}
function AddProjectileSkinTex(int texNum, string tex) {}
function AddProjectileSkin(string id, string className) {}

//Update and Apply Skins
function UpdateWeaponSkinTextures(DeusExWeapon wep) {}
function UpdateProjectileSkinTextures(DeusExProjectile proj) {}
function UpdateWeaponSkinsForPawn(ScriptedPawn P) {}
function ApplyWeaponSkin(DeusExWeapon wep, bool firstPerson) {}
function ApplyProjectileSkin(DeusExProjectile proj) {}
function ApplyProjectileSkinFrom(DeusExWeapon wep, DeusExProjectile proj) {}
function TransferSkin(DeusExWeapon wep) {}
function RefreshAllWeapons() {}
