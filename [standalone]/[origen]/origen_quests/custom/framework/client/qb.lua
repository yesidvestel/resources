if Config.Framework ~= 'qbcore' then return end

if GetResourceState('qb-core') ~= 'started' then
    while true do 
        print('^0[^5Origen Quest^0] qb-core is not started, please make sure to start origen_quest after qb-core^0')
        Wait(2000)
    end
end

Framework.Core = exports['qb-core']:GetCoreObject()

function Framework:TriggerCallback(...)
    return self.Core.Functions.TriggerCallback(...)
end

function Framework:GetPlayerData()
    return self.Core.Functions.GetPlayerData()
end

function Framework:GetClosestVehicle(coords)
    return self.Core.Functions.GetClosestVehicle(coords)
end

function Framework:GetPlayersFromCoords(coords, radius)
    return self.Core.Functions.GetPlayersFromCoords(coords, radius)
end

function Framework:GetObjects()
    return self.Core.Functions.GetObjects()
end

function Framework:GetPeds()
    return self.Core.Functions.GetPeds()
end

function Framework:GetVehicles()
    return self.Core.Functions.GetVehicles()
end

function Framework:SpawnVehicle(model, cb, coords, isNetwork)
    return self.Core.Functions.SpawnVehicle(model, cb, coords, isNetwork)
end

function Framework:DeleteVehicle(vehicle)
    return self.Core.Functions.DeleteVehicle(vehicle)
end

function Framework:SetVehicleProperties(vehicle, props)
    return self.Core.Functions.SetVehicleProperties(vehicle, props)       
end

function Framework:GetClosestPlayer(coords)
    return self.Core.Functions.GetClosestPlayer(coords)
end

function Framework:Notify(text)
    return self.Core.Functions.Notify(text)
end

exports('GetCoreObject', function()
    return Framework.Core
end)