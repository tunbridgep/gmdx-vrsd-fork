//=============================================================================
// PlasmaBoltBreeder.
//=============================================================================
class PlasmaBoltBreeder extends PlasmaBolt;

function PostBeginPlay()
{
	Super.PostBeginPlay();
    DrawScale = 0.5;
    ScaleGlow = 0.5;
    Style=STY_Translucent;
}

defaultproperties
{
    mpDamage=10.000000
    Damage=10.000000
}
