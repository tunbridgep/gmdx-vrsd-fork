//=============================================================================
// ComputerSecurity.
//=============================================================================
class ComputerSecurity extends Computers;

struct sViewInfo
{
	var() localized string	titleString;
	var() name				cameraTag;
	var() name				turretTag;
	var() name				doorTag;
};

var() localized sViewInfo Views[3];
var int team;
var() travel int secLevel;              //CyberP: skill requirement to hack this computer.
// ----------------------------------------------------------------------------
// network replication
// ----------------------------------------------------------------------------
replication
{
   //server to client
   reliable if (Role == ROLE_Authority)
      Views, team;
}

function PostBeginPlay()
{
   Super.PostBeginPlay();

   if (secLevel < 1)
   {
    if (FRand() < 0.25)
    secLevel = 3;
    else if (FRand() < 0.35)
    secLevel = 2;
    else
    secLevel = 1;
   }
}

// -----------------------------------------------------------------------
// SetControlledObjectOwners
// Used to enhance network replication.
// -----------------------------------------------------------------------

function SetControlledObjectOwners(DeusExPlayer PlayerWhoOwns)
{
	local int cameraIndex;
	local name tag;
	local SecurityCamera camera;
   local AutoTurret turret;
   local DeusExMover door;

	for (cameraIndex=0; cameraIndex<ArrayCount(Views); cameraIndex++)
	{
		tag = Views[cameraIndex].cameraTag;
		if (tag != '')
			foreach AllActors(class'SecurityCamera', camera, tag)
				camera.SetOwner(PlayerWhoOwns);

		tag = Views[cameraIndex].turretTag;
		if (tag != '')
			foreach AllActors(class'AutoTurret', turret, tag)
            turret.SetOwner(PlayerWhoOwns);

		tag = Views[cameraIndex].doorTag;
		if (tag != '')
			foreach AllActors(class'DeusExMover', door, tag)
				door.SetOwner(PlayerWhoOwns);

	}

}

// ----------------------------------------------------------------------
// AdditionalActivation()
// Called for subclasses to do any additional activation steps.
// ----------------------------------------------------------------------

function AdditionalActivation(DeusExPlayer ActivatingPlayer)
{
   if (Level.NetMode != NM_Standalone)
      SetControlledObjectOwners(ActivatingPlayer);
    
    if (!IsHDTP())
        Skin = Texture'DeusExDeco.Skins.ComputerSecurityTex1';
    Super.AdditionalDeactivation(ActivatingPlayer);
}

// ----------------------------------------------------------------------
// AdditionalDeactivation()
// ----------------------------------------------------------------------

function AdditionalDeactivation(DeusExPlayer DeactivatingPlayer)
{
   if (Level.NetMode != NM_Standalone)
      SetControlledObjectOwners(None);

    if (!IsHDTP())
        Skin = default.Skin;
    Super.AdditionalDeactivation(DeactivatingPlayer);
}

defaultproperties
{
     allowHackingLockout=true
     Team=-1
     terminalType=Class'DeusEx.NetworkTerminalSecurity'
     lockoutDelay=120.000000
     UserList(0)=(userName="SECURITY",Password="SECURITY")
     ItemName="Security Computer Terminal"
     Physics=PHYS_None
     HDTPSkin="HDTPDecos.Skins.HDTPComputerSecurityTex1"
     Skin=Texture'RSDCrap.Skins.ComputerSecurityTex1Blank'
     Mesh=LodMesh'DeusExDeco.ComputerSecurity'
     SoundRadius=8
     SoundVolume=255
     SoundPitch=96
     AmbientSound=Sound'DeusExSounds.Generic.SecurityL'
     CollisionRadius=11.590000
     CollisionHeight=10.100000
     bCollideWorld=False
     BindName="ComputerSecurity"
}
