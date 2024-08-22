--[[ 
    Hi dear customer or developer, here you can fully configure your server's 
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version 
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= "qb" then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

function RegisterServerCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function GetPlayerFromId(player)
    local Player = QBCore.Functions.GetPlayer(player)
    if Player then 
        Player.citizenid = Player.PlayerData.citizenid
        Player.identifier = Player.PlayerData.citizenid
        Player.source = Player.PlayerData.source
    end
    return Player
end

function GetPlayerFromIdentifier(ident)
    local Player = QBCore.Functions.GetPlayerByCitizenId(ident)
    if Player then
        Player.source = Player.PlayerData.source
    end
    return Player
end

function PlayerJob(player)
    return GetPlayerFromId(player).PlayerData.job.name
end