Config = {}
Config.Keybind = 'F1'           -- FiveM Keyboard, this is registered keymapping, so needs changed in keybindings if player already has this mapped.
Config.Toggle = false           -- use toggle mode. False requires hold of key
Config.UseWhilstWalking = false -- use whilst walking
Config.EnableExtraMenu = true
Config.Fliptime = 15000

Config.MenuItems = {
    {
        id = 'citizen',
        title = 'Ciudadano',
        icon = 'user',
        items = {
            {
                id = 'givenum',
                title = 'Dar detalles de contacto',
                icon = 'address-book',
                type = 'client',
                event = 'qb-phone:client:GiveContactDetails',
                shouldClose = true
            }, {
            id = 'getintrunk',
            title = 'Métete en el maletero',
            icon = 'car',
            type = 'client',
            event = 'qb-trunk:client:GetIn',
            shouldClose = true
        }, {
            id = 'cornerselling',
            title = 'Venta de esquina',
            icon = 'cannabis',
            type = 'client',
            event = 'qb-drugs:client:cornerselling',
            shouldClose = true
        }, {
            id = 'togglehotdogsell',
            title = 'Venta de perritos calientes',
            icon = 'hotdog',
            type = 'client',
            event = 'qb-hotdogjob:client:ToggleSell',
            shouldClose = true
        }, {
            id = 'interactions',
            title = 'Interacción',
            icon = 'triangle-exclamation',
            items = {
                {
                    id = 'handcuff',
                    title = 'Esposar',
                    icon = 'user-lock',
                    type = 'client',
                    event = 'police:client:CuffPlayerSoft',
                    shouldClose = true
                }, {
                id = 'playerinvehicle',
                title = 'Poner en el vehículo',
                icon = 'car-side',
                type = 'client',
                event = 'police:client:PutPlayerInVehicle',
                shouldClose = true
            }, {
                id = 'playeroutvehicle',
                title = 'Sacar del vehículo',
                icon = 'car-side',
                type = 'client',
                event = 'police:client:SetPlayerOutVehicle',
                shouldClose = true
            }, {
                id = 'stealplayer',
                title = 'Robar',
                icon = 'mask',
                type = 'client',
                event = 'police:client:RobPlayer',
                shouldClose = true
            }, {
                id = 'escort',
                title = 'Secuestrar',
                icon = 'user-group',
                type = 'client',
                event = 'police:client:KidnapPlayer',
                shouldClose = true
            }, {
                id = 'escort2',
                title = 'Escolta',
                icon = 'user-group',
                type = 'client',
                event = 'police:client:EscortPlayer',
                shouldClose = true
            }, {
                id = 'escort554',
                title = 'Rehén',
                icon = 'child',
                type = 'client',
                event = 'A5:Client:TakeHostage',
                shouldClose = true
            }
            }
        }
        }
    },
    {
        id = 'general',
        title = 'General',
        icon = 'rectangle-list',
        items = {
            {
                id = 'house',
                title = 'Interacción de la casa',
                icon = 'house',
                items = {
                    {
                        id = 'givehousekey',
                        title = 'Dar las llaves de la casa',
                        icon = 'key',
                        type = 'client',
                        event = 'qb-houses:client:giveHouseKey',
                        shouldClose = true
                    }, {
                    id = 'removehousekey',
                    title = 'Quitar las llaves de la casas',
                    icon = 'key',
                    type = 'client',
                    event = 'qb-houses:client:removeHouseKey',
                    shouldClose = true
                }, {
                    id = 'togglelock',
                    title = 'Alternar cerradura de puerta',
                    icon = 'door-closed',
                    type = 'client',
                    event = 'qb-houses:client:toggleDoorlock',
                    shouldClose = true
                }, {
                    id = 'decoratehouse',
                    title = 'decorar casa',
                    icon = 'box',
                    type = 'client',
                    event = 'qb-houses:client:decorate',
                    shouldClose = true
                }, {
                    id = 'houseLocations',
                    title = 'Lugares de interacción',
                    icon = 'house',
                    items = {
                        {
                            id = 'setstash',
                            title = 'Establecer alijo',
                            icon = 'box-open',
                            type = 'client',
                            event = 'qb-houses:client:setLocation',
                            shouldClose = true
                        }, {
                        id = 'setoutift',
                        title = 'Conjunto Armario',
                        icon = 'shirt',
                        type = 'client',
                        event = 'qb-houses:client:setLocation',
                        shouldClose = true
                    }, {
                        id = 'setlogout',
                        title = 'Establecer cierre de sesión',
                        icon = 'door-open',
                        type = 'client',
                        event = 'qb-houses:client:setLocation',
                        shouldClose = true
                    }
                    }
                }
                }
            }, {
            id = 'clothesmenu',
            title = 'Ropa',
            icon = 'shirt',
            items = {
                {
                    id = 'Hair',
                    title = 'Cabello',
                    icon = 'user',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                id = 'Ear',
                title = 'Auricular',
                icon = 'ear-deaf',
                type = 'client',
                event = 'qb-radialmenu:ToggleProps',
                shouldClose = true
            }, {
                id = 'Neck',
                title = 'Cuello',
                icon = 'user-tie',
                type = 'client',
                event = 'qb-radialmenu:ToggleClothing',
                shouldClose = true
            }, {
                id = 'Top',
                title = 'Arriba',
                icon = 'shirt',
                type = 'client',
                event = 'qb-radialmenu:ToggleClothing',
                shouldClose = true
            }, {
                id = 'Shirt',
                title = 'Camisa',
                icon = 'shirt',
                type = 'client',
                event = 'qb-radialmenu:ToggleClothing',
                shouldClose = true
            }, {
                id = 'Pants',
                title = 'Pantalones',
                icon = 'user',
                type = 'client',
                event = 'qb-radialmenu:ToggleClothing',
                shouldClose = true
            }, {
                id = 'Shoes',
                title = 'Zapatos',
                icon = 'shoe-prints',
                type = 'client',
                event = 'qb-radialmenu:ToggleClothing',
                shouldClose = true
            }, {
                id = 'meer',
                title = 'Extras',
                icon = 'plus',
                items = {
                    {
                        id = 'Hat',
                        title = 'Tiene',
                        icon = 'hat-cowboy-side',
                        type = 'client',
                        event = 'qb-radialmenu:ToggleProps',
                        shouldClose = true
                    }, {
                    id = 'Glasses',
                    title = 'Anteojos',
                    icon = 'glasses',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleProps',
                    shouldClose = true
                }, {
                    id = 'Visor',
                    title = 'Visera',
                    icon = 'hat-cowboy-side',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleProps',
                    shouldClose = true
                }, {
                    id = 'Mask',
                    title = 'Mascara',
                    icon = 'masks-theater',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'Vest',
                    title = 'Chaleco',
                    icon = 'vest',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'Bag',
                    title = 'Bolsa',
                    icon = 'bag-shopping',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'Bracelet',
                    title = 'Pulsera',
                    icon = 'user',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleProps',
                    shouldClose = true
                }, {
                    id = 'Watch',
                    title = 'Reloj',
                    icon = 'stopwatch',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleProps',
                    shouldClose = true
                }, {
                    id = 'Gloves',
                    title = 'Guantes',
                    icon = 'mitten',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }
                }
            }
            }
        }
        }
    },
}

