--[[ FX Information ]]

fx_version "cerulean"
game "gta5"
lua54 "yes"

--[[ Resource Information ]]
name "0r-vehicleshop"
author "aliko. <Discord: aliko.>"
version "1.1.0"
description "Fivem Script: Vehicle Shop ESX/QB ?"

--[[ Manifest ]]
shared_scripts {
    "@ox_lib/init.lua", -- if you are using ox
    "shared/**/*"
}

client_scripts {
    "client/utils.lua",
    "client/variables.lua",
    "client/functions.lua",
    "client/events.lua",
    "client/nui.lua",
    "client/threads.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/utils.lua",
    "server/variables.lua",
    "server/functions.lua",
    "server/callbacks.lua",
    "server/commands.lua",
    "server/events.lua",
    "server/threads.lua"
}

ui_page "ui/index.html"

files {
    "locales/**/*",
    "ui/index.html",
    "ui/build/**/*"
}

escrow_ignore {
    "locales/**/*",
    "shared/**/*",
    "client/**/*",
    "server/**/*",
    "server/**/*",
    "ui/build/**/*",
}

dependency '/assetpacks'