Citizen.CreateThread(function ()
    while true do
        if Config.Inventory ~= "qb-inventory" and Config.Inventory ~= "origen_inventory" and Config.Inventory ~= "ls-inventory" then break end
        Wait(10000)
        local time = os.date("*t")

        if time.hour == 23 then
            MySQL.query('DELETE FROM stashitems WHERE stash LIKE "armas_policiales%"')
            print('SAPD - Armouty inventory deleted')
            break
        end
    end
    if GetResourceState("ox_inventory") ~= "started" then return end
    
    for mapIndex, _ in pairs(Tables.Markers) do 
        exports.ox_inventory:RegisterStash('armas_policiales_'..mapIndex, Config.Translations['Equipment'], 100, 100*1000, true)
    end
    exports.ox_inventory:RegisterStash('OrigenPersonalStash', Config.Translations['Equipment'], 100, 100*1000, true)
end)

function LeaveTakePertenences(station, source)
    local Player = FW_GetPlayer(source)
    if Config.Inventory == "ox_inventory" or Config.Inventory == "qs-inventory" or Config.Inventory == "codem-inventory" then  
        if Player.PlayerData.metadata["pertenencesSaved"] and type(Player.PlayerData.metadata["pertenencesSaved"]) == "table" then
            for k, v in pairs(Player.PlayerData.metadata["pertenencesSaved"]) do 
                Player.Functions.AddItem(v.name, v.count, k, v.metadata)
            end
            Player.Functions.SetMetaData("pertenencesSaved", 0)
            TriggerClientEvent("origen_police:ShowNotification", source, Config.Translations.PertenencesPickUp)
        else
            if #Player.PlayerData.items == 0 then 
                return
            end
            local itemsToSave = {}
            for k, v in pairs(Player.PlayerData.items) do 
                if not v then return end
                itemsToSave[v.slot] = {
                    name = v.name,
                    count = Config.Inventory == "ox_inventory" and v.count or v.amount,
                    metadata = Config.Inventory == "ox_inventory" and v.metadata or v.info
                }
            end
            Player.Functions.SetMetaData("pertenencesSaved", itemsToSave)
            if Config.Inventory == "qs-inventory" then 
                exports['qs-inventory']:ClearInventory(source)
            else
                Player.Functions.ClearInventory()
            end
            TriggerClientEvent("origen_police:ShowNotification", source, Config.Translations.LeavePertenences)
        end
        return
    end

    local stashID = (Config.Inventory == "origen_inventory" and "stash_" or "")..(Config.Framework == "esx" and string.match(Player.PlayerData.citizenid, ":(.*)") or Player.PlayerData.citizenid) .. "_police_station_" .. station
    local stash = exports[Config.Inventory]:GetStashItems(stashID)
    local has = false
    for _, _ in pairs(stash) do
        has = true
        break
    end

    if has then
        Player.Functions.ClearInventory()
        for k, v in pairs(stash) do
            Player.Functions.AddItem(v.name, v.amount, v.slot, v.info)
        end
        TriggerEvent(Config.Inventory .. ":server:SaveStashItems", stashID, {})
        TriggerClientEvent("origen_police:ShowNotification", source, Config.Translations.PertenencesPickUp)
    else
        local playerItems = {}
        if Config.Inventory == "origen_inventory" then 
            playerItems = exports.origen_inventory:GetInventory(source)
        else
            playerItems = Player.PlayerData.items
        end
        TriggerEvent(Config.Inventory .. ":server:SaveStashItems", stashID, playerItems)
        Player.Functions.ClearInventory()
        TriggerClientEvent("origen_police:ShowNotification", source, Config.Translations.LeavePertenences)
    end
end

function GetTrunkItems(plate)
    if Config.Inventory == "qs-inventory" then
        local data = MySQL.awaitQuery("SELECT items FROM inventory_trunk WHERE plate = ? LIMIT 1", {plate})
        if data[1] == nil then return nil end
        local result = json.decode(data[1].items)
        result = {
            items = result,
        }
        return result
    elseif Config.Inventory == "ox_inventory" then
        return exports['ox_inventory']:GetInventoryItems('trunk'..plate)
    elseif Config.Inventory == "codem-inventory" then
        local data = MySQL.awaitQuery("SELECT trunk FROM codem_new_vehicleandglovebox WHERE plate = ?", {plate})

        if data[1] == nil then return nil end
        local result = json.decode(data[1].trunk)
        result = {
            items = result,
        }
        return result
    end

    return exports[Config.Inventory]:GetTrunk(plate)
