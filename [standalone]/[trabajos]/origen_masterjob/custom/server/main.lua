Custom = Custom or {}
local Items = nil
function GetItemData(item)
    if Config.Inventory == 'ox_inventory' then
        local itemsList = exports.ox_inventory:Items()
        local itemData = itemsList[item:lower()] or itemsList[item:upper()]
        if itemData then
            itemData.image = 'https://cfx-nui-ox_inventory/web/images/' .. item:lower() .. '.png'
        end
        return itemData
    else
        if Config.Framework == "qb-core" then
            return QBCore.Shared.Items[item]
        elseif Config.Framework == "esx" then
            if Config.Inventory == "ox_inventory" then 
                for k, v in pairs(exports.ox_inventory:Items()) do
                    if v.name:lower() == item:lower() then
                        v.amount = v.count
                        v.image ='https://cfx-nui-ox_inventory/web/images/'..v.name:lower()..'.png'
                        return v
                    end
                end
                return nil
            elseif Config.Inventory == "origen_inventory" then 
                if not Items then 
                    Items = exports['origen_inventory']:GetItemList()
                end
                return Items[item:lower()]
            elseif Config.Inventory == "codem-inventory" then 
                if not Items then 
                    Items = exports['codem-inventory']:GetItemlist()
                end
                local Item =  Items[item:lower()]
                return codem_fix_item(Item)
            elseif Config.Inventory == "qs-inventory" then 
                if not Items then 
                    Items = exports['qs-inventory']:GetItemList()
                end
                local Item =  Items[item:lower()]
                return qs_fix_item(Item)
            else
                --- your iventory getitem data
            end
        end
    end
end

FW_CreateCallback("origen_masterjob:GetItemData", function(source, cb, item)
    if Config.Inventory == "ox_inventory" then 
        for k, v in pairs(exports.ox_inventory:Items()) do
            if v.name:lower() == item:lower() then
                v.amount = v.count
                v.image ='https://cfx-nui-ox_inventory/web/images/'..v.name:lower()..'.png'
                return cb(v)
            end
        end
        return cb(nil)
    elseif Config.Inventory == "origen_inventory" then 
        if not Items then 
            Items = exports['origen_inventory']:GetItemList()
        end
        debuger('^4ESX Items return ',Items[item:lower()])
        return cb(Items[item:lower()])
    elseif Config.Inventory == "codem-inventory" then 
        if not Items then 
            Items = exports['codem-inventory']:GetItemlist()
        end
        debuger('^4ESX Items return ',Items[item:lower()])
        local Item =  Items[item:lower()]
        return cb(codem_fix_item(Item))
    elseif Config.Inventory == "qs-inventory" then 
        if not Items then 
            Items = exports['qs-inventory']:GetItemList()
        end
        debuger('^4ESX Items return ',Items[item:lower()])
        return cb(Items[item:lower()])
    else
         --- your iventory getitem data
    end
end)

--- only ox_inventory call
FW_CreateCallback("origen_masterjob:RegisterStash", function(source, cb, id, label, slots, weight, owner)
    exports.ox_inventory:RegisterStash(id, label, slots, weight, owner)
    cb();
end)

FW_CreateCallback("origen_masterjob:server:SaveVehicle", function(source, cb, garage, plate, props, gang)
    local Player = FW_GetPlayer(source)
    
    if gang then
        local Gang = GetGang(Player.PlayerData.metadata.gang)

        if Gang then
            if Config.Framework == "qb-core" then
                local result = MySQL.query.await("SELECT citizenid FROM player_vehicles WHERE plate = ?", {plate})

                if result[1] and Gang.Functions.GetPlayer(result[1].citizenid) then
                    cb(MySQL.update.await("UPDATE player_vehicles SET mods = ?, garage = ?, state = ? WHERE plate = ?", {json.encode(props), garage, 1, plate}) > 0)
                else
                    cb(false)
                end
            elseif Config.Framework == "esx" then
                local result = MySQL.query.await("SELECT owner FROM owned_vehicles WHERE plate = ?", {plate})

                if result[1] and Gang.Functions.GetPlayer(result[1].owner) then
                    cb(MySQL.update.await("UPDATE owned_vehicles SET vehicle = ?, parking = ?, stored = ? WHERE plate = ?", {json.encode(props), garage, 1, plate}) > 0)
                else
                    cb(false)
                end
            end
        else
            cb(false)
        end
    else
        if Config.Framework == "qb-core" then
            cb(MySQL.update.await("UPDATE player_vehicles SET mods = ?, garage = ?, state = ? WHERE plate = ? AND citizenid = ?", {json.encode(props), garage, 1, plate, Player.PlayerData.citizenid}) > 0) 
        elseif Config.Framework == "esx" then
            cb(MySQL.update.await("UPDATE owned_vehicles SET vehicle = ?, parking = ?, stored = ? WHERE plate = ? AND owner = ?", {json.encode(props), garage, 1, plate, Player.PlayerData.citizenid}) > 0) 
        end
    end
end)

