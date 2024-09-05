
Customize = {}

Customize.Framework = "QBCore" -- ESX or QBCore or OLDQBCore

Customize.GetVehFuel = function(Veh)
    return GetVehicleFuelLevel(Veh)-- exports["LegacyFuel"]:GetFuel(Veh)
end

Customize.SetVehFuel = function(Veh, Fuel)
    return GetVehicleFuelLevel(Veh) -- exports['LegacyFuel']:SetFuel(Veh, data.Table.fuel)
end

Customize.Carkeys = function(Plate)
    TriggerEvent('vehiclekeys:client:SetOwner', Plate) --   qb-core
end

Customize.PriceType = 'cash' -- cash - bank
Customize.GaragesPrice = 100
Customize.ImpoundGaragesPrice = 600

Customize.Garages = {
    {
        Blips = {
            Position = vector3(213.56, -809.54, 31.01),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(213.56, -809.54, 31.01), Heading = 340.67 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(236.95, -783.71, 30.63, 179.64),
            location = { posX = 233.37, posY = -789.9, posZ = 30.6, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 50.0 },
        },
        VehPutPos = vector3(213.936, -792.53, 30.3523),
        VehSpawnPos = vector4(209.64, -791.39, 30.5, 248.63),
    },
    {
        Blips = {
            Position = vector3(274.07, -331.93, 44.92),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(275.44, -345.09, 45.17), Heading = 340.67 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(292.16, -332.99, 44.92, 159.89),
            location = { posX = 289.18, posY = -342.94, posZ = 44.92, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 38.0 },
        },
        VehPutPos = vector3(274.07, -331.93, 44.92),
        VehSpawnPos = vector4(292.16, -332.99, 44.92, 159.89),
    },
    {
        Blips = {
            Position = vector3(899.83, -57.79, 78.76),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(876.63, -81.5, 78.87), Heading = 340.67 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(884.6, -39.94, 78.76, 137.11),
            location = { posX = 880.51, posY = -47.78, posZ = 78.76, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 50.0 },
        },
        VehPutPos = vector3(899.83, -57.79, 78.76),
        VehSpawnPos = vector4(884.6, -39.94, 78.76, 137.11),
    },
    {
        Blips = {
            Position = vector3(-1145.56, -757.71, 18.87),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-1159.07, -740.27, 19.89), Heading = 135.67 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(-1129.24, -748.8, 19.7, 34.73),
            location = { posX = -1140.45, posY = -741.29, posZ = 20.01, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 25.0 },
        },
        VehPutPos = vector3(-1145.56, -757.71, 18.87),
        VehSpawnPos = vector4(-1182.46, -736.86, 20.23, 264.27),
    },
    {
        Blips = {
            Position = vector3(74.38, 14.33, 68.98),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(67.9, 12.97, 69.21), Heading = 340.67 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(60.2, 24.17, 69.69, 240.77),
            location = { posX = 69.23, posY = 21.95, posZ = 69.39, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 25.0 },
        },
        VehPutPos = vector3(74.38, 14.33, 68.98),
        VehSpawnPos = vector4(60.2, 24.17, 69.69, 240.77),
    },
    {
        Blips = {
            Position = vector3(-453.63, -802.92, 30.54),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-450.66, -793.89, 30.54), Heading = 110.67 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(-472.11, -777.92, 30.56, 170.17),
            location = { posX = -471.79, posY = -785.96, posZ = 30.55, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 33.0 },
        },
        VehPutPos = vector3(-453.63, -802.92, 30.54),
        VehSpawnPos = vector4(-472.11, -777.92, 30.56, 170.17),
    },
    {
        Blips = {
            Position = vector3(361.43, 282.71, 103.37),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(362.21, 298.37, 103.88), Heading = 260.00 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(369.36, 272.41, 103.11, 243.43),
            location = { posX = 378.67, posY = 269.13, posZ = 103.03, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 33.0 },
        },
        VehPutPos = vector3(361.43, 282.71, 103.37),
        VehSpawnPos = vector4(369.36, 272.41, 103.11, 243.43),
    },
    {
        Blips = {
            Position = vector3(-1191.73, -1493.21, 4.38),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-1183.93, -1509.68, 4.65), Heading = 40.00 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(-1186.13, -1472.49, 4.38, 210.1),
            location = { posX = -1177.42, posY = -1483.45, posZ = 4.38, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 50.0 },
        },
        VehPutPos = vector3(-1191.73, -1493.21, 4.38),
        VehSpawnPos = vector4(-1186.13, -1472.49, 4.38, 210.1),
    },
    {
        Blips = {
            Position = vector3(-771.35, -2037.52, 8.89),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-796.05, -2023.17, 9.17), Heading = 40.00 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(-753.01, -2017.93, 8.89, 114.33),
            location = { posX = -761.59, posY = -2025.54, posZ = 8.89, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 50.0 },
        },
        VehPutPos = vector3(-771.35, -2037.52, 8.89),
        VehSpawnPos = vector4(-753.01, -2017.93, 8.89, 114.33),
    },

