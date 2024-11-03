//Sarge: Class to manage random numbers so we can use them
//later in a deterministic fashion, set at the start of a playthrough.
//Used by the item randomisers.
class RandomTable extends object;

const MAX_VALUES = 500;

var travel float values[500];
var travel int index;

function Generate()
{
    local int i;
    for (i=0;i<MAX_VALUES;i++)
        values[i] = FRand();
}

function int GetRandomInt(int multiply)
{
    return int(values[GetIndex()] * multiply);
}

function int GetRandomFloat()
{
    return values[GetIndex()];
}

function int GetIndex()
{
    index++;
    if (index >= MAX_VALUES)
        index = 0;

    return index;
}
