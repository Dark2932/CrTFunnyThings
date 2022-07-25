/*
    Author: Dark2932
    Flie: SimpleBanItem.zs
*/

#priority 100000
#loader crafttweaker reloadableevents
import crafttweaker.item.IItemStack;
import crafttweaker.event.BlockBreakEvent;
import crafttweaker.event.BlockPlaceEvent;
import crafttweaker.event.PlayerRightClickItemEvent;
import crafttweaker.event.PlayerTickEvent;

zenClass SimpleBanItem {

    var list as IItemStack[] = [];
    var isNullList as bool = true;

    zenConstructor() {
        print("[SimpleBanItem] An instance loaded!");
    }

    function addSingleItem(item as IItemStack) as SimpleBanItem {
        this.list += item;
        item.addTooltip("§4该物品在服务器已被封禁！");
        this.isNullList = false;
        return this;
    }

    function addMultipleItem(items as IItemStack[]) as SimpleBanItem {
        for item in items {
            this.list += item;
            item.addTooltip("§4该物品在服务器已被封禁！");
        }
        this.isNullList = false;
        return this;
    }

    function addBannedTypeTip(type as string) as SimpleBanItem {
        if (!isNullList) {
            for item in this.list {
                if (type == "delete")  {
                    item.addTooltip("§2类型：§r§n直接清除");
                }
                if (type == "use")  {
                    item.addTooltip("§2类型：§r§n禁止使用");
                }
                if (type == "build")  {
                    item.addTooltip("§2类型：§r§n禁止放置和破坏");
                }
            }
        }
        return this;
    }

    function getItems() as IItemStack[] {
        return this.list;
    }

    function getItemsWithNumber() as string[] {
        var items as string[] = [];
        for i, item in this.list {
            items += i + 1 ~ ". §2" ~ toString(item);
        }
        return items;
    }

    function registerDelete(message as string) {
        events.onPlayerTick(function(event as PlayerTickEvent) {
            val player = event.player;
            val world = player.world;
            if (player.creative) return;
            if (!world.remote && !player.isFake()) {
                for i in 0 to 36 {
                    val stack = player.getInventoryStack(i);
                    for list in this.list {
                        if (list.matches(stack)) {
                            player.replaceItemInInventory(i, null);
                            player.sendMessage(message);
                        }
                    }
                }
            }
        });
    }

    function registerUse(message as string) {
        events.onPlayerRightClickItem(function(event as PlayerRightClickItemEvent) {
            val player = event.player;
            if (player.creative) return;
            for item in this.list {
                if (!event.world.remote && item.matches(event.item)) {
                    player.sendMessage(message);
                    event.cancel();
                }
            }
        });
    }

    function registerBuild(message as string) {
        events.onBlockPlace(function(event as BlockPlaceEvent) {
            val world = event.world;
            val player = event.player;
            val block = event.block;
            if (player.creative) return;
            if (!world.remote && !player.isFake()) {
                for item in this.list {
                    if (item.isItemBlock && BlockUtils.getBlockID(item.asBlock(), false) == BlockUtils.getBlockID(block, false)) {
                        player.sendMessage(message);
                        event.cancel();
                    }
                }
            }
        });
        events.onBlockBreak(function(event as BlockBreakEvent) {
            val world = event.world;
            val player = event.player;
            val block = event.block;
            if (player.creative) return;
            if (!world.remote && event.isPlayer && !player.isFake()) {
                for item in this.list {
                    if (item.isItemBlock && BlockUtils.getBlockID(item.asBlock(), false) == BlockUtils.getBlockID(block, false)) {
                        player.sendMessage(message);
                        event.cancel();
                    }
                }
            }
        });
    }
    
}