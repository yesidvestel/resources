local ObjectList = {} -- Object, Model, Coords, IsRendered, SpawnRange

local PlacingObject, LoadedObjects = false, false
local CurrentModel, CurrentObject, CurrentObjectType, CurrentObjectName, CurrentSpawnRange, CurrentCoords, CurrentItem = nil, nil, nil, nil, nil, nil, nil

local group = {user = true}

local ObjectTypes = {
    "none",
    "container",
    "bed",
}

local ObjectParams = {
    ["bed"] = {event = "dusa-pets:bed:sleep", args = CurrentObject, icon = "fas fa-bed", label = "Sleep", SpawnRange = 200, event_2 = "dusa-pets:bed:sit", icon_2 = "fas fa-dog", label_2 = "Sit", event_3 = "dusa-pets:bed:out", icon_3 = "fas fa-right-from-bracket", label_3 = "Out", event_4 = "dusa-pets:bed:delete", icon_4 = "fas fa-trash", label_4 = "Delete"},
    ["none"] = {SpawnRange = 200},
}

local function CancelPlacement()
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentObjectName = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k, v in pairs(ObjectList) do
            if v["IsRendered"] then
                RemoveRoadNodeSpeedZone(v["speedzone"])
                DeleteObject(v["object"])
            end
        end
    end
end)

local function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    -- draw it once to set up layout
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()


    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, 152, true))
    ButtonMessage("Cancel")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, 153, true))
    ButtonMessage("Place object")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, 190, true))
    Button(GetControlInstructionalButton(2, 189, true))
    ButtonMessage("Rotate object")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

local function RequestSpawnObject(object)
    local hash = GetHashKey(object)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Wait(1000)
    end
end

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return b, c, e
end

local function PlaceSpawnedObject(heading, item)
    local ObjectType = 'prop' --will be replaced with inputted prop type later, which will determine options/events
    local Options = { SpawnRange = tonumber(CurrentSpawnRange) }
    if ObjectParams[CurrentObjectType] ~= nil then
        Options = { event = ObjectParams[CurrentObjectType].event, args = ObjectParams[CurrentObjectType].args, icon = ObjectParams[CurrentObjectType].icon, label = ObjectParams[CurrentObjectType].label, SpawnRange = ObjectParams[CurrentObjectType].SpawnRange} --will be replaced with config of options later
    end
    local finalCoords = vector4(CurrentCoords.x, CurrentCoords.y, CurrentCoords.z, heading)
    TriggerServerEvent("dusa_objects:server:CreateNewObject", CurrentModel, finalCoords, CurrentObjectType, Options, CurrentObjectName)
    TriggerServerEvent('dusa-pets:removeItem', item, 1)
    DeleteObject(CurrentObject)
    PlacingObject = false
    CurrentObject = nil
    CurrentObjectType = nil
    CurrentObjectName = nil
    CurrentSpawnRange = nil
    CurrentCoords = nil
    CurrentModel = nil
end

local function CreateSpawnedObject(data)
    if data.object == nil then return print("Invalid Object") end
    local object = data.object
    CurrentObjectType = data.type
    CurrentItem = data.item
    -- CurrentObjectName = data.name or "Random Object"
    CurrentObjectName = "Random Object"
    CurrentSpawnRange = ObjectParams[objectType] and ObjectParams[objectType] ~= nil or data.distance or 15

    RequestSpawnObject(object)
    CurrentModel = object
    CurrentObject = CreateObject(object, 1.0, 1.0, 1.0, true, true, false)
    local heading = 0.0
    SetEntityHeading(CurrentObject, 0)
    
    SetEntityAlpha(CurrentObject, 150)
    SetEntityCollision(CurrentObject, false, false)
    -- SetEntityInvincible(CurrentObject, true)
    FreezeEntityPosition(CurrentObject, true)
    CreateThread(function()
        form = setupScaleform("instructional_buttons")
        while PlacingObject do
            local hit, coords, entity = RayCastGamePlayCamera(20.0)
            CurrentCoords = coords

            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)

            if hit then
                SetEntityCoords(CurrentObject, coords.x, coords.y, coords.z)
            end
            
            if IsControlJustPressed(0, 174) then
                heading = heading + 5
                if heading > 360 then heading = 0.0 end
            end
    
            if IsControlJustPressed(0, 175) then
                heading = heading - 5
                if heading < 0 then heading = 360.0 end
            end
            
            if IsControlJustPressed(0, 44) then
                CancelPlacement()
            end

            SetEntityHeading(CurrentObject, heading)
            if IsControlJustPressed(0, 38) then
                PlaceSpawnedObject(heading, data.item)
            end
            
            Wait(1)
        end
    end)
end
exports("CreateSpawnedObject", CreateSpawnedObject)

RegisterNetEvent('dusa:startPlacing', function(data)
    local table = {{distance = 100, object = data.obj, type = data.type, item = data.item}}
    PlacingObject = true
    CreateSpawnedObject(table[1])
end)

