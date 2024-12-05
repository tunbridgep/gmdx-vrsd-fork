//=============================================================================
// SoyFood.
//=============================================================================
class SoyFood extends RSDEdible;

function Eat(DeusExPlayer player)
{
    player.HealPlayer(5, False);
	PlaySound(sound'EatingChips',SLOT_None,3.0);
}

function SetSkin()
{
    local Texture tex;
    Super.SetSkin();

    //Set up Meshes
    switch(textureSet)
    {
        case 0: tex = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPSoyFoodTex1","",IsHDTP()); break;
        case 1: tex = class'HDTPLoader'.static.GetTexture("HK_Signs.HK_Sign_28"); break;
    }
}

defaultproperties
{
     bBreakable=True
     FragType=Class'DeusEx.PaperFragment'
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Soy Food"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.SoyFood'
     PickupViewMesh=LodMesh'DeusExItems.SoyFood'
     ThirdPersonMesh=LodMesh'DeusExItems.SoyFood'
     Icon=Texture'DeusExUI.Icons.BeltIconSoyFood'
     largeIcon=Texture'DeusExUI.Icons.LargeIconSoyFood'
     largeIconWidth=42
     largeIconHeight=46
     Description="Fine print: 'Seasoned with nanoscale mechanochemical generators, this TSP (textured soy protein) not only tastes good but also self-heats when its package is opened.'"
     beltDescription="SOY FOOD"
     HDTPSkin="HDTPItems.Skins.HDTPSoyFoodTex1"
     Mesh=LodMesh'DeusExItems.SoyFood'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
     fullness=8
}
