---- > In QBCore replace self.Functions.Setjob to the next function
```lua
function self.Functions.SetJob(job, grade, fromMJ)
    local job = job:lower()
    local grade = tostring(grade) or '0'

    if QBCore.Shared.Jobs[job] ~= nil then
        if not fromMJ and GetResourceState('origen_masterjob') == 'started' then
            local BusN = exports["origen_masterjob"]:GetBusiness(self.PlayerData.job.name)
            if BusN then
                BusN.Functions.RemovePlayer(self.PlayerData.citizenid, true)
                TriggerClientEvent("origen_masterjob:client:OnBusinessUpdate", self.PlayerData.source, false)
            end
        end
        self.PlayerData.job.name = job
        self.PlayerData.job.label = QBCore.Shared.Jobs[job].label
        self.PlayerData.job.onduty = QBCore.Shared.Jobs[job].defaultDuty

        if QBCore.Shared.Jobs[job].grades[grade] then
            local jobgrade = QBCore.Shared.Jobs[job].grades[grade]
            self.PlayerData.job.grade = {}
            self.PlayerData.job.grade.name = jobgrade.name
            self.PlayerData.job.grade.level = tonumber(grade)
            self.PlayerData.job.payment = jobgrade.payment ~= nil and jobgrade.payment or 30
            self.PlayerData.job.isboss = jobgrade.isboss ~= nil and jobgrade.isboss or false
        else
            return false
        end

        self.Functions.UpdatePlayerData()
        TriggerClientEvent("QBCore:Client:OnJobUpdate", self.PlayerData.source, self.PlayerData.job)
        return true
    elseif GetResourceState('origen_masterjob') == 'started' then
        local BusN = exports["origen_masterjob"]:GetBusiness(job)
        if BusN then
            local jobgrade = BusN.Functions.GetGrade(grade)

            if not jobgrade then
                return false
            end

            self.PlayerData.job.name = job
            self.PlayerData.job.label = BusN.Data.label
            self.PlayerData.job.onduty = false


            self.PlayerData.job.grade = {}
            self.PlayerData.job.grade.name = jobgrade.label or "Sin grado"
            self.PlayerData.job.grade.level = grade

            self.PlayerData.job.payment = jobgrade.pay or 30
            self.PlayerData.job.isboss = jobgrade.boss or false

            self.Functions.UpdatePlayerData()
            TriggerClientEvent("QBCore:Client:OnJobUpdate", self.PlayerData.source, self.PlayerData.job)

            if not fromMJ then
                BusN.Functions.AddPlayer(self.PlayerData.citizenid, self.PlayerData.charinfo.firstname .. " " .. self.PlayerData.charinfo.lastname, tostring(grade), true)
            end

            return true
        end
    end

    return false
end
```

----> Then remove this line from qb-core

```lua
if PlayerData.job and PlayerData.job.name and not QBCore.Shared.Jobs[PlayerData.job.name] then PlayerData.job = nil end
```
----> Set ``QBShared.ForceJobDefaultDutyAtLogin`` to false in qb-core


# qb-inventory/server/main.lua

 before GetStashItems
```lua

exports("GetStash", function(stashId)
	return Stashes[stashId] or {
		items = GetStashItems(stashId)
	}
end)

exports('GetStashItems', GetStashItems)

RegisterServerEvent('qb-inventory:server:SaveStashItems', function(stashId, items)
    MySQL.insert('INSERT INTO stashitems (stash, items) VALUES (@stash, @items) ON DUPLICATE KEY UPDATE items = @items', {
        ['@stash'] = stashId,
        ['@items'] = json.encode(items)
    })

	if Stashes[stashId] then
		Stashes[stashId].items = items
	end
end)
```

# qb-garages/client/main.lua
```lua
    -- INSERT THESE LINES AT THE END OF THE SCRIPT
   exports('MenuGarage', MenuGarage) 
   exports('enterVehicle', enterVehicle)

   -- reemplace this function
local function CheckPlayers(vehicle, garage)
    for i = -1, 5, 1 do
        local seat = GetPedInVehicleSeat(vehicle, i)
        if seat then
            TaskLeaveVehicle(seat, vehicle, 0)
            if garage then
                if not garage.takeVehicle then garage.takeVehicle = GetEntityCoords((PlayerPedId())) end

                SetEntityCoords(seat, garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z)
            end
        end
    end
    SetVehicleDoorsLocked(vehicle)
    Wait(1500)
    QBCore.Functions.DeleteVehicle(vehicle)
end
```

