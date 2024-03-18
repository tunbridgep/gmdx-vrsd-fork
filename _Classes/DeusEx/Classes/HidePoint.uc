//=============================================================================
// HidePoint.
//=============================================================================
class HidePoint expands NavigationPoint;

var vector faceDirection;
var ScriptedPawn ChosenPawn;

function PreBeginPlay()
{
	Super.PreBeginPlay();

	faceDirection = 200 * vector(Rotation);
}

function Timer()
{
   ChosenPawn = None;
}

defaultproperties
{
     bDirectional=True
}
