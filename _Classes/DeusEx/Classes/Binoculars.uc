//=============================================================================
// Binoculars.
//=============================================================================
class Binoculars extends DeusExPickup;

var int ScopeFov;

//SARGE: Always allow as secondary
function bool CanAssignSecondary(DeusExPlayer player)
{
    return true;
}

function OnDeActivate(DeusExPlayer player)
{
    player.DesiredFOV = player.Default.DesiredFOV;
    //player.PlaySound(Sound'binmiczoomout', SLOT_None);
    // Hide the Scope View
    DeusExRootWindow(player.rootWindow).scopeView.DeactivateView();
}


function OnActivate(DeusExPlayer player)
{
    //PlaySound(Sound'binmiczoomin', SLOT_None);
    RefreshScopeDisplay(player, FALSE);
}

// ----------------------------------------------------------------------
// RefreshScopeDisplay()
// ----------------------------------------------------------------------

function RefreshScopeDisplay(DeusExPlayer player, optional bool bInstant)
{
	if ((bActive) && (player != None))
	{
		// Show the Scope View
		DeusExRootWindow(player.rootWindow).scopeView.ActivateView(ScopeFov, True, bInstant);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     DeactivateSound=Sound'binmiczoomout'
     ActivateSound=Sound'binmiczoomim'
     ScopeFOV=20
     bBreakable=True
     FragType=Class'DeusEx.PlasticFragment'
     maxCopies=1
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Binoculars"
     ItemArticle="some"
     PlayerViewOffset=(X=18.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Binoculars'
     PickupViewMesh=LodMesh'DeusExItems.Binoculars'
     ThirdPersonMesh=LodMesh'DeusExItems.Binoculars'
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconBinoculars'
     largeIcon=Texture'DeusExUI.Icons.LargeIconBinoculars'
     largeIconWidth=49
     largeIconHeight=34
     Description="A pair of military binoculars."
     beltDescription="BINOCS"
     Skin=Texture'HDTPItems.Skins.HDTPBinocularsTex1'
     Mesh=LodMesh'DeusExItems.Binoculars'
     CollisionRadius=7.000000
     CollisionHeight=2.060000
     Mass=5.000000
     Buoyancy=6.000000
}
