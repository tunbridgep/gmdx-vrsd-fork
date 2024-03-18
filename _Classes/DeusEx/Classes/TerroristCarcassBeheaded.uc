//=============================================================================
// TerroristCarcass.
//=============================================================================
class TerroristCarcassBeheaded extends DeusExCarcass;

/*function PostPostBeginPlay()
{
local FleshFragmentNub nub;
local vector vec;
local rotator randRot;
//vec = Location;
//vec.X += 15;
//vec.Y += 30;
//Super.InitFor(self);
//vec.Z -=38;
if (Mesh != Mesh2)
{
vec = vect(0,0,0);
vec.X += CollisionRadius * 1.77;
vec.Z -= 40.5;
vec.Y += 3.5;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
//randRot.Yaw=0;
//randRot.Pitch=32768;
//SetRotation(randRot);
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
else
{
vec = vect(0,0,0);
vec.X -= CollisionRadius * 1.9;
vec.Z -= 43;
vec.Y -= 0.25;
vec = vec >> Rotation;
vec += Location;
randRot=Rotation;
//randRot.Yaw=0;
//randRot.Pitch=32768;
//SetRotation(randRot);
	nub = Spawn(class'FleshFragmentNub', Self,, vec, randRot);
	if (nub != None)
	{
	nub.ScaleGlow=0.9;
    }
}
 super.PostPostBeginPlay();
} */

defaultproperties
{
     Mesh2=LodMesh'DeusExCharacters.GM_Jumpsuit_CarcassB'
     Mesh3=LodMesh'DeusExCharacters.GM_Jumpsuit_CarcassC'
     HDTPMeshName="HDTPCharacters.HDTPTerroristCarcass"
     HDTPMesh2Name="HDTPCharacters.HDTPTerroristCarcassB"
     HDTPMesh3Name="HDTPCharacters.HDTPTerroristCarcassC"
     HDTPMeshTex(0)="HDTPCharacters.Skins.HDTPTerroristTex0"
     HDTPMeshTex(1)="HDTPCharacters.Skins.HDTPTerroristTex1"
     HDTPMeshTex(2)="HDTPCharacters.Skins.HDTPTerroristTex2"
     HDTPMeshTex(3)="HDTPCharacters.Skins.HDTPTerroristTex3"
     HDTPMeshTex(4)="HDTPCharacters.Skins.HDTPTerroristTex4"
     HDTPMeshTex(5)="HDTPCharacters.Skins.HDTPTerroristTex5"
     HDTPMeshTex(6)="DeusExItems.Skins.PinkMaskTex"
     HDTPMeshTex(7)="DeusExItems.Skins.PinkMaskTex"
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit_Carcass'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.TerroristTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.TerroristTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.TerroristTex1'
     MultiSkins(3)=Texture'GMDXSFX.Skins.TerroristTexBeheaded'
     MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
}
