if Config.Framework ~= 'esx' then return end

if GetResourceState('es_extended') ~= 'started' then
    while true do 
        debugger('^0[^5Origen Quest^0] es_extended is not started, please make sure to start origen_quest after es_extended^0')
        Wait(2000)
    end
end

Framework.Core = exports['es_extended']:getSharedObject()

Framework.Core.Shared = {}
Framework.Core.Shared.Items = {}

function Framework:TriggerCallback(...)
    self.Core.TriggerServerCallback(...)
end

function Framework:GetPlayerData()
    local PlayerData = self.Core.GetPlayerData()
    return {
        citizenid = PlayerData.identifier,
        charinfo = {
            firstname = PlayerData.firstName,
            lastname = PlayerData.lastName,
            birthdate = PlayerData.dateofbirth,
            gender = PlayerData.sex == 'm' and 0 or 1,
        },
        job = {
            name = PlayerData.job.name,
            grade = PlayerData.job.grade,
            label = PlayerData.job.label,
        },
        gang = {
            name = Custom:GetGangName()
        },
        metadata = {},
        position = PlayerData.coords
    }
end

function Framework:GetPlayersFromCoords(coords, radius)
    return self.Core.Game.GetPlayersInArea(coords, radius)
end

function Framework:GetClosestVehicle(coords)
    return self.Core.Game.GetClosestVehicle(coords)
end

function Framework:GetObjects()
    return self.Core.Game.GetObjects()
end

function Framework:GetPeds()
    return self.Core.Game.GetPeds()
end

function Framework:GetVehicles()
    return self.Core.Game.GetVehicles()
end

function Framework:SpawnVehicle(model, cb, coords, isNetwork)
    self.Core.Game.SpawnVehicle(model, coords, 0.0, cb, isNetwork)
end

function Framework:DeleteVehicle(vehicle)
    self.Core.Game.DeleteVehicle(vehicle)
end

function Framework:SetVehicleProperties(vehicle, props)
    self.Core.Game.SetVehicleProperties(vehicle, props)   
end

function Framework:GetClosestPlayer(coords)
    return self.Core.Game.GetClosestPlayer(coords)
end

function Framework:Notify(text, type, duration)
    self.Core.ShowNotification(text, type, duration)
end

exports('GetCoreObject', function()
    return Framework.Core
end)