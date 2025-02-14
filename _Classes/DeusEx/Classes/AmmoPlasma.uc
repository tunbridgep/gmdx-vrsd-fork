//=============================================================================
// AmmoPlasma.
//=============================================================================
class AmmoPlasma extends DeusExAmmo;

function PostBeginPlay()
{
local DeusExPlayer player;

        super.PostBeginPlay();

        player=DeusExPlayer(GetPlayerPawn());

   if ((player != none) && (player.bHardCoreMode == True))
   	{
   	    if (Owner == None)
    	AmmoAmount = 8;  //CyberP: less ammo on hardcore
   	}
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponHeavy'
     AmmoAmount=12
     MaxAmmo=30
     ItemName="Plasma Clip"
     ItemArticle="a"
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoPlasma'
     largeIconWidth=22
     largeIconHeight=46
     Description="A clip of extruded, magnetically-doped plastic slugs that can be heated and delivered with devastating effect using the plasma gun."
     beltDescription="PMA CLIP"
     HDTPMesh="HDTPItems.HDTPAmmoPlasma"
     Mesh=LodMesh'DeusExItems.AmmoPlasma'
     CollisionRadius=4.300000
     CollisionHeight=8.440000
     bCollideActors=True
}
