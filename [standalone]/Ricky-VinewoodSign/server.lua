local ESX = nil
local QBCore = nil
local FrameworkFound = nil

-- Función para cargar el framework
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
    end

    print('[Ricky-VinewoodSign] Framework found: ' .. tostring(FrameworkFound))
end

-- Evento para cargar el framework cuando se inicia el recurso
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then 
        LoadFramework()
    end
end)

-- Función para verificar autorización
Authorized = function(source)
    if FrameworkFound == 'esx' then 
        if not ESX then
            print("[ERROR] ESX no inicializado.")
            return false
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            return false
        end
        for _, v in pairs(Config.AuthorizedGroups.group) do 
            if xPlayer.getGroup() == v then 
                return true
            end
        end
    elseif FrameworkFound == 'qbcore' then
        if not QBCore then
            print("[ERROR] QBCore no inicializado.")
            return false
        end
        for _, v in pairs(Config.AuthorizedGroups.group) do 
            if QBCore.Functions.HasPermission(source, v) then 
                return true
            end
        end
    elseif FrameworkFound == 'standalone' then
        for _, v in pairs(Config.AuthorizedGroups.identifier) do 
            for _, v2 in pairs(GetPlayerIdentifiers(source)) do 
                if v2 == v then 
                    return true
                end
            end
        end
    end
    return false
end

-- Función para obtener datos del archivo JSON
GetFileData = function()
    local file = LoadResourceFile(GetCurrentResourceName(), Config.FileName)
    if file then
        file = json.decode(file)
        if file then
            return file
        else
            print("[ERROR] Error al decodificar JSON.")
        end
    else
        print("[ERROR] Error al cargar el archivo.")
    end
    return {}
end

-- Comando para abrir el menú
RegisterCommand(Config.Command, function(source, args, rawCommand)
    if not Authorized(source) then return end
    local fileData = GetFileData()
    TriggerClientEvent('ricky-vinewood:openNui', source, fileData[1] or "", fileData[2] or "")
end)

-- Evento para guardar el texto
RegisterServerEvent('ricky-vinewood:saveText')
AddEventHandler('ricky-vinewood:saveText', function(data)
    if not Authorized(source) then return end
    local newText = data.text or ""
    local newColor = data.color or "#FFFFFF"
    local file = LoadResourceFile(GetCurrentResourceName(), Config.FileName)
    file = json.decode(file) or {}
    file[1] = newText
    file[2] = newColor
    SaveResourceFile(GetCurrentResourceName(), Config.FileName, json.encode(file, {indent = true}), -1)
    TriggerClientEvent('ricky-vinewood:saveText', -1, file)
end)

-- Evento para cargar el texto
RegisterServerEvent('ricky-vinewood:loadText')
AddEventHandler('ricky-vinewood:loadText', function()
    TriggerClientEvent('ricky-vinewood:saveText', source, GetFileData())
end)
