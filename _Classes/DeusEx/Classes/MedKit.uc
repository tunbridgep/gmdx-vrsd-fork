//=============================================================================
// MedKit.
//=============================================================================
class MedKit extends DeusExPickup;

//
// Healing order is head, torso, legs, then arms (critical -> less critical)
//
var int healAmount;
var bool bNoPrintMustBeUsed;

var localized string MustBeUsedOn;
var localized String HealsLabel;                                                //RSD: Added

//SARGE: Moved the Bioenergy perk-based max amount bonus here, was in DeusExPlayer
function bool DoRightFrob(DeusExPlayer frobber, bool objectInHand)
{
    if (frobber.PerkNamesArray[30]==1)
        MaxCopies = 20;
    return super.DoRightFrob(frobber,objectInHand);
}

// ----------------------------------------------------------------------
state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;
      local int MedSkillLevel;

		Super.BeginState();

		//player = DeusExPlayer(Owner);
		player = DeusExPlayer(GetPlayerPawn());                                 //RSD: Altering this to enable generic LeftClick interact
		if (player != None)
		{
			player.HealPlayer(healAmount, True);
			if (player.SkillSystem!=None)
			   MedSkillLevel=player.SkillSystem.GetSkillLevel(class'SkillMedicine');

			// Medkits kill all status effects when used in multiplayer removed (player.Level.NetMode != NM_Standalone )||
			if (player.PerkNamesArray[19]==1)
			{
				player.StopPoison();
				player.myPoisoner = None;
	            player.poisonCounter = 0;
                player.poisonTimer   = 0;
            	player.poisonDamage  = 0;
				player.drugEffectTimer = 0;	// stop the drunk effect
			}
		}

		UseOnce();
	}
Begin:
}


// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local DeusExPlayer player;
	local String outText;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	player = DeusExPlayer(Owner);

	if (player != none && player.PerkNamesArray[30]==1)
		MaxCopies = 25;

	if (player != None)
	{
		winInfo.SetTitle(itemName);
		if (player.PerkNamesArray[30] == 1)
			winInfo.AddSecondaryButton(self);                                   //RSD: Can now equip medkits as secondaries with the Combat Medic's Bag perk
		winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());
        winInfo.AppendText(Sprintf(healsLabel,player.CalculateSkillHealAmount(30)) $ winInfo.CR()); //RSD Display heal amount
		if (!bNoPrintMustBeUsed)
		{
			winInfo.AppendText(winInfo.CR() $ MustBeUsedOn $ winInfo.CR());
		}
		else
		{
			bNoPrintMustBeUsed = False;
		}

		// Print the number of copies
		outText = CountLabel @ String(NumCopies);

		winInfo.AppendText(winInfo.CR() $ outText);
	}

	return True;
}

// ----------------------------------------------------------------------
// NoPrintMustBeUsed()
// ----------------------------------------------------------------------

function NoPrintMustBeUsed()
{
	bNoPrintMustBeUsed = True;
}

// ----------------------------------------------------------------------
// GetHealAmount()
//
// Arms and legs get healing bonuses
// ----------------------------------------------------------------------

function float GetHealAmount(int bodyPart, optional float pointsToHeal)
{
	local float amt;

	if (pointsToHeal == 0)
		pointsToHeal = healAmount;

	// CNN - just make all body parts equal to avoid confusion
	return pointsToHeal;
/*
	switch (bodyPart)
	{
		case 0:		// head
			amt = pointsToHeal * 2; break;
			break;

		case 1:		// torso
			amt = pointstoHeal;
			break;

		case 2:		// right arm
			amt = pointsToHeal * 1.5; break;

		case 3:		// left arm
			amt = pointsToHeal * 1.5; break;

		case 4:		// right leg
			amt = pointsToHeal * 1.5; break;

		case 5:		// left leg
			amt = pointsToHeal * 1.5; break;

		default:
			amt = pointstoHeal;
	}

	return amt;*/
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return (BeltSpot == 9);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bAutoActivate=True
     healAmount=30
     MustBeUsedOn="Use to heal critical body parts, or use on character screen to direct healing at a certain body part."
     HealsLabel="Heals %d points"
     maxCopies=15
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Medkit"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.MedKit'
     PickupViewMesh=LodMesh'DeusExItems.MedKit'
     ThirdPersonMesh=LodMesh'DeusExItems.MedKit3rd'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconMedKit'
     largeIcon=Texture'DeusExUI.Icons.LargeIconMedKit'
     largeIconWidth=39
     largeIconHeight=46
     Description="A first-aid kit.|n|n<UNATCO OPS FILE NOTE JR095-VIOLET> The nanomachines of an augmented agent will automatically metabolize the contents of a medkit to efficiently heal damaged areas. An agent with medical training could greatly expedite this process. -- Jaime Reyes <END NOTE>"
     beltDescription="MEDKIT"
     Skin=Texture'HDTPItems.Skins.HDTPMedKitTex1'
     Mesh=LodMesh'DeusExItems.MedKit'
     CollisionRadius=7.500000
     CollisionHeight=1.000000
     Mass=10.000000
     Buoyancy=8.000000
}
