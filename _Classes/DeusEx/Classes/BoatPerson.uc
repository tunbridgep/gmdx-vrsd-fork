//=============================================================================
// BoatPerson.
//=============================================================================
class BoatPerson extends HumanCivilian;

function PopHead()
{
MultiSkins[0]=Texture'GMDXSFX.Skins.BoatPersonTexBeheaded';
CarcassType = Class'DeusEx.BoatPersonCarcassBeheaded';
}

defaultproperties
{
     CarcassType=Class'DeusEx.BoatPersonCarcass'
     WalkingSpeed=0.296000
     walkAnimMult=0.750000
     runAnimMult=0.800000
     bCanPop=True
     GroundSpeed=200.000000
     Mesh=LodMesh'DeusExCharacters.GM_DressShirt_S'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.BoatPersonTex0'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.PantsTex3'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.BoatPersonTex0'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.BoatPersonTex1'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="BoatPerson"
     FamiliarName="Boat Person"
     UnfamiliarName="Boat Person"
}
