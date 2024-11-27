//=============================================================================
// CrateUnbreakableSmall.
//=============================================================================
class CrateUnbreakableSmall extends Containers;

var() bool bBatterySlot;
var() bool bBattery;
var localized string StrIn;
var localized string StrOut;

function PostBeginPlay()
{
  super.PostBeginPlay();

  if (bBatterySlot)
      ItemName = StrOut;
  else if (bBattery)
  {
      ItemName = StrIn;
  }
}

function Tick(float deltaTime)
{
    if (bBattery) //CyberP/Totalitarian: meh horrid hack. For the batteries in Vandenberg Tunnels.
    {             //CyberP/Totalitarian: comment this out if you don't want them to float in shallow water (you do).
                  //CyberP/Totalitarian: Native code was causing fuckery.
        if (region.Zone.bWaterZone)
        {
            if (Physics != PHYS_Falling)
            {
               SetPhysics(PHYS_Falling);
               Velocity.Z+=2;
            }
        }
    }
    super.Tick(deltaTime);
}
/*function Landed(vector HitNormal)
{
 if (bBattery && Region.Zone.bWaterZone)
 {
     SetPhysics(PHYS_Falling);
     velocity.Z+=400;
     SetPhysics(PHYS_Falling);
 }
 else
 {
     super.Landed(HitNormal);
 }
}

singular function ZoneChange( ZoneInfo NewZone )
{
    Super.ZoneChange(NewZone);

    if (bBattery)
    {
    SetPhysics(PHYS_Falling);
    Velocity.Z *= 0.05;
    Velocity.Z+= 1000;
    }
}*/

function Frob(Actor Frobber, Inventory frobWith)
{
	local Actor A;
	local Pawn P;
	local DeusExPlayer Player;
    local GMDXImpactSpark AST;

	P = Pawn(Frobber);
	Player = DeusExPlayer(Frobber);

    if (!bBatterySlot)
	   Super.Frob(Frobber, frobWith);

	// Trigger event if we aren't hackable
	if (bBatterySlot && Player != None)
	{
	 if (ItemName != StrOut && ItemName != StrIn)
	      ItemName = StrOut;
	 if (ItemName == StrOut)
 	 {
 	    if (Player.carriedDecoration != None && Player.carriedDecoration.IsA('CrateUnbreakableSmall')
         && CrateUnbreakableSmall(Player.carriedDecoration).bBattery)
         {
		  if (Event != '')
			 foreach AllActors(class 'Actor', A, Event)
				A.Trigger(Self, P);
		   DrawScale=1;
           PlaySound(Sound'WeaponPickup',SLOT_None,,,,1.2);
           player.carriedDecoration.DrawScale = 0.001;
           player.carriedDecoration.Destroy();
           if (player.carriedDecoration != None)
              player.carriedDecoration = None;
           ItemName = StrIn;
		  }
	 }
     else if (ItemName == StrIn)
     {
         return;
     }
    }
}

defaultproperties
{
     StrIn="Battery"
     StrOut="Battery Slot"
     bFlammable=False
     ItemName="Metal Crate"
     bBlockSight=True
     HDTPMesh="HDTPDecos.HDTPcrateUnbreakableSmall"
     Mesh=LodMesh'DeusExDeco.CrateUnbreakableSmall'
     ScaleGlow=0.500000
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     Mass=50.000000
     Buoyancy=60.000000
     bSelectMeleeWeapon=False
     HDTPFailsafe=true; //Sometimes used as something weird/wacky, like big trees
}
