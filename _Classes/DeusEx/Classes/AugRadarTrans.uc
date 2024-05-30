//=============================================================================
// AugRadarTrans.
//=============================================================================
class AugRadarTrans extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
class'DeusExPlayer'.default.bRadarTran=true;
//class'DeusExPlayer'.default.bCloakEnabled=true;                               //RSD: Overhauled cloak/radar routines
Player.PlaySound(Sound'GMDXSFX.Generic.Select', SLOT_Interact, 0.85, ,768,0.8);
}

function Deactivate()
{
	Super.Deactivate();

	class'DeusExPlayer'.default.bRadarTran=false;
	/*if (Player.AugmentationSystem.GetAugLevelValue(class'AugCloak')== -1.0)   //RSD: Overhauled cloak/radar routines
	   class'DeusExPlayer'.default.bCloakEnabled=false;*/
	Player.PlaySound(Sound'biomodoff', SLOT_Interact, 0.85, ,768,1.0);
}

function float GetEnergyRate()
{
	return energyRate * LevelValues[CurrentLevel];
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
      AugmentationLocation = LOC_Torso;
	}
}

defaultproperties
{
     mpAugValue=0.500000
     mpEnergyDrain=30.000000
     EnergyRate=340.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconRadarTrans'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconRadarTrans_Small'
     AugmentationName="Radar Transparency"
     Description="Radar-absorbent resin augments epithelial proteins; microprojection units distort agent's visual signature. Provides highly effective concealment from automated detection systems -- bots, cameras, turrets.|n|nTECH ONE: Power drain is normal.|n|nTECH TWO: Power drain is reduced slightly.|n|nTECH THREE: Power drain is reduced moderately.|n|nTECH FOUR: Power drain is reduced significantly."
     MPInfo="When active, you are invisible to electronic devices such as cameras, turrets, and proximity mines.  Energy Drain: Very Low"
     LevelValues(0)=1.000000
     LevelValues(1)=0.830000
     LevelValues(2)=0.660000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=2
}
