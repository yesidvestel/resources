RegisterNetEvent("jd:eliminarcoches")
AddEventHandler("jd:eliminarcoches", function ()
    TriggerEvent('okokNotify:Alert', "Grua", "En 5 minuto todos los vehiculos vacios seran remolcados.", 5000, 'neutral')
    Citizen.Wait(190000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 3 minuto todos los vehiculos vacios seran remolcados.", 5000, 'neutral')
    Citizen.Wait(60000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 1 minutos todos los vehiculos vacios seran remolcados.", 5000, 'neutral')
    Citizen.Wait(30000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 30 segundos todos los vehiculos vacios seran remolcados.", 5000, 'neutral')
    Citizen.Wait(10000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 20 segundos todos los vehiculos vacios seran remolcados.", 5000, 'neutral')
    Citizen.Wait(5000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 10 segundos todos los vehiculos vacios seran remolcados.", 5000, 'neutral')
    Citizen.Wait(1000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 5 segundos todos los vehiculos vacios seran remolcados.", 2000, 'neutral')
    Citizen.Wait(1000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 4 segundos todos los vehiculos vacios seran remolcados.", 5200, 'neutral')
    Citizen.Wait(1000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 3 segundos todos los vehiculos vacios seran remolcados.", 2000, 'neutral')
    Citizen.Wait(1000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 2 segundos todos los vehiculos vacios seran remolcados.", 2000, 'neutral')
    Citizen.Wait(1000)
    TriggerEvent('okokNotify:Alert', "Grua", "En 1 segundos todos los vehiculos vacios seran remolcados.", 2000, 'neutral')
    Citizen.Wait(1000)
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
            SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
            SetEntityAsMissionEntity(vehicle, false, false) 
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then 
                DeleteVehicle(vehicle) 
            end
        end
    end
end)