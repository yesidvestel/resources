if Config.Framework ~= "qbcore" then return end
if GetResourceState("qb-core") ~= "started" then
    while true do 
        print("^0[^5Origen Police^0] qb-core is not started, please make sure to start origen_police after qb-core^0")
        Wait(2000)
    end
end
Framework = exports['qb-core']:GetCoreObject()

function FW_TriggerCallback(...)
    Framework.Functions.TriggerCallback(...)
end

function FW_GetPlayerData()
    return Framework.Functions.GetPlayerData()
end

function FW_GetClosestVehicle(coords)
    return Framework.Functions.GetClosestVehicle(coords)
end

function FW_GetPlayersFromCoords(coords, radius)
    return Framework.Functions.GetPlayersFromCoords(coords, radius)
end

function FW_GetClosestVehicle(coords)
    return Framework.Functions.GetClosestVehicle(coords)
end

function FW_GetObjects()
    return Framework.Functions.GetObjects()
end

function Fw_GetPeds()
    return Framework.Functions.GetPeds()
end

function FW_GetVehicles()
    return Framework.Functions.GetVehicles()
end

function FW_SpawnVehicle(model, cb, coords, isNetwork)
    Framework.Functions.SpawnVehicle(model, cb, coords, isNetwork)
end

function FW_DeleteVehicle(vehicle)
    Framework.Functions.DeleteVehicle(vehicle)
end

function FW_SetVehicleProperties(vehicle, props)
    Framework.Functions.SetVehicleProperties(vehicle, props)       
end

function FW_GetClosestPlayer(coords)
    return Framework.Functions.GetClosestPlayer(coords)

end

function FW_Notify(text)
    Framework.Functions.Notify(text)
end

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    TriggerEvent("origen_police:client:OnPlayerLoaded")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent("origen_police:client:OnPlayerUnload")
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate", function()
    TriggerEvent("origen_police:client:OnJobUpdate")
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    SetDuty(duty)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobData)
    local isPolice = CanOpenTablet(jobData.name)[1]
    if not isPolice then return SetDuty(false) end
    SetDuty(jobData.onduty)
end)

Citizen.CreateThread(function()
    local Player = FW_GetPlayerData()
    if Player and Player.job and Player.job.name then 
        TriggerEvent("origen_police:client:OnPlayerLoaded")
    end
end)

exports('FW_TriggerCallback', FW_TriggerCallback)
exports('FW_GetPlayerData', FW_GetPlayerData)
exports('FW_GetPlayersFromCoords', FW_GetPlayersFromCoords)
exports('FW_GetClosestVehicle', FW_GetClosestVehicle)
exports('FW_GetClosestVehicle', FW_GetClosestVehicle)
exports('FW_GetObjects', FW_GetObjects)
exports('Fw_GetPeds', Fw_GetPeds)
exports('FW_GetVehicles', FW_GetVehicles)
exports('FW_SpawnVehicle', FW_SpawnVehicle)
exports('FW_DeleteVehicle', FW_DeleteVehicle)
exports('FW_SetVehicleProperties', FW_SetVehicleProperties)
exports('FW_GetClosestPlayer', FW_GetClosestPlayer)
exports('FW_Notify', FW_Notify)

exports('GetCoreObject', function()
    return Framework
end)