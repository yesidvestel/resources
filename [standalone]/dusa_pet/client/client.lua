pet = nil
activePet = nil
local pet_model
local illness, petHealth = 'healthy', 100
local petFood = 100
local petMoving, stay, ballThrown, chasing, searching, sleeping, gotolocation, commanded, pet_type, canattack,
    hudstatus, sitting, revived = false, false, false, false, false, false, false, false, false, false, false, false, false
feeding, bowlhash, petName = false, 'prop_bowl_crisps', Config.DefaultPetName
local PetTable, PetJob = {}, {}
local currentObject = nil
local petSpeed = 8.0
local attacking = false
local petShopSpawned, vetSpawned = false, false
local petShopNPC, vet
local pet_clothes = {}

-- Spawn NPC When you get close, delete when you leave

--------------------------FUNCTIONS----------------------------
---------------------------------------------------------------
-- Spawn NPC
function TargetNPC(model, coords, heading, options, func)
    local model = GetHashKey(model)

    if not HasModelLoaded(model) then
        RequestModel(model)
        Wait(10)
    end

    while not HasModelLoaded(model) do
        Wait(10)
    end

    npc = CreatePed(5, model, coords.x, coords.y, coords.z - 1, heading, false, false)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetModelAsNoLongerNeeded(model)
    if Config.Target and Config.Target ~= 'false' then
        if Config.Target == 'ox_target' then
            exports[Config.Target]:addLocalEntity(npc, options)
        else
            exports[Config.Target]:AddTargetEntity(npc, { -- The specified entity number
                options = options,
                distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
            })
        end
    end
end

if Config.Target == 'false' or Config.Target == false then
    CreateThread(function()
        local textDrawn = false
        while true do
            local sleep = 2000
            for k, v in pairs(Config.Peds) do
                local distance = #(GetEntityCoords(PlayerPedId()) - v.coords)
                textDrawn = false
                if distance < 5 then
                    sleep = 0
                    textDrawn = true
                    dusa.textUI(Config.Translations[Config.Locale].e_interact)
                end
                if not textDrawn then
                    dusa.hideUI()
                end
            end
            Wait(sleep)
        end
    end)
    RegisterCommand("pet:interact", function()
        for k, v in pairs(Config.Peds) do
            if k == 'petshop' then
                local distance = #(GetEntityCoords(PlayerPedId()) - v.coords)
                if distance < 5 then
                    OpenPetShop()
                end
            elseif k == 'petstore' then
                local distance = #(GetEntityCoords(PlayerPedId()) - v.coords)
                if distance < 5 then
                    OpenShop()
                end
            end
        end
    end)
    RegisterKeyMapping('pet:interact', Config.Translations[Config.Locale].keymap_description, 'keyboard', "E")
end

-- Spawn NPC
local aiming, entity

local function IsPermit(pet)
    for _, v in pairs(Config.K9) do
        if pet then
            if v.pet == pet then
                for _, permitted in pairs(v.permit) do
                    if dusa.framework == 'qb' then 
                        if dusa.playerData.citizenid == permitted then return true end
                    else
                        if dusa.playerData.identifier == permitted then return true end
                    end
                end
            end
        else
            for _, permitted in pairs(v.permit) do
                if dusa.framework == 'qb' then 
                    if dusa.playerData.citizenid == permitted then return true end
                else
                    if dusa.playerData.identifier == permitted then return true end
                end
            end
        end
    end
    return false
end

function isPolice()
    for k, v in pairs(Config.PoliceJobs) do
        if dusa.framework == 'qb' then 
            if (dusa.playerData.job.name == k and dusa.playerData.job.grade.level >= v.grade) or IsPermit() then
                return true
            end
        else 
            if (dusa.playerData.job.name == k and dusa.playerData.job.grade >= v.grade) or IsPermit() then
                return true
            end
        end
    end
    return false
end

function k9Search()
    if PetJob[pet_model] then
        for k, v in pairs(PetJob[pet_model]) do
            if dusa.framework == 'esx' then grade = dusa.playerData.job.grade else grade = dusa.playerData.job.grade.level end 
            if dusa.playerData.job.name == k and dusa.playerData.job.grade >= v.grade then
                if DoesEntityExist(pet) then
                    attacking = true
                    if IsPlayerFreeAiming(PlayerId()) then
                        aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                        if (aiming) then
                            if IsEntityAPed(entity) then
                                TaskGoToEntity(pet, entity, -1, 2.0, petSpeed, 1073741824.0, 0)
                                dusa.showNotification(petName .. ' '..Config.Notifications[Config.Locale].willsniff, 'info')
                                searching = true
                                return entity
                            end
                        end
                    end
                end
            end
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].k9_search, 'error')
    end
end

RegisterNetEvent('dusa_pet:cl:k9search', function()
    if PetJob[pet_model] then
        for k, v in pairs(PetJob[pet_model]) do
            if dusa.framework == 'esx' then grade = dusa.playerData.job.grade else grade = dusa.playerData.job.grade.level end 
            if dusa.playerData.job.name == k and dusa.playerData.job.grade.level >= v.grade then
                if DoesEntityExist(pet) then
                    attacking = true
                    if IsPlayerFreeAiming(PlayerId()) then
                        aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                        if (aiming) then
                            if IsEntityAPed(entity) then
                                TaskGoToEntity(pet, entity, -1, 2.0, petSpeed, 1073741824.0, 0)
                                dusa.showNotification(petName .. ' '..Config.Notifications[Config.Locale].willsniff, 'info')
                                searching = true
                                return entity
                            end
                        end
                    end
                end
            end
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].k9_search, 'error')
    end
end)

function k9Attack()
    if PetJob[pet_model] then
        for k, v in pairs(PetJob[pet_model]) do
            if dusa.framework == 'esx' then grade = dusa.playerData.job.grade else grade = dusa.playerData.job.grade.level end 
            if dusa.playerData.job.name == k and grade >= v.grade then
                if DoesEntityExist(pet) then
                    stay = false
                    attacking = true
                    gotolocation = false
                    canattack = true
                    if IsPlayerFreeAiming(PlayerId()) then
                        aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                        if (aiming) then
                            if IsEntityAPed(entity) then
                                SetCanAttackFriendly(pet, true, false)
                                SetPedRelationshipGroupDefaultHash(entity, GetHashKey("CIVMALE"))
                                SetPedRelationshipGroupHash(pet, GetHashKey('COUGAR'))
                                TaskPutPedDirectlyIntoMelee(pet, entity, 0.0, -1.0, 0.0, 0)
                                dusa.showNotification(petName .. ' '..Config.Notifications[Config.Locale].willattack, 'success')
                                return entity
                            end
                        end
                    end
                end
            end
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].k9_attack, 'error')
    end
end

RegisterNetEvent('dusa_pet:cl:k9attack', function()
    local grade
    if PetJob[pet_model] then
        for k, v in pairs(PetJob[pet_model]) do
            if dusa.framework == 'esx' then grade = dusa.playerData.job.grade else grade = dusa.playerData.job.grade.level end 
            if dusa.playerData.job.name == k and grade >= v.grade then
                if DoesEntityExist(pet) then
                    stay = false
                    attacking = true
                    gotolocation = false
                    canattack = true
                    if IsPlayerFreeAiming(PlayerId()) then
                        aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                        if (aiming) then
                            if IsEntityAPed(entity) then
                                SetCanAttackFriendly(pet, true, false)
                                SetPedRelationshipGroupDefaultHash(entity, GetHashKey("CIVMALE"))
                                SetPedRelationshipGroupHash(pet, GetHashKey('COUGAR'))
                                TaskPutPedDirectlyIntoMelee(pet, entity, 0.0, -1.0, 0.0, 0)
                                dusa.showNotification(petName .. ' '..Config.Notifications[Config.Locale].willattack, 'success')
                                return entity
                            end
                        end
                    end
                end
            end
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].k9_attack, 'error')
    end
end)

function OpenShop()
    SetNuiFocus(true, true)
    for k, v in pairs(Config.Shop) do
        SendNUIMessage({
            type = "o_shop",
            action = 'open',
            shopType = k,
            dataShop = v
        })
    end
end

function PetEmote()
    if DoesEntityExist(pet) then
        SetNuiFocus(true, true)
        for k, v in pairs(Config.Emotes) do
            SendNUIMessage({
                type = "o_emote",
                action = 'open',
                menuType = k,
                menuList = v,
                name = petName,
                status = ({
                    health = petHealth,
                    hunger = petFood,
                    illness = illness
                })
            })
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].callpetfirst, 'error')
    end
