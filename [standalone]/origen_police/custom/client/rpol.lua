function Calls(id)
    if id == "10.8" then
        UseCommand('rpol', Config.Translations["10.8"])
    elseif id == "10.10" then
        UseCommand('rpol', Config.Translations["10.10"])
    elseif id == "Cod 7" then
        UseCommand('rpol', Config.Translations["Cod 7"])
    elseif id == "254-V" then
        local fplate, fmodel = GetRadarVehicle()

        if fplate then
            local text = Config.Translations["254-V"]:format(fmodel, fplate, GetStreetName(GetEntityCoords(PlayerPedId())))
            ExecuteCommand('rpol ' .. text)
        end
    elseif id == "487-V" then
        local fplate, fmodel = GetRadarVehicle()

        if fplate then
            local text = Config.Translations["487-V"]:format(fmodel, fplate)
            ExecuteCommand('rpol ' .. text)
        end
    elseif id == "Cod 2" then
        UseCommand('rpol', Config.Translations["Cod 2"])
    elseif id == "10.22" then
        UseCommand('rpol', Config.Translations["10.22"])
    elseif id == "6-Adam" then
        UseCommand('rpol', Config.Translations["6-Adam"])
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 or (GetPedInVehicleSeat(vehicle, -1) ~= ped and GetPedInVehicleSeat(vehicle, 0) ~= ped) then
            TriggerServerEvent("origen_police:server:updateref", {
                color = 50
            })
        else
            local players = {}
            for i = -1, 0 do
                local p = GetPedInVehicleSeat(vehicle, i)
                if p ~= 0 then
                    table.insert(players, GetPlayerServerId(NetworkGetPlayerIndexFromPed(p)))
                end
            end
            TriggerServerEvent("origen_police:server:updateref", {
                color = 50
            }, players)
        end
        SendNUIMessage({
            action = "SyncQuick",
            color = 50
        })
    elseif id == "10.98" then
        UseCommand('rpol', Config.Translations["10.98"])
    elseif id == "Veh 488" then
        local fplate, fmodel = GetRadarVehicle()

        if fplate then
            local text = Config.Translations["Veh 488"]:format(GetStreetName(GetEntityCoords(PlayerPedId())), fmodel, fplate)
            ExecuteCommand('rpol ' .. text)
        end
    elseif id == "Veh 487" then
        local fplate, fmodel = GetRadarVehicle()

        if fplate then
            local text = Config.Translations["Veh 487"]:format(GetStreetName(GetEntityCoords(PlayerPedId())), fmodel, fplate)
            ExecuteCommand('rpol ' .. text)
        end
    elseif id == "Veh Alt" then
        local fplate, fmodel = GetRadarVehicle()

        if fplate then
            local text = Config.Translations["Veh Alt"]:format(fmodel, fplate, GetStreetName(GetEntityCoords(PlayerPedId())))
            ExecuteCommand('rpol ' .. text)
        end
    elseif id == "10.6" then
        local fplate, fmodel = GetRadarVehicle()

        if fplate then
            local text = Config.Translations["10.6"]:format(fmodel, fplate, GetStreetName(GetEntityCoords(PlayerPedId())))
            ExecuteCommand('rpol ' .. text)
        end
    elseif id == "10-20" then
        local PlayerData = FW_GetPlayerData(true)
        UseCommand('me', Config.Translations["10-20ME"])
        TriggerServerEvent("SendAlert:police", {
            coords = GetEntityCoords(PlayerPedId()),
            title = "10-20",
            metadata = {
                name = PlayerData.job.grade.name .. " " .. PlayerData.charinfo.lastname .. " (" .. (PlayerData.metadata.police_badge or "0000") .. ")",
                unit = unit ~= "none" and unit or nil
            }
        })
    elseif id == "QRR" then
        local PlayerData = FW_GetPlayerData(true)
        UseCommand('me', Config.Translations["QRRME"])
        TriggerServerEvent("SendAlert:police", {
            coords = GetEntityCoords(PlayerPedId()),
            title = "QRR",
            message = Config.Translations["Agentatrisk"],
            metadata = {
                name = PlayerData.job.grade.name .. " " .. PlayerData.charinfo.lastname .. " (" .. (PlayerData.metadata.police_badge or "0000") .. ")",
                unit = unit ~= "none" and unit or nil
            }
        })
        TriggerServerEvent("origen_police:server:updateref", {
            color = 1
        })
    end
end

RegisterCommand("rpol", function(source, args, raw) -- If you don't know what you're doing, don't touch anything.
    local PlayerData = FW_GetPlayerData(true)
    if CanOpenTablet(PlayerData.job.name)[1] and PlayerData.job.onduty then
        local message = table.concat(args, " ")

        -- local department = "lspd"
        -- department = Framework.Shared.Jobs[PlayerData.job.name] and Framework.Shared.Jobs[PlayerData.job.name].grades[tostring(PlayerData.job.grade.level)] and Framework.Shared.Jobs[PlayerData.job.name].grades[tostring(PlayerData.job.grade.level)].type
        local header = "^4"

        local unit = exports["origen_police"]:GetMultiFrec()
        if unit ~= "none" then
            header = header .. "[" .. unit:upper() .. "] "
        end

        header = header ..  PlayerData.job.grade.name .. " " .. PlayerData.charinfo.lastname .. " (" .. (PlayerData.metadata.police_badge or "0000") .. ")"
        TriggerServerEvent("origen_police:server:rpol", PlayerData.job.name, header .. "  ^0" .. message)
    end
end)