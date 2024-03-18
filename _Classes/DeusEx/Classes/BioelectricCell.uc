//=============================================================================
// BioelectricCell.
//=============================================================================
class BioelectricCell extends DeusExPickup;

var int rechargeAmount;
var int mpRechargeAmount;

var localized String msgRecharged;
var localized String RechargesLabel;

/*function PostBeginPlay()
{
   Super.PostBeginPlay();
   if (Level.NetMode != NM_Standalone)
      rechargeAmount = mpRechargeAmount;
}*/

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;
        local float origEnergy;                                                 //RSD: Added

		Super.BeginState();

		//player = DeusExPlayer(Owner);
		player = DeusExPlayer(GetPlayerPawn());                                 //RSD: Altering this to enable generic LeftClick interact
		if (player != None)
		{
		    origEnergy = player.Energy;                                         //RSD

            if (player.PerkNamesArray[8]==1)
		    rechargeAmount=25;
			//player.ClientMessage(Sprintf(msgRecharged, rechargeAmount));      //RSD

			player.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);

			player.Energy += rechargeAmount;
			if (player.Energy > player.EnergyMax)
				player.Energy = player.EnergyMax;

			player.ClientMessage(Sprintf(msgRecharged, int(player.Energy-origEnergy+0.5))); //RSD: Tells you how much energy you actually recovered
		}

		UseOnce();
	}
Begin:
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local string str;
    local DeusExPlayer player;

    player = DeusExPlayer(Owner);

	if (player != none && player.PerkNamesArray[30]==1)
		MaxCopies = 25;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	if (player.PerkNamesArray[30] == 1)
		winInfo.AddSecondaryButton(self);                                       //RSD: Can now equip biocells as secondaries with the Combat Medic's Bag perk
	winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());
	if (player.PerkNamesArray[8]==1)                                            //RSD: Set here because otherwise is only set when activating
		rechargeAmount=25;
	winInfo.AppendText(Sprintf(RechargesLabel, RechargeAmount));

	// Print the number of copies
	str = CountLabel @ String(NumCopies);
	winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ str);

	return True;
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return (BeltSpot == 0);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     rechargeAmount=20
     mpRechargeAmount=50
     msgRecharged="Recharged %d points"
     RechargesLabel="Recharges %d Energy Units"
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Bioelectric Cell"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.BioCell'
     PickupViewMesh=LodMesh'DeusExItems.BioCell'
     ThirdPersonMesh=LodMesh'DeusExItems.BioCell'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconBioCell'
     largeIcon=Texture'DeusExUI.Icons.LargeIconBioCell'
     largeIconWidth=44
     largeIconHeight=43
     Description="A bioelectric cell provides efficient storage of energy in a form that can be utilized by a number of different devices.|n|n<UNATCO OPS FILE NOTE JR289-VIOLET> Augmented agents have been equipped with an interface that allows them to transparently absorb energy from bioelectric cells. -- Jaime Reyes <END NOTE>"
     beltDescription="BIOCELL"
     Mesh=LodMesh'DeusExItems.BioCell'
     CollisionRadius=4.700000
     CollisionHeight=0.930000
     Mass=5.000000
     Buoyancy=4.000000
}