-----------------------------------------------------------------------------------------------------------
    {
        Blips = {
            Position = vector3(1105.11, 2667.94, 38.03),
            Label = "Car",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(1105.6, 2659.18, 38.14), Heading = 260.00 },
        Type = 'car', --car, air, sea
        UIName = 'Public Parking',
        Camera = {
            vehSpawn = vector4(1121.17, 2659.89, 38.0, 52.75),
            location = { posX = 1114.87, posY = 2664.58, posZ = 38.01, rotX = 0.0, rotY = 0.0, rotZ = -32.0, fov = 33.0 },
        },
        VehPutPos = vector3(1105.11, 2667.94, 38.03),
        VehSpawnPos = vector4(1121.17, 2659.89, 38.0, 52.75),
    },
        /*{
        Blips = {
            Position = vector3(463.75, -982.43, 43.69),
            Label = "Air",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(463.75, -982.43, 43.69), Heading = 89.74 },
        Type = 'air', --car, air, sea
        UIName = 'Test Pilbox Hill',
        Camera = {
            vehSpawn = vector4(-75.3122, -818.490, 326.17, 201.5),
            location = { posX = -58.0, posY = -828.5, posZ = 335.17, rotX = -25.0, rotY = 0.0, rotZ = 60.2, fov = 40.0 },
        },
        VehPutPos = vector3(449.76, -981.27, 43.69),
        VehSpawnPos = vector4(449.85, -981.23, 43.69, 93.23),
    },*/
    /*{
        Blips = {
            Position = vector3(-869.43, -1491.55, 5.17),
            Label = "Sea",
            Sprite = 357,
            Display = 4,
            Scale = 0.5,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-869.43, -1491.55, 5.17), Heading = 112.87 },
        Type = 'sea', --car, air, sea
        UIName = 'Test Pilbox Hill',
        Camera = {
            vehSpawn = vector4(-855.5, -1484.77, -0.47, 111.13),
            location = { posX = -868.0, posY = -1495.0, posZ = 6.31, rotX = -25.0, rotY = 0.0, rotZ = -40.0, fov = 40.0 },
        },
        VehPutPos = vector3(-858.29, -1475.77, 0.5),
        VehSpawnPos = vector4(-799.54, -1502.98, -0.08, 114.38),
    },*/

}

function GetFramework() 
    local Get = nil
    if Customize.Framework == "ESX" then
        while Get == nil do
            TriggerEvent('esx:getSharedObject', function(Set) Get = Set end)
            Citizen.Wait(0)
        end
    end
    if Customize.Framework == "NewESX" then
        Get = exports['es_extended']:getSharedObject()
    end
    if Customize.Framework == "QBCore" then
        Get = exports["qb-core"]:GetCoreObject()
    end
    if Customize.Framework == "OLDQBCore" then
        while Get == nil do
            TriggerEvent('QBCore:GetObject', function(Set) Get = Set end)
            Citizen.Wait(200)
        end
    end
    return Get
end
