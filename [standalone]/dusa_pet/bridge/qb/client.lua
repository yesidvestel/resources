if GetResourceState('qb-core') ~= 'started' then return end
QBCore = exports['qb-core']:GetCoreObject()
dusa = {}
dusa.framework, dusa.playerLoaded, dusa.playerData, dusa.inventory = 'qb', nil, {}, 'qb'

if GetResourceState('ox_inventory') == 'started' then dusa.inventory = 'ox' end
if GetResourceState('qs-inventory') == 'started' then dusa.inventory = 'qs' end

AddStateBagChangeHandler('isLoggedIn', '', function(_bagName, _key, value, _reserved, _replicated)
    if value then
        dusa.playerData = QBCore.Functions.GetPlayerData()
    else
        table.wipe(dusa.playerData)
    end
    dusa.playerLoaded = value
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName or not LocalPlayer.state.isLoggedIn then return end
    dusa.playerData = QBCore.Functions.GetPlayerData()
    SendNUIMessage({
        type = 'translate',
        translate = Config.Translations[Config.Locale]
    })
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    dusa.playerData = QBCore.Functions.GetPlayerData()
    dusa.playerLoaded = true
    SendNUIMessage({
        type = 'translate',
        translate = Config.Translations[Config.Locale]
    })
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    dusa.playerData.job = job
end)

AddEventHandler('gameEventTriggered', function(event, data)
	if event ~= 'CEventNetworkEntityDamage' then return end
    local playerPed = PlayerPedId()
	local victim, victimDied = data[1], data[4]
	if not IsPedAPlayer(victim) then return end
	local player = PlayerId()
	if victimDied and NetworkGetPlayerIndexFromPed(victim) == player and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim))  then
        isDead = true
        TriggerEvent('dusa_pets:cl:onOwnerDeath')
	end
end)

---@diagnostic disable: duplicate-set-field

function dusa.showNotification(text, type)
	SendNUIMessage({
        type = 'notification',
        action = type,
        text = text
    })
end

RegisterNetEvent('dusa_pets:cl:notify', function(text, type)
    dusa.showNotification(text, type)
end)

function dusa.serverCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb,  ...)
end

function dusa.getClosestPlayer()
	return QBCore.Functions.GetClosestPlayer()
end

function dusa.getClosestVehicle(coords)
	return QBCore.Functions.GetClosestVehicle(coords)
end

function dusa.textUI(label)
    return exports['qb-core']:DrawText(label, 'right')
end

function dusa.keyPressed()
    return exports['qb-core']:KeyPressed()
end

function dusa.hideUI()
    return exports['qb-core']:HideText()
end

function dusa.isPlayerDead()
    dusa.playerData = QBCore.Functions.GetPlayerData()
    return dusa.playerData.metadata.isdead
end