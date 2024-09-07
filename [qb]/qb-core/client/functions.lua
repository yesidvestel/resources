QBCore.Functions = {}
-- Player

function QBCore.Functions.GetPlayerData(cb)
    if not cb then return QBCore.PlayerData end
    cb(QBCore.PlayerData)
end

function QBCore.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity)
    return vector4(coords.x, coords.y, coords.z, GetEntityHeading(entity))
end

function QBCore.Functions.HasItem(items, amount)
    return exports['qb-inventory']:HasItem(items, amount)
end

-- Utility

function QBCore.Functions.DrawText(x, y, width, height, scale, r, g, b, a, text)
    -- Use local function instead
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width / 2, y - height / 2 + 0.005)
end

function QBCore.Functions.DrawText3D(x, y, z, text)
    -- Use local function instead
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function QBCore.Functions.RequestAnimDict(animDict)
    if HasAnimDictLoaded(animDict) then return end
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
end

---@param entity number - The entity to look at
---@param timeout number - The time in milliseconds before the function times out
---@param speed number - The speed at which the entity should turn
---@return number - The time at which the entity was looked at
function QBCore.Functions.LookAtEntity(entity, timeout, speed)
    local involved = GetInvokingResource()
    if not DoesEntityExist(entity) then
        turnPromise:reject(involved .. ' :^1  Entity does not exist')
        return turnPromise.value
    end
    if not type(entity) == 'number' then
        turnPromise:reject(involved .. ' :^1  Entity must be a number')
        return turnPromise.value
    end
    if not type(speed) == 'number' then
        turnPromise:reject(involved .. ' :^1  Speed must be a number')
        return turnPromise.value
    end
    if speed > 5.0 then speed = 5.0 end
    if timeout > 5000 then timeout = 5000 end

    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)

    local targetPos = GetEntityCoords(entity)
    local dx = targetPos.x - playerPos.x
    local dy = targetPos.y - playerPos.y
    local targetHeading = GetHeadingFromVector_2d(dx, dy)

    local turnSpeed = speed
    local startTimeout = GetGameTimer()
    while true do
        local currentHeading = GetEntityHeading(ped)
        local diff = targetHeading - currentHeading
        if math.abs(diff) < 2 then
            break
        end

        if diff < -180 then
            diff = diff + 360
        elseif diff > 180 then
            diff = diff - 360
        end

        turnSpeed = speed + (2.5 - speed) * (1 - math.abs(diff) / 180)

        if diff > 0 then
            currentHeading = currentHeading + turnSpeed
        else
            currentHeading = currentHeading - turnSpeed
        end
        SetEntityHeading(ped, currentHeading)
        Wait(0)
        if (startTimeout + timeout) < GetGameTimer() then break end
    end
    SetEntityHeading(ped, targetHeading)
end

-- Function to run an animation
--- @param animDic string: The name of the animation dictionary
--- @param animName string - The name of the animation within the dictionary
--- @param duration number - The duration of the animation in milliseconds. -1 will play the animation indefinitely
--- @param upperbodyOnly boolean - If true, the animation will only affect the upper body of the ped
--- @return number - The timestamp indicating when the animation concluded. For animations set to loop indefinitely, this will still return the maximum duration of the animation.
function QBCore.Functions.PlayAnim(animDict, animName, upperbodyOnly, duration)
    local invoked = GetInvokingResource()
    local animPromise = promise.new()
    if type(animDict) ~= 'string' or type(animName) ~= 'string' then
        animPromise:reject(invoked .. ' :^1  Wrong type for animDict or animName')
        return animPromise.value
    end
    if not DoesAnimDictExist(animDict) then
        animPromise:reject(invoked .. ' :^1  Animation dictionary does not exist')
        return animPromise.value
    end

    local flags = upperbodyOnly and 16 or 0
    local runTime = duration or -1
    if runTime == -1 then flags = 49 end
    local ped = PlayerPedId()
    local start = GetGameTimer()
    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)
        if (GetGameTimer() - start) > 5000 then
            animPromise:reject(invoked .. ' :^1  Animation dictionary failed to load')
            return animPromise.value
        end
        Wait(1)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, runTime, flags, 0, true, true, true)
    Wait(10) -- Wait a bit for the animation to start, then check if it exists
    local currentTime = GetAnimDuration(animDict, animName)
    if currentTime == 0 then
        animPromise:reject(invoked .. ' :^1  Animation does not exist')
        return animPromise.value
    end

    local fullDuration = currentTime * 1000
    -- If duration is provided and is less than the full duration, use it instead
    local waitTime = duration and math.min(duration, fullDuration) or fullDuration

    Wait(waitTime)
    RemoveAnimDict(animDict)
    animPromise:resolve(currentTime)
    return animPromise.value
