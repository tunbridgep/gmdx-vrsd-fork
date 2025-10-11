//=============================================================================
// SignFloor.
//=============================================================================
class SignFloor extends DeusExDecoration;

var() bool bSparta;                       //SARGE: If shenanigans are enabled, turn into the Sparta sign //SARGE: Unused but might re-enable it??

var bool bRolledSparta;                   //Roll for sparta only once per map load.

function PostBeginPlay()
{
    Super.PostBeginPlay();
    bRolledSparta = FRand() <= 0.05 /*|| bSparta*/;
}

exec function UpdateHDTPsettings()
{
    local DeusExPlayer player;

    player = DeusExPlayer(GetPlayerPawn());

    if (bRolledSparta && player != None && player.bShenanigans) //5% chance of sparta signs in shenanigans mode.
    {
        bHDTPFailsafe = false;
        Super.UpdateHDTPsettings();
        Skin = class'HDTPLoader'.static.GetTexture2("RSDCrap.Skins.HDTPSpartaSign","RSDCrap.Skins.SpartaSign",IsHDTP());
    }
    else
        Super.UpdateHDTPsettings();

}

defaultproperties
{
     FragType=Class'DeusEx.PlasticFragment'
     ItemName="Caution Sign"
     HDTPMesh="HDTPDecos.HDTPSignfloor"
     Mesh=LodMesh'DeusExDeco.SignFloor'
     CollisionRadius=12.500000
     CollisionHeight=15.380000
     Mass=20.000000
     Buoyancy=12.000000
}