FW_CreateCallback("origen_masterjob:server:GetVehicles", function(source, cb, garage, gang)
    local Player = FW_GetPlayer(source)
    local retval = {}
    
    if gang then
        local Gang = GetGang(Player.PlayerData.metadata.gang)

        if Gang then
            if Config.Framework == "qb-core" then
                local result = MySQL.query.await("SELECT mods FROM player_vehicles WHERE garage = ? AND state = ?", {garage, 1})

                for i = 1, #result, 1 do
                    local mods = json.decode(result[i].mods)
                    table.insert(retval, mods)
                end
            elseif Config.Framework == "esx" then
                local result = MySQL.query.await("SELECT vehicle FROM owned_vehicles WHERE parking = ? AND stored = ?", {garage, 1})

                for i = 1, #result, 1 do
                    local vehicle = json.decode(result[i].vehicle)
                    table.insert(retval, vehicle)
                end
            end
        end
    else
        if Config.Framework == "qb-core" then
            local result = MySQL.query.await("SELECT mods FROM player_vehicles WHERE citizenid = ? AND garage = ? AND state = ?", {Player.PlayerData.citizenid, garage, 1})

            for i = 1, #result, 1 do
                local mods = json.decode(result[i].mods)
                table.insert(retval, mods)
            end
        elseif Config.Framework == "esx" then
            local result = MySQL.query.await("SELECT vehicle FROM owned_vehicles WHERE owner = ? AND parking = ? AND stored = ?", {Player.PlayerData.citizenid, garage, 1})

            for i = 1, #result, 1 do
                local vehicle = json.decode(result[i].vehicle)
                table.insert(retval, vehicle)
            end
        end
    end

    cb(retval)
end)

RegisterServerEvent("origen_masterjob:server:OutVehicle", function(plate)
    if Config.Framework == "qb-core" then
        MySQL.update.await("UPDATE player_vehicles SET state = ? WHERE plate = ?", {0, plate})
    elseif Config.Framework == "esx" then
        MySQL.update.await("UPDATE owned_vehicles SET stored = ? WHERE plate = ?", {0, plate})
    end
end)

function RemoveItem(xPlayer, name, amount, slot)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:RemoveItem(xPlayer.source, name, amount, slot)
    else
        xPlayer.removeInventoryItem(name, amount, slot)
    end
end

function ClearInventory(xPlayer)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:ClearInventory(xPlayer.source)
    else
        for i = 1, #xPlayer.inventory, 1 do
            if xPlayer.inventory[i].count > 0 then
                xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
            end
        end

        for i = 1, #xPlayer.loadout, 1 do
            xPlayer.removeWeapon(xPlayer.loadout[i].name)
        end

        if xPlayer.getMoney() > 0 then
            xPlayer.removeMoney(xPlayer.getMoney(), "Death")
        end

        if xPlayer.getAccount('black_money').money > 0 then
            xPlayer.setAccountMoney('black_money', 0, "Death")
        end
    end
end

function AddItem(xPlayer, name, amount, slot, info)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:AddItem(xPlayer.source, name, amount, info, slot)
    else
        xPlayer.addInventoryItem(name, amount, info, slot)
    end
end

