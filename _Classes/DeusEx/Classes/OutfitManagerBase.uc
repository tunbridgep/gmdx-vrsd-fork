//This class is a stub.
//It is here to work as an interface for the actual Outfit Manager
//See the included documentation for more information
class OutfitManagerBase extends Object abstract;

//This should be called in TravelPostAccept
function Setup(DeusExPlayer newPlayer) {}

function ApplyCurrentOutfit() {}

function Unlock(string id) {}

function string GetOutfitNameByID(string id) {}

function BeginNewOutfit(string id, string n, string d, string preview, bool male, bool female) {}
function SetOutfitMesh(string mesh) {}
function SetOutfitAccessorySlots(int t0, int t1, int t2, int t3, int t4, int t5, int t6, int t7, int tm) {}
function SetOutfitTextures(optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional int accessoriesOffset) {}
function SetOutfitMainTex(string tm) {}
function SetOutfitBodyTex(string t0) {}
function SetOutfitDisableAccessories() {}

//Function called by spawners
function bool ValidateSpawn(string id) {}
