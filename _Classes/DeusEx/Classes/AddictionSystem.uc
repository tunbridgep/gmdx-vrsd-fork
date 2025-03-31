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
    var const float             maxTimer;                           //Maximum possible length this drug can last
    var travel int stacks;
    var const int maxStacks;
    var localized string        drugName;                           //Drug Name
};

var localized string MsgWithdrawal;                                             //RSD: Addiction system: Message saying you're now suffering from withdrawal
var localized string MsgAddicted;                                               //RSD: Addiction system: Message saying you're now addicted
var localized string MsgNotAddicted;                                            //RSD: Addiction system: Message saying you're no longer addicted
var localized string MsgDrugWornOff;                                            //RSD: Addiction system: Message saying the drug wore off

var travel Addiction addictions[3];

const DRUG_TOBACCO = 0;
const DRUG_ALCOHOL = 1;
const DRUG_CRACK = 2;

//This should be called in ResetPlayerToDefaults, and TravelPostAccept
function SetPlayer(DeusExPlayer newPlayer)
{
    Player = newPlayer;
}

//Get the current health bonus from drugs
function int GetTorsoHealthBonus()
{
    local int healthBonus;
    if (addictions[DRUG_ALCOHOL].drugTimer > 0)
        healthBonus += 5 * addictions[DRUG_ALCOHOL].stacks;                         //RSD: Get 5 bonus health for every stack
    if (addictions[DRUG_CRACK].bInWithdrawals)
        healthBonus -= 10;

    return healthBonus;
}

//Subtract torso health, but keep it above 0
function SubtractTorsoHealth(int amount)
{
    player.HealthTorso = MAX(1,player.HealthTorso-amount);
}

//The bread and butter of this class
function TickAddictions(float deltaTime)
{
    local bool ticked;
    local Addiction info;
    local int i;
    local int stackSize, currentStackTime;
    local PersonaScreenHealth winHealth;
    local bool bWasAddicted;

    if (player == None)
        return;

    for (i=0;i<ArrayCount(player.AddictionManager.addictions);i++)
    {
        info = player.AddictionManager.addictions[i];

        stackSize = int(info.maxTimer) / info.maxStacks;
        currentStackTime = stackSize * (info.stacks - 1);

        if (int(info.drugTimer) <= currentStackTime && info.stacks > 0)
        {
            info.stacks--;
            
            //Do stack removal effects
            switch (i)
            {
                case DRUG_TOBACCO:
                    //player.ClientMessage("Tobacco Stack Removed");
                    break;
                case DRUG_ALCOHOL:
                    //Remove added HP
                    SubtractTorsoHealth(5);
                    //player.ClientMessage("Alcohol Stack Removed");
                    break;
                case DRUG_CRACK:
                    //player.ClientMessage("Zyme Stack Removed");
                    break;
            }
        }

        if (info.drugTimer > 0)
        {
            ticked = true;
	        //player.ClientMessage("Ticking addiction for " $ i $ ", timer is " $ info.drugTimer);
            info.drugTimer -= deltaTime;

            if (info.drugTimer <= 0)
            {
                info.drugTimer = 0;

                player.ClientMessage(Sprintf(MsgDrugWornOff,info.drugName));               //RSD: Tell the player the drug wore off
            
                //If drug just wore off, set a timer for the withdrawals to kick in
                if (player.bHardCoreMode || player.bRestrictedMetabolism)
                    info.withdrawalTimer = (0.5+(0.1*FRand()-0.1))*info.withdrawalDelay;
                else
                    info.withdrawalTimer = (1.0+(0.1*FRand()-0.1))*info.withdrawalDelay;
            }
        }
        else if (info.withdrawalTimer > 0)
        {
            ticked = true;
            info.withdrawalTimer -= DeltaTime;

            if (info.withdrawalTimer <= 0)
            {
                info.withdrawalTimer = 0;

                if (info.level >= info.threshold)
                {
                    //Tell player they are in withdrawals
                    player.PlaySound(Sound'GMDXSFX.Player.withdrawal_notice_loud',SLOT_None);
                    player.ClientMessage(Sprintf(MsgWithdrawal,info.drugName));
                    info.bInWithdrawals = true;
                
                    //Do withdrawal effects
                    switch (i)
                    {
                        case DRUG_TOBACCO:
                            //player.ClientMessage("Tobacco Withdrawal Added");
                            break;
                        case DRUG_ALCOHOL:
                            //player.ClientMessage("Alcohol Withdrawal Added");
                            break;
                        case DRUG_CRACK:
                            SubtractTorsoHealth(10);
                            //player.ClientMessage("Zyme Withdrawal Added");
                            break;
                    }
                }
            }
        }

        //subtract addiction levels 60 seconds after skill point acquisition (shhh!)
        if (info.subtractionTimer > 0)
        {
            ticked = true;
            info.subtractionTimer = FMAX(0.,info.subtractionTimer - deltaTime);
            //player.ClientMessage("Ticking subtraction timer for " $ drugLabels[i] $ ": " $ info.subtractionTimer);
            if (info.subtractionTimer == 0)
            {
                //subtract our addiction level by the specified reduction
                info.level = FMAX(0.,info.level - info.subtractionLevel);

                //player.ClientMessage("Removing " $ info.subtractionLevel $ " from " $ druglabels[i]);
            }
        }

        //Set addicted status
        if (!info.bAddicted && info.level >= info.threshold)
        {
            player.ClientMessage(Sprintf(MsgAddicted,info.drugName));
            info.bAddicted = true;

            //Do addiction addition effects
            switch (i)
            {
                case DRUG_TOBACCO:
                    //player.ClientMessage("Tobacco Addiction Added");
                    break;
                case DRUG_ALCOHOL:
                    //player.ClientMessage("Alcohol Addiction Added");
                    break;
                case DRUG_CRACK:
                    //player.ClientMessage("Zyme Addiction Added");
                    break;
            }
        }
        else if (info.bAddicted && info.level < info.threshold)
        {
            player.ClientMessage(Sprintf(MsgNotAddicted,info.drugName));
            info.bAddicted = false;

            //Do addiction removal effects
            switch (i)
            {
                case DRUG_TOBACCO:
                    //player.ClientMessage("Tobacco Addiction Removed");
                    break;
                case DRUG_ALCOHOL:
                    //player.ClientMessage("Alcohol Addiction Removed");
                    break;
                case DRUG_CRACK:
                    //player.ClientMessage("Zyme Addiction Removed");
                    break;
            }
        }
        
        //Remove withdrawals when we get below the threshold
        if (info.bInWithdrawals && info.level < info.threshold)
        {
            ticked = true;
            info.bInWithdrawals = false;
                
            //Do withdrawal removal effects
            switch (i)
            {
                case DRUG_TOBACCO:
                    //player.ClientMessage("Tobacco Withdrawal Removed");
                    break;
                case DRUG_ALCOHOL:
                    //player.ClientMessage("Alcohol Withdrawal Removed");
                    break;
                case DRUG_CRACK:
                    //player.ClientMessage("Zyme Withdrawal Removed");
                    break;
            }
        }
        player.AddictionManager.addictions[i] = info;
    }

    //Refresh total health whenever drug status changes
    //This is likely inefficient, should do better
    if (ticked)
    {
        player.GenerateTotalHealth();
        winHealth = PersonaScreenHealth(DeusExRootWindow(player.rootWindow).GetTopWindow());
        if (winHealth != None)
            winHealth.UpdateRegionsMaxHealth();
    }
}

