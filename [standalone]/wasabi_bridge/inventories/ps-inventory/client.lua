---@diagnostic disable: duplicate-set-field
-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
-- Use this file to add support for another inventory by simply copying the file and replacing the logic within the functions
local found = GetResourceState('ps-inventory')
if found ~= 'started' and found ~= 'starting' then return end

WSB.inventorySystem = 'ps-inventory'
WSB.inventory = {}

OldInventory = GetResourceMetadata(WSB.inventorySystem, 'version', 0)
OldInventory = OldInventory:gsub('%.', '')
OldInventory = tonumber(OldInventory)
if not OldInventory or OldInventory >= 105 then OldInventory = false end
local inventoryPrefix = OldInventory and 'inventory' or 'ps-inventory'

function WSB.inventory.openPlayerInventory(targetId)
    TriggerServerEvent(inventoryPrefix .. ':server:OpenInventory', 'otherplayer', targetId)
    TriggerEvent(inventoryPrefix .. 'inventory:server:RobPlayer', targetId)
end

function WSB.inventory.openStash(data)
    -- data = {name = name, unique = true, maxWeight = maxWeight, slots = slots}
    if data.unique then
        data.name = ('%s_%s'):format(data.name, WSB.getIdentifier())
    end

    TriggerServerEvent(inventoryPrefix .. ':server:OpenInventory', 'stash', data.name,
        { maxweight = data.maxWeight, slots = data.slots })
    TriggerEvent(inventoryPrefix .. ':client:SetCurrentStash', data.name)
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
]]
    local shopData = ConvertShopData(data)

    TriggerServerEvent(inventoryPrefix .. ":server:OpenInventory", "shop", data.identifier, shopData)
end
