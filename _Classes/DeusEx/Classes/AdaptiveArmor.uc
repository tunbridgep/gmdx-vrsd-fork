//=============================================================================
// AdaptiveArmor.
//=============================================================================
class AdaptiveArmor extends ChargedPickup;

//
// Behaves just like the cloak augmentation
//
//     Charge=500

//SARGE: Change skin based on it's charge level
simulated function Tick(float deltaTime)
{
    super.Tick(deltaTime);
    if (!bActive)
    {
        if (Charge == 0)
            Multiskins[1] = Texture'BlackMaskTex';
        else
            Multiskins[1] = default.Multiskins[1];
    }
}

defaultproperties
{
     skillNeeded=Class'DeusEx.SkillEnviro'
     LoopSound=Sound'DeusExSounds.Pickup.SuitLoop'
     //ChargedIcon=Texture'DeusExUI.Icons.ChargedIconArmorAdaptive'
     ChargedIcon=Texture'RSDCrap.Icons.ChargedIconArmorAdaptive' //SARGE: Changed to new icon since the charged icon seems outdated/weird
     chargeMult=0.100000
     ItemName="Thermoptic Camo"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.AdaptiveArmor'
     PickupViewMesh=LodMesh'DeusExItems.AdaptiveArmor'
     ThirdPersonMesh=LodMesh'DeusExItems.AdaptiveArmor'
     Charge=250
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconArmorAdaptive'
     largeIcon=Texture'DeusExUI.Icons.LargeIconArmorAdaptive'
     largeIconWidth=35
     largeIconHeight=49
     Description="Integrating woven fiber-optics and an advanced computing system, thermoptic camo can render an agent invisible to both humans and bots by dynamically refracting light and radar waves; however, the high power drain makes it impractial for more than short-term use, after which the circuitry is fused and it becomes useless."
     beltDescription="THRM CAMO"
     Mesh=LodMesh'DeusExItems.AdaptiveArmor'
     CollisionRadius=11.500000
     CollisionHeight=13.810000
     Mass=30.000000
     Buoyancy=20.000000
}
