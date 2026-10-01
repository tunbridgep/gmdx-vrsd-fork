//=============================================================================
// MenuScreenOptions
//=============================================================================

class MenuScreenGMDXOptionsPerkConfig expands MenuScreenListWindow;

var const localized string strGeneral;

function CreateChoices()
{
    local int i, n;
    local PerkSystem PS;
    local Perk P;
    local string str;

    //Add each perk as an item
    if (player != None && player.PerkManager != None)
    {
        PS = player.PerkManager;
        for (i = 0;i < PS.GetNumPerks();i++)
        {
            P = PS.GetPerkAtIndex(i);
            if (P == None || P.bHidden)
                continue;

            if (P.PerkSkill == None)
                str = strGeneral;
            else
                str = P.PerkSkill.default.SkillName;

            items[n].actionText = str $ ": " $ P.PerkName;
            items[n].helpText = P.PerkDescription;
            items[n].consoleTarget = string(P.Class);
            items[n].variable = "bPerkEnabled";
            items[n].defaultValue = int(P.default.bPerkEnabled);
            n++;
        }
    }

    super.CreateChoices();
}

function SaveSettings()
{
    local int i;
    local PerkSystem PS;
    local Perk P;

    super.SaveSettings();

    //Add each perk as an item
    if (player != None && player.PerkManager != None)
    {
        PS = player.PerkManager;
        for (i = 0;i < PS.GetNumPerks();i++)
        {
            P = Ps.GetPerkAtIndex(i);
            if (P == None)
                continue;

            P.SaveConfig();
        }
    }
}

defaultproperties
{
     Title="GMDX Perk Config"
     colWidths(0)=214
     colWidths(1)=155
     bShowDefaults=true
     bShortHeaderButtons=false
     clientTextures(0)=Texture'RSDCrap.UserInterface.MenuQoLBackground_1'
     clientTextures(1)=Texture'RSDCrap.UserInterface.MenuQoLBackground_2'
     clientTextures(2)=Texture'RSDCrap.UserInterface.MenuQoLBackground_3'
     clientTextures(3)=Texture'RSDCrap.UserInterface.MenuQoLBackground_4'
     DescriptionPos=(X=8,Y=305)
     SearchPos=(X=224,Y=0)
     SearchSize=(X=140,Y=16)
     strGeneral="General"
}