Config.VehicleDoors = {
    id = 'vehicledoors',
    title = 'Puertas de vehículos',
    icon = 'car-side',
    items = {
        {
            id = 'door0',
            title = 'puerta del conductor',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            shouldClose = false
        }, {
        id = 'door4',
        title = 'Capucha',
        icon = 'car',
        type = 'client',
        event = 'qb-radialmenu:client:openDoor',
        shouldClose = false
    }, {
        id = 'door1',
        title = 'Puerta de pasajeros',
        icon = 'car-side',
        type = 'client',
        event = 'qb-radialmenu:client:openDoor',
        shouldClose = false
    }, {
        id = 'door3',
        title = 'Trasera derecha',
        icon = 'car-side',
        type = 'client',
        event = 'qb-radialmenu:client:openDoor',
        shouldClose = false
    }, {
        id = 'door5',
        title = 'Frente',
        icon = 'car',
        type = 'client',
        event = 'qb-radialmenu:client:openDoor',
        shouldClose = false
    }, {
        id = 'door2',
        title = 'Izquierda trasera',
        icon = 'car-side',
        type = 'client',
        event = 'qb-radialmenu:client:openDoor',
        shouldClose = false
    }
    }
}

Config.VehicleExtras = {
    id = 'vehicleextras',
    title = 'Extras del vehículo',
    icon = 'plus',
    items = {
        {
            id = 'extra1',
            title = 'Extra 1',
            icon = 'box-open',
            type = 'client',
            event = 'qb-radialmenu:client:setExtra',
            shouldClose = false
        }, {
        id = 'extra2',
        title = 'Extra 2',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra3',
        title = 'Extra 3',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra4',
        title = 'Extra 4',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra5',
        title = 'Extra 5',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra6',
        title = 'Extra 6',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra7',
        title = 'Extra 7',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra8',
        title = 'Extra 8',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra9',
        title = 'Extra 9',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra10',
        title = 'Extra 10',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra11',
        title = 'Extra 11',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra12',
        title = 'Extra 12',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }, {
        id = 'extra13',
        title = 'Extra 13',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
    }
    }
}

