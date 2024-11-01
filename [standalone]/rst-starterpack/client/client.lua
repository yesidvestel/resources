local QBCore = exports['qb-core']:GetCoreObject()
local pedSpawned = false
local StarterpackPed = nil
local StarterpackZone = nil


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    SetupStarterpackMenu()
end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    deletePed()
end)
AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    SetupStarterpackMenu()
end)
--Marcas
Citizen.CreateThread(function()
	while true do		
		Citizen.Wait(0)
		--if PlayerJob.type == 'leo' then
			--for _, v in pairs(Config.Location) do
				--print(Config.Location.x)
				DrawMarker(0, Config.Location.x, Config.Location.y, Config.Location.z+1.2 - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
			    DrawMarker(36, -235.65, -987.53, 29.16 - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
			--end
			--[[if PlayerJob.onduty then
				for _, v in pairs(Config.Locations['armory']) do
					DrawMarker(2, v.x, v.y, v.z - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
				end
				for _, v in pairs(Config.Locations['fingerprint']) do
					DrawMarker(2, v.x, v.y, v.z - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
				end
				for _, v in pairs(Config.Locations['helicopter']) do
					DrawMarker(2, v.x, v.y, v.z - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
				end
				for _, v in pairs(Config.Locations['vehicle']) do
					DrawMarker(2, v.x, v.y, v.z - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
				end
				for _, v in pairs(Config.Locations['vestier']) do
					DrawMarker(2, v.x, v.y, v.z - 0.2 , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
				end
			--end
        else
            Citizen.Wait(1000)
        end]]
	end
end)

local function createPed()
    if pedSpawned then return end

    local current = "a_m_y_smartcaspat_01"

    RequestModel(current)
    while not HasModelLoaded(current) do
        Wait(0)
    end

    StarterpackPed = CreatePed(0, current, Config.Location.x, Config.Location.y, Config.Location.z-1, Config.Location.w, false, false)
    TaskStartScenarioInPlace(StarterpackPed, "WORLD_HUMAN_STAND_MOBILE", 0, true)
    FreezeEntityPosition(StarterpackPed, true)
    SetEntityInvincible(StarterpackPed, true)
    SetBlockingOfNonTemporaryEvents(StarterpackPed, true)

    exports['qb-target']:AddTargetEntity(StarterpackPed, {
        options = {
            {
                type = "client",
                event = "rst-starterpack:client:claimStarterpack",
                icon = 'fas fa-certificate',
                label = 'Claim your Starterpack Now!'
            }
        },
        distance = 2.0
    })

    pedSpawned = true
end

local function deletePed()
    DeletePed(StarterpackPed)
end


function SetupStarterpackMenu()
    createPed()
end

RegisterNetEvent('rst-starterpack:client:claimStarterpack', function()
    local xPlayer = QBCore.Functions.GetPlayerData()
    if xPlayer then
        if xPlayer.metadata['starterpack'] then
            QBCore.Functions.Notify("You Already Claimed Starterpack!", 'primary')
        else
            QBCore.Functions.Notify("Please Wait, we are giving you something for starterpack", 'primary')
            TriggerServerEvent('rst-starterpack:server:claimStarterpack')
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    deletePed()
end)