# qb-garages/server/main.lua
```lua
    --- REEMPACE THIS EVENTS
QBCore.Functions.CreateCallback("qb-garage:server:checkOwnership", function(source, cb, plate, type, house, gang)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    if type == "public" then        --Public garages only for player cars
        MySQL.query('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',{plate, pData.PlayerData.citizenid}, function(result)
            if result[1] then
                cb(true)
            else
                cb(false)
            end
        end)
    elseif type == "house" then     --House garages only for player cars that have keys of the house
        MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
            if result[1] then
                local hasHouseKey = exports['qb-houses']:hasKey(result[1].license, result[1].citizenid, house)
                if hasHouseKey then
                    cb(true)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)
    elseif type == "gang" then        --Gang garages only for gang members cars (for sharing)
        MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
            if result[1] then
                --Check if found owner is part of the gang
                local resultplayer = MySQL.single.await('SELECT * FROM players WHERE citizenid = ?', { result[1].citizenid })
                if resultplayer then
                    local playergang = json.decode(resultplayer.gang)
                    if playergang.name == gang then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)
    elseif type == "job" then        --Gang garages only for gang members cars (for sharing)
        debuger (plate)
        MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?', {plate}, function(result)
            if result[1] then
                --Check if found owner is part of the gang
                debuger ('^5hay coches^0')
                local resultplayer = MySQL.single.await('SELECT * FROM players WHERE citizenid = ?', { result[1].citizenid })
                if resultplayer then
                    local playerjob = json.decode(resultplayer.job)
                    if playerjob.name == pData?.PlayerData?.job?.name then
                        cb(true)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)
    else                            --Job garages only for cars that are owned by someone (for sharing and service) or only by player depending of config
        local shared = ''
        if not Config["SharedGarages"] then
            shared = " AND citizenid = '"..pData.PlayerData.citizenid.."'"
        end
        MySQL.query('SELECT * FROM player_vehicles WHERE plate = ?'..shared, {plate}, function(result)
            if result[1] then
                cb(true)
            else
                cb(false)
            end
        end)
    end
end)

-------------------------------------
-------------------------------------
QBCore.Functions.CreateCallback('qb-garage:server:spawnvehicle', function (source, cb, vehInfo, coords, warp)
    local plate = vehInfo.plate
    local veh = QBCore.Functions.SpawnVehicle(source, vehInfo.vehicle, coords, warp)
    if coords then
        SetEntityHeading(veh, coords.w)
    end
    SetVehicleNumberPlateText(veh, plate)
    local vehProps = {}
    local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] then vehProps = json.decode(result[1].mods) end
    local netId = NetworkGetNetworkIdFromEntity(veh)
    OutsideVehicles[plate] = {netID = netId, entity = veh}
    cb(netId, vehProps)
end)

---------------------------------------
---------------------------------------
RegisterNetEvent('qb-garage:server:updateVehicle', function(state, fuel, engine, body, plate, garage, type, gang)
     QBCore.Functions.TriggerCallback('qb-garage:server:checkOwnership', source, function(owned)     --Check ownership
        if owned then
            if state == 0 or state == 1 or state == 2 then                                          --Check state value
                if type ~= "house" then
                    if Config.Garages[garage] or type == 'job' then                                                             --Check if garage is existing
                        MySQL.update('UPDATE player_vehicles SET state = ?, garage = ?, fuel = ?, engine = ?, body = ? WHERE plate = ?', {state, garage, fuel, engine, body, plate})
                    end
                else
                    MySQL.update('UPDATE player_vehicles SET state = ?, garage = ?, fuel = ?, engine = ?, body = ? WHERE plate = ?', {state, garage, fuel, engine, body, plate})
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t("error.not_owned"), 'error')
        end
    end, plate, type, garage, gang)
end)


```
## ##################################################################################### ##
## ################################ ESX ################################################ ##
## ##################################################################################### ##
---- > In ESX replace self.setJob to the next function
```lua
function self.setJob(newJob, grade)
    grade = tostring(grade)
    local lastJob = json.decode(json.encode(self.job))

    if ESX.DoesJobExist(newJob, grade) then
        if not fromMJ and GetResourceState('origen_masterjob') == 'started' then
            local BusN = exports["origen_masterjob"]:GetBusiness(self.job.name)
            if BusN then
                BusN.Functions.RemovePlayer(self.identifier, true)
                TriggerClientEvent("origen_masterjob:client:OnBusinessUpdate", self.source, false)
            end
        end

        local jobObject, gradeObject = ESX.Jobs[newJob], ESX.Jobs[newJob].grades[grade]

        self.job.id                  = jobObject.id
        self.job.name                = jobObject.name
        self.job.label               = jobObject.label

        self.job.grade               = tonumber(grade)
        self.job.grade_name          = gradeObject.name
        self.job.grade_label         = gradeObject.label
        self.job.grade_salary        = gradeObject.salary

        if gradeObject.skin_male then
            self.job.skin_male = json.decode(gradeObject.skin_male)
        else
            self.job.skin_male = {}
        end

        if gradeObject.skin_female then
            self.job.skin_female = json.decode(gradeObject.skin_female)
        else
            self.job.skin_female = {}
        end

        TriggerEvent('esx:setJob', self.source, self.job, lastJob)
        self.triggerEvent('esx:setJob', self.job, lastJob)
        Player(self.source).state:set("job", self.job, true)
    elseif GetResourceState('origen_masterjob') == 'started' then
        local BusN = exports["origen_masterjob"]:GetBusiness(newJob)
        if BusN then
            local jobgrade = BusN.Functions.GetGrade(grade)

            if not jobgrade then
                print(('[es_extended] [^3WARNING^7] Ignoring invalid ^5.setJob()^7 usage for ID: ^5%s^7, Job: ^5%s^7'):format(self.source, newJob))
            end

            self.job.name                = newJob
            self.job.label               = BusN.Data.label

            self.job.grade               = tonumber(grade)
            self.job.grade_name          = jobgrade.boss and "boss" or jobgrade.label:lower():gsub(" ", "_")
            self.job.grade_label         = jobgrade.label or "Sin grado"
            self.job.grade_salary        = jobgrade.pay or 30
            self.job.skin_male = {}
            self.job.skin_female = {}

            TriggerEvent('esx:setJob', self.source, self.job, lastJob)
            self.triggerEvent('esx:setJob', self.job, lastJob)
            Player(self.source).state:set("job", self.job, true)

            if not fromMJ then
                BusN.Functions.AddPlayer(self.identifier, self.get("firstName") .. " " .. self.get("lastName"), tostring(grade), true)
            end
        else
            print(('[es_extended] [^3WARNING^7] Ignoring invalid ^5.setJob()^7 usage for ID: ^5%s^7, Job: ^5%s^7'):format(self.source, newJob))
        end
    else
        print(('[es_extended] [^3WARNING^7] Ignoring invalid ^5.setJob()^7 usage for ID: ^5%s^7, Job: ^5%s^7'):format(self.source, newJob))
    end
end
```

