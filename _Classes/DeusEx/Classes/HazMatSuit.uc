//=============================================================================
// HazMatSuit.
//=============================================================================
class HazMatSuit extends ChargedPickup;

var localized string ItemProtect;

function string GetDescription2(DeusExPlayer player)
{
    local string str;

    //Add Defense
    //TODO: Calculate this properly
    str = AddLine(str,ItemProtect);
    
    str = AddLine(str, super.GetDescription2(player));
    
    return str;
}

//
// Reduces poison gas, tear gas, and radiation damage
//

defaultproperties
{
     ItemProtect="Environmental Protection: 60%"
     ChargeRemainingLabel="Durability: %d%%"
     ActivateSound=Sound'RSDCrap.Pickup.HazmatSuitEquip'
     DeactivateSound=Sound'RSDCrap.Pickup.HazmatSuitUnequip'
     skillNeeded=Class'DeusEx.SkillEnviro'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconHazMatSuit'
     ExpireMessage="HazMatSuit power supply used up"
     ItemName="Hazmat Suit"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.HazMatSuit'
     PickupViewMesh=LodMesh'DeusExItems.HazMatSuit'
     ThirdPersonMesh=LodMesh'DeusExItems.HazMatSuit'
     Charge=1000
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconHazMatSuit'
     largeIcon=Texture'DeusExUI.Icons.LargeIconHazMatSuit'
     largeIconWidth=46
     largeIconHeight=45
     Description="A standard hazardous materials suit that protects against a full range of environmental hazards including radiation, fire, biochemical toxins, electricity, and EMP. Hazmat suits contain an integrated bacterial oxygen scrubber that degrades over time and thus should not be reused."
     beltDescription="HAZMAT"
     Texture=Texture'DeusExItems.Skins.ReflectionMapTex1'
     Mesh=LodMesh'DeusExItems.HazMatSuit'
     CollisionRadius=17.000000
     CollisionHeight=11.520000
     Mass=20.000000
     Buoyancy=12.000000
}
