if Config.Framework ~= "qbcore" then return end

if GetResourceState("qb-core") ~= "started" then
    while true do 
        debugger('^0[^5Origen Quest^0] qb-core is not started, please make sure to start origen_quest after qb-core^0')
        Wait(2000)
    end
end

Framework.Core = exports['qb-core']:GetCoreObject()

function Framework:CreateCallback(...)
    self.Core.Functions.CreateCallback(...)
end

function Framework:GetPlayer(source)
    local Player = self.Core.Functions.GetPlayer(source)
    if Player == nil then return nil end
    return Player
end

function Framework:CreateUseableItem(...)
    self.Core.Functions.CreateUseableItem(...)
end

function Framework:RegisterCommand(name, help, arguments, argsrequired, callback, permission, ...)
    self.Core.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
end
exports('GetCoreObject', function()
    return Framework.Core
end)