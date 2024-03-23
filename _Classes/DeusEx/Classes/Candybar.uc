//=============================================================================
// Candybar.
//=============================================================================
class Candybar extends RSDEdible;

var localized string bioboost;

function Eat(DeusExPlayer player)
{
    player.HealPlayer(2, False);
    player.PlaySound(sound'CandyEat',SLOT_None,2);
    player.Energy += 3;
    if (player.Energy > player.EnergyMax)
        player.Energy = player.EnergyMax;
    player.ClientMessage(bioboost);
}

defaultproperties
{
     bioboost="Recharged 3 Bioelectrical Energy Units"
     bBreakable=True
     FragType=Class'DeusEx.PaperFragment'
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Candy Bar"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Candybar'
     PickupViewMesh=LodMesh'DeusExItems.Candybar'
     ThirdPersonMesh=LodMesh'DeusExItems.Candybar'
     Icon=Texture'DeusExUI.Icons.BeltIconCandyBar'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCandyBar'
     largeIconWidth=46
     largeIconHeight=36
     Description="'CHOC-O-LENT DREAM. IT'S CHOCOLATE! IT'S PEOPLE! IT'S BOTH!(tm) 85% Recycled Material.'"
     beltDescription="CANDY BAR"
     Skin=Texture'HDTPItems.Skins.HDTPCandybartex1'
     Mesh=LodMesh'DeusExItems.Candybar'
     CollisionRadius=6.250000
     CollisionHeight=0.670000
     Mass=3.000000
     Buoyancy=4.000000
     fullness=6
}
