//=============================================================================
// Liquor40oz.
//=============================================================================
class Liquor40oz extends Vice; //DeusExPickup;

enum ESkinColor
{
	SC_Super45,
	SC_Bottle2,
	SC_Bottle3,
	SC_Bottle4
};

var() ESkinColor SkinColor;

exec function UpdateHDTPSettings()
{
	Super.UpdateHDTPSettings();
    switch (SkinColor)
    {
        case SC_Super45:
            Multiskins[1]=class'HDTPLoader'.static.GetTexture2("HDTPitems.skins.HDTPLiquor40oztex1","",IsHDTP());
            Multiskins[3]=class'HDTPLoader'.static.GetTexture2("HDTPitems.skins.HDTPLiquor40oztex1","",IsHDTP());
            Skin=class'HDTPLoader'.static.GetTexture2("","Liquor40oztex1",IsHDTP());
            break;
        case SC_Bottle2:
            Multiskins[1]=class'HDTPLoader'.static.GetTexture2("HDTPitems.skins.HDTPLiquor40oztex3","",IsHDTP());
            Multiskins[3]=class'HDTPLoader'.static.GetTexture2("HDTPitems.skins.HDTPLiquor40oztex3","",IsHDTP());
            Skin=class'HDTPLoader'.static.GetTexture2("","Liquor40oztex2",IsHDTP());
            break;
        case SC_Bottle3:
            Multiskins[1]=class'HDTPLoader'.static.GetTexture2("HDTPitems.skins.HDTPLiquor40oztex4","",IsHDTP());
            Multiskins[3]=class'HDTPLoader'.static.GetTexture2("HDTPitems.skins.HDTPLiquor40oztex4","",IsHDTP());
            Skin=class'HDTPLoader'.static.GetTexture2("","Liquor40oztex3",IsHDTP());
            break;
        case SC_Bottle4:
            Multiskins[1]=class'HDTPLoader'.static.GetTexture2("HDTPitems.skins.HDTPLiquor40oztex5","",IsHDTP());
            Multiskins[3]=class'HDTPLoader'.static.GetTexture2("HDTPitems.skins.HDTPLiquor40oztex5","",IsHDTP());
            Skin=class'HDTPLoader'.static.GetTexture2("","Liquor40oztex4",IsHDTP());
            break;
    }
}

function Eat(DeusExPlayer player)
{
    if (!player.bAddictionSystem)                                        //RSD: Was 2, now 5 health to go alongside the addiction system bonus //SARGE: Actually just back to 2, with addiction system only giving the buff
        player.HealPlayer(2, False);
    player.drugEffectTimer += 7.0;
    player.PlaySound(sound'drinkwine',SLOT_None);
}

defaultproperties
{
     AddictionIncrement=5.000000
     bUseHunger=True
     bBreakable=True
     ItemName="Forty"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     LandSound=Sound'DeusExSounds.Generic.GlassHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconBeerBottle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconBeerBottle'
     largeIconWidth=14
     largeIconHeight=47
     Description="'COLD SWEAT forty ounce malt liquor. Never let 'em see your COLD SWEAT.'"
     beltDescription="FORTY"
     HDTPTexture="HDTPItems.Skins.HDTPLiquor40oztex2"
     HDTPMesh="HDTPItems.HDTPLiquor40oz"
     Mesh=LodMesh'DeusExItems.Liquor40oz'
     CollisionRadius=4.000000
     CollisionHeight=9.140000
     bCollideWorld=True
     bBlockPlayers=True
     Mass=10.000000
     Buoyancy=8.000000
     fullness=4
}
