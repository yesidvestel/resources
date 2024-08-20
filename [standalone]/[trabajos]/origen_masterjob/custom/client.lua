Custom = {}

Buffer = {}

function origenHelp(text)
    if Buffer[text] then
        Buffer[text].time = GetGameTimer()
    else
        local textformated = text or ""
        local key = ""
        
        if string.find(textformated, "~y~") then
            textformated = string.gsub(textformated, "~y~", "")
            key = string.sub(textformated, 1, 1)
            textformated = string.sub(textformated, 2)
            textformated = string.gsub(textformated, "~w~", "")
        end
        
        Buffer[text] = {
            time = GetGameTimer(),
            noty = exports["origen_notify"]:CreateHelp(key, textformated)
        }
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        for k, v in pairs(Buffer) do
            if GetGameTimer() - v.time > 200 then
                exports["origen_notify"]:RemoveHelp(v.noty)
                Buffer[k] = nil
            end
        end
    end
end)

function ShowHelpNotification(key, msg)
    if Config.OrigenNotify then
        origenHelp('~y~' .. key .. '~w~ ' .. msg)
    else
        -- Add your own ShowHelpNotification(key,msg)
    end
end


Custom.DrawText = function( key,msg)
    if key then 
        print ('CustomDrawtext', key, msg)
    else 
        print ('CustomDrawtext', msg)
    end
end
Custom.HideText = function()
    print ('Custom hide')
end


Custom.ShowShopState = function(msg)
    if not Config.CustomNotify then
        if Config.Framework == "qb-core" then
            QBCore.Functions.Notify(msg, "primary")
        elseif Config.Framework == "esx" then
            ESX.ShowNotification(msg)
        end
    else
        exports["origen_notify"]:ShowNotification(msg, "business")
        -- Put your code here if you want to use a custom notification
    end
end

-- @param msg string 
Custom.ShowNotification = function (msg)
    if not Config.CustomNotify then
        if Config.Framework == "qb-core" then
            QBCore.Functions.Notify(msg, "primary")
        elseif Config.Framework == "esx" then
            ESX.ShowNotification(msg)
        end
    else
        print('ADD YOUR CUSTOM NOTIFY custom/client.lua :81')
        -- Add here your custom notification
        -- Example:
        -- exports["origen_notify"]:ShowNotification(msg, "business")
    end
end

function GetItemData(item)
    if Config.Inventory == "ox_inventory" then
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
            local data = nil
            debuger('^3 check Items exist ....')
            FW_TriggerCallback("origen_masterjob:GetItemData", function(dataR)
                data = dataR
            end, item)
            
            while data == nil do
                Citizen.Wait(0)
            end
            debuger('^2 Item exist')
            return data
        end
    end
end



-- @param Sid string
-- @param Sslots number
-- @param label string
function OpenStash(Sid, Sslots, label)
    if Config.Inventory == "ox_inventory" then
        if exports.ox_inventory:openInventory('stash', Sid) == false then
            FW_TriggerCallback("origen_masterjob:RegisterStash", function()
                exports.ox_inventory:openInventory('stash', {id=Sid, owner=false})
            end, Sid, label, Sslots, 100000, false)
        end
    elseif Config.Inventory == 'codem-inventory' then 
        exports['codem-inventory']:OpenStash(Sid, 1200000, Sslots)
    else
        if newQBInventory then
            local data = { label = label, slots = Sslots, maxweight = 100000 }
            TriggerServerEvent("origen_masterjob:server:openNewQBStash", Sid, data)
        else
            TriggerServerEvent("inventory:server:OpenInventory", "stash", Sid, {
                slots = Sslots,
                label = label
            })
            TriggerEvent("inventory:client:SetCurrentStash", Sid)
        end
    end
end

function OpenOutfitMenu()
    if Config.Clothing == "qb-clothing" then 
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    elseif Config.Clothing == "illenium-appearance" then
        TriggerEvent('illenium-appearance:client:openOutfitMenu')
    else
        Custom.ShowNotification("Your clothing system isn't suppported right now, file: custom/client.lua")
    end
end

function openPlayerInventory(pID)
    pID = tonumber(pID)
    if Config.Inventory == 'ox_inventory' then
        exports.ox_inventory:openNearbyInventory()
    elseif Config.Inventory == 'qb-inventory' then
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", pID)
    end
end

--------------------------------------------
-------------  Custom Garage ---------------
--------------------------------------------
function CustomGarage(PlayerData, coords)
    -- Add here your own garage system
end

function CustomGarageBusiness(PlayerData, coords)
    -- Add here your own garage system
end

---------------------------
------   Mechanic    ------
---------------------------
Custom.ReapirVehicle = function(vehicle)
    --exports['VehicleDeformation']:FixVehicleDeformation(vehicle)
end
Custom.GetVehicleProperties = function(vehicle)
    if Config.Framework == "qb-core" then
        return QBCore.Functions.GetVehicleProperties(vehicle)
    elseif Config.Framework == "esx" then
        return ESX.Game.GetVehicleProperties(vehicle)
    end
end

Custom.SetVehicleProperties = function(vehicle, mods)
    if Config.Framework == "qb-core" then
        QBCore.Functions.SetVehicleProperties(vehicle, mods)
    elseif Config.Framework == "esx" then
        ESX.Game.SetVehicleProperties(vehicle, mods)
    end
end

Custom.GetVehicleFuel = function(vehicle)
    -- Add here your own fuel system
    -- Example:
    -- return exports['FuelSystem']:GetFuel(vehicle)
end

Custom.SetVehicleFuel = function(vehicle, fuel)
    -- Add here your own fuel system
    -- Example:
    -- exports['FuelSystem']:SetFuel(vehicle, fuel)
end

Custom.OpenModificationMenu = function(vehicle)
    -- Add here your own tunning system
end

-- your custom key system
Custom.GetClientVehicleKeys = function(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    debuger('Custom.GetVehicleKeys', plate)
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
end

function Custom.SpawnVehicle(model, cb, coords, isNetwork)
    if Config.Framework == "qb-core" then
        QBCore.Functions.SpawnVehicle(model, cb, coords, isNetwork)
    elseif Config.Framework == "esx" then
        ESX.Game.SpawnVehicle(model, coords, 0.0, cb, isNetwork)
    end
end

--[[
    -- your custom open menu
RegisterCommand('customs',function() 
    Tunning.OpenTunnigMenu() 
end, true)

RegisterNetEvent('origen_masterjob:open_mechanic',funciton() 
    Tunning.OpenTunnigMenu() 
end)
]]