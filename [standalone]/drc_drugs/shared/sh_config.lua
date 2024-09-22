Config = {}

Config.Debug = false
--SERVER SETTINGS
Config.Framework = "qbcore" -- Set your framework! qbcore, ESX, standalone
Config.NewESX = false -- if you use esx 1.1 version set this to false
Config.InteractionType = "textui" -- target or textui or 3dtext | which type of interaction you want
Config.Target = "qb-target" -- Which Target system do u use? qb-target, qtarget
Config.Dispatch = { enabled = true, script = "ps-disptach" } -- cd_dispatch, linden_outlawalert, ps-disptach
Config.Bob74_ipl = true -- Loads lab interiors
Config.PoliceJobs = { 'police', 'sheriff' }
Config.NotificationType = "ox_lib" -- Notifications | types: ESX, ox_lib, qbcore
Config.Progress = "ox_lib" -- ProgressBar | types: progressBars, ox_lib, qbcore
Config.Clothing = "illenium-appearance" -- fivem-appearance, esx_skin, qb-clothing, custom | change in client/cl_Utils.lua | GetSkin = function() | ApplySkin = function()
Config.TextUI = "ox_lib" -- TextUIs | types: esx, ox_lib, luke
Config.Input = "qb-input" -- Input | types: ox_lib, qb-input
Config.Context = "qbcore" -- Context | types: ox_lib, qbcore
Config.SellingMoneyType = "cash" -- Selling Money Type | ESX types: bank, money, black_money or own types | QBCORE types: cash, bank, crypto or own types
--PLAYER CONTROL
Config.Logs = { enabled = true, type = "ox_lib" } -- use webhook or ox_lib (datadog) Can be changed in server > sv_utils.lua
Config.DropPlayer = true -- Drop (Kick) Player if tries to cheat!
Config.AnticheatBan = false -- Change in server/sv_Utils.lua!!! WIll not work by default you need to add your custom trigger to ban player!

--BLIPS
Config.Blips = {
    FlowerShop = { -- do not use same value twice (will result in overwriting of blip)
        BlipCoords = vec3(307.91, -1286.48, 29.53), -- Blip coords
        Sprite = 40, -- Blip Icon
        Display = 4, -- keep 4
        Scale = 0.5, -- Size of blip
        Colour = 69, -- colour
        Name = "Flower Shop" -- Blip name
    },
    ComicShop = {
        BlipCoords = vec3(-143.52, 229.53, 93.94),
        Sprite = 280,
        Display = 4,
        Scale = 0.5,
        Colour = 50,
        Name = "Comic Shop"
    },
}

--Madrazo Trade
Config.Madrazo = {
    enabled = true,
    Header = "Madrazo",
    Title = "Buy Meth Lab access",
    Description = "Trade 5 full Figures for Lab access!",
    Available = { -- Time
        enabled = false, from = 1, to = 22
    },
    RequiredItems = {
        { item = "coke_figure", count = 5, remove = true },
    },
    AddItems = {
        { item = "meth_access", count = 1 },
    },
    Location = {
        Coords = vec3(-1032.44, 686.0, 161.45),
        Heading = 270.7,
        radius = 0.7,
    },
    Log = "Has Traded 5x coke figure for 1 Meth Access Card"
}

--Gerald Trade
Config.Gerald = {
    enabled = true,
    Header = "Gerald",
    Title = "Buy Coke Lab access",
    Description = "Trade 20 packages of weed for 1 Coke Lab with Gerald!",
    Available = { -- Time
        enabled = false, from = 3, to = 10
    },
    RequiredItems = {
        { item = "weed_package", count = 20, remove = true },
    },
    AddItems = {
        { item = "coke_access", count = 1 },
    },
    Location = {
        Coords = vec3(-58.91, -1530.98, 34.5),
        Heading = 229.64,
        radius = 0.7,
    },
    Log = "Has Traded 20x Weed Package for 1 Coke Access Card"
}

--Locate Dealer
Config.LocateDealer = {
    enabled = true,
    RequiredItems = {
        --{ item = "hack_usb", count = 1, remove = true }, -- Add you hacking usb item from your server or just create one!
    },
    DealerPos = { -- Location of dealers
        vec2(-1301.67, -776.34),
        vec2(819.61, -2348.83),
    },
    Location = { --Target
        Coords = vector3(-1055.31, -243.29, 44.05),
        radius = 0.4,
    },
}

