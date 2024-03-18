//=============================================================================
// SubwayControlPanel.
//=============================================================================
class SubwayControlPanel extends DeusExDecoration;

#exec obj load file=HDTPanim

defaultproperties
{
     bInvincible=True
     ItemName="Subway Control Panel"
     bPushable=False
     Physics=PHYS_None
     Skin=Texture'HDTPanim.Animated.SubwayControlPanel01'
     Mesh=LodMesh'DeusExDeco.SubwayControlPanel'
     SoundRadius=8
     SoundVolume=255
     SoundPitch=72
     AmbientSound=Sound'DeusExSounds.Generic.ElectronicsHum'
     CollisionRadius=6.000000
     CollisionHeight=8.400000
     Mass=40.000000
     Buoyancy=30.000000
}
