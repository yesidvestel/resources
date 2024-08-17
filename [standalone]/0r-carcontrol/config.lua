Config = {
    MenuKey = 'F11',
    Framework = 'qb', -- 'qb', 'oldqb', 'esx', 'oldesx'
    Sql = 'oxmysql',
    EnableMileageSystem = true, -- Enable mileage system
    OptimizationMode = "fast", -- fast, medium, low, ulrtalow 
    MileageUpdateInterval = 1500,  -- In how many milliseconds should the mileage system be run // Decrementing this value will increase the rise of mileage in every car
    IgnoredPlates = { -- Script will never count the mileage of cars with these plates
        "ADMIN",
        "ADMINCAR"
    }
}

function GetCore()
    local object = nil
    local Framework = Config.Framework

    if Config.Framework == "oldesx" then
        local counter = 0
        while not object  do
            TriggerEvent('esx:getSharedObject', function(obj) object = obj end)
            counter = counter + 1
            if counter == 3 then
                break
            end
            Wait(1000)
        end
    end
    
    if Config.Framework == "esx" then
        local counter = 0
        local status = pcall(function ()
            exports['es_extended']:getSharedObject()
        end)
        if status then        
            while not object do
                object = exports['es_extended']:getSharedObject()
                counter = counter + 1
                if counter == 3 then
                    break
                end
                Wait(1000)
            end
        end
    end

    if Config.Framework == "qb" then
        object = exports["qb-core"]:GetCoreObject()
    end

    if Config.Framework == "oldqb" then
        local counter = 0

        while  not object do
            counter = counter + 1
            TriggerEvent('QBCore:GetObject', function(obj) object = obj end)
            if counter == 3 then
                break
            end
            Wait(1000)
        end
    end
    return object, Framework
end