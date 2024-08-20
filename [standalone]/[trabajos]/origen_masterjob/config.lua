Config = Config or {}

Config.CustomNotify = false -- Set to true if you want to use your own notification system
Config.customDrawText = false
Config.Debug = false

Config.KeyMenu = 'F7' -- Key to open the menu

Config.fixQS = true -- fix qs metadata

Config.Phone = "default" -- default, qs-smartphone, lb-phone

-- Added compatibility for OrigenNotify
Config.OrigenNotify = false -- Enable CustomNotify as well:)
Config.OrigenInventoryOldVersion = false

----------------------------------
-------  PAYMENTS EMPLOYED -------
----------------------------------
Config.InfinitePayckeck = false -- Set to true if you want to pay the paycheck infinitely and not discount to society
Config.PaycheckInterVal = 30 -- in minutes
Config.OnDutyPay = true -- Only pay when you are on duty
Config.MinSocietyPay = 300 -- If the payment depends on the companies and they run out of money, how much do state employees earn?(Config.InfinitePayckeck = false)
Config.MaxSocietySalary = 9999 -- The maximum salary that a boss can establish for a job grade
----------------------------------



Config.BillsNPC = vector4(1250.48, -3190.08, 5.88, 337.29)

Config.BillsNPCs = {
    {
        coords = vector4(1269.82, -3200.06, 5.9, 271.54),
        model = "player_one",
    },
    {
        coords = vector4(1245.3, -3202.88, 6.03, 11.69),
        model = "player_two",
    }
}

Config.Language = "es"

Config.MenuItemTablet = true --  active item tablet
Config.CustomMechanic = false  -- check instalation/mechanic
Config.MarkerDutyAccess = false  --- access service-only points
Config.CustomGarage = false  -- check instalation/garage
Config.CustomPlateGenerator = false
Config.DeliveryTime = 15 -- In minutes waiting time for orders
Config.BusinessLevelFactor = 150

----------------------------------
-------  accounts config ---------
----------------------------------
Config.Account = {}
Config.Account.Transfer = 'cash'
Config.Account.billing = 'bank'
Config.Account.Paybill = 'bank'
Config.Account.SellVehicle = 'cash'

----------------------------------
--------      SHOPS      ---------
----------------------------------

Config.strictSellItemsShop = true



Config.RestritedJob = {
    ['unemployed'] = false,
    ['police'] = true
}

Config.Money = {
    ItemCash = true,
    account = 'money'
}

Config.Markers = {
    ["stash"] = {
        label = "Store",
        radius = 1.0,
        help = "Open the warehouse",
        slots = 50
    },
    ["clothing"] = {
        label = "Locker room",
        radius = 1.0,
        help = "Change your clothes"
    },
    ["stash_safe"] = {
        label = "Safe",
        radius = 1.0,
        help = "Open the safe",
        slots = 20
    },
    ["delivery"] = {
        label = "Load post",
        radius = 1.0,
        help = "Open the loading post"
    },
    ["tuning"] = {
        label = "Modification point",
        radius = 2.0,
        help = "Modify the vehicle",
        type = "mechanic",
        max = 5
    },
    ["garage"] = {
        label = "Garage",
        radius = 2.5,
        help = "Enter the garage",
        useheading = true
    },
    ["gar_taxi"] = {
        label = "Taxis garage",
        radius = 2.0,
        help = "Use the garage",
        type = "taxi",
        useheading = true,
        vehicles = {
            "taxi",
            "rentalbus",
            "stretch",
            "patriot2"
        }
    },
    ["gar_business"] = {
        label = "Company garage",
        radius = 2.0,
        help = "Use the garage",
        useheading = true
    }
}

Config.Garage = {
    coords = vector4(202.1999, -1004.4250, -98.9999, 3.3941),
    parks = {
        { coords = vector4(203.5676, -997.8387, -99.0000, 177.1650) },
        { coords = vector4(198.1634, -997.8378, -99.0000, 177.9458) },
        { coords = vector4(193.7832, -997.6540, -99.0000, 179.1584) },
        { coords = vector4(194.8356, -1003.9368, -99.0000, 269.3047) },
    },
}

exports('GetConfig', function()
    return Config
end)

Config.BusinessMultifrec = {
    "Frequency 1",
    "Frequency 2",
    "Frequency 3",
    "Frequency 4",
    "Frequency 5",
    "Frequency 6",
    "Frequency 7",
    "Frequency 8",
    "Frequency 9",
    "Frequency 10"
}


function debuger(...)
    if Config.Debug  then
        print ('^3[ORIGEN MASTERJOB]:^0', ...)
        print ('^0')
    end
end

Lang = Lang[Config.Language] -- DON'T TOUCH THIS