mainLastIndex = 1
vehicle = 0
mainMenuId = 'customs-main'
local QBCore
local inMenu = false
local dragcam = require('client.dragcam')
local startDragCam = dragcam.startDragCam
local stopDragCam = dragcam.stopDragCam

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local menu = {
    id = mainMenuId,
    canClose = true,
    disableInput = false,
    title = 'Popcorn Customs',
    position = 'top-left',
    options = {},
}

local function main()
    if GetVehicleBodyHealth(vehicle) < 1000.0 then
        return {{
            label = 'Reparar',
            description = ('%s%d'):format(Config.Currency, math.ceil(1000 - GetVehicleBodyHealth(vehicle))),
            close = true,
        }}
    end

    local options = {
        {
            label = 'Rendimiento',
            close = true,
            args = {
                menu = 'client.menus.performance',
            }
        },
        {
            label = 'Cosméticos - Piezas',
            close = true,
            args = {
                menu = 'client.menus.parts',
            }
        },
        {
            label = 'Cosméticos - Colores',
            close = true,
            args = {
                menu = 'client.menus.colors',
            }
        },
    }

    if DoesExtraExist(vehicle, 1) then
        options[#options + 1] = {
            label = 'Extras',
            close = true,
            args = {
                menu = 'client.menus.extras',
            }
        }
    end

    return options
end

local function disableControls()
    inMenu = true
    CreateThread(function()
        while inMenu do
            Wait(0)
            DisableControlAction(0, 71, true) -- acelerando
            DisableControlAction(0, 72, true) -- desacelerando
            for i = 81, 85 do -- radio
                DisableControlAction(0, i, true)
            end
            DisableControlAction(0, 106, true) -- girar las ruedas del vehículo
        end
    end)
end

local function repair()
    local success = lib.callback.await('customs:server:repair', false, GetVehicleBodyHealth(vehicle))
    if success then
        lib.notify({
            title = 'Customs',
            description = '¡Vehículo reparado!',
            position = 'top',
            type = 'success'
        })
        SendNUIMessage({sound = true})
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleEngineHealth(vehicle, 1000.0)
        local fuelLevel = GetVehicleFuelLevel(vehicle)
        SetVehicleFixed(vehicle)
        SetVehicleFuelLevel(vehicle, fuelLevel)
    else
        lib.notify({
            title = 'Customs',
            description = '¡No tienes suficiente dinero!',
            position = 'top',
            type = 'error'
        })
    end

    menu.options = main()
    lib.setMenuOptions(menu.id, menu.options)
    lib.showMenu(menu.id, 1)
end

local function onSubmit(selected, scrollIndex, args)
    if menu.options[selected].label == 'Reparar' then
        lib.hideMenu(false)
        repair()
        return
    end
    local menuId = require(args.menu)()
    lib.showMenu(menuId, 1)
end

menu.onSelected = function(selected)
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    mainLastIndex = selected
end

menu.onClose = function()
    inMenu = false
    stopDragCam()
    if not lib.callback.await('customs:server:adminMenuOpened') then
        lib.showTextUI('Presiona [E] para tunear tu coche', {
            icon = 'fa-solid fa-car',
            position = 'left-center',
        })
    end
    if QBCore then
        TriggerServerEvent("customs:server:saveVehicleProps")
    end
end

lib.callback.register('customs:client:vehicleProps', function()
    return QBCore.Functions.GetVehicleProperties(vehicle)
end)

return function()
    if not cache.vehicle or inMenu then return end
    vehicle = cache.vehicle
    SetVehicleModKit(vehicle, 0)
    menu.options = main()
    lib.registerMenu(menu, onSubmit)
    lib.showMenu(menu.id, 1)
    disableControls()
    startDragCam(vehicle)
end