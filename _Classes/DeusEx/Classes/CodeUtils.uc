//=============================================================================
// SARGE: Code Utils
// Functions to assist with managing Codes
// Used by the No Keypad Cheese modifier
//=============================================================================
class CodeUtils extends Object abstract;

struct CodeNote
{
    var string code1;
    var string code2;
    var string noteName;
    var bool bNoStrict;
};

var const CodeNote codeNotes[150];
var const string guessableCodes[10];

static function bool IsGuessable(string code, string code2)
{
    local int i;
    for (i = 0;i < ArrayCount(default.guessableCodes);i++)
    {
        if (default.guessableCodes[i] == "")
            continue;

        if (caps(code) == caps(default.guessableCodes[i]) || caps(code2) == caps(default.guessableCodes[i]))
        {
            //Log("CODE GUESSABLE: " $ i @ default.guessableCodes[i]);
            return true;
        }
    }
    return false;
}

static function bool HasCode(DeusExPlayer P, string code, string code2, bool bNoHidden)
{
    return (IsGuessable(code,code2) && !bNoHidden) || GetCodeNote(P,code,code2,bNoHidden) != None;
}

//SARGE: This is horrid and needs a rewrite!
static function DeusExNote GetCodeNote(DeusExPlayer P, string code, string code2, bool bNoHidden)
{
	local DeusExNote note;
    local int i;
    local bool bCode1Match;
    local bool bCode2Match;
    local bool bMatch, bTest;
    
    if (code == "")
        return None;
    
    for (i = 0;i < ArrayCount(default.codeNotes);i++)
    {
        //If either code matches the note, then check the note
        if (default.codeNotes[i].bNoStrict && code2 != "")
        {
            bCode1Match = true;
            bCode2Match = caps(default.codeNotes[i].code2) == caps(code2);
        }
        else
        {
            bCode1Match = caps(default.codeNotes[i].code1) == caps(code);
            bCode2Match = code2 == "" || caps(default.codeNotes[i].code2) == caps(code2);
        }
        
        if (bCode1Match && bCode2Match)
        {
            note = P.FirstNote;

            while( note != None )
            {
                //P.DebugLog("Note:" @ note.originalText @ note.bConNote @ "Looking for [" $ code $","$ code2 $ "]" @ note.bHidden @ note.bUserNote);

                //Don't show hidden notes
                if (note.bHidden && bNoHidden)
                {
                    note = note.next;
                    continue;
                }

                //Don't show user notes
                if (note.bUserNote || note.bMarkerNote)
                {
                    note = note.next;
                    continue;
                }

                //Datacube/email/etc notes need to be linked manually
                //P.DebugLog("Compare: " $ caps(string(note.textTag)) @ caps(default.codeNotes[i].noteName));
                if (caps(string(note.textTag)) == caps(default.codeNotes[i].noteName))
                {
                    P.DebugLog("CODE FOUND: " $ code $ " IN NOTE " $ default.codeNotes[i].noteName);
                    return note;
                }

                note = note.next;
            }
            //P.DebugLog("Note is " $ note);
        }
    }
        
    //Otherwise check con notes:
    if (note == None)
    {
        note = P.FirstNote;

        while( note != None )
        {
            //Don't show hidden notes
            if (note.bHidden && bNoHidden)
            {
                note = note.next;
                continue;
            }
            
            //if (note.bConNote)
            //    P.DebugLog("CHECKING NOTE CODE: " $ note.originalText);

            //If the note was added via consys, we can search it for the code.
            //Find BOTH if we're a strict code
            if (code2 != "")
                bMatch = note.bConNote && InStr(CAPS(note.originalText),CAPS(code2)) != -1;
            else
                bMatch = note.bConNote && InStr(CAPS(note.originalText),CAPS(code)) != -1;

            if (bMatch)
            {
                P.DebugLog("CODE FOUND: " $ code $ " IN CON NOTE " $ note.originalText);
                return note;
            }

            note = note.next;
        }
        //P.DebugLog("Note is " $ note);
    }
         
    P.DebugLog("NOTE CODE " $code$ " NOT FOUND IN NOTES");
	return None;
}

