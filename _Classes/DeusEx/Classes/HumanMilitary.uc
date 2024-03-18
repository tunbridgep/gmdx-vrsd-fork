//=============================================================================
// HumanMilitary.
//=============================================================================
class HumanMilitary extends ScriptedPawn
	abstract;

function PostBeginPlay()
{
local DeusExPlayer player;

	Super.PostBeginPlay();

    if (Style != STY_Translucent)
       bReactCarcass = True;  //CyberP: all except holograms react to carc now
    else if (Style == STY_Translucent || IsA('WaltonSimons')) //CyberP/|Totalitarian|: Holograms don't run away from projectiles, neither does Walt
       bAvoidHarm = False;
    //player = DeusExPlayer(GetPlayerPawn());

    if (FRand() < 0.4 && !IsA('MIB') && !IsA('MJ12Commando') && !IsA('AnnaNavarre') && !IsA('WaltonSimons'))
      bDefensiveStyle = True; //CyberP: many pawns play a more defensive combat role when in close proximity

    if (bCanStrafe && !bDefendHome)  //CyberP: get them to move more.
    bAvoidAim = True;

    if (RotationRate.Yaw != 90000)
        RotationRate.Yaw = 90000; //CyberP: turn faster

    if (!(GetStateName() == 'Seeking' || GetStateName() == 'Attacking') && bCloakOn) //RSD: Failsafe for cloaked enemies on load
        ForceCloakOff();
}

function bool WillTakeStompDamage(actor stomper)
{
	// This blows chunks!
	if (stomper.IsA('PlayerPawn') && (GetPawnAllianceType(Pawn(stomper)) != ALLIANCE_Hostile))
		return false;
	else
		return true;
}

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
         if (CombatDifficulty <= 1)
         {
         if (VisibilityThreshold < 0.010000)
             VisibilityThreshold = 0.010000;
         if (HearingThreshold < 0.150000)
             HearingThreshold = 0.150000;
             EnemyTimeout = 8.000000;
         if (SurprisePeriod < 2.000000)
             SurprisePeriod = 2.0;
         if (smartStrafeRate == default.smartStrafeRate)
             smartStrafeRate = default.smartStrafeRate*0.75;
         }
         else if (CombatDifficulty <= 2)
         {
         if (HearingThreshold < 0.145000)
             HearingThreshold = 0.145000;
         if (SurprisePeriod < 1.50000)
             SurprisePeriod = 1.500000;
             EnemyTimeout = 9.000000;
         if (VisibilityThreshold != 0.007000)
             VisibilityThreshold = 0.007000;
         if (smartStrafeRate == default.smartStrafeRate)
             smartStrafeRate = default.smartStrafeRate*0.75;
         }
         else if (!bHardCoreMode && CombatDifficulty <= 4.000000)
         {
         if (HearingThreshold < 0.145000)
             HearingThreshold = 0.145000;
         if (SurprisePeriod < 1.000000)
             SurprisePeriod = 1.0+(FRand()*0.4);
             EnemyTimeout = 10.000000;
         if (VisibilityThreshold != 0.006000)
             VisibilityThreshold = 0.006000;
         }
         else if (bHardCoreMode)
         {
         if (BaseAccuracy != 0.000000 && BaseAccuracy != 2.000000 && BaseAccuracy > 0.050000) //CyberP: all Human Military are more accurate on hardcore mode.
             BaseAccuracy=0.050000;
         EnemyTimeout = 11.000000;
         if (bDefendHome && HomeExtent < 64)
             EnemyTimeOut = 16.000000;  //CyberP: camp for longer
         if (HearingThreshold < 0.135000)
             HearingThreshold = 0.135000;
         if (VisibilityThreshold != 0.005000)
             VisibilityThreshold = 0.005000;
         SurprisePeriod = 0.5+(FRand()*0.6);
         if (Weapon != None && Weapon.IsA('WeaponMiniCrossbow'))
             BaseAccuracy=0.000000;
         else if (IsA('MJ12Commando'))
             HearingThreshold = 0.125000;
         }
         bNotFirstDiffMod = true;
}

defaultproperties
{
     BaseAccuracy=0.100000
     maxRange=2000.000000
     MinHealth=20.000000
     bPlayIdle=True
     bCanCrouch=True
     bSprint=True
     CrouchRate=0.300000
     SprintRate=1.000000
     CloseCombatMult=0.550000
     bReactAlarm=True
     EnemyTimeout=14.000000
     bCanTurnHead=True
     smartStrafeRate=0.450000
     WaterSpeed=80.000000
     AirSpeed=160.000000
     AccelRate=500.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'GMDXSFX.Human.PainSmall04'
     Die=Sound'DeusExSounds.Player.MaleDeath'
     VisibilityThreshold=0.003000
     DrawType=DT_Mesh
     Mass=150.000000
     Buoyancy=155.000000
     BindName="HumanMilitary"
}
