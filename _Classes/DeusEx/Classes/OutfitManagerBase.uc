//This class is a stub.
//It is here to work as an interface for the actual Outfit Manager
//See the included documentation for more information
class OutfitManagerBase extends Object abstract;

//This should be called in TravelPostAccept
function Setup(DeusExPlayer newPlayer) {}

function ApplyCurrentOutfit() {}

function Unlock(string id) {}

function string GetOutfitNameByID(string id) {}

function AddOutfit(string id, string n, string d, bool male, bool female, optional string mesh, optional string tm, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional int accessoriesOffset) {}

