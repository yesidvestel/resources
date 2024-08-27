if Config.Framework ~= "esx" then return end
if GetResourceState("es_extended") ~= "started" then
    while true do 
        print("^0[^5Origen Police^0] es_extended is not started, please make sure to start origen_police after es_extended^0")
        Wait(2000)
    end
end
Framework = exports["es_extended"]:getSharedObject()
Framework.Shared = {Jobs = {}, Vehicles = {}}

Citizen.CreateThread(function()
    Framework.TriggerServerCallback("origen_police:server:GetJobs", function(jobs)
        Framework.Shared.Jobs = jobs
    end)
    
    Framework.TriggerServerCallback("origen_police:server:GetVehicles", function(vehicles)
        Framework.Shared.Vehicles = vehicles
    end)
end)

function FW_TriggerCallback(...)
    Framework.TriggerServerCallback(...)
end

function FW_GetPlayerData(useMetadata)
    local PlayerData = Framework.GetPlayerData()
    return {
        citizenid = PlayerData.identifier,
        items = GetPlayerItems(PlayerData),
        job = PlayerData.job and {
            name = PlayerData.job.name,
            label = PlayerData.job.label,
            grade = {
                level = PlayerData.job.grade,
                name = PlayerData.job.grade_label
            },
            isboss = IsBoss(PlayerData.job.grade),
            onduty = GetResourceState("origen_police") == "started" and exports["origen_police"]:GetPoliceDuty() or false
        } or false,
        charinfo = {
            firstname = PlayerData.firstName,
            lastname = PlayerData.lastName,
            account = "XXXXXXXXX",
            birthdate = PlayerData.dateofbirth,
            nationality = "XXXXXXXXX",
            gender = PlayerData.sex == "m" and 0 or 1,
        },
        metadata = useMetadata and (Config.fixQS and FW_GetPlayerMetadata() or PlayerData.metadata) or {},
        position = PlayerData.coords
    }
end

function FW_GetPlayersFromCoords(coords, radius)
    return Framework.Game.GetPlayersInArea(coords, radius)
end

function FW_GetClosestVehicle(coords)
    return Framework.Game.GetClosestVehicle(coords)
end

function FW_GetObjects()
    return Framework.Game.GetObjects()
end

function Fw_GetPeds()
    return Framework.Game.GetPeds()
end

function FW_GetVehicles()
    return Framework.Game.GetVehicles()
end

function FW_SpawnVehicle(model, cb, coords, isNetwork)
    Framework.Game.SpawnVehicle(model, coords, 0.0, cb, isNetwork)
end

function FW_DeleteVehicle(vehicle)
    Framework.Game.DeleteVehicle(vehicle)
end

function FW_SetVehicleProperties(vehicle, props)
    Framework.Game.SetVehicleProperties(vehicle, props)
end

function FW_GetClosestPlayer(coords)
    return Framework.Game.GetClosestPlayer(coords)
end

function FW_Notify(text)
    Framework.ShowNotification(text)
end

RegisterNetEvent("esx:onPlayerSpawn", function()
    TriggerEvent("origen_police:client:OnPlayerLoaded")
end)

RegisterNetEvent("esx:onPlayerLogout", function()
    TriggerEvent("origen_police:client:OnPlayerUnload")
end)

RegisterNetEvent("origen_police:esx:SetDuty", function(duty)
    SetDuty(duty)
end)

Citizen.CreateThread(function()
    local Player = FW_GetPlayerData()
    if Player and Player.job and Player.job.name then 
        TriggerEvent("origen_police:client:OnPlayerLoaded")
    end
end)



if not Framework.ShowHelpNotification then 
    -- When the users don't have the ShowHelpNotificaiton
    Framework.ShowHelpNotification = function()
        print("ShowHelpNotificaiton function is not found, please make sure that you have installed origen_notify, else disable the Config.CustomNotify")
    end
end

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