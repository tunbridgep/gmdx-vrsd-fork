//=============================================================================
// Phone.
//=============================================================================
class Phone extends ElectronicDevices;

enum ERingSound
{
	RS_Office1,
	RS_Office2,
    RS_None     //SARGE: Added.
};

enum EAnswerSound
{
	AS_Dialtone,
	AS_Busy,
	AS_NotRecognised,
	//AS_CircuitsBusy,   //SARGE: Has no associated sound, removed
    AS_Investigation,    //Locked pending Investigation
    AS_Authorisation,    //Awaiting Authorisation
    AS_ShutDownByUNATCO, //Shut down by UNATCO
	AS_None,             //SARGE: Added. The phone makes no sound at all.
    AS_Random,           //Special case. Plays a random sound. The default, since this is how it was in Vanilla.
};

var() ERingSound RingSound;
var() EAnswerSound AnswerSound;         //Sound when frobbing the phone
var() EAnswerSound OfflineSound;        //Sound when frobbing the phone, if we can't trigger it.
var() float ringFreq;
var float ringTimer;
var bool bUsing;
var() bool bUnatcoPhone;
var() bool bPayPhone;
var int pSoundID;

var() bool bScriptedPhone;       //SARGE: If set, the phone won't ring randomly, will activate all linked triggers and keypads, and will follow logic based on flags.

var private int numRings;           //SARGE: Now, we ring in groups of 3-5 rings, to be more realistic, rather than 1 random ring every so often.

var() private name TriggerFlag;   //SARGE: Flag that must be set to trigger linked objects.
var() private bool bCheckFalse;

var private float startedSound;     //SARGE: Add a maximum time each sound can play for, like 10 seconds, since some can go forever.

//SARGE: Some of the phones in the game have weird bools set, instead of using the enum (stupid original devs!)
//Lets fix that!
function PostBeginPlay()
{
    if (bUnatcoPhone)
    {
        AnswerSound = AS_Authorisation;
        ringFreq=0.2; //Ring lots and lots.
    }
    else if (bPayphone)
        AnswerSound = AS_ShutDownByUNATCO;
}

function bool InConversation(DeusExPlayer player, bool bCheckFirstPerson)
{
    return player != None && player.InConversation(bCheckFirstPerson);
}

function bool CanRing()
{
    return AnswerSound != AS_Investigation && AnswerSound != AS_ShutDownByUNATCO;
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

    //Add a maximum timer for each sound
    if (startedSound > 0)
    {
        startedSound -= deltaTime;
        if (startedSound < 0)
        {
            startedSound = 0;
            StopSound(pSoundID);
        }
    }

    if (!bScriptedPhone)
    {
        ringTimer += deltaTime;
        
        if (ringTimer >= 2.5)
        {
            ringTimer -= 2.5;

            if (!bUsing && numRings == 0 && FRand() < ringFreq && CanRing())
                numRings = Rand(2)+5; //5 to 7 random rings
        }
    }
}

function Ring()
{
    if (!InConversation(DeusExPlayer(GetPlayerPawn()),false))
    {
        numRings--;
        switch (RingSound)
        {
            case RS_Office1:	PlaySound(sound'PhoneRing1', SLOT_Misc,,, 256); break;
            case RS_Office2:	PlaySound(sound'PhoneRing2', SLOT_Misc,,, 256); break;
        }
    }
    else
    {
        numRings = 0;
    }
}

function Timer()
{
	bUsing = False;
}

