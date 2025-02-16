//=============================================================================
// KarkianBaby.
//=============================================================================
class KarkianBaby extends Karkian;

function bool IsHDTP()
{
    return DeusExPlayer(GetPlayerPawn()).IsHDTPInstalled() && class'DeusEx.Karkian'.default.iHDTPModelToggle > 0;
}

defaultproperties
{
     CarcassType=Class'DeusEx.KarkianBabyCarcass'
     WalkingSpeed=0.185000
     InitialInventory(1)=(Inventory=None)
     walkAnimMult=2.500000
     runAnimMult=2.500000
     GroundSpeed=500.000000
     WaterSpeed=150.000000
     Health=100
     DrawScale=0.500000
     CollisionRadius=30.000000
     CollisionHeight=18.549999
     Mass=60.000000
     Buoyancy=60.000000
     RotationRate=(Yaw=50000)
     BindName="KarkianBaby"
     FamiliarName="Baby Karkian"
     UnfamiliarName="Baby Karkian"
}
