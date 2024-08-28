Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = {
    MenuxKey = keys["["],
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