local spawnedMushroomsLeaf = 0
local MushroomsPlants = {}
local TSE = TriggerServerEvent
local inside = false
local Mushroomplant = {}

local MushroomsField = lib.zones.sphere({
    coords = Config.MushroomsField.coords,
    radius = Config.MushroomsField.radius,
    debug = Config.MushroomsField.DebugPoly,
    inside = function ()
        
    end,
    onEnter = function ()
        while spawnedMushroomsLeaf < 10 do
            Wait(0)
			local MushroomsCoords = GenerateMushroomsLeafCoords()
			RequestModel(Config.MushroomsField.prop)
			while not HasModelLoaded(Config.MushroomsField.prop) do
				Wait(0)
			end
			local obj = CreateObject(Config.MushroomsField.prop, MushroomsCoords.x, MushroomsCoords.y, MushroomsCoords.z, true,
				true, false)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
            if Config.InteractionType ~= "target" then
                Mushroomplant[obj] = lib.zones.sphere({
                    coords = vec3(MushroomsCoords.x, MushroomsCoords.y, MushroomsCoords.z + 1),
                    radius = 1,
                    debug = Config.Debug,
                    inside = function(self)
                        if IsControlJustReleased(0, 38) then
                            PickUpMushroom(obj)
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
            table.insert(MushroomsPlants, obj)
			spawnedMushroomsLeaf = spawnedMushroomsLeaf + 1
        end

        inside = true
    end,
    onExit = function ()
        inside = false
    end
})

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(MushroomsPlants) do
			SetEntityAsMissionEntity(v, false, true)
			DeleteObject(v)
		end
	end
end)

SetTimeout(2000, function()
	if Config.InteractionType == "target" then
		target = Target()
		target:AddTargetModel(Config.MushroomsField.prop, {
			options = {
				{
					action = function(entity)
						PickUpMushroom(entity)
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
			distance = 3
		})
	end
end)

function GenerateMushroomsLeafCoords()
	while true do
		Wait(1)

		local MushroomCoordX, MushroomCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(math.floor(Config.MushroomsField.radius * -1) + 2,
			math.floor(Config.MushroomsField.radius) - 2)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(math.floor(Config.MushroomsField.radius * -1) + 2,
			math.floor(Config.MushroomsField.radius) - 2)
		MushroomCoordX = Config.MushroomsField.coords.x + modX
		MushroomCoordY = Config.MushroomsField.coords.y + modY

		local coordZ = GetCoordZMushrooms(MushroomCoordX, MushroomCoordY)
		local coord = vector3(MushroomCoordX, MushroomCoordY, coordZ)
		if ValidateMushroomsLeafCoord(coord) then
			return coord
		end
	end
end

function GetCoordZMushrooms(x, y)
	local groundCheckHeights = { 1.0, 25.0, 50.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 70.0
end

function ValidateMushroomsLeafCoord(plantCoord)
	local validate = true
	if spawnedMushroomsLeaf > 0 then
		for k, v in pairs(MushroomsPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end
	end
	return validate
end

function PickUpMushroom(target)
	local nearbyID
	for i = 1, #MushroomsPlants, 1 do
		local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(MushroomsPlants[i]))
		if dist < 2 then
			nearbyID = i
		end
	end
	if IsPedOnFoot(cache.ped) then
		lib.callback('drc_drugs:mushroom:getitem', false, function(value)
			if value then
				if not IsProgressBarActive() then
					if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
					if Config.InteractionType ~= "target" then
						Mushroomplant[target]:remove()
						Mushroomplant[target] = nil
					end
                    TaskStartScenarioInPlace(cache.ped, "world_human_gardener_plant", 0, true)
                    FreezeEntityPosition(cache.ped, true)
					ProgressBar(10000, locale("pickingup"))
                    ClearPedTasks(cache.ped)
					FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
					TSE('drc_drugs:deleteprop', ObjToNet(target))
					SetEntityAsMissionEntity(target, false, true)
					DeleteObject(target)
					table.remove(MushroomsPlants, nearbyID)
					spawnedMushroomsLeaf = spawnedMushroomsLeaf - 1
					TSE('drc_drugs:mushroom:giveitems', "MushroomPickup")
				end
			else
				Notify("error", locale("error"), locale("RequiredItems"))
			end
		end, "MushroomPickup")
	else
		Wait(500)
	end
end
