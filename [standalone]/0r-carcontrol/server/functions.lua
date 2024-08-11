function GetCarMedia(vehicle) 
    local carMedia = nil

    for _,v in ipairs(CarMedias) do 
        if v.vehicle == vehicle then 
            carMedia = v
            break
        end
    end

    if carMedia then 
        if carMedia.pausedAt then 
            if carMedia.startedAt == nil then
                carMedia.startedAt = 0
            end
            
            carMedia.startedAt = os.time() - (carMedia.pausedAt - carMedia.startedAt)
            carMedia.pausedAt = nil
        end
    end

    return carMedia
end

function GetPlayersInCar(vehicle)
    local peds = {}

    for i = -1, 6, 1 do 
        local ped = GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(source), false), i)

        if ped ~= 0 then 
            table.insert(peds, ped)
        end
    end

    local players = {}
    for _, playerId in ipairs(GetPlayers()) do 
        for ped in ipairs(peds) do
            if tostring(ped) == tostring(playerId) then 
                table.insert(players, playerId)
                break
            end
        end
    end

    return players
end

function ExecuteSql(query, parameters)
    local IsBusy = true
    local result = nil
    if Config.Sql == "oxmysql" then
        if parameters then
            exports.oxmysql:execute(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        end

    elseif Config.Sql == "ghmattimysql" then
        if parameters then
            exports.ghmattimysql:execute(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            exports.ghmattimysql:execute(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.Sql == "mysql-async" then
        if parameters then
            MySQL.Async.fetchAll(query, parameters, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.Async.fetchAll(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    end
    while IsBusy do
        Wait(0)
    end
    return result
end 