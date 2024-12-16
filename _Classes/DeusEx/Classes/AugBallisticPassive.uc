//=============================================================================
// AugBallisticPassive.
//=============================================================================
class AugBallisticPassive extends AugBallistic;

var float mpAugValue;
var float mpEnergyDrain;

var localized string DamageModDesc;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
	}
}

//SARGE: New function to get the damage modifier for the augmentation
function float GetDamageMod()
{
    local float damageMod;
    if (CurrentLevel >= 0.0 && player.Energy > 0)
    {
        //damageMod = 1.0-(player.Energy/player.GetMaxEnergy())*(1.0-LevelValues[CurrentLevel]);               //RSD: Now protects proportionally to current energy (up to 20/25/30/35%)
        //damageMod = 1.0 - 0.35*FClamp(player.Energy/(LevelValues[CurrentLevel]*player.GetMaxEnergy()),0.0,1.0);//RSD: Still proportional, but up to 35% protection depending on 100/80/60/40% of your energy bar
        damageMod = 1.0 - 0.35*FClamp((player.Energy+GetAdjustedEnergyReserve())/(LevelValues[CurrentLevel]*player.GetMaxEnergy(true)),0.0,1.0);//SARGE: As above, but also takes into account the energy reserved by the augmentation, and scales off your total max energy, not max after reserves
    }
    return damageMod;
}

function string GetDescription()
{
    return Description $ "|n|n" $ sprintf(DamageModDesc,int(100 * (1.0 - GetDamageMod())));
}

defaultproperties
{
     mpAugValue=0.600000
     mpEnergyDrain=90.000000
     EnergyRate=0.000000
     EnergyReserved=20
     AugmentationType=Aug_Toggle
     AugmentationName="Ballistic Protection (Passive)"
     DamageModDesc="Current Damage Resistance: %d%%"
     Description="A monomolecular wire lattice permanently reinforces the skin's epithelial membrane, reducing the damage an agent receives from solid projectiles, blunt weapons and bladed weapons.|n|nThe strength of the lattice is proportional to the the agent's ambient bioelectric field, providing full protection (35%) only at a certain charge threshold.|n|nTECH ONE: The charge threshold for full protection is at a maximum (100%).|n|nTECH TWO: The charge threshold for full protection is reduced slightly (80%).|n|nTECH THREE: The charge threshold for full protection is reduced moderately (60%).|n|nTECH FOUR: The charge threshold for full protection is reduced significantly (40%)."
     LevelValues(0)=1.000000
     LevelValues(1)=0.800000
     LevelValues(2)=0.600000
     LevelValues(3)=0.400000
}
