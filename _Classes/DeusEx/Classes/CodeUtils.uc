//=============================================================================
// SARGE: Code Utils
// Functions to assist with managing Codes
// Used by the No Keypad Cheese modifier
//=============================================================================
class CodeUtils extends Object abstract;

enum EAutofillMode
{
    AUTOFILL_NORMAL,
    AUTOFILL_NONE,
    AUTOFILL_PASSWORD_ONLY,
};

struct CodeNote
{
    var string code1;
    var string code2;
    var string noteName;
    var bool bHidden; //Won't show in Keypad/Computer notes window
    var EAutofillMode AutofillMode; //Won't autofill when clicking
    var string customPassword;      //When autofilling, use this instead of the password.

    //Enforce checking that the note actually contains the text for our code.
    //The way we detect con notes is flawed, we only get the conversation. For conversations that add multiple notes, we need to check for the real note only.
    var bool bTextCheck;
};

var const CodeNote codeNotes[200];
var const string ignoredCodes[10];
var const string guessableCodes[10];

//SARGE: This is hacky...
static function bool CanAutofill(DeusExNote note)
{
    local int i;
    for (i = 0;i < ArrayCount(default.codeNotes);i++)
    {
        if (CodeMatch(i,note) && default.codeNotes[i].AutofillMode != AUTOFILL_NONE)
            return true;
    }
    return false;
}

static function private bool CodeMatch(int index, DeusExNote note)
{
    local bool bCheck1, bCheck2;

    //Check that the note name is valid
    bCheck1 = caps(default.codeNotes[index].noteName) == caps(string(note.textTag))
        || caps("FemJC"$default.codeNotes[index].noteName) == caps(string(note.textTag)) //FemJC
        || caps(string(note.textTag)) == caps(default.codeNotes[index].noteName $ "_DV"); //Also check downloaded emails.
    
    //Check that the note actually contains the code
    bCheck2 = !default.codeNotes[index].bTextCheck || InStr(caps(note.text),caps(default.codeNotes[index].code1)) != -1;

    return bCheck1 && bCheck2;
}

//Given a passed in note, gets the relevant code from it.
//Some notes can have multiple codes, so we need to provide an index
static function GetCodeFromNote(DeusExNote note, int codeNumber, out string code, out string code2)
{
    local int i;

    local string firstCode, firstCode2;
    local int codesDone;
    local bool bPasswordOnly, bFirstPasswordOnly, bDone;

    if (note == None || note.bUserNote || note.bMarkerNote)
        return;

    if (note.textTag != '')
    {
        for (i = 0;i < ArrayCount(default.codeNotes);i++)
        {
            if (CodeMatch(i,note))
            {
                //We need to store ALL the codes, so we can
                //go through and find one that matches exactly.
                //Alternatively if it DOES match exactly, simply return it.
                if (codesDone >= codeNumber)
                {
                    code = default.codeNotes[i].code1;

                    if (default.codeNotes[i].customPassword != "")
                        code2 = default.codeNotes[i].customPassword;
                    else
                        code2 = default.codeNotes[i].code2;
                    bPasswordOnly = default.codeNotes[i].AutofillMode == AUTOFILL_PASSWORD_ONLY;
                    bDone = true;
                    break;
                }
                else if (firstCode == "" && firstCode2 == "")
                {
                    firstCode = default.codeNotes[i].code1;
                    
                    if (default.codeNotes[i].customPassword != "")
                        firstCode2 = default.codeNotes[i].customPassword;
                    else
                        firstCode2 = default.codeNotes[i].code2;

                    bFirstPasswordOnly = default.codeNotes[i].AutofillMode == AUTOFILL_PASSWORD_ONLY;
                }
                codesDone++;
            }
        }

        if (!bDone)
        {
            //We didn't have an exact match, so instead we will simply return the first code we found.
            code = firstCode;
            code2 = firstCode2;
            bPasswordOnly = bFirstPasswordOnly;
        }

        if (bPasswordOnly)
            code = "";
    }
}

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
                
    P.DebugLog("Searching for code:" @ code @ code2);
    
    for (i = 0;i < ArrayCount(default.codeNotes);i++)
    {
        if (default.codeNotes[i].code1 == "" && default.codeNotes[i].code2 == "")
            continue;

        bCode1Match = caps(default.codeNotes[i].code1) == caps(code) || (caps(default.codeNotes[i].code1) == "" && code2 != "");
        bCode2Match = code2 == "" || caps(default.codeNotes[i].code2) == caps(code2);
        
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
                if (CodeMatch(i,note))
                {
                    if (!bNoHidden || !default.codeNotes[i].bHidden)
                    {
                        P.DebugLog("CODE FOUND: " $ code $ " IN NOTE " $ default.codeNotes[i].noteName);
                        return note;
                    }
                }

                note = note.next;
            }
            //P.DebugLog("Note is " $ note);
        }
    }

    /*
        
    //Otherwise check con notes:
    if (note == None)
    {
        note = P.FirstNote;
            
        //Don't check for codes which are common words, such as "Security", "Research", etc.
        for (i = 0;i < ArrayCount(default.ignoredCodes);i++)
        {
            if ((code2 ~= default.ignoredCodes[i] || (code ~= default.ignoredCodes[i] && code2 == "")) && default.ignoredCodes[i] != "")
            {
                P.DebugLog("NOTE CODE " $code$ " NOT FOUND IN NOTES (Excepted Code: "$ code2 $" )");
                return None;
            }
        }

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
            //NOTE: Only search for passwords, not usernames
            else if (code2 != "")
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
         
    */

    P.DebugLog("NOTE CODE " $code$ " NOT FOUND IN NOTES");
	return None;
}

