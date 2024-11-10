//=============================================================================
// BioelectricCell.
//=============================================================================
class BioelectricCell extends ConsumableItem;

var int rechargeAmount;
var int mpRechargeAmount;

var localized String RechargesLabel;

function PostBeginPlay()
{
   Super.PostBeginPlay();
   if (Level.NetMode != NM_Standalone)
      bioenergyAmount = mpRechargeAmount;
}

function bool CanAssignSecondary(DeusExPlayer player)
{
    return player.PerkManager.GetPerkWithClass(class'DeusEx.PerkCombatMedicsBag').bPerkObtained;
}

//SARGE: Cannot use if at max bioenergy
function bool RestrictedUse(DeusExPlayer player)
{
    return (player.Energy >= player.EnergyMax);
}

//Set max copies based on the Medics Bag perk
function SetMax()
{
    local DeusExPlayer player;
    player = DeusExPlayer(Owner);

	if (player != none && player.PerkManager.GetPerkWithClass(class'DeusEx.PerkCombatMedicsBag').bPerkObtained == true)
		MaxCopies = default.MaxCopies + 5;
}

function bool DoLeftFrob(DeusExPlayer frobber)
{
    SetMax();
    return super.DoLeftFrob(frobber);
}

//SARGE: Moved the Bioenergy perk-based max amount bonus here, was in DeusExPlayer
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    SetMax();
    return super.DoRightFrob(frobber,objectInHand);
}

function OnActivate(DeusExPlayer player)
{
    super.OnActivate(player);
    player.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);
}


// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

function bool UpdateInfo(Object winObject)
{
    SetMax();
    Super.UpdateInfo(winObject);
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
     bAutoActivate=True
     bioenergyAmount=20
     mpRechargeAmount=50
	 CannotUse="You're already at full Energy"
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
