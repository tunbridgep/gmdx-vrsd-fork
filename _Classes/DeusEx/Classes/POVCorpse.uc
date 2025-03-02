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

//GMDX

var string savedName;                                                           //SARGE: vRSD seemingly forgot to add this?

//SARGE: Weapon Offset Stuff
//TODO: Replace this with a generic implementation
var const vector weaponOffsets;                                                 //Sarge: Our weapon offsets. Leave at (0,0,0) to disable using offsets
var travel vector oldOffsets;                                                   //Sarge: Stores our old default offsets
var travel bool bOldOffsetsSet;                                                 //Sarge: Stores whether or not old default offsets have been remembered
var travel bool bSearched;                                                      //Sarge: Carried over from Carcasses so they are retained when we make a new one by putting the corpse down
var travel int PickupAmmoCount;                                                 //Sarge: Carried over from Carcasses so they are retained when we make a new one by putting the corpse down

//END GMDX:

//Function to fix weapon offsets
function DoWeaponOffset(DeusExPlayer player)
{
    if ((weaponOffsets.x != 0.0 || weaponOffsets.y != 0.0 || weaponOffsets.z != 0.0))
    {
    
        //Remember our old weapon offsets
        if (!bOldOffsetsSet)
        {
            //player.ClientMessage("Setting old offsets");
            oldOffsets.x = default.PlayerViewOffset.x;
            oldOffsets.y = default.PlayerViewOffset.y;
            oldOffsets.z = default.PlayerViewOffset.z;
            bOldOffsetsSet = true;
        }

        if (player.bEnhancedWeaponOffsets)
        {
            default.PlayerViewOffset.x = weaponOffsets.x;
            default.PlayerViewOffset.y = weaponOffsets.y;
            default.PlayerViewOffset.z = weaponOffsets.z;
        }
        else if (bOldOffsetsSet)
        {
            default.PlayerViewOffset.x = oldOffsets.x;
            default.PlayerViewOffset.y = oldOffsets.y;
            default.PlayerViewOffset.z = oldOffsets.z;
        }
    }
}

//SARGE: Called when the item is added to the players hands
function Draw(DeusExPlayer frobber)
{
    DoWeaponOffset(frobber);
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
    DoWeaponOffset(DeusExPlayer(GetPlayerPawn()));
}

simulated event RenderOverlays( canvas Canvas )
{
    //This has to be done here for some stupid reason
    if (handsTex == None)
        SetWeaponHandTex();

    //SARGE: TODO: Allow setting POV skins
    //multiskins[0] = POVSkin;
    multiskins[1] = handstex;
    super.RenderOverlays(canvas);
    //multiskins[0] = none;
    multiskins[1] = none;
}

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
