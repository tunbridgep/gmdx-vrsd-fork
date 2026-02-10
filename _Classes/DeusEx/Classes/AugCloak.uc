//=============================================================================
// AugCloak.
//=============================================================================
class AugCloak extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
var ExplosionLight lite;

state Active
{

Begin:
	if ((Player.inHand != None) && (Player.inHand.IsA('DeusExWeapon')))
		Player.ServerConditionalNotifyMsg( Player.MPMSG_NoCloakWeapon );

    AISendEvent('LoudNoise',EAITYPE_Audio,,416);
	player.CloakManager.SetCloaked(true,true); //GMDX
 }

function Deactivate()
{
    AISendEvent('LoudNoise',EAITYPE_Audio,,416);
	player.CloakManager.ForceOff(true); //GMDX
	Super.Deactivate();
}

simulated function float GetEnergyRate()
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
      AugmentationLocation = LOC_Eye;
	}
}

defaultproperties
{
     mpAugValue=1.000000
     mpEnergyDrain=40.000000
     EnergyRate=340.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconCloak'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCloak_Small'
     AugmentationName="Cloak"
     Description="Subdermal pigmentation cells allow the agent to blend with their surrounding environment, rendering them effectively invisible to observation by organic hostiles.|n|nTECH ONE: Power drain is normal.|n|nTECH TWO: Power drain is reduced slightly.|n|nTECH THREE: Power drain is reduced moderately.|n|nTECH FOUR: Power drain is reduced significantly."
     MPInfo="When active, you are invisible to enemy players.  Electronic devices and players with the vision augmentation can still detect you.  Cannot be used with a weapon.  Energy Drain: Moderate"
     LevelValues(0)=1.000000
     LevelValues(1)=0.830000
     LevelValues(2)=0.660000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=6
}
