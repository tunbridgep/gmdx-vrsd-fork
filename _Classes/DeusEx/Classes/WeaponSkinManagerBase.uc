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

//Skin Additions
function AddSkin(string id, string className, string skinName, optional bool bUnlocked) {}
function AddSkinTex(int texNum, string tex) {}
function Add3rdSkinTex(int texNum, string tex) {}
function AddSkinIcons(string beltIconTex, string largeIconTex) {}
