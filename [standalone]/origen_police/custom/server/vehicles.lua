function ConfiscateVehicle(stored, plate, newStation, billPrice, source)
    -- Plate of the vehicle and the place that the vehicle will be confiscated to
    plate = plate:gsub("^%s*(.-)%s*$", "%1")
    if Config.Framework == "qbcore" then
        MySQL.awaitQuery("UPDATE player_vehicles SET state = ?, garage = ?, billPrice = ? WHERE plate = ?", {stored, newStation, billPrice, plate})
    elseif Config.Framework == "esx" then
        MySQL.awaitQuery("UPDATE owned_vehicles SET stored = ?, parking = ?, billPrice = ? WHERE plate = ?", {stored, newStation, billPrice, plate})
    end
end

function GetConfiscatedVehicles(garageName)
    -- Get all confiscated vehicles from a specific station
    if Config.Framework == "qbcore" then
        return MySQL.awaitQuery("SELECT * FROM player_vehicles WHERE state = ? AND garage = ?", {2, garageName})
    elseif Config.Framework == "esx" then
        return MySQL.awaitQuery("SELECT * FROM owned_vehicles WHERE stored = ? AND parking = ?", {2, garageName})
    end
end

function GetOwnerIdentifierByPlate(plate)
    -- Get the owner identifier of a vehicle by the plate
    plate = plate:gsub("^%s*(.-)%s*$", "%1")
    local query = ""
    if Config.Framework == "qbcore" then
        query = 'SELECT citizenid AS identifier FROM player_vehicles WHERE plate = @plate'
    elseif Config.Framework == "esx" then
        query = 'SELECT owner AS identifier FROM owned_vehicles WHERE plate = @plate'
    end
    local data = MySQL.awaitQuery(query, {['@plate'] = plate})
    if data and data[1] then
        return data[1].identifier
    end
    return false
end

function GetConfiscatedVehiclesByOwner(owner)
    -- Get all confiscated vehicles from a specific owner
    if Config.Framework == "qbcore" then
        return MySQL.awaitQuery("SELECT * FROM player_vehicles WHERE state = ? AND citizenid = ? AND garage = ?", {2, owner, Config.ConfiscateParkName})
    elseif Config.Framework == "esx" then
        return MySQL.awaitQuery("SELECT * FROM owned_vehicles WHERE stored = ? AND owner = ? AND parking = ?", {2, owner, Config.ConfiscateParkName})
    end
end

function GetConfiscatedVehicleByPlate(plate)
    -- Get a confiscated vehicle by the plate
    plate = plate:gsub("^%s*(.-)%s*$", "%1")
    if Config.Framework == "qbcore" then
        return MySQL.awaitPrepare("SELECT * FROM player_vehicles WHERE state = ? AND plate = ? LIMIT 1", {2, plate})
    elseif Config.Framework == "esx" then
        return MySQL.awaitPrepare("SELECT * FROM owned_vehicles WHERE stored = ? AND plate = ? LIMIT 1", {2, plate})
    end
end

local function GetVehicleTypeByModel(model)
    local vehicleTypes = {
        motorcycles = 'bike',
        boats = 'boat',
        helicopters = 'heli',
        planes = 'plane',
        submarines = 'submarine',
        trailer = 'trailer',
        train = 'train'
    }

    local vehicleData = Framework.Shared.Vehicles[model]
    if not vehicleData then return 'automobile' end
    local category = vehicleData.category
    local vehicleType = vehicleTypes[category]
    return vehicleType or 'automobile'
end

function PlayerPayMoney(source, money)
    local src = source
    if Config.Framework == "qbcore" then
        local player = Framework.Functions.GetPlayer(src)
        local cash = player.PlayerData.money['cash']
        local bank = player.PlayerData.money['bank']
        if cash >= money then
            player.Functions.RemoveMoney('cash', money, "confiscated-vehicle")
            return true
        elseif bank >= money then
            player.Functions.RemoveMoney('bank', money, "confiscated-vehicle")
            return true
        else
            return false
        end
    elseif Config.Framework == "esx" then
        local Player = Framework.GetPlayerFromId(src)
        if Player.getMoney() >= money then
            Player.removeMoney(money, "confiscated-vehicle")
            AddMoneyToSociety(tonumber(money), Config.ConfiscateSocietyTarget)
            return true
        else    
            return false
        end
    else
        -- If you are using another framework, you can add your own money system here
        return false
    end
end

function PayConfiscatedVehicle(owner, plate, billPrice)
    if Config.Framework == "qbcore" then
        local Player = FW_GetPlayerFromCitizenid(owner)
        if Player and PlayerPayMoney(Player.PlayerData.source, billPrice) then
            local vehData = GetConfiscatedVehicleByPlate(plate)
            local affectedRows = MySQL.awaitUpdate("UPDATE `player_vehicles` SET `garage` = ?, `state` = ? WHERE `plate` = ?", {"OUT", 0, plate})
            return vehData
        else
            TriggerClientEvent("origen_police:ShowNotification", Player.PlayerData.source, Config.Translations.NoMoney)
        end
    elseif Config.Framework == "esx" then
        local Player = FW_GetPlayerFromCitizenid(owner)
        if Player and PlayerPayMoney(Player.PlayerData.source, billPrice) then 
            local vehData = GetConfiscatedVehicleByPlate(plate)
            local affectedRows = MySQL.awaitUpdate("UPDATE `owned_vehicles` SET `parking` = ?, `stored` = ? WHERE `plate` = ?", {"OUT", 0, plate})
            return vehData
        else
            TriggerClientEvent("origen_police:ShowNotification", Player.PlayerData.source, Config.Translations.NoMoney)
        end
    else
        -- If you are using another framework, you can add your own check here to pay impound vehicle cost
    end
    return false
end