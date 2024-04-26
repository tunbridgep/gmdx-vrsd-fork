//=============================================================================
// PerkSystem.
//=============================================================================

// Trash: This is where perks are initialized and stored
// PERK SYSTEM #2: Add the perk that you created to InitializePerks()

class PerkSystem extends Actor
	intrinsic;

var travel Perk PerkList[37];			// Trash: Hopefully with this system, you can make this 500 and it wouldn't matter much
var travel int numPerks;				// Trash: UnrealScript doesn't support lists, so this is essentially the number of perks in the game
var travel DeusExPlayer PlayerAttached;	// Trash: The player this class is attached to


// ----------------------------------------------------------------------
// InitializePerks()
// ----------------------------------------------------------------------

function InitializePerks(DeusExPlayer newPlayer)	// Trash: Add every perk in the game to the PerkList[] array and assign the player
{
	PlayerAttached = newPlayer;

	// Rifle Perks
	AddPerk(Class'DeusEx.PerkSteady');
	AddPerk(Class'DeusEx.PerkStoppingPower');
	AddPerk(Class'DeusEx.PerkMarksman');

	// Pistol Perks
	AddPerk(Class'DeusEx.PerkSidearm');
	AddPerk(Class'DeusEx.PerkOneHanded');
	AddPerk(Class'DeusEx.PerkHumanCombustion');

	// Lowtech Perks
	AddPerk(Class'DeusEx.PerkSharpEyed');
	AddPerk(Class'DeusEx.PerkPiercing');
	AddPerk(Class'DeusEx.PerkInventive');

	// Heavy Perks
	AddPerk(Class'DeusEx.PerkControlledBurn');
	AddPerk(Class'DeusEx.PerkBlastEnergy');
	AddPerk(Class'DeusEx.PerkHERocket');

	// Demolition Perks
	AddPerk(Class'DeusEx.PerkSonicTransducerSensor');
	AddPerk(Class'DeusEx.PerkShortFuse');
	AddPerk(Class'DeusEx.PerkKnockoutGas');

	// Lockpicking Perks
	AddPerk(Class'DeusEx.PerkSleightOfHand');
	AddPerk(Class'DeusEx.PerkDoorsman');
	AddPerk(Class'DeusEx.PerkLocksport');

	// Electronics Perks
	AddPerk(Class'DeusEx.PerkSabotage');
	AddPerk(Class'DeusEx.PerkWirelessStrength');
	AddPerk(Class'DeusEx.PerkCracked');

	// Medicine Perks
	AddPerk(Class'DeusEx.PerkBiogenic');
	AddPerk(Class'DeusEx.PerkToxicologist');
	AddPerk(Class'DeusEx.PerkCombatMedicsBag');

	// Enviro TrainPerks
	AddPerk(Class'DeusEx.PerkFieldRepair');
	AddPerk(Class'DeusEx.PerkHardened');
	AddPerk(Class'DeusEx.PerkTechSpecialist');

	// Athletics Perks
	AddPerk(Class'DeusEx.PerkPerserverance');
	AddPerk(Class'DeusEx.PerkAdrenalineRush');
	AddPerk(Class'DeusEx.PerkEndurance');

	// Stealth Perks
	AddPerk(Class'DeusEx.PerkNimble');
	AddPerk(Class'DeusEx.PerkSecurityLoophole');
	AddPerk(Class'DeusEx.PerkTacticalDistraction');

	// Hacking Perks
	AddPerk(Class'DeusEx.PerkModder');
	AddPerk(Class'DeusEx.PerkMisfeatureExploit');
	AddPerk(Class'DeusEx.PerkTurretDomination');
}

function AddPerk(class<Perk> perk)
{
	local Perk perkInstance;

	perkInstance = new(self)Perk;

	PerkList[numPerks] = perkInstance;
    numPerks++;
}

// ----------------------------------------------------------------------
// GetPerkIndex()
// ----------------------------------------------------------------------

function int GetPerkIndex(Perk Perk)  // Trash: Get the index of the perk by just checking the class
{
	local int index;

	for (index = 0; index < ArrayCount(PerkList); index++)
	{
		if (PerkList[index] == Perk)
		{
			return index;
		}
	}
}

// ----------------------------------------------------------------------
// GetPerksForSkill()
// ----------------------------------------------------------------------

function Perk GetPerksForSkill(Skill skill)  // Trash: Get every perk with the same skill and sort it
{
	local Perk skillPerkList[10];

	local int skillPerkListIndex;
	local int index;

	for (index = 0; index < ArrayCount(PerkList); index++)
	{
		if (PerkList[index].ReturnPerkSkill() == Skill)
		{
			skillPerkList[skillPerkListIndex] = PerkList[index];
			skillPerkListIndex++;
		}
	}

	return skillPerkList[index];
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     PerkList=0
}