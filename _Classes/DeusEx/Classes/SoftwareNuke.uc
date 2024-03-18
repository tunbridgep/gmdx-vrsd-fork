//=============================================================================
// MedKit.
//=============================================================================
class SoftwareNuke extends DeusExPickup;

// ----------------------------------------------------------------------

 function PostBeginPlay()
{
 local rotator rot;

  super.PostBeginPlay();

  rot.Pitch = 0;
  rot.Yaw = self.Rotation.Yaw;
  rot.Roll = 0;

  SetRotation(rot);
}

// ----------------------------------------------------------------------

defaultproperties
{
     bBreakable=True
     FragType=Class'DeusEx.PlasticFragment'
     maxCopies=15
     bCanHaveMultipleCopies=True
     ItemName="NUKE Virus Software"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'GameMedia.Minidisk'
     PickupViewMesh=LodMesh'GameMedia.Minidisk'
     ThirdPersonMesh=LodMesh'GameMedia.Minidisk'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'GMDXSFX.Skins.NukeBelt'
     largeIcon=Texture'GMDXSFX.Skins.NukeLarge'
     largeIconWidth=32
     largeIconHeight=32
     Description="Hacking Software. A virus that shuts down the local network firewall, enabling the user to attempt to hack systems above their skill level. The firewall will become active again once the user logs out."
     beltDescription="NUKEVIRUS"
     Physics=PHYS_None
     Skin=Texture'GMDXSFX.2027Misc.MinidiskTex1'
     Mesh=LodMesh'GameMedia.Minidisk'
     MultiSkins(1)=Texture'GMDXSFX.2027Misc.MinidiskTex1'
     CollisionRadius=3.000000
     CollisionHeight=0.500000
     Mass=4.000000
     Buoyancy=8.000000
}
