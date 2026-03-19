//=============================================================================
// WoundPoison.
//=============================================================================
class WoundPoison extends Wound;

defaultproperties
{
    WoundName="Poisoning"
    WoundDescription="After being poisoned, agents suffer significant nausea and lethargy, preventing consumption of food and drink and reducing movement speed by %d percent"
    woundData(0)=10
    DamageThreshold=200
}

