//=============================================================================
// LootTable
//=============================================================================
class LootTable extends Actor;

struct LootTableEntry                                                           //RSD: Used to populate a list of random entries
{
	var() Class<Inventory> item;
	var() int weight;
};

var(LootTable) config LootTableEntry entries[11];
var(LootTable) config float slotChance;

defaultproperties
{
     slotChance=1.000000
}
