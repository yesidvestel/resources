Citizen.CreateThread(function()
    for k, v in pairs(Config.BillsNPCs) do
        RequestModel(GetHashKey(v.model))

        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(1)
        end

        local npc = CreatePed(4, GetHashKey(v.model), v.coords.x, v.coords.y, v.coords.z - 1, v.coords.w, false, true)
        SetEntityHeading(npc, v.coords.w)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        TaskStartScenarioInPlace(npc, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end

    local notify = false
    local inRangeNPCs = {}

    while true do
        local wait = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        local anyNPCInRange = false

        for k, v in pairs(Config.BillsNPCs) do
            if #(playerCoords - v.coords.xyz) < 2.5 then
                anyNPCInRange = true
                inRangeNPCs[k] = true
                wait = 5

                if Config.CustomNotify then
                    if Config.customDrawText and not notify then
                        Custom.DrawText("E", "Check your bills")
                        notify = true
                    else
                        ShowHelpNotification("E", "Check your bills")
                    end
                else
                    if Config.Framework == "qb-core" then
                        if not notify then
                            exports['qb-core']:DrawText("[E] - Check your bills", 'left')
                            notify = true
                        end
                    elseif Config.Framework == "esx" then
                        ESX.ShowHelpNotification("~INPUT_PICKUP~ Check your bills", true)
                    end
                end

                if IsControlJustPressed(0, 38) then
                    ShowBills()
                end
            else
                inRangeNPCs[k] = nil
            end
        end

        if not anyNPCInRange and notify then
            if Config.Framework == "qb-core" and not Config.CustomNotify then
                exports['qb-core']:HideText()
            elseif Config.CustomNotify and Config.customDrawText then
                Custom.HideText()
            end
            notify = false
        end

        Citizen.Wait(wait)
    end
end)

function ShowBills()
    FW_TriggerCallback("origen_masterjob:server:GetBills", function(bills)
        if Config.Framework == "qb-core" then
            local menu = {
                {
                    header = "Bills",
                    isMenuHeader = true,
                }
            }

            for i = 1, #bills do
                local txt = ""
                if type(bills[i].concepts) == 'table' then
                    bills[i].concepts = json.decode(bills[i].concepts)
                    for j = 1, #bills[i].concepts do
                        txt = txt .. bills[i].concepts[j] .. "<br>"
                    end
                else
                    txt = tostring(bills[i].concepts)
                end


                table.insert(menu, {
                    header = bills[i].title .. ': <span style="color: green; font-weight: bold">$' .. bills[i].price .. "</span>",
                    txt = txt,
                    params = {
                        event = "origen_masterjob:server:PayBill",
                        isServer = true,
                        args = bills[i]
                    }
                })
            end
        
            exports["qb-menu"]:openMenu(menu)
        elseif Config.Framework == "esx" then
            local elements = {}

            for i = 1, #bills do
                table.insert(elements, {
                    label = bills[i].title .. ': <span style="color: green; font-weight: bold">$' .. bills[i].price .. "</span>",
                    value = bills[i].id,
                    price = bills[i].price,
                    job = bills[i].job
                })
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bills', {
                title    = "Bills",
                align    = 'bottom-right',
                elements = elements
            }, function(data, menu)
                TriggerServerEvent("origen_masterjob:server:PayBill", {
                    id = data.current.value,
                    price = data.current.price,
                    job = data.current.job
                })
                menu.close()
            end, function(data, menu)
                menu.close()
            end)
        end
    end)
end

exports('ShowBills', ShowBills)

exports("GetBills", function()
    local p = promise:new()
    FW_TriggerCallback("origen_masterjob:server:GetBills", function(bills)
        p:resolve(bills)
    end)
    return Citizen.Await(p)
end)