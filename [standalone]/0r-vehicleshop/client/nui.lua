RegisterNUICallback("hideFrame", function(_, cb)
    closeCurrentGallery()
    Koci.Client.SendReactMessage("setVisible", false)
    Koci.Client.SendReactMessage("resetFrame")
    cb(true)
end)

RegisterNUICallback("loadLocaleFile", function(_, cb)
    Wait(1)
    SendNUIMessage({
        action = "setLocale",
        data = locales.ui
    })
    cb(true)
end)

RegisterNUICallback("setCompareCameraCoords", function(_, cb)
    if OpenedGallery.currentCam == "selected" then
        OpenedGallery.currentCam = "compared"
        setGlobalCamCoords(
            OpenedGallery.compareCoords.comparedCam.coords,
            OpenedGallery.compareCoords.comparedCam.rotation
        )
    elseif OpenedGallery.currentCam == "compared" then
        OpenedGallery.currentCam = "selected"
        setGlobalCamCoords(
            OpenedGallery.compareCoords.selectedCam.coords,
            OpenedGallery.compareCoords.selectedCam.rotation
        )
    end
    cb({ status = true, currentCam = OpenedGallery.currentCam })
end)

RegisterNUICallback("setVehicleColor", function(data, cb)
    local vehicle = data.vehicle
    SetVehicleColours(vehicle, math.random(0, 159), math.random(0, 159))
    SetVehicleCustomPrimaryColour(
        vehicle,
        tonumber(data.color.r),
        tonumber(data.color.g),
        tonumber(data.color.b)
    )
    cb(true)
end)

RegisterNUICallback("startRotatingVehicle", function(data, cb)
    local vehicle = OpenedGallery.currentCam == "selected" and
        gSpawnedVehicles[1]
        or
        gSpawnedVehicles[2]
    if vehicle and DoesEntityExist(vehicle) then
        gRotatingVehicles[vehicle] = GetEntityRotation(vehicle)
        RotateVehicle(vehicle)
    end
    cb(true)
end)

RegisterNUICallback("stopRotatingVehicles", function(_, cb)
    for key, value in pairs(gRotatingVehicles) do
        local vehicle = key
        local rot = value
        gRotatingVehicles[vehicle] = nil
        SetEntityRotation(vehicle, rot, false, false, 2, false)
    end
    cb(true)
end)

RegisterNUICallback("onToggleCompareActive", function(status, cb)
    if not status then
        local selectedCar = gSpawnedVehicles[1]
        local comparedCar = gSpawnedVehicles[2]
        local playerPedId = PlayerPedId()
        if DoesEntityExist(selectedCar) and OpenedGallery.currentCam == "selected" then
            SetEntityCoords(selectedCar, OpenedGallery.carSpawnCoords.xyz)
            SetEntityHeading(selectedCar, OpenedGallery.carSpawnCoords.w)
        end
        if DoesEntityExist(comparedCar) and OpenedGallery.currentCam == "compared" then
            SetEntityCoords(comparedCar, OpenedGallery.compareCoords.nosm_com_veh_coords.xyz)
            SetEntityHeading(comparedCar, OpenedGallery.compareCoords.nosm_com_veh_coords.w)
        end
    end
    cb(true)
end)

