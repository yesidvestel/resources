local NPCEntities = {}

function CreateNPCsBills()
    for _, npcCoord in pairs(BillsNPCPositions) do 
        Citizen.CreateThread(function()
            RequestModel(GetHashKey("s_m_y_cop_01"))
        
            while not HasModelLoaded(GetHashKey("s_m_y_cop_01")) do
                Wait(1)
            end
            local npc = CreatePed(4, GetHashKey("s_m_y_cop_01"), npcCoord.x, npcCoord.y, npcCoord.z - 1, npcCoord.w, false, true)
            NPCEntities[#NPCEntities + 1] = npc
            SetEntityHeading(npc, npcCoord.w)
            FreezeEntityPosition(npc, true)
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            TaskStartScenarioInPlace(npc, "WORLD_HUMAN_CLIPBOARD", 0, true)
        
            local notify = false
        
            while true do
                local wait = 1000
        
                if #(GetEntityCoords(PlayerPedId()) - npcCoord.xyz) < 2.5 then
                    wait = 5
        
                    if Config.CustomNotify then
                        ShowHelpNotification("E", "Check your bills")
                        notify = true
                    else
                        if Config.Framework == "qbcore" then
                            if not notify then
                                exports['qb-core']:DrawText("[E] - Check your bills", 'left')
                                notify = true
                            end
                        elseif Config.Framework == "esx" then
                            Framework.ShowHelpNotification("~INPUT_PICKUP~ Check your bills", true)
                        end
                    end
        
                    if IsControlJustPressed(0, 38) then
                        ShowBills()
                    end
                elseif notify then
                    HideHelpNotification()
                    notify = false
                end
        
                Citizen.Wait(wait)
            end
        end)
    end
end

function ClearNPCsBills()
    for _, npc in pairs(NPCEntities) do 
        DeleteEntity(npc)
    end
end

function ShowBills()
    FW_TriggerCallback("origen_police:server:GetBills", function(bills)
        if Config.Framework == "qbcore" then
            local menu = {
                {
                    header = "Bills",
                    isMenuHeader = true,
                }
            }

            for i = 1, #bills do
                local txt = ""
                local title = (bills[i].title and bills[i].title) or 'Bill'

                bills[i].concepts = json.decode(bills[i].concepts)
                for j = 1, #bills[i].concepts do
                    txt = txt .. bills[i].concepts[j] .. "<br>"
                end

                table.insert(menu, {
                    header = title .. ': $' .. bills[i].price .. "",
                    txt = txt,
                    params = {
                        event = "origen_police:server:PayBill",
                        isServer = true,
                        args = {
                            id = bills[i].id,
                            price = bills[i].price,
                            job = bills[i].job
                        }
                    }
                })
            end
        
            OpenMenu(menu)
        elseif Config.Framework == "esx" then
            local elements = {}

            for i = 1, #bills do
                local title = (bills[i].title and bills[i].title) or 'Bill'
                table.insert(elements, {
                    label = title .. ': $' .. bills[i].price .. "",
                    value = bills[i].id,
                    price = bills[i].price,
                    job = bills[i].job
                })
            end

            OpenMenu('default', GetCurrentResourceName(), 'bills', {
                title    = "Bills",
                align    = 'bottom-right',
                elements = elements
            }, function(data, menu)
                TriggerServerEvent("origen_police:server:PayBill", {
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

exports("ShowBills", ShowBills)
RegisterNetEvent("origen_police:client:ShowBills", function()
    ShowBills()
end)

exports("GetBills", function()
    FW_TriggerCallback("origen_police:server:GetBills", function(bills)
        return bills
    end)
end)