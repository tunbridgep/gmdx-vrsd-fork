//=============================================================================
// SoyFood.
//=============================================================================
class SoyFood extends RSDEdible;

function PostBeginPlay()
{
    //When TT was placing soyfood in the maps, he simply changed their texture to the HK_Sign texture
    //instead of setting their skins properly. So we need to fix it.
    //I could just go through the maps and reset it that way, but fuck it...
    if (multiskins[0] != None && string(multiskins[0].Name) == "HK_Sign_28")
    {
        textureSet = 1;
        Skin = class'HDTPLoader'.static.GetTexture2("HK_Signs.HK_Sign_28","RSDCrap.Skins.SoyFoodTex2",IsHDTP());
    }

    Super.PostBeginPlay();
}

function Eat(DeusExPlayer player)
{
	player.PlaySound(sound'EatingChips',SLOT_None,3.0);
}

function SetSkin()
{
    Super.SetSkin();

    //Set up Meshes
    switch(textureSet)
    {
        case 0: Skin = class'HDTPLoader'.static.GetTexture2("HDTPItems.Skins.HDTPSoyFoodTex1","",IsHDTP()); break;
        //case 1: Skin = class'HDTPLoader'.static.GetTexture("HK_Signs.HK_Sign_28"); break;
        case 1: Skin = class'HDTPLoader'.static.GetTexture2("HK_Signs.HK_Sign_28","RSDCrap.Skins.SoyFoodTex2",IsHDTP()); break; //SARGE: Replaced with a nice new texture!
    }
}

defaultproperties
{
     healAmount=5;
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
     dontRandomiseSkin=true //We want the HK ones to only appear in HK, so don't randomise them. Might change this later!
     totalSkins=2
     bHasMultipleSkins=true
}
