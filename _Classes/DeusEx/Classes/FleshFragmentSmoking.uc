//=============================================================================
// FleshFragmentSmoking.
//=============================================================================
class FleshFragmentSmoking expands DeusExFragment;

var float TwitchyS;
var float TwitchyE;
var bool bWasUnconscious;


auto state Flying                      //CyberP: modified to be more gory

{

	function BeginState()
	{
		local rotator      randRot;

		Super.BeginState();

        if (Region.Zone.bWaterZone)
		{
			Destroy();
			return;
		}

        Velocity.Z = -400;
		Velocity = VRand() * 200; //300
		DrawScale = FRand() + 0.5;
		TwitchyS=DrawScale*0.8;
		TwitchyE=DrawScale-TwitchyS;
                randRot=Rotation;
		randRot.Yaw=FRand()*30000;

		if (FRand() < 0.02)
             Skin=class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPFleshFragTex1","DeusExItems.Skins.FleshFragmentTex1",IsHDTP());
	}
}

/*function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (!IsInState('Dying'))
		if (FRand() < 0.3)
			Spawn(class'BloodDrop',,, Location);

   if ((bWasUnconscious)&&(FRand()<0.1))
      DrawScale=FRand()*TwitchyE+TwitchyS;

}*/

defaultproperties
{
     bSmoking=True
     Fragments(0)=LodMesh'DeusExItems.FleshFragment1'
     Fragments(1)=LodMesh'DeusExItems.FleshFragment2'
     Fragments(2)=LodMesh'DeusExItems.FleshFragment3'
     Fragments(3)=LodMesh'DeusExItems.FleshFragment4'
     numFragmentTypes=4
     elasticity=0.400000
     ImpactSound=Sound'DeusExSounds.Generic.FleshHit1'
     MiscSound=Sound'DeusExSounds.Generic.FleshHit2'
     Mesh=LodMesh'DeusExItems.FleshFragment1'
     CollisionRadius=0.500000
     CollisionHeight=2.000000
     Mass=5.000000
     Buoyancy=5.500000
     bVisionImportant=True
}
