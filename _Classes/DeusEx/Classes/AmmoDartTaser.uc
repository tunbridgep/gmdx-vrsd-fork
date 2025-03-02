//=============================================================================
// AmmoDartPoison.
//=============================================================================
class AmmoDartTaser extends DeusExAmmo;

function PostBeginPlay()
{
    local DeusExPlayer player;
    super.PostBeginPlay();
    player=DeusExPlayer(GetPlayerPawn());

    if ((player != none) && (player.bHardCoreMode == True))
   	{
   	    if (Owner == None)
    	    AmmoAmount = 1;  //CyberP: less ammo on hardcore
   	}
}

defaultproperties
{
     bShowInfo=True
     altDamage=15
     AmmoAmount=3
     ammoSkill=Class'DeusEx.SkillWeaponPistol'
     MaxAmmo=30
     ItemArticle="some"
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     largeIconWidth=20
     largeIconHeight=47
     PlayerViewMesh=LodMesh'DeusExItems.AmmoDart'
     PickupViewMesh=LodMesh'DeusExItems.AmmoDart'
     ThirdPersonMesh=LodMesh'DeusExItems.AmmoDart'
     Mesh=LodMesh'DeusExItems.AmmoDart'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
     ItemName="Taser Darts"
     Icon=Texture'RSDCrap.Icons.BeltIconAmmoDartsTaser'
     largeIcon=Texture'RSDCrap.Icons.LargeIconAmmoDartsTaser'
     HDTPIcon="GMDXSFX.Icons.BeltIconTaserDart"
     HDTPLargeIcon="GMDXSFX.Icons.LargeIconTaserDart"
     Description="A dart that once has penetrated the skin delivers a high-voltage electrical current via an internal electrode, causing involuntary muscle spasms and effectively incapacitating the target in a non-lethal manner."
     beltDescription="TASER"
     HDTPSkin="GMDXSFX.Skins.TaserAmmo"
     Skin=Texture'RSDCrap.Skins.AmmoDartTex4'
}
