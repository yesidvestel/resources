Config = {}
Config.RequireJob = true                       -- do you need a mech job to use parts?
Config.FuelResource = 'LegacyFuel'             -- supports any that has a GetFuel() and SetFuel() export

Config.PaintTime = 5                           -- how long it takes to paint a vehicle in seconds
Config.ColorFavorites = false                  -- add your own colors to the favorites menu (see bottom of const.lua)

Config.NitrousBoost = 1.8                      -- how much boost nitrous gives (want this above 1.0)
Config.NitrousUsage = 0.1                      -- how much nitrous is used per frame while holding key

Config.UseDistance = true                      -- enable/disable saving vehicle distance
Config.UseDistanceDamage = true                -- damage vehicle engine health based on vehicle distance
Config.UseWearableParts = true                 -- enable/disable wearable parts
Config.WearablePartsChance = 1                 -- chance of wearable parts being damaged while driving if enabled
Config.WearablePartsDamage = math.random(1, 2) -- how much wearable parts are damaged when damaged if enabled
Config.DamageThreshold = 25                    -- how worn a part needs to be or below to apply an effect if enabled
Config.WarningThreshold = 50                   -- how worn a part needs to be to show a warning color in toolbox if enabled

Config.MinimalMetersForDamage = {              -- unused if Config.UseDistanceDamage is false
    { min = 5000,  max = 10000, damage = 10 },
    { min = 15000, max = 20000, damage = 20 },
    { min = 25000, max = 30000, damage = 30 },
}

Config.WearableParts = { -- unused if Config.UseWearableParts is false (feel free to add/remove parts)
    radiator = { label = Lang:t('menu.radiator_repair'), maxValue = 100, repair = { steel = 2 } },
    axle = { label = Lang:t('menu.axle_repair'), maxValue = 100, repair = { aluminum = 2 } },
    brakes = { label = Lang:t('menu.brakes_repair'), maxValue = 100, repair = { copper = 2 } },
    clutch = { label = Lang:t('menu.clutch_repair'), maxValue = 100, repair = { copper = 2 } },
    fuel = { label = Lang:t('menu.fuel_repair'), maxValue = 100, repair = { plastic = 2 } },
}

Config.Shops = {
    mechanic = { -- City location
        managed = true,
        shopLabel = 'LS Customs',
        showBlip = true,
        blipSprite = 72,
        blipColor = 46,
        blipCoords = vector3(-1144.7, -1721.13, 4.9),
        shop = vector3(-343.66, -140.78, 39.02), -- Tienda mecanico
        duty = vector3(-348.18, -134.55, 39.59),  --Entrar y salir de servicio
        stash = vector3(-346.02, -130.68, 39.02), -- Almacenamiento
        paint = vector3(-324.11, -147.11, 39.10), -- Pintar carros
        vehicles = {
            withdraw = vector3(-369.30, -104.75, 38.38),
            spawn = vector4(-369.65, -107.8, 38.65, 70.52),
            list = { 'flatbed', 'towtruck', 'minivan', 'blista' }
        },
        shopItems = {
            { name = 'veh_toolbox',       price = 75, amount = 50 },
            { name = 'veh_armor',         price = 75, amount = 50 },
            { name = 'veh_brakes',        price = 75, amount = 50 },
            { name = 'veh_engine',        price = 75, amount = 50 },
            { name = 'veh_suspension',    price = 75, amount = 50 },
            { name = 'veh_transmission',  price = 75, amount = 50 },
            { name = 'veh_turbo',         price = 75, amount = 50 },
            { name = 'veh_interior',      price = 75, amount = 50 },
            { name = 'veh_exterior',      price = 75, amount = 50 },
            { name = 'veh_wheels',        price = 75, amount = 50 },
            { name = 'veh_neons',         price = 75, amount = 50 },
            { name = 'veh_xenons',        price = 75, amount = 50 },
            { name = 'veh_tint',          price = 75, amount = 50 },
            { name = 'veh_plates',        price = 75, amount = 50 },
            { name = 'nitrous',           price = 500, amount = 50 },
           -- { name = 'tunerlaptop',       price = 500, amount = 50 },
            { name = 'repairkit',         price = 75, amount = 50 },
            { name = 'advancedrepairkit', price = 75, amount = 50 },
            { name = 'tirerepairkit',     price = 75, amount = 50 },
        }
    },
}