end

function QBCore.Functions.LoadModel(model)
    if HasModelLoaded(model) then return end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

function QBCore.Functions.LoadAnimSet(animSet)
    if HasAnimSetLoaded(animSet) then return end
    RequestAnimSet(animSet)
    while not HasAnimSetLoaded(animSet) do
        Wait(0)
    end
end

RegisterNUICallback('getNotifyConfig', function(_, cb)
    cb(QBCore.Config.Notify)
end)

function QBCore.Functions.Notify(text, texttype, length, icon)
    local message = {
        action = 'notify',
        type = texttype or 'primary',
        length = length or 5000,
    }

    if type(text) == 'table' then
        message.text = text.text or 'Placeholder'
        message.caption = text.caption or 'Placeholder'
    else
        message.text = text
    end

    if icon then
        message.icon = icon
    end

    SendNUIMessage(message)
end

function QBCore.Debug(resource, obj, depth)
    TriggerServerEvent('QBCore:DebugSomething', resource, obj, depth)
end

-- Callback Functions --

-- Client Callback
function QBCore.Functions.CreateClientCallback(name, cb)
    QBCore.ClientCallbacks[name] = cb
end

function QBCore.Functions.TriggerClientCallback(name, cb, ...)
    if not QBCore.ClientCallbacks[name] then return end
    QBCore.ClientCallbacks[name](cb, ...)
end

-- Server Callback
function QBCore.Functions.TriggerCallback(name, cb, ...)
    QBCore.ServerCallbacks[name] = cb
    TriggerServerEvent('QBCore:Server:TriggerCallback', name, ...)
end

function QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if GetResourceState('progressbar') ~= 'started' then error('progressbar needs to be started in order for QBCore.Functions.Progressbar to work') end
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish then
                onFinish()
            end
        else
            if onCancel then
                onCancel()
            end
        end
    end)
end

-- Getters

function QBCore.Functions.GetVehicles()
    return GetGamePool('CVehicle')
end

function QBCore.Functions.GetObjects()
    return GetGamePool('CObject')
end

function QBCore.Functions.GetPlayers()
    return GetActivePlayers()
end

