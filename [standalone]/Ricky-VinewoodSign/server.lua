local ESX = nil
local QBCore = nil
local FrameworkFound = nil

LoadFramework = function()
    if Config.Framework == 'esx' then 
        ESX = exports['es_extended']:getSharedObject()
        FrameworkFound = 'esx'
    elseif Config.Framework == 'qbcore' then 
        QBCore = exports["qb-core"]:GetCoreObject()
        FrameworkFound = 'qbcore'
    elseif Config.Framework == 'autodetect' then
        if GetResourceState('es_extended') == 'started' then 
            ESX = exports['es_extended']:getSharedObject()
            FrameworkFound = 'esx'
        elseif GetResourceState('qb-core') == 'started' then
            QBCore = exports["qb-core"]:GetCoreObject()
            FrameworkFound = 'qbcore'
        else
            FrameworkFound = 'standalone'
        end
    elseif Config.Framework == 'standalone' then
        FrameworkFound = 'standalone'
    else
        print('[Ricky-VinewoodSign] Error: Framework configuration not recognized.')
    end

    print('[Ricky-VinewoodSign] Framework found: ' .. (FrameworkFound or 'none'))
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then 
        LoadFramework()
    end
end)

Authorized = function(source)
    if FrameworkFound == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            for _, v in pairs(Config.AuthorizedGroups.group) do 
                if xPlayer.getGroup() == v then 
                    return true
                end
            end
        end
    elseif FrameworkFound == 'qbcore' then
        for _, v in pairs(Config.AuthorizedGroups.group) do 
            if QBCore.Functions.HasPermission(source, v) then 
                return true
            end
        end
    elseif FrameworkFound == 'standalone' then
        for _, v in pairs(Config.AuthorizedGroups.identifier) do 
            local identifiers = GetPlayerIdentifiers(source)
            if identifiers then
                for _, v2 in pairs(identifiers) do 
                    if v2 == v then 
                        return true
                    end
                end
            end
        end
    end
    return false
end

GetFileData = function()
    local file = LoadResourceFile(GetCurrentResourceName(), Config.FileName)
    if file then
        local data = json.decode(file)
        if type(data) == 'table' then
            return data
        else
            print('[Ricky-VinewoodSign] Error: JSON decoding failed or data is not a table.')
        end
    else
        print('[Ricky-VinewoodSign] Error: Could not load file ' .. Config.FileName)
    end
    return {}
end

RegisterCommand(Config.Command, function(source, args, rawCommand)
    if not Authorized(source) then return end
    local fileData = GetFileData()
    if next(fileData) then
        TriggerClientEvent('ricky-vinewood:openNui', source, fileData[1] or '', fileData[2] or '')
    end
end)

RegisterServerEvent('ricky-vinewood:saveText')
AddEventHandler('ricky-vinewood:saveText', function(data)
    if not Authorized(source) then return end
    local newText = data.text or ''
    local newColor = data.color or ''
    local fileData = GetFileData()
    fileData[1] = newText
    fileData[2] = newColor
    local success = SaveResourceFile(GetCurrentResourceName(), Config.FileName, json.encode(fileData, {indent = true}), -1)
    if success then
        TriggerClientEvent('ricky-vinewood:saveText', -1, fileData)
    else
        print('[Ricky-VinewoodSign] Error: Could not save data to file ' .. Config.FileName)
    end
end)

RegisterServerEvent('ricky-vinewood:loadText')
AddEventHandler('ricky-vinewood:loadText', function()
    TriggerClientEvent('ricky-vinewood:saveText', source, GetFileData())
end)
