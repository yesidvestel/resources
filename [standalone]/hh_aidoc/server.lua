local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('hhfw:docOnline', function(source, cb)
	local src = source
	local Ply = QBCore.Functions.GetPlayer(src)
	local xPlayers = QBCore.Functions.GetPlayers()
	local doctor = 0
	local canpay = false
	if Ply.PlayerData.money["cash"] >= Config.Price then
		canpay = true
	else
		if Ply.PlayerData.money["bank"] >= Config.Price then
			canpay = true
		end
	end

	for i=1, #xPlayers, 1 do
		local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
		if xPlayer.PlayerData.job.name == 'ambulance' then
			doctor = doctor + 1
		end
	end

	cb(doctor, canpay)
end)


RegisterNetEvent("hh_aidoc:hhfw:callHelp")
AddEventHandler("hh_aidoc:hhfw:callHelp", function()
    local src = source
    print("hhfw:callHelp event triggered") -- Add this line for debugging
    local player = QBCore.Functions.GetPlayer(src)

    if player then
        local playerData = player.PlayerData

        if (playerData.metadata["isdead"]) or (playerData.metadata["inlaststand"]) then
            QBCore.Functions.TriggerCallback('hhfw:docOnline', src, function(EMSOnline, hasEnoughMoney)
                if EMSOnline <= Config.Doctor and hasEnoughMoney then
                    TriggerClientEvent('hhfw:spawnVehicle', src, GetEntityCoords(GetPlayerPed(src)))
                    TriggerEvent('hhfw:charge', src)
                    TriggerClientEvent('QBCore:Notify', src, "El medico esta llegando")
                else
                    if EMSOnline > Config.Doctor then
                        TriggerClientEvent('QBCore:Notify', src, "Hay demasiados médicos en línea.", "error")
                    elseif not hasEnoughMoney then
                        TriggerClientEvent('QBCore:Notify', src, "Dinero insuficiente", "error")
                    else
                        TriggerClientEvent('QBCore:Notify', src, "Espere, el paramédico está en camino.", "primary")
                    end
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, "Esto solo se puede usar cuando esté muerto.", "error")
        end
    end
end)



RegisterServerEvent('hhfw:charge')
AddEventHandler('hhfw:charge', function(source)
	local src = source
	local xPlayer = QBCore.Functions.GetPlayer(src)
	if xPlayer.PlayerData.money["cash"] >= Config.Price then
		xPlayer.Functions.RemoveMoney("cash", Config.Price)
	else
		xPlayer.Functions.RemoveMoney("bank", Config.Price)
	end
	TriggerEvent("qb-bossmenu:server:addAccountMoney", 'ambulance', Config.Price)
end)
