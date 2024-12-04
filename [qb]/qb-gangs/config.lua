Config = Config or {}

Config.Fuel = 'LegacyFuel' --ps-fuel, lj-fuel, LegacyFuel

Config.stash ={
    ["ballas"] = vector3(79.97, -1964.25, 18.04),
    ["vagos"] = vector3(337.08, -2012.87, 22.39),
    ["families"] = vector3(-136.91, -1609.84, 35.03),
	 ["cartel"] = vector3(1436.73, -1489.58, 66.62), --prueba
}
Config.armor ={
    ['ballas'] = {
        [1] = vector3(79.86, -1964.79, 18.04),
        [2] = vector3(-449.811, 6012.909, 31.815),
    },
}

Config.Gangs = {
    ["ballas"] = {
        ["VehicleSpawner"] = vector3(87.83, -1968.48, 20.75),
        ["colors"] = { 145, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["manchez"] = "Manchez",
            ["chino2"] = "Lowrider",
        },
    },
    ["vagos"] = {
        ["VehicleSpawner"] = vector4(335.66, -2039.72, 21.14, 60.08),
        ["colors"] = { 89, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["manchez"] = "Manchez",
            ["chino2"] = "Lowrider",
        },
    },
    ["families"] = {
        ["VehicleSpawner"] = vector4(-108.68, -1598.61, 31.66, 329.64),
        ["colors"] = { 53, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {

            ["manchez"] = "Manchez",
            ["chino2"] = "Lowrider",
        },
    },  -- Add your next table under this comma
	["cartel"] = {
        ["VehicleSpawner"] = vector4(1421.28, -1505.19, 60.82, 179.87),
        ["colors"] = { 81, 0 }, ---  primary and secondary colors id https://wiki.rage.mp/index.php?title=Vehicle_Colors
        ["vehicles"] = {
            ["manchez"] = "Manchez",
            ["chino2"] = "Lowrider",
        },
    },  -- Add your next table under this comma
}
