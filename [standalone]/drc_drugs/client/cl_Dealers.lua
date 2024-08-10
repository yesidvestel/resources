local TSE = TriggerServerEvent

SetTimeout(2000, function()
    if Config.InteractionType == "target" then
        target = Target()
        if Config.LocateDealer.enabled then
            target:RemoveZone('DealerLocation1')
            target:AddCircleZone("DealerLocation1", Config.LocateDealer.Location.Coords,
                Config.LocateDealer.Location.radius,
                { name = "DealerLocation1", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:dealers:progress", icon = "fas fa-desktop", label = locale("LocateDealer"),
                        shop = "LocateDealer1",
                    }
                },
                    distance = 2.5
                }
            )
        end
        if Config.Gerald.enabled then
            target:RemoveZone('GeraldLocation')
            target:AddCircleZone("GeraldLocation", Config.Gerald.Location.Coords, Config.Madrazo.Location.radius,
                { name = "GeraldLocation", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:dealers:menus", icon = "fas fa-cannabis", label = locale("Gerald"),
                        shop = "GeraldShop",
                    }
                },
                    distance = 2.5
                }
            )
        end
        if Config.Madrazo.enabled then
            target:RemoveZone('MadrazoLocation')
            target:AddCircleZone("MadrazoLocation", Config.Madrazo.Location.Coords, Config.Madrazo.Location.radius,
                { name = "MadrazoLocation", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:dealers:menus", icon = "fas fa-capsules", label = locale("Madrazo"),
                        shop = "MadrazoTrade",
                    }
                },
                    distance = 2.5
                }
            )
        end
    else
        if Config.LocateDealer.enabled then
            lib.zones.sphere({
                coords = Config.LocateDealer.Location.Coords,
                radius = Config.LocateDealer.Location.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:dealers:progress", {shop = "LocateDealer1"})
                    end

                    if Config.InteractionType == "3dtext" then
                        Draw3DText(self.coords, "[~g~E~w~] - " .. locale("LocateDealer"))
                    end
                end,
                onEnter = function()
                    if Config.InteractionType == "textui" then
                        TextUIShow("[E] - " .. locale("LocateDealer"))
                    end    
                end,
                onExit = function()
                    if Config.InteractionType == "textui" then
                        TextUIHide()
                    end
                end
            })
        end
        if Config.Gerald.enabled then
            lib.zones.sphere({
                coords = Config.Gerald.Location.Coords,
                radius = Config.Gerald.Location.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:dealers:menus", {shop = "GeraldShop"})
                    end

                    if Config.InteractionType == "3dtext" then
                        Draw3DText(self.coords, "[~g~E~w~] - " .. locale("Gerald"))
                    end
                end,
                onEnter = function()
                    if Config.InteractionType == "textui" then
                        TextUIShow("[E] - " .. locale("Gerald"))
                    end    
                end,
                onExit = function()
                    if Config.InteractionType == "textui" then
                        TextUIHide()
                    end
                end
            })
        end
        if Config.Madrazo.enabled then
            lib.zones.sphere({
                coords = Config.Madrazo.Location.Coords,
                radius = Config.Madrazo.Location.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:dealers:menus", {shop = "MadrazoTrade"})
                    end

                    if Config.InteractionType == "3dtext" then
                        Draw3DText(self.coords, "[~g~E~w~] - " .. locale("Madrazo"))
                    end
                end,
                onEnter = function()
                    if Config.InteractionType == "textui" then
                        TextUIShow("[E] - " .. locale("Madrazo"))
                    end    
                end,
                onExit = function()
                    if Config.InteractionType == "textui" then
                        TextUIHide()
                    end
                end
            })
        end
    end
end)

