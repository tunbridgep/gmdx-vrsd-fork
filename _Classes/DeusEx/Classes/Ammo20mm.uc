//=============================================================================
// Ammo20mm.
//=============================================================================
class Ammo20mm extends DeusExAmmo;

function PostBeginPlay()
{
local DeusExPlayer player;

        super.PostBeginPlay();

        player=DeusExPlayer(GetPlayerPawn());

   if ((player != none) && (player.bHardCoreMode == True))
   	{
   	    if (Owner == None)
    	AmmoAmount = 2;  //CyberP: less ammo on hardcore
   	}
}

defaultproperties
{
     bShowInfo=True
     altDamage=200
     ammoSkill=Class'DeusEx.SkillDemolition'
     AmmoAmount=3
     MaxAmmo=4
     ItemName="20mm HE Ammo"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.Ammo20mm'
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmo20mm'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmo20mm'
     largeIconWidth=47
     largeIconHeight=37
     Description="The 20mm high-explosive round complements the standard 7.62x51mm assault rifle by adding the capability to clear small rooms, foxholes, and blind corners using an underhand launcher."
     beltDescription="20MM HE"
     HDTPSkin="HDTPItems.Skins.HDTPAmmo20mmTex1"
     Mesh=LodMesh'DeusExItems.Ammo20mm'
     CollisionRadius=9.500000
     CollisionHeight=4.750000
     bCollideActors=True
     bHarderScaling=True
     ammoHUDColor=(R=255,G=64)
}
