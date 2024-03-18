//-----------------------------------------------------------
//GMDX:dasraiser
//viewport mod so update pos/rot happen here, keeping it sync'd
//-----------------------------------------------------------
class GMDXViewportWindow expands ViewportWindow;

var DeusExPlayer Player;


event CalcView(actor originActor, actor watchActor,
					out vector frameLocation, out rotator frameRotation)
{
	local vector rx,ry,rz;
	if (Player.bGEPprojectileInflight)
	{
		GetAxes(Player.aGEPProjectile.Rotation,rx,ry,rz);
		frameLocation=Player.aGEPProjectile.OldLocation-rz*2+rx*0.1;
		frameRotation=Player.aGEPProjectile.Rotation;
	} else
	{
	frameLocation=Player.RocketTarget.Location;
	frameRotation=player.RocketTarget.Rotation;
	}
}

defaultproperties
{
}
