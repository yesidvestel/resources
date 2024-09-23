-- Function will auto detect the inventory script that is running
local function DetectInventory()
    local IS_qb_inventory = GetResourceState('qb-inventory') == 'started'
    local IS_lj_inventory = GetResourceState('lj-inventory') == 'started'
    local IS_ps_inventory = GetResourceState('ps-inventory') == 'started'
    if IS_qb_inventory then
        return 'qb-inventory'
    elseif IS_lj_inventory then
        return 'lj-inventory'
    elseif IS_ps_inventory then
        return 'ps-inventory'
    else
        return 'none'
    end
end

-- Function to check if an export exists
local function exportExists(resource, exportName)
    local exists = false
    local status, result = pcall(function()
        return exports[resource][exportName]
    end)
    if status and result ~= nil then
        exists = true
    end
    return exists
end

local inventory = DetectInventory()

local GetItem_inv = exportExists(inventory, 'GetItemsByName') -- Exports to get items from inventory

local AddItem_inv = exportExists(inventory, 'AddItem')  -- Exports to add items to inventory

local RemoveItem_inv = exportExists(inventory, 'RemoveItem')  -- Exports to remove items from inventory

QBCore = exports['qb-core']:GetCoreObject()

PlayerLoaded = 'QBCore:Server:PlayerLoaded' -- Triggered when a player is fully loaded in

-- Function to get items from inventory
function GetItemsByName(src, item)
    local Player = QBCore.Functions.GetPlayer(src)

    if GetItem_inv then
        return exports[inventory]:GetItemsByName(src, item)
    else
        return Player.Functions.GetItemsByName(item)
    end
end

-- Function to add items to inventory
function AddItem(src, item, amount)
    local Player = QBCore.Functions.GetPlayer(src)

    if AddItem_inv then
        exports[inventory]:AddItem(src, item, amount)
    else
        Player.Functions.AddItem(item, amount)
    end

    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
end

-- Function to remove items from inventory
function RemoveItem(src, item, amount, slot)
    local Player = QBCore.Functions.GetPlayer(src)

    if RemoveItem_inv then
        exports[inventory]:RemoveItem(src, item, amount, slot)
    else
        Player.Functions.RemoveItem(item, amount, slot)
    end

    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
end

-- Function to get money from account
function GetMoney(src, accountype)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player.Functions.GetMoney(accountype)
end

-- Function to remove money from account
function RemoveMoney(src, accountype, amount, reason)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney(accountype, amount, reason)
end

-- function to add money to account
function AddMoney(src, accountype, amount, reason)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney(accountype, amount, reason)
end
