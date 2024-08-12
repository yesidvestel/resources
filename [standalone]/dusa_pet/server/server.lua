RegisterServerEvent('dusa_pets:sv:buyPet')
AddEventHandler('dusa_pets:sv:buyPet', function(cart, price, petType, moneyType)
	local _source = source
	local xPlayer = dusa.getPlayer(_source)
	local CheckMoney = CheckMoney(xPlayer, price, moneyType, _source)
	if CheckMoney then
		for i = 1, #cart do
			MySQL.Async.execute('INSERT INTO dusa_pets (owner, modelname, type) VALUES (@owner, @modelname, @type)',
			{
				['@owner']   = dusa.getIdentifier(source),
				['@modelname']   = cart[i].pet_code,
				['@type']   = petType
			}, function (rowsChanged)
				TriggerClientEvent('dusa_pets:cl:notify', _source, Config.Notifications[Config.Locale].bought_pet, 'success')
				TriggerClientEvent('dusa_pets:cl:petbought', _source)
			end)
		end
	end
end)

function CheckMoney(xPlayer, price, moneyType, _source)
	if moneyType == "cash" then
		if dusa.getMoney(_source, 'money') > price then
			dusa.removeMoney(_source, 'money', price)
			return true
		else
			TriggerClientEvent('dusa_pets:cl:notify', _source, Config.Notifications[Config.Locale].not_enough_cash, 'error')
			return false
		end
	elseif moneyType == 'card' then
		if dusa.getMoney(_source, 'bank') > price then
			dusa.removeMoney(_source, 'bank', price)
			return true
		else
			TriggerClientEvent('dusa_pets:cl:notify', _source, Config.Notifications[Config.Locale].not_enough_bank, 'error')
			return false
		end
	end
end

RegisterServerEvent('dusa_pets:getOwnedPet')
AddEventHandler('dusa_pets:getOwnedPet',function()
	local xPlayer = dusa.getPlayer(source)
	MySQL.Async.fetchAll('SELECT * FROM dusa_pets WHERE owner = @owner', {
		['@owner'] = dusa.getIdentifier(source),
		['@modelname'] = modelname,
	}, function (result)
		TriggerClientEvent('dusa-pets:cl:spawnpet',modelname,health,illness)
	end)
end)

RegisterServerEvent('dusa_pets:sv:updatePet')
AddEventHandler('dusa_pets:sv:updatePet',function(health, illness, pet)
    local xPlayer = dusa.getPlayer(source)
	local identifier = dusa.getIdentifier(source)
	MySQL.Async.execute('UPDATE dusa_pets SET health = @health, illnesses = @illness WHERE owner = @owner AND modelname = @modelname', {
		['@health'] = health,
		['@illness'] = illness,				
		['@owner']   = identifier,
		['@modelname']   = pet
	}, function(rowsChanged)
	end)
end)

RegisterServerEvent('dusa_pets:sv:updatePetName')
AddEventHandler('dusa_pets:sv:updatePetName',function(name, pet)
    local xPlayer = dusa.getPlayer(source)
	local identifier = dusa.getIdentifier(source)
	MySQL.Async.execute('UPDATE dusa_pets SET name = @name WHERE owner = @owner AND modelname = @modelname', {
		['@name'] = name,		
		['@owner']   = identifier,
		['@modelname']   = pet,
	}, function(rowsChanged)
	end)
end)

RegisterServerEvent('dusa_pets:sv:removePet')
AddEventHandler('dusa_pets:sv:removePet',function(model)
	local source = source
	local xPlayer = dusa.getPlayer(source)
	local identifier = dusa.getIdentifier(source)
	MySQL.Async.execute('DELETE FROM dusa_pets WHERE owner = @owner AND modelname = @modelname', {
		['@owner'] = identifier,
		['@modelname'] = model
	})
end)

