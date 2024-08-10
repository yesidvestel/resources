local TSE = TriggerServerEvent
RegisterNetEvent("drc_drugs:comicshop:Menus", function(data)
    PlayPedAmbientSpeechNative(ComicNPC, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE')
    if data.shop == "comicshop" then
        options = {}
        if Config.Context == "qbcore" then
            options[1] = {
                isMenuHeader = true,
                header = Config.ComicShop.Header
            }
            for _, v in pairs(Config.ComicShop.Items) do
                options[#options+1] = {
                    header = v.label,
                    txt = v.description .. v.price,
                    params = {
                        event = 'drc_drugs:comicshop:progress',
                        args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                    }
                }
            end
            exports['qb-menu']:openMenu(options)
        elseif Config.Context == "ox_lib" then
            for _, v in pairs(Config.ComicShop.Items) do
                options[#options+1] = {
                    title = v.label,
                    description = v.description .. v.price,
                    event = 'drc_drugs:comicshop:progress',
                    args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                }
            end
            lib.registerContext({
                id = 'ComicShop',
                title = Config.ComicShop.Header,
                options = options
            })
            lib.showContext('ComicShop')
        end
    end
end)

RegisterNetEvent("drc_drugs:comicshop:progress")
AddEventHandler("drc_drugs:comicshop:progress", function(data)
    if data.shop == "comicshop" then
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
                lib.callback('drc_drugs:comicshop:getitem', false, function(value)
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
                            PlayPedAmbientSpeechNative(ComicNPC, 'GENERIC_THANKS', 'SPEECH_PARAMS_FORCE')
                            FreezeEntityPosition(cache.ped, false)
                            ClearPedTasks(cache.ped)
                            if Config.Target == 'ox_target' then
                                exports.ox_target:disableTargeting(false)
                            end
                            TSE("drc_drugs:comicshop:giveitems", data.item, data.price, amount)
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

local ComicShopPed = nil
local Spawned = false
CreateThread(function()
    while true do
        Wait(1000)
        if Config.ComicShop.enabled then
            for _, v in pairs(Config.ComicShop.Ped) do
                local Coords = GetEntityCoords(PlayerPedId())
                local distance = #(Coords - vec3(v.coords))
                if distance < 20 and not Spawned then
                    Spawned = true
                    RequestModel(GetHashKey(v.model))

                    while not HasModelLoaded(GetHashKey(v.model)) do
                        Wait(1)
                    end

                    ComicNPC = CreatePed(4, v.model, v.coords, false, true)
                    ComicShopPed = ComicNPC

                    if Config.InteractionType ~= "target" then
                        lib.zones.sphere({
                            coords = GetEntityCoords(ComicNPC),
                            radius = 1,
                            debug = Config.Debug,
                            inside = function(self)
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("drc_drugs:comicshop:Menus", {shop = "comicshop"})
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
                        target:AddTargetEntity(ComicNPC, {
                            options = {
                                {
                                    event = "drc_drugs:comicshop:Menus",
                                    icon = "fas fa-store",
                                    label = locale("shop"),
                                    shop = "comicshop"
                                },
                            },
                            distance = 2
                        })
                    end
                    for i = 0, 255, 51 do
                        Wait(50)
                        SetEntityAlpha(ComicNPC, i, false)
                    end
                    FreezeEntityPosition(ComicNPC, true)
                    SetEntityInvincible(ComicNPC, true)
                    SetBlockingOfNonTemporaryEvents(ComicNPC, true)
                    TaskStartScenarioInPlace(ComicNPC, v.scenario, 0, true)
                elseif distance >= 20 and Spawned then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(ComicShopPed, i, false)
                    end
                    DeletePed(ComicShopPed)
                    Spawned = false
                end
            end
        end
    end
end)
