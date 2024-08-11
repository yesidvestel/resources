local PedInCar = false

CreateThread(function() 
    while true do 
        if IsCamActive(ParkCam) and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then 
            DisableParkCam()
        elseif IsCamActive(ParkCam) and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
            local vehicleRotation = GetEntityRotation(GetVehiclePedIsIn(PlayerPedId(), false))

            SetCamRot(ParkCam, vehicleRotation.x - 80.0, vehicleRotation.y, vehicleRotation.z, 2)

            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.4)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("~g~Cámara de estacionamiento habilitada~w~ - Cuidado!")
            DrawText(0.41, 0.95)
        end
        Wait(1)
    end 
end)

if Config.EnableMileageSystem then 
    CreateThread(function() 
        while true do 
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

            if vehicle and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and IsVehicleOnAllWheels(vehicle) and not IsCarIgnored(vehicle) then
                local plate = GetVehicleNumberPlateText(vehicle)

                local currentCoords = GetEntityCoords(vehicle)
                Wait(1000)
                local updatedCoords = GetEntityCoords(vehicle)

                local traveled = #(updatedCoords - currentCoords) / 100

                if traveled > 0 then 
                    TriggerServerEvent("0r-carcontrol:Server:AddMileage", plate, traveled)
                end
            end

            Wait(Config.MileageUpdateInterval)
        end
    end)
end