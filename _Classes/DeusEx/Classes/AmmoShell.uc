//=============================================================================
// AmmoShell.
//=============================================================================
class AmmoShell extends DeusExAmmo;

var bool bWaitForIt;

//
// SimUseAmmo - Spawns shell casings client side
//
/*simulated function bool SimUseAmmo()
{
	local vector offset, tempvec, X, Y, Z;
	local ShellCasing2 shell;
    local DeusExPlayer player;

	if ( AmmoAmount > 0 )
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z;

		shell = spawn(class'ShellCasing2',,, Owner.Location + offset,Pawn(Owner).viewrotation);
		shell.RemoteRole = ROLE_None;

		if (shell != None)
		{
			shell.Velocity = (FRand()*20+90) * Y + (10-FRand()*20) * X;
			shell.Velocity.Z = 0;
		}
		return True;
	}
	return False;
} */

function Timer()
{
 local vector offset, tempvec, X, Y, Z;
 local ShellCasing2 shell;
 local DeusExWeapon W;

		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += (tempvec.Z);
		if (Owner.IsA('DeusExPlayer'))
		{
		   W = DeusExWeapon(Pawn(Owner).Weapon);
		   //if (W.bAimingDown)
		   //    offset.Z += 3;
		   if (DeusExPlayer(Owner).bIsCrouching)
               offset.Z -= 7;
           else
               offset.Z -= 4;
        }
        shell = spawn(class'ShellCasing2',,, Owner.Location + offset,Pawn(Owner).viewrotation);

		if (shell != None)
		{
			shell.Velocity = (FRand()*20+90) * Y + (10-FRand()*20) * X;
			shell.Velocity.Z = 20;
			shell.ImpactSound=Sound'RSDCrap.Weapons.ShellCaseSound';
			shell.MiscSound=Sound'RSDCrap.Weapons.ShellCaseSound';
		}
		bWaitForIt=False;
}
function bool UseAmmo(int AmountNeeded)
{
	local vector offset, tempvec, X, Y, Z;
	local ShellCasing2 shell;

    if (Owner != None && Owner.IsA('DeusExPlayer'))
       if (DeusExPlayer(Owner).inHand != None && DeusExPlayer(Owner).inHand.IsA('WeaponSawedOffShotgun'))
          bWaitForIt=True;

	if (Super.UseAmmo(AmountNeeded) && bWaitForIt==False)
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z;
      if ( DeusExMPGame(Level.Game) != None )
      {
			if ( Level.NetMode == NM_ListenServer )
			{
	         shell = spawn(class'ShellCasing2',,, Owner.Location + offset,Pawn(Owner).viewrotation);
				shell.RemoteRole = ROLE_None;
			}
			else
	         shell = None;
      }
      else
      {
         shell = spawn(class'ShellCasing2',,, Owner.Location + offset,Pawn(Owner).viewrotation);
      }
		if (shell != None)
		{
			shell.Velocity = (FRand()*20+90) * Y + (10-FRand()*20) * X;
			shell.Velocity.Z = 20;
			shell.ImpactSound=Sound'RSDCrap.Weapons.ShellCaseSound';
			shell.MiscSound=Sound'RSDCrap.Weapons.ShellCaseSound';
		}
		return True;
	}
	if (bWaitForIt == True)
	{ SetTimer(0.5,False); return True; }
	return False;
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponRifle'
     AmmoAmount=5
     MaxAmmo=30
     ItemName="12 Gauge Buckshot Shells"
     ItemArticle="some"
     PickupViewMesh=LodMesh'HDTPItems.HDTPammoshell'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoShells'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoShells'
     largeIconWidth=34
     largeIconHeight=45
     Description="Standard 12 gauge shotgun shell; very effective for close-quarters combat against soft targets, but useless against body armor."
     beltDescription="BUCKSHOT"
     Mesh=LodMesh'HDTPItems.HDTPammoshell'
     CollisionRadius=9.300000
     CollisionHeight=10.210000
     bCollideActors=True
}
