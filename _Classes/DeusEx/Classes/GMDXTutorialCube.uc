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

//We need to do this
function UpdateTextTag()
{
    local DeusExPlayer player;
    local string str;
    super.PostPostBeginPlay();

    //Figure out our texttag based on our passed in HackText
    //This is a holdover from GMDX v9 where it used strings instead of a text package.
    if (textTag == '')
    {
        player = DeusExPlayer(GetPlayerPawn());
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

function Tick(float deltaTime)
{
    UpdateTextTag();
    super.Tick(deltaTime);
}

defaultproperties
{
    //datacubeTitles(0)=(textTag="GMDXText.Datacube00",replacement="Important Information")
    datacubeTitles(1)=(textTag="GMDXText.Datacube01",replacement="Swimming Tips")
    datacubeTitles(2)=(textTag="GMDXText.Datacube02",replacement="Ladder Jumping")
    datacubeTitles(3)=(textTag="GMDXText.Datacube03",replacement="Accuracy Breakdown")
    datacubeTitles(4)=(textTag="GMDXText.Datacube04",replacement="Secondary Items")
    datacubeTitles(5)=(textTag="GMDXText.Datacube05",replacement="Final Test")
    //datacubeTitles(6)=(textTag="GMDXText.Datacube06",replacement="Weapon Controls")
    //datacubeTitles(7)=(textTag="GMDXText.Datacube07",replacement="Training Course Closed")
    //datacubeTitles(8)=(textTag="GMDXText.Datacube08",replacement="Takedowns")
    //datacubeTitles(9)=(textTag="GMDXText.Datacube09",replacement="Door Information")
    //datacubeTitles(10)=(textTag="GMDXText.Datacube10",replacement="Mantling Training")
    datacubeTitles(11)=(textTag="GMDXText.Datacube11",replacement="About Ammo Types")
    datacubeTitles(12)=(textTag="GMDXText.Datacube12",replacement="Jumping")
    datacubeTitles(13)=(textTag="GMDXText.Datacube13",replacement="Crawlspaces")
    datacubeTitles(14)=(textTag="GMDXText.Datacube14",replacement="Walkway Code")
    datacubeTitles(15)=(textTag="GMDXText.Datacube15",replacement="Staying Healthy")
    datacubeTitles(16)=(textTag="GMDXText.Datacube16",replacement="Advanced Interactivity")
    datacubeTitles(17)=(textTag="GMDXText.Datacube17",replacement="Zyme Deal")
    datacubeTitles(18)=(textTag="GMDXText.Datacube18",replacement="Well Done!")
    datacubeTitles(19)=(textTag="GMDXText.Datacube19",replacement="Storage Inventory Ledger")
    datacubeTitles(20)=(textTag="GMDXText.Datacube20",replacement="The Cannister")
    datacubeTitles(21)=(textTag="GMDXText.Datacube21",replacement="Nano-Augmentation Guidelines")
    datacubeTitles(22)=(textTag="GMDXText.Datacube22",replacement="Transfer Request")
    datacubeTitles(23)=(textTag="GMDXText.Datacube23",replacement="Stop Falling Asleep!")
    ////SARGE: New training messages
    datacubeTitles(24)=(textTag="GMDXText.Datacube24",replacement="Advanced World Interactions")
    datacubeTitles(25)=(textTag="GMDXText.Datacube25",replacement="Left-Click Interactions")
    datacubeTitles(26)=(textTag="GMDXText.Datacube26",replacement="Ammo Restrictions")
    datacubeTitles(27)=(textTag="GMDXText.Datacube27",replacement="Disarming Explosives")
    datacubeTitles(28)=(textTag="GMDXText.Datacube28",replacement="Toolbelt Slots")
     TextPackage="GMDXText"

}
