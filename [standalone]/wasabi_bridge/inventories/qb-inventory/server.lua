---@diagnostic disable: duplicate-set-field
-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
-- Use this file to add support for another inventory by simply copying the file and replacing the logic within the functions
local found = GetResourceState('qb-inventory')
local qsFound = GetResourceState('qs-inventory')
if found ~= 'started' and found ~= 'starting' then return end
if qsFound == 'started' or qsFound == 'starting' then return end

WSB.inventory = {}
WSB.inventorySystem = 'qb-inventory'

OldInventory = GetResourceMetadata(WSB.inventorySystem, 'version', 0)
OldInventory = OldInventory:gsub('%.', '')
OldInventory = tonumber(OldInventory)
if not OldInventory or OldInventory >= 200 then OldInventory = false end

if not OldInventory then
    local registeredShops = {}
    RegisterNetEvent('wasabi_bridge:registerShop', function(data)
        local src = source
        if registeredShops[data.identifier] then
            exports['qb-inventory']:OpenShop(src, data.identifier)
            return
        end

        exports['qb-inventory']:CreateShop({
            name = data.identifier,
            label = data.name,
            slots = #data.inventory,
            items = data.inventory -- { name = 'sandwich', price = 5 }
        })
        registeredShops[data.identifier] = data
        exports['qb-inventory']:OpenShop(src, data.identifier)
    end)

    RegisterNetEvent('wasabi_bridge:openStash', function(data)
        local src = source
        exports['qb-inventory']:OpenInventory(src, data.name,
            { label = data.name, slots = data.slots, maxweight = data.maxWeight })
    end)

    RegisterNetEvent('wasabi_bridge:openPlayerInventory', function(targetId)
        local src = source
        exports['qb-inventory']:OpenInventoryById(src, targetId)
    end)
end


function WSB.inventory.getItemSlot(source, itemName)
    return GetItemSlot(source, itemName) or false
end

function WSB.inventory.getItemMetadata(source, slot)
    local player = WSB.getPlayer(source)
    if not player then return end
    return player.Functions.GetItemBySlot(slot).info
end

function WSB.inventory.setItemMetadata(source, slot, metadata)
    if not slot then return false end
    local player = WSB.getPlayer(source)
    if not player then return end
    local item = player.Functions.GetItemBySlot(slot)
    if not item then return false end
    item.info = metadata
    player.PlayerData.items[slot] = item
    player.Functions.SetPlayerData("items", player.PlayerData.items)
    return true
end

---Clears specified inventory
---@param source number
---@param keepItems string | table
function WSB.inventory.clearInventory(source, identifier, keepItems)
    exports['qb-inventory']:ClearInventory(source, keepItems)
end