RegisterNetEvent('dusa_pets:k9Search')
AddEventHandler('dusa_pets:k9Search',function(ID,targetID)
	local itemFound = false
	local source = source
	local targetPlayer = dusa.getPlayer(targetID)
	for _, v in pairs(Config.IllegalItems) do
		if dusa.framework == 'esx' then
			if targetPlayer.getInventoryItem(v) and targetPlayer.getInventoryItem(v).count >= 0 then
				itemFound = true
			end
		else
			if targetPlayer.Functions.GetItemByName(v) and targetPlayer.Functions.GetItemByName(v).amount >= 0 then
				itemFound = true
			end
		end
	end
	TriggerClientEvent('dusa_pets:k9ItemCheck', source, itemFound)
end)

RegisterServerEvent('dusa-pets:addItem')
AddEventHandler('dusa-pets:addItem', function(item, count)
	local source = source
	local player = dusa.getPlayer(source)
	if player then
		dusa.addItem(source, item, count)
	end
end)

RegisterServerEvent('dusa-pets:removeItem')
AddEventHandler('dusa-pets:removeItem', function(item, count)
	local source = source
	local player = dusa.getPlayer(source)
	if player then
		if dusa.framework == 'esx' then
			if player.getInventoryItem(item).count >= count then
				dusa.removeItem(source, item, count)
			else
				print('not enough item tried to remove')
			end
		else
			if player.Functions.GetItemByName(item).amount >= count then
				dusa.removeItem(source, item, count)
			else
				print('not enough item tried to remove')
			end
		end
	end
end)

RegisterServerEvent('dusa-pets:manipulateMoney')
AddEventHandler('dusa-pets:manipulateMoney', function(will, account, price)
	local source = source
	local player = dusa.getPlayer(source)
	if player then
		if will == 'remove' then
			dusa.removeMoney(source, account, price)
		elseif will == 'add' then
			dusa.addMoney(source, account, price)
		end
	end
end)

local ServerObjects = {}

RegisterNetEvent("dusa_objects:server:CreateNewObject", function(model, coords, objecttype, options, objectname)
    local source = source
    if model and coords then
        TriggerClientEvent("dusa_objects:client:AddObject", -1, {id = math.random(0, 10000), model = model, coords = coords, type = objecttype, name = objectname, options = options})
    else 
        print("[DUSA_PETS]: Object or coords was invalid")
    end
end)

RegisterNetEvent("dusa_objects:server:DeleteObject", function(objectid)
    local source = source
    if objectid > 0 then
        TriggerClientEvent("dusa_objects:client:receiveObjectDelete", -1, objectid)
    end
end)

function GetStatus(identifier, model)
	local result =  MySQL.query.await("SELECT health, illnesses FROM dusa_pets WHERE owner = '"..identifier.."' AND modelname = '"..model.."'")
	return result[1]
end

-- function GetIllness(identifier, model)
-- 	local result =  MySQL.query.await("SELECT illnesses FROM dusa_pets WHERE owner = '"..identifier.."' AND modelname = '"..model.."'")
-- 	return result[1].illnesses
-- end

function GetPetName(identifier, model)
	local result =  MySQL.query.await("SELECT name FROM dusa_pets WHERE owner = '"..identifier.."' AND modelname = '"..model.."'")
	return result[1].name
end

function GetPetClothes(identifier, model)
	local result =  MySQL.query.await("SELECT clothes FROM dusa_pets WHERE owner = '"..identifier.."' AND modelname = '"..model.."'")
	return result[1]
end

function GetAllPets(identifier)
	local result =  MySQL.query.await("SELECT * FROM dusa_pets WHERE owner = '"..identifier.."'")
	return result
end

function GetPlayerInventory(player, source)
	local result = CheckClotheItems(player, source)
	return result
end

-- function GetWardobe(player, identifier, model)
-- 	local wardobe = {}
-- 	local inventory = GetPlayerInventory(player)
-- 	local clothes = MySQL.query.await("SELECT clothes FROM dusa_pets WHERE owner = '"..identifier.."' AND modelname = '"..model.."'")
-- 	table.insert(wardrobe, inventory)
-- 	table.insert(wardrobe, clothes)
-- 	return wardrobe
-- end

