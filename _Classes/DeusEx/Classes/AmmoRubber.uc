//=============================================================================
// AmmoShell.
//=============================================================================
class AmmoRubber extends DeusExAmmo;

var bool bWaitForIt;

//
// SimUseAmmo - Spawns shell casings client side
//
simulated function bool SimUseAmmo()
{
	local vector offset, tempvec, X, Y, Z;
	local ShellCasing2 shell;

	if ( AmmoAmount > 0 )
	{
		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += (tempvec.Z-5);
		if (Owner.IsA('DeusExPlayer'))
		   if (DeusExPlayer(Owner).bIsCrouching)
               offset.Z -= 5;
		shell = spawn(class'ShellCasing2',,, Owner.Location + offset,Pawn(Owner).viewrotation);
		shell.RemoteRole = ROLE_None;

		if (shell != None)
		{
			shell.Velocity = (FRand()*20+90) * Y + (10-FRand()*20) * X;
			shell.Velocity.Z = 20;
		}
		return True;
	}
	return False;
}

function Timer()
{
 local vector offset, tempvec, X, Y, Z;
 local ShellCasing2 shell;

		GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);
		offset = Owner.CollisionRadius * X + 0.3 * Owner.CollisionRadius * Y;
		tempvec = 0.8 * Owner.CollisionHeight * Z;
		offset.Z += tempvec.Z;
		if (Owner.IsA('DeusExPlayer'))
		   if (DeusExPlayer(Owner).bIsCrouching)
               offset.Z -= 7;

        shell = spawn(class'ShellCasing2',,, Owner.Location + offset,Pawn(Owner).viewrotation);

		if (shell != None)
		{
			shell.Velocity = (FRand()*20+90) * Y + (10-FRand()*20) * X;
			shell.Velocity.Z = 20;
			shell.MultiSkins[0]=Texture'RSDCrap.Items.RubberShell';
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
			shell.MultiSkins[0]=Texture'RSDCrap.Items.RubberShell';
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
     altDamage=10
     ammoSkill=Class'DeusEx.SkillWeaponRifle'
     AmmoAmount=8
     MaxAmmo=30
     ItemName="12 Gauge Rubber Shells"
     ItemArticle="some"
     PickupViewMesh=LodMesh'HDTPItems.HDTPammoshell'
     Icon=Texture'GMDXSFX.Icons.BeltIconRubberShells'
     largeIcon=Texture'GMDXSFX.Icons.LargeIconRubberShells'
     largeIconWidth=34
     largeIconHeight=45
     Description="A law enforcement tool for non-lethal crowd control."
     beltDescription="RUBBER"
     Skin=Texture'RSDCrap.Items.RubberShellBox'
     Mesh=LodMesh'HDTPItems.HDTPammoshell'
     CollisionRadius=9.300000
     CollisionHeight=10.210000
     bCollideActors=True
}
