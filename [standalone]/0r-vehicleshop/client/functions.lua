Koci.Client.GetVehicleProperties = function(vehicle)
    if Config.FrameWork == "esx" then
        return Koci.Framework.Game.GetVehicleProperties(vehicle)
    elseif Config.FrameWork == "qb" then
        return Koci.Framework.Functions.GetVehicleProperties(vehicle)
    end
end

Koci.Client.SetVehicleProperties = function(vehicle, props)
    if Config.FrameWork == "esx" then
        return Koci.Framework.Game.SetVehicleProperties(vehicle, props)
    elseif Config.FrameWork == "qb" then
        return Koci.Framework.Functions.SetVehicleProperties(vehicle, props)
    end
end

--- A simple wrapper around SendNUIMessage that you can use to
--- dispatch actions to the React frame.
---
---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
Koci.Client.SendReactMessage = function(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

---@param system ("esx_notify" | "qb_notify" | "custom_notify") System to be used
---@param type string inform / success / error
---@param title string Notification text
---@param text? string (optional) description, custom notify.
---@param duration? number (optional) Duration in miliseconds, custom notify.
---@param icon? string (optional) icon.
Koci.Client.SendNotify = function(title, type, duration, icon, text)
    system = Config.NotifyType
    if system == "esx_notify" then
        if Config.FrameWork == "esx" then
            Koci.Framework.ShowNotification(title, type, duration)
        end
    elseif system == "qb_notify" then
        if Config.FrameWork == "qb" then
            Koci.Framework.Functions.Notify(title, type)
        end
    elseif system == "custom_notify" then
        Utils.Functions.CustomNotify(nil, title, type, text, duration, icon)
    end
end

--- Gets player data based on the configured framework.
---@return PlayerData table player data.
Koci.Client.GetPlayerData = function()
    if Config.FrameWork == "esx" then
        return Koci.Framework.GetPlayerData()
    elseif Config.FrameWork == "qb" then
        return Koci.Framework.Functions.GetPlayerData()
    end
end

-- Draws 3D text at the specified world coordinates.
---@param x (number) The X-coordinate of the text in the world.
---@param y (number) The Y-coordinate of the text in the world.
---@param z (number) The Z-coordinate of the text in the world.
---@param text (string) The text to be displayed.
Koci.Client.DrawText3D = function(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 70, 134, 123, 75)
    ClearDrawOrigin()
end

--- Loads a model on the client.
---@param model number|string The model to load, specified as either a number or a string.
Koci.Client.LoadModel = function(model)
    if HasModelLoaded(model) then
        return
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

--- Displays a text UI based on the specified framework.
--- @param _type string (optional) The framework to use, defaults to Config.FrameWork if not provided.
--- @param message string The message to display in the text UI.
--- @param options table (optional) Additional options for displaying the text UI.
Koci.Client.ShowTextUI = function(_type, message, options)
    _type = _type or Config.FrameWork
    if _type == "qb" then
        if not Utils.Functions.hasResource("qb-core") then
            Utils.Functions.debugPrint("qb-core is not active on your server !")
            return
        end
        exports["qb-core"]:DrawText(message, "right")
    elseif _type == "ox" then
        if not Utils.Functions.hasResource("ox_lib") then
            Utils.Functions.debugPrint("ox_lib is not active on your server !")
            return
        end
        if not options then
            options = {
                position = "left-center"
            }
        end
        lib.showTextUI(message, options)
    end
end

--- Hides the currently displayed text UI.
Koci.Client.HideTextUI = function()
    if Utils.Functions.hasResource("ox_lib") then
        lib.hideTextUI()
    end
    if Utils.Functions.hasResource("qb-core") then
        exports["qb-core"]:HideText()
    end
end

-- @ End core func.
-- @ Start script func.

function deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepCopy(orig_key)] = deepCopy(orig_value)
        end
        setmetatable(copy, deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function openGallery(g)
    OpenedGallery = deepCopy(g)
    if OpenedGallery.discount and OpenedGallery.discount.active then
        local updatedVehicles = calculateDiscountedPriceOfVehicles(
            OpenedGallery.vehicles,
            OpenedGallery.discount.percentage
        )
        OpenedGallery.vehicles = updatedVehicles
    end
    setBankBalance()
    SetEntityVisible(PlayerPedId(), false)
    SetEntityCoords(PlayerPedId(), OpenedGallery.playerTeleportCoords.xyz)
    SetEntityHeading(PlayerPedId(), OpenedGallery.playerTeleportCoords.w)
    Wait(100)
    create_gCam(OpenedGallery.camCoords, OpenedGallery.camRotation)
    SetNuiFocus(true, true)
    if not IsRadarHidden() then
        DisplayRadar(false)
    end
    closeHud()
    OpenedGallery.currentCam = "selected"
    playRandomMusic()
    Koci.Client.SendReactMessage("load_gallery", OpenedGallery)
    Koci.Client.SendReactMessage("setVisible", true)
end

function playRandomMusic()
    if Config.Music.status then
        local volume = Config.Music.volume
        local musics = Config.Music.musics
        local selectedMusic = musics[math.random(#musics)]
        Koci.Client.SendReactMessage("setPlayingSong", {
            on = false,
            file = selectedMusic.fileName,
            author = selectedMusic.author,
            name = selectedMusic.name,
            volume = volume
        })
    else
        Koci.Client.SendReactMessage("setPlayingSong", {
            on = false,
            file = "No",
            author = "No",
            name = "No"
        })
    end
end

function closeCurrentGallery()
    DoScreenFadeIn(0)
    if OpenedGallery then
        SetEntityCoords(PlayerPedId(), OpenedGallery.coords)
    end
    if IsRadarHidden() then
        DisplayRadar(true)
    end
    OpenedGallery = nil
    SetNuiFocus(false, false)
    destroy_gCam()
    SetEntityVisible(PlayerPedId(), true)
    openHud()
    deleteSpawnedCars()
end

function create_gCam(coords, rot)
    if not DoesCamExist(gCam) then
        gCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
        SetCamCoord(gCam, coords)
        SetCamRot(gCam, rot, 2)
        SetCamActive(gCam, true)
        RenderScriptCams(true, true, 1000)
    end
end

function destroy_gCam()
    if DoesCamExist(gCam) then
        DestroyCam(gCam, true)
        RenderScriptCams(false, false, 1)
        gCam = nil
    end
end

function setGlobalCamCoords(coords, rot)
    if DoesCamExist(gCam) then
        RenderScriptCams(false, false, 1)
        SetCamCoord(gCam, coords)
        SetCamRot(gCam, rot, 2)
        RenderScriptCams(true, true, 1000)
    end
end

function deleteSpawnedCars()
    for i, v in pairs(gSpawnedVehicles) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
        gSpawnedVehicles[i] = nil
    end
end

function deleteSpawnedCar(i)
    if DoesEntityExist(gSpawnedVehicles[i]) then
        DeleteEntity(gSpawnedVehicles[i])
    end
    gSpawnedVehicles[i] = nil
end

function setBankBalance()
    Koci.Client.TriggerServerCallback("0r-vehicleshop:Server:GetPlayerAccountBalance", {
        type = "bank"
    }, function(balance)
        Koci.Client.SendReactMessage("setBankBalance", tonumber(balance))
    end)
end

function calculateVehiclePrice(_vehicle, plate, payment)
    local price = _vehicle.price
    plate = tostring(plate)
    local platePrice = 0
    local blackMoneyPrice = 1
    if type(plate) == "string" and #plate > 0 then
        platePrice = tonumber(OpenedGallery.customPlate.price)
    end
    if payment == "black_money" then
        price = price * tonumber(OpenedGallery.buyWithBlackMoney.multiplier)
    elseif payment == "coin" then
        price = _vehicle.coinPrice
    end
    return math.floor(price + platePrice)
end

function calculateVehicleRentalFee(price, custom_plate, rented_day, daily_fee)
    local rentel_fee = math.floor(daily_fee * rented_day)
    if type(custom_plate) == "string" and #custom_plate > 0 then
        rentel_fee = rentel_fee + tonumber(OpenedGallery.customPlate.price)
    end
    return math.floor(rentel_fee)
end

function calculateDiscountedPriceOfVehicles(vehicles, percentage)
    if type(percentage) ~= "number" or percentage < 0 or percentage > 100 then
        percentage = 0
    end
    if type(vehicles) ~= "table" then
        return Config.Vehicles or {}
    end
    for category, cVehicles in pairs(vehicles) do
        for key, value in pairs(cVehicles) do
            local oldPrice = value.price
            local discountAmount = oldPrice * (percentage / 100)
            local newPrice = oldPrice - discountAmount
            value.price = math.floor(newPrice)
        end
    end
    return vehicles
end

function GetVehicleTractionType(value)
    if value == 0.0 then
        return "RWD"
    elseif value > 0.0 and value < 0.35 then
        return "AWD 30/70"
    elseif value == 0.5 then
        return "AWD"
    elseif value > 0.5 and value < 0.75 then
        return "AWD 70/30"
    elseif value == 1.0 then
        return "FWD"
    else
        return "-undefined-"
    end
end

function calculateAccelerationTimeForVehicle(vehicle_top_speed)
    local initialSpeed = 0
    local finalSpeed = 100
    local accelerationFactor = 6

    local acceleration = vehicle_top_speed / accelerationFactor
    local accelerationTime = (finalSpeed - initialSpeed) / acceleration

    return string.format("%.2f", accelerationTime)
end

function RotateVehicle(vehicle)
    Citizen.CreateThread(function()
        while gRotatingVehicles[vehicle] and DoesEntityExist(vehicle) do
            SetEntityRotation(vehicle, GetEntityRotation(vehicle) + vector3(0, 0, 0.1), false, false, 2, false)
            Wait(10)
        end
    end)
end

function CheckOverdueRentalCars()
    Koci.Client.TriggerServerCallback("0r-vehicleshop:Server:CheckOverdueRentalCars", nil, function(r)
        if r.any_action then
            Koci.Client.SendNotify(_t("rent.overdue_vehicles_deleted"))
        end
    end)
end
