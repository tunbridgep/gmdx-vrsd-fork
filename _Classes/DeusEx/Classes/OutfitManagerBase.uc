//This class is a stub.
//It is here to work as an interface for the actual Outfit Manager
//See the included documentation for more information
class OutfitManagerBase extends Object;

//Part Slot Names
enum PartSlot
{
    PS_Body_M,
    PS_Body_F,
    PS_Main,             //Main model texture
    PS_Glasses,
    PS_Hat,
    PS_Mask,
    PS_Trench, //Common trench coats
    PS_Trench_F, //Female Exclusive trench coats
    PS_Trench_M, //Male Exclusive trench coats
    PS_Trench_Shirt, //Common Trench Shirts
    PS_Trench_Shirt_M, //Male Exclusive Trench Shirts
    PS_Trench_Shirt_F, //Female Exclusive Trench Shirts
    PS_Torso_M,
    PS_Torso_F,
    PS_Skirt,
    PS_Legs, //Common Legs
    PS_Legs_M, //Male exclusive legs
    PS_Legs_F, //Female exclusive legs
    PS_DressLegs //Legs used for dresses, stockings etc.
};


//These should be called in TravelPostAccept
//This is overridden by the real outfit manager if Augmentique is installed
//By default, all we want to do is destroy any spawners.
function Setup(DeusExPlayer newPlayer)
{
    local int i;
    local OutfitSpawner S;
    local Actor a;
	foreach newPlayer.AllActors(class'OutfitSpawner', S)
    {
        //Destroy objects linked to spawner
        foreach newPlayer.AllActors(class'Actor', a)
        {
            for(i = 0;i < 5;i++)
            {
                if (S.LinkedObjects[i] != "" && S.LinkedObjects[i] == string(a.Name))
                    a.Destroy();
            }
        }

        S.Destroy();
    }
}

function CompleteSetup() {}

//Parts List Functions
function GlobalAddPart(PartSlot slot,string name,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm) {}
function AddPart(PartSlot slot,string name,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm) {}
function GroupAddParts(PartSlot bodySlot) {}
function GroupTranspose(PartSlot bodySlot,optional int slot0,optional int slot1,optional int slot2,optional int slot3,optional int slot4,optional int slot5,optional int slot6,optional int slot7,optional int slot8) {}
function GroupTranspose2(PartSlot bodySlot, PartSlot bodySlot2,optional int slot0,optional int slot1,optional int slot2,optional int slot3,optional int slot4,optional int slot5,optional int slot6,optional int slot7,optional int slot8) {}

//Outfit Functions
function bool GetPartsGroup(string mesh) {}
function BeginNewPartsGroup(string mesh, bool allowMale, bool allowFemale) {}
function AddDefaultReference(string defRef) {}
function BeginNewOutfit(string id, string name, optional string desc, optional string highlightName, optional string pickupName, optional string pickupMessage, optional string pickupArticle) {}
function OutfitAddPartReference(string partID) {}
function Unlock(string id, optional bool bShowMessage) {}

//Function called by spawners
function SpawnerPickup(OutfitSpawner S) {}

//Force-apply current outfit
function ApplyCurrentOutfit() {}
