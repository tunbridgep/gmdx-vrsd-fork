//=============================================================================
// BoneSkullBloody.
//=============================================================================
class BoneSkullBloody extends DeusExDecoration;

simulated function Tick(float deltaTime)
{
   if ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority))
      return;

	// fade out the object smoothly 2 seconds before it dies completely
	if (LifeSpan <= 2)
	{
		if (Style != STY_Translucent)
			Style = STY_Translucent;

		ScaleGlow = LifeSpan / 2.0;
	}
}

defaultproperties
{
     bInvincible=True
     FragType=Class'DeusEx.WoodFragment'
     bHighlight=False
     bCanBeBase=True
     ItemName="Human Skull"
     LifeSpan=30.000000
     Skin=Texture'DeusExItems.Skins.FleshFragmentTex1'
     Mesh=LodMesh'DeusExDeco.BoneSkull'
     CollisionRadius=1.000000
     CollisionHeight=4.700000
     bCollideActors=False
     bBlockActors=False
     Mass=8.000000
     Buoyancy=10.000000
}
