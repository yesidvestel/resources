lib.locale()
local TSE = TriggerServerEvent
local Electricity = false
local headingtotable = nil
local SpawnedCokePlant = 0
local CokePlants = {}
local inside = false
local cokelabzones = {}
local cokeplant = {}

if Config.Coke.ElectricityNeeded then
    Electricity = false
else
    Electricity = true
end

local FigureCarry = false

local CokeLab = lib.zones.sphere({
    coords = Config.Coke.Lab.coords,
    radius = Config.Coke.Lab.radius,
    debug = Config.Coke.Lab.DebugPoly,
    inside = function ()
        
    end,
    onEnter = function ()
        if Config.InteractionType == "target" then
            target = Target()
            target:AddCircleZone("CokeElectricMenu", Config.Coke.Electricity.coords,
                Config.Coke.Electricity.radius,
                { name = "CokeElectricMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:coke:progress", icon = "fas fa-car-battery", label = locale("turnonelt"),
                        menu = "ElectricON" },
                    { event = "drc_drugs:coke:progress", icon = "fas fa-car-battery", label = locale("turnoffelt"),
                        menu = "ElectricOFF" }
                },
                    distance = 2.5
                }
            )

            target:AddCircleZone("CokeProcessMenu", Config.Coke.LeafProcess.coords,
                Config.Coke.LeafProcess.radius,
                { name = "CokeProcessMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:coke:menus", icon = "fas fa-box-open", label = locale("CokeProcess"),
                        menu = "CokeProcess",
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

            target:AddCircleZone("CokeTeleportMenu2", Config.Coke.LeaveLab.coords, Config.Coke.LeaveLab.radius,
                { name = "CokeTeleportMenu2", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:coke:progress", icon = "fas fa-door-open", label = locale("leave"),
                        menu = "CokeDoor2" }
                },
                    distance = 2.5
                }
            )

            target:AddCircleZone("CokeBoxMenu", Config.Coke.CokeBox.coords, Config.Coke.CokeBox.radius,
                { name = "CokeBoxMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:coke:menus", icon = "fas fa-box-open", label = locale("CokeBox"),
                        menu = "CokeBox",
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

            target:AddCircleZone("CokeFigureMenu", Config.Coke.FigurePackage.coords,
                Config.Coke.FigurePackage.radius,
                { name = "CokeFigureMenu", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { event = "drc_drugs:coke:menus", icon = "fas fa-box", label = locale("CokePack"),
                        menu = "CokeFigure",
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

            for k, v in pairs(Config.Coke.SodaTables) do
                target:AddCircleZone("CokeSodaMenu" .. k, v.coords, v.radius,
                    { name = "CokeSodaMenu" .. k, debugPoly = v.debugPoly, useZ = true },
                    { options = {
                        { event = "drc_drugs:coke:menus", icon = "fas fa-prescription-bottle",
                            label = locale("CokeClean"), menu = "CokeSoda", headingtotable = v.headingtotable,
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
            end
        else
            cokelabzones[#cokelabzones+1] = lib.zones.sphere({
                coords = Config.Coke.Electricity.coords,
                radius = Config.Coke.Electricity.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:coke:progress", Electricity and {menu = "ElectricOFF"} or {menu = "ElectricON"})
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

            cokelabzones[#cokelabzones+1] = lib.zones.sphere({
                coords = Config.Coke.LeafProcess.coords,
                radius = Config.Coke.LeafProcess.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:coke:menus", {menu = "CokeProcess"})
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("CokeProcess"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("CokeProcess"))
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

            cokelabzones[#cokelabzones+1] = lib.zones.sphere({
                coords = Config.Coke.LeaveLab.coords,
                radius = Config.Coke.LeaveLab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:coke:progress", {menu = "CokeDoor2"})
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

            cokelabzones[#cokelabzones+1] = lib.zones.sphere({
                coords = Config.Coke.CokeBox.coords,
                radius = Config.Coke.CokeBox.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:coke:menus", {menu = "CokeBox"})
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("CokeBox"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("CokeBox"))
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

            cokelabzones[#cokelabzones+1] = lib.zones.sphere({
                coords = Config.Coke.FigurePackage.coords,
                radius = Config.Coke.FigurePackage.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if Electricity then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("drc_drugs:coke:menus", {menu = "CokeFigure"})
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("CokePack"))
                        end
                    end
                end,
                onEnter = function()
                    if Electricity then
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("CokePack"))
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

            for k, v in pairs(Config.Coke.SodaTables) do
                cokelabzones[#cokelabzones+1] = lib.zones.sphere({
                    coords = v.coords,
                    radius = v.radius + 0.5,
                    debug = v.DebugPoly,
                    inside = function(self)
                        if Electricity then
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("drc_drugs:coke:menus", {menu = "CokeSoda", headingtotable = v.headingtotable})
                            end
            
                            if Config.InteractionType == "3dtext" then
                                Draw3DText(self.coords, "[~g~E~w~] - " .. locale("CokeClean"))
                            end
                        end
                    end,
                    onEnter = function()
                        if Electricity then
                            if Config.InteractionType == "textui" then
                                TextUIShow("[E] - " .. locale("CokeClean"))
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
    end,
    onExit = function ()
        if Config.InteractionType == "target" then
            target = Target()
            target:RemoveZone('CokeElectricMenu')
            for k, v in pairs(Config.Coke.SodaTables) do
                target:RemoveZone('CokeSodaMenu' .. k)
            end
            target:RemoveZone('CokeFigureMenu')
            target:RemoveZone('CokeBoxMenu')
            target:RemoveZone('CokeTeleportMenu2')
        else
            for i = 1, #cokelabzones do
                cokelabzones[i]:remove()
            end
        end
    end
})

local CokeField = lib.zones.sphere({
    coords = Config.Coke.Field.coords,
    radius = Config.Coke.Field.radius,
    debug = Config.Coke.Field.DebugPoly,
    inside = function ()
        
    end,
    onEnter = function ()
        while SpawnedCokePlant < 15 do
            Wait(0)
            local CokeCoords = GenerateCokePlantCoords()
            RequestModel(Config.Coke.Field.prop)
            while not HasModelLoaded(Config.Coke.Field.prop) do
                Wait(100)
            end
            local obj = CreateObject(Config.Coke.Field.prop, CokeCoords.x, CokeCoords.y, CokeCoords.z, true, true, false)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            if Config.InteractionType ~= "target" then
                cokeplant[obj] = lib.zones.sphere({
                    coords = vec3(CokeCoords.x, CokeCoords.y, CokeCoords.z + 1),
                    radius = 1,
                    debug = Config.Debug,
                    inside = function(self)
                        if IsControlJustReleased(0, 38) then
                            PickUpCoke(obj)
                        end
        
                        if Config.InteractionType == "3dtext" then
                            Draw3DText(self.coords, "[~g~E~w~] - " .. locale("pickup"))
                        end
                    end,
                    onEnter = function()
                        if Config.InteractionType == "textui" then
                            TextUIShow("[E] - " .. locale("pickup"))
                        end    
                    end,
                    onExit = function()
                        if Config.InteractionType == "textui" then
                            TextUIHide()
                        end
                    end
                }) 
            end
            table.insert(CokePlants, obj)
            SpawnedCokePlant = SpawnedCokePlant + 1
        end

        inside = true
    end,
    onExit = function ()
        inside = false
    end
})

RegisterNetEvent("drc_drugs:coke:menus", function(data)
    if data == "FullFigure" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('CokeFigure')
                },
                {
                    header = locale("CokeCarryFigure"),
                    txt = '',
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data, option = "carry" }
                    }
                },
                {
                    header = locale("CokeBreakigure"),
                    txt = '',
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data, option = "break" }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsFigureMenu',
                title = locale("CokeFigure"),
                options = {
                    [locale("CokeCarryFigure")] = {
                        arrow = false,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data, option = "carry" }
                    },
                    [locale("CokeBreakigure")] = {
                        arrow = false,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data, option = "break" }
                    }
                }
            })
            lib.showContext('DrugsFigureMenu')
        end
    elseif data == "EmptyFigure" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('CokeFigure')
                },
                {
                    header = locale("CokeCarryFigure"),
                    txt = '',
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data, option = "carry" }
                    }
                },
                {
                    header = locale("CokeBreakigure"),
                    txt = '',
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data, option = "break" }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsEmptyFigureMenu',
                title = locale("CokeFigure"),
                options = {
                    [locale("CokeCarryFigure")] = {
                        arrow = false,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data, option = "carry" }
                    },
                    [locale("CokeBreakigure")] = {
                        arrow = false,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data, option = "break" }
                    }
                }
            })
            lib.showContext('DrugsEmptyFigureMenu')
        end
    elseif data == "BrokenFigure" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('CokeFigure')
                },
                {
                    header = locale("CokeRepairFigure"),
                    txt = locale("CokeRepairFigureDesc"),
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsBrokenFigureMenu',
                title = locale("CokeFigure"),
                options = {
                    [locale("CokeRepairFigure")] = {
                        description = locale("CokeRepairFigureDesc"),
                        arrow = false,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data }
                    }
                }
            })
            lib.showContext('DrugsBrokenFigureMenu')
        end
    end
    if data.menu == "CokeBox" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Coke.CokeBox.header,
                    txt = Config.Coke.CokeBox.description,
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsCokeBoxMenu',
                title = locale("table"),
                options = {
                    [Config.Coke.CokeBox.header] = {
                        arrow = false,
                        description = Config.Coke.CokeBox.description,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsCokeBoxMenu')
        end
    elseif data.menu == "CokeProcess" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Coke.LeafProcess.header,
                    txt = Config.Coke.LeafProcess.description,
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsProcessMenu',
                title = locale("table"),
                options = {
                    [Config.Coke.LeafProcess.header] = {
                        arrow = false,
                        description = Config.Coke.LeafProcess.description,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsProcessMenu')
        end
    elseif data.menu == "CokeSoda" then
        headingtotable = data.headingtotable
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Coke.Soda.header,
                    txt = Config.Coke.Soda.description,
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsSodaMenu',
                title = locale("table"),
                options = {
                    [Config.Coke.Soda.header] = {
                        arrow = false,
                        description = Config.Coke.Soda.description,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsSodaMenu')
        end
    elseif data.menu == "CokeFigure" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Coke.FigurePackage.header,
                    txt = Config.Coke.FigurePackage.description,
                    params = {
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsFigureMenu',
                title = locale("table"),
                options = {
                    [Config.Coke.FigurePackage.header] = {
                        arrow = false,
                        description = Config.Coke.FigurePackage.description,
                        event = 'drc_drugs:coke:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsFigureMenu')
        end
    end
end)

-- PROGRESSY --
RegisterNetEvent("drc_drugs:coke:progress")
AddEventHandler("drc_drugs:coke:progress", function(data)
    if data.menu == "CokeDoor1" then
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
                    SetEntityCoords(cache.ped, Config.Coke.Enterlab.teleport, false, false, false, true)
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
            SetEntityCoords(cache.ped, Config.Coke.Enterlab.teleport, false, false, false, true)
            Wait(1100)
            DoScreenFadeIn(300)
            FreezeEntityPosition(cache.ped, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(false)
            end
        end
    elseif data.menu == "CokeDoor2" then
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(true)
        end
        DoScreenFadeOut(1000)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(5000, locale("leaving"))
        SetEntityCoords(cache.ped, Config.Coke.LeaveLab.teleport, false, false, false, true)
        Wait(1100)
        DoScreenFadeIn(300)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
    elseif data.menu == "CokeBox" then
        lib.callback('drc_drugs:coke:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    local ped = cache.ped
                    local dict = "anim@amb@business@coc@coc_unpack_cut@"

                    RequestAnimDict(dict)
                    RequestModel("bkr_prop_coke_box_01a")
                    RequestModel("bkr_prop_coke_fullmetalbowl_02")
                    RequestModel("bkr_prop_coke_fullscoop_01a")
                    while not HasAnimDictLoaded(dict) and not HasModelLoaded("bkr_prop_coke_box_01a") and
                        not HasModelLoaded("bkr_prop_coke_fullmetalbowl_02") and
                        not HasModelLoaded("bkr_prop_coke_fullscoop_01a") do
                        Wait(100)
                    end

                    CokeBowl = CreateObject(GetHashKey('bkr_prop_coke_fullmetalbowl_02'), x, y, z, 1, 0, 1)
                    CokeScoop = CreateObject(GetHashKey('bkr_prop_coke_fullscoop_01a'), x, y, z, 1, 0, 1)
                    CokeBox = CreateObject(GetHashKey('bkr_prop_coke_box_01a'), x, y, z, 1, 0, 1)
                    local targetRotation = vec3(180.0, 180.0, Config.Coke.CokeBox.heading)
                    local x, y, z = table.unpack(Config.Coke.CokeBox.teleport)
                    local netScene = NetworkCreateSynchronisedScene(x - 0.2, y - 0.1, z - 0.65, targetRotation, 2, false
                        , false, 1148846080, 0, 1.3)

                    NetworkAddPedToSynchronisedScene(ped, netScene, dict, "fullcut_cycle_v1_cokepacker", 1.5, -4.0, 1, 16
                        , 1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(CokeBowl, netScene, dict, "fullcut_cycle_v1_cokebowl", 4.0, -8.0
                        , 1)
                    NetworkAddEntityToSynchronisedScene(CokeBox, netScene, dict, 'fullcut_cycle_v1_cokebox', 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(CokeScoop, netScene, dict, 'fullcut_cycle_v1_cokescoop', 4.0,
                        -8.0, 1)
                    FreezeEntityPosition(ped, true)
                    Wait(150)
                    NetworkStartSynchronisedScene(netScene)
                    SetEntityVisible(CokeScoop, false, 0)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    ProgressBar(43828, locale("CokeBoxProg"))
                    DeleteObject(CokeBowl)
                    DeleteObject(CokeBox)
                    DeleteObject(CokeScoop)
                    FreezeEntityPosition(ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    TSE("drc_drugs:coke:giveitems", data.menu)
                    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 450)
                    SetEntityVisible(CokeScoop, true, 0)
                    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 65)
                    SetEntityVisible(CokeBox, false, 0)
                    Wait(GetAnimDuration(dict, "fullcut_cycle_v1_cokepacker") * 245)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "CokeFigure" then
        lib.callback('drc_drugs:coke:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then

                    local ped = cache.ped
                    local dict = "anim@amb@business@coc@coc_packing_hi@"
                    FreezeEntityPosition(ped, true)
                    RequestAnimDict(dict)
                    RequestModel("bkr_prop_coke_fullscoop_01a")
                    RequestModel("bkr_prop_coke_fullmetalbowl_02")
                    RequestModel("bkr_prop_coke_dollboxfolded")
                    RequestModel("bkr_prop_coke_dollmould")
                    RequestModel("bkr_prop_coke_press_01b")
                    RequestModel("bkr_prop_coke_dollcast")
                    RequestModel("bkr_prop_coke_doll")
                    RequestModel("bkr_prop_coke_dollbox")
                    RequestModel("bkr_prop_coke_doll_bigbox")

                    while not HasAnimDictLoaded(dict) and
                        not HasModelLoaded("bkr_prop_coke_fullscoop_01a") and
                        not HasModelLoaded("bkr_prop_coke_fullmetalbowl_02") and
                        not HasModelLoaded("bkr_prop_coke_dollboxfolded") and
                        not HasModelLoaded("bkr_prop_coke_dollmould") and
                        not HasModelLoaded("bkr_prop_coke_press_01b") and
                        not HasModelLoaded("bkr_prop_coke_dollcast") and
                        not HasModelLoaded("bkr_prop_coke_doll") and
                        not HasModelLoaded("bkr_prop_coke_dollbox") and
                        not HasModelLoaded("bkr_prop_coke_doll_bigbox") do
                        Wait(100)
                    end

                    scoop = CreateObject(GetHashKey('bkr_prop_coke_fullscoop_01a'), x, y, z, 1, 0, 1)
                    metalbowl = CreateObject(GetHashKey('bkr_prop_coke_fullmetalbowl_02'), x, y, z, 1, 0, 1)
                    foldedbox = CreateObject(GetHashKey('bkr_prop_coke_dollboxfolded'), x, y, z, 1, 0, 1)
                    dollmould = CreateObject(GetHashKey('bkr_prop_coke_dollmould'), x, y, z, 1, 0, 1)
                    cokepress = CreateObject(GetHashKey('bkr_prop_coke_press_01b'), x, y, z, 1, 0, 1)
                    dollcast = CreateObject(GetHashKey('bkr_prop_coke_dollcast'), x, y, z, 1, 0, 1)
                    cocdoll = CreateObject(GetHashKey('bkr_prop_coke_doll'), x, y, z, 1, 0, 1)
                    boxeddoll = CreateObject(GetHashKey('bkr_prop_coke_dollbox'), x, y, z, 1, 0, 1)

                    local targetRotation = vec3(180.0, 180.0, Config.Coke.FigurePackage.heading)
                    local x, y, z = table.unpack(Config.Coke.FigurePackage.teleport)
                    local netScene = NetworkCreateSynchronisedScene(x, y, z, targetRotation, 2, false, false, 1148846080
                        , 0, 1.3)
                    NetworkAddPedToSynchronisedScene(ped, netScene, dict, "full_cycle_v1_pressoperator", 1.5, -4.0, 1, 16
                        , 1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(scoop, netScene, dict, "full_cycle_v1_scoop", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(metalbowl, netScene, dict, "full_cycle_v1_cocbowl", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(foldedbox, netScene, dict, "full_cycle_v1_foldedbox", 4.0, -8.0,
                        1)
                    local netScene2 = NetworkCreateSynchronisedScene(x, y, z, targetRotation, 2, false, false, 1148846080
                        , 0, 1.3)
                    NetworkAddEntityToSynchronisedScene(dollmould, netScene2, dict, "full_cycle_v1_dollmould", 4.0, -8.0
                        , 1) --
                    NetworkAddEntityToSynchronisedScene(cokepress, netScene2, dict, "full_cycle_v1_cokepress", 4.0, -8.0
                        , 1)
                    NetworkAddEntityToSynchronisedScene(dollcast, netScene2, dict, "full_cycle_v1_dollcast^3", 4.0, -8.0
                        , 1)
                    local netScene3 = NetworkCreateSynchronisedScene(x, y, z, targetRotation, 2, false, false, 1148846080
                        , 0, 1.3)
                    NetworkAddEntityToSynchronisedScene(cocdoll, netScene3, dict, "full_cycle_v1_cocdoll", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(boxeddoll, netScene3, dict, "full_cycle_v1_boxeddoll", 4.0, -8.0
                        , 1)
                    Wait(150)
                    NetworkStartSynchronisedScene(netScene)
                    Wait(100)
                    NetworkStartSynchronisedScene(netScene2)
                    Wait(100)
                    NetworkStartSynchronisedScene(netScene3)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    ProgressBar(GetAnimDuration(dict, "full_cycle_v1_pressoperator") * 780, locale("CokePacking"))
                    DeleteObject(cokepress)
                    DeleteObject(foldedbox)
                    DeleteObject(dollmould)
                    DeleteObject(dollcast)
                    DeleteObject(cocdoll)
                    DeleteObject(boxeddoll)
                    DeleteObject(scoop)
                    DeleteObject(metalbowl)
                    FreezeEntityPosition(ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    TSE("drc_drugs:coke:giveitems", data.menu)
                    Wait(GetAnimDuration(dict, "full_cycle_v1_pressoperator") * 780)
                    NetworkStopSynchronisedScene(netScene)
                    NetworkStopSynchronisedScene(netScene2)
                    NetworkStopSynchronisedScene(netScene3)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "EmptyFigure" then
        if data.option == "break" then
            dict = "anim@heists@box_carry@"
            clip = "idle"
            RequestAnimDict(dict)
            while (not HasAnimDictLoaded(dict)) do Wait(0) end
            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
            local hash = `bkr_prop_coke_doll`
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(100)
                RequestModel(hash)
            end
            local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
            AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), -0.11, 0.4, -0.11, 1.0, 9.0, 115.0, true, true, false, false, 1, true)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(true)
            end
            FreezeEntityPosition(cache.ped, true)
            ProgressBar(6000, locale("BreakFigure"))
            DetachEntity(prop, false, false)
            DeleteEntity(prop)
            StopAnimTask(cache.ped, dict, clip, 1.0)
            Wait(0)
            FreezeEntityPosition(cache.ped, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(false)
            end
            TSE("drc_drugs:coke:giveitems", "empty")
        else
            if not FigureCarry then
                local ped = cache.ped
                RequestAnimDict("impexp_int-0")
                while (not HasAnimDictLoaded("impexp_int-0")) do Wait(0) end
                TaskPlayAnim(ped, 'impexp_int-0', 'mp_m_waremech_01_dual-0', 8.0, -8, -1, 49, 0, 0, 0, 0)
                FigureObject = CreateObject(GetHashKey("bkr_prop_coke_doll"), 0, 0, 0, true, true, true)
                AttachEntityToEntity(FigureObject, ped, GetPedBoneIndex(ped, 24816), -0.03, 0.45, -0.01, -10.0, 90.0,
                    180.0, true, true, false, true, 1, true)
            else
                DetachEntity(FigureObject, 0, 0)
                DeleteEntity(FigureObject)
                ClearPedTasks(cache.ped)
            end
            FigureCarry = not FigureCarry
        end
    elseif data.menu == "BrokenFigure" then
        lib.callback('drc_drugs:coke:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    dict = "anim@heists@box_carry@"
                    clip = "idle"
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                    local hash = `bkr_prop_coke_doll`
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(100)
                        RequestModel(hash)
                    end
                    local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
                    AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), -0.11, 0.4, -0.11, 1.0, 9.0, 115.0, true, true, false, false, 1, true)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    FreezeEntityPosition(cache.ped, true)
                    ProgressBar(6000, locale("RepairingFigure"))
                    DetachEntity(prop, false, false)
                    DeleteEntity(prop)
                    StopAnimTask(cache.ped, dict, clip, 1.0)
                    Wait(0)
                    FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    TSE("drc_drugs:coke:giveitems", data.menu) 
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "FullFigure" then
        if data.option == "break" then
            dict = "anim@heists@box_carry@"
            clip = "idle"
            RequestAnimDict(dict)
            while (not HasAnimDictLoaded(dict)) do Wait(0) end
            TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
            local hash = `bkr_prop_coke_doll`
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(100)
                RequestModel(hash)
            end
            local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
            AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), -0.11, 0.4, -0.11, 1.0, 9.0, 115.0, true, true, false, false, 1, true)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(true)
            end
            FreezeEntityPosition(cache.ped, true)
            ProgressBar(6000, locale("RepairingFigure"))
            DetachEntity(prop, false, false)
            DeleteEntity(prop)
            StopAnimTask(cache.ped, dict, clip, 1.0)
            Wait(0)
            FreezeEntityPosition(cache.ped, false)
            if Config.Target == 'ox_target' then
                exports.ox_target:disableTargeting(false)
            end
            TSE("drc_drugs:coke:giveitems", data.option)
        else
            if not FigureCarry then
                local ped = cache.ped
                RequestAnimDict("impexp_int-0")
                while (not HasAnimDictLoaded("impexp_int-0")) do Wait(0) end
                TaskPlayAnim(ped, 'impexp_int-0', 'mp_m_waremech_01_dual-0', 8.0, -8, -1, 49, 0, 0, 0, 0)
                FigureObject = CreateObject(GetHashKey("bkr_prop_coke_doll"), 0, 0, 0, true, true, true)
                AttachEntityToEntity(FigureObject, ped, GetPedBoneIndex(ped, 24816), -0.03, 0.45, -0.01, -10.0, 90.0,
                    180.0, true, true, false, true, 1, true)
            else
                DetachEntity(FigureObject, 0, 0)
                DeleteEntity(FigureObject)
                ClearPedTasks(cache.ped)
            end
            FigureCarry = not FigureCarry
        end
    elseif data.menu == "ElectricON" then
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(true)
        end
        TaskTurnPedToFaceCoord(cache.ped, Config.Coke.Electricity.coords, 2000)
        TaskStartScenarioInPlace(cache.ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        Wait(2000)
        dict = "gestures@f@standing@casual"
        clip = "gesture_point"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Wait(0) end
        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(1000, locale("turnonel"))
        ClearPedTasks(cache.ped)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
        Electricity = true
    elseif data.menu == "ElectricOFF" then
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(true)
        end
        TaskTurnPedToFaceCoord(cache.ped, Config.Coke.Electricity.coords, 2000)
        TaskStartScenarioInPlace(cache.ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        Wait(2000)
        dict = "gestures@f@standing@casual"
        clip = "gesture_point"
        RequestAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do Wait(0) end
        TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
        FreezeEntityPosition(cache.ped, true)
        ProgressBar(1000, locale("turnoffel"))
        ClearPedTasks(cache.ped)
        FreezeEntityPosition(cache.ped, false)
        if Config.Target == 'ox_target' then
            exports.ox_target:disableTargeting(false)
        end
        Electricity = false
    elseif data.menu == "CokeProcess" then
        lib.callback('drc_drugs:coke:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    if not Minigame("Coke") then return Notify("error", locale("error"), locale("fail")) end
                    local object = CreateObject(GetHashKey("bkr_prop_coke_box_01a"), Config.Coke.LeafProcess.boxcoords.x
                        , Config.Coke.LeafProcess.boxcoords.y, Config.Coke.LeafProcess.boxcoords.z, true, true, false)
                    SetEntityHeading(object, Config.Coke.LeafProcess.boxcoords.w)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    TaskTurnPedToFaceCoord(cache.ped, Config.Coke.LeafProcess.coords, 2000)
                    Wait(2000)
                    dict = "mp_arresting"
                    clip = "a_uncuff"
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                    local hash = `ng_proc_leaves01`
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(100)
                        RequestModel(hash)
                    end
                    local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
                    AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.13, 0.05, 0.0, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
                    FreezeEntityPosition(cache.ped, true)
                    ProgressBar(6000, locale("RepairingFigure"))
                    DetachEntity(prop, false, false)
                    DeleteEntity(prop)
                    StopAnimTask(cache.ped, dict, clip, 1.0)
                    Wait(0)
                    FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    TSE("drc_drugs:coke:giveitems", data.menu)
                    DeleteObject(object)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    elseif data.menu == "CokeSoda" then
        lib.callback('drc_drugs:coke:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    if not Minigame("Coke") then return Notify("error", locale("error"), locale("fail")) end
                    local ped = cache.ped
                    local dict = "anim@amb@business@coc@coc_unpack_cut_left@"
                    RequestAnimDict(dict)
                    RequestModel("bkr_prop_coke_box_01a")
                    RequestModel("prop_cs_credit_card")
                    RequestModel("bkr_prop_coke_bakingsoda_o")
                    while not HasAnimDictLoaded(dict) and not HasModelLoaded("bkr_prop_coke_bakingsoda_o") and
                        not HasModelLoaded("prop_cs_credit_card") do
                        Wait(100)
                    end
                    card = CreateObject(GetHashKey('prop_cs_credit_card'), x, y, z, 1, 0, 1)
                    card_2 = CreateObject(GetHashKey('prop_cs_credit_card'), x, y, z, 1, 0, 1)
                    soda = CreateObject(GetHashKey('bkr_prop_coke_bakingsoda_o'), x, y, z, 1, 0, 1)
                    local targetRotation = vec3(180.0, 180.0, headingtotable)
                    local x, y, z = table.unpack(GetEntityCoords(cache.ped))
                    if headingtotable == 0.0 then
                        netScene = NetworkCreateSynchronisedScene(x + 1.7, y + 0.4, z - 0.65, targetRotation, 2, false,
                            false, 1148846080, 0, 1.1)
                    else
                        netScene = NetworkCreateSynchronisedScene(x - 1.7, y - 0.4, z - 0.65, targetRotation, 2, false,
                            false, 1148846080, 0, 1.1)
                    end
                    NetworkAddPedToSynchronisedScene(ped, netScene, dict, "coke_cut_coccutter", 1.5, -4.0, 1, 16,
                        1148846080, 0)
                    NetworkAddEntityToSynchronisedScene(card, netScene, dict, "coke_cut_creditcard", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(card_2, netScene, dict, "coke_cut_creditcard^1", 4.0, -8.0, 1)
                    NetworkAddEntityToSynchronisedScene(soda, netScene, dict, "cut_cough_v1_bakingsoda", 4.0, -8.0, 1)
                    NetworkStartSynchronisedScene(netScene)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    ProgressBar(GetAnimDuration(dict, "coke_cut_coccutter") * 770, locale("CokeCleaning"))
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    DeleteObject(card)
                    DeleteObject(card_2)
                    DeleteObject(soda)
                    FreezeEntityPosition(ped, false)
                    TSE("drc_drugs:coke:giveitems", data.menu)
                    Wait(GetAnimDuration(dict, "coke_cut_coccutter") * 770)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    end
end)

function PickUpCoke(target)
    local nearbyID
    for i = 1, #CokePlants, 1 do
        local dist = #(GetEntityCoords(cache.ped) - GetEntityCoords(CokePlants[i]))
        if dist < 2 then
            nearbyID = i
        end
    end
    if IsPedOnFoot(cache.ped) then
        lib.callback('drc_drugs:coke:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    if Config.InteractionType ~= "target" then
                        cokeplant[target]:remove()
                        cokeplant[target] = nil
                    end
                    TaskStartScenarioInPlace(cache.ped, "world_human_gardener_plant", 0, true)
                    FreezeEntityPosition(cache.ped, true)
                    ProgressBar(10000, locale("pickingup"))
                    ClearPedTasks(cache.ped)
                    FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    TSE('drc_drugs:deleteprop', ObjToNet(target))
                    SetEntityAsMissionEntity(target, false, true)
                    DeleteObject(target)
                    table.remove(CokePlants, nearbyID)
                    SpawnedCokePlant = SpawnedCokePlant - 1
                    TSE('drc_drugs:coke:giveitems', "CokePick")
                end
            else
                Notify("error", locale("error"), locale("RequiredTrowel"))
            end
        end, "CokePick")
    else
        Wait(500)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(CokePlants) do
            SetEntityAsMissionEntity(v, false, true)
            DeleteObject(v)
        end
    end
end)

SetTimeout(2000, function()
    if Config.InteractionType == "target" then
        target = Target()
        target:AddTargetModel(Config.Coke.Field.prop, {
            options = {
                {
                    action = function(entity)
                        PickUpCoke(entity)
                    end,
                    icon = "fas fa-leaf",
                    label = locale("pickup"),
                    canInteract = function()
                        if inside then
                            return true
                        end
                    end
                },
            },
            distance = 3
        })
    end
end)

function GenerateCokePlantCoords()
    while true do
        Wait(0)

        local CokeCoordX, CokeCoordY

        math.randomseed(GetGameTimer())
        local modX = math.random(math.floor(Config.Coke.Field.radius * -1) + 2, math.floor(Config.Coke.Field.radius) - 2)

        Wait(100)

        math.randomseed(GetGameTimer())
        local modY = math.random(math.floor(Config.Coke.Field.radius * -1) + 2, math.floor(Config.Coke.Field.radius) - 2)

        CokeCoordX = Config.Coke.Field.coords.x + modX
        CokeCoordY = Config.Coke.Field.coords.y + modY

        local coordZ = GetCoordZCoke(CokeCoordX, CokeCoordY)
        local coord = vector3(CokeCoordX, CokeCoordY, coordZ)

        if ValidateCokePlantCoord(coord) then
            return coord
        end
    end
end

function GetCoordZCoke(x, y)
    local groundCheckHeights = { 1.0, 25.0, 50.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

    for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

        if foundGround then
            return z
        end
    end

    return 70
end

function ValidateCokePlantCoord(plantCoord)
    if SpawnedCokePlant > 0 then
        local validate = true

        for k, v in pairs(CokePlants) do
            local dist = #(plantCoord - GetEntityCoords(v))
            if dist < 5 then
                validate = false
            end
        end
        local validdist = #(plantCoord - Config.Coke.Field.coords)
        if validdist > 50 then
            validate = false
        end

        return validate
    else
        return true
    end
end

-- PROGRESSY KONEC --

-- BOXZONES --

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if Config.InteractionType == "target" then
            target = Target()
            for k, _ in pairs(Config.Coke.SodaTables) do
                target:RemoveZone('CokeSodaMenu' .. k)
            end
            target:RemoveZone('CokeElectricMenu')
            target:RemoveZone('CokeFigureMenu')
            target:RemoveZone('CokeBoxMenu')
            target:RemoveZone('CokeTeleportMenu2')
            target:RemoveZone('CokeTeleportMenu1')
            target:RemoveZone('CokeProcessMenu')
        else
            for i = 1, #cokelabzones do
                cokelabzones[i]:remove()
            end
        end
    end
end)

SetTimeout(2000, function()
    if Config.Coke.Enterlab.NeedItem then
        if Config.InteractionType ~= "target" then
            lib.zones.sphere({
                coords = Config.Coke.Enterlab.coords,
                radius = Config.Coke.Enterlab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:coke:progress", {menu = "CokeDoor1", Card = Config.Coke.Enterlab.ItemName})
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
            target:AddCircleZone("CokeTeleportMenu1", Config.Coke.Enterlab.coords, Config.Coke.Enterlab.radius,
                { name = "CokeTeleportMenu1", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { 
                        event = "drc_drugs:coke:progress", 
                        icon = "fas fa-door-open", 
                        label = locale("enter"),
                        menu = "CokeDoor1",
                        Card = Config.Coke.Enterlab.ItemName 
                    }
                },
                    distance = 2.5
                }
            )
        end
    else
        if Config.InteractionType ~= "target" then
            lib.zones.sphere({
                coords = Config.Coke.Enterlab.coords,
                radius = Config.Coke.Enterlab.radius + 0.5,
                debug = Config.Debug,
                inside = function(self)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("drc_drugs:coke:progress", {menu = "CokeDoor1"})
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
            target:AddCircleZone("CokeTeleportMenu1", Config.Coke.Enterlab.coords, Config.Coke.Enterlab.radius,
                { name = "CokeTeleportMenu1", debugPoly = Config.Debug, useZ = true },
                { options = {
                    { 
                        event = "drc_drugs:coke:progress", 
                        icon = "fas fa-door-open", 
                        label = locale("enter"),
                        menu = "CokeDoor1" 
                    }
                },
                    distance = 2.5
                }
            )
        end
    end
end)