CreateThread(function()
	while true do
		for k, v in pairs(ObjectList) do
            local data = v["options"]
            local objectCoords = v["coords"]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - vector3(objectCoords["x"], objectCoords["y"], objectCoords["z"]))
			if dist < data["SpawnRange"] and v["IsRendered"] == nil then
                
				local object = CreateObject(v["model"], objectCoords["x"], objectCoords["y"], objectCoords["z"], false, false, false)
                SetEntityHeading(object, objectCoords["w"])
                SetEntityAlpha(object, 0)
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
				v["IsRendered"] = true
                v["object"] = object

                --local model = GetEntityModel(object)
                --local min, max = GetModelDimensions(model) --TODO: get max model dimensions to generate the SpeedZone radius
                v["speedzone"] = AddRoadNodeSpeedZone(objectCoords["x"], objectCoords["y"], objectCoords["z"], 10.0, 0, false)

                if v["model"] == bowlhash then
                    feeding = true
                    mamaobj = object
                end
                
                for i = 0, 255, 51 do
                    Wait(50)
                    SetEntityAlpha(v["object"], i, false)
                end
                if ObjectParams[v.type] ~= nil then
                    exports['qtarget']:AddTargetEntity(object, {
                        debugPoly=true,
                        options = {
                            {
                                name = "object_spawner_"..object, 
                                event = ObjectParams[v.type].event,
                                args = ObjectParams[v.type].args,
                                icon = ObjectParams[v.type].icon,
                                label = ObjectParams[v.type].label,
                                distance = ObjectParams[data.SpawnRange],
                                id = v.id
                            },
                            {
                                name = "object_spawner2_"..object, 
                                event = ObjectParams[v.type].event_2,
                                icon = ObjectParams[v.type].icon_2,
                                label = ObjectParams[v.type].label_2,
                                distance = ObjectParams[data.SpawnRange],
                                id = v.id+1
                            },
                            {
                                name = "object_spawner3_"..object, 
                                event = ObjectParams[v.type].event_3,
                                icon = ObjectParams[v.type].icon_3,
                                label = ObjectParams[v.type].label_3,
                                distance = ObjectParams[data.SpawnRange],
                                id = v.id+2
                            },
                            {
                                name = "object_spawner4_"..object, 
                                event = ObjectParams[v.type].event_4,
                                icon = ObjectParams[v.type].icon_4,
                                label = ObjectParams[v.type].label_4,
                                distance = ObjectParams[data.SpawnRange],
                                id = v.id+3
                            },
                        },
                    })
                end
			end
			
			if dist >= data["SpawnRange"] and v["IsRendered"] then
                if DoesEntityExist(v["object"]) then 
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(v["object"], i, false)
                    end
                    DeleteObject(v["object"])

                    RemoveRoadNodeSpeedZone(v["speedzone"])
                    v["object"] = nil
                    v["IsRendered"] = nil
                end
			end
		end
        Wait(1500)
	end
end)

local generalid = 0
RegisterNetEvent("dusa_objects:client:AddObject", function(object)
    ObjectList[object.id] = object
    generalid = object.id
end)

RegisterNetEvent('dusa_objects:client:receiveObjectDelete', function(id)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestDistance = -1
    local closestEntity   = nil

    for i=1, #Config.Objects, 1 do
        local object = GetClosestObjectOfType(playerCoords, 50.0, GetHashKey(Config.Objects[i].prop), false, false, false)
        if DoesEntityExist(object) then
            for i = 255, 0, -51 do
                Wait(50)
                SetEntityAlpha(object, i, false)
            end
            print('delete', object)
            DeleteObject(object)

            -- RemoveRoadNodeSpeedZone(ObjectList[id]["speedzone"])
        end
    end
end)

-- OPTIONAL OBJECT MENU
-- RegisterNetEvent('dusa_pets:client:objectmenu', function()
--     local options = {}
--     for _,v in pairs(Config.Objects) do
--         table.insert(options, {
--             title = v.label,
--             event = "dusa:startPlacing",
--             args = {
--                 obj = v.prop,
--                 type = v.type or 'none'
--             }
--         })
--         lib.registerContext({
--             id = 'object_menu',
--             title = 'Object Menu',
--             menu = 'some_menu',
--             options = options
--         })
--     end
--     lib.showContext('object_menu')
-- end)

AddEventHandler('dusa_pets:hasEnteredEntityZone', function(entity, item)
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = 'E - Remove Prop'
    CurrentActionData = {entity = entity, item = item}
end)

AddEventHandler('dusa_pets:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

CreateThread(function()
	while true do
		local Sleep = 5000

			local GetEntityCoords = GetEntityCoords
			local GetClosestObjectOfType = GetClosestObjectOfType
			local DoesEntityExist = DoesEntityExist
			local playerCoords = GetEntityCoords(PlayerPedId())
	
			local closestDistance = -1
			local closestEntity   = nil
            local entityItem = nil

			for k, v in pairs(Config.Objects) do
				local object = GetClosestObjectOfType(playerCoords, 50.0, GetHashKey(v.prop), false, false, false)

				if DoesEntityExist(object) then
					Sleep = 500
					local objCoords = GetEntityCoords(object)
					local distance = #(playerCoords - objCoords)

					if closestDistance == -1 or closestDistance > distance then
						closestDistance = distance
						closestEntity   = object
                        entityItem = k
					end
				end
			end

			if closestDistance ~= -1 and closestDistance <= 3.0 then
				if LastEntity ~= closestEntity then
					TriggerEvent('dusa_pets:hasEnteredEntityZone', closestEntity, entityItem)
					LastEntity = closestEntity
				end
			else
				if LastEntity then
					TriggerEvent('dusa_pets:hasExitedEntityZone', LastEntity)
					LastEntity = nil
                    entityItem = nil
				end
			end
		Wait(Sleep)
	end
end)

RegisterNetEvent('dusa-pets:bed:delete', function()
    if not CurrentAction then 
		return 
	end

    if CurrentAction == 'remove_entity' then
        TriggerServerEvent('dusa_objects:server:DeleteObject', CurrentActionData.entity)
        TriggerServerEvent('dusa-pets:addItem', CurrentItem, 1)
        TriggerEvent('dusa_pets:refreshbed')
        SetEntityInvincible(pet, false)
	end

    CurrentAction = nil
end)

Objects = {
    ["sf_prop_sf_bed_dog_01a"] = true,
    ["sf_prop_sf_bed_dog_01b"] = true,
}
