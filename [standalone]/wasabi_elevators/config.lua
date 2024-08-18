-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

Config = {}

Config.checkForUpdates = true -- Check for Updates?

Config.Elevators = {
    HospitalCentralElevator = { -- Elevator name(Doesn't show it's just to name table)
        [1] = {
            coords = vec3(320.46, -598.25, 38.33), -- Coords, if you're new; last number is heading
            heading = 70.65, -- Heading of how will spawn on floor
            title = 'Piso 1', -- Title 
            description = 'Cirugías', -- Description
            target = { -- Target length/width
                width = 5,
                length = 4
            },
            groups = {-- Job locks
                'police',
                'ambulance'
            },
        },
        [2] = {
            coords = vec3(316.6, -577.48, 43.28), -- Coords, if you're new; last number is heading
            heading = 70.65, -- Heading of how will spawn on floor
            title = 'Piso 2', -- Title 
            description = 'Piso principal', -- Description
            target = { -- Target length/width
                width = 5,
                length = 4
            },
            groups = {-- Job locks
                'police',
                'ambulance'
            },
        },
        [3] = {
            coords = vec3(327.67, -569.28, 48.21), -- Coords, if you're new; last number is heading
            heading = 252.84,
            title = 'Piso 3',
            description = 'Habitaciones',
            target = {
            width = 5,
            length = 4
            } -- Example without group
        },
        [4] = {
            coords = vec3(338.87, -583.77, 74.16), -- Coords, if you're new; last number is heading
            heading = 252.84,
            title = 'Piso 4',
            description = 'Helipuerto',
            target = {
            width = 5,
            length = 4
            } -- Example without group
        },
    },
}