end

function UpdateHud()
    SendNUIMessage({
        type = "o_hud",
        action = 'update',
        status = ({
            health = petHealth,
            hunger = petFood,
            illness = illness
        })
    })
end

function OpenWardrobe()
    if DoesEntityExist(pet) then
        SetNuiFocus(true, true)
        wardrobetimeout = true
        if not next(pet_clothes) then
            dusa.serverCallback('dusa-pets:cb:getWardrobe', function(clothes, inventory)
                pet_clothes = clothes
                SendNUIMessage({
                    type = "o_wardrobe",
                    action = 'open',
                    pet = pet_type,
                    inventory = inventory,
                    clothes = clothes
                })
            end, activePet)
        else
            dusa.serverCallback('dusa-pets:cb:getPlayerInventory', function(inventory)
                SendNUIMessage({
                    type = "o_wardrobe",
                    action = 'open',
                    pet = pet_type,
                    inventory = inventory,
                    clothes = pet_clothes
                })
            end)
        end

    else
        dusa.showNotification(Config.Notifications[Config.Locale].callpetfirst, 'error')
    end
end


local function CheckAvailableK9()
    local available_k9 = {}
    local already_added = {}

    for _, datak9 in pairs(Config.K9) do
        for job, info in pairs(datak9.jobs) do
            if dusa.framework == 'qb' then 
                if (dusa.playerData.job.name == job and dusa.playerData.job.grade.level >= info.grade) or IsPermit(datak9.pet) then
                    if not already_added[datak9] then
                        table.insert(available_k9, datak9)
                        already_added[datak9] = true
                    end
                end
            else 
                if (dusa.playerData.job.name == job and dusa.playerData.job.grade >= info.grade) or IsPermit(datak9.pet) then
                    if not already_added[datak9] then
                        table.insert(available_k9, datak9)
                        already_added[datak9] = true
                    end
                end
            end
        end
    end
    return available_k9
end

function OpenPetShop()
    local petShopPets = {}
    local pd = GetPetData('allpets')
    if pd then
        for _, petData in ipairs(pd) do
            petShopPets[petData.modelname] = true
        end
    end

    local result = {}
    for _, petData in ipairs(Config.PetShop.pets) do
        if not petShopPets[petData.pet] then
            table.insert(result, petData)
        end
    end
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "o_petshop",
        action = 'open',
        petshopData = result,
        k9data = CheckAvailableK9(),
        isPolice = isPolice()
    })
end

function OpenPetMenu()
    local result = GetPetData('allpets')
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "o_petmenu",
        action = 'open',
        petinvData = result
    })
end

local activeobject = false
local function WearItem(action, component, item)
    if action == 'wear' then
        for k, v in pairs(Config.Clothes) do
            for wi, data in pairs(v) do
                -- wi == 'rose' etc.
                if item == wi then
                    if not data.Component then
                        local hash = data.Object
                        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.0))
                        RequestModel(hash)
                        while not HasModelLoaded(hash) do
                            Citizen.Wait(0)
                        end
                        object = CreateObjectNoOffset(hash, x, y, z, true, false)
                        activeobject = item
                        SetModelAsNoLongerNeeded(hash)
                        if pet_type == "Big Dogs" or pet_type == 'big' then
                            AttachEntityToEntity(object, pet, data.PropLocation.big_dog.bone,
                                data.PropLocation.big_dog.x, data.PropLocation.big_dog.y, data.PropLocation.big_dog.z,
                                data.PropLocation.big_dog.rx, data.PropLocation.big_dog.ry,
                                data.PropLocation.big_dog.rz, true, true, false, true, 1, true)
                        elseif pet_type == "Mid Dogs" or pet_type == 'mid' then
                            AttachEntityToEntity(object, pet, data.PropLocation.mid_dog.bone,
                                data.PropLocation.mid_dog.x, data.PropLocation.mid_dog.y, data.PropLocation.mid_dog.z,
                                data.PropLocation.mid_dog.rx, data.PropLocation.mid_dog.ry,
                                data.PropLocation.mid_dog.rz, true, true, false, true, 1, true)
                        elseif pet_type == "Small Dogs" or pet_type == 'small' then
                            AttachEntityToEntity(object, pet, data.PropLocation.small_dog.bone,
                                data.PropLocation.small_dog.x, data.PropLocation.small_dog.y,
                                data.PropLocation.small_dog.z, data.PropLocation.small_dog.rx,
                                data.PropLocation.small_dog.ry, data.PropLocation.small_dog.rz, true, true, false, true,
                                1, true)
                        elseif pet_type == "Cats" then
                            AttachEntityToEntity(object, pet, data.PropLocation.cat.bone, data.PropLocation.cat.x,
                                data.PropLocation.cat.y, data.PropLocation.cat.z, data.PropLocation.cat.rx,
                                data.PropLocation.cat.ry, data.PropLocation.cat.rz, true, true, false, true, 1, true)
                        end
                    else
                        activeobject = item
                        SetPedComponentVariation(pet, data.Component, data.Variation, data.Texture, 0)
                    end
                end
            end
        end
    else
        if DoesEntityExist(object) then
            if component == activeobject then
                DeleteObject(object)
                DeleteEntity(object)
                DetachEntity(object)
                for k, v in pairs(GetGamePool('CObject')) do
                    if IsEntityAttachedToEntity(pet, v) then
                        SetEntityAsMissionEntity(v, true, true)
                        DeleteObject(v)
                        DeleteEntity(v)
                    end
                end
            end
        else
            for i = 1, 10 do
                SetPedComponentVariation(pet, i, 0, 0, 0)
            end
        end
    end
end

local function OpenHud(bool)
    if bool then
        hudstatus = true
        SendNUIMessage({
            type = "o_hud",
            action = 'open',
            status = ({
                health = petHealth,
                hunger = petFood
            })
        })
    else
        hudstatus = false
        SendNUIMessage({
            type = "o_hud",
            action = 'close'
        })
    end
end

local function PlayAction(action)
    if action == 'ball' then
        TriggerEvent('dusa-pets:cl:useBall')
    elseif action == 'follow' then
        TriggerEvent('dusa_pets:follow')
    elseif action == 'sit' or action == 'up' then
        TriggerEvent('dusa_pets:sit')
    elseif action == 'lay' then -- bend
        TriggerEvent('dusa_pets:lay')
    elseif action == 'bark' then
        TriggerEvent('dusa_pets:bark')
    elseif action == 'paw' then
        TriggerEvent('dusa_pets:paw')
    elseif action == 'dance' then
        TriggerEvent('dusa_pets:standup')
    elseif action == 'getin' then
        TriggerEvent('dusa_pets:petGetIn')
    elseif action == 'getout' then
        TriggerEvent('dusa_pets:petGetOut')
    elseif action == 'goto' then
        if DoesEntityExist(pet) then
            stay = false
            attacking = false
            gotolocation = true
            entity = nil
            dusa.showNotification(Config.Notifications[Config.Locale].goto_info, 'info')
            PingLocation(pet)
        end
    elseif action == 'attack' then
        if DoesEntityExist(pet) then
            dusa.showNotification(Config.Notifications[Config.Locale].attack_info, 'info')
            stay = false
            attacking = true
            gotolocation = false
            canattack = true
            while true do
                Citizen.Wait(0)

                local hit, coords, attackentity = RayCastGamePlayCamera(1000.0)
                if hit and IsEntityAPed(attackentity) and PlayerPedId() ~= attackentity and
                    not IsEntityDead(attackentity) and IsPedHuman(attackentity) and canattack then
                    local position = GetEntityCoords(PlayerPedId())
                    local dist = #(coords - position)
                    if dist < 30 then
                        dusa.textUI(Config.Notifications[Config.Locale].finalize_attack)
                        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 4, 253, 132, 255)
                        if IsControlJustPressed(0, 38) then
                            if dusa.framework == 'qb' then dusa.keyPressed() else dusa.hideUI() end
                            if DoesEntityExist(pet) then
                                entity = attackentity
                                SetCanAttackFriendly(pet, true, false)
                                SetPedRelationshipGroupDefaultHash(entity, GetHashKey("CIVMALE"))
                                SetPedRelationshipGroupHash(pet, GetHashKey('COUGAR'))
                                TaskPutPedDirectlyIntoMelee(pet, entity, 0.0, -1.0, 0.0, 0)
                                break
                            end
                        end
                    end
                end

                if IsControlJustPressed(0, 73) then
                    dusa.hideUI()
                    canattack = false
                    attacking = false
                    entity = nil
                    dusa.showNotification(Config.Notifications[Config.Locale].attack_canceled, 'error')
                    break
                end
            end
        end
    elseif action == 'pet' then
        TriggerEvent('dusa_pets:pet')
    elseif action == 'feed' then
        TriggerEvent('dusa_pets:feedPet')
    end
