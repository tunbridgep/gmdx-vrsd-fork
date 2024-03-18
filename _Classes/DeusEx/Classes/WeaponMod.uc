//=============================================================================
// WeaponMod //CyberP: contains CorinthMaxwell's code for stackable weapon mods.
//=============================================================================
class WeaponMod extends DeusExPickup
   abstract;

var() Float WeaponModifier;
var localized String DragToUpgrade;
var () bool bNoRandomSwap;

// ----------------------------------------------------------------------
// Network Replication
// ----------------------------------------------------------------------
replication
{
   // client to server function call
   reliable if (Role < ROLE_Authority)
      ApplyMod, DestroyMod;
}


function PostBeginPlay()
{
   Super.PostBeginPlay();

   LoopAnim('Cycle');
}

// ----------------------------------------------------------------------
// ApplyMod()
//
// Applies the modification to the weapon.  Unique for each different
// type of weapon mod class
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
}

// ----------------------------------------------------------------------
// DestroyMod()
//
// Subtract a use, then destroy if out of uses
// ----------------------------------------------------------------------

function DestroyMod()
{
   local DeusExPlayer player;

   player = DeusExPlayer(Owner);
   NumCopies--;

   if (IsA('WeaponModLaser'))               //CyberP: weapon mod installation sounds
   player.PlaySound(sound'PlasmaRifleReload',SLOT_None,,,,1.2);
   else if (IsA('WeaponModScope'))
   player.PlaySound(sound'WeaponPickup',SLOT_None);
   else if (IsA('WeaponModSilencer'))
   player.PlaySound(sound'Switch3ClickOff',SLOT_None,,,,0.9);
   else if (IsA('WeaponModDamage'))
   player.PlaySound(sound'weaponmodinstall',SLOT_None,0.8);
   else if (IsA('WeaponModAuto'))
   player.PlaySound(Sound'GMDXSFX.Generic.robotmove2',SLOT_None,,,,0.9);
   else
   player.PlaySound(Sound'M4ClipOut',SLOT_None,,,,0.8);

   if (NumCopies <= 0)
   {
      if (player.inHand == Self)
         player.PutInHand(None);
      Destroy();
   }
   else
   {
      UpdateBeltText();
   }
}

// ----------------------------------------------------------------------
// UpdateInfo()
//
// Describes the capabilities of this weapon mod,
// for instance, "Increases base accuracy by 20%"
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
   local PersonaInfoWindow winInfo;

   winInfo = PersonaInfoWindow(winObject);
   if (winInfo == None)
      return False;

   winInfo.Clear();
   winInfo.SetTitle(itemName);
   winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

   winInfo.AppendText(DragToUpgrade);

   return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     DragToUpgrade="Drag over weapon to upgrade.  Weapons highlighted in GREEN can be upgraded with this mod."
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.WeaponMod'
     PickupViewMesh=LodMesh'DeusExItems.WeaponMod'
     ThirdPersonMesh=LodMesh'DeusExItems.WeaponMod'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
     largeIconWidth=34
     largeIconHeight=49
     Mesh=LodMesh'DeusExItems.WeaponMod'
     CollisionRadius=3.500000
     CollisionHeight=4.420000
     Mass=8.000000
}