--Pharmacist
Config.Pharmacist = {
    enabled = true,
    Header = "Pharmacist",
    Available = { -- Time
        enabled = false, from = 18, to = 23
    },
    Items = {
        { label = 'Empty Plastic Can', item = 'meth_emptysacid', description = "Buy Empty Plastic Can for: $",
            price = 2500, MinAmount = 1, MaxAmount = 1 },
        { label = 'Amonian', item = 'meth_amoniak', description = "Buy Amoniak for: $", price = 800, MinAmount = 1,
            MaxAmount = 5 },
        { label = 'Syringe', item = 'syringe', description = "Buy Syringe for: $", price = 100, MinAmount = 1,
            MaxAmount = 1 },
        { label = 'Meth Pipe', item = 'meth_pipe', description = "Buy Meth Pipe for: $", price = 100, MinAmount = 1,
            MaxAmount = 1 },
        { label = 'Crack Pipe', item = 'crack_pipe', description = "Buy Crack Pipe for: $", price = 160, MinAmount = 1,
            MaxAmount = 1 },
    },

    Ped = {
        { model = "s_m_m_doctor_01", coords = vec4(75.76, -1622.35, 30.9 - 1.0, 236.13), scenario = "WORLD_HUMAN_SMOKING" },
    },
}

--Dealer
Config.Dealer = {
    enabled = true,
    Header = "Weed Dealer",
    Items = {
        { label = 'Weed Access Card', item = 'weed_access', description = "Buy Weed Access for: $", price = 5000,
            MinAmount = 1, MaxAmount = 1 },
        { label = 'Weed Papers', item = 'weed_papers', description = "Buy Weed Papers for: $", price = 100, MinAmount = 1,
            MaxAmount = 5 },
        { label = 'Blunt Wraps', item = 'weed_wrap', description = "Buy Blunt wraps for: $", price = 200, MinAmount = 1,
            MaxAmount = 5 },
        { label = 'Plastic Bag', item = 'plastic_bag', description = "Buy Plastic Bag for: $", price = 100, MinAmount = 1,
            MaxAmount = 10 },
    },
    Ped = {
        { model = "s_m_y_dealer_01", coords = vec4(-1301.67, -776.34, 18.47, 202.49), scenario = "WORLD_HUMAN_SMOKING" },
    },
}

--Medicament dealer
Config.MedicamentsShop = {
    enabled = true,
    Header = "Medicament Dealer",
    Items = {
        { label = 'LSD', item = 'lsd', description = "Buy LSD for: $", price = 100, MinAmount = 1, MaxAmount = 2 },
        { label = 'Xanax', item = 'xanaxpack', description = "Buy Xanax for: $", price = 1500, MinAmount = 1,
            MaxAmount = 2 },
        { label = 'Ecstasy', item = 'ecstasy', description = "Buy Ecstasy for: $", price = 200, MinAmount = 1,
            MaxAmount = 2 },
    },
    Ped = {
        { model = "s_m_y_dealer_01", coords = vec4(819.61, -2348.83, 29.33, 261.57), scenario = "WORLD_HUMAN_SMOKING" },
    },
}

--ComicShop
Config.ComicShop = {
    enabled = true,
    Header = "Comic Shop",
    Items = {
        { label = 'Action Figure', item = 'coke_figureempty', description = "Buy Action Figure for: $", price = 240,
            MinAmount = 1, MaxAmount = 2 },
    },
    Ped = {
        { model = "u_m_y_imporage", coords = vec4(-143.52, 229.53, 93.94, 1.4), scenario = "WORLD_HUMAN_MUSCLE_FLEX" },
    },
    Log = "Has bought Item %s, Count %s"
}

--Flowershop
Config.FlowerShop = {
    enabled = true,
    Header = "Flower Shop",
    Items = {
        { label = 'Hammer', item = 'hammer', description = "Buy Hammer for: $", price = 700, MinAmount = 1, MaxAmount = 2 },
        { label = 'Trowel', item = 'trowel', description = "Buy Trowel for: $", price = 800, MinAmount = 1, MaxAmount = 2 },
        { label = 'Scissors', item = 'scissors', description = "Buy Scissors for: $", price = 500, MinAmount = 1,
            MaxAmount = 2 },
        { label = 'Glue', item = 'glue', description = "Buy Glue for: $", price = 100, MinAmount = 1, MaxAmount = 2 },
        { label = 'Baking Soda', item = 'baking_soda', description = "Buy Baking Soda for: $", price = 100, MinAmount = 1,
            MaxAmount = 2 },
    },
    Ped = {
        { model = "s_m_m_gardener_01", coords = vec4(307.91, -1286.48, 29.53, 165.26), scenario = "WORLD_HUMAN_SMOKING" },
    },
}

