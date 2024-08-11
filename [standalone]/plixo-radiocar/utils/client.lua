local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
	local breakMe = 0
    while QBCore == nil do
        Wait(100)
		breakMe = breakMe + 1
        TriggerEvent(Config.QBCore, function(obj) QBCore = obj end)
		if breakMe > 10 then
			break
		end
    end
end)


-- this will send information to server.
function CheckPlayerCar(vehicle)
	if QBCore then
		local veh = QBCore.Functions.GetVehicleProperties(vehicle)
		TriggerServerEvent("row-radiocar:openUI", veh.plate)
	else
		TriggerServerEvent("row-radiocar:openUI", GetVehicleNumberPlateText(vehicle))
	end
end

-- if you want this script for... lets say like only vip, edit this function.
function YourSpecialPermission()
    return true
end