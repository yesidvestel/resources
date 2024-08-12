if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['es_extended']:getSharedObject()
dusa = {}
dusa.framework = 'esx'
dusa.inventory = 'default'

if GetResourceState('ox_inventory') == 'started' then dusa.inventory = 'ox' end
if GetResourceState('qs-inventory') == 'started' then dusa.inventory = 'qs' end

---@diagnostic disable: duplicate-set-field

function dusa.getPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function dusa.registerCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function dusa.getIdentifier(source)
    local player = dusa.getPlayer(source)
    if not player then return false end
    return player.identifier
end

function dusa.addItem(source, item, count, slot, metadata)
    local player = dusa.getPlayer(source)
    return player.addInventoryItem(item, count)
end

function dusa.removeItem(source, item, count, slot, metadata)
    local player = dusa.getPlayer(source)
    player.removeInventoryItem(item, count)
end

function dusa.registerUsableItem(item, cb)
    ESX.RegisterUsableItem(item, cb)
end

function dusa.addMoney(source, type, amount)
    if type == 'cash' then type = 'money' end
    local player = dusa.getPlayer(source)
    player.addAccountMoney(type, amount)
end

function dusa.removeMoney(source, type, amount)
    if type == 'cash' then type = 'money' end
    local player = dusa.getPlayer(source)
    player.removeAccountMoney(type, amount)
end

function dusa.getMoney(source, type)
    if type == 'cash' then type = 'money' end
    local player = dusa.getPlayer(source)
    return player.getAccount(type).money
end

-- USABLE ITEMS
for k, v in pairs(Config.TreatItems) do
	dusa.registerUsableItem(v, function(source)
		TriggerClientEvent('dusa_pets:cl:treatpet', source, v)
	end)
end

for _,v in pairs(Config.Objects) do
	dusa.registerUsableItem(v.item, function(source)
		TriggerClientEvent('dusa:startPlacing', source, {obj = v.prop, type = v.type, item = v.item})
	end)
end

dusa.registerUsableItem('tennisball', function(source)
	TriggerClientEvent('dusa-pets:cl:useBall', source)
end)

dusa.registerUsableItem('nametag', function(source)
	TriggerClientEvent('dusa_pets:cl:renamepet', source)
end)

dusa.registerUsableItem('petbowl', function(source)
	TriggerClientEvent('dusa_pets:cl:feed', source)
end)

dusa.registerUsableItem('leash', function(source)
	TriggerClientEvent('dusa_pets:cl:createLeash', source, 'leash_model')
end)

dusa.registerUsableItem('leash2', function(source)
	TriggerClientEvent('dusa_pets:cl:createLeash', source, 'leash_model_2')
end)

dusa.registerUsableItem('leash3', function(source)
	TriggerClientEvent('dusa_pets:cl:createLeash', source, 'leash_model_3')
end)