fx_version 'bodacious'

game 'gta5'

lua54 'yes'

version '1.0.5'

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
}

escrow_ignore {
    'config/*.lua',
	'locales/*.lua',
	'server/custom/framework/*.lua',
}

dependency '/assetpacks'