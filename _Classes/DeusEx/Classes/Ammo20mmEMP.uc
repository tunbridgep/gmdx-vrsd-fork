//=============================================================================
// Ammo20mm.
//=============================================================================
class Ammo20mmEMP extends DeusExAmmo;

//Less ammo on Hardcore
function SetupDifficultyMod(DeusExPlayer P)
{
    super.SetupDifficultyMod(P);
    if (P.bHardCoreMode)
        AmmoAmount = 1;
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponRifle'
     AmmoAmount=2
     MaxAmmo=32
     ItemName="20mm EMP Ammo"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.Ammo20mm'
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconEMPGrenade'
     largeIcon=Texture'DeusExUI.Icons.LargeIconEMPGrenade'
     largeIconWidth=47
     largeIconHeight=37
     Description="20mm EMP Grenade that explodes upon contact. It's moderately weak due to a combination of it's size and method of detonation."
     beltDescription="20MM EMP"
     //TODO: Add non-HDTP EMP Grenade skin
     HDTPSkin="HDTPItems.Skins.HDTPEMPGrenadeTex1"
     Mesh=LodMesh'DeusExItems.Ammo20mm'
     CollisionRadius=9.500000
     CollisionHeight=4.750000
     bCollideActors=True
     ammoHUDColor=(G=80,B=255)
}
