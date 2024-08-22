fx_version 'bodacious'

game 'gta5'

version '1.0.6'

lua54 'yes'

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

exports {
    'hasActiveDelivery'
}
dependency '/assetpacks'