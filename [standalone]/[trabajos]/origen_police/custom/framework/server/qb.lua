if Config.Framework ~= "qbcore" then return end
if GetResourceState("qb-core") ~= "started" then
    while true do 
        print("^0[^5Origen Police^0] qb-core is not started, please make sure to start origen_police after qb-core^0")
        Wait(2000)
    end
end
Framework = exports['qb-core']:GetCoreObject()

function FW_CreateCallback(name, callback, mdw)
    Framework.Functions.CreateCallback(name, function(source, cb1, ...)
        if mdw then
            local args = {...}
            mdw(source, cb1, function()
                callback(source, cb1, table.unpack(args))
            end)
        else
            callback(source, cb1, ...)
        end
    end)
end

function FW_GetPlayer(source)
    local Player = Framework.Functions.GetPlayer(source)
    if Player == nil then return nil end
    return Player
end

function FW_GetPlayerFromCitizenid(citizenid)
    return Framework.Functions.GetPlayerByCitizenId(citizenid) or Framework.Functions.GetOfflinePlayerByCitizenId(citizenid)
end

function FW_CreateUseableItem(...)
    Framework.Functions.CreateUseableItem(...)
end

function FW_CommandsAdd(name, help, arguments, argsrequired, callback, permission, ...)
    Framework.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
end

exports('FW_CreateCallback', FW_CreateCallback)
exports("FW_GetPlayer", FW_GetPlayer)
exports("FW_GetPlayerFromCitizenid", FW_GetPlayerFromCitizenid)
exports("FW_CreateUseableItem", FW_CreateUseableItem)
exports("FW_CommandsAdd", FW_CommandsAdd)

exports('GetCoreObject', function()
    return Framework
end)