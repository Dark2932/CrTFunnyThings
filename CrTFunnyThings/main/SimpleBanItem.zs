/*
    Author: Dark2932
    Flie: SimpleBanItem.zs
*/

#priority 10000
#loader crafttweaker reloadableevents
import crafttweaker.item.IItemStack;
import crafttweaker.player.IPlayer;
import crafttweaker.event.PlayerTickEvent;

zenClass SimpleBanItem {

    zenConstructor() {
        print("[SimpleBanItem] An instance loaded!");
    }

    function addSingleItem(item as IItemStack) as SimpleBanItem {
        this.list += item;
        return this;
    }

    function addMultipleItem(items as IItemStack[]) as SimpleBanItem {
        for item in items {
            this.list += item;
        }
        return this;
    }

    function getItems() as IItemStack[] {
        return this.list;
    }

    function register(message as string) {
        events.onPlayerTick(function(event as PlayerTickEvent) {
            val player = event.player;
            val world = player.world;
            if (!world.remote && !player.isFake()) {
                for i in 0 to 9 {
                    val stack = player.getHotbarStack(i);
                    for list in this.list {
                        if (list.matches(stack)) {
                            player.replaceItemInInventory(i, null);
                            player.sendMessage(message);
                        }
                    }
                }
                for i in 0 to 27 {
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

    var list as IItemStack[] = [];
    
}

global SimpleBanItem as SimpleBanItem = SimpleBanItem();