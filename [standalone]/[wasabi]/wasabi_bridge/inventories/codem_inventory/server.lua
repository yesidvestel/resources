---@diagnostic disable: duplicate-set-field
-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
-- Use this file to add support for another inventory by simply copying the file and replacing the logic within the functions
local found = GetResourceState('codem-inventory')
if found ~= 'started' and found ~= 'starting' then return end

WSB.inventory = {}
WSB.inventorySystem = 'codem-inventory'

function WSB.inventory.getItemSlot(source, itemName)
    return GetItemSlot(source, itemName) or false
end

function WSB.inventory.getItemMetadata(source, slot)
    local player = WSB.getPlayer(source)
    if not player then return end
    return exports['codem-inventory']:GetItemBySlot(source, slot).info
end

function WSB.inventory.setItemMetadata(source, slot, metadata)
    if not slot then return false end
    if not metadata then metadata = {} end

    exports['codem-inventory']:SetItemMetadata(source, slot, metadata)
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
    local invData = exports['codem-inventory']:GetInventory(identifier, source)
    for _, item in pairs(invData) do
        if item.count > 0 and not isInList(item.name, keepItems) then
            exports['codem-inventory']:RemoveItem(source, item.name, item.count)
        end
    end

    exports['codem-inventory']:SaveInventory(source, false)
end
