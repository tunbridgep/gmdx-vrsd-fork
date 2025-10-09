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
    return (player.Energy >= player.GetMaxEnergy());
}

function OnActivate(DeusExPlayer player)
{
    super.OnActivate(player);
    player.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);
}


// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return (BeltSpot == 0);
}

//SARGE: Max number is lowered on Hardcore
/*
function int RetMaxCopies()
{
    local DeusExPlayer player;
    local int amount;
    player = DeusExPlayer(GetPlayerPawn());

    if (player != None && player.bHardcoreMode)
        amount = 5;
    else
        amount = default.maxCopies;

    if (player != None && player.PerkManager != None && player.PerkManager.GetPerkWithClass(class'PerkCombatMedicsBag').bPerkObtained)
        amount += 5;

    return amount;
}
*/

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bBiogenic=true
     bAutoActivate=True
     bioenergyAmount=15
     mpRechargeAmount=50
	 CannotUse="You're already at full Energy"
     maxCopies=15
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
