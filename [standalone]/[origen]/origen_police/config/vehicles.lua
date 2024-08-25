Config.Vehicles = {
    ["car"] = {
        ["police"] = {
            ["police"] = {label = "Police Patrol 1", grade = 1},
            ["police2"] = {label = "Police Patrol 2", grade = 1},
            ["police3"] = {label = "Police Patrol 3", grade = 1},
            ["policeb"] = {label = "Police Patrol 4", grade = 2},
        },
        ["sheriff"] = {
            -- vehicle list of sheriff
        },
        ["ambulance"] = {
            -- vehicle list of paramedics
            ["ambulance"] = {label = "Ambulance", grade = 1},
        }
    },
    ["heli"] = {
        ["police"] = {
            ["polmav"] = {label = "Police maverick", grade = 3},
        },
        ["sheriff"] = {
            -- vehicle list of sheriff
        },
        ["ambulance"] = {
            -- vehicle list of paramedics
        }
    },
    ["boat"] = {
        ["police"] = {
            ["predator"] = {label = "Police Boat", grade = 1},
        },
        ["sheriff"] = {
            -- vehicle list of sheriff
        },
        ["ambulance"] = {
            -- vehicle list of paramedics
        }
    }
}

Config.AllowedAlprJobs = { -- Jobs that can use the ALPR(speed radar) system
    ["police"] = true,
    ["sheriff"] = true,
}

Config.Camara = {
    fov_max = 80.0,
    fov_min = 10.0,
    zoomspeed = 5.0,
    speed_lr = 5.0,
    speed_ud = 5.0
}

Config.SirensSystem = true -- To enable or disable the sirens system(Q -> turn on/off lights; ,-> turn on/off sirens)

Config.Sirens = {
    "VEHICLES_HORNS_SIREN_1",
    "VEHICLES_HORNS_SIREN_2",
    "VEHICLES_HORNS_POLICE_WARNING"
}

Config.DefaultCarCamOffset = vector3(0.0, 0.5, 0.7)
Config.CustomCarOffsets = { -- Modified offsets for special vehicles
    ["police"] =  vector3(0.0, 0.5, 0.7),
    ["police2"] =  vector3(0.0, 0.5, 0.7),
}

Config.CustomCarLabels = { -- A list for custom vehicle labels, for the citizen search only will take this label if the vehicle label is NULL
    -- [GetHashKey("police")] = "POLICE PATROL",
    -- [GetHashKey("police2")] = "POLICE PATROL 2",
    -- [GetHashKey("police3")] = "POLICE PATROL 3",
}

Config.SpeedType = 'kmh' -- 'kmh' or 'mph'
Config.VehicleDataDist = 3.0 -- The distance to show the vehicle data
Config.HeliCam = true -- Enable or disable the helicam system