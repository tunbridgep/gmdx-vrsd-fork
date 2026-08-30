//=============================================================================
// DataCubeNG+.
// A special data cube that allows us to access NewGamePlus.
//=============================================================================
class DataCubeNGPlus extends DataCube;

function OnEndRead(DeusExPlayer reader)
{
    reader.DisplayNewGamePlusMessage(true);
}

defaultproperties
{
    TextPackage="GMDXText"
    textTag="DatacubeNGPlus"
    bAddToVault=false
}
