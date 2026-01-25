//=============================================================================
// FontMAnager
//=============================================================================

// SARGE: This is a relatively simple class that just holds a big list of fonts
// so that we can use "classic" fonts if we want to

class FontManager extends object;


var globalconfig bool bClassicFont; //Whether or not we're using the "Classic" fonts from the original game.

var globalconfig bool bDXRandoFonts; //Use the DXRando fonts provided by TheAstropath

var globalconfig bool bBigDatacubeFont; //Use the TechMedium font for datacubes and other readable objects

//Holds a list of the different "text types",
//so we can return the right fonts for them.

enum TextType
{
    //Special Cases for Classic Fonts
    TT_AmmoCount,
    TT_DamageAbsorb,
    TT_AugHotKey,
    TT_MainMenu,
    TT_DataCube,

    //Implement DXRandoFonts
    TT_FontComputer8x20_A,
    TT_FontComputer8x20_B,
    TT_FontComputer8x20_C,
    TT_FontConversation,
    TT_FontConversationBold,
    TT_FontConversationLarge,
    TT_FontConversationLargeBold,
    TT_FontFixedWidthLocation,
    TT_FontFixedWidthSmall,
    TT_FontFixedWidthSmall_DS,
    TT_FontHUDWingDings,
    TT_FontLocation,
    TT_FontMenuExtraLarge,
    TT_FontMenuHeaders,
    TT_FontMenuHeaders_DS,
    TT_FontMenuSmall,
    TT_FontMenuSmall_DS,
    TT_FontMenuTitle,
    TT_FontSansSerif_8,
    TT_FontSansSerif_8_Bold,
    TT_FontTiny,
    TT_FontTitleLarge,
    TT_TechMedium,
    TT_TechMedium_B,
    TT_TechMedium_DS,
    //TT_TechMediumFix,
    //TT_TechMediumFix_B,
    //TT_TechMediumFix_DS,
    TT_TechSmall,
    TT_TechSmall_DS,
    //TT_TechSmallFix,
    //TT_TechSmallFix_DS,
    TT_TechTiny,

};

//This fucking sucks.
//Helper function to select a font
function private Font GetFontSelection(Font regularfont, optional Font classicfont, optional Font randofont, optional Font randoclassic)
{
    if (bDXRandoFonts && bClassicFont && randoclassic != None)
        return randoclassic;
    else if (bClassicFont && classicfont != None)
        return classicfont;
    else if (bDXRandoFonts && randofont != None)
        return randofont;
    return regularfont;
}

