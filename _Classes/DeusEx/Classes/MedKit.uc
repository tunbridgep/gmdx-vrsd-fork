//=============================================================================
// MedKit.
//=============================================================================
class MedKit extends ConsumableItem;

//
// Healing order is head, torso, legs, then arms (critical -> less critical)
//
var int healAmount;

function bool CanAssignSecondary(DeusExPlayer player)
{
    return player.PerkManager.GetPerkWithClass(class'DeusEx.PerkCombatMedicsBag').bPerkObtained;
}

//SARGE: Cannot use if at max health
function bool RestrictedUse(DeusExPlayer player)
{
    return (player.Health >= player.GenerateTotalMaxHealth());
}

function OnActivate(DeusExPlayer player)
{
    super.OnActivate(player);

    // Medkits kill all status effects when used in multiplayer removed (player.Level.NetMode != NM_Standalone )||
    if (player.PerkManager.GetPerkWithClass(class'DeusEx.PerkToxicologist').bPerkObtained == true)
    {
        player.StopPoison();
        player.myPoisoner = None;
        player.poisonCounter = 0;
        player.poisonTimer   = 0;
        player.poisonDamage  = 0;
        player.drugEffectTimer = 0;	// stop the drunk effect
    }
}

//Override this to use medicine skill
//lazy hack
function HealMe(DeusExPlayer player)
{
    player.HealPlayer(healAmount, True);
}

function int GetHealAmount(DeusExPlayer player)
{
    return player.CalculateSkillHealAmount(healAmount);
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return (BeltSpot == 9);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bAutoActivate=True
     healAmount=30
	 CannotUse="You're already at full Health"
     maxCopies=15
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Medkit"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.MedKit'
     PickupViewMesh=LodMesh'DeusExItems.MedKit'
     ThirdPersonMesh=LodMesh'DeusExItems.MedKit3rd'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconMedKit'
     largeIcon=Texture'DeusExUI.Icons.LargeIconMedKit'
     largeIconWidth=39
     largeIconHeight=46
     Description="A first-aid kit.|n|n<UNATCO OPS FILE NOTE JR095-VIOLET> The nanomachines of an augmented agent will automatically metabolize the contents of a medkit to efficiently heal damaged areas. An agent with medical training could greatly expedite this process. -- Jaime Reyes <END NOTE>"
     beltDescription="MEDKIT"
     Skin=Texture'HDTPItems.Skins.HDTPMedKitTex1'
     Mesh=LodMesh'DeusExItems.MedKit'
     CollisionRadius=7.500000
     CollisionHeight=1.000000
     Mass=10.000000
     Buoyancy=8.000000
}
