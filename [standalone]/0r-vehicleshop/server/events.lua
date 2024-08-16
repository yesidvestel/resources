RegisterNetEvent("0r-vehicleshop:Server:HandleCallback", function(key, payload)
    local src = source
    if Koci.Callbacks[key] then
        Koci.Callbacks[key](src, payload, function(cb)
            TriggerClientEvent("0r-vehicleshop:Client:HandleCallback", src, key, cb)
        end)
    end
end)
