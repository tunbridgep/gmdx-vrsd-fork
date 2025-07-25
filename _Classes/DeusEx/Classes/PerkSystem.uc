//=============================================================================
// PerkSystem.
//=============================================================================

// Trash: This is where perks are initialized and stored
// PERK SYSTEM #2: Add the perk that you created to InitializePerks()

class PerkSystem extends object;

var private Perk PerkList[100];			// Trash: Hopefully with this system, you can make this 500 and it wouldn't matter much. You still need to manually set how many perks are created here though...
var private int numPerks;				// Trash: UnrealScript doesn't support lists, so this is essentially the number of perks in the game
var private DeusExPlayer PlayerAttached;	// Trash: The player this class is attached to

var private travel String obtainedPerks[100]; //SARGE: Now we store the owned perks in this list, rather than in the perks themselves, so that we can regenerate the perk list on load.
var private travel int numObtained;

// ----------------------------------------------------------------------
// InitializePerks()
// ----------------------------------------------------------------------

function InitializePerks(DeusExPlayer newPlayer)	// Trash: Add every perk in the game to the PerkList[] array and assign the player
{
    local int i;

	PlayerAttached = newPlayer;

    for (i = 0;i < 100;i++)
        PerkList[i] = None;
    numPerks = 0;

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
	AddPerk(Class'DeusEx.PerkHemmorhage');
	AddPerk(Class'DeusEx.PerkInventive');

	// Heavy Perks
	AddPerk(Class'DeusEx.PerkControlledBurn');
	AddPerk(Class'DeusEx.PerkBlastEnergy');
	AddPerk(Class'DeusEx.PerkHeavilyTweaked');
	AddPerk(Class'DeusEx.PerkHERocket');
	AddPerk(Class'DeusEx.PerkMobileOrdnance');

	// Demolition Perks
	AddPerk(Class'DeusEx.PerkSonicTransducerSensor');
	AddPerk(Class'DeusEx.PerkShortFuse');
	AddPerk(Class'DeusEx.PerkSensorBurnout');
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
	AddPerk(Class'DeusEx.PerkToxicologist');
	AddPerk(Class'DeusEx.PerkBiogenic');
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
	AddPerk(Class'DeusEx.PerkDataRecovery');
	AddPerk(Class'DeusEx.PerkModder');
	AddPerk(Class'DeusEx.PerkMisfeatureExploit');
	AddPerk(Class'DeusEx.PerkTurretDomination');

    //General Perks
	AddPerk(Class'DeusEx.PerkFirefighter');
	AddPerk(Class'DeusEx.PerkLawfare');
	AddPerk(Class'DeusEx.PerkGlutton');
	AddPerk(Class'DeusEx.PerkSocketJockey');
    
    for (i = 0;i < numObtained;i++)
    {
        playerAttached.DebugMessage("Obtained Perks: " $ obtainedPerks[i]);
    }
    playerAttached.DebugMessage("numObtained: " $ numObtained);
    playerAttached.DebugMessage("numPerks: " $ numPerks);
}

function AddPerk(class<Perk> perk)
{
	local Perk perkInstance;
    local int i;

	perkInstance = new(self)Perk;

	PerkList[numPerks] = perkInstance;
	PerkList[numPerks].PerkOwner = PlayerAttached;

    //If it's in the obtained list, set it to obtained
    for (i = 0;i < numObtained;i++)
    {
        if (obtainedPerks[i] == string(Perk.Name))
        {
            perkInstance.bPerkObtained = true;
            perkInstance.OnMapLoad();
            perkInstance.OnMapLoadAndPurchase();
        }
    }

    numPerks++;
}

// ----------------------------------------------------------------------
// AddAll()
// ----------------------------------------------------------------------

function AddAll()
{
    local int i;
    for (i = 0;i < numPerks;i++)
        PurchasePerk(PerkList[i].Class,true);
}

// ----------------------------------------------------------------------
// PurchasePerk()
// ----------------------------------------------------------------------

function bool PurchasePerk(class<Perk> perk, optional bool free)  // Trash: Purchase the perk if possible
{
    local Perk perkInstance;
    local int i;
    local bool bFound;

    perkInstance = GetPerkWithClass(perk);

    if (perkInstance == None)
        return false;

    if (perkInstance.IsPurchasable() || free)
    {
        if (!free)
            PlayerAttached.SkillPointsAvail -= perkInstance.PerkCost;

        //Don't re-add it if we already have it
        for (i = 0;i < numObtained;i++)
            if (obtainedPerks[i] == string(perk.Name))
                bFound = true;

        PlayerAttached.PlaySound(Sound'GMDXSFX.Generic.codelearned',SLOT_None,,,,0.8);
		perkInstance.bPerkObtained = true;
        perkInstance.OnPerkPurchase();
        perkInstance.OnMapLoadAndPurchase();

        if (!bFound)
            obtainedPerks[numObtained++] = string(perk.Name);

        return true;
    }
    return false;
}

// ----------------------------------------------------------------------
// GetNumPerks()
// ----------------------------------------------------------------------

function int GetNumPerks()
{
    return numPerks;
}

// ----------------------------------------------------------------------
// GetNumObtainedPerks()
// ----------------------------------------------------------------------

function int GetNumObtainedPerks()
{
    return numObtained;
}

// ----------------------------------------------------------------------
// ResetPerks()
// ----------------------------------------------------------------------

function ResetPerks()  // Trash: Reset every perk
{
	local int index;

	for (index = 0; index < numObtained; index++)
	{
		obtainedPerks[index] = "";
	}
    numObtained = 0;
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
// GetPerkAtIndex()
// ----------------------------------------------------------------------

function Perk GetPerkAtIndex(int index)  // Trash: Get the perk at a certain index
{
    if (index < numPerks)
        return PerkList[index];
    else
        return None;
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
// GetPerkForSkill()
// ----------------------------------------------------------------------

function Perk GetPerkForSkill(Class<Skill> pSkill, int perkNum)  // SARGE: Get perk perkNum for skill
{
    local int i, count;
    for (i = 0; i < numPerks;i++)
    {
        if (PerkList[i].PerkSkill == pSkill)
        {
            count++;
            if (count > perkNum)
                return PerkList[i];
        }
    }
    return None;
}

// ----------------------------------------------------------------------
// GetGeneralPerk()
// ----------------------------------------------------------------------

function Perk GetGeneralPerk(int perkNum)  // SARGE: Get general perk perkNum (no associated skill)
{
    return GetPerkForSkill(None,perkNum);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    
}
