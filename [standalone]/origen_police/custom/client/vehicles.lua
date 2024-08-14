function ConfiscateVeh() 
    local vehicle = GetVehicleInCamera()

    if vehicle ~= 0 and #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId())) < 5 then
        if IsEntityPositionFrozen(vehicle) then
            ShowNotification("Invalid vehicle to confiscate")
            return
        end
        local attempt = 0

        while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
            Citizen.Wait(100)
            NetworkRequestControlOfEntity(vehicle)
            attempt = attempt + 1
        end

        if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
            local billPrice = 0
            if Config.Framework == "qbcore" then
                local number = exports['qb-input']:ShowInput({
                    header = "Bill price",
                    submitText = "Send",
                    inputs = {
                        {
                            text = "Price",
                            name = "number",
                            type = "number",
                            isRequired = true
                        }
                    }
                })
                if number and number.number then
                    billPrice = tonumber(number.number)
                    local plate = GetVehiclePlate(vehicle)
                    TriggerServerEvent("origen_police:server:Impound", plate, billPrice)
                    for i = 100, 0, -1 do
                        SetEntityAlpha(vehicle, i, false)
                        Citizen.Wait(15)
                    end
                    SetEntityAsMissionEntity(vehicle, 1, 1)
                    DeleteVehicle(vehicle)
                    ShowNotification(Config.Translations.VehicleConfiscated)
                end
            elseif Config.Framework == "esx" then
                OpenMenu('dialog', GetCurrentResourceName(), 'radarmaxspeed', {
                    title = "Bill price"
                }, function(data, menu)
                    if data and data.value and tonumber(data.value) then
                        billPrice = tonumber(data.value)
                        local plate = GetVehiclePlate(vehicle)
                        TriggerServerEvent("origen_police:server:Impound", plate, billPrice)
                        for i = 100, 0, -1 do
                            SetEntityAlpha(vehicle, i, false)
                            Citizen.Wait(15)
                        end
                        SetEntityAsMissionEntity(vehicle, 1, 1)
                        DeleteVehicle(vehicle)
                        ShowNotification(Config.Translations.VehicleConfiscated)
                        menu.close()
                    else
                        ShowNotification(Config.Translations.MustEnterNumber)
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end
        end
    else
        ShowNotification(Config.Translations.MustLook)
    end
end

function AddVehicleExtras(vtype, vehicle, model)
    if vtype == 'car' then 

    elseif vtype == 'boat' then 

    elseif vtype == 'helicopter' then 

    end
    --
end

function GetVehiclePlate(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end