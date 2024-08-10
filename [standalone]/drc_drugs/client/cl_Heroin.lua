local SpawnedHeroinPlants = 0
local HeroinPlants = {}
local TSE = TriggerServerEvent
local inside = false
local HeroinPlant = {}

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(HeroinPlants) do
			SetEntityAsMissionEntity(v, false, true)
			DeleteObject(v)
		end
	end
end)

RegisterNetEvent("drc_drugs:heroin:menu", function(data)
	if data.menu == "HeroinProcess" then
		if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Heroin.Process.header,
                    txt = Config.Heroin.Process.description,
                    params = {
                        event = 'drc_drugs:heroin:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
				id = 'DrugsHeroinMenu',
				title = locale("table"),
				options = {
					[Config.Heroin.Process.header] = {
						arrow = false,
						description = Config.Heroin.Process.description,
						event = 'drc_drugs:heroin:progress',
						args = { menu = data.menu }
					}
				}
			})
			lib.showContext('DrugsHeroinMenu')
        end
	end
end)

local HeroinField = lib.zones.sphere({
    coords = Config.Heroin.Field.coords,
    radius = Config.Heroin.Field.radius,
    debug = Config.Heroin.Field.DebugPoly,
    inside = function ()
        
    end,
    onEnter = function ()
        while SpawnedHeroinPlants < 15 do
			Wait(0)
			local heroinCoords = GenerateHeroinCoords()
			RequestModel(Config.Heroin.Field.prop)
			while not HasModelLoaded(Config.Heroin.Field.prop) do
				Wait(100)
			end
			local obj = CreateObject(Config.Heroin.Field.prop, heroinCoords.x, heroinCoords.y, heroinCoords.z, true, true, false)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			if Config.InteractionType ~= "target" then
                HeroinPlant[obj] = lib.zones.sphere({
                    coords = vec3(heroinCoords.x, heroinCoords.y, heroinCoords.z + 1),
                    radius = 1,
                    debug = Config.Debug,
                    inside = function(self)
                        if IsControlJustReleased(0, 38) then
                            PickUpPoppy(obj)
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("pickup"))
                        end
                    end,
                    onEnter = function()
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("pickup"))
                        end    
                    end,
                    onExit = function()
                        if Config.InteractionType == "textui" then
                            TextUIHide()
                        end
                    end
                }) 
            end
			table.insert(HeroinPlants, obj)
			SpawnedHeroinPlants = SpawnedHeroinPlants + 1
		end

        inside = true
    end,
    onExit = function ()
        inside = false
    end
})

