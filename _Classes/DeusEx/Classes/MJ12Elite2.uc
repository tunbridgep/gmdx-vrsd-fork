//=============================================================================
// MJ12Elite2.
// SARGE: Some of the maps had these weird franken-troops,
// so I decided to make a proper class for them
// These guys are a bit weaker, but have proper stealth capabilities.
//=============================================================================
class MJ12Elite2 extends MJ12Elite;

function DifficultyMod(float CombatDifficulty, bool bHardCoreMode, bool bExtraHardcore, bool bFirstLevelLoad) //RSD: New function to streamline NPC stat difficulty modulation
{
    Super.DifficultyMod(CombatDifficulty, bHardCoreMode, bExtraHardcore, bFirstLevelLoad);

    if (!bHardCoreMode)
    {
        if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
        {
            default.Health=150;
            default.HealthHead=150;
            default.HealthTorso=150;
            default.HealthLegLeft=130;
            default.HealthLegRight=130;
            default.HealthArmLeft=130;
            default.HealthArmRight=130;
            Health=150;
            HealthHead=150;
            HealthTorso=150;
            HealthLegLeft=150;
            HealthLegRight=150;
            HealthArmLeft=150;
            HealthArmRight=150;
        }
        CloakThreshold=100;
        GroundSpeed=220.000000;
        //SurprisePeriod=1.000000;
    }
    else
    {
        if (bFirstLevelLoad || !bNotFirstDiffMod)                       //RSD: Only alter health if it's the first time loading the map
        {
            default.Health=200;
            default.HealthHead=200;
            default.HealthTorso=200;
            default.HealthLegLeft=150;
            default.HealthLegRight=150;
            default.HealthArmLeft=150;
            default.HealthArmRight=150;
            Health=200;
            HealthHead=200;
            HealthTorso=200;
            HealthLegLeft=150;
            HealthLegRight=150;
            HealthArmLeft=150;
            HealthArmRight=150;
        }
        CloakThreshold=140;
        //GroundSpeed=220.000000;
    }
    super.DifficultyMod(CombatDifficulty,bHardCoreMode,bExtraHardcore,bFirstLevelLoad);
}

defaultproperties
{
    BaseAccuracy=0.060000
    Health=200
    Die=Sound'GMDXSFX.Human.Death06'
    HealthHead=200
    HealthTorso=200
    HealthLegLeft=200
    HealthLegRight=200
    HealthArmLeft=200
    HealthArmRight=200
    VisibilityThreshold=0.002500
    HearingThreshold=0.100000
    EnemyTimeout=12.000000
    //MultiSkins(3)=Texture'DeusExCharacters.Skins.MiscTex1'
    MultiSkins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
    MultiSkins(6)=Texture'GMDXSFX.Skins.MJ12TroopTex9'
    CarcassType=Class'DeusEx.MJ12TroopCarcassElite2'
    BindName="MJ12Troop"
    FamiliarName="MJ12 Shock Trooper"
    UnfamiliarName="MJ12 Shock Trooper"
    fireReactTime=0.35
}
