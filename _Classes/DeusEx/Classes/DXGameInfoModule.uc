class DXGameInfoModule extends Object abstract;

var private transient DeusExGameInfo gameInfo;

var private transient DXGameInfoModule next;

function DXGameInfoModule GetNext()
{
    return next;
}

function DXGameInfoModule SetNext(DXGameInfoModule n)
{
    next = n;
}

function Init(DeusExGameInfo info)
{
    gameInfo = info;
}

function DeusExGameInfo GetGameInfo()
{
    return gameInfo;
}

function Tick(float deltaTime)
{
}

function PlayerLogin(PlayerPawn newPlayer)
{
}
