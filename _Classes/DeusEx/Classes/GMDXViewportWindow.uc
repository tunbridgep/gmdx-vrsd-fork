//-----------------------------------------------------------
//GMDX:dasraiser
//viewport mod so update pos/rot happen here, keeping it sync'd
// SARGE: This was completely unused, so I have commandeered it for the drone window.
//-----------------------------------------------------------
class GMDXViewportWindow expands ViewportWindow;

var DeusExPlayer Player;


event CalcView(actor originActor, actor watchActor,
					out vector frameLocation, out rotator frameRotation)
{

    player = DeusExPlayer(originActor);

    if (player == None)
        return;

    frameRotation = player.SAVErotation;
    frameLocation = player.Location;
}

defaultproperties
{
}
