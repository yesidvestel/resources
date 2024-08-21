--░██╗░░░░░░░██╗███████╗██████╗░██╗░░██╗░█████╗░░█████╗░██╗░░██╗░██████╗
--░██║░░██╗░░██║██╔════╝██╔══██╗██║░░██║██╔══██╗██╔══██╗██║░██╔╝██╔════╝
--░╚██╗████╗██╔╝█████╗░░██████╦╝███████║██║░░██║██║░░██║█████═╝░╚█████╗░
--░░████╔═████║░██╔══╝░░██╔══██╗██╔══██║██║░░██║██║░░██║██╔═██╗░░╚═══██╗
--░░╚██╔╝░╚██╔╝░███████╗██████╦╝██║░░██║╚█████╔╝╚█████╔╝██║░╚██╗██████╔╝
--░░░╚═╝░░░╚═╝░░╚══════╝╚═════╝░╚═╝░░╚═╝░╚════╝░░╚════╝░╚═╝░░╚═╝╚═════╝░



--      _       _     _   _
--     / \   __| | __| | | |__   ___ _ __ ___
--    / _ \ / _` |/ _` | | '_ \ / _ \ '__/ _ \
--   / ___ \ (_| | (_| | | | | |  __/ | |  __/
--  /_/   \_\__,_|\__,_| |_| |_|\___|_|  \___|


--- @param Important, add a webhook here, otherwise the images won't work.

-- Mandatory webhook or Fivemanage token [https://www.fivemanage.com] (full use)
Config.Webhook = 'n1uyPYAkUXVyaKW8V8w2j7Ayu6scR5OQ'

Config.TwitterWebhook = 'https://discord.com/api/webhooks/1275600747765174312/pX7hu4g6X2BxYBgvWiyIqT6g_Rog1iE1m3v-7QycQny2VE-LIb3dL5xMWNTliryXmDyI'
Config.InstagramWebhook = 'https://discord.com/api/webhooks/1275600882334961725/xCLjO4iZQvtq2iT_zVBpzqUenW3XLDUP9Eka_RGYJwlbJMwQWPdtzRfYHeFHfEReYR15'
Config.YellowPagesWebhook = 'https://discord.com/api/webhooks/1275601816352063499/LsjtR5qy2TpQBP9YBclC-zHL5ip5yhlnaHm_UpKrorNZtfli0P0NXtSLw3ktD4QemTpn'
Config.NewsWebhook = 'https://discord.com/api/webhooks/1275601185088208937/uhO2kdH7STla9rDkH4p6bkWF3MGnc6a_3CdXQWoIWJBa-HiqjNQIVnmiLzffLPHmLXhm'
Config.DarkWebBuy = 'https://discord.com/api/webhooks/1275601197960794163/eORify00O8HliDfR2tWA_M45C9TLdW7iiB4554EmmUJhEXyi5SDxoqwXkbDObxZCUMen'
Config.BankWebhook = 'https://discord.com/api/webhooks/1275601488978378802/VaMZCHf4IUxdP0SHxo5oTGbMlEKU0eLe2OAOS0jkVp8poYLAr0timKYVni4sy9NuQg76' -- You can modify on qs-smartphone/server/custom/misc/bank.lua


--      _       _     _   _
--     / \   __| | __| | | |__   ___ _ __ ___
--    / _ \ / _` |/ _` | | '_ \ / _ \ '__/ _ \
--   / ___ \ (_| | (_| | | | | |  __/ | |  __/
--  /_/   \_\__,_|\__,_| |_| |_|\___|_|  \___|





-- Options
Config.PublicWebhookFooter = 'Quasar Smartphone Logs'
Config.WebhookImage = 'https://i.ibb.co/QkfKWGH/store.png'

Config.Webhooks = { -- Enable or disable webhooks.
    twitter = true,
    instagram = true,
    yellowpages = true,
    news = true,
}

Config.WebhooksTranslations = { -- All webhook translations.
    ['twitter'] = {
        name = 'Twitter',
        title = 'New Tweet!',
        username = '**Username**: @',
        description = '\n**Description**: ',
        image = 'https://i.ibb.co/QJ14fxK/twitter.png'
    },

    ['instagram'] = {
        name = 'Instagram',
        title = 'New Post!',
        username = '**Username**: @',
        description = '\n**Description**: ',
        image = 'https://i.ibb.co/sgYz1PX/instagram.png'
    },

    ['yellowpages'] = {
        name = 'Yellow Pages',
        title = 'New Post!',
        username = '**Username**: ',
        description = '\n**Description**: ',
        number = '\n**Number**: ',
        image = 'https://i.ibb.co/GT9XWDP/yellowpages.png'
    },

    ['news'] = {
        name = 'News',
        title = 'New Storie!',
        storie = '**Title**: ',
        description = '\n**Description**: ',
        date = '\n**Number**: ',
        image = 'https://i.ibb.co/1vdzfX5/news.png'
    },
}

function WebhookDarkWeb(player, item, data, exploit)
    local embed = {}
    local message

    if exploit then
        message = '@everyone'
        dataFinal = {
            Item = tostring(data.Item) or false,
            Label = tostring(data.Label) or false,
            isItem = tostring(data.isItem) or false,
            Price = tostring(data.Price) or false,
            Count = tostring(data.Count) or false,
        }
        embed = {
            ['color'] = 16711680,
            ['title'] = 'qs-smartphone DarkWeb EXPLOITED',
            ['description'] = '**ID:** `' .. player.source .. '` \n**Identifier:** `' .. player.identifier .. '` \n**Item:** `' .. item .. '`.',
            ['footer'] = {
                ['text'] = 'Data: \nItem : ' .. dataFinal.Item .. ' \nLabel : ' .. dataFinal.Label .. ' \nisItem? : ' .. dataFinal.isItem .. ' \nPrice : ' .. dataFinal.Price .. ' \nCount : ' .. dataFinal.Count .. ' \nEncoded Data : ' .. json.encode(data, { indent = true }) .. '.'
            }
        }
    else
        message = ''
        embed = {
            ['color'] = 65280,
            ['title'] = 'SMARTPHONE DarkWeb',
            ['description'] = '**ID:** `' .. player.source .. '` \n**Identifier:** `' .. player.identifier .. '` \n**Item:** `' .. item .. '` **amount:** `' .. data .. '`.',
        }
    end

    PerformHttpRequest(Config.DarkWebBuy, function(err, text, headers) end, 'POST', json.encode({ username = 'Smartphone', content = message, embeds = { embed } }), { ['Content-Type'] = 'application/json' })
end
