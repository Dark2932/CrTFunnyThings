/*
    Author: Dark2932
    Flie: AFK_Place.zs
*/

#priority 10000
#loader crafttweaker reloadableevents
import crafttweaker.data.IData;
import crafttweaker.block.IBlock;
import crafttweaker.item.IItemStack;
import crafttweaker.event.PlayerInteractBlockEvent;
import crafttweaker.event.WorldTickEvent;

zenClass AFKPlace {

    zenConstructor(arg as string) {
        this.id = arg;
    }

    function getBlockID(block as IBlock) as string {
        return BlockUtils.getBlockID(block, false);
    }

    function getItemID(item as IItemStack) as string {
        return ItemUtils.getItemID(item, true);
    }

    function makePlace(Block as IBlock) {
        events.onPlayerInteractBlock(function(event as PlayerInteractBlockEvent) {

            val player = event.player;
            val world = event.world;
            val item = event.item;
            val block = event.block;
            val ID1 = this.getBlockID(block);
                
            if (!world.remote && player.isSneaking && ID1 == this.getBlockID(Block) && !isNull(item)) {

                //save
                if (!(<minecraft:flint>.matches(item))) {
                    val ID2 = this.getItemID(item);
                    player.sendMessage("§6==================================================");
                    player.sendMessage("§a§l选中物品: §e" ~ ID2);
                    player.sendMessage("§b§l资源刷新: §c关闭");
                    player.sendMessage("§c§l按住 §eShift §c§l并使用 §e燧石 §c§l以开启资源刷新!");
                    this.worldBlock = ID1;
                    this.worldItem = item;
                    this.x = event.x;
                    this.y = event.y;
                    this.z = event.z;
                    this.c = 1;
                }
                
                //start and close
                else if (this.c == 1) {
                    //start
                    if (this.s == 0) {
                        player.sendMessage("§b§l资源刷新: §a开启");
                        player.sendMessage("§d§l刷新频率: §e" + this.v + "s/个");
                        this.s += 1;
                    }

                    //close
                    else if (this.s == 1) {
                        player.sendMessage("§b§l资源刷新: §c关闭");
                        this.s = 0;
                    }

                }

            }

        });
    }

    function makeProduct(Block as IBlock, second as double) {
        this.makePlace(Block);
        this.v = second;
        events.onWorldTick(function(event as WorldTickEvent) {
            val world = event.world;
            if (!world.remote && event.phase == "START") {
                    this.t += 1;
                if ((this.t % (second * 20) == 0) && this.s == 1) {
                    val x = this.x;
                    val y = this.y;
                    val z = this.z;
                    val WorldBlock = world.getBlock(x, y, z);
                    if (this.worldBlock == this.getBlockID(WorldBlock)) {
                        world.spawnEntity(this.worldItem.withAmount(1).createEntityItem(world, x, y + 1, z));
                    }
                    this.t = 0;
                }
            }
        });
    }
    
    val id as string;
    val v as double;
    var t as int = 0;
    var c as int = 0;
    var s as int = 0;
    var x as int;
    var y as int;
    var z as int;
    var worldBlock as string = "null";
    var worldItem as IItemStack = null;

}

global AFKPlace as AFKPlace = AFKPlace("Instanced");