function QBCore.Functions.GetPeds(ignoreList)
    local pedPool = GetGamePool('CPed')
    local peds = {}
    local ignoreTable = {}
    ignoreList = ignoreList or {}
    for i = 1, #ignoreList do
        ignoreTable[ignoreList[i]] = true
    end
    for i = 1, #pedPool do
        if not ignoreTable[pedPool[i]] then
            peds[#peds + 1] = pedPool[i]
        end
    end
    return peds
end

function QBCore.Functions.GetClosestPed(coords, ignoreList)
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    ignoreList = ignoreList or {}
    local peds = QBCore.Functions.GetPeds(ignoreList)
    local closestDistance = -1
    local closestPed = -1
    for i = 1, #peds, 1 do
        local pedCoords = GetEntityCoords(peds[i])
        local distance = #(pedCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestPed = peds[i]
            closestDistance = distance
        end
    end
    return closestPed, closestDistance
end

function QBCore.Functions.IsWearingGloves()
    local ped = PlayerPedId()
    local armIndex = GetPedDrawableVariation(ped, 3)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then
        if QBCore.Shared.MaleNoGloves[armIndex] then
            return false
        end
    else
        if QBCore.Shared.FemaleNoGloves[armIndex] then
            return false
        end
    end
    return true
end

function QBCore.Functions.GetClosestPlayer(coords)
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords(coords)
    local closestDistance = -1
    local closestPlayer = -1
    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() and closestPlayers[i] ~= -1 then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

function QBCore.Functions.GetPlayersFromCoords(coords, distance)
    local players = GetActivePlayers()
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    distance = distance or 5
    local closePlayers = {}
    for _, player in ipairs(players) do
        local targetCoords = GetEntityCoords(GetPlayerPed(player))
        local targetdistance = #(targetCoords - coords)
        if targetdistance <= distance then
            closePlayers[#closePlayers + 1] = player
        end
    end
    return closePlayers
end

function QBCore.Functions.GetClosestVehicle(coords)
    local ped = PlayerPedId()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

function QBCore.Functions.GetClosestObject(coords)
    local ped = PlayerPedId()
    local objects = GetGamePool('CObject')
    local closestDistance = -1
    local closestObject = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #objects, 1 do
        local objectCoords = GetEntityCoords(objects[i])
        local distance = #(objectCoords - coords)
        if closestDistance == -1 or closestDistance > distance then
            closestObject = objects[i]
            closestDistance = distance
        end
    end
    return closestObject, closestDistance
end

function QBCore.Functions.GetClosestBone(entity, list)
    local playerCoords, bone, coords, distance = GetEntityCoords(PlayerPedId())
    for _, element in pairs(list) do
        local boneCoords = GetWorldPositionOfEntityBone(entity, element.id or element)
        local boneDistance = #(playerCoords - boneCoords)
        if not coords then
            bone, coords, distance = element, boneCoords, boneDistance
        elseif distance > boneDistance then
            bone, coords, distance = element, boneCoords, boneDistance
        end
    end
    if not bone then
        bone = { id = GetEntityBoneIndexByName(entity, 'bodyshell'), type = 'remains', name = 'bodyshell' }
        coords = GetWorldPositionOfEntityBone(entity, bone.id)
        distance = #(coords - playerCoords)
    end
    return bone, coords, distance
end

function QBCore.Functions.GetBoneDistance(entity, boneType, boneIndex)
    local bone
    if boneType == 1 then
        bone = GetPedBoneIndex(entity, boneIndex)
    else
        bone = GetEntityBoneIndexByName(entity, boneIndex)
    end
    local boneCoords = GetWorldPositionOfEntityBone(entity, bone)
    local playerCoords = GetEntityCoords(PlayerPedId())
    return #(boneCoords - playerCoords)
end

function QBCore.Functions.AttachProp(ped, model, boneId, x, y, z, xR, yR, zR, vertex)
    local modelHash = type(model) == 'string' and joaat(model) or model
    local bone = GetPedBoneIndex(ped, boneId)
    QBCore.Functions.LoadModel(modelHash)
    local prop = CreateObject(modelHash, 1.0, 1.0, 1.0, 1, 1, 0)
    AttachEntityToEntity(prop, ped, bone, x, y, z, xR, yR, zR, 1, 1, 0, 1, not vertex and 2 or 0, 1)
    SetModelAsNoLongerNeeded(modelHash)
    return prop
end

-- Vehicle

function QBCore.Functions.SpawnVehicle(model, cb, coords, isnetworked, teleportInto)
    local ped = PlayerPedId()
    model = type(model) == 'string' and joaat(model) or model
    if not IsModelInCdimage(model) then return end
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    isnetworked = isnetworked == nil or isnetworked
    QBCore.Functions.LoadModel(model)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, isnetworked, false)
    local netid = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleFuelLevel(veh, 100.0)
    SetModelAsNoLongerNeeded(model)
    if teleportInto then TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1) end
    if cb then cb(veh) end
end

function QBCore.Functions.DeleteVehicle(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end

function QBCore.Functions.GetPlate(vehicle)
    if vehicle == 0 then return end
    return QBCore.Shared.Trim(GetVehicleNumberPlateText(vehicle))
end

function QBCore.Functions.GetVehicleLabel(vehicle)
    if vehicle == nil or vehicle == 0 then return end
    return GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
end

function QBCore.Functions.SpawnClear(coords, radius)
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    local vehicles = GetGamePool('CVehicle')
    local closeVeh = {}
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)
        if distance <= radius then
            closeVeh[#closeVeh + 1] = vehicles[i]
        end
    end
    if #closeVeh > 0 then return false end
    return true
end

QBCore.Functions.GetVehicleProperties = function(vehicle)
	if DoesEntityExist(vehicle) then		
		local paintType1, whoCaresColor1, whoCaresPearlescentColor1 = GetVehicleModColor_1(vehicle)
		local paintType2, whoCaresColor2, whoCaresPearlescentColor2 = GetVehicleModColor_2(vehicle)
		local color1 = {}
		local color2 = {}
		color1[1], color1[2], color1[3] = GetVehicleCustomPrimaryColour(vehicle)
		color2[1], color2[2], color2[3] = GetVehicleCustomSecondaryColour(vehicle)
		
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		return {
			model             = GetEntityModel(vehicle),

			plate             = Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),
			
			bodyHealth        = Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = Round(GetVehicleEngineHealth(vehicle), 1),
			tankHealth        = Round(GetVehiclePetrolTankHealth(vehicle), 1),

			fuelLevel         = Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = Round(GetVehicleDirtLevel(vehicle), 1),
			
			color1            = color1,
			color2            = color2,
			paintType         = {paintType1, paintType2},

			pearlescentColor  = pearlescentColor,
			interiorColor     = GetVehicleInteriorColor(vehicle),
			dashboardColor    = GetVehicleDashboardColour(vehicle),
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),
			modCustomTiresF   = GetVehicleModVariation(vehicle, 23),
			modCustomTiresR   = GetVehicleModVariation(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleMod(vehicle, 48),
		}
	else
		return
	end