-- kıyafet kaydetmesi kontrol et
RegisterServerEvent('dusa-pets:sv:saveClothes')
AddEventHandler('dusa-pets:sv:saveClothes', function(data, model)
	local source = source
	local player = dusa.getPlayer(source)
	local identifier = dusa.getIdentifier(source)
    local result = ExecuteSql("SELECT clothes FROM dusa_pets WHERE owner = '"..identifier.."' AND modelname ='"..model.."'")
	if result[1] ~= nil then
		MySQL.update('UPDATE dusa_pets SET `clothes` = ? WHERE owner = ? AND modelname = ?', {json.encode(data), dusa.getIdentifier(source), model})
	end
end)

dusa.registerCallback('dusa-pets:cb:getPetData', function(source, cb, type, model)
	local player = dusa.getPlayer(source)
	local identifier = dusa.getIdentifier(source)
	local result
	if type == 'inventory' then
		result = GetPlayerInventory(player, source)
	elseif type == 'allpets' then
		result = GetAllPets(identifier)
	elseif type == 'clothes' then
		result = GetPetClothes(identifier, model)
	elseif type == 'wardrobe' then
		result = GetWardobe(player, identifier, model)
	elseif type == 'name' then
		result = GetPetName(identifier, model)
	-- elseif type == 'illness' then
	-- 	result = GetIllness(identifier, model)
	elseif type == 'status' then
		result = GetStatus(identifier, model)
	end
	cb(result)
end)

dusa.registerCallback('dusa-pets:cb:getWardrobe', function(source, cb, model)
	local player = dusa.getPlayer(source)
	local identifier = dusa.getIdentifier(source)
	local clothes = GetPetClothes(identifier, model)
	local inventory = GetPlayerInventory(player, source)
	cb(clothes, inventory)
end)

dusa.registerCallback('dusa-pets:cb:checkMoney', function(source, cb, price, moneyType)
	if moneyType == "cash" then
		if dusa.getMoney(source, 'money') > price then
			cb(true)
		else
			cb(false)
		end
	elseif moneyType == 'card' then
		if dusa.getMoney(source, 'bank') > price then
			cb(true)
		else
			cb(false)
		end
	end
end)

dusa.registerCallback('dusa-pets:cb:getPlayerInventory', function(source, cb)
	local player = dusa.getPlayer(source)
	local inventory = GetPlayerInventory(player, source)
	cb(inventory)
end)

dusa.registerCallback('dusa-pets:cb:checkItem', function(source, cb, item, count)
	local player = dusa.getPlayer(source)
	if dusa.framework == 'esx' then
		if player.getInventoryItem(item).count >= count then
			cb(true)
		else
			cb(false)
		end
	else
		if player.Functions.GetItemByName(item) and player.Functions.GetItemByName(item).amount >= count then
			cb(true)
		else
			cb(false)
		end
	end
end)

dusa.registerCallback('dusa-pets:cb:getPetClothing', function(source, cb, model)
	local player = dusa.getPlayer(source)
	local identifier = dusa.getIdentifier(source)
	local result = ExecuteSql("SELECT clothes FROM dusa_pets WHERE owner = '"..identifier.."'  AND modelname = '"..model.."'")
	if result[1] ~= nil then
		cb(result[1])
	end
end)

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
	if MySQL == nil then
		exports.oxmysql:execute(query, function(data)
			result = data
			IsBusy = false
		end)
	else
		MySQL.query(query, {}, function(data)
			result = data
			IsBusy = false
		end)
	end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

function CheckClotheItems(player, source)
	local inventory = {}
	if player then
		for k,v in pairs(Config.Clothes) do
			for wi, data in pairs(v) do
				if dusa.framework == 'esx' then
					if player.getInventoryItem(wi) and player.getInventoryItem(wi).count > 0 then
						if not inventory[wi] then
							table.insert(inventory, data)
						end
					end
				else
					if player.Functions.GetItemByName(wi) and player.Functions.GetItemByName(wi).amount > 0 then
						if not inventory[wi] then
							table.insert(inventory, data)
						end
					end
				end
			end
		end
	end
	return inventory
end

-- SYNC LEASH