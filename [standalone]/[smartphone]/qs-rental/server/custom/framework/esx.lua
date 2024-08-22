--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'esx' then
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
    local Player = ESX.GetPlayerFromId(player)
    return Player
end