end

QBCore.Functions.SetVehicleProperties = function(vehicle, props)
	if DoesEntityExist(vehicle) then
		SetVehicleModKit(vehicle, 0)

		if props.plate ~= nil then
			SetVehicleNumberPlateText(vehicle, props.plate)
		end

		if props.plateIndex ~= nil then
			SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
		end

		if props.bodyHealth ~= nil then
			SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
		end

		if props.engineHealth ~= nil then
			SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
		end

		if props.fuelLevel ~= nil then
			SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
		end

		if props.dirtLevel ~= nil then
			SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
		end

		if props.paintType ~= nil then
			SetVehicleModColor_1(vehicle, props.paintType[1], 0, 0)
			SetVehicleModColor_2(vehicle, props.paintType[2], 0, 0)
		end

		if props.color1 ~= nil then
			ClearVehicleCustomPrimaryColour(vehicle)
			SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
		end

		if props.color2 ~= nil then
			ClearVehicleCustomSecondaryColour(vehicle)
			SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
		end

		if props.interiorColor ~= nil then
			SetVehicleInteriorColor(vehicle, props.interiorColor)
		end

		if props.dashboardColor ~= nil then
			SetVehicleDashboardColour(vehicle, props.dashboardColor)
		end

		if props.pearlescentColor ~= nil then
			local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
			SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
		end

		if props.wheelColor ~= nil then
			local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
			SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
		end

		if props.wheels ~= nil then
			SetVehicleWheelType(vehicle, props.wheels)
		end

		if props.windowTint ~= nil then
			SetVehicleWindowTint(vehicle, props.windowTint)
		end

		if props.neonEnabled ~= nil then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras ~= nil then
			for id,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(id), 0)
				else
					SetVehicleExtra(vehicle, tonumber(id), 1)
				end
			end
		end

		if props.neonColor ~= nil then
			SetVehicleNeonLightsColour(vehicle, props.neonColor["1"], props.neonColor["2"], props.neonColor["3"])
		end

		if props.modSmokeEnabled ~= nil then
			ToggleVehicleMod(vehicle, 20, true)
		end

		if props.tyreSmokeColor ~= nil then
			SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor["1"], props.tyreSmokeColor["2"], props.tyreSmokeColor["3"])
		end

		if props.modSpoilers ~= nil then
			SetVehicleMod(vehicle, 0, props.modSpoilers, false)
		end

		if props.modFrontBumper ~= nil then
			SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
		end

		if props.modRearBumper ~= nil then
			SetVehicleMod(vehicle, 2, props.modRearBumper, false)
		end

		if props.modSideSkirt ~= nil then
			SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
		end

		if props.modExhaust ~= nil then
			SetVehicleMod(vehicle, 4, props.modExhaust, false)
		end

		if props.modFrame ~= nil then
			SetVehicleMod(vehicle, 5, props.modFrame, false)
		end

		if props.modGrille ~= nil then
			SetVehicleMod(vehicle, 6, props.modGrille, false)
		end

		if props.modHood ~= nil then
			SetVehicleMod(vehicle, 7, props.modHood, false)
		end

		if props.modFender ~= nil then
			SetVehicleMod(vehicle, 8, props.modFender, false)
		end

		if props.modRightFender ~= nil then
			SetVehicleMod(vehicle, 9, props.modRightFender, false)
		end

		if props.modRoof ~= nil then
			SetVehicleMod(vehicle, 10, props.modRoof, false)
		end

		if props.modEngine ~= nil then
			SetVehicleMod(vehicle, 11, props.modEngine, false)
		end

		if props.modBrakes ~= nil then
			SetVehicleMod(vehicle, 12, props.modBrakes, false)
		end

		if props.modTransmission ~= nil then
			SetVehicleMod(vehicle, 13, props.modTransmission, false)
		end

		if props.modHorns ~= nil then
			SetVehicleMod(vehicle, 14, props.modHorns, false)
		end

		if props.modSuspension ~= nil then
			SetVehicleMod(vehicle, 15, props.modSuspension, false)
		end

		if props.modArmor ~= nil then
			SetVehicleMod(vehicle, 16, props.modArmor, false)
		end

		if props.modTurbo ~= nil then
			ToggleVehicleMod(vehicle,  18, props.modTurbo)
		end

		if props.modXenon ~= nil then
			ToggleVehicleMod(vehicle,  22, props.modXenon)
		end

		if props.xenonColor ~= nil then
			SetVehicleXenonLightsColor(vehicle, props.xenonColor)
		end

		if props.modFrontWheels ~= nil then
			SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
		end

		if props.modBackWheels ~= nil then
			SetVehicleMod(vehicle, 24, props.modBackWheels, false)
		end

		if props.modCustomTiresF ~= nil then
			SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
		end

		if props.modCustomTiresR ~= nil then
			SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
		end
    
		if props.modPlateHolder ~= nil then
			SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
		end

		if props.modVanityPlate ~= nil then
			SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
		end

		if props.modTrimA ~= nil then
			SetVehicleMod(vehicle, 27, props.modTrimA, false)
		end

		if props.modOrnaments ~= nil then
			SetVehicleMod(vehicle, 28, props.modOrnaments, false)
		end

		if props.modDashboard ~= nil then
			SetVehicleMod(vehicle, 29, props.modDashboard, false)
		end

		if props.modDial ~= nil then
			SetVehicleMod(vehicle, 30, props.modDial, false)
		end

		if props.modDoorSpeaker ~= nil then
			SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
		end

		if props.modSeats ~= nil then
			SetVehicleMod(vehicle, 32, props.modSeats, false)
		end

		if props.modSteeringWheel ~= nil then
			SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
		end

		if props.modShifterLeavers ~= nil then
			SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
		end

		if props.modAPlate ~= nil then
			SetVehicleMod(vehicle, 35, props.modAPlate, false)
		end

		if props.modSpeakers ~= nil then
			SetVehicleMod(vehicle, 36, props.modSpeakers, false)
		end

		if props.modTrunk ~= nil then
			SetVehicleMod(vehicle, 37, props.modTrunk, false)
		end

		if props.modHydrolic ~= nil then
			SetVehicleMod(vehicle, 38, props.modHydrolic, false)
		end

		if props.modEngineBlock ~= nil then
			SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
		end

		if props.modAirFilter ~= nil then
			SetVehicleMod(vehicle, 40, props.modAirFilter, false)
		end

		if props.modStruts ~= nil then
			SetVehicleMod(vehicle, 41, props.modStruts, false)
		end

		if props.modArchCover ~= nil then
			SetVehicleMod(vehicle, 42, props.modArchCover, false)
		end

		if props.modAerials ~= nil then
			SetVehicleMod(vehicle, 43, props.modAerials, false)
		end

		if props.modTrimB ~= nil then
			SetVehicleMod(vehicle, 44, props.modTrimB, false)
		end

		if props.modTank ~= nil then
			SetVehicleMod(vehicle, 45, props.modTank, false)
		end

		if props.modWindows ~= nil then
			SetVehicleMod(vehicle, 46, props.modWindows, false)
		end

		if props.modLivery ~= nil then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end

