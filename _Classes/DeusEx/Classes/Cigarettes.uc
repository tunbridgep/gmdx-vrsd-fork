//=============================================================================
// Cigarettes.
//=============================================================================
class Cigarettes extends Vice; //DeusExPickup;

var localized string Description2;

function SetSkin()
{
    Skin = default.skin;
    Description = default.Description;
    Icon = default.Icon;
    LargeIcon = default.LargeIcon;

    switch(textureSet)
    {
        case 0: break; //Handled by UpdateHDTPSettings
        case 1: //Big Top
            Skin = class'HDTPLoader'.static.GetTexture2("RSDCrap.Skins.HDTPCigarettestex2","RSDCrap.Skins.Cigarettestex2",IsHDTP());
            Description = Description2;
            //TODO: Port these across
            if (IsHDTP())
            {
                Icon = class'HDTPLoader'.static.GetTexture("HDTPitems.skins.belticonCigarettes2");
                LargeIcon = class'HDTPLoader'.static.GetTexture("HDTPitems.skins.largeiconCigarettes2");
            }
            break;
        case 2: //Holy Smokes!
            Skin = class'HDTPLoader'.static.GetTexture2("RSDCrap.Skins.HDTPCigarettestex3","RSDCrap.Skins.Cigarettestex3",IsHDTP());
    }
	super.SetSkin();
}

function Eat(DeusExPlayer player)
{
    local vector loc;
    local rotator rot;
    local SmokeTrail puff;
    local Sound coughSound;

    loc = player.Location;
    rot = player.Rotation;
    loc += 2.0 * player.CollisionRadius * vector(player.ViewRotation);
    loc.Z += player.CollisionHeight * 0.9;
    puff = Spawn(class'SmokeTrail', player,, loc, rot);
    if (puff != None)
    {
        puff.DrawScale = 1.0;
        puff.origScale = puff.DrawScale;
    }

    if (Player.FlagBase.GetBool('LDDPJCIsFemale'))
        CoughSound = Sound(DynamicLoadObject("FemJC.FJCCough", class'Sound', false));
    else
        CoughSound = sound'MaleCough';
    
    PlaySound(CoughSound);

    if (!player.bAddictionSystem)                                        //RSD: Only deal damage without addiction system
    {
        if (player.HealthTorso > 4 || !player.bRealUI || !player.bHardCoreMode) //RSD: Dunno why it was !bRealUI, but I added !bHardcoreMode to match (maybe crash bug?)
            player.TakeDamage(2, player, player.Location, vect(0,0,0), 'PoisonGas');
    }
    if (!player.IsInState('Dying'))
        UseOnce();
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
     Description2="Big Top Cigarettes -- Elephant tested, Lion Approved!"
     beltDescription="CIGS"
     Mesh=LodMesh'DeusExItems.Cigarettes'
     CollisionRadius=5.200000
     CollisionHeight=1.320000
     Mass=2.000000
     Buoyancy=3.000000
}
