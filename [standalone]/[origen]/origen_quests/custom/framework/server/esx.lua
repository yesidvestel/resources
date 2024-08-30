if Config.Framework ~= 'esx' then return end


if GetResourceState('es_extended') ~= 'started' then
    while true do 
        debugger('^0[^5Origen Quest^0] es_extended is not started, please make sure to start origen_quest after es_extended^0')
        Wait(2000)
    end
end

Framework.Core = exports['es_extended']:getSharedObject()

Framework.Core.Shared = {}
Framework.Core.Shared.Items = {}

CreateThread(function()
    Framework.Core.Shared.Items = Custom:GetAllItems()
    while not Framework.Core.Shared.Items do
        Wait(1000)
        Framework.Core.Shared.Items = Custom:GetAllItems()
        debuger('Waiting items load...')
    end
end)

function Framework:CreateCallback(...)
    self.Core.RegisterServerCallback(...)
end

function Framework:GetPlayer(source)
    local player = self.Core.GetPlayerFromId(source)
    if player then
        local identifier = player.identifier
        local xPlayerCopy = player
        player = {
            Functions = {
                AddItem = function(name, amount, slot, info)
                    amount = tonumber(amount)
                    if Config.Inventory == 'origen_inventory' then
                        return exports['origen_inventory']:AddItem(source, name, amount)
                    elseif Config.Inventory == 'ox_inventory' then
                        return exports.ox_inventory:AddItem(source, name, amount, info, slot)
                    elseif Config.Inventory == 'ls-inventory' or Config.Inventory == 'qs-inventory' then
                        return xPlayerCopy.addInventoryItem(name, amount, info, slot)
                    end
                    return xPlayerCopy.addInventoryItem(name, amount, slot, info)
                end,
                RemoveItem = function(name, amount, slot, info)
                    amount = tonumber(amount)
                    if Config.Inventory == 'origen_inventory' then
                        return exports['origen_inventory']:RemoveItem(source, name, amount)
                    elseif Config.Inventory == 'ox_inventory' then
                        return exports.ox_inventory:RemoveItem(source, name, amount, nil, slot)
                    elseif Config.Inventory == 'ls-inventory' or Config.Inventory == 'qs-inventory' then
                        return xPlayerCopy.removeInventoryItem(name, amount)
                    end
                    return xPlayerCopy.removeInventoryItem(name, amount)
                end,
                ClearInventory = function()
                    if Config.Inventory == 'ox_inventory' then
                        exports.ox_inventory:ClearInventory(xPlayerCopy.source)
                    else
                        if Config.Inventory == 'origen_inventory' then 
                            exports.origen_inventory:ClearInventory(xPlayerCopy.source)
                            return 
                        end
                        for i = 1, #xPlayerCopy.inventory, 1 do
                            if xPlayerCopy.inventory[i].count > 0 then
                                xPlayerCopy.setInventoryItem(xPlayerCopy.inventory[i].name, 0)
                            end
                        end

                        for i = 1, #xPlayerCopy.loadout, 1 do
                            xPlayerCopy.removeWeapon(xPlayerCopy.loadout[i].name)
                        end

                        if xPlayerCopy.getMoney() > 0 then
                            xPlayerCopy.removeMoney(xPlayerCopy.getMoney(), 'Death')
                        end
                
                        if xPlayerCopy.getAccount('black_money').money > 0 then
                            xPlayerCopy.setAccountMoney('black_money', 0, 'Death')
                        end
                    end
                end,
                GetItemByName = function(name)
                    return xPlayerCopy.getInventoryItem(name)
                end,
            },
            PlayerData = {
                citizenid = xPlayerCopy.identifier,
                charinfo = {
                    firstname = xPlayerCopy.get('firstName'),
                    lastname = xPlayerCopy.get('lastName'),
                },
                job = {
                    name = xPlayerCopy.job.name,
                    label = xPlayerCopy.job.label,
                    grade = {
                        level = xPlayerCopy.job.grade,
                        label = xPlayerCopy.job.grade_label,
                        name = xPlayerCopy.job.grade_label
                    },
                },
                metadata = xPlayerCopy.metadata or {},
                source = xPlayerCopy.source,
                items = {},
            }
        }
        return player
    end
    return false
end

function Framework:CreateUseableItem(...)
    self.Core.RegisterUsableItem(...)
end

function Framework:RegisterCommand(name, help, arguments, argsrequired, callback, permission, ...)
    local _callback = function(xPlayer, args, showError)
        callback(xPlayer.source, args, showError)
    end
    for i = 1, #arguments, 1 do
        arguments[i].type = "any"
        arguments[i].help = arguments[i].label
    end
    self.Core.RegisterCommand({name}, permission or 'user', _callback, false, {
        help = help,
        arguments = arguments
    })
end

exports('GetCoreObject', function()
    return Framework.Core
end)

