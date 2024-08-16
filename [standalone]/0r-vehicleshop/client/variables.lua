Koci = {}
Koci.Framework = Utils.Functions.GetFramework()
Koci.Utils = Utils.Functions
Koci.Callbacks = {}
Koci.Client = {}

Koci.Client.TriggerServerCallback = function(key, payload, func)
    if not func then
        func = function() end
    end
    Koci.Callbacks[key] = func
    TriggerServerEvent("0r-vehicleshop:Server:HandleCallback", key, payload)
end

OpenedGallery = nil
gCam = nil
gSpawnedVehicles = {}
gPlayerInTestDrive = false
gRotatingVehicles = {}