Config.VehicleSeats = {
    id = 'vehicleseats',
    title = 'Asientos de vehículos',
    icon = 'chair',
    items = {}
}

Config.JobInteractions = {
    ['ambulance'] = {
        {
            id = 'statuscheck',
            title = 'Verificar estado de salud',
            icon = 'heart-pulse',
            type = 'client',
            event = 'hospital:client:CheckStatus',
            shouldClose = true
        }, {
        id = 'revivep',
        title = 'Reanimar',
        icon = 'user-doctor',
        type = 'client',
        event = 'hospital:client:RevivePlayer',
        shouldClose = true
    }, {
        id = 'treatwounds',
        title = 'Curar heridas',
        icon = 'bandage',
        type = 'client',
        event = 'hospital:client:TreatWounds',
        shouldClose = true
    }, {
        id = 'emergencybutton2',
        title = 'Boton de emergencia',
        icon = 'bell',
        type = 'client',
        event = 'ps-dispatch:client:emsdown',
        shouldClose = true
    }, {
        id = 'escort',
        title = 'Escolta',
        icon = 'user-group',
        type = 'client',
        event = 'police:client:EscortPlayer',
        shouldClose = true
    }, {
        id = 'stretcheroptions',
        title = 'Camilla',
        icon = 'bed-pulse',
        items = {
            {
                id = 'spawnstretcher',
                title = 'Camilla de aparición',
                icon = 'plus',
                type = 'client',
                event = 'qb-radialmenu:client:TakeStretcher',
                shouldClose = false
            }, {
            id = 'despawnstretcher',
            title = 'Quitar camilla',
            icon = 'minus',
            type = 'client',
            event = 'qb-radialmenu:client:RemoveStretcher',
            shouldClose = false
        }
        }
    }
    },
    ['taxi'] = {
        {
            id = 'togglemeter',
            title = 'Mostrar/Ocultar medidor',
            icon = 'eye-slash',
            type = 'client',
            event = 'qb-taxi:client:toggleMeter',
            shouldClose = false
        }, {
        id = 'togglemouse',
        title = 'Medidor de inicio/parada',
        icon = 'hourglass-start',
        type = 'client',
        event = 'qb-taxi:client:enableMeter',
        shouldClose = true
    }, {
        id = 'npc_mission',
        title = 'Misión PNJ',
        icon = 'taxi',
        type = 'client',
        event = 'qb-taxi:client:DoTaxiNpc',
        shouldClose = true
    }
    },
    ['tow'] = {
        {
            id = 'togglenpc',
            title = 'Toggle NPC',
            icon = 'toggle-on',
            type = 'client',
            event = 'jobs:client:ToggleNpc',
            shouldClose = true
        }, {
        id = 'towvehicle',
        title = 'vehículo de remolque',
        icon = 'truck-pickup',
        type = 'client',
        event = 'qb-tow:client:TowVehicle',
        shouldClose = true
    }
    },
    ['mechanic'] = {
        {
            id = 'towvehicle',
            title = 'vehículo de remolque',
            icon = 'truck-pickup',
            type = 'client',
            event = 'qb-tow:client:TowVehicle',
            shouldClose = true
        }
    },
    ['police'] = {
        {
            id = 'emergencybutton',
            title = 'Boton de emergencia',
            icon = 'bell',
            type = 'client',
            event = 'ps-dispatch:client:officerdown',
            shouldClose = true
        }, {
        id = 'checkvehstatus',
        title = 'Verificar el estado de la melodía',
        icon = 'circle-info',
        type = 'client',
        event = 'qb-tunerchip:client:TuneStatus',
        shouldClose = true
    }, {
        id = 'resethouse',
        title = 'Restablecer bloqueo de casa',
        icon = 'key',
        type = 'client',
        event = 'qb-houses:client:ResetHouse',
        shouldClose = true
    },{
        id = 'trafficstop',
		title = 'Alerta de parada de tráfico',
		icon = 'user-lock',
		type = 'client',
		event = 'ps-mdt:client:trafficStop',
		shouldClose = true
    }, {
        id = 'takedriverlicense',
        title = 'Revocar la licencia de conducir',
        icon = 'id-card',
        type = 'client',
        event = 'police:client:SeizeDriverLicense',
        shouldClose = true
    }, {
        id = 'policeinteraction',
        title = 'Acciones policiales',
        icon = 'list-check',
        items = {
            {
                id = 'statuscheck',
                title = 'Verificar estado de salud',
                icon = 'heart-pulse',
                type = 'client',
                event = 'hospital:client:CheckStatus',
                shouldClose = true
            }, {
            id = 'checkstatus',
            title = 'Comprobar estado',
            icon = 'question',
            type = 'client',
            event = 'police:client:CheckStatus',
            shouldClose = true
        }, {
            id = 'escort',
            title = 'Escolta',
            icon = 'user-group',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true
        }, {
            id = 'searchplayer',
            title = 'Buscar',
            icon = 'magnifying-glass',
            type = 'client',
            event = 'police:client:SearchPlayer',
            shouldClose = true
        }, {
            id = 'jailplayer',
            title = 'Encarcelar',
            icon = 'user-lock',
            type = 'client',
            event = 'police:client:JailPlayer',
            shouldClose = true
        }
        }
    }, {
        id = 'policeobjects',
        title = 'Objetos',
        icon = 'road',
        items = {
            {
                id = 'spawnpion',
                title = 'Cono',
                icon = 'triangle-exclamation',
                type = 'client',
                event = 'police:client:spawnCone',
                shouldClose = false
            }, {
            id = 'spawnhek',
            title = 'Puerta',
            icon = 'torii-gate',
            type = 'client',
            event = 'police:client:spawnBarrier',
            shouldClose = false
        }, {
            id = 'spawnschotten',
            title = 'Senal de limite de velocidad',
            icon = 'sign-hanging',
            type = 'client',
            event = 'police:client:spawnRoadSign',
            shouldClose = false
        }, {
            id = 'spawntent',
            title = 'Carpa',
            icon = 'campground',
            type = 'client',
            event = 'police:client:spawnTent',
            shouldClose = false
        }, {
            id = 'spawnverlichting',
            title = 'Encendiendo',
            icon = 'lightbulb',
            type = 'client',
            event = 'police:client:spawnLight',
            shouldClose = false
        }, {
            id = 'spikestrip',
            title = 'Tiras de púas',
            icon = 'caret-up',
            type = 'client',
            event = 'police:client:SpawnSpikeStrip',
            shouldClose = false
        }, {
            id = 'deleteobject',
            title = 'Quitar objeto',
            icon = 'trash',
            type = 'client',
            event = 'police:client:deleteObject',
            shouldClose = false
        }
        }
    }
    },
    ['hotdog'] = {
        {
            id = 'togglesell',
            title = 'Alternar venta',
            icon = 'hotdog',
            type = 'client',
            event = 'qb-hotdogjob:client:ToggleSell',
            shouldClose = true
        }
    }
}

