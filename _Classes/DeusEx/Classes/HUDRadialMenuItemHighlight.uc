//-----------------------------------------------------------
// HUDRadialMenuItemHighlight
//-----------------------------------------------------------
class HUDRadialMenuItemHighlight extends Window;


var Color col;
var EDrawStyle borderStyle;
var Texture borderTex;

event InitWindow() {
	  Super.InitWindow();
}


event DrawWindow(GC gc) {
	  drawBorder(gc);
}


function drawBorder(GC gc) {

	gc.SetTileColor(col);
	gc.SetStyle(borderStyle);
	gc.SetAlignments(HALIGN_Left, VALIGN_Top);
	gc.DrawBox(0,0,width, height, 0,0,1, borderTex);

}
/*
function drawDot(GC gc) {
	gc.SetTileColor(col);
	gc.SetStyle(dotStyle);
	gc.SetAlignments(HALIGN_Left, VALIGN_Top);
	gc.DrawIcon(0,0,dotTex);
}
*/

defaultproperties
{
     col=(R=255,G=255,B=255)
     borderStyle=DSTY_Translucent
     borderTex=Texture'Extension.Solid'
}
