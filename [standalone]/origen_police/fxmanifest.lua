fx_version "bodacious"

game "gta5"

author "OrigenNetwork"

version "2.3.3"

shared_scripts {
    "config/_framework.lua",
    "config/police-stations/loader.lua",
    "config/translations/*.lua",
    "config/*.lua",
    "radio/config.lua",
    "custom/shared/*.lua",
}

client_scripts {
    "utils/*.lua",
    "custom/framework/client/*.lua",
    "custom/client/actions.lua",
    "custom/client/clothing.lua",
    "custom/client/commands.lua",
    "custom/client/federal.lua",
    "custom/client/inventory.lua",
    "custom/client/menu.lua",
    "custom/client/rpol.lua",
    "custom/client/vehicles.lua",
    "custom/client/voice.lua",
    "custom/client/client_pay_bills.lua",
    "client/init.lua",
    "client/menu/*.lua",
    "client/*.lua",
    "radio/client/**/*.lua",
}

server_scripts {
    'items.lua', -- qb auto add items
    "utils/FileManager.js",
    "server/middlewares/*.lua",
    "config/logs/logs.lua",
    "custom/server/database.lua",
    "custom/framework/server/*.lua",
    "custom/server/inventory.lua",
    "custom/server/rpol.lua",
    "custom/server/society.lua",
    "custom/server/vehicles.lua",
    "custom/server/menu/*.lua",
    "custom/server/vehicles.lua",
    "server/init.lua",
    "server/*.lua",
    "server/menu/*.lua",
    "radio/server/**/*.lua",
}

ui_page 'html/index.html'

files {
    "config/police-stations/*.json",
	'html/index.html',
    "html/apps/*.html",
    "html/components/*.html",
    'html/img/*.*',
    'html/img/webp/*.webp',
    'html/**/*.*',
    'html/sounds/*.*',
    "html/apps/*.html",
    "html/components/*.html",
    "html/css/*.css",
    "html/fonts/*.*",
    "html/js/*.js",
    "stream/*.ytyp",
}

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

provide {
    'qb-policejob'
}

-- Escrow
lua54 'yes'

dependencies {
    "pma-voice"
}

escrow_ignore {
    "utils/mugshot.lua",
    "config/*.lua",
    "config/translations/*.lua",
    "config/logs/logs.lua",
    "custom/client/*.lua",
    "custom/client/menu/*.lua",
    "custom/framework/**/*.lua",
    "custom/shared/*.lua",
    "custom/server/*.lua",
    "custom/server/menu/*.lua",
    "server/tables.lua",
    "radio/config.lua",
    'items.lua'
}

dependency '/assetpacks'
dependency '/assetpacks'