Config.TrunkClasses = {
    [0] = { allowed = true, x = 0.0, y = -1.5, z = 0.0 },   -- Coupes
    [1] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Sedans
    [2] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 },  -- SUVs
    [3] = { allowed = true, x = 0.0, y = -1.5, z = 0.0 },   -- Coupes
    [4] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Muscle
    [5] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Sports Classics
    [6] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Sports
    [7] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Super
    [8] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, -- Motorcycles
    [9] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 },  -- Off-road
    [10] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Industrial
    [11] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Utility
    [12] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Vans
    [13] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Cycles
    [14] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Boats
    [15] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Helicopters
    [16] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Planes
    [17] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Service
    [18] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Emergency
    [19] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Military
    [20] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Commercial
    [21] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }  -- Trains
}

Config.ExtrasEnabled = true

Config.Commands = {
    ['top'] = {
        Func = function() ToggleClothing('Top') end,
        Sprite = 'top',
        Desc = 'Quitarte/ponerte la camisa',
        Button = 1,
        Name = 'Torso'
    },
    ['gloves'] = {
        Func = function() ToggleClothing('gloves') end,
        Sprite = 'gloves',
        Desc = 'Quitarte/ponerte los guantes',
        Button = 2,
        Name = 'Gloves'
    },
    ['visor'] = {
        Func = function() ToggleProps('visor') end,
        Sprite = 'visor',
        Desc = 'Alternar variación de sombrero',
        Button = 3,
        Name = 'Visor'
    },
    ['bag'] = {
        Func = function() ToggleClothing('Bag') end,
        Sprite = 'bag',
        Desc = 'Abre o cierra tu bolso',
        Button = 8,
        Name = 'Bag'
    },
    ['shoes'] = {
        Func = function() ToggleClothing('Shoes') end,
        Sprite = 'shoes',
        Desc = 'Quitarte/ponerte los zapatos',
        Button = 5,
        Name = 'Shoes'
    },
    ['vest'] = {
        Func = function() ToggleClothing('Vest') end,
        Sprite = 'vest',
        Desc = 'Quítate/ponte el chaleco',
        Button = 14,
        Name = 'Vest'
    },
    ['hair'] = {
        Func = function() ToggleClothing('hair') end,
        Sprite = 'hair',
        Desc = 'Pon tu cabello recogido/suelto/en un moño/cola de caballo.',
        Button = 7,
        Name = 'Hair'
    },
    ['hat'] = {
        Func = function() ToggleProps('Hat') end,
        Sprite = 'hat',
        Desc = 'Quitarte/ponerte el sombrero',
        Button = 4,
        Name = 'Hat'
    },
    ['glasses'] = {
        Func = function() ToggleProps('Glasses') end,
        Sprite = 'glasses',
        Desc = 'Quítate/ponte las gafas',
        Button = 9,
        Name = 'Glasses'
    },
    ['ear'] = {
        Func = function() ToggleProps('Ear') end,
        Sprite = 'ear',
        Desc = 'Quítate y ponte el accesorio para la oreja',
        Button = 10,
        Name = 'Ear'
    },
    ['neck'] = {
        Func = function() ToggleClothing('Neck') end,
        Sprite = 'neck',
        Desc = 'Quítate y ponte el accesorio para el cuello',
        Button = 11,
        Name = 'Neck'
    },
    ['watch'] = {
        Func = function() ToggleProps('Watch') end,
        Sprite = 'watch',
        Desc = 'Quita y enciende tu reloj',
        Button = 12,
        Name = 'Watch',
        Rotation = 5.0
    },
    ['bracelet'] = {
        Func = function() ToggleProps('Bracelet') end,
        Sprite = 'bracelet',
        Desc = 'Quítate/ponte la pulsera',
        Button = 13,
        Name = 'Bracelet'
    },
    ['mask'] = {
        Func = function() ToggleClothing('Mask') end,
        Sprite = 'mask',
        Desc = 'Quítate/ponte la mascarilla',
        Button = 6,
        Name = 'Mask'
    }
}

