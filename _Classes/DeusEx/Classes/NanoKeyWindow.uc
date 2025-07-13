//=============================================================================
// Nano Key Window
//=============================================================================

//SARGE: Designed to let us right-click on the nano-key window
//to select the nano-key

class NanoKeyWindow extends PersonaItemDetailWindow;

event bool MouseButtonPressed(float pointX, float pointY, EInputKey button, int numClicks)
{
    if (button == IK_RightMouse) //Sarge: Allow selecting NanoKey with right click.
        player.SelectNanokey();
}
