local TSE = TriggerServerEvent

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if Config.InteractionType == "target" then
            target = Target()
            target:RemoveZone('CrackProcess')
        end
    end
end)

SetTimeout(2000, function()
    if Config.InteractionType == "target" then
        target = Target()
        target:AddCircleZone("CrackProcess", Config.Crack.Process.coords, Config.Crack.Process.radius,
            { name = "CrackProcess", debugPoly = Config.Debug, useZ = true },
            { options = {
                { event = "drc_drugs:crack:menu", icon = "fas fa-pills", label = locale("MakeCrack"),
                    menu = "CrackProcess",
                }
            },
                distance = 2.5
            }
        )
    else
        lib.zones.sphere({
            coords = Config.Crack.Process.coords,
            radius = Config.Crack.Process.radius + 0.5,
            debug = Config.Debug,
            inside = function(self)
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("drc_drugs:crack:menu", {menu = "CrackProcess"})
                end

                if Config.InteractionType == "3dtext" then
                    Draw3DText(self.coords, "[~g~E~w~] - " .. locale('MakeCrack'))
                end
            end,
            onEnter = function()
                if Config.InteractionType == "textui" then
                        TextUIShow("[E] - " .. locale('MakeCrack'))
                end    
            end,
            onExit = function()
                if Config.InteractionType == "textui" then
                    TextUIHide()
                end
            end
        })
    end
end)

RegisterNetEvent("drc_drugs:crack:menu", function(data)
    if data.menu == "CrackProcess" then
        if Config.Context == "qbcore" then
            exports['qb-menu']:openMenu({
                {
                    isMenuHeader = true,
                    header = locale('table')
                },
                {
                    header = Config.Crack.Process.header,
                    txt = Config.Crack.Process.description,
                    params = {
                        event = 'drc_drugs:crack:progress',
                        args = { menu = data.menu }
                    }
                }
            })
        elseif Config.Context == "ox_lib" then
            lib.registerContext({
                id = 'DrugsCrackMenu',
                title = locale("table"),
                options = {
                    [Config.Crack.Process.header] = {
                        arrow = false,
                        description = Config.Crack.Process.description,
                        event = 'drc_drugs:crack:progress',
                        args = { menu = data.menu }
                    }
                }
            })
            lib.showContext('DrugsCrackMenu')
        end
    end
end)

RegisterNetEvent("drc_drugs:crack:progress")
AddEventHandler("drc_drugs:crack:progress", function(data)
    if data.menu == "CrackProcess" then
        lib.callback('drc_drugs:crack:getitem', false, function(value)
            if value then
                if not IsProgressBarActive() then
                    SetEntityCoords(cache.ped, Config.Crack.Process.Teleport, false, false, false, true)
                    TaskTurnPedToFaceCoord(cache.ped, Config.Crack.Process.coords, 2000)
                    dict = "anim@mp_player_intupperspray_champagne"
                    clip = "idle_a"
                    RequestAnimDict(dict)
                    while (not HasAnimDictLoaded(dict)) do Wait(0) end
                    TaskPlayAnim(cache.ped, dict, clip, 3.0, 1.0, -1, 49, 0, false, false, false)
                    local hash = `bkr_prop_coke_bottle_01a`
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Wait(100)
                        RequestModel(hash)
                    end
                    local prop = CreateObject(hash, GetEntityCoords(cache.ped), true, true, true)
                    AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.0, 0.0, -0.22, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(true)
                    end
                    FreezeEntityPosition(cache.ped, true)
                    ProgressBar(Config.Heroin.Process.Duration, locale("CrackMaking"))
                    StopAnimTask(cache.ped, dict, clip, 1.0)
                    Wait(0)
                    FreezeEntityPosition(cache.ped, false)
                    if Config.Target == 'ox_target' then
                        exports.ox_target:disableTargeting(false)
                    end
                    DeleteEntity(prop)
                    TSE("drc_drugs:crack:giveitems", data.menu)
                end
            else
                Notify("error", locale("error"), locale("RequiredItems"))
            end
        end, data.menu)
    end
end)
