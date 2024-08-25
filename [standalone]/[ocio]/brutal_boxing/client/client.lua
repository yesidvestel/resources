-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks
-- discord.gg/212leaks


InMenu = false
ShowText = false
InBoxing = false
CurrentRound = 0
Joined = false
InBet = false
InParty = false
CurrentArea = nil
CurrentAreaTable = {}
Gloves = {}

Citizen.CreateThread(function()

    while true do
        sleep = 2000
        local nearMarker = false
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if not InMenu then
            for k,v in pairs(Config.Areas) do
                if #(playerCoords - v.Start) < 10.0 then
                    sleep = 1
                    DrawMarker(Config.Marker.marker, v.Start, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.size[1], Config.Marker.size[2], Config.Marker.size[3], Config.Marker.rgb[1], Config.Marker.rgb[2], Config.Marker.rgb[3], 255, Config.Marker.bobUpAndDown, true, 2, Config.Marker.rotate, nil, false)
                    
                    if #(playerCoords - v.Start) < 2.0 then
                        inMarker = true
                        nearMarker = true
                        if not ShowText then
                            TextUIFunction('open', Config.MenuOpen[1])
                            ShowText = true
                        end
                        
                        if IsControlJustReleased(0, Config.MenuOpen[2]) then
                            CurrentArea = k
                            OpenMenuUtil()

                            TSCB('brutal_boxing:server:GetAreaTable', function(data)
                                CurrentAreaTable = data
                                SendNUIMessage({action = "OpenBoxingMenu", id = GetPlayerServerId(PlayerId()), label = CurrentArea, areatable = CurrentAreaTable})
                            end, CurrentArea)
                        end
                    end
                end
            end
        end

        if (inMarker and not nearMarker) or (InMenu and inMarker) then
            inMarker = false
            ShowText = false
            TextUIFunction('hide')
        end

        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('brutal_boxing:client:MenuOpenAgain')
AddEventHandler('brutal_boxing:client:MenuOpenAgain', function(NewAreaTable, index)
    if CurrentArea == index and not InParty then
        CurrentAreaTable = NewAreaTable
        SendNUIMessage({action = "OpenBoxingMenu", id = GetPlayerServerId(PlayerId()), label = CurrentArea, areatable = CurrentAreaTable})
    end
end)

RegisterNetEvent('brutal_boxing:client:SuccessJoin')
AddEventHandler('brutal_boxing:client:SuccessJoin', function()
    Joined = true
end)

RegisterNetEvent('brutal_boxing:client:startbettimer')
AddEventHandler('brutal_boxing:client:startbettimer', function(NewAreaTable, index)
    if CurrentArea == index then
        CurrentAreaTable = NewAreaTable
        InBet = true
        SendNUIMessage({action = "OpenBoxingMenu", id = GetPlayerServerId(PlayerId()), label = CurrentArea, areatable = CurrentAreaTable})
    end
end)

RegisterNetEvent('brutal_boxing:client:start')
AddEventHandler('brutal_boxing:client:start', function(NewAreaTable, place)
    CurrentAreaTable = NewAreaTable
    InParty = true
    Joined = false
    InBoxing = false
    InBet = false

    if InMenu then
        SendNUIMessage({action = "Close"})
    end

    for k,v in pairs(Gloves) do DeleteObject(v) end

    local coords
    if place == 1 then
        coords = Config.Areas[CurrentArea].Player1
    elseif place == 2 then
        coords = Config.Areas[CurrentArea].Player2
    end

    local ped = GetPlayerPed(-1)
    SetEntityCoords(ped, coords[1], coords[2], coords[3]-1, 1, 0, 0, 1)
    SetEntityHeading(ped, coords[4])
    FreezeEntityPosition(ped, true)
    local maxhp = GetEntityMaxHealth(ped)
    SetEntityHealth(ped, maxhp)
    AddArmourToPed(playerPed, 0)
    SetPedArmour(playerPed, 0)

    if CurrentAreaTable.gloves then
        local hash = GetHashKey('prop_boxing_glove_01')
        while not HasModelLoaded(hash) do RequestModel(hash) Citizen.Wait(0) end
        local gloveA = CreateObject(hash, coords.x,coords.y,coords.z + 0.50, true,false,false)
        local gloveB = CreateObject(hash, coords.x,coords.y,coords.z + 0.50, true,false,false)
        table.insert(Gloves,gloveA)
        table.insert(Gloves,gloveB)
        SetModelAsNoLongerNeeded(hash)
        FreezeEntityPosition(gloveA,false)
        SetEntityCollision(gloveA,false,true)
        ActivatePhysics(gloveA)
        FreezeEntityPosition(gloveB,false)
        SetEntityCollision(gloveB,false,true)
        ActivatePhysics(gloveB)
        AttachEntityToEntity(gloveA, ped, GetPedBoneIndex(ped, 0xEE4F), 0.05, 0.00,  0.04,     00.0, 90.0, -90.0, true, true, false, true, 1, true) -- object is attached to right hand 
        AttachEntityToEntity(gloveB, ped, GetPedBoneIndex(ped, 0xAB22), 0.05, 0.00, -0.04,     00.0, 90.0,  90.0, true, true, false, true, 1, true) -- object is attached to right hand 
    end

    SetGameplayCamRelativeHeading(GetEntityHeading(ped)-coords[4])
    SetGameplayCamRelativePitch(90, 1.0)

    SendNUIMessage({action = "Countback"})
    local CountBack = true
    Citizen.CreateThread(function()
        while CountBack do
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
            Wait(1)
        end
    end)

    Citizen.Wait(1000*3)
    CountBack = false

    CurrentRound += 1
    SendNUIMessage({
        action = "OpenBoxingHud", 
        time = Config.Areas[CurrentArea].Time, 
        round = CurrentRound, 
        player1_name = CurrentAreaTable.player1.nickname, 
        player2_name = CurrentAreaTable.player2.nickname, 
        player1_points = CurrentAreaTable.player1.points,
        player2_points = CurrentAreaTable.player2.points,
    })
    FreezeEntityPosition(ped, false)
    
    InBoxing = true

    if CurrentAreaTable.gloves and Config.DemageModifier.Use then
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), Config.DemageModifier.Glove)
    elseif Config.DemageModifier.Use then
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), Config.DemageModifier.Basic)
    end

    Citizen.CreateThread(function()
        while InBoxing do
            for k,v in pairs(Config.DisableControls) do
                DisableControlAction(0,v,true)
                DisableControlAction(1,v,true)
                DisableControlAction(2,v,true)
            end

            SetPlayerHealthRechargeMultiplier(PlayerId(), 0)

            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)

            Wait(1)
        end
    end)

    Citizen.CreateThread(function()
        local timer = 0
        while InBoxing do

            AddArmourToPed(PlayerPedId(), 0)
            SetPedArmour(PlayerPedId(), 0)

            local player1 = GetPlayerPed(GetPlayerFromServerId(CurrentAreaTable.player1.id))
            local player1_health = GetEntityHealth(player1)
            if GetEntityMaxHealth(player1) == 200 then
                player1_health -= 100
            else
                player1_health -= 75
            end

            local player2 = GetPlayerPed(GetPlayerFromServerId(CurrentAreaTable.player2.id))
            local player2_health = GetEntityHealth(player2)
            if GetEntityMaxHealth(player2) == 200 then
                player2_health -= 100
            else
                player2_health -= 75
            end

            SendNUIMessage({action = "BoxingStats", player1_health = player1_health, player2_health = player2_health})

            if place == 1 then
                if player1_health < 25 or player2_health < 25 then
                    if player1_health > player2_health then
                        TriggerServerEvent('brutal_boxing:server:roundover', CurrentArea, 1)
                    elseif player2_health > player1_health then
                        TriggerServerEvent('brutal_boxing:server:roundover', CurrentArea, 2)
                    else
                        TriggerServerEvent('brutal_boxing:server:roundover', CurrentArea, false)
                    end
                end

                if timer >= Config.Areas[CurrentArea].Time then
                    if player1_health > player2_health then
                        TriggerServerEvent('brutal_boxing:server:roundover', CurrentArea, 1)
                    elseif player2_health > player1_health then
                        TriggerServerEvent('brutal_boxing:server:roundover', CurrentArea, 2)
                    else
                        TriggerServerEvent('brutal_boxing:server:roundover', CurrentArea, false)
                    end
                end
            end
            
            timer += 1
            Citizen.Wait(1000)
        end
    end)
