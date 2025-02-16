//=============================================================================
// FontMAnager
//=============================================================================

// SARGE: This is a relatively simple class that just holds a big list of fonts
// so that we can use "classic" fonts if we want to

class FontManager extends object;


var globalconfig bool bClassicFont; //Whether or not we're using the "Classic" fonts from the original game.

//Holds a list of the different "text types",
//so we can return the right fonts for them.

enum TextType
{
    TT_AmmoCount,
};

function Font GetFont(TextType TT)
{
    switch (TT)
    {
        case TT_AmmoCount: if (bClassicFont) return Font'FontTiny'; else return Font'TechMedium'; break;
    }
}
