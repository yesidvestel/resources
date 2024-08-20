Config = Config or {}
Config.BusinessTypes = {
    ["shop"] = {
        label = "Store",
        blip = {
            sprite = 52,
            color = 2
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    },
    ["mechanic"] = {
        label = "Workshop",
        blip = {
            sprite = 72,
            color = 4
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    },
    ["gym"] = {
        label = "Gym",
        blip = {
            sprite = 311,
            color = 4
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    },
    ["restaurant"] = {
        label = "RESTAURANT / BAR / DISCECA / CAFE / FAST FOOD",
        blip = {
            sprite = 93,
            color = 8
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    },
    ["taxi"] = {
        label = "Taxi",
        blip = {
            sprite = 198,
            color = 5
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    },
    ["compraventa"] = {
        label = "Purchase-sale of vehicles",
        blip = {
            sprite = 326,
            color = 47
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    },
    ["varios"] = {
        label = "Several",
        blip = {
            sprite = 59,
            color = 5
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    },
    ["emblema"] = {
        label = "Emblematic",
        blip = {
            sprite = 438,
            color = 0
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    },
    ["ammu"] = {
        label = "Ammunation",
        blip = {
            sprite = 110,
            color = 59
        },
        exp = {
            Billing = 0.05,
            BuyItem = 0.01
        }
    }
}

Config.AvailableItems = {  --- by a specific company or by type of company
    --[==[  specific company
        ['origen'] = {
              {
            name = "sandwich",
            level = 0,
            price = 5,
            },
            {
                name = "snikkel_candy",
                level = 0,
                price = 5,
            },
        },
    ]==]
    ['pepe2'] = {
        {
            name = "tosti",
            level = 0,
            price = 5,
        }
    },
    ["shop"] = {
        {
            name = "sandwich",
            level = 0,
            price = 5,
        },
        {
            name = "snikkel_candy",
            level = 0,
            price = 5,
        },
    },
    ["mechanic"] = {
        {
            name = "repairkit",
            level = 0,
            price = 5,
        },
        {
            name = "cleaningkit",
            level = 0,
            price = 5,
        }
    },
    ["gym"] = {
        {
            name = "water_bottle",
            level = 0,
            price = 5,
        },
        {
            name = "kurkakola",
            level = 0,
            price = 5,
        }
    },
    ["restaurant"] = {
        {
            name = "water_bottle",
            level = 0,
            price = 5,
        },
        {
            name = "kurkakola",
            level = 0,
            price = 5,
        }
    },
    ["taxi"] = {
        {
            name = "water_bottle",
            level = 0,
            price = 5,
        },
        {
            name = "kurkakola",
            level = 0,
            price = 5,
        }
    },
    ["compraventa"] = {
        {
            name = "repairkit",
            level = 0,
            price = 5,
        },
        {
            name = "kurkakola",
            level = 0,
            price = 5,
        }
    },
    ["varios"] = {
        {
            name = "water_bottle",
            level = 0,
            price = 5,
        },
        {
            name = "kurkakola",
            level = 0,
            price = 5,
        }
    },
    ["emblema"] = {
        {
            name = "water_bottle",
            level = 0,
            price = 5,
        },
        {
            name = "kurkakola",
            level = 0,
            price = 5,
        }
    },
    ["ammu"] = {
        {
            name = "water_bottle",
            level = 0,
            price = 5,
        },
        {
            name = "kurkakola",
            level = 0,
            price = 5,
        }
    },
}