function QBCore.Functions.LoadParticleDictionary(dictionary)
    if HasNamedPtfxAssetLoaded(dictionary) then return end
    RequestNamedPtfxAsset(dictionary)
    while not HasNamedPtfxAssetLoaded(dictionary) do
        Wait(0)
    end
end

function QBCore.Functions.StartParticleAtCoord(dict, ptName, looped, coords, rot, scale, alpha, color, duration)
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    QBCore.Functions.LoadParticleDictionary(dict)
    UseParticleFxAssetNextCall(dict)
    SetPtfxAssetNextCall(dict)
    local particleHandle
    if looped then
        particleHandle = StartParticleFxLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
        if color then
            SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false)
        end
        SetParticleFxLoopedAlpha(particleHandle, alpha or 10.0)
        if duration then
            Wait(duration)
            StopParticleFxLooped(particleHandle, 0)
        end
    else
        SetParticleFxNonLoopedAlpha(alpha or 10.0)
        if color then
            SetParticleFxNonLoopedColour(color.r, color.g, color.b)
        end
        StartParticleFxNonLoopedAtCoord(ptName, coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, scale or 1.0)
    end
    return particleHandle
end

function QBCore.Functions.StartParticleOnEntity(dict, ptName, looped, entity, bone, offset, rot, scale, alpha, color, evolution, duration)
    QBCore.Functions.LoadParticleDictionary(dict)
    UseParticleFxAssetNextCall(dict)
    local particleHandle, boneID
    if bone and GetEntityType(entity) == 1 then
        boneID = GetPedBoneIndex(entity, bone)
    elseif bone then
        boneID = GetEntityBoneIndexByName(entity, bone)
    end
    if looped then
        if bone then
            particleHandle = StartParticleFxLoopedOnEntityBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
        else
            particleHandle = StartParticleFxLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
        end
        if evolution then
            SetParticleFxLoopedEvolution(particleHandle, evolution.name, evolution.amount, false)
        end
        if color then
            SetParticleFxLoopedColour(particleHandle, color.r, color.g, color.b, false)
        end
        SetParticleFxLoopedAlpha(particleHandle, alpha)
        if duration then
            Wait(duration)
            StopParticleFxLooped(particleHandle, 0)
        end
    else
        SetParticleFxNonLoopedAlpha(alpha or 10.0)
        if color then
            SetParticleFxNonLoopedColour(color.r, color.g, color.b)
        end
        if bone then
            StartParticleFxNonLoopedOnPedBone(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, boneID, scale)
        else
            StartParticleFxNonLoopedOnEntity(ptName, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale)
        end
    end
    return particleHandle
