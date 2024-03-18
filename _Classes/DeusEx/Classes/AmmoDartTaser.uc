//=============================================================================
// AmmoDartPoison.
//=============================================================================
class AmmoDartTaser extends AmmoDart;

function PostBeginPlay()
{
local DeusExPlayer player;

        super.PostBeginPlay();

        player=DeusExPlayer(GetPlayerPawn());

   if ((player != none) && (player.bHardCoreMode == True))
   	{
   	    if (Owner == None)
    	    AmmoAmount = 1;  //CyberP: less ammo on hardcore
   	}
}

defaultproperties
{
     altDamage=15
     ItemName="Taser Darts"
     Icon=Texture'GMDXSFX.Icons.BeltIconTaserDart'
     largeIcon=Texture'GMDXSFX.Icons.LargeIconTaserDart'
     Description="A dart that once has penetrated the skin delivers a high-voltage electrical current via an internal electrode, causing involuntary muscle spasms and effectively incapacitating the target in a non-lethal manner."
     beltDescription="TASER"
     Skin=Texture'GMDXSFX.Skins.TaserAmmo'
}