function private PlayAnswerSound(EAnswerSound snd)
{
	local float rnd;
	if (bPayphone)
        startedSound = 2;
    else
        startedSound = 5;
    switch (snd)
    {
        case AS_DialTone:
            pSoundID = PlaySound(sound'PhoneDialtone', SLOT_Misc,,, 256);
            break;
        case AS_Busy:
            pSoundID = PlaySound(sound'PhoneBusy', SLOT_Misc,,, 256);
            break;
        case AS_NotRecognised:
            pSoundID = PlaySound(sound'PhoneVoice1', SLOT_Misc,,, 256); //Not a recognised user
            break;
        case AS_Investigation:
            pSoundID = PlaySound(sound'PhoneVoice2', SLOT_Misc,,, 256); //Locked pending investigation
            break;
        case AS_Authorisation:
            pSoundID = PlaySound(sound'PhoneVoice3', SLOT_Misc,,, 256); //Awaiting Authorisation
            break;
        case AS_ShutDownByUNATCO:
            pSoundID = PlaySound(sound'PhoneVoice4', SLOT_Misc,,, 256); //Shut down by order of UNATCO
            break;
        case AS_None:
            break;
        case AS_Random:
            rnd = FRand();
            if (rnd < 0.2)
                pSoundID = PlaySound(sound'PhoneBusy', SLOT_Misc,,, 256);
            else if (rnd < 0.4)
                pSoundID = PlaySound(sound'PhoneDialtone', SLOT_Misc,,, 256);
            else if (rnd < 0.6)
                pSoundID = PlaySound(sound'PhoneVoice1', SLOT_Misc,,, 256); //Not a recognised user
            //else if (rnd < 0.7)
                //pSoundID = PlaySound(sound'PhoneVoice2', SLOT_Misc,,, 256); //Locked pending investigation
            else
                pSoundID = PlaySound(sound'PhoneVoice3', SLOT_Misc,,, 256); //Awaiting Authorisation
            //else
                //pSoundID = PlaySound(sound'PhoneVoice4', SLOT_Misc,,, 256); //Shut down by order of Unatco
            break;
    }
}

function Frob(actor Frobber, Inventory frobWith)
{
    local Keypad K;
    local DeusExPlayer P;
    local bool bTrigger;
    local EAnswerSound snd;

    P = DeusExPlayer(Frobber);

    snd = AnswerSound;

	if (bUsing)
		return;

    if (bScriptedPhone)
    {
        P.DebugMessage("InConversation: " $ P.InConversation());
        //no re-frobbing in conversation
        if (InConversation(P,true))
            return;

        //SARGE: Activate all linked Keypads.
        //This is a bit of a hack, but lets us "dial" numbers,
        //which is nice.
        if (TriggerFlag == '' || P == None || P.FlagBase == None)
            bTrigger = true;
        else if (!P.FlagBase.GetBool(TriggerFlag) && bCheckFalse)
            bTrigger = true;
        else if (P.FlagBase.GetBool(TriggerFlag) && !bCheckFalse)
            bTrigger = true;

        //P.DebugMessage("Phone Frobbed: " $ TriggerFlag @ P @ P.FlagBase.GetBool(TriggerFlag) @ bCheckFalse @ bTrigger);

        //If the checked flag is set, don't let us keep frobbing
        if (bTrigger)
        {
            StopSound(pSoundID);
            Super.Frob(Frobber, frobWith);
            //Trigger any linked keypads - allows dialing the phone
            if (Event != '')
            {
                foreach AllActors(class 'Keypad', K, Event)
                {
                    P.DebugMessage("Frobbing " $ K);
                    K.Frob(Frobber,None);
                }
            }
        }
        else
            snd = OfflineSound;
    }
    else
        Super.Frob(Frobber, frobWith);
        
    PlayAnswerSound(snd);

    if (bTrigger)
        SetTimer(1.0, False);
    else
        SetTimer(3.0, False);
    numRings = 0;
	bUsing = True;
}

defaultproperties
{
     ringFreq=0.040000
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     bCanBeBase=True
     ItemName="Telephone"
     Mesh=LodMesh'DeusExDeco.Phone'
     HDTPMesh="HDTPDecos.HDTPphone"
     CollisionRadius=11.870000
     CollisionHeight=3.780000
     Mass=20.000000
     Buoyancy=15.000000
     AnswerSound=AS_Random
     OfflineSound=AS_Busy
}
