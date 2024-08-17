-- Author : Morow
-- Github : https://github.com/Morow73
local QBCore = exports['qb-core']:GetCoreObject()

if Config.USE_QBCore then
    TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
end

RegisterNetEvent("mrw_minigolf:locateClub")
AddEventHandler("mrw_minigolf:locateClub", function()
    local src = source

    if Config.USE_QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        local getPlayerMoney = Player.Functions.GetMoney("cash", Config.club_price)

        if Player.Functions.GetMoney("cash", Config.club_price) then
            Player.Functions.RemoveMoney("cash", Config.club_price)
            TriggerClientEvent("mrw_minigolf:st_game", src, 1)
        else
            TriggerClientEvent("mrw_golf:Notification", src, translation["no_money"])
        end
    else
        -- IF USE YOUR CUSTOM FRAMEWORK !!
        -- ADD YOUR LINE FOR COMPARE PLAYER MONEY
        TriggerClientEvent("mrw_minigolf:st_game", src, 1)
    end
end)