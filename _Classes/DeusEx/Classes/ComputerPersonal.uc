//=============================================================================
// ComputerPersonal.
//=============================================================================
class ComputerPersonal extends Computers;

var() travel int secLevel;

function PostBeginPlay()
{
   Super.PostBeginPlay();

   if (secLevel < 1)
   {
    if (FRand() < 0.1)
    secLevel = 2;
    else
    secLevel = 1;
   }
}

defaultproperties
{
     terminalType=Class'DeusEx.NetworkTerminalPersonal'
     lockoutDelay=60.000000
     UserList(0)=(userName="USER",Password="USER")
     ItemName="Personal Computer Terminal"
     Mesh=LodMesh'HDTPDecos.HDTPComputerpersonal'
     CollisionRadius=36.000000
     CollisionHeight=7.400000
     bBlockPlayers=False
     BindName="ComputerPersonal"
}
