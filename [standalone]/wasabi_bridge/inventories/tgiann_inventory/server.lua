---@diagnostic disable: duplicate-set-field
-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local found = GetResourceState('tgiann-inventory')
if found ~= 'started' and found ~= 'starting' then return end

WSB.inventorySystem = 'tgiann-inventory'
WSB.inventory = {}

local registeredShops = {}
RegisterNetEvent('wasabi_bridge:registerShop', function(data)
    local src = source
    if registeredShops[data.identifier] then
       exports["tgiann-inventory"]:OpenInventory(src, 'shop', data.identifier, data.identifier)
        return
    end

    exports["tgiann-inventory"]:RegisterShop(data.identifier,data.inventory)
    registeredShops[data.identifier] = data
    exports["tgiann-inventory"]:OpenInventory(src, 'shop', data.identifier, data.identifier)
end)

function WSB.inventory.getItemSlot(source, itemName)
    return GetItemSlot(source, itemName) or false
end

function WSB.inventory.getItemMetadata(source, slot)
    if not source or not slot then return end
    return exports["tgiann-inventory"]:GetItemBySlot(source, slot).metadata
end

function WSB.inventory.setItemMetadata(source, slot, metadata)
    if not slot then return false end
    if not metadata then metadata = {} end
    local item = exports["tgiann-inventory"]:GetItemBySlot(source, slot)
    exports["tgiann-inventory"]:UpdateItemMetadata(source, item.name, slot, metadata)
end

local function isInList(item, list)
    for _, value in ipairs(list) do
        if value == item then
            return true
        end
    end
    return false
end

---Clears specified inventory
---@param source number
---@param keepItems string | table
function WSB.inventory.clearInventory(source, identifier, keepItems)
    exports["tgiann-inventory"]:ClearInventory(source)
        TriggerClientEvent('wasabi_ambulance:weaponRemove', source)

    local invData = exports["tgiann-inventory"]:GetPlayerItems(source)
    for _, item in pairs(invData) do
        if item.count > 0 and not isInList(item.name, keepItems) then
            exports["tgiann-inventory"]:RemoveItem(source, item.name, item.count, item.key)
        end
    end
end