function ValidateHeroinCoord(plantCoord)
	local validate = true
	if SpawnedHeroinPlants > 0 then
		for k, v in pairs(HeroinPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end
	end
	return validate
end

function GetCoordZHeroin(x, y)
	local groundCheckHeights = { 1.0, 25.0, 50.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 70.0
end

RegisterNetEvent("drc_drugs:heroin:progress")
AddEventHandler("drc_drugs:heroin:progress", function(data)
	if data.menu == "HeroinProcess" then
		lib.callback('drc_drugs:heroin:getitem', false, function(value)
			if value then
				if not IsProgressBarActive() then
					SetEntityCoords(cache.ped, Config.Heroin.Process.Teleport, false, false, false, true)
					TaskTurnPedToFaceCoord(cache.ped, Config.Heroin.Process.coords, 2000)
					dict = "mini@drinking"
					clip = "shots_barman_b"
					RequestAnimDict(dict)
					while (not HasAnimDictLoaded(dict)) do Wait(0) end
					TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
					local hash = `bkr_prop_meth_sodium`
					RequestModel(hash)
					while not HasModelLoaded(hash) do
						Wait(100)
						RequestModel(hash)
					end
					local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
					AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.14, -0.35, -0.28, -60.0, -20.0, -10.0, true, true, false, false, 1, true)
					if Config.Target == 'ox_target' then
						exports.ox_target:disableTargeting(true)
					end
					FreezeEntityPosition(cache.ped, true)
					ProgressBar(Config.Crack.Process.Duration, locale("HeroinProcessing"))
					DetachEntity(prop, false, false)
					DeleteEntity(prop)
					StopAnimTask(cache.ped, dict, clip, 1.0)
					Wait(0)
					FreezeEntityPosition(cache.ped, false)
					if Config.Target == 'ox_target' then
						exports.ox_target:disableTargeting(false)
					end
					TSE("drc_drugs:heroin:giveitems", data.menu)
				end
			else
				Notify("error", locale("error"), locale("RequiredItems"))
			end
		end, data.menu)
	end
end)

function GenerateHeroinCoords()
	while true do
		Wait(0)

		local heroinCoordX, heroinCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(math.floor(Config.Heroin.Field.radius * -1) + 2, math.floor(Config.Heroin.Field.radius) - 2)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(math.floor(Config.Heroin.Field.radius * -1) + 2, math.floor(Config.Heroin.Field.radius) - 2)

		heroinCoordX = Config.Heroin.Field.coords.x + modX
		heroinCoordY = Config.Heroin.Field.coords.y + modY

		local coordZ = GetCoordZHeroin(heroinCoordX, heroinCoordY)
		local coord = vector3(heroinCoordX, heroinCoordY, coordZ)

		if ValidateHeroinCoord(coord) then
			return coord
		end
	end
end

SetTimeout(2000, function()
	if Config.InteractionType == "target" then
		target = Target()
		target:AddTargetModel(Config.Heroin.Field.prop, {
			options = {
				{
					action = function(entity)
						PickUpPoppy(entity)
					end,
					icon = "fas fa-leaf",
					label = locale("pickup"),
					canInteract = function()
						if inside then
							return true
						end
					end
				},
			},
			distance = 4
		})
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if Config.InteractionType == "target" then
			target = Target()
			target:RemoveZone('HeroinProcess')
		end
	end
end)

SetTimeout(2000, function()
	if Config.InteractionType == "target" then
		target = Target()
		target:AddCircleZone("HeroinProcess", Config.Heroin.Process.coords, Config.Heroin.Process.radius,
			{ name = "HeroinProcess", debugPoly = Config.Debug, useZ = true },
			{ options = {
				{ event = "drc_drugs:heroin:menu", icon = "fas fa-prescription-bottle", label = locale("HeroinProcess"),
					menu = "HeroinProcess",
				}
			},
				distance = 2.5
			}
		)
	else
		lib.zones.sphere({
			coords = Config.Heroin.Process.coords,
			radius = Config.Heroin.Process.radius + 0.5,
			debug = Config.Debug,
			inside = function(self)
				if IsControlJustReleased(0, 38) then
					TriggerEvent("drc_drugs:heroin:menu", {menu = "HeroinProcess"})
				end

				if Config.InteractionType == "3dtext" then
					Draw3DText(self.coords, "[~g~E~w~] - " .. locale("HeroinProcess"))
				end
			end,
			onEnter = function()
				if Config.InteractionType == "textui" then
					TextUIShow("[E] - " .. locale("HeroinProcess"))
				end    
			end,
			onExit = function()
				if Config.InteractionType == "textui" then
					TextUIHide()
				end
			end
		})
	end
end)

function PickUpPoppy(target)
	local nearbyID
	for i = 1, #HeroinPlants, 1 do
		local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(HeroinPlants[i]))
		if dist < 2 then
			nearbyID = i
		end
	end
	if IsPedOnFoot(cache.ped) then
		lib.callback('drc_drugs:heroin:getitem', false, function(value)
			if value then
				if not IsProgressBarActive() then
					if Config.Target == 'ox_target' then
						exports.ox_target:disableTargeting(true)
					end
					if Config.InteractionType ~= "target" then
						HeroinPlant[target]:remove()
						HeroinPlant[target] = nil
					end
					TaskStartScenarioInPlace(cache.ped, "world_human_gardener_plant", 0, true)
					FreezeEntityPosition(cache.ped, true)
					ProgressBar(Config.Heroin.Field.Duration, locale("pickingup"))
					ClearPedTasks(cache.ped)
					FreezeEntityPosition(cache.ped, false)
					if Config.Target == 'ox_target' then
						exports.ox_target:disableTargeting(false)
					end
					TSE('drc_drugs:deleteprop', ObjToNet(target))
					SetEntityAsMissionEntity(target, false, true)
					DeleteObject(target)
					table.remove(HeroinPlants, nearbyID)
					SpawnedHeroinPlants = SpawnedHeroinPlants - 1
					TSE('drc_drugs:heroin:giveitems', "heroinPickup")
				end
			else
				Notify("error", locale("error"), locale("RequiredTrowel"))
			end
		end, "heroinPickup")
	else
		Wait(500)
	end
end
