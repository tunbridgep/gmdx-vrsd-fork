//=============================================================================
// AugHeartLung.
//=============================================================================
class AugHeartLung extends Augmentation;

//CyberP: now automatic w/ use of a silly hack. Be wary of modifiying aug drain rates.
state Active
{
Begin:
	// make sure if the player turns on any other augs while
	// this one is on, it gets affected also.
/*Loop:                                                                         //RSD: Now fully passive
	Player.AugmentationSystem.BoostAugs(True, Self);
	Sleep(1.0);
	Goto('Loop');*/
}

function Deactivate()
{
	Super.Deactivate();

	/*Player.AugmentationSystem.BoostAugs(False, Self);                         //RSD: Now fully passive
	Player.AugmentationSystem.DeactivateAll();*/
}

simulated function float GetEnergyRate()
{
	return energyRate * LevelValues[CurrentLevel];
}

defaultproperties
{
     EnergyRate=0.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconHeartLung'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconHeartLung_Small'
     bAlwaysActive=True
     AugmentationName="Synthetic Heart"
     Description="This synthetic heart circulates not only blood but a steady concentration of mechanochemical power cells, smart phagocytes, and liposomes containing prefab diamondoid machine parts, resulting in upgraded performance for all installed augmentations.|n|n<UNATCO OPS FILE NOTE JR133-VIOLET> However, this will not enhance any augmentation past its maximum upgrade level. -- Jaime Reyes <END NOTE>|n|nNO UPGRADES"
     LevelValues(0)=1.400000
     LevelValues(1)=1.300000
     LevelValues(2)=1.200000
     LevelValues(3)=1.100000
     AugmentationLocation=LOC_Torso
}