end

function QBCore.Functions.GetStreetNametAtCoords(coords)
    local streetname1, streetname2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    return { main = GetStreetNameFromHashKey(streetname1), cross = GetStreetNameFromHashKey(streetname2) }
end

function QBCore.Functions.GetZoneAtCoords(coords)
    return GetLabelText(GetNameOfZone(coords))
end

function QBCore.Functions.GetCardinalDirection(entity)
    entity = DoesEntityExist(entity) and entity or PlayerPedId()
    if DoesEntityExist(entity) then
        local heading = GetEntityHeading(entity)
        if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
            return 'North'
        elseif (heading >= 45 and heading < 135) then
            return 'West'
        elseif (heading >= 135 and heading < 225) then
            return 'South'
        elseif (heading >= 225 and heading < 315) then
            return 'East'
        end
    else
        return 'Cardinal Direction Error'
    end
end

function QBCore.Functions.GetCurrentTime()
    local obj = {}
    obj.min = GetClockMinutes()
    obj.hour = GetClockHours()

    if obj.hour <= 12 then
        obj.ampm = 'AM'
    elseif obj.hour >= 13 then
        obj.ampm = 'PM'
        obj.formattedHour = obj.hour - 12
    end

    if obj.min <= 9 then
        obj.formattedMin = '0' .. obj.min
    end

    return obj
end

function QBCore.Functions.GetGroundZCoord(coords)
    if not coords then return end

    local retval, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
    if retval then
        return vector3(coords.x, coords.y, groundZ)
    else
        print('Couldn\'t find Ground Z Coordinates given 3D Coordinates')
        print(coords)
        return coords
    end
end

function QBCore.Functions.GetGroundHash(entity)
    local coords = GetEntityCoords(entity)
    local num = StartShapeTestCapsule(coords.x, coords.y, coords.z + 4, coords.x, coords.y, coords.z - 2.0, 1, 1, entity, 7)
    local retval, success, endCoords, surfaceNormal, materialHash, entityHit = GetShapeTestResultEx(num)
    return materialHash, entityHit, surfaceNormal, endCoords, success, retval
end