local bags = { [40] = true, [41] = true, [44] = true, [45] = true }

Config.ExtraCommands = {
    ['pants'] = {
        Func = function() ToggleClothing('Pants', true) end,
        Sprite = 'pants',
        Desc = 'Quitarte/ponerte los pantalones',
        Name = 'Pants',
        OffsetX = -0.04,
        OffsetY = 0.0
    },
    ['shirt'] = {
        Func = function() ToggleClothing('Shirt', true) end,
        Sprite = 'shirt',
        Desc = 'Quitarte/ponerte la camisa',
        Name = 'shirt',
        OffsetX = 0.04,
        OffsetY = 0.0
    },
    ['reset'] = {
        Func = function()
            if not ResetClothing(true) then
                Notify('Nothing To Reset', 'error')
            end
        end,
        Sprite = 'reset',
        Desc = 'Regresar todo a la normalidad',
        Name = 'reset',
        OffsetX = 0.12,
        OffsetY = 0.2,
        Rotate = true
    },
    ['bagoff'] = {
        Func = function() ToggleClothing('Bagoff', true) end,
        Sprite = 'bagoff',
        SpriteFunc = function()
            local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
            local BagOff = LastEquipped['Bagoff']
            if LastEquipped['Bagoff'] then
                if bags[BagOff.Drawable] then
                    return 'bagoff'
                else
                    return 'paraoff'
                end
            end
            if Bag ~= 0 then
                if bags[Bag] then
                    return 'bagoff'
                else
                    return 'paraoff'
                end
            else
                return false
            end
        end,
        Desc = 'Quitar/poner tu bolso',
        Name = 'bagoff',
        OffsetX = -0.12,
        OffsetY = 0.2
    }
}
