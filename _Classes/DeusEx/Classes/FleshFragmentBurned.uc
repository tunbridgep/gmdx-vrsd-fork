//=============================================================================
// FleshFragment.
//=============================================================================
class FleshFragmentBurned expands DeusExFragment;

var float TwitchyS;
var float TwitchyE;
var bool bWasUnconscious;


auto state Flying                      //CyberP: modified to be more gory

{

	function BeginState()
	{
		local rotator      randRot;

		Super.BeginState();
        if (Level.Game.bLowGore || Level.Game.bVeryLowGore || Region.Zone.bWaterZone)
		{
			Destroy();
			return;
		}
		Velocity = VRand() * 300; //300
		DrawScale = FRand();
        randRot=Rotation;
		randRot.Yaw=FRand()*30000;

		if (FRand() < 0.6 && DrawScale > 0.5)
		bSmoking=False;

	}
}

defaultproperties
{
     bSmoking=True
     Fragments(0)=LodMesh'DeusExItems.FleshFragment1'
     Fragments(1)=LodMesh'DeusExItems.FleshFragment2'
     Fragments(2)=LodMesh'DeusExItems.FleshFragment3'
     Fragments(3)=LodMesh'DeusExItems.FleshFragment4'
     numFragmentTypes=4
     elasticity=0.300000
     ImpactSound=Sound'DeusExSounds.Generic.FleshHit1'
     MiscSound=Sound'DeusExSounds.Generic.FleshHit2'
     LifeSpan=60.000000
     Skin=Texture'DeusExDeco.Skins.AlarmLightTex5'
     HDTPSkin="HDTPDecos.Skins.HDTPAlarmLightTex5"
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     AmbientGlow=224
     CollisionRadius=0.500000
     CollisionHeight=1.500000
     LightType=LT_Steady
     LightEffect=LE_FireWaver
     LightBrightness=255
     LightHue=80
     LightSaturation=128
     LightRadius=2
     Mass=5.000000
     Buoyancy=5.500000
}
