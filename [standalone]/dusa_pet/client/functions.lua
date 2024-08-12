function makeEntityFaceEntity(entity1, entity2)
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(entity1, heading)
end

function getSpawnLocation(plyped)
    if IsPedInAnyVehicle(plyped, true) then
        return GetOffsetFromEntityInWorldCoords(plyped, -2.0, 1.0, 0.5)
    else
        return GetOffsetFromEntityInWorldCoords(plyped, 1.0, -1.0, 0.5)
    end
end

function RotationToDirection(rotation)
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

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination = 
    { 
        x = cameraCoord.x + direction.x * distance, 
        y = cameraCoord.y + direction.y * distance, 
        z = cameraCoord.z + direction.z * distance 
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
    return b, c, e
end

function PingLocation(pet)
    while true do
        Citizen.Wait(0)

        local hit, coords, entity = RayCastGamePlayCamera(1000.0)

        if hit then
            local position = GetEntityCoords(PlayerPedId())
            dusa.textUI(Config.Notifications[Config.Locale].determine_location)
            DrawMarker(3, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.1, 1.1, 0.5, 4, 253, 132, 255, 0, 0, 0, 1, 0, 0, 0)
            if IsControlJustPressed(0, 38) then
                if dusa.framework == 'qb' then dusa.keyPressed() else dusa.hideUI() end
                if #(position - coords) < Config.MaxDistanceToSend then
                    TaskGoStraightToCoord(pet, coords.x, coords.y, coords.z, 10.0, -1)
                else
                    dusa.showNotification(Config.Notifications[Config.Locale].fartosend, 'error')
                end
                break;
            end
        end
    end
end