end

function ProtectPetFromEnvironment(pet, vehicle, bool)
    SetEntityInvincible(pet, bool)
    SetBlockingOfNonTemporaryEvents(pet, bool)
    SetEntityCanBeDamaged(pet, not bool)
end

function petSickness()
    Citizen.CreateThread(function()
        while true do
            if DoesEntityExist(pet) then
                if illness == 'healthy' and petHealth <= Config.HealthLimit then
                    local chance = math.random(1, 100)
                    if chance <= Config.IllnessChance then
                        illness = Config.Illnesses[math.random(#Config.Illnesses)].illness
                        TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                        dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].caught_illness..' '..illness, 'error')
                    end
                end
            else
                break
            end
            Wait(Config.IllnessInterval * 1000)
        end
    end)
end

function GetPetData(type)
    local p = nil
    p = promise.new()
    dusa.serverCallback('dusa-pets:cb:getPetData', function(result)
        p:resolve(result)
    end, type, activePet)
    return Citizen.Await(p)
end

function UpdatePet()
    Citizen.CreateThread(function()
        while true do
            if DoesEntityExist(pet) then        
                TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                OpenHud(false)
                OpenHud(true)
            else
                break
            end
            Wait(Config.UpdateInterval * 60000)
        end
    end)
end

function PetMenu()
    TriggerEvent('dusa_pets:petMenu')
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function CloseShop()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "o_shop",
        action = 'close'
    })
end

function CloseWardrobe()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "o_wardrobe",
        action = 'close',
        cleardata = false
    })
end

function CloseEmote()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "o_emote",
        action = 'close'
    })
end

function ClosePetShop()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "o_petshop",
        action = 'close'
    })
end

function ClosePetMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "o_petmenu",
        action = 'close'
    })
end

--- @param -- data.body, data.head
function SetPetClothing()
    dusa.serverCallback('dusa-pets:cb:getPetClothing', function(data)
        local data = json.decode(data.clothes)
        if data then
            for i = 1, #data do
                WearItem('wear', 'head', data[i].item_kod)
            end
        end
    end, activePet)
end

function GetObject(object)
    currentObject = object
end

local deadnotify = false
-- Main Pet Loop
function petOut()
    Citizen.CreateThread(function()
        while true do
            if DoesEntityExist(pet) then
                -- Search a Person
                petHealth = GetEntityHealth(pet) - 100
                if searching then
                    local dst = #(GetEntityCoords(pet) - GetEntityCoords(entity))
                    if dst < 10 then
                        local player, distance = dusa.getClosestPlayer()
                        if distance ~= -1 and distance <= 10 then
                            Wait(3000)
                            searching = false
                            TriggerServerEvent('dusa_pets:k9Search', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
                        end
                    end
                end
                -- K9 is Attacking
                if attacking then
                    if DoesEntityExist(entity) then
                        local entityHealth = GetEntityHealth(entity)
                        if entityHealth <= 140 then
                            attacking = false
                            entity = nil
                            local chance = math.random(1, 100)
                            if chance <= Config.IllnessChance then
                                illness = Config.Illnesses[math.random(#Config.Illnesses)].illness
                                TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                                dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].caught_illness..' '..illness, 'error')        
                            end
                            SetPedRelationshipGroupHash(pet, GetHashKey('PET'))
                        end
                    end
                end
                -- Chase ball if it was thrown
                if ballThrown then
                    local speed = GetEntitySpeed(pet)
                    local dst3 = #(GetEntityCoords(pet) - GetEntityCoords(ballObj))
                    if speed <= 0 then
                        TaskGoToEntity(pet, ballObj, -1, 2.0, petSpeed, 1073741824.0, 0)
                        stay = false
                        feeding = false
                        if dst3 < 2 then
                            -- DeleteEntity(ballObj)

                            AttachEntityToEntity(ballObj, pet, 57, 0.16803031647964, -0.051084017667257,
                                0.0040759411623455, 0, 0, 0, true, true, false, true, 1, true)
                            ballThrown = false
                            petMoving = false
                            chasing = false
                            returnBall = true
                        end
                    end
                end
                -- If pet has an illness, lower health or other things
                if illness ~= "healthy" and petHealth > 0 then
                    for i = 1, #Config.Illnesses do
                        if illness == Config.Illnesses[i].illness then
                            petHealth = petHealth - Config.Illnesses[i].damage
                            SetEntityHealth(pet, GetEntityHealth(pet) - (Config.Illnesses[i].damage))
                        end
                    end
                end
                -- If Health less/equal to 0 then kill pet
                if (GetEntityHealth(pet) <= 100 or petHealth <= 0) and not revived and not deadnotify then
                    SetEntityInvincible(pet, false)
                    SetEntityHealth(pet, 0)
                    SetFlash(0, 0, 100, 3000, 100)
                    petHealth = 0
                    dusa.showNotification(Config.Notifications[Config.Locale].dead_revive, 'error')
                    TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                    deadnotify = true
                    AttachTempRope('delete')
                    UpdateHud()
                end

                -- If Pet is Alive, Take Food Away
                if petHealth > 0 then
                    -- petHealth = GetEntityHealth(pet) - 100
                    if petFood > 0 then
                        petFood = petFood - Config.ReduceHunger
                        UpdateHud()
                    else
                        -- If Food is less then 0, Take Health away
                        petHealth = petHealth - .5
                        SetEntityHealth(pet, GetEntityHealth(pet) - .5)
                        UpdateHud()
                    end
                end
                -- Feeding & Moving to Bowl
                if feeding and not petMoving then
                    petMoving = true
                    stay = false
                    TaskGoToEntity(pet, mamaobj, -1, 2.0, petSpeed, 1073741824.0, 0)
                    local dst2 = #(GetEntityCoords(pet) - GetEntityCoords(mamaobj))
                    if dst2 < 3 then
                        if PetTable[pet_model].dictionary.eat then
                            LoadAnimDict(PetTable[pet_model].dictionary.eat)
                            TaskPlayAnim(pet, PetTable[pet_model].dictionary.eat, PetTable[pet_model].animation.eat,
                                8.0, -8, -1, 1, 0, false, false, false)
                        else
                            LoadAnimDict(PetTable[pet_model].dictionary.sit)
                            TaskPlayAnim(pet, PetTable[pet_model].dictionary.sit, PetTable[pet_model].animation.sit,
                                3.0, -8, -1, 1, 0, false, false, false)
                        end
                        Wait(5000)
                        TriggerServerEvent('dusa_objects:server:DeleteObject', mamaobj)
                        DeleteObject(mamaobj)
                        DeleteEntity(mamaobj)
                        dusa.showNotification(Config.Notifications[Config.Locale].eaten_food, 'hunger')
                        petFood = 100
                        feeding = false
                        petMoving = false
                        ClearPedTasks(pet)
                        UpdateHud()
                    end
                end

                -- Move & Stay
                local dst = #(GetEntityCoords(pet) - GetEntityCoords(PlayerPedId()))
                if dst > 4 and not petMoving and not stay and not feeding and not chasing and not attacking and
                    not gotolocation and not commanded and not searching then
                    petMoving = true
                    TaskGoToEntity(pet, PlayerPedId(), -1, 1.0, petSpeed, 1073741824.0, 0)
                elseif dst < 4 then
                    petMoving = false
                    if returnBall then
                        -- bura
                        DetachEntity(ballObj)
                        DeleteEntity(ballObj)
                        TriggerServerEvent('dusa-pets:addItem', 'tennisball', 1) 
                        returnBall = false
                    end
                end

                if dst > Config.MaxDistanceToPet then
                    dusa.showNotification(Config.Notifications[Config.Locale].too_faraway, 'info')
                    TriggerEvent('dusa-pets:cl:spawnpet', activePet)
                    SendNUIMessage({
                        type = "o_petmenu",
                        action = 'sendPet'
                    })
                    break;
                end

            else
                break
            end
            Wait(2000)
        end
    end)
end

---------------------------EVENTS------------------------------
---------------------------------------------------------------
RegisterNetEvent('dusa-pets:cl:spawnpet')
AddEventHandler('dusa-pets:cl:spawnpet', function(modelname)
    if DoesEntityExist(pet) then
        TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
        DeleteEntity(pet)
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
        OpenHud(false)
        AttachTempRope('delete')
        pet = nil
        activePet = nil
        pet_type = false
        pet_clothes = {}
    else
        local playerCoords = GetEntityCoords(PlayerPedId())
        local hash = modelname
        local playerPed = PlayerPedId()
        local playerGroup = GetPedGroupIndex(playerPed)
        local spawnCoord = getSpawnLocation(playerPed)
        Citizen.CreateThread(function() 
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                Wait(10)
            end
            while not HasModelLoaded(hash) do
                Wait(10)
            end
            pet = CreatePed(28, hash, spawnCoord.x + 1, spawnCoord.y + 1, spawnCoord.z - 1, 1, 1)
            -- SetModelAsNoLongerNeeded(hash)
            AddRelationshipGroup('PET')
            AddRelationshipGroup('OWNER')
            SetPedRelationshipGroupHash(pet, GetHashKey('PET'))
            SetPedRelationshipGroupHash(playerPed, GetHashKey('OWNER'))
            SetRelationshipBetweenGroups(0, GetHashKey("PET"), GetHashKey('OWNER'))
        end)

        dusa.serverCallback('dusa-pets:cb:getPetData', function(result)
            illness = result.illnesses
            petHealth = result.health
        end, 'status', activePet)

        Wait(500)
        SetEntityHealth(pet, (petHealth + 100))

        petOut()
        petSickness()
        UpdatePet()

        -- Remove all random clothes
        for i = 1, 10 do
            SetPedComponentVariation(pet, i, 0, 0, 0)
        end
        SetPetClothing()
        OpenHud(true)
        local petModel = GetEntityModel(pet)

        for type, pets in pairs(Config.Pets) do
            for k, v in pairs(pets) do
                if petModel == GetHashKey(k) then
                    pet_type = type
                    pet_model = hash
                    PetTable[k] = v
                end
            end
        end

        for k, v in pairs(Config.K9) do
            if GetHashKey(v.pet) == petModel then
                pet_type = 'dog'
                pet_model = hash
                PetTable[v.pet] = v.animations
                PetJob[v.pet] = v.jobs
            end
        end
    end
end)

RegisterNetEvent('dusa_pets:cl:loadModels', function()
    for _, v in pairs(Config.PetShop.pets) do
        if not HasModelLoaded(v.pet) then
            RequestModel(v.pet)
            Wait(10)
        end
        while not HasModelLoaded(v.pet) do
            Wait(10)
        end
    end
end)

RegisterNetEvent('dusa-pets:cl:useBall')
AddEventHandler('dusa-pets:cl:useBall', function()
    dusa.serverCallback('dusa-pets:cb:checkItem', function(check)
        if check then
            local hash = 'prop_tennis_ball'
            local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.0))
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Citizen.Wait(0)
            end
            ballObj = CreateObjectNoOffset(hash, x, y, z, true, false)
            SetModelAsNoLongerNeeded(hash)
            AttachEntityToEntity(ballObj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.15, 0, 0, 0, 270.0, 60.0,
                true, true, false, true, 1, true) -- object is attached to right hand 
            local forwardVector = GetEntityForwardVector(PlayerPedId())
            local force = 50.0
            local animDict = "melee@unarmed@streamed_variations"
            local anim = "plyr_takedown_front_slap"
            ClearPedTasks(PlayerPedId())
            while (not HasAnimDictLoaded(animDict)) do
                RequestAnimDict(animDict)
                Citizen.Wait(5)
            end
            TaskPlayAnim(PlayerPedId(), animDict, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
            Wait(500)
            DetachEntity(ballObj)
            ApplyForceToEntity(ballObj, 1, forwardVector.x * force, forwardVector.y * force + 5.0, forwardVector.z, 0, 0, 0, 0,
                false, true, true, false, true)
            ballID = ObjToNet(ballObj)
            SetNetworkIdExistsOnAllMachines(ballObj, true)
            ballThrown = true
            chasing = true
            TriggerServerEvent('dusa-pets:removeItem', 'tennisball', 1)        
        else
            dusa.showNotification(Config.Notifications[Config.Locale].donthave_tennis, 'error')
        end
    end, 'tennisball', 1)
end)

