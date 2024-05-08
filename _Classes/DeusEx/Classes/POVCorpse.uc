//=============================================================================
// POVCorpse.
//=============================================================================
class POVCorpse extends DeusExPickup;

var travel String carcClassString;
var travel String KillerBindName;
var travel Name   CarcassTag; //cyberp
var travel Name   KillerAlliance;
var travel Name   Alliance;
var travel bool   bNotDead;
var travel bool   bEmitCarcass;
var travel int    CumulativeDamage;
var travel int    MaxDamage;
var travel string CorpseItemName;
var travel Name   CarcassName;
var travel Inventory Inv;
var Texture pMultitex[8];
var bool    bHasSkins;

defaultproperties
{
     weaponOffsets=(X=15.00,Y=15.00,Z=-5.00)
     MaxDamage=10
     bDisplayableInv=False
     ItemName="body"
     PlayerViewOffset=(X=20.000000,Y=13.000000,Z=-5.000000)
     PlayerViewMesh=LodMesh'DeusExItems.POVCorpse'
     PickupViewMesh=LodMesh'DeusExItems.TestBox'
     LandSound=Sound'DeusExSounds.Generic.FleshHit1'
     Mesh=LodMesh'DeusExItems.TestBox'
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     Mass=40.000000
     Buoyancy=30.000000
}
