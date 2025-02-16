//=============================================================================
// SARGE: Empty Rocket Shell
// Used in UNATCO HQ after MJ12 Escape mission.
// Was originally a trophy, but made it into a new class since we want to HDTPify it
//=============================================================================
class EmptyRocketShell extends DeusExDecoration;

function bool IsHDTP()
{
    return DeusExPlayer(GetPlayerPawn()) != None && DeusExPlayer(GetPlayerPawn()).IsHDTPInstalled() && class'DeusEx.WeaponGEPGun'.default.iHDTPModelToggle > 0;
}

defaultproperties
{
     ItemName="Empty Rocket Shell"
     FamiliarName="Empty Rocket Shell"
     UnfamiliarName="Empty Rocket Shell"
     ItemArticle="a"
     HDTPMesh="HDTPItems.HDTPRocket"
     Mesh=LodMesh'DeusExItems.Rocket'
     DrawScale=0.250000
     CollisionRadius=8.000000
     CollisionHeight=2.000000
     Mass=34.000000
     Buoyancy=10.000000
}
