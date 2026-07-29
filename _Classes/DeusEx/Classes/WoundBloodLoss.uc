//=============================================================================
// WoundBloodLoss.
//=============================================================================
class WoundBloodLoss extends Wound;

function WoundAdded()
{
    local int newTotal;
    
    Super.WoundAdded();

    newTotal = player.default.HealthTorso+Player.GetTorsoHealthAdjustment();
    
    //Cap health at the new value.
    player.HealthTorso = MIN(newTotal,player.HealthTorso);
    player.HealthTorso = MAX(1,player.HealthTorso);
    
    player.GenerateTotalHealth();
}

function WoundRemoved()
{
    Super.WoundRemoved();
    //player.HealthTorso += woundData[0];
    player.GenerateTotalHealth();
}

defaultproperties
{
    WoundName="Blood Loss"
    WoundDescription="Blood loss occurs after taking repeated instances of damage resulting in bleeding. When untreated, it can cause significant body weakness. (-%d Torso HP)"
    woundData(0)=40
}

