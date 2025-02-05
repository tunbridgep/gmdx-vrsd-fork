//=============================================================================
// Sodacan.
//=============================================================================
class Sodacan extends RSDEdible;

function Eat(DeusExPlayer player)
{
    local Sound BurpSound;
    
    //Heal
    player.HealPlayer(2, False);

    //LDDP, 10/25/21: Load sound for burping dynamically.
    if ((player.FlagBase != None) && (Player.FlagBase.GetBool('LDDPJCIsFemale')))
        BurpSound = Sound(DynamicLoadObject("FemJC.FJCBurp", class'Sound', false));
    else
        BurpSound = sound'MaleBurp';

    PlaySound(BurpSound);
}

function SetSkin()
{
    local Texture tex;
    //Set up Meshes
    switch(textureSet)
    {
        case 0:
            tex = class'HDTPLoader'.static.GetTexture2("HDTPItems.HDTPSodacantex1","RSDCrap.Skins.SodaCanTex1",IsHDTP());
            break;
        case 1:
            tex = class'HDTPLoader'.static.GetTexture2("HDTPItems.HDTPSodacantex2","RSDCrap.Skins.SodaCanTex2",IsHDTP());
            break;
        case 2:
            tex = class'HDTPLoader'.static.GetTexture2("HDTPItems.HDTPSodacantex3","RSDCrap.Skins.SodaCanTex3",IsHDTP());
            break;
        case 3:
            tex = class'HDTPLoader'.static.GetTexture2("HDTPItems.HDTPSodacantex4","RSDCrap.Skins.SodaCanTex4",IsHDTP());
            break;
    }

    if (IsHDTP())
    {
        Skin = None;
        Multiskins[1] = tex;
    }
    else
    {
        Skin = tex;
        Multiskins[1] = None;
    }
}

function PreBeginPlay()
{
    //check for non-standard textures, adjust accordingly. HAAACKY.
    //SARGE: Ugh....just use the proper skin system...
    if(skin == texture'SodacanTex2' || multiskins[0] == texture'SodacanTex2')
        textureSet = 1;
    else if(skin == texture'SodacanTex3' || multiskins[0] == texture'SodacanTex3')
        textureSet = 2;
    else if(skin == texture'SodacanTex4' || multiskins[0] == texture'SodacanTex4')
        textureSet = 3;
    super.PreBeginPlay();

}

defaultproperties
{
     bBreakable=True
     FragType=Class'DeusEx.PlasticFragment'
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Soda"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconSodaCan'
     largeIcon=Texture'DeusExUI.Icons.LargeIconSodaCan'
     largeIconWidth=24
     largeIconHeight=45
     Description="The can is blank except for the phrase 'PRODUCT PLACEMENT HERE.' It is unclear whether this is a name or an invitation."
     beltDescription="SODA"
     Mesh=LodMesh'DeusExItems.Sodacan'
     HDTPMesh="HDTPItems.HDTPsodacan"
     CollisionRadius=3.000000
     CollisionHeight=4.500000
     Mass=5.000000
     Buoyancy=3.000000
     fullness=4
     totalSkins=4
}