---@param source = Player.PlayerData.source
function Custom.RemoveMoney(Player, account, amount, log)
    if Config.Inventory == 'ox_inventory' and Config.Money.ItemCash and account == Config.Money.account then
        local success = exports.ox_inventory:RemoveItem(Player.PlayerData.source, account, amount)
        return success
    else
        if Config.Framework == 'qb-core' then
            if Config.Money.ItemCash and account == Config.Money.account then
                local item = exports[Config.Inventory]:GetItemByName(Player.PlayerData.source, account)
                if item and tonumber(item.amount) >= tonumber(amount) then 
                    return exports[Config.Inventory]:RemoveItem(Player.PlayerData.source, account, amount)
                else
                    return false
                end
            else
                if tonumber(Player.PlayerData.money[account]) >= tonumber(amount) then
                    return Player.Functions.RemoveMoney(account, amount, tostring(log))
                end
            end
        elseif Config.Framework == 'esx' then 
            debuger ('account remove money', account, amount)
            if Player.getAccount(account).money >= tonumber(amount) then 
                return Player.Functions.RemoveMoney(account, amount, tostring(log))
            end
        end
    end
    return false 
end

function Custom.CheckItem(itemName)
    if Config.Framework == "qb-core" then
        return exports['qb-core']:GetCoreObject().Shared.Items[itemName]
    else
        return true
    end
end


Custom.GetVehicleKeys = function(source, plate)
    --- your vehiclekeys system
    debuger('Custom.GetVehicleKeys' , source, plate)
    TriggerClientEvent("vehiclekeys:client:SetOwner",source, plate)
end

Custom.GetVehicleData = function(plate)
    debuger('GetPlate', plate)
    if Config.Framework == "qb-core" then
        local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?',{plate})
        debuger('GetPlate', json.encode(result))
        if result and result[1] then 
            return {
                owner = result[1].citizenid
            }
        else
            return false 
        end
    elseif Config.Framework == "esx" then
        local result = MySQL.query.await("SELECT * FROM owned_vehicles WHERE plate = ? ", {plate})
        if result  and result[1] then 
            return {
                owner = result[1].owner
            }
        else
            return false 
        end
    end
end

Custom.PlateGenerator = function()
    local plate = ''
    --- your system generate Plate
    return plate
end

Custom.QueryGiveBusinesscar = function(values)
    if Config.Framework == "qb-core" then 
        MySQL.query.await('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage) VALUES (?, ?, ?, ?, ?, ?, ?)', values)
    elseif Config.Framework == "esx" then
        MySQL.query.await('INSERT INTO owned_vehicles (owner, plate, vehicle, job, stored, parking) VALUES (?, ?, ?, ?, ?, ?)', values)
    end
end

Custom.QueryRemoveBusinesscar = function(values)
    if Config.Framework == "qb-core" then 
        MySQL.query.await('DELETE FROM player_vehicles WHERE citizenid = ? AND plate = ?', values)
    elseif Config.Framework == "esx" then
        MySQL.query.await('DELETE FROM owned_vehicles WHERE owner = ? AND plate = ?', values)
    end
end

-- Custom SendBill
-- Info: Replace the false value from Custom.SendBill with your own function
--       The data value contains {senderSource, receiverSource, price, concept, business}
--       You have to respond to the callback with true if the bill was sent successfully, otherwise respond with the error message
-- 
-- Example:
-- Custom.SendBill = function(data, cb)
--     local success = MySQL.insert.await('INSERT INTO bills (sender, receiver, price, concept) VALUES (?, ?, ?, ?)', {data.senderSource, data.receiverSource, data.price, data.concept})
--     cb(success or 'Failed to send bill')
-- end

Custom.SendBill = false

FW_CreateCallback('qs-inventory:server:GetStashItems', function(source,cb, stash) 
    local stash = exports['qs-inventory']:GetStashItems(stash)
    cb(qs_fix_({items = stash}).items)
end)


FW_CreateCallback('codem-inventory:server:GetStashItems', function(source,cb, stash) 
local stash = exports['codem-inventory']:GetInventoryItems('Stash',stash)
cb(codem_fix_({items = stash or {}}).items)
end)

--codem 
RegisterNetEvent('codem-inventory:server:SaveStashItems', function(id, items)
    exports["codem-inventory"]:SaveStashItems(id, items)
end)

Codem = Codem or {}

function Codem.GetInventoryItems(id)
    return exports[Config.Inventory]:GetInventoryItems("Stash",Player.PlayerData.job.name .. "_stash")
end