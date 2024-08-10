local TSE = TriggerServerEvent

if Config.Weed.ElectricityNeeded then
    Electricity = false
else
    Electricity = true
end

WeedEntity = {}

WeedEntitiesZones = {}

local weedlabzones = {}

local WeedLab = lib.zones.sphere({
    coords = Config.Weed.Lab.coords,
    radius = Config.Weed.Lab.radius,
    debug = Config.Weed.Lab.DebugPoly,
    inside = function(self)

    end,
    onEnter = function()
        local objects = GetGamePool("CObject")
        for i = 1, #objects do
            if Config.Weed.Pickup.Models[GetEntityModel(objects[i])] then
                if not table.contains(WeedEntity, objects[i]) then
                    table.insert(WeedEntity, objects[i])
                    if Config.InteractionType == "target" then
                        target = Target()
                        target:AddTargetEntity(objects[i], {
                            options = {
                                {
                                    action = function(entity)
                                        PickWeed(entity, "WeedPick")
                                    end,
                                    icon = "fas fa-cannabis",
                                    label = locale("pickup"),
                                    canInteract = function()
                                        if Electricity then
                                            return true
                                        end
                                    end
                                },
                            },
                            distance = 2
                        })
                    else
                        WeedEntitiesZones[#WeedEntitiesZones+1] = lib.zones.sphere({
                            coords = vec3(GetEntityCoords(objects[i]).x, GetEntityCoords(objects[i]).y, GetEntityCoords(objects[i]).z + 1),
                            radius = 1,
                            debug = Config.Debug,
                            inside = function(self)
                                if Electricity then
                                    if IsControlJustReleased(0, 38) then
                                        PickWeed(objects[i], "WeedPick")
                                    end

                                    if Config.InteractionType == "3dtext" then
                                        Draw3DText(self.coords, "[~g~E~w~] - " .. locale("pickup"))
                                    end
                                end
                            end,
                            onEnter = function()
                                if Electricity then
                                    if Config.InteractionType == "textui" then
                                        TextUIShow("[E] - " .. locale('pickup'))
                                    end    
                                end
                            end,
                            onExit = function()
                                if Electricity then
                                    if Config.InteractionType == "textui" then
                                        TextUIHide()
                                    end
                                end
                            end
                        }) 
                    end
                end
            end
        end
        if Config.InteractionType == "target" then
            target = Target()
            target:AddCircleZone("WeedElectricMenu", Config.Weed.AC.coords, Config.Weed.AC.radius,
                { name = "WeedElectricMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:weed:progress", icon = "fas fa-wind", label = locale("turnonact"),
                        menu = "ElectricON", },
                    { event = "drc_drugs:weed:progress", icon = "fas fa-wind", label = locale("turnoffact"),
                        menu = "ElectricOFF", }
                },
                    distance = 2.5
                })
            target:AddCircleZone("WeedTeleportMenu2", Config.Weed.LeaveLab.coords, Config.Weed.LeaveLab.radius,
                { name = "WeedTeleportMenu2", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:weed:progress", icon = "fas fa-door-open", label = locale("leave"),
                        menu = "WeedDoor2",
                    }
                },
                    distance = 2.5
                })

            target:AddCircleZone("WeedCleanMenu", Config.Weed.Clean.coords, Config.Weed.Clean.radius,
                { name = "WeedCleanMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:weed:menus", icon = "fas fa-cannabis", label = locale("WeedClean"),
                        menu = "WeedClean",
                        canInteract = function()
                            if Electricity then
                                return true
                            end
                        end
                    }
                },
                    distance = 2.5
                })
            target:AddCircleZone("WeedPackMenu", Config.Weed.Package.coords, Config.Weed.Package.radius,
                { name = "WeedPackMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:weed:menus", icon = "fas fa-box-open", label = locale("WeedPack"),
                        menu = "WeedPack",
                        canInteract = function()
                            if Electricity then
                                return true
                            end
                        end
                    }
                },
                    distance = 2.5
                })
        else
            weedlabzones[#weedlabzones+1] = lib.zones.sphere({
                coords = Config.Weed.AC.coords,
                radius = Config.Weed.AC.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:weed:progress", Electricity and {menu = "ElectricOFF"} or {menu = "ElectricON"})
                    end
    
                    if Config.InteractionType == "3dtext" then
                        Draw3DText(self.coords, string.format("[~g~E~w~] - %s", Electricity and locale('turnoffelt') or locale("turnonelt")))
                    end
                end,
                onEnter = function()
                    if Config.InteractionType == "textui" then
                        TextUIShow(string.format("[E] - %s", Electricity and locale('turnoffelt') or locale("turnonelt")))
                    end     
                end,
                onExit = function()
                    if Config.InteractionType == "textui" then
                        TextUIHide()
                    end
                end
            })

            weedlabzones[#weedlabzones+1] = lib.zones.sphere({
                coords = Config.Weed.LeaveLab.coords,
                radius = Config.Weed.LeaveLab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:weed:progress", {menu = "WeedDoor2"})
                    end
    
                    if Config.InteractionType == "3dtext" then
                        Draw3DText(self.coords, "[~g~E~w~] - " .. locale("leave"))
                    end
                end,
                onEnter = function()
                    if Config.InteractionType == "textui" then
                        TextUIShow("[E] - " .. locale("leave"))
                    end    
                end,
                onExit = function()
                    if Config.InteractionType == "textui" then
                        TextUIHide()
                    end
                end
            })

            weedlabzones[#weedlabzones+1] = lib.zones.sphere({
                coords = Config.Weed.Clean.coords,
                radius = Config.Weed.Clean.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:weed:menus", {menu = "WeedClean"})
                        end

                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("WeedClean"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale('WeedClean'))
                        end    
                    end
                end,
                onExit = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIHide()
                        end
                    end
                end
            })

            weedlabzones[#weedlabzones+1] = lib.zones.sphere({
                coords = Config.Weed.Package.coords,
                radius = Config.Weed.Package.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:weed:menus", {menu = "WeedPack"})
                        end

                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("WeedPack"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale('WeedPack'))
                        end    
                    end
                end,
                onExit = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIHide()
                        end
                    end
                end
            })
        end 
    end,
    onExit = function()
        if Config.InteractionType == "target" then
            target = Target()
            target:RemoveZone('WeedElectricMenu2')
            target:RemoveZone('WeedElectricMenu')
            target:RemoveZone('WeedSodaMenu')
            target:RemoveZone('WeedFigureMenu')
            target:RemoveZone('WeedCleanMenu')
            target:RemoveZone('WeedTeleportMenu2')
            target:RemoveZone('WeedPackMenu')
            target:RemoveZone('MethGet')
        else
            for i = 1, #weedlabzones do
                weedlabzones[i]:remove()
            end
        end
    end
})

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
    