RegisterNetEvent('dusa_pets:petGetIn')
AddEventHandler('dusa_pets:petGetIn', function()
    local vehicle
    if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
        vehicle = GetVehiclePedIsIn(PlayerPedId())
        distance = 1
    else
        vehicle, distance = dusa.getClosestVehicle(GetEntityCoords(PlayerPedId()))
    end
    petvehicle = not petvehicle
    if petvehicle then
        if vehicle ~= 0 and distance < 7 then
            if PetTable[pet_model].dictionary.getin then
                SetVehicleDoorOpen(vehicle, 1, false, false)
                ProtectPetFromEnvironment(pet, vehicle, true)
                Wait(1000)
                TaskEnterVehicle(pet, vehicle, -1, 0, 2.0, 3)
                CreateThread(function()
                    while true do
                        local dist = #(GetEntityCoords(vehicle) - GetEntityCoords(pet))
                        if dist < 1 then
                            ClearPedTasks(pet)
                            Wait(100)
                            makeEntityFaceEntity(pet, vehicle)
                            LoadAnimDict(PetTable[pet_model].dictionary.getin)
                            TaskPlayAnim(pet, PetTable[pet_model].dictionary.getin, PetTable[pet_model].animation.getin,
                                3.0, -8, -1, 0, 0, false, false, false)
                            Wait(2000)
                            SetPedIntoVehicle(pet, vehicle, 0)
                            ClearPedTasks(pet)
                            LoadAnimDict(PetTable[pet_model].dictionary.carsit)
                            TaskPlayAnim(pet, PetTable[pet_model].dictionary.carsit, PetTable[pet_model].animation.carsit,
                                3.0, -8, -1, 1, 0, false, false, false)
                            SetVehicleDoorShut(vehicle, 1, false)
                            Wait(3000)
                            ProtectPetFromEnvironment(pet, vehicle, false)
                            break
                        end
                        Wait(1)
                    end
                end)
            else
                TaskWarpPedIntoVehicle(pet, vehicle, -2)
                Wait(500)
                ClearPedTasks(pet)
                LoadAnimDict(PetTable[pet_model].dictionary.sit)
                TaskPlayAnim(pet, PetTable[pet_model].dictionary.sit, PetTable[pet_model].animation.sit, 3.0, -8, -1, 1, 0,
                    false, false, false)
            end
        else
            dusa.showNotification(Config.Notifications[Config.Locale].noveh_nearby, 'error')
        end
    else
        if vehicle ~= 0 and distance < 7 then
            if PetTable[pet_model].dictionary.getout then
                SetVehicleDoorOpen(vehicle, 1, false, false)
                ProtectPetFromEnvironment(pet, vehicle, true)
                Wait(1000)
                TaskLeaveVehicle(pet, vehicle, 256)
                ClearPedTasksImmediately(pet)
                Wait(100)
                LoadAnimDict(PetTable[pet_model].dictionary.getout)
                TaskPlayAnim(pet, PetTable[pet_model].dictionary.getout, PetTable[pet_model].animation.getout, 3.0, -8, -1, 0,
                    0, false, false, false)
                Wait(3000)
                ProtectPetFromEnvironment(pet, vehicle, false)
            else
                TaskLeaveVehicle(pet, vehicle, 16)
            end
        else
            dusa.showNotification(Config.Notifications[Config.Locale].noveh_nearby, 'error')
        end
    end
end)

RegisterNetEvent('dusa_pets:feedPet')
AddEventHandler('dusa_pets:feedPet', function()
    if not DoesEntityExist(bowlObj) then
        bendAnimation()
        bowlhash = 'prop_bowl_crisps'
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.0))
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end
        bowlObj = CreateObjectNoOffset(hash, x, y, z, true, false)
        PlaceObjectOnGroundProperly(bowlObj)
        SetModelAsNoLongerNeeded(hash)
        feeding = true
    end