--Weed
Config.Weed = {
    --LABORATORY
    ElectricityNeeded = true,
    --Lab circlezone
    Lab = {
        coords = vector3(1054.33, -3196.17, -39.17),
        radius = 23.85,
        DebugPoly = false,
        name = "WeedLab",
    },
    --Air Conditioner
    AC = {
        coords = vector3(1045.32, -3194.84, -38.33),
        radius = 0.4,
    },
    --Mini game
    Minigame = { -- Select only one option
        Memorygame = false,
        oxlib = false
    },
    --ENTER LAB
    Enterlab = {
        coords = vector3(2855.56, 4447.03, 48.88),
        radius = 1.2,
        teleport = vector3(1066.12, -3183.43, -40.16),
        NeedItem = true,
        ItemName = "weed_access"
    },
    --LEAVE LAB
    LeaveLab = {
        coords = vector3(1066.57, -3183.46, -38.96), radius = 1.0, teleport = vector3(2855.99, 4445.97, 47.54),
    },
    --Collecting weed
    Pickup = {
        Models = { [`bkr_prop_weed_lrg_01a`] = true, [`bkr_prop_weed_lrg_01b`] = true },
        RequiredItems = {
            { item = "scissors", count = 1, remove = false },
        },
        AddItems = {
            { item = "weed_bud", count = 1 },
        },
        Log = "Has Picked up Weed bud With leaves"
    },
    --Clean
    Clean = {
        header = "Clean Weed",
        description = "Ingredients: 1x Weed bud with leaves",
        coords = vector3(1038.67, -3205.93, -38.3),
        radius = 0.8,
        teleport = vector3(1039.3 - 0.8, -3205.95, -37.69 - 1.4),
        heading = 90.0,
        leave = vector3(1039.28, -3205.38, -39.17),
        RequiredItems = {
            { item = "weed_bud", count = 1, remove = true },
        },
        AddItems = {
            { item = "weed_budclean", count = 1 },
        },
        Log = "Has proccessed 1x Weed bud with leaves into 1x Weed bud"
    },
    --Package
    Package = {
        header = "Pack Weed",
        description = "Ingredients: 5x Weed bud, 1x Plastic bag",
        coords = vector3(1036.35, -3203.13, -38.24),
        radius = 0.8,
        RequiredItems = {
            { item = "weed_budclean", count = 5, remove = true },
            { item = "plastic_bag", count = 1, remove = true },
        },
        AddItems = {
            { item = "weed_package", count = 1 },
        },
        Log = "Has proccessed 5x Weed bud, 1x Plastic bag into 1x Weed Packed"
    },
}

--Meth
Config.Meth = {
    --LABORATORY
    ElectricityNeeded = true,
    --Electricity
    Electricity = {
        coords = vector3(998.33, -3202.35, -38.48), radius = 0.7,
    },
    --Mini game
    Minigame = { -- Select only one option
        Memorygame = true,
        oxlib = false
    },
    --Lab circlezone
    Lab = {
        coords = vector3(1013.22, -3194.95, -37.88),
        radius = 18.85,
        DebugPoly = false,
        name = "MethLab",
    },
    --ENTER LAB
    Enterlab = {
        coords = vector3(762.93, -1092.78, 22.58),
        radius = 1.6,
        teleport = vector3(996.99, -3200.7, -37.39),
        NeedItem = true,
        ItemName = "meth_access"
    },
    --LEAVE LAB
    LeaveLab = {
        coords = vector3(996.49, -3200.62, -36.32),
        radius = 1.0,
        teleport = vector3(763.09, -1092.92, 21.22),
    },
    --GET ACID
    GetSacid = {
        coords = vector3(2718.76, 1558.05, 21.4),
        radius = 1.0,
        teleport = vector3(2718.82, 1558.8, 19.82),
        RequiredItems = {
            { item = "meth_emptysacid", count = 1, remove = true },
        },
        AddItems = {
            { item = "meth_sacid", count = 1 },
        },
        Log = "Has refill his Can with Sodium Benzoate"
    },
    --HEAT
    Heat = {
        coords = vector3(1001.97, -3198.86, -38.53),
        radius = 0.4,
        teleport = vector3(1002.38, -3198.91, -39.99),
        heading = 82.52,
    },
    --Pouring
    Pouring = {
        header = "Start Cooking",
        description = "Ingredients: 1x Amoniak, 1x Sodium benzoate",
        coords = vector3(1005.76, -3200.91, -38.1),
        radius = 0.6,
        teleport = vector3(1005.71, -3200.39, -38.51),
        heading = 180.0,
        -- Items are in Complete
    },
    --Complete
    Complete = {
        coords = vector3(1007.84, -3201.51, -38.53),
        radius = 0.5,
        teleport = vector3(1007.89, -3201.09, -39.99),
        heading = 188.27,
        RequiredItems = {
            { item = "meth_amoniak", count = 1, remove = true },
            { item = "meth_sacid", count = 1, remove = true },
        },
        AddItems = {
            { item = "meth_glass", count = 1 },
            { item = "meth_emptysacid", count = 1 },
        },
        Log = "Has proccessed 1x Amoniak, 1x Sodium benzoate into 1x Meth tray"
    },
    --Break
    Break = {
        header = "Break Meth",
        description = "Ingredients: 1x Meth tray, 1x Hammer",
        coords = vector3(1016.47, -3194.15, -39.01),
        radius = 0.5,
        teleport = vector3(1016.70 - 3.6, -3195.64 - 1.0, -38.99 - 1.0),
        heading = 180.0,
        RequiredItems = {
            { item = "meth_glass", count = 1, remove = true },
            { item = "hammer", count = 1, remove = false },
        },
        AddItems = {
            { item = "meth_sharp", count = 1 },
        },
        Log = "Has proccessed 1x Meth tray, 1x Hammer into 1x Broken Meth tray"
    },
    --Package
    Package = {
        header = "Pack Meth",
        description = "Ingredients: 1x Broken Meth tray, 1x Plastic bag",
        coords = vector3(1011.28, -3194.15, -39.04),
        radius = 0.5,
        teleport = vector3(1012.24, -3196.25, -38.99),
        heading = 180.0,
        RequiredItems = {
            { item = "meth_sharp", count = 1, remove = true },
            { item = "plastic_bag", count = 1, remove = true },
        },
        AddItems = {
            { item = "meth_bag", count = 1 },
        },
        Log = "Has proccessed 1x Broken Meth tray, 1x Plastic bag into 1x Meth bag"

    },
}

