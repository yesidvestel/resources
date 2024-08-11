function GetPedVehicleData(ped) 
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle ~= 0 then
        return {
            vehicle = vehicle,
            name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)),
            vites = GetVehicleCurrentGear(vehicle),
            rpm = GetVehicleCurrentRpm(vehicle),
            fuel = GetVehicleFuelLevel(vehicle) or 100,
	        plaka = GetVehicleNumberPlateText(vehicle),
            engineTemperature = GetVehicleEngineTemperature(vehicle) or 90
        } 
    else
        return nil
    end
end



-- function ChangePedSeat(ped) 
--     local vehicle = GetVehiclePedIsIn(ped, false)

--     if vehicle ~= 0 then 
--         local maxSeatAmount = GetVehicleMaxNumberOfPassengers(vehicle)
--         local pedSeatIndex = nil
--         local availableSeats = {}

--         for i = -1, maxSeatAmount, 1 do 
--             if GetPedInVehicleSeat(vehicle, i) == ped then 
--                 pedSeatIndex = i
--             elseif IsVehicleSeatFree(vehicle, i) then
--                 table.insert(availableSeats, i)
--             end
--         end

--         local newSeat = nil

--         if pedSeatIndex then 
--             for _, targetSeat in ipairs(availableSeats) do 
--                 if targetSeat > pedSeatIndex then 
--                     newSeat = targetSeat
--                     break
--                 end
--             end

--             if not newSeat then 
--                 for _, targetSeat in ipairs(availableSeats) do 
--                     if targetSeat < pedSeatIndex then 
--                         newSeat = targetSeat
--                         break
--                     end
--                 end
--             end

--             if newSeat then 
--                 SetPedIntoVehicle(ped, vehicle, newSeat)
--             end
--         end
--     end
-- end

function EnableParkCam() 
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle then 
        ParkCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)

        AttachCamToEntity(ParkCam, vehicle, 0.0, -0.5, 5.0, true)

        SetCamActive(ParkCam, true)
        SetCamRot(ParkCam, -90.0, 0.0, -30.0, 2)
        SetCamFov(ParkCam, 80.0)

        RenderScriptCams(true, true, 1000, 0, 0)
    end
end

function DisableParkCam() 
    RenderScriptCams(false, true, 1000, 0, 0)

    DestroyCam(ParkCam, false)

    ParkCam = nil
end

local function convertToPercentage(value)
    return math.ceil(value * 10000 - 2001) / 80
    --99,9875
end

CreateThread(function()
    isbelt = false
	while true do
		if Config.OptimizationMode == "ultralow" then 
			Wait(2000); 
		elseif Config.OptimizationMode == "low" then 
			Wait(1000); 
		elseif Config.OptimizationMode == "medium" then 
			Wait(500); 
		elseif Config.OptimizationMode == "fast" then 
			Wait(100); 
		end 
        local person = PlayerPedId()
        if IsPauseMenuActive() then
            SendNUIMessage({
                carhud = 'indi';
            })
		elseif IsPedInAnyVehicle(person) then
            local veh = GetVehiclePedIsIn(ped, false);
            local car = GetVehiclePedIsUsing(person)
            local fuel = (GetVehicleFuelLevel(car)*1.4)
            local vites = GetVehicleCurrentGear(car)
            local hasar = (GetVehicleBodyHealth(car))
            local hiz = (GetEntitySpeed(car)*3.5) 
            local rpm = GetVehicleCurrentRpm(car)
            local heading = GetEntityHeading(person)
            local rpmmath = convertToPercentage(rpm)
            local blip = GetFirstBlipInfoId(8)
            local blipCoords = nil
            local metre = 0
            if (blip ~= 0) then
                blipCoords = GetBlipCoords(blip)
                local pedCoords = GetEntityCoords(person)
                metre = GetDistanceBetweenCoords(blipCoords.x, blipCoords.y, blipCoords.z, pedCoords.x, pedCoords.y, pedCoords.z, false)
            end
            dooropened = false
            for i = 0, 3 do
                local doorsangle = GetVehicleDoorAngleRatio(car, i)
                if doorsangle ~= 0.0 then
                    dooropened = true
                end
            end
            SendNUIMessage({
                carhud = 'arabada';
                rpm = rpmmath;
                fuel = fuel;
                far = farseviye;
                gear = vites;
                speed = hiz;
                kapi = dooropened;
                vehiclerun = vehiclerunstatus;
                kemer = seatbelt;
                motor = hasar;
                metre = metre;
                heading = heading;
            })
        else
            SendNUIMessage({
                carhud = 'indi';
            })
        end
	end
end)