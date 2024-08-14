if Config.Framework ~= "esx" then return end
if GetResourceState("es_extended") ~= "started" then
    while true do 
        print("^0[^5Origen Police^0] es_extended is not started, please make sure to start origen_police after es_extended^0")
        Wait(2000)
    end
end
Framework = exports["es_extended"]:getSharedObject()
Framework.Functions = Framework.Functions or {}
Framework.Shared = {}
Framework.Shared.Jobs = {}
Framework.Shared.Vehicles = {}

Citizen.CreateThread(function()
    -- Vehicles
    if tableExists('vehicles') then 
        local vehicles, retvalVehicles = MySQL.awaitQuery("SELECT name, model, category FROM vehicles", {}), {}
        for i = 1, #vehicles, 1 do
            retvalVehicles[vehicles[i].model] = { category = vehicles[i].category }
        end
        Framework.Shared.Vehicles = retvalVehicles
    else
        debuger("^1The 'vehicles' table does not exist. Please configure your own table in origen_police/custom/framework/server/esx.lua.^0")
    end

    -- Jobs
    local attempt = 0
    Framework.Shared.Jobs = Framework.GetJobs()
    
    while next(Framework.Shared.Jobs) == nil do
        attempt = attempt + 1
        if attempt > 10 then
            debuger('^1Failed to load jobs^0')
            break
        end
        debuger('Waiting for load jobs...')
        Wait(1000)
        Framework.Shared.Jobs = Framework.GetJobs()
    end
end)

Framework.RegisterServerCallback("origen_police:server:GetJobs", function(source, cb, data)
    while Framework.Shared.Jobs == nil do
        Citizen.Wait(0)
    end
    cb(Framework.Shared.Jobs)
end)

Framework.RegisterServerCallback("origen_police:server:GetVehicles", function(source, cb, data)
    while Framework.Shared.Vehicles == nil do
        Citizen.Wait(0)
    end
    cb(Framework.Shared.Vehicles)
end)