--Heroin
Config.Heroin = {
    --Field
    Field = {
        coords = vec3(4123.8, 4499.54, 17.55),
        radius = 20.85,
        Duration = 10000,
        name = "PoppyField",
        debugPoly = false,
        RequiredItems = {
            { item = "trowel", count = 1, remove = false },
        },
        AddItems = {
            { item = "poppyplant", count = 1 },
        },
        prop = `prop_plant_01b`, -- DO NOT CHANGE THIS UNLESS YOU KNOW WHAT YOU ARE
        Log = "Has picked up 1x Poppy Plant"
    },
    --Process
    Process = {
        header = "Process Poppy plants",
        description = "Ingredients: 3x Poppy plant, 1x Amoniak, 1x Plastic bag",
        coords = vector3(1391.41, 3605.55, 39.07),
        radius = 0.4,
        Teleport = vector3(1391.87, 3605.64, 37.94),
        Duration = 30000,
        RequiredItems = {
            { item = "poppyplant", count = 3, remove = true },
            { item = "meth_amoniak", count = 1, remove = true },
            { item = "plastic_bag", count = 1, remove = true },
        },
        AddItems = {
            { item = "heroin", count = 1 },
        },
        Log = "Has proccessed 3x Poppy plant, 1x Amoniak, 1x Plastic bag into 1x heroin"
    },
}

--Crack
Config.Crack = {
    --Process
    Process = {
        header = "Make Crack",
        description = "Ingredients: 2x Pure Coke, 1x Baking Soda, 1x Water Bottle",
        coords = vector3(2431.04, 4971.46, 42.28),
        radius = 0.4,
        Teleport = vector3(2431.47, 4970.94, 41.35),
        Duration = 60000,
        RequiredItems = {
            { item = "coke_pure", count = 2, remove = true },
            { item = "baking_soda", count = 1, remove = true },
            { item = "water", count = 1, remove = true },
        },
        AddItems = {
            { item = "crack", count = 1 },
        },
        Log = "Has proccessed 2x Pure Coke, 1x Baking Soda, Water Bottle into 1X Crack"
    },
}