RegisterNUICallback("BuyAVehicle", function(data, cb)
    local vehicle = data.vehicle
    local paymentMethod = data.paymentMethod
    local customPlate = data.customPlate
    if not DoesEntityExist(vehicle.entity) then
        cb({ status = false, error = "Entity doesn't exist !" })
        return
    end
    local PlayerPed = PlayerPedId()
    local totalPrice = calculateVehiclePrice(vehicle, customPlate, paymentMethod)
    local vehicleProps = Koci.Client.GetVehicleProperties(gSpawnedVehicles[1])
    local deliveryCoords = OpenedGallery.deliveryCoords
    Koci.Client.TriggerServerCallback("0r-vehicle:Server:BuyNewVehicle", {
        vehicle = vehicle,
        price = totalPrice,
        paymentMethod = paymentMethod,
        customPlate = customPlate,
        gallery = OpenedGallery,
        vehicleProps = vehicleProps
    }, function(r)
        if r.status == true then
            Koci.Client.LoadModel(vehicle.name)
            DoScreenFadeOut(150)
            Wait(500)
            closeCurrentGallery()
            Koci.Client.SendReactMessage("setVisible", false)
            Koci.Client.SendReactMessage("resetFrame")
            SetEntityCoords(PlayerPed, deliveryCoords, true)
            local spawnedVehicle = CreateVehicle(
                vehicle.name,
                deliveryCoords,
                true,
                true
            )
            Koci.Client.SetVehicleProperties(spawnedVehicle, vehicleProps)
            SetVehicleFuelLevel(spawnedVehicle, 100.0)
            SetVehicleNumberPlateText(spawnedVehicle, r.plate)
            SetPedIntoVehicle(PlayerPed, spawnedVehicle, -1)
            SetModelAsNoLongerNeeded(vehicle.name)
            giveVehicleKey(r.plate)
            TriggerEvent("bp_garage:addownervehicle", false)
            DoScreenFadeIn(150)
            Wait(500)
            Koci.Client.SendNotify(_t("buy.success"), "success")
            cb({ status = true })
        else
            cb({
                status = false,
                error = r.error
            })
        end
    end)
end)

RegisterNUICallback("RentAVehicle", function(data, cb)
    local vehicle = data.vehicle
    local customPlate = data.customPlate
    local paymentMethod = data.paymentMethod
    local rentedDay = data.rentedDay
    local daily_fee = (vehicle.price * OpenedGallery.vehiclesBeRented.percentageOfRentalFee) / 100
    if not DoesEntityExist(vehicle.entity) then
        cb({ status = false, error = "Entity doesn't exist !" })
        return
    end
    local PlayerPed = PlayerPedId()
    local totalPrice = calculateVehicleRentalFee(vehicle.price, customPlate, rentedDay, daily_fee)
    local vehicleProps = Koci.Client.GetVehicleProperties(gSpawnedVehicles[1])
    -- local vehicleProps = Koci.Client.GetVehicleProperties(GetVehiclePedIsIn(PlayerPed))
    local deliveryCoords = OpenedGallery.deliveryCoords
    Koci.Client.TriggerServerCallback("0r-vehicle:Server:RentNewVehicle", {
        vehicle = vehicle,
        price = totalPrice,
        paymentMethod = paymentMethod,
        customPlate = customPlate,
        gallery = OpenedGallery,
        vehicleProps = vehicleProps,
        rented_day = rentedDay,
        daily_fee = daily_fee
    }, function(r)
        if r.status == true then
            Koci.Client.LoadModel(vehicle.name)
            DoScreenFadeOut(150)
            Wait(500)
            closeCurrentGallery()
            Koci.Client.SendReactMessage("setVisible", false)
            Koci.Client.SendReactMessage("resetFrame")
            SetEntityCoords(PlayerPed, deliveryCoords, true)
            local spawnedVehicle = CreateVehicle(
                vehicle.name,
                deliveryCoords,
                true,
                true
            )
            Koci.Client.SetVehicleProperties(spawnedVehicle, vehicleProps)
            SetVehicleFuelLevel(spawnedVehicle, 100.0)
            SetVehicleNumberPlateText(spawnedVehicle, r.plate)
            SetPedIntoVehicle(PlayerPed, spawnedVehicle, -1)
            SetModelAsNoLongerNeeded(vehicle.name)
            giveVehicleKey(r.plate)
            DoScreenFadeIn(150)
            Wait(500)
            Koci.Client.SendNotify(_t("rent.success"), "success")
            cb({ status = true })
        else
            cb({
                status = false,
                error = r.error
            })
        end
    end)
end)