//Called by Vice objects. Adds them to the system
function AddAddiction(int type, float addictionIncrease, float timerIncrease)
{
    local bool bJustAdded;

    addictions[type].drugTimer = FMIN(player.AddictionManager.addictions[type].maxTimer,player.AddictionManager.addictions[type].drugTimer + timerIncrease);
    addictions[type].level = FMIN(100.0,player.AddictionManager.addictions[type].level + addictionIncrease);

    //Stop withdrawals on added addiction type
    addictions[type].bInWithdrawals = false;
    
    //If we were previously sober, set the drug effect as just added
    if (addictions[type].drugTimer > 0.0)
        bJustAdded = true;

    if (addictions[type].stacks < addictions[type].maxStacks)
    {
        addictions[type].stacks++;

        //Do drug adding effects
        switch (type)
        {
            case DRUG_TOBACCO:
                //player.ClientMessage("Tobacco Buff Added");
                break;
            case DRUG_ALCOHOL:
                    player.HealthTorso+=5;
                //player.ClientMessage("Alcohol Buff Added");
                break;
            case DRUG_CRACK:
                //player.ClientMessage("Zyme Buff Added");
                break;
        }
    }
}

//Remove from all addictions after a certain time limit
function RemoveAddictions(float amount, float timer)
{
    local int i, t;

    for (i=0;i<ArrayCount(addictions);i++)
    {
        //Add some randomness to the timer
        t = timer + (FRand() * 10) + (FRand() * -10);

        //Don't allow zero timers
        if (t <= 0)
            t = 0.1;
        
        //player.ClientMessage("Removing " $ amount $ " addiction from " $ drugLabels[i] $ " in " $ t $ " seconds ");

        addictions[i].subtractionTimer = t;
        addictions[i].subtractionLevel = amount;
    }
}

defaultproperties
{
    addictions(0)=(threshold=50.00,withdrawalDelay=1200.00,maxTimer=600.00,maxStacks=1,drugName="Tobacco")
    addictions(1)=(threshold=50.00,withdrawalDelay=1800.00,maxTimer=600.00,maxStacks=5,drugName="Alcohol")
    addictions(2)=(threshold=50.00,withdrawalDelay=600.00,maxTimer=600.00,maxStacks=1,drugName="Zyme")
    MsgWithdrawal="You are now suffering from %s withdrawal"
    MsgAddicted="You are now addicted to %s"
    MsgNotAddicted="You are no longer addicted to %s"
    MsgDrugWornOff="%s has worn off"
}