--Coke
Config.Coke = {
    --LABORATORY
    ElectricityNeeded = false,
    --Lab circlezone
    Electricity = {
        coords = vector3(1091.5, -3191.67, -39.7),
        radius = 0.4
    },
    --Mini game
    Minigame = { -- Select only one option
        Memorygame = true,
        oxlib = false
    },
    --Lab Circlezone
    Lab = {
        coords = vector3(1092.68, -3194.89, -38.99),
        radius = 18.85,
        DebugPoly = false,
        name = "CokeLab",
    },
    --ENTER LAB
    Enterlab = {
        coords = vector3(1242.16, -3113.78, 6.01),
        radius = 1.2,
        teleport = vector3(1088.76, -3187.68, -39.99),
        NeedItem = true,
        ItemName = "coke_access"
    },
    --LEAVE LAB
    LeaveLab = {
        coords = vector3(1088.66, -3187.51, -38.83),
        radius = 0.8,
        teleport = vector3(1242.16, -3113.78, 6.01),
    },
    --Field
    Field = {
        coords = vector3(2526.91, 4358.54, 40.09),
        radius = 40.0,
        DebugPoly = false,
        name = "Cokefield",
        prop = `prop_plant_01a`, -- DO NOT CHANGE THIS UNLESS YOU KNOW WHAT YOU ARE
        RequiredItems = {
            { item = "trowel", count = 1, remove = false },
        },
        AddItems = {
            { item = "coke_leaf", count = 1 },
        },
        Log = "Has Picked up Coke Leaf"
    },
    --LeafProcess
    LeafProcess = {
        header = "Process Coke leaves",
        description = "Ingredients: 2x Coke Leaves", coords = vector3(1101.8, -3193.06, -38.98), radius = 0.4,
        boxcoords = vector4(1101.81, -3193.14, -39.18, 90),
        RequiredItems = {
            { item = "coke_leaf", count = 2, remove = true },
        },
        AddItems = {
            { item = "coke_box", count = 1 },
        },
        Log = "Has proccessed 2x Coke Leaves into 1X Coke Box"
    },
    --CokeBox
    CokeBox = {
        header = "Pour Coke",
        description = "Ingredients: 1x Box with Coke",
        coords = vector3(1086.8, -3195.31, -39.15), radius = 0.4, teleport = vector3(1087.31, -3196.04, -38.99),
        heading = 0.0,
        RequiredItems = {
            { item = "coke_box", count = 1, remove = true },
        },
        AddItems = {
            { item = "coke_raw", count = 3 },
        },
        Log = "Has proccessed 1x Coke Box into 3x Raw Coke"
    },
    --Coke Cleaning
    Soda = {
        header = "Clean Coke",
        description = "Ingredients: 2x Raw Coke",
        RequiredItems = {
            { item = "coke_raw", count = 2, remove = true },
        },
        AddItems = {
            { item = "coke_pure", count = 1 },
        },
        Log = "Has proccessed 2x Raw Coke into 1x Pure Coke"
    },
    SodaTables = {
        -- use only headingtotable 0.0 or 180.0 | 270 and 90 dont work
        { coords = vector3(1095.39, -3196.3, -39.15), radius = 0.4, DebugPoly = false, headingtotable = 0.0 },
        { coords = vector3(1093.04, -3196.36, -39.15), radius = 0.4, DebugPoly = false, headingtotable = 0.0 },
        { coords = vector3(1090.33, -3196.2, -39.15), radius = 0.4, DebugPoly = false, headingtotable = 0.0 },
        { coords = vector3(1095.36, -3195.34, -39.15), radius = 0.4, DebugPoly = false, headingtotable = 180.0 },
        { coords = vector3(1093.09, -3195.33, -39.15), radius = 0.4, DebugPoly = false, headingtotable = 180.0 },
        { coords = vector3(1090.28, -3195.3, -39.15), radius = 0.4, DebugPoly = false, headingtotable = 180.0 },
    },
    --Packaging
    FigurePackage = {
        header = "Pack Coke",
        description = "Ingredients: 1x Empty Action figure, 5x Pure Coke",
        coords = vector3(1100.43, -3199.39, -39.26), radius = 0.5,
        teleport = vector3(1100.62 - 7.0, -3198.83 + 2.2, -38.99 - 1.0), heading = 180.0,
        RequiredItems = {
            { item = "coke_pure", count = 5, remove = true },
            { item = "coke_figureempty", count = 1, remove = true },
        },
        AddItems = {
            { item = "coke_figure", count = 1 },
        },
        Log = "Has proccessed 1x Empty Action figure, 5x Pure Coke into 1x Coke Figure"
    },
}

--Mushrooms
Config.MushroomsField = {
    --Field!
    coords = vec3(-582.9, 5834.17, 30.61),
    radius = 18.85,
    name = "MushroomsField",
    debugPoly = false,
    prop = `prop_stoneshroom2`, -- DO NOT CHANGE THIS UNLESS YOU KNOW WHAT YOU ARE DOING
    RequiredItems = {
        { item = "trowel", count = 1, remove = false },
    },
    AddItems = {
        { item = "magicmushroom", count = 1 },
    },
    Log = "Has picked up Mushroom"
}

--Peyote
Config.PeyoteField = {
    --Field!
    coords = vec3(318.78, 4319.8, 48.09),
    radius = 38.85,
    name = "PeyoteField",
    debugPoly = false,
    RequiredItems = {
        { item = "trowel", count = 1, remove = false },
    },
    AddItems = {
        { item = "peyote", count = 1 },
    },
    prop = `prop_peyote_highland_01`, -- DO NOT CHANGE THIS UNLESS YOU KNOW WHAT YOU ARE DOING
    Log = "Has picked up Peyote"
}

