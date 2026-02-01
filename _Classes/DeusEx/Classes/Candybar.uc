//=============================================================================
// Candybar.
//=============================================================================
class Candybar extends RSDEdible;

function Eat(DeusExPlayer player)
{
    player.PlaySound(sound'CandyEat',SLOT_None,2);
}

function SetSkin()
{
    switch (textureSet)
    {
        case 0:
            Skin = class'HDTPLoader'.static.GetTexture2(HDTPSkin,string(default.Skin),IsHDTP());
            break;
        case 1:
            Skin = Texture'DeusExItems.Skins.CandyBarTex2'; //HDTP has no alternate candybar texture
            break;
    }
}

//SARGE: We need to do some swoocy bullshit because of how the vanilla game works.
//In the vanilla game, the Monty Bites icon is the default, despite using the Chunkohoney skin as the default.
//So we need to swap the icons around, but ONLY in non-default icon mode.
//This is the worst hack ever devised.
function IconInfo GetIcon(int skinIndex)
{
    Log("SkinIndex: " $ skinIndex);
    if (skinIndex == 1)
        return super.GetIcon(0);
    else
        return super.GetIcon(1);
}

defaultproperties
{
     healAmount=2
     bioenergyAmount=3
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
     HDTPSkin="HDTPItems.Skins.HDTPCandybartex1"
     Mesh=LodMesh'DeusExItems.Candybar'
     CollisionRadius=6.250000
     CollisionHeight=0.670000
     Mass=3.000000
     Buoyancy=4.000000
     fullness=6
     totalSkins=2
     bHasMultipleSkins=true
}
