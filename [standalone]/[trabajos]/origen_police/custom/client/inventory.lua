function search_player_inv(pID)
    if Config.Inventory == 'ox_inventory' then
        exports.ox_inventory:openNearbyInventory()
    elseif Config.Inventory == 'qb-inventory' or Config.Inventory == "new-qb-inventory" or Config.Inventory == "origen_inventory" or Config.Inventory == 'qs-inventory' or Config.Inventory == "ls-inventory" then
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", pID)
        if Config.Inventory == "new-qb-inventory" then 
            TriggerServerEvent("origen_police:new-qb-inv:OpenPInv", pID)
        end
    elseif Config.Inventory == 'codem-inventory' then
        TriggerEvent('codem-inventory:client:openplayerinventory', pID)
        isClose = true
        CreateThread(function()
            while isClose do
                local targetPed = GetPlayerPed(GetPlayerFromServerId(pID))
                if not targetPed then isClose = false return end
                local targetCoords = GetEntityCoords(targetPed)
                local playerCoords = GetEntityCoords(PlayerPedId())
                if #(targetCoords - playerCoords) >= 4.0 then
                    TriggerServerEvent('origen_police:server:SetInventoryRobStatus', pID, false)
                    isClose = false
                end
                Wait(3)
            end
        end)
    end
end

local animsToSearch = {
    { dict = 'missminuteman_1ig_2', anim = 'handsup_base', flag = 3 },
    { dict = 'mp_arresting', anim = 'idle', flag = 3 },
    { dict = 'random@mugging3', anim = 'handsup_standing_base', flag = 3},
    { dict = 'combat@damage@writhe', anim = 'writhe_loop', flag = 3 },
    { dict = 'veh@low@front_ps@idle_duck', anim = 'sit', flag = 3 },
    { dict = 'move_injured_ground', anim = 'front_loop', flag = 3 },
    { dict = 'dead', anim = 'dead_a', flag = 3 },
}

function CanSearchPlayer(player)
    -- Check if player can search another player
    for k,v in pairs(animsToSearch) do
        if IsEntityPlayingAnim(GetPlayerPed(player), v.dict, v.anim, v.flag) == 1 then
            return true
        end
    end
    if IsEntityDead(GetPlayerPed(player)) then
        return true
    end
    return false
end

function SearchClosestPlayer(playerId)
    local ped = PlayerPedId()
    if Config.Framework == "qbcore" then
        ProgressBar("search_player_inv", "Searching", 3000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@gangops@facility@servers@bodysearch@",
            anim = "player_search",
            flags = 49,
        }, {}, {}, function()
            StopAnimTask(ped, "anim@gangops@facility@servers@bodysearch@", "player_search", 1.0)
            search_player_inv(playerId)
            StartSearchDistance(playerId)
        end)
    elseif Config.Framework == "esx" then
        if GetResourceState("esx_progressbar") ~= "missing" then
            RequestAnimDict("anim@gangops@facility@servers@bodysearch@")
            while not HasAnimDictLoaded("anim@gangops@facility@servers@bodysearch@") do
                Citizen.Wait(0)
            end
            TaskPlayAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, 8.0, -1, 49, 0, 0, 0, 0)
            Citizen.CreateThread(function()
                Wait(3000)
                local success, error = pcall(function()
                    exports["esx_progressbar"]:CancelProgressbar()
                end)
                search_player_inv(playerId)
                StartSearchDistance(playerId)
            end)
            ProgressBar("Searching", 3000, {
                FreezePlayer = false,
            })
        else
            Citizen.Wait(3000)
            search_player_inv(playerId)
            StartSearchDistance(playerId)
        end
    end
end

function GiveVehicleKeys(vehicle)
    -- Your code here
end

function GetPlayerItems(PlayerData)
    if Config.Inventory == "qs-inventory" then 
        return exports['qs-inventory']:getUserInventory() or {}
    elseif Config.Inventory == "ls-inventory" then
        return exports["ls-inventory"]:GetPlayerItems() or {}
    elseif Config.Inventory == "origen_inventory" then
        return exports.origen_inventory:GetInventory() or {}
    elseif Config.Inventory == "ox_inventory" then 
        return exports.ox_inventory:GetPlayerItems() or {}
    elseif Config.Inventory == "codem-inventory" then
        return exports["codem-inventory"]:GetClientPlayerInventory() or {}
    elseif Config.Inventory == 'core_inventory' then 
        local inventory = -1
        Framework.TriggerServerCallback("core_inventory:server:getInventory", function(data)
            inventory = data
        end)
        while inventory == -1 do
            Citizen.Wait(0)
        end
        return inventory or {}
    end

    if not PlayerData then 
        PlayerData = FW_GetPlayerData()
    end
    return PlayerData.items or {}
end

function GetItemFromWeapon(PlayerData, weapon)
    for k, v in pairs(GetPlayerItems(PlayerData)) do
        if GetHashKey(v.name) == weapon then
            return v
        end
    end
end

exports("GetPlayerItems", GetPlayerItems)