defaultproperties
{
    ////M00
    codeNotes(0)=(code1="0012",noteName="00_Datacube01")
    ////M01
    codeNotes(1)=(code1="jmanderley",code2="knight_killer",noteName="01_Datacube01")
    codeNotes(2)=(code1="0451",noteName="01_Datacube03")
    codeNotes(3)=(code1="nsf001",code2="smashthestate",noteName="01_Datacube04")
    codeNotes(4)=(code1="ghermann",code2="zeitgeist",noteName="01_Datacube05")
    codeNotes(5)=(code1="satcom",code2="UNATCO_001",noteName="01_Datacube06")
    codeNotes(6)=(code1="230023",code2="4558",noteName="01_Datacube07")
    //This one's a real doozy!
    codeNotes(7)=(code1="anavarre",code2="scryspc",noteName="01_Email13")
    codeNotes(8)=(code1="ghermann",code2="zeitgeist",noteName="01_Email13")
    codeNotes(9)=(code1="jmanderley",code2="knight_killer",noteName="01_Email13")
    codeNotes(10)=(code1="jreed",code2="redshoes",noteName="01_Email13")
    codeNotes(11)=(code1="jreyes",code2="amigo",noteName="01_Email13")
    codeNotes(12)=(code1="scarter",code2="antique",noteName="01_Email13")
    codeNotes(13)=(code1="ajacobson",code2="calvo",noteName="01_Email13")
    codeNotes(14)=(code1="2001",noteName="01_Email14")
    ////M02
    codeNotes(15)=(code1="jsteward",code2="JS1357",noteName="02_Datacube02")
    codeNotes(16)=(code1="2167",noteName="02_Datacube03") //Not a bug. There's 2 copies of this
    codeNotes(17)=(code1="pdenton",code2="chameleon",noteName="02_Datacube05")
    codeNotes(18)=(code1="2167",noteName="02_Datacube06") //Not a bug. There's 2 copies of this
    codeNotes(19)=(code1="4321",noteName="02_Datacube07")
    codeNotes(20)=(code1="543654",code2="5544",noteName="02_Datacube08")
    codeNotes(21)=(code1="2577",noteName="02_Datacube09")
    codeNotes(22)=(code1="9923",noteName="02_Datacube10")
    codeNotes(23)=(code1="MJ12",code2="coupdetat",noteName="02_Datacube11")
    codeNotes(24)=(code1="947761",code2="2867",noteName="02_Datacube13")
    codeNotes(25)=(code1="Righteous",noteName="02_Datacube14",bNoStrict=true) //NSF
    codeNotes(26)=(code1="666",noteName="02_Datacube15")
    codeNotes(27)=(code1="TFrase",code2="valleyforge",noteName="02_Datacube15")
    codeNotes(28)=(code1="2167",noteName="02_Email08") //Make that 3 copies...
    ////M03
    codeNotes(29)=(code1="6653",noteName="03_Book06")
    codeNotes(30)=(code1="6653",noteName="03_Datacube08") //Unused???
    codeNotes(31)=(code1="5914",noteName="03_Datacube10")
    codeNotes(32)=(code1="etodd",code2="saintmary",noteName="03_Datacube12")
    codeNotes(33)=(code1="9905",noteName="03_Datacube13")
    codeNotes(34)=(code1="5482",noteName="03_Datacube14") //Unused???
    codeNotes(35)=(code1="9905",noteName="03_Email01")
    ////M04
    codeNotes(36)=(code1="MCOLLINS",code2="REVOLUTION",noteName="04_Datacube01")
    codeNotes(37)=(code1="NAPOLEON",code2="REVOLUTION",noteName="04_Datacube01")
    codeNotes(38)=(code1="TJEFFERSON",code2="NEWREVOLUTION",noteName="04_Datacube02")
    codeNotes(39)=(code1="487659",code2="259087",noteName="04_Datacube03")
    ////M05
    codeNotes(40)=(code1="4089",code2="4679",noteName="05_Datacube01")
    codeNotes(41)=(code1="MJ12",code2="INVADER",noteName="05_Datacube02")
    codeNotes(42)=(code1="0199",noteName="05_Datacube03")
    codeNotes(43)=(code1="psherman",code2="raven",noteName="05_Datacube03")
    codeNotes(44)=(code1="2971",noteName="05_Datacube04")
    codeNotes(45)=(code1="anavarre",code2="scryspc",noteName="05_Datacube08")
    codeNotes(46)=(code1="ghermann",code2="zeitgeist",noteName="05_Datacube08")
    codeNotes(47)=(code1="jmanderley",code2="knight_killer",noteName="05_Datacube08")
    codeNotes(48)=(code1="jreed",code2="redshoes",noteName="05_Datacube08")
    codeNotes(49)=(code1="jreyes",code2="amigo",noteName="05_Datacube08")
    codeNotes(50)=(code1="scarter",code2="antique",noteName="05_Datacube08")
    codeNotes(51)=(code1="ajacobson",code2="calvo",noteName="05_Datacube08")
    codeNotes(52)=(code1="klloyd","target",noteName="05_Datacube08")
    codeNotes(53)=(code1="2971",noteName="05_Email01")
    codeNotes(54)=(code1="9905",noteName="05_Email10")
    codeNotes(55)=(code1="5239",noteName="05_Email11") //Unused???
    ////M06
    codeNotes(56)=(code1="3444",noteName="06_Bulletin07")
    codeNotes(57)=(code1="989",noteName="06_Datacube02")
    codeNotes(58)=(code1="718",noteName="06_Datacube05")
    codeNotes(59)=(code1="MChow",noteName="06_Datacube10")
    codeNotes(60)=(code1="MJ12",code2="SECURITY",noteName="06_Datacube11")
    codeNotes(61)=(code1="MCHOW",code2="DAMOCLES",noteName="06_Datacube12")
    codeNotes(62)=(code1="911",noteName="06_Datacube13")
    codeNotes(63)=(code1="INSURGENT",noteName="06_Datacube15")
    codeNotes(64)=(code1="99871",noteName="06_Datacube16")
    codeNotes(65)=(code1="TALON",code2="SKYEYE",noteName="06_Datacube18")
    codeNotes(66)=(code1="TAM",code2="Dragon",noteName="06_Datacube19")
    codeNotes(67)=(code1="QUEENSTOWER",code2="SECURITY",noteName="06_Datacube20")
    codeNotes(68)=(code1="FLYBOY",code2="5X5",noteName="06_Datacube23")
    codeNotes(69)=(code1="525",noteName="06_Datacube25")
    codeNotes(70)=(code1="5878",noteName="06_Datacube29")
    codeNotes(71)=(code1="768",noteName="06_Datacube30")
    codeNotes(72)=(code1="ALL_SHIFTS",code2="DATA_ENTRY",noteName="06_Datacube31")
    ////M08
    codeNotes(73)=(code1="jallred",code2="Apple",noteName="08_Datacube01")
    codeNotes(74)=(code1="Alice_Priest",code2="Secretary",noteName="08_Datacube01")
    ////M09
    codeNotes(75)=(code1="71324",noteName="09_Datacube02")
    codeNotes(76)=(code1="65678",noteName="09_Datacube03")
    codeNotes(77)=(code1="83353",noteName="09_Datacube04")
    codeNotes(78)=(code1="4453",noteName="09_Datacube06")
    codeNotes(79)=(code1="9753",noteName="09_Datacube07")
    codeNotes(80)=(code1="2249",noteName="09_Datacube08")
    codeNotes(81)=(code1="0909",noteName="09_Datacube09")
    codeNotes(82)=(code1="root",code2="reindeerflotilla",noteName="09_Datacube10")
    codeNotes(83)=(code1="Walton",code2="Simons",noteName="09_Datacube11")
    codeNotes(84)=(code1="USFema",code2="Security",noteName="09_Datacube12")
    codeNotes(85)=(code1="KZhao",code2="Captain",noteName="09_Datacube13")
    codeNotes(86)=(code1="6655",noteName="09_Datacube14")
    ////M10
    codeNotes(87)=(code1="4003",noteName="10_Book09")
    codeNotes(88)=(code1="bduclare",code2="nico_angel",noteName="10_Datacube02")
    codeNotes(89)=(code1="005133",code2="salem008",noteName="10_Datacube03")
    codeNotes(90)=(code1="004418",code2="morbus13",noteName="10_Datacube04")
    codeNotes(91)=(code1="002639",code2="aramis01",noteName="10_Datacube05")
    codeNotes(92)=(code1="001506",code2="naga066",noteName="10_Datacube06")
    codeNotes(93)=(code1="1966",noteName="10_Datacube07")
    codeNotes(94)=(code1="2221969",code2="dullbill",noteName="10_Datacube08")
    codeNotes(95)=(code1="Hela",code2="Ragnarok",noteName="10_Datacube11")
    codeNotes(96)=(code1="rzelazny",code2="shadowjack",noteName="10_Datacube12")
    codeNotes(97)=(code1="1784",noteName="10_Datacube13")
    ////M11
    codeNotes(98)=(code1="pynchon",noteName="11_Datacube01",bNoStrict=true) //meverrett
    codeNotes(99)=(code1="8001",noteName="11_Datacube02")
    codeNotes(100)=(code1="1942",noteName="11_Datacube03")
    codeNotes(101)=(code1="0022",noteName="11_Datacube03")
    codeNotes(102)=(code1="34501",code2="08711",noteName="11_Datacube03")
    codeNotes(103)=(code1="2384",noteName="11_Email01")
    codeNotes(104)=(code1="6426",noteName="11_Email01")
    codeNotes(105)=(code1="57601",code2="wyrdred08",noteName="11_Book03")
    ////M12
    codeNotes(106)=(code1="Tunnel01",code2="Omega2a",noteName="12_Datacube01")
    ////M14
    codeNotes(107)=(code1="Tech",code2="Sharkman",noteName="14_Datacube01")
    codeNotes(108)=(code1="5690",noteName="14_Datacube02")
    codeNotes(109)=(code1="MJ12",code2="Skywalker",noteName="14_Datacube03")
    codeNotes(110)=(code1="Elder",code2="Armageddon",noteName="14_Datacube05")
    codeNotes(111)=(code1="Oceanguard",code2="Kraken",noteName="14_Datacube06")
    ////M15
    codeNotes(112)=(code1="0169",noteName="15_Datacube01")
    codeNotes(113)=(code1="a51",code2="xx15yz",noteName="15_Datacube07")
    codeNotes(114)=(code1="1038",noteName="15_Datacube08")
    codeNotes(115)=(code1="2242",noteName="15_Datacube09")
    codeNotes(116)=(code1="6765",noteName="15_Datacube11")
    codeNotes(117)=(code1="4225",noteName="15_Datacube12")
    codeNotes(118)=(code1="jshears",code2="momerath",noteName="15_Datacube13")
    codeNotes(119)=(code1="area51",code2="bravo13",noteName="15_Datacube17")
    codeNotes(120)=(code1="2001",noteName="15_Datacube19")
    codeNotes(121)=(code1="page",code2="uberalles",noteName="15_Datacube21")

    guessableCodes(0)="8675309"
    guessableCodes(1)="7243"
    guessableCodes(2)="calvo"
}