RegisterNetEvent("drc_drugs:dealers:menus")
AddEventHandler("drc_drugs:dealers:menus", function(data)
    if data.shop == "GeraldShop" then
        if not IsProgressBarActive() then
            SetEntityHeading(cache.ped, Config.Gerald.Location.Heading)
            Wait(1500)
            dict = "mini@safe_cracking"
            clip = "idle_base"
            RequestAnimDict(dict)
            while (not HasAnimDictLoaded(dict)) do Wait(0) end
            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(true)
            end
            FreezeEntityPosition(cache.ped, true)
            ProgressBar(2000, locale("Listening"))
            StopAnimTask(cache.ped, dict, clip, 1.0)
            Wait(0)
            FreezeEntityPosition(cache.ped, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(false)
            end
            if Config.Gerald.Available.enabled then
                local h = GetClockHours()
                if h > Config.Gerald.Available.from and h < Config.Gerald.Available.to then
                    if Config.Context == "qbcore" then
                        exports['qb-menu']:openMenu({
                            {
                                isMenuHeader = true,
                                header = Config.Gerald.Header
                            },
                            {
                                header = Config.Gerald.Title,
                                txt = Config.Gerald.Description,
                                params = {
                                    event = 'drc_drugs:dealers:progress',
                                    args = { shop = data.shop }
                                }
                            }
                        })
                    elseif Config.Context == "ox_lib" then
                        lib.registerContext({
                            id = 'GeraldShopMenu',
                            title = Config.Gerald.Header,
                            options = {
                                [Config.Gerald.Title] = {
                                    arrow = false,
                                    description = Config.Gerald.Description,
                                    event = 'drc_drugs:dealers:progress',
                                    args = { shop = data.shop }
                                }
                            }
                        })
                        lib.showContext('GeraldShopMenu')
                    end
                else
                    Notify("info", locale("Gerald"), locale("GeraldNotHome"))
                end
            else
                if Config.Context == "qbcore" then
                    exports['qb-menu']:openMenu({
                        {
                            isMenuHeader = true,
                            header = Config.Gerald.Header
                        },
                        {
                            header = Config.Gerald.Title,
                            txt = Config.Gerald.Description,
                            params = {
                                event = 'drc_drugs:dealers:progress',
                                args = { shop = data.shop }
                            }
                        }
                    })
                elseif Config.Context == "ox_lib" then
                    lib.registerContext({
                        id = 'GeraldShopMenu',
                        title = Config.Gerald.Header,
                        options = {
                            [Config.Gerald.Title] = {
                                arrow = false,
                                description = Config.Gerald.Description,
                                event = 'drc_drugs:dealers:progress',
                                args = { shop = data.shop }
                            }
                        }
                    })
                    lib.showContext('GeraldShopMenu')
                end
            end
        end
    elseif data.shop == "MadrazoTrade" then
        if not IsProgressBarActive() then
            SetEntityHeading(cache.ped, Config.Madrazo.Location.Heading)
            Wait(1500)
            if not IsProgressBarActive() then
                dict = "mini@safe_cracking"
                clip = "idle_base"
                RequestAnimDict(dict)
                while (not HasAnimDictLoaded(dict)) do Wait(0) end
                TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                if Config.Target == 'ox_target' then
                    exports.ox_target:disableTargeting(true)
                end
                FreezeEntityPosition(cache.ped, true)
                ProgressBar(2000, locale("Listening"))
                StopAnimTask(cache.ped, dict, clip, 1.0)
                Wait(0)
                FreezeEntityPosition(cache.ped, false)
                if Config.Target == 'ox_target' then
                    exports.ox_target:disableTargeting(false)
                end
                if Config.Madrazo.Available.enabled then
                    local h = GetClockHours()
                    if h > 0 and h < 23 then
                        if Config.Context == "qbcore" then
                            exports['qb-menu']:openMenu({
                                {
                                    isMenuHeader = true,
                                    header = Config.Madrazo.Header
                                },
                                {
                                    header = Config.Madrazo.Title,
                                    txt = Config.Madrazo.Description,
                                    params = {
                                        event = 'drc_drugs:dealers:progress',
                                        args = { shop = data.shop }
                                    }
                                }
                            })
                        elseif Config.Context == "ox_lib" then
                            lib.registerContext({
                                id = 'MadrazoShopMenu',
                                title = Config.Madrazo.Header,
                                options = {
                                    [Config.Madrazo.Title] = {
                                        arrow = false,
                                        description = Config.Madrazo.Description,
                                        event = 'drc_drugs:dealers:progress',
                                        args = { shop = data.shop }
                                    }
                                }
                            })
                            lib.showContext('MadrazoShopMenu')
                        end
                    else
                        Notify("info", locale("Madrazo"), locale("MadrazoNotHome"))
                    end
                else
                    if Config.Context == "qbcore" then
                        exports['qb-menu']:openMenu({
                            {
                                isMenuHeader = true,
                                header = Config.Madrazo.Header
                            },
                            {
                                header = Config.Madrazo.Title,
                                txt = Config.Madrazo.Description,
                                params = {
                                    event = 'drc_drugs:dealers:progress',
                                    args = { shop = data.shop }
                                }
                            }
                        })
                    elseif Config.Context == "ox_lib" then
                        lib.registerContext({
                            id = 'MadrazoShopMenu',
                            title = Config.Madrazo.Header,
                            options = {
                                [Config.Madrazo.Title] = {
                                    arrow = false,
                                    description = Config.Madrazo.Description,
                                    event = 'drc_drugs:dealers:progress',
                                    args = { shop = data.shop }
                                }
                            }
                        })
                        lib.showContext('MadrazoShopMenu')
                    end
                end
            end
        end
    elseif data.shop == "DealerShop" then
        options = {}

        if Config.Context == "qbcore" then
            for _, v in pairs(Config.Dealer.Items) do
                options[#options+1] = {
                    header = v.label,
                    txt = v.description .. v.price,
                    params = {
                        event = 'drc_drugs:dealers:progress',
                        args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount,
                        max = v.MaxAmount }
                    }
                }
            end

            exports['qb-menu']:openMenu(options)
        elseif Config.Context == "ox_lib" then
            for _, v in pairs(Config.Dealer.Items) do
                options[#options+1] = {
                    title = v.label,
                    description = v.description .. v.price,
                    event = 'drc_drugs:dealers:progress',
                    args = { shop = data.shop, item = v.item, price = v.price, min = v.MinAmount, max = v.MaxAmount }
                }
            end
            lib.registerContext({
                id = 'DealerShop',
                title = Config.Dealer.Header,
                options = options
            })
            lib.showContext('DealerShop')
        end
    end
end)