end)

RegisterNetEvent('dusa_pets:sit')
RegisterNetEvent('dusa_pets:lay')
RegisterNetEvent('dusa_pets:follow')
RegisterNetEvent('dusa_pets:bark')
RegisterNetEvent('dusa_pets:paw')
RegisterNetEvent('dusa_pets:pet')
RegisterNetEvent('dusa_pets:k9ItemCheck')

RegisterNetEvent('dusa_pets:refreshbed', function()
    sleeping = false
    sitting = false
end)

AddEventHandler('dusa_pets:follow', function()
    if sleeping or sitting then
        dusa.showNotification(petName ..' '.. Config.Notifications[Config.Locale].petisinbed, 'success')
    else
        stay, attacking, chasing, searching, sleeping, gotolocation, commanded, sitting, canattack = false, false, false,
            false, false, false, false, false, false
        entity = nil
        ClearPedTasks(pet)
        dusa.showNotification(petName ..' '.. Config.Notifications[Config.Locale].following, 'success')
    end
end)

AddEventHandler('dusa_pets:sit', function()
    sitting = not sitting
    if PetTable[pet_model].animation.sit then
        if sitting then
            stay = true
            attacking = false
            entity = nil
            ClearPedTasks(pet)
            LoadAnimDict(PetTable[pet_model].dictionary.sit)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.sit, PetTable[pet_model].animation.sit, 3.0, -8, -1, 1, 0,
                false, false, false)
        else
            stay = false
            attacking = false
            entity = nil
            if PetTable[pet_model].animation.up then
                LoadAnimDict(PetTable[pet_model].dictionary.up)
                TaskPlayAnim(pet, PetTable[pet_model].dictionary.up, PetTable[pet_model].animation.up, 8.0, -8, -1, 0, 0,
                false, false, false)
            else
                ClearPedTasks(pet)
            end
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].cant_animate, 'error')
    end
end)

AddEventHandler('dusa_pets:lay', function()
    sleeping = not sleeping
    if PetTable[pet_model].animation.sleep then
        if sleeping then
            stay = false
            attacking = false
            entity = nil
            ClearPedTasks(pet)
            LoadAnimDict(PetTable[pet_model].dictionary.sleep)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.sleep, PetTable[pet_model].animation.sleep, 8.0, -8, -1, 1,
                0, false, false, false)
        else
            -- ClearPedTasks(pet)
            LoadAnimDict(PetTable[pet_model].dictionary.wake)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.wake, PetTable[pet_model].animation.wake, 8.0, -8, -1, 0,
                0, false, false, false)
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].cant_animate, 'error')
    end
end)

AddEventHandler('dusa_pets:bark', function()
    barking = not barking
    if PetTable[pet_model].animation.bark then
        if barking then
            stay = false
            attacking = false
            entity = nil
            ClearPedTasks(pet)
            LoadAnimDict(PetTable[pet_model].dictionary.bark)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.bark, PetTable[pet_model].animation.bark, 8.0, -8, -1, 1,
                0, false, false, false)
        else
            ClearPedTasks(pet)
            LoadAnimDict(PetTable[pet_model].dictionary.stopbark)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.stopbark, PetTable[pet_model].animation.stopbark, 8.0, -8,
                -1, 0, 0, false, false, false)
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].cant_animate, 'error')
    end
end)

AddEventHandler('dusa_pets:paw', function()
    paw = not paw
    if PetTable[pet_model].animation.paw then
        if paw then
            stay = false
            attacking = false
            entity = nil
            ClearPedTasks(pet)
            LoadAnimDict(PetTable[pet_model].dictionary.tricks)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.tricks, PetTable[pet_model].animation.paw, 8.0, -8, -1, 1,
                0, false, false, false)
        else
            LoadAnimDict(PetTable[pet_model].dictionary.tricks)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.tricks, PetTable[pet_model].animation.stoppaw, 8.0, -8, -1,
                0, 0, false, false, false)
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].cant_animate, 'error')
    end
end)

AddEventHandler('dusa_pets:standup', function()
    standup = not standup
    if PetTable[pet_model].animation.dance then
        if standup then
            stay = false
            attacking = false
            entity = nil
            ClearPedTasks(pet)
            LoadAnimDict(PetTable[pet_model].dictionary.tricks)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.tricks, PetTable[pet_model].animation.dance, 8.0, -8, -1,
                1, 0, false, false, false)
        else
            LoadAnimDict(PetTable[pet_model].dictionary.tricks)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.tricks, PetTable[pet_model].animation.stopdance, 8.0, -8,
                -1, 0, 0, false, false, false)
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].cant_animate, 'error')
    end
end)

AddEventHandler('dusa_pets:pet', function()
    petchop = not petchop
    local playerPed = PlayerPedId()
    if petchop then
        stay = false
        attacking = false
        entity = nil
        LoadAnimDict(PetTable[pet_model].dictionary.tricks)

        makeEntityFaceEntity(PlayerPedId(), pet)
        makeEntityFaceEntity(pet, PlayerPedId())

        local coords = GetEntityCoords(playerPed)
        local forward = GetEntityForwardVector(playerPed)
        local x, y, z = table.unpack(coords + forward * 1.0)

        SetEntityCoords(pet, x, y, z, 0, 0, 0, 0)
        TaskPause(pet, 5000)
        TaskPlayAnim(playerPed, PetTable[pet_model].dictionary.tricks, 'petting_franklin', 8.0, -8, -1, 0, 0, false,
            false, false)
        if pet_type ~= 'Cats' then
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.tricks, 'petting_chop', 8.0, -8, -1, 0, 0, false, false, false)
        end
    else
        ClearPedTasks(playerPed)
        ClearPedTasks(pet)
    end
end)

AddEventHandler('dusa_pets:k9ItemCheck', function(itemfound)
    if itemfound then
        dusa.showNotification(Config.Notifications[Config.Locale].k9_found, 'error')
        if PetTable[pet_model].animation.bark then
            ClearPedTasks(pet)
            LoadAnimDict(PetTable[pet_model].dictionary.bark)
            TaskPlayAnim(pet, PetTable[pet_model].dictionary.bark, PetTable[pet_model].animation.bark, 8.0, -8, -1, 1,
                0, false, false, false)
            Wait(3000)
            ClearPedTasks(pet)
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].k9_nofound, 'error')
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Keybinds) do
        RegisterKeyMapping(v.command, v.description, "keyboard", v.key)
        if v.func then
            RegisterCommand(v.command, v.func, false)
        end
        if k == 'movehud' then
            RegisterCommand(v.command, function(source, args)
                if hudstatus then
                    SetNuiFocus(true, true)
                end
            end)
        end
        TriggerEvent("chat:addSuggestion", "/"..v.command)
    end
end)

RegisterNetEvent('dusa-pets:bed:sleep', function(data)
    local odata = data
    commanded = true
    TaskGoToEntity(pet, odata.entity, -1, 1, petSpeed, 1073741824.0, 0)
    CreateThread(function()
        while true do
            local dist = #(GetEntityCoords(pet) - GetEntityCoords(odata.entity))
            if dist < 1.5 then
                AttachEntityToEntity(pet, odata.entity, 57, 0.1, 0.0, 0.6, 0.1, 0.2, 125.5, true, true, false, true, 1,
                    true)
                ClearPedTasks(pet)
                SetEntityInvincible(pet, true)
                SetBlockingOfNonTemporaryEvents(pet, true)
                sleeping = true
                stay = false
                attacking = false
                entity = nil
                if PetTable[pet_model].dictionary.sleep then
                    LoadAnimDict(PetTable[pet_model].dictionary.sleep)
                    TaskPlayAnim(pet, PetTable[pet_model].dictionary.sleep, PetTable[pet_model].animation.sleep, 8.0, -8,
                        -1, 1, 0, false, false, false)
                else
                    dusa.showNotification(Config.Notifications[Config.Locale].cant_animate, 'error')
                end
                commanded = false
                break
            end
            Wait(1)
        end
    end)
end)

