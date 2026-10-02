//=============================================================================
// WaterRingBlood.
//=============================================================================
class WaterRingBlood extends Effects;

simulated function Tick(float deltaTime)
{
	DrawScale += 0.4 * deltaTime;
	ScaleGlow -= deltaTime*0.1;
}

function PostBeginPlay()
{
	local Rotator rot;

	Super.PostBeginPlay();

	rot.Pitch = 16384;
	rot.Roll = 0;
	rot.Yaw = Rand(65535);
	SetRotation(rot);
}

defaultproperties
{
     LifeSpan=1.800000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'DeusExDeco.Skins.RedLightTex'
     Mesh=LodMesh'DeusExItems.FlatFX'
     DrawScale=0.100000
     bUnlit=False
     ScaleGlow=0.100000
}
