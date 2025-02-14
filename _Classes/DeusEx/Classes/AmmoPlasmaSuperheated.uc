//=============================================================================
// AmmoPlasma.
//=============================================================================
class AmmoPlasmaSuperheated extends DeusExAmmo;

Function PostBeginPlay()
{
   Destroy();
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponHeavy'
     AmmoAmount=50
     MaxAmmo=400
     ItemName="Plasma (Gamma-Ionized) Clip"
     ItemArticle="a"
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoPlasma'
     largeIconWidth=22
     largeIconHeight=46
     Description="A clip of extruded, magnetically-doped, gamma-ionized plastic slugs that can be heated and delivered with devastating effect using the plasma gun."
     beltDescription="PMA G"
     HDTPMesh="HDTPItems.HDTPAmmoPlasma"
     Mesh=LodMesh'DeusExItems.AmmoPlasma'
     CollisionRadius=4.300000
     CollisionHeight=8.440000
     bCollideActors=True
}
