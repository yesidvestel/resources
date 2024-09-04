local ESX = nil
local QBCore = nil
local FrameworkFound = nil
local nuiOpen = false
local modelCreated = {}

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
end

-- Crear hilo para inicializar el framework y cargar datos
Citizen.CreateThread(function()
    LoadFramework()
    TriggerServerEvent('ricky-vinewood:loadText')
end)

-- Evento para abrir el NUI
RegisterNetEvent('ricky-vinewood:openNui')
AddEventHandler('ricky-vinewood:openNui', function(text, color)
    nuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "SET_LOCALES",
        locales = Config.Locales
    })
    SendNUIMessage({
        type = "OPEN",
        text = text or "",
        color = color or "#FFFFFF"
    })
end)

-- Callback para guardar texto
RegisterNUICallback('saveText', function(data)
    TriggerServerEvent('ricky-vinewood:saveText', data)
end)

-- Callback para cerrar el NUI
RegisterNUICallback('close', function(data)
    nuiOpen = false
    SetNuiFocus(false, false)
end)

-- Evento para actualizar el texto
RegisterNetEvent('ricky-vinewood:saveText')
AddEventHandler('ricky-vinewood:saveText', function(data)
    UpdateMap(data)
    if nuiOpen then 
        SendNUIMessage({
            type = "UPDATE",
            text = data[1] or "",
            color = data[2] or "#FFFFFF"
        })
    end
end)

-- Evento para eliminar modelos cuando se detiene el recurso
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(modelCreated) do
            DeleteEntity(v)
        end
    end
end)

-- Convertir hex a RGB
hexToRgb = function(hex)
    hex = hex:gsub("#","")
    return {
        r = tonumber("0x"..hex:sub(1,2)),
        g = tonumber("0x"..hex:sub(3,4)),
        b = tonumber("0x"..hex:sub(5,6))
    }
end

-- Actualizar el mapa con nuevos modelos
UpdateMap = function(data)
    for _, v in pairs(modelCreated) do
        DeleteEntity(v)
    end
    modelCreated = {}
    if not data or not data[1] then return end
    local completeText = data[1]
    for i = 1, #completeText do 
        if i > 8 then 
            return 
        end
        local string = completeText:sub(i, i)
        local model = string
        local coords = Config.Coords[i].coordinate
        local heading = Config.Coords[i].heading
        if model ~= " " then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(1)
            end

            local obj = CreateObject(model, coords, false, false, false)
            SetEntityHeading(obj, heading)
            table.insert(modelCreated, obj)
            SetColorModel(model, "techdevontop", hexToRgb(data[2] or "#FFFFFF"))
        end
    end
end

-- Establecer el color del modelo
SetColorModel = function(model, textureName, colorRgb)
    if not colorRgb or not colorRgb.r or not colorRgb.g or not colorRgb.b then
        print("[ERROR] colorRgb no válido.")
        return
    end
    local txd = 'txd_vinewood_sign'
    local txn = 'txn_vinewood_sign'
    local dict = CreateRuntimeTxd(txd)
    local texture = CreateRuntimeTexture(dict, txn, 4, 4)
    local resolution = GetTextureResolution(txd, txn)
    if(colorRgb.r == 255 and colorRgb.g == 255 and colorRgb.b == 255) then
        RemoveReplaceTexture("mainTexture", textureName)
    else
        SetRuntimeTexturePixel(texture, 0, 0, colorRgb.r, colorRgb.g, colorRgb.b, 255)
        CommitRuntimeTexture(texture)
        AddReplaceTexture("mainTexture", textureName, txd, txn)  
    end  
end
