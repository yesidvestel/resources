local QBCore = exports['qb-core']:GetCoreObject()

local Webhooks = {
    ['default'] = 'https://discord.com/api/webhooks/1275940679692062792/1oQy6rc6gB778DqpgGhFV4BytyTTW2QAMPiVfgd6js6PoO120La1PE_gjL7nQmRaTxZ8', -- predeterminado
    ['testwebhook'] = 'https://discord.com/api/webhooks/1275940833102925854/Lu1wJgqYMTdfTO92zp-rl7KhuJffXZyGO2_6Xv6qSXd2h1c5nmrktYCXmB5f-fD43cuj', -- webhook de prueba
    ['playermoney'] = 'https://discord.com/api/webhooks/1275940966355832944/Mx_-RUDiHyBgyHphdSXD0xDCWXa1mBrvn5ye1RkRlWqcTCGFKaG3vuOEsV7q4zlsaoIr', -- dinero del jugador
    ['playerinventory'] = 'https://discord.com/api/webhooks/1275941164645875823/9YS1gTTO6wOkcjY305PsPSrcNLtyhZnsM2wWioCuL1K5nd68uEeCQzY-liCLXPQLfJSR', -- inventario del jugador
    ['robbing'] = 'https://discord.com/api/webhooks/1275941166080200846/44WXJwv3rE4E-yUfs52HzfiFuYDtC4Pbqa90wkjml-a1mxa7EbXYju6GOdV-92c0GfVe', -- robo
    ['cuffing'] = 'https://discord.com/api/webhooks/1275941166205898803/peyDwF6HqTXxNgFbVq2V5hHa8AAekIDOOGYEPTdKFp-J9o9_7MTm9aNQemhf7zvhRi-E', -- esposando
    ['drop'] = 'https://discord.com/api/webhooks/1275941166877118560/zyqCCQ55As7GfnK9OyjGpR8SpcHttAezzKZIcjOWwKmjOn2iw0CYYKCDuRYvgw47nLEX', -- soltar
    ['trunk'] = 'https://discord.com/api/webhooks/1275941625318608949/sf-_KN33yS4eJOBNuhEH6Tm-f6JNZFWr96Urt-B3Ruu7GjnJq1z5gaVIRu6xI4cQUFHT', -- maletero
    ['stash'] = 'https://discord.com/api/webhooks/1275941625964662915/DWf7SUnWP595IIS2alETtm_btyRSarAFj-iGp_P92XvJEaobUdtfj0iF9t7SOdtF7xWX', -- escondite
    ['glovebox'] = 'https://discord.com/api/webhooks/1275941626585546847/EkvBBfpzOCCb1l-3nX3D9IJRfTe85ZHDdL7ZxRJ1rjQddudpJDcX2_EgO8mc8F4_EO4v', -- guantera
    ['banking'] = 'https://discord.com/api/webhooks/1275941627025821856/b5jCvS9wk2kFAXd386ik0o5tU2RLjcQy4qSO5LFtHyWn589gBB7G98Q6lIfiygg_5YgS', -- banca
    ['vehicleshop'] = 'https://discord.com/api/webhooks/1275941627625738250/mizjtZA2SIy73qLSQpplyHbeBgDiYyLVTpDJkQqo0zPFXONxOI85cY0_39vNYYt9oZ2y', -- tienda de vehículos
    ['vehicleupgrades'] = 'https://discord.com/api/webhooks/1275941628623720500/qLzLeugsdBWlhSphUmg3IaR2MMBE6uDpl7hLaQEupsvwzpOe4xuXFUEPyA3ENQygDdIg', -- mejoras de vehículos
    ['shops'] = 'https://discord.com/api/webhooks/1275941628955070524/zMRYDAad9is6qShjbNYCJA4iHmvANLYkrKwmbl0Sg7vOZjd_wrBFxnZWun1DxpTDNdyi', -- tiendas
    ['dealers'] = 'https://discord.com/api/webhooks/1275942502360158238/FLbDLlDfIxjQEPG3e_aFCDKewPyBay__bQ1zNlY6IYwrxu_LT8NPyX2YyC43m_KT4Ojo', -- distribuidores
    ['storerobbery'] = 'https://discord.com/api/webhooks/1275940679692062792/1oQy6rc6gB778DqpgGhFV4BytyTTW2QAMPiVfgd6js6PoO120La1PE_gjL7nQmRaTxZ8', -- robo de tienda
    ['bankrobbery'] = 'https://discord.com/api/webhooks/1275942503203340411/jDUSLIjlsncsZxCr9C3t-rV1CJmziTWwdZGsHVKI4hidpckZaAgR6py39OAcIHd1adz-', -- robo de banco
    ['powerplants'] = 'https://discord.com/api/webhooks/1275942503471648892/7PvVxDfGh1MSYN6ikEUtuTzbo-Qo-lS1Umi-tc7R70JJW-C30wdxacD2XJYk-96o0yj5', -- plantas de energía
    ['death'] = 'https://discord.com/api/webhooks/1275942504054652959/79aNDSh9dHbK5LokckdYrzuuVDgPFXWafHc3sIE1JHMAknRsAt_D8w9zIVHvj32ATrzW', -- muerte
    ['joinleave'] = 'https://discord.com/api/webhooks/1275942504595853473/j5ROcUs0rkyF7Hfpccli92KBD1OgCf7s6wyl5SyvwLbQIjCfE6PDQ8DiQJAKSA7OEFou', -- unirse/salir
    ['ooc'] = 'https://discord.com/api/webhooks/1275942505187250302/HgxYW7Cy9DQ2cn1XXCzM1JYIbAYGKpB5ELv-Xkg581libqlAbcscyNKKHPU6MzDT3_bH', -- fuera de personaje (OOC)
    ['report'] = 'https://discord.com/api/webhooks/1275942505736830976/GizLfYqmGTwEWHQv0H6oiGJKpI7S98F05t3iBz-nxdX5VdIGOUe1MqYXNkaR_t8SZD2V', -- reporte
    ['me'] = 'https://discord.com/api/webhooks/1275942506374238219/mM1fOSXzKqAXliDqjqjjtdafeGLBQF2uPYRuDUaLynMf_HvOZ9spHk2rDU37bR9FG8gZ', -- yo
    ['pmelding'] = 'https://discord.com/api/webhooks/1275943871984963625/UR_iCPoNAaVVszuIXGjSGcONNbWMlVlfxP_WQi6uEuCPAcDIvMbHAmM_YTyAu684tebo', -- mensaje privado
    ['112'] = '', -- emergencia (112)
    ['bans'] = 'https://discord.com/api/webhooks/1275943872626954311/NAbop9txiGoHcYRVfRlsn5ngiaAaX8ERWbl_SMq7RGWWBRTdNZiDTva0tWMs9iWUIJ7M', -- prohibiciones
    ['anticheat'] = 'https://discord.com/api/webhooks/1275943873314685048/-6r-ae-4Hr23CVKWm_RIOIl_W3WUJ6DL5WWLW5Lcd5vnL-OYIHFtbSoerlgJ7eWOi-F5', -- antitrampas
    ['weather'] = 'https://discord.com/api/webhooks/1275943873851429045/5_wWaqLmJZhS4gUrtNvDrxWgdFXr-gexL0f8-zY9DoruDJO-a7ifr7KalXoxuzjiXUZC', -- clima
    ['moneysafes'] = 'https://discord.com/api/webhooks/1275943874317258832/2nJyv-2W0pxcI_q6lUblZVhuzOoex4zTRDWV-G-HkFzNV_D-6eUBQ0ExZHd8BSGk_A-H', -- cajas fuertes de dinero
    ['bennys'] = 'https://discord.com/api/webhooks/1275943875256782920/O44xZZ6I0BTCnLEY9cEVffjbOVStW2Etlavve8SF8FsKufo2DfltkVJh5h2-yT9enRbg', -- Benny's
    ['bossmenu'] = 'https://discord.com/api/webhooks/1275946193658318919/nNcs8VbT9ATK-ZjVE_sfi0Qirn_lvf8HYB7ZE7SXrSUZQvoHve7AMZ5pwlOmr4tWYwnG', -- menú del jefe
    ['robbery'] = 'https://discord.com/api/webhooks/1275947580030713876/Rb_06Ad9HzKTZRAm5D0I-YaNu36YSXWkbUZAKkQtMw7QsoJjI9oA7uPsT0styINXsYZn', -- robo
    ['casino'] = 'https://discord.com/api/webhooks/1275947590365610124/aNxuRLWOsXlAxJeox3X-o2wGkvkRGtQNNdN1AwcaapwcC5eNNETBMCzDVpPSSSBn3UWR', -- casino
    ['traphouse'] = '', -- casa trampa
    ['911'] = '', -- emergencia (911)
    ['palert'] = 'https://discord.com/api/webhooks/1275947591821037649/VV-bDgQHj6g6IDvXOgROsoOkr5m_KEtxSThFUD2_wGrQfKKo5oniOptfu8qkT-RyC_c2', -- alerta policial
    ['house'] = 'https://discord.com/api/webhooks/1275948810392305836/MESmSPrldqefrHMdIBu4jsFRFI64I-TpBk3zqqiLVlZcoyNgL9rzhmVMF3bLL5hRUKAD', -- casa
    ['qbjobs'] = 'https://discord.com/api/webhooks/1275950924228988958/hy7wdJcHya-klwEDmeqogYyGdgaE-z31OErnBkUVcNtKi31AIM252dLipb5Prk6RCGnH', -- trabajos qb
}

local colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ['lightgreen'] = 65309,
}

local logQueue = {}

RegisterNetEvent('qb-log:server:CreateLog', function(name, title, color, message, tagEveryone, imageUrl)
    local postData = {}
    local tag = tagEveryone or false

    if Config.Logging == 'discord' then
        if not Webhooks[name] then
            print('Tried to call a log that isn\'t configured with the name of ' .. name)
            return
        end
        local webHook = Webhooks[name] ~= '' and Webhooks[name] or Webhooks['default']
        local embedData = {
            {
                ['title'] = title,
                ['color'] = colors[color] or colors['default'],
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
                ['description'] = message,
                ['author'] = {
                    ['name'] = 'QBCore Logs',
                    ['icon_url'] = 'https://raw.githubusercontent.com/GhzGarage/qb-media-kit/main/Display%20Pictures/Logo%20-%20Display%20Picture%20-%20Stylized%20-%20Red.png',
                },
                ['image'] = imageUrl and imageUrl ~= '' and { ['url'] = imageUrl } or nil,
            }
        }

        if not logQueue[name] then logQueue[name] = {} end
        logQueue[name][#logQueue[name] + 1] = { webhook = webHook, data = embedData }

        if #logQueue[name] >= 10 then
            if tag then
                postData = { username = 'QB Logs', content = '@everyone', embeds = {} }
            else
                postData = { username = 'QB Logs', embeds = {} }
            end
            for i = 1, #logQueue[name] do postData.embeds[#postData.embeds + 1] = logQueue[name][i].data[1] end
            PerformHttpRequest(logQueue[name][1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
            logQueue[name] = {}
        end
    elseif Config.Logging == 'fivemanage' then
        local FiveManageAPIKey = GetConvar('FIVEMANAGE_LOGS_API_KEY', 'false')
        if FiveManageAPIKey == 'false' then
            print('You need to set the FiveManage API key in your server.cfg')
            return
        end
        local extraData = {
            level = tagEveryone and 'warn' or 'info', -- info, warn, error or debug
            message = title,                          -- any string
            metadata = {                              -- a table or object with any properties you want
                description = message,
                playerId = source,
                playerLicense = GetPlayerIdentifierByType(source, 'license'),
                playerDiscord = GetPlayerIdentifierByType(source, 'discord')
            },
            resource = GetInvokingResource(),
        }
        PerformHttpRequest('https://api.fivemanage.com/api/logs', function(statusCode, response, headers)
            -- Uncomment the following line to enable debugging
            -- print(statusCode, response, json.encode(headers))
        end, 'POST', json.encode(extraData), {
            ['Authorization'] = FiveManageAPIKey,
            ['Content-Type'] = 'application/json',
        })
    end
end)

Citizen.CreateThread(function()
    local timer = 0
    while true do
        Wait(1000)
        timer = timer + 1
        if timer >= 60 then -- If 60 seconds have passed, post the logs
            timer = 0
            for name, queue in pairs(logQueue) do
                if #queue > 0 then
                    local postData = { username = 'QB Logs', embeds = {} }
                    for i = 1, #queue do
                        postData.embeds[#postData.embeds + 1] = queue[i].data[1]
                    end
                    PerformHttpRequest(queue[1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
                    logQueue[name] = {}
                end
            end
        end
    end
end)

QBCore.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function()
    TriggerEvent('qb-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
