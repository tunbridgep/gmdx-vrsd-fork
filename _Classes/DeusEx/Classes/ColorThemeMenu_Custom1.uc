//=============================================================================
// ColorThemeMenu_Earth
//=============================================================================

class ColorThemeMenu_Custom1 extends ColorThemeMenu;

/*
   Colors!

	colors(0)  = MenuColor_Background
	colors(1)  = MenuColor_TitleBackground
	colors(2)  = MenuColor_TitleText
	colors(3)  = MenuColor_ButtonFace
	colors(4)  = MenuColor_ButtonTextNormal
	colors(5)  = MenuColor_ButtonTextFocus
	colors(6)  = MenuColor_ButtonTextDisabled
	colors(7)  = MenuColor_HeaderText
	colors(8)  = MenuColor_NormalText
	colors(9)  = MenuColor_ListText
	colors(10) = MenuColor_ListHighlight
	colors(11) = MenuColor_ListFocus

*/
/*var int colorCounter;

function PostBeginPlay()
{
super.PostBeginPlay();

  retrieveColor();
}

function retrieveColor()
{
local int i;

colorCounter = arrayCount(colors);

for (i=0;i<ArrayCount(player.customColor);i++)
    {
       //for (j=0;j<ArrayCount(Colors);i++)
        //Colors[j]= player.customColor[i];
        SetColor(colorCounter, player.customColor[i]);
        if (colorCounter < 15)
            colorCounter++;
     }
}

function SetColor(Int colorIndex, Color newColor)
{
	if ((colorIndex >= 0) && (colorIndex < arrayCount(colorNames)))
	{
		colors[colorIndex] = newColor;
	}
}         */
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     themeName="CustomMenu"
     Colors(0)=(B=255)
     Colors(1)=(G=49,B=255)
     Colors(2)=(R=210,G=194,B=255)
     Colors(3)=(R=77,G=77,B=77)
     Colors(4)=(R=185,G=185,B=185)
     Colors(5)=(R=255,G=255,B=255)
     Colors(6)=(R=86,G=38,B=24)
     Colors(7)=(R=206,G=206,B=202)
     Colors(8)=(R=204,G=198,B=201)
     Colors(9)=(R=255)
     Colors(10)=(G=255)
     Colors(11)=(R=255,G=64)
     Colors(12)=(G=255)
     Colors(13)=(R=32,G=48,B=255)
}
