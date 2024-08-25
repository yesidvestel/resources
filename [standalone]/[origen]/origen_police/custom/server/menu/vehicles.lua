function GetVehiclesByIdentifier(identifier)
    local status, data = pcall(function()
        if Config.Framework == "qbcore" then
            return MySQL.awaitQuery('SELECT hash, plate, wanted, garage FROM player_vehicles WHERE citizenid = ?', {identifier})
        else
            return MySQL.awaitQuery('SELECT plate, wanted, vehicle FROM owned_vehicles WHERE owner = ?', {identifier})
        end
    end)
    if not status then
        return {}
    end
    return data
end

function SearchDataFromVehicle(plate)
    local status, data = pcall(function()
        if Config.Framework == "qbcore" then
            return MySQL.awaitQuery('SELECT player_vehicles.citizenid, player_vehicles.hash, player_vehicles.plate, player_vehicles.garage, players.charinfo FROM player_vehicles INNER JOIN players ON player_vehicles.citizenid COLLATE utf8mb4_general_ci = players.citizenid WHERE plate LIKE ? COLLATE utf8mb4_general_ci', {"%" .. plate .. "%"})
        else 
            return MySQL.awaitQuery('SELECT owned_vehicles.plate, owned_vehicles.owner, owned_vehicles.vehicle, users.firstname, users.lastname FROM owned_vehicles INNER JOIN users ON owned_vehicles.owner = users.identifier WHERE owned_vehicles.plate LIKE ?', {"%" .. plate .. "%"})
        end
    end)
    if not status then
        return {}
    end
    return data
end

function GetDataFromVehicle(plate)
    local status, data = pcall(function()
        if Config.Framework == "qbcore" then
            return MySQL.awaitQuery('SELECT player_vehicles.citizenid, player_vehicles.hash, player_vehicles.plate, player_vehicles.garage, player_vehicles.wanted, player_vehicles.description, players.charinfo FROM player_vehicles LEFT JOIN players ON player_vehicles.citizenid = players.citizenid WHERE plate = ?', {plate})
        else 
            return MySQL.awaitQuery('SELECT owned_vehicles.plate, owned_vehicles.owner, owned_vehicles.vehicle, owned_vehicles.wanted, owned_vehicles.description, users.firstname, users.lastname FROM owned_vehicles INNER JOIN users ON owned_vehicles.owner = users.identifier WHERE owned_vehicles.plate = ?', {plate})
        end
    end)
    if not status then
        return {}
    end
    return data
end

function UpdateVehicleData(key, value, plate)
    local status, data = pcall(function()
        if Config.Framework == "qbcore" then
            return MySQL.awaitUpdate('UPDATE player_vehicles SET ' .. key .. ' = ? WHERE plate = ?', {value, plate}) > 0
        elseif Config.Framework == "esx" then
            return MySQL.awaitUpdate('UPDATE owned_vehicles SET ' .. key .. ' = ? WHERE plate = ?', {value, plate}) > 0
        end
    end)
    if not status then
        return {}
    end
    return data
end