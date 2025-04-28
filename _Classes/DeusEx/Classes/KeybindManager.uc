//=============================================================================
// KeybindManager.
//=============================================================================

//Sarge: This class manages and stores various keybindings
//Mostly used by the extra belt slots and the aug system.
class KeybindManager extends Object;

var travel DeusExPlayer player;

//These are the bindings we need to know about.
//This list will be added to if and when it's necessary
enum EKeybind
{
    //GMDX movement keys
    KB_LeanLeft,
    KB_LeanRight,
    KB_Jump,

    //belt keys
    KB_Belt0,
    KB_Belt1,
    KB_Belt2,
    KB_Belt3,
    KB_Belt4,
    KB_Belt5,
    KB_Belt6,
    KB_Belt7,
    KB_Belt8,
    KB_Belt9,
    KB_Belt11,
    KB_Belt12,

    //aug keys
    KB_Aug0, //F3
    KB_Aug1, //F4
    KB_Aug2, //F5
    KB_Aug3, //F6
    KB_Aug4, //F7
    KB_Aug5, //F8
    KB_Aug6, //F9
    KB_Aug7, //F10
    KB_Aug8, //F11
    KB_Aug9, //F12

    //Keyring button
    KB_Keyring,

    //Use Secondary item
    KB_Secondary,

    //Aug Menu
    KB_AugMenu_Hold,
    KB_AugMenu_Toggle,
};

//Associates a keybinding with an alias
struct Binding
{
    var string keys[10];
    var int totalBinds;
    var string alias;
};

//holds our actual keybindings.
var private transient Binding bindings[255];

//Now things get annoying...
function string GetBindName(string keyName)
{
    switch (keyName)
    {
        case "Minus": return "-";
        case "Equals": return "=";
        case "Semicolon": return ";";
        case "LeftBracket": return "[";
        case "RightBracket": return "]";
        case "SingleQuote": return "'";
        case "Comma": return ",";
        case "Period": return ".";
        default: return keyName;
    }
}

function string GetBinding(EKeybind bindName, int bindNumber, optional int offset)
{
    local string binding;
    binding = bindings[bindName + offset].keys[bindNumber];
    return GetBindName(binding);
}

function string GetBindingString(EKeybind bindName, optional int offset)
{
    local int i;
    local string retStr;
    local Binding binding;

    binding = bindings[bindName + offset];

    retStr = GetBindName(binding.keys[0]);

    for (i = 1;i < binding.totalBinds;i++)
    {
        if (retStr != "")
            retStr = retStr $ ", " $ GetBindName(binding.keys[i]);
    }

    return retStr;
}

//Used to set up a binding. Defines what it's alias is, and what it's default key is.
function SetupBinding(EKeybind bindName, string key, string alias, optional int offset)
{
    bindings[bindName + offset].alias = alias;
    if(key != "" && bindings[bindName + offset].totalBinds == 0 && player.ConsoleCommand("KEYBINDING " $ key) == "")
        BindKey(bindName,key,offset);
}

function BindKey(EKeybind bindName, string key, optional int offset)
{
    local int i, bindIndex;
    if (key == "" || bindings[bindName + offset].alias == "")
        return;
    
    bindIndex = -1;

    //overwrite existing binds
    for (i = 0;i < bindings[bindName + offset].totalBinds;i++)
    {
        if (key == bindings[bindName + offset].keys[i])
            bindIndex = i;
    }

    if (bindIndex == -1)
        bindIndex = bindings[bindName].totalBinds++;

    if (bindings[bindName].totalBinds >= 10)
        return;

    bindings[bindName].keys[bindIndex] = key;
    //player.clientmessage("Binding " $ key $ " to " $ bindings[bindName + offset].alias);
    player.ConsoleCommand("SET InputExt" @ key @ bindings[bindName + offset].alias);
    player.SaveConfig();
}

//replace an alias with a new one
function ReplaceAlias(EKeybind bindName, string newAlias, optional int offset)
{
    local int i;
    if (newAlias != "")
    {
        bindings[bindName + offset].alias = newAlias;
        for (i = 0;i < bindings[bindName + offset].totalBinds;i++)
            BindKey(bindName,bindings[bindName + offset].keys[i],offset);
    }
}

function AddBindingToArray(EKeybind bindName, string key, optional int offset)
{
    local int bindIndex;
    local int i;

    bindIndex = -1;

    //overwrite existing binds
    for (i = 0;i < bindings[bindName + offset].totalBinds;i++)
    {
        if (key == bindings[bindName + offset].keys[i])
            bindIndex = i;
    }

    if (bindIndex == -1)
        bindIndex = bindings[bindName + offset].totalBinds++;

    //bindings[bindName + offset].key = key;
    bindings[bindName + offset].keys[bindIndex] = key;
}

//Clears out the binding array
function ClearAll()
{
    local int i, j;

    //Reset bindings
    for (i=1;i<255;i++)
    {
        bindings[i].totalBinds = 0;
        bindings[i].alias = "";
        for (j=0;j<10;j++)
            bindings[i].keys[j] = "";
    }
}

