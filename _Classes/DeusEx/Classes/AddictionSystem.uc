//Sarge: Class to manage addictions

class AddictionSystem extends object;

// which player am I attached to?
var DeusExPlayer Player;

struct Addiction
{
    var float                   drugTimer;                          //Time remaining on the drug buff
    var float                   subtractionTimer;                   //Time remaining on addiction reduction
    var float                   withdrawalTimer;                    //Time remaining for withdrawals
    var float                   withdrawalDelay;                    //How long until withdrawals kick in
    var float                   level;                              //How addicted are we currently?
    var float                   threshold;                          //Addiction Threshold: At what level does withdrwal kick in?
    var float                   subtractionLevel;                   //How much to reduce addiction by each time it's reduced
    var bool                    bInWithdrawals;                     //Are we currently in withdrawals?
    var bool                    bAddicted;                          //Are we currently addicted?
    var float                   maxTimer;                           //Maximum possible length this drug can last
    //var localised string        drugName;                           //Drug Name
};

var localized string MsgWithdrawal;                                             //RSD: Addiction system: Message saying you're now suffering from withdrawal
var localized string MsgAddicted;                                               //RSD: Addiction system: Message saying you're now addicted
var localized string MsgNotAddicted;                                            //RSD: Addiction system: Message saying you're no longer addicted
var localized string MsgDrugWornOff;                                            //RSD: Addiction system: Message saying the drug wore off
var localized string drugLabels[3];                                             //RSD: Addiction system: Name of each drug

var travel Addiction addictions[3];

const DRUG_TOBACCO = 0;
const DRUG_ALCOHOL = 1;
const DRUG_CRACK = 2;

//This should be called in ResetPlayerToDefaults, and TravelPostAccept
function SetPlayer(DeusExPlayer newPlayer)
{
    Player = newPlayer;
}