RegisterNetEvent('dusa-pets:bed:sit', function(data)
    local odata = data
    commanded = true
    TaskGoToEntity(pet, odata.entity, -1, 1, petSpeed, 1073741824.0, 0)
    CreateThread(function()
        while true do
            local dist = #(GetEntityCoords(pet) - GetEntityCoords(odata.entity))
            if dist < 1.5 then
                AttachEntityToEntity(pet, odata.entity, 57, 0.1, 0.0, 0.6, 0.1, 0.2, 125.5, true, true, false, true, 1,
                    true)
                ClearPedTasks(pet)
                SetEntityInvincible(pet, true)
                SetBlockingOfNonTemporaryEvents(pet, true)
                sitting = true
                stay = true
                attacking = false
                entity = nil
                ClearPedTasks(pet)
                LoadAnimDict(PetTable[pet_model].dictionary.sit)
                TaskPlayAnim(pet, PetTable[pet_model].dictionary.sit, PetTable[pet_model].animation.sit, 3.0, -8, -1, 1,
                    0, false, false, false)
                commanded = false
                break
            end
            Wait(1)
        end
    end)
end)

RegisterNetEvent('dusa-pets:bed:out', function(data)
    local odata = data
    commanded = false
    stay = false
    attacking = false
    sleeping = false
    sitting = false
    entity = nil
    DetachEntity(pet)
    SetEntityInvincible(pet, false)
    ClearPedTasks(pet)
end)

RegisterNUICallback('itemData', function(data)
    local newD = data.data
    local total = 0
    for i = 1, #newD do
        if newD[i] then
            if dusa.framework == 'esx' then
                dusa.serverCallback('dusa-pets:cb:checkMoney', function(check)
                    if check then
                        TriggerServerEvent('dusa-pets:addItem', newD[i].item, newD[i].count)
                        TriggerServerEvent('dusa-pets:manipulateMoney', 'remove', data.account, newD[i].totalPrice)
                    else
                        if data.account == 'cash' then dusa.showNotification(Config.Notifications[Config.Locale].not_enough_cash, 'error')
                        else dusa.showNotification(Config.Notifications[Config.Locale].not_enough_bank, 'error') end
                    end
                end, newD[i].totalPrice, data.account)
            else
                if data.account == 'card' then
                    if dusa.playerData.money["bank"] >= newD[i].totalPrice then
                        TriggerServerEvent('dusa-pets:addItem', newD[i].item, newD[i].count)
                        TriggerServerEvent('dusa-pets:manipulateMoney', 'remove', data.account, newD[i].totalPrice)
                    else
                        dusa.showNotification(Config.Notifications[Config.Locale].not_enough_bank, 'error')
                    end
                else
                    if dusa.playerData.money["cash"] >= newD[i].totalPrice then
                        TriggerServerEvent('dusa-pets:addItem', newD[i].item, newD[i].count)
                        TriggerServerEvent('dusa-pets:manipulateMoney', 'remove', data.account, newD[i].totalPrice)
                    else
                        dusa.showNotification(Config.Notifications[Config.Locale].not_enough_cash, 'error')
                    end
                end
            end
            total = total + newD[i].totalPrice
        end
    end
    if total > 0 then
        dusa.showNotification(Config.Notifications[Config.Locale].totalpaid..' '..total, 'info')
        CloseShop()
    else
        dusa.showNotification(Config.Notifications[Config.Locale].basket_empty, 'error')
    end
end)

RegisterNUICallback('wearItem', function(data)
    if data.action == 'wear' then
        WearItem('wear', 'head', data.item)
    elseif data.action == 'takeoff' then
        -- burada tüm itemleri çıkarır, bunu iteme özel yapmalı
        WearItem(false, data.item)
    end
    pet_clothes = data.currentData
end)

RegisterNUICallback('saveItem', function(data)
    local clothes = {}
    if data.clothes[1].item[1] then
        table.insert(clothes, data.clothes[1].item[1])
    end
    if data.clothes[2].item[1] then
        table.insert(clothes, data.clothes[2].item[1])
    end
    TriggerServerEvent('dusa-pets:sv:saveClothes', clothes, activePet)
end)

RegisterNUICallback('closeUI', function()
    CloseShop()
    CloseWardrobe()
    CloseEmote()
    ClosePetShop()
end)

RegisterNUICallback('playAction', function(data)
    PlayAction(data.action)
end)

RegisterNUICallback('deletePet', function(data)
    TriggerServerEvent('dusa_pets:sv:removePet', data.pet.pet_code)
    dusa.showNotification(data.pet.name ..' '..Config.Notifications[Config.Locale].released_pet, 'success')
    -- uzaklaş
    DeleteEntity(pet)
end)

-- PREVIEW

function CreateCamera()
    -- RequestCollisionAtCoord(x, y, z)
    DoScreenFadeOut(1000)
    Wait(1000)
    DoScreenFadeIn(250)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.PreviewCoords.CamCoords.x, Config.PreviewCoords.CamCoords.y, Config.PreviewCoords.CamCoords.z, 0.00, 0.00, 0.00, 50.00, false, 0)
    PointCamAtCoord(cam, Config.PreviewCoords.petCoords.x, Config.PreviewCoords.petCoords.y, Config.PreviewCoords.petCoords.z)
    SetFocusPosAndVel(Config.PreviewCoords.FocusCoords.x, Config.PreviewCoords.FocusCoords.y, Config.PreviewCoords.FocusCoords.z, 0.0, 0.0, 0.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1, true, true)
    DisplayHud(false)
    DisplayRadar(false)
end

RegisterNUICallback('previewPet', function(data)
    -- data.pet
    if DoesEntityExist(previewPet) then
        DeleteEntity(previewPet)
    else
        local preview = data.pet
        if not HasModelLoaded(preview) then
            RequestModel(preview)
            Wait(10)
        end
        while not HasModelLoaded(preview) do
            Wait(10)
        end
        previewPet = CreatePed(28, preview, Config.PreviewCoords.petCoords.x, Config.PreviewCoords.petCoords.y, Config.PreviewCoords.petCoords.z, Config.PreviewCoords.heading, 0)
        SetModelAsNoLongerNeeded(preview)
        CreateCamera()
    end
end)

RegisterNUICallback("rotate", function(data, cb)
    if (data["key"] == "left") then
        rotation(5)
    else
        rotation(-5)
    end
    cb("ok")
end)

function rotation(dir)
    local entityRot = GetEntityHeading(previewPet) + dir
    SetEntityHeading(previewPet, entityRot % 360)
end

RegisterNUICallback('destroyPreview', function()
    DoScreenFadeOut(1000)
    Wait(1000)
    DoScreenFadeIn(250)
    if DoesEntityExist(previewPet) then
        DeleteEntity(previewPet)
    end
    RenderScriptCams(false)
    DestroyAllCams(true)
    SetFocusEntity(GetPlayerPed(PlayerId()))
    DisplayHud(true)
    DisplayRadar(true)
end)

-- BUY PET
RegisterNUICallback('buyPet', function(data)
    TriggerServerEvent('dusa_pets:sv:buyPet', data.cart, data.price, 'dog', data.type)
end)

-- CALL / SEND PET
RegisterNUICallback('callPet', function(data)
    if not DoesEntityExist(pet) then
        LoadAnimDict('rcmnigel1c')
        TaskPlayAnim(PlayerPedId(), 'rcmnigel1c', 'hailing_whistle_waive_a', 8.0, -8, -1, 0, 0, false, false, false)
    end
    petName = data.pet.name
    activePet = data.pet.pet_code
    deadnotify = false
    TriggerEvent('dusa-pets:cl:spawnpet', data.pet.pet_code)
end)

RegisterNetEvent('dusa_pets:cl:petbought', function()
    ClosePetShop()
end)

RegisterNetEvent('dusa_pets:cl:onOwnerDeath', function()
    if DoesEntityExist(pet) then
        dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].pet_went, 'info')
        TriggerEvent('dusa-pets:cl:spawnpet', activePet)
        SendNUIMessage({
            type = "o_petmenu",
            action = 'sendPet'
        })
    end
end)

