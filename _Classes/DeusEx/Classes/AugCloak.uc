//=============================================================================
// AugCloak.
//=============================================================================
class AugCloak extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
var ExplosionLight lite;
var SpoofedCoronaSmall cor;
var Vector offset, X, Y, Z;
var Vector Dir;

state Active
{

Begin:
	if ((Player.inHand != None) && (Player.inHand.IsA('DeusExWeapon')))
		Player.ServerConditionalNotifyMsg( Player.MPMSG_NoCloakWeapon );
	Player.PlaySound(Sound'CloakUp', SLOT_None, 0.85, ,768,1.0);
    AISendEvent('LoudNoise',EAITYPE_Audio,,416);
    lite=Spawn(class'ExplosionLight',,,Player.Location);
    if (lite != none)
    {
     //lite.LightType=LT_Flicker;
     //lite.LightBrightness=255;
     lite.LightHue=144;
     lite.LightSaturation=80;
     lite.size=6;
    }

    if (Player.bNoTranslucency && Player.CarriedDecoration != none)
	{
    Player.CarriedDecoration.Style = STY_Translucent;
	Player.CarriedDecoration.ScaleGlow = 0.2; //was 1.0
	Player.CarriedDecoration.bUnlit = True;
    }
	class'DeusExPlayer'.default.bCloakEnabled=true;
	Player.Style = STY_Translucent;
	Player.ScaleGlow = 0.001;
	Player.MultiSkins[6] = Texture'PinkMaskTex';
    Player.MultiSkins[7] = Texture'PinkMaskTex';
    offset=vect(0,0,0);
 }

function Deactivate()
{
	Player.PlaySound(Sound'CloakDown', SLOT_None, 0.85, ,768,1.0);
	class'DeusExPlayer'.default.bCloakEnabled=false; //GMDX
    Player.Style = Player.default.Style;
	Player.ScaleGlow = Player.default.ScaleGlow;
	Player.MultiSkins[6] = Texture'DeusExCharacters.Skins.FramesTex4';
    Player.MultiSkins[7] = Texture'DeusExCharacters.Skins.LensesTex5';
	if (Player.bNoTranslucency && Player.CarriedDecoration != none)
	{
    Player.CarriedDecoration.Style = Player.CarriedDecoration.default.Style;
	Player.CarriedDecoration.ScaleGlow = Player.CarriedDecoration.default.ScaleGlow;
	Player.CarriedDecoration.bUnlit = False;
    }
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
