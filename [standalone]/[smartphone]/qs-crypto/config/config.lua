Config = {}
Locales = Locales or {}

Config.Framework = 'qb' -- 'esx' or 'qb'

Config.Language = 'es'

Crypto = {
    Lower = 500,
    Upper = 5000,

    Debug = true,

    History = {
        ["btc"] = {}
    },

    Worth = {
        ["btc"] = 1000
    },

    Labels = {
        ["btc"] = "BTC"
    },

    Exchange = {
        coords = vector3(1276.21, -1709.88, 54.57),
        RebootInfo = {
            state = false,
            percentage = 0
        },
    },

    Coin = 'btc', -- For auto updating the value of btc
    RefreshTimer = 5, -- In minutes, so every 5 minutes.

    ChanceOfCrashOrLuck = 2, -- This is in % (1-100)
    Crash = {20,80}, -- Min / Max
    Luck = {20,45}, -- Min / Max

    ChanceOfDown = 30, -- If out of 100 hits less or equal to
    ChanceOfUp = 60, -- If out of 100 is greater or equal to
    CasualDown = {1,10}, -- Min / Max (If it goes down)
    CasualUp = {1,10}, -- Min / Max (If it goes up)
}

Ticker = {
    Enabled = false, -- Decide whether the real life price ticker should be enabled or not :)  
    coin = 'BTC', -- The coin, please make sure you find the actual name, for example: Bitcoin vs BTC, BTC would be correct
    currency = 'USD', -- For example USD, NOK, SEK, EUR, CAD and more here https://www.countries-ofthe-world.com/world-currencies.html
    tick_time = 2, -- Minutes (Minimum is 2 minutes) 20,160 Requests a month, Its recommended to get the free API key so the crypto script doesnt switch on and off if ratelimit is encountered
    Api_key = 'put_api_key_here', -- If you decide to get an api key for the API (https://min-api.cryptocompare.com/pricing) The free plan should be more than enough for 1 Fivem server
    Error_handle = { -- Error handle stuff, for more user friendly and readable errors, Don't touch.
        ['fsym is a required param.'] = 'Config error: Invalid / Missing coin name',
        ['tsyms is a required param.'] = 'Config error: Invalid / Missing currency',
        ['cccagg_or_exchange'] = 'Config error: Invalid currency / coin combination', -- For some reason api throws this error if either coin or currency is invalid
    },
}