//=============================================================================
// BoneFemurLessBloody.
//=============================================================================
class BoneFemurLessbloody extends DeusExDecoration;

//CyberP: new class used for gore when gibbing

simulated function BeginState()
	{
		Super.BeginState();

		Velocity = VRand() * 220;
		Velocity.Z = FRand() * 30 + 30;
		SetRotation(Rotator(Velocity));
		
		if (class'DeusExPlayer'.default.iPersistentDebris >= 2) //SARGE: Stick around forever, if we've enabled the setting.
            LifeSpan = 0;
	}

simulated function Tick(float deltaTime)
{

   if ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority))
      return;


	// fade out the object smoothly 2 seconds before it dies completely
	if (LifeSpan <= 2 && LifeSpan != 0)
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
     ItemName="Human Femur"
     LifeSpan=30.000000
     HDTPSkin="HDTPItems.Skins.HDTPFlatFXtex6"
     HDTPMesh="HDTPDecos.HDTPbonefemur"
     Mesh=LodMesh'DeusDeco.Bonefemur'
     CollisionRadius=2.000000
     CollisionHeight=0.780000
     bCollideActors=False
     bBlockActors=False
     Mass=5.000000
     Buoyancy=10.000000
}
