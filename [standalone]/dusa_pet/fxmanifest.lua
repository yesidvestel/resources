----------------------------------------------------------------
----                   DUSADEV.TEBEX.IO                    	----
----------------------------------------------------------------
fx_version 'bodacious'
game 'gta5'
author 'dusadev.tebex.io'
description 'Dusa Pet & Companion Script'
version '1.5.3'

shared_scripts {
	'config.lua',
	'@ox_lib/init.lua',
}

ui_page {
	'web/index.html',
}

files {
	'web/index.html',
    'web/assets/style/*.css',
	'web/script/*.js',
	'web/assets/img/products/*.png',
	'web/assets/img/wardrobe/*.png',
	'web/assets/img/emote/*.png',
	'web/assets/img/emote/*.svg',
	'web/assets/img/pets/*.png',
	'web/assets/img/pets/*.svg',
	'web/assets/img/petshop/*.png',
	'web/assets/img/petshop/*.svg',
}

client_script {
	'bridge/esx/client.lua',
	'bridge/qb/client.lua',
    'client/client.lua',
    'client/functions.lua',
    'client/items.lua',
    'client/objectspawner.lua',
}

server_script {
    '@mysql-async/lib/MySQL.lua',
	'bridge/esx/server.lua',
	'bridge/qb/server.lua',
	'server/server.lua',
	'server/updater.lua'
}


lua54 'yes'

escrow_ignore {
	'bridge/esx/client.lua',
	'bridge/qb/client.lua',
	'bridge/esx/server.lua',
	'bridge/qb/server.lua',
	'config.lua',
	'client/client.lua',
	'client/objectspawner.lua',
	'client/items.lua',
	'client/functions.lua',
	'server/server.lua',
	'server/updater.lua',
} 
dependency '/assetpacks'