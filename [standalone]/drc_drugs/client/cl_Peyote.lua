local spawnedPeyoteLeaf = 0
local PeyotePlants = {}
local TSE = TriggerServerEvent
local inside = false
local PeyotePlant = {}

local PeyoteField = lib.zones.sphere({
    coords = Config.PeyoteField.coords,
    radius = Config.PeyoteField.radius,
    debug = Config.PeyoteField.DebugPoly,
    inside = function ()
        
    end,
    onEnter = function ()
        while spawnedPeyoteLeaf < 10 do
            Wait(0)
			local PeyoteCoords = GeneratePeyoteLeafCoords()
			RequestModel(Config.PeyoteField.prop)
			while not HasModelLoaded(Config.PeyoteField.prop) do
				Wait(0)
			end
			local obj = CreateObject(Config.PeyoteField.prop, PeyoteCoords.x, PeyoteCoords.y, PeyoteCoords.z, true,
				true, false)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
            if Config.InteractionType ~= "target" then
                PeyotePlant[obj] = lib.zones.sphere({
                    coords = vec3(PeyoteCoords.x, PeyoteCoords.y, PeyoteCoords.z + 1),
                    radius = 1,
                    debug = Config.Debug,
                    inside = function(self)
                        if IsControlJustReleased(0, 38) then
                            PickUpPeyote(obj)
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
            table.insert(PeyotePlants, obj)
			spawnedPeyoteLeaf = spawnedPeyoteLeaf + 1
        end

        inside = true
    end,
    onExit = function ()
        inside = false
    end
})

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(PeyotePlants) do
			SetEntityAsMissionEntity(v, false, true)
			DeleteObject(v)
		end
	end
end)

SetTimeout(2000, function()
	if Config.InteractionType == "target" then
		target = Target()
		target:AddTargetModel(Config.PeyoteField.prop, {
			options = {
				{
					action = function(entity)
						PickUpPeyote(entity)
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

function GeneratePeyoteLeafCoords()
	while true do
		Wait(1)

		local PeyoteCoordX, PeyoteCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(math.floor(Config.PeyoteField.radius * -1) + 2, math.floor(Config.PeyoteField.radius) - 2)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(math.floor(Config.PeyoteField.radius * -1) + 2, math.floor(Config.PeyoteField.radius) - 2)
		PeyoteCoordX = Config.PeyoteField.coords.x + modX
		PeyoteCoordY = Config.PeyoteField.coords.y + modY

		local coordZ = GetCoordZPeyote(PeyoteCoordX, PeyoteCoordY)
		local coord = vector3(PeyoteCoordX, PeyoteCoordY, coordZ)

		if ValidatePeyoteLeafCoord(coord) then
			return coord
		end
	end
end

function GetCoordZPeyote(x, y)
	local groundCheckHeights = { 1.0, 25.0, 50.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 20.0
end

function ValidatePeyoteLeafCoord(plantCoord)
	if spawnedPeyoteLeaf > 0 then
		local validate = true

		for k, v in pairs(PeyotePlants) do
			local dist = #(plantCoord - GetEntityCoords(v))
			if dist < 5 then
				validate = false
			end
		end
		local validdist = #(plantCoord - Config.PeyoteField.coords)
		if validdist > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function PickUpPeyote(target)
	local nearbyID
	for i = 1, #PeyotePlants, 1 do
		local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(PeyotePlants[i]))
		if dist < 2 then
			nearbyID = i
		end
	end
	if IsPedOnFoot(cache.ped) then
		lib.callback('drc_drugs:peyote:getitem', false, function(value)
			if value then
				if not IsProgressBarActive() then
					if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
					if Config.InteractionType ~= "target" then
						PeyotePlant[target]:remove()
						PeyotePlant[target] = nil
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
					table.remove(PeyotePlants, nearbyID)
					spawnedPeyoteLeaf = spawnedPeyoteLeaf - 1
					TSE('drc_drugs:peyote:giveitems', "PeyotePickup")
				end
			else
				Notify("error", locale("error"), locale("RequiredItems"))
			end
		end, "PeyotePickup")
	else
		Wait(500)
	end
end
