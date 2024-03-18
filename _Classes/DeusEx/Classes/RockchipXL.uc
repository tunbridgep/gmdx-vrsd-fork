//=============================================================================
// RockchipXL.
//=============================================================================
class RockchipXL expands DeusExDecoration;

auto state Flying
{
	simulated function BeginState()
	{
		Super.BeginState();
        Velocity = VRand() * 800;

        if (FRand() < 0.2)
		{
        Mesh=LodMesh'DeusExItems.Rockchip2';
		DrawScale = (DrawScale * 0.3) + FRand();
		}
        else if (FRand() < 0.5)
		{
        DrawScale = (DrawScale * 0.3) + FRand() * 1.5;
		Mesh=LodMesh'DeusExItems.Rockchip3';
        }
		else
		{
		DrawScale = (DrawScale * 0.3) + FRand() * 1.8;
		}
        if (DrawScale > 0.5)
            SetCollisionSize(Default.CollisionRadius + DrawScale, Default.CollisionHeight + DrawScale);
		//Skin=Texture'HDTPDecos.Skins.HDTPWaterFountaintex1';
	}
}

defaultproperties
{
     HitPoints=200
     minDamageThreshold=2
     FragType=Class'DeusEx.Rockchip'
     bCanBeBase=True
     ItemName="Rock"
     Skin=Texture'GMDXSFX.Skins.RockChipTex'
     Mesh=LodMesh'DeusExItems.Rockchip1'
     CollisionRadius=3.500000
     CollisionHeight=1.000000
     Mass=15.000000
     Buoyancy=3.000000
}