----> Replace this part of code in es_extended
```lua
if ESX.DoesJobExist(job, grade) then
    jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
else
    print(('[^3WARNING^7] Ignoring invalid job for ^5%s^7 [job: ^5%s^7, grade: ^5%s^7]'):format(identifier, job, grade))
    job, grade = 'unemployed', '0'
    jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
end
```

TO

```lua
if ESX.DoesJobExist(job, grade) then
    jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
elseif GetResourceState('origen_masterjob') == 'started' then
    local BusN = exports["origen_masterjob"]:GetBusiness(job)
    if BusN then
        local jobgrade = BusN.Functions.GetGrade(grade)

        if jobgrade then
            jobObject = {
                id = BusN.Data.id,
                name = job,
                label = BusN.Data.label,
            }
            gradeObject = {
                name = jobgrade.boss and "boss" or jobgrade.label:lower():gsub(" ", "_"),
                label = jobgrade.label or "Sin grado",
                salary = jobgrade.pay or 30
            }
        else
            print(('[^3WARNING^7] Ignoring invalid job for ^5%s^7 [job: ^5%s^7, grade: ^5%s^7]'):format(identifier, job, grade))
        end
    else
        print(('[^3WARNING^7] Ignoring invalid job for ^5%s^7 [job: ^5%s^7, grade: ^5%s^7]'):format(identifier, job, grade))
    end
else
    print(('[^3WARNING^7] Ignoring invalid job for ^5%s^7 [job: ^5%s^7, grade: ^5%s^7]'):format(identifier, job, grade))
    job, grade = 'unemployed', '0'
    jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
end
```

For ESX and QBCore
----> Customize your modifications menu in ``custom/client.lua`` -> ``OpenModificationMenu``