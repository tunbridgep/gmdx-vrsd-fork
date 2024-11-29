//=============================================================================
// Ammo3006.
//=============================================================================
class Ammo3006 extends DeusExAmmo;

function PostBeginPlay()
{
local DeusExPlayer player;

        super.PostBeginPlay();

        player=DeusExPlayer(GetPlayerPawn());

   if ((player != none) && (player.bHardCoreMode == True))
   	{
   	    if (Owner == None)
    	AmmoAmount = 4;  //CyberP: less ammo on hardcore
   	}
}

function bool UseAmmo(int AmountNeeded)
{
	local vector offset, tempvec, X, Y, Z;
	local ShellCasing shell;
	local DeusExWeapon W;

	if (Super.UseAmmo(AmountNeeded))
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.86 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z-3.5;
        W = DeusExWeapon(Pawn(Owner).Weapon);
        if (W.Owner.IsA('DeusExPlayer') && DeusExPlayer(W.Owner).IsCrouching())
        offset.Z -= 3.5;

		// use silent shells if the weapon has been silenced
      if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
      {
         shell = None;
      }
      else
      {
            shell = spawn(class'ShellCasing',,, Owner.Location + offset,Pawn(Owner).viewrotation);
      }

		if (shell != None && IsHDTP())
		{
			shell.Velocity = (FRand()*90+90) * Y + (20-FRand()*40) * X;
			shell.Velocity.Z = 19+frand()*10;
			shell.Mesh = class'HDTPLoader'.static.GetMesh("HDTPItems.HDTPSniperCasing");
			Shell.Smokeprob=0.2;
			shell.DrawScale+=0.4;
		}
		return True;
	}

	return False;
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponRifle'
     AmmoAmount=5
     MaxAmmo=20
     ItemName="30.06 Ammo"
     ItemArticle="some"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmo3006'
     largeIconWidth=43
     largeIconHeight=31
     Description="Its high velocity and accuracy have made sniper rifles using the 30.06 round the preferred tool of individuals requiring 'one shot, one kill' for over fifty years."
     beltDescription="3006 AMMO"
     HDTPMesh="HDTPItems.HDTPammo3006"
     Mesh=LodMesh'DeusExItems.Ammo3006'
     CollisionRadius=8.000000
     CollisionHeight=3.860000
     bCollideActors=True
}
