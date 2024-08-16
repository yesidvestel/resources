function closeHud()
    -- If you want to turn off hud in the gallery menu, you can use the hud-close export of the plugin you are using here
end

function openHud()
    -- If you want to turn one hud in the gallery menu, you can use the hud-open export of the plugin you are using here
end

function giveVehicleKey(plate)
    if Config.VehicleKeys.status then
        if Config.VehicleKeys.system == "qb" then
            TriggerEvent("vehiclekeys:client:SetOwner", string.upper(plate))
        else
            -- TriggerClientEvent("event:name:customvehiclekey", plate)
        end
    end
end
