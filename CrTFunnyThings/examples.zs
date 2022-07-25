/*
    Author: Dark2932
    Flie: examples.zs
*/

#norun
#priority 1
#loader crafttweaker reloadableevents

//example - AFKAutoSpawnItem
AFKAutoSpawnItem.makeProduct(<minecraft:lapis_block>.asBlock(), 10);

//examplae - SimpleBanItem
SimpleBanItem().addSingleItem(<minecraft:bedrock>).register(["delete"], "§f§l[§bSimpleBanItem§f§l] §cThis item is banned!");