//Get all of our keybindings and find what we're looking for.
function Setup(DeusExPlayer P)
{
    local string keyName, alias;
    local int i, augNum, beltNum, arrayvar;
    local EKeybind bindPos;
    local bool bReplaceShowScores;
    
    player = P;

    ClearAll();

    for (i=0;i<255;i++)
    {
        keyName = player.ConsoleCommand( "KEYNAME "$ i );
        if (keyName != "")
        {
            alias = player.ConsoleCommand( "KEYBINDING "$ keyName );

            //Get the aug keys.
            //Get the alternate keys first so they appear first
            //in the list
			if (Left(alias,8) == "DualMapF")
			{
			    augNum = int(Mid(alias,8));

                //Go from F3 onwards.
                //Aug F3 is DualMapF3
			    if (augNum > 2 && augNum <= 12)
                    AddBindingToArray(KB_Aug0,keyName,augNum - 3);
		    }

            //Get the aug keys
			if (Left(alias,21) == "ActivateAugmentation ")
            {
			    augNum = int(Mid(alias,21));

                //Go from F3 onwards.
                //Aug F3 is ActivateAugmentation 0
			    if (augNum >= 0 && augNum <= 9)
                    AddBindingToArray(KB_Aug0,keyName,augNum);
            }
            
            //Get the alt belt keys first so they appear before the regular ones.
			if (Left(alias,7) == "AltBelt")
            {
			    beltNum = int(Mid(alias,7));
                
			    if (beltNum >= 0 && beltNum <= 12)
                    AddBindingToArray(KB_Belt0,keyName,beltNum);
            }
            //Get the belt keys
			if (Left(alias,13) == "ActivateBelt ")
            {
			    beltNum = int(Mid(alias,13));
                
			    if (beltNum >= 0 && beltNum <= 12)
                    AddBindingToArray(KB_Belt0,keyName,beltNum);
            }
			
            if (Left(alias,13) == "SelectNanoKey")
                AddBindingToArray(KB_Keyring,keyName);
            if (Left(alias,8) == "LeanLeft")
                AddBindingToArray(KB_LeanLeft,keyName);
            if (Left(alias,9) == "LeanRight")
                AddBindingToArray(KB_LeanRight,keyName);
            if (Left(alias,4) == "Jump")
                AddBindingToArray(KB_Jump,keyName);
            if (Left(alias,17) == "HoldRadialAugMenu")
                AddBindingToArray(KB_AugMenu_Hold,keyName);
            if (Left(alias,19) == "ToggleRadialAugMenu")
                AddBindingToArray(KB_AugMenu_Toggle,keyName);

            //HACK: V is autobound to "Look Down"
            //Since literally nobody uses that anymore, just clobber it...
            if (Left(alias,8) == "LookDown" && keyName == "V")
            {
                AddBindingToArray(KB_Secondary,keyName);
                ReplaceAlias(KB_Secondary,"UseSecondary");
            }

            //HACK: Allow using the Multiplayer Scores button to
            //also work for belt slot 11
            //This is inconsistent, but should "just work", so it stays.
            if (Left(alias,10) == "ShowScores" && keyName == "Equals" /*&& player.bBiggerBelt*/)
            {
                bReplaceShowScores = true;
                AddBindingToArray(KB_Belt12,keyName);
            }
	    }
    }

    //configure our bindings
    //This sets default keys, and configures the alias for each.

    //augs
    SetupBinding(KB_Aug0,"F3","ActivateAugmentation 0");
    SetupBinding(KB_Aug1,"F4","ActivateAugmentation 1");
    SetupBinding(KB_Aug2,"F5","ActivateAugmentation 2");
    SetupBinding(KB_Aug3,"F6","ActivateAugmentation 3");
    SetupBinding(KB_Aug4,"F7","ActivateAugmentation 4");
    SetupBinding(KB_Aug5,"F8","ActivateAugmentation 5");
    SetupBinding(KB_Aug6,"F9","ActivateAugmentation 6");
    SetupBinding(KB_Aug7,"F10","ActivateAugmentation 7");
    SetupBinding(KB_Aug8,"F11","ActivateAugmentation 8");
    SetupBinding(KB_Aug9,"F12","ActivateAugmentation 9");
    
    //belt
    SetupBinding(KB_Belt0,"0","ActivateBelt 0");
    SetupBinding(KB_Belt1,"1","ActivateBelt 1");
    SetupBinding(KB_Belt2,"2","ActivateBelt 2");
    SetupBinding(KB_Belt3,"3","ActivateBelt 3");
    SetupBinding(KB_Belt4,"4","ActivateBelt 4");
    SetupBinding(KB_Belt5,"5","ActivateBelt 5");
    SetupBinding(KB_Belt6,"6","ActivateBelt 6");
    SetupBinding(KB_Belt7,"7","ActivateBelt 7");
    SetupBinding(KB_Belt8,"8","ActivateBelt 8");
    SetupBinding(KB_Belt9,"9","ActivateBelt 9");
    //bind belt slots 11 and 12
    SetupBinding(KB_Belt11,"Minus","ActivateBelt 10");
    SetupBinding(KB_Belt12,"Equals","ActivateBelt 11");

    //Misc keys
    SetupBinding(KB_Keyring,"","SelectNanoKey");
    SetupBinding(KB_Secondary,"V","UseSecondary");

    //Bind the Lean Keys to Tiptoes
    ReplaceAlias(KB_LeanLeft,"LeanLeft | SetTiptoesLeft 1 | OnRelease SetTiptoesLeft 0");
    ReplaceAlias(KB_LeanRight,"LeanRight | SetTiptoesRight 1 | OnRelease SetTiptoesRight 0");
    
    //Setup Mantle key
    ReplaceAlias(KB_Jump,"Jump | StartMantling 1 | OnRelease StopMantling 1");
    
    //Setup aug wheel key
    ReplaceAlias(KB_AugMenu_Hold,"HoldRadialAugMenu | ToggleRadialAugMenu 1 0 | OnRelease ToggleRadialAugMenu 1 1");
    
    if (bReplaceShowScores)
        ReplaceAlias(KB_Belt12,"ShowScores | ActivateBelt 11");
}
