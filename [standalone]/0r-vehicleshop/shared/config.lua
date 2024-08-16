-- Configuration settings for the GPS system.
Config               = {}

-- Debug print setting for displaying debug messages.
Config.DebugPrint    = true

-- Locale setting for language localization.
Config.Locale        = "en"

-- ("esx" | "qb") -- > The latest version is always used.
Config.FrameWork     = "qb"

-- ("esx_notify" | "qb_notify" | "custom_notify") -- > System to be used
Config.NotifyType    = "qb_notify"

---("ox_inventory" | "qb_inventory" | "custom") System to be used
Config.InventoryType = "qb_inventory"

--[[
    -- QB | ESX
    ("owned_vehicles" | "player_vehicles")
    Database table name where player vehicles are save.
    It must be set to one of the two databases.
    Table columns will be written accordingly.
    Currently only 2 databases can be used.
    !!! "owned_vehicles" for ESX | "player_vehicles" for QB !!!
--]]
Config.PlayerVehiclesDB = "player_vehicles"

Config.Plate            = {
    -- Total number max 8, for ex: Letters = 6, Numbers = 2 => 6 + 2 = 8
    NumberOfLetters = 6,
    NumberOfNumbers = 2,
    Letters = {
        "A", "B", "C", "D", "E", "F",
        "G", "H", "I", "J", "K", "L",
        "M", "N", "O", "P", "Q", "R",
        "S", "T", "U", "V", "W", "X",
        "Y", "Z"
    }
}

Config.VehicleKeys      = {
    -- (true | false) -- Will keys be given after vehicle purchases?
    status = true,
    -- [
    -- If you are setting custom. Please review server/utils.lua and configure it accordingly.
    --]
    -- ("qb" | "custom") -- The key system depends on which plugin.
    system = "qb",
}

Config.Music            = {
    status = true,
    -- Volume: 0.1 - 1.0
    volume = 0.5,
    musics = {
        [1] = {
            -- file name: "public/music/x_music.mp3"
            fileName = "skyfall.mp3",
            name = "Skyfall - Adele",
            author = "Adele"
        },
    }
}

Config.VehicleClasses   = {
    [0] = "Compacts",
    [1] = "Sedans",
    [2] = "SUVs",
    [3] = "Coupes",
    [4] = "Muscle",
    [5] = "Sports Classics",
    [6] = "Sports",
    [7] = "Super",
    [8] = "Motorcycles",
    [9] = "Off-road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycles",
    [14] = "Boats",
    [15] = "Helicopters",
    [16] = "Planes",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Trains",
    [22] = "Open Wheel",
}

