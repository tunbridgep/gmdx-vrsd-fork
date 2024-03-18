//=============================================================================
// Terrorist.
//=============================================================================
class Terrorist extends HumanMilitary;

function PopHead()
{
MultiSkins[3] = Texture'GMDXSFX.Skins.TerroristTexBeheaded';
MultiSkins[4] = none;
MultiSkins[6] = none;
CarcassType = Class'DeusEx.TerroristCarcassBeheaded';
}

defaultproperties
{
     MinHealth=10.000000
     CarcassType=Class'DeusEx.TerroristCarcass'
     WalkingSpeed=0.296000
     AvoidAccuracy=0.100000
     CrouchRate=0.150000
     SprintRate=0.500000
     walkAnimMult=0.780000
     runAnimMult=1.100000
     HDTPMeshName="HDTPCharacters.HDTPTerrorist"
     HDTPMeshTex(0)="HDTPCharacters.Skins.HDTPTerroristTex0"
     HDTPMeshTex(1)="HDTPCharacters.Skins.HDTPTerroristTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPTerroristTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPTerroristTex3"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPTerroristTex4"
     HDTPMeshTex(5)="HDTPCharacters.Skins.HDTPTerroristTex5"
     HDTPMeshTex(6)="DeusExItems.Skins.PinkMaskTex"
     HDTPMeshTex(7)="DeusExItems.Skins.PinkMaskTex"
     bGrenadier=True
     bCanPop=True
     GroundSpeed=210.000000
     Health=85
     HealthHead=85
     HealthTorso=90
     HealthLegLeft=90
     HealthLegRight=90
     HealthArmLeft=90
     HealthArmRight=90
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.TerroristTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.TerroristTex1'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.GogglesTex1'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="Terrorist"
     FamiliarName="Terrorist"
     UnfamiliarName="Terrorist"
}