end

function GetGloveboxItems(plate)
    if Config.Inventory == "qs-inventory" then
        local data = MySQL.awaitQuery("SELECT items FROM inventory_glovebox WHERE plate = ? LIMIT 1", {plate})
        if data[1] == nil then return nil end
        local result = json.decode(data[1].items)
        result = {
            items = result,
        }
        return result
    elseif Config.Inventory == "ox_inventory" then
        return exports['ox_inventory']:GetInventoryItems('glove'..plate)
    elseif Config.Inventory == "codem-inventory" then
        local data = MySQL.awaitQuery("SELECT glovebox FROM codem_new_vehicleandglovebox WHERE plate = ?", {plate})

        if data[1] == nil then return nil end
        local result = json.decode(data[1].glovebox)
        result = {
            items = result,
        }
        return result
    end

    return exports[Config.Inventory]:GetGlovebox(plate)
end

function RegisterShop(...)
    if Config.Inventory == "ox_inventory" then
        local items = select(2, ...).inventory
        for k, v in pairs(items) do 
            v.metadata = {}
            v.metadata.serial = v.info.serie
            v.metadata.components = {}
            if v.info and v.info.attachments then
                for z, u in pairs(v.info.attachments) do 
                    v.metadata.components[z] = u.component:lower()
                end
            end
        end
        return exports['ox_inventory']:RegisterShop(...)
    end
end

function AddItem(xPlayer, name, amount, slot, info)
    if Config.Inventory == "ox_inventory" then
        return exports.ox_inventory:AddItem(xPlayer.source, name, amount, info, slot)
    elseif Config.Inventory == "core_inventory" then
        return exports['core_inventory']:addItem("content-"..xPlayer.getIdentifier():gsub(":", ""), name, amount, info, content)
    end

    return xPlayer.addInventoryItem(name, amount, slot, info)
end

function RemoveItem(xPlayer, name, amount, slot)
    if Config.Inventory == "origen_inventory" then
        return exports.origen_inventory:RemoveItem(xPlayer.source, name, amount)
    elseif Config.Inventory == "ox_inventory" then
        return exports.ox_inventory:RemoveItem(xPlayer.source, name, amount, nil, slot)
    end
    return xPlayer.removeInventoryItem(name, amount, slot)
end

function GetItemFromSlot(xPlayer, slot)
    if Config.Inventory == "origen_inventory" then
        return exports.origen_inventory:GetItemBySlot(xPlayer.source, slot)
    elseif Config.Inventory == "core_inventory" then
        return exports['core_inventory']:getInventory('primary-' .. (Config.Framework == "esx" and xPlayer.citizenid:gsub(':','') or xPlayer.citizenid))[1]
    end
    for k, v in pairs(xPlayer.items) do 
        if v.slot == slot then
            return v
        end
    end
end

if Config.Framework == "esx" then 
    Citizen.CreateThread(function()
        FW_CreateCallback("origen_police:server:GetInventory", function(source, cb)
            local Player = Framework.GetPlayerFromId(source)
            cb(Player ~= nil and Player.getInventory() or {})
        end)
    end)
end

if Config.Inventory == 'codem-inventory' then
    RegisterServerEvent('origen_police:server:SetInventoryRobStatus')
    AddEventHandler('origen_police:server:SetInventoryRobStatus', function(playerId, val)
        TriggerClientEvent('codem-inventory:client:robstatus', playerId, val)
    end)
end

-- NEW QB INV UPDATE
local ArmouryRegistered = false

RegisterNetEvent("origen_police:new-qb-inv:OpenArmoury", function()
    local src = source
    if not ArmouryRegistered then
        ArmouryRegistered = true
        exports["qb-inventory"]:CreateShop({
            name = "OrigenPoliceArmoury",
            label = "Origen Police Armoury",
            coords = GetEntityCoords(GetPlayerPed(src)),
            items = Config.Armory.items
        })
    end
    exports["qb-inventory"]:OpenShop(src, "OrigenPoliceArmoury")
end)

RegisterNetEvent("origen_police:new-qb-inv:OpenStash", function(invName, label, maxweight, slots)
    local src = source
    local data = { label = label, maxweight = maxweight, slots = slots }
    exports['qb-inventory']:OpenInventory(src, invName, data)
end)

RegisterNetEvent("origen_police:new-qb-inv:OpenPInv", function(targetId)
    local src = source
    exports['qb-inventory']:OpenInventoryById(src, targetId)
end)