function FW_CreateCallback(name, callback, mdw)
    Framework.RegisterServerCallback(name, function(source, cb1, ...)
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
    return INTERNAL_QBCORE_PLAYER_TO_ESX_PLAYER(Framework.GetPlayerFromId(source)) 
end

function FW_GetPlayerFromCitizenid(citizenid)
    return INTERNAL_QBCORE_PLAYER_TO_ESX_PLAYER(Framework.GetPlayerFromIdentifier(citizenid), citizenid)
end

Framework.Functions.HasPermission = function(source)
    return Framework.GetPlayerFromId(source).group ~= "user"
end

function INTERNAL_QBCORE_PLAYER_TO_ESX_PLAYER(xPlayer, citizenid)
    if xPlayer then
        local identifier = xPlayer.identifier
        local xPlayerCopy = xPlayer
        xPlayer = {
            Functions = {
                getInventory = function()
                    return xPlayerCopy.getInventory()
                end,
                RemoveItem = function(name, amount, slot)
                    return RemoveItem(xPlayerCopy, name, amount, slot)
                end,
                SetMetaData = function(key, value)
                    if Config.fixQS then 
                        local playerMetadata = MySQL.awaitPrepare("SELECT data FROM origen_metadata WHERE id = ? LIMIT 1", {identifier})
                        playerMetadata = playerMetadata and json.decode(playerMetadata) or {}
                        playerMetadata[key] = value
                        MySQL.rawExec("INSERT INTO origen_metadata (id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?", {identifier, json.encode(playerMetadata), json.encode(playerMetadata)})
                    else 
                        xPlayerCopy.setMeta(key, value)
                    end
                end,
                GetMetaData = function(key)
                    if Config.fixQS then 
                        return FW_GetMetadata(identifier, key) or {}
                    else
                        return xPlayerCopy.getMeta(key) or {}
                    end
                end,
                SetJob = function(name, grade)
                    xPlayerCopy.setJob(name, grade)
                end,
                RemoveMoney = function(type, amount, reason)
                    return xPlayerCopy.removeAccountMoney(type, amount, reason)
                end,
                ClearInventory = function()
                    if Config.Inventory == "ox_inventory" then
                        exports.ox_inventory:ClearInventory(xPlayerCopy.source)
                    elseif Config.Inventory == "codem-inventory" then
                        exports['codem-inventory']:ClearInventory(xPlayerCopy.source)
                    else
                        if Config.Inventory == "origen_inventory" then 
                            exports.origen_inventory:ClearInventory(xPlayerCopy.source)
                            return 
                        end
                        for i = 1, #xPlayerCopy.inventory, 1 do
                            if xPlayerCopy.inventory[i].count > 0 then
                                xPlayerCopy.setInventoryItem(xPlayerCopy.inventory[i].name, 0)
                            end
                        end

                        for i = 1, #xPlayerCopy.loadout, 1 do
                            xPlayerCopy.removeWeapon(xPlayerCopy.loadout[i].name)
                        end

                        if xPlayerCopy.getMoney() > 0 then
                            xPlayerCopy.removeMoney(xPlayerCopy.getMoney(), "Death")
                        end
                
                        if xPlayerCopy.getAccount('black_money').money > 0 then
                            xPlayerCopy.setAccountMoney('black_money', 0, "Death")
                        end
                    end
                end,
                AddItem = function(name, amount, slot, info)
                    if Config.Inventory == "origen_inventory" then 
                        return exports.origen_inventory:AddItem(xPlayerCopy.source, name, amount, slot, info)
                    elseif Config.Inventory == "codem-inventory" then
                        exports['codem-inventory']:AddItem(xPlayerCopy.source, name, amount, slot, info)
                    end
                    return AddItem(xPlayerCopy, name, amount, slot, info)
                end,
            },
            PlayerData = {
                citizenid = xPlayer.identifier,
                charinfo = {
                    firstname = xPlayerCopy.get("firstName"),
                    lastname = xPlayerCopy.get("lastName"),
                    account = exports["origen_police"]:GetPlayerBankNumber(xPlayerCopy.identifier),
                    birthdate = xPlayerCopy.get("dateofbirth"),
                    nationality = "XXXXXXXXX",
                    gender = xPlayerCopy.get("sex"),
                },
                job = {
                    name = xPlayerCopy.job.name,
                    label = xPlayerCopy.job.label,
                    grade = {
                        level = xPlayerCopy.job.grade,
                        label = xPlayerCopy.job.grade_label,
                        name = xPlayerCopy.job.grade_label
                    },
                    isboss = IsBoss(xPlayerCopy.job.grade)
                },
                money = {bank = xPlayerCopy.getAccount('bank').money, cash = xPlayerCopy.getMoney()},
                metadata = xPlayerCopy.metadata or {},
                source = xPlayerCopy.source,
                items = Config.Inventory == "qs-inventory" and exports['qs-inventory']:GetInventory(xPlayerCopy.source) 
                        or Config.Inventory == "ls-inventory" and exports["ls-inventory"]:GetPlayerItems(xPlayerCopy.source)
                        or Config.Inventory == "codem-inventory" and exports['codem-inventory']:GetInventory(xPlayer.identifier, xPlayerCopy.source)
                        or xPlayerCopy.inventory,
            }
        }
        if Config.fixQS then 
            xPlayer.PlayerData.metadata = xPlayer.Functions.GetMetaData()
        end
        return xPlayer
    else
        if not citizenid then return {} end
        local data = MySQL.awaitQuery("SELECT * FROM users WHERE identifier = ? LIMIT 1", {citizenid})
        if data == nil then 
            return xPlayer
        end
        data = data[1]
        if data == nil then 
            return xPlayer
        end
        local jobData = Framework.Shared.Jobs[data.job]
        if not jobData then 
            jobData = {label = "Unknown", grades = {}}
            debuger("The job ^5"..data.job.."^0 can't be loaded^0")
        end
        xPlayer = {
            Functions = {
                SetJob = function(name, grade)
                    MySQL.rawExec("UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?", {name, grade, citizenid})
                end,
                GetMetaData = function(key)
                    if Config.fixQS then 
                        return FW_GetMetadata(citizenid, key) or {}
                    else 
                        return key ~= nil and json.decode(data.metadata)[key] or json.decode(data.metadata) or {}
                    end
                end,
                SetMetaData = function(key, value)
                    if Config.fixQS then 
                        local playerMetadata = MySQL.awaitPrepare("SELECT data FROM origen_metadata WHERE id = ? LIMIT 1", {citizenid})
                        playerMetadata = playerMetadata and json.decode(playerMetadata) or {}
                        playerMetadata[key] = value

                        MySQL.rawExec("INSERT INTO origen_metadata (id, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?", {citizenid, json.encode(playerMetadata), json.encode(playerMetadata)})
                    else 
                        local playerMetadata = json.decode(data["metadata"] or "[]")
                        playerMetadata[key] = value
                        MySQL.rawExec("UPDATE users SET metadata = ? WHERE identifier = ?", {json.encode(playerMetadata), citizenid})
                    end
                end,
            },
            PlayerData = {
                citizenid = data.identifier,
                charinfo = {
                    firstname = data.firstname,
                    lastname = data.lastname,
                    account = exports["origen_police"]:GetPlayerBankNumber(data.identifier),
                    birthdate = data.dateofbirth,
                    nationality = "XXXXXXXXX",
                    gender = data.sex,
                },
                job = {
                    name = data.job,
                    label = jobData.label,
                    grade = {
                        level = data.job_grade,
                        label = (jobData.grades[tostring(data.job_grade)] and jobData.grades[tostring(data.job_grade)].label) or 'Unknown',
                        name = (jobData.grades[tostring(data.job_grade)] and jobData.grades[tostring(data.job_grade)].name) or 'Unknown',
                    },
                    isboss = IsBoss(data.job_grade),
                },
                metadata = json.decode(data.metadata) or {},
                source = nil,
                items = {}
            }
        }
        if Config.fixQS then 
            xPlayer.PlayerData.metadata = xPlayer.Functions.GetMetaData()
        end
        return xPlayer
    end
end

function FW_CreateUseableItem(...)
    Framework.RegisterUsableItem(...)
end

function FW_CommandsAdd(name, help, arguments, argsrequired, callback, permission, ...)
    local _callback = function(xPlayer, args, showError)
        callback(xPlayer.source, args, showError)
    end
    if type(permission) == "table" then
        for k, v in pairs(Config.PermissionsGroups) do 
            table.insert(permission, v)
        end
    else
        permission = {permission}
        for k, v in pairs(Config.PermissionsGroups) do 
            table.insert(permission, v)
        end
    end
    Framework.RegisterCommand({name}, permission, _callback, true, {
        help = help,
        arguments = arguments
    })
end

exports('FW_CreateCallback', FW_CreateCallback)
exports("FW_GetPlayer", FW_GetPlayer)
exports("FW_GetPlayerFromCitizenid", FW_GetPlayerFromCitizenid)
exports("FW_CreateUseableItem", FW_CreateUseableItem)
exports("FW_CommandsAdd", FW_CommandsAdd)

exports('GetCoreObject', function()
    return Framework
end)