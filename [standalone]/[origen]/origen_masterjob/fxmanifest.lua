fx_version "cerulean"

game "gta5"

version '1.3.11'

shared_scripts {
    'locales/*.lua',
    "config.lua",
    'shared/*.lua',
    "radio/config.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/log.lua",
    "server/init.lua",
    "custom/server/command.lua",
    "custom/server/main.lua",
    "custom/server/menu/phone.lua",
    "server/garage.lua",
    "server/class.lua",
    "server/commands.lua",
    "server/events.lua",
    "server/functions.lua",
    "server/menu.lua",
    "server/npcs.lua",
    "server/threads.lua",
    "radio/server/**/*.lua",
}

client_scripts {
    "client/init.lua",
    "custom/client_pay_bills.lua",
    "custom/client.lua",
    "client/garage.lua",
    "client/builder.lua",
    "client/events.lua",
    "client/functions.lua",
    "client/menu.lua",
    "client/npcs.lua",
    "client/radio.lua",
    "client/shops.lua",
    "custom/blips.lua",
    "client/threads.lua",
    'client/tunnig.lua',
    "radio/client/**/*.lua",
}

files {
    "html/**/*",
    "peds.json"
}

ui_page "html/index.html"

lua54 'yes'

escrow_ignore {
    "config.lua",
    "custom/**/*.lua",
    "custom/*.lua",
    'shared/*.lua',
    "locales/*.lua",
    "radio/config.lua"
}
dependency '/assetpacks'
dependency '/assetpacks'