function Custom:ShowHelpNotification(key, msg)
    if Config.Framework == 'qbcore' then
        exports['qb-core']:DrawText(msg, nil, key)
    elseif Config.Framework == 'esx' then
        Framework.Core.ShowHelpNotification(msg, key)
    end

    -- Put your code here if you want to use a custom help notification
end

function Custom:ShowNotification(msg, type, duration)
    if not Config.CustomNotify then
        Framework:Notify(msg, type, duration)
    else
        -- Put your code here if you want to use a custom notification
    end
end

function Custom:HideHelpNotification(key, msg)
    if Config.Framework == 'qbcore' then 
        exports['qb-core']:HideText()
        return
    end
    -- Write your code here if you want to use a custom notification and delete the code above
end

function Custom:GetAllItems()
    local p = promise:new()
    Framework:TriggerCallback('origen_quests:server:GetItems', function(data)
        p:resolve(data)
    end)
    local result = Citizen.Await(p)
    if not result then
        debuger("Error in Functions:GetAllItems")
        return {}
    end
    return result
end

function Custom:GetGangName()
    if GetResourceState('origen_ilegal') == 'started' then
        return exports['origen_ilegal']:GetGangID()
    else
        return print("Error: origen_ilegal resource is not started add your own gang check on custom/client/client.lua")
    end
end