//=============================================================================
// ExplosionSmall.
//=============================================================================
class ExplosionSmall extends AnimatedSprite;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	spawn(class'Rockchip', None);
	spawn(class'Rockchip', None);
}

defaultproperties
{
     animSpeed=0.085000
     numFrames=5
     frames(0)=Texture'DeusExItems.Skins.FlatFXTex10'
     frames(1)=Texture'DeusExItems.Skins.FlatFXTex11'
     frames(2)=Texture'DeusExItems.Skins.FlatFXTex12'
     frames(3)=Texture'DeusExItems.Skins.FlatFXTex13'
     frames(4)=Texture'DeusExItems.Skins.FlatFXTex13'
     Texture=Texture'DeusExItems.Skins.FlatFXTex10'
     DrawScale=4.800000
}