Config.Vehicles         = {
    ["compacts"] = {
        { label = "Blista",     name = "blista",     price = 2000,  coinPrice = 1000 },
        { label = "Brioso",     name = "brioso",     price = 62000, coinPrice = 1000 },
        { label = "Dilettante", name = "dilettante", price = 40000, coinPrice = 1000 },
        { label = "Issi S",     name = "issi2",      price = 38500, coinPrice = 1000 },
        { label = "Panto",      name = "panto",      price = 22000, coinPrice = 1000 },
        { label = "Prairie",    name = "prairie",    price = 60000, coinPrice = 1000 },
        { label = "Rhapsody",   name = "rhapsody",   price = 30000, coinPrice = 1000 },
    },
    ["coupes"] = {
        { label = "Cogcabrio", name = "cogcabrio", price = 40000 },
        { label = "Exemplar",  name = "exemplar",  price = 60000 },
        { label = "F620",      name = "f620",      price = 70000 },
        { label = "Felon",     name = "felon",     price = 70000 },
        { label = "Felon S",   name = "felon2",    price = 60000 },
        { label = "Jackal",    name = "jackal",    price = 92000 },
        { label = "Oracle S",  name = "oracle",    price = 82000 },
        { label = "Oracle",    name = "oracle2",   price = 87000 },
        { label = "sentinel",  name = "sentinel",  price = 100000 },
        { label = "Windsor",   name = "windsor",   price = 70000 },
        { label = "windsor S", name = "windsor2",  price = 70000 },
        { label = "zion",      name = "zion",      price = 75000 },
        { label = "zion S",    name = "zion2",     price = 80000 },
    },
    ["motorcycles"] = {
        { label = "Avarus",       name = "avarus",      price = 4700 },
        { label = "Bati",         name = "bati",        price = 50000 },
        { label = "Carbonr S",    name = "carbonrs",    price = 31200 },
        { label = "Cliff hanger", name = "cliffhanger", price = 7700 },
        { label = "Daemon",       name = "daemon",      price = 18100 },
        { label = "Defiler",      name = "defiler",     price = 5000 },
        { label = "Diablous S",   name = "Diablous2",   price = 50000 },
        { label = "Double",       name = "double",      price = 35000 },
        { label = "Ess key",      name = "esskey",      price = 14000 },
        { label = "Faggio S",     name = "faggio",      price = 5500 },
        { label = "FCR",          name = "fcr",         price = 13500 },
        { label = "FCR S",        name = "fcr2",        price = 19600 },
        { label = "Gargoyle",     name = "gargoyle",    price = 34000 },
        { label = "Hakuchou",     name = "hakuchou",    price = 60000 },
        { label = "Hexer",        name = "hexer",       price = 19500 },
        { label = "Innovation",   name = "innovation",  price = 32000 },
        { label = "Lectro",       name = "lectro",      price = 40000 },
        { label = "Nightblade",   name = "nightblade",  price = 25000 },
        { label = "PCJ",          name = "pcj",         price = 13500 },
        { label = "Ruffian",      name = "ruffian",     price = 10000 },
        { label = "Sanchez",      name = "sanchez2",    price = 15000 },
        { label = "Vader",        name = "vader",       price = 11700 },
        { label = "Vortex",       name = "vortex",      price = 13356 },
        { label = "Wolfsbane",    name = "wolfsbane",   price = 27000 },
    },
    ["muscle"] = {
        { label = "Blade",        name = "blade",      price = 1000 },
        { label = "Buccaneer",    name = "buccaneer",  price = 10000 },
        { label = "Chino",        name = "chino",      price = 15000 },
        { label = "Chino S",      name = "chino2",     price = 20000 },
        { label = "Coquette GM",  name = "coquette3",  price = 80000 },
        { label = "Dominator",    name = "dominator",  price = 55000 },
        { label = "Faction",      name = "faction",    price = 35000 },
        { label = "Gauntlet",     name = "gauntlet",   price = 40000 },
        { label = "Hermes",       name = "hermes",     price = 53000 },
        { label = "Hotknife",     name = "hotknife",   price = 50000 },
        { label = "Moon Beam",    name = "moonbeam",   price = 65000 },
        { label = "Night Shade",  name = "nightshade", price = 30300 },
        { label = "Picador",      name = "picador",    price = 15000 },
        { label = "Ratloader MS", name = "ratloader2", price = 18000 },
        { label = "Ruiner",       name = "ruiner",     price = 54000 },
        { label = "Sabre GT",     name = "sabregt",    price = 87000 },
        { label = "Slam Van",     name = "slamvan",    price = 80000 },
        { label = "stalion",      name = "stalion",    price = 42000 },
        { label = "Tampa GT",     name = "tampa",      price = 20000 },
        { label = "Vigero",       name = "vigero",     price = 78000 },
        { label = "Virgo",        name = "virgo",      price = 75000 },
        { label = "Voodoo",       name = "voodoo",     price = 70000 },
        { label = "Yosemite",     name = "yosemite",   price = 70000 },
    },
    ["offroad"] = {
        { label = "Bf Injection", name = "bfinjection", price = 15000 },
        { label = "Bifta",        name = "bifta",       price = 18000 },
        { label = "Brawler",      name = "brawler",     price = 30000 },
        { label = "Mesa OR",      name = "mesa3",       price = 45000 },
        { label = "Rancher XL",   name = "rancherxl",   price = 30000 },
        { label = "Rebel OR",     name = "rebel2",      price = 20000 },
    },
    ["sedans"] = {
        { label = "Asea",        name = "asea",        price = 3000 },
        { label = "Asterope",    name = "asterope",    price = 4000 },
        { label = "COG55",       name = "cog55",       price = 25000 },
        { label = "Cognoscenti", name = "cognoscenti", price = 30000 },
        { label = "Emperor",     name = "emperor",     price = 8000 },
        { label = "Fugitive",    name = "fugitive",    price = 35000 },
        { label = "Glendale",    name = "glendale",    price = 25000 },
        { label = "Ingot",       name = "ingot",       price = 45000 },
        { label = "Intruder",    name = "intruder",    price = 53000 },
        { label = "Premier",     name = "premier",     price = 35000 },
        { label = "Primo",       name = "primo",       price = 50000 },
        { label = "Regina",      name = "regina",      price = 22500 },
        { label = "Schafter SD", name = "schafter2",   price = 45000 },
        { label = "Stanier",     name = "stanier",     price = 40000 },
        { label = "Stratum",     name = "stratum",     price = 63000 },
        { label = "Stretch",     name = "stretch",     price = 100000 },
        { label = "Superd",      name = "superd",      price = 42000 },
        { label = "Surge",       name = "surge",       price = 30000 },
        { label = "Tailgater",   name = "tailgater",   price = 86000 },
        { label = "Warrener",    name = "warrener",    price = 35000 },
        { label = "Washington",  name = "washington",  price = 25000 },
    },
    ["sports"] = {
        { label = "Alpha",         name = "alpha",        price = 20000 },
        { label = "Banshee",       name = "banshee",      price = 35000 },
        { label = "Blista S",      name = "blista2",      price = 6000 },
        { label = "Blista GT",     name = "blista3",      price = 25000 },
        { label = "Buffalo",       name = "buffalo",      price = 68000 },
        { label = "Buffalo GT",    name = "buffalo3",     price = 70000 },
        { label = "Carboni",       name = "carbonizzare", price = 55500 },
        { label = "Comet SX",      name = "comet2",       price = 80000 },
        { label = "Coquette",      name = "coquette",     price = 45000 },
        { label = "Elegy",         name = "elegy",        price = 75000 },
        { label = "Elegy S",       name = "elegy2",       price = 78000 },
        { label = "Feltzer S",     name = "feltzer2",     price = 63100 },
        { label = "Furore GT",     name = "furoregt",     price = 50000 },
        { label = "Fusilade",      name = "fusilade",     price = 66000 },
        { label = "Futo",          name = "futo",         price = 75000 },
        { label = "Jester",        name = "jester",       price = 150000 },
        { label = "Khamelion",     name = "khamelion",    price = 83000 },
        { label = "Kuruma",        name = "kuruma",       price = 98000 },
        { label = "Lynx S",        name = "lynx2",        price = 57300 },
        { label = "Massacro",      name = "massacro",     price = 88000 },
        { label = "Neon",          name = "neon",         price = 170000 },
        { label = "Ninef",         name = "ninef",        price = 63000 },
        { label = "Pariah",        name = "pariah",       price = 72200 },
        { label = "Penumbra",      name = "penumbra",     price = 66500 },
        { label = "Raiden",        name = "raiden",       price = 68800 },
        { label = "Rapid GT",      name = "rapidgt",      price = 35000 },
        { label = "Rapidgt Turbo", name = "rapidgt2",     price = 82500 },
        { label = "Revolter",      name = "revolter",     price = 40000 },
        { label = "ruston",        name = "ruston",       price = 93200 },
        { label = "Schafter ST",   name = "schafter3",    price = 40000 },
        { label = "Schwarzer",     name = "schwarzer",    price = 65350 },
        { label = "Seven 70",      name = "seven70",      price = 93000 },
        { label = "Specter",       name = "specter",      price = 58750 },
        { label = "Streiter",      name = "streiter",     price = 100000 },
        { label = "Sultan",        name = "sultan",       price = 86642 },
        { label = "Surano",        name = "surano",       price = 71350 },
        { label = "Tampa ST",      name = "tampa2",       price = 43500 },
        { label = "Tropos",        name = "tropos",       price = 95000 },
        { label = "Verlierer ST",  name = "verlierer2",   price = 96000 },
    },
    ["sportsclassics"] = {
        { label = "Btype",       name = "btype",     price = 90000 },
        { label = "Btype SC",    name = "btype2",    price = 95000 },
        { label = "Btype S",     name = "btype3",    price = 99000 },
        { label = "Casco",       name = "casco",     price = 42000 },
        { label = "Coquette SC", name = "coquette2", price = 54000 },
        { label = "Feltzer SC",  name = "feltzer3",  price = 80000 },
        { label = "GT500",       name = "gt500",     price = 70000 },
        { label = "Infernus SC", name = "infernus2", price = 70000 },
        { label = "Mamba",       name = "mamba",     price = 40000 },
        { label = "Manana",      name = "manana",    price = 66000 },
        { label = "Monroe",      name = "monroe",    price = 84000 },
        { label = "Peyote",      name = "peyote",    price = 86500 },
        { label = "Pigalle",     name = "pigalle",   price = 20000 },
        { label = "Rapid GTSC",  name = "rapidgt3",  price = 38000 },
        { label = "Retinue",     name = "retinue",   price = 78000 },
        { label = "Savestra",    name = "savestra",  price = 85000 },
        { label = "Stinger",     name = "stinger",   price = 76000 },
        { label = "Stromberg",   name = "stromberg", price = 77000 },
        { label = "Turismo SC",  name = "turismo2",  price = 90000 },
        { label = "Viseris",     name = "viseris",   price = 100000 },
        { label = "Ztype",       name = "ztype",     price = 100000 },
    },
    ["super"] = {
        { label = "Adder",        name = "adder",      price = 120000 },
        { label = "Banshee 900R", name = "banshee2",   price = 60000 },
        { label = "Bullet",       name = "bullet",     price = 95000 },
        { label = "Cyclone",      name = "cyclone",    price = 127000 },
        { label = "drafter",      name = "drafter",    price = 500000 },
        { label = "Entity XF",    name = "entityxf",   price = 60000 },
        { label = "FMJ",          name = "fmj",        price = 150000 },
        { label = "GPL",          name = "gp1",        price = 127000 },
        { label = "Italigtb",     name = "italigtb",   price = 200000 },
        { label = "jugular",      name = "jugular",    price = 500000 },
        { label = "LE7B",         name = "le7b",       price = 85000 },
        { label = "Nero",         name = "nero",       price = 220000 },
        { label = "Osiris",       name = "osiris",     price = 100000 },
        { label = "Penetrator",   name = "penetrator", price = 69999 },
        { label = "Pfister",      name = "pfister811", price = 130000 },
        { label = "Prototipo",    name = "prototipo",  price = 125000 },
        { label = "Reaper",       name = "reaper",     price = 167000 },
        { label = "SCL",          name = "sc1",        price = 100000 },
        { label = "Sheava",       name = "sheava",     price = 147000 },
        { label = "sultanrs",     name = "sultanrs",   price = 95000 },
        { label = "T20",          name = "t20",        price = 250000 },
        { label = "Tempesta",     name = "tempesta",   price = 127000 },
        { label = "Turismor",     name = "turismor",   price = 127000 },
        { label = "Tyrus",        name = "tyrus",      price = 135000 },
        { label = "Vagner",       name = "vagner",     price = 127000 },
        { label = "Visione",      name = "visione",    price = 130000 },
        { label = "Voltic",       name = "voltic",     price = 127000 },
        { label = "XA21",         name = "xa21",       price = 150000 },
        { label = "Zentorno",     name = "zentorno",   price = 325000 },
    },
    ["suvs"] = {
        { label = "Baller",       name = "baller",      price = 40000 },
        { label = "Baller Super", name = "baller4",     price = 50000 },
        { label = "BJXL",         name = "bjxl",        price = 50000 },
        { label = "Cavalcade",    name = "cavalcade",   price = 92000 },
        { label = "Contender",    name = "contender",   price = 70000 },
        { label = "Dubsta",       name = "dubsta",      price = 95000 },
        { label = "FQ2",          name = "fq2",         price = 63000 },
        { label = "Granger",      name = "granger",     price = 50000 },
        { label = "Gresley",      name = "gresley",     price = 70000 },
        { label = "Habanero",     name = "habanero",    price = 62000 },
        { label = "Huntley",      name = "huntley",     price = 100000 },
        { label = "Lands Talker", name = "landstalker", price = 85000 },
        { label = "Mesa S",       name = "mesa",        price = 60000 },
        { label = "Patriot",      name = "patriot",     price = 70000 },
        { label = "Radi",         name = "radi",        price = 74000 },
        { label = "Rocoto",       name = "rocoto",      price = 60000 },
        { label = "Sadler",       name = "sadler",      price = 100000 },
        { label = "Seminole",     name = "seminole",    price = 97000 },
        { label = "Serrano",      name = "serrano",     price = 78000 },
        { label = "XLS",          name = "xls",         price = 70000 },
    },
    ["vans"] = {
        { label = "Bobcatxl", name = "bobcatxl", price = 50000 },
        { label = "Camper",   name = "camper",   price = 60000 },
        { label = "Journey",  name = "journey",  price = 80000 },
        { label = "Minivan",  name = "minivan",  price = 70000 },
        { label = "Minivan2", name = "minivan2", price = 50000 },
        { label = "Rumpo VN", name = "rumpo3",   price = 65000 },
        { label = "Speedo",   name = "speedo",   price = 100000 },
        { label = "Youga",    name = "Youga",    price = 24000 },
        { label = "Youga VN", name = "youga2",   price = 20000 },
    },
}

