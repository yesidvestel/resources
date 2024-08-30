function Custom:CheckPlayerItems(player, requiredItems)
    for itemName, requiredAmount in pairs(requiredItems) do
        local item = player.Functions.GetItemByName(itemName)
        if Config.Framework == 'esx' then
            item.amount = item.count
        end
        if not item or item.amount < requiredAmount then
            return false
        end
    end

    return true
end

function Custom:CanCarryItems(player, items)
    return true
end

function Custom:RemovePlayerItems(player, items)
    for item, amount in pairs(items) do
        player.Functions.RemoveItem(item, amount)
    end
end

function Custom:AddPlayerItems(player, items)
    for item, amount in pairs(items) do
        player.Functions.AddItem(item, amount)
    end
end

function Custom:GetGangsToAssing()
    if GetResourceState('origen_ilegal') == 'started' then
        local aux, Gangs = {}, exports['origen_ilegal']:getGangsQuest()
        for k,v in pairs(Gangs) do
            aux[#aux + 1] = {
                id = v.id,
                label = v.label,
            }
        end
        debuger('[^2INFO^7] - origen_ilegal started, added to gangs list')
        return aux
    else
        debuger('origen_ilegal not started please add your own gang system on Custom:GetGangsToAssing() custom/server/server.lua')
        return {}
    end
end



function Custom:GetBusinessToAssign()
    if Config.Framework == 'esx' then
        local aux, jobs = {}, Framework.Core.Jobs
        for k,v in pairs(jobs) do
            aux[#aux+1] = {
                id = v.name,
                label = v.label,
            }
        end

        if GetResourceState('origen_masterjob') == 'started' then
            local business = exports["origen_masterjob"]:GetBusinesses()
            for k,v in pairs(business) do
                aux[#aux+1] = {
                    id = v.Data.id,
                    label = v.Data.label,
                }
            end
            debuger('[^2INFO^7] - origen_masterjob started, added to business list')
        end

        return aux
    elseif Config.Framework == 'qbcore' then
        local aux, jobs = {}, Framework.Core.Shared.Jobs
        for k,v in pairs(jobs) do
            table.insert(aux, {
                id = k,
                label = v.label,
            })
        end

        if GetResourceState('origen_masterjob') == 'started' then
            local business = exports["origen_masterjob"]:GetBusinesses()
            for k,v in pairs(business) do
                table.insert(aux, {
                    id = v.Data.id,
                    label = v.Data.label,
                })
            end
        end

        return aux
    end

end


function Custom:GetPlayerGang(source)
    if GetResourceState('origen_ilegal') == 'started' then
        local gang = exports['origen_ilegal']:GetGangID(source)
        return (gang and gang or 'none')
    end
    if Config.Framework == 'qbcore' then
        local Player = Framework:GetPlayer(source)
        local gang = Player.PlayerData.gang.name
        return (gang and gang or 'none')
    else
        debuger('You need to add your own gang system on Custom:GetPlayerGang() custom/server/server.lua')
        return 'none'
    end
end


------------------------------------------------------------------------
------------------------------------------------------------------------

-- [ENGLISH]: IF YOU DONT KNOW WHAT ARE YOU DOING DONT TOUCH THIS
-- [CASTELLANO]: SI NO SABES QUE ES ESTO PORFAVOR NO TOQUES NADA DE ESTO
-- [ANDALUZ]: ÇI NO ÇABÊ QUE ÊH ÊTTO PORFABÔH NO TOQUÊ NÁ DE ÊTTO
-- [FRENCH]: SI VOUS NE SAVEZ PAS CE QUE C'EST, VEUILLEZ NE TOUCHER À RIEN
-- [CATALÁ]: SI NO SAPS QUE ÉS AIXÒ PORFAVOR NO TOCS RES
-- [CHINESSE]: 如果您不知道這是什麼，請不要觸摸任何東西
-- [JAPANESSE]: これが何なのか分からない場合は、何も触れないでください
-- [KOREAN]: 이게 뭔지 모르시면 아무 것도 만지지 마세요

------------------------------------------------------------------------
------------------------------------------------------------------------

function Custom:GetAllItems()
    local _items = {}
    local item_data = {}
    local missing_items = {}
    if Config.Inventory == 'ox_inventory' then
        item_data = exports.ox_inventory:ItemList()
    elseif Config.Inventory == 'origen_inventory' then
        if Config.Framework == 'qbcore' then
            item_data = Framework.Core.Shared.Items
        else
            item_data = exports.origen_inventory:GetItemList()
        end
    elseif Config.Inventory == 'qs-inventory' then
        item_data = exports['qs-inventory']:GetItemList()
    elseif Config.Inventory == 'qb-inventory' then
        item_data = Framework.Core.Shared.Items
    elseif Config.Inventory == 'none' then
        if Config.Framework == 'qbcore' then
            item_data = Framework.Core.Shared.Items
        elseif Config.Framework == 'esx' then
            debuger('You need to add your own items on Custom:GetAllItems() custom/server/server.lua')
        end
    else
        debuger('You need to add your own items on Custom:GetAllItems() custom/server/server.lua')
    end
    if next(item_data) then
        for k,v in pairs(item_data) do
            if not v.name then
                missing_items[#missing_items+1] = k
                goto skip
            end
            _items[v.name:lower()] = {
                name = v.name:lower(),
                label = v.label,
                description = (v and v.description) or ''
            }
            ::skip::
        end
    end
    if next(missing_items) then
        debuger("Items without assigned names:")
        for _, item in ipairs(missing_items) do
            debuger('- '..item)
        end
    end
    return _items
end