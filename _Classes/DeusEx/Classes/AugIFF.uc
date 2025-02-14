//=============================================================================
// AugIFF.
//=============================================================================
class AugIFF extends Augmentation;

var int HazardsRange;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state Active
{
Begin:
}

// ----------------------------------------------------------------------
// Deactivate()
// ----------------------------------------------------------------------

function Deactivate()
{
	Super.Deactivate();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

//Set to Toggle when we have more than 1 level
function Setup()
{
    super.Setup();
    if (CurrentLevel > 0)
    {
        if (AugmentationType == Aug_Passive && bIsActive)
            Deactivate();
        AugmentationType=Aug_Toggle;
        EnergyReserved=5;
    }
    else
    {
        AugmentationType=Aug_Passive;
        EnergyReserved=0;
    }
}

defaultproperties
{
     EnergyRate=0.000000
     MaxLevel=2
     Icon=Texture'DeusExUI.UserInterface.AugIconIFF'
     AugmentationType=Aug_Passive
     AugmentationName="IFF"
     Description="Automatic friend or foe identification uses advanced heuristic algorithms to associate visible objects with known threat categories.|n|nTargeting reticle highlights RED over enemies, and GREEN over allies and neutrals.|n|nNO UPGRADES"
     LevelValues(0)=1.000000
     LevelValues(1)=2.000000
     LevelValues(2)=3.000000
     HazardsRange=50;
     AugmentationLocation=LOC_Default
     bAddedToWheel=false;
}
