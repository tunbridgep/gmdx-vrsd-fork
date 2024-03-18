//=============================================================================
// ShockRing.
//=============================================================================
class ShockRingProjectile extends DeusExProjectile;

simulated function Tick(float deltaTime)
{
	DrawScale += 1.6;
	SetCollisionSize( DrawScale*32, 4 );
}

defaultproperties
{
     blastRadius=4.000000
     DamageType=Radiation
     AccurateRange=3000
     maxRange=3000
     bIgnoresNanoDefense=True
     speed=1.000000
     Damage=8.000000
     LifeSpan=0.550000
     Style=STY_Translucent
     Skin=Texture'HDTPDecos.Skins.HDTPWaterFountaintex2'
     Mesh=LodMesh'DeusExItems.FlatFX'
     bUnlit=True
     bCollideWorld=False
     LightType=LT_Steady
     LightBrightness=224
     LightHue=160
     LightSaturation=96
     LightRadius=32
}