defaultproperties
{
    ////M00
    codeNotes(0)=(code1="0012",noteName="00_Datacube01")
    codeNotes(1)=(code1="0089",noteName="00_Datacube02")
    ////M01
    codeNotes(2)=(code1="jmanderley",code2="knight_killer",noteName="01_Datacube01")
    codeNotes(3)=(code1="0451",noteName="01_Datacube03")
    codeNotes(4)=(code1="nsf001",code2="smashthestate",noteName="01_Datacube04")
    codeNotes(5)=(code1="ghermann",code2="zeitgeist",noteName="01_Datacube05")
    codeNotes(6)=(code1="satcom",code2="UNATCO_001",noteName="01_Datacube06")
    codeNotes(7)=(code1="230023",code2="4558",noteName="01_Datacube07")
    //This one's a real doozy!
    codeNotes(8)=(code1="anavarre",code2="scryspc",noteName="01_Email13")
    codeNotes(9)=(code1="ghermann",code2="zeitgeist",noteName="01_Email13")
    codeNotes(10)=(code1="jmanderley",code2="knight_killer",noteName="01_Email13")
    codeNotes(11)=(code1="jreed",code2="redshoes",noteName="01_Email13")
    codeNotes(12)=(code1="jreyes",code2="amigo",noteName="01_Email13")
    codeNotes(13)=(code1="scarter",code2="antique",noteName="01_Email13")
    codeNotes(14)=(code1="ajacobson",code2="calvo",noteName="01_Email13")
    codeNotes(15)=(code1="2001",noteName="01_Email14")
    ////M02
    codeNotes(16)=(code1="jsteward",code2="JS1357",noteName="02_Datacube02")
    codeNotes(17)=(code1="2167",noteName="02_Datacube03") //Not a bug. There's 2 copies of this
    codeNotes(18)=(code1="pdenton",code2="chameleon",noteName="02_Datacube05")
    codeNotes(19)=(code1="2167",noteName="02_Datacube06") //Not a bug. There's 2 copies of this
    codeNotes(20)=(code1="4321",noteName="02_Datacube07",AutofillMode=AUTOFILL_NONE)
    codeNotes(21)=(code1="543654",code2="5544",noteName="02_Datacube08")
    codeNotes(22)=(code1="2577",noteName="02_Datacube09")
    codeNotes(23)=(code1="9923",noteName="02_Datacube10")
    codeNotes(24)=(code1="MJ12",code2="coupdetat",noteName="02_Datacube11")
    codeNotes(25)=(code1="947761",code2="2867",noteName="02_Datacube13")
    codeNotes(26)=(code1="NSF",code2="Righteous",noteName="02_Datacube14") //NSF
    codeNotes(27)=(code1="666",noteName="02_Datacube15")
    codeNotes(28)=(code1="TFrase",code2="valleyforge",noteName="02_Datacube18")
    codeNotes(29)=(code1="2167",noteName="02_Email08") //Make that 3 copies...
    ////M03
    codeNotes(30)=(code1="6653",noteName="03_Book06")
    codeNotes(31)=(code1="6653",noteName="03_Datacube08") //Unused???
    codeNotes(32)=(code1="5914",noteName="03_Datacube10")
    codeNotes(33)=(code1="etodd",code2="saintmary",noteName="03_Datacube12")
    codeNotes(34)=(code1="9905",noteName="03_Datacube13")
    codeNotes(35)=(code1="5482",noteName="03_Datacube14") //Unused???
    codeNotes(36)=(code1="9905",noteName="03_Email01")
    codeNotes(37)=(code1="",code2="knight_killer",noteName="03_Email08") //Email from Paul
    codeNotes(38)=(code1="jmanderley",code2="knight_killer",noteName="03_Email08",bHidden=true) //Email from Paul
    ////M04
    codeNotes(39)=(code1="MCOLLINS",code2="REVOLUTION",noteName="04_Datacube01")
    codeNotes(40)=(code1="NAPOLEON",code2="REVOLUTION",noteName="04_Datacube01")
    codeNotes(41)=(code1="TJEFFERSON",code2="NEWREVOLUTION",noteName="04_Datacube02")
    codeNotes(42)=(code1="487659",code2="259087",noteName="04_Datacube03")
    ////M05
    codeNotes(43)=(code1="4089",noteName="05_Datacube01")
    codeNotes(44)=(code1="4679",noteName="05_Datacube01")
    codeNotes(45)=(code1="MJ12",code2="INVADER",noteName="05_Datacube02")
    codeNotes(46)=(code1="0199",noteName="05_Datacube03")
    codeNotes(47)=(code1="psherman",code2="raven",noteName="05_Datacube03")
    codeNotes(48)=(code1="2971",noteName="05_Datacube04")
    codeNotes(49)=(code1="anavarre",code2="scryspc",noteName="05_Datacube08")
    codeNotes(50)=(code1="ghermann",code2="zeitgeist",noteName="05_Datacube08")
    codeNotes(51)=(code1="jmanderley",code2="knight_killer",noteName="05_Datacube08")
    codeNotes(52)=(code1="jreed",code2="redshoes",noteName="05_Datacube08")
    codeNotes(53)=(code1="jreyes",code2="amigo",noteName="05_Datacube08")
    codeNotes(54)=(code1="scarter",code2="antique",noteName="05_Datacube08")
    codeNotes(55)=(code1="ajacobson",code2="calvo",noteName="05_Datacube08")
    codeNotes(56)=(code1="klloyd","target",noteName="05_Datacube08")
    codeNotes(57)=(code1="2971",noteName="05_Email01")
    codeNotes(58)=(code1="1991",noteName="05_Email10")
    codeNotes(59)=(code1="5239",noteName="05_Email11") //Unused???
    ////M06
    codeNotes(60)=(code1="3444",noteName="06_Bulletin07")
    codeNotes(61)=(code1="989",noteName="06_Datacube02")
    codeNotes(62)=(code1="718",noteName="06_Datacube05",bHidden=true)
    codeNotes(63)=(code1="MChow",noteName="06_Datacube10")
    codeNotes(64)=(code1="MJ12",code2="SECURITY",noteName="06_Datacube11")
    codeNotes(65)=(code1="MCHOW",code2="DAMOCLES",noteName="06_Datacube12",AutofillMode=AUTOFILL_PASSWORD_ONLY)
    codeNotes(66)=(code1="ADONOVAN",code2="DAMOCLES",noteName="06_Datacube12",AutofillMode=AUTOFILL_PASSWORD_ONLY)
    codeNotes(67)=(code1="MLUNDQUIST",code2="DAMOCLES",noteName="06_Datacube12",AutofillMode=AUTOFILL_PASSWORD_ONLY)
    codeNotes(68)=(code1="MBATES",code2="DAMOCLES",noteName="06_Datacube12",AutofillMode=AUTOFILL_PASSWORD_ONLY)
    codeNotes(69)=(code1="911",noteName="06_Datacube13")
    codeNotes(70)=(code1="mchow",code2="INSURGENT",noteName="06_Datacube15",bHidden=true)
    codeNotes(71)=(code1="99871",noteName="06_Datacube16")
    codeNotes(72)=(code1="TALON",code2="SKYEYE",noteName="06_Datacube18")
    codeNotes(73)=(code1="TAM",code2="Dragon",noteName="06_Datacube19")
    codeNotes(74)=(code1="QUEENSTOWER",code2="SECURITY",noteName="06_Datacube20")
    codeNotes(75)=(code1="FLYBOY",code2="5X5",noteName="06_Datacube23")
    codeNotes(76)=(code1="525",noteName="06_Datacube25")
    codeNotes(77)=(code1="5878",noteName="06_Datacube29")
    codeNotes(78)=(code1="768",noteName="06_Datacube30")
    codeNotes(79)=(code1="ALL_SHIFTS",code2="DATA_ENTRY",noteName="06_Datacube31")
    codeNotes(80)=(code1="1709",noteName="06_Datacube20")
    ////M08
    codeNotes(81)=(code1="jallred",code2="Apple",noteName="08_Datacube01")
    codeNotes(82)=(code1="Alice_Priest",code2="Secretary",noteName="08_Datacube01")
    ////M09
    codeNotes(83)=(code1="71324",noteName="09_Datacube02")
    codeNotes(84)=(code1="65678",noteName="09_Datacube03")
    codeNotes(85)=(code1="83353",noteName="09_Datacube04")
    codeNotes(86)=(code1="4453",noteName="09_Datacube06")
    codeNotes(87)=(code1="9753",noteName="09_Datacube07")
    codeNotes(88)=(code1="2249",noteName="09_Datacube08")
    codeNotes(89)=(code1="0909",noteName="09_Datacube09")
    codeNotes(90)=(code1="root",code2="reindeerflotilla",noteName="09_Datacube10")
    codeNotes(91)=(code1="Walton",code2="Simons",noteName="09_Datacube11")
    codeNotes(92)=(code1="USFema",code2="Security",noteName="09_Datacube12")
    codeNotes(93)=(code1="KZhao",code2="Captain",noteName="09_Datacube13")
    codeNotes(94)=(code1="6655",noteName="09_Datacube14")
    ////M10
    codeNotes(95)=(code1="4003",noteName="10_Book09")
    codeNotes(96)=(code1="bduclare",code2="nico_angel",noteName="10_Datacube02")
    codeNotes(97)=(code1="005133",code2="salem008",noteName="10_Datacube03")
    codeNotes(98)=(code1="004418",code2="morbus13",noteName="10_Datacube04")
    codeNotes(99)=(code1="002639",code2="aramis01",noteName="10_Datacube05")
    codeNotes(100)=(code1="001506",code2="naga066",noteName="10_Datacube06")
    codeNotes(101)=(code1="1966",noteName="10_Datacube07")
    codeNotes(102)=(code1="2221969",code2="dullbill",noteName="10_Datacube08")
    codeNotes(103)=(code1="Hela",code2="Ragnarok",noteName="10_Datacube11")
    codeNotes(104)=(code1="rzelazny",code2="shadowjack",noteName="10_Datacube12")
    codeNotes(105)=(code1="1784",noteName="10_Datacube13")
    ////M11
    codeNotes(106)=(code1="meverett",code2="pynchon",noteName="11_Datacube01")
    codeNotes(107)=(code1="8001",noteName="11_Datacube02")
    codeNotes(108)=(code1="1942",noteName="11_Datacube03")
    codeNotes(109)=(code1="0022",noteName="11_Datacube03")
    codeNotes(110)=(code1="34501",code2="08711",noteName="11_Datacube03")
    codeNotes(111)=(code1="2384",noteName="11_Email01")
    codeNotes(112)=(code1="6426",noteName="11_Email01")
    codeNotes(113)=(code1="576001",code2="wyrdred03",noteName="11_Book03",customPassword="wyrdred0")
    ////M12
    codeNotes(114)=(code1="Tunnel01",code2="Omega2a",noteName="12_Datacube01")
    ////M14
    codeNotes(115)=(code1="Tech",code2="Sharkman",noteName="14_Datacube01")
    codeNotes(116)=(code1="5690",noteName="14_Datacube02")
    codeNotes(117)=(code1="MJ12",code2="Skywalker",noteName="14_Datacube03")
    codeNotes(118)=(code1="Elder",code2="Armageddon",noteName="14_Datacube05")
    codeNotes(119)=(code1="Oceanguard",code2="Kraken",noteName="14_Datacube06")
    ////M15
    codeNotes(120)=(code1="0169",noteName="15_Datacube01")
    codeNotes(121)=(code1="a51",code2="xx15yz",noteName="15_Datacube07")
    codeNotes(122)=(code1="1038",noteName="15_Datacube08")
    codeNotes(123)=(code1="2242",noteName="15_Datacube09")
    codeNotes(124)=(code1="6765",noteName="15_Datacube11")
    codeNotes(125)=(code1="4225",noteName="15_Datacube12")
    codeNotes(126)=(code1="jshears",code2="momerath",noteName="15_Datacube13")
    codeNotes(127)=(code1="area51",code2="bravo13",noteName="15_Datacube17")
    codeNotes(128)=(code1="2001",noteName="15_Datacube19")
    codeNotes(129)=(code1="page",code2="uberalles",noteName="15_Datacube21")

    ///CONVERSATION NOTES now have proper note names
    ///NOTE: FemJC versions are handled automatically
    codeNotes(130)=(code1="0451",noteName="MeetKaplan")
    codeNotes(131)=(code1="JCD",code2="bionicman",noteName="MeetJanice")
    codeNotes(132)=(code1="JCD",code2="bionicman",noteName="Prebriefing")
    codeNotes(133)=(code1="9183",noteName="MeetJosh")
    codeNotes(134)=(code1="2153",noteName="Doctor1Barter")
    codeNotes(135)=(code1="2153",noteName="Doctor2Barter")
    codeNotes(136)=(code1="3316",noteName="JaneyThankful")
    codeNotes(137)=(code1="3316",noteName="WorkerGivesInfo")
    //codeNotes(137)=(code1="",code2="righteous",noteName="MaleHostageRescued") //Add a "fake" version we can click on for autofilling
    codeNotes(138)=(code1="NSF",code2="righteous",noteName="MaleHostageRescued",AutofillMode=AUTOFILL_PASSWORD_ONLY) //SARGE: This one needs testing!
    codeNotes(139)=(code1="5482",noteName="FannSatisfied")
    codeNotes(140)=(code1="6653",noteName="MeetCurly",bTextCheck=true)
    codeNotes(141)=(code1="6282",noteName="TalkedToPaulAfterMessage")
    codeNotes(142)=(code1="0199",noteName="MeetDoctorMoreau")
    codeNotes(143)=(code1="demiurge",code2="archon",noteName="PaulInMedLab")
    codeNotes(144)=(code1="MJ12",code2="Invader",noteName="SvenConvos")
    codeNotes(145)=(code1="MANAGEMENT",code2="CODE324",noteName="M06MeetBarThug")
    codeNotes(146)=(code1="1997",noteName="Gate_Guard2",bTextCheck=true)
    codeNotes(147)=(code1="6512",noteName="Disgruntled_Guy_Convos")
    codeNotes(148)=(code1="6512",noteName="M06SupervisorConvos")
    codeNotes(149)=(code1="55655",noteName="M07Briefing",bTextCheck=true)
    codeNotes(150)=(code1="JCDenton",code2="sanctuary",noteName="MeetTracerTong2",bTextCheck=true)
    codeNotes(151)=(code1="06288",noteName="MeetTracerTong2",bTextCheck=true)
    codeNotes(152)=(code1="87342",noteName="MeetMaggie",bTextCheck=true)
    codeNotes(153)=(code1="6655",noteName="CafWorker1Help")
    codeNotes(154)=(code1="0001",noteName="MeetAimee")
    codeNotes(155)=(code1="1966",noteName="MeetCassandra")
    codeNotes(156)=(code1="streetstation17",code2="werewolf",noteName="JoshuaInterrupted")
    codeNotes(157)=(code1="nicolette",code2="chad",noteName="NicoletteInStudy")
    codeNotes(158)=(code1="5868",noteName="MeetCarlaBrown")
    codeNotes(159)=(code1="GSavage",code2="Tiffany",noteName="GaryComputerBriefing")
    codeNotes(160)=(code1="command",code2="zebra42",noteName="MeetStacyWebber")
    codeNotes(161)=(code1="command",code2="zebra42",noteName="StephanieRescued")
    codeNotes(162)=(code1="Tunnel01",code2="Omega2a",noteName="MeetTimBaker")
    codeNotes(163)=(code1="tech",code2="sharkman",noteName="MeetDrBrittanyPrinzler")
    codeNotes(164)=(code1="1223",noteName="MeetDrCorwell")
    codeNotes(165)=(code1="APinkerton",code2="Antennapedia",noteName="MeetDrPinkerton")
    codeNotes(166)=(code1="8946",noteName="M15MeetEverett")
    codeNotes(167)=(code1="1038",noteName="MeetPowerGuy")
    codeNotes(168)=(code1="a51",code2="xx15yz",noteName="MeetScaredSoldier")

    //Infolinks
    codeNotes(169)=(code1="JCD",code2="bionicman",noteName="DL_Office")
    codeNotes(170)=(code1="1125",noteName="DL_Paul")
    codeNotes(171)=(code1="1125",noteName="DL_PaulDead")
    codeNotes(172)=(code1="525",noteName="DL_Daedalus_04")
    codeNotes(173)=(code1="5868",noteName="DL_no_carla")
    codeNotes(174)=(code1="8456",noteName="DL_FrontGate")
    codeNotes(175)=(code1="Page",code2="UberAlles",noteName="DL_Final_Helios03_5")
    codeNotes(176)=(code1="Icarus",code2="panopticon",noteName="DL_Final_Helios06")
    codeNotes(177)=(code1="7243",noteName="DL_Final_Morgan",AutofillMode=AUTOFILL_NONE)
    codeNotes(178)=(code1="8946",noteName="DL_Morgan_Missed_Convo")

    //Other misc notes
    codeNotes(179)=(code1="170391",noteName="03_NYC_AirfieldHeliBase_ComputerPersonal1_Special0")
    codeNotes(180)=(code1="2167",noteName="02_NYC_Underground_ComputerSecurity3_Special1")
    codeNotes(181)=(code1="6512",noteName="06_HongKong_Versalife_ComputerPersonal72_Special0")

    //Shipping and Receiving notes
    codeNotes(182)=(code1="2835",noteName="Datacube20",autofillmode=AUTOFILL_NONE)
    
    //Missed Tutorial Note
    codeNotes(183)=(code1="154",noteName="Datacube14")
    
    //Missed Notes from 1.22
    codeNotes(184)=(code1="dmoreau",code2="raptor",noteName="05_Book01")
    codeNotes(185)=(code1="LAB 12",code2="GRAYTEST",noteName="15_Datacube18")

    guessableCodes(0)="8675309"
    guessableCodes(1)="calvo"
    guessableCodes(2)="bionicman" //Allow accessing our computer before Alex's infolink finishes.
    guessableCodes(3)="4321" //This code is so iconic and so memorable, and the code is right next to it, so just allow it anyway...
    guessableCodes(4)="22" //Only 2 digits, guessable
    guessableCodes(5)="12" //Only 2 digits, obvious

    ignoredCodes(0)="SECURITY"
    ignoredCodes(1)="RESEARCH"
    ignoredCodes(2)="199" //Fix the code for a random UC keypad (that we shouldn't know anyway) returning the 1997 code for the Luminous Path entrance.
}
