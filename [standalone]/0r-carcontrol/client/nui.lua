RegisterNUICallback("exitMenu", function(data, cb) 
    TriggerEvent("0r-carcontrol:Client:HideMenu")
end)

RegisterNUICallback("toggleInteriorLight", function() 
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local lightState = not IsVehicleInteriorLightOn(vehicle)

    SetVehicleInteriorlight(vehicle, lightState)
end)

RegisterNUICallback("toggleHeadLight", function() 
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local _, ligthsOn, highBeamsOn = GetVehicleLightsState(vehicle)
    local lightState = nil

    if ligthsOn == 1 or highBeamsOn == 1 then
        SetVehicleLights(vehicle, 1)
    else
        SetVehicleLights(vehicle, 3)
    end
end)

RegisterNUICallback("toggleEngine", function() 
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local engineState = not GetIsVehicleEngineRunning(vehicle)

    SetVehicleEngineOn(vehicle, engineState, false, true)
end)

RegisterNUICallback("toggleNeonLight", function() 
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local neonUpgrade = GetVehicleMod(vehicle, 22)

    if neonUpgrade ~= -1 then 
        for i = 0, 3, 1 do
            local neonState = IsVehicleNeonLightEnabled(vehicle, i)

            if neonState == 1 then 
                SetVehicleNeonLightEnabled(vehicle, i, false)
            else
                SetVehicleNeonLightEnabled(vehicle, i, true)
            end
        end
    end
end)

RegisterNUICallback("changeSeat", function() 
    ChangePedSeat(PlayerPedId())
end)

RegisterNUICallback("toggleDoor", function(index) 
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if GetVehicleDoorAngleRatio(vehicle, index) > 0.1 then 
        SetVehicleDoorShut(vehicle, index, false)
    else
        SetVehicleDoorOpen(vehicle, index, false, false)
    end
end)

RegisterNUICallback("lockCar", function() 
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle then 
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then 
            TriggerServerEvent("0r-carcontrol:Server:ToggleVehicleLock")     
        end
    end
end)

local playing
RegisterNUICallback("controlMusic", function(data) 
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed)
    local plate = GetVehicleNumberPlateText(vehicle)
    local musicId = "musicId_"..plate
    local pos = GetEntityCoords(vehicle)
    table.insert(MusicDatas, {
        vehicle = vehicle,
        musicId = musicId
    })

    if data.action == "playMusic" then
        playing = true
        TriggerServerEvent("0r-carcontrol:Server:ControlCarMedia", "play", musicId, {position = pos, link = data.musicLink})
        Wait(500)
        SendNUIMessage({
            action = "playMusic",
            playerState = "playing",
            maxDuration = exports.xsound:getMaxDuration(musicId),
            timestamp = exports.xsound:getTimeStamp(musicId),
            link = exports.xsound:getLink(musicId)
        })
    elseif data.action == "pauseMusic" then
        playing = false
        TriggerServerEvent("0r-carcontrol:Server:ControlCarMedia", "pause", musicId)
    elseif data.action == "resumeMusic" then
        playing = true
        TriggerServerEvent("0r-carcontrol:Server:ControlCarMedia", "resume", musicId)
    elseif data.action == "changeVolume" then
        TriggerServerEvent("0r-carcontrol:Server:ControlCarMedia", "changeVolume", musicId, {volume = data.volume})
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if playing then
            sleep = 1
            for k, v in pairs(MusicDatas) do
                local musicId = v.musicId
                local vehicle = v.vehicle
                local pos

                if exports.xsound:soundExists(musicId) then
                    if not exports.xsound:isDynamic(musicId) then
                        exports.xsound:setSoundDynamic(musicId, true)
                    end
    
                    if exports.xsound:isPlaying(musicId) then
                        pos = GetEntityCoords(vehicle)
                        
                        exports.xsound:Position(musicId, pos)
                        TriggerServerEvent("0r-carcontrol:Server:ControlCarMedia", "position", musicId, {position = pos})
                        Wait(100)
                        
                        if ShowingMenu then
                            SendNUIMessage({
                                action = "updatePercentage",
                                timestamp = exports.xsound:getTimeStamp(musicId),
                                maxDuration = exports.xsound:getMaxDuration(musicId),
                            })
                        end
                    end
                end
            end  
        end
        Wait(sleep)
    end
end)

RegisterNUICallback("showParkCam", function() 
    TriggerEvent("0r-carcontrol:Client:ShowParkCam")
end)