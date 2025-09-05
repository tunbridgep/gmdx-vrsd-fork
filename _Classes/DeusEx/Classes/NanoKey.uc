//=============================================================================
// NanoKey.
//=============================================================================
class NanoKey extends DeusExPickup;

var() name			KeyID;			// unique FName identifier used for movers and such

var const localized string DuplicateMsg; //SARGE: Appended to name when we have a duplicate

enum ESkinColor
{
	SC_Level1,
	SC_Level2,
	SC_Level3,
	SC_Level4
};

var() ESkinColor SkinColor;

//Add it to the frobbers keyring, then destroy it
function bool DoLeftFrob(DeusExPlayer frobber)
{
    frobber.PickupNanoKey(Self);
    Destroy();
    return false;
}
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    frobber.PickupNanoKey(Self);
    Destroy();
    return false;
}

//Sarge: Update key frob display when we have a duplicate, and use the description if it's been assigned
function string GetFrobString(DeusExPlayer player)
{
    local string frobString;

    //Don't allow DEFAULT DESCRIPTION NAME keys
    if (Description != default.Description)
        frobString = Description;
    else
        frobString = itemName;

    //SARGE: Make the frob string look nice
    //frobString = player.TitleCase(frobString); //SARGE: Now done in BeginPlay

    if ((player.iToolWindowShowDuplicateKeys == 1 || player.iToolWindowShowDuplicateKeys == 3) && player.KeyRing.HasKey(KeyID))
        frobString = frobString @ DuplicateMsg;

    return frobString;
}

// ----------------------------------------------------------------------
// BeginPlay()
// ----------------------------------------------------------------------

function BeginPlay()
{
	Super.BeginPlay();
    
    //SARGE: A lot of descriptions weird and inconsistent capitalisation.
    //I'm too lazy to fix them in the maps, so we will just fix them here.
    Description = class'DeusExPlayer'.static.TitleCase(Description);

	switch (SkinColor)
	{
		case SC_Level1:	MultiSkins[0] = Texture'NanoKeyTex1'; break;
		case SC_Level2:	MultiSkins[0] = Texture'NanoKeyTex2'; break;
		case SC_Level3:	MultiSkins[0] = Texture'NanoKeyTex3'; break;
		case SC_Level4:	MultiSkins[0] = Texture'NanoKeyTex4'; break;
	}
}

// ----------------------------------------------------------------------
// GiveTo()
//
// Called during conversations since HandlePickupQuery() isn't called
// then
// ----------------------------------------------------------------------

function GiveTo( pawn Other )
{
	local DeusExPlayer player;

	if (Other.IsA('DeusExPlayer'))
	{
		player = DeusExPlayer(Other);
		player.PickupNanoKey(Self);
		Destroy();
	}
	else
	{
		Super.GiveTo(Other);
	}
}

// ----------------------------------------------------------------------
// HandlePickupQuery()
//
// Adds the NanoKey to the player's NanoKeyRing and then destroys
// this object
// ----------------------------------------------------------------------

function bool HandlePickupQuery( inventory Item )
{
	local DeusExPlayer player;

	if ( Item.Class == Class )
	{
		player = DeusExPlayer(Owner);
		player.PickupNanoKey(NanoKey(item));
		item.Destroy();

		return True;
	}

	return Super.HandlePickupQuery(Item);
}

auto state Pickup
{
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
}
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ItemName="NanoKey"
     DuplicateMsg="(Duplicate)"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.NanoKey'
     PickupViewMesh=LodMesh'DeusExItems.NanoKey'
     ThirdPersonMesh=LodMesh'DeusExItems.NanoKey'
     Icon=Texture'DeusExUI.Icons.BeltIconNanoKey'
     Description="NO KEY DESCRIPTION - REPORT THIS AS A BUG!"
     beltDescription="NANO"
     Mesh=LodMesh'DeusExItems.NanoKey'
     CollisionRadius=2.050000
     CollisionHeight=3.110000
     Mass=1.000000
}
