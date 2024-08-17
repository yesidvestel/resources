RegisterNetEvent("origen_police:client:domyfinguer", function()
    local PlayerData = FW_GetPlayerData(false)
    local text = Config.Translations['domyfinguer']:format((PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname))
    UseCommand('me', text)
end)

function OpenArmoury()
    if Config.Inventory == "qb-inventory" or Config.Inventory == "new-qb-inventory" or Config.Inventory == "origen_inventory" or Config.Inventory == "qs-inventory" or Config.Inventory == "ls-inventory" then 
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Equipment", Config.Armory)
        if Config.Inventory == "new-qb-inventory" then
            TriggerServerEvent("origen_police:new-qb-inv:OpenArmoury")
        end
    elseif Config.Inventory == "ox_inventory" then
        TriggerServerEvent("origen_police:ox:server:Armoury")
        exports.ox_inventory:openInventory('shop', { type = 'OrigenPoliceArmoury', id = 1})
    elseif Config.Inventory == "codem-inventory" then 
        TriggerEvent('codem-inventory:openshop', 'OrigenPoliceShop')
    else
        ShowNotification(Config.Translations.InvNotSupported)
    end
end

function LeavePoliceEquipment(p)
    local PlayerData = FW_GetPlayerData(false)
    local invID = "armas_policiales_" .. (p.station or 0).."_"..PlayerData.citizenid
    if Config.Inventory == "qb-inventory" or Config.Inventory == "new-qb-inventory" or Config.Inventory == "origen_inventory" or Config.Inventory == "qs-inventory" or Config.Inventory == "ls-inventory" or Config.Inventory == "codem-inventory" then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", invID, {
            maxweight = 100000,
            slots = 100,
            label = "Police equipment"
        })
        TriggerEvent("inventory:client:SetCurrentStash", invID)
        if Config.Inventory == "new-qb-inventory" then 
            TriggerServerEvent("origen_police:new-qb-inv:OpenStash", invID, "Police equipment", 100000, 100)
        end
    elseif Config.Inventory == "ox_inventory" then
        invID = invID:gsub("_"..PlayerData.citizenid, "")
        exports.ox_inventory:openInventory('stash', {id=invID, owner = PlayerData.citizenid})
    else
        ShowNotification(Config.Translations.InvNotSupported)
    end
end

function PoliceInventory(p)
    local PlayerData = FW_GetPlayerData(false)
    if Config.Inventory == "qb-inventory" or Config.Inventory == "new-qb-inventory" or Config.Inventory == "origen_inventory" or Config.Inventory == "qs-inventory" or Config.Inventory == "ls-inventory" or Config.Inventory == "codem-inventory" then 
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "inventario_policial_" .. (p.station or 0), {
            maxweight = 100000,
            slots = 100,
            label = "Police inventory"
        })
        TriggerEvent("inventory:client:SetCurrentStash", "inventario_policial_" .. (p.station or 0))
        if Config.Inventory == "new-qb-inventory" then 
            TriggerServerEvent("origen_police:new-qb-inv:OpenStash", "inventario_policial_" .. (p.station or 0), "Police Inventory", 100000, 100)
        end
    elseif Config.Inventory == "ox_inventory" then
        exports.ox_inventory:openInventory('stash', {id='OrigenPersonalStash', owner = 'inventario_policial_'..(p.station or 0)})
    else
        ShowNotification(Config.Translations.InvNotSupported)
    end
end

function OpenEvidenceInventory(p)
    if Config.Inventory == "qb-inventory" or Config.Inventory == "new-qb-inventory" or Config.Inventory == "origen_inventory" or Config.Inventory == "qs-inventory" or Config.Inventory == "ls-inventory" or Config.Inventory == "codem-inventory" then
        OpenMenu('dialog', GetCurrentResourceName(), 'evidenceInventory', {
            title = "Enter the Evidence ID",
        }, function(data, menu)
            if data and data.value then
                local text = data.value
                if text and text:gsub("%s+", "") ~= "" then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", text, {
                        maxweight = 50000,
                        slots = 50,
                        label = "Drawer: " .. text
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", text)
                    if Config.Inventory == "new-qb-inventory" then 
                        TriggerServerEvent("origen_police:new-qb-inv:OpenStash", text, "Drawer: " .. text, 50000, 50)
                    end
                end

                menu.close()
            else
                ShowNotification(Config.Translations.MustEnterNumber)
            end
        end, function(data, menu)
            menu.close()
        end)
    elseif Config.Inventory == "ox_inventory" then
        exports.ox_inventory:openInventory('policeevidence')
    end
end

function CanOpenQuickAccessMenu()
    -- Check if player can open quick access menu
    local PlayerData = FW_GetPlayerData(false)
    if PlayerData == nil or PlayerData.job == nil or PlayerData.job.name == nil then return false end
    return (CanOpenTablet(PlayerData.job.name)[1] and PlayerData.job.onduty)
end

function handCuff(cb) -- This is just a callback so you can do anything you want, there's no need to add anything if you don't want to.
    cb(true)
end