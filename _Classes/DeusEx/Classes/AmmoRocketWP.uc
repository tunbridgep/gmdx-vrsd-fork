//=============================================================================
// AmmoRocketWP.
//=============================================================================
class AmmoRocketWP extends AmmoRocket;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	AmmoAmount=4;
}

defaultproperties
{
     altDamage=50
     ItemName="WP Rockets"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoWPRockets'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoWPRockets'
     largeIconWidth=45
     largeIconHeight=37
     Description="The white-phosphorus rocket, or 'wooly peter,' was designed to expand the mission profile of the GEP gun. While it does minimal damage upon detonation, the explosion will spread a cloud of particularized white phosphorus that ignites immediately upon contact with the air."
     beltDescription="WP ROCKET"
     Skin=Texture'HDTPItems.Skins.HDTPgepammotex2'
     MultiSkins(1)=Texture'HDTPItems.Skins.HDTPgepammotex2'
}
