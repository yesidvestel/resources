-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

hasBoomBox = function(radio)
    local equipRadio = true
    CreateThread(function()
        if Config.InstructionNotification then
            lib.notify({
                title = 'Instructions',
                description = 'Presiona E para soltar el boombox',
                type = 'success'
            })
        end
        while equipRadio do
            Wait(0)
            if IsControlJustReleased(0, 38) then
                equipRadio = false
				DetachEntity(radio)
				PlaceObjectOnGroundProperly(radio)
                FreezeEntityPosition(radio, true)
                boomboxPlaced(radio)
            end
        end
    end)
end

if Framework == "ESX" then
    boomboxPlaced = function(obj)
        local coords = GetEntityCoords(obj)
        local heading = GetEntityHeading(obj)
        local targetPlaced = false
        CreateThread(function()
            while true do
                if DoesEntityExist(obj) and not targetPlaced then
                    exports.qtarget:AddBoxZone("boomboxzone", coords, 1, 1, {
                        name="boomboxzone",
                        heading=heading,
                        debugPoly=false,
                        minZ=coords.z-0.9,
                        maxZ=coords.z+0.9
                    }, {
                        options = {
                            {
                                event = 'wasabi_boombox:interact',
                                icon = 'fas fa-hand-paper',
                                label = 'Interact',
                            },
                            {
                                event = 'wasabi_boombox:pickup',
                                icon = 'fas fa-volume-up',
                                label = 'Pick Up'
                            }

                        },
                        job = 'all',
                        distance = 1.5
                    })
                    targetPlaced = true
                elseif not DoesEntityExist(obj) then
                    exports.qtarget:RemoveZone('boomboxzone')
                    targetPlaced = false
                    break
                end
                Wait(1000)
            end
        end)
    end
elseif Framework == "qb" then
    boomboxPlaced = function(obj)
        local coords = GetEntityCoords(obj)
        local heading = GetEntityHeading(obj)
        local targetPlaced = false
        CreateThread(function()
            while true do
                if DoesEntityExist(obj) and not targetPlaced then
                    exports['qb-target']:AddBoxZone("boomboxzone", coords, 1, 1, {
                        name="boomboxzone",
                        heading=heading,
                        debugPoly=false,
                        minZ=coords.z-0.9,
                        maxZ=coords.z+0.9
                    }, {
                        options = {
                            {
                                event = 'wasabi_boombox:interact',
                                icon = 'fas fa-hand-paper',
                                label = 'Interact',
                            },
                            {
                                event = 'wasabi_boombox:pickup',
                                icon = 'fas fa-volume-up',
                                label = 'Pick Up'
                            }

                        },
                        job = 'all',
                        distance = 1.5
                    })
                    targetPlaced = true
                elseif not DoesEntityExist(obj) then
                    exports['qb-target']:RemoveZone('boomboxzone')
                    targetPlaced = false
                    break
                end
                Wait(1000)
            end
        end)
    end
end

interactBoombox = function(radio, radioCoords)
    if not activeRadios[radio] then
        activeRadios[radio] = {
            pos = radioCoords,
            data = {
                playing = false
            }
        }
    else
        activeRadios[radio].pos = radioCoords
    end
    TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
    if not activeRadios[radio].data.playing then
        lib.registerContext({
            id = 'boomboxFirst',
            title = 'Boombox',
            options = {
                {
                    title = 'Reproducir música',
                    description = 'Reproducir música en el altavoz',
                    arrow = true,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'play', id = radio}
                },
                {
                    title = 'Canciones guardadas',
                    description = 'Canciones que guardaste previamente',
                    arrow = true,
                    event = 'wasabi_boombox:savedSongs',
                    args = {id = radio}
                }
            }
        })
        lib.showContext('boomboxFirst')
    else
        lib.registerContext({
            id = 'boomboxSecond',
            title = 'Boombox',
            options = {
                {
                    title = 'Cambiar música',
                    description = 'Cambiar música en el altavoz',
                    arrow = true,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'play', id = radio}
                },
                {
                    title = 'Canciones guardadas',
                    description = 'Canciones que guardaste previamente',
                    arrow = true,
                    event = 'wasabi_boombox:savedSongs',
                    args = {id = radio}
                },
                {
                    title = 'Detener la música',
                    description = 'Detener la música on speaker',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'stop', id = radio}
                },
                {
                    title = 'Ajustar el volumen',
                    description = 'Cambiar el volumen del altavoz',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'volume', id = radio}
                },
                {
                    title = 'Cambiar distancia',
                    description = 'Cambiar distancia del altavoz',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'distance', id = radio}
                }
            }
        })
        lib.showContext('boomboxSecond')
    end
end

selectSavedSong = function(data)
    lib.registerContext({
        id = 'selectSavedSong',
        title = 'Manage Song',
        options = {
            {
                title = 'Reproducir canción',
                description = 'Reproduce esta canción',
                arrow = false,
                event = 'wasabi_boombox:playSavedSong',
                args = data
            },
            {
                title = 'Eliminar canción',
                description = 'Borrar esta canción',
                arrow = true,
                event = 'wasabi_boombox:deleteSong',
                args = data
            }
        }
    })
    lib.showContext('selectSavedSong')
end

if Framework == "ESX" then
    savedSongsMenu = function(radio)
        ESX.TriggerServerCallback('wasabi_boombox:getSavedSongs', function(cb)
            local radio = radio.id
            local Options = {
                {
                    title = 'Guardar una canción',
                    description = 'Guarda una canción para reproducirla más tarde.',
                    arrow = true,
                    event = 'wasabi_boombox:saveSong',
                    args = {id = radio}
                }
            }
            if cb then
                for i=1, #cb do
                    print(radio)
                    table.insert(Options, {
                        title = cb[i].label,
                        description = '',
                        arrow = true,
                        event = 'wasabi_boombox:selectSavedSong',
                        args = {id = radio, link = cb[i].link, label = cb[i].label}
                    })
                end
            end
            lib.registerContext({
                id = 'boomboxSaved',
                title = 'Boombox',
                options = Options
            })
            lib.showContext('boomboxSaved')
        end)
    end
elseif Framework == "qb" then
    savedSongsMenu = function(radio)
        QBCore.Functions.TriggerCallback('wasabi_boombox:getSavedSongs', function(cb)
            local radio = radio.id
            local Options = {
                {
                    title = 'Guardar una canción',
                    description = 'Guarda una canción para reproducirla más tarde.',
                    arrow = true,
                    event = 'wasabi_boombox:saveSong',
                    args = {id = radio}
                }
            }
            if cb then
                for i=1, #cb do
                    print(radio)
                    table.insert(Options, {
                        title = cb[i].label,
                        description = '',
                        arrow = true,
                        event = 'wasabi_boombox:selectSavedSong',
                        args = {id = radio, link = cb[i].link, label = cb[i].label}
                    })
                end
            end
            lib.registerContext({
                id = 'boomboxSaved',
                title = 'Boombox',
                options = Options
            })
            lib.showContext('boomboxSaved')
        end)
    end
end