RegisterNetEvent("drc_drugs:weed:menus", function(data)
    if data.menu == "WeedClean" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Weed.Clean.header,
                    txt = Config.Weed.Clean.description,
                    params = {
                        event = 'drc_drugs:weed:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsWeedCleanMenu',
                title = locale("table"),
                options = {
                    [Config.Weed.Clean.header] = {
                        arrow = false,
                        description = Config.Weed.Clean.description,
                        event = 'drc_drugs:weed:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsWeedCleanMenu')
        end
    elseif data.menu == "WeedPack" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Weed.Package.header,
                    txt = Config.Weed.Package.description,
                    params = {
                        event = 'drc_drugs:weed:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsWeedPackMenu',
                title = locale("table"),
                options = {
                    [Config.Weed.Package.header] = {
                        arrow = false,
                        description = Config.Weed.Package.description,
                        event = 'drc_drugs:weed:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsWeedPackMenu')
        end
    end
end)

-- PROGRESSY --
RegisterNetEvent("drc_drugs:weed:progress")
AddEventHandler("drc_drugs:weed:progress", function(data)
    if data.menu == "WeedDoor1" then
        if data.Card then
            lib.callback('drc_drugs:getitembyname', false, function(value)
                if not value then
                    return Notify("error", locale("error"), locale("RequiredCard"))
                else
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    DoScreenFadeOut(1000)
                    FreezeEntityPosition(cache.ped, true)
                    ProgressBar(5000, locale("entering"))
                    SetEntityCoords(cache.ped, Config.Weed.Enterlab.teleport, false, false, false, true)
                    Wait(1100)
                    DoScreenFadeIn(300)
                    FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                end
            end, data.Card)
        else
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(true)
            end
            DoScreenFadeOut(1000)
            FreezeEntityPosition(cache.ped, true)
            ProgressBar(5000, locale("entering"))
            SetEntityCoords(cache.ped, Config.Weed.Enterlab.teleport, false, false, false, true)
            Wait(1100)
            DoScreenFadeIn(300)
            FreezeEntityPosition(cache.ped, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(false)
            end
        end
    elseif data.menu == "WeedDoor2" then
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(true)
        end
        DoScreenFadeOut(1000)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(5000, locale("leaving"))
        SetEntityCoords(cache.ped, Config.Weed.LeaveLab.teleport, false, false, false, true)
        Wait(1100)
        DoScreenFadeIn(300)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
    elseif data.menu == "WeedClean" then
        lib.callback('drc_drugs:weed:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    if not Minigame("Weed") then return Notify("error", locale("error"), locale("fail")) end
                    local ped = cache.ped
                    local dict = "anim@amb@business@weed@weed_sorting_seated@"

                    RequestAnimDict(dict)
                    RequestModel("bkr_prop_weed_bag_01a")
                    RequestModel("bkr_prop_weed_bag_pile_01a")
                    RequestModel("bkr_prop_weed_bud_02b")
                    RequestModel("bkr_prop_weed_leaf_01a")
                    RequestModel("bkr_prop_weed_dry_01a")
                    RequestModel("bkr_prop_weed_bucket_open_01a")

                    while not HasAnimDictLoaded(dict) and
                        not HasModelLoaded("bkr_prop_weed_bag_01a") and
                        not HasModelLoaded("bkr_prop_weed_bag_pile_01a") and
                        not HasModelLoaded("bkr_prop_weed_bud_02b") and
                        not HasModelLoaded("bkr_prop_weed_leaf_01a") and
                        not HasModelLoaded("bkr_prop_weed_dry_01a") and
                        not HasModeLoaded("bkr_prop_weed_bucket_open_01a") do
                        Wait(100)
                    end

                    weed_bag_01 = CreateObject(GetHashKey('bkr_prop_weed_bag_01a'), x, y, z, 1, 0, 1)
                    weed_bag_pile_01 = CreateObject(GetHashKey('bkr_prop_weed_bag_pile_01a'), x, y, z, 1, 0, 1)
                    bud = CreateObject(GetHashKey('bkr_prop_weed_bud_02b'), x, y, z, 1, 0, 1)
                    leaf = CreateObject(GetHashKey('bkr_prop_weed_leaf_01a'), x, y, z, 1, 0, 1)
                    weeedry = CreateObject(GetHashKey('bkr_prop_weed_dry_01a'), x, y, z, 1, 0, 1)
                    bucket = CreateObject(GetHashKey('bkr_prop_weed_bucket_open_01a'), x, y, z, 1, 0, 1)

                    local targetRotation = vec3(180.0, 180.0, Config.Weed.Clean.heading)
                    local x, y, z = table.unpack(Config.Weed.Clean.teleport)
                    local netScene = NetworkCreateSynchronisedScene(x, y, z, targetRotation.x,
                        targetRotation.y, targetRotation.z, 2, false, false,
                        1148846080, 0, 0.9)
                    local netScene2 = NetworkCreateSynchronisedScene(x, y, z, targetRotation.x,
                        targetRotation.y, targetRotation.z, 2, false, false,
                        1148846080, 0, 0.9)
                    NetworkAddPedToSynchronisedScene(ped, netScene, dict, "sorter_left_sort_v1_sorter01", 1.5, -4.0, 1,
                        16,
                        1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(weed_bag_01, netScene, dict, "sorter_left_sort_v1_weedbag01a",
                        4.0,
                        -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(weed_bag_pile_01, netScene, dict,
                        "sorter_left_sort_v1_weedbagpile01a",
                        4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(bud, netScene, dict, "sorter_left_sort_v1_weedbud02b^3", 4.0,
                        -8.0, 1)

                    NetworkAddPedToSynchronisedScene(ped, netScene2, dict, "sorter_left_sort_v1_sorter01", 1.5, -4.0, 1,
                        16,
                        1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(weeedry, netScene2, dict, "sorter_left_sort_v1_weeddry01a", 4.0,
                        -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(leaf, netScene2, dict, "sorter_left_sort_v1_weedleaf01a^1", 4.0,
                        -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(bucket, netScene2, dict, "sorter_left_sort_v1_bucket01a", 4.0,
                        -8.0, 1)
                    Wait(150)
                    NetworkStartSynchronisedScene(netScene)
                    Wait(150)
                    NetworkStartSynchronisedScene(netScene2)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    ProgressBar(GetAnimDuration(dict, "sorter_left_sort_v1_sorter01") * 970, locale("WeedCleaning"))
                    DeleteObject(weed_bag_01)
                    DeleteObject(weed_bag_pile_01)
                    DeleteObject(bud)
                    DeleteObject(leaf)
                    DeleteObject(weeedry)
                    DeleteObject(bucket)
                    FreezeEntityPosition(ped, false)
                    TSE("drc_drugs:weed:giveitems", data.menu)
                    SetEntityCoords(cache.ped, Config.Weed.Clean.leave, false, false, false, true)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "ElectricON" then
        TaskTurnPedToFaceCoord(cache.ped, Config.Weed.AC.coords, 4000)
        dict = "anim@heists@prison_heiststation@cop_reactions"
        clip = "cop_b_idle"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Wait(0) end
        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(10000, locale("turnonac"))
        StopAnimTask(cache.ped, dict, clip, 1.0)
        Wait(0)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
        Electricity = true
        local objects = GetGamePool("CObject")
        for i = 1, #objects do
            if Config.Weed.Pickup.Models[GetEntityModel(objects[i])] then
                if Config.InteractionType == "target" then
                    target = Target()
                    target:AddTargetEntity(objects[i], {
                        options = {
                            {
                                action = function(entity)
                                    PickWeed(entity, "WeedPick")
                                end,
                                icon = "fas fa-cannabis",
                                label = locale("pickup"),
                                canInteract = function()
                                    if Electricity then
                                        return true
                                    end
                                end
                            },
                        },
                        distance = 2
                    })
                else
                    for i = 1, #WeedEntitiesZones do
                        WeedEntitiesZones[i]:remove()
                    end
                    lib.zones.sphere({
                        coords = vec3(GetEntityCoords(objects[i]).x, GetEntityCoords(objects[i]).y, GetEntityCoords(objects[i]).z + 1),
                        radius = 1,
                        debug = Config.Debug,
                        inside = function(self)
                            if Electricity then
                                if IsControlJustReleased(0, 38) then
                                    PickWeed(objects[i], "WeedPick")
                                end

                                if Config.InteractionType == "3dtext" then
                                    Draw3DText(self.coords, "[~g~E~w~] - " .. locale("pickup"))
                                end
                            end
                        end,
                        onEnter = function()
                            if Electricity then
                                if Config.InteractionType == "textui" then
                                    TextUIShow("[E] - " .. locale('pickup'))
                                end    
                            end
                        end,
                        onExit = function()
                            if Electricity then
                                if Config.InteractionType == "textui" then
                                    TextUIHide()
                                end
                            end
                        end
                    })
                end
            end
        end
    elseif data.menu == "ElectricOFF" then
        TaskTurnPedToFaceCoord(cache.ped, Config.Weed.AC.coords, 4000)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(true)
        end
        dict = "anim@heists@prison_heiststation@cop_reactions"
        clip = "cop_b_idle"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Wait(0) end
        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(10000, locale("turnoffac"))
        StopAnimTask(cache.ped, dict, clip, 1.0)
        Wait(0)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
        Electricity = false
    elseif data.menu == "WeedPack" then
        lib.callback('drc_drugs:weed:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    if not Minigame("Weed") then return Notify("error", locale("error"), locale("fail")) end
                    dict = "mp_arresting"
                    clip = "a_uncuff"
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                    local hash = `bkr_prop_weed_bud_pruned_01a`
                    local hash2 = `bkr_prop_weed_bag_01a`
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(100)
                        RequestModel(hash)
                    end
                    RequestModel(hash2)
                    while not HasModelLoaded(hash2) do
                        Wait(100)
                        RequestModel(hash2)
                    end
                    local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
                    local prop2 = CreateObject(hash2, GetEntityCoords(cache.ped), true, true, true)
                    AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.15, 0.06, -0.02, 264.0, 30.0, 120.0, true, true, false, false, 1, true)
                    AttachEntityToEntity(prop2, cache.ped, GetPedBoneIndex(cache.ped, 18905), 0.05, 0.01, 0.02, 0.0, 0.0, 20.0, true, true, false, false, 1, true)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    FreezeEntityPosition(cache.ped, true)
                    ProgressBar(4100, locale("WeedPacking"))
                    DetachEntity(prop, false, false)
                    DeleteEntity(prop)
                    DetachEntity(prop2, false, false)
                    DeleteEntity(prop2)
                    StopAnimTask(cache.ped, dict, clip, 1.0)
                    Wait(0)
                    FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    TSE("drc_drugs:weed:giveitems", data.menu)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    end
end)

function PickWeed(entity, menu)
    if DoesEntityExist(entity) then
        if Electricity then
            if not IsProgressBarActive() then
                lib.callback('drc_drugs:weed:getitem', false, function(value)
                    if value == 1 then
                        Notify("error", locale("error"), locale("WeedColectedAlready"))
                    else
                        TaskTurnPedToFaceEntity(cache.ped, entity, 4000)
                        if value then
                            dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
                            clip = "weed_crouch_checkingleaves_idle_01_inspector"
                            RequestAnimDict(dict)
                            while (not HasAnimDictLoaded(dict)) do Wait(0) end
                            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                            local hash = `prop_cs_scissors`
                            RequestModel(hash)
                            while not HasModelLoaded(hash) do
                                Wait(100)
                                RequestModel(hash)
                            end
                            local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
                            AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.1, -0.02, -0.03, -190.0, 40.0, 90.0, true, true, false, false, 1, true)
                            if Config.Target == 'ox_target' then
                                exports.ox_target:disableTargeting(true)
                            end
                            FreezeEntityPosition(cache.ped, true)
                            ProgressBar(10000, locale("WeedColecting"))
                            DetachEntity(prop, false, false)
                            DeleteEntity(prop)
                            StopAnimTask(cache.ped, dict, clip, 1.0)
                            Wait(0)
                            FreezeEntityPosition(cache.ped, false)
                            if Config.Target == 'ox_target' then
                                exports.ox_target:disableTargeting(false)
                            end
                            TSE("drc_drugs:weed:giveitems", menu, entity)
                        else
                            Notify("error", locale("error"), locale("RequiredItems"))
                        end
                    end
                end, menu, entity)
            end
        end
    else
        Notify("error", locale("error"), locale("needac"))
    end
end

-- PROGRESSY KONEC --

-- BOXZONES --

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if Config.InteractionType == "target" then
            target = Target()
            target:RemoveZone('WeedElectricMenu2')
            target:RemoveZone('WeedElectricMenu')
            target:RemoveZone('WeedSodaMenu')
            target:RemoveZone('WeedFigureMenu')
            target:RemoveZone('WeedCleanMenu')
            target:RemoveZone('WeedTeleportMenu2')
            target:RemoveZone('WeedTeleportMenu1')
            target:RemoveZone('WeedPackMenu')
            target:RemoveZone('MethGet')
        else
            for i = 1, #weedlabzones do
                weedlabzones[i]:remove()
            end
        end
    end
end)

SetTimeout(2000, function()
    if Config.Weed.Enterlab.NeedItem then
        if Config.InteractionType == "target" then
            target = Target()
            target:AddCircleZone("WeedTeleportMenu1", Config.Weed.Enterlab.coords, Config.Weed.Enterlab.radius,
                { name = "WeedTeleportMenu1", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:weed:progress", icon = "fas fa-door-open", label = locale("enter"),
                        menu = "WeedDoor1",
                        Card = Config.Weed.Enterlab.ItemName
                    }
                },
                    distance = 2.5
                }
            )
        else
            lib.zones.sphere({
                coords = Config.Weed.Enterlab.coords,
                radius = Config.Weed.Enterlab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:weed:progress", {menu = "WeedDoor1", Card = Config.Weed.Enterlab.ItemName})
                    end

                    if Config.InteractionType == "3dtext" then
                        Draw3DText(self.coords, "[~g~E~w~] - " .. locale('enter'))
                    end
                end,
                onEnter = function()
                    if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale('enter'))
                    end    
                end,
                onExit = function()
                    if Config.InteractionType == "textui" then
                        TextUIHide()
                    end
                end
            })
        end
    else
        if Config.InteractionType == "target" then
            target = Target()
            target:AddCircleZone("WeedTeleportMenu1", Config.Weed.Enterlab.coords, Config.Weed.Enterlab.radius,
                { name = "WeedTeleportMenu1", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:weed:progress", icon = "fas fa-door-open", label = locale("enter"),
                        menu = "WeedDoor1"
                    }
                },
                    distance = 2.5
                }
            )
        else
            lib.zones.sphere({
                coords = Config.Weed.Enterlab.coords,
                radius = Config.Weed.Enterlab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:weed:progress", {menu = "WeedDoor1"})
                    end

                    if Config.InteractionType == "3dtext" then
                        Draw3DText(self.coords, "[~g~E~w~] - " .. locale('enter'))
                    end
                end,
                onEnter = function()
                    if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale('enter'))
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
--BOXZONES KONEC--
