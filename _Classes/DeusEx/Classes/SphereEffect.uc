//=============================================================================
// SphereEffect.
//=============================================================================
class SphereEffect extends Effects;

var float size;
var ElectricityEmitter emit;
var ElectricityEmitter emit2;
var bool bEmitElec;

simulated function Tick(float deltaTime)
{
	DrawScale = 3.0 * size * (Default.LifeSpan - LifeSpan) / Default.LifeSpan;
	ScaleGlow = 2.0 * (LifeSpan / Default.LifeSpan);

    /*if (bEmitElec)
    {
    emit = Spawn(class'ElectricityEmitter');
    if (emit != none)
    {
    emit.randomAngle=36000.000000;
    emit.flickerTime=0.005000;
    emit.DamageAmount=0;
    emit.LifeSpan=0.2;
    }
    emit2 = Spawn(class'ElectricityEmitter');
    if (emit2 != none)
    {
    emit2.randomAngle=36000.000000;
    emit2.flickerTime=0.005000;
    emit2.DamageAmount=0;
    emit2.LifeSpan=0.2;
    }
    }*/
}

defaultproperties
{
     size=5.000000
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.SphereEffect'
     bUnlit=True
     LightType=LT_Strobe
     LightBrightness=224
     LightHue=148
     LightSaturation=64
     LightRadius=32
}