--Selling
Config.PhoneBooths = { -- use hash
    -429560270,
    -1559354806,
    -78626473,
    295857659,
    -2103798695,
    1158960338,
    1511539537,
    1281992692
}

Config.Drugs = {
    weed_package = { -- Item name
        Label = "Weed", -- Item label
        ReqPolice = 0, -- Police count
        ReportChance = 5, --Dispatch Chance 0 - 100 %
        MinPrice = 25, -- Min price
        MaxPrice = 55, -- Max price
        MinCount = 1, -- Min Count
        MaxCount = 5, -- Max Count
        Chance = 100, -- 0 - 100% succes of negotiate for better price
        AttackChance = 5, -- 0 - 100% Chance of NPC atacking player
        animation = {
            model = `bkr_prop_weed_bag_01a`,
            pos = vec3(0.16, 0.04, -0.05),
            rot = vec3(0.0, 26.0, 100.0),
            bone = 57005
        }
    },
    meth_bag = { -- Item name
        Label = "Meth", -- Item label
        ReqPolice = 0, -- Police count
        ReportChance = 5, --Dispatch Chance 0 - 100 %
        MinPrice = 25, -- Min price
        MaxPrice = 55, -- Max price
        MinCount = 1, -- Min Count
        MaxCount = 5, -- Max Count
        Chance = 80, -- 0 - 100% succes of negotiate for better price
        AttackChance = 5, -- 0 - 100% Chance of NPC atacking player
        animation = {
            model = `prop_meth_bag_01`,
            pos = vec3(0.16, 0.04, -0.05),
            rot = vec3(0.0, 26.0, 100.0),
            bone = 57005
        },
    },
    crack = { -- Item name
        Label = "Crack", -- Item label
        ReqPolice = 0, -- Police count
        ReportChance = 5, --Dispatch Chance 0 - 100 %
        MinPrice = 10, -- Min price
        MaxPrice = 33, -- Max price
        MinCount = 1, -- Min Count
        MaxCount = 5, -- Max Count
        Chance = 80, -- 0 - 100% succes of negotiate for better price
        AttackChance = 5, -- 0 - 100% Chance of NPC atacking player
        animation = {
            model = `bkr_prop_weed_bag_01a`,
            pos = vec3(0.16, 0.04, -0.05),
            rot = vec3(0.0, 26.0, 100.0),
            bone = 57005
        },
    },
    heroin = { -- Item name
        Label = "Heroin", -- Item label
        ReqPolice = 0, -- Police count
        ReportChance = 5, --Dispatch Chance 0 - 100 %
        MinPrice = 10, -- Min price
        MaxPrice = 33, -- Max price
        MinCount = 1, -- Min Count
        MaxCount = 5, -- Max Count
        Chance = 80, -- 0 - 100% succes of negotiate for better price
        AttackChance = 5, -- 0 - 100% Chance of NPC atacking player
        animation = {
            model = `bkr_prop_weed_bag_01a`,
            pos = vec3(0.16, 0.04, -0.05),
            rot = vec3(0.0, 26.0, 100.0),
            bone = 57005
        },
    },
    coke_figure = { -- Item name
        Label = "Action Figure with Coke", -- Item label
        ReqPolice = 0, -- Police count
        ReportChance = 5, --Dispatch Chance 0 - 100 %
        MinPrice = 25, -- Min price
        MaxPrice = 55, -- Max price
        MinCount = 1, -- Min Count
        MaxCount = 5, -- Max Count
        Chance = 80, -- 0 - 100% succes of negotiate for better price
        AttackChance = 5, -- 0 - 100% Chance of NPC atacking player
        animation = {
            model = `bkr_prop_coke_doll`,
            pos = vec3(0.16, 0.04, -0.05),
            rot = vec3(0.0, 26.0, 100.0),
            bone = 57005
        }
    }
}

