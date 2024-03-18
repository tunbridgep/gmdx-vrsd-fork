//=============================================================================
// Soldier.
//=============================================================================
class Soldier extends HumanMilitary;

function PostBeginPlay()
{
if (MultiSkins[6]==Texture'DeusExCharacters.Skins.SoldierTex3')
         bHasHelmet = True;

super.PostBeginPlay();
}

function PopHead()
{
MultiSkins[3] = Texture'GMDXSFX.Skins.ChefTexBeheaded';
MultiSkins[6] = Texture'DeusExItems.Skins.PinkMaskTex';
CarcassType = Class'DeusEx.SoldierCarcassBeheaded';
}

defaultproperties
{
     CarcassType=Class'DeusEx.SoldierCarcass'
     WalkingSpeed=0.296000
     walkAnimMult=0.780000
     bGrenadier=True
     disturbanceCount=1
     bCanPop=True
     GroundSpeed=200.000000
     Health=140
     HealthHead=140
     HealthTorso=140
     HealthLegLeft=140
     HealthLegRight=140
     HealthArmLeft=140
     HealthArmRight=140
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.SoldierTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.SoldierTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.SoldierTex1'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.SoldierTex0'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.SoldierTex3'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=49.000000
     BindName="Soldier"
     FamiliarName="Soldier"
     UnfamiliarName="Soldier"
}
