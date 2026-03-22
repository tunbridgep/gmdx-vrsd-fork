//=============================================================================
// SARGE: A bigger version of the generic scrolling window
// Based off the CustomizeKeys and Playthrough Modifiers (RSD) menus
//=============================================================================

class MenuScreenListWindowBig expands MenuScreenListWindow;
	
var MenuUIScrollAreaWindow winScroll;

//SARGE: Add a scrolling text area
function CreateDescriptionWindow()
{
    //Create Scroll area Window
    winScroll = CreateScrollAreaWindow(winClient);
    winScroll.SetPos(DescriptionPos.X, DescriptionPos.Y);
    winScroll.SetSize(DescriptionSize.X, DescriptionSize.Y);

    winDesc = MenuUINormalLargeTextWindow(winScroll.ClipWindow.NewChild(Class'MenuUINormalLargeTextWindow'));
    winDesc.SetTextMargins(4, 2);
    winDesc.SetWordWrap(true);
    winDesc.SetTextAlignments(HALIGN_Left, VALIGN_Top);
    winDesc.SetText("");
}

function RefreshChoices()
{
    winScroll.Hide(); //Stop spamming messages during draw.
    super.RefreshChoices();
    winScroll.Show();
}

defaultproperties
{
     SearchPos=(X=26,Y=21)
     SearchSize=(X=160,Y=16)
     ScrollWindowPos=(X=26,Y=42)
     ScrollWindowSize=(X=178,Y=350)
     DescriptionPos=(X=220,Y=253)
     DescriptionSize=(X=379,Y=142)
     bHasHeaderButtons=false
     bHasImages=true
     bShowValueInHelp=true
     ClientWidth=639
     ClientHeight=432
     textureRows=2
     textureCols=3
     bShortHeaderButtons=false
     defaultHelpHeight=37
     colWidths(0)=160
     colWidths(1)=0
     clientTextures(0)=Texture'RSDCrap.UserInterface.PictureMenuBG01'
     clientTextures(1)=Texture'RSDCrap.UserInterface.PictureMenuBG02'
     clientTextures(2)=Texture'RSDCrap.UserInterface.PictureMenuBG03'
     clientTextures(3)=Texture'RSDCrap.UserInterface.PictureMenuBG04'
     clientTextures(4)=Texture'RSDCrap.UserInterface.PictureMenuBG05'
     clientTextures(5)=Texture'RSDCrap.UserInterface.PictureMenuBG06'
}
