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

function postpostbeginplay()
{
	super.PostPostBeginPlay();

    //Set up Meshes
    if (iHDTPModelToggle > 0)
    {
        //check for non-standard textures, adjust accordingly. HAAACKY.
        if(skin == texture'SodacanTex2' || multiskins[0] == texture'SodacanTex2')
            Multiskins[1] = class'HDTPLoader'.static.GetTexture("HDTPSodacantex2");
        else if(skin == texture'SodacanTex3' || multiskins[0] == texture'SodacanTex3')
            Multiskins[1] = class'HDTPLoader'.static.GetTexture("HDTPSodacantex3");
        else if(skin == texture'SodacanTex4' || multiskins[0] == texture'SodacanTex4')
            Multiskins[1] = class'HDTPLoader'.static.GetTexture("HDTPSodacantex4");
    }
    else
    {
        Multiskins[1] = default.Multiskins[1];
    }
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
}
