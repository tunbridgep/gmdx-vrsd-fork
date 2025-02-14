//=============================================================================
// RatCarcass.
//=============================================================================
class RatCarcass extends DeusExCarcass;

var mesh CarcassMesh[6];

// ----------------------------------------------------------------------
// InitFor()
// ----------------------------------------------------------------------

function InitFor(Actor Other)
{
	local int i;

	super.InitFor(Other);

    if (IsHDTP())
        Mesh = carcassmesh[rand(6)]; //fuck you, let's have a ton of very similar but slightly different carcasses
	SetScaleGlow();
}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{
	local int i, j, r;
	local Inventory inv;

	bCollideWorld = true;

	// Use the carcass name by default
	CarcassName = Name;

	// Add initial inventory items
	for (i=0; i<8; i++)
	{
		if ((InitialInventory[i].inventory != None) && (InitialInventory[i].count > 0))
		{
			for (j=0; j<InitialInventory[i].count; j++)
			{
				inv = spawn(InitialInventory[i].inventory, self);
				if (inv != None)
				{
					inv.bHidden = True;
					inv.SetPhysics(PHYS_None);
					AddInventory(inv);
				}
			}
		}
	}

	// use the correct mesh
	if (Region.Zone.bWaterZone)
	{
		bNotDead = False;		// you will die in water every time
	}

	if (bAnimalCarcass)
		itemName = msgAnimalCarcass;

	MaxDamage = 0.8*Mass;
	SetScaleGlow();

	SetTimer(30.0, False);

	Super.PostBeginPlay();

    //fuck you, let's have a ton of very similar but slightly different carcasses
    if (IsHDTP())
    {
        CarcassMesh[0]=class'HDTPLoader'.static.GetMesh("HDTPCharacters.HDTPRatCarcass");
        CarcassMesh[1]=class'HDTPLoader'.static.GetMesh("HDTPCharacters.HDTPRatCarcass2");
        CarcassMesh[2]=class'HDTPLoader'.static.GetMesh("HDTPCharacters.HDTPRatCarcass3");
        CarcassMesh[3]=class'HDTPLoader'.static.GetMesh("HDTPCharacters.HDTPRatCarcass4");
        CarcassMesh[4]=class'HDTPLoader'.static.GetMesh("HDTPCharacters.HDTPRatCarcass5");
        CarcassMesh[5]=class'HDTPLoader'.static.GetMesh("HDTPCharacters.HDTPRatCarcass6");
        Mesh = carcassmesh[rand(6)];
    }
}

// ----------------------------------------------------------------------
// ZoneChange()
// ----------------------------------------------------------------------

function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	// use the correct mesh for water
	if (NewZone.bWaterZone)
		Mesh = carcassmesh[rand(6)];
	SetScaleGlow();
}

defaultproperties
{
     hdtpReference=class'DeusEx.Rat'
     Mesh=LodMesh'DeusExCharacters.RatCarcass'
     Mesh2=LodMesh'DeusExCharacters.RatCarcass'
     Mesh3=LodMesh'DeusExCharacters.RatCarcass'
     HDTPMesh="HDTPCharacters.HDTPRatCarcass"
     HDTPMesh2="HDTPCharacters.HDTPRatCarcass"
     HDTPMesh3="HDTPCharacters.HDTPRatCarcass"
     bAnimalCarcass=True
     CollisionRadius=10.000000
     CollisionHeight=3.400000
     Mass=20.000000
}
