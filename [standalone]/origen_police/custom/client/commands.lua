RegisterCommand("qrr", function()
    local PlayerData = FW_GetPlayerData(true)
    local userData = CanOpenTablet(PlayerData.job.name)
    if userData[1] then
        UseCommand('me', Config.Translations['QRRME'])
        TriggerServerEvent("SendAlert:police", {
            coords = GetEntityCoords(PlayerPedId()),
            title = "QRR",
            job = userData[2],-- index 2 correspond to the player category
            message = Config.Translations['Agentatrisk'],
            metadata = {
                name = PlayerData.job.grade.name .. " " .. PlayerData.charinfo.lastname .. " (" .. (PlayerData.metadata.police_badge or "0000") .. ")",
                unit = unit ~= "none" and unit or nil
            }
        })
        TriggerServerEvent("origen_police:server:updateref", {
            color = 1
        })
    end
end)

RegisterCommand("10-20", function()
    local PlayerData = FW_GetPlayerData(false)
    if CanOpenTablet(PlayerData.job.name)[1] then
        UseCommand('me', Config.Translations['10-20ME'])
        TriggerServerEvent("SendAlert:police", {
            coords = GetEntityCoords(PlayerPedId()),
            title = "10-20",
            metadata = {
                name = PlayerData.job.grade.name .. " " .. PlayerData.charinfo.lastname .. " (" .. (PlayerData.metadata.police_badge or "0000") .. ")",
                unit = unit ~= "none" and unit or nil
            }
        })
    end
end)

function UseCommand(type, message)
    if type == 'me' then 
        ExecuteCommand("me "..message)
    elseif type == 'do' then
        ExecuteCommand("do "..message)
    elseif type == 'rpol' then
        ExecuteCommand("rpol "..message)
    end
end

RegisterNetEvent("origen_police:client:onPlayerCall911", function(message)
    -- This is for the 911 call
end)

RegisterNetEvent("origen_police:client:onPlayerCall911ems", function(message)
    -- This is for the 911ems call
end)