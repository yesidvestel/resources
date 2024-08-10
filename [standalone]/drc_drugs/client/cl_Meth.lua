local TSE = TriggerServerEvent
local Electricity = false
if Config.Meth.ElectricityNeeded then
    Electricity = false
else
    Electricity = true
end
local heat = false
local cooked = false
local methlabzones = {}

local MethLab = lib.zones.sphere({
    coords = Config.Meth.Lab.coords,
    radius = Config.Meth.Lab.radius,
    debug = Config.Meth.Lab.DebugPoly,
    inside = function ()
        
    end,
    onEnter = function ()
        if Config.InteractionType == "target" then
            target = Target()
            target:AddCircleZone("MethElectricMenu", Config.Meth.Electricity.coords,
                Config.Meth.Electricity.radius,
                { name = "MethElectricMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:progress", icon = "fas fa-car-battery", label = locale("turnonelt"),
                        menu = "ElectricON" },
                    { event = "drc_drugs:meth:progress", icon = "fas fa-car-battery", label = locale("turnoffelt"),
                        menu = "ElectricOFF" }
                },
                    distance = 2.5
                }
            )

            target:AddCircleZone("MethTeleportMenu2", Config.Meth.LeaveLab.coords, Config.Meth.LeaveLab.radius,
                { name = "MethTeleportMenu2", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:progress", icon = "fas fa-door-open", label = locale("leave"),
                        menu = "MethDoor2" }
                },
                    distance = 2.5
                }
            )

            target:AddCircleZone("MethPourMenu", Config.Meth.Pouring.coords, Config.Meth.Pouring.radius,
                { name = "MethPourMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:menus", icon = "fas fa-fire-burner", label = locale("MethCook"),
                        menu = "MethPour",
                        canInteract = function()
                            if Electricity then
                                return true
                            end
                        end
                    }
                },
                    distance = 2.5
                }
            )

            target:AddCircleZone("MethHeatMenu", Config.Meth.Heat.coords, Config.Meth.Heat.radius,
                { name = "MethHeatMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:progress", icon = "fas fa-fire", label = locale("MethHeat"), menu = "Heat",
                        canInteract = function()
                            if Electricity then
                                return true
                            end
                        end
                    }
                },
                    distance = 2.5
                }
            )

            target:AddCircleZone("MethCompleteMenu", Config.Meth.Complete.coords, Config.Meth.Complete.radius,
                { name = "MethCompleteMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:progress", icon = "fas fa-box-open", label = locale("MethFinish"),
                        menu = "Complete",
                        canInteract = function()
                            if Electricity then
                                return true
                            end
                        end
                    }
                },
                    distance = 2.5
                }
            )

            target:AddCircleZone("MethPackageMenu", Config.Meth.Package.coords, Config.Meth.Package.radius,
                { name = "MethPackageMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:menus", icon = "fas fa-box", label = locale("MethPack"),
                        menu = "MethPackage",
                        canInteract = function()
                            if Electricity then
                                return true
                            end
                        end
                    }
                },
                    distance = 2.5
                }
            )

            target:AddCircleZone("MethBreakMenu", Config.Meth.Break.coords, Config.Meth.Break.radius,
                { name = "MethBreakMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:menus", icon = "fas fa-hammer", label = locale("MethBreak"),
                        menu = "MethBreak",
                        canInteract = function()
                            if Electricity then
                                return true
                            end
                        end
                    }
                },
                    distance = 2.5
                }
            )
        else
            methlabzones[#methlabzones+1] = lib.zones.sphere({
                coords = Config.Meth.Electricity.coords,
                radius = Config.Meth.Electricity.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:meth:progress", Electricity and {menu = "ElectricOFF"} or {menu = "ElectricON"})
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

            methlabzones[#methlabzones+1] = lib.zones.sphere({
                coords = Config.Meth.LeaveLab.coords,
                radius = Config.Meth.LeaveLab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:meth:progress", {menu = "MethDoor2"})
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

            methlabzones[#methlabzones+1] = lib.zones.sphere({
                coords = Config.Meth.Pouring.coords,
                radius = Config.Meth.Pouring.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:meth:menus", {menu = "MethPour"})
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("MethCook"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("MethCook"))
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

            methlabzones[#methlabzones+1] = lib.zones.sphere({
                coords = Config.Meth.Heat.coords,
                radius = Config.Meth.Heat.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:meth:progress", {menu = "Heat"})
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("MethHeat"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("MethHeat"))
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

            methlabzones[#methlabzones+1] = lib.zones.sphere({
                coords = Config.Meth.Complete.coords,
                radius = Config.Meth.Complete.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:meth:progress", {menu = "Complete"})
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("MethFinish"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("MethFinish"))
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

            methlabzones[#methlabzones+1] = lib.zones.sphere({
                coords = Config.Meth.Package.coords,
                radius = Config.Meth.Package.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:meth:menus", {menu = "MethPackage"})
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("MethPack"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("MethPack"))
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

            methlabzones[#methlabzones+1] = lib.zones.sphere({
                coords = Config.Meth.Break.coords,
                radius = Config.Meth.Break.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:meth:progress", {menu = "MethBreak"})
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("MethBreak"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("MethBreak"))
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
    onExit = function ()
        if Config.InteractionType == "target" then
            target = Target()
            target:RemoveZone('MethElectricMenu')
            target:RemoveZone('MethBreakMenu')
            target:RemoveZone('MethPackageMenu')
            target:RemoveZone('MethPourMenu')
            target:RemoveZone('MethTeleportMenu2')
            target:RemoveZone('MethHeatMenu')
            target:RemoveZone('MethCompleteMenu')
        else
            for i = 1, #methlabzones do
                methlabzones[i]:remove()
            end
        end
    end
})

RegisterNetEvent("drc_drugs:meth:menus", function(data)
    if data.menu == "MethPour" then
        if not cooked then
            if heat then
                if Config.Context == "qbcore" then
                    exports['qb-menu']:openMenu({
                        {
                            isMenuHeader = true,
                            header = locale('Oven')
                        },
                        {
                            header = Config.Meth.Pouring.header,
                            txt = Config.Meth.Pouring.description,
                            params = {
                                event = 'drc_drugs:meth:progress',
                                args = { menu = data.menu }
                            }
                        }
                    })
                elseif Config.Context == "ox_lib" then
                    lib.registerContext({
                        id = 'DrugsMethPourMenu',
                        title = locale("Oven"),
                        options = {
                            [Config.Meth.Pouring.header] = {
                                arrow = false,
                                description = Config.Meth.Pouring.description,
                                event = 'drc_drugs:meth:progress',
                                args = { menu = data.menu }
                            }
                        }
                    })
                    lib.showContext('DrugsMethPourMenu')
                end
            else
                Notify("error", locale("Meth"), locale("MethNeedHeat"))
            end
        else
            Notify("error", locale("Meth"), locale("MethNeedFinish"))
        end
    elseif data.menu == "MethBreak" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Meth.Break.header,
                    txt = Config.Meth.Break.description,
                    params = {
                        event = 'drc_drugs:meth:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsMethBreakMenu',
                title = locale("table"),
                options = {
                    [Config.Meth.Break.header] = {
                        arrow = false,
                        description = Config.Meth.Break.description,
                        event = 'drc_drugs:meth:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsMethBreakMenu')
        end
    elseif data.menu == "MethPackage" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Meth.Package.header,
                    txt = Config.Meth.Package.description,
                    params = {
                        event = 'drc_drugs:meth:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsPackageMenu',
                title = locale("table"),
                options = {
                    [Config.Meth.Package.header] = {
                        arrow = false,
                        description = Config.Meth.Package.description,
                        event = 'drc_drugs:meth:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsPackageMenu')
        end
    end
end)
-- PROGRESSY --
RegisterNetEvent("drc_drugs:meth:progress")
AddEventHandler("drc_drugs:meth:progress", function(data)
    if data.menu == "MethDoor1" then
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
                    SetEntityCoords(cache.ped, Config.Meth.Enterlab.teleport, false, false, false, true)
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
            SetEntityCoords(cache.ped, Config.Meth.Enterlab.teleport, false, false, false, true)
            Wait(1100)
            DoScreenFadeIn(300)
            FreezeEntityPosition(cache.ped, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(false)
            end
        end
    elseif data.menu == "MethDoor2" then
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(true)
        end
        DoScreenFadeOut(1000)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(5000, locale("leaving"))
        SetEntityCoords(cache.ped, Config.Meth.LeaveLab.teleport, false, false, false, true)
        Wait(1100)
        DoScreenFadeIn(300)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
    elseif data.menu == "MethGet" then
        lib.callback('drc_drugs:meth:getitem', false, function(value)
            if value then
                SetEntityCoords(cache.ped, Config.Meth.GetSacid.teleport, false, false, false, true)
                TaskTurnPedToFaceCoord(cache.ped, Config.Meth.GetSacid.coords, 1000)
                Wait(1000)
                dict = "timetable@gardener@filling_can"
                clip = "gar_ig_5_filling_can"
                RequestAnimDict(dict)
                while (not HasAnimDictLoaded(dict)) do Wait(0) end
                TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                local hash = `bkr_prop_meth_sacid`
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Wait(100)
                    RequestModel(hash)
                end
                local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
                AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 18905), 0.19, 0.02, 0.46, 0.0, 190.0, 0.0, true, true, false, false, 1, true)
                if Config.Target == 'ox_target' then
                    exports.ox_target:disableTargeting(true)
                end
                FreezeEntityPosition(cache.ped, true)
                ProgressBar(5000, locale("MethRefueling"))
                DetachEntity(prop, false, false)
                DeleteEntity(prop)
                StopAnimTask(cache.ped, dict, clip, 1.0)
                Wait(0)
                FreezeEntityPosition(cache.ped, false)
                if Config.Target == 'ox_target' then
                    exports.ox_target:disableTargeting(false)
                end
                TSE("drc_drugs:meth:giveitems", data.menu)
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "Heat" then
        if not cooked and not heat then
            if not Minigame("Meth") then return Notify("error", locale("error"), locale("fail")) end
            SetEntityCoords(cache.ped, Config.Meth.Heat.teleport, false, false, false, true)
            SetEntityHeading(cache.ped, Config.Meth.Heat.heading)
            dict = "anim@gangops@facility@servers@"
            clip = "hotwire"
            RequestAnimDict(dict)
            while (not HasAnimDictLoaded(dict)) do Wait(0) end
            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(true)
            end
            FreezeEntityPosition(cache.ped, true)
            ProgressBar(5000, locale("MethHeating"))
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(false)
            end
            StopAnimTask(cache.ped, dict, clip, 1.0)
            Wait(0)
            FreezeEntityPosition(cache.ped, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(false)
            end
            Notify("success", locale("Meth"), locale("MethHeated"))
            heat = true
        else
            Notify("info", locale("Meth"), locale("MethAlready"))
        end
    elseif data.menu == "Complete" then
        lib.callback('drc_drugs:meth:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    if cooked and heat then
                        SetEntityCoords(cache.ped, Config.Meth.Complete.teleport, false, false, false, true)
                        SetEntityHeading(cache.ped, Config.Meth.Complete.heading)
                        dict = "anim@gangops@facility@servers@"
                        clip = "hotwire"
                        RequestAnimDict(dict)
                        while (not HasAnimDictLoaded(dict)) do Wait(0) end
                        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                        if Config.Target == 'ox_target' then
                            exports.ox_target:disableTargeting(true)
                        end
                        FreezeEntityPosition(cache.ped, true)
                        ProgressBar(5000, locale("MethFinishing"))
                        if Config.Target == 'ox_target' then
                            exports.ox_target:disableTargeting(false)
                        end
                        StopAnimTask(cache.ped, dict, clip, 1.0)
                        Wait(0)
                        FreezeEntityPosition(cache.ped, false)
                        cooked = false
                        heat = false
                        TSE("drc_drugs:meth:giveitems", data.menu)
                    else
                        Notify("info", locale("Meth"), locale("MethStartCook"))
                    end
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "MethPour" then
        lib.callback('drc_drugs:meth:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    local ped = cache.ped
                    local targetRotation = vec3(180.0, 180.0, Config.Meth.Pouring.heading)
                    local x, y, z = table.unpack(Config.Meth.Pouring.teleport)
                    local dict = "anim@amb@business@meth@meth_monitoring_cooking@cooking@"
                    RequestAnimDict(dict)
                    RequestModel("bkr_prop_meth_ammonia")
                    RequestModel("bkr_prop_meth_sacid")
                    RequestModel("bkr_prop_fakeid_clipboard_01a")
                    RequestModel("bkr_prop_fakeid_penclipboard")

                    while not HasAnimDictLoaded(dict) and
                        not HasModelLoaded("bkr_prop_meth_ammonia") and
                        not HasModelLoaded("bkr_prop_meth_sacid") and
                        not HasModelLoaded("bkr_prop_fakeid_clipboard_01a") and
                        not HasModelLoaded("bkr_prop_fakeid_penclipboard") do
                        Wait(100)
                    end
                    ammonia = CreateObject(GetHashKey('bkr_prop_meth_ammonia'), x, y, z, 1, 0, 1)
                    acid = CreateObject(GetHashKey('bkr_prop_meth_sacid'), x, y, z, 1, 0, 1)
                    clipboard = CreateObject(GetHashKey('bkr_prop_fakeid_clipboard_01a'), x, y, z, 1, 0, 1)
                    pencil = CreateObject(GetHashKey('bkr_prop_fakeid_penclipboard'), x, y, z, 1, 0, 1)
                    local netScene = NetworkCreateSynchronisedScene(x + 5.0, y + 2.0, z - 0.4, targetRotation, 2, false,
                        false, 1148846080, 0, 1.3)
                    local netScene2 = NetworkCreateSynchronisedScene(x + 5.0, y + 2.0, z - 0.4, targetRotation, 2, false
                        , false, 1148846080, 0, 1.3)
                    NetworkAddPedToSynchronisedScene(ped, netScene, dict, "chemical_pour_long_cooker", 1.5, -4.0, 1,
                        16, 1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(ammonia, netScene, dict, "chemical_pour_long_ammonia", 4.0,
                        -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(acid, netScene, dict, "chemical_pour_long_sacid", 4.0, -8.0,
                        1)
                    NetworkAddEntityToSynchronisedScene(clipboard, netScene, dict, "chemical_pour_long_clipboard",
                        4.0, -8.0, 1)
                    NetworkAddPedToSynchronisedScene(ped, netScene2, dict, "chemical_pour_long_cooker", 1.5, -4.0, 1
                        , 16, 1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(pencil, netScene2, dict, "chemical_pour_long_pencil", 4.0,
                        -8.0, 1)

                    Wait(150)
                    NetworkStartSynchronisedScene(netScene)
                    NetworkStartSynchronisedScene(netScene2)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    FreezeEntityPosition(cache.ped, true)
                    ProgressBar(GetAnimDuration(dict, "chemical_pour_long_cooker") * 770, locale("MethCooking"))
                    FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    DeleteObject(clipboard)
                    DeleteObject(pencil)
                    DeleteObject(ammonia)
                    DeleteObject(acid)
                    cooked = true
                    Notify("info", locale("Meth"), locale("MethGoFinish"))
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "MethPackage" then
        lib.callback('drc_drugs:meth:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    local ped = cache.ped
                    local targetRotation = vec3(180.0, 180.0, Config.Meth.Package.heading)
                    local x, y, z = table.unpack(Config.Meth.Package.teleport)
                    local dict = "anim@amb@business@meth@meth_smash_weight_check@"
                    RequestAnimDict(dict)
                    RequestModel("bkr_prop_meth_scoop_01a")
                    RequestModel("bkr_prop_meth_bigbag_03a")
                    RequestModel("bkr_prop_meth_bigbag_04a")
                    RequestModel("bkr_prop_fakeid_penclipboard")
                    RequestModel("bkr_prop_fakeid_clipboard_01a")
                    RequestModel("bkr_prop_meth_openbag_02")
                    RequestModel("bkr_prop_coke_scale_01")
                    RequestModel("bkr_prop_meth_smallbag_01a")
                    RequestModel("bkr_prop_meth_openbag_01a")
                    RequestModel("bkr_prop_fakeid_penclipboard")
                    while not HasAnimDictLoaded(dict) and
                        not HasModelLoaded("bkr_prop_meth_scoop_01a") and
                        not HasModelLoaded("bkr_prop_meth_bigbag_03a") and
                        not HasModelLoaded("bkr_prop_meth_bigbag_04a") and
                        not HasModelLoaded("bkr_prop_meth_openbag_02") and
                        not HasModelLoaded("bkr_prop_coke_scale_01") and
                        not HasModelLoaded("bkr_prop_meth_smallbag_01a") and
                        not HasModelLoaded("bkr_prop_meth_openbag_01a") and
                        not HasModelLoaded("bkr_prop_fakeid_clipboard_01a") and
                        not HasModelLoaded("bkr_prop_fakeid_penclipboard") do
                        Wait(100)
                    end
                    scoop = CreateObject(GetHashKey('bkr_prop_meth_scoop_01a'), x, y, z, 1, 0, 1)
                    box02 = CreateObject(GetHashKey('bkr_prop_meth_bigbag_03a'), x, y, z, 1, 0, 1)
                    box01 = CreateObject(GetHashKey('bkr_prop_meth_bigbag_04a'), x, y, z, 1, 0, 1)
                    box03 = CreateObject(GetHashKey('bkr_prop_meth_openbag_02'), x, y, z, 1, 0, 1)
                    box03_small = CreateObject(GetHashKey('bkr_prop_meth_smallbag_01a'), x, y, z, 1, 0, 1)
                    box03_open = CreateObject(GetHashKey('bkr_prop_meth_openbag_01a'), x, y, z, 1, 0, 1)
                    scale = CreateObject(GetHashKey('bkr_prop_coke_scale_01'), x, y, z, 1, 0, 1)
                    clipboard = CreateObject(GetHashKey('bkr_prop_fakeid_clipboard_01a'), x, y, z, 1, 0, 1)
                    pencilboard = CreateObject(GetHashKey('bkr_prop_fakeid_penclipboard'), x, y, z, 1, 0, 1)
                    local netScene = NetworkCreateSynchronisedScene(x - 5.3, y - 0.4, z - 1.0, targetRotation, 2, false,
                        false, 1148846080, 0, 1.3)
                    local netScene2 = NetworkCreateSynchronisedScene(x - 5.3, y - 0.4, z - 1.0, targetRotation, 2, false
                        , false, 1148846080, 0, 1.3)
                    local netScene3 = NetworkCreateSynchronisedScene(x - 5.3, y - 0.4, z - 1.0, targetRotation, 2, false
                        , false, 1148846080, 0, 1.3)
                    NetworkAddPedToSynchronisedScene(ped, netScene, dict, "break_weigh_char01", 1.5, -4.0, 1, 16,
                        1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(scoop, netScene, dict, "break_weigh_scoop", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(box01, netScene, dict, "break_weigh_box01", 4.0,
                        -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(box03, netScene, dict, "break_weigh_methbag01^3", 4.0, -8.0,
                        1)
                    NetworkAddPedToSynchronisedScene(ped, netScene2, dict, "break_weigh_char01", 1.5, -4.0, 1, 16,
                        1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(scale, netScene2, dict, "break_weigh_scale", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(box02, netScene2, dict, "break_weigh_box01^1", 4.0,
                        -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(box03_small, netScene2, dict, "break_weigh_methbag01^2",
                        4.0, -8.0, 1)
                    NetworkAddPedToSynchronisedScene(ped, netScene3, dict, "break_weigh_char01", 1.5, -4.0, 1, 16,
                        1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(box03_open, netScene3, dict, "break_weigh_methbag01^1", 4.0
                        , -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(clipboard, netScene3, dict, "break_weigh_clipboard", 4.0,
                        -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(pencilboard, netScene3, dict, "break_weigh_pen", 4.0, -8.0, 1)
                    NetworkStartSynchronisedScene(netScene)
                    NetworkStartSynchronisedScene(netScene2)
                    NetworkStartSynchronisedScene(netScene3)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    ProgressBar(GetAnimDuration(dict, "break_weigh_char01") * 770, locale("MethPacking"))
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    DeleteObject(scoop)
                    DeleteObject(box02)
                    DeleteObject(box01)
                    DeleteObject(box03)
                    DeleteObject(box03_small)
                    DeleteObject(box03_open)
                    DeleteObject(scale)
                    DeleteObject(clipboard)
                    DeleteObject(pencilboard)
                    FreezeEntityPosition(ped, false)
                    TSE("drc_drugs:meth:giveitems", data.menu)
                    Wait(GetAnimDuration(dict, "break_weigh_char01") * 770)
                    NetworkStopSynchronisedScene(netScene)
                    NetworkStopSynchronisedScene(netScene2)
                    NetworkStopSynchronisedScene(netScene3)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "ElectricON" then
        TaskTurnPedToFaceCoord(cache.ped, Config.Meth.Electricity.coords, 2000)
        Wait(2000)
        dict = "gestures@f@standing@casual"
        clip = "gesture_point"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Wait(0) end
        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(1000, locale("turnonel"))
        StopAnimTask(cache.ped, dict, clip, 1.0)
        Wait(0)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
        Electricity = true
    elseif data.menu == "ElectricOFF" then
        TaskTurnPedToFaceCoord(cache.ped, Config.Meth.Electricity.coords, 2000)
        Wait(2000)
        dict = "gestures@f@standing@casual"
        clip = "gesture_point"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Wait(0) end
        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(1000, locale("turnoffel"))
        StopAnimTask(cache.ped, dict, clip, 1.0)
        Wait(0)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
        Electricity = false
    elseif data.menu == "MethBreak" then
        lib.callback('drc_drugs:meth:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    local ped = cache.ped
                    local targetRotation = vec3(180.0, 180.0, Config.Meth.Break.heading)
                    local x, y, z = table.unpack(Config.Meth.Break.teleport)
                    local dict = "anim@amb@business@meth@meth_smash_weight_check@"

                    RequestAnimDict(dict)
                    RequestModel("bkr_prop_meth_tray_02a")
                    RequestModel("w_me_hammer")
                    RequestModel("bkr_prop_meth_tray_01a")
                    RequestModel("bkr_prop_meth_smashedtray_01")
                    RequestModel("bkr_prop_meth_smashedtray_01_frag_")
                    RequestModel("bkr_prop_meth_bigbag_02a")
                    RequestModel("bkr_prop_fakeid_penclipboard")

                    while not HasAnimDictLoaded(dict) and
                        not HasModelLoaded("bkr_prop_meth_tray_02a") and
                        not HasModelLoaded("bkr_prop_fakeid_penclipboard") and
                        not HasModelLoaded("w_me_hammer") and
                        not HasModelLoaded("bkr_prop_meth_tray_01a") and
                        not HasModelLoaded("bkr_prop_meth_smashedtray_01") and
                        not HasModelLoaded("bkr_prop_meth_smashedtray_01_frag_") and
                        not HasModelLoaded("bkr_prop_meth_bigbag_02a") do
                        Wait(100)
                    end

                    tray = CreateObject(GetHashKey('bkr_prop_meth_tray_02a'), x, y, z, 1, 0, 1)
                    tray_2 = CreateObject(GetHashKey('bkr_prop_meth_tray_01a'), x, y, z, 1, 0, 1)
                    tray_smashed = CreateObject(GetHashKey('bkr_prop_meth_smashedtray_01_frag_'), x, y, z, 1, 0, 1)
                    hammer = CreateObject(GetHashKey('w_me_hammer'), x, y, z, 1, 0, 1)
                    bigbag = CreateObject(GetHashKey('bkr_prop_meth_bigbag_02a'), x, y, z, 1, 0, 1)
                    local netScene = NetworkCreateSynchronisedScene(x, y, z, targetRotation, 2, false,
                        false, 1148846080, 0, 1.3)
                    local netScene2 = NetworkCreateSynchronisedScene(x, y, z, targetRotation, 2, false
                        , false, 1148846080, 0, 1.3)
                    NetworkAddPedToSynchronisedScene(ped, netScene, dict, "break_weigh_char02", 1.5, -4.0, 1, 16,
                        1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(tray_2, netScene, dict, "break_weigh_tray01^1", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(hammer, netScene, dict, "break_weigh_hammer", 4.0, -8.0, 1)
                    NetworkAddPedToSynchronisedScene(ped, netScene2, dict, "break_weigh_char02", 1.5, -4.0, 1, 16,
                        1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(tray, netScene2, dict, "break_weigh_tray01^2", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(tray_smashed, netScene2, dict, "break_weigh_tray01", 4.0
                        , -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(bigbag, netScene2, dict, "break_weigh_box01^1", 4.0, -8.0, 1)
                    Wait(150)
                    NetworkStartSynchronisedScene(netScene)
                    NetworkStartSynchronisedScene(netScene2)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    ProgressBar(GetAnimDuration(dict, "break_weigh_char02") * 770, locale("MethBreaking"))
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    DeleteObject(tray)
                    DeleteObject(tray_2)
                    DeleteObject(tray_quebrada)
                    DeleteObject(tray_smashed)
                    DeleteObject(hammer)
                    DeleteObject(bigbag)
                    FreezeEntityPosition(ped, false)
                    TSE("drc_drugs:meth:giveitems", data.menu)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    end
end)
-- PROGRESSY KONEC --

-- BOXZONES --

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if Config.InteractionType == "target" then
            target = Target()
            target:RemoveZone('MethHeatMenu')
            target:RemoveZone('MethCompleteMenu')
            target:RemoveZone('MethElectricMenu2')
            target:RemoveZone('MethElectricMenu')
            target:RemoveZone('MethBreakMenu')
            target:RemoveZone('MethPackageMenu')
            target:RemoveZone('MethPourMenu')
            target:RemoveZone('MethTeleportMenu2')
            target:RemoveZone('MethTeleportMenu1')
            target:RemoveZone('MethGet')
        end
    end
end)

SetTimeout(2000, function()
    if Config.Meth.Enterlab.NeedItem then
        if Config.InteractionType ~= "target" then
            lib.zones.sphere({
                coords = Config.Meth.Enterlab.coords,
                radius = Config.Meth.Enterlab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:meth:progress", {menu = "MethDoor1", Card = Config.Meth.Enterlab.ItemName})
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
        else
            target = Target()
            target:AddCircleZone("MethTeleportMenu1", Config.Meth.Enterlab.coords, Config.Meth.Enterlab.radius,
                { name = "MethTeleportMenu1", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:progress", icon = "fas fa-door-open", label = locale("enter"),
                        menu = "MethDoor1", Card = Config.Meth.Enterlab.ItemName }
                },
                    distance = 2.5
                }
            )
        end
    else
        if Config.InteractionType ~= "target" then
            lib.zones.sphere({
                coords = Config.Meth.Enterlab.coords,
                radius = Config.Meth.Enterlab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:meth:progress", {menu = "MethDoor1"})
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
        else
            target = Target()
            target:AddCircleZone("MethTeleportMenu1", Config.Meth.Enterlab.coords, Config.Meth.Enterlab.radius,
                { name = "MethTeleportMenu1", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:meth:progress", icon = "fas fa-door-open", label = locale("enter"),
                        menu = "MethDoor1" }
                },
                    distance = 2.5
                }
            )
        end
    end

    if Config.InteractionType ~= "target" then
        lib.zones.sphere({
            coords = Config.Meth.GetSacid.coords,
            radius = Config.Meth.GetSacid.radius + 0.5,
            debug = Config.Debug,
            inside = function(self)
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("drc_drugs:meth:progress", {menu = "MethGet"})
                end

                if Config.InteractionType == "3dtext" then
                    Draw3DText(self.coords, "[~g~E~w~] - " .. locale('MethRefuel'))
                end
            end,
            onEnter = function()
                if Config.InteractionType == "textui" then
                        TextUIShow("[E] - " .. locale('MethRefuel'))
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
        target:AddCircleZone("MethGet", Config.Meth.GetSacid.coords, Config.Meth.GetSacid.radius,
            { name = "MethGet", debugPoly = Config.Debug, useZ = true },
            { options = {
                { event = "drc_drugs:meth:progress", icon = "fas fa-fire", label = locale("MethRefuel"), menu = "MethGet" }
            },
                distance = 2.5
            }
        )
    end
end)
--BOXZONES KONEC--
