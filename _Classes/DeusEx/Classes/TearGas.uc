//=============================================================================
// TearGas.
//=============================================================================
class TearGas extends Cloud;

function PostBeginPlay()
{
PlaySound(sound'PepperGunFire', SLOT_None,,,96);
super.PostBeginPlay();
}

defaultproperties
{
     DamageType=TearGas
     maxDrawScale=1.000000
     speed=160.000000
     LifeSpan=1.200000
     Texture=WetTexture'Effects.Smoke.Gas_Tear_A'
     DrawScale=0.300000
     ScaleGlow=0.500000
     CollisionRadius=16.000000
     CollisionHeight=16.000000
}
