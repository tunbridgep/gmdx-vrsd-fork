//=============================================================================
// TerroristElite.
// SARGE: A special, much harder variant of the Terrorist with fiercer body armor.
// Only appears in New Game Plus
//=============================================================================
class TerroristElite extends Terrorist;

defaultproperties
{
     MinHealth=0.000000
     CarcassType=Class'DeusEx.TerroristEliteCarcass'
     WalkingSpeed=0.296000
     walkAnimMult=0.780000
     runAnimMult=1.100000
     bGrenadier=True
     //bHasCloak=True
     //bCanPop=True
     GroundSpeed=210.000000
     Health=250
     HealthHead=200
     HealthTorso=250
     HealthLegLeft=100
     HealthLegRight=100
     HealthArmLeft=100
     HealthArmRight=100
     HearingThreshold=0.150000
     VisibilityThreshold=0.015000
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'RSDCrap.Fixed_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.TerroristTex2'
     MultiSkins(2)=Texture'RSDCrap.Skins.TerroristArmoredTex1'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'RSDCrap.Skins.hTerroristTex3'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="Terrorist"
     FamiliarName="NSF Veteran"
     UnfamiliarName="NSF Veteran"
     fireReactTime=0.45
     BaseAccuracy=0.220000
     maxRange=8000.000000
     bSmartWeaponDraw=true
     fHighAlertChance=0.5
}
