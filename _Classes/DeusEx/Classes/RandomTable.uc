//Sarge: Class to manage random numbers so we can use them
//later in a deterministic fashion, set at the start of a playthrough.
//Used by the item randomisers.
class RandomTable extends object;

// Linear Congruent RNG for 16-bit integers
// parameters https://www.pcg-random.org/posts/visualizing-the-heart-of-some-prngs.html
// Sarge: Provided by RSD. This is all greek to me

const m_mod = 65536; //2^16
const a_mult = 25385; //optimal primitive element of 2^16
const c_inc = 1337; //any odd number
                            
var int internal_randval;

// Seed with integer between 0 and 2^32
function Seed(int seed)
{
    internal_randval = abs(seed) % m_mod;
}

function iterateRand()
{
    internal_randval = (a_mult*internal_randval + c_inc) % m_mod;
}

function int GetRandomInt(int max)
{
    local int randOut;

    iterateRand();
    //randOut = internal_randval % max; //RSD: biases the least significant bits for bad cycle period
    randOut = (max*internal_randval)/m_mod;


    return randOut;
}

function float GetRandomFloat()
{
    local float randOut;

	iterateRand();
	randOut = float(internal_randval)/float(m_mod);
	
	return randOut;
}