function Font GetFont(TextType TT)
{
    switch (TT)
    {
        //DXRando Fonts
        case TT_FontComputer8x20_A:
            return GetFontSelection(Font'FontComputer8x20_A',,Font'RSDCrap.DXRFontComputer8x20_A');
        case TT_FontComputer8x20_B:
            return GetFontSelection(Font'FontComputer8x20_B',,Font'RSDCrap.DXRFontComputer8x20_B');
        case TT_FontComputer8x20_C:
            return GetFontSelection(Font'FontComputer8x20_C',,Font'RSDCrap.DXRFontComputer8x20_C');
        case TT_FontConversation:
            return GetFontSelection(Font'FontConversation',,Font'RSDCrap.DXRFontConversation');
        case TT_FontConversationBold:
            return GetFontSelection(Font'FontConversationBold',,Font'RSDCrap.DXRFontConversationBold');
        case TT_FontConversationLarge:
            return GetFontSelection(Font'FontConversationLarge',,Font'RSDCrap.DXRFontConversationLarge');
        case TT_FontConversationLargeBold:
            return GetFontSelection(Font'FontConversationLargeBold',,Font'RSDCrap.DXRFontConversationLargeBold');
        case TT_FontFixedWidthLocation:
            return GetFontSelection(Font'FontFixedWidthLocation',,Font'RSDCrap.DXRFontFixedWidthLocation');
        case TT_FontFixedWidthSmall:
            return GetFontSelection(Font'FontFixedWidthSmall',,Font'RSDCrap.DXRFontFixedWidthSmall');
        case TT_FontFixedWidthSmall_DS:
            return GetFontSelection(Font'FontFixedWidthSmall_DS',,Font'RSDCrap.DXRFontFixedWidthSmall_DS');
        case TT_FontHUDWingDings:
            return GetFontSelection(Font'FontHUDWingDings',,Font'RSDCrap.DXRFontHUDWingDings');
        case TT_FontLocation:
            return GetFontSelection(Font'FontLocation',,Font'RSDCrap.DXRFontLocation');
        case TT_FontMenuExtraLarge:
            return GetFontSelection(Font'FontMenuExtraLarge',,Font'RSDCrap.DXRFontMenuExtraLarge');
        case TT_FontMenuHeaders:
            return GetFontSelection(Font'DeusExUI.FontMenuHeaders',,Font'RSDCrap.DXRFontMenuHeaders');
        case TT_FontMenuHeaders_DS:
            return GetFontSelection(Font'DeusExUI.FontMenuHeaders_DS',,Font'RSDCrap.DXRFontMenuHeaders_DS');
        case TT_FontMenuSmall:
            return GetFontSelection(Font'FontMenuSmall',,Font'RSDCrap.DXRFontMenuSmall');
        case TT_FontMenuSmall_DS:
            return GetFontSelection(Font'FontMenuSmall_DS',,Font'RSDCrap.DXRFontMenuSmall_DS');
        case TT_FontMenuTitle:
            return GetFontSelection(Font'FontMenuTitle',,Font'RSDCrap.DXRFontMenuTitle');
        case TT_FontSansSerif_8:
            return GetFontSelection(Font'FontSansSerif_8',,Font'RSDCrap.DXRFontSansSerif_8');
        case TT_FontSansSerif_8_Bold:
            return GetFontSelection(Font'FontSansSerif_8_Bold',,Font'RSDCrap.DXRFontSansSerif_8_Bold');
        case TT_FontTiny:
            return GetFontSelection(Font'FontTiny',,Font'RSDCrap.DXRFontTiny');
        case TT_FontTitleLarge:
            return GetFontSelection(Font'FontTitleLarge',,Font'RSDCrap.DXRFontTitleLarge');
        case TT_TechMedium:
            return GetFontSelection(Font'TechMedium',,Font'RSDCrap.DXRTechMedium');
        case TT_TechMedium_B:
            return GetFontSelection(Font'TechMedium_B',,Font'RSDCrap.DXRTechMedium_B');
        case TT_TechMedium_DS:
            return GetFontSelection(Font'TechMedium_DS',,Font'RSDCrap.DXRTechMedium_DS');
        //case TT_TechMediumFix:
        //    return GetFontSelection(Font'TechMediumFix',,Font'RSDCrap.DXRTechMediumFix');
        //case TT_TechMediumFix_B:
        //    return GetFontSelection(Font'TechMediumFix_B',,Font'RSDCrap.DXRTechMediumFix_B');
        //case TT_TechMediumFix_DS:
        //    return GetFontSelection(Font'TechMediumFix_DS',,Font'RSDCrap.DXRTechMediumFix_DS');
        case TT_TechSmall:
            return GetFontSelection(Font'TechSmall',,Font'RSDCrap.DXRTechSmall');
        case TT_TechSmall_DS:
            return GetFontSelection(Font'TechSmall_DS',,Font'RSDCrap.DXRTechSmall_DS');
        //case TT_TechSmallFix:
        //    return GetFontSelection(Font'TechSmallFix',,Font'RSDCrap.DXRTechSmallFix');
        //case TT_TechSmallFix_DS:
        //    return GetFontSelection(Font'TechSmallFix_DS',,Font'RSDCrap.DXRTechSmallFix_DS');
        case TT_TechTiny:
            return GetFontSelection(Font'TechTiny',,Font'RSDCrap.DXRTechTiny');


        //Special Cases for Classic Fonts
        case TT_DataCube:
            if (bBigDatacubeFont)
                return GetFontSelection(Font'FontMenuTitle',,Font'RSDCrap.DXRFontMenuTitle');
            else
                return GetFontSelection(Font'FontMenuSmall',,Font'RSDCrap.DXRFontMenuSmall');
        case TT_AmmoCount:
        case TT_DamageAbsorb:
            return GetFontSelection(Font'TechMedium',Font'FontTiny',Font'RSDCrap.DXRTechMedium',Font'RSDCrap.DXRFontTiny');
        case TT_AugHotKey:
            return GetFontSelection(Font'FontMenuSmall',Font'FontTiny',Font'RSDCrap.DXRFontMenuSmall',Font'RSDCrap.DXRFontTiny');
        case TT_MainMenu:
            return GetFontSelection(Font'DeusExUI.FontConversationLarge',Font(DynamicLoadObject("DXFonts.MainMenuTrueType", class'Font')),Font'RSDCrap.DXRFontConversationLarge');
    }
}

function float GetTextPosition(float pos1, float pos2)
{
    if (bClassicFont)
        return pos2;
    else
        return pos1;
}

defaultproperties
{
    bClassicFont=True
    bDXRandoFonts=True
    bBigDatacubeFont=True
}
