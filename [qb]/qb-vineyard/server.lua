local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-vineyard:server:getGrapes', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(Config.GrapeAmount.min, Config.GrapeAmount.max)
    Player.Functions.AddItem("grape", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['grape'], "add")
end)

QBCore.Functions.CreateCallback('qb-vineyard:server:loadIngredients', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local grape = Player.Functions.GetItemByName('grapejuice')
	if Player.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 23 then
                Player.Functions.RemoveItem("grapejuice", 23, false)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['grapejuice'], "remove")
                cb(true)
            else
                TriggerClientEvent('QBCore:Notify', source, Lang:t("error.invalid_items"), 'error')
                cb(false)
            end
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t("error.invalid_items"), 'error')
            cb(false)
        end
	else
		TriggerClientEvent('QBCore:Notify', source, Lang:t("error.no_items"), "error")
        cb(false)
	end
end)

QBCore.Functions.CreateCallback('qb-vineyard:server:grapeJuice', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local grape = Player.Functions.GetItemByName('grape')
	if Player.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 16 then
                Player.Functions.RemoveItem("grape", 16, false)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['grape'], "remove")
                cb(true)
            else
                TriggerClientEvent('QBCore:Notify', source, Lang:t("error.invalid_items"), 'error')
                cb(false)
            end
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t("error.invalid_items"), 'error')
            cb(false)
        end
	else
		TriggerClientEvent('QBCore:Notify', source, Lang:t("error.no_items"), "error")
        cb(false)
	end
end)

RegisterNetEvent('qb-vineyard:server:receiveWine', function()
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local amount = math.random(Config.WineAmount.min, Config.WineAmount.max)
	Player.Functions.AddItem("wine", amount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['wine'], "add")
end)

RegisterNetEvent('qb-vineyard:server:receiveGrapeJuice', function()
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local amount = math.random(Config.GrapeJuiceAmount.min, Config.GrapeJuiceAmount.max)
	Player.Functions.AddItem("grapejuice", amount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['grapejuice'], "add")
end)
----adicional rutas
-- Grape Giving via Picking

RegisterNetEvent('qb-vineyard:server:getGrapes', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem("grape", math.random(3,11))
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grape'], "add")
end)

-- Portion Events

