//=============================================================================
// AmmoSabot.
//=============================================================================
class AmmoSabot extends DeusExAmmo;

var bool bWaitForIt;

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
		   if (DeusExPlayer(Owner).IsCrouching())
               offset.Z -= 7;
           else
               offset.Z -= 4;
        }
        shell = spawn(class'ShellCasing2',,, Owner.Location + offset,Pawn(Owner).viewrotation);

		if (shell != None)
		{
			shell.Velocity = (FRand()*20+90) * Y + (10-FRand()*20) * X;
			shell.Velocity.Z = 20;
			shell.MultiSkins[0]=Texture'RSDCrap.Items.SabotShell';
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
      if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
      {
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
			shell.MultiSkins[0]=Texture'RSDCrap.Items.SabotShell';
         shell.ImpactSound=Sound'RSDCrap.Weapons.ShellCaseSound';
			shell.MiscSound=Sound'RSDCrap.Weapons.ShellCaseSound';
		}
		return True;
	}
    if (bWaitForIt == True)
	{ SetTimer(0.5,False); return True; }
	return False;
}

exec function UpdateHDTPsettings()
{
    super.UpdateHDTPsettings();
    if (IsHDTP())
        MultiSkins[1]=class'HDTPLoader'.static.GetTexture("RSDCrap.Items.SabotShellBox");
    else
        MultiSkins[1]=None;
}

defaultproperties
{
     bShowInfo=True
     ammoSkill=Class'DeusEx.SkillWeaponRifle'
     AmmoAmount=8
     MaxAmmo=30
     ItemName="12 Gauge Sabot Shells"
     ItemArticle="some"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoSabot'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoSabot'
     largeIconWidth=35
     largeIconHeight=46
     Description="A 12 gauge shotgun shell surrounding a solid core of tungsten that can punch through all but the thickest hardened steel armor at close range."
     beltDescription="SABOT"
     Skin=Texture'DeusExItems.Skins.AmmoShellTex2'
     HDTPSkin="RSDCrap.Items.SabotShellBox"
     HDTPMesh="HDTPItems.HDTPammoshell"
     Mesh=LodMesh'DeusExItems.AmmoShell'
     CollisionRadius=9.300000
     CollisionHeight=10.210000
     bCollideActors=True
}
