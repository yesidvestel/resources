
local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("insidetrack:server:getbalance", function(source, cb)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local Chips = Player.Functions.GetItemByName("casino_goldchip")
    local minAmount = 100
    if Chips ~= nil then 
        if Chips.amount >= minAmount then
            Chips = Chips 
        else
            return TriggerClientEvent('QBCore:client:closeBetsNotEnough', src)
        end
    else
        return TriggerClientEvent('QBCore:client:closeBetsZeroChips', src)
    end
end)

RegisterServerEvent("insidetrack:server:placebet", function(bet)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local Chips = Player.Functions.GetItemByName("casino_goldchip")
    if Chips ~= nil then 
        if Chips.amount >= bet then
            Player.Functions.RemoveItem("casino_goldchip", bet)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['casino_goldchip'], "remove", bet)
            TriggerClientEvent('QBCore:Notify', src, "Has hecho una apuesta de "..bet.." fichas de casino")
        else
            return TriggerClientEvent('QBCore:client:closeBetsNotEnough', src)
        end
    else
        return TriggerClientEvent('QBCore:client:closeBetsZeroChips', src)
    end
end)

RegisterServerEvent("insidetrack:server:winnings", function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        if Player.Functions.AddItem('casino_goldchip', amount, nil, {["quality"] = 100}) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["casino_goldchip"], "add", amount)
            TriggerClientEvent('QBCore:Notify', src, "¡Ganaste "..amount.." fichas de casino!")
        else
            TriggerClientEvent('QBCore:Notify', src, 'Tienes demasiadas fichas en tus bolsillos', 'error')
        end
    end
end)

