//=============================================================================
// OutdoorThings.
//=============================================================================
class SpiderBotFake extends DeusExDecoration;

function bool IsHDTP()
{
    return DeusExPlayer(GetPlayerPawn()).IsHDTPInstalled() && class'SpiderBot'.default.iHDTPModelToggle > 0;
}

defaultproperties
{
     bInvincible=True
     bHighlight=False
     HDTPMesh="HDTPCharacters.HDTPspiderbot2"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExCharacters.SpiderBot2'
     bAlwaysRelevant=True
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
}
