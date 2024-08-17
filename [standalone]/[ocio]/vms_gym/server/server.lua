local statistics = {}

local function AddPlayerMembership(identifier, membershipName, membershipTime, cb)
	MySQL.Async.insert('INSERT INTO gym_memberships (owner, name, time) VALUES (@owner, @name, @time)', {["@owner"] = identifier, ["@name"] = membershipName, ["@time"] = membershipTime}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end
local function RemovePlayerMembership(identifier, membershipName, cb)
	MySQL.Async.execute('DELETE FROM gym_memberships WHERE owner = @owner AND name = @name', {["@owner"] = identifier, ["@name"] = membershipName}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end

local function GetPlayerMemberships(identifier, cb)
	MySQL.Async.fetchAll('SELECT * FROM gym_memberships WHERE owner = @owner', {['@owner'] = identifier}, function(result)
		if cb then
			cb(result)
		end
	end)
end

if Config.Core == "ESX" then
    ESX = Config.CoreExport()

    AddEventHandler(Config.PlayerLoadedServer, function(playerId, xPlayer, isNew)
        local playerId = playerId
        MySQL.Async.fetchAll('SELECT statistics FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1].statistics then
                statistics[playerId] = {
                    identifier = xPlayer.identifier,
                    stats = json.decode(result[1].statistics)
                }
                TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
            else
                statistics[playerId] = {
                    identifier = xPlayer.identifier,
                    stats = {}
                }
                if Config.StatisticsMenu['strenght'] then
                    statistics[playerId].stats['strenght'] = 0.0
                end
                if Config.StatisticsMenu['condition'] then
                    statistics[playerId].stats['condition'] = 0.0
                end
                if Config.StatisticsMenu['shooting'] then
                    statistics[playerId].stats['shooting'] = 0.0
                end
                if Config.StatisticsMenu['driving'] then
                    statistics[playerId].stats['driving'] = 0.0
                end
                if Config.StatisticsMenu['flying'] then
                    statistics[playerId].stats['flying'] = 0.0
                end
                TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
            end
        end)
        if Config.EnableMemberships then
            Citizen.Wait(2000)
            GetPlayerMemberships(xPlayer.identifier, function(callback)
                TriggerClientEvent('vms_gym:cl:getMemberships', playerId, callback)
            end)
        end
    end)

    AddEventHandler(Config.PlayerLogoutServer, function(playerId)
        savePlayerStatistics(playerId)
    end)
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()

    RegisterNetEvent(Config.PlayerLoadedServer, function()
        local playerId = source
        local Player = QBCore.Functions.GetPlayer(playerId)
        MySQL.Async.fetchAll('SELECT statistics FROM players WHERE citizenid = @citizenid', {
            ['@citizenid'] = Player.PlayerData.citizenid
        }, function(result)
            if result[1].statistics then
                statistics[playerId] = {
                    identifier = Player.PlayerData.citizenid,
                    stats = json.decode(result[1].statistics)
                }
                TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
            else
                statistics[playerId] = {
                    identifier = Player.PlayerData.citizenid,
                    stats = {}
                }
                if Config.StatisticsMenu['strenght'] then
                    statistics[playerId].stats['strenght'] = 0.0
                end
                if Config.StatisticsMenu['condition'] then
                    statistics[playerId].stats['condition'] = 0.0
                end
                if Config.StatisticsMenu['shooting'] then
                    statistics[playerId].stats['shooting'] = 0.0
                end
                if Config.StatisticsMenu['driving'] then
                    statistics[playerId].stats['driving'] = 0.0
                end
                if Config.StatisticsMenu['flying'] then
                    statistics[playerId].stats['flying'] = 0.0
                end
                TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
            end
        end)
        if Config.EnableMemberships then
            Citizen.Wait(2000)
            GetPlayerMemberships(Player.PlayerData.citizenid, function(callback)
                TriggerClientEvent('vms_gym:cl:getMemberships', playerId, callback)
            end)
        end
    end)

    AddEventHandler(Config.PlayerLogoutServer, function(playerId)
        savePlayerStatistics(playerId)
    end)
else
    Citizen.CreateThread(function()
        while true do
            print(('^8[WARNING] ^7- You missconfigure Config.Core: ^1"%s"^7, available: ^2"ESX"^7 / ^2"QB-Core"^7'):format(Config.Core))
            Citizen.Wait(7500)
        end
    end)
end

MySQL.ready(function()
    if Config.AutoExecuteQuery then
        if Config.Core == "ESX" then
            MySQL.Async.execute('ALTER TABLE users ADD COLUMN IF NOT EXISTS statistics LONGTEXT DEFAULT NULL')
        elseif Config.Core == "QB-Core" then
            MySQL.Async.execute('ALTER TABLE players ADD COLUMN IF NOT EXISTS statistics LONGTEXT DEFAULT NULL')
        end
        if Config.EnableMemberships then
            MySQL.Async.execute([[
                CREATE TABLE IF NOT EXISTS `gym_memberships` (
                    `owner` varchar(70) DEFAULT NULL,
                    `name` varchar(80) DEFAULT NULL,
                    `time` int(11) DEFAULT NULL
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
            ]])
        end
    end
end)

RegisterNetEvent('vms_gym:sv:restartPlayer', function()
    local playerId = source
    if Config.Core == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            MySQL.Async.fetchAll('SELECT statistics FROM users WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            }, function(result)
                if result[1].statistics then
                    statistics[playerId] = {
                        identifier = xPlayer.identifier,
                        stats = json.decode(result[1].statistics)
                    }
                    TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
                else
                    statistics[playerId] = {
                        identifier = xPlayer.identifier,
                        stats = {}
                    }
                    if Config.StatisticsMenu['strenght'] then
                        statistics[playerId].stats['strenght'] = 0.0
                    end
                    if Config.StatisticsMenu['condition'] then
                        statistics[playerId].stats['condition'] = 0.0
                    end
                    if Config.StatisticsMenu['shooting'] then
                        statistics[playerId].stats['shooting'] = 0.0
                    end
                    if Config.StatisticsMenu['driving'] then
                        statistics[playerId].stats['driving'] = 0.0
                    end
                    if Config.StatisticsMenu['flying'] then
                        statistics[playerId].stats['flying'] = 0.0
                    end
                    TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
                end
            end)
            if Config.EnableMemberships then
                GetPlayerMemberships(xPlayer.identifier, function(callback)
                    TriggerClientEvent('vms_gym:cl:getMemberships', playerId, callback)
                end)
            end
        end
    elseif Config.Core == "QB-Core" then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            MySQL.Async.fetchAll('SELECT statistics FROM players WHERE citizenid = @citizenid', {
                ['@citizenid'] = Player.PlayerData.citizenid
            }, function(result)
                if result[1].statistics then
                    statistics[playerId] = {
                        identifier = Player.PlayerData.citizenid,
                        stats = json.decode(result[1].statistics)
                    }
                    TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
                else
                    statistics[playerId] = {
                        identifier = Player.PlayerData.citizenid,
                        stats = {}
                    }
                    if Config.StatisticsMenu['strenght'] then
                        statistics[playerId].stats['strenght'] = 0.0
                    end
                    if Config.StatisticsMenu['condition'] then
                        statistics[playerId].stats['condition'] = 0.0
                    end
                    if Config.StatisticsMenu['shooting'] then
                        statistics[playerId].stats['shooting'] = 0.0
                    end
                    if Config.StatisticsMenu['driving'] then
                        statistics[playerId].stats['driving'] = 0.0
                    end
                    if Config.StatisticsMenu['flying'] then
                        statistics[playerId].stats['flying'] = 0.0
                    end
                    TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
                end
            end)
            if Config.EnableMemberships then
                GetPlayerMemberships(Player.PlayerData.citizenid, function(callback)
                    TriggerClientEvent('vms_gym:cl:getMemberships', playerId, callback)
                end)
            end
        end
    end
end)

RegisterNetEvent('vms_gym:sv:getMemberships', function()
    if not Config.EnableMemberships then return end
    local src = source
    local xPlayer = Config.Core == "ESX" and ESX.GetPlayerFromId(src) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(src)
    local xPlayerIdentifier = Config.Core == "ESX" and xPlayer.identifier or Config.Core == "QB-Core" and xPlayer.PlayerData.citizenid
    if xPlayer and xPlayerIdentifier then
        GetPlayerMemberships(xPlayerIdentifier, function(playerMemberships)
            TriggerClientEvent('vms_gym:cl:getMemberships', src, playerMemberships)
        end)
    end
end)

RegisterNetEvent('vms_gym:sv:setTaken', function(gymId, pointId, boolean)
    TriggerClientEvent('vms_gym:cl:setTaken', -1, gymId, pointId, boolean)
end)

RegisterNetEvent('vms_gym:sv:sendRequestOfMembership', function(playerId, membershipName, days, price)
    if not Config.EnableMemberships then return end
    local src = source
    TriggerClientEvent('vms_gym:cl:sendRequestOfMembership', playerId, src, membershipName, days, price)
end)

RegisterNetEvent('vms_gym:sv:acceptMembership', function(sellerId, membershipName, days, price)
    if not Config.EnableMemberships then return end
    local src = source
    local xPlayer = Config.Core == "ESX" and ESX.GetPlayerFromId(src) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(src)
    local xSeller = Config.Core == "ESX" and ESX.GetPlayerFromId(sellerId) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(sellerId) 
    if xPlayer then
        local playerMoney = Config.Core == "ESX" and xPlayer.getAccount('money').money or Config.Core == "QB-Core" and xPlayer.PlayerData.money['cash']
        if playerMoney >= price then
            local dateYear = os.date('%Y')
            local dateMonth = os.date('%m')
            local dateDay = os.date('%d') + days
            local dateHour = os.date('%H')
            local dateMinute = os.date('%M')
            local dayeSeconds = os.date('%S')
            local time = {year = dateYear, month = dateMonth, day = dateDay, hour = dateHour, min = dateMinute, sec = dayeSeconds}
            local osTime = os.time(time)
            if Config.Core == "ESX" then
                xPlayer.removeAccountMoney('money', price)
                AddPlayerMembership(xPlayer.identifier, membershipName, osTime, function(done)
                    if done then
                        GetPlayerMemberships(xPlayer.identifier, function(playerMemberships)
                            TriggerClientEvent('vms_gym:cl:getMemberships', src, playerMemberships)
                        end)
                        TriggerClientEvent('vms_gym:notification', src, Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['bought_membership'], 4000, "fa-solid fa-dumbbell", 'success')
                        if sellerId then
                            if xSeller then
                                AddMoneyToSociety(price, xSeller.job.name)
                            end
                            TriggerClientEvent('vms_gym:notification', sellerId, Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['selled_membership'], 4000, "fa-solid fa-dumbbell", 'success')
                        end
                    end
                end)
            elseif Config.Core == "QB-Core" then
                xPlayer.Functions.RemoveMoney('cash', price)
                AddPlayerMembership(xPlayer.PlayerData.citizenid, membershipName, osTime, function(done)
                    if done then
                        GetPlayerMemberships(xPlayer.PlayerData.citizenid, function(playerMemberships)
                            TriggerClientEvent('vms_gym:cl:getMemberships', src, playerMemberships)
                        end)
                        TriggerClientEvent('vms_gym:notification', src, Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['bought_membership'], 4000, "fa-solid fa-dumbbell", 'success')
                        if sellerId then
                            if xSeller then
                                AddMoneyToSociety(price, xSeller.PlayerData.job.name)
                            end
                            TriggerClientEvent('vms_gym:notification', sellerId, Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['selled_membership'], 4000, "fa-solid fa-dumbbell", 'success')
                        end
                    end
                end)
            end
        else
            TriggerClientEvent('vms_gym:notification', src, Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['no_money_for_membership'], 4000, "fa-solid fa-dumbbell", 'error')
            if sellerId then
                TriggerClientEvent('vms_gym:notification', sellerId, Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['customer_did_not_buy'], 4000, "fa-solid fa-dumbbell", 'error')
            end
        end
    end
end)

RegisterNetEvent('vms_gym:sv:rejectMembership', function(sellerId)
    TriggerClientEvent('vms_gym:notification', sellerId, Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['customer_did_not_buy'], 4000, "fa-solid fa-dumbbell", 'error')
end)

RegisterNetEvent('vms_gym:sv:addValue', function(name, value)
    local src = source
    if not statistics[src] then return end
    if statistics[src].stats then
        if not statistics[src].stats[name] then
            statistics[src].stats[name] = 0.0
        end
        if Config.SendNotificationWhenSkillIncrase and statistics[src].stats[name] < 100.0 then
            TriggerClientEvent('vms_gym:notification', src, 
                Config.Translate[Config.Language]['notify.title.'..name], 
                Config.Translate[Config.Language]['incrase_'..name]:format(value..'%'), 
                3000, 
                name == "strenght" and "fa-solid fa-dumbbell" or name == "condition" and "fa-solid fa-lungs" or name == "shooting" and "fa-solid fa-gun" or name == "driving" and "fa-solid fa-car" or name == "flying" and "fa-solid fa-plane-up", 
                'info',
                true
            )
        end
        statistics[src].stats[name] = statistics[src].stats[name] + value
        if statistics[src].stats[name] > 100.0 then
            statistics[src].stats[name] = 100.0
        end
        TriggerClientEvent('vms_gym:cl:updateStatistic', src, statistics[src].stats)
    end
end)

RegisterNetEvent('vms_gym:sv:removeValue', function(name, value)
    local src = source
    if not statistics[src] then return end
    if statistics[src].stats then
        if not statistics[src].stats[name] then
            statistics[src].stats[name] = 0.0
        end
        if Config.SendNotificationWhenSkillDecrease and statistics[src].stats[name] > 0.0 then
            TriggerClientEvent('vms_gym:notification', src, 
                Config.Translate[Config.Language]['notify.title.'..name], 
                Config.Translate[Config.Language]['decrease_'..name]:format(value..'%'), 
                3000, 
                name == "strenght" and "fa-solid fa-dumbbell" or name == "condition" and "fa-solid fa-lungs" or name == "shooting" and "fa-solid fa-gun" or name == "driving" and "fa-solid fa-car" or name == "flying" and "fa-solid fa-plane-up", 
                'info',
                true
            )
        end
        statistics[src].stats[name] = statistics[src].stats[name] - value
        if statistics[src].stats[name] < 0.0 then
            statistics[src].stats[name] = 0.0
        end
        TriggerClientEvent('vms_gym:cl:updateStatistic', src, statistics[src].stats)
    end
end)

savePlayerStatistics = function(playerId)
    if statistics[playerId] then
        if Config.Core == "ESX" then
            MySQL.Async.execute('UPDATE users SET statistics = @statistics WHERE identifier = @identifier', {
                ['@statistics'] = json.encode(statistics[playerId].stats),
                ['@identifier'] = statistics[playerId].identifier
            })
        elseif Config.Core == "QB-Core" then
            MySQL.Async.execute('UPDATE players SET statistics = @statistics WHERE citizenid = @citizenid', {
                ['@statistics'] = json.encode(statistics[playerId].stats),
                ['@citizenid'] = statistics[playerId].identifier
            })
        end
    end
end

function StartSave()
    CreateThread(function()
        while true do
            Wait(Config.SavingTimeout)
            local xPlayers = Config.Core == "ESX" and ESX.GetExtendedPlayers() or Config.Core == "QB-Core" and QBCore.Functions.GetPlayers()
            for i = 1, #(xPlayers) do
                local xPlayer = xPlayers[i]
                savePlayerStatistics(Config.Core == "ESX" and xPlayer.source or Config.Core == "QB-Core" and xPlayer)
            end
        end
    end)
end

StartSave()

if Config.EnableMemberships then
    function CheckMemberships(d, h, m)
        MySQL.Async.fetchAll('SELECT time as timestamp, name, owner FROM gym_memberships', {}, function(result)
            local nowTime = os.time()
            for i=1, #result, 1 do
                local aboTime = result[i].timestamp
                if aboTime <= nowTime then
                    MySQL.Async.execute('DELETE FROM gym_memberships WHERE owner = @owner AND name = @name AND time = @time', {
                        ['@owner'] = result[i].owner,
                        ['@name'] = result[i].name,
                        ['@time'] = aboTime,
                    })
                    local player = Config.Core == "ESX" and ESX.GetPlayerFromIdentifier(result[i].owner) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayerByCitizenId(result[i].owner)
                    if player then
                        GetPlayerMemberships(result[i].owner, function(playerMemberships)
                            TriggerClientEvent('vms_gym:cl:getMemberships', player, playerMemberships)
                        end)
                    end
                end
            end
        end)
    end
    
    TriggerEvent('cron:runAt', 02, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 04, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 06, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 08, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 10, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 12, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 14, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 16, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 18, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 20, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 22, 0, CheckMemberships)
    TriggerEvent('cron:runAt', 24, 0, CheckMemberships)
end