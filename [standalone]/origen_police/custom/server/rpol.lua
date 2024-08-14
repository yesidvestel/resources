RegisterServerEvent("origen_police:server:rpol", function(job, message)
    if Config.Framework ~= "qbcore" and Config.Framework ~= "esx" then return print("Can't find supported framework: ", Config.Framework) end
    local jobCategory = CanOpenTablet(source)[2]
    local Players = Config.Framework == "qbcore" and Framework.Functions.GetPlayersOnDuty(job) or GetPlayersInDuty(jobCategory)
    local CentralSuscribers = exports["origen_police"]:GetCentralSuscribeds()
    for k, v in pairs(Players) do
        if CentralSuscribers[v] then 
            TriggerClientEvent('origen_police:client:rpol', v, message)
        end
        TriggerClientEvent('chat:addMessage', v, { args = {message}})
    end
end)