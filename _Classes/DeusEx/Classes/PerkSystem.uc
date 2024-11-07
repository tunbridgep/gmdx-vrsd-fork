//=============================================================================
// PerkSystem.
//=============================================================================

// Trash: This is where perks are initialized and stored
// PERK SYSTEM #2: Add the perk that you created to InitializePerks()

class PerkSystem extends object;

var travel Perk PerkList[50];			// Trash: Hopefully with this system, you can make this 500 and it wouldn't matter much. You still need to manually set how many perks are created here though...
var travel int numPerks;				// Trash: UnrealScript doesn't support lists, so this is essentially the number of perks in the game
var travel DeusExPlayer PlayerAttached;	// Trash: The player this class is attached to


// ----------------------------------------------------------------------
// InitializePerks()
// ----------------------------------------------------------------------

function InitializePerks(DeusExPlayer newPlayer)	// Trash: Add every perk in the game to the PerkList[] array and assign the player
{
	PlayerAttached = newPlayer;

	// Trash: The system automatically sorts every perk so order doesn't matter
	// Trash: HOWEVER I'd still highly suggest placing perks under the appropriate comments

	// Rifle Perks
	AddPerk(Class'DeusEx.PerkSteady');
	AddPerk(Class'DeusEx.PerkStoppingPower');
	AddPerk(Class'DeusEx.PerkMarksman');

	// Pistol Perks
	AddPerk(Class'DeusEx.PerkSidearm');
	AddPerk(Class'DeusEx.PerkAmbidextrous');
	AddPerk(Class'DeusEx.PerkHollowPoints');
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
	AddPerk(Class'DeusEx.PerkFilterUpgrade');
	AddPerk(Class'DeusEx.PerkHardened');
	AddPerk(Class'DeusEx.PerkBlastPadding');
	AddPerk(Class'DeusEx.PerkThermalImaging');
	AddPerk(Class'DeusEx.PerkChameleon');

	// Athletics Perks
	AddPerk(Class'DeusEx.PerkPerserverance');
	AddPerk(Class'DeusEx.PerkSprinter');
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
	PerkList[numPerks].PerkOwner = PlayerAttached;
    numPerks++;
}

// ----------------------------------------------------------------------
// GetNumObtainedPerks()
// ----------------------------------------------------------------------

function int GetNumObtainedPerks()
{
	local int index, num;

	for (index = 0; index < numPerks; index++)
	{
        if (PerkList[index].bPerkObtained)
            num++;
	}
    return num;
}

// ----------------------------------------------------------------------
// ResetPerks()
// ----------------------------------------------------------------------

function ResetPerks()  // Trash: Reset every perk
{
	local int index;

	for (index = 0; index < numPerks; index++)
	{
		PerkList[index].bPerkObtained = false;
	}
}

// ----------------------------------------------------------------------
// GetPerkIndex()
// ----------------------------------------------------------------------

function int GetPerkIndex(Perk Perk)  // Trash: Get the index of the perk by checking the class
{
	local int index;

	for (index = 0; index < numPerks; index++)
	{
		if (PerkList[index].class == Perk.class)
		{
			return index;
		}
	}
}

// ----------------------------------------------------------------------
// GetPerkWithName()
// ----------------------------------------------------------------------

function Perk GetPerkWithName(String pName)  // Trash: Get the perk by checking the name
{
	local int index;

	for (index = 0; index < numPerks; index++)
	{
		if (PerkList[index].PerkName == pName)
		{
			return PerkList[index];
		}
	}
}

// ----------------------------------------------------------------------
// GetPerkWithClass()
// ----------------------------------------------------------------------

function Perk GetPerkWithClass(Class<Perk> pClass)  // Trash: Get the perk by checking the class
{
	local int index;

	for (index = 0; index < numPerks; index++)
	{
		if (PerkList[index].class == pClass)
		{
			return PerkList[index];
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    
}
