//=============================================================================
// Cigarettes.
//=============================================================================
class Cigarettes extends Vice; //DeusExPickup;

//enum ECigType
//{
//	SC_Default,
//	SC_BigTop
//};


//var() ECigType Cig;

var bool bDontUse;

function SetSkin()
{
	switch(textureSet)
	{
			case 0:		Skin = default.skin; description = default.description; icon = default.icon; largeicon = default.largeicon; break;
			case 1:		Skin = Texture'HDTPitems.Skins.HDTPcigarettesTex2'; Description = "Big Top Cigarettes -- Elephant tested, Lion Approved!"; icon = texture'HDTPitems.skins.belticonCigarettes2'; largeicon = texture'HDTPitems.skins.largeiconCigarettes2'; break;
			default:	Skin = default.skin; description = default.description; icon = default.icon; largeicon = default.largeicon; break;
	}
	super.SetSkin();
}





state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local Pawn P;
		local vector loc;
		local rotator rot;
		local SmokeTrail puff;
		local DeusExPlayer playa;

		Super.BeginState();


      if (bDontUse)
      {
        playa = DeusExPlayer(GetPlayerPawn());
        if (playa!=none)
        {
        loc = playa.Location;
		rot = playa.Rotation;
		if (!playa.bAddictionSystem)                                            //RSD: Only deal damage without addiction system
		{
        if (playa.HealthTorso > 4)                                              //RSD: Cigs can't kill you like below (for crash fix)
        	playa.TakeDamage(2, playa, loc, vect(0,0,0), 'PoisonGas');
        PlaySound(sound'MaleCough');
        }
        loc += 2.0 * playa.CollisionRadius * vector(playa.ViewRotation);
		loc.Z += playa.CollisionHeight * 0.9;
        puff = Spawn(class'SmokeTrail', playa,, loc, rot);
			if (puff != None)
			{
				puff.DrawScale = 1.2;
				puff.origScale = puff.DrawScale;
			}
			bDontUse=false;
			Destroy();
		  }
		}

        playa = DeusExPlayer(GetPlayerPawn());
		if (playa != None)
		{
			loc = playa.Location;
			rot = playa.Rotation;
			loc += 2.0 * playa.CollisionRadius * vector(playa.ViewRotation);
			loc.Z += playa.CollisionHeight * 0.9;
			puff = Spawn(class'SmokeTrail', playa,, loc, rot);
			if (puff != None)
			{
				puff.DrawScale = 1.0;
				puff.origScale = puff.DrawScale;
			}
			if (!playa.bAddictionSystem)                                        //RSD: Only deal damage without addiction system
			{
			PlaySound(sound'MaleCough');
            if (playa.HealthTorso > 4 || !playa.bRealUI || !playa.bHardCoreMode)//RSD: Dunno why it was !bRealUI, but I added !bHardcoreMode to match (maybe crash bug?)
			    playa.TakeDamage(2, playa, playa.Location, vect(0,0,0), 'PoisonGas');
			}
		}
		if (playa != None && !playa.IsInState('Dying'))
		    UseOnce();
	}
Begin:
}

defaultproperties
{
     AddictionType=0
     AddictionIncrement=20.000000
     MaxDrugTimer=120.000000
     bHasMultipleSkins=True
     bBreakable=True
     FragType=Class'DeusEx.PaperFragment'
     maxCopies=5
     ItemName="Cigarettes"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Cigarettes'
     PickupViewMesh=LodMesh'DeusExItems.Cigarettes'
     ThirdPersonMesh=LodMesh'DeusExItems.Cigarettes'
     Icon=Texture'DeusExUI.Icons.BeltIconCigarettes'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCigarettes'
     largeIconWidth=29
     largeIconHeight=43
     Description="'COUGHING NAILS -- when you've just got to have a cigarette.'"
     beltDescription="CIGS"
     Skin=Texture'HDTPItems.Skins.HDTPCigarettestex1'
     Mesh=LodMesh'DeusExItems.Cigarettes'
     CollisionRadius=5.200000
     CollisionHeight=1.320000
     Mass=2.000000
     Buoyancy=3.000000
}
