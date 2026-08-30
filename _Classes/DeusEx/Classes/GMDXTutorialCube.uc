//=============================================================================
// GMDXTutorialCube //CyberP: simple display text. Doesn't fuck around with text packages
// SARGE: Now not a total piece of shit
//=============================================================================
class GMDXTutorialCube extends DataCube;

//These are offset by 1
//We really should use an int here, instead of an enum,
//but the original GMDX implementation absolutely sucked, and I don't
//want to have to go through every map and change the datacubes to use the right numbers.
//So, we will just add to this instead. Ugh....
enum EHackText
{
	HText1,
	HText2,
	HText3,
	HText4,
	HText5,
	HText6,
	HText7,
	HText8,
	HText9,
	HText10,
	HText11,
	HText12,
	HText13,
	HText14,
	HText15,
	HText16,
	HText17,
	HText18,
	HText19,
	HText20,
	HText21,
	HText22,
	HText23,
	HText24,
	HText25,
	HText26,
	HText27,
	HText28,
	HText29,
};

var() EHackText HackText;

function bool DarkenScreen()
{
    if (textTag == '')
        return false; //Not configured yet

    return bRead && !bSkipDarkenCheck;
}

function SetupDifficultyMod(DeusExPlayer P)
{
    UpdateTextTag(P);
	super.SetupDifficultyMod(P);
}

//We need to do this
function UpdateTextTag(DeusExPlayer player)
{
    local string str;

    //Figure out our texttag based on our passed in HackText
    //This is a holdover from GMDX v9 where it used strings instead of a text package.
    if (textTag == '')
    {
        if (player != None && player.flagBase != None)
        {
            str = "Datacube";

            if (HackText < 10)
                str = str $ "0";

            str = str $ int(HackText);

            textTag = player.flagBase.StringToName(str);
        }
    }
}

defaultproperties
{
    TextPackage="GMDXText"

}
