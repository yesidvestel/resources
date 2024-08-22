fx_version 'cerulean'

game 'gta5'

version '1.0.5'

lua54 'yes'

ui_page 'html/index.html'

shared_scripts {
	'config/*.lua',
	'locales/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/custom/framework/*.lua',
	'server/*.lua',
}

client_scripts {
	'client/*.lua',
    'client/custom/**/*.lua',
}

escrow_ignore {
    'config/*.lua',
	'locales/*.lua',
	'client/custom/framework/*.lua',
	'server/custom/framework/*.lua',
}

exports {
    'IsInRace',
    'IsInEditor',
}

dependency '/assetpacks'