class CloakManager extends Object;

//=============================================================================
// SARGE: CloakManager
// Manages cloaking and uncloaking
//=============================================================================

var private transient Pawn sourceObject;
var private travel bool bStartedCloaking;
var private travel bool bStartedUncloaking;
var private travel bool bIsCloaked;
var private travel bool bIsRadar;
var private travel float scaleGlow;
var private travel float targetScaleGlow;

var transient Texture glowTex;

var const float MinScaleGlow;

enum ESkinStyle
{
    SK_Normal,
    SK_Animated,
};
var private travel ESkinStyle skinStyle;

// ----------------------------------------------------------------------
// Init()
// ----------------------------------------------------------------------

function Init(Pawn src)
{
    sourceObject = src;
    scaleGlow = sourceObject.default.scaleGlow;
    glowTex = class'HDTPLoader'.static.GetTexture2("HDTPDecos.Skins.HDTPAlarmLightTex6","DeusExDeco.Skins.AlarmLightTex6",class'DeusExPlayer'.static.IsHDTPInstalled());
}

// ----------------------------------------------------------------------
// SetCloaked()
// Cloak needs to first "fade in" or "fade out", then it actually applies the effect
// ----------------------------------------------------------------------

function private _UpdateHDTP(Pawn P)
{
    if (DeusExPlayer(P) != None)
        DeusExPlayer(P).UpdateHDTPSettings();
    else if (ScriptedPawn(P) != None)
        ScriptedPawn(P).UpdateHDTPSettings();
}

function SetCloaked(bool bSet, bool bSound)
{
    if (bSet && !bStartedCloaking && !bIsCloaked)
    {
        bStartedCloaking = true;
        targetScaleGlow = MinScaleGlow;
        DoSpecialLighting(true);
        DoCorona();
        if (bSound)
            PlayCloakingSound(true);

        _UpdateHDTP(sourceObject);
    }
    else if (!bSet && !bStartedUncloaking && bIsCloaked)
    {
        ForceOff(bSound);
    }
}

function ForceOff(bool bSound)
{
    bStartedUncloaking = true;
    targetScaleGlow = sourceObject.default.scaleGlow;
    DoSpecialLighting(true);
    DoCorona();
    if (bSound)
        PlayCloakingSound(false);
    _UpdateHDTP(sourceObject);
}

// ----------------------------------------------------------------------
// SetRadar()
// Radar is very simple, it's instant
// ----------------------------------------------------------------------

function SetRadar(bool bSet)
{
    bIsRadar = bSet;
    PlayRadarSound(bSet);
    _UpdateHDTP(sourceObject);
}

// ----------------------------------------------------------------------
// GetCloakSkin()
// ----------------------------------------------------------------------

function Texture GetCurrentTexture()
{
    if (bIsCloaked)
        return Texture'RSDCrap.Skins.CloakingTex';
    else if (bIsRadar)
        return Texture'Effects.Electricity.Xplsn_EMPG';
    else
        return None;
}

function float GetScaleGlow()
{
    return ScaleGlow;
}

// ----------------------------------------------------------------------
// SelectCloakSkin()
// Allow users to select one of 2 cloak skins.
// 0 = standard "dotty" skin, non-animated.
// 1 = animated "whooshy" blue skin used by the player.
// More may be added at a future date.
// ----------------------------------------------------------------------

function SetSkinStyle(ESkinStyle skinID)
{
    skinStyle = skinID;
}

// ----------------------------------------------------------------------
// UpdateSkin()
// ----------------------------------------------------------------------

function UpdateSkin(optional Actor a)
{
    if (a == None)
        a = sourceObject;

    if (bIsRadar)
        class'SkinUtils'.static.SetSkinStyle(a,STY_Translucent, Texture'Effects.Electricity.Xplsn_EMPG', 0.4);
    else if (bIsCloaked && !bStartedUncloaking)
    {
        if (skinStyle == SK_Animated)
            class'SkinUtils'.static.SetSkinStyle(a, STY_Translucent, FireTexture'GameEffects.InvisibleTex');
        else
            //SARGE: Was previously using 'HDTPWeaponCrowbarTex2', vanilla used 'WhiteStatic'
            //Imported the high-quality one from HDTP, since WhiteStatic is WAY too visible!
            class'SkinUtils'.static.SetSkinStyle(a, STY_Translucent, Texture'RSDCrap.Skins.CloakingTex');
    }
    else if (bStartedCloaking || bStartedUncloaking)
        class'SkinUtils'.static.SetSkinStyle(a, STY_Translucent, glowTex);

    if (Pawn(A) != None)
        class'SkinUtils'.static.GlassesFix(Pawn(a));
}

