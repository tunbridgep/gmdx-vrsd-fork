//=============================================================================
// AmmoNapalm.
//=============================================================================
class AmmoNapalm extends DeusExAmmo;

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponHeavy'
     AmmoAmount=50
     MaxAmmo=150
     ItemName="Napalm Canister"
     ItemArticle="a"
     PickupViewMesh=LodMesh'HDTPItems.HDTPammoNapalm'
     LandSound=Sound'DeusExSounds.Generic.GlassDrop'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoNapalm'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoNapalm'
     largeIconWidth=46
     largeIconHeight=42
     Description="A pressurized canister of jellied gasoline for use with flamethrowers.|n|n<UNATCO OPS FILE NOTE SC080-BLUE> The canister is double-walled to minimize accidental detonation caused by stray bullets during a firefight. -- Sam Carter <END NOTE>"
     beltDescription="NAPALM"
     Mesh=LodMesh'HDTPItems.HDTPammoNapalm'
     CollisionRadius=3.130000
     CollisionHeight=11.480000
     bCollideActors=True
}
