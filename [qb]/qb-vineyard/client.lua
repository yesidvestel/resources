local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = {}

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
		QBCore.Functions.GetPlayerData(function(PlayerData)
			PlayerJob = PlayerData.job
		end)
    end
end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

local tasking = false
local startVineyard = false
local random = 0
local pickedGrapes = 0
local blip = 0
local winetimer = Config.wineTimer
local loadIngredients = false
local wineStarted = false
local finishedWine = false

local grapeLocations = {
	[1] = vector3(-1875.41, 2100.37, 138.86),
	[2] = vector3(-1908.69, 2107.48, 131.31),
	[3] = vector3(-1866.04, 2112.64, 134.41),
	[4] = vector3(-1907.76, 2125.35, 124.03),
	[5] = vector3(-1850.31, 2142.95, 122.30),
	[6] = vector3(-1888.22, 2164.51, 114.81),
	[7] = vector3(-1835.52, 2180.59, 104.88),
	[8] = vector3(-1891.98, 2208.35, 94.56),
	[9] = vector3(-1720.37, 2182.03, 106.18),
	[10] = vector3(-1808.52, 2173.14, 107.63),
	[11] = vector3(-1784.22, 2222.80, 92.86),
	[12] = vector3(-1889.13, 2250.05, 79.63),
	[13] = vector3(-1861.16, 2254.32, 81.04),
	[14] = vector3(-1886.75, 2272.45, 70.81),
	[15] = vector3(-1845.49, 2274.63, 73.33),
	[16] = vector3(-1687.28, 2195.76, 97.87),
	[17] = vector3(-1741.18, 2173.22, 114.39),
	[18] = vector3(-1743.17, 2141.11, 121.18),
	[19] = vector3(-1813.84, 2089.57, 134.21),
	[20] = vector3(-1698.71, 2150.65, 110.41),
}

local function log(debugMessage)
	print(('^6[^3qb-vineyard^6]^0 %s'):format(debugMessage))
end

local function CreateBlip()
	if tasking then
		blip = AddBlipForCoord(grapeLocations[random].x,grapeLocations[random].y,grapeLocations[random].z)
	end
    SetBlipSprite(blip, 465)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Drop Off")
    EndTextCommandSetBlipName(blip)
end

