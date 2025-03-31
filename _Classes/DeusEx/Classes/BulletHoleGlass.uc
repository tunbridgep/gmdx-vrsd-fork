//=============================================================================
// BulletHoleGlass.
//=============================================================================
class BulletHoleGlass extends DeusExDecal;

var int crackTex;

function BeginPlay()
{
        
    if (FRand() < 0.5)
        crackTex = 0;
    else
        crackTex = 1;

    super.BeginPlay();
}

// overridden to NOT rotate decal
//HDTP DDL- OVERRULED!
function DoHDTP()
{
    super.DoHDTP();

    if (!IsHDTP())
    {
        if (crackTex == 0)
            Texture = Texture'FlatFXTex29';
        else
            Texture = Texture'FlatFXTex30';
    }

	drawscale *= 1.0 + frand()*0.2;

    if (class'DeusExPlayer'.default.bJohnWooSparks)
        drawScale *= 1.5;
}

defaultproperties
{
     HDTPTexture="HDTPItems.Skins.HDTPFlatFXtex29"
	 Texture=Texture'DeusExItems.Skins.FlatFXtex29'
     DrawScale=0.100000
     HDTPDrawScale=0.00625
}

