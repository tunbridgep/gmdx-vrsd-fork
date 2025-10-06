//=============================================================================
// PickupDistributor.
//=============================================================================
class PickupDistributor extends Keypoint;

//
// Distributes NanoKeys at the start of a level, then destroys itself
//

// copied from NanoKey
enum ESkinColor
{
	SC_Level1,
	SC_Level2,
	SC_Level3,
	SC_Level4
};

struct SNanoKeyInitStruct
{
	var() name					ScriptedPawnTag;
	var() name					KeyID;
	var() localized String		Description;
	var() ESkinColor			SkinColor;
};

var() localized SNanoKeyInitStruct NanoKeyData[8];

//SARGE: This has to be a new variable, it can't be in the struct or the editor breaks.
struct SNanoKeyExtraData
{
    var() bool bDontAllowHardcore;             //SARGE: Don't give out this key in Hardcore mode.
};

var() SNanoKeyExtraData ExtraData[8];

function PostPostBeginPlay()
{
	local int i;
	local ScriptedPawn P;
	local NanoKey key;
	local DeusExPlayer Playa; //SARGE: Added for Hardcore check. See below.

    playa = DeusExPlayer(GetPlayerPawn()); //SARGE: Added for Hardcore check. See below.

	Super.PostPostBeginPlay();

	for(i=0; i<ArrayCount(NanoKeyData); i++)
	{
		if (NanoKeyData[i].ScriptedPawnTag != '' && (playa == None || !playa.bHardcoreMode || !ExtraData[i].bDontAllowHardcore)) //SARGE: Added hardcore checking
		{
			foreach AllActors(class'ScriptedPawn', P, NanoKeyData[i].ScriptedPawnTag)
			{
				key = spawn(class'NanoKey', P);
				if (key != None)
				{
					key.KeyID = NanoKeyData[i].KeyID;
					key.Description = NanoKeyData[i].Description;
//					key.SkinColor = NanoKeyData[i].SkinColor;
					key.InitialState = 'Idle2';
					key.GiveTo(P);
					key.SetBase(P);
				}
			}
		}
	}

	Destroy();
}

defaultproperties
{
     bStatic=False
}