Config.Shops            = {
    {
        name                 = "Concesionario",
        vehicles             = Config.Vehicles,
        type                 = "car", -- > car | boat | helicopter
        job                  = false, -- > false or job name
        isMoneyAnItem        = {
            status = false,
            -- Item name if status is true
            item = "money"
        },
        buyWithBlackMoney    = {
            active = false,
            -- Item name if active is true
            item = "blackmoney",
            -- Calculated x times the normal vehicle price
            multiplier = 1.5
        },
        buyWithCoin          = {
            active = false,
            item = "excoin"
        },
        vehiclesBeRented     = {
            active = true,
            --[[
                Value percentage calculates the daily rate of the vehicle price,
                for ex: X Vehicle Price = 100.000, Percentage = 10% -> Daily Fee = 10.000
            --]]
            percentageOfRentalFee = 10,
        },
        customPlate          = {
            active = false,
            price = 2000
        },
        coords               = vector3(-56.403923797607, -1096.7048095703, 25.5),
        camCoords            = vector3(-47.7892, -1093.5864, 26.4224),
        camRotation          = vector3(190.0, 180.0, 5.00),
        distance             = 2.0,
        carSpawnCoords       = vector4(-45.7515, -1100.3845, 26.4224, 7.5665),
        deliveryCoords       = vector4(-48.906772613525, -1077.6535644531, 26.81402015686, 66.28524017334),
        deliveryGarage       = "pillboxgarage", -- if u need, the QB Framework player_vehicles table needs it.
        compareCoords        = {
            selectedVehicleCoords = vector4(-35.5, -1064.109863, -44.359741, 0.0),
            selectedCam = {
                coords = vector3(-47.7892, -1093.5864, 26.4224),
                rotation = vector3(190.0, 180.0, 5.00),
            },
            comparedVehicleCoords = vector4(-45.758240, -1055.221924, -44.359741, 270.0),
            -- The coordinate we set to center the vehicle a little more when the vehicle properties panel is closed !
            nosm_com_veh_coords = vector4(-45.758240, -1054.221924, -44.359741, 270.0),
            comparedCam = {
                coords = vector3(-40.5, -1053.0, -42.5),
                rotation = vector3(190.0, 180.0, -85.00),
            },
        },
        playerTeleportCoords = vector4(-37.64443000, -1054.39700000, -44.4, 270.0), -- Player hold coordinates
        testDrive            = {
            active      = true,                                                     -- if you want to allow a test drive
            seconds     = 30,
            startCoords = vector4(-58.7214, -1108.7333, 25.9793, 73.1715),
            range       = 10000,
        },
        discount             = {
            active = true,
            -- Makes a certain percentage discount on existing prices (1-100)
            percentage = 10
        },
        textType = "ox", -- > "drawtext" | "ox" | "qb"
    },
}