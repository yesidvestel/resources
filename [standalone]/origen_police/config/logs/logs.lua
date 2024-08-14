ServerConfig = {}

ServerConfig.UseIdentifiers = true

-- If you want to use fivemanage you can use it with this url structure: 
--            https://api.fivemanage.com/api/image?apiKey=YOUR_API_TOKEN
-- Where YOUR_API_TOKEN is the token that you get from fivemanage page

ServerConfig.Logs = {
    DispatchAlerts = 'YOUR_DISCORD_WEBHOOK',
    Shapes = 'YOUR_DISCORD_WEBHOOK',
    Notes = 'YOUR_DISCORD_WEBHOOK',
    DutyClock = 'YOUR_DISCORD_WEBHOOK',
    Management = 'YOUR_DISCORD_WEBHOOK',
    Camera = 'YOUR_DISCORD_WEBHOOK',
    Federal = 'YOUR_DISCORD_WEBHOOK',
    Bills = 'YOUR_DISCORD_WEBHOOK',
    Cams = 'YOUR_DISCORD_WEBHOOK',
    Mugshots = 'YOUR_DISCORD_WEBHOOK'
}