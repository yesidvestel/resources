AddMoneyToSociety = function(money, sellerJobName)
    if Config.Core == "ESX" then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..sellerJobName, function(account)
            if account then
                account.addMoney(money)
            end
        end)
    elseif Config.Core == "QB-Core" then
        exports['qb-management']:AddGangMoney(sellerJobName, money)
    end
end

if Config.Core == "ESX" then
    ESX.RegisterUsableItem('protein', function(source)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem('protein', 1)
        TriggerClientEvent('vms_gym:runStrengthBooster', src, 3.0, 360000) -- Multiplier: 3.0, Time: 360000ms = 6 minutes
    end)
    
    ESX.RegisterUsableItem('runbooster', function(source)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem('runbooster', 1)
        TriggerClientEvent('vms_gym:runConditionBooster', src, 4.0, 300000) -- Multiplier: 4.0, Time: 300000ms = 5 minutes
    end)
elseif Config.Core == "QB-Core" then
    QBCore.Functions.CreateUseableItem('protein', function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) then
            Player.Functions.RemoveItem(item.name, 1)
            TriggerClientEvent('vms_gym:runStrengthBooster', src, 3.0, 360000) -- Multiplier: 3.0, Time: 360000ms = 6 minutes
        end
    end)

    QBCore.Functions.CreateUseableItem('runbooster', function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) then
            Player.Functions.RemoveItem(item.name, 1)
            TriggerClientEvent('vms_gym:runConditionBooster', src, 4.0, 300000) -- Multiplier: 4.0, Time: 300000ms = 5 minutes
        end
    end)
end