RegisterNUICallback("testDrive", function(data, cb)
    local vehicle = data.vehicle
    local _entity = vehicle.entity
    local lastOpenedGallery = OpenedGallery
    if not vehicle or
        not _entity or
        gPlayerInTestDrive or
        not DoesEntityExist(_entity)
    then
        cb(false)
        return
    end
    local vProps = Koci.Client.GetVehicleProperties(_entity)
    closeCurrentGallery()
    Koci.Client.SendReactMessage("setVisible", false)
    Koci.Client.SendReactMessage("resetFrame")
    DoScreenFadeOut(150)
    Wait(500)
    Koci.Client.LoadModel(vehicle.name)
    local spawnedVehicle = CreateVehicle(vehicle.name, lastOpenedGallery.testDrive.startCoords, false, false)
    Koci.Client.SetVehicleProperties(_entity, vProps)
    SetPedIntoVehicle(PlayerPedId(), spawnedVehicle, -1)
    SetVehicleNumberPlateText(spawnedVehicle, _t("vehicle.showing_test_drive_plate"))
    SetModelAsNoLongerNeeded(vehicle.name)
    gSpawnedVehicles[3] = spawnedVehicle
    DoScreenFadeIn(150)
    Wait(500)
    Koci.Client.SendNotify(_t("test_drive.started_message", lastOpenedGallery.testDrive.seconds), "success")
    Citizen.CreateThread(function()
        local condt_finish = false
        local step = 0
        local start = GetGameTimer() / 1000
        while not condt_finish and (GetGameTimer() / 1000 - start < lastOpenedGallery.testDrive.seconds and DoesEntityExist(spawnedVehicle) and not IsEntityDead(PlayerPedId())) do
            if #(GetEntityCoords(PlayerPedId()) - lastOpenedGallery.testDrive.startCoords.xyz) > lastOpenedGallery.testDrive.range then
                SetPedCoordsKeepVehicle(PlayerPedId(), lastOpenedGallery.testDrive.startCoords.w)
            end
            if GetVehiclePedIsIn(PlayerPedId(), false) == 0 and DoesEntityExist(spawnedVehicle) then
                if 5 - step ~= 0 then
                    Koci.Client.SendNotify(_t("test_drive.into_warn", (5 - step)), "success")
                end
                if step == 5 then
                    condt_finish = true
                end
                step = step + 1
            elseif step ~= 0 then
                step = 0
            end
            Wait(1000)
        end
        FreezeEntityPosition(spawnedVehicle, true)
        SetVehicleUndriveable(spawnedVehicle, true)
        ClearPedTasksImmediately(PlayerPedId())
        deleteSpawnedCars()
        SetEntityCoords(PlayerPedId(), lastOpenedGallery.coords)
        Koci.Client.SendNotify(_t("test_drive.end_message"), "success")
    end)
    cb(true)
end)

RegisterNUICallback("showVehicle", function(selectedVehicle, cb)
    local vehicle = selectedVehicle
    local model = (type(vehicle.name) == "number" and vehicle.name or GetHashKey(vehicle.name))
    CreateThread(function()
        Koci.Client.LoadModel(model)
        deleteSpawnedCars()
        local spawnedVehicle = CreateVehicle(model, OpenedGallery.carSpawnCoords, false, false)
        SetVehicleEngineOn(spawnedVehicle, false, true, true)
        SetVehicleNumberPlateText(spawnedVehicle, _t("vehicle.showing_plate"))
        SetVehicleRadioEnabled(spawnedVehicle, false)
        SetVehicleFixed(spawnedVehicle)
        SetVehicleFuelLevel(spawnedVehicle, 100.0)
        SetVehicleDirtLevel(spawnedVehicle, 0.0)
        SetVehicleLights(spawnedVehicle, 1)
        SetModelAsNoLongerNeeded(model)
        gSpawnedVehicles[1] = spawnedVehicle
        local vehicle_top_speed = math.floor((
            GetVehicleHandlingFloat(
                spawnedVehicle,
                "CHandlingData",
                "fInitialDriveMaxFlatVel"
            ) * 1.2
        ) / 0.9)
        local vehicle_traction = GetVehicleHandlingFloat(
            spawnedVehicle,
            "CHandlingData",
            "fDriveBiasFront"
        )
        local vehicle_grip = GetVehicleHandlingInt(
            spawnedVehicle,
            "CHandlingData",
            "fSteeringLock"
        )
        local vehicleSpecifications = {
            entity = spawnedVehicle,
            name = vehicle.name,
            label = vehicle.label,
            grip = vehicle_grip,
            drift = 100 - vehicle_grip,
            traction = GetVehicleTractionType(vehicle_traction),
            road = Config.VehicleClasses[GetVehicleClass(spawnedVehicle)],
            top_speed = vehicle_top_speed,
            sec_0_100 = calculateAccelerationTimeForVehicle(vehicle_top_speed),
            price = vehicle.price,
            coinPrice = vehicle.coinPrice
        }
        if not OpenedGallery.currentCam or OpenedGallery.currentCam ~= "selected" then
            OpenedGallery.currentCam = "selected"
            setGlobalCamCoords(OpenedGallery.camCoords, OpenedGallery.camRotation)
        end
        cb({ status = true, vehicle = vehicleSpecifications })
    end)
end)

