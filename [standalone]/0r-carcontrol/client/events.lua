Core, FW = GetCore()

TSC = nil

if FW == 'qb' or FW == 'oldqb' then
    TSC = Core.Functions.TriggerCallback
else
    TSC = Core.TriggerServerCallback
end

ShowingMenu = false
ParkCam = nil
MusicDatas = {}

RegisterNetEvent("0r-carcontrol:Client:ShowMenu", function() 
    local vehicle = GetPedVehicleData(PlayerPedId())

    if vehicle then 
        TSC("0r-carcontrol:Server:GetMileage", function(mileage) 
            vehicle.mileage = mileage

            SetNuiFocus(true, true)

            SendNUIMessage({
                action = "show",
                vehicle = vehicle
            })

            ShowingMenu = true
        end, { plate = GetVehicleNumberPlateText(vehicle.vehicle) })
    end
end)

RegisterNetEvent("0r-carcontrol:Client:HideMenu", function() 
    SendNUIMessage({
        action = "hide",
    })

    SetNuiFocus(false, false)

    ShowingMenu = false
end)

RegisterNetEvent("0r-carcontrol:Client:ControlCarMedia", function(_type, musicId, data) 
    if _type == "position" then
        if exports.xsound:soundExists(musicId) then
            exports.xsound:Position(musicId, data.position)
        end
    end

    if _type == "play" then
        exports.xsound:PlayUrlPos(musicId, data.link, 1, data.position)
        exports.xsound:Distance(musicId, 20)
        exports.xsound:setVolume(musicId, 0.5)

        exports.xsound:onPlayEnd(musicId, function()
            SendNUIMessage({
                action = "endMusic"
            })
        end)
    end

    if _type == "pause" then
        exports.xsound:Pause(musicId)

        SendNUIMessage({
            action = "pauseMusic",
            playerState = "paused",
            maxDuration = exports.xsound:getMaxDuration(musicId),
            timestamp = exports.xsound:getTimeStamp(musicId)
        })
    end

    if _type == "resume" then
        exports.xsound:Resume(musicId)

        SendNUIMessage({
            action = "resumeMusic",
            playerState = "playing",
            maxDuration = exports.xsound:getMaxDuration(musicId),
            timestamp = exports.xsound:getTimeStamp(musicId)
        })
    end

    if _type == "changeVolume" then
        local volume = tonumber(data.volume)
        volume = volume / 100
        exports.xsound:setVolume(musicId, volume)
    end
end)

RegisterNetEvent("0r-carcontrol:Client:ShowParkCam", function() 
    if ParkCam then 
        DisableParkCam()
    else
        EnableParkCam()
    end

    TriggerEvent("0r-carcontrol:Client:HideMenu")
end)