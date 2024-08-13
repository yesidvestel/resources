---@diagnostic disable: duplicate-set-field
-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local found = GetResourceState('tgiann-inventory')
if found ~= 'started' and found ~= 'starting' then return end

WSB.inventorySystem = 'tgiann-inventory'
WSB.inventory = {}

function WSB.inventory.openPlayerInventory(targetId)
    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetId, nil, { showClothe = false })
end

function WSB.inventory.openStash(data)
    -- data = {name = name, unique = true, maxWeight = maxWeight, slots = slots}
    if data.unique then
        data.name = ('%s_%s'):format(data.name, WSB.getIdentifier())
    end
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', data.name, { maxweight = data.maxWeight, slots = data.slots })
    
end

function WSB.inventory.openShop(data)
    --[[
data = {
    identifier = 'shop_identifier',
    name = 'Shop Name',
    inventory = {
        { name = 'item_name', price = 100 },
    },
    locations = {
        vec3(0, 0, 0),
    }
}
]]
    -- local shopData = ConvertShopData(data)

    -- TriggerServerEvent("inventory:server:OpenInventory", "shop", data.name, shopData)
    TriggerServerEvent('wasabi_bridge:registerShop', data)
end