/*
function UpdateSkin(optional bool bUpdateHDTP)
{
    _UpdateSkin(sourceObject,bUpdateHDTP);
    if (sourceObject.Weapon != None)
        _UpdateSkin(sourceObject.Weapon,bUpdateHDTP);
}


function private _UpdateSkin(Actor obj, optional bool bUpdateHDTP)
{
    if (bUpdateHDTP)
    {
        if (obj.IsA('DeusExPlayer'))
            DeusExPlayer(obj).UpdateHDTPSettings();
        else if (obj.IsA('ScriptedPawn'))
            ScriptedPawn(obj).UpdateHDTPSettings();
    }

    if (bIsRadar)
        class'SkinUtils'.static.SetSkinStyle(obj,STY_Translucent, Texture'Effects.Electricity.Xplsn_EMPG', 0.4);
    else if (bIsCloaked && !bStartedUncloaking)
        class'SkinUtils'.static.SetSkinStyle(obj, STY_Translucent, Texture'RSDCrap.Skins.CloakingTex');
    else if (bStartedCloaking || bStartedUncloaking)
        class'SkinUtils'.static.SetSkinStyle(obj, STY_Translucent);
            
    obj.ScaleGlow = scaleGlow;
}
*/

function bool IsInAnyState()
{
    return IsInTransientState() || IsCloaked() || IsRadar();
}

function bool IsInTransientState()
{
    return bStartedCloaking || bStartedUncloaking;
}

function bool IsCloaked()
{
    return bIsCloaked;
}

function bool IsRadar()
{
    return bIsRadar;
}

// ----------------------------------------------------------------------
// DoSpecialLighting()
// Does some fancy lighting effects on the source actor when we enable cloaking,
// and removes them when we are fully cloaked
// ----------------------------------------------------------------------
function DoSpecialLighting(bool bDoEffects)
{
    if (bDoEffects)
    {
        sourceObject.AmbientGlow = 255;
        sourceObject.LightType = LT_Strobe;
        sourceObject.LightBrightness = 64;
        sourceObject.LightHue = 160;
        sourceObject.LightSaturation = 96;
        sourceObject.LightRadius = 6;
    }
    else
    {
        sourceObject.AmbientGlow = sourceObject.default.AmbientGlow;
        sourceObject.LightType = sourceObject.default.LightType;
        sourceObject.LightBrightness = sourceObject.default.LightBrightness;
        sourceObject.LightHue = sourceObject.default.LightHue;
        sourceObject.LightSaturation = sourceObject.default.LightSaturation;
        sourceObject.LightRadius = sourceObject.default.LightRadius;
    }
}

function DoCorona()
{
    local ExplosionLight lite;
    local SpoofedCoronaSmall cor;

    lite = sourceObject.Spawn(class'ExplosionLight',,,sourceObject.Location);
    if (lite != none)
    {
        lite.LightHue=144;
        lite.LightSaturation=80;
        lite.size=6;
        lite.SetBase(sourceObject);
    }
        
    cor = sourceObject.Spawn(class'SpoofedCoronaSmall',,,sourceObject.Location);
    if (cor != none)
        cor.SetBase(sourceObject);
}

function SetShadowState(bool bShown)
{
    if (bShown)
    {
        if (DeusExPlayer(sourceObject) != None)
            DeusExPlayer(sourceObject).CreateShadow();
        else if (ScriptedPawn(sourceObject) != None)
            ScriptedPawn(sourceObject).CreateShadow();
    }
    else
    {
        if (DeusExPlayer(sourceObject) != None)
            DeusExPlayer(sourceObject).KillShadow();
        else if (ScriptedPawn(sourceObject) != None)
            ScriptedPawn(sourceObject).KillShadow();

    }
}

function PlayCloakingSound(bool bOnSound)
{
    if (bOnSound)
        sourceObject.PlaySound(Sound'CloakUp', SLOT_None, 0.85, ,768,1.0);
    else
        sourceObject.PlaySound(Sound'CloakDown', SLOT_None, 0.85, ,768,1.0);
}

function PlayRadarSound(bool bOnSound)
{
    if (bOnSound)
        sourceObject.PlaySound(Sound'GMDXSFX.Generic.Select', SLOT_None, 0.85, ,768,0.8);
    else
        sourceObject.PlaySound(Sound'biomodoff', SLOT_None, 0.85, ,768,1.0);
}

// ----------------------------------------------------------------------
// TickCloaking()
// Slowly darkens or brightens our model until we're ready, then sets full cloaking on
// ----------------------------------------------------------------------
function TickCloaking(float DeltaTime)
{
    if (bStartedCloaking)
    {
        scaleGlow -= DeltaTime;
        sourceObject.ScaleGlow -= DeltaTime;
        if (scaleGlow <= targetScaleGlow)
        {
            scaleGlow = targetScaleGlow;
            bStartedCloaking = false;
            bIsCloaked = true;
            DoSpecialLighting(false);
            SetShadowState(false);
            _UpdateHDTP(sourceObject);
        }
    }
    else if (bStartedUncloaking)
    {
        scaleGlow += DeltaTime;
        sourceObject.ScaleGlow += DeltaTime;
        if (scaleGlow >= targetScaleGlow)
        {
            scaleGlow = targetScaleGlow;
            bStartedUncloaking = false;
            bIsCloaked = false;
            DoSpecialLighting(false);
            SetShadowState(true);
            _UpdateHDTP(sourceObject);
        }
    }
}

defaultproperties
{
    MinScaleGlow=0.25
}