------------------------TREAT ITEMS----------------------------
---------------------------------------------------------------
RegisterNetEvent('dusa_pets:cl:treatpet')
AddEventHandler('dusa_pets:cl:treatpet', function(item)
    if DoesEntityExist(pet) then
        local dist = #(GetEntityCoords(pet) - GetEntityCoords(PlayerPedId()))
        if dist < 4 then
            if petHealth > 0 and petHealth < 100 then
                -- Treatment Kit Item
                if item == 'treatmentkit' then
                    stay = true
                    ClearPedTasksImmediately(pet)
                    makeEntityFaceEntity(pet, PlayerPedId())
                    if PetTable[pet_model].dictionary.sleep then
                        LoadAnimDict(PetTable[pet_model].dictionary.sleep)
                        TaskPlayAnim(pet, PetTable[pet_model].dictionary.sleep, PetTable[pet_model].animation.sleep, 8.0, -8, -1, 1, 0, false, false, false)
                    else
                        LoadAnimDict(PetTable[pet_model].dictionary.sit)
                        TaskPlayAnim(pet, PetTable[pet_model].dictionary.sit, PetTable[pet_model].animation.sit, 8.0, -8, -1, 1, 0, false, false, false)
                    end
                    FreezeEntityPosition(pet, true)
                    LoadAnimDict('amb@medic@standing@kneel@base')
                    TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
                    if Config.Progressbar == 'ox_lib' then   
                        if lib.progressCircle({
                            duration = 10000,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true
                            },
                            anim = {
                                dict = 'anim@gangops@facility@servers@bodysearch@',
                                clip = 'player_search'
                            },
                            prop = {
                                model = 'prop_syringe_01', --xm_prop_smug_crate_s_medical v_med_latexgloveboxred prop_syringe_01
                                pos = vec3(0.03, 0.03, 0.02),
                                rot = vec3(0.0, 0.0, -1.5)
                            }
                        }) then
                            stay = false
                            FreezeEntityPosition(pet, false)
                            if PetTable[pet_model].dictionary.wake then
                                LoadAnimDict(PetTable[pet_model].dictionary.wake)
                                TaskPlayAnim(pet, PetTable[pet_model].dictionary.wake, PetTable[pet_model].animation.wake, 8.0, -8, -1, 0,
                                    0, false, false, false)
                            else
                                LoadAnimDict(PetTable[pet_model].dictionary.up)
                                TaskPlayAnim(pet, PetTable[pet_model].dictionary.up, PetTable[pet_model].animation.up, 8.0, -8, -1, 0, 0,
                                    false, false, false)
                            end
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].treated_success, 'success')
                            petSpeed = 10.0
                            ReviveInjuredPed(pet)
                            SetEntityHealth(pet, 200)
                            petHealth = 100
                            TriggerServerEvent('dusa-pets:removeItem', item, 1) 
                            OpenHud(false)
                            OpenHud(true)
                            TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                        else
                            stay = false
                            FreezeEntityPosition(pet, false)
                            ClearPedTasks(pet)
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(Config.Notifications[Config.Locale].treatment_aborted, 'info')
                        end
                    else
                        QBCore.Functions.Progressbar("treatmentkit", 'Treating..', 10000, false, false, {
                            disableMovement = false,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true
                        }, {
                            animDict = "anim@gangops@facility@servers@bodysearch@",
                            anim = "player_search",
                        }, {}, {}, function() -- Done
                            stay = false
                            FreezeEntityPosition(pet, false)
                            if PetTable[pet_model].dictionary.wake then
                                LoadAnimDict(PetTable[pet_model].dictionary.wake)
                                TaskPlayAnim(pet, PetTable[pet_model].dictionary.wake, PetTable[pet_model].animation.wake, 8.0, -8, -1, 0,
                                    0, false, false, false)
                            else
                                LoadAnimDict(PetTable[pet_model].dictionary.up)
                                TaskPlayAnim(pet, PetTable[pet_model].dictionary.up, PetTable[pet_model].animation.up, 8.0, -8, -1, 0, 0,
                                    false, false, false)
                            end
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].treated_success, 'success')
                            petSpeed = 10.0
                            ReviveInjuredPed(pet)
                            SetEntityHealth(pet, 200)
                            petHealth = 100
                            TriggerServerEvent('dusa-pets:removeItem', item, 1) 
                            OpenHud(false)
                            OpenHud(true)
                            TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                        end, function()
                            stay = false
                            FreezeEntityPosition(pet, false)
                            ClearPedTasks(pet)
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(Config.Notifications[Config.Locale].treatment_aborted, 'info')
                        end)
                    end
                end
            -- Magic Revive Item
            elseif petHealth <= 0 then
                if item == 'revivekit' then
                    stay = true
                    makeEntityFaceEntity(pet, PlayerPedId())
                    FreezeEntityPosition(pet, true)
                    LoadAnimDict('amb@medic@standing@kneel@base')
                    TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)     
                    if Config.Progressbar == 'ox_lib' then   
                        if lib.progressCircle({
                            duration = 20000,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true
                            },
                            anim = {
                                dict = 'anim@gangops@facility@servers@bodysearch@',
                                clip = 'player_search'
                            },
                            prop = {
                                model = 'prop_syringe_01',
                                pos = vec3(0.03, 0.03, 0.02),
                                rot = vec3(0.0, 0.0, -1.5)
                            }
                        }) then
                            stay = false
                            FreezeEntityPosition(pet, false)
                            ClearPedTasks(pet)
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].revived_success, 'success')
                            petSpeed = 10.0
                            -- Despawn pet after revive
                            if DoesEntityExist(pet) then
                                DeleteEntity(pet)
                            end
                            Wait(1000)
                            local hash = activePet
                            local playerPed = PlayerPedId()
                            local spawnCoord = getSpawnLocation(playerPed)
                            if not HasModelLoaded(hash) then
                                RequestModel(hash)
                                Wait(10)
                            end
                            while not HasModelLoaded(hash) do
                                Wait(10)
                            end
                            revivedpet = CreatePed(28, hash, spawnCoord.x + 1, spawnCoord.y + 1, spawnCoord.z - 1, 1, 1)
                            pet = revivedpet
                            Wait(500)
                            petHealth = 100
                            SetEntityHealth(pet, 200)
                            revived = true
                            deadnotify = false
                            ReviveInjuredPed(pet)
                            petOut()
                            OpenHud(false)
                            OpenHud(true)
                            TriggerServerEvent('dusa-pets:removeItem', item, 1) 
                            TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                            for i = 1, 10 do
                                SetPedComponentVariation(pet, i, 0, 0, 0)
                            end
                            SetPetClothing()
                            Wait(5000)
                            AddRelationshipGroup('PET')
                            AddRelationshipGroup('OWNER')
                            SetPedRelationshipGroupHash(pet, GetHashKey('PET'))
                            SetPedRelationshipGroupHash(playerPed, GetHashKey('OWNER'))
                            SetRelationshipBetweenGroups(0, GetHashKey("PET"), GetHashKey('OWNER'))
                            revived = false
                            ballThrown = false
                            chasing = false
                        else
                            stay = false
                            FreezeEntityPosition(pet, false)
                            ClearPedTasks(pet)
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(Config.Notifications[Config.Locale].treatment_aborted, 'info')
                        end
                    else
                        QBCore.Functions.Progressbar("revive", 'Reviving', 20000, false, false, {
                            disableMovement = false,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true
                        }, {
                            animDict = "anim@gangops@facility@servers@bodysearch@",
                            anim = "player_search",
                        }, {}, {}, function() -- Done
                            stay = false
                            FreezeEntityPosition(pet, false)
                            ClearPedTasks(pet)
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].revived_success, 'success')
                            petSpeed = 10.0
                            -- Despawn pet after revive
                            if DoesEntityExist(pet) then
                                DeleteEntity(pet)
                            end
                            Wait(1000)
                            local hash = activePet
                            local playerPed = PlayerPedId()
                            local spawnCoord = getSpawnLocation(playerPed)
                            if not HasModelLoaded(hash) then
                                RequestModel(hash)
                                Wait(10)
                            end
                            while not HasModelLoaded(hash) do
                                Wait(10)
                            end
                            revivedpet = CreatePed(28, hash, spawnCoord.x + 1, spawnCoord.y + 1, spawnCoord.z - 1, 1, 1)
                            pet = revivedpet
                            Wait(500)
                            petHealth = 100
                            SetEntityHealth(pet, 200)
                            revived = true
                            deadnotify = false
                            ReviveInjuredPed(pet)
                            petOut()
                            OpenHud(false)
                            OpenHud(true)
                            TriggerServerEvent('dusa-pets:removeItem', item, 1) 
                            TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                            for i = 1, 10 do
                                SetPedComponentVariation(pet, i, 0, 0, 0)
                            end
                            SetPetClothing()
                            Wait(5000)
                            AddRelationshipGroup('PET')
                            AddRelationshipGroup('OWNER')
                            SetPedRelationshipGroupHash(pet, GetHashKey('PET'))
                            SetPedRelationshipGroupHash(playerPed, GetHashKey('OWNER'))
                            SetRelationshipBetweenGroups(0, GetHashKey("PET"), GetHashKey('OWNER'))
                            revived = false
                            ballThrown = false
                            chasing = false
                        end, function()
                            stay = false
                            FreezeEntityPosition(pet, false)
                            ClearPedTasks(pet)
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(Config.Notifications[Config.Locale].treatment_aborted, 'info')
                        end)
                    end
                end
            elseif petHealth == 100 then
                dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].already_healthy, 'info')
            end

            -- Ilness Pills (fatigue falan)
            if petHealth > 0 and illness ~= 'healthy' and petHealth <= 95 then
                if item == 'treatmentpills' then
                    makeEntityFaceEntity(pet, PlayerPedId())
                    LoadAnimDict(PetTable[pet_model].dictionary.sit)
                    TaskPlayAnim(pet, PetTable[pet_model].dictionary.sit, PetTable[pet_model].animation.sit, 8.0, -8, -1, 1, 0, false, false, false)
                    LoadAnimDict('amb@medic@standing@kneel@base')
                    TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)  
                    if Config.Progressbar == 'ox_lib' then
                        if lib.progressCircle({
                            duration = 5000,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true
                            },
                            anim = {},
                            prop = {
                                model = 'prop_cs_pills', --xm_prop_smug_crate_s_medical v_med_latexgloveboxred prop_syringe_01
                                pos = vec3(0.03, 0.03, 0.02),
                                rot = vec3(0.0, 0.0, -1.5)
                            }
                        }) then
                            stay = false
                            FreezeEntityPosition(pet, false)
                            LoadAnimDict(PetTable[pet_model].dictionary.up)
                            TaskPlayAnim(pet, PetTable[pet_model].dictionary.up, PetTable[pet_model].animation.up, 8.0, -8, -1, 0, 0,
                                false, false, false)
                            ClearPedTasks(PlayerPedId())
                            petHealth = petHealth + 5
                            SetEntityHealth(pet, GetEntityHealth(pet) + 5)
                            illness = 'healthy'
                            TriggerServerEvent('dusa-pets:removeItem', item, 1) 
                            TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                            dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].treated_success, 'success')
                            OpenHud(false)
                            OpenHud(true)
                        else
                            stay = false
                            FreezeEntityPosition(pet, false)
                            LoadAnimDict(PetTable[pet_model].dictionary.up)
                            TaskPlayAnim(pet, PetTable[pet_model].dictionary.up, PetTable[pet_model].animation.up, 8.0, -8, -1, 0, 0,
                                false, false, false)
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(Config.Notifications[Config.Locale].treatment_aborted, 'info')
                        end
                    else
                        QBCore.Functions.Progressbar("pills", 'Giving pills..', 5000, false, false, {
                            disableMovement = false,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true
                        }, {}, {}, {}, function() -- Done
                            stay = false
                            FreezeEntityPosition(pet, false)
                            LoadAnimDict(PetTable[pet_model].dictionary.up)
                            TaskPlayAnim(pet, PetTable[pet_model].dictionary.up, PetTable[pet_model].animation.up, 8.0, -8, -1, 0, 0,
                                false, false, false)
                            ClearPedTasks(PlayerPedId())
                            petHealth = petHealth + 5
                            SetEntityHealth(pet, GetEntityHealth(pet) + 5)
                            illness = 'healthy'
                            TriggerServerEvent('dusa-pets:removeItem', item, 1) 
                            TriggerServerEvent('dusa_pets:sv:updatePet', petHealth, illness, activePet)
                            dusa.showNotification(petName..' '..Config.Notifications[Config.Locale].treated_success, 'success')
                            OpenHud(false)
                            OpenHud(true)
                        end, function()
                            stay = false
                            FreezeEntityPosition(pet, false)
                            LoadAnimDict(PetTable[pet_model].dictionary.up)
                            TaskPlayAnim(pet, PetTable[pet_model].dictionary.up, PetTable[pet_model].animation.up, 8.0, -8, -1, 0, 0,
                                false, false, false)
                            ClearPedTasks(PlayerPedId())
                            dusa.showNotification(Config.Notifications[Config.Locale].treatment_aborted, 'info')
                        end)
                    end
                end
            else
                -- if illness == 'healthy' then dusa.showNotification(petName..' doesnt have any illness', 'info') end
                -- if petHealth <= 0 then dusa.showNotification('You cant give pills to dead pet', 'error') end
            end
        else
            dusa.showNotification(Config.Notifications[Config.Locale].too_awaytotreat..' '..petName, 'error')
        end
    else
        dusa.showNotification(Config.Notifications[Config.Locale].callpet_totreat, 'error')
    end
