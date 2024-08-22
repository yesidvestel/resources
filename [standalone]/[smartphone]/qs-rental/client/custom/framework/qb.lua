--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'qb' then
    return
end

CreateThread(function()
    QBCore = exports['qb-core']:GetCoreObject()
end)

function TriggerServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

function SendTextMessage(msg, type) --You can add your notification system here for simple messages.
    if type == 'inform' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)

        --exports['qs-core']:Notify('inform', msg)
        --exports['mythic_notify']:DoHudText('inform', msg)
    end
    if type == 'error' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)

        --exports['qs-core']:Notify(msg, "error")
        --exports['mythic_notify']:DoHudText('error', msg)
    end
    if type == 'success' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)

        --exports['qs-core']:Notify( msg, "success")
        --exports['mythic_notify']:DoHudText('success', msg)
    end
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
