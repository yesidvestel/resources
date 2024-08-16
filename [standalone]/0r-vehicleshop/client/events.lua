AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        closeCurrentGallery()
    end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)
        CheckOverdueRentalCars()
    end
end)

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    Wait(1000)
    CheckOverdueRentalCars()
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    Wait(1000)
    CheckOverdueRentalCars()
end)

RegisterNetEvent("0r-vehicleshop:Client:HandleCallback", function(key, data)
    if Koci.Callbacks[key] then
        Koci.Callbacks[key](data)
        Koci.Callbacks[key] = nil
    end
end)