RegisterNetEvent('qb-vineyard:server:PortionGrapes', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Grape = Player.Functions.GetItemByName('grape')
    if Grape then
        if Grape.amount >= 16 then
            Player.Functions.RemoveItem("grape", 16)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grape'], "remove")
            Player.Functions.AddItem("grapejuice", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice'], "add")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.invalid_items"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.invalid_items"), 'error')
    end
end)

RegisterNetEvent('qb-vineyard:server:PortionGrapeJuice', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local GrapeJuice = Player.Functions.GetItemByName('grapejuice')
    if GrapeJuice then
        if GrapeJuice.amount >= 3 then
            Player.Functions.RemoveItem("grapejuice", 3)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice'], "remove")
            Player.Functions.AddItem("wine", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine'], "add")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.invalid_items"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.invalid_items"), 'error')
    end
end)

-- Direct Packaging Events

RegisterNetEvent('qb-vineyard:server:GrapeJuicePackaging', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local GrapeJuice = Player.Functions.GetItemByName('grapejuice')
    if GrapeJuice then
        if GrapeJuice.amount >= 24 then
            Player.Functions.RemoveItem("grapejuice", 24)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice'], "remove")
            Player.Functions.AddItem("grapejuice24", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice24'], "add")
        elseif GrapeJuice.amount >= 12 then
            Player.Functions.RemoveItem("grapejuice", 12)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice'], "remove")
            Player.Functions.AddItem("grapejuice12", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice12'], "add")
        elseif GrapeJuice.amount >= 6 then
            Player.Functions.RemoveItem("grapejuice", 6)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice'], "remove")
            Player.Functions.AddItem("grapejuice6", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice6'], "add")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.invalid_items"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.invalid_items"), 'error')
    end
end)

RegisterNetEvent('qb-vineyard:server:WinePackaging', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Wine = Player.Functions.GetItemByName('wine')
    if Wine then
        if Wine.amount >= 24 then
            Player.Functions.RemoveItem("wine", 24)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine'], "remove")
            Player.Functions.AddItem("wine24", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine24'], "add")
        elseif Wine.amount >= 12 then
            Player.Functions.RemoveItem("wine", 12)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine'], "remove")
            Player.Functions.AddItem("wine12", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine12'], "add")
			PrepareAnim() grapeJuiceProcess()
        elseif Wine.amount >= 6 then
            Player.Functions.RemoveItem("wine", 6)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine'], "remove")
            Player.Functions.AddItem("wine6", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine6'], "add")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.invalid_items"), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.invalid_items"), 'error')
    end
end)
-- Evento de venta directa
RegisterNetEvent('qb-vineyard:server:SellMenu', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	print(Player)
    local GrapeJuice6 = Player.Functions.GetItemByName('grapejuice6')
    local GrapeJuice12 = Player.Functions.GetItemByName('grapejuice12')
    local GrapeJuice24 = Player.Functions.GetItemByName('grapejuice24')
    local Wine6 = Player.Functions.GetItemByName('wine6')
    local Wine12 = Player.Functions.GetItemByName('wine12')
    local Wine24 = Player.Functions.GetItemByName('wine24')
    if GrapeJuice24 then
        Player.Functions.RemoveItem("grapejuice24", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice24'], "remove")
        TriggerClientEvent('QBCore:Notify', src, Lang:t("text.ven_24_grape"), 'success')
        Player.Functions.AddMoney('cash', 32)
    elseif GrapeJuice12 then
        Player.Functions.RemoveItem("grapejuice12", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice12'], "remove")
        TriggerClientEvent('QBCore:Notify', src, Lang:t("text.ven_12_grape"), 'success')
        Player.Functions.AddMoney('cash', 15)
    elseif GrapeJuice6 then
        Player.Functions.RemoveItem("grapejuice6", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapejuice6'], "remove")
        TriggerClientEvent('QBCore:Notify', src, Lang:t("text.ven_6_grape"), 'success')
        Player.Functions.AddMoney('cash', 4)
    elseif Wine24 then
        Player.Functions.RemoveItem("wine24", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine24'], "remove")
        TriggerClientEvent('QBCore:Notify', src, Lang:t("text.ven_24_wine"),'success')
        Player.Functions.AddMoney('cash', 180)
    elseif Wine12 then
        Player.Functions.RemoveItem("wine12", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine12'], "remove")
        TriggerClientEvent('QBCore:Notify', src, Lang:t("text.ven_12_wine"), 'success')
        Player.Functions.AddMoney('cash', 80)
    elseif Wine6 then
        Player.Functions.RemoveItem("wine6", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine6'], "remove")
        TriggerClientEvent('QBCore:Notify', src, Lang:t("text.ven_6_wine"), 'success')
        Player.Functions.AddMoney('cash', 35)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('You don\'t have the correct Items!'),'error')
    end
end)
--- Items Basis

QBCore.Functions.CreateUseableItem('grapejuice24', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('grapejuice24')
    Player.Functions.AddItem('grapejuice', 24)
end)

QBCore.Functions.CreateUseableItem('grapejuice12', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('grapejuice12')
    Player.Functions.AddItem('grapejuice', 12)
end)

QBCore.Functions.CreateUseableItem('grapejuice6', function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('grapejuice6')
    Player.Functions.AddItem('grapejuice', 6)
end)

QBCore.Functions.CreateUseableItem('wine24', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('wine24')
    Player.Functions.AddItem('wine', 24)
end)

QBCore.Functions.CreateUseableItem('wine12', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('wine12')
    Player.Functions.AddItem('wine', 12)
end)

QBCore.Functions.CreateUseableItem('wine6', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('wine6')
    Player.Functions.AddItem('wine', 6)
end)

