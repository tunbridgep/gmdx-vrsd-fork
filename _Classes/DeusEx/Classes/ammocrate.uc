//=============================================================================
// AmmoCrate
//=============================================================================
class AmmoCrate extends Containers;

var localized String AmmoReceived;
var localized String AmmoReceivedSP;                                            //RSD: For use in Mission05
var localized String NoMoreAmmoSP;                                              //RSD: For use in Mission05
var bool bAmmoTakenSP;                                                          //RSD: For use in Mission05

// ----------------------------------------------------------------------
// Frob()
//
// If we are frobbed, trigger our event
// ----------------------------------------------------------------------
function Frob(Actor Frobber, Inventory frobWith)
{
	local Actor A;
	local Pawn P;
	local DeusExPlayer Player;
   local Inventory CurInventory;
   local ammo ammoTypePlayer;                                                   //RSD: Added

   //Don't call superclass frob.

   P = Pawn(Frobber);
	Player = DeusExPlayer(Frobber);

   if (Player != None && Player.Level.NetMode != NM_Standalone)                 //RSD: This code is now MP only
   {
      CurInventory = Player.Inventory;
      while (CurInventory != None)
      {
         if (CurInventory.IsA('DeusExWeapon'))
            RestockWeapon(Player,DeusExWeapon(CurInventory));
         CurInventory = CurInventory.Inventory;
      }
      Player.ClientMessage(AmmoReceived);
		PlaySound(sound'WeaponPickup', SLOT_None, 0.5+FRand()*0.25, , 256, 0.95+FRand()*0.1);
   }
   else if (Player != None && !bAmmoTakenSP)                                    //RSD: SP code for Mission05
   {
      CurInventory = self.Inventory;
      if (CurInventory == none)                                                 //RSD: If there's already nothing in it, say we're empty
      {
         Player.ClientMessage(NoMoreAmmoSP);
      }
      else
      {
      while (CurInventory != None)
      {
         if (CurInventory.IsA('Ammo'))
         {
            ammoTypePlayer = ammo(Player.FindInventoryType(Ammo(CurInventory).Class));
            //player.ClientMessage(Ammo(CurInventory).Class);
            //player.ClientMessage(Ammo(CurInventory).AmmoAmount);
            MoveAmmoFromCrateSP(Ammo(CurInventory), ammoTypePlayer);
         }
         CurInventory = CurInventory.Inventory;
      }
      Player.ClientMessage(AmmoReceivedSP);
      PlaySound(sound'WeaponPickup', SLOT_None, 0.5+FRand()*0.25, , 256, 0.95+FRand()*0.1);
      }
      bAmmoTakenSP = true;
   }
   else if (Player != None)                                                     //RSD: Only one use in SP
   {
      Player.ClientMessage(NoMoreAmmoSP);
   }
}

function RestockWeapon(DeusExPlayer Player, DeusExWeapon WeaponToStock)
{
   local Ammo AmmoType;

   if (WeaponToStock.AmmoType != None)
   {
      if (WeaponToStock.AmmoNames[0] == None)
         AmmoType = Ammo(Player.FindInventoryType(WeaponToStock.AmmoName));
      else
         AmmoType = Ammo(Player.FindInventoryType(WeaponToStock.AmmoNames[0]));

      if ((AmmoType != None) && (AmmoType.AmmoAmount < WeaponToStock.PickupAmmoCount))
      {
         AmmoType.AddAmmo(WeaponToStock.PickupAmmoCount - AmmoType.AmmoAmount);
      }
   }
}

function RestockWeaponSP(DeusExPlayer Player, DeusExWeapon WeaponToStock, DeusExWeapon WeaponStocked) //RSD: For SP use in Mission05, unused because we can just loop over the ammo types, duh
{
   local ammo ammoTypeCrate, ammotypePlayer;                                    //RSD
   local int i;

   if (WeaponStocked.AmmoType != None)
   {
      if (WeaponStocked.AmmoNames[0] == None)
      {
         AmmoTypeCrate = Ammo(FindInventoryType(WeaponStocked.AmmoName));
         AmmoTypePlayer = Ammo(Player.FindInventoryType(WeaponToStock.AmmoName));
         MoveAmmoFromCrateSP(AmmoTypeCrate, AmmoTypePlayer);
      }
      else
      {
         for (i = 0; i < 4; i++)                                                //RSD: Loop over ammo types (max 4), i.e. ammo part 7
         {
            if (WeaponStocked.AmmoNames[i] != none)
            {
               AmmoTypeCrate = Ammo(FindInventoryType(WeaponStocked.AmmoNames[i]));
               AmmoTypePlayer = Ammo(Player.FindInventoryType(WeaponToStock.AmmoNames[i]));
               MoveAmmoFromCrateSP(AmmoTypeCrate, AmmoTypePlayer);
            }
         }
      }
   }
}

function MoveAmmoFromCrateSP(ammo ammoTypeCrate, ammo ammoTypePlayer)           //RSD: For SP use in Mission05
{
   local DeusExAmmo DXammotype;

   if (ammoTypeCrate.Class == ammoTypePlayer.Class)
   {
      if (ammoTypePlayer.IsA('DeusExAmmo'))
      {
         DXammotype = DeusExAmmo(ammoTypePlayer);
         DXammotype.AddAmmo(ammoTypeCrate.AmmoAmount);                          //RSD: Need this to make sure my adjustedMaxAmmo() calls go through
         ammoTypeCrate.AmmoAmount = 0;
      }
      else
      {
         ammoTypePlayer.AddAmmo(ammoTypeCrate.AmmoAmount);
         ammoTypeCrate.AmmoAmount = 0;
      }
   }
}

function Inventory FindInventoryType( class DesiredClass )                      //RSD: Stolen from Pawn.uc
{
	local Inventory Inv;

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
		if ( Inv.class == DesiredClass )
			return Inv;
	return None;
}

function bool AddInventory( inventory NewItem )                                 //RSD: Copied from Pawn.uc, needed to get ammo copies from player
{
	// Skip if already in the inventory.
	local inventory Inv;

	// The item should not have been destroyed if we get here.
	if (NewItem ==None )
		log("tried to add none inventory to "$self);

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
		if( Inv == NewItem )
			return false;

	// DEUS_EX AJY
	// Update the previous owner's inventory chain
	if (NewItem.Owner != None)
		Pawn(NewItem.Owner).DeleteInventory(NewItem);

	// Add to front of inventory chain.
	NewItem.SetOwner(Self);
	NewItem.Inventory = Inventory;
	Inventory = NewItem;


	return true;
}

function inventory SpawnCopy( ammo AmmoToCopy )                                 //RSD: Copied code from Ammo.uc, needed to get ammo copies from player
{
	local Inventory Copy;

    Copy = spawn(AmmoToCopy.Class,self,,,rot(0,0,0));
    Copy.Tag           = AmmoToCopy.Tag;
	Copy.Event         = AmmoToCopy.Event;
	Copy.Instigator    = none;
	Ammo(Copy).AmmoAmount = AmmoToCopy.AmmoAmount;
	Copy.BecomeItem();
	self.AddInventory( Copy );
	Copy.GotoState('');

    return Copy;
}

defaultproperties
{
     AmmoReceived="Ammo restocked"
     AmmoReceivedSP="Ammo retrieved"
     NoMoreAmmoSP="The crate is empty"
     HitPoints=4000
     bFlammable=False
     ItemName="Ammo Crate"
     bPushable=False
     bBlockSight=True
     Mesh=LodMesh'DeusExItems.DXMPAmmobox'
     bAlwaysRelevant=True
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     Mass=3000.000000
     Buoyancy=40.000000
}
