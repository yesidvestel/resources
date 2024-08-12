if GetResourceState('qb-core') ~= 'started' then return end
QBCore = exports['qb-core']:GetCoreObject()
dusa = {}
dusa.framework = 'qb'
dusa.inventory = 'qb'

if GetResourceState('ox_inventory') == 'started' then dusa.inventory = 'ox' end
if GetResourceState('qs-inventory') == 'started' then dusa.inventory = 'qs' end
if GetResourceState('qb-inventory') == 'started' then dusa.inventory = 'qb' end

if GetResourceState(Config.Target) ~= 'started' then print('^5 IMPORTANT! ^2The target at config is not started on your server. Check Config.Target again!^0') end

---@diagnostic disable: duplicate-set-field

function dusa.getPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function dusa.registerCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function dusa.getIdentifier(source)
    local player = dusa.getPlayer(source)
    return player.PlayerData.citizenid
end

function dusa.addItem(source, item, count, slot, metadata)
    local player = dusa.getPlayer(source)
    if not player then return end
    local giveItem = player.Functions.AddItem(item, count, slot, metadata)
    item = player.Functions.GetItemByName(item)
    if item?.count then item.count = count elseif item?.amount then item.amount = count end
    TriggerClientEvent('inventory:client:ItemBox', source,  item, 'add')
    return giveItem
end

function dusa.removeItem(source, item, count, slot, metadata)
    local player = dusa.getPlayer(source)
    player.Functions.RemoveItem(item, count, slot, metadata)
end

function dusa.registerUsableItem(item, cb)
    QBCore.Functions.CreateUseableItem(item, cb)
end

function dusa.addMoney(source, type, amount)
    if type == 'money' then type = 'cash' end
    local player = dusa.getPlayer(source)
    player.Functions.AddMoney(type, amount)
end

-- para silme hatası
function dusa.removeMoney(source, type, amount)
    if type == 'money' then type = 'cash' end
    if type == 'card' then type = 'bank' end
    local player = dusa.getPlayer(source)
    player.Functions.RemoveMoney(type, amount)
end

function dusa.getMoney(source, type)
    if type == 'money' then type = 'cash' end
    local player = dusa.getPlayer(source)
    return player.Functions.GetMoney(type)
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