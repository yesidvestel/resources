Config = {}

Config.PlayCasinoAmbientNoise = true
Config.SetShowCarOnDisplay = true
Config.VehicleOnDisplay = `crownbp`


Config.SetAnimatedWalls = true
Config.AnimatedWallNormal = 'CASINO_DIA_PL'
Config.AnimatedWallWin = 'CASINO_WIN_PL'
-- WALLS 
-- CASINO_DIA_PL    - Falling Diamonds
-- CASINO_HLW_PL    - Falling Skulls
-- CASINO_SNWFLK_PL - Falling Snowflakes 
-- CASINO_WIN_PL    - Falling Confetti 

Config.SendWelcomeMail = false -- Sends a email to players phone on entering casino
Config.WelcomeMailsender = "El Casino y Resort Diamante";
Config.WelcomeMailsubject = "¡Bienvenido!";
Config.WelcomeMailmessage = "Bienvenido a El Casino y Resort Diamante. Estamos abiertos las 24 horas, los 7 días de la semana, y solo aceptamos transacciones electrónicas.";

Config.payment = "bank" -- or "cash" -- Payment player will recieve by selling casino chips

Config.casinoChipPrice    = 100
Config.casinoMemberPrice  = 500
Config.casinoVIPPrice  = 500

Config.CasinoShop = {
    [1] = { name = "casino_goldchip",   price = 100, amount = 1000, info = {}, type = "item", slot = 1 },
    -- [2] = { name = "casino_member",     price = 500, amount = 50, info = {}, type = "item", slot = 2 },
    -- [3] = { name = "casino_vip",        price = 750, amount = 50, info = {}, type = "item", slot = 3 }
}   