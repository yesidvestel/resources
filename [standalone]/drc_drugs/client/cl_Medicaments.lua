local TSE = TriggerServerEvent
RegisterNetEvent("drc_drugs:medicaments:menus", function(data)
    PlayPedAmbientSpeechNative(MedicamentNPC, 'Generic_Hows_It_Going', 'Speech_Params_Force')
    if data.shop == "medicaments" then
        options = {}
        if Config.Context == "qbcore" then
            options[1] = {
                isMenuHeader = true,
                header = Config.MedicamentsShop.Header
            }
            for _, v in pairs(Config.MedicamentsShop.Items) do
                options[#options+1] = {
                    header = v.label,
                    txt = v.description .. v.price,
                    params = {
                        event = 'drc_drugs:medicaments:progress',
                        args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                    }
                }
            end
            exports['qb-menu']:openMenu(options)
        elseif Config.Context == "ox_lib" then
            for _, v in pairs(Config.MedicamentsShop.Items) do
                options[#options+1] = {
                    title = v.label,
                    description = v.description .. v.price,
                    event = 'drc_drugs:medicaments:progress',
                    args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                }
            end
            lib.registerContext({
                id = 'MedicamentsMenu',
                title = Config.MedicamentsShop.Header,
                options = options
            })
            lib.showContext('MedicamentsMenu')
        end
    end
end)

RegisterNetEvent("drc_drugs:medicaments:progress")
AddEventHandler("drc_drugs:medicaments:progress", function(data)
    if Config.Input == "qb-input" then
        local dialog = exports['qb-input']:ShowInput({
            header = locale("Pricefor") .. data.price,
            submitText = "Submit",
            inputs = {
                {
                    text = locale("Amount") .. locale("Range") .. data.min .. ' - ' .. data.max,
                    name = "amount",
                    type = "number",
                    isRequired = true,
                }
            }
        })
        if dialog then
            amount = tonumber(dialog["amount"])
        end
    elseif Config.Input == "ox_lib" then
        amount = lib.inputDialog(locale("Pricefor") .. data.price,
            { locale("Amount") .. locale("Range") .. data.min .. ' - ' .. data.max })
        amount = tonumber(amount[1])
    end

    if amount then
        if tonumber(amount) >= data.min and tonumber(amount) <= data.max then
            lib.callback('drc_drugs:medicaments:getitem', false, function(value)
                if value then
                    if not IsProgressBarActive() then
                        dict = "misscarsteal4@actor"
                        clip = "actor_berating_loop"
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Wait(0) end
                        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                        if Config.Target == 'ox_target' then
                            exports.ox_target:disableTargeting(true)
                        end
                        FreezeEntityPosition(cache.ped, true)
                        ProgressBar(6000, locale("Buying"))
                        StopAnimTask(cache.ped, dict, clip, 1.0)
                        Wait(0)
                        PlayPedAmbientSpeechNative(MedicamentNPC, 'GENERIC_THANKS', 'Speech_Params_Force_Shouted_Critical')
                        FreezeEntityPosition(cache.ped, false)
                        ClearPedTasks(cache.ped)
                        if Config.Target == 'ox_target' then
                            exports.ox_target:disableTargeting(false)
                        end
                        TSE("drc_drugs:medicaments:giveitems", data.item, data.price, amount)
                    end
                else
                    Notify("error", locale("error"), locale("RequiredItems"))
                end
            end, data.price, amount)
        else
            Notify("error", locale("error"), locale("IvalidAmount"))
        end
    else
        Notify("error", locale("error"), locale("IvalidAmount"))
    end
end)

local MedicamentsShopPed = nil
local Spawned = false
CreateThread(function()
    while true do
        Wait(1000)
        if Config.MedicamentsShop.enabled then
            for _, v in pairs(Config.MedicamentsShop.Ped) do
                local Coords = GetEntityCoords(PlayerPedId())
                local distance = #(Coords - vec3(v.coords))
                if distance < 20 and not Spawned then
                    Spawned = true
                    RequestModel(GetHashKey(v.model))

                    while not HasModelLoaded(GetHashKey(v.model)) do
                        Wait(100)
                    end

                    MedicamentNPC = CreatePed(4, v.model, v.coords, false, true)
                    MedicamentsShopPed = MedicamentNPC

                    if Config.InteractionType ~= "target" then
                        lib.zones.sphere({
                            coords = GetEntityCoords(MedicamentNPC),
                            radius = 1,
                            debug = Config.Debug,
                            inside = function(self)
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("drc_drugs:medicaments:menus", {shop = "medicaments"})
                                end
                
                                if Config.InteractionType == "3dtext" then
                                    Draw3DText(self.coords, "[~g~E~w~] - " .. locale('shop'))
                                end
                            end,
                            onEnter = function()
                                if Config.InteractionType == "textui" then
                                        TextUIShow("[E] - " .. locale('shop'))
                                end    
                            end,
                            onExit = function()
                                if Config.InteractionType == "textui" then
                                    TextUIHide()
                                end
                            end
                        })
                    else
                        target = Target()
                        target:AddTargetEntity(MedicamentNPC, {
                            options = {
                                {
                                    event = "drc_drugs:medicaments:menus",
                                    icon = "fas fa-skull",
                                    label = locale("shop"),
                                    shop = "medicaments"
                                },
                            },
                            distance = 2
                        })
                    end
                    for i = 0, 255, 51 do
                        Wait(50)
                        SetEntityAlpha(MedicamentNPC, i, false)
                    end
                    FreezeEntityPosition(MedicamentNPC, true)
                    SetEntityInvincible(MedicamentNPC, true)
                    SetBlockingOfNonTemporaryEvents(MedicamentNPC, true)
                    TaskStartScenarioInPlace(MedicamentNPC, v.scenario, 0, true)
                elseif distance >= 20 and Spawned then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(MedicamentsShopPed, i, false)
                    end
                    DeletePed(MedicamentsShopPed)
                    Spawned = false
                end
            end
        end
    end
end)