//The bread and butter of this class
function TickAddictions(float deltaTime)
{
    local Addiction info;
    local int i;

    if (player == None)
        return;

    for (i=0;i<ArrayCount(player.AddictionManager.addictions);i++)
    {
        info = player.AddictionManager.addictions[i];
        if (info.drugTimer > 0)
        {
	        //player.ClientMessage("Ticking addiction for " $ i $ ", timer is " $ info.drugTimer);
            info.drugTimer -= deltaTime;
                                                                                
            if (info.drugTimer <= 0)
            {
                info.drugTimer = 0;

                player.ClientMessage(Sprintf(MsgDrugWornOff,DrugLabels[i]));               //RSD: Tell the player the drug wore off
            
                //If drug just wore off, set a timer for the withdrawals to kick in
                if (player.bHardCoreMode || player.bRestrictedMetabolism)
                    info.withdrawaltimer = (0.5+(0.1*FRand()-0.1))*info.withdrawalDelay;
                else
                    info.withdrawaltimer = (1.0+(0.1*FRand()-0.1))*info.withdrawalDelay;
                
                //Do drug removal effects
                switch (i)
                {
                    case DRUG_TOBACCO:
                        player.ClientMessage("Tobacco Removed");
                        break;
                    case DRUG_ALCOHOL:
                        player.ClientMessage("Alcohol Removed");
                        break;
                    case DRUG_CRACK:
                        player.ClientMessage("Zyme Removed");
                        break;
                }
            }
        }
        else if (info.withdrawalTimer > 0)
        {
            info.withdrawalTimer -= DeltaTime;

            if (info.withdrawalTimer <= 0)
            {
                info.withdrawalTimer = 0;

                //Tell player they are in withdrawals
                player.PlaySound(Sound'GMDXSFX.Player.withdrawal_notice_loud',SLOT_None);
                player.ClientMessage(Sprintf(MsgWithdrawal,DrugLabels[i]));
                info.bInWithdrawals = true;
            
                //Do withdrawal effects
                switch (i)
                {
                    case DRUG_TOBACCO:
                        player.ClientMessage("Tobacco Withdrawal Added");
                        break;
                    case DRUG_ALCOHOL:
                        player.ClientMessage("Alcohol Withdrawal Added");
                        break;
                    case DRUG_CRACK:
                        player.ClientMessage("Zyme Withdrawal Added");
                        break;
                }
            }
        }

        //subtract addiction levels 60 seconds after skill point acquisition (shhh!)
        if (info.subtractionTimer > 0)
        {
            info.subtractionTimer = MAX(0.,info.subtractionTimer - deltaTime);
            if (info.subtractionTimer == 0)
            {
                //subtract our addiction level by the specified reduction
                info.level = MAX(0.,info.level - info.subtractionLevel);
                
                //Do addiction removal effects
                switch (i)
                {
                    case DRUG_TOBACCO:
                        player.ClientMessage("Tobacco Addiction Removed");
                        break;
                    case DRUG_ALCOHOL:
                        player.ClientMessage("Alcohol Addiction Removed");
                        break;
                    case DRUG_CRACK:
                        player.ClientMessage("Zyme Addiction Removed");
                        break;
                }
            }
        }

        //Set addicted status
        if (!info.bAddicted && info.level >= info.threshold)
        {
            player.ClientMessage(Sprintf(MsgAddicted,DrugLabels[i]));
            info.bAddicted = true;
        }
        else if (info.bAddicted && info.level < info.threshold)
        {
            player.ClientMessage(Sprintf(MsgNotAddicted,DrugLabels[i]));
            info.bAddicted = false;
        }
        
        //Remove withdrawals when we get below the threshold
        if (info.bInWithdrawals && !info.bAddicted)
        {
            info.bInWithdrawals = false;
            player.ClientMessage(Sprintf(MsgNotAddicted,DrugLabels[i]));
                
            //Do withdrawal removal effects
            switch (i)
            {
                case DRUG_TOBACCO:
                    player.ClientMessage("Tobacco Withdrawal Removed");
                    break;
                case DRUG_ALCOHOL:
                    player.ClientMessage("Alcohol Withdrawal Removed");
                    break;
                case DRUG_CRACK:
                    player.ClientMessage("Zyme Withdrawal Removed");
                    break;
            }
        }
        player.AddictionManager.addictions[i] = info;
    }
}

//Called by Vice objects. Adds them to the system
function AddAddiction(int type, float addictionIncrease, float timerIncrease)
{
    player.AddictionManager.addictions[type].drugTimer = MIN(player.AddictionManager.addictions[type].maxTimer,player.AddictionManager.addictions[type].drugTimer + timerIncrease);
    player.AddictionManager.addictions[type].level = MIN(100,player.AddictionManager.addictions[type].level + addictionIncrease);

    //Stop withdrawals on added addiction type
    player.AddictionManager.addictions[type].bInWithdrawals = false;
}

//Remove from all addictions after a certain time limit
function RemoveAddictions(float amount, float timer)
{
    local Addiction info;
    local int i;
    for (i=0;i<ArrayCount(player.AddictionManager.addictions);i++)
    {
        info = player.AddictionManager.addictions[i];
        info.subtractionTimer = timer;
        info.subtractionLevel = amount;
    }
}

defaultproperties
{
    addictions(0)=(threshold=50.00,withdrawalDelay=1200.00,maxTimer=600.00,drugName="Tobacco")
    addictions(1)=(threshold=50.00,withdrawalDelay=1800.00,maxTimer=600.00,drugName="Alcohol")
    addictions(2)=(threshold=50.00,withdrawalDelay=600.00,maxTimer=600.00,drugName="Zyme")
    MsgWithdrawal="You are now suffering from %s withdrawal"
    MsgAddicted="You are now addicted to %s"
    MsgNotAddicted="You are no longer addicted to %s"
    MsgDrugWornOff="%s has worn off"
    drugLabels(0)="Nicotine"
    drugLabels(1)="Alcohol"
    drugLabels(2)="Zyme"
}
