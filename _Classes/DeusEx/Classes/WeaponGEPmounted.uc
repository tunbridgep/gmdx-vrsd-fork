//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WeaponGEPmounted expands WeaponGEPGun;


var DeusExPlayer player;
var GMDXFlickerLight lightFlicker;
var vector axesX;//fucking weapon rotation fix
var vector axesY;
var vector axesZ;

function SetMount(DeusExPlayer dxp)
{
	local vector ofs;
	local rotator rfs;

	rfs.Yaw=2912;
	GetAxes(rfs,axesX,axesY,axesZ);
	player=dxp;

	SetCollision(false,false,false);
	bCollideWorld=false;

	//if (lightFlicker==none) //CyberP: commented flicker call out for now
	//{
	//  lightFlicker=Spawn(class'DeusEx.GMDXFlickerLight',self);
	//  if (lightFlicker!=none)
	//  {
	//     lightFlicker.UpdateLocation(player);
	//  }
	//}
}
/*
function BecomePickup()
{
}

State Sleeping
{
	ignores Touch;
	function BeginState()
	{
	}
	function EndState()
	{
	}
Begin:
}
*/
function RenderME(Canvas canvas,bool bSetWire,optional bool bClearZ)
{
	local rotator rfs;
	local vector dx;
	local vector dy;
	local vector dz;

	if(player==none||(!player.bGEPzoomActive)) return;
		PreRender1();

	dx=axesX>>player.ViewRotation;
	dy=axesY>>player.ViewRotation;
	dz=axesZ>>player.ViewRotation;
	rfs=OrthoRotation(dx,dy,dz);

	SetRotation(rfs);
  	SetLocation(player.Location+ CalcDrawOffset());// player.BaseEyeHeight*vect(0,0,1)+(PlayerViewOffset>>player.ViewRotation));

	Canvas.DrawActor(self, bSetWire,bClearZ);
	PreRender2();

	if (lightFlicker!=none) lightFlicker.UpdateLocation(player);

}

//bHiddenEd=true

defaultproperties
{
     bHasScope=True
     bHideWeapon=True
     PlayerViewOffset=(X=24.000000,Y=7.200000,Z=-4.600000)
     PickupViewMesh=LodMesh'HDTPItems.HDTPGEPgun'
     bHidden=True
     bDetectable=False
     bHiddenEd=True
     Mesh=LodMesh'HDTPItems.HDTPGEPgun'
     bOnlyOwnerSee=True
     bCollideActors=False
     bBlockActors=False
}