end)

RegisterNetEvent('brutal_boxing:client:finish')
AddEventHandler('brutal_boxing:client:finish', function(Place, Table, Winner)
    SendNUIMessage({action = "Close"})

    if Table.betsetting and Place == 1 then
        if Winner ~= false  then
            TriggerServerEvent('brutal_boxing:server:endofbet', Table, Winner)
        else
            TriggerServerEvent('brutal_boxing:server:endofbet', Table, Winner)
        end
    end

    SendNUIMessage({action = "EndNotify", table = Table, winner = Winner})

    if Config.DemageModifier.Use then
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), Config.DemageModifier.Basic)
    end

    local ped = GetPlayerPed(-1)
    SetEntityCoords(ped, Config.Areas[CurrentArea].Start, 1, 0, 0, 1)
    ClearPedTasksImmediately(ped)
    for k,v in pairs(Gloves) do DeleteObject(v) end
    InBoxing = false
    InParty = false
    CurrentArea = nil
    CurrentRound = 0
    CurrentAreaTable = {}
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        for k,v in pairs(Gloves) do DeleteObject(v) end
    end
end)

RegisterNetEvent(LoadedEvent)
AddEventHandler(LoadedEvent, function()
    Citizen.Wait(5000)
    local ped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(ped)
    local object = GetClosestObjectOfType(playerCoords, 3.0, GetHashKey('prop_boxing_glove_01'), false, false, false)

    if DoesEntityExist(object) then
        DetachEntity(object, true, false)
        DeleteEntity(object)

        local object2 = GetClosestObjectOfType(playerCoords, 3.0, GetHashKey('prop_boxing_glove_01'), false, false, false)
        if DoesEntityExist(object2) then
            DetachEntity(object2, true, false)
            DeleteEntity(object2)
        end
    end
end)

-----------------------------------------------------------
--------------------| basic functions |--------------------
-----------------------------------------------------------

function OpenMenuUtil()
    InMenu = true
    SetNuiFocus(true, true)

    Citizen.CreateThread(function()
        while InMenu do
            N_0xf4f2c0d4ee209e20() -- it's disable the AFK camera zoom
            Citizen.Wait(15000)
        end 
    end)

    DisplayRadar(false)
end

RegisterNetEvent('brutal_boxing:client:SendNotify')
AddEventHandler('brutal_boxing:client:SendNotify', function(title, text, time, type)
	notification(title, text, time, type)
end)

function SendNotify(Number)
    notification(Config.Notify[Number][1], Config.Notify[Number][2], Config.Notify[Number][3], Config.Notify[Number][4])
end

function isBoxing()
    return InBoxing
end

-----------------------------------------------------------
-----------------| NOT RENAME THE SCRIPT |-----------------
-----------------------------------------------------------

Citizen.CreateThread(function()
    Citizen.Wait(1000*30)
	if GetCurrentResourceName() ~= 'brutal_boxing' then
		while true do
			Citizen.Wait(1)
			print("Please don't rename the script! Please rename it back to 'brutal_boxing'")
		end
	end
end)