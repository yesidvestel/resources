local TSE = TriggerServerEvent
RegisterNetEvent("drc_drugs:pharmacist:Menus")
AddEventHandler("drc_drugs:pharmacist:Menus", function(data)
    if data.shop == "PharmacistShop" then
        local h = GetClockHours()
        if Config.Pharmacist.Available.enabled then
            if h > Config.Pharmacist.Available.from - 1.0 and h < Config.Pharmacist.Available.to + 1.0 then
                options = {}
                if Config.Context == "qbcore" then
                    options[1] = {
                        isMenuHeader = true,
                        header = Config.Pharmacist.Header
                    }
                    for _, v in pairs(Config.Pharmacist.Items) do
                        options[#options+1] = {
                            header = v.label,
                            txt = v.description .. v.price,
                            params = {
                                event = 'drc_drugs:pharmacist:progress',
                                args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                            }
                        }
                    end
                    exports['qb-menu']:openMenu(options)
                elseif Config.Context == "ox_lib" then
                    for _, v in pairs(Config.Pharmacist.Items) do
                        options[#options+1] = {
                            title = v.label,
                            description = v.description .. v.price,
                            event = 'drc_drugs:pharmacist:progress',
                            args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                        }
                    end
                    lib.registerContext({
                        id = 'PharmacistShop',
                        title = Config.Pharmacist.Header,
                        options = options
                    })
                    lib.showContext('PharmacistShop')
                end
            else
                Notify("info", locale("Pharmacist"), locale("PharmacistBreak"))
            end
        else
            options = {}
            if Config.Context == "qbcore" then
                options[1] = {
                    isMenuHeader = true,
                    header = Config.Pharmacist.Header
                }
                for _, v in pairs(Config.Pharmacist.Items) do
                    options[#options+1] = {
                        header = v.label,
                        txt = v.description .. v.price,
                        params = {
                            event = 'drc_drugs:pharmacist:progress',
                            args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                        }
                    }
                end
                exports['qb-menu']:openMenu(options)
            elseif Config.Context == "ox_lib" then
                for _, v in pairs(Config.Pharmacist.Items) do
                    options[#options+1] = {
                        title = v.label,
                        description = v.description .. v.price,
                        event = 'drc_drugs:pharmacist:progress',
                        args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                    }
                end
                lib.registerContext({
                    id = 'PharmacistShop',
                    title = Config.Pharmacist.Header,
                    options = options
                })
                lib.showContext('PharmacistShop')
            end
        end
    end
end)

RegisterNetEvent("drc_drugs:pharmacist:progress")
AddEventHandler("drc_drugs:pharmacist:progress", function(data)
    if data.shop == "PharmacistShop" then
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
                lib.callback('drc_drugs:pharmacist:getitem', false, function(value)
                    if value then
                        if not lib.progressActive() then
                            for _, v in pairs(Config.Pharmacist.Ped) do
                                TaskTurnPedToFaceCoord(cache.ped, v.coords, 4000)
                            end
                            dict = "misscarsteal4@actor"
                            clip = "actor_berating_loop"
                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Wait(0) end
                            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                            if Config.Target == 'ox_target' then
                                exports.ox_target:disableTargeting(true)
                            end
                            FreezeEntityPosition(cache.ped, true)
                            ProgressBar(15000, locale("Buying"))
                            StopAnimTask(cache.ped, dict, clip, 1.0)
                            Wait(0)
                            PlayPedAmbientSpeechNative(PharmacistPed, 'GENERIC_THANKS', 'SPEECH_PARAMS_FORCE')
                            FreezeEntityPosition(cache.ped, false)
                            ClearPedTasks(cache.ped)
                            if Config.Target == 'ox_target' then
                                exports.ox_target:disableTargeting(false)
                            end
                            TSE("drc_drugs:pharmacist:giveitems", data.item, data.price, amount)
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
    end
end)

local PharmacistPed = nil
local Spawned = false
CreateThread(function()
    while true do
        Wait(1000)
        if Config.Pharmacist.enabled then
            for _, v in pairs(Config.Pharmacist.Ped) do
                local Coords = GetEntityCoords(PlayerPedId())
                local distance = #(Coords - vec3(v.coords))
                if distance < 20 and not Spawned then
                    Spawned = true
                    RequestModel(GetHashKey(v.model))

                    while not HasModelLoaded(GetHashKey(v.model)) do
                        Wait(100)
                    end

                    local Pharmacist = CreatePed(4, v.model, v.coords, false, true)
                    PharmacistPed = Pharmacist
                    if Config.InteractionType ~= "target" then
                        lib.zones.sphere({
                            coords = GetEntityCoords(Pharmacist),
                            radius = 1,
                            debug = Config.Debug,
                            inside = function(self)
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("drc_drugs:pharmacist:Menus", {shop = "PharmacistShop"})
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
                        target:AddTargetEntity(Pharmacist, {
                            options = {
                                {
                                    event = "drc_drugs:pharmacist:Menus",
                                    icon = "fas fa-book-medical",
                                    label = locale("shop"),
                                    shop = "PharmacistShop"
                                },
                            },
                            distance = 2
                        })
                    end
                    for i = 0, 255, 51 do
                        Wait(50)
                        SetEntityAlpha(Pharmacist, i, false)
                    end
                    FreezeEntityPosition(Pharmacist, true)
                    SetEntityInvincible(Pharmacist, true)
                    SetBlockingOfNonTemporaryEvents(Pharmacist, true)
                    TaskStartScenarioInPlace(Pharmacist, v.scenario, 0, true)
                elseif distance >= 20 and Spawned then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(PharmacistPed, i, false)
                    end
                    DeletePed(PharmacistPed)
                    Spawned = false
                end
            end
        end
    end
end)