RegisterNUICallback("showComparedVehicle", function(comparedVehicle, cb)
    local vehicle = comparedVehicle
    local model = (type(vehicle.name) == "number" and vehicle.name or GetHashKey(vehicle.name))
    local playerPedId = PlayerPedId()
    CreateThread(function()
        Koci.Client.LoadModel(model)
        local selectedVehicle = gSpawnedVehicles[1]
        local selectedVehicleCoords = GetEntityCoords(selectedVehicle)
        local configSelectedVehicleCoords = OpenedGallery.compareCoords.selectedVehicleCoords
        local _dist = #(selectedVehicleCoords.xy - configSelectedVehicleCoords.xy)
        if _dist > 1 then
            SetEntityCoords(selectedVehicle, configSelectedVehicleCoords.xyz)
            SetEntityHeading(selectedVehicle, configSelectedVehicleCoords.w)
        end
        deleteSpawnedCar(2)
        local spawnedVehicle = CreateVehicle(model, OpenedGallery.compareCoords.comparedVehicleCoords, false, false)
        SetVehicleEngineOn(spawnedVehicle, false, true, true)
        SetVehicleNumberPlateText(spawnedVehicle, _t("vehicle.showing_plate"))
        SetVehicleRadioEnabled(spawnedVehicle, false)
        SetVehicleFixed(spawnedVehicle)
        SetVehicleFuelLevel(spawnedVehicle, 100.0)
        SetVehicleDirtLevel(spawnedVehicle, 0.0)
        SetVehicleLights(spawnedVehicle, 1)
        SetModelAsNoLongerNeeded(model)
        gSpawnedVehicles[2] = spawnedVehicle
        local vehicle_top_speed = math.floor((
            GetVehicleHandlingFloat(
                spawnedVehicle,
                "CHandlingData",
                "fInitialDriveMaxFlatVel"
            ) * 1.2
        ) / 0.9)
        local vehicle_traction = GetVehicleHandlingFloat(
            spawnedVehicle,
            "CHandlingData",
            "fDriveBiasFront"
        )
        local vehicle_grip = GetVehicleHandlingInt(
            spawnedVehicle,
            "CHandlingData",
            "fSteeringLock"
        )
        local vehicleSpecifications = {
            entity = spawnedVehicle,
            name = vehicle.name,
            label = vehicle.label,
            grip = vehicle_grip,
            drift = 100 - vehicle_grip,
            traction = GetVehicleTractionType(vehicle_traction),
            road = Config.VehicleClasses[GetVehicleClass(spawnedVehicle)],
            top_speed = vehicle_top_speed,
            sec_0_100 = calculateAccelerationTimeForVehicle(vehicle_top_speed),
            price = vehicle.price
        }
        cb({ status = true, vehicle = vehicleSpecifications })
    end)
end)
