//=============================================================================
// WoundBloodLoss.
//=============================================================================
class WoundBloodLoss extends Wound;

function WoundAdded()
{
    local int newTotal;

    newTotal = player.default.HealthTorso+Player.GetTorsoHealthAdjustment();
    
    //Cap health at the new value.
    player.HealthTorso = MIN(newTotal,player.HealthTorso);
    
    player.GenerateTotalHealth();
}

function WoundRemoved()
{
    //player.HealthTorso += woundData[0];
    player.GenerateTotalHealth();
}

defaultproperties
{
    WoundName="Blood Loss"
    WoundDescription="Blood loss occurs after consistent damage over time. When untreated, it can cause significant body weakness. (-%d Torso HP)"
    woundData(0)=40
}

