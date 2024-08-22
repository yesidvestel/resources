--[[ 
    Hi dear customer or developer, here you can fully configure your server's 
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version 
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= "esx" then
    return
end

local legacyEsx = pcall(function()
    ESX = exports['es_extended']:getSharedObject()
end)
if not legacyEsx then  
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

TriggerEvent('qs-base:getSharedObject', function(Library) QS = Library end)

function RegisterServerCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function GetPlayerFromId(player)
    local Player = QS.GetPlayerFromId(player)
    if Player then 
        Player.identifier = Player.PlayerData.identifier
        Player.source = Player.PlayerData.source
    end
    return Player
end

function GetPlayerFromIdentifier(ident)
    local Player = ESX.GetPlayerFromIdentifier(ident)
    return Player
end

function PlayerJob(player)
    return ESX.GetPlayerFromId(player).job.name
end