local function nextTask()
	if tasking then
		return
	end
	random = math.random(#grapeLocations)
	tasking = true
	CreateBlip()
end

local function startVinyard()
	local amount = math.random(Config.PickAmount.min, Config.PickAmount.max)
	QBCore.Functions.Notify(Lang:t("text.start_shift"))
	while startVineyard do
		if tasking then
			Wait(5000)
		else
			nextTask()
			pickedGrapes = pickedGrapes + 1
			if pickedGrapes == amount then
				nextTask()
				Wait(20000)
				startVineyard = false
				pickedGrapes = 0
				QBCore.Functions.Notify(Lang:t("text.end_shift"))
			end
		end
		Wait(5)
	end
end

local function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

local function pickProcess()
    QBCore.Functions.Progressbar("pick_grape", Lang:t("progress.pick_grapes"), math.random(6000,8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
		tasking = false
        TriggerServerEvent("qb-vineyard:server:getGrapes")
		DeleteBlip()
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify(Lang:t("task.cancel_task"), "error")
    end)
end

local function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

local function PickAnim()
    local ped = PlayerPedId()
    LoadAnim('amb@prop_human_bum_bin@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_bum_bin@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

local grapeZones = {}
for k=1, #grapeLocations do
	local label = ("GrapeZone-%s"):format(k)
	grapeZones[k] = {
		isInside = false,
		zone = BoxZone:Create(grapeLocations[k], 1.75, 3, {
			name=label,
			minZ = grapeLocations[k].z-1.0,
			maxZ = grapeLocations[k].z+1.0,
			debugPoly=Config.Debug,
		})
	}
	grapeZones[k].zone:onPlayerInOut(function(isPointInside)
		grapeZones[k].isInside = isPointInside
		if grapeZones[k].isInside then
			if Config.Debug then
				log(Lang:t("text.zone_entered",{zone=label}))
				if k == random then log(Lang:t("text.valid_zone")) else log(Lang:t("text.invalid_zone")) end
			end

			if k==random then
				CreateThread(function()
					while grapeZones[k].isInside and k==random do
						exports['qb-core']:DrawText(Lang:t("task.start_task"),'right')
						if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0,38) then
							PickAnim()
							pickProcess()
							exports['qb-core']:HideText()
							random = 0
						end
						Wait(1)
					end
				end)
			end
		else
			if Config.Debug then log(Lang:t("text.zone_exited",{zone=label})) end
			exports['qb-core']:HideText()
		end
	end)
end

local function StartWineProcess()
    CreateThread(function()
        wineStarted = true
        while winetimer > 0 do
            winetimer = winetimer - 1
            Wait(1000)
		end
		wineStarted = false
		finishedWine = true
		winetimer = Config.wineTimer
    end)
end


local function PrepareAnim()
    local ped = PlayerPedId()
    LoadAnim('amb@code_human_wander_rain@male_a@base')
    TaskPlayAnim(ped, 'amb@code_human_wander_rain@male_a@base', 'static', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

local function grapeJuiceProcess()
    QBCore.Functions.Progressbar("grape_juice", Lang:t("progress.process_grapes"), math.random(15000,20000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("qb-vineyard:server:receiveGrapeJuice")
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify(Lang:t("task.cancel_task"), "error")
    end)
end

local Zones = {}
Zones[1] = {
	isInside = false,
	zone = PolyZone:Create(Config.Vineyard.start.zones, {
		name="Vineyard-Start",
		minZ = Config.Vineyard.start.minZ,
		maxZ = Config.Vineyard.start.maxZ,
		debugPoly = Config.Debug
	})
}
Zones[1].zone:onPlayerInOut(function(isPointInside)
	Zones[1].isInside = isPointInside
	if isPointInside then
		if Config.Debug then log(Lang:t("text.zone_entered",{zone="Start"})) end
		if not startVineyard and PlayerJob.name == "vineyard" then
			exports['qb-core']:DrawText(Lang:t("task.start_task"),'right')
			CreateThread(function()
				while Zones[1].isInside do
					if IsControlJustReleased(0,38) and not startVineyard then
						startVineyard = true
						startVinyard()
					end
					Wait(1)
				end
			end)

		end
	else
		if Config.Debug then log(Lang:t("text.zone_exited",{zone="Start"})) end
		exports['qb-core']:HideText()
	end
end)

Zones[2] = {
	isInside = false,
	zone = PolyZone:Create(Config.Vineyard.wine.zones, {
		name="Vineyard-Wine",
		minZ = Config.Vineyard.wine.minZ,
		maxZ = Config.Vineyard.wine.maxZ,
		debugPoly = Config.Debug
	})
}
Zones[2].zone:onPlayerInOut(function(isPointInside)
	Zones[2].isInside = isPointInside
	if isPointInside then
		if Config.Debug then log(Lang:t("text.zone_entered",{zone="Wine"})) end

		if not startVineyard and PlayerJob.name == "vineyard" then
			CreateThread(function()
				while Zones[2].isInside do
					if not wineStarted then
						if not loadIngredients then
							exports['qb-core']:DrawText(Lang:t("task.load_ingrediants"),'right')
							if IsControlJustPressed(0, 38) and not LocalPlayer.state.inv_busy then
								QBCore.Functions.TriggerCallback('qb-vineyard:server:loadIngredients', function(result)
									if result then loadIngredients = true end
								end)

							end
						else
							if not finishedWine then
								exports['qb-core']:DrawText(Lang:t("task.wine_process"),'right')
								if IsControlJustPressed(0, 38) and not LocalPlayer.state.inv_busy then
									StartWineProcess()
								end
							else
								exports['qb-core']:DrawText(Lang:t("task.get_wine"),'right')
								if IsControlJustPressed(0, 38) and not LocalPlayer.state.inv_busy then
									TriggerServerEvent("qb-vineyard:server:receiveWine")
									finishedWine = false
									loadIngredients = false
									wineStarted = false
								end
							end
						end
					else
						exports['qb-core']:DrawText(Lang:t("task.countdown",{time=winetimer}),'right')
						Wait(999)
					end
					Wait(1)
				end
			end)

		end
	else
		if Config.Debug then log(Lang:t("text.zone_exited",{zone="Wine"})) end
		exports['qb-core']:HideText()
	end
end)

Zones[3] = {
	isInside = false,
	zone = PolyZone:Create(Config.Vineyard.grapejuice.zones, {
		name="Vineyard-GrapeJuice",
		minZ = Config.Vineyard.grapejuice.minZ,
		maxZ = Config.Vineyard.grapejuice.maxZ,
		debugPoly = Config.Debug
	})
}
Zones[3].zone:onPlayerInOut(function(isPointInside)
	Zones[3].isInside = isPointInside
	if isPointInside then
		if Config.Debug then log(Lang:t("text.zone_entered",{zone="Juice"})) end
		if not startVineyard and PlayerJob.name == "vineyard" then
			CreateThread(function()
				while Zones[3].isInside do
					exports['qb-core']:DrawText(Lang:t("task.make_grape_juice"),'right')
					if IsControlJustPressed(0, 38) and not LocalPlayer.state.inv_busy then
						QBCore.Functions.TriggerCallback('qb-vineyard:server:grapeJuice', function(result)
							if result then PrepareAnim() grapeJuiceProcess() end
						end)
					end
					Wait(1)
				end
			end)
		end
	else
		if Config.Debug then log(Lang:t("text.zone_exited",{zone="Juice"})) end
		exports['qb-core']:HideText()
	end
end)
---- ped
local function EnsurePedModel(pedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(10)
    end
end

local function CreatePedAtCoords(pedModel, coords)
    if type(pedModel) == "string" then
        pedModel = GetHashKey(pedModel)
    end
    EnsurePedModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 0.98, coords.w, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

Citizen.CreateThread(function()
	CreatePedAtCoords('cs_russiandrunk', vector4(-1888.0942, 2050.4277, 140.9838, 156.2016))
end)
----target
Citizen.CreateThread(function()
		exports['qb-target']:AddBoxZone("JuicePickerPackaging", vector3(-1926.14, 2045.65, 140.02), 2.0, 2.0, {
            name = "JuicePickerPackaging",
            heading = 77.61,
            debugPoly = Config.DebugPoly,
	    }, {
		    options = {
			    {
                    type = "client",
                    event = "qb-vineyard:client:PackingMenu",
				    icon = "fa fa-box",
				    label = "Pack Some Drinks?!",
			    },
		    },
		    distance = 2
        })
		exports['qb-target']:AddBoxZone("JuicePickerSell", vector3(-1888.09, 2050.43, 140.98), 0.8, 0.8, {
            name = "JuicePickerSell",
            heading = 0,
            debugPoly = Config.DebugPoly,
            minZ = 139.98,
            maxZ = 141.78,
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-vineyard:client:SellMenu",
				    icon = "fa fa-dollar-sign",
				    label = "Sell Juices",
			    },
		    },
		    distance = 3
        })
end)
----
local function DeliveryTargetZone(route)
    Citizen.CreateThread(function()
        --if Config.Target == 'qb-target' then
            exports['qb-target']:AddBoxZone("VineyardSellMenu", Config.Routes[route].DeliveryCoords, 2, 2, {
                name = "VineyardSellMenu", heading = Config.Routes[route].heading, debugPoly = Config.DebugPoly, },
            { options = { { type = "client", event = "qb-vineyard:client:SellMenuEvent", icon = "fa-solid fa-hand", label = "Deliver The Goods!", }, }, distance = 1.5 })
        --[[elseif Config.Target == 'qtarget' then
            exports['qtarget']:AddBoxZone("VineyardSellMenu", Config.Routes[route].DeliveryCoords, 2, 2, {
                name = "VineyardSellMenu", heading = Config.Routes[route].heading, debugPoly = Config.DebugPoly, },
            { options = { { type = "client", event = "qb-vineyard:client:SellMenuEvent", icon = "fa-solid fa-hand", label = "Deliver The Goods!", }, }, distance = 1.5 })
        end]]
    end)
end

local function DeliveryBlip(route)
	Blip = AddBlipForCoord(Config.Routes[route].DeliveryCoords)
    SetBlipSprite(Blip, Config.RoutesBlipConfig.BlipSprite)
	SetBlipDisplay(Blip, Config.RoutesBlipConfig.BlipDisplay)
    SetBlipScale(Blip, Config.RoutesBlipConfig.BlipScale)
	SetBlipColour(Blip, Config.RoutesBlipConfig.BlipColour)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.RoutesBlipConfig.BlipName)
    EndTextCommandSetBlipName(Blip)
end
RegisterNetEvent('qb-vineyard:client:SellMenuFactors')
AddEventHandler('qb-vineyard:client:SellMenuFactors', function()
    local luck = math.random(#Config.Routes)
    SetNewWaypoint(Config.Routes[luck].DeliveryCoords)
    DeliveryTargetZone(luck)
    DeliveryBlip(luck)
end)
RegisterNetEvent('qb-vineyard:client:GrapeJuicePackaging')
AddEventHandler('qb-vineyard:client:GrapeJuicePackaging', function()
    TriggerServerEvent('qb-vineyard:server:GrapeJuicePackaging')	
end)
RegisterNetEvent('qb-vineyard:client:WinePackaging')
AddEventHandler('qb-vineyard:client:WinePackaging', function()
    TriggerServerEvent('qb-vineyard:server:WinePackaging')
end)
RegisterNetEvent('qb-vineyard:client:SellMenuEvent')
AddEventHandler('qb-vineyard:client:SellMenuEvent', function()
    QBCore.Functions.Progressbar("deliver_goods", "Delivering Goods...", math.random(8500,12000), true, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "timetable@jimmy@doorknock@",
        anim = "knockdoor_idle",
        flags = 17,
    }, {}, {}, function()
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("qb-vineyard:server:SellMenu")
        RemoveBlip(Blip)
        if Config.Target == 'qb-target' then
            exports['qb-target']:RemoveZone("VineyardSellMenu")
        elseif Config.Target == 'qtarget' then
            exports['qtarget']:RemoveZone("VineyardSellMenu")
        end
    end, function()
        Notify(3, Config.Notifications["TaskCancel"], Config.Notifications["okok_VineyardTitle"])
        ClearPedTasks(PlayerPedId())
    end)
end)
----evento
RegisterNetEvent('qb-vineyard:client:PackingMenu')
AddEventHandler('qb-vineyard:client:PackingMenu', function()
    local myMenu = {
        {
            id = 1,
            header = 'Juice Packings'
        },
        {
            id = 2,
            header = "Pack GrapeJuice",
            txt = "x6 GrapeJuice = 6Pack | x12 GrapeJuice = 12Pack | x24 GrapeJuice = 24Pack",
            params = {
                event = "qb-vineyard:client:GrapeJuicePackaging",
            }
        },
        {
            id = 3,
            header = "Pack Wine",
            txt = "x6 Wine = 6Pack | x12 = 12Pack | x24 Wine = 24Pack",
            params = {
                event = "qb-vineyard:client:WinePackaging",
            }
        },
    }
    exports['qb-menu']:openMenu(myMenu)
end)
RegisterNetEvent('qb-vineyard:client:SellMenu')
AddEventHandler('qb-vineyard:client:SellMenu', function()
    local myMenu = {
        {
            id = 1,
            header = 'Juice Sales'
        },
        {
            id = 2,
            header = "Sell GrapeJuice",
            txt = "x6 Grape Juice = $4.00 | x12 Grape Juice = $15.00 | x24 Grape Juice = $32.00",
            params = {
                event = "qb-vineyard:client:SellMenuFactors",
            }
        },
        {
            id = 3,
            header = "Sell Wine",
            txt = "x6 Wine = $35.00 | x12 Wine = $80.00 | x24 Wine = $180.00",
            params = {
                event = "qb-vineyard:client:SellMenuFactors",
            }
        },
    }
    exports['qb-menu']:openMenu(myMenu)
end)