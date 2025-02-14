//=============================================================================
// MedKit.
//=============================================================================
class SoftwareStop extends DeusExPickup;

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

exec function UpdateHDTPsettings()
{
	Super.UpdateHDTPsettings();
    MultiSkins[1] = class'HDTPLoader'.static.GetTexture2("GMDXSFX.2027Misc.MinidiskTex0","RSDCrap.Skins.MiniDiskTex0",IsHDTP());
}

// ----------------------------------------------------------------------

defaultproperties
{
     bBreakable=True
     FragType=Class'DeusEx.PlasticFragment'
     maxCopies=15
     bCanHaveMultipleCopies=True
     ItemName="STOP! Worm Software"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'GameMedia.Minidisk'
     PickupViewMesh=LodMesh'GameMedia.Minidisk'
     ThirdPersonMesh=LodMesh'GameMedia.Minidisk'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'GMDXSFX.Skins.StopBelt'
     largeIcon=Texture'GMDXSFX.Skins.StopLarge'
     largeIconWidth=32
     largeIconHeight=32
     Description="Hacking Software. This program freezes any diagnostic attempt by the network for approximately 7 seconds, granting the user precious time."
     beltDescription="STOPWORM"
     Physics=PHYS_None
     Mesh=LodMesh'GameMedia.Minidisk'
     CollisionRadius=3.000000
     CollisionHeight=0.500000
     Mass=4.000000
     Buoyancy=8.000000
}