--Consumables
Config.Consumables = {
    weed_joint = { -- Item name
        Remove = true, -- Remove item
        Log = "Has smoked joint",
        RemoveItem = "weed_joint", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Smoking pot",
        duration = 5500,
        effect = "weed",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 10,
            },
            armor = {
                enabled = true,
                add = 5,
            },
            strength = {
                enabled = false,
                time = 60 --TIME IS IN SECONDS
            },
            speed = {
                enabled = false,
                time = 60
            },
            stamina = {
                enabled = false,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = false,
                anim = {
                    dict = 'amb@world_human_aa_smoke@male@idle_a',
                    clip = 'idle_c'
                },
                prop = {
                    model = `prop_cigar_02`,
                    pos = vec3(0.01, 0.0, 0.02),
                    rot = vec3(0.0, 0.0, -170.0),
                    bone = 28422
                },
            },
            scenario = {
                enabled = true,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = true,
                anim = "syringe"
            }
        }
    },
    meth_syringe = { -- Item name
        Remove = true, -- Remove item
        Log = "Has used Syringe with Meth",
        RemoveItem = "meth_syringe", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Shooting Meth",
        duration = 13500,
        effect = "Poison",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 30,
            },
            armor = {
                enabled = true,
                add = 50,
            },
            strength = {
                enabled = true,
                time = 60
            },
            speed = {
                enabled = true,
                time = 60
            },
            stamina = {
                enabled = true,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = false,
                anim = {
                    dict = 'amb@world_human_aa_smoke@male@idle_a',
                    clip = 'idle_c'
                },
                prop = {
                    model = `prop_cigar_02`,
                    pos = vec3(0.01, 0.0, 0.02),
                    rot = vec3(0.0, 0.0, -170.0),
                    bone = 28422
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = true,
                anim = "syringe"
            }
        }
    },
    heroin_syringe = { -- Item name
        Remove = true, -- Remove item
        Log = "Has used Syringe with Heroin",
        RemoveItem = "heroin_syringe", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Shooting Heroin",
        duration = 13500,
        effect = "Poison",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 50,
            },
            armor = {
                enabled = true,
                add = 10,
            },
            strength = {
                enabled = true,
                time = 60
            },
            speed = {
                enabled = true,
                time = 60
            },
            stamina = {
                enabled = true,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = false,
                anim = {
                    dict = 'amb@world_human_aa_smoke@male@idle_a',
                    clip = 'idle_c'
                },
                prop = {
                    model = `prop_cigar_02`,
                    pos = vec3(0.01, 0.0, 0.02),
                    rot = vec3(0.0, 0.0, -170.0),
                    bone = 28422
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = true,
                anim = "syringe"
            }
        }
    },
    meth_pipe = { -- Item name
        Remove = true, -- Remove item
        Log = "Has smoked Meth pipe",
        RemoveItem = "meth_bag", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Smoking Meth",
        duration = 17500,
        effect = "Poison",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 30,
            },
            armor = {
                enabled = true,
                add = 50,
            },
            strength = {
                enabled = true,
                time = 60
            },
            speed = {
                enabled = true,
                time = 60
            },
            stamina = {
                enabled = true,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'switch@trevor@trev_smoking_meth',
                    clip = 'trev_smoking_meth_loop',
                },
                prop = {
                    model = `prop_cs_meth_pipe`,
                    pos = vec3(0.12, -0.05, -0.03),
                    rot = vec3(19.0, 10.0, -10.0),
                    bone = 57005
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = false,
                anim = "syringe"
            }
        }
    },
    xanaxpill = { -- Item name
        Remove = true, -- Remove item
        Log = "Has popped Xanax Pill",
        RemoveItem = "xanaxpill", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Poppin pill",
        duration = 2500,
        effect = "xanax",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 5,
            },
            armor = {
                enabled = true,
                add = 15,
            },
            strength = {
                enabled = false,
                time = 60
            },
            speed = {
                enabled = false,
                time = 60
            },
            stamina = {
                enabled = true,
                time = 10
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'mp_suicide',
                    clip = 'pill',
                },
                prop = {
                    model = nil,
                    pos = nil,
                    rot = nil,
                    bone = nil
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = false,
                anim = "syringe"
            }
        }
    },
    lsd = { -- Item name
        Remove = true, -- Remove item
        Log = "Has swalowed LSD",
        RemoveItem = "lsd", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Taking LSD",
        duration = 2500,
        effect = "trip",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 10,
            },
            armor = {
                enabled = false,
                add = 50,
            },
            strength = {
                enabled = false,
                time = 60
            },
            speed = {
                enabled = true,
                time = 30
            },
            stamina = {
                enabled = false,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'mp_suicide',
                    clip = 'pill',
                },
                prop = {
                    model = nil,
                    pos = nil,
                    rot = nil,
                    bone = nil
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = false,
                anim = "syringe"
            }
        }
    },
    ecstasy = { -- Item name
        Remove = true, -- Remove item
        Log = "Has swalowed Ecstasy",
        RemoveItem = "ecstasy", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Taking Ecstasy",
        duration = 2500,
        effect = "ecstasy",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 30,
            },
            armor = {
                enabled = false,
                add = 50,
            },
            strength = {
                enabled = false,
                time = 60
            },
            speed = {
                enabled = true,
                time = 60
            },
            stamina = {
                enabled = true,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'mp_suicide',
                    clip = 'pill',
                },
                prop = {
                    model = nil,
                    pos = nil,
                    rot = nil,
                    bone = nil
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = false,
                anim = "syringe"
            }
        }
    },
    coke_pure = { -- Item name
        Remove = true, -- Remove item
        Log = "Has snorted Pure Coke",
        RemoveItem = "coke_pure", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Snorting Coke",
        duration = 4000,
        effect = "coke",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 30,
            },
            armor = {
                enabled = true,
                add = 50,
            },
            strength = {
                enabled = true,
                time = 60
            },
            speed = {
                enabled = true,
                time = 60
            },
            stamina = {
                enabled = true,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'anim@amb@nightclub@peds@',
                    clip = 'missfbi3_party_snort_coke_b_male3',
                },
                prop = {
                    model = nil,
                    pos = nil,
                    rot = nil,
                    bone = nil
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = false,
                anim = "syringe"
            }
        }
    },
    crack_pipe = { -- Item name
        Remove = true, -- Remove item
        Log = "Has smoked Crack Pipe",
        RemoveItem = "crack", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Smoking Crack",
        duration = 17500,
        effect = "alien",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 30,
            },
            armor = {
                enabled = true,
                add = 50,
            },
            strength = {
                enabled = true,
                time = 60
            },
            speed = {
                enabled = true,
                time = 60
            },
            stamina = {
                enabled = true,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'switch@trevor@trev_smoking_meth',
                    clip = 'trev_smoking_meth_loop',
                },
                prop = {
                    model = `prop_cs_crackpipe`,
                    pos = vec3(0.13, -0.09, -0.05),
                    rot = vec3(29.0, 28.0, -1.0),
                    bone = 57005
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = false,
                anim = "syringe"
            }
        }
    },
    magicmushroom = { -- Item name
        Remove = true, -- Remove item
        Log = "Has eaten Magic Mushroom",
        RemoveItem = "magicmushroom", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Eating Magic Mushroom",
        duration = 17500,
        effect = "trip",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 30,
            },
            armor = {
                enabled = false,
                add = 90,
            },
            strength = {
                enabled = false,
                time = 60
            },
            speed = {
                enabled = false,
                time = 60
            },
            stamina = {
                enabled = false,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'amb@world_human_drinking@coffee@male@idle_a',
                    clip = 'idle_c',
                },
                prop = {
                    model = `ng_proc_leaves08`,
                    pos = vec3(0.14, 0.01, -0.03),
                    rot = vec3(0.0, 0.0, 50.0),
                    bone = 57005
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = false,
                anim = "syringe"
            }
        }
    },
    peyote = { -- Item name
        Remove = true, -- Remove item
        Log = "Has eaten Peyote",
        RemoveItem = "peyote", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Eating Peyote",
        duration = 1500,
        effect = "trip",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 30,
            },
            armor = {
                enabled = false,
                add = 90,
            },
            strength = {
                enabled = false,
                time = 60
            },
            speed = {
                enabled = false,
                time = 60
            },
            stamina = {
                enabled = false,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'amb@world_human_drinking@coffee@male@idle_a',
                    clip = 'idle_c',
                },
                prop = {
                    model = `prop_peyote_highland_01`,
                    pos = vec3(0.15, 0.01, -0.09),
                    rot = vec3(-90.0, -9.0, 0.0),
                    bone = 57005
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = false,
                anim = "syringe"
            }
        }
    },
    weed_blunt = { -- Item name
        Remove = true, -- Remove item
        Log = "Has smoked Blunt",
        RemoveItem = "weed_blunt", -- Remove Item name
        RemoveItemCount = 1, -- Remove Item Count
        ProgressBar = "Smoking blunt",
        duration = 17500,
        effect = "weed",
        add = {
            enabled = true,
            health = {
                enabled = true,
                add = 10,
            },
            armor = {
                enabled = true,
                add = 5,
            },
            strength = {
                enabled = false,
                time = 60
            },
            speed = {
                enabled = false,
                time = 60
            },
            stamina = {
                enabled = false,
                time = 60
            },
        },
        animation = {
            emote = {
                enabled = true,
                anim = {
                    dict = 'amb@world_human_aa_smoke@male@idle_a',
                    clip = 'idle_c'
                },
                prop = {
                    model = `prop_cigar_02`,
                    pos = vec3(0.01, 0.0, 0.02),
                    rot = vec3(0.0, 0.0, -170.0),
                    bone = 28422
                },
            },
            scenario = {
                enabled = false,
                anim = {
                    scenario = "WORLD_HUMAN_SMOKING_POT"
                },
            },
            custom = {
                enabled = true,
                anim = "syringe"
            }
        }
    }
}
