//=============================================================================
// RockchipLarge.
//=============================================================================
class RockchipLarge expands DeusExFragment;

//CyberP: new class used by explosions only
#exec obj load file=CoreTexConcrete

auto state Flying
{
	simulated function BeginState()
	{
		Super.BeginState();

        Multiskins[0]=Texture'ClenGrayCemnt_B';
		Velocity = VRand() * 600;
		Velocity.Z = FRand() * 100 + 100;
		DrawScale = (DrawScale * 0.4) + FRand() * 0.6;
		SetRotation(Rotator(Velocity));
	}
}

function ZoneChange(ZoneInfo NewZone)
{
	Super.ZoneChange(NewZone);

	if (NewZone.bWaterZone)
	    Destroy();
}

defaultproperties
{
     Fragments(0)=LodMesh'DeusExItems.Rockchip1'
     Fragments(1)=LodMesh'DeusExItems.Rockchip2'
     Fragments(2)=LodMesh'DeusExItems.Rockchip3'
     numFragmentTypes=3
     elasticity=0.400000
     ImpactSound=Sound'DeusExSounds.Generic.RockHit1'
     MiscSound=Sound'DeusExSounds.Generic.RockHit2'
     Skin=Texture'GMDXSFX.Skins.RockChipTex'
     Mesh=LodMesh'DeusExItems.Rockchip1'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
