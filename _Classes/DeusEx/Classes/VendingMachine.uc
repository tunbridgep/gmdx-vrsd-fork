//=============================================================================
// VendingMachine.
//=============================================================================
class VendingMachine extends ElectronicDevices;

#exec OBJ LOAD FILE=Ambient

enum ESkinColor
{
	SC_Drink,
	SC_Snack
};

var() ESkinColor SkinColor;

var localized String msgDispensed;
var localized String msgNoCredits;
var int numUses;
var localized String msgEmpty;
var() bool bFrobbable;

function UpdateHDTPSettings()
{
    local Texture tex, tex2;
	Super.UpdateHDTPSettings();
	switch (SkinColor)
	{
		case SC_Drink:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPvendingDrinktex1","DeusExDeco.VendingMachineTex1",IsHDTP());
                        tex2 = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPvendingDrinktex2"); 
                        break;
		case SC_Snack:	tex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.HDTPvendingSnacktex1","DeusExDeco.VendingMachineTex2",IsHDTP());
                        tex2 = class'HDTPLoader'.static.GetTexture("HDTPDecos.HDTPvendingSnacktex2"); 
                        break;
	}

    if (IsHDTP())
    {
        MultiSkins[1] = tex;
        MultiSkins[2] = tex2;
    }
    else
    {
        Skin = tex;
    }
}

function Frob(actor Frobber, Inventory frobWith)
{
	local DeusExPlayer player;
	local Vector loc;
	local Pickup product;

    if (!bFrobbable)
		return;

	Super.Frob(Frobber, frobWith);

	player = DeusExPlayer(Frobber);

	if (player != None)
	{
		if (numUses <= 0)
		{
			player.ClientMessage(msgEmpty);
			return;
		}

		if (player.Credits >= 2)
		{
			PlaySound(sound'VendingCoin', SLOT_None);
			loc = Vector(Rotation) * CollisionRadius * 0.8;
			loc.Z -= CollisionHeight * 0.7;
			loc += Location;

			if (SkinColor == SC_Drink)
            {
				product = Spawn(class'Sodacan', None,, loc);
                //SARGE: Randomise flavour of sodacan
                SodaCan(product).textureSet = rand(3);
                SodaCan(product).SetSkin();
            }
			else
				product = Spawn(class'Candybar', None,, loc);

			if (product != None)
			{
				if (product.IsA('Sodacan'))
					PlaySound(sound'VendingCan', SLOT_None);
				else
					PlaySound(sound'VendingSmokes', SLOT_None);

				product.Velocity = Vector(Rotation) * 100;
				product.bFixedRotationDir = True;
				product.RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
				product.RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
			}

			player.Credits -= 2;
			player.ClientMessage(msgDispensed);
			numUses--;
		}
		else
			player.ClientMessage(msgNoCredits);
	}
}

defaultproperties
{
     msgDispensed="2 credits deducted from your account"
     msgNoCredits="Costs 2 credits..."
     numUses=10
     msgEmpty="It's empty"
     bFrobbable=True
     bCanBeBase=True
     ItemName="Vending Machine"
     HDTPMesh="HDTPDecos.HDTPVendingMachine"
     Mesh=LodMesh'DeusExDeco.VendingMachine'
     SoundRadius=8
     SoundVolume=96
     AmbientSound=Sound'Ambient.Ambient.HumLow3'
     CollisionRadius=34.000000
     CollisionHeight=50.000000
     Mass=150.000000
     Buoyancy=100.000000
	 bHDTPFailsafe=False
}