end)

CreateThread(function()
    for _, v in pairs(Config.Peds) do
        local options = { -- This is your options table, in this table all the options will be specified for the target to accept
            {
                num = 1,
                icon = v.icon, 
                label = v.label, 
                action = v.func,
                onSelect = v.func
            }
        }
        TargetNPC(v.ped, v.coords, v.heading, options, v.func)
    end
end)

function DetachRope()
    if entity1 and entity2 then
        CloseTowingMenu()
        TriggerServerEvent('kuz_towing:stopTow')
        DeleteRope(localRope)
        SetEntityMaxSpeed(entity1, 99999.0)
        SetEntityMaxSpeed(entity2, 99999.0)
        localRope = nil
    elseif tempRope then
        CloseTowingMenu()
        DeleteRope(tempRope)
        tempRope = nil
    end

    if driverPed ~= nil then
        DeletePed(driverPed)
        driverPed = nil
    end

    entity1 = nil
    entity2 = nil

    SendNUIMessage({
        event = "reset",
    })
end

function AttemptAttachRope()
    if entity1 and entity2 then
        playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        SetRopesCreateNetworkWorldState(false)
        TriggerServerEvent('kuz_towing:tow', pet, playerPed)
        CloseTowingMenu()
        if tempRope ~= nil then
            DeleteRope(tempRope)
            tempRope = nil
        end
    end
end
tempRope = nil
local ropes = {}
function AttachTempRope(entity, leash, keepleash)
    playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    if tempRope ~= nil or entity == 'delete' then
        DeleteRope(tempRope)
        if not keepleash then
            DeleteObject(leashobj)
        end
        tempRope = nil
        return
    end

    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do
        Citizen.Wait(50)
    end

    local bonePos = GetWorldPositionOfEntityBone(entity, 43)
    if GetDistanceBetweenCoords(bonePos, pos, true) <= Config.LeashLength * 1.5 then
        CreateLeash(leash)
        tempRope = AddRope(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, Config.LeashLength * 0.2, 5, Config.LeashLength * 0.75, 0.1, 10.0, true, false, true, 1.0, false)
        AttachEntitiesToRope(tempRope, playerPed, entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.LeashLength - 2.0, true, true, 'IK_R_Hand', 'SKEL_Head')
        AttachEntityToEntity(leashobj, playerPed, 91, 0.10034350574222, 0.074516708630257, 0.055570255062422, 5.7745604779566, -86.389520847268, -136.02870738022, true, true, false, true, 1, true)
        ClearPedTasks(pet)
        TaskFollowNavMeshToCoord(pet, pos.x, pos.y, pos.z, 2.0, -1, 1, true)
    end
end

function CreateLeash(leash)
    RequestModel(leash)
    while not HasModelLoaded(leash) do
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.0))
    leashobj = CreateObjectNoOffset(leash, x, y, z, true, false)
    SetModelAsNoLongerNeeded(leash)
end



RegisterNetEvent('dusa_pets:cl:createLeash')
AddEventHandler('dusa_pets:cl:createLeash', function(leash)
    if DoesEntityExist(pet) then
        AttachTempRope(pet, leash, false)
    else
        dusa.showNotification(Config.Notifications[Config.Locale].callpetfirst, 'error')
    end
end)

RegisterNetEvent('dusa_pets:cl:removeLeash')
AddEventHandler('dusa_pets:cl:removeLeash', function(id, pet_, ply_)
    for k, rope in pairs(ropes) do
        if rope.id == id then
            DeleteRope(rope.rope)
            ropes[k] = nil
        end
    end
end)