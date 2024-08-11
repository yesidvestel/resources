Core, FW = GetCore()

SC = nil

if FW == 'qb' or FW == 'oldqb' then
    SC = Core.Functions.CreateCallback
else
    SC = Core.RegisterServerCallback
end

CarMedias = {}

SC("0r-carcontrol:Server:GetMileage", function(source, cb, payload) 
    print(json.encode(payload))
    if Config.EnableMileageSystem then 
        local carMileageResult = ExecuteSql("SELECT * FROM carmileages WHERE plate = @plate", { 
            ["@plate"] = payload.plate 
        })

        if #carMileageResult > 0 then 
            cb(carMileageResult[1].mileage)
        else
            cb(nil)
        end
    else
        cb(nil)
    end
end)

SC("0r-carcontrol:Server:GetCarMedia", function(source, cb, payload) 
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
    local carMedia = GetCarMedia(vehicle)

    cb(carMedia)
end)

RegisterServerEvent("0r-carcontrol:Server:ControlCarMedia", function(_type, musicId, data)
    TriggerClientEvent("0r-carcontrol:Client:ControlCarMedia", -1, _type, musicId, data)
end)

RegisterServerEvent("0r-carcontrol:Server:ToggleVehicleLock", function() 
    local source = source
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)

    if vehicle then 
        if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(source) then 
            local lockStatus = GetVehicleDoorLockStatus(vehicle)
            local newLockStatus = nil

            if lockStatus == 4 then 
                newLockStatus = 0
            else
                newLockStatus = 4
            end

            SetVehicleDoorsLocked(vehicle, newLockStatus) 
        end
    end
end)

if Config.EnableMileageSystem then
    RegisterServerEvent("0r-carcontrol:Server:AddMileage", function(plate, traveled) 
        local source = source
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)

        if vehicle and GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(source) and not IsCarIgnored(vehicle) and GetVehicleNumberPlateText(vehicle) == plate then 
            local carOldMileage = ExecuteSql("SELECT * FROM carmileages WHERE plate = @plate", { 
                ["@plate"] = plate 
            })

            if #carOldMileage > 0 then 
                ExecuteSql("UPDATE carmileages SET mileage = @mileage WHERE plate = @plate", { 
                    ["@plate"] = plate, 
                    ["@mileage"] = carOldMileage[1].mileage + traveled 
                })
            else
                ExecuteSql("INSERT INTO carmileages (plate, mileage) VALUES (@plate, @mileage)", { 
                    ["@plate"] = plate, 
                    ["@mileage"] = traveled 
                })
            end
        end
    end)
end


