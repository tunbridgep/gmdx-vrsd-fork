//=============================================================================
// Ammo10mm.
//=============================================================================
class Ammo10mm extends DeusExAmmo;

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
	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
        {
	AmmoAmount = 9;
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
		W = DeusExWeapon(Pawn(Owner).Weapon);
        if (W.bAimingDown)
		{
		    offset = Owner.CollisionRadius * X + 0.3 * (Owner.CollisionRadius * 0.15) * Y ;
		    tempvec = 0.9 * Owner.CollisionHeight * Z;
            offset.Z += tempvec.Z;
		}
        else
        {
		    offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y ;
		    tempvec = 0.82 * Owner.CollisionHeight * Z;
            offset.Z += tempvec.Z;
            if (W.IsA('WeaponStealthPistol'))
                offset.Z -= 3;
		}
        if (W.Owner.IsA('DeusExPlayer') && DeusExPlayer(W.Owner).IsCrouching())
        offset.Z -= 4;

		// use silent shells if the weapon has been silenced
      if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
      {
         shell = None;
      }
      else
      {
         //if ((W != None) && ((W.NoiseLevel < 0.1) || W.bHasSilencer))
            //shell = spawn(class'ShellCasingSilent',,, Owner.Location + offset,Pawn(Owner).viewrotation);
         //else
            shell = spawn(class'ShellCasing',,, Owner.Location + offset,Pawn(Owner).viewrotation);
      }

		if (shell != None)
		{
			shell.Velocity = (FRand()*90+60) * Y + (20-FRand()*40) * X;
			shell.Velocity.Z = 10 + frand()*10;
			shell.DrawScale += 0.1;
		}
		return True;
	}

	return False;
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponPistol'
     AmmoAmount=5
     MaxAmmo=50
     ItemName="10mm Ammo"
     ItemArticle="some"
     PickupViewMesh=LodMesh'DeusExItems.Ammo10mm'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmo10mm'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmo10mm'
     largeIconWidth=44
     largeIconHeight=31
     Description="With their combination of high stopping power and low recoil, pistols chambered for the 10mm round have become the sidearms of choice for paramilitary forces around the world."
     beltDescription="10MM AMMO"
     Skin=Texture'HDTPItems.Skins.HDTPAmmo10mmTex1'
     Mesh=LodMesh'DeusExItems.Ammo10mm'
     CollisionRadius=8.500000
     CollisionHeight=3.770000
     bCollideActors=True
     pickupSound=sound'RSDCrap.Pickups.Pickup10mmAmmo'
}