RegisterNetEvent("drc_drugs:dealers:progress")
AddEventHandler("drc_drugs:dealers:progress", function(data)
    if data.shop == "DealerShop" then
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
                lib.callback('drc_drugs:dealersshop:getitem', false, function(value)
                    if value then
                        if not IsProgressBarActive() then
                            for _, v in pairs(Config.Dealer.Ped) do
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
                            ProgressBar(9000, locale("Buying"))
                            StopAnimTask(cache.ped, dict, clip, 1.0)
                            Wait(0)
                            FreezeEntityPosition(cache.ped, false)
                            ClearPedTasks(cache.ped)
                            if Config.Target == 'ox_target' then
                                exports.ox_target:disableTargeting(false)
                            end
                            TSE("drc_drugs:dealersshop:giveitems", data.item, data.price, amount)
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
    elseif data.shop == "GeraldShop" then
        lib.callback('drc_drugs:dealers:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    GetSkin()
                    local x, y, z = table.unpack(GetEntityCoords(cache.ped, false))
                    RequestCutscene('mp_intro_mcs_10_a2', 8)
                    while not (HasCutsceneLoaded()) do
                        Wait(0)
                    end
                    local model = GetHashKey("s_m_y_marine_01")
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        RequestModel(model)
                        Wait(0)
                    end
                    local ped = CreatePed(7, model, x, y, z - 40, 0.0, true, true)

                    local ped2 = CreatePed(7, model, x, y, z - 40, 0.0, true, true)

                    local ped3 = CreatePed(7, model, x, y, z - 40, 0.0, true, true)
                    SetEntityVisible(ped2, false, false)
                    SetEntityVisible(ped, false, false)
                    SetEntityVisible(ped3, false, false)
                    SetEntityCollision(ped2, false, false)
                    SetEntityCollision(ped, false, false)
                    SetEntityCollision(ped3, false, false)
                    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
                    RegisterEntityForCutscene(cache.ped, 'MP_1', 0, 0, 64)
                    SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
                    RegisterEntityForCutscene(ped, 'MP_2', 0, 0, 64)
                    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
                    RegisterEntityForCutscene(ped2, 'MP_3', 0, 0, 64)
                    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
                    RegisterEntityForCutscene(ped3, 'MP_4', 0, 0, 64)
                    StartCutscene(0)
                    while not (DoesCutsceneEntityExist('MP_2', 0)) do
                        Wait(0)
                    end
                    while not (DoesCutsceneEntityExist('MP_1', 0)) do
                        Wait(0)
                    end
                    while not (DoesCutsceneEntityExist('MP_3', 0)) do
                        Wait(0)
                    end
                    while not (DoesCutsceneEntityExist('MP_4', 0)) do
                        Wait(0)
                    end
                    ApplySkin()
                    while not (HasCutsceneFinished()) do
                        SetEntityCollision(cache.ped, true, true)
                        Wait(0)
                    end
                    DeleteEntity(ped)
                    DeleteEntity(ped2)
                    DeleteEntity(ped3)
                    ApplySkin()
                    SetEntityCollision(cache.ped, true, true)
                    TSE("drc_drugs:dealers:giveitems", data.shop)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.shop)
    elseif data.shop == "MadrazoTrade" then
        lib.callback('drc_drugs:dealers:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    GetSkin()
                    local x, y, z = table.unpack(GetEntityCoords(cache.ped, false))
                    RequestCutscene('mp_int_mcs_15_a3', 8)
                    while not (HasCutsceneLoaded()) do
                        Wait(0)
                    end
                    local model = GetHashKey("s_m_y_marine_01")
                    RequestModel(model)

                    while not HasModelLoaded(model) do
                        RequestModel(model)
                        Wait(0)
                    end

                    local ped = CreatePed(7, model, x, y, z - 40, 0.0, true, true)

                    local ped2 = CreatePed(7, model, x, y, z - 40, 0.0, true, true)

                    local ped3 = CreatePed(7, model, x, y, z - 40, 0.0, true, true)

                    SetEntityVisible(ped2, false, false)
                    SetEntityVisible(ped, false, false)
                    SetEntityVisible(ped3, false, false)
                    SetEntityCollision(ped2, false, false)
                    SetEntityCollision(ped, false, false)
                    SetEntityCollision(ped3, false, false)
                    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
                    RegisterEntityForCutscene(cache.ped, 'MP_1', 0, 0, 64)
                    SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
                    RegisterEntityForCutscene(ped, 'MP_2', 0, 0, 64)
                    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
                    RegisterEntityForCutscene(ped2, 'MP_3', 0, 0, 64)
                    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)

                    RegisterEntityForCutscene(ped3, 'MP_4', 0, 0, 64)
                    StartCutscene(0)

                    while not (DoesCutsceneEntityExist('MP_2', 0)) do
                        Wait(0)
                    end
                    while not (DoesCutsceneEntityExist('MP_1', 0)) do
                        Wait(0)
                    end
                    while not (DoesCutsceneEntityExist('MP_3', 0)) do
                        Wait(0)
                    end
                    while not (DoesCutsceneEntityExist('MP_4', 0)) do
                        Wait(0)
                    end
                    ApplySkin()
                    while not (HasCutsceneFinished()) do
                        Wait(0)
                    end
                    TSE("drc_drugs:dealers:giveitems", data.shop)
                    DeleteEntity(ped)
                    DeleteEntity(ped2)
                    DeleteEntity(ped3)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.shop)
    elseif data.shop == "LocateDealer1" then
        lib.callback('drc_drugs:dealers:getitem', fasle, function(value)
            if value then
                if not IsProgressBarActive() then
                    TaskTurnPedToFaceCoord(cache.ped, Config.LocateDealer.Location.Coords, 4000)
                    dict = "anim@heists@prison_heiststation@cop_reactions"
                    clip = "cop_b_idle"
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    FreezeEntityPosition(cache.ped, true)
                    ProgressBar(15000, locale("LocatingDealer"))
                    StopAnimTask(cache.ped, dict, clip, 1.0)
                    Wait(0)
                    FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    Notify("success", locale("success"), locale("LocationInGPS"))
                    DealerPos = Config.LocateDealer.DealerPos[math.random(1, #Config.LocateDealer.DealerPos)]
                    SetNewWaypoint(DealerPos)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.shop)
    end
end)

local DealerPed = nil
local SpawnedDealer = false
CreateThread(function()
    while true do
        Wait(1000)
        if Config.Dealer.enabled then
            for _, v in pairs(Config.Dealer.Ped) do
                local Coords = GetEntityCoords(PlayerPedId())
                local distance = #(Coords - vec3(v.coords))
                if distance < 20 and not SpawnedDealer then
                    SpawnedDealer = true
                    RequestModel(GetHashKey(v.model))

                    while not HasModelLoaded(GetHashKey(v.model)) do
                        Wait(100)
                    end

                    local Dealer = CreatePed(4, v.model, v.coords, false, true)
                    DealerPed = Dealer
                    if Config.InteractionType ~= "target" then
                        lib.zones.sphere({
                            coords = GetEntityCoords(DealerPed),
                            radius = 1,
                            debug = Config.Debug,
                            inside = function(self)
                                if IsControlJustReleased(0, 38) then
                                    TriggerEvent("drc_drugs:dealers:menus", {shop = "DealerShop"})
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
                        target:AddTargetEntity(Dealer, {
                            options = {
                                {
                                    event = "drc_drugs:dealers:menus",
                                    icon = "fas fa-store",
                                    label = locale("shop"),
                                    shop = "DealerShop"
                                },
                            },
                            distance = 2
                        })
                    end

                    for i = 0, 255, 51 do
                        Wait(50)
                        SetEntityAlpha(Dealer, i, false)
                    end
                    FreezeEntityPosition(Dealer, true)
                    SetEntityInvincible(Dealer, true)
                    SetBlockingOfNonTemporaryEvents(Dealer, true)
                    TaskStartScenarioInPlace(Dealer, v.scenario, 0, true)
                elseif distance >= 20 and SpawnedDealer then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(DealerPed, i, false)
                    end
                    DeletePed(DealerPed)
                    SpawnedDealer = false
                end
            